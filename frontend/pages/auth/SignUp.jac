cl import from react { useState }
cl import from "@jac-client/utils" {
    Link,
    Navigate,
    jacSignup,
    jacIsLoggedIn,
    jacLogout
}
cl import from ..onboarding.onboarding { Onboarding }

cl {
    def SignupPage()  -> any {
        let [email, setEmail] = useState("");
        let [password, setPassword] = useState("");
        let [confirmPassword, setConfirmPassword] = useState("");
        let [error, setError] = useState("");
        let [success, setSuccess] = useState("");

        # Redirect if already logged in
        if jacIsLoggedIn() {
            return <div className="flex flex-col items-center justify-center min-h-screen p-6">
                <h2 className="section-heading">
                    You're already logged in!
                </h2>
                <button
                    className="nav-button nav-button-logout mt-4"
                    onClick={lambda   -> None{ jacLogout();window.location.href = "/page/app#/signup";} }
                >
                    Logout
                </button>
            </div>;
        }

        async def handleSignup(e: any) -> None {
            e.preventDefault();

            setError("");
            setSuccess("");

            # Validation
            if not email or not password or not confirmPassword {
                setError("All fields are required.");
                return;
            }
            if password != confirmPassword {
                setError("Passwords do not match.");
                return;
            }

            # Signup
            result = await jacSignup(email, password);
            if result["success"] {
                window.location.href = "/page/app#/onboarding";
            } else {
                setError(
                    result["error"] if result["error"] else "Signup failed. Try again."
                );
            }
        }

        return <div className="flex justify-center items-center min-h-screen bg-gray-50 p-6">
            <form
                onSubmit={handleSignup}
                className="card flex flex-col gap-4 w-full max-w-md fade-in"
            >
                <h1 className="section-heading text-gradient text-center">
                    Create Your Account
                </h1>
                {(
                    <div
                        style={{"color": "red"}}
                    >
                        {error}
                    </div>
                )
                if error
                else None}
                {(
                    <div
                        style={{"color": "green"}}
                    >
                        {success}
                    </div>
                )
                if success
                else None}
                <input
                    type="email"
                    placeholder="Email"
                    value={email}
                    onChange={lambda  e: any  -> None{ setEmail(e.target.value);} }
                    className="input"
                />
                <input
                    type="password"
                    placeholder="Password"
                    value={password}
                    onChange={lambda  e: any  -> None{ setPassword(e.target.value);} }
                    className="input"
                />
                <input
                    type="password"
                    placeholder="Confirm Password"
                    value={confirmPassword}
                    onChange={lambda  e: any  -> None{ setConfirmPassword(
                        e.target.value
                    );} }
                    className="input"
                />
                <button
                    type="submit"
                    className="primary-btn mt-2"
                >
                    Sign Up
                </button>
                <p className="text-center text-gray-600 text-sm mt-2">
                    Already have an account?
                    <Link
                        to="/login"
                        className="text-blue-600 hover:text-blue-700 font-semibold"
                    >
                        Login
                    </Link>
                </p>
            </form>
        </div>;
    }
}
