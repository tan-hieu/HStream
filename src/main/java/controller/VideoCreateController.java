package controller;

import dao.VideoDao;
import dao.VideoDaoImpl;
import entity.User;
import entity.Video;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/admin/video/create")
public class VideoCreateController extends HttpServlet {
    private final VideoDao videoDao = new VideoDaoImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        // Kiểm tra quyền admin
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null ||
                Boolean.FALSE.equals(((User) session.getAttribute("currentUser")).getAdmin())) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().write("{\"success\":false,\"message\":\"Không có quyền truy cập\"}");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        String channelName = currentUser.getFullname();

        try {
            // Lấy tham số
            String title = trimOrNull(req.getParameter("title"));
            String content = trimOrNull(req.getParameter("content"));
            String thumbnailUrl = trimOrNull(req.getParameter("thumbnailUrl"));
            String linkYoutube = trimOrNull(req.getParameter("linkYoutube"));
            String action = trimOrNull(req.getParameter("action")); // "draft" hoặc "publish"

            // Validate tất cả các trường bắt buộc
            StringBuilder errors = new StringBuilder();
            if (title == null || title.isBlank()) {
                errors.append("Tiêu đề không được để trống. ");
            }
            if (content == null || content.isBlank()) {
                errors.append("Nội dung không được để trống. ");
            }
            if (thumbnailUrl == null || thumbnailUrl.isBlank()) {
                errors.append("Ảnh đại diện không được để trống. ");
            }
            if (linkYoutube == null || linkYoutube.isBlank()) {
                errors.append("Link video YouTube không được để trống. ");
            }

            if (errors.length() > 0) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"success\":false,\"message\":\"" + escapeJson(errors.toString().trim()) + "\"}");
                return;
            }

            // Kiểm tra trùng lặp: link + channelName
            if (videoDao.existsByLinkAndChannel(linkYoutube, channelName)) {
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                resp.getWriter().write("{\"success\":false,\"message\":\"Video với link này đã được bạn đăng trước đó!\"}");
                return;
            }

            // Tạo entity Video
            Video video = new Video();
            video.setTitle(title);
            video.setContent(content);
            video.setThumbnailUrl(thumbnailUrl);
            video.setLinkYoutube(linkYoutube);
            video.setChannelName(channelName);
            video.setViews(0);

            // Xử lý logic lưu nháp vs đăng bài
            if ("publish".equals(action)) {
                video.setStatus(true);
                video.setPostingDate(LocalDate.now());
            } else {
                // Lưu nháp: status = false, không có ngày đăng
                video.setStatus(false);
                video.setPostingDate(null);
            }

            videoDao.insert(video);

            String msg = "publish".equals(action) ? "Đăng bài thành công!" : "Lưu nháp thành công!";
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("{\"success\":true,\"message\":\"" + msg + "\",\"id\":" + video.getId() + "}");

        } catch (Exception ex) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"success\":false,\"message\":\"Lỗi hệ thống: " + escapeJson(ex.getMessage()) + "\"}");
        }
    }

    private String trimOrNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}