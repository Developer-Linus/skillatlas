cl {
    def LearningRoadmap(props: any) -> any {
        learning_path = props["learning_path"];
        target_role = props["target_role"];

        has_learning_path = false;
        if learning_path
        and learning_path["phases"]
        and learning_path["phases"].length > 0 {
            has_learning_path = true;
        }
        def render_empty_state()  -> any {
            return <div className="text-center py-6">
                <p className="text-sm text-gray-500">
                    We are preparing a personalized learning roadmap for you based on your skill gaps.
                </p>
            </div>;
        }
        def render_phases()  -> any {
            phase_index = 0;

            return <div className="timeline">
                {learning_path["phases"].map(
                    lambda  phase: any  -> any{ is_active = phase_index == 0;current_phase_number = phase_index + 1;phase_index = phase_index + 1;dot_class = "timeline-dot ";if is_active {
                        dot_class = dot_class + "timeline-dot-active";
                    } else {
                        dot_class = dot_class + "timeline-dot-inactive";
                    } card_class = "phase-card ";if is_active {
                        card_class = card_class + "phase-card-active";
                    } else {
                        card_class = card_class + "phase-card-locked";
                    } action_node = None;if is_active {
                        action_node = <button className="primary-btn text-xs">
                            Start Phase →
                        </button>;
                    } else {
                        action_node = <span className="phase-badge phase-badge-locked">
                            Locked
                        </span>;
                    } return <div className="relative fade-in">
                        <div
                            className={dot_class}
                        ></div>
                        <div
                            className={card_class}
                        >
                            <div className="flex justify-between items-center mb-3">
                                <h4 className="font-semibold text-gray-800">
                                    Phase {current_phase_number}: {phase["phase_title"]}
                                </h4>
                                <span className="text-xs text-gray-500">
                                    {phase["estimated_time"]}
                                </span>
                            </div>
                            <div className="mb-3">
                                <p className="text-xs font-medium text-gray-600 mb-1">
                                    Skills you’ll gain
                                </p>
                                <div className="flex flex-wrap gap-2">
                                    {phase["skills_targeted"].map(
                                        lambda  skill: any  -> any{ return <span className="skill-pill">
                                            {skill}
                                        </span>; }
                                    )}
                                </div>
                            </div>
                            <div className="flex justify-between items-center mt-4">
                                <p className="text-xs text-gray-500">
                                    {phase["resources_count"]} curated resources
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
