package controller;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import entity.Video;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Servlet implementation class MainController
 */
@WebServlet({"/home"})
public class MainController extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public MainController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String page = request.getParameter("page");
        if (request.getRequestURI().equals(request.getContextPath() + "/admin")) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        String viewPath = "";

        if (page == null || page.isEmpty() || page.equals("home")) {
            viewPath = "/home/views/user/home.jsp";
        } else {
            switch (page) {
                case "login":
                    viewPath = "/home/views/user/login.jsp";
                    break;
                case "register":
                    viewPath = "/home/views/user/register.jsp";
                    break;
                case "like":
                    viewPath = "/home/views/user/like.jsp";
                    break;
                case "share":
                    viewPath = "/home/views/user/share.jsp";
                    break;
                case "rest_password":
                    viewPath = "/home/views/user/rest_password.jsp";
                    break;
                case "forgot-password":
                    viewPath = "/home/views/user/forgot_password.jsp";
                    break;
                case "details":
                    viewPath = "/home/views/user/details_page.jsp";
                    break;
                case "history":
                    viewPath = "/home/views/user/history.jsp";
                    break;
                case "profile":
                    viewPath = "/home/views/user/profile.jsp";
                    break;
                // Admin pages
                case "video-management":
                    viewPath = "/home/views/admin/video_management.jsp";
                    break;
                case "user-management":
                    viewPath = "/home/views/admin/user_management.jsp";
                    break;
                case "favorite-report":
                    viewPath = "/home/views/admin/favorite_report.jsp";
                    break;
                case "shared-friends":
                    viewPath = "/home/views/admin/shared_friends.jsp";
                    break;
                default:
                    viewPath = "/home/views/user/home.jsp";
            }
        }

        // Đổ dữ liệu cho Home (phân trang) hoặc Details (chi tiết video)
        if (page == null || page.isEmpty() || "home".equals(page)) {
            int pageSize = 6;
            int currentPage = 1;
            try {
                String p = request.getParameter("p");
                if (p != null) currentPage = Math.max(1, Integer.parseInt(p));
            } catch (NumberFormatException ignored) {}

            VideoDao videoDao = new VideoDaoImpl();
            
            // THÊM: Lấy từ khóa tìm kiếm
            String searchKeyword = request.getParameter("search");
            if (searchKeyword != null) {
                searchKeyword = searchKeyword.trim();
                if (searchKeyword.isEmpty()) searchKeyword = null;
            }
            
            long totalItems;
            List<entity.Video> videos;
            
            if (searchKeyword != null) {
                // Tìm kiếm theo từ khóa
                totalItems = videoDao.countByKeyword(searchKeyword);
                int totalPages = (int) Math.max(1, Math.ceil(totalItems / (double) pageSize));
                if (currentPage > totalPages) currentPage = totalPages;
                videos = videoDao.findPageByKeyword(searchKeyword, currentPage, pageSize);
                request.setAttribute("searchKeyword", searchKeyword);
            } else {
                // Không tìm kiếm - lấy tất cả
                totalItems = videoDao.countAll();
                int totalPages = (int) Math.max(1, Math.ceil(totalItems / (double) pageSize));
                if (currentPage > totalPages) currentPage = totalPages;
                videos = videoDao.findPage(currentPage, pageSize);
            }
            
            int totalPages = (int) Math.max(1, Math.ceil(totalItems / (double) pageSize));

            request.setAttribute("videos", videos);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalItems", totalItems);
        } else if ("details".equals(page)) {
            // Lấy video theo id, tăng view, lấy video liên quan + bình luận
            int id;
            try {
                id = Integer.parseInt(request.getParameter("id"));
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            VideoDao videoDao = new VideoDaoImpl();
            Video v = videoDao.findById(id);
            if (v == null || v.getStatus() == null || !v.getStatus()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            // Tăng view
            videoDao.incrementViews(id);

            // Tính embed URL từ LinkYoutube
            String embedUrl = toEmbedUrl(v.getLinkYoutube());

            // Lấy video liên quan
            List<Video> related = videoDao.findRelated(id, 7);

            // Lấy bình luận
            CommentDao commentDao = new CommentDaoImpl();
            var comments = commentDao.findByVideoId(id);

            request.setAttribute("video", v);
            request.setAttribute("embedUrl", embedUrl);
            request.setAttribute("relatedVideos", related);
            request.setAttribute("comments", comments);

            var currentUser = request.getSession(false) == null ? null : request.getSession(false).getAttribute("currentUser");
            if (currentUser != null) {
                dao.FavouriteDao favDao = new dao.FavouriteDaoImpl();
                boolean isLiked = favDao.exists(((entity.User) currentUser).getId(), v.getId());
                long totalLikes = favDao.countByVideo(v.getId());
                request.setAttribute("isLiked", isLiked);
                request.setAttribute("totalLikes", totalLikes);
            } else {
                dao.FavouriteDao favDao = new dao.FavouriteDaoImpl();
                long totalLikes = favDao.countByVideo(v.getId());
                request.setAttribute("isLiked", false);
                request.setAttribute("totalLikes", totalLikes);
            }
        } else if ("like".equals(page)) {
            var session = request.getSession(false);
            var currentUser = (session == null) ? null : session.getAttribute("currentUser");
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/home?page=login");
                return;
            }
            int userId = ((entity.User) currentUser).getId();
            FavouriteDao favDao = new FavouriteDaoImpl();
            List<Video> likedVideos = favDao.findLikedVideos(userId);
            if (request.getParameter("shuffle") != null) {
                java.util.Collections.shuffle(likedVideos);
            }
            request.setAttribute("likedVideos", likedVideos);
            request.setAttribute("likedCount", favDao.countByUser(userId));
        }

        request.setAttribute("page", viewPath);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    // Chuyển LinkYoutube -> embed URL
    private String toEmbedUrl(String link) {
        if (link == null || link.isBlank()) return "";
        // Đã là embed
        if (link.contains("/embed/")) return link;

        String id = null;
        Pattern p = Pattern.compile("(?:youtu\\.be/|v=)([A-Za-z0-9_-]{6,})");
        Matcher m = p.matcher(link);
        if (m.find()) {
            id = m.group(1);
        }
        return (id != null) ? "https://www.youtube.com/embed/" + id : link;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
