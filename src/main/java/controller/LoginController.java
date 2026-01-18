package controller;

import dao.UserDao;
import dao.UserDaoImpl;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDao userDao = new UserDaoImpl();

    // Map khóa toàn ứng dụng: key = email (lowercase), value = LockInfo
    @SuppressWarnings("unchecked")
    private Map<String, LockInfo> getLockMap() {
        synchronized (getServletContext()) {
            Map<String, LockInfo> map = (Map<String, LockInfo>) getServletContext().getAttribute("LOGIN_LOCK_MAP");
            if (map == null) {
                map = new ConcurrentHashMap<>();
                getServletContext().setAttribute("LOGIN_LOCK_MAP", map);
            }
            return map;
        }
    }

    private static class LockInfo {
        int failedAttempts;
        long lockUntilMillis; // 0 nếu không khóa

        boolean isLocked(long now) {
            return lockUntilMillis > now;
        }

        long remainSeconds(long now) {
            long ms = Math.max(0, lockUntilMillis - now);
            return Math.max(1, ms / 1000);
        }

        void reset() {
            failedAttempts = 0;
            lockUntilMillis = 0;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("page", "/home/views/user/login.jsp");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String emailRaw = request.getParameter("email");
        String password = request.getParameter("password");

        String emailKey = (emailRaw == null ? "unknown" : emailRaw.trim().toLowerCase());
        long now = System.currentTimeMillis();

        Map<String, LockInfo> lockMap = getLockMap();
        LockInfo info = lockMap.computeIfAbsent(emailKey, k -> new LockInfo());

        // Nếu đang khóa: trả về ngay, kèm countdown
        if (info.isLocked(now)) {
            long remainSec = info.remainSeconds(now);
            System.out.println("[LOGIN] BLOCKED: account locked. remainSec=" + remainSec + ", lockUntil=" + info.lockUntilMillis + ", now=" + now);
            request.setAttribute("error", "Tài khoản tạm khóa. Vui lòng thử lại sau " + remainSec + " giây.");
            request.setAttribute("lockRemain", remainSec);
            request.setAttribute("page", "/home/views/user/login.jsp");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        } else if (info.lockUntilMillis > 0 && !info.isLocked(now)) {
            System.out.println("[LOGIN] UNLOCK: lock expired. Resetting state for " + emailKey);
            info.reset();
        }

        // Tra cứu user
        User user = null;
        if (emailRaw != null && password != null) {
            user = userDao.findByEmail(emailRaw);
        }

        System.out.println("[LOGIN] emailKey=" + emailKey + ", now=" + now + ", info.failedAttempts=" + info.failedAttempts + ", lockUntil=" + info.lockUntilMillis);
        System.out.println("[LOGIN] userLookup: found=" + (user != null) + (user != null ? (", isAdmin=" + Boolean.TRUE.equals(user.getAdmin())) : ""));

        // Sai thông tin: tăng bộ đếm và có thể đặt khóa
        if (user == null || !password.equals(user.getPassword())) {
            info.failedAttempts = info.failedAttempts + 1;
            System.out.println("[LOGIN] INVALID credentials. failedAttempts=" + info.failedAttempts + " for " + emailKey);

            if (info.failedAttempts >= 3) {
                info.lockUntilMillis = now + 30_000;
                info.failedAttempts = 0;
                System.out.println("[LOGIN] SET LOCK: 30s from now. lockUntil=" + info.lockUntilMillis + ", now=" + now);
                request.setAttribute("error", "Bạn đã nhập sai 3 lần. Tài khoản tạm khóa 30 giây.");
                request.setAttribute("lockRemain", 30);
            } else {
                int remain = 3 - info.failedAttempts;
                System.out.println("[LOGIN] WARN: remaining attempts=" + remain + " for " + emailKey);
                request.setAttribute("error", "Email hoặc mật khẩu không đúng. Bạn còn " + remain + " lần thử trước khi bị khóa.");
            }

            request.setAttribute("page", "/home/views/user/login.jsp");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        // ==================== THÊM MỚI: Kiểm tra tài khoản bị khóa ====================
        if (user.getActive() == null || !user.getActive()) {
            System.out.println("[LOGIN] BLOCKED: Account is deactivated for " + emailKey);
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
            request.setAttribute("page", "/home/views/user/login.jsp");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }
        // ==============================================================================

        // Đăng nhập đúng: xóa trạng thái sai/khóa cho email này
        System.out.println("[LOGIN] SUCCESS: " + emailKey + " logged in. Resetting lock state.");
        info.reset();

        // Thiết lập session đăng nhập
        HttpSession session = request.getSession(true);
        session.setAttribute("currentUser", user);

        String ret = request.getParameter("return");
        if (ret != null && !ret.isBlank()) {
            response.sendRedirect(ret);
            return;
        }

        System.out.println("[LOGIN] REDIRECT: " + (Boolean.TRUE.equals(user.getAdmin()) ? "/admin" : "/home?page=home"));
        if (Boolean.TRUE.equals(user.getAdmin())) {
            response.sendRedirect(request.getContextPath() + "/admin");
        } else {
            response.sendRedirect(request.getContextPath() + "/home?page=home");
        }
    }
}
