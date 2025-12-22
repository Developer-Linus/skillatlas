import from backend.edges.edges { has_skill }
import from backend.utils.current_time { get_current_time }
enum UserRole { ADMIN = "admin", USER = "user" }

enum SeniorityLevel { JUNIOR = "junior", MID = "mid", SENIOR = "senior" }

node UserData {
    has email: str;
    has role: UserRole.USER.value;
    has target_role: str;
    has resume_summary: str = "";
    has experience_years: int = 0;
    has bio: str = "";
    has completed_courses: list[str] = [];
    has preferred_industries: list[str] = [];
    has learning_progress: dict[str, int] = {};
    has created_at: str = get_current_time();

    def add_skill(skill_name: str, level: int) -> str;
    def update_skill(skill_name: str, level: int) -> str;
    def add_target_role(role: str) -> str;
    def remove_target_role(role: str) -> str;
    def complete_course(course_name: str) -> str;
    def get_basic_info()  -> dict[str, str];
    def get_skills()  -> list[dict[str, any]];
    def get_target_role()  -> list[str];
    def get_completed_courses()  -> list[str];
    def get_preferred_industries()  -> list[str];
    def get_learning_progress()  -> dict[str, int];
    def get_profile_snapshot()  -> dict[str, any];
    def summarize_profile()  -> str by llm(
        method="ReAct", tools=([self.get_profile_snapshot])
    );
}

obj MatchResult {
    has number_of_matching_skills: int;
    has matching_skills: list[str];
}

obj MissingSkillsResult {
    has number_of_missing_skills: int;
    has missing_skills: list[str];
}

obj SkillSpec {
    has name: str;
    has canonical_name: str = "";
    has category: str = "";
    has current_level: int = 1;
}

node Skill {
    has name: str;
    has canonical_name: str = "";
    has category: str = "";
}

obj RoleSpec {
    has name: str;
    has description: str;
    has seniority_level: str;
    has industry: list[SkillSpec] = [];
    has skill_requirements: list[SkillSpec] = [];
}

node Role {
    has name: str;
    has seniority_level: SeniorityLevel;
    has description: str = "";
    has industry: list[str] = "";
    has skill_requirements: list[Skill] = [];
}

node JobPosting {
    has job_uid: str;
    has title: str;
    has company: str;
    has location: str;
    has employment_type: str;
    has description: str;
    has posted_at: str;
    has source: str;
    has salary: str = "";
    has apply_links: list = [];
}

node SkillGap {
    has skill_name: str;
    has severity: int;
}

node LearningPhase {
    has phase_name: str;
    has skills: list[str];
    has resources: list[str];
    has estimated_time: str;
}

node LearningPath {
    has target_role: str;
    has missing_skills: list[str];
    has phases: list[LearningPhase];
    has resources: list[dict];
}

node MatchScore {
    has score_value: float;
    has matched_skills: list[str];
    has missing_skills: list[str];
    has explanation: str;
}
