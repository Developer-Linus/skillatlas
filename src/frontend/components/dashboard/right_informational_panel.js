import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function RightPanel(props) {
  let resume_summary = props["resume_summary"];
  let target_role = props["target_role"];
  let role_description = props["role_description"] || "No description available.";
  return __jacJsx("aside", {"className": "w-full lg:w-80 flex flex-col gap-6 bg-gray-100 p-4 rounded-lg shadow-md"}, [__jacJsx("div", {"className": "card fade-in p-4 bg-white shadow-sm rounded-md border border-gray-200"}, [__jacJsx("h3", {"className": "text-lg font-semibold text-gray-800 mb-2"}, ["Resume Summary"]), __jacJsx("p", {"className": "text-sm text-gray-700"}, [resume_summary])]), __jacJsx("div", {"className": "card fade-in p-4 bg-white shadow-sm rounded-md border border-gray-200"}, [__jacJsx("h3", {"className": "text-lg font-semibold text-primary-500 mb-2"}, ["About ", target_role]), __jacJsx("p", {"className": "text-sm text-gray-700 leading-relaxed"}, [role_description])])]);
}
export { RightPanel };
