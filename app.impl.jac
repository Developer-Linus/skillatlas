impl profile_manager.execute{
    snapshot = self.get_profile_snapshot();
    summary = self.summarize_profile();
    report {"profile_snapshot": snapshot, "profile_summary": summary} ;
}

sem profile_manager. summarize_profile= """
You are given a user profile snapshot in dictionary form.
Write a single, concise paragraph summary that includes:
- Current position and years of experience.
- Key skills with levels.
- Completed courses and ongoing learning progress.
- Target roles or career goals.
- Preferred industries if any.

Guidelines:
- Keep it factual and based only on the snapshot data.
- Do not create opinions or add extra information.
- Combine all points into natural prose; avoid lists or bullets.
- Be concise and clear.

Example:
For a user with the following snapshot:
{
    "basic_info": {
        "current_position": "Junior Data Analyst",
        "experience_years": 0
    },
    "skills": [
        {"name": "Python", "level": 3},
        {"name": "Machine Learning", "level": 1}
    ],
    "completed_courses": [],
    "learning_progress": {"Python": 3, "Machine Learning": 1},
    "target_roles": ["Mid Data Analyst"],
    "preferred_industries": []
}

The example summary paragraph can be:
"The user is currently a Junior Data Analyst with no prior work experience. They have foundational skills in Python (level 3) and introductory knowledge in Machine Learning (level 1). They are actively progressing in Python and Machine Learning and are targeting roles as a Mid Data Analyst. They have not completed any formal courses yet and have no specific preferred industries."
""";

impl resume_parser.execute{
    parsed = self.parse_resume();
    summary = self.summarize_resume();
    report {
        "file_type": parsed["file_type"],
        "status": parsed["status"],
        "errors": parsed["errors"],
        "cleaned_resume_text": parsed["text"],
        "resume_summary": summary
    } ;
}

sem resume_parser. summarize_resume= """
Summarize a resume for professional understanding.

    Purpose:
        Generate a concise, human-readable summary of a resume, highlighting
        key sections such as experience, skills, education, and career objectives.

    Input:
        Uses the output of self.parse_resume(), which provides cleaned text
        extracted from the resume (PDF, DOCX, or scanned PDF).

    Output:
        Returns a single string summarizing the resume in 2–4 professional sentences.
        Example:
            "Jane Doe is an entry-level software engineer skilled in Python and data analysis.
             She holds a BSc in Computer Science and has internship experience in backend development."

    Constraints:
        - Avoid including sensitive personal identifiers beyond professional details.
        - Maintain concise, professional tone suitable for HR review or LLM downstream processing.
        - Focus on actionable skills, experience, and educational background.

    Method:
        Uses the "ReAct" reasoning method to extract key information before composing
        the summary.
""";

impl extract_and_attach_skills.get_user_data{
    return [root-->(`?UserData)][0];
}

impl extract_and_attach_skills.start{
    if self.get_user_data() {
        visit [here-->(`?UserData)];
    } else {
        report {"success": False, "error": "UserData not found"} ;
    }
}

impl extract_and_attach_skills.extract{
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
        "success": True,
        "existing_skills": existing_user_skill_names,
        "newly_added_skills": newly_added_skills,
        "total_skills_after_update": [s["name"] for s in user.get_skills()]
    } ;
}

sem extract_and_attach_skills. extract_skills= """
You extract the most relevant skills from the user’s resume text.

Rules:
1. ALWAYS call the tool get_resume_text() first to obtain cleaned resume text.
2. Return ONLY the top, key skills that are most important for the user’s target roles.
3. Return a LIST of Skill node OBJECTS: [SkillNode, SkillNode, ...].
4. Do NOT return duplicates or irrelevant skills.
5. If no relevant skills are found, return an empty list [].
6. Ensure each SkillNode has the correct name, optional canonical_name, and category fields populated.
""";
