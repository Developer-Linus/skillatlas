import from dotenv { load_dotenv }
cl import from "@jac-client/utils" { Router, Routes, Route }
cl {
    def app()  -> any {
        return <Router>
            <div className="min-h-screen bg-gray-50 text-gray-900 font-sans">
                <Routes>
                    <Route
                        path="/"
                        element={<HomePage />}
                    />
                    <Route
                        path="/login"
                        element={<LoginPage />}
                    />
                    <Route
                        path="/signup"
                        element={<SignupPage />}
                    />
                    <Route
                        path="/onboarding"
                        element={<Onboarding />}
                    />
                </Routes>
            </div>
        </Router>;
    }
}

with entry {
    load_dotenv();
}
