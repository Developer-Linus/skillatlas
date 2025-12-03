import from byllm.lib { Model }

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
    has created_at: str = "";
    has is_private: bool = True;
    has shared_with: list[User] = [];  # list of edge objects

    def add_skill(skill_name: str, level: int) -> str;
    def update_skill(skill_name: str, level: int) -> str;
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
    has explanation: str;
}

edge has_skill {
    has level: int;

    def update_level(new_level: int) -> None;
}

edge wants_skill {}

edge targets_role {}

edge requires_skill {
    has level_required: int;

    def update_required_level(new_level: int) -> None;
}

edge in_industry {}

edge teaches_skill {}

edge prepares_for {}

edge qualifies_for {}

edge covers_skill {}

edge represents_role {}

edge demands_skill {
    has importance_score: float;
}

edge belongs_to_cluster {}

edge has_gap {}

edge leads_to_skill {}

edge affects {}

edge enrolled_in {
    has progress: float;
    has started_at: str;
    has completed_at: str;
}

edge aspires_to {}

edge interested_in_skill {}

walker ProfileManager {
    has user_id: str;

    def get_user()  -> User {
        return [root-->(`?User:id==self.user_id)][0];
    }

    def get_profile_snapshot()  -> dict[str, any] {
        return self.get_user().get_profile_snapshot();
    }

    def summarize_profile()  -> str by llm(
        method="ReAct", tools=([self.get_profile_snapshot])
    );

    can execute with entry {
        snapshot = self.get_profile_snapshot();
        summary = self.summarize_profile();
        report {
            "user_id": self.user_id,
            "profile_snapshot": snapshot,
            "profile_summary": summary
        } ;
    }
}

with entry {
    skill_python = Skill(
        id="s1",
        name="Python",
        level_required=1,
        difficulty_level=SkillDifficulty.BEGINNER.value
    );
    root ++> skill_python;

    skill_ml = Skill(
        id="s2",
        name="Machine Learning",
        level_required=2,
        difficulty_level=SkillDifficulty.INTERMEDIATE.value
    );
    root ++> skill_ml;

    user1 = User(
        id="u1",
        email="alice@example.com",
        role=UserRole.USER.value,
        target_roles=["Mid Data Analyst"],
        current_position="Junior Data Analyst",
        experience_years=1,
        bio="Passionate about data-driven insights and predictive modeling.",
        completed_courses=["Intro to Data Analysis", "Python for Data Science"],
        preferred_industries=["Finance", "Healthcare"],
        learning_progress={"Python": 4, "Machine Learning": 2, "SQL": 3}
    );
    root ++> user1;

    # Add skills to user
    user1.add_skill("Python", 4);
    user1.add_skill("Machine Learning", 2);
    user1.add_skill("SQL", 3);
    user1.update_skill("Python", 5);

    # Create a role
    role_ds = Role(
        id="r1",
        name="Data Scientist",
        seniority_level=SeniorityLevel.JUNIOR.value,
        average_salary=60000
    );
    root ++> role_ds;

    # Role → Skill required edges
    role_ds +>: requires_skill(level_required=1) :+> skill_python;
    role_ds +>: requires_skill(level_required=2) :+> skill_ml;

    root spawn ProfileManager(user_id="u1");
}
