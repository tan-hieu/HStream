<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/assets/css/theme.css"
/>
<style>
  /* Card chính */
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

  /* Input group styling */
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

  /* Viền xanh khi focus (giống ảnh 2) */
  .input-group-icon.is-focused {
    border-color: #6366f1 !important;
    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.35) !important;
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

  .input-group-icon .form-control::placeholder {
    color: var(--gray-muted);
  }

  /* ========================== */
  /* TOOLTIP VALIDATION GIỐNG ẢNH 2 */
  /* ========================== */
  .validation-tooltip {
    display: none;
    position: absolute;
    left: 0;
    top: 100%;
    margin-top: 8px;
    background: #f0ad4e;
    color: #333;
    padding: 10px 14px;
    border-radius: 6px;
    font-size: 0.88rem;
    font-weight: 500;
    z-index: 100;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
    max-width: 100%;
    white-space: nowrap;
    animation: tooltipFadeIn 0.2s ease;
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

  .validation-tooltip::before {
    content: "";
    position: absolute;
    top: -8px;
    left: 18px;
    border-left: 8px solid transparent;
    border-right: 8px solid transparent;
    border-bottom: 8px solid #f0ad4e;
  }

  .validation-tooltip i {
    margin-right: 8px;
    color: #8a6d3b;
    font-size: 0.95rem;
  }

  .input-wrapper {
    position: relative;
  }

  .input-wrapper.show-tooltip .validation-tooltip {
    display: flex;
    align-items: center;
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

  .auth-card .btn-primary:active {
    transform: translateY(0);
    box-shadow: 0 8px 18px -6px rgba(99, 102, 241, 0.65);
  }

  .auth-card .btn-primary:disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }

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

  .spinner-border-sm {
    width: 1rem;
    height: 1rem;
  }
</style>

<div class="d-flex align-items-center justify-content-center min-vh-500">
  <main class="card shadow-lg auth-card">
    <!-- Header -->
    <header class="text-center mb-4">
      <h1 class="h3 fw-bold text-primary mb-2">Quên mật khẩu</h1>
      <p class="text-muted mb-0">Nhập email để khôi phục mật khẩu</p>
    </header>

    <!-- Thông báo lỗi từ server -->
    <c:if test="${not empty error}">
      <div
        class="alert alert-danger py-2 mb-3 d-flex align-items-center"
        role="alert"
      >
        <i class="fa-solid fa-circle-exclamation me-2"></i>
        <span>${error}</span>
      </div>
    </c:if>

    <!-- Thông báo thành công từ server -->
    <c:if test="${not empty message}">
      <div
        class="alert alert-success py-2 mb-3 d-flex align-items-center"
        role="alert"
      >
        <i class="fa-solid fa-circle-check me-2"></i>
        <span>${message}</span>
      </div>
    </c:if>

    <!-- Form nhập email -->
    <form
      method="post"
      action="${pageContext.request.contextPath}/forgot-password"
      id="forgotForm"
      novalidate
    >
      <div class="mb-4">
        <label class="form-label fw-semibold" for="email">Email</label>
        <div class="input-wrapper" id="emailWrapper">
          <div class="input-group input-group-icon" id="emailInputGroup">
            <span class="input-group-text">
              <i class="fa-solid fa-envelope"></i>
            </span>
            <input
              class="form-control"
              type="email"
              id="email"
              name="email"
              placeholder="name@gmail.com"
              autocomplete="email"
              value="${emailValue}"
            />
          </div>
          <!-- Tooltip validation giống ảnh 2 -->
          <div class="validation-tooltip" id="emailTooltip">
            <i class="fa-solid fa-exclamation-triangle"></i>
            <span id="tooltipMessage">Vui lòng điền vào trường này.</span>
          </div>
        </div>
        <small class="text-muted mt-1 d-block"
          >Chỉ hỗ trợ địa chỉ Gmail (@gmail.com)</small
        >
      </div>

      <!-- Submit button -->
      <button
        class="btn btn-primary w-100 d-flex justify-content-center align-items-center gap-2"
        type="submit"
        id="submitBtn"
      >
        <i class="fa-solid fa-paper-plane" id="submitIcon"></i>
        <span id="submitText">Gửi mã xác nhận</span>
      </button>
    </form>

    <!-- Link quay lại đăng nhập -->
    <div class="text-center mt-4 text-muted">
      <a
        class="fw-semibold text-decoration-none link-primary"
        href="${pageContext.request.contextPath}/login"
      >
        <i class="fa-solid fa-arrow-left me-1"></i>Quay lại đăng nhập
      </a>
    </div>
  </main>
</div>

<script>
  (function () {
    // ==================== LẤY CÁC ELEMENTS ====================
    const emailInput = document.getElementById("email");
    const emailWrapper = document.getElementById("emailWrapper");
    const emailInputGroup = document.getElementById("emailInputGroup");
    const tooltipMessage = document.getElementById("tooltipMessage");
    const forgotForm = document.getElementById("forgotForm");
    const submitBtn = document.getElementById("submitBtn");
    const submitIcon = document.getElementById("submitIcon");
    const submitText = document.getElementById("submitText");

    // Regex kiểm tra Gmail hợp lệ
    const gmailPattern = /^[a-zA-Z0-9._%+-]+@gmail\.com$/i;

    // ==================== HÀM ẨN TOOLTIP ====================
    function hideTooltip() {
      emailWrapper.classList.remove("show-tooltip");
      emailInputGroup.classList.remove("is-focused");
    }

    // ==================== HÀM HIỂN THỊ TOOLTIP ====================
    function showTooltip(message) {
      tooltipMessage.textContent = message;
      emailWrapper.classList.add("show-tooltip");
      emailInputGroup.classList.add("is-focused");
      // THÊM: Đảm bảo tooltip luôn hiển thị
      document.getElementById("emailTooltip").style.display = "flex";
    }

    // ==================== HÀM LOADING STATE ====================
    function setLoading(isLoading) {
      if (isLoading) {
        submitBtn.disabled = true;
        submitIcon.className = "spinner-border spinner-border-sm";
        submitText.textContent = "Đang gửi...";
      } else {
        submitBtn.disabled = false;
        submitIcon.className = "fa-solid fa-paper-plane";
        submitText.textContent = "Gửi mã xác nhận";
      }
    }

    // ==================== SỰ KIỆN INPUT ====================
    emailInput.addEventListener("input", function () {
      hideTooltip();
      // Ẩn tooltip khi đang nhập
      document.getElementById("emailTooltip").style.display = "none";
    });

    emailInput.addEventListener("focus", function () {
      emailInputGroup.classList.add("is-focused");
      hideTooltip();
    });

    emailInput.addEventListener("blur", function () {
      if (!emailWrapper.classList.contains("show-tooltip")) {
        emailInputGroup.classList.remove("is-focused");
      }
    });

    // ==================== XỬ LÝ SUBMIT FORM ====================
    forgotForm.addEventListener("submit", function (e) {
      const value = emailInput.value.trim();

      // 1. KIỂM TRA TRƯỜNG RỖNG
      if (!value) {
        e.preventDefault();
        e.stopPropagation();
        showTooltip("Vui lòng điền vào trường này.");
        emailInput.focus();
        return false;
      }

      // 2. KIỂM TRA ĐỊNH DẠNG GMAIL
      if (!gmailPattern.test(value)) {
        e.preventDefault();
        e.stopPropagation();
        showTooltip(
          "Vui lòng nhập địa chỉ Gmail hợp lệ (ví dụ: example@gmail.com)"
        );
        emailInput.focus();
        return false;
      }

      // 3. NẾU HỢP LỆ - Hiển thị loading và submit form
      setLoading(true);
      // Form sẽ tự submit đến controller /forgot-password
      return true;
    });

    // ==================== FOCUS INPUT KHI LOAD TRANG ====================
    if (!emailInput.value) {
      emailInput.focus();
    }
  })();
</script>
