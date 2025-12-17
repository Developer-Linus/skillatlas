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

impl extract_and_attach_skills.extract{
    user_data = here;
    if not user_data {
        report {"success": False, "error": "UserData not found"} ;
        disengage;
    }
    extracted_skills_specs = self.extract_skills(user_data);
    existing_user_skills = user_data.get_skills();
    existing_user_skill_names = [
        s["name"].lower().strip() for s in existing_user_skills
    ];
    newly_added_skills = [];
    for spec in extracted_skills_specs {
        canon_name = "";
        if spec.canonical_name != "" {
            canon_name = spec.canonical_name;
        } else {
            canon_name = spec.name.lower().replace(" ", "_");
        }

        skill_node = Skill(
            id=jid(spec),
            name=spec.name,
            canonical_name=canon_name,
            category=spec.category
        );

        if not skill_node.name.lower() in existing_user_skill_names {
            user_data +>: has_skill(level=spec.current_level) :+> skill_node;
            newly_added_skills.append(skill_node.name);
        }
    }
    report {
        "success": True,
        "existing_skills": existing_user_skill_names,
        "newly_added_skills": newly_added_skills,
        "total_skills_after_update": [s["name"] for s in user_data.get_skills()]
    } ;
}

impl extract_and_attach_skills.start{
    visit [-->](`?UserData) else {
        report {"success": False, "error": "User data not found!"} ;
    }
}

sem extract_and_attach_skills. extract_skills= """
You extract the most relevant skills from the user’s resume text.

Rules:
1. ALWAYS call the tool get_resume_text() first to obtain cleaned resume text.
2. Return ONLY the top, key skills that are most important for the user’s target role.
3. Return a LIST of Skill node OBJECTS: [SkillNode, SkillNode, ...].
4. Assign current_level (1–5) per skill based on confidence inferred from resume evidence (projects, roles, duration, ownership). Rate practical confidence as a career advisor for user's target role.
5. Do NOT return duplicates or irrelevant skills.
6. If no relevant skills are found, return an empty list [].
7. Ensure each SkillNode has the correct name, current_level, optional canonical_name, and category fields populated.
""";

impl profile_manager.get_user_data{
    return [root-->(`?UserData)][0];
}

impl profile_manager.get_profile_snapshot{
    return self.get_user().get_profile_snapshot();
}

impl resume_parser.detect_resume_type{
    return self.utils.detect_file_type(self.uploaded_path);
}

impl resume_parser.parse_resume{
    output = {"text": "", "file_type": "", "status": "failed", "errors": []};
    try {
        file_type = self.detect_resume_type();
        output["file_type"] = file_type;

        if file_type == "" {
            output["errors"].append("Could not detect file type");
            return output;
        }

        text = self.utils.extract_text_temp(self.uploaded_path, file_type);
        if text.strip() == "" {
            output["errors"].append("Failed to extract text from resume");
            return output;
        }

        output["text"] = text;
        output["status"] = "success";
    } except Exception as e {
        output["errors"].append(str(e));
    }
    return output;
}

impl save_user_profile.start{
    visit [here-->(`?UserData)] else {
        new_user_data = here ++> UserData(
            email=self.email, role=UserRole.USER.value, target_role=self.target_role
        );
        visit [-->new_user_data];
    }
}

impl save_user_profile.update_email_and_targetrole{
    here.email = self.email;
    here.target_role = self.target_role;
    report {"user_data_id": jid(here), "success": True, "user_node": here,} ;
}

impl store_cv_file.start{
    if not os.path.exists(self.upload_dir) {
        os.makedirs(self.upload_dir);
    }
    timestamp = str(int(time.time()));
    final_path = os.path.join(self.upload_dir, timestamp + "_" + self.file_name);
    try {
        raw_bytes = base64.b64decode(self.file_data_b64);
        with open(final_path, "wb") as f {
            f.write(raw_bytes);
        }

        report {"status": "success", "path": final_path} ;
    } except Exception as e {
        report {"status": "error", "error": str(e)} ;
    }
}

impl collect_job_postings.get_user_data{
    return [root-->(`?UserData)][0];
}

impl collect_job_postings.start{
    user_data = self.get_user_data();
    self.target_role = user_data.get_target_role();
    if not target_role {
        report {"error": "User has no target role"} ;
        disengage;
    }
    if not user_data {
        report {"error": "UserData not found"} ;
        disengage;
    }
    visit [-->user_data];
}

impl collect_job_postings.fetch_and_attach_jobs{
    user_data = here;
    web = WebSearch();
    jobs = web.search_job_postings(self.target_role);
    if len(jobs) == 0 {
        report {"info": "No job postings found"} ;
        disengage;
    }
    for job in jobs {
        job_node = JobPosting(
            job_uid=job["job_uid"],
            title=job["title"],
            company=job["company"],
            location=job["location"],
            employment_type=job["employment_type"],
            description=job["description"],
            posted_at=job["posted_at"],
            source=job["source"],
            salary=job["salary"]
        );

        user_data ++> job_node;
    }
    job_listings = [user_data-->(`?JobPosting)];
    report {
        "target_role": self.target_role,
        "attached_jobs": len(jobs),
        "jobs": job_listings
    } ;
}

impl extract_target_role_requirements.get_user_data{
    return [root-->(`?UserData)][0];
}

impl extract_target_role_requirements.get_job_postings{
    user_data = self.get_user_data();
    return [user_data-->(`?JobPosting)];
}

impl extract_target_role_requirements.start{
    user_data = self.get_user_data();
    self.target_role = user_data.get_target_role();
    if not user_data {
        report {"error": "UserData not found"} ;
        disengage;
    }
    if not self.target_role {
        report {"error": "User has no target role"} ;
        disengage;
    }
    visit [-->user_data];
}

impl extract_target_role_requirements.extract_requirements{
    user_data = here;
    jobs = self.get_job_postings();
    if len(jobs) == 0 {
        report {"info": "No job postings found for extraction"} ;
        disengage;
    }
    job_texts = [job.description for job in jobs];
    role_data = self.get_role_requirements(
        target_role=self.target_role, job_descriptions=job_texts
    );
    role_node = Role(
        id=jid(role_data),
        name=self.target_role,
        seniority_level=role_data.seniority_level,
        description=role_data.description,
        industry=role_data.industries,
        skill_requirements=role_data.required_skills
    );
    user_data ++> role_node;
    report {
        "role_id": role_node.id,
        "role_name": role_node.name,
        "skills_extracted": role_node.skill_requirements,
        "industries": role_node.industry
    } ;
}

sem extract_target_role_requirements. get_role_requirements= """
        Instruction for the LLM:

    1. Input:
       - target_role: role name/title
       - job_descriptions: list of raw job posting texts

    2. Task:
       - Extract **role requirements** from the job descriptions.
       - Aggregate and deduplicate skills and industries.

    3. Output: **exactly** a RoleSpec object with:
       {
         "name": <role name>,
         "description": <concise summary of role responsibilities>,
         "seniority_level": <junior|mid|senior>,
         "industry": [<SkillSpec>, ...],
         "skill_requirements": [<SkillSpec>, ...] # max 10 items
       }

    4. Rules:
       - For `industry` and `skill_requirements`, return SkillSpec nodes only.
       - Deduplicate repeated skills or industries.
       - Include only practical, observable skills from the text.
       - Ignore company perks, salaries, or boilerplate.
       - Return **RoleSpec object only**; no explanations, no extra text.
       - Preserve canonical skill names if available.

    5. Goal:
       - Produce a clean, deterministic RoleSpec that can be persisted in Jac
         and used for skill matching and dashboard display.
    """;

impl extract_and_attach_skills.get_resume_text{
    user_data = here;
    return f"resume_parser_output: {self.resume_parser_output}, target_role: {user_data.get_target_role()}";
}

impl compute_match_score.get_user_data{
    return [root-->(`?UserData)][0];
}

impl compute_match_score.start{
    user_data = self.get_user_data;
    self.target_role = user.get_target_role();
    if not user_data {
        report {"error": "UserData not found"} ;
        disengage;
    }
    if not self.target_role {
        report {"error": "User has no target role"} ;
        disengage;
    }
    visit [-->user_data];
}
impl compute_match_score.extract_matching_skills{
        matched_skills = [
            s
            for s in required_skills
            if s in user_skills
        ];
        return {"number_of_matching_skills": len(matched_skills),
        "matching_skills": matched_skills};
    }
impl compute_match_score.extract_missing_skills{
        missing_skills = [
            s
            for s in required_skills
            if s not in user_skills
        ];
        return {"number_of_missing_skills": len(missing_skills),
        "missing_skills": missing_skills};
    }
sem compute_match_score.get_matched_skills = """
    1. Input:
       - user_skills: list of user's skills (strings)
       - required_skills: list of skills required for the target role (strings)

    2. Task:
       - Use **semantic similarity** to compare user_skills with required_skills.
       - Identify which required skills are **already matched** by the user's skills.
       - You may call `extract_matching_skills(user_skills, required_skills)` to assist.

    3. Output:
       - Return a dictionary with:
         {
             "number_of_matching_skills": int,  # count of matched skills
             "matching_skills": list[str]       # list of matched skills
         }
       - Do not include explanations or extra text.
       - Only include semantically relevant matches.

    4. Goal:
       - Provide structured data for computing the overall match score and for dashboard display.
""";

impl compute_match_score.calculate_score{
    user_data = here;
    user_skills = [s["name"].lower().strip() for s in self.user_data.get_skills()];
    required_skills = [
        s["canonical_name"].lower().strip() if s["canonical_name"] != "" else s["name"].lower().strip()
        for s in self.target_role.skill_requirements
    ];

    # Find matched and missing skills
    number_of_matched_skills = self.get_matched_skills()["number_of_matching_skills"];
    matched_skills = self.get_matched_skills()["matching_skills"];

    number_of_missing_skills = self.get_missing_skills()["number_of_missing_skills"];
     missing_skills = self.get_missing_skills()["missing_skills"];

    # Compute match score (0–100%)
    score_value = float(len(matched_skills)) / max(len(required_skills), 1);
    score_percentage = score_value * 100.0;
    explanation = "";
   if score_percentage >= 90.0 {
    explanation = "Excellent! You already have nearly all the skills needed for this role. You're very well-prepared!";
} elif score_percentage >= 70.0 {
    explanation = "You're doing well! You have most of the key skills, but there are a few areas you could improve.";
} elif score_percentage >= 40.0 {
    explanation = "You have a good starting point, but several important skills are missing. Focusing on these will boost your match.";
} else {
    explanation = "You're just getting started. Consider building foundational skills to better align with this role.";
}

    # Create MatchScore node
    match_node = MatchScore(
        score_value=score_value,
        matched_skills=matched_skills,
        missing_skills=missing_skills,
        explanation=explanation
    );

    user_data ++> match_node;
    # Report the result
    report {
        "score_value": match_node.score_value,
        "matched_skills": match_node.matched_skills,
        "missing_skills": match_node.missing_skills,
        "explanation": match_node.explanation
    };
}
sem compute_match_score.get_missing_skills = """
1. Input:
       - user_skills: list of user's skills (strings)
       - required_skills: list of skills required for the target role (strings)

    2. Task:
       - Use **semantic similarity** to compare user_skills with required_skills.
       - Identify which required skills are **missing** from the user's skill set.
       - You may call `extract_missing_skills(user_skills, required_skills)` to assist.

    3. Output:
       - Return a dictionary with:
         {
             "number_of_missing_skills": int,  # count of missing skills
             "missing_skills": list[str]       # list of missing skills
         }
       - Do not include explanations or extra text.
       - Only include semantically relevant missing skills.

    4. Goal:
       - Provide structured data for computing the overall match score and for dashboard display.
""";
