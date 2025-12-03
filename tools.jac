# ==========================================================
# CV Parser Module in Jac
# Handles:
#   • PDF (via PyPDF2)
#   • PDF OCR fallback (via pdf2image + pytesseract)
#   • DOCX (via python-docx)
#   • File type detection (via python-magic)
#   • Text cleaning
# ==========================================================
import from PdfReader {
    PyPDF2
}
import io;
import re;
import magic;
import pytesseract;
import python:pdf2image;
import python:docx;

# File type detection
def detect_file_type(file_bytes: bytes) -> str {
    let mime = magic.from_buffer(file_bytes, mime=True);

    if mime == "application/pdf" {
        return "pdf";
    }

    if mime == "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    or mime == "application/msword" {
        return "docx";
    }

    return "unknown";
}

# Extract text from normal PDF
def parse_pdf_text(file_bytes: bytes) -> str {
    let reader = PyPDF2.PdfReader(io.BytesIO(file_bytes));
    let pages = [];

    for page in reader.pages {
        let extracted = page.extract_text();
        if extracted == None {
            pages.append("");
        } else {
            pages.append(extracted);
        }
    }

    return "\n".join(pages);
}

# OCR for scanned pdfs
def parse_pdf_ocr(file_bytes: bytes) -> str {
    let images = pdf2image.convert_from_bytes(file_bytes);
    let text = "";

    for img in images {
        text += pytesseract.image_to_string(img) + "\n";
    }

    return text;
}
# PDF parser with fallback
def parse_pdf(file_bytes: bytes) -> str {
    let txt = parse_pdf_text(file_bytes);

    if txt.strip() == "" {
        txt = parse_pdf_ocr(file_bytes);
    }

    return txt;
}

# DOCX parsing
def parse_docx(file_bytes: bytes) -> str {
    let document = docx.Document(io.BytesIO(file_bytes));
    let paragraphs = [];

    for p in document.paragraphs {
        paragraphs.append(p.text);
    }

    return "\n".join(paragraphs);
}

# Clean the output
def clean_text(text: str) -> str {
    if text == None {
        text = "";
    }

    text = text.replace("\xa0", " ");
    text = re.sub(r"\s+", " ", text);

    return text.strip();
}


# Main entry point
def parse_cv(file_bytes: bytes) -> dict {
    let file_type = detect_file_type(file_bytes);
    let raw = "";

    if file_type == "pdf" {
        raw = parse_pdf(file_bytes);
    }
    elif file_type == "docx" {
        raw = parse_docx(file_bytes);
    }
    else {
        return {
            "status": "error",
            "message": "Unsupported file format"
        };
    }

    let cleaned = clean_text(raw);

    return {
        "status": "success",
        "type": file_type,
        "text": cleaned
    };
}
