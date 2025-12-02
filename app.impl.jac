impl User.get_basic_info{
    return {
        "id": self.id,
        "email": self.email,
        "current_position": self.current_position,
        "experience_years": self.experience_years,
        "bio": self.bio
    };
}

impl User.get_target_roles{
    return self.target_roles;
}

impl User.get_completed_courses{
    return self.completed_courses;
}

impl User.get_preferred_industries{
    return self.preferred_industries;
}

impl User.get_learning_progress{
    return self.learning_progress;
}
impl User.get_skills{
            # retrieve edges of type has_skill that originate from this user
        skill_edges = [self-->(`?has_skill)];   # list of edge objects
        skills_list = [];

        for e in skill_edges {
            # e.to is the node at the other end (Skill)
            # guard: if skill node missing, skip
            if e.to {
                skills_list = skills_list + [
                    {
                        "name": e.to.name,
                        "level": e.level
                    }
                ];
            }
        }

        return skills_list;
}
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

impl UserManager.manage_user{ }
