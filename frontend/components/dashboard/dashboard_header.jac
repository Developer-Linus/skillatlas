cl import from "@jac-client/utils" { jacLogout }
cl {
    def DashboardHeader(props: any) -> any {
        def handle_logout()  -> None {
            jacLogout();
        }

        return <header className="header fade-in mb-6 rounded-lg overflow-hidden">
            <div className="header-inner flex justify-between items-center bg-white shadow-sm rounded-lg px-6 py-5">
                <div>
                    <h1 className="text-3xl font-bold text-gradient">
                        SkillAtlas
                    </h1>
                    <p className="text-sm text-gray-500 mt-1">
                        Your personalized career intelligence dashboard
                    </p>
                </div>
                <div className="flex items-center gap-4">
                    <div className="hidden sm:block text-right">
                        <p className="text-xs text-gray-400">
                            Signed in
                        </p>
                        <p className="text-sm font-medium text-gray-700">
                            Career Explorer
                        </p>
                    </div>
                    <button
                        className="nav-button nav-button-logout flex items-center gap-2 px-4 py-2 rounded-md text-white bg-cyan-500 hover:bg-cyan-600 transition shadow-sm"
                        onClick={lambda   -> None{ handle_logout();} }
                    >
                        <span>
                            Logout
                        </span>
                        <span className="text-xs opacity-80">
                            →
                        </span>
                    </button>
                </div>
            </div>
        </header>;
    }
}
