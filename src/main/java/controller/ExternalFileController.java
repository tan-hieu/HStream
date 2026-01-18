package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;

/**
 * Servlet implementation class ExternalFileController
 */
@WebServlet("/uploads/*")
public class ExternalFileController extends HttpServlet {
	private String avatarsDir; // absolute path to avatars folder
    private String uploadsBaseDir;
       
    @Override
    public void init() throws ServletException {
        // xác định nơi lưu avatar giống logic trong ProfileController
        String env = System.getenv("AVATAR_UPLOAD_DIR");
        if (env != null && !env.trim().isEmpty()) {
            avatarsDir = env;
        } else {
            String catalinaBase = System.getProperty("catalina.base");
            if (catalinaBase != null && !catalinaBase.trim().isEmpty()) {
                avatarsDir = catalinaBase + File.separator + "uploads" + File.separator + "avatars";
            } else {
                String userDir = System.getProperty("user.dir");
                avatarsDir = userDir + File.separator + "uploads" + File.separator + "avatars";
            }
        }
        File avatarsFolder = new File(avatarsDir);
        if (!avatarsFolder.exists()) avatarsFolder.mkdirs();
        File parent = avatarsFolder.getParentFile();
        if (parent != null) uploadsBaseDir = parent.getAbsolutePath(); // uploads folder
        else uploadsBaseDir = avatarsFolder.getAbsolutePath();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // pathInfo contains e.g. /avatars/uuid.png
        String pathInfo = req.getPathInfo(); 
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Normalize to avoid ../ attacks
        File requested = new File(uploadsBaseDir, pathInfo);
        if (!requested.getCanonicalPath().startsWith(new File(uploadsBaseDir).getCanonicalPath())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!requested.exists() || !requested.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = Files.probeContentType(requested.toPath());
        if (contentType == null) contentType = "application/octet-stream";

        // Caching headers (1 day)
        resp.setHeader("Cache-Control", "public, max-age=86400");
        resp.setHeader("Pragma", "public");
        resp.setContentType(contentType);
        resp.setContentLengthLong(requested.length());

        try (FileInputStream in = new FileInputStream(requested)) {
            byte[] buffer = new byte[8192];
            int len;
            while ((len = in.read(buffer)) != -1) {
                resp.getOutputStream().write(buffer, 0, len);
            }
            resp.getOutputStream().flush();
        }
    }

}
