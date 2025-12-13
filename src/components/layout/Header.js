import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { Logo } from "./Logo.js";
import { NavMenu } from "./NavMenu.js";
function Header() {
  return __jacJsx("header", {"className": "w-full bg-gray-50 shadow-md"}, [__jacJsx("div", {"className": "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex flex-col sm:flex-row items-center justify-between gap-4"}, [__jacJsx(Logo, {}, []), __jacJsx(NavMenu, {}, [])])]);
}
export { Header };
