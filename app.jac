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

# retrieve edges of type has_skill that originate from this user
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

walker UserManager {
    has user_id: str;

    def get_user()  -> User {
        return [root-->(`?User:id==self.user_id)][0];
    }

    def semantic_role_match(
        user_skills: list[dict], role: Role, target_roles: list[str]
    ) -> MatchScore by llm(
        method="ReAct",
        tools=(
            [
                User.get_skills,
                User.get_target_roles,
                User.get_profile_snapshot,
                Role.get_required_skills
            ]
        )
    );

    def recommend_roles()  -> list[MatchScore] {
        user = self.get_user();
        user_skills = user.get_skills();
        user_targets = user.get_target_roles();

        roles = [root-->(`?Role)];
        scores = [];
        for r in roles {
            score = self.semantic_role_match(user_skills, r, user_targets);
            scores = scores + [score];
        }

        scores.sort(key=lambda  x: MatchScore: x.score_value);
        scores = scores[::-1];
        return scores;
    }

    def summarize_user_profile()  -> str {
        return self.get_user().summarize_profile();
    }

    def add_skill(skill_name: str, level: int) -> str {
        return self.get_user().add_or_update_skill(skill_name, level);
    }

    def complete_course(course_name: str) -> str {
        return self.get_user().complete_course(course_name);
    }

    can execute with entry {
        user = self.get_user();
        profile_summary = self.summarize_user_profile();
        role_recommendations = self.recommend_roles();

        report {
            "user_id": user.id,
            "profile_summary": profile_summary,
            "role_recommendations": role_recommendations
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
    user1 = User(
        id="u1",
        email="alice@example.com",
        role=UserRole.USER.value,
        target_roles=["AI Engineer"],
        current_position="Junior Analyst"
    );
    root ++> user1;

    # Add skills to user
    user1.add_or_update_skill("Python", 3);
    user1.add_or_update_skill("Machine Learning", 1);

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

    # Run walker
    root spawn UserManager(user_id="u1");
}

sem UserManager. semantic_role_match= """
Compute a semantic match score between a user and a role using LLM reasoning.

Steps:
1. Get user's skills from User.get_skills()
2. Get user's target roles from User.get_target_roles()
3. Get user's profile from User.get_profile_snapshot()
4. Get role's required skills from Role.get_required_skills()
5. For each required skill:
    - If user has the skill at the required level or higher, add to matched_skills
    - Otherwise, add to missing_skills
6. Compute score_value = len(matched_skills) / total number of required skills
7. RETURN JSON ONLY in this exact structure:
{
    "score_value": float,
    "matched_skills": [list of matched skill names],
    "missing_skills": [list of missing skill names]
}
Ensure all fields are always present, even if empty.
""";
