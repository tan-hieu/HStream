package controller;

import dao.CommentDao;
import dao.CommentDaoImpl;
import dao.VideoDao;
import dao.VideoDaoImpl;
import entity.Comment;
import entity.User;
import entity.Video;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;

/**
 * Servlet implementation class CommentController
 */
@WebServlet("/comment")
public class CommentController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CommentController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setStatus(405);
		response.setContentType("application/json; charset=UTF-8");
		writeJson(response, "{\"error\":\"METHOD_NOT_ALLOWED\"}");
	}

	private void writeJson(HttpServletResponse response, String json) throws IOException {
		try (PrintWriter w = response.getWriter()) {
			w.write(json);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");

		HttpSession session = request.getSession(false);
		User currentUser = (session == null) ? null : (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			response.setStatus(401);
			writeJson(response, "{\"error\":\"UNAUTHORIZED\"}");
			return;
		}

		String videoIdRaw = request.getParameter("videoId");
		String content = request.getParameter("content");
		int videoId;

		if (videoIdRaw == null) {
			response.setStatus(400);
			writeJson(response, "{\"error\":\"MISSING_VIDEO_ID\"}");
			return;
		}
		try {
			videoId = Integer.parseInt(videoIdRaw);
		} catch (NumberFormatException ex) {
			response.setStatus(400);
			writeJson(response, "{\"error\":\"INVALID_VIDEO_ID\"}");
			return;
		}

		if (content == null || (content = content.trim()).isEmpty()) {
			response.setStatus(400);
			writeJson(response, "{\"error\":\"EMPTY_CONTENT\"}");
			return;
		}
		if (content.length() > 500) {
			response.setStatus(400);
			writeJson(response, "{\"error\":\"CONTENT_TOO_LONG\"}");
			return;
		}

		VideoDao videoDao = new VideoDaoImpl();
		Video v = videoDao.findById(videoId);
		if (v == null || v.getStatus() == null || !v.getStatus()) {
			response.setStatus(404);
			writeJson(response, "{\"error\":\"VIDEO_NOT_FOUND\"}");
			return;
		}

		Comment c = Comment.builder()
				.user(currentUser)
				.video(v)
				.content(content)
				.commentDate(LocalDate.now())
				.build();

		try {
			CommentDao cDao = new CommentDaoImpl();
			cDao.insert(c);
		} catch (Exception ex) {
			response.setStatus(500);
			writeJson(response, "{\"error\":\"SERVER_ERROR\"}");
			return;
		}

		// Escape đơn giản cho JSON (thay " và \)
		String safeContent = content.replace("\\", "\\\\").replace("\"", "\\\"");
		String safeAuthor = (currentUser.getFullname() == null ? "Người dùng" :
				currentUser.getFullname().replace("\\", "\\\\").replace("\"", "\\\""));

		writeJson(response, String.format(
				"{\"id\":%d,\"author\":\"%s\",\"content\":\"%s\",\"date\":\"%s\"}",
				c.getId(), safeAuthor, safeContent, c.getCommentDate()
		));
	}

}
