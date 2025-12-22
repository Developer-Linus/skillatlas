import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function DashboardMetrics(props) {
  let matched = props["matched_skills_count"];
  let missing = props["missing_skills_count"];
  let fit = props["role_fit_percent"];
  let radius = 42;
  let circumference = 2 * 3.1416 * radius;
  let offset = circumference - fit / 100 * circumference;
  return __jacJsx("div", {"className": "grid grid-cols-1 sm:grid-cols-3 gap-6"}, [__jacJsx("div", {"className": "card flex flex-col justify-center items-center gap-2 fade-in hover:scale-105 transition-transform duration-300"}, [__jacJsx("div", {"className": "text-4xl text-success-500"}, ["✓"]), __jacJsx("p", {"className": "text-gray-600 font-medium text-center"}, ["Matched Skills"]), __jacJsx("p", {"className": "text-3xl font-bold text-success-500"}, [matched])]), __jacJsx("div", {"className": "card flex flex-col justify-center items-center gap-3 fade-in hover:scale-105 transition-transform duration-300"}, [__jacJsx("div", {"className": "text-4xl text-primary-500"}, ["🎯"]), __jacJsx("p", {"className": "text-gray-600 font-medium text-center mb-2"}, ["Role Fit"]), __jacJsx("div", {"className": "relative flex justify-center items-center"}, [__jacJsx("svg", {"width": "120", "height": "120"}, [__jacJsx("circle", {"cx": "60", "cy": "60", "r": radius, "stroke": "#E5E7EB", "strokeWidth": "8", "fill": "none"}, []), __jacJsx("circle", {"cx": "60", "cy": "60", "r": radius, "stroke": "#3B82F6", "strokeWidth": "8", "fill": "none", "strokeDasharray": circumference, "strokeDashoffset": offset, "strokeLinecap": "round", "transform": "rotate(-90 60 60)"}, [])]), __jacJsx("div", {"className": "absolute text-xl font-bold text-primary-500"}, [fit, "%"])])]), __jacJsx("div", {"className": "card flex flex-col justify-center items-center gap-2 fade-in hover:scale-105 transition-transform duration-300"}, [__jacJsx("div", {"className": "text-4xl text-error-500"}, ["⚠"]), __jacJsx("p", {"className": "text-gray-600 font-medium text-center"}, ["Missing Skills"]), __jacJsx("p", {"className": "text-3xl font-bold text-error-500"}, [missing])])]);
}
export { DashboardMetrics };
