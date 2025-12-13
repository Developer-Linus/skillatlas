import base64;
import os;
import time;

walker StoreCVFile {
    has file_name: str;
    has file_data_b64: str;
    has upload_dir: str = "uploads";

    can ensure_dir_exists with `root entry {
        if not os.path.exists(self.upload_dir) {
            os.makedirs(self.upload_dir);
        }
        report {"status": "dir_ready", "dir": self.upload_dir} ;
    }

    can save_file with `root entry {
        self.ensure_dir_exists();

        timestamp = str(int(time.time()));
        final_path = os.path.join(self.upload_dir, timestamp + "_" + self.file_name);

        try {
            raw_bytes = base64.b64decode(self.file_data_b64);
            with open(final_path, "wb") as f {
                f.write(raw_bytes);
            }

            report {"status": "success", "path": final_path} ;
        } except Exception as e {
            report {"status": "error", "error": str(e)} ;
        }
    }
}
