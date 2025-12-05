impl ProfileManager.execute{
    snapshot = self.get_profile_snapshot();
    summary = self.summarize_profile();
    report {
        "user_id": self.user_id,
        "profile_snapshot": snapshot,
        "profile_summary": summary
    } ;
}

sem ProfileManager. summarize_profile= """
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
