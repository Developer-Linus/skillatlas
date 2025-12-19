cl {
    def MetricCard(props: dict) -> any {
        label = props.get("label");
        value = props.get("value");
        value_color = props.get("color", "text-blue-600");

        return <div className="card text-center fade-in">
            <p className="text-sm text-gray-500">
                {label}
            </p>
            <p
                className={"text-xl font-semibold " + value_color}
            >
                {value}
            </p>
        </div>;
    }
}
