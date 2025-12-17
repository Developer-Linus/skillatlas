cl import from "@jac-client/utils" { Link }

cl {
    def DashboardSidebar()  -> any {
        return <aside className="w-64 bg-white border-r border-gray-200 p-4 flex flex-col gap-6 fade-in">
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
            <div className="card">
                <h4 className="font-semibold mb-2">
                    Resume Summary
                </h4>
                <p className="text-sm text-gray-600">
                    15 skills extracted
                </p>
                <p className="text-sm text-gray-600">
                    Target role set
                </p>
            </div>
            <button className="secondary-btn">
                Re-run Analysis
            </button>
        </aside>;
    }
}
