import os;
import requests;
import logging;
import from hashlib { md5 }
import from firecrawl { Firecrawl }
import from byllm.lib { Model }

glob llm = Model(model_name="mistral/mistral-small-latest", verbose=False);

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
        if not target_role or len(missing_skills) == 0 {
            return [];
        }
        """
        You are an expert learning architect.

        Generate ONE concise web search query to find structured ONLINE COURSES
        (not articles, blogs, or forum posts) for becoming a {target_role}.

        Rules:
        - Include ONLY the top 5 missing skills
        - MUST include words: course OR specialization OR certification
        - Prefer platforms: Coursera, Udemy, edX, Pluralsight
        - Exclude blogs, Reddit, Medium, LinkedIn
        - Max 18 words
        - Return ONLY the query string

        Good example:
        "Data Analyst advanced SQL data governance certification Coursera Udemy"
    """;
        def build_firecrawl_query(target_role: str, missing_skills: list[str]) -> str by llm();
        query = build_firecrawl_query(target_role, missing_skills);

        # -----------------------------
        # Perform Firecrawl search
        # -----------------------------
        firecrawl = Firecrawl(api_key=self.firecrawl_api_key);

        try {
            results = firecrawl.search(query=query, sources=["web"], limit=limit);
        } except Exception as e {
            print("Firecrawl search failed:", e);
            return [];
        }

        # -----------------------------
        # -----------------------------
        # Validate results
        # Validate results
        # -----------------------------
        # -----------------------------
        if not hasattr(results, "web") or not results.web {
            print("No web results found from Firecrawl");
            return [];
        }

        # -----------------------------
        # -----------------------------
        # Transform results to Jac-friendly format
        # Transform results to Jac-friendly format
        # -----------------------------
        # -----------------------------
        resources = [];
        for r in results.web {
            resources.append(
                {
                    "title": getattr(r, "title"),
                    "url": getattr(r, "url"),
                    "description": getattr(r, "description"),
                    "provider": "Web"
                }
            );
        }

        return resources;
    }
}
