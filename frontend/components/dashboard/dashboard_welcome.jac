cl {
    def DashboardWelcome(props: any) -> any {
        user_email = props["user_email"];

        return <div className="fade-in mb-4">
            <h2 className="section-heading">
                Welcome,
                <span className="text-gradient font-semibold">
                    {user_email}
                </span>
            </h2>
            <p className="text-sm text-gray-500 mt-1">
                Here’s a snapshot of your progress and next steps
            </p>
        </div>;
    }
}
