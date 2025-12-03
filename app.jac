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

    def add_or_update_skill(
        skill_name  # e.to is the node at the other end (Skill)
        : str,
        level: int
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

    def get_required_skills()  -> list[dict] {
        return [
            {"skill_name": edge.to_node.name, "level_required": edge.level_required}
            for edge in [here->:requires_skill:->]
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

node Memory {
    has sessions: list = [];

    def get_or_create_session(user_id: str) -> Session {
        # Try to find existing session
        session_list = [
            s
            for s in self.sessions
            if s.user_id == user_id
        ];
        if session_list {
            return session_list[0];
        }

        # If none exists, create a new one
        # If none exists, create a new one
        new_session = Session(user_id=user_id);
        self.sessions = self.sessions + [new_session];
        return new_session;
    }

    def list_sessions()  -> list[dict] {
        return [
            {
                "user_id": s.user_id,
                "created_at": s.created_at,
                "history_length": len(s.history)
            } for s in self.sessions
        ];
    }
}

node Session {
    has user_id: str;
    has history: list[str] = [];
    has created_at: str = get_current_datetime();

    def add_history(entry: str) {
        self.history = self.history + [entry];
    }

    def get_history(last_n: int = 10) -> str {
        # Return the last `last_n` entries joined by newline
        # Return the last `last_n` entries joined by newline
        return "\n".join(self.history[-last_n:]);
    }

    def snapshot()  -> str by llm(method="ReAct", tools=([self.get_history]));
}
#-------------------------
#-------------------------
#   SessionManager Walker
#   SessionManager Walker
#-------------------------
#-------------------------
walker SessionManager {
    has user_id: str = "";

    # No auth for now
    # No auth for now
    obj __specs__ {
        static has auth: bool = False;
    }

    can get_or_create_session with `root entry {
        # Ensure memory node exists
        # Ensure memory node exists
        memory_list = [root-->(`?Memory)];
        if not memory_list {
            memory = root ++> Memory();
        } else {
            memory = memory_list[0];
        }

        # Get or create session in one call
        # Get or create session in one call
        session = memory.get_or_create_session(self.user_id);

        # Return session for agent usage
        # Return session for agent usage
        report session ;
    }
}

enum NavigatorAgents {
    CAREER_ENGINE = "CareerEngine",
    LEARNING_RECOMMENDER = "LearningRecommender",
    PROFILE_MANAGER = "ProfileManager",
}

walker smart_career_navigator {
    has action: str;
    has user_id: str;
    has session_id: str;

    obj __specs__ {
        static has auth: bool = False;
    }

    # LLM-driven routing function
    # LLM-driven routing function
    def route_to_agent(action: str, history: str) -> NavigatorAgents by llm(
        method="ReAct"
    );

    can execute with `root entry;
}

node ProfileManager {
    has user_id: str;

    # -------------------------
    # -------------------------
    # Helper: Fetch user node
    # Helper: Fetch user node
    # -------------------------
    # -------------------------
    def get_user()  -> User {
        return [root-->(`?User:id==self.user_id)][0];
    }

    # -------------------------
    # -------------------------
    # Read-only snapshot for LLM or other agents
    # Read-only snapshot for LLM or other agents
    # -------------------------
    # -------------------------
    def get_profile_snapshot()  -> dict[str, any] {
        return self.get_user().get_profile_snapshot();
    }

    # -------------------------
    # -------------------------
    # Summarize user profile using LLM
    # Summarize user profile using LLM
    # -------------------------
    # -------------------------
    def summarize_profile()  -> str by llm(
        method="ReAct", tools=([self.get_profile_snapshot])
    );

    # -------------------------
    # -------------------------
    # -------------------------
    # -------------------------
    # LLM-driven read-only orchestrator
    # LLM-driven read-only orchestrator
    # LLM-driven read-only orchestrator
    # LLM-driven read-only orchestrator
    # -------------------------
    # -------------------------
    # -------------------------
    # -------------------------
    def route_and_run(action: str, history: str) -> str by llm(
        method="ReAct", tools=([self.summarize_profile])
    );

    # -------------------------
    # -------------------------
    # -------------------------
    # -------------------------
    # Entry point called by supervisor agent
    # Entry point called by supervisor agent
    # Entry point called by supervisor agent
    # Entry point called by supervisor agent
    # -------------------------
    # -------------------------
    # -------------------------
    # -------------------------
    can execute with smart_career_navigator entry {
        session = visitor.session;

        # Get LLM summary
        # Get LLM summary
        # Get LLM summary
        # Get LLM summary
        response = self.route_and_run(visitor.action, session.get_history());

        # Append interaction to session
        # Append interaction to session
        # Append interaction to session
        # Append interaction to session
        session.add_history("user: " + visitor.action + "\nai: " + response);

        # Return structured report to supervisor
        # Return structured report to supervisor
        # Return structured report to supervisor
        # Return structured report to supervisor
        report {
            "user_id": self.user_id,
            "session_id": jid(visitor.session),
            "created_at": visitor.session.created_at,
            "profile_snapshot": self.get_profile_snapshot(),
            "response_summary": response
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

    # Create a user
    # Create a user
    # Create a user
    # Create a user
    # Create a user
    # Create a user
    # Create a user
    # Create a user
    # Create a user
    # Create a user
    # Create a user
    # Create a user
    # Create a user
    # Create a user
    # Create a user
    # Create a user
    user1 = User(
        id="u1",
        email="alice@example.com",
        role=UserRole.USER.value,
        target_roles=["Mid Data Analyst"],
        current_position="Junior Data Analyst"
    );
    root ++> user1;

    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    # Add skills to user
    user1.add_or_update_skill("Python", 3);
    user1.add_or_update_skill("Machine Learning", 1);

    # Create a role
    # Create a role
    # Create a role
    # Create a role
    # Create a role
    # Create a role
    # Create a role
    # Create a role
    # Create a role
    # Create a role
    # Create a role
    # Create a role
    # Create a role
    # Create a role
    # Create a role
    # Create a role
    role_ds = Role(
        id="r1",
        name="Data Scientist",
        seniority_level=SeniorityLevel.JUNIOR.value,
        average_salary=60000
    );
    root ++> role_ds;

    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    # Role → Skill required edges
    role_ds +>: requires_skill(level_required=1) :+> skill_python;
    role_ds +>: requires_skill(level_required=2) :+> skill_ml;
}
