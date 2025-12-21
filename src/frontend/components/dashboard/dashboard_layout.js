import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { useState } from "react";
import { Header } from "../../components/layout/Header.js";
import { DashboardHeader } from "./dashboard_header.js";
import { DashboardSidebar } from "./dashboard_sidebar.js";
import { DashboardInfoPanel } from "./dashboard_info_panel.js";
function DashboardLayout(props) {
  let [sidebarOpen, setSidebarOpen] = useState(true);
  let [infoOpen, setInfoOpen] = useState(true);
  let dashboardData = props.dashboardData || {};
  let user_email = "user_email" in dashboardData ? dashboardData["user_email"] : "";
  let target_role = "target_role" in dashboardData ? dashboardData["target_role"] : "";
  let skills = "skills" in dashboardData ? dashboardData["skills"] : [];
  let resume_summary = "resume_summary" in dashboardData ? dashboardData["resume_summary"] : "";
  let match_score = "match_score" in dashboardData ? dashboardData["match_score"] : {};
  return __jacJsx("div", {"className": "min-h-screen bg-gray-50"}, [__jacJsx(DashboardHeader, {"user_email": user_email, "target_role": target_role}, []), __jacJsx("div", {"className": "flex h-[calc(100vh-72px)]"}, [sidebarOpen && __jacJsx(DashboardSidebar, {"target_role": target_role, "skills_count": skills.length, "resume_summary": resume_summary}, []), __jacJsx("main", {"className": "flex-1 overflow-y-auto p-6"}, [props.children]), infoOpen && __jacJsx(DashboardInfoPanel, {"match_score": "score_value" in match_score ? match_score["score_value"] : 0, "matched_skills": "matched_skills" in match_score ? len(match_score["matched_skills"]) : 0, "missing_skills": "missing_skills" in match_score ? len(match_score["missing_skills"]) : 0}, [])])]);
}
export { DashboardLayout };
