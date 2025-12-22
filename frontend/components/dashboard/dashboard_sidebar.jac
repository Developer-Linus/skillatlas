cl {
    def DashboardSidebar(props: any) -> any {
        user_email = props["user_email"];
        target_role = props["target_role"];
        skills = props["skills"] or [];
        missing_skills = props["missing_skills"] or [];
        skills_count = skills.length;
        missing_count = missing_skills.length;

        return <aside className="w-full lg:w-64 card fade-in space-y-4">
            <div className="space-y-1">
                <p className="text-xs uppercase tracking-wide text-gray-400">
                    Account
                </p>
                <div className="flex items-center gap-2 text-sm text-gray-800">
                    <span className="break-all font-medium">
                        {user_email}
                    </span>
                </div>
            </div>
            <div className="border-t border-gray-200 pt-3 space-y-2">
                <div className="flex items-center justify-between">
                    <span className="text-sm text-gray-500">
                        Target Role
                    </span>
                    <div className="flex items-center gap-1 text-sm font-semibold text-primary-500">
                        {target_role}
                    </div>
                </div>
                <div className="flex justify-between items-center">
                    <span className="text-sm text-gray-500">
                        Total Skills
                    </span>
                    <span className="text-sm font-semibold text-gray-800">
                        {skills_count}
                    </span>
                </div>
            </div>
            <div className="border-t border-gray-200 pt-3">
                <h4 className="text-sm font-semibold text-gray-700 mb-2">
                    Your Skills
                </h4>
                <div className="max-h-60 overflow-y-auto space-y-1">
                    {skills.map(
                        lambda  skill: any  -> any{ return <div className="flex items-center gap-2 text-xs bg-gray-100 px-2 py-1 rounded-md">
                            <span className="text-success-500 font-bold">
                                ✓
                            </span>
                            <span className="text-gray-800">
                                {skill["name"]}
                            </span>
                        </div>; }
                    )}
                </div>
                {missing_skills.length > 0
                and <div className="mt-3">
                    <h4 className="text-sm font-semibold text-gray-700 mb-2">
                        Missing Skills
                    </h4>
                    <div className="max-h-60 overflow-y-auto space-y-1">
                        {missing_skills.map(
                            lambda  skill: any  -> any{ return <div className="flex items-center gap-2 text-xs bg-red-100 px-2 py-1 rounded-md">
                                <span className="text-error-500 font-bold">
                                    X
                                </span>
                                <span className="text-gray-800">
                                    {skill}
                                </span>
                            </div>; }
                        )}
                    </div>
                </div>}
            </div>
        </aside>;
    }
}
