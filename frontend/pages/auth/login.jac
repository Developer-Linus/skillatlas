cl import from react { useState }
cl import from "@jac-client/utils" { Link, jacLogin, jacIsLoggedIn, jacLogout }

cl {
    def LoginPage()  -> any {
        let [email, setEmail] = useState("");
        let [password, setPassword] = useState("");
        let [error, setError] = useState("");
        let [success, setSuccess] = useState("");

        if jacIsLoggedIn() {
            return <div className="flex flex-col items-center justify-center min-h-screen p-6">
                <h2 className="section-heading">
                    You're already logged in!
                </h2>
                <Navigate to="/login" />
            </div>;
        }

        async def handleLogin(e: any) -> None {
            e.preventDefault();
            setError("");
            setSuccess("");

            if not email or not password {
                setError("Email and password are required.");
                return;
            }

            successLogin = await jacLogin(email, password);

            if successLogin {
                setSuccess("Login successful! Redirecting...");
                window.location.href = "/page/app#/dashboard";
            } else {
                setError("Invalid email or password.");
            }
        }

        return <div className="flex justify-center items-center min-h-screen bg-gray-50 p-6">
            <form
                onSubmit={handleLogin}
                className="card flex flex-col gap-4 w-full max-w-md fade-in"
            >
                <h1 className="section-heading text-gradient text-center">
                    Login to Your Account
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
                <button
                    type="submit"
                    className="primary-btn mt-2"
                >
                    Login
                </button>
                <p className="text-center text-gray-600 text-sm mt-2">
                    Don't have an account?
                    <Link
                        to="/signup"
                        className="text-blue-600 hover:text-blue-700 font-semibold"
                    >
                        Sign Up
                    </Link>
                </p>
            </form>
        </div>;
    }
}
