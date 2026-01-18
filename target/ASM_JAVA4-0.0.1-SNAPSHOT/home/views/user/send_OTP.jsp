<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
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
      action="${pageContext.request.contextPath}/verify-otp"
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
      action="${pageContext.request.contextPath}/resend-otp"
      method="post"
      class="text-center"
    >
      <input type="hidden" name="email" value="${email}" />
      <p class="text-muted mb-2">Không nhận được mã?</p>
      <button type="submit" class="btn btn-link p-0">
        <i class="fa-solid fa-rotate-right me-1"></i> Gửi lại mã OTP
      </button>
    </form>

    <!-- Lưu ý -->
    <small class="text-muted d-block mt-3 text-center">
      <i class="fa-solid fa-info-circle me-1"></i>
      Nếu không thấy email, kiểm tra hộp thư <strong>Spam/Rác</strong>.
    </small>

    <!-- Link quay lại -->
    <div class="text-center mt-3">
      <a
        href="${pageContext.request.contextPath}/home?page=register"
        class="link-primary text-decoration-none"
      >
        <i class="fa-solid fa-arrow-left me-1"></i> Quay lại đăng ký
      </a>
    </div>
  </main>
</div>

<script>
  // Lấy các elements
  const inputs = Array.from(document.querySelectorAll(".otp-digit"));
  const otpCodeInput = document.getElementById("otp-code");
  const otpForm = document.getElementById("otp-form");
  const otpTooltip = document.getElementById("otpTooltip");
  const otpTooltipMessage = document.getElementById("otpTooltipMessage");
  const submitBtn = document.getElementById("submitBtn");
  const submitIcon = document.getElementById("submitIcon");
  const submitText = document.getElementById("submitText");

  // Ẩn tooltip
  function hideTooltip() {
    otpTooltip.classList.remove("show");
    inputs.forEach((input) => input.classList.remove("is-invalid"));
  }

  // Hiện tooltip với message
  function showTooltip(message) {
    otpTooltipMessage.textContent = message;
    otpTooltip.classList.add("show");
  }

  // Đánh dấu các ô nhập là invalid
  function markInvalid() {
    inputs.forEach((input) => {
      if (!input.value) {
        input.classList.add("is-invalid");
      }
    });
  }

  // Hiển thị loading state
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

  // Focus vào ô đầu tiên khi load trang
  window.addEventListener("DOMContentLoaded", () => {
    inputs[0].focus();
  });

  // Xử lý sự kiện cho từng ô input
  inputs.forEach((input, idx) => {
    // Xử lý nhập số
    input.addEventListener("input", (e) => {
      hideTooltip();
      const val = e.target.value;
      const lastChar = val.replace(/[^0-9]/g, "").slice(-1);
      e.target.value = lastChar;

      if (lastChar) {
        input.classList.remove("is-invalid");
        input.classList.add("is-valid");
        if (idx < inputs.length - 1) {
          inputs[idx + 1].focus();
        }
      } else {
        input.classList.remove("is-valid");
      }
    });

    // Xử lý phím bấm
    input.addEventListener("keydown", (e) => {
      if (e.key === "Backspace") {
        if (!input.value && idx > 0) {
          inputs[idx - 1].focus();
          inputs[idx - 1].value = "";
          inputs[idx - 1].classList.remove("is-valid");
        } else {
          input.classList.remove("is-valid");
        }
      }
      if (e.key === "ArrowLeft" && idx > 0) {
        e.preventDefault();
        inputs[idx - 1].focus();
      }
      if (e.key === "ArrowRight" && idx < inputs.length - 1) {
        e.preventDefault();
        inputs[idx + 1].focus();
      }
    });

    // Xử lý paste
    input.addEventListener("paste", (e) => {
      e.preventDefault();
      const paste = (e.clipboardData || window.clipboardData).getData("text");
      const digits = paste.replace(/\D/g, "");
      if (!digits) return;

      hideTooltip();
      let writeIdx = 0;
      for (let ch of digits) {
        if (writeIdx >= inputs.length) break;
        inputs[writeIdx].value = ch;
        inputs[writeIdx].classList.remove("is-invalid");
        inputs[writeIdx].classList.add("is-valid");
        writeIdx++;
      }

      if (writeIdx < inputs.length) {
        inputs[writeIdx].focus();
      } else {
        inputs[inputs.length - 1].focus();
      }
    });

    // Xử lý focus
    input.addEventListener("focus", () => {
      input.select();
    });
  });

  // Xử lý submit form
  otpForm.addEventListener("submit", (e) => {
    const code = inputs.map((i) => i.value).join("");

    // Kiểm tra đủ 6 số
    if (code.length !== 6 || /\D/.test(code)) {
      e.preventDefault();
      showTooltip("Vui lòng nhập đủ 6 chữ số.");
      markInvalid();
      const firstEmpty = inputs.find((i) => !i.value);
      if (firstEmpty) firstEmpty.focus();
      return;
    }

    // Gán giá trị vào hidden input
    otpCodeInput.value = code;
    setLoading(true);
  });
</script>
