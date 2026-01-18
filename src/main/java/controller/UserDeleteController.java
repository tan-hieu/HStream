package controller;

import java.io.IOException;
import java.io.PrintWriter;

import dao.UserDao;
import dao.UserDaoImpl;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/user/delete")
public class UserDeleteController extends HttpServlet {

    private UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        // Kiểm tra quyền admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            out.print("{\"success\": false, \"message\": \"Chưa đăng nhập!\"}");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (!Boolean.TRUE.equals(currentUser.getAdmin())) {
            out.print("{\"success\": false, \"message\": \"Không có quyền truy cập!\"}");
            return;
        }
        
        try {
            String idStr = request.getParameter("id");
            
            // Validate ID
            if (idStr == null || idStr.isEmpty()) {
                out.print("{\"success\": false, \"message\": \"ID người dùng không hợp lệ!\"}");
                return;
            }
            
            int id = Integer.parseInt(idStr);
            
            // Không cho phép xóa chính mình
            if (currentUser.getId().equals(id)) {
                out.print("{\"success\": false, \"message\": \"Không thể xóa tài khoản của chính bạn!\"}");
                return;
            }
            
            // Tìm user cần xóa
            User user = userDao.findById(id);
            if (user == null) {
                out.print("{\"success\": false, \"message\": \"Không tìm thấy người dùng!\"}");
                return;
            }
            
            // Xóa user
            userDao.delete(id);
            
            out.print("{\"success\": true, \"message\": \"Xóa người dùng thành công!\"}");
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"ID không hợp lệ!\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        }
    }
}