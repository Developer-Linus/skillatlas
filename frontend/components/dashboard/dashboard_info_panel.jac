cl {
    def DashboardInfoPanel()  -> any {
        return <aside className="w-72 bg-white border-l border-gray-200 p-4 fade-in hidden lg:block">
            <h3 className="section-subheading">
                Your Fit
            </h3>
            <RadialMatchScore
                score={72}
            />
            <div className="grid grid-cols-2 gap-3 mt-4">
                <MetricCard
                    label="Matched"
                    value="9"
                />
                <MetricCard
                    label="Missing"
                    value="6"
                />
                <MetricCard
                    label="Level Avg"
                    value="Intermediate"
                />
                <MetricCard
                    label="Readiness"
                    value="Good"
                />
            </div>
        </aside>;
    }
}
