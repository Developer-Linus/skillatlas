impl skill_extractor.extract{
    user_data = self.get_user_data();
    extracted_skills = self.extract_skills();
    existing_user_skills = user_data.get_skills();
    existing_user_skill_names = [
        s["name"].lower().strip() for s in existing_user_skills
    ];
    newly_added_skills = [];
    for skill_node in extracted_skills {
        if not skill_node.name.lower() in existing_user_skill_names {
            user_data +>: has_skill(level=1) :+> skill_node;
            newly_added_skills.append(skill_node.name);
        }
    }
    report {
        "existing_skills": existing_user_skill_names,
        "newly_added_skills": newly_added_skills,
        "total_skills_after_update": [s["name"] for s in user.get_skills()]
    } ;
}

sem skill_extractor. extract_skills= """
You extract the most relevant skills from the user’s resume text.

Rules:
1. ALWAYS call the tool get_resume_text() first to obtain cleaned resume text.
2. Return ONLY the top, key skills that are most important for the user’s target roles.
3. Return a LIST of Skill node OBJECTS: [SkillNode, SkillNode, ...].
4. Do NOT return duplicates or irrelevant skills.
5. If no relevant skills are found, return an empty list [].
6. Ensure each SkillNode has the correct name, optional canonical_name, and category fields populated.
""";
