cl import from react { useState }
cl import from ...components.layout.Header { Header }
cl import from .dashboard_header {DashboardHeader}
cl import from .dashboard_sidebar { DashboardSidebar }
cl import from .dashboard_info_panel { DashboardInfoPanel }

cl {
    def DashboardLayout(props: dict) -> any {
        [sidebarOpen, setSidebarOpen] = useState(True);
        [infoOpen, setInfoOpen] = useState(true);
        dashboardData = props.get("dashboardData", {});

        return <div className="min-h-screen bg-gray-50">
            <DashboardHeader user_email=dashboardData.get("user_email") />

            <div className="flex h-[calc(100vh-72px)]">
                {sidebarOpen and <DashboardSidebar
                    target_role=dashboardData.get("target_role")
                    skills=dashboardData.get("skills")
                    resume_summary=dashboardData.get("resume_summary")
                />}
                <main className="flex-1 overflow-y-auto p-6">
                    {props.children}
                </main>
                {infoOpen and <DashboardInfoPanel
                    match_score=dashboardData.get("match_score")
                    key_metrics=dashboardData.get("key_metrics")
                />}
            </div>
        </div>;
    }
}
