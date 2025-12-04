import from PdfReader { PyPDF2 }
import io;
import magic;
import pytesseract;
import pdf2image;
import docx;

# File type detection
def detect_file_type(file_bytes: bytes) -> str {
    mime = magic.from_buffer(file_bytes, mime=True);

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
    reader = PyPDF2.PdfReader(io.BytesIO(file_bytes));
    pages = [];

    for page in reader.pages {
        extracted = page.extract_text();
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
    images = pdf2image.convert_from_bytes(file_bytes);
    text = "";

    for img in images {
        text += pytesseract.image_to_string(img) + "\n";
    }

    return text;
}
# PDF parser with fallback
def parse_pdf(file_bytes: bytes) -> str {
    txt = parse_pdf_text(file_bytes);

    if txt.strip() == "" {
        txt = parse_pdf_ocr(file_bytes);
    }

    return txt;
}

# DOCX parsing
def parse_docx(file_bytes: bytes) -> str {
    document = docx.Document(io.BytesIO(file_bytes));
    paragraphs = [];

    for p in document.paragraphs {
        paragraphs.append(p.text);
    }

    return "\n".join(paragraphs);
}

# Clean the output
# LLM-ready text cleaning
def clean_text(text: str | None) -> str {
    if text == None {
        return "";
    }

    # Normalize common PDF/OCR artifacts
    text = text.replace("\xa0", " ");  # non-breaking space
    text = text.replace("\r", " ");  # carriage return
    text = text.replace("\t", " ");  # tabs

    # Remove invisible/control characters
    cleaned = "";
    for ch in text {
        if ch.isprintable() {
            cleaned += ch;
        }
    }

    # Collapse multiple spaces into single space
    cleaned = " ".join(cleaned.split());

    return cleaned.strip();
}
