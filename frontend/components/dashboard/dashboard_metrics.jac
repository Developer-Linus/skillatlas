cl {
    def DashboardMetrics(props: any) -> any {
        matched = props["matched_skills_count"];
        missing = props["missing_skills_count"];
        fit = props["role_fit_percent"];
        radius = 42;
        circumference = 2 * 3.1416 * radius;
        offset = circumference - (fit / 100) * circumference;
        return <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
            <div className="card flex flex-col justify-center items-center gap-2 fade-in hover:scale-105 transition-transform duration-300">
                <div className="text-4xl text-success-500">
                    ✓
                </div>
                <p className="text-gray-600 font-medium text-center">
                    Matched Skills
                </p>
                <p className="text-3xl font-bold text-success-500">
                    {matched}
                </p>
            </div>
            <div className="card flex flex-col justify-center items-center gap-3 fade-in hover:scale-105 transition-transform duration-300">
                <div className="text-4xl text-primary-500">
                    🎯
                </div>
                <p className="text-gray-600 font-medium text-center mb-2">
                    Role Fit
                </p>
                <div className="relative flex justify-center items-center">
                    <svg
                        width="120"
                        height="120"
                    >
                        <circle
                            cx="60"
                            cy="60"
                            r={radius}
                            stroke="#E5E7EB"
                            strokeWidth="8"
                            fill="none"
                        />
                        <circle
                            cx="60"
                            cy="60"
                            r={radius}
                            stroke="#3B82F6"
                            strokeWidth="8"
                            fill="none"
                            strokeDasharray={circumference}
                            strokeDashoffset={offset}
                            strokeLinecap="round"
                            transform="rotate(-90 60 60)"
                        />
                    </svg>
                    <div className="absolute text-xl font-bold text-primary-500">
                        {fit}%
                    </div>
                </div>
            </div>
            <div className="card flex flex-col justify-center items-center gap-2 fade-in hover:scale-105 transition-transform duration-300">
                <div className="text-4xl text-error-500">
                    ⚠
                </div>
                <p className="text-gray-600 font-medium text-center">
                    Missing Skills
                </p>
                <p className="text-3xl font-bold text-error-500">
                    {missing}
                </p>
            </div>
        </div>;
    }
}
