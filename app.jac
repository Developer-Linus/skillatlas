import from byllm.llm { Model }
import time;

glob llm = Model(model_name="gemini/gemini-2.5-flash", verbose=False);

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
    has created_at: str = time.now();
    has is_private  # retrieve edges of type has_skill that originate from this user
    : bool = true;

    has shared_with: list[str] = [];  # list of edge objects
    # list of edge objects

    # Mutation abilities
    def add_or_update_skill(skill_name: str, level: int) -> str;
    def add_target_role(role: str) -> str;
    def remove_target_role(role: str) -> str;
    def complete_course(course_name: str) -> str;
    # Readonly getters
    def get_basic_info()  -> dict[str, str];
    def get_skills()  -> list[dict[str, any]];
    def get_target_roles()  -> list[str];
    def get_completed_courses()  -> list[str];
    def get_preferred_industries()  -> list[str];
    def get_learning_progress()  -> dict[str, int];
    def get_profile_snapshot()  -> dict[str, any];
    # LLM functions
    def summarize_profile()  -> str by llm(
        method="ReAct",
        tools=(
            [
                self.get_profile_snapshot,
                self.get_basic_info,
                self.get_skills,
                self.get_target_roles,
                self.get_completed_courses,
                self.get_preferred_industries,
                self.get_learning_progress,

            ]
        )
    );

    def recommend_roles()  -> list[str] by llm(
        method="ReAct", tools=([self.get_skills, self.get_learning_progress])
    );
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
# User -> Skill
# User -> Skill
# User -> Skill
edge has_skill {
    has level: int;

    def update_level(new_level: int) -> None;
}

# User -> Skill
# User -> Skill
# User -> Skill
# User -> Skill
edge wants_skill {}

# User -> Role
# User -> Role
edge targets_role {}

# Role -> Skill
# Role -> Skill
edge requires_skill {
    has level_required: int;

    def update_required_level(new_level: int) -> None;
}

# Role -> Industry
# Role -> Industry
edge in_industry {}

# Course -> Skill
# Course -> Skill
edge teaches_skill {}

# Course -> Role
# Course -> Role
edge prepares_for {}

# Certification -> Role
# Certification -> Role
edge qualifies_for {}

# Certification -> Skill
# Certification -> Skill
edge covers_skill {}

# JobPosting -> Role
# JobPosting -> Role
edge represents_role {}

# JobPosting -> Skill
# JobPosting -> Skill
edge demands_skill {
    has importance_score: float;
}

# Skill -> SkillCluster
# Skill -> SkillCluster
edge belongs_to_cluster {}
# User -> SkillGap
# User -> SkillGap
edge has_gap {}
# LearningPath -> Skill
# LearningPath -> Skill
edge leads_to_skill {}
# Trend -> Skill/Role
# Trend -> Skill/Role
edge affects {}

walker UserManager {
    """
    1. Locate.
    2. Create-if-missing
    3. Operate
    """
    has user_id: str;

    can manage_user with User entry;
}
# retrieve edges of type has_skill that originate from this user
