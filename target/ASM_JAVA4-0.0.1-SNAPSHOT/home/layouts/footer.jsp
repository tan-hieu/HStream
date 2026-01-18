<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
.footer {
  background-color: #f8f8f8;
  border-top: 1px solid #ddd;
  padding: 20px 40px;
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: center;
  font-family: Arial, sans-serif;
  font-size: 14px;
  color: #555;
}

.footer .left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.footer .left i {
  color: #065fd4;
  font-size: 18px;
}

.footer .center {
  text-align: center;
  flex: 1;
}

.footer .right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.footer .right a {
  color: #555;
  text-decoration: none;
  transition: color 0.2s;
}

.footer .right a:hover {
  color: #065fd4;
}

/* Nếu bạn muốn cố định chân trang dưới cùng */
.footer-fixed {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
}
</style>

<!-- ========== PHẦN CHÂN TRANG ========== -->
<footer class="footer">
  <div class="left">
    <i class="fa-solid fa-copyright"></i>
    <span>2025 NetCafe Management System</span>
  </div>

  <div class="center">
    <span>Thiết kế bởi <strong>HIT</strong></span>
  </div>

  <div class="right">
    <a href="#"><i class="fa-brands fa-facebook"></i> Facebook</a>
    <a href="#"><i class="fa-brands fa-github"></i> GitHub</a>
    <a href="#"><i class="fa-brands fa-discord"></i> Discord</a>
  </div>
</footer>
