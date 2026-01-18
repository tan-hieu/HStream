package controller;

import com.google.gson.Gson;
import dao.FavouriteDao;
import dao.FavouriteDaoImpl;
import entity.Favourite;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/admin/api/favorite-users")
public class FavoriteUserApiController extends HttpServlet {
    private final FavouriteDao favouriteDao = new FavouriteDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String videoIdStr = req.getParameter("videoId");
        System.out.println("Video ID nhận được từ request: " + videoIdStr); // Kiểm tra videoId từ request
        resp.setContentType("application/json; charset=UTF-8");
        Gson gson = new Gson();

        if (videoIdStr == null || videoIdStr.isEmpty()) {
            System.out.println("Không có videoId trong request."); // Debug trường hợp không có videoId
            resp.getWriter().write(gson.toJson(Collections.emptyList()));
            return;
        }

        try {
            int videoId = Integer.parseInt(videoIdStr);
            List<Object[]> favs = favouriteDao.findByVideoId(videoId);
            System.out.println("Dữ liệu trả về từ DAO: " + favs); // Kiểm tra dữ liệu từ DAO

            List<Map<String, Object>> result = new ArrayList<>();
            for (Object[] fav : favs) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", fav[0]);
                map.put("userId", fav[1]);
                map.put("fullname", fav[2]);
                map.put("email", fav[3]);
                map.put("videoId", fav[4]);
                map.put("title", fav[5]);
                map.put("likeDate", fav[6].toString());
                result.add(map);
            }

            System.out.println("Dữ liệu JSON trả về: " + gson.toJson(result)); // Kiểm tra JSON trả về
            resp.getWriter().write(gson.toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Lỗi khi xử lý API: " + e.getMessage()); // Debug lỗi
            resp.getWriter().write(gson.toJson(Collections.emptyList()));
        }
    }
}
