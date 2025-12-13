impl has_skill.update_level{
    if new_level < 0 {
        return "Level cannot be negative.";
    }
    level = new_level;
}

impl requires_skill.update_required_level{
    if new_level < 0 {
        return "Level cannot be negative.";
    }
    level_required = new_level;
}
