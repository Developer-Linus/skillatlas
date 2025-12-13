import from backend.walkers.resume_parser { ResumeParser }
import from backend.models.models { UserData, Skill }
import from backend.edges.edges { has_skill }
import from core.llm { llm }

walker SkillExtractor {
    has resume_parser: ResumeParser;
    has resume_parser_output: str = "";

    def get_user_data()  -> UserData {
        return [root-->(`?UserData)][0];
    }

    def get_resume_text()  -> str {
        resume_data = self.resume_parser.parse_resume();
        self.resume_parser_output = resume_data["text"];
        return self.resume_parser_output;
    }

    def extract_skills()  -> list[Skill] by llm(
        method="ReAct", tools=([self.get_resume_text])
    );

    can extract with `root entry;
}
