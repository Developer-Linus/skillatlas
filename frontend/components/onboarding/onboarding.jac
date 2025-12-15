cl import from .....utils { fileToBase64 }
cl import from react { useState }
cl import from "@jac-client/utils" { Navigate, jacIsLoggedIn }
import from backend.walkers.save_user_profile { save_user_profile }
import from backend.walkers.store_cv_file { store_cv_file }
import from backend.walkers.resume_parser { resume_parser }
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
                result = root spawn save_user_profile(
                    email=email, target_role=targetRole
                );
                if result.reports and result.reports[0][0]["success"] {
                    setSuccess("Profile updated successfully!");
                    setStep(2);
                } else {
                    setError("Failed to update profile.");
                }
            } except Exception as e {
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
                saveResult = root spawn store_cv_file(
                    file_name=cvFile.name, file_data_b64=base64Data
                );
                if not saveResult.reports
                or saveResult.reports[0][0]["status"] != "success" {
                    setError("Failed to upload CV: " + saveResult.error);
                    return;
                }
                uploadedPath = saveResult.reports[0][0]["path"];
                parseResult = root spawn resume_parser(uploaded_path=uploadedPath);
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
                {(
                    <>
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
                    </>
                )
                if step == 1
                else None}
                {(
                    <>
                        <input
                            type="file"
                            accept=".pdf,.docx,.txt"
                            onChange={handleFileChange}
                            className="input"
                        />
                    </>
                )
                if step == 2
                else None}
                <div className="flex justify-between items-center mt-2">
                    {(
                        <button
                            type="button"
                            className="secondary-btn"
                            onClick={handleBack}
                        >
                            Back
                        </button>
                    )
                    if step == 2
                    else None}
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
