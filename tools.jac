# ==========================================================
# CV Parser Module in Jac
# Handles:
#   • PDF (via PyPDF2)
#   • PDF OCR fallback (via pdf2image + pytesseract)
#   • DOCX (via python-docx)
#   • File type detection (via python-magic)
#   • Text cleaning
# ==========================================================
include utils;
# Main entry point
def parse_cv(file_bytes: bytes) -> dict {
    file_type = detect_file_type(file_bytes);
    raw = "";

    if file_type == "pdf" {
        raw = parse_pdf(file_bytes);
    } elif file_type == "docx" {
        raw = parse_docx(file_bytes);
    } else {
        return {"status": "error", "message": "Unsupported file format"};
    }

    let cleaned = clean_text(raw);

    return {"status": "success", "type": file_type, "text": cleaned};
}
