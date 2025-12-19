import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function DashboardHeader(user_email, target_role) {
  __jacJsx("div", {"class": "card mb-6 flex justify-between items-center"}, [__jacJsx("div", {}, [__jacJsx("h1", {"class": "section-heading"}, ["Welcome, ", user_email, "!"]), __jacJsx("p", {"class": "text-gray-600"}, ["Target Role:", __jacJsx("span", {"class": "font-semibold"}, [target_role])])]), __jacJsx("div", {}, [__jacJsx("button", {"class": "primary-btn"}, ["Edit Profile"])])]);
}
export { DashboardHeader };
