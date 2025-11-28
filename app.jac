node User {
    # -----------------------------
    # Identity / Auth
    # -----------------------------
    has id: str;  # internal unique ID
    has username: str;
    has email: str;
    # -----------------------------
    # Career Profile
    # -----------------------------
    has current_role: str = "";  # e.g., "Software Engineer"
    has target_roles: list[str] = [];  # roles the user wants to pursue
    has experience_years: int = 0;
    has bio: str = "";
    # -----------------------------
    # Skills & Learning
    # -----------------------------
    has completed_courses: list[str] = [];
    has preferred_industries: list[str] = [];
    has learning_progress: dict[str, int] = {};  # {skill_name: level}
    # -----------------------------
    # Privacy & Metadata
    # -----------------------------
    has created_at: str = "";
    has is_private: bool = true;
    has shared_with: list[str] = [];

    #                     ABILITIES
    # 1. Add or Update a Skill Level
    def add_or_update_skill(skill_name: str, level: int) -> str;
    # 2. Add a Target Role
    def add_target_role(role: str) -> str;
    # 3. Remove a Target Role
    def remove_target_role(role: str) -> str;
    # 4. Mark Course as Completed
    def complete_course(course_name: str) -> str;
}
