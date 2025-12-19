cl import from "@jac-client/utils" { Link }

cl {
    def DashboardSidebar(user_email: str, skills_count: int, target_role: str) -> any {
        return <aside className="w-64 bg-white border-r border-gray-200 p-4 flex flex-col gap-6 fade-in">
            <div className="mb-4">
                <h3 className="section-subheading">
                    User
                </h3>
                <p className="font-semibold text-gray-800">
                    {user_email}
                </p>
                <p className="text-sm text-gray-600 mt-1">
                    Target Role:
                    <span className="font-medium">
                        {target_role}
                    </span>
                </p>
            </div>
            <div>
                <h3 className="section-subheading">
                    Navigation
                </h3>
                <nav className="flex flex-col gap-2">
                    <Link
                        to="/dashboard/overview"
                        className="nav-link"
                    >
                        Overview
                    </Link>
                    <Link
                        to="/dashboard/skills"
                        className="nav-link"
                    >
                        Skills
                    </Link>
                    <Link
                        to="/dashboard/gaps"
                        className="nav-link"
                    >
                        Gaps
                    </Link>
                    <Link
                        to="/dashboard/roadmap"
                        className="nav-link"
                    >
                        Roadmap
                    </Link>
                </nav>
            </div>
            <div className="card mt-4">
                <h4 className="font-semibold mb-2">
                    Profile Summary
                </h4>
                <p className="text-sm text-gray-600">
                    Skills extracted: {skills_count}
                </p>
                <p className="text-sm text-gray-600">
                    Target role: {target_role}
                </p>
            </div>
            <button className="secondary-btn mt-auto">
                Re-run Analysis
            </button>
        </aside>;
    }
}
