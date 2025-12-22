import {__jacJsx, __jacSpawn} from "@jac-client/utils";
function DashboardHeader(props) {
  function handle_logout() {
    jacLogout();
  }
  return __jacJsx("header", {"className": "header fade-in mb-6 rounded-lg overflow-hidden"}, [__jacJsx("div", {"className": "header-inner flex justify-between items-center bg-white shadow-sm rounded-lg px-6 py-5"}, [__jacJsx("div", {}, [__jacJsx("h1", {"className": "text-3xl font-bold text-gradient"}, ["SkillAtlas"]), __jacJsx("p", {"className": "text-sm text-gray-500 mt-1"}, ["Your personalized career intelligence dashboard"])]), __jacJsx("div", {"className": "flex items-center gap-4"}, [__jacJsx("div", {"className": "hidden sm:block text-right"}, [__jacJsx("p", {"className": "text-xs text-gray-400"}, ["Signed in"]), __jacJsx("p", {"className": "text-sm font-medium text-gray-700"}, ["Career Explorer"])]), __jacJsx("button", {"className": "nav-button nav-button-logout flex items-center gap-2 px-4 py-2 rounded-md text-white bg-cyan-500 hover:bg-cyan-600 transition shadow-sm", "onClick": () => {
    handle_logout();
  }}, [__jacJsx("span", {}, ["Logout"]), __jacJsx("span", {"className": "text-xs opacity-80"}, ["→"])])])])]);
}
export { DashboardHeader };
