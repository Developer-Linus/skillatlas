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
#---------------------------------
#          ROLE NODE
#---------------------------------
node Role {
    has id: str;  # internal unique ID
    has name: str;  # display name
    has seniority_level: SeniorityLevel;  # e.g., "Junior", "Mid", "Senior"
    has description: str = "";  # job description / summary
    has industry: str = "";  # e.g., "Finance", "Tech", "Healthcare"
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
