import base64;
import os;
import time;
import from dotenv { load_dotenv }
import from byllm.lib { Model }
import from backend.models.models { UserData, UserRole }
import from backend.models.models {
    UserData,
    JobPosting,
    Skill,
    SkillSpec,
    RoleSpec,
    Role,
    MatchScore,
    MatchResult,
    MissingSkillsResult
}
import from backend.edges.edges { has_skill }
import from tools { WebSearch }
import from backend.utils.cv_utils { ResumeUtils }

glob llm = Model(model_name="mistral/mistral-small-latest", verbose=False);
# anthropic/claude-sonnet-4-5-20250929
# mistral/mistral-small-latest
walker profile_manager {
    def get_user_data()  -> UserData;
    def get_profile_snapshot()  -> dict[str, any];
    def summarize_profile()  -> str by llm(
        method="ReAct", tools=[self.get_profile_snapshot]
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
    ) -> RoleSpec by llm();

    can start with `root entry;
    can extract_requirements with UserData entry;
}

walker extract_and_attach_skills {
    has resume_parser_output: str;

    def get_resume_text()  -> str;
    def extract_skills(resume_text: str) -> list[SkillSpec] by llm();
    can start with `root entry;
    can extract with UserData entry;
}

walker compute_match_score {
    has target_role: Role;
    has user_data: UserData;
    has matched_skills: list[str] = [];
    has missing_skills: list[str] = [];
    has score_value: float = 0.0;
    has explanation: str = "";

    def extract_matching_skills(
        user_skills: list[str], required_skills: list[str]
    ) -> dict[str, any];

    def extract_missing_skills(
        user_skills: list[str], required_skills: list[str]
    ) -> dict[str, str | int];

    def get_matched_skills(
        user_skills: list[str], required_skills: list[str]
    ) -> MatchResult by llm();

    def get_missing_skills(
        user_skills: list[str], required_skills: list[str]
    ) -> MissingSkillsResult by llm();

    def get_user_data()  -> UserData;
    can start with `root entry;
    can calculate_score with UserData entry;
}

walker get_dashboard_data {
    can start with `root entry {
        visit [-->(`?UserData)];
    }

    can collect with UserData entry {
        user_data = here;

        # 1. Check if user exists
        if not user_data {
            report {
                "success": False,
                "redirect": "login",
                "error": "UserData not found"
            } ;
            disengage;
        }

        # 2. Check target role
        target_role_name = user_data.get_target_role();
        if not target_role_name {
            report {
                "success": False,
                "redirect": "onboarding",
                "error": "Target role not set"
            } ;
            disengage;
        }

        # 3. Collect job postings (only if missing)
        jobs = [user_data-->(`?JobPosting)];
        if len(jobs) == 0 {
            root spawn collect_job_postings(target_role=target_role_name);
            jobs = [user_data-->(`?JobPosting)];
        }

        # 4. Collect or create Role node
        role_nodes = [user_data-->(`?Role:name==target_role_name)];
        role_node = None;

        if len(role_nodes) > 0 {
            role_node = role_nodes[0];
        } else {
            # Create role if missing
            root spawn extract_target_role_requirements(target_role=target_role_name);
            role_nodes = [user_data-->(`?Role:name==target_role_name)];
            role_node = role_nodes[0];
        }

        # 5. Collect or compute MatchScore
        match_nodes = [user_data-->(`?MatchScore)];
        match_result = None;
        if len(match_nodes) > 0 {
            match_result = match_nodes[0];
        } else {
            # Compute MatchScore if it doesn’t exist
            match_result = user_data spawn compute_match_score(
                target_role=role_node, user_data=user_data
            );
        }

        # 6. Gather user skills and resume summary
        skills = user_data.get_skills() or [];
        resume_summary = user_data.resume_summary or "";

        # 7. Compute dashboard metrics safely
        total_skills = len(skills);
        matched_skills_count = len(match_result.matched_skills or []);
        missing_skills_count = len(match_result.missing_skills or []);
        match_score = match_result.score_value or 0.0;

        # 8. Report all dashboard data
        report {
            "success": True,
            "user_email": user_data.email,
            "target_role": role_node.name,
            "role_description": role_node.description or "",
            "skills": skills,
            "resume_summary": resume_summary,
            "match_score": match_score,
            "match_explanation": match_result.explanation or "",
            "matched_skills": match_result.matched_skills or [],
            "missing_skills": match_result.missing_skills or [],
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
