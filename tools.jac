import from dotenv { load_dotenv }
import from core.serper { SERPER_API_KEY }
import requests;

obj WebSearch {
    has api_key: str = SERPER_API_KEY;
    has base_url: str = "https://google.serper.dev/search";
    has jobs_url: str = "https://google.serper.dev/jobs";

    """
    Fetches market trend insights for a given job role in Kenya. This method is intentionally focused on trends - not job postings.
    """

    def search_job_trends(role: str) -> str {
        headers = {"X-API-KEY": self.api_key, "Content-Type": "application/json"};

        # Query designed to force Google results toward trend-focused content
        query = f"latest {role} job market trends Kenyan youth demand skills for the years 2024 and 2025.";
        payload = {
            "q": query,
            "gl": "ke",
            "hl": "en",
            "num": 10
        }
        # Make Serper API request
        resp = requests.post(self.base_url, headers=headers, json=payload);

        if resp.status_code != 200 {
            return f"Serper request failed: {resp.status_code}";
        }

        data = resp.json();

        # Main list of search results
        organic_results = data.get("organic", []) if isinstance(data, dict) else [];

        # Extract trend insights
        trend_keywords = ["trend", "demand", "market", "growth",
            "skills", "opportunities", "youth", "hiring"];
        # Extract from organic search snippets
        for item in organic_results {
            snippet = item.get("snippet", "");
            lower_snippet = snippet.lower();
            # Keep snippet only if it contains any trend keyword
            for kw in trend_keywords{
                if kw in lower_snippet{
                    trends.append(snippet);
                    break;
                }
            }
        }
        # Extract from People Also Ask (PAA) section
        for paa in data.get("peopleAlsoAsk", []){
            answer = paa.get("answer", "");
            if answer {
                trends.append(answer);
            }
        }
        # Extract from knowledge graph description
        kg = data.get("knowledgeGraph", {});
        if kg.get("description"){
            trends.append(kg["description"]);
        }

        # Handle case where no trends were found
        if len(trends) == 0 {
            return "No clear market trends found for this role.";
        }
        # Return clean, concise summary
        summary = "";
        for t in trends[:6]{
            summary += f"-{t}\n";
        }
        return summary;
    }

    # Fetches active job postings for a given role in Kenya using Serper Jobs API
    def search_job_postings(role: str) {
        headers = {"X-API-KEY":self.api_key, "Content-Type": "application/json"};
        payload = {
            "q": f"{role} jobs Kenya",
            "gl": "ke",
            "hl": "en",
            "num": 20
        };
        resp = requests.post(self.jobs_url, headers=headers, json=payload);
        if resp.status_code != 200{
            return f"Serper request failed: {resp.status_code}";
        }
        data = resp.json();
        jobs = data.get("jobs", []);

        jobs = jobs[:10];
        
        job_nodes = [];
        for job in jobs {
            job_nodes.append({
                "title": job.get('title', ""),
                "company": job.get("companyName", ""),
                "location": job.get("location", ""),
                "salary_range": job.get("salary", ""),
                "role_type": job.get("jobType", "")
            });
        }
        return job_nodes;
    }
}
