package controller;

import entity.User;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

/**
 * Servlet Filter implementation class AuthFilter
 */
@WebFilter("/*")
public class AuthFilter extends HttpFilter {
    // Các trang công khai không cần đăng nhập (không dùng null trong Set.of)
    private static final Set<String> PUBLIC_HOME_PAGES = Set.of(
            "", "home", "login", "register", "forgot-password", "verify-otp", "resend-otp", "details"
    );

    private static boolean isStatic(String uri) {
        return uri.startsWith("/assets/")
                || uri.startsWith("/img/")
                || uri.endsWith(".css")
                || uri.endsWith(".js")
                || uri.endsWith(".png")
                || uri.endsWith(".jpg")
                || uri.endsWith(".jpeg")
                || uri.endsWith(".svg")
                || uri.endsWith(".ico")
                || uri.endsWith(".map");
    }

    private static boolean isPublicHomePage(String page) {
        return page == null || PUBLIC_HOME_PAGES.contains(page);
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String ctx = request.getContextPath();
        String uri = request.getRequestURI().substring(ctx.length()); // ví dụ: /home, /admin
        String page = request.getParameter("page"); // dùng cho /home?page=...

        // Cho phép tài nguyên tĩnh
        if (isStatic(uri)) {
            chain.doFilter(req, res);
            return;
        }

        // Cho phép các endpoint công khai
        boolean isPublicEndpoint =
                uri.equals("/") ||
                uri.equals("") ||                  // trường hợp /context không có dấu /
                uri.equals("/login") ||
                uri.equals("/register") ||
                uri.equals("/verify-otp") ||
                uri.equals("/resend-otp") ||
                // === THÊM CÁC ENDPOINT QUÊN MẬT KHẨU ===
                uri.equals("/forgot-password") ||
                uri.equals("/verify-reset-otp") ||
                uri.equals("/resend-reset-otp") ||
                uri.equals("/reset-password") ||
                // Chỉ cho phép /home với các page công khai
                (uri.equals("/home") && isPublicHomePage(page));

        if (isPublicEndpoint) {
            chain.doFilter(req, res);
            return;
        }

        // Kiểm tra đăng nhập
        User current = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (current == null) {
            // Lưu URL để quay lại sau khi đăng nhập
            String returnUrl = request.getRequestURI() +
                    (request.getQueryString() != null ? "?" + request.getQueryString() : "");
            request.getSession(true).setAttribute("returnUrl", returnUrl);
            response.sendRedirect(ctx + "/home?page=login");
            return;
        }

        chain.doFilter(req, res);
    }
}
