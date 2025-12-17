import base64;
import os;
import time;
import from dotenv { load_dotenv }
import from byllm.lib { Model }
import from backend.models.models { UserData, UserRole }
import from backend.models.models { UserData, JobPosting, Skill, SkillSpec }
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
    can fetch_and_attach_jobs with `root entry;
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

with entry {
    load_dotenv();
}
