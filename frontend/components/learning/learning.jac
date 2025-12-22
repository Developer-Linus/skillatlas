cl {
    def LearningPage(props: any) -> any {
        learning_path = props["learning_path"];
        target_role = props["target_role"];

        has_learning_path = false;
        if learning_path
        and learning_path["phases"]
        and learning_path["phases"].length > 0 {
            has_learning_path = true;
        }
        def render_empty_state()  -> any {
            return <p className="text-sm text-gray-500">
                We are preparing a personalized learning roadmap for you based on your skill gaps.
            </p>;
        }
        def render_phases()  -> any {
            phase_index = 0;

            return <div className="relative border-l-2 border-primary-200 pl-6 space-y-6">
                {learning_path["phases"].map(
                    lambda  phase: any  -> any{ is_active = phase_index == 0;current_phase_number = phase_index + 1;phase_index = phase_index + 1;dot_class = "absolute -left-[10px] top-2 w-4 h-4 rounded-full ";if is_active {
                        dot_class = dot_class + "bg-primary-500";
                    } else {
                        dot_class = dot_class + "bg-gray-300";
                    } card_class = "p-4 rounded-lg border transition ";if is_active {
                        card_class = card_class + "border-primary-300 bg-primary-50";
                    } else {
                        card_class = card_class + "border-gray-200 bg-white opacity-70";
                    } action_node = None;if is_active {
                        action_node = <button className="text-xs px-3 py-1 rounded bg-primary-500 text-white hover:bg-primary-600 transition">
                            Start Phase
                        </button>;
                    } else {
                        action_node = <span className="text-xs text-gray-400">
                            Locked
                        </span>;
                    } return <div className="relative fade-in">
                        <div
                            className={dot_class}
                        ></div>
                        <div
                            className={card_class}
                        >
                            <div className="flex justify-between items-center mb-2">
                                <h4 className="font-semibold text-gray-800">
                                    Phase {current_phase_number}: {phase["phase_title"]}
                                </h4>
                                <span className="text-xs text-gray-500">
                                    {phase["estimated_time"]}
                                </span>
                            </div>
                            <div className="mb-2">
                                <p className="text-xs text-gray-600 mb-1">
                                    Skills Covered
                                </p>
                                <div className="flex flex-wrap gap-1">
                                    {phase["skills_targeted"].map(
                                        lambda  skill: any  -> any{ return <span className="text-xs bg-gray-200 px-2 py-1 rounded">
                                            {skill}
                                        </span>; }
                                    )}
                                </div>
                            </div>
                            <div className="flex justify-between items-center mt-3">
                                <p className="text-xs text-gray-500">
                                    {phase["resources_count"]} learning resources
                                </p>
                                {action_node}
                            </div>
                        </div>
                    </div>; }
                )}
            </div>;
        }
        def render_roadmap_body()  -> any {
            if not has_learning_path {
                return render_empty_state();
            }
            return render_phases();
        }
        return <div className="card fade-in">
            <h3 className="font-semibold mb-4 text-gray-800">
                Learning Roadmap to Become {target_role}
            </h3>
            {render_roadmap_body()}
        </div>;
    }
}
