import from utils.cv_utils { ResumeUtils }
import from core.llm { llm }
walker ResumeParser {
    has uploaded_path: str;
    has utils: ResumeUtils = ResumeUtils();

    # Detect file type
    def detect_resume_type()  -> str {
        return self.utils.detect_file_type(self.uploaded_path);
    }

    # Extract & clean resume text
    def parse_resume()  -> dict[str, any] {
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

    # summarize resume via LLM
    def summarize_resume()  -> str by llm(method="ReAct", tools=([self.parse_resume]));
    can execute with `root entry;
}
