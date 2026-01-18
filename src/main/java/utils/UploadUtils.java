package utils;

import jakarta.servlet.ServletContext;
import java.io.File;

public class UploadUtils {
    public static File getUploadsDir(ServletContext ctx) {
        String configured = System.getProperty("app.uploads.dir");
        if (configured == null || configured.trim().isEmpty()) {
            configured = System.getenv("APP_UPLOADS_DIR");
        }

        File base;
        if (configured != null && !configured.trim().isEmpty()) {
            base = new File(configured);
        } else {
            base = new File(System.getProperty("user.home"), "ASM_JAVA4_uploads");
        }

        File avatars = new File(base, "avatars");
        if (!avatars.exists()) avatars.mkdirs();
        return avatars;
    }
}
