package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet({"/admin"})
public class AdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // Chặn truy cập nếu không phải admin
        if (session == null || session.getAttribute("currentUser") == null ||
            Boolean.FALSE.equals(((entity.User) session.getAttribute("currentUser")).getAdmin())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String page = request.getParameter("page");
        String viewPath;

        // Map trang admin giống MainController
        if (page == null || page.isEmpty() || page.equals("home")) {
            viewPath = "/home/views/user/home.jsp";

            int pageSize = 6;
            int currentPage = 1;
            try {
                String p = request.getParameter("p"); // ví dụ: /admin?page=home&p=2
                if (p != null) currentPage = Math.max(1, Integer.parseInt(p));
            } catch (NumberFormatException ignored) {}

            dao.VideoDao videoDao = new dao.VideoDaoImpl();
            long totalItems = videoDao.countAll();
            int totalPages = (int) Math.max(1, Math.ceil(totalItems / (double) pageSize));
            if (currentPage > totalPages) currentPage = totalPages;

            java.util.List<entity.Video> videos = videoDao.findPage(currentPage, pageSize);

            request.setAttribute("videos", videos);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalItems", totalItems);
        } else {
            switch (page) {
                case "video-management":
                    // chuyển qua servlet /admin/videos để đổ dữ liệu
                    response.sendRedirect(request.getContextPath() + "/admin/videos");
                    return;
                case "user-management":
                    viewPath = "/home/views/admin/user_management.jsp";

                    dao.UserDao userDao = new dao.UserDaoImpl();
                    java.util.List<entity.User> users = userDao.findAll();

                    // Log kiểm tra
                    System.out.println("[AdminController] users loaded: " + (users == null ? 0 : users.size()));
                    if (users != null) {
                        users.stream().limit(5).forEach(u ->
                            System.out.println(" - User{id=" + u.getId() + ", email=" + u.getEmail() + ", fullname=" + u.getFullname() + "}")
                        );
                    }

                    request.setAttribute("users", users);
                    break;
                case "favorite-report":
                    viewPath = "/home/views/admin/favorite_report.jsp";
                    break;
                case "favorite-user":
                    viewPath = "/home/views/admin/favorite_user.jsp";
                    break;
                case "shared-friends":
                    viewPath = "/home/views/admin/shared_friends.jsp";
                    break;
                default:
                    viewPath = "/home/views/user/home.jsp";
            }
        }

        request.setAttribute("page", viewPath);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
