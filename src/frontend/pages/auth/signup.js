import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { useState } from "react";
import { Link, Navigate, jacSignup, jacIsLoggedIn, jacLogout } from "@jac-client/utils";
function SignupPage() {
  let [email, setEmail] = useState("");
  let [password, setPassword] = useState("");
  let [confirmPassword, setConfirmPassword] = useState("");
  let [error, setError] = useState("");
  let [success, setSuccess] = useState("");
  if (jacIsLoggedIn()) {
    return __jacJsx("div", {"className": "flex flex-col items-center justify-center min-h-screen p-6"}, [__jacJsx("h2", {"className": "section-heading"}, ["You're already logged in!"]), __jacJsx("button", {"className": "nav-button nav-button-logout mt-4", "onClick": () => {
      jacLogout();
      window.location.href = "/page/app#/signup";
    }}, ["Logout"])]);
  }
  async function handleSignup(e) {
    e.preventDefault();
    setError("");
    setSuccess("");
    if (!email || !password || !confirmPassword) {
      setError("All fields are required.");
      return;
    }
    if (password !== confirmPassword) {
      setError("Passwords do not match.");
      return;
    }
    let result = await jacSignup(email, password);
    if (result["success"]) {
      window.location.href = "/page/app#/onboarding";
    } else {
      setError(result["error"] ? result["error"] : "Signup failed. Try again.");
    }
  }
  return __jacJsx("div", {"className": "flex justify-center items-center min-h-screen bg-gray-50 p-6"}, [__jacJsx("form", {"onSubmit": handleSignup, "className": "card flex flex-col gap-4 w-full max-w-md fade-in"}, [__jacJsx("h1", {"className": "section-heading text-gradient text-center"}, ["Create Your Account"]), error ? __jacJsx("div", {"style": {"color": "red"}}, [error]) : null, success ? __jacJsx("div", {"style": {"color": "green"}}, [success]) : null, __jacJsx("input", {"type": "email", "placeholder": "Email", "value": email, "onChange": e => {
    setEmail(e.target.value);
  }, "className": "input"}, []), __jacJsx("input", {"type": "password", "placeholder": "Password", "value": password, "onChange": e => {
    setPassword(e.target.value);
  }, "className": "input"}, []), __jacJsx("input", {"type": "password", "placeholder": "Confirm Password", "value": confirmPassword, "onChange": e => {
    setConfirmPassword(e.target.value);
  }, "className": "input"}, []), __jacJsx("button", {"type": "submit", "className": "primary-btn mt-2"}, ["Sign Up"]), __jacJsx("p", {"className": "text-center text-gray-600 text-sm mt-2"}, ["Already have an account?", __jacJsx(Link, {"to": "/login", "className": "text-blue-600 hover:text-blue-700 font-semibold"}, ["Login"])])])]);
}
export { SignupPage };
