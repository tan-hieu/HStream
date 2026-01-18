package controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.UUID;
import java.util.regex.Pattern;

import dao.UserDao;
import dao.UserDaoImpl;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/update-profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 1024 * 1024 * 5,         // 5 MB
    maxRequestSize = 1024 * 1024 * 10      // 10 MB
)
public class ProfileController extends HttpServlet {
    
    private UserDao userDao = new UserDaoImpl();
    
    // Pattern cho số điện thoại: bắt đầu bằng 0, đúng 10 chữ số
    private static final Pattern PHONE_PATTERN = Pattern.compile("^0\\d{9}$");

    // Nếu muốn đặt đường dẫn tĩnh mặc định, bạn có thể thay đổi giá trị DEFAULT_RELATIVE_UPLOAD_DIR
    private static final String DEFAULT_RELATIVE_UPLOAD_DIR = "uploads" + File.separator + "avatars";

    private File getAvatarFolder() {
        // 1) ưu tiên biến môi trường AVATAR_UPLOAD_DIR (tuyệt đối)
        String env = System.getenv("AVATAR_UPLOAD_DIR");
        if (env != null && !env.trim().isEmpty()) {
            File f = new File(env);
            if (!f.exists()) f.mkdirs();
            return f;
        }

        // 2) nếu chạy trên Tomcat, lưu ở ${catalina.base}/uploads/avatars
        String catalinaBase = System.getProperty("catalina.base");
        if (catalinaBase != null && !catalinaBase.trim().isEmpty()) {
            File f = new File(catalinaBase + File.separator + "uploads" + File.separator + "avatars");
            if (!f.exists()) f.mkdirs();
            return f;
        }

        // 3) fallback: thư mục relative tới working dir của process (user.dir)
        String userDir = System.getProperty("user.dir");
        File f = new File(userDir + File.separator + DEFAULT_RELATIVE_UPLOAD_DIR);
        if (!f.exists()) f.mkdirs();
        return f;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            out.print("{\"success\": false, \"message\": \"Vui lòng đăng nhập!\"}");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        
        try {
            // Lấy dữ liệu từ form
            String fullname = request.getParameter("fullname");
            String mobile = request.getParameter("mobile");
            String genderStr = request.getParameter("gender");
            String birthdateStr = request.getParameter("birthdate");
            
            // Validate Họ tên
            if (fullname == null || fullname.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Họ tên không được để trống!\"}");
                return;
            }
            
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
            
            // Xử lý upload avatar
            String avatarPath = currentUser.getAvatar(); // giữ nguyên avatar cũ nếu không upload mới
            
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = java.nio.file.Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExt = "";
                int dot = fileName.lastIndexOf('.');
                if (dot >= 0) fileExt = fileName.substring(dot + 1).toLowerCase();
                
                if (!fileExt.matches("jpg|jpeg|png|gif|webp")) {
                    out.print("{\"success\": false, \"message\": \"Chỉ chấp nhận file ảnh (jpg, jpeg, png, gif, webp)!\"}");
                    return;
                }
                
                String uniqueFileName = UUID.randomUUID().toString() + "." + fileExt;
                
                File avatarFolder = getAvatarFolder(); // folder thực tế trên filesystem
                File destFile = new File(avatarFolder, uniqueFileName);
                
                // Lưu file bằng cách copy InputStream (portable)
                try (InputStream is = filePart.getInputStream()) {
                    Files.copy(is, destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }

                // Tạo URL public để truy cập: contextPath + /uploads/avatars/<file>
                // String publicUrl = request.getContextPath() + "/uploads/avatars/" + uniqueFileName;
                // avatarPath = publicUrl;
                
                // Trả về relative URL (không include contextPath) — sẽ hiển thị bằng client ghép contextPath
                String publicUrl = "/uploads/avatars/" + uniqueFileName;
                avatarPath = publicUrl;
            }
            
            // Cập nhật thông tin user
            User user = userDao.findById(currentUser.getId());
            if (user == null) {
                out.print("{\"success\": false, \"message\": \"Không tìm thấy người dùng!\"}");
                return;
            }
            
            user.setFullname(fullname.trim());
            user.setMobile(mobile.trim());
            user.setGender("true".equalsIgnoreCase(genderStr));
            user.setBirthdate(birthdate);
            // KHÔNG cho phép sửa email - giữ nguyên email cũ
            if (avatarPath != null) {
                user.setAvatar(avatarPath);
            }
            
            // Lưu vào database
            User updatedUser = userDao.update(user);
            
            // Cập nhật session
            session.setAttribute("currentUser", updatedUser);
            
            out.print("{\"success\": true, \"message\": \"Cập nhật hồ sơ thành công!\", \"avatar\": \"" + (avatarPath != null ? avatarPath : "") + "\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        }
    }
}