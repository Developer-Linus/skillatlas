import ".styles.css";
import from .frontend.pages.HomePage { HomePage }
import from .frontend.pages.auth.SignUp { SignupPage }
import from .frontend.pages.auth.Login { LoginPage }
import from .frontend.pages { Onboarding }
import from "@jac-client/utils" { Router, Routes, Route }
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
