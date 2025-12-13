cl import from "@jac-client/utils" { Link, jacIsLoggedIn, jacLogout, Navigate }

cl {
    def NavMenu()  -> any {
        logged_in = jacIsLoggedIn();

        def MenuLinks()  -> any {
            if logged_in {
                return <div className="flex flex-col sm:flex-row sm:items-center sm:gap-6 mt-2 sm:mt-0">
                    <Link
                        to="/dashboard"
                        className="nav-link text-base font-medium text-blue-600 hover:text-blue-700 transition py-2"
                    >
                        Dashboard
                    </Link>
                    <Link
                        to="/todos"
                        className="nav-link text-base font-medium text-blue-600 hover:text-blue-700 transition py-2"
                    >
                        Todos
                    </Link>
                    <Link
                        to="/learning"
                        className="nav-link text-base font-medium text-blue-600 hover:text-blue-700 transition py-2"
                    >
                        Learning
                    </Link>
                    <button
                        className="auth-button px-4 py-2 rounded bg-cyan-500 text-white hover:bg-cyan-600 transition"
                        onClick={lambda   -> None{ jacLogout();} }
                    >
                        Logout
                    </button>
                </div>;
            } else {
                return <div className="flex flex-col sm:flex-row sm:items-center sm:gap-6 mt-2 sm:mt-0">
                    <Link
                        to="/login"
                        className="auth-button px-4 py-2 rounded bg-blue-600 text-white hover:bg-blue-700 transition"
                    >
                        Login
                    </Link>
                    <Link
                        to="/signup"
                        className="auth-button px-4 py-2 rounded bg-green-500 text-white hover:bg-green-600 transition"
                    >
                        Sign Up
                    </Link>
                </div>;
            }
        }

        return <nav className="nav-menu relative flex flex-col sm:flex-row sm:items-center gap-2">
            <MenuLinks />
        </nav>;
    }
}
