cl {
    def app()  -> any {
        return <Router>
            <div assName="min-h-screen bg-gray-50 text-gray-900 font-sans">
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