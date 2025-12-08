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
    skill_nodes = [self-->(`?Skill)];
    skills_list = [];
    for s in skill_nodes {
        skills_list += [{"id": s.id, "name": s.name,}];
    }
    return skills_list;
}

impl User.get_profile_snapshot{
    return {
        "basic_info": self.get_basic_info(),
        "skills": self.get_skills(),
        "target_roles": self.get_target_roles(),
        "completed_courses": self.get_completed_courses(),
        "preferred_industries": self.get_preferred_industries(),
        "learning_progress": self.get_learning_progress()
    };
}

impl User.add_skill{
    if level < 0 {
        return "Level cannot be negative.";
    }
    skill_nodes = [root-->(`?Skill:name==skill_name)];
    if not skill_nodes {
        return f"Skill node {skill_name} does not exist. Create it first.";
    }
    skill_node = skill_nodes[0];
    self +>: has_skill(level=level) :+> skill_node;
    self.learning_progress[skill_name] = level;
    return f"Skill {skill_name} added with level {level}.";
}

impl User.update_skill{
    if level < 0 {
        return "Level cannot be negative.";
    }
    skill_nodes = [root-->(`?Skill:name==skill_name)];
    if not skill_nodes {
        return f"Skill node {skill_name} does not exist.";
    }
    skill_node = skill_nodes[0];
    existing_edges = [self->:has_skill:->skill_node];
    if not existing_edges {
        return f"Skill {skill_name} is not added yet. Use add_skill instead.";
    }
    existing_edges[0].level = level;
    self.learning_progress[skill_name] = level;
    return f"Skill {skill_name} updated to level {level}";
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

sem MatchScore. score_value= """
How close the user is to being ready for the role right now.
• 0.90–1.00 = ready to apply or already over-qualified
• 0.75–0.89 = very strong candidate, minor upskilling needed
• 0.50–0.74 = decent foundation, needs moderate work
• 0.25–0.49 = significant gaps
• 0.00–0.24 = almost no overlap
""";

sem MatchScore. matched_skills= """
Skill names where user_level ≥ role_required_level
""";

sem MatchScore. missing_skills= """"
Skill names where either:
– user has no record of the skill, or
– user_level < role_required_level
""";

sem MatchScore. explanation= """
One-sentence reasoning that a career coach would give the user
""";

sem Skill. name= """
The display name of the skill as extracted from the user’s profile or resume.
It should be human-readable and may include variations.
""";

sem Skill. canonical_name= """
An optional normalized identifier for the skill, used to deduplicate and match skills across the system.
""";

sem Skill. category= """
The broad category or domain the skill belongs to.
This helps in grouping and filtering skills for users and roles.
""";
