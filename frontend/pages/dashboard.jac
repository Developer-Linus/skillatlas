cl import from react { useState, useEffect }
cl import from ...components.layout.Header { Header }
cl import from ..components.dashboard.dashboard_header {DashboardHeader}
cl import from ..components.dashboard.dashboard_sidebar { DashboardSidebar }
cl import from ..components.dashboard.dashboard_info_panel { DashboardInfoPanel }

cl {
    def DashboardPage() -> any {
        [dashboardData, setDashboardData] = useState(None);
        [loading, setLoading] = useState(true);

        # Load dashboard data from Jac walker
        useEffect(lambda -> None {
            async def fetchData() -> None {
                result = await root spawn get_dashboard_data();
                console.log(result);
                if result.reports and len(result.reports) > 0{
                    setDashboardData(result.reports[0]);
                }
                setLoading(false);
            }
            fetchData();
        }, []);

        if loading {
            return <div className="flex justify-center items-center h-screen">
                <p className="text-gray-600">Loading Dashboard...</p>
            </div>;
        }

        if not dashboardData or not dashboardData["success"] {
            return <div className="flex justify-center items-center h-screen">
                <p className="text-red-500">
                    {dashboardData["error"] if dashboardData else "Failed to load dashboard."}
                </p>
            </div>;
        }

        user_email = dashboardData["user_email"];
        target_role = dashboardData["target_role"];
        skills_count = len(dashboardData["skills"]);
        match_score = dashboardData["match_score"]["score_value"];
        matched_skills = len(dashboardData["match_score"]["matched_skills"]);
        missing_skills = len(dashboardData["match_score"]["missing_skills"]);
        avg_level = dashboardData.get("avg_level", "Intermediate");
        readiness = dashboardData.get("readiness", "Good");

        return <DashboardLayout>
            # Sidebar
            <DashboardSidebar
                user_email={user_email}
                skills_count={skills_count}
                target_role={target_role}
            />

            # Main Content
            <main className="flex-1 overflow-y-auto p-6">
                <h1 className="section-heading text-gradient">
                    Welcome, {user_email}
                </h1>
                <p className="text-gray-600 mb-6">
                    Here's a quick overview of your skills, role fit, and learning progress.
                </p>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <MetricCard label="Matched Skills" value={matched_skills.toString()} />
                    <MetricCard label="Missing Skills" value={missing_skills.toString()} />
                    <MetricCard label="Role Fit %" value={f"{match_score:.1f}"} />
                </div>

                <div className="mt-6 card">
                    <h2 className="font-semibold mb-2">Resume Summary</h2>
                    <p className="text-sm text-gray-600">
                        {dashboardData["resume_summary"]}
                    </p>
                </div>
            </main>
            <DashboardInfoPanel
                match_score={match_score}
                matched_skills={matched_skills}
                missing_skills={missing_skills}
                avg_level={avg_level}
                readiness={readiness}
            />
        </DashboardLayout>;
    }
}
