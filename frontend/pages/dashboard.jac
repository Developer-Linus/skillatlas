cl import from react { useState, useEffect }
cl import from "@jac-client/utils" { jacLogout, jacIsLoggedIn, Navigate}

cl {
    def DashboardPage() -> any {
          if not jacIsLoggedIn() {
            return <Navigate to="/login" />;
        }
        [dashboardData, setDashboardData] = useState(None);
        [loading, setLoading] = useState(true);

        # ------------------------------
        # Fetch Dashboard Data Safely
        # ------------------------------
        useEffect(lambda -> None {
            cancelled = false;

            async def fetchData() -> None {
                result = await root spawn get_dashboard_data();
                console.log(result);
                if cancelled {
                    return;
                }

                if result.reports and result.reports.length > 0 {
                    dashboard = result.reports[0];

                    if dashboard and dashboard["success"] and not cancelled {
                        setDashboardData(dashboard);
                    }
                }

                if not cancelled {
                    setLoading(false);
                }
            }

            fetchData();

            return lambda -> None {
                cancelled = true;
            };
        }, []);

        # ------------------------------
        # Loading / Error States
        # ------------------------------
        if loading {
            return <div className="flex justify-center items-center h-screen">
                <p className="text-gray-600 text-lg animate-pulse">Loading Dashboard...</p>
            </div>;
        }

        if not dashboardData or not dashboardData["success"] {
            return <div className="flex justify-center items-center h-screen">
                <p className="text-error-500 text-lg font-semibold">
                    Failed to load dashboard.
                </p>
            </div>;
        }

        # ------------------------------
        # Extract Data Safely
        # ------------------------------
        user_email = dashboardData["user_email"];
        target_role = dashboardData["target_role"];
        skills = dashboardData["skills"] or [];
        skills_count = skills.length;

        matched_skills_list = dashboardData["matched_skills"] or [];
        missing_skills_list = dashboardData["missing_skills"] or [];
        matched_skills_count = dashboardData["matched_skills_count"];
        missing_skills_count = dashboardData["missing_skills_count"];

        match_score = dashboardData["match_score"];
        role_fit_percent = Math.round(match_score * 100);

        resume_summary = dashboardData["resume_summary"];
        job_postings = dashboardData["job_postings"] or [];
        learning_path = dashboardData["learning_path"];
        has_learning_path = false;
        if learning_path and learning_path["phases"] and learning_path["phases"].length > 0 {
            has_learning_path = true;
            }
        phase_index = 0;

        # ------------------------------
        # Render Dashboard
        # ------------------------------
        return <div className="min-h-screen bg-gray-50 font-sans p-6">

           # --- Header ---
<header className="header fade-in mb-6">
    <div className="header-inner flex justify-between items-center">
        <div>
            <h1 className="logo-title">SkillAtlas Dashboard</h1>
            <p className="logo-subtitle">Your career insights at a glance</p>
        </div>

        # Logout Button
        <button
            className="nav-button nav-button-logout px-4 py-2 rounded text-white bg-cyan-500 hover:bg-cyan-600 transition"
            onClick={lambda -> None { jacLogout(); }}
        >
            Logout
        </button>
    </div>
</header>


            <div className="flex flex-col lg:flex-row gap-6 max-w-7xl mx-auto">

                # --- Sidebar ---
                <aside className="w-full lg:w-64 card fade-in space-y-3">
                    <p><b>Email:</b> {user_email}</p>
                    <p><b>Target Role:</b> {target_role}</p>
                    <p><b>Total Skills:</b> {skills_count}</p>

                    # Optional Skills List (scrollable)
                    <div className="mt-4 max-h-60 overflow-y-auto border-t border-gray-200 pt-2">
                        <h4 className="text-sm font-semibold text-gray-600 mb-2">Skills</h4>
                        {skills.map(lambda skill: any -> any {
                            return <span className="inline-block bg-primary-500 text-white text-xs px-2 py-1 rounded mr-1 mb-1">
                                {skill["name"]}
                            </span>;
                        })}
                    </div>
                </aside>

                # --- Main Content ---
                <main className="flex-1 space-y-6">

                    # Welcome
                    <h2 className="section-heading text-gradient fade-in">
                        Welcome, {user_email}
                    </h2>

                    # Metrics
                    <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
                        <div className="card text-center fade-in hover:scale-105 transition-transform duration-300">
                            <p className="text-gray-600 font-medium">Matched Skills</p>
                            <p className="text-2xl font-bold text-success-500">{matched_skills_count}</p>
                        </div>
                        <div className="card text-center fade-in hover:scale-105 transition-transform duration-300">
                            <p className="text-gray-600 font-medium">Missing Skills</p>
                            <p className="text-2xl font-bold text-error-500">{missing_skills_count}</p>
                        </div>
                        <div className="card text-center fade-in hover:scale-105 transition-transform duration-300">
                            <p className="text-gray-600 font-medium">Role Fit %</p>
                            <p className="text-2xl font-bold text-primary-500">{role_fit_percent}</p>
                        </div>
                    </div>

                    # Resume
                    <div className="card fade-in">
                        <h3 className="font-semibold mb-2 text-gray-800">Resume Summary</h3>
                        <p className="text-sm text-gray-600">{resume_summary}</p>
                    </div>
                    # ------------------------------
# Learning Roadmap
# ------------------------------
<div className="card fade-in">
    <h3 className="font-semibold mb-4 text-gray-800">
        Learning Roadmap to Become {target_role}
    </h3>

    if not has_learning_path {
        <p className="text-sm text-gray-500">
            We are preparing a personalized learning roadmap for you based on your skill gaps.
        </p>
    } else {
        <div className="relative border-l-2 border-primary-200 pl-6 space-y-6">
            {learning_path["phases"].map(lambda phase: any -> any {
                # Determine active phase
                is_active = phase_index == 0;

                # Compute phase number
                current_phase_number = phase_index + 1;

                # Increment for next phase
                phase_index = phase_index + 1;

                # Build dot and card classes
                dot_class = "absolute -left-[10px] top-2 w-4 h-4 rounded-full ";
                if is_active {
                    dot_class = dot_class + "bg-primary-500";
                } else {
                    dot_class = dot_class + "bg-gray-300";
                }

                card_class = "p-4 rounded-lg border transition ";
                if is_active {
                    card_class = card_class + "border-primary-300 bg-primary-50";
                } else {
                    card_class = card_class + "border-gray-200 bg-white opacity-70";
                }

                return <div className="relative fade-in">
                    # Timeline Dot
                    <div className={dot_class}></div>

                    # Phase Card
                    <div className={card_class}>
                        <div className="flex justify-between items-center mb-2">
                            <h4 className="font-semibold text-gray-800">
                                Phase {current_phase_number}: {phase["phase_title"]}
                            </h4>
                            <span className="text-xs text-gray-500">
                                {phase["estimated_time"]}
                            </span>
                        </div>

                        # Skills Covered
                        <div className="mb-2">
                            <p className="text-xs text-gray-600 mb-1">Skills Covered</p>
                            <div className="flex flex-wrap gap-1">
                                {phase["skills_targeted"].map(lambda skill: any -> any {
                                    return <span className="text-xs bg-gray-200 px-2 py-1 rounded">
                                        {skill}
                                    </span>;
                                })}
                            </div>
                        </div>

                        # Footer
                        <div className="flex justify-between items-center mt-3">
                            <p className="text-xs text-gray-500">
                                {phase["resources_count"]} learning resources
                            </p>

                            if is_active {
                                <button className="text-xs px-3 py-1 rounded bg-primary-500 text-white hover:bg-primary-600 transition">
                                    Start Phase
                                </button>
                            } else {
                                <span className="text-xs text-gray-400">
                                    Locked
                                </span>
                            }
                        </div>
                    </div>
                </div>;
            })}
        </div>
    }
</div>

                    # Job Opportunities
                    <div className="card fade-in">
                        <h3 className="font-semibold mb-4 text-gray-800">Job Opportunities</h3>
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            {job_postings.map(lambda job: any -> any {
                                return <div className="card border border-gray-200 hover:shadow-lg transition-shadow p-4 fade-in">
                                    <p className="font-semibold text-primary-500">{job["title"]}</p>
                                    <p className="text-sm text-gray-600">{job["company"]}</p>
                                    <p className="text-xs text-gray-500">{job["location"]}</p>
                                </div>;
                            })}
                        </div>
                    </div>

                </main>
            </div>
        </div>;
    }
}
