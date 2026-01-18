package controller;

import com.google.gson.Gson;
import entity.Share;
import jakarta.persistence.EntityManager;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/admin/api/shares")
public class ShareApiController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");
        String videoIdStr = req.getParameter("videoId");
        Gson gson = new Gson();
        if (videoIdStr == null || videoIdStr.isEmpty()) {
            resp.getWriter().write(gson.toJson(Collections.emptyList()));
            return;
        }
        EntityManager em = utils.JpaUtils.getEntityManager();
        try {
            int videoId = Integer.parseInt(videoIdStr);
            List<Share> shares = em.createQuery(
                "SELECT s FROM Share s JOIN FETCH s.user WHERE s.video.id = :vid ORDER BY s.shareDate DESC",
                Share.class
            ).setParameter("vid", videoId).getResultList();

            List<Map<String, Object>> out = new ArrayList<>();
            for (Share s : shares) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", s.getId());
                m.put("senderFullname", s.getUser() != null ? s.getUser().getFullname() : "");
                m.put("senderEmail", s.getUser() != null ? s.getUser().getEmail() : "");
                m.put("recipientEmail", s.getEmail());
                m.put("shareDate", s.getShareDate() != null ? s.getShareDate().toString() : "");
                out.add(m);
            }
            resp.getWriter().write(gson.toJson(out));
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write(gson.toJson(Collections.emptyList()));
        } finally {
            em.close();
        }
    }
}
