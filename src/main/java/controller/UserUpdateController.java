package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.regex.Pattern;

import dao.UserDao;
import dao.UserDaoImpl;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/user/update")
public class UserUpdateController extends HttpServlet {

    private UserDao userDao = new UserDaoImpl();
    
    // Pattern cho số điện thoại: bắt đầu bằng 0, đúng 10 chữ số
    private static final Pattern PHONE_PATTERN = Pattern.compile("^0\\d{9}$");
    
    // Xóa NAME_PATTERN - không cần validate pattern cho tên nữa

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
            // Lấy dữ liệu từ form
            String idStr = request.getParameter("id");
            String fullname = request.getParameter("fullname");
            String mobile = request.getParameter("mobile");
            String genderStr = request.getParameter("gender");
            String birthdateStr = request.getParameter("birthdate");
            String adminStr = request.getParameter("admin");
            String activeStr = request.getParameter("active");
            
            // Validate ID
            if (idStr == null || idStr.isEmpty()) {
                out.print("{\"success\": false, \"message\": \"ID người dùng không hợp lệ!\"}");
                return;
            }
            
            // Validate Họ tên - chỉ kiểm tra không rỗng
            if (fullname == null || fullname.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Họ tên không được để trống!\"}");
                return;
            }
            // Không validate pattern nữa - cho phép nhập tự do
            
            // Validate Số điện thoại - bắt đầu bằng 0, đúng 10 số
            if (mobile == null || mobile.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Số điện thoại không được để trống!\"}");
                return;
            }
            if (!PHONE_PATTERN.matcher(mobile.trim()).matches()) {
                out.print("{\"success\": false, \"message\": \"Số điện thoại phải bắt đầu bằng số 0 và có đúng 10 chữ số!\"}");
                return;
            }
            
            // Validate Ngày sinh - không được vượt quá ngày hiện tại
            if (birthdateStr == null || birthdateStr.isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Ngày sinh không được để trống!\"}");
                return;
            }
            LocalDate birthdate = LocalDate.parse(birthdateStr);
            if (birthdate.isAfter(LocalDate.now())) {
                out.print("{\"success\": false, \"message\": \"Ngày sinh không được vượt quá ngày hiện tại!\"}");
                return;
            }
            
            // Parse dữ liệu
            int id = Integer.parseInt(idStr);
            boolean gender = "true".equalsIgnoreCase(genderStr);
            boolean admin = "true".equalsIgnoreCase(adminStr);
            boolean active = "true".equalsIgnoreCase(activeStr);
            
            // Tìm user cần update
            User user = userDao.findById(id);
            if (user == null) {
                out.print("{\"success\": false, \"message\": \"Không tìm thấy người dùng!\"}");
                return;
            }
            
            // Cập nhật thông tin
            user.setFullname(fullname.trim());
            user.setMobile(mobile.trim());
            user.setGender(gender);
            user.setBirthdate(birthdate);
            user.setAdmin(admin);
            user.setActive(active);
            
            // Lưu vào database
            userDao.update(user);
            
            out.print("{\"success\": true, \"message\": \"Cập nhật thành công!\"}");
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"ID không hợp lệ!\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        }
    }
}
