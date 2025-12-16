import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { fileToBase64 } from "../../../../utils.js";
import { useState } from "react";
import { Navigate, jacIsLoggedIn } from "@jac-client/utils";
function Onboarding() {
  let [step, setStep] = useState(1);
  let [email, setEmail] = useState("");
  let [targetRole, setTargetRole] = useState("");
  let [cvFile, setCvFile] = useState(null);
  let [error, setError] = useState("");
  let [success, setSuccess] = useState("");
  let [loading, setLoading] = useState(false);
  if (!jacIsLoggedIn()) {
    return __jacJsx(Navigate, {"to": "/login"}, []);
  }
  async function handleStep1Submit(e) {
    e.preventDefault();
    setError("");
    setSuccess("");
    if (!email || !targetRole) {
      setError("Both email and target role are required.");
      return;
    }
    try {
      let result = await __jacSpawn("save_user_profile", "", {"email": email, "target_role": targetRole});
      if (result.reports && result.reports[0]["success"]) {
        setSuccess("Email and target role updated successfully!");
        setStep(2);
      } else {
        setError("Failed to update profile.");
      }
    } catch (e) {
      setError("Failed to update profile. Try again.");
    }
  }
  async function handleStep2Submit(e) {
    e.preventDefault();
    setError("");
    setSuccess("");
    setLoading(true);
    if (!cvFile) {
      setError("Please select a CV file to upload.");
      setLoading(false);
      return;
    }
    try {
      let base64Data = await fileToBase64(cvFile);
      let saveResult = await __jacSpawn("store_cv_file", "", {"file_name": cvFile.name, "file_data_b64": base64Data});
      if (!saveResult.reports || saveResult.reports[0]["status"] !== "success") {
        setError("Failed to upload CV: " + saveResult.reports[0]["error"] || "unknown error");
        setLoading(false);
        return;
      }
      let uploadedPath = saveResult.reports[0]["path"];
      let parseResult = await __jacSpawn("resume_parser", "", {"uploaded_path": uploadedPath});
      if (!parseResult.reports || parseResult.reports[0]["status"] !== "success") {
        setError("Failed to parse CV.");
        setLoading(false);
        return;
      }
      let cleanedText = parseResult.reports[0]["cleaned_resume_text"];
      let extracted_skills = await __jacSpawn("extract_and_attach_skills", "", {"resume_parser_output": cleanedText});
      console.log(extracted_skills.reports[0]["total_skills_after_update"]);
      setSuccess("CV uploaded and processed successfully!");
    } catch (e) {
      setError("Failed to upload or process your CV. Try again.");
    } finally {
      setLoading(false);
    }
  }
  function handleFileChange(e) {
    if (e.target.files.length > 0) {
      setCvFile(e.target.files[0]);
    }
  }
  function handleBack() {
    setStep(1);
    setCvFile(null);
    setError("");
    setSuccess("");
  }
  function getSubmitButtonText() {
    if (step === 1) {
      return "Next";
    } else if (loading) {
      return "Processing...";
    } else {
      return "Upload CV";
    }
  }
  function getHeadingText() {
    if (step === 1) {
      return "Step 1: Profile Info";
    } else {
      return "Step 2: Upload Your CV";
    }
  }
  function getSubmitHandler() {
    if (step === 1) {
      return handleStep1Submit;
    } else {
      return handleStep2Submit;
    }
  }
  return __jacJsx("div", {"className": "flex justify-center items-center min-h-screen bg-gray-50 p-6"}, [__jacJsx("form", {"className": "card flex flex-col gap-4 w-full max-w-md fade-in", "onSubmit": getSubmitHandler()}, [__jacJsx("h1", {"className": "section-heading text-gradient text-center"}, [getHeadingText()]), __jacJsx("p", {"className": "text-gray-600 text-sm text-center"}, ["Step ", step, " of 2"]), error && __jacJsx("div", {"style": {"color": "red"}}, [error]), success && __jacJsx("div", {"style": {"color": "green"}}, [success]), step === 1 && __jacJsx(null, {}, [__jacJsx("input", {"type": "email", "placeholder": "Email", "value": email, "onChange": e => {
    setEmail(e.target.value);
  }, "className": "input"}, []), __jacJsx("input", {"type": "text", "placeholder": "Target Role", "value": targetRole, "onChange": e => {
    setTargetRole(e.target.value);
  }, "className": "input"}, [])]), step === 2 && __jacJsx(null, {}, [__jacJsx("input", {"type": "file", "accept": ".pdf,.docx,.txt", "onChange": handleFileChange, "className": "input"}, [])]), __jacJsx("div", {"className": "flex justify-between items-center mt-2"}, [step === 2 && __jacJsx("button", {"type": "button", "className": "secondary-btn", "onClick": handleBack}, ["Back"]), __jacJsx("button", {"type": "submit", "className": "primary-btn", "disabled": loading}, [getSubmitButtonText()])])])]);
}
export { Onboarding };
