import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function DashboardSidebar(props) {
  let user_email = props["user_email"];
  let target_role = props["target_role"];
  let skills = props["skills"] || [];
  let missing_skills = props["missing_skills"] || [];
  let skills_count = skills.length;
  let missing_count = missing_skills.length;
  return __jacJsx("aside", {"className": "w-full lg:w-64 card fade-in space-y-4"}, [__jacJsx("div", {"className": "space-y-1"}, [__jacJsx("p", {"className": "text-xs uppercase tracking-wide text-gray-400"}, ["Account"]), __jacJsx("div", {"className": "flex items-center gap-2 text-sm text-gray-800"}, [__jacJsx("span", {"className": "break-all font-medium"}, [user_email])])]), __jacJsx("div", {"className": "border-t border-gray-200 pt-3 space-y-2"}, [__jacJsx("div", {"className": "flex items-center justify-between"}, [__jacJsx("span", {"className": "text-sm text-gray-500"}, ["Target Role"]), __jacJsx("div", {"className": "flex items-center gap-1 text-sm font-semibold text-primary-500"}, [target_role])]), __jacJsx("div", {"className": "flex justify-between items-center"}, [__jacJsx("span", {"className": "text-sm text-gray-500"}, ["Total Skills"]), __jacJsx("span", {"className": "text-sm font-semibold text-gray-800"}, [skills_count])])]), __jacJsx("div", {"className": "border-t border-gray-200 pt-3"}, [__jacJsx("h4", {"className": "text-sm font-semibold text-gray-700 mb-2"}, ["Your Skills"]), __jacJsx("div", {"className": "max-h-60 overflow-y-auto space-y-1"}, [skills.map(skill => {
    return __jacJsx("div", {"className": "flex items-center gap-2 text-xs bg-gray-100 px-2 py-1 rounded-md"}, [__jacJsx("span", {"className": "text-success-500 font-bold"}, ["✓"]), __jacJsx("span", {"className": "text-gray-800"}, [skill["name"]])]);
  })]), missing_skills.length > 0 && __jacJsx("div", {"className": "mt-3"}, [__jacJsx("h4", {"className": "text-sm font-semibold text-gray-700 mb-2"}, ["Missing Skills"]), __jacJsx("div", {"className": "max-h-60 overflow-y-auto space-y-1"}, [missing_skills.map(skill => {
    return __jacJsx("div", {"className": "flex items-center gap-2 text-xs bg-red-100 px-2 py-1 rounded-md"}, [__jacJsx("span", {"className": "text-error-500 font-bold"}, ["X"]), __jacJsx("span", {"className": "text-gray-800"}, [skill])]);
  })])])])]);
}
export { DashboardSidebar };
