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

impl resume_parser.get_user_data{
    return [root-->(`?UserData)][0];
}

impl resume_parser.execute{
    user_data = self.get_user_data();
    parsed = self.parse_resume();
    summary = self.summarize_resume();
    user_data.resume_summary = summary;
    report {
        "file_type": parsed["file_type"],
        "status": parsed["status"],
        "errors": parsed["errors"],
        "cleaned_resume_text": parsed["text"],
        "resume_summary": summary,
        "user_resume_summary": user_data.resume_summary
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
    extracted_skills_specs = self.extract_skills(resume_text=self.resume_parser_output);
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
            name=spec.name, canonical_name=canon_name, category=spec.category
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
Extract exactly 5-10 professional skills from the resume text.For each skill, evaluate the 'current_level' (1-5) based on experience. Return a flat list of SkillSpec objects. Do not include thinking or text.""";

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
    if not self.target_role {
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
    report {"target_role": self.target_role, "attached_jobs": len(jobs)} ;
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
        name=self.target_role,
        seniority_level=role_data.seniority_level,
        description=role_data.description,
        industry=role_data.industry,
        skill_requirements=role_data.skill_requirements
    );
    user_data ++> role_node;
    report {
        "role_name": role_node.name,
        "skills_extracted": role_node.skill_requirements,
        "industries": role_node.industry
    } ;
}

sem extract_target_role_requirements. get_role_requirements= """
You are a precise data extraction agent. From the provided job descriptions, extract requirements for the target role and populate a RoleSpec object.

Rules:
    1. 'name', 'description', and 'seniority_level' MUST be strings at the root of the JSON.
    2. 'seniority_level' MUST be one of: 'junior', 'mid', or 'senior' (all lowercase).
    3. 'industry' MUST be a list of 1-3 primary industries.
    4. 'skill_requirements' MUST be a flat list of SkillSpec objects.
       - LIMIT: Extract ONLY the top 8-12 most critical skills.
       - Prioritize hard technical skills and essential soft skills.
       - Do not include every single tool mentioned; group them if necessary (e.g., 'Cloud Platforms' instead of listing 10 AWS services).
    5. DO NOT create nested dictionaries like 'industry: { name: ... }'.
    6. Return ONLY the RoleSpec object.
""";

impl extract_and_attach_skills.get_resume_text{
    user_data = here;
    return f"resume_parser_output: {self.resume_parser_output}, target_role: {user_data.get_target_role()}";
}

impl compute_match_score.get_user_data{
    return [root-->(`?UserData)][0];
}

impl compute_match_score.start{
    user_data = self.get_user_data();
    if not user_data {
        report {"error": "UserData not found"} ;
        disengage;
    }
    self.user_data = user_data;
    role_name = user_data.get_user_role();
    if not role_name {
        report {"error": "User has no target role"} ;
        disengage;
    }
    role_nodes = [root-->(`?Role:name==role_name)];
    if not role_nodes {
        report {"error": "Target Role node not found"} ;
        disengage;
    }
    self.target_role = role_nodes[0];
    visit [-->user_data];
}

impl compute_match_score.extract_matching_skills{
    matched_skills = [
        s
        for s in required_skills
        if s in user_skills
    ];
    return {
        "number_of_matching_skills": len(matched_skills),
        "matching_skills": matched_skills
    };
}

impl compute_match_score.extract_missing_skills{
    missing_skills = [
        s
        for s in required_skills
        if s not in user_skills
    ];
    return {
        "number_of_missing_skills": len(missing_skills),
        "missing_skills": missing_skills
    };
}

sem compute_match_score. get_matched_skills= """
    Task: Identify which 'required_skills' are satisfied by 'user_skills'.
    Rules:
    1. Use semantic similarity (e.g., 'React' satisfies 'Frontend Frameworks').
    2. STRICT: 'matching_skills' must contain ONLY verbatim strings from the 'required_skills' input.
    3. No hallucinations: If a user skill isn't in 'required_skills', ignore it.
    4. Output: Return a MatchResult object. 'number_of_matching_skills' must be len(matching_skills).
""";

sem compute_match_score. get_missing_skills= """
    Task: Identify which 'required_skills' are NOT covered by 'user_skills'.
    Rules:
    1. A skill is missing only if no 'user_skills' are semantically equivalent.
    2. STRICT: 'missing_skills' must contain ONLY verbatim strings from the 'required_skills' input.
    3. Output: Return a MissingSkillResult object. 'number_of_missing_skills' must be len(missing_skills).
""";

impl compute_match_score.calculate_score{
    user_data = here;
    user_skills = [s["name"].lower().strip() for s in self.user_data.get_skills()];
    required_skills = [
        s.canonical_name.lower().strip()
        if s.canonical_name != ""
        else s.name.lower().strip() for s in self.target_role.skill_requirements
    ];
    matched_result = self.get_matched_skills(
        user_skills=user_skills, required_skills=required_skills
    );
    missing_result = self.get_missing_skills(
        user_skills=user_skills, required_skills=required_skills
    );
    self.matched_skills = list(set(matched_result.matching_skills));
    self.missing_skills = list(set(missing_result.missing_skills));
    num_matched = len(self.matched_skills);
    num_required = max(len(required_skills), 1);
    self.score_value = float(min(num_matched, num_required)) / float(num_required);
    score_percentage = self.score_value * 100.0;
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
    self.explanation = explanation;
    match_node = MatchScore(
        score_value=self.score_value,
        matched_skills=self.matched_skills,
        missing_skills=self.missing_skills,
        explanation=self.explanation
    );
    user_data ++> match_node;
    report {
        "score_value": match_node.score_value,
        "matched_skills": match_node.matched_skills,
        "missing_skills": match_node.missing_skills,
        "explanation": match_node.explanation
    } ;
}

impl get_dashboard_data.start{
    visit [-->(`?UserData)];
}

impl get_dashboard_data.collect{
    user_data = here;
    if not user_data {
        report {"success": False, "redirect": "login", "error": "UserData not found"} ;
        disengage;
    }
    target_role_name = user_data.get_target_role();
    if not target_role_name {
        report {
            "success": False,
            "redirect": "onboarding",
            "error": "Target role not set"
        } ;
        disengage;
    }
    jobs = [user_data-->(`?JobPosting)];
    if len(jobs) == 0 {
        root spawn collect_job_postings(target_role=target_role_name);
        jobs = [user_data-->(`?JobPosting)];
    }
    role_nodes = [user_data-->(`?Role:name==target_role_name)];
    role_node = None;
    if len(role_nodes) > 0 {
        role_node = role_nodes[0];
    } else {
        root spawn extract_target_role_requirements(target_role=target_role_name);
        role_nodes = [user_data-->(`?Role:name==target_role_name)];
        role_node = role_nodes[0];
    }
    match_nodes = [user_data-->(`?MatchScore)];
    match_result = None;
    if len(match_nodes) > 0 {
        match_result = match_nodes[0];
    } else {
        match_result = user_data spawn compute_match_score(
            target_role=role_node, user_data=user_data
        );
    }
    learning_path_data = None;
    learning_paths = [user_data-->(`?LearningPath)];
    learning_path = None;
    if len(learning_paths) > 0 {
        learning_path = learning_paths[0];
    } elif match_result.missing_skills and len(match_result.missing_skills) > 0 {
        learning_path = root spawn recommend_learning_path(
            target_role=target_role_name, missing_skills=match_result.missing_skills
        );
    }
    skills = user_data.get_skills() or [];
    resume_summary = user_data.resume_summary or "";
    total_skills = len(skills);
    matched_skills_count = len(match_result.matched_skills or []);
    missing_skills_count = len(match_result.missing_skills or []);
    match_score = match_result.score_value or 0.0;
    if len(learning_paths) > 0 {
        lp = learning_paths[0];
        phases_summary = [
            {
                "phase_title": phase.phase_name,
                "skills_targeted": phase.skills,
                "estimated_time": phase.estimated_time,
                "resources_count": len(phase.resources)
            } for phase in lp.phases
        ];
        resources_summary = [
            {"title": r["title"], "url": r["url"], "provider": r["provider"]}
            for r in lp.resources
        ];
        learning_path_data = {
            "target_role": lp.target_role,
            "missing_skills": lp.missing_skills,
            "phases": phases_summary,
            "resources": resources_summary,
            "total_phases": len(phases_summary),
            "total_resources": len(resources_summary)
        };
    }
    report {
        "success": True,
        "user_email": user_data.email,
        "target_role": role_node.name,
        "role_description": role_node.description or "",
        "skills": skills,
        "resume_summary": resume_summary,
        "match_score": match_score,
        "match_explanation": match_result.explanation or "",
        "matched_skills": match_result.matched_skills or [],
        "missing_skills": match_result.missing_skills or [],
        "total_skills": total_skills,
        "matched_skills_count": matched_skills_count,
        "missing_skills_count": missing_skills_count,
        "job_postings": [
            {
                "title": j.title,
                "company": j.company,
                "location": j.location,
                "posted_at": j.posted_at
            } for j in jobs
        ],
        "learning_path": learning_path_data
    } ;
}

impl recommend_learning_path.get_user_data{
    return [root-->(`?UserData)][0];
}

impl recommend_learning_path.start{
    user_data = self.get_user_data();
    if not user_data {
        report {"error": "UserData not found"} ;
        disengage;
    }
    self.target_role = user_data.get_target_role();
    match_nodes = [user_data-->(`?MatchScore)];
    if not match_nodes or len(match_nodes) == 0 {
        report {"error": "MatchScore not found"} ;
        disengage;
    }
    self.missing_skills = match_nodes[0].missing_skills;
    if not self.target_role {
        report {"error": "User has no target role"} ;
        disengage;
    }
    if not self.missing_skills or len(self.missing_skills) == 0 {
        report {"error": "User has no missing skills"} ;
        disengage;
    }
    visit [-->user_data];
}

impl recommend_learning_path.fetch_and_attach_learning_path{
    user_data = here;
    web = WebSearch();
    resources = web.fetch_learning_resources(
        self.target_role, self.missing_skills, limit=10
    );
    if not resources or len(resources) == 0 {
        report {"error": "No learning resources found for missing skills"} ;
        disengage;
    }
    phases = self.build_learning_phases(self.missing_skills, resources);
    if not phases or len(phases) == 0 {
        report {"error": "Failed to generate learning phases"} ;
        disengage;
    }
    learning_path = LearningPath(
        target_role=self.target_role,
        missing_skills=self.missing_skills,
        phases=phases,
        resources=resources
    );
    print(learning_path);
    user_data ++> learning_path;
    report {
        "target_role": self.target_role,
        "missing_skills_count": len(self.missing_skills),
        "phases_count": len(phases),
        "resources_count": len(resources)
    } ;
}

sem recommend_learning_path. build_learning_phases= """
Generate a structured learning roadmap based on missing skills and resources.

    Args:
        missing_skills: List of skills the user needs to learn.
        resources: List of course/tutorial resources relevant to missing skills.

    Returns:
        List of LearningPhase nodes, each with:
            - phase_name: str, human-readable phase title.
            - skills: list[str], skills covered in this phase.
            - resources: list[str], URLs from the input resources.
            - estimated_time: str, approximate completion time.

    LLM Instructions:
        - Group skills into logical phases (foundational -> advanced).
        - Assign relevant resources to each phase (2–5 URLs per phase).
        - Estimate realistic completion time per phase.
        - Ensure all fields are populated and output is a list of phases.
""";
