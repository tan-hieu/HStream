package controller;

import dao.ShareDao;
import dao.ShareDaoImpl;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.EmailService;

import java.io.IOException;
import java.util.regex.Pattern;

/**
 * Servlet implementation class ShareController
 */
@WebServlet("/share")
public class ShareController extends HttpServlet {
    private final ShareDao shareDao = new ShareDaoImpl();
    private static final Pattern EMAIL_RE = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private final EmailService mailer = new EmailService(
            "smtp.gmail.com", 587, "dtanhieu123@gmail.com", "rfpl mndo hkxv gpgm", true
    );

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ShareController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");

		HttpSession session = request.getSession(false);
		User current = (session == null) ? null : (User) session.getAttribute("currentUser");
		if (current == null) {
			response.setStatus(401);
			response.getWriter().write("{\"error\":\"UNAUTHORIZED\"}");
			return;
		}

		String email = request.getParameter("email");
		String videoIdStr = request.getParameter("videoId");
		String link = request.getParameter("link"); // optional: YouTube or site link

		if (email == null || !EMAIL_RE.matcher(email).matches()) {
			response.setStatus(400);
			response.getWriter().write("{\"error\":\"INVALID_EMAIL\"}");
			return;
		}

		int videoId;
		try {
			videoId = Integer.parseInt(videoIdStr);
		} catch (Exception e) {
			response.setStatus(400);
			response.getWriter().write("{\"error\":\"BAD_VIDEO_ID\"}");
			return;
		}

		boolean firstTime;
		try {
			firstTime = shareDao.upsert(current.getId(), videoId, email);
		} catch (Exception e) {
			response.setStatus(500);
			response.getWriter().write("{\"error\":\"DB_ERROR\"}");
			return;
		}

		// Send email
		String subject = "Có người chia sẻ video với bạn";
		String content = "<p>Chào bạn,</p>"
				+ "<p>" + current.getFullname() + " đã chia sẻ một video với bạn.</p>"
				+ "<p>Link video: <a href=\"" + (link == null ? "" : link) + "\">" + (link == null ? "Xem video" : link) + "</a></p>"
				+ "<p>Trân trọng.</p>";

        try {
            mailer.sendEmail(email, subject, content);
        } catch (jakarta.mail.MessagingException e) {
            e.printStackTrace(); // hoặc dùng logger
            response.setStatus(502);
            response.getWriter().write("{\"error\":\"MAIL_SEND_FAILED\"}");
            return;
        }

		String msg = firstTime
				? "Đã gửi thành công."
				: "Bạn đã chia sẻ video này trước đó – thời gian chia sẻ đã được cập nhật.";
		response.getWriter().write("{\"ok\":true,\"firstTime\":" + firstTime + ",\"message\":\"" + msg + "\"}");
	}

}
