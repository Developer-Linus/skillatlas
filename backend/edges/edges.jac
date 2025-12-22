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
