import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { MetricCard } from "./metric_card.js";
function DashboardInfoPanel(match_score, matched_skills, missing_skills, avg_level, readiness) {
  return __jacJsx("aside", {"className": "w-72 bg-white border-l border-gray-200 p-4 fade-in hidden lg:block"}, [__jacJsx("h3", {"className": "section-subheading"}, ["Your Fit"]), __jacJsx(RadialMatchScore, {"score": match_score}, []), __jacJsx("div", {"className": "grid grid-cols-2 gap-3 mt-4"}, [__jacJsx(MetricCard, {"label": "Matched", "value": matched_skills.toString()}, []), __jacJsx(MetricCard, {"label": "Missing", "value": missing_skills.toString()}, []), __jacJsx(MetricCard, {"label": "Level Avg", "value": avg_level}, []), __jacJsx(MetricCard, {"label": "Readiness", "value": readiness}, [])])]);
}
export { DashboardInfoPanel };
