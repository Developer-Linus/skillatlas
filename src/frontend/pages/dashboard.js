import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { useState, useEffect } from "react";
import { jacLogout, jacIsLoggedIn, Navigate } from "@jac-client/utils";
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
      console.log(result);
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
  let has_learning_path = false;
  if (learning_path && learning_path["phases"] && learning_path["phases"].length > 0) {
    has_learning_path = true;
  }
  let phase_index = 0;
  return __jacJsx("div", {"className": "min-h-screen bg-gray-50 font-sans p-6"}, [__jacJsx("header", {"className": "header fade-in mb-6"}, [__jacJsx("div", {"className": "header-inner flex justify-between items-center"}, [__jacJsx("div", {}, [__jacJsx("h1", {"className": "logo-title"}, ["SkillAtlas Dashboard"]), __jacJsx("p", {"className": "logo-subtitle"}, ["Your career insights at a glance"])]), __jacJsx("button", {"className": "nav-button nav-button-logout px-4 py-2 rounded text-white bg-cyan-500 hover:bg-cyan-600 transition", "onClick": () => {
    jacLogout();
  }}, ["Logout"])])]), __jacJsx("div", {"className": "flex flex-col lg:flex-row gap-6 max-w-7xl mx-auto"}, [__jacJsx("aside", {"className": "w-full lg:w-64 card fade-in space-y-3"}, [__jacJsx("p", {}, [__jacJsx("b", {}, ["Email:"]), " ", user_email]), __jacJsx("p", {}, [__jacJsx("b", {}, ["Target Role:"]), " ", target_role]), __jacJsx("p", {}, [__jacJsx("b", {}, ["Total Skills:"]), " ", skills_count]), __jacJsx("div", {"className": "mt-4 max-h-60 overflow-y-auto border-t border-gray-200 pt-2"}, [__jacJsx("h4", {"className": "text-sm font-semibold text-gray-600 mb-2"}, ["Skills"]), skills.map(skill => {
    return __jacJsx("span", {"className": "inline-block bg-primary-500 text-white text-xs px-2 py-1 rounded mr-1 mb-1"}, [skill["name"]]);
  })])]), __jacJsx("main", {"className": "flex-1 space-y-6"}, [__jacJsx("h2", {"className": "section-heading text-gradient fade-in"}, ["Welcome, ", user_email]), __jacJsx("div", {"className": "grid grid-cols-1 sm:grid-cols-3 gap-6"}, [__jacJsx("div", {"className": "card text-center fade-in hover:scale-105 transition-transform duration-300"}, [__jacJsx("p", {"className": "text-gray-600 font-medium"}, ["Matched Skills"]), __jacJsx("p", {"className": "text-2xl font-bold text-success-500"}, [matched_skills_count])]), __jacJsx("div", {"className": "card text-center fade-in hover:scale-105 transition-transform duration-300"}, [__jacJsx("p", {"className": "text-gray-600 font-medium"}, ["Missing Skills"]), __jacJsx("p", {"className": "text-2xl font-bold text-error-500"}, [missing_skills_count])]), __jacJsx("div", {"className": "card text-center fade-in hover:scale-105 transition-transform duration-300"}, [__jacJsx("p", {"className": "text-gray-600 font-medium"}, ["Role Fit %"]), __jacJsx("p", {"className": "text-2xl font-bold text-primary-500"}, [role_fit_percent])])]), __jacJsx("div", {"className": "card fade-in"}, [__jacJsx("h3", {"className": "font-semibold mb-2 text-gray-800"}, ["Resume Summary"]), __jacJsx("p", {"className": "text-sm text-gray-600"}, [resume_summary])]), __jacJsx("div", {"className": "card fade-in"}, [__jacJsx("h3", {"className": "font-semibold mb-4 text-gray-800"}, ["Learning Roadmap to Become ", target_role]), "if", " not has_learning_path ", __jacJsx("p", {"className": "text-sm text-gray-500"}, ["We are preparing a personalized learning roadmap for you based on your skill gaps."]), " else ", __jacJsx("div", {"className": "relative border-l-2 border-primary-200 pl-6 space-y-6"}, [learning_path["phases"].map(phase => {
    let is_active = phase_index === 0;
    let current_phase_number = phase_index + 1;
    phase_index = phase_index + 1;
    let dot_class = "absolute -left-[10px] top-2 w-4 h-4 rounded-full ";
    if (is_active) {
      dot_class = dot_class + "bg-primary-500";
    } else {
      dot_class = dot_class + "bg-gray-300";
    }
    let card_class = "p-4 rounded-lg border transition ";
    if (is_active) {
      card_class = card_class + "border-primary-300 bg-primary-50";
    } else {
      card_class = card_class + "border-gray-200 bg-white opacity-70";
    }
    return __jacJsx("div", {"className": "relative fade-in"}, [__jacJsx("div", {"className": dot_class}, []), __jacJsx("div", {"className": card_class}, [__jacJsx("div", {"className": "flex justify-between items-center mb-2"}, [__jacJsx("h4", {"className": "font-semibold text-gray-800"}, ["Phase ", current_phase_number, ": ", phase["phase_title"]]), __jacJsx("span", {"className": "text-xs text-gray-500"}, [phase["estimated_time"]])]), __jacJsx("div", {"className": "mb-2"}, [__jacJsx("p", {"className": "text-xs text-gray-600 mb-1"}, ["Skills Covered"]), __jacJsx("div", {"className": "flex flex-wrap gap-1"}, [phase["skills_targeted"].map(skill => {
      return __jacJsx("span", {"className": "text-xs bg-gray-200 px-2 py-1 rounded"}, [skill]);
    })])]), __jacJsx("div", {"className": "flex justify-between items-center mt-3"}, [__jacJsx("p", {"className": "text-xs text-gray-500"}, [phase["resources_count"], " learning resources"]), "if", " is_active ", __jacJsx("button", {"className": "text-xs px-3 py-1 rounded bg-primary-500 text-white hover:bg-primary-600 transition"}, ["Start Phase"]), " else ", __jacJsx("span", {"className": "text-xs text-gray-400"}, ["Locked"])])])]);
  })])]), __jacJsx("div", {"className": "card fade-in"}, [__jacJsx("h3", {"className": "font-semibold mb-4 text-gray-800"}, ["Job Opportunities"]), __jacJsx("div", {"className": "grid grid-cols-1 sm:grid-cols-2 gap-4"}, [job_postings.map(job => {
    return __jacJsx("div", {"className": "card border border-gray-200 hover:shadow-lg transition-shadow p-4 fade-in"}, [__jacJsx("p", {"className": "font-semibold text-primary-500"}, [job["title"]]), __jacJsx("p", {"className": "text-sm text-gray-600"}, [job["company"]]), __jacJsx("p", {"className": "text-xs text-gray-500"}, [job["location"]])]);
  })])])])])]);
}
export { DashboardPage };
