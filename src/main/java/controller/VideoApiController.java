package controller;

import com.google.gson.Gson;
import dao.VideoDao;
import dao.VideoDaoImpl;
import entity.Video;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/api/videos")
public class VideoApiController extends HttpServlet {
    private final VideoDao videoDao = new VideoDaoImpl();

    // Tạo DTO chỉ chứa trường cần thiết
    public static class VideoSimpleDTO {
        public Integer id;
        public String title;
        public VideoSimpleDTO(Integer id, String title) {
            this.id = id;
            this.title = title;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");
        try {
            List<Video> videos = videoDao.findAllActive();
            // Chuyển sang DTO để tránh lỗi serialize
            List<VideoSimpleDTO> simpleList = videos.stream()
                .map(v -> new VideoSimpleDTO(v.getId(), v.getTitle()))
                .collect(Collectors.toList());
            
            // In danh sách video ra console để kiểm tra
            System.out.println("==> Danh sách video trả về cho client:");
            for (VideoSimpleDTO v : simpleList) {
                System.out.println("ID: " + v.id + ", Title: " + v.title);
            }

            resp.getWriter().print(new Gson().toJson(simpleList));
        } catch (Exception e) {
            e.printStackTrace(); // In ra log để debug
            resp.setStatus(500);
            resp.getWriter().print("{\"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}
