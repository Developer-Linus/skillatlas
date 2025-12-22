cl {
    def RightPanel(props: any) -> any {
        resume_summary = props["resume_summary"];
        target_role = props["target_role"];
        role_description = props["role_description"] or "No description available.";

        return <aside className="w-full lg:w-80 flex flex-col gap-6 bg-gray-100 p-4 rounded-lg shadow-md">

            # Resume Summary Card
            <div className="card fade-in p-4 bg-white shadow-sm rounded-md border border-gray-200">
                <h3 className="text-lg font-semibold text-gray-800 mb-2">
                    Resume Summary
                </h3>
                <p className="text-sm text-gray-700">
                    {resume_summary}
                </p>
            </div>
            <div className="card fade-in p-4 bg-white shadow-sm rounded-md border border-gray-200">
                <h3 className="text-lg font-semibold text-primary-500 mb-2">
                    About {target_role}
                </h3>
                <p className="text-sm text-gray-700 leading-relaxed">
                    {role_description}
                </p>
            </div>

        </aside>;
    }
}
