enum SkillDifficulty {
    BEGINNER = "beginner",
    INTERMEDIATE = "intermediate",
    ADVANCED = "advanced"
}

edge has_skill {
    has level: int;

    def update_level(new_level: int) -> None;
}

edge wants_skill {}

edge targets_role {}

edge requires_skill {
    has required_level: int;

    def update_required_level(new_level: int) -> None;
}

edge in_industry {}

edge teaches_skill {}

edge prepares_for {}

edge qualifies_for {}

edge covers_skill {
    has difficulty_level: SkillDifficulty;
}

edge demands_skill {
    has importance_score: float;
}

edge has_gap {}

edge affects {}
# User -> Course/Certification
edge enrolled_in {
    has progress: int = 0;
    has started_at: str = get_current_datetime();

    def update_progress(new_progress: int) -> None {
        self.progress = new_progress;
    }
}
