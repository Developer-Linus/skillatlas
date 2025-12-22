import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function DashboardWelcome(props) {
  let user_email = props["user_email"];
  return __jacJsx("div", {"className": "fade-in mb-4"}, [__jacJsx("h2", {"className": "section-heading"}, ["Welcome,", __jacJsx("span", {"className": "text-gradient font-semibold"}, [user_email])]), __jacJsx("p", {"className": "text-sm text-gray-500 mt-1"}, ["Here’s a snapshot of your progress and next steps"])]);
}
export { DashboardWelcome };
