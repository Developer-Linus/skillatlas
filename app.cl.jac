import from "@jac-client/utils" { Router, Routes, Route }
import ".styles.css";
import from .frontend.pages.homepage { HomePage }
import from .frontend.pages.auth.signup { SignupPage }
import from .frontend.pages.auth.login { LoginPage }
import from .frontend.pages.onboarding { Onboarding }

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
