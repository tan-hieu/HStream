package controller;

import dao.VideoDao;
import dao.VideoDaoImpl;
import entity.Video;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet({"/admin/videos", "/admin/video/update", "/admin/video/delete"})
public class VideoAdminController extends HttpServlet {
    private final VideoDao videoDao = new VideoDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // chỉ cho admin
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("currentUser") == null ||
                Boolean.FALSE.equals(((entity.User) s.getAttribute("currentUser")).getAdmin())) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // đổ list cho trang quản lý
        var videos = videoDao.findAll();
        req.setAttribute("videos", videos);
        req.setAttribute("page", "/home/views/admin/video_management.jsp");
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("currentUser") == null ||
                Boolean.FALSE.equals(((entity.User) s.getAttribute("currentUser")).getAdmin())) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().write("Không có quyền");
            return;
        }

        String path = req.getServletPath();
        if ("/admin/video/delete".equals(path)) {
            handleDelete(req, resp);
            return;
        }

        try {
            req.setCharacterEncoding("UTF-8");

            String idStr = req.getParameter("id");
            String linkYoutube = trimOrNull(req.getParameter("linkYoutube"));
            String title = trimOrNull(req.getParameter("title"));
            String content = trimOrNull(req.getParameter("content"));
            String statusStr = trimOrNull(req.getParameter("status"));
            String postingDateStr = trimOrNull(req.getParameter("postingDate"));
            String thumbnailUrl = trimOrNull(req.getParameter("thumbnailUrl"));
            String channelName = trimOrNull(req.getParameter("channelName"));

            // Validate tất cả các trường bắt buộc
            StringBuilder errors = new StringBuilder();
            
            if (linkYoutube == null || linkYoutube.isBlank()) {
                errors.append("Link Youtube không được để trống. ");
            } else if (!isValidYoutubeLink(linkYoutube)) {
                errors.append("Link Youtube không hợp lệ. ");
            }
            
            if (title == null || title.isBlank()) {
                errors.append("Tiêu đề không được để trống. ");
            }
            
            if (content == null || content.isBlank()) {
                errors.append("Nội dung không được để trống. ");
            }
            
            if (thumbnailUrl == null || thumbnailUrl.isBlank()) {
                errors.append("Ảnh đại diện không được để trống. ");
            } else if (!isValidImageUrl(thumbnailUrl)) {
                errors.append("Link ảnh đại diện không hợp lệ. ");
            }
            
            if (statusStr == null) {
                errors.append("Trạng thái không hợp lệ. ");
            }
            
            if (errors.length() > 0) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.setContentType("text/plain; charset=UTF-8");
                resp.getWriter().write(errors.toString().trim());
                return;
            }

            // Parse trạng thái
            Boolean status = "1".equals(statusStr) || "true".equalsIgnoreCase(statusStr);

            // Quy ước ngày đăng
            java.time.LocalDate postingDate = null;
            if (Boolean.TRUE.equals(status)) {
                if (postingDateStr == null || postingDateStr.isBlank()) {
                    postingDate = java.time.LocalDate.now();
                } else {
                    try {
                        postingDate = java.time.LocalDate.parse(postingDateStr);
                    } catch (Exception ex) {
                        postingDate = java.time.LocalDate.now();
                    }
                }
            } else {
                postingDate = null;
            }

            // Xác định video theo id hoặc link
            entity.Video target;
            if (idStr != null && !idStr.isBlank()) {
                int id = Integer.parseInt(idStr);
                target = new dao.VideoDaoImpl().findById(id);
                if (target == null) {
                    throw new IllegalArgumentException("Không tìm thấy video với ID: " + id);
                }
            } else {
                if (linkYoutube == null || linkYoutube.isBlank()) {
                    throw new IllegalArgumentException("Thiếu ID hoặc Link video.");
                }
                target = new dao.VideoDaoImpl().findByLink(linkYoutube);
                if (target == null) {
                    throw new IllegalArgumentException("Không tìm thấy video với link này.");
                }
            }

            // Cập nhật field
            target.setLinkYoutube(linkYoutube);
            target.setTitle(title);
            target.setContent(content);
            target.setStatus(status);
            target.setPostingDate(postingDate);
            target.setThumbnailUrl(thumbnailUrl);
            target.setChannelName(channelName != null ? channelName : target.getChannelName());

            new dao.VideoDaoImpl().update(target);

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.setContentType("text/plain; charset=UTF-8");
            resp.getWriter().write("Cập nhật thành công");
        } catch (Exception ex) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("text/plain; charset=UTF-8");
            resp.getWriter().write("Cập nhật thất bại: " + ex.getMessage());
        }
    }

    // Kiểm tra link YouTube hợp lệ
    private boolean isValidYoutubeLink(String link) {
        if (link == null || link.isBlank()) return false;
        return link.matches(".*youtube\\.com/embed/[A-Za-z0-9_-]+.*") ||
               link.matches(".*youtube\\.com/watch\\?v=[A-Za-z0-9_-]+.*") ||
               link.matches(".*youtu\\.be/[A-Za-z0-9_-]+.*");
    }

    // Kiểm tra URL ảnh có định dạng hợp lệ
    private boolean isValidImageUrl(String url) {
        if (url == null || url.isBlank()) return false;
        String lower = url.toLowerCase();
        // Phải bắt đầu bằng http:// hoặc https://
        if (!lower.startsWith("http://") && !lower.startsWith("https://")) {
            return false;
        }
        // Cho phép các URL ảnh phổ biến
        return lower.contains(".jpg") || lower.contains(".jpeg") || 
               lower.contains(".png") || lower.contains(".gif") || 
               lower.contains(".webp") || lower.contains(".svg") ||
               lower.contains("ytimg.com") || lower.contains("imgur.com") ||
               lower.contains("cloudinary.com") || lower.contains("unsplash.com") ||
               lower.contains("pexels.com") || lower.contains("pixabay.com") ||
               (lower.startsWith("https://") && lower.length() > 20);
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.isBlank()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("Thiếu id");
                return;
            }
            int id = Integer.parseInt(idStr);
            Video v = videoDao.findById(id);
            if (v == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("Không tìm thấy video");
                return;
            }
            videoDao.deleteById(id);
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.setContentType("text/plain; charset=UTF-8");
            resp.getWriter().write("Xóa thành công");
        } catch (Exception ex) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("text/plain; charset=UTF-8");
            resp.getWriter().write("Xóa thất bại: " + ex.getMessage());
        }
    }

    private String trimOrNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}