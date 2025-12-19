cl import from .metric_card { MetricCard }
cl {
    def DashboardInfoPanel(
        match_score: float,
        matched_skills: int,
        missing_skills: int,
        avg_level: str,
        readiness: str
    ) -> any {
        return <aside className="w-72 bg-white border-l border-gray-200 p-4 fade-in hidden lg:block">
            <h3 className="section-subheading">
                Your Fit
            </h3>
            <RadialMatchScore
                score={match_score}
            />
            <div className="grid grid-cols-2 gap-3 mt-4">
                <MetricCard
                    label="Matched"
                    value={matched_skills.toString()}
                />
                <MetricCard
                    label="Missing"
                    value={missing_skills.toString()}
                />
                <MetricCard
                    label="Level Avg"
                    value={avg_level}
                />
                <MetricCard
                    label="Readiness"
                    value={readiness}
                />
            </div>
        </aside>;
    }
}
