package controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;

import dao.UserDao;
import dao.UserDaoImpl;
import entity.User;
import utils.UploadUtils;

@WebServlet("/user/avatar")
public class AvatarController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String v = request.getParameter("v"); // optional version

        if (id == null || id.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        User user = null;
        try {
            user = userDao.findById(Integer.parseInt(id));
        } catch (Exception ignored) {}

        ServletContext ctx = request.getServletContext();
        File uploadsDir = UploadUtils.getUploadsDir(ctx);
        File found = null;

        // Nếu DB chứa một URL tuyệt đối -> redirect
        if (user != null && user.getAvatar() != null) {
            String avatarField = user.getAvatar();
            if (avatarField.startsWith("http://") || avatarField.startsWith("https://")) {
                String redirectUrl = avatarField;
                if (v != null && !v.isEmpty()) {
                    redirectUrl = avatarField + (avatarField.contains("?") ? "&v=" + v : "?v=" + v);
                }
                response.sendRedirect(redirectUrl);
                return;
            }
        }

        // Tìm file local dựa trên id (id.ext hoặc id_*)
        if (uploadsDir != null && uploadsDir.exists()) {
            File[] matches = uploadsDir.listFiles((dir, name) -> name.startsWith(id + ".") || name.startsWith(id + "_"));
            if (matches != null && matches.length > 0) {
                found = matches[0];
            }
        }

        // Nếu không tìm thấy file local -> dùng ảnh mặc định trong webapp (img/ava.png)
        if (found == null) {
            String defaultPath = ctx.getRealPath("/img/ava.png");
            if (defaultPath != null) {
                found = new File(defaultPath);
                if (!found.exists()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        }

        // Cache policy
        if (v != null && !v.isEmpty()) {
            response.setHeader("Cache-Control", "public, max-age=31536000, immutable");
        } else {
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
        }

        String contentType = Files.probeContentType(found.toPath());
        if (contentType == null) contentType = "application/octet-stream";
        response.setContentType(contentType);
        response.setContentLengthLong(found.length());

        try (InputStream in = new FileInputStream(found);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int len;
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
