import from core.llm { llm }
import from models.models {
    User,
    Skill,
    Role,
    Course,
    JobPosting,
    Certification,
    Industry,
    SkillGap,
    SkillCluster,
    Trend,
    LearninPath,
    MatchScore,
    UserRole,
    SeniorityLevel
}
import from edges.edges { has_skill, requires_skill, SkillDifficulty }
import from walkers.profile_manager { ProfileManager }
import from walkers.resume_parser { ResumeParser }
import from walkers.skill_extractor { SkillExtractor }

with entry {
    skill_python = Skill(id="s1", name="Python");
    root ++> skill_python;

    skill_ml = Skill(id="s2", name="Machine Learning");
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

    user1.add_skill("Python", 4);
    user1.add_skill("Machine Learning", 2);
    user1.add_skill("SQL", 3);
    user1.update_skill("Python", 5);

    role_ds = Role(
        id="r1",
        name="Data Scientist",
        seniority_level=SeniorityLevel.JUNIOR.value,
        average_salary=60000
    );
    root ++> role_ds;

    # Role → Skill required edges
    role_ds +>: requires_skill(required_level=1) :+> skill_python;
    role_ds +>: requires_skill(required_level=2) :+> skill_ml;

    # root spawn ProfileManager(user_id="u1");
    # root spawn ResumeParser(uploaded_path="./sample_resumes/john_resume.pdf");
    root spawn SkillExtractor(
        user_id="u1",
        resume_parser=ResumeParser(uploaded_path="./sample_resumes/john_resume.pdf")
    );
}
