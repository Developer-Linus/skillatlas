import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function JobOpportunities(props) {
  let job_postings = props["job_postings"] || [];
  if (job_postings.length === 0) {
    return __jacJsx("div", {"className": "card fade-in"}, [__jacJsx("h3", {"className": "font-semibold mb-4 text-gray-800"}, ["Job Opportunities"]), __jacJsx("p", {"className": "text-sm text-gray-500"}, ["No job opportunities found at the moment. Please check back later."])]);
  }
  return __jacJsx("div", {"className": "card fade-in"}, [__jacJsx("h3", {"className": "font-semibold mb-4 text-gray-800"}, ["Job Opportunities"]), __jacJsx("div", {"className": "grid grid-cols-1 sm:grid-cols-2 gap-4"}, [job_postings.map(job => {
    return __jacJsx("div", {"className": "card border border-gray-200 hover:shadow-lg transition-shadow p-4 fade-in"}, [__jacJsx("p", {"className": "font-semibold text-primary-500"}, [job["title"]]), __jacJsx("p", {"className": "text-sm text-gray-600"}, [job["company"]]), __jacJsx("p", {"className": "text-xs text-gray-500"}, [job["location"]])]);
  })])]);
}
export { JobOpportunities };
