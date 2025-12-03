enum UserRole { ADMIN = "admin", USER = "user" }

enum SkillDifficulty {
    BEGINNER = "beginner",
    INTERMEDIATE = "intermediate",
    ADVANCED = "advanced"
}

enum SeniorityLevel { JUNIOR = "junior", MID = "mid", SENIOR = "senior" }

node User {
    has id: str;
    has email: str;
    has role: UserRole;
    has target_roles: list[str];
    has current_position: str = "";
    has experience_years: int = 0;
    has bio: str = "";
    has completed_courses: list[str] = [];
    has preferred_industries: list[str] = [];
    has learning_progress: dict[str, int] = {};
    has created_at: str = "";
    has is_private: bool = True;
    has shared_with: list[User] = [];  # list of edge objects
    # list of edge objects
    def add_or_update_skill(
        skill_name  # e.to is the node at the other end (Skill)
        : str,
        level: int
        # e.to is the node at the other end (Skill)
    ) -> str;

    def add_target_role(role: str) -> str;
    def remove_target_role(role: str) -> str;
    def complete_course(course_name: str) -> str;
    def get_basic_info()  -> dict[str, str];
    def get_skills()  -> list[dict[str, any]];
    def get_target_roles()  -> list[str];
    def get_completed_courses()  -> list[str];
    def get_preferred_industries()  -> list[str];
    def get_learning_progress()  -> dict[str, int];
    def get_profile_snapshot()  -> dict[str, any];
    def summarize_profile()  -> str by llm(
        method="ReAct", tools=([self.get_profile_snapshot])
    );
}

node Skill {
    has id: str;
    has name: str;
    has difficulty_level: SkillDifficulty;
    has canonical_name: str = "";
    has category: str = "";
    has level_required: int = 0;
    has importance_score: float = 0.0;
}

node Role {
    has id: str;
    has name: str;
    has average_salary: int;
    has seniority_level: SeniorityLevel;
    has description: str = "";
    has industry: str = "";

    def get_required_skills()  -> list[dict[str, any]] {
        return [
            {"skill_name": edge.to.name, "level_required": edge.level_required}
            for edge in [self-->(`?requires_skill)]
        ];
    }
}

node Course {
    has id: str;
    has title: str;
    has provider: str;
    has skills_taught: list[str];
    has duration: str;
    has course_difficulty: str;
}

node JobPosting {
    has title: str;
    has location: str;
    has company: str;
    has salary_range: int;
    has role_type: str;
}

node Certification {
    has id: str;
    has name: str;
    has issurer: str;
    has skills_tested: str;
    has level: str;
}

node Industry {
    has name: str;
    has top_skills: str;
    has growth_score: str;
}  # retrieve edges of type has_skill that originate from this user
  # retrieve edges of type has_skill that originate from this user


node SkillGap {
    has skill_name: str;
    has required_level: str;
    has current_level: str;
    has severity: int;
}

node SkillCluster {
    has cluster_name: str;
    has skills: list[str];
}

node Trend {
    has topic: str;
    has trend_score: int;
    has affected_skills: str;
    has affected_roles: str;
}

node LearninPath {
    has name: str;
    has steps: list[str];
    has goal_role: str;
    has estimated_time: str;
}

node MatchScore {
    has score_value: float;
    has matched_skills: list[str];
    has missing_skills: list[str];
}
