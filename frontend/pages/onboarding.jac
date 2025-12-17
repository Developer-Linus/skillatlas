cl import from .....utils { fileToBase64 }
cl import from react { useState }
cl import from "@jac-client/utils" { Navigate, jacIsLoggedIn }
import from backend.models.models { UserData }
cl {
    def Onboarding()  -> any {
        [step, setStep] = useState(1);
        [email, setEmail] = useState("");
        [targetRole, setTargetRole] = useState("");
        [cvFile, setCvFile] = useState(None);
        [error, setError] = useState("");
        [success, setSuccess] = useState("");
        [loading, setLoading] = useState(False);

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
                if result.reports and result.reports[0]["success"] {
                    user_node = result.reports[0]["user_node"];
                    setSuccess("Email and target role updated successfully!");
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
            setLoading(True);

            if not cvFile {
                setError("Please select a CV file to upload.");
                setLoading(False);
                return;
            }

            try {
                base64Data = await fileToBase64(cvFile);

                # Save file
                saveResult = root spawn store_cv_file(
                    file_name=cvFile.name, file_data_b64=base64Data
                );
                if not saveResult.reports
                or saveResult.reports[0]["status"] != "success" {
                    setError(
                        "Failed to upload CV: " + (
                            saveResult.reports[0]["error"] or "unknown error"
                        )
                    );
                    setLoading(False);
                    return;
                }

                uploadedPath = saveResult.reports[0]["path"];

                parseResult = root spawn resume_parser(uploaded_path=uploadedPath);
                if not parseResult.reports
                or parseResult.reports[0]["status"] != "success" {
                    setError("Failed to parse CV.");
                    setLoading(False);
                    return;
                }

                cleanedText = parseResult.reports[0]["cleaned_resume_text"];
                extracted_skills = await root spawn extract_and_attach_skills(
                    resume_parser_output=cleanedText
                );
                setSuccess("CV uploaded and processed successfully!");
            } except Exception as e {
                setError("Failed to upload or process your CV. Try again.");
            } finally {
                setLoading(False);
            }
        }

        # File input
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
            } elif loading {
                return "Processing...";
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
                and <>
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
                </>}
                {step == 2
                and <>
                    <input
                        type="file"
                        accept=".pdf,.docx,.txt"
                        onChange={handleFileChange}
                        className="input"
                    />
                </>}
                <div className="flex justify-between items-center mt-2">
                    {step == 2
                    and <button
                        type="button"
                        className="secondary-btn"
                        onClick={handleBack}
                    >
                        Back
                    </button>}
                    <button
                        type="submit"
                        className="primary-btn"
                        disabled={loading}
                    >
                        {getSubmitButtonText()}
                    </button>
                </div>
            </form>
        </div>;
    }
}
