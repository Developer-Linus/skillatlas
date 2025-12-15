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
