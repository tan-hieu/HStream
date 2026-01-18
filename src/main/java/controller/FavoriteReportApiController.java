package controller;

import com.google.gson.Gson;
import dao.*;
import entity.*;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/admin/api/favorite-report")
public class FavoriteReportApiController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");
        PrintWriter out = resp.getWriter();
        EntityManager em = utils.JpaUtils.getEntityManager();

        try {
            // 1. Thống kê số lượng user đăng ký theo ngày (yyyy-MM-dd)
            List<Object[]> userStats = em.createQuery(
                "SELECT CAST(u.createdDate AS date), COUNT(u) FROM User u GROUP BY CAST(u.createdDate AS date) ORDER BY CAST(u.createdDate AS date)"
            ).getResultList();

            // 2. Top video có lượt xem nhiều nhất
            List<Video> topVideos = em.createQuery(
                "SELECT v FROM Video v ORDER BY v.views DESC", Video.class
            ).setMaxResults(10).getResultList();

            // 3. Số bình luận theo từng video (JPQL đúng)
            // Lấy các video đã đăng (Status = 1) và có ít nhất 1 bình luận
            List<Object[]> commentStats = em.createQuery(
                "SELECT v.title, COUNT(c) " +
                "FROM Video v JOIN v.comments c " +
                "WHERE v.status = 1 " +
                "GROUP BY v.title " +
                "ORDER BY COUNT(c) DESC"
            ).getResultList();

            Map<String, Object> result = new HashMap<>();

            List<Map<String, Object>> userStatsList = new ArrayList<>();
            for (Object[] row : userStats) {
                Map<String, Object> item = new HashMap<>();
                item.put("date", row[0] == null ? "" : row[0].toString());
                item.put("count", row[1]);
                userStatsList.add(item);
            }
            result.put("userStats", userStatsList);

            List<Map<String, Object>> topVideosList = new ArrayList<>();
            for (Video v : topVideos) {
                Map<String, Object> item = new HashMap<>();
                item.put("title", v.getTitle());
                item.put("views", v.getViews());
                topVideosList.add(item);
            }
            result.put("topVideos", topVideosList);

            List<Map<String, Object>> commentStatsList = new ArrayList<>();
            for (Object[] row : commentStats) {
                Map<String, Object> item = new HashMap<>();
                item.put("title", row[0]);
                item.put("count", row[1]);
                commentStatsList.add(item);
            }
            result.put("commentStats", commentStatsList);

            String json = new Gson().toJson(result);
            out.print(json);
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            out.print("{\"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
        } finally {
            em.close();
        }
    }
}
