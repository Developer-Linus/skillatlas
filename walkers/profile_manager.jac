import from byllm.lib { Model }
import from models.models { User }
glob llm = Model(model_name="gemini/gemini-2.5-flash", verbose=False);
walker ProfileManager {
    has user_id: str;

    def get_user()  -> User {
        return [root-->(`?User:id==self.user_id)][0];
    }

    def get_profile_snapshot()  -> dict[str, any] {
        return self.get_user().get_profile_snapshot();
    }

    def summarize_profile()  -> str by llm(
        method="ReAct", tools=([self.get_profile_snapshot])
    );

    can execute with entry {
        snapshot = self.get_profile_snapshot();
        summary = self.summarize_profile();
        report {
            "user_id": self.user_id,
            "profile_snapshot": snapshot,
            "profile_summary": summary
        } ;
    }
}
