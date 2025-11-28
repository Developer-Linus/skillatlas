impl User.add_or_update_skill{
    if level < 0 {
        return "Level cannot be negative.";
    }
    self.learning_progress[skill_name] = level;
    return f"Skill '{skill_name}' set to level {level}.";
}

impl User.add_target_role{
    if role == "" {
        return "Role cannot be empty.";
    }
    if not (role in self.target_roles) {
        self.target_roles.append(role);
    }
    return f"Target role '{role}' added.";
}

impl User.remove_target_role{
    if role in self.target_roles {
        self.target_roles.remove(role);
        return f"Target role '{role}' removed.";
    }
    return f"Role '{role}' not found.";
}

impl User.complete_course{
    if course(course_name in self.completed_courses) {
        self.completed_courses.append(course_name);
    }
    return f"Course '{course_name}' marked as completed.";
}
