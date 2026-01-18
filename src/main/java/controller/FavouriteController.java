package controller;

import dao.FavouriteDao;
import dao.FavouriteDaoImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class FavouriteController
 */
@WebServlet("/favourite")
public class FavouriteController extends HttpServlet {
	private final FavouriteDao favouriteDao = new FavouriteDaoImpl();

    public FavouriteController() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        HttpSession session = request.getSession(false);
        var user = (session == null) ? null :session.getAttribute("currentUser");
        if (user == null){
            response.setStatus(401);
            response.getWriter().write("{\"error\":\"UNAUTHORIZED\"}");
            return;
        }

        int videoId;
        try{
            videoId =Integer.parseInt(request.getParameter("videoId"));
        }catch (Exception e){
            response.setStatus(400);
            response.getWriter().write("{\"error\":\"BAD_REQUEST\"}");
            return;
        }

        int userId = ((entity.User) user).getId();
        boolean existed = favouriteDao.exists(userId, videoId);
        if (existed){
            favouriteDao.remove(userId, videoId);
            long total = favouriteDao.countByVideo(videoId);
            response.getWriter().write("{\"liked\":false,\"totalLikes\":"+ total +"}");
        }else {
            favouriteDao.add(userId, videoId);
            long total = favouriteDao.countByVideo(videoId);
            response.getWriter().write("{\"liked\":true,\"totalLikes\":"+ total +"}");
        }
    }

}
