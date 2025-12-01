enum UserRole { ADMIN = "admin", USER = "user" }

enum SkillDifficulty {
    BEGINNER = "beginner",
    INTERMEDIATE = "intermediate",
    ADVANCED = "advanced"
}

enum SeniorityLevel { JUNIOR = "junior", MID = "mid", SENIOR = "senior" }

node User {
    has id: str;
    has username: str;
    has email: str;
    has role: UserRole;
    has current_position: str = "";
    has target_roles: list[str] = [];
    has experience_years: int = 0;
    has bio: str = "";
    has completed_courses: list[str] = [];
    has preferred_industries: list[str] = [];
    has learning_progress: dict[str, int] = {};
    has created_at: str = "";
    has is_private: bool = true;
    has shared_with: list[str] = [];

    def add_or_update_skill(skill_name: str, level: int) -> str;
    def add_target_role(role: str) -> str;
    def remove_target_role(role: str) -> str;
    def complete_course(course_name: str) -> str;
}

node Skill {
    has id: str;
    has name: str;
    has canonical_name: str = "";
    has category: str = "";
    has difficulty_level: SkillDifficulty;
    has level_required: int = 0;
    has importance_score: float = 0.0;
}

node Role {
    has id: str;
    has name: str;
    has seniority_level: SeniorityLevel;
    has description: str = "";
    has industry: str = "";
    has average_salary: int;
}

node Course {
    has id: str;
    has title: str;
    has provider: str;
    has skills_taught: list[str];
    has duration: str;
    has difficulty: str;
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
}

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
# User -> Skill
edge has_skill {
    has level: int;

    def update_level(new_level: int) -> None;
}

# User -> Skill
edge wants_skill {}

# User -> Role
edge targets_role {}

# Role -> Skill
edge requires_skill {
    has level_required: int;

    def update_required_level(new_level: int) -> None;
}

# Role -> Industry
edge in_industry {}

# Course -> Skill
edge teaches_skill {}

# Course -> Role
edge prepares_for {}

# Certification -> Role
edge qualifies_for {}

# Certification -> Skill
edge covers_skill {}

# JobPosting -> Role
edge represents_role {}

# JobPosting -> Skill
edge demands_skill {
    has importance_score: float;
}

# Skill -> SkillCluster
edge belongs_to_cluster {}
# User -> SkillGap
edge has_gap {}
# LearningPath -> Skill
edge leads_to_skill {}
# Trend -> Skill/Role
edge affects {}
