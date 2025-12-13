cl import from ....utils { fileToBase64 }
cl import from react { useState }
cl import from "@jac-client/utils" { Navigate, jacIsLoggedIn }
import from walkers.save_user_profile { SaveUserProfile }
import from walkers.store_cv_file { StoreCVFile }
import from walkers.resume_parser { ResumeParser }

cl {
    def Onboarding()  -> any {
        let [step, setStep] = useState(1);
        let [email, setEmail] = useState("");
        let [targetRole, setTargetRole] = useState("");
        let [cvFile, setCvFile] = useState(None);
        let [error, setError] = useState("");
        let [success, setSuccess] = useState("");

        if not jacIsLoggedIn() {
            return <Navigate to="/login" />;
        }

        # Step 1: Save user profile
        async def handleStep1Submit(e: any) -> None {
            e.preventDefault();
            setError("");
            setSuccess("");

            if not email or not targetRole {
                setError("Both email and target role are required.");
                return;
            }

            try {
                result = SaveUserProfile(email=email, target_role=target_role) spawn root;
                if result.reports and result.reports[0]["success"] {
                    setSuccess("Profile updated successfully!");
                    setStep(2);
                } else {
                    setError("Failed to update profile.");
                }
            } except Exception {
                setError("Failed to update profile. Try again.");
            }
        }

        # Step 2: Upload CV
        async def handleStep2Submit(e: any) -> None {
            e.preventDefault();
            setError("");
            setSuccess("");

            if not cvFile {
                setError("Please select a CV file to upload.");
                return;
            }

            try {
                base64Data = await fileToBase64(cvFile);
                saveResult = root spawn StoreCVFile(
                    file_name=cvFile.name, file_data_b64=base64Data
                );
                if saveResult.status != "success" {
                    setError("Failed to upload CV: " + saveResult.error);
                    return;
                }
                parseResult = root spawn ResumeParser(uploaded_path=saveResult.path);
                setSuccess("CV uploaded and processed successfully!");
                console.log("Resume summary:", parseResult.resume_summary);
            } except Exception as e {
                setError("Failed to upload or process your CV. Try again.");
            }
        }
        # File input
        def handleFileChange(e: any) -> None {
            if e.target.files.length > 0 {
                setCvFile(e.target.files[0]);
            }
        }

        # Back button
        def handleBack()  -> None {
            setStep(1);
            setCvFile(None);
            setError("");
            setSuccess("");
        }

        def getSubmitButtonText()  -> str {
            if step == 1 {
                return "Next";
            } else {
                return "Upload CV";
            }
        }
        def getHeadingText()  -> str {
            if step == 1 {
                return "Step 1: Profile Info";
            } else {
                return "Step 2: Upload Your CV";
            }
        }
        def getSubmitHandler()  -> any {
            if step == 1 {
                return handleStep1Submit;
            } else {
                return handleStep2Submit;
            }
        }
        return <div className="flex justify-center items-center min-h-screen bg-gray-50 p-6">
            <form
                className="card flex flex-col gap-4 w-full max-w-md fade-in"
                onSubmit={getSubmitHandler()}
            >
                <h1 className="section-heading text-gradient text-center">
                    {getHeadingText()}
                </h1>
                <p className="text-gray-600 text-sm text-center">
                    Step {step} of 2
                </p>
                {error
                and <div
                    style={{"color": "red"}}
                >
                    {error}
                </div>}
                {success
                and <div
                    style={{"color": "green"}}
                >
                    {success}
                </div>}
                {step == 1
                and {<>
                    <input
                        type="email"
                        placeholder="Email"
                        value={email}
                        onChange={lambda  e: any  -> None{ setEmail(e.target.value);} }
                        className="input"
                    />
                    <input
                        type="text"
                        placeholder="Target Role"
                        value={targetRole}
                        onChange={lambda  e: any  -> None{ setTargetRole(
                            e.target.value
                        );} }
                        className="input"
                    />
                </>}}
                {step == 2
                and {<>
                    <input
                        type="file"
                        accept=".pdf,.docx,.txt"
                        onChange={handleFileChange}
                        className="input"
                    />
                </>}}
                <div className="flex justify-between items-center mt-2">
                    {step == 2
                    and {<button
                        type="button"
                        className="secondary-btn"
                        onClick={handleBack}
                    >
                        Back
                    </button>}}
                    <button
                        type="submit"
                        className="primary-btn"
                    >
                        {getSubmitButtonText()}
                    </button>
                </div>
            </form>
        </div>;
    }
}
