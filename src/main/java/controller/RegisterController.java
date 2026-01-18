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
import utils.EmailService;
import utils.OtpService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/register")
public class RegisterController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final UserDao userDao = new UserDaoImpl();

	private final EmailService emailController = new EmailService(
			"smtp.gmail.com",587,"dtanhieu123@gmail.com","rfpl mndo hkxv gpgm",true
	);

    public RegisterController() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		forwardBack(request,response);
	}

	private void forwardBack(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setAttribute("page", "home/views/user/register.jsp");
		request.getRequestDispatcher("/index.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String fullname = request.getParameter("fullname");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String genderStr = request.getParameter("gender");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
		String birthdateStr = request.getParameter("birthdate");

		if (fullname == null || fullname.trim().length() < 3){
			request.setAttribute("error","Họ và tên ít nhất 3 ký tự");
			forwardBack(request,response);
			return;
		}
		if (phone == null || !phone.matches("^0\\d{9}$")){
			request.setAttribute("error","Số điện thoại gồm 10 chữ số và bắt đầu bằng 0");
			forwardBack(request,response);
			return;
		}
		if (genderStr == null || !(genderStr.equals("male") || genderStr.equals("female"))){
			request.setAttribute("error","Vui lòng chọn giới tính");
			forwardBack(request,response);
			return;
		}
		if (birthdateStr == null){
			request.setAttribute("error","Vui lòng chọn ngày sinh");
			forwardBack(request,response);
			return;
		}
		LocalDate birthdate;
		try {
			birthdate = LocalDate.parse(birthdateStr);
			if (birthdate.isAfter(LocalDate.now())) {
				request.setAttribute("error","Ngày sinh không hợp lệ");
				forwardBack(request,response);
				return;
			}
		} catch (Exception e) {
			request.setAttribute("error","Ngày sinh không hợp lệ");
			forwardBack(request,response);
			return;
		}
		if (email == null || !email.matches("^[a-zA-Z0-9._%+-]+@gmail\\.com$")){
			request.setAttribute("error","Email không hợp lệ hoặc không phải gmail");
			forwardBack(request,response);
			return;
		}
		if (password == null || !password.matches("^\\d{6,}$")){
			request.setAttribute("error","Mật khẩu gồm ít nhất 6 ký tự số");
			forwardBack(request,response);
			return;
		}
		if (!password.equals(confirmPassword)){
			request.setAttribute("error","Mật khẩu xác nhận không khớp");
			forwardBack(request,response);
			return;
		}
		if (userDao.existsByEmail(email)){
			request.setAttribute("error","Email đã được đăng ký");
			forwardBack(request,response);
			return;
		}

		boolean isMale = genderStr.equals("male");

		User pendingUser = User.builder()
				.email(email)
				.password(password)
				.fullname(fullname.trim())
				.mobile(phone)
				.birthdate(birthdate)
				.gender(isMale)
				.admin(false)
				.active(true)
				.createdDate(LocalDateTime.now()) // <- thêm dòng này
				.build();

		request.getSession().setAttribute("PENDING_USER",pendingUser);

//		try {
//			userDao.insert(pendingUser);
//		}catch (Exception e){
//			request.setAttribute("error","Đăng ký thất bại. Vui lòng thử lại.");
//			forwardBack(request,response);
//			return;
//		}

		String otp = OtpService.generateOtp(6);
		OtpService.storeOtp(request.getSession(),email,otp);

		String subject = "Mã xác nhận đăng ký tài khoản";
		String body = "Xin chào " + fullname + ",Mã OTP của bạn là: " + otp + ". Vui lòng không chia sẻ mã này với bất kỳ ai.";

		try {
			emailController.sendEmail(email,subject,body);
		} catch (MessagingException ex) {
			request.setAttribute("error","Gửi email thất bại. Vui lòng thử lại.");
			OtpService.clear(request.getSession());
			forwardBack(request,response);
			return;
		}

		request.setAttribute("email",email);
		request.setAttribute("message","Đăng ký thành công! Vui lòng kiểm tra email để lấy mã xác nhận.");
		request.setAttribute("page", "home/views/user/send_OTP.jsp");
		request.getRequestDispatcher("/index.jsp").forward(request, response);

	}

}
