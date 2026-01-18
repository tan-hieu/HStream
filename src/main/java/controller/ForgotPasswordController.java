package controller;

import dao.UserDao;
import dao.UserDaoImpl;
import entity.User;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.EmailService;
import utils.OtpService;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;

/**
 * Controller xử lý luồng Quên mật khẩu:
 * 1. /forgot-password: Nhập email → kiểm tra tồn tại → gửi OTP
 * 2. /verify-reset-otp: Xác thực mã OTP
 * 3. /resend-reset-otp: Gửi lại mã OTP
 * 4. /reset-password: Đặt lại mật khẩu mới
 */
@WebServlet({"/forgot-password", "/verify-reset-otp", "/resend-reset-otp", "/reset-password"})
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Regex kiểm tra email Gmail hợp lệ
    private static final String GMAIL_REGEX = "^[a-zA-Z0-9._%+-]+@gmail\\.com$";

    // Regex kiểm tra mật khẩu ít nhất 6 chữ số
    private static final String PASSWORD_REGEX = "^\\d{6,}$";

    private final UserDao userDao = new UserDaoImpl();

    // Cấu hình Email Service - NÊN ĐƯA VÀO FILE CONFIG HOẶC BIẾN MÔI TRƯỜNG
    private final EmailService emailService = new EmailService(
            "smtp.gmail.com",
            587,
            "dtanhieu123@gmail.com",
            "rfpl mndo hkxv gpgm",
            true
    );

    // ==================== HANDLE GET REQUEST ====================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch (path) {
            case "/forgot-password":
                // Hiển thị trang nhập email
                forwardToForgotPassword(request, response);
                break;
            default:
                // Các URL khác redirect về trang quên mật khẩu
                response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }

    // ==================== HANDLE POST REQUEST ====================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đảm bảo encoding UTF-8 cho tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/forgot-password":
                handleForgotPassword(request, response);
                break;
            case "/verify-reset-otp":
                handleVerifyResetOtp(request, response);
                break;
            case "/resend-reset-otp":
                handleResendResetOtp(request, response);
                break;
            case "/reset-password":
                handleResetPassword(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }

    // ==================== BƯỚC 1: NHẬP EMAIL & GỬI OTP ====================
    /**
     * Xử lý bước 1: Nhập email
     * - Kiểm tra email không được để trống
     * - Kiểm tra email có đuôi @gmail.com
     * - Kiểm tra email có tồn tại trong database
     * - Nếu hợp lệ: Tạo OTP, lưu session, gửi email, chuyển trang xác thực
     */
    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        
        // 1. Kiểm tra email không được để trống
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email.");
            request.setAttribute("emailValue", "");
            forwardToForgotPassword(request, response);
            return;
        }
        
        email = email.trim().toLowerCase(); // Chuẩn hóa email về chữ thường
        
        // 2. Kiểm tra định dạng email phải là @gmail.com
        if (!email.matches(GMAIL_REGEX)) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ Gmail hợp lệ (vd: example@gmail.com).");
            request.setAttribute("emailValue", email);
            forwardToForgotPassword(request, response);
            return;
        }
        
        // 3. Kiểm tra email có tồn tại trong database không
        User user = userDao.findByEmail(email);
        if (user == null) {
            request.setAttribute("error", "Email này chưa được đăng ký. Vui lòng kiểm tra lại hoặc đăng ký tài khoản mới.");
            request.setAttribute("emailValue", email);
            forwardToForgotPassword(request, response);
            return;
        }
        
        // 4. Tạo OTP và lưu vào session
        HttpSession session = request.getSession(true);
        
        // Xóa OTP cũ nếu có
        OtpService.clear(session);
        
        // Tạo OTP mới 6 chữ số
        String otp = OtpService.generateOtp(6);
        
        // Lưu OTP và email vào session
        OtpService.storeOtp(session, email, otp);
        session.setAttribute("RESET_PASSWORD_EMAIL", email);
        session.setAttribute("RESET_USER_ID", user.getId());
        
        // 5. Gửi email chứa mã OTP
        String subject = "🔐 Mã xác nhận khôi phục mật khẩu - Video Sharing";
        String body = buildOtpEmailBody(user.getFullname(), otp);
        
        try {
            emailService.sendEmail(email, subject, body);
        } catch (MessagingException ex) {
            ex.printStackTrace();
            // Xóa session nếu gửi email thất bại
            OtpService.clear(session);
            session.removeAttribute("RESET_PASSWORD_EMAIL");
            session.removeAttribute("RESET_USER_ID");
            
            request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại sau.");
            request.setAttribute("emailValue", email);
            forwardToForgotPassword(request, response);
            return;
        }
        
        // 6. Chuyển sang trang nhập OTP
        request.setAttribute("email", email);
        request.setAttribute("message", "Mã xác nhận đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư.");
        forwardToVerifyOtp(request, response);
    }

    // ==================== BƯỚC 2: XÁC THỰC OTP ====================
    /**
     * Xử lý bước 2: Xác thực mã OTP
     * - Kiểm tra đã bị khóa do nhập sai quá nhiều lần chưa
     * - Kiểm tra OTP có hợp lệ không (đúng mã, chưa hết hạn)
     * - Nếu đúng: Đánh dấu đã xác thực, chuyển trang đổi mật khẩu
     * - Nếu sai: Tăng số lần thử, nếu >= 3 lần thì khóa 30 giây
     */
    private void handleVerifyResetOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Kiểm tra session hợp lệ
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        
        String sessionEmail = (String) session.getAttribute("RESET_PASSWORD_EMAIL");
        String inputEmail = request.getParameter("email");
        String inputCode = request.getParameter("code");
        
        // Kiểm tra email trong session
        if (sessionEmail == null || !sessionEmail.equals(inputEmail)) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        
        // 1. Kiểm tra đang bị khóa không
        if (OtpService.isLocked(session)) {
            long remainSeconds = OtpService.getLockRemainMs(session) / 1000;
            request.setAttribute("email", sessionEmail);
            request.setAttribute("error", "Bạn đã nhập sai quá nhiều lần. Vui lòng chờ " + remainSeconds + " giây.");
            forwardToVerifyOtp(request, response);
            return;
        }
        
        // 2. Kiểm tra OTP có được nhập không
        if (inputCode == null || inputCode.trim().isEmpty()) {
            request.setAttribute("email", sessionEmail);
            request.setAttribute("error", "Vui lòng nhập mã OTP.");
            forwardToVerifyOtp(request, response);
            return;
        }
        
        inputCode = inputCode.trim();
        
        // 3. Kiểm tra OTP phải đúng 6 chữ số
        if (!inputCode.matches("^\\d{6}$")) {
            request.setAttribute("email", sessionEmail);
            request.setAttribute("error", "Mã OTP phải gồm 6 chữ số.");
            forwardToVerifyOtp(request, response);
            return;
        }
        
        // 4. Kiểm tra OTP còn hiệu lực không (chưa hết hạn)
        if (!OtpService.isOtpValid(session)) {
            request.setAttribute("email", sessionEmail);
            request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã mới.");
            forwardToVerifyOtp(request, response);
            return;
        }
        
        // 5. Xác thực OTP
        boolean isValid = OtpService.verifyOtp(session, sessionEmail, inputCode);
        
        if (!isValid) {
            int attempts = OtpService.getAttempts(session);
            int remainingAttempts = 3 - attempts;
            
            String errorMsg;
            if (remainingAttempts <= 0) {
                long lockSeconds = OtpService.getLockRemainMs(session) / 1000;
                errorMsg = "Bạn đã nhập sai quá 3 lần. Vui lòng chờ " + lockSeconds + " giây rồi thử lại.";
            } else {
                errorMsg = "Mã OTP không đúng. Bạn còn " + remainingAttempts + " lần thử.";
            }
            
            request.setAttribute("email", sessionEmail);
            request.setAttribute("error", errorMsg);
            forwardToVerifyOtp(request, response);
            return;
        }
        
        // 6. OTP đúng - Đánh dấu đã xác thực và chuyển trang đổi mật khẩu
        session.setAttribute("RESET_OTP_VERIFIED", true);
        session.setAttribute("RESET_OTP_VERIFIED_TIME", System.currentTimeMillis());
        
        request.setAttribute("email", sessionEmail);
        request.setAttribute("message", "Xác thực thành công! Vui lòng đặt mật khẩu mới.");
        forwardToResetPassword(request, response);
    }

    // ==================== BƯỚC 2 PHỤ: GỬI LẠI OTP ====================
    /**
     * Xử lý gửi lại mã OTP
     * - Kiểm tra đang bị khóa không
     * - Tạo OTP mới, lưu session, gửi email
     */
    private void handleResendResetOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        
        String sessionEmail = (String) session.getAttribute("RESET_PASSWORD_EMAIL");
        
        if (sessionEmail == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        
        // 1. Kiểm tra đang bị khóa không
        if (OtpService.isLocked(session)) {
            long remainSeconds = OtpService.getLockRemainMs(session) / 1000;
            request.setAttribute("email", sessionEmail);
            request.setAttribute("error", "Vui lòng chờ " + remainSeconds + " giây trước khi gửi lại mã.");
            forwardToVerifyOtp(request, response);
            return;
        }
        
        // 2. Kiểm tra user còn tồn tại trong DB không
        User user = userDao.findByEmail(sessionEmail);
        if (user == null) {
            OtpService.clear(session);
            session.removeAttribute("RESET_PASSWORD_EMAIL");
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        
        // 3. Tạo OTP mới và lưu session
        String newOtp = OtpService.generateOtp(6);
        OtpService.storeOtp(session, sessionEmail, newOtp);
        
        // 4. Gửi email
        String subject = "🔐 Mã xác nhận khôi phục mật khẩu (Gửi lại) - Video Sharing";
        String body = buildOtpEmailBody(user.getFullname(), newOtp);
        
        try {
            emailService.sendEmail(sessionEmail, subject, body);
        } catch (MessagingException ex) {
            ex.printStackTrace();
            request.setAttribute("email", sessionEmail);
            request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại sau.");
            forwardToVerifyOtp(request, response);
            return;
        }
        
        // 5. Thông báo thành công
        request.setAttribute("email", sessionEmail);
        request.setAttribute("message", "Đã gửi lại mã OTP thành công. Vui lòng kiểm tra email.");
        forwardToVerifyOtp(request, response);
    }

    // ==================== BƯỚC 3: ĐẶT LẠI MẬT KHẨU ====================
    /**
     * Xử lý bước 3: Đặt lại mật khẩu mới
     * - Kiểm tra đã xác thực OTP chưa (bảo mật)
     * - Kiểm tra thời gian xác thực (không quá 10 phút)
     * - Validate mật khẩu: 6 chữ số, 2 lần nhập phải khớp
     * - Lưu mật khẩu mới vào database
     */
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // 1. Kiểm tra session hợp lệ
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String sessionEmail = (String) session.getAttribute("RESET_PASSWORD_EMAIL");
        Boolean otpVerified = (Boolean) session.getAttribute("RESET_OTP_VERIFIED");
        Long verifiedTime = (Long) session.getAttribute("RESET_OTP_VERIFIED_TIME");
        String inputEmail = request.getParameter("email");

        // 2. Kiểm tra bảo mật: Email phải khớp và đã xác thực OTP
        if (sessionEmail == null || !sessionEmail.equals(inputEmail) ||
            otpVerified == null || !otpVerified) {
            // Có thể là tấn công - redirect về đầu
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        // 3. Kiểm tra thời gian xác thực (không quá 10 phút)
        if (verifiedTime != null) {
            long elapsed = System.currentTimeMillis() - verifiedTime;
            long maxTime = 10 * 60 * 1000; // 10 phút
            if (elapsed > maxTime) {
                clearResetSession(session);
                request.setAttribute("error", "Phiên làm việc đã hết hạn. Vui lòng thực hiện lại.");
                forwardToForgotPassword(request, response);
                return;
            }
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // 4. Kiểm tra mật khẩu mới không được để trống
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("email", sessionEmail);
            request.setAttribute("error", "Vui lòng nhập mật khẩu mới.");
            forwardToResetPassword(request, response);
            return;
        }

        newPassword = newPassword.trim();

        // 5. Kiểm tra mật khẩu phải có ít nhất 6 chữ số
        if (!newPassword.matches(PASSWORD_REGEX)) {
            request.setAttribute("email", sessionEmail);
            request.setAttribute("error", "Mật khẩu phải gồm ít nhất 6 chữ số (0-9).");
            forwardToResetPassword(request, response);
            return;
        }

        // 6. Kiểm tra mật khẩu xác nhận không được để trống
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("email", sessionEmail);
            request.setAttribute("error", "Vui lòng nhập lại mật khẩu xác nhận.");
            forwardToResetPassword(request, response);
            return;
        }

        confirmPassword = confirmPassword.trim();

        // 7. Kiểm tra 2 mật khẩu phải khớp nhau
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("email", sessionEmail);
            request.setAttribute("error", "Mật khẩu xác nhận không khớp. Vui lòng nhập lại.");
            forwardToResetPassword(request, response);
            return;
        }

        // 8. Tìm user trong database
        User user = userDao.findByEmail(sessionEmail);
        if (user == null) {
            clearResetSession(session);
            request.setAttribute("error", "Tài khoản không tồn tại. Vui lòng thử lại.");
            forwardToForgotPassword(request, response);
            return;
        }

        // 9. Cập nhật mật khẩu mới
        // LƯU Ý: Trong thực tế nên hash mật khẩu trước khi lưu
        // Ví dụ: user.setPassword(hashPassword(newPassword));
        user.setPassword(newPassword);

        try {
            userDao.update(user);
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("email", sessionEmail);
            request.setAttribute("error", "Đổi mật khẩu thất bại. Vui lòng thử lại sau.");
            forwardToResetPassword(request, response);
            return;
        }

        // 10. Xóa session và chuyển về trang đăng nhập
        clearResetSession(session);

        request.setAttribute("message", "🎉 Đổi mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
        request.setAttribute("page", "/home/views/user/login.jsp");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    // ==================== HELPER METHODS ====================
    
    /**
     * Forward đến trang nhập email (Bước 1)
     */
    private void forwardToForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("page", "/home/views/user/forgot_password.jsp");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
    
    /**
     * Forward đến trang xác thực OTP (Bước 2)
     */
    private void forwardToVerifyOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("page", "/home/views/user/verify_reset_otp.jsp");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
    
    /**
     * Forward đến trang đặt mật khẩu mới (Bước 3)
     */
    private void forwardToResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("page", "/home/views/user/reset_password.jsp");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
    
    /**
     * Xóa toàn bộ session liên quan đến reset password
     */
    private void clearResetSession(HttpSession session) {
        if (session != null) {
            session.removeAttribute("RESET_PASSWORD_EMAIL");
            session.removeAttribute("RESET_USER_ID");
            session.removeAttribute("RESET_OTP_VERIFIED");
            session.removeAttribute("RESET_OTP_VERIFIED_TIME");
            OtpService.clear(session);
        }
    }
    
    /**
     * Tạo nội dung email HTML chứa mã OTP
     */
    private String buildOtpEmailBody(String fullname, String otp) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head><meta charset='UTF-8'></head>" +
                "<body style='font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;'>" +
                "<div style='max-width: 500px; margin: 0 auto; background: #ffffff; border-radius: 10px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);'>" +
                "<h2 style='color: #6366f1; text-align: center;'>🔐 Khôi phục mật khẩu</h2>" +
                "<p>Xin chào <strong>" + fullname + "</strong>,</p>" +
                "<p>Bạn đã yêu cầu khôi phục mật khẩu cho tài khoản của mình.</p>" +
                "<p>Mã xác nhận của bạn là:</p>" +
                "<div style='text-align: center; margin: 20px 0;'>" +
                "<span style='display: inline-block; font-size: 32px; font-weight: bold; color: #6366f1; background: #f0f0ff; padding: 15px 30px; border-radius: 8px; letter-spacing: 5px;'>" + otp + "</span>" +
                "</div>" +
                "<p style='color: #666;'>⏰ Mã có hiệu lực trong vòng <strong>5 phút</strong>.</p>" +
                "<p style='color: #e74c3c;'>⚠️ Vui lòng không chia sẻ mã này với bất kỳ ai.</p>" +
                "<hr style='border: none; border-top: 1px solid #eee; margin: 20px 0;'>" +
                "<p style='color: #999; font-size: 12px; text-align: center;'>Nếu bạn không yêu cầu đổi mật khẩu, vui lòng bỏ qua email này.</p>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
    
    /**
     * Hash mật khẩu bằng SHA-256 (Tùy chọn - nên dùng trong thực tế)
     */
    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Không thể hash mật khẩu", e);
        }
    }
}