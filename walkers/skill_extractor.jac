import from walkers.resume_parser { ResumeParser }
import from models.models { User, Skill }
import from edges.edges { has_skill }
import from core.llm { llm }

walker SkillExtractor {
    has user_id: str;
    has resume_parser: ResumeParser;
    has resume_parser_output: str = "";

    def get_user()  -> User {
        return [root-->(`?User:id==self.user_id)][0];
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
