import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { Router, Routes, Route } from "@jac-client/utils";
import "./styles.css";
import { HomePage } from "./frontend/pages/homepage.js";
import { SignupPage } from "./frontend/pages/auth/signup.js";
import { LoginPage } from "./frontend/pages/auth/login.js";
import { Onboarding } from "./frontend/pages/onboarding.js";
function app() {
  return __jacJsx(Router, {}, [__jacJsx("div", {"className": "min-h-screen bg-gray-50 text-gray-900 font-sans"}, [__jacJsx(Routes, {}, [__jacJsx(Route, {"path": "/", "element": __jacJsx(HomePage, {}, [])}, []), __jacJsx(Route, {"path": "/login", "element": __jacJsx(LoginPage, {}, [])}, []), __jacJsx(Route, {"path": "/signup", "element": __jacJsx(SignupPage, {}, [])}, []), __jacJsx(Route, {"path": "/onboarding", "element": __jacJsx(Onboarding, {}, [])}, [])])])]);
}
export { app };
