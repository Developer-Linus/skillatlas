cl {
    def MetricCard(props: dict) -> any {
        return <div className="card text-center">
            <p className="text-sm text-gray-500">
                {props.label}
            </p>
            <p className="text-xl font-semibold text-blue-600">
                {props.value}
            </p>
        </div>;
    }
}
