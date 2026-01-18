<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/assets/css/theme.css"
/>
<style>
  /* Card sáng, viền rõ hơn, shadow accent */
  .auth-card {
    max-width: 420px;
    width: 92vw;
    background: var(--bg-soft);
    border: 1px solid var(--border-soft);
    border-radius: 1.5rem;
    padding: 2.25rem;
    color: var(--gray-light);
    box-shadow: var(--shadow-accent);
  }

  .form-label {
    color: var(--gray-subtle);
  }

  /* Input group sáng hơn */
  .input-group-icon {
    border: 1px solid var(--border-soft);
    border-radius: 0.75rem;
    background: var(--bg-panel);
    overflow: hidden;
    transition: border-color 0.2s ease, box-shadow 0.2s ease,
      background 0.2s ease;
  }
  .input-group-icon:focus-within {
    border-color: var(--accent);
    box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.28);
    background: var(--bg-soft);
  }
  .input-group-icon .input-group-text {
    border: 0;
    background: transparent;
    color: var(--accent);
    font-size: 1.1rem;
    display: flex;
    align-items: center;
    justify-content: center;
    padding-inline: 0.95rem;
  }
  .input-group-icon .form-control {
    border: 0;
    background: transparent;
    box-shadow: none;
    padding-left: 0;
    color: var(--gray-light);
  }
  .input-group-icon .form-control:focus {
    box-shadow: none;
  }
  .input-group-icon .toggle-password {
    border: 0;
    border-left: 1px solid var(--border-soft);
    background: transparent;
    padding: 0 0.9rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: 1.05rem;
    color: var(--gray-icon);
  }
  .input-group-icon .toggle-password:hover {
    background: var(--layer-soft);
    color: var(--accent);
  }
  .input-group-icon .toggle-password:active {
    transform: none;
  }
  .input-group-icon .toggle-password:focus-visible {
    outline: 2px solid var(--accent);
    outline-offset: 2px;
    border-radius: 0.4rem;
  }
  .input-group-icon .toggle-password.is-show {
    color: var(--accent);
    background: transparent;
    box-shadow: none;
  }
  .input-group-icon .toggle-password i {
    transform: none;
  }

  .form-control {
    border-left: none;
  }
  .form-control:focus {
    border-color: var(--accent);
    box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.35);
  }

  /* Button override cho trang login: gradient + hover đồng bộ */
  .auth-card .btn-primary {
    background: var(--accent-grad) !important;
    border-color: var(--accent) !important;
    color: #fff !important;
    box-shadow: 0 10px 24px -8px rgba(99, 102, 241, 0.7);
    transition: transform 0.12s ease, box-shadow 0.2s ease, filter 0.2s ease;
  }
  .auth-card .btn-primary:hover {
    filter: brightness(1.05);
    box-shadow: 0 16px 32px -10px rgba(99, 102, 241, 0.85);
    transform: translateY(-1px);
  }
  .auth-card .btn-primary:active {
    transform: translateY(0);
    box-shadow: 0 8px 18px -6px rgba(99, 102, 241, 0.65);
  }

  /* Text/link theo theme */
  .text-primary {
    color: var(--accent) !important;
  }
  .link-primary {
    color: var(--accent) !important;
  }
  .link-primary:hover {
    color: var(--accent-light) !important;
  }
  .text-muted {
    color: var(--gray-muted) !important;
  }
</style>

<div class="d-flex align-items-center justify-content-center min-vh-500">
  <main class="card shadow-lg auth-card">
    <header class="text-center mb-4">
      <h1 class="h3 fw-bold text-primary mb-2">Đăng nhập</h1>
      <p class="text-muted mb-0">Chào mừng bạn quay trở lại</p>
    </header>

    <c:choose>
      <c:when test="${not empty lockRemain}">
        <div class="alert alert-warning py-2 mb-3">
          Tài khoản đang bị khóa. Vui lòng thử lại sau
          <span id="lockCountdown">${lockRemain}</span> giây.
        </div>
      </c:when>
      <c:otherwise>
        <c:if test="${not empty error}">
          <div class="alert alert-danger py-2 mb-3">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
          <div class="alert alert-success py-2 mb-3">${message}</div>
        </c:if>
      </c:otherwise>
    </c:choose>

    <form
      method="post"
      action="${pageContext.request.contextPath}/login"
      id="loginForm"
    >
      <div class="mb-3">
        <label class="form-label fw-semibold" for="email"> Email</label>
        <div class="input-group input-group-icon">
          <span class="input-group-text">
            <i class="fa-solid fa-envelope"></i>
          </span>
          <input
            class="form-control"
            type="email"
            id="email"
            name="email"
            placeholder="name@gmail.com"
            required
            pattern="^[a-zA-Z0-9._%+-]+@gmail\.com$"
            title="Vui lòng nhập địa chỉ Gmail kết thúc bằng @gmail.com"
            value="${param.email}"
          />
        </div>
      </div>

      <div class="mb-3">
        <label class="form-label fw-semibold" for="password">Mật khẩu</label>
        <div class="input-group input-group-icon">
          <span class="input-group-text">
            <i class="fa-solid fa-lock"></i>
          </span>
          <input
            class="form-control"
            type="password"
            id="password"
            name="password"
            placeholder="Nhập mật khẩu"
            required
            pattern="^\d{6,}$"
            title="Mật khẩu phải gồm ít nhất 6 chữ số."
          />
          <button
            class="toggle-password"
            type="button"
            id="togglePassword"
            aria-label="Ẩn hoặc hiện mật khẩu"
          >
            <i class="fa-solid fa-eye-slash" id="togglePasswordIcon"></i>
          </button>
        </div>
      </div>

      <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="form-check">
          <input
            class="form-check-input"
            type="checkbox"
            id="remember"
            name="remember"
          />
          <label class="form-check-label" for="remember"
            >Ghi nhớ đăng nhập</label
          >
        </div>
        <a
          class="link-primary text-decoration-none"
          href="${pageContext.request.contextPath}/home?page=forgot-password"
          >Quên mật khẩu?
        </a>
      </div>

      <button
        class="btn btn-primary w-100 d-flex justify-content-center align-items-center gap-2"
        type="submit"
      >
        <i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng nhập
      </button>
    </form>

    <div class="text-center mt-4 text-muted">
      Chưa có tài khoản?
      <a
        class="fw-semibold text-decoration-none"
        href="${pageContext.request.contextPath}/home?page=register"
      >
        <i class="bi bi-person-plus-fill me-1"></i>Đăng ký ngay
      </a>
    </div>
  </main>

  <script>
    const togglePassword = document.getElementById("togglePassword");
    const passwordInput = document.getElementById("password");
    const toggleIcon = document.getElementById("togglePasswordIcon");
    const emailInput = document.getElementById("email");
    const loginForm = document.getElementById("loginForm");
    let lockCountdownEl = document.getElementById("lockCountdown");
    let lockAlertEl = lockCountdownEl
      ? lockCountdownEl.closest(".alert")
      : null;
    let timer = null;

    function emailKey() {
      const v = (emailInput.value || "").trim().toLowerCase();
      return v.length ? v : "unknown";
    }

    function setFormDisabled(disabled) {
      [...loginForm.querySelectorAll("input, button")].forEach((el) => {
        el.disabled = disabled;
      });
    }

    function startCountdown(remainSec) {
      dbg("startCountdown:", remainSec);
      if (!lockCountdownEl) {
        // Tạo alert nếu chưa có từ server
        lockAlertEl = document.createElement("div");
        lockAlertEl.className = "alert alert-warning py-2 mb-3";
        lockAlertEl.innerHTML =
          'Tài khoản đang bị khóa. Vui lòng thử lại sau <span id="lockCountdown"></span> giây.';
        // Chèn alert lên trước form
        loginForm.parentNode.insertBefore(lockAlertEl, loginForm);
        lockCountdownEl = lockAlertEl.querySelector("#lockCountdown");
      }

      // Disable form
      setFormDisabled(true);

      // Khởi tạo đếm ngược
      let remain = Math.max(0, parseInt(remainSec, 10) || 0);
      lockCountdownEl.textContent = remain;

      // Xóa timer cũ nếu có
      if (timer) clearInterval(timer);

      timer = setInterval(() => {
        remain = Math.max(0, remain - 1);
        lockCountdownEl.textContent = remain;

        if (remain <= 0) {
          clearInterval(timer);
          timer = null;
          // Enable form và xóa alert
          setFormDisabled(false);
          if (lockAlertEl) {
            lockAlertEl.remove();
            lockAlertEl = null;
            lockCountdownEl = null;
          }
          // Xóa trạng thái lưu trữ
          localStorage.removeItem("loginLock:" + emailKey());
        }
      }, 1000);
    }

    // Toggle mật khẩu
    togglePassword.addEventListener("click", () => {
      const show = passwordInput.type === "password";
      passwordInput.type = show ? "text" : "password";
      toggleIcon.classList.remove("fa-eye", "fa-eye-slash");
      toggleIcon.classList.add(show ? "fa-eye" : "fa-eye-slash");
      togglePassword.classList.toggle("is-show", show);
      togglePassword.setAttribute("aria-pressed", show ? "true" : "false");
      togglePassword.setAttribute(
        "title",
        show ? "Ẩn mật khẩu" : "Hiện mật khẩu"
      );
    });

    // Client-side validate
    emailInput.addEventListener("input", () => {
      const valid = /^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(emailInput.value);
      emailInput.setCustomValidity(
        valid ? "" : "Chỉ chấp nhận địa chỉ Gmail (@gmail.com)."
      );

      // Khi đổi email, nếu email mới đang bị khóa theo localStorage → khôi phục countdown
      const key = "loginLock:" + emailKey();
      const lockUntil = parseInt(localStorage.getItem(key) || "0", 10);
      const now = Date.now();
      dbg("email changed:", emailKey(), "lockUntil=", lockUntil, "now=", now);

      if (lockUntil > now) {
        const remainSec = Math.ceil((lockUntil - now) / 1000);
        startCountdown(remainSec);
      } else {
        // Không khóa: nếu đang hiển thị alert, bỏ đi và enable form
        if (lockAlertEl) {
          if (timer) clearInterval(timer);
          timer = null;
          setFormDisabled(false);
          lockAlertEl.remove();
          lockAlertEl = null;
          lockCountdownEl = null;
        }
      }
    });

    passwordInput.addEventListener("input", () => {
      const valid = /^\d{6,}$/.test(passwordInput.value);
      passwordInput.setCustomValidity(
        valid ? "" : "Mật khẩu phải gồm ít nhất 6 chữ số."
      );
    });

    // Nếu server gửi lockRemain, lưu vào localStorage để countdown tiếp tục khi reload
    (function initLockFromServer() {
      const serverCountdown = document.getElementById("lockCountdown");
      if (serverCountdown) {
        const remain = parseInt(serverCountdown.textContent, 10);
        dbg("server lockRemain found:", remain);
        const until = Date.now() + remain * 1000;
        localStorage.setItem("loginLock:" + emailKey(), String(until));
        startCountdown(remain);
      } else {
        // KHÔNG có lockRemain span → thử parse từ alert lỗi (đỏ)
        const errorAlert = document.querySelector(".alert.alert-danger");
        if (errorAlert) {
          const txt = errorAlert.textContent || "";
          const m = txt.match(/thử lại sau\s+(\d+)\s+giây/i);
          if (m) {
            const remain = parseInt(m[1], 10);
            dbg(
              "parsed seconds from error alert:",
              remain,
              "→ convert to countdown"
            );
            // Đổi alert đỏ sang alert vàng + thêm span countdown
            errorAlert.classList.remove("alert-danger");
            errorAlert.classList.add("alert-warning");
            errorAlert.innerHTML =
              'Tài khoản đang bị khóa. Vui lòng thử lại sau <span id="lockCountdown">' +
              remain +
              "</span> giây.";
            lockAlertEl = errorAlert;
            lockCountdownEl = errorAlert.querySelector("#lockCountdown");
            const until = Date.now() + remain * 1000;
            localStorage.setItem("loginLock:" + emailKey(), String(until));
            startCountdown(remain);
            return;
          } else {
            dbg("no seconds found in error alert text");
          }
        }

        // Không có gì từ server → thử đọc localStorage
        const key = "loginLock:" + emailKey();
        const lockUntil = parseInt(localStorage.getItem(key) || "0", 10);
        const now = Date.now();
        if (lockUntil > now) {
          const remainSec = Math.ceil((lockUntil - now) / 1000);
          dbg("resume from localStorage, remain:", remainSec);
          startCountdown(remainSec);
        } else {
          dbg("no active lock in localStorage");
        }
      }
    })();

    function dbg(...args) {
      console.log("[LOGIN_UI]", ...args);
    }
    dbg(
      "init: lockCountdownEl=",
      !!lockCountdownEl,
      "lockAlertEl=",
      !!lockAlertEl
    );
  </script>
</div>
