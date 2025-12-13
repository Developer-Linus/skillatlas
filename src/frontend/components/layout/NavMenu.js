import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { Link, jacIsLoggedIn, jacLogout, Navigate } from "@jac-client/utils";
function NavMenu() {
  let logged_in = jacIsLoggedIn();
  function MenuLinks() {
    if (logged_in) {
      return __jacJsx("div", {"className": "flex flex-col sm:flex-row sm:items-center sm:gap-6 mt-2 sm:mt-0"}, [__jacJsx(Link, {"to": "/dashboard", "className": "nav-link text-base font-medium text-blue-600 hover:text-blue-700 transition py-2"}, ["Dashboard"]), __jacJsx(Link, {"to": "/todos", "className": "nav-link text-base font-medium text-blue-600 hover:text-blue-700 transition py-2"}, ["Todos"]), __jacJsx(Link, {"to": "/learning", "className": "nav-link text-base font-medium text-blue-600 hover:text-blue-700 transition py-2"}, ["Learning"]), __jacJsx("button", {"className": "auth-button px-4 py-2 rounded bg-cyan-500 text-white hover:bg-cyan-600 transition", "onClick": () => {
        jacLogout();
      }}, ["Logout"])]);
    } else {
      return __jacJsx("div", {"className": "flex flex-col sm:flex-row sm:items-center sm:gap-6 mt-2 sm:mt-0"}, [__jacJsx(Link, {"to": "/login", "className": "auth-button px-4 py-2 rounded bg-blue-600 text-white hover:bg-blue-700 transition"}, ["Login"]), __jacJsx(Link, {"to": "/signup", "className": "auth-button px-4 py-2 rounded bg-green-500 text-white hover:bg-green-600 transition"}, ["Sign Up"])]);
    }
  }
  return __jacJsx("nav", {"className": "nav-menu relative flex flex-col sm:flex-row sm:items-center gap-2"}, [__jacJsx(MenuLinks, {}, [])]);
}
export { NavMenu };
