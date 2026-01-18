package controller;

import dao.UserDao;
import dao.UserDaoImpl;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.EmailService;
import utils.OtpService;

import java.io.IOException;

/**
 * Servlet implementation class VerifyOtpController
 */
@WebServlet({"/verify-otp","/resend-otp"})
public class VerifyOtpController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final UserDao userDao = new UserDaoImpl();
	private final EmailService emailController = new EmailService(
			"smtp.gmail.com",587,"dtanhieu123@gmail.com","rfpl mndo hkxv gpgm",true
	);

    public VerifyOtpController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();

        if ("/verify-otp".equals(path)) {
            handleVerifyOtp(request, response);
        } else if ("/resend-otp".equals(path)) {
            handleResendOtp(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = request.getParameter("email");
        String code = request.getParameter("code");

        if (OtpService.isLocked(session)) {
            long remain = OtpService.getLockRemainMs(session) / 1000;
            forwardOtpPage(request, response, email, "error", "Quá nhiều lần thử không hợp lệ. Vui lòng chờ " + remain + " giây rồi thử lại.");
            return;
        }

        if (email == null || code == null || code.length() != 6) {
            forwardOtpPage(request, response, email, "error", "Mã OTP không hợp lệ.");
            return;
        }

        if (!OtpService.verifyOtp(session, email, code)) {
            int attempts = OtpService.getAttempts(session);
            String msg = OtpService.isLocked(session)
                    ? "Quá 3 lần sai. Vui lòng thử lại sau."
                    : "Mã sai. Lần thử: " + attempts + "/3.";
            forwardOtpPage(request, response, email, "error", msg);
            return;
        }

        User pending = (User) session.getAttribute("PENDING_USER");
        if (pending == null || !email.equals(pending.getEmail())) {
            forwardOtpPage(request, response, email, "error", "Không tìm thấy thông tin người dùng tạm thời.");
            return;
        }

        boolean saved = false;
        try {
            userDao.insert(pending);
            saved = true;
        } catch (Exception e) {
            forwardOtpPage(request, response, email, "error", "Lưu người dùng thất bại.");
            return;
        } finally {
            if (saved) {
                OtpService.clear(session);
            }
        }

        response.sendRedirect(request.getContextPath() + "/home?page=login");
    }

    private void handleResendOtp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (OtpService.isLocked(session)) {
            long remain = OtpService.getLockRemainMs(session) / 1000;
            forwardOtpPage(request, response, null, "error", "Bạn đang bị tạm khóa. Vui lòng thử lại sau " + remain + " giây.");
            return;
        }

        User pending = (User) session.getAttribute("PENDING_USER");
        if (pending == null) {
            forwardOtpPage(request, response, null, "error", "Không có phiên đăng ký để gửi lại OTP.");
            return;
        }

        String otp = OtpService.generateOtp(6);
        OtpService.storeOtp(session, pending.getEmail(), otp);

        String subject = "Mã xác nhận đăng ký tài khoản (gửi lại)";
        String body = "Mã OTP của bạn là: " + otp + ". Mã có hiệu lực trong vòng 5 phút. Vui lòng không chia sẻ mã này với bất kỳ ai.";

        try {
            emailController.sendEmail(pending.getEmail(), subject, body);
        } catch (jakarta.mail.MessagingException ex) {
            forwardOtpPage(request, response, pending.getEmail(), "error", "Gửi email thất bại. Vui lòng thử lại.");
            return;
        }

        forwardOtpPage(request, response, pending.getEmail(), "message", "Gửi lại mã OTP thành công. Vui lòng kiểm tra email.");
    }

    private void forwardOtpPage(HttpServletRequest request, HttpServletResponse response, String email, String attrName, String message) throws ServletException, IOException {
        if (email == null) {
            User pending = (User) request.getSession().getAttribute("PENDING_USER");
            email = pending != null ? pending.getEmail() : null;
        }
        if (attrName != null && message != null) {
            request.setAttribute(attrName, message);
        }
        request.setAttribute("email", email);
        request.setAttribute("page", "home/views/user/send_OTP.jsp");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

}
