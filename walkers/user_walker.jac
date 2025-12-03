include models;
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
