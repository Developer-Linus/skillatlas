node User {
    has id: str;
    has username: str;
    has email: str;
    has current_role: str = "";
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
    has difficulty_level: str = "Beginner";
    has level_required: int = 0;
    has importance_score: float = 0.0;
}
#---------------------------------
#          ROLE NODE
#---------------------------------
node Role {
    has id: str;  # internal unique ID
    has name: str;  # display name
    has description: str = "";  # job description / summary
    has industry: str = "";  # e.g., "Finance", "Tech", "Healthcare"
    has seniority_level: str = "";  # e.g., "Junior", "Mid", "Senior"
    has average_salary: int;
}
