<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="jakarta.tags.core" prefix="c"%>
<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/assets/css/theme.css"
/>

<style>
  .auth-card {
    max-width: 440px;
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

  /* OTP Input styling */
  .otp-inputs {
    gap: 0.6rem;
  }

  .otp-inputs input {
    width: 3.2rem;
    height: 3.5rem;
    text-align: center;
    font-size: 1.5rem;
    font-weight: 600;
    border-radius: 0.6rem;
    border: 2px solid var(--border-soft);
    background: var(--bg-panel);
    color: var(--gray-light);
    outline: none;
    transition: all 0.2s ease;
    -moz-appearance: textfield;
  }

  .otp-inputs input:focus {
    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.35);
    border-color: var(--accent);
    transform: scale(1.05);
  }

  .otp-inputs input.is-invalid {
    border-color: #dc3545 !important;
    animation: shake 0.3s ease;
  }

  .otp-inputs input.is-valid {
    border-color: #28a745 !important;
  }

  .otp-inputs input::-webkit-outer-spin-button,
  .otp-inputs input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }

  @keyframes shake {
    0%,
    100% {
      transform: translateX(0);
    }
    25% {
      transform: translateX(-5px);
    }
    75% {
      transform: translateX(5px);
    }
  }

  /* Validation tooltip */
  .validation-tooltip {
    display: none;
    background: #ffc107;
    color: #333;
    padding: 10px 14px;
    border-radius: 6px;
    font-size: 0.9rem;
    font-weight: 500;
    margin-top: 10px;
    text-align: center;
    animation: tooltipFadeIn 0.2s ease;
  }

  .validation-tooltip.show {
    display: block;
  }

  .validation-tooltip i {
    margin-right: 6px;
  }

  @keyframes tooltipFadeIn {
    from {
      opacity: 0;
      transform: translateY(-5px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  /* Button styling */
  .auth-card .btn-primary {
    background: var(--accent-grad) !important;
    border-color: var(--accent) !important;
    color: #fff !important;
    box-shadow: 0 10px 24px -8px rgba(99, 102, 241, 0.7);
    transition: transform 0.12s ease, box-shadow 0.2s ease, filter 0.2s ease;
    font-weight: 600;
  }

  .auth-card .btn-primary:hover {
    filter: brightness(1.05);
    box-shadow: 0 16px 32px -10px rgba(99, 102, 241, 0.85);
    transform: translateY(-1px);
  }

  .auth-card .btn-primary:disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }

  .btn-link {
    color: var(--accent) !important;
    font-weight: 500;
    text-decoration: none;
  }

  .btn-link:hover {
    color: var(--accent-light) !important;
    text-decoration: underline;
  }

  /* Text colors */
  .text-primary {
    color: var(--accent) !important;
  }
  .link-primary {
    color: var(--accent) !important;
  }
  .text-muted {
    color: var(--gray-muted) !important;
  }

  /* Countdown timer */
  .countdown-timer {
    font-weight: 600;
    color: var(--accent);
  }

  /* Email display */
  .email-display {
    background: rgba(99, 102, 241, 0.1);
    padding: 8px 16px;
    border-radius: 20px;
    display: inline-block;
  }

  @media (max-width: 420px) {
    .otp-inputs input {
      width: 2.6rem;
      height: 3rem;
      font-size: 1.2rem;
    }
  }

  .input-group-icon {
    border: 1px solid var(--border-soft);
    border-radius: 0.75rem;
    background: var(--bg-panel);
    overflow: hidden;
    transition: border-color 0.2s ease, box-shadow 0.2s ease,
      background 0.2s ease;
    display: flex;
    align-items: stretch;
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
</style>

<div class="d-flex align-items-center justify-content-center min-vh-500">
  <main class="card shadow-lg auth-card">
    <!-- Header -->
    <header class="text-center mb-4">
      <div class="mb-3">
        <i class="fa-solid fa-envelope-open-text fa-3x text-primary"></i>
      </div>
      <h1 class="h3 fw-bold text-primary mb-2">Xác thực OTP</h1>
      <p class="text-muted mb-2">Mã xác nhận 6 chữ số đã được gửi đến:</p>
      <p class="email-display text-primary fw-semibold mb-0">${email}</p>
    </header>

    <!-- Thông báo thành công -->
    <c:if test="${not empty message}">
      <div
        class="alert alert-info py-2 mb-3 d-flex align-items-center"
        role="alert"
      >
        <i class="fa-solid fa-circle-info me-2"></i>
        <span>${message}</span>
      </div>
    </c:if>

    <!-- Thông báo lỗi -->
    <c:if test="${not empty error}">
      <div
        class="alert alert-danger py-2 mb-3 d-flex align-items-center"
        role="alert"
      >
        <i class="fa-solid fa-circle-exclamation me-2"></i>
        <span>${error}</span>
      </div>
    </c:if>

    <!-- Form xác thực OTP -->
    <form
      action="${pageContext.request.contextPath}/verify-reset-otp"
      method="post"
      id="otp-form"
    >
      <input type="hidden" name="email" value="${email}" />
      <input type="hidden" name="code" id="otp-code" value="" />

      <!-- 6 ô nhập OTP -->
      <div class="d-flex otp-inputs justify-content-center mb-3">
        <input
          type="text"
          inputmode="numeric"
          pattern="[0-9]*"
          maxlength="1"
          class="otp-digit"
          data-index="0"
          aria-label="Số OTP 1"
          autocomplete="off"
        />
        <input
          type="text"
          inputmode="numeric"
          pattern="[0-9]*"
          maxlength="1"
          class="otp-digit"
          data-index="1"
          aria-label="Số OTP 2"
          autocomplete="off"
        />
        <input
          type="text"
          inputmode="numeric"
          pattern="[0-9]*"
          maxlength="1"
          class="otp-digit"
          data-index="2"
          aria-label="Số OTP 3"
          autocomplete="off"
        />
        <input
          type="text"
          inputmode="numeric"
          pattern="[0-9]*"
          maxlength="1"
          class="otp-digit"
          data-index="3"
          aria-label="Số OTP 4"
          autocomplete="off"
        />
        <input
          type="text"
          inputmode="numeric"
          pattern="[0-9]*"
          maxlength="1"
          class="otp-digit"
          data-index="4"
          aria-label="Số OTP 5"
          autocomplete="off"
        />
        <input
          type="text"
          inputmode="numeric"
          pattern="[0-9]*"
          maxlength="1"
          class="otp-digit"
          data-index="5"
          aria-label="Số OTP 6"
          autocomplete="off"
        />
      </div>

      <!-- Tooltip validation -->
      <div class="validation-tooltip" id="otpTooltip">
        <i class="fa-solid fa-exclamation-triangle"></i>
        <span id="otpTooltipMessage">Vui lòng nhập đủ 6 chữ số.</span>
      </div>

      <!-- Nút xác nhận -->
      <button
        type="submit"
        class="btn btn-primary w-100 mb-3 mt-3"
        id="submitBtn"
      >
        <i class="fa-solid fa-check me-2" id="submitIcon"></i>
        <span id="submitText">Xác nhận</span>
      </button>
    </form>

    <!-- Form gửi lại OTP -->
    <form
      action="${pageContext.request.contextPath}/resend-reset-otp"
      method="post"
      class="text-center"
      id="resendForm"
    >
      <input type="hidden" name="email" value="${email}" />
      <p class="text-muted mb-2">Không nhận được mã?</p>
      <button type="submit" class="btn btn-link p-0" id="resendBtn">
        <i class="fa-solid fa-rotate-right me-1"></i> Gửi lại mã OTP
      </button>
    </form>

    <!-- Thời gian hiệu lực -->
    <div class="text-center mt-3">
      <small class="text-muted">
        <i class="fa-regular fa-clock me-1"></i>
        Mã có hiệu lực trong
        <span class="countdown-timer" id="countdown">5:00</span>
      </small>
    </div>

    <!-- Lưu ý -->
    <small class="text-muted d-block mt-3 text-center">
      <i class="fa-solid fa-info-circle me-1"></i>
      Nếu không thấy email, kiểm tra hộp thư <strong>Spam/Rác</strong>.
    </small>

    <!-- Link quay lại -->
    <div class="text-center mt-3">
      <a
        href="${pageContext.request.contextPath}/forgot-password"
        class="link-primary text-decoration-none"
      >
        <i class="fa-solid fa-arrow-left me-1"></i> Nhập lại email khác
      </a>
    </div>

    <!-- Thêm vào phần form đổi mật khẩu -->
    <div class="mb-3">
      <label class="form-label fw-semibold" for="newPassword"
        >Mật khẩu mới</label
      >
      <div class="input-group input-group-icon">
        <span class="input-group-text">
          <i class="fa-solid fa-lock"></i>
        </span>
        <input
          class="form-control"
          type="password"
          id="newPassword"
          name="newPassword"
          placeholder="Nhập mật khẩu mới"
          required
          pattern="^\d{6,}$"
          title="Mật khẩu phải gồm ít nhất 6 chữ số."
        />
        <!-- Nút con mắt -->
        <button
          class="toggle-password"
          type="button"
          id="toggleNewPassword"
          aria-label="Ẩn hoặc hiện mật khẩu"
          tabindex="-1"
          style="
            background: transparent;
            border: 0;
            outline: none;
            display: flex;
            align-items: center;
          "
        >
          <i class="fa-solid fa-eye-slash" id="toggleNewPasswordIcon"></i>
        </button>
      </div>
      <small class="text-muted">Mật khẩu phải gồm ít nhất 6 chữ số</small>
    </div>

    <div class="mb-3">
      <label class="form-label fw-semibold" for="confirmPassword"
        >Xác nhận mật khẩu</label
      >
      <div class="input-group input-group-icon">
        <span class="input-group-text">
          <i class="fa-solid fa-lock"></i>
        </span>
        <input
          class="form-control"
          type="password"
          id="confirmPassword"
          name="confirmPassword"
          placeholder="Nhập lại mật khẩu"
          required
          pattern="^\d{6,}$"
          title="Mật khẩu phải gồm ít nhất 6 chữ số."
        />
        <button
          class="toggle-password"
          type="button"
          id="toggleConfirmPassword"
          aria-label="Ẩn hoặc hiện mật khẩu"
        >
          <i class="fa-solid fa-eye-slash" id="toggleConfirmPasswordIcon"></i>
        </button>
      </div>
    </div>

    <script>
      // Toggle mật khẩu mới
      const newPasswordInput = document.getElementById("newPassword");
      const toggleNewPassword = document.getElementById("toggleNewPassword");
      const toggleNewPasswordIcon = document.getElementById(
        "toggleNewPasswordIcon"
      );

      function setToggleState(btn, icon, show) {
        icon.classList.remove("fa-eye", "fa-eye-slash");
        icon.classList.add(show ? "fa-eye" : "fa-eye-slash");
        btn.classList.toggle("is-show", show);
        btn.setAttribute("aria-pressed", show ? "true" : "false");
        btn.setAttribute("title", show ? "Ẩn mật khẩu" : "Hiện mật khẩu");
      }

      toggleNewPassword.addEventListener("click", () => {
        const show = newPasswordInput.type === "password";
        newPasswordInput.type = show ? "text" : "password";
        setToggleState(toggleNewPassword, toggleNewPasswordIcon, show);
      });

      // Lấy các elements
      const inputs = Array.from(document.querySelectorAll(".otp-digit"));
      const otpCodeInput = document.getElementById("otp-code");
      const otpForm = document.getElementById("otp-form");
      const otpTooltip = document.getElementById("otpTooltip");
      const otpTooltipMessage = document.getElementById("otpTooltipMessage");
      const submitBtn = document.getElementById("submitBtn");
      const submitIcon = document.getElementById("submitIcon");
      const submitText = document.getElementById("submitText");
      const countdownEl = document.getElementById("countdown");
      const resendBtn = document.getElementById("resendBtn");

      // Thời gian hiệu lực OTP: 5 phút
      let timeLeft = 5 * 60; // 300 giây

      /**
       * Ẩn tooltip
       */
      function hideTooltip() {
        otpTooltip.classList.remove("show");
        inputs.forEach((input) => input.classList.remove("is-invalid"));
      }

      /**
       * Hiện tooltip với message
       */
      function showTooltip(message) {
        otpTooltipMessage.textContent = message;
        otpTooltip.classList.add("show");
      }

      /**
       * Đánh dấu các ô nhập là invalid
       */
      function markInvalid() {
        inputs.forEach((input) => {
          if (!input.value) {
            input.classList.add("is-invalid");
          }
        });
      }

      /**
       * Hiển thị loading state
       */
      function setLoading(isLoading) {
        if (isLoading) {
          submitBtn.disabled = true;
          submitIcon.className = "spinner-border spinner-border-sm me-2";
          submitText.textContent = "Đang xác thực...";
        } else {
          submitBtn.disabled = false;
          submitIcon.className = "fa-solid fa-check me-2";
          submitText.textContent = "Xác nhận";
        }
      }

      /**
       * Cập nhật đồng hồ đếm ngược
       */
      function updateCountdown() {
        const minutes = Math.floor(timeLeft / 60);
        const seconds = timeLeft % 60;
        countdownEl.textContent =
          minutes + ":" + (seconds < 10 ? "0" : "") + seconds;

        if (timeLeft <= 0) {
          countdownEl.textContent = "Hết hạn";
          countdownEl.style.color = "#dc3545";
          showTooltip("Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã mới.");
        } else {
          timeLeft--;
          setTimeout(updateCountdown, 1000);
        }
      }

      // Bắt đầu đếm ngược
      updateCountdown();

      // Focus vào ô đầu tiên khi load trang
      window.addEventListener("DOMContentLoaded", () => {
        inputs[0].focus();
      });

      // Xử lý sự kiện cho từng ô input
      inputs.forEach((input, idx) => {
        // Khi nhập
        input.addEventListener("input", (e) => {
          hideTooltip();
          const val = e.target.value;
          // Chỉ lấy ký tự số cuối cùng
          const lastChar = val.replace(/[^0-9]/g, "").slice(-1);
          e.target.value = lastChar;

          // Nếu đã nhập và không phải ô cuối thì focus ô tiếp theo
          if (lastChar && idx < inputs.length - 1) {
            inputs[idx + 1].focus();
          }

          // Đánh dấu valid nếu có giá trị
          if (lastChar) {
            input.classList.remove("is-invalid");
            input.classList.add("is-valid");
          } else {
            input.classList.remove("is-valid");
          }
        });

        // Khi nhấn phím
        input.addEventListener("keydown", (e) => {
          // Backspace: xóa và quay về ô trước
          if (e.key === "Backspace" && !input.value && idx > 0) {
            inputs[idx - 1].focus();
            inputs[idx - 1].value = "";
            inputs[idx - 1].classList.remove("is-valid");
          }
          // Mũi tên trái
          if (e.key === "ArrowLeft" && idx > 0) {
            inputs[idx - 1].focus();
          }
          // Mũi tên phải
          if (e.key === "ArrowRight" && idx < inputs.length - 1) {
            inputs[idx + 1].focus();
          }
        });

        // Khi paste
        input.addEventListener("paste", (e) => {
          e.preventDefault();
          hideTooltip();
          const paste = (e.clipboardData || window.clipboardData).getData(
            "text"
          );
          const digits = paste.replace(/\D/g, ""); // Chỉ lấy số

          if (!digits) return;

          // Điền các số vào các ô
          let writeIdx = 0;
          for (let ch of digits) {
            if (writeIdx >= inputs.length) break;
            inputs[writeIdx].value = ch;
            inputs[writeIdx].classList.add("is-valid");
            writeIdx++;
          }

          // Focus vào ô cuối cùng đã điền hoặc ô tiếp theo
          if (writeIdx < inputs.length) {
            inputs[writeIdx].focus();
          } else {
            inputs[inputs.length - 1].focus();
          }
        });

        // Khi focus
        input.addEventListener("focus", () => {
          input.select();
        });
      });

      // Xử lý submit form
      otpForm.addEventListener("submit", (e) => {
        hideTooltip();

        // Lấy mã OTP từ các ô input
        const code = inputs.map((i) => i.value).join("");

        // Kiểm tra đã nhập đủ 6 số chưa
        if (code.length !== 6) {
          e.preventDefault();
          showTooltip("Vui lòng nhập đủ 6 chữ số.");
          markInvalid();
          // Focus vào ô trống đầu tiên
          const firstEmpty = inputs.find((i) => !i.value);
          if (firstEmpty) firstEmpty.focus();
          return;
        }

        // Kiểm tra chỉ chứa số
        if (/\D/.test(code)) {
          e.preventDefault();
          showTooltip("Mã OTP chỉ được chứa chữ số.");
          inputs.forEach((i) => i.classList.add("is-invalid"));
          return;
        }

        // Kiểm tra OTP đã hết hạn chưa
        if (timeLeft <= 0) {
          e.preventDefault();
          showTooltip("Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã mới.");
          return;
        }

        // Nếu hợp lệ, gán vào hidden input và submit
        otpCodeInput.value = code;
        setLoading(true);
      });

      // Xử lý gửi lại OTP
      resendBtn.addEventListener("click", () => {
        resendBtn.disabled = true;
        resendBtn.innerHTML =
          '<i class="spinner-border spinner-border-sm me-1"></i> Đang gửi...';
      });
    </script>
  </main>
</div>
