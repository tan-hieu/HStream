package controller;

import dao.UserDao;
import dao.UserDaoImpl;
import entity.User;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;
import java.time.LocalDate;

import utils.UploadUtils;

@WebServlet("/user/profile/update")
@MultipartConfig
public class ProfileUpdateController extends HttpServlet {
    private UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Bạn chưa đăng nhập!\"}");
            return;
        }

        User user = (User) session.getAttribute("currentUser");

        String fullname = request.getParameter("fullname");
        String mobile = request.getParameter("mobile");
        String genderStr = request.getParameter("gender");
        String birthdateStr = request.getParameter("birthdate");

        String avatarPathForResponse = null;
        Part avatarPart = null;
        try {
            avatarPart = request.getPart("avatar");
        } catch (IllegalStateException | IOException | ServletException ex) {
            avatarPart = null;
        }

        if (avatarPart != null && avatarPart.getSize() > 0) {
            String contentType = avatarPart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                response.getWriter().write("{\"success\":false,\"message\":\"Tập tin không phải ảnh.\"}");
                return;
            }

            String submitted = avatarPart.getSubmittedFileName();
            String ext = "";
            if (submitted != null && !submitted.isEmpty()) {
                String origName = Paths.get(submitted).getFileName().toString();
                int i = origName.lastIndexOf('.');
                if (i >= 0) ext = origName.substring(i).toLowerCase();
            }
            if (ext.isEmpty()) {
                if ("image/png".equals(contentType)) ext = ".png";
                else if ("image/gif".equals(contentType)) ext = ".gif";
                else ext = ".jpg";
            }

            ServletContext ctx = request.getServletContext();
            File uploadsDir = UploadUtils.getUploadsDir(ctx);

            String idPrefix = String.valueOf(user.getId());
            File[] oldFiles = uploadsDir.listFiles((dir, name) -> name.startsWith(idPrefix + ".") || name.startsWith(idPrefix + "_"));
            if (oldFiles != null) {
                for (File f : oldFiles) {
                    try { f.delete(); } catch (SecurityException ignored) {}
                }
            }

            String newName = idPrefix + ext;
            File savedFile = new File(uploadsDir, newName);

            try (InputStream in = avatarPart.getInputStream();
                 OutputStream out = new FileOutputStream(savedFile)) {
                byte[] buffer = new byte[8192];
                int len;
                while ((len = in.read(buffer)) != -1) {
                    out.write(buffer, 0, len);
                }
            } catch (IOException ex) {
                response.getWriter().write("{\"success\":false,\"message\":\"Lỗi lưu ảnh: " + ex.getMessage() + "\"}");
                return;
            }

            try { savedFile.setReadable(true, false); } catch (SecurityException ignored) {}

            // Lưu vào DB: giữ proxy URL (DB lưu /user/avatar?id=...), file thực tế nằm ở uploadsDir bền vững
            String avatarBase = "/user/avatar?id=" + user.getId();
            user.setAvatar(avatarBase);

            avatarPathForResponse = avatarBase + "&v=" + System.currentTimeMillis();
        }

        user.setFullname(fullname);
        user.setMobile(mobile);
        user.setGender("true".equals(genderStr));
        if (birthdateStr != null && !birthdateStr.isEmpty()) {
            user.setBirthdate(LocalDate.parse(birthdateStr));
        }

        User updated = userDao.update(user);

        if (avatarPathForResponse != null) {
            updated.setAvatar(avatarPathForResponse); // session dùng đường dẫn có v
        }
        session.setAttribute("currentUser", updated);

        StringBuilder json = new StringBuilder();
        json.append("{\"success\":true,\"message\":\"Cập nhật thành công!\"}");
        if (avatarPathForResponse != null) {
            // send avatar separately for client to update immediately
            json = new StringBuilder();
            json.append("{\"success\":true,\"message\":\"Cập nhật thành công!\",\"avatar\":\"")
                .append(avatarPathForResponse).append("\"}");
        }
        response.getWriter().write(json.toString());
    }
}
