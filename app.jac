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

    def get_user_data()  -> UserData {
        return [root-->(`?UserData)][0];
    }

    def get_profile_snapshot()  -> dict[str, any] {
        return self.get_user().get_profile_snapshot();
    }

    def summarize_profile()  -> str by llm(
        method="ReAct", tools=([self.get_profile_snapshot])
    );

    can execute with `root entry;
}

walker resume_parser {
    has uploaded_path: str;
    has utils: ResumeUtils = ResumeUtils();

    def detect_resume_type()  -> str {
        return self.utils.detect_file_type(self.uploaded_path);
    }

    def parse_resume()  -> dict[str, any] {
        output = {"text": "", "file_type": "", "status": "failed", "errors": []};

        try {
            file_type = self.detect_resume_type();
            output["file_type"] = file_type;

            if file_type == "" {
                output["errors"].append("Could not detect file type");
                return output;
            }

            text = self.utils.extract_text_temp(self.uploaded_path, file_type);
            if text.strip() == "" {
                output["errors"].append("Failed to extract text from resume");
                return output;
            }

            output["text"] = text;
            output["status"] = "success";
        } except Exception as e {
            output["errors"].append(str(e));
        }

        return output;
    }

    def summarize_resume()  -> str by llm(method="ReAct", tools=([self.parse_resume]));
    can execute with `root entry;
}

walker save_user_profile {
    has email: str;
    has target_role: str;

    can start with `root entry {
        visit [here-->(`?UserData)] else {
            new_user_data = here ++> UserData(
                email=self.email,
                role=UserRole.USER.value,
                target_role=self.target_role
            );
            visit [-->new_user_data];
        }
    }

    can update_email_and_targetrole with UserData entry {
        here.email = self.email;
        here.target_role = self.target_role;

        report {"user_data_id": jid(here), "success": True, "user_node": here,} ;
    }
}

walker store_cv_file {
    has file_name: str;
    has file_data_b64: str;
    has upload_dir: str = "uploads";

    can start with `root entry {
        if not os.path.exists(self.upload_dir) {
            os.makedirs(self.upload_dir);
        }

        timestamp = str(int(time.time()));
        final_path = os.path.join(self.upload_dir, timestamp + "_" + self.file_name);

        try {
            raw_bytes = base64.b64decode(self.file_data_b64);
            with open(final_path, "wb") as f {
                f.write(raw_bytes);
            }

            report {"status": "success", "path": final_path} ;
        } except Exception as e {
            report {"status": "error", "error": str(e)} ;
        }
    }
}

walker collect_job_postings {
    has target_role: str;

    def get_user_data() {
        return [root-->(`?UserData)][0];
    }

    can start with `root entry {
        user_data = self.get_user_data();
        target_role = user_data.get_target_role();
        if not user_data {
            report {"error": "UserData not found"} ;
            disengage;
        }
        if not target_role {
            report {"error": "User has no target role"} ;
            disengage;
        }
        self.user_data = user_data;
        self.target_role = user_data.target_role;
    }

    can fetch_and_attach_jobs with `root entry {
        user_data = self.get_user_data();
        web = WebSearch();
        jobs = web.search_job_postings(self.target_role);

        if len(jobs) == 0 {
            report {"info": "No job postings found"} ;
            disengage;
        }

        for job in jobs {
            job_node = JobPosting(
                job_uid=job["job_uid"],
                title=job["title"],
                company=job["company"],
                location=job["location"],
                employment_type=job["employment_type"],
                description=job["description"],
                posted_at=job["posted_at"],
                source=job["source"],
                salary=job["salary"]
            );

            user_data ++> job_node;
        }

        report {"attached_jobs": len(jobs), "target_role": self.target_role} ;
    }
}

walker extract_and_attach_skills {
    has resume_parser_output: str;

    def get_resume_text()  -> str {
        user_data = here;
        return f"resume_parser_output: {self.resume_parser_output}, target_role: {user_data.get_target_role()}";
    }

    def extract_skills(profile_data: UserData) -> list[SkillSpec] by llm(
        method="ReAct", tools=[self.get_resume_text]
    );

    can start with `root entry;
    can extract with UserData entry;
}

with entry {
    load_dotenv();
}
