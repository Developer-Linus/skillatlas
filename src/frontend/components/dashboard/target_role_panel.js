import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function TargetRoleInfoPanel(props) {
  let target_role = props["target_role"];
  let role_description = props["role_description"] || "No description available for this role.";
  return __jacJsx("aside", {"className": "w-full lg:w-80 card fade-in p-4 bg-gray-50 border border-gray-200 space-y-4"}, [__jacJsx("h3", {"className": "text-lg font-semibold text-primary-500"}, ["About ", target_role]), __jacJsx("p", {"className": "text-sm text-gray-700 leading-relaxed"}, [role_description])]);
}
export { TargetRoleInfoPanel };
