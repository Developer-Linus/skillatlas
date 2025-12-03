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
    skill_edges = [self-->(`?has_skill)];  # list of edge objects
    skills_list = [];
    for e in skill_edges {
        # e.to is the node at the other end (Skill)
        # guard: if skill node missing, skip
        if e.to {
            skills_list = skills_list + [{"name": e.to.name, "level": e.level}];
        }
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

impl smart_career_navigator.execute{
    memory_list = [root-->(`?Memory)];
    if not memory_list {
        memory = root ++> Memory();
    } else {
        memory = memory_list[0];
    }
    if not self.session_id {
        session = memory.get_or_create_session(self.user_id);
    } else {
        self.session = & (self.session_id);
    }
    routed_agent = self.route_to_agent(self.action, self.session.get_history());
    node_cls = globals().get(routed_agent.value, "");
    if not node_cls {
        report {
            "user_id": self.user_id,
            "response": "Sorry, I couldn't determine the agent to handle this request."
        } ;
        return;
    }
    node_inst = node_cls(
        user_id=self.user_id, action=self.action, session=self.session
    );
    visit [-->(`?node_cls)] else {
        attached_node = here ++> node_inst;
        visit attached_node;
    }
    self.session.add_history("user: " + self.action);
    report {
        "user_id": self.user_id,
        "session_id": jid(self.session),
        "created_at": self.session.created_at,
        "routed_agent": routed_agent,
        "session_history": self.session.get_history(),

    } ;
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
