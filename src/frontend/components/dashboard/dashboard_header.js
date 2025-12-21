import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function DashboardHeader(user_email, target_role) {
  return __jacJsx("div", {"className": "card mb-6 flex justify-between items-center"}, [__jacJsx("div", {}, [__jacJsx("h1", {"className": "section-heading"}, ["Welcome, ", user_email, "!"]), __jacJsx("p", {"className": "text-gray-600"}, ["Target Role:", __jacJsx("span", {"className": "font-semibold"}, [target_role])])]), __jacJsx("div", {}, [__jacJsx("button", {"className": "primary-btn"}, ["Edit Profile"])])]);
}
export { DashboardHeader };
