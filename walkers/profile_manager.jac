import from byllm.lib { Model }
import from core.llm { llm }
import from models.models { UserData }
walker ProfileManager {
    has user_id: str;

    def get_user_data()  -> UserData {
        return [root-->(`?UserData)][0];
    }

    def get_profile_snapshot()  -> dict[str, any] {
        return self.get_user().get_profile_snapshot();
    }

    def summarize_profile()  -> str by llm(
        method="ReAct", tools=([self.get_profile_snapshot])
    );

    can execute with `root entry;
}
