import os;
import requests;
import logging;
import from hashlib { md5 }
import from firecrawl { Firecrawl }

obj WebSearch {
    has api_key: str = os.getenv("SCRAPINGDOG_API_KEY");
    has base_url: str = "https://api.scrapingdog.com/google_jobs";
    has firecrawl_api_key: str = os.getenv("FIRECRAWL_API_KEY");

    """
    Fetch raw job postings for a given role in Kenya.
    Simple version based on Scrapingdog example.
    """
    def search_job_postings(role: str) -> list {
        logging.basicConfig(level=logging.INFO);

        params = {
            "api_key": self.api_key,
            "query": f"{role}+jobs+in+Kenya",
            "country": "KE",
            "language": "en",

        };

        try {
            resp = requests.get(self.base_url, params=params, timeout=10);
            resp.raise_for_status();
        } except requests.exceptions.Timeout {
            logging.error("Request timed out while fetching job postings.");
            return [];
        } except requests.exceptions.RequestException as e {
            logging.error(f"Error during Scrapingdog request: {e}");
            return [];
        }

        try {
            data = resp.json();
        } except ValueError {
            logging.error("Failed to parse JSON from Scrapingdog response.");
            return [];
        }

        jobs = data.get("jobs_results", []);
        if not isinstance(jobs, list) {
            logging.warning("Unexpected jobs_results format; expected a list.");
            return [];
        }

        job_nodes = [];
        for job in jobs {
            try {
                title = job.get("title", "").strip();
                company = job.get("company_name", "").strip();
                location = job.get("location", "").strip();
                description = job.get("description", "").strip();
                extensions = job.get("extensions", []);
                apply_links = job.get("apply_links", []);
                source = job.get("via", job.get("source", "")).strip();
                employment_type = "UNKNOWN";
                posted_at = "";
                for ext in extensions {
                    lower_ext = ext.lower();
                    if "full" in lower_ext
                    or "part" in lower_ext
                    or "contract" in lower_ext {
                        employment_type = ext;
                    } elif "day" in lower_ext or "ago" in lower_ext {
                        posted_at = ext;
                    }
                }

                salary = "";
                job_uid_str = f"{title}_{company}_{location}";
                job_uid = md5(job_uid_str.encode("utf-8")).hexdigest();

                job_nodes.append(
                    {
                        "job_uid": job_uid,
                        "title": title,
                        "company": company,
                        "location": location,
                        "employment_type": employment_type,
                        "description": description,
                        "posted_at": posted_at,
                        "source": source,
                        "salary": salary,
                        "apply_links": apply_links
                    }
                );
            } except Exception as e {
                logging.warning(f"Skipping a job due to unexpected format: {e}");
                continue;
            }
        }

        if not job_nodes {
            logging.info(f"No job postings found for role '{role}'.");
        }

        return job_nodes;
    }

    def fetch_learning_resources(
        target_role: str, missing_skills: list[str], limit: int = 5
    ) -> list {
        if not target_role or missing_skills.length == 0 {
            return [];
        }

        skills_text = "";
        for skill in missing_skills {
            if skills_text == "" {
                skills_text = skill;
            } else {
                skills_text = skills_text + ", " + skill;
            }
        }

        query = "best structured learning roadmap to become " + target_role + " covering skills such as " + skills_text;

        firecrawl = Firecrawl(api_key=self.firecrawl_api_key);

        result = None;
        try {
            result = firecrawl.search(query=query, limit=limit);
        } except Exception as e {
            return [];
        }

        if not result or not result["success"] {
            return [];
        }

        web_results = result["data"]["web"];
        if not web_results or not isinstance(web_results, list) {
            return [];
        }

        resources = [];

        for r in web_results {
            resources.append(
                {
                    "title": r["title"] or "",
                    "url": r["url"] or "",
                    "description": r["description"] or "",
                    "provider": "Web"
                }
            );
        }

        return resources;
    }
}
