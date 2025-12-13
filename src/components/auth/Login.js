import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { useState } from "react";
import { Link, jacLogin, jacIsLoggedIn, jacLogout } from "@jac-client/utils";
function LoginPage() {
  let [email, setEmail] = useState("");
  let [password, setPassword] = useState("");
  let [error, setError] = useState("");
  let [success, setSuccess] = useState("");
  if (jacIsLoggedIn()) {
    return __jacJsx("div", {"className": "flex flex-col items-center justify-center min-h-screen p-6"}, [__jacJsx("h2", {"className": "section-heading"}, ["You're already logged in!"]), __jacJsx("button", {"className": "nav-button nav-button-logout mt-4", "onClick": () => {
      jacLogout();
    }}, ["Logout"])]);
  }
  async function handleLogin(e) {
    e.preventDefault();
    setError("");
    setSuccess("");
    if (!email || !password) {
      setError("Email and password are required.");
      return;
    }
    let successLogin = await jacLogin(email, password);
    if (successLogin) {
      setSuccess("Login successful! Redirecting...");
      window.location.href = "/page/app#/";
    } else {
      setError("Invalid email or password.");
    }
  }
  return __jacJsx("div", {"className": "flex justify-center items-center min-h-screen bg-gray-50 p-6"}, [__jacJsx("form", {"onSubmit": handleLogin, "className": "card flex flex-col gap-4 w-full max-w-md fade-in"}, [__jacJsx("h1", {"className": "section-heading text-gradient text-center"}, ["Login to Your Account"]), error ? __jacJsx("div", {"style": {"color": "red"}}, [error]) : null, success ? __jacJsx("div", {"style": {"color": "green"}}, [success]) : null, __jacJsx("input", {"type": "email", "placeholder": "Email", "value": email, "onChange": e => {
    setEmail(e.target.value);
  }, "className": "input"}, []), __jacJsx("input", {"type": "password", "placeholder": "Password", "value": password, "onChange": e => {
    setPassword(e.target.value);
  }, "className": "input"}, []), __jacJsx("button", {"type": "submit", "className": "primary-btn mt-2"}, ["Login"]), __jacJsx("p", {"className": "text-center text-gray-600 text-sm mt-2"}, ["Don't have an account?", " ", __jacJsx(Link, {"to": "/signup", "className": "text-blue-600 hover:text-blue-700 font-semibold"}, ["Sign Up"])])])]);
}
export { LoginPage };
