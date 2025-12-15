import from backend.models.models { UserData, JobPosting }
import from tools { WebSearch }

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
