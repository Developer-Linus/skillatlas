import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { useState, useEffect } from "react";
import { Header } from "../../components/layout/Header.js";
import { DashboardHeader } from "../components/dashboard/dashboard_header.js";
import { DashboardSidebar } from "../components/dashboard/dashboard_sidebar.js";
import { DashboardInfoPanel } from "../components/dashboard/dashboard_info_panel.js";
function DashboardPage() {
  let [dashboardData, setDashboardData] = useState(null);
  let [loading, setLoading] = useState(true);
  useEffect(() => {
    async function fetchData() {
      let result = await __jacSpawn("get_dashboard_data", "", {});
      console.log(result);
      if (result.reports && len(result.reports) > 0) {
        setDashboardData(result.reports[0]);
      }
      setLoading(false);
    }
    fetchData();
  }, []);
  if (loading) {
    return __jacJsx("div", {"className": "flex justify-center items-center h-screen"}, [__jacJsx("p", {"className": "text-gray-600"}, ["Loading Dashboard..."])]);
  }
  if (!dashboardData || !dashboardData["success"]) {
    return __jacJsx("div", {"className": "flex justify-center items-center h-screen"}, [__jacJsx("p", {"className": "text-red-500"}, [dashboardData ? dashboardData["error"] : "Failed to load dashboard."])]);
  }
  let user_email = dashboardData["user_email"];
  let target_role = dashboardData["target_role"];
  let skills_count = len(dashboardData["skills"]);
  let match_score = dashboardData["match_score"]["score_value"];
  let matched_skills = len(dashboardData["match_score"]["matched_skills"]);
  let missing_skills = len(dashboardData["match_score"]["missing_skills"]);
  let avg_level = dashboardData.get("avg_level", "Intermediate");
  let readiness = dashboardData.get("readiness", "Good");
  return __jacJsx(DashboardLayout, {}, [__jacJsx(DashboardSidebar, {"user_email": user_email, "skills_count": skills_count, "target_role": target_role}, []), __jacJsx("main", {"className": "flex-1 overflow-y-auto p-6"}, [__jacJsx("h1", {"className": "section-heading text-gradient"}, ["Welcome, ", user_email]), __jacJsx("p", {"className": "text-gray-600 mb-6"}, ["Here's a quick overview of your skills, role fit, and learning progress."]), __jacJsx("div", {"className": "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"}, [__jacJsx(MetricCard, {"label": "Matched Skills", "value": matched_skills.toString()}, []), __jacJsx(MetricCard, {"label": "Missing Skills", "value": missing_skills.toString()}, []), __jacJsx(MetricCard, {"label": "Role Fit %", "value": `${match_score}`}, [])]), __jacJsx("div", {"className": "mt-6 card"}, [__jacJsx("h2", {"className": "font-semibold mb-2"}, ["Resume Summary"]), __jacJsx("p", {"className": "text-sm text-gray-600"}, [dashboardData["resume_summary"]])])]), __jacJsx(DashboardInfoPanel, {"match_score": match_score, "matched_skills": matched_skills, "missing_skills": missing_skills, "avg_level": avg_level, "readiness": readiness}, [])]);
}
export { DashboardPage };
