import base64;
import os;
import time;
import from dotenv { load_dotenv }
import from byllm.lib { Model }
import from backend.models.models { UserData, UserRole }
import from backend.models.models { UserData, JobPosting, Skill, SkillSpec, RoleSpec }
import from backend.edges.edges { has_skill }
import from tools { WebSearch }
import from backend.utils.cv_utils { ResumeUtils }

glob llm = Model(model_name="mistral/mistral-small-latest", verbose=False);

walker profile_manager {
    has user_id: str;

    def get_user_data()  -> UserData;
    def get_profile_snapshot()  -> dict[str, any];
    def summarize_profile()  -> str by llm(
        method="ReAct", tools=([self.get_profile_snapshot])
    );

    can execute with `root entry;
}

walker resume_parser {
    has uploaded_path: str;
    has utils: ResumeUtils = ResumeUtils();

    def get_user_data()  -> UserData;
    def detect_resume_type()  -> str;
    def parse_resume()  -> dict[str, any];
    def summarize_resume()  -> str by llm(method="ReAct", tools=([self.parse_resume]));
    can execute with `root entry;
}

walker save_user_profile {
    has email: str;
    has target_role: str;

    can start with `root entry;
    can update_email_and_targetrole with UserData entry;
}

walker store_cv_file {
    has file_name: str;
    has file_data_b64: str;
    has upload_dir: str = "uploads";

    can start with `root entry;
}

walker collect_job_postings {
    has target_role: str;

    def get_user_data()  -> UserData;
    can start with `root entry;
    can fetch_and_attach_jobs with UserData entry;
}

walker extract_target_role_requirements {
    has target_role: str;

    def get_user_data()  -> UserData;
    def get_job_postings()  -> list[JobPosting];
    def get_role_requirements(
        target_role: Role, job_descriptions: list[str]
    ) -> RoleSpec by llm(method="ReAct", tools=[self.get_job_postings]);

    can start with `root entry;
    can extract_requirements with UserData entry;
}

walker extract_and_attach_skills {
    has resume_parser_output: str;

    def get_resume_text()  -> str;
    def extract_skills(profile_data: UserData) -> list[SkillSpec] by llm(
        method="ReAct", tools=[self.get_resume_text]
    );

    can start with `root entry;
    can extract with UserData entry;
}

walker compute_match_score {
    has target_role: Role;
    has user_data: UserData;

    def extract_matching_skills(
        user_skills: list[str], required_skills: list[str]
    ) -> dict[str, any];

    def extract_missing_skills(
        user_skills: list[str], required_skills: list[str]
    ) -> dict[str, any];

    def get_matched_skills()  -> dict[str, any] by llm(
        method="ReAct", tool=[self.extract_matching_skills]
    );

    def get_missing_skills()  -> dict[str, any] by llm(
        method="ReAct", tool=[self.extract_missing_skills]
    );

    def get_user_data()  -> UserData;
    can start with `root entry;
    can calculate_score with UserData entry;
}

walker get_dashboard_data {
    can start with `root entry {
        visit [-->(`?UserData)];
    }

    can collect with UserData entry {
        # 1. Ensure UserData exists
        user_data = here;
        if not user_data {
            report {
                "success": False,
                "redirect": "login",
                "error": "UserData not found"
            } ;
            disengage;
        }

        # 2. Ensure target role exists
        target_role_name = user_data.get_target_role();
        if not target_role_name {
            report {
                "success": False,
                "redirect": "onboarding",
                "error": "Target role not set"
            } ;
            disengage;
        }

        # 3. Collect job postings attached to user
        job_postings_result = root spawn collect_job_postings(
            target_role=target_role_name
        );

        jobs = [user_data-->(`?JobPosting)];

        # 4. Extract target role requirements
        role_extraction_result = root spawn extract_target_role_requirements(
            target_role=target_role_name
        );
        role_node = [user_data-->(`?Role:name==target_role_name)][0];

        # 5. Compute match score
        match_result = user_data spawn compute_match_score(
            target_role=role_node, user_data=user_data
        );

        # 6. Gather user skills and resume summary
        skills = user_data.get_skills();
        resume_summary = user_data.resume_summary;

        # 7. Dashboard metrics
        total_skills = len(skills);
        matched_skills_count = len(match_result["matched_skills"]);
        missing_skills_count = len(match_result["missing_skills"]);

        # 8. Report all data for frontend dashboard
        report {
            "success": True,
            "user_email": user_data.email,
            "target_role": role_node.name,
            "role_description": role_node.description,
            "skills": skills,
            "resume_summary": resume_summary,
            "match_score": match_result["score_value"],
            "match_explanation": match_result["explanation"],
            "matched_skills": match_result["matched_skills"],
            "missing_skills": match_result["missing_skills"],
            "total_skills": total_skills,
            "matched_skills_count": matched_skills_count,
            "missing_skills_count": missing_skills_count,
            "job_postings": [
                {
                    "title": j.title,
                    "company": j.company,
                    "location": j.location,
                    "posted_at": j.posted_at
                } for j in jobs
            ]
        } ;
    }
}

with entry {
    load_dotenv();
}
