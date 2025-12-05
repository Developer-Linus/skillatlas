edge has_skill {
    has level: int;

    def update_level(new_level: int) -> None;
}

edge wants_skill {}

edge targets_role {}

edge requires_skill {
    has level_required: int;

    def update_required_level(new_level: int) -> None;
}

edge in_industry {}

edge teaches_skill {}

edge prepares_for {}

edge qualifies_for {}

edge covers_skill {}

edge represents_role {}

edge demands_skill {
    has importance_score: float;
}

edge belongs_to_cluster {}

edge has_gap {}

edge leads_to_skill {}

edge affects {}
# User -> Course/Certification
edge enrolled_in {
    has progress: int = 0;
    has started_at: str = get_current_datetime();

    def update_progress(new_progress: int) -> None {
        self.progress = new_progress;
    }
}

edge aspires_to {}

edge interested_in_skill {}
