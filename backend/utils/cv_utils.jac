import magic;
import PyPDF2;
import pytesseract;
import from pdf2image { convert_from_path }
import docx;
import re;
import tempfile;
import shutil;
import traceback;

obj ResumeUtils {
    # (1) Detect file type using python-magic
    def detect_file_type(file_path: str) -> str {
        try {
            file_type = magic.from_file(file_path, mime=True);
            return file_type;
        } except Exception as e {
            print(f"Error detecting file type: {e}");
            return "";
        }
    }

    # (2) Extract text from normal PDF
    def extract_text_pdf(file_path: str) -> str {
        try {
            reader = PyPDF2.PdfReader(file_path);
            text = "";
            for page in reader.pages {
                text += page.extract_text() or "";
            }
            return text;
        } except Exception as e {
            print(f"Error extracting PDF text: {e}");
            return "";
        }
    }

    # (3) OCR scanned PDF
    def extract_text_scanned_pdf(file_path: str) -> str {
        try {
            pages = convert_from_path(file_path);
            text = "";
            for img in pages {
                text += pytesseract.image_to_string(img);
            }
            return text;
        } except Exception as e {
            print(f"Error during OCR of scanned PDF: {e}");
            return "";
        }
    }

    # (4) Extract text from DOCX
    def extract_text_docx(file_path: str) -> str {
        try {
            doc_file = docx.Document(file_path);
            text = "";
            for para in doc_file.paragraphs {
                text += para.text + "\n";
            }
            return text;
        } except Exception as e {
            print(f"Error extracting DOCX text: {e}");
            return "";
        }
    }

    # (5) Clean text for LLM input
    def clean_text(raw: str) -> str {
        if raw is None {
            return "";
        }
        text = raw;
        text = re.sub(r"\s+", " ", text);
        text = re.sub(r"[^\x00-\x7F]+", " ", text);
        text = text.strip();
        return text;
    }

    # (6) Extract text from any resume type, using temp file and handling exceptions
    def extract_text_temp(file_path: str, file_type: str) -> str {
        text = "";
        temp = tempfile.NamedTemporaryFile(delete=True);

        try {
            # Copy user upload to temp
            shutil.copyfile(file_path, temp.name);

            if "pdf" in file_type {
                text = self.extract_text_pdf(temp.name);
                if text.strip() == "" {
                    # Fallback to OCR
                    text = self.extract_text_scanned_pdf(temp.name);
                }
            } elif "word" in file_type or "docx" in file_type {
                text = self.extract_text_docx(temp.name);
            } else {
                print(f"Unsupported file type: {file_type}");
                return "";
            }

            # Clean text before returning
            text = self.clean_text(text);
        } except Exception as e {
            print(f"Error processing resume: {e}");
            print(traceback.format_exc());
            return "";
        } finally {
            # Ensure temp file is deleted
            try {
                temp.close();
            } except Exception as e2 {
                print(f"Error closing temp file: {e2}");
            }
        }

        return text;
    }
}
