<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/assets/css/theme.css"
/>
<style>
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

  .text-primary {
    color: var(--accent) !important;
  }
  .text-muted {
    color: var(--gray-muted) !important;
  }
</style>

<div class="d-flex align-items-center justify-content-center min-vh-500">
  <main class="card shadow-lg auth-card">
    <header class="text-center mb-4">
      <h1 class="h3 fw-bold text-primary mb-2">Đặt lại mật khẩu</h1>
      <p class="text-muted mb-0">Tạo mật khẩu mới cho tài khoản của bạn</p>
    </header>

    <c:if test="${not empty error}">
      <div class="alert alert-danger py-2 mb-3">${error}</div>
    </c:if>

    <form
      method="post"
      action="${pageContext.request.contextPath}/reset-password"
      id="resetForm"
    >
      <input type="hidden" name="email" value="${email}" />

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
          />
        </div>
        <small class="text-muted">Mật khẩu phải gồm ít nhất 6 chữ số</small>
      </div>

      <div class="mb-4">
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
          />
        </div>
      </div>

      <button
        class="btn btn-primary w-100 d-flex justify-content-center align-items-center gap-2"
        type="submit"
      >
        <i class="fa-solid fa-key"></i>
        <span>Đặt lại mật khẩu</span>
      </button>
    </form>

    <div class="text-center mt-4">
      <a
        class="fw-semibold text-decoration-none link-primary"
        href="${pageContext.request.contextPath}/home?page=login"
      >
        <i class="fa-solid fa-arrow-left me-1"></i>Quay lại đăng nhập
      </a>
    </div>
  </main>
</div>
