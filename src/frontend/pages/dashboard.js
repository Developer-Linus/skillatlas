import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { useState, useEffect } from "react";
import { jacLogout, jacIsLoggedIn, Navigate } from "@jac-client/utils";
import { LearningRoadmap } from "../components/dashboard/learning_path.js";
import { DashboardHeader } from "../components/dashboard/dashboard_header.js";
import { DashboardSidebar } from "../components/dashboard/dashboard_sidebar.js";
import { DashboardWelcome } from "../components/dashboard/dashboard_welcome.js";
import { DashboardMetrics } from "../components/dashboard/dashboard_metrics.js";
import { ResumeSummary } from "../components/dashboard/resume_summary.js";
import { JobOpportunities } from "../components/dashboard/job_opportunities.js";
import { RightPanel } from "../components/dashboard/right_informational_panel.js";
function DashboardPage() {
  if (!jacIsLoggedIn()) {
    return __jacJsx(Navigate, {"to": "/login"}, []);
  }
  let [dashboardData, setDashboardData] = useState(null);
  let [loading, setLoading] = useState(true);
  useEffect(() => {
    let cancelled = false;
    async function fetchData() {
      let result = await __jacSpawn("get_dashboard_data", "", {});
      if (cancelled) {
        return;
      }
      if (result.reports && result.reports.length > 0) {
        let dashboard = result.reports[0];
        if (dashboard && dashboard["success"] && !cancelled) {
          setDashboardData(dashboard);
        }
      }
      if (!cancelled) {
        setLoading(false);
      }
    }
    fetchData();
    return () => {
      cancelled = true;
    };
  }, []);
  if (loading) {
    return __jacJsx("div", {"className": "flex justify-center items-center h-screen"}, [__jacJsx("p", {"className": "text-gray-600 text-lg animate-pulse"}, ["Loading Dashboard..."])]);
  }
  if (!dashboardData || !dashboardData["success"]) {
    return __jacJsx("div", {"className": "flex justify-center items-center h-screen"}, [__jacJsx("p", {"className": "text-error-500 text-lg font-semibold"}, ["Failed to load dashboard."])]);
  }
  let user_email = dashboardData["user_email"];
  let target_role = dashboardData["target_role"];
  let skills = dashboardData["skills"] || [];
  let skills_count = skills.length;
  let matched_skills_list = dashboardData["matched_skills"] || [];
  let missing_skills_list = dashboardData["missing_skills"] || [];
  let matched_skills_count = dashboardData["matched_skills_count"];
  let missing_skills_count = dashboardData["missing_skills_count"];
  let match_score = dashboardData["match_score"];
  let role_fit_percent = Math.round(match_score * 100);
  let resume_summary = dashboardData["resume_summary"];
  let job_postings = dashboardData["job_postings"] || [];
  let learning_path = dashboardData["learning_path"];
  let role_description = dashboardData["role_description"];
  return __jacJsx("div", {"className": "min-h-screen bg-gray-50 font-sans p-6"}, [__jacJsx(DashboardHeader, {}, []), __jacJsx("div", {"className": "flex flex-col lg:flex-row gap-6 max-w-7xl mx-auto"}, [__jacJsx(DashboardSidebar, {"user_email": user_email, "target_role": target_role, "skills": skills, "missing_skills": missing_skills_list}, []), __jacJsx("main", {"className": "flex-1 space-y-6"}, [__jacJsx(DashboardWelcome, {"user_email": user_email}, []), __jacJsx(DashboardMetrics, {"matched_skills_count": matched_skills_count, "missing_skills_count": missing_skills_count, "role_fit_percent": role_fit_percent}, []), __jacJsx(ResumeSummary, {"resume_summary": resume_summary}, []), __jacJsx(LearningRoadmap, {"learning_path": learning_path, "target_role": target_role}, []), __jacJsx(JobOpportunities, {"job_postings": job_postings}, [])]), __jacJsx(RightPanel, {"resume_summary": resume_summary, "target_role": target_role, "role_description": role_description}, [])])]);
}
export { DashboardPage };
