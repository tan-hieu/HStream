<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
taglib prefix="fn" uri="jakarta.tags.functions" %>
<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/assets/css/theme.css"
/>
<style>
  :root {
    --bg-body: #0f1420;
    --card-bg: #ffffff;
    --text-main: #1f2937;
    --text-muted: #6b7280;
    --border: #e2e8f0;
    --primary: #4c57ff;
    --primary-weak: #d0d5ff;
    --primary-hover: #93a0ff;
    --soft-shadow: 0 8px 24px rgba(15, 20, 32, 0.2);
  }

  body {
    background: var(--bg-body);
  }

  .container .bg-white {
    background: var(--card-bg);
    color: var(--text-main);
    border-radius: 16px;
    box-shadow: var(--soft-shadow);
    border: 1px solid var(--border);
  }

  .text-muted {
    color: var(--text-muted) !important;
  }

  /* Tiêu đề nổi bật */
  h3.fw-bold {
    letter-spacing: 0.2px;
    font-size: 2.1rem;
    background: linear-gradient(90deg, #7a7dfb 30%, #1ee9b1 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    text-fill-color: transparent;
    font-weight: 800;
    margin-bottom: 0.2em;
  }

  .search-box {
    border: 1px solid #99999957;
    border-radius: 10px;
    padding: 10px 12px;
    transition: box-shadow 0.2s ease, border-color 0.2s ease;
  }
  .search-box:focus-within {
    border-color: var(--primary-hover);
    box-shadow: 0 4px 12px rgba(76, 87, 255, 0.15);
  }
  .search-box input {
    border: none;
    background: transparent;
    outline: none;
    width: 100%;
    color: #fff !important; /* Màu chữ trắng */
  }

  .search-box input::placeholder {
    color: rgba(255, 255, 255, 0.6) !important; /* Màu placeholder nhạt hơn */
  }

  .form-select {
    border: 1px solid var(--border);
    border-radius: 10px;
    padding: 10px 12px;
    color: var(--text-main);
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
  }
  .form-select:focus {
    border-color: var(--primary-hover);
    box-shadow: 0 0 0 4px rgba(76, 87, 255, 0.15);
  }

  /* --- Bảng dark mode đẹp, dễ đọc --- */
  .table {
    --bs-table-bg: #181e2a;
    --bs-table-striped-bg: #20273a;
    --bs-table-hover-bg: #232a3a;
    --bs-table-border-color: #232a3a;
    --bs-table-color: #f3f6fa;
    color: var(--bs-table-color);
    background: var(--bs-table-bg);
    border-radius: 16px;
    overflow: hidden;
    font-size: 1.07rem;
    box-shadow: 0 4px 24px rgba(20, 30, 60, 0.18);
  }

  .table thead.table-light {
    background: linear-gradient(90deg, #232a3a 60%, #7a7dfb 100%) !important;
    color: #fff !important;
    font-weight: 800;
    letter-spacing: 0.5px;
    border-bottom: 2px solid #313a4d;
  }

  .table th,
  .table td {
    border-color: #232a3a !important;
    color: white;
    vertical-align: middle;
    padding: 15px 12px;
  }

  .table tbody tr {
    border-bottom: 1px solid #232a3a;
    transition: background 0.18s;
  }

  .table tbody tr:hover > * {
    background-color: #2a3350 !important;
    color: #fff;
  }

  .table-striped > tbody > tr:nth-of-type(odd) > * {
    background-color: #20273a !important;
  }

  .table-striped > tbody > tr:nth-of-type(even) > * {
    background-color: #181e2a !important;
  }

  /* Badge trạng thái */
  .status-active {
    background: linear-gradient(90deg, #1ee9b1 60%, #0fd9a1 100%);
    color: #0f5132;
    border: none;
    border-radius: 999px;
    font-weight: 700;
    padding: 5px 20px;
    font-size: 1em;
    box-shadow: 0 2px 8px rgba(30, 233, 177, 0.08);
    letter-spacing: 0.5px;
  }

  .status-block {
    background: linear-gradient(90deg, #ff6b81 60%, #ff3b5c 100%);
    color: #fff;
    border: none;
    border-radius: 999px;
    font-weight: 700;
    padding: 5px 20px;
    font-size: 1em;
    box-shadow: 0 2px 8px rgba(255, 107, 129, 0.1);
    letter-spacing: 0.5px;
  }

  /* Nút hành động */
  .table .btn-outline-primary,
  .table .btn-outline-danger {
    border-radius: 8px;
    padding: 6px 10px;
    font-size: 1.1em;
    transition: background 0.18s, color 0.18s;
  }

  .table .btn-outline-primary {
    border-color: #7a7dfb;
    color: #7a7dfb;
    background: transparent;
  }
  .table .btn-outline-primary:hover {
    background: #7a7dfb;
    color: #fff;
    border-color: #7a7dfb;
  }

  .table .btn-outline-danger {
    border-color: #ff6b81;
    color: #ff6b81;
    background: transparent;
  }
  .table .btn-outline-danger:hover {
    background: #ff6b81;
    color: #fff;
    border-color: #ff6b81;
  }

  /* Đổi màu nền và màu chữ cho bảng để phù hợp dark mode */
  .table {
    --bs-table-bg: #181e2a;
    --bs-table-striped-bg: #232a3a;
    --bs-table-striped-color: #e2e8f0;
    --bs-table-hover-bg: #232a3a;
    --bs-table-hover-color: #fff;
    color: #e2e8f0;
    background: #181e2a;
    border-radius: 12px;
    overflow: hidden;
  }

  .table thead.table-light {
    --bs-table-bg: #232a3a;
    background: #232a3a !important;
    color: #a5b4fc;
    border-bottom: 1px solid #313a4d;
  }

  .table > :not(caption) > * > * {
    background-color: var(--bs-table-bg) !important;
    box-shadow: none;
    border-color: #232a3a !important;
  }

  .table tbody tr:hover > * {
    background-color: #232a3a !important;
    color: #fff;
  }

  .table-striped > tbody > tr:nth-of-type(odd) > * {
    background-color: #232a3a !important;
  }

  .table-striped > tbody > tr:nth-of-type(even) > * {
    background-color: #181e2a !important;
  }

  .table th,
  .table td {
    border-color: #232a3a !important;
  }

  .status-active {
    background: #1eecb1;
    color: #0f5132;
    border: 1px solid #1eecb1;
  }

  .status-block {
    background: #ff6b81;
    color: #fff;
    border: 1px solid #ff6b81;
  }

  .btn-outline-primary {
    border-color: var(--primary-weak);
    color: var(--primary);
  }
  .btn-outline-primary:hover {
    background: var(--primary);
    border-color: var(--primary);
    color: #fff;
    box-shadow: 0 6px 16px rgba(76, 87, 255, 0.35);
  }

  .btn-outline-danger {
    border-color: #ffc9c9;
    color: #e63946;
  }
  .btn-outline-danger:hover {
    background: #e63946;
    border-color: #e63946;
    color: #fff;
    box-shadow: 0 6px 16px rgba(230, 57, 70, 0.3);
  }

  .pagination-wrapper {
    margin-top: 24px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
  }
  .pagination-controls {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
    justify-content: center;
  }
  .pagination-btn,
  .pagination-page {
    min-width: 40px;
    height: 40px;
    padding: 0 12px;
    border-radius: 8px;
    border: 1px solid var(--primary-weak);
    background: #fff;
    color: #334;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  .pagination-btn[disabled],
  .pagination-page[disabled] {
    opacity: 0.5;
    cursor: not-allowed;
  }
  .pagination-btn:hover:not([disabled]),
  .pagination-page:hover:not([disabled]):not(.active) {
    background: #f1f4ff;
    border-color: var(--primary-hover);
    color: #253060;
    transform: translateY(-1px);
    box-shadow: 0 2px 6px rgba(147, 160, 255, 0.25);
  }
  .pagination-page.active {
    background: var(--primary);
    border-color: var(--primary);
    color: #fff;
    box-shadow: 0 2px 6px rgba(76, 87, 255, 0.3);
  }
  .pagination-page.active:hover {
    background: var(--primary);
    color: #fff;
    transform: none;
    box-shadow: 0 2px 6px rgba(76, 87, 255, 0.35);
  }

  .modal-content {
    border-radius: 14px;
    border: 1px solid var(--border);
    box-shadow: var(--soft-shadow);
  }
  .modal-header .modal-title {
    color: var(--text-main);
    font-weight: 700;
  }
  .form-control {
    border: 1px solid var(--border);
    border-radius: 10px;
    color: var(--text-main);
  }
  .form-control:focus {
    border-color: var(--primary-hover);
    box-shadow: 0 0 0 4px rgba(76, 87, 255, 0.15);
  }

  .btn.btn-outline-secondary {
    border-color: var(--border);
    color: var(--text-main);
  }
  .btn-check:checked + .btn.btn-outline-secondary {
    border-color: var(--primary);
    background: #eef1ff;
    color: var(--primary);
    box-shadow: 0 2px 8px rgba(76, 87, 255, 0.2);
  }

  .modal-dialog.modal-dialog-centered {
    display: flex;
    align-items: center;
    min-height: calc(100% - 1rem);
    padding: 0;
  }

  .modal-content.edit-modal-dark {
    background: var(--bg-panel, #0d1218) !important;
    border: 1px solid var(--border-soft, rgba(255, 255, 255, 0.18)) !important;
    border-radius: 16px !important;
    box-shadow: 0 16px 48px rgba(0, 0, 0, 0.5),
      0 0 0 1px rgba(99, 102, 241, 0.15) !important;
    color: var(--gray-light, #e2e8f0) !important;
  }

  .edit-modal-dark .modal-header {
    background: linear-gradient(
      135deg,
      rgba(99, 102, 241, 0.15),
      rgba(139, 92, 246, 0.1)
    );
    border-bottom: 1px solid var(--border-subtle, rgba(255, 255, 255, 0.08));
    padding: 18px 24px;
    border-radius: 16px 16px 0 0;
  }

  .edit-modal-dark .modal-title {
    color: #fff !important;
    font-weight: 700;
    font-size: 1.1rem;
    display: flex;
    align-items: center;
  }

  .edit-modal-dark .modal-title i {
    color: var(--accent, #6366f1);
  }

  .edit-modal-dark .modal-body {
    padding: 24px;
    background: var(--bg-panel, #0d1218);
  }

  .edit-modal-dark .form-label {
    color: var(--gray-subtle, #cbd5e1);
    font-weight: 600;
    font-size: 0.875rem;
    margin-bottom: 6px;
  }

  .edit-modal-dark .form-control,
  .edit-modal-dark .form-select {
    background: var(--bg-soft, #1e2530) !important;
    border: 1px solid var(--border-subtle, rgba(255, 255, 255, 0.08)) !important;
    color: var(--gray-light, #e2e8f0) !important;
    border-radius: 10px;
    padding: 10px 14px;
    transition: all 0.25s ease;
  }

  .edit-modal-dark .form-control:focus,
  .edit-modal-dark .form-select:focus {
    border-color: var(--accent, #6366f1) !important;
    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.25) !important;
    background: var(--bg-soft, #1e2530) !important;
  }

  .edit-modal-dark .form-control:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    background: rgba(30, 37, 48, 0.5) !important;
  }

  .edit-modal-dark .form-control::placeholder {
    color: var(--gray-muted, #6b7280) !important;
  }

  .role-toggle-group {
    display: flex;
    gap: 12px;
  }

  .role-btn {
    flex: 1;
    padding: 10px 16px;
    border: 1px solid var(--border-soft, rgba(255, 255, 255, 0.18)) !important;
    background: var(--bg-soft, #1e2530) !important;
    color: var(--gray-subtle, #cbd5e1) !important;
    border-radius: 10px;
    font-weight: 600;
    font-size: 0.875rem;
    transition: all 0.25s ease;
  }

  .role-btn:hover {
    background: var(--layer-soft, rgba(255, 255, 255, 0.06)) !important;
    border-color: var(--accent, #6366f1) !important;
    color: var(--accent-light, #7a7dfb) !important;
  }

  .btn-check:checked + .role-btn {
    background: linear-gradient(
      135deg,
      var(--accent, #6366f1),
      var(--violet, #8b5cf6)
    ) !important;
    border-color: transparent !important;
    color: #fff !important;
    box-shadow: 0 4px 14px rgba(99, 102, 241, 0.4);
  }

  /* Status Toggle Buttons */
  .status-toggle-group {
    display: flex;
    gap: 12px;
  }

  .status-btn {
    flex: 1;
    padding: 10px 16px;
    border: 1px solid var(--border-soft, rgba(255, 255, 255, 0.18)) !important;
    background: var(--bg-soft, #1e2530) !important;
    color: var(--gray-subtle, #cbd5e1) !important;
    border-radius: 10px;
    font-weight: 600;
    font-size: 0.875rem;
    transition: all 0.25s ease;
  }

  .status-btn:hover {
    background: var(--layer-soft, rgba(255, 255, 255, 0.06)) !important;
  }

  .btn-check:checked + .status-btn.status-active-btn {
    background: linear-gradient(135deg, #059669, #10b981) !important;
    border-color: transparent !important;
    color: #fff !important;
    box-shadow: 0 4px 14px rgba(16, 185, 129, 0.4);
  }

  .btn-check:checked + .status-btn.status-block-btn {
    background: linear-gradient(135deg, #dc2626, #ef4444) !important;
    border-color: transparent !important;
    color: #fff !important;
    box-shadow: 0 4px 14px rgba(239, 68, 68, 0.4);
  }

  .edit-modal-dark .modal-footer {
    background: var(--bg-soft, #1e2530);
    border-top: 1px solid var(--border-subtle, rgba(255, 255, 255, 0.08));
    padding: 16px 24px;
    border-radius: 0 0 16px 16px;
    gap: 12px;
  }

  .btn-cancel {
    background: var(--layer-soft, rgba(255, 255, 255, 0.06)) !important;
    border: 1px solid var(--border-soft, rgba(255, 255, 255, 0.18)) !important;
    color: var(--gray-subtle, #cbd5e1) !important;
    padding: 10px 20px;
    border-radius: 10px;
    font-weight: 600;
    transition: all 0.25s ease;
  }

  .btn-cancel:hover {
    background: rgba(239, 68, 68, 0.15) !important;
    border-color: #ef4444 !important;
    color: #f87171 !important;
  }

  .btn-save {
    background: linear-gradient(
      135deg,
      var(--accent, #6366f1),
      var(--violet, #8b5cf6)
    ) !important;
    border: none !important;
    color: #fff !important;
    padding: 10px 24px;
    border-radius: 10px;
    font-weight: 600;
    box-shadow: 0 4px 14px rgba(99, 102, 241, 0.35);
    transition: all 0.25s ease;
  }

  .btn-save:hover {
    background: linear-gradient(
      135deg,
      var(--accent-dark, #4f51d9),
      var(--accent, #6366f1)
    ) !important;
    box-shadow: 0 6px 20px rgba(99, 102, 241, 0.5);
    transform: translateY(-1px);
  }

  .btn-save:active {
    transform: translateY(0);
  }

  .btn-save:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none;
  }

  #successToast {
    background: linear-gradient(135deg, #059669, #10b981) !important;
    color: #fff !important;
    border-radius: 12px;
    box-shadow: 0 8px 24px rgba(16, 185, 129, 0.4);
  }

  #successToast.toast-error {
    background: linear-gradient(135deg, #dc2626, #ef4444) !important;
    box-shadow: 0 8px 24px rgba(239, 68, 68, 0.4);
  }

  #successToast .toast-body {
    font-weight: 600;
    padding: 14px 16px;
  }

  .btn-save.loading {
    pointer-events: none;
    opacity: 0.8;
  }

  .btn-save.loading::after {
    content: "";
    display: inline-block;
    width: 14px;
    height: 14px;
    margin-left: 8px;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-top-color: #fff;
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }

  @keyframes spin {
    to {
      transform: rotate(360deg);
    }
  }

  /* Error styling for inputs */
  .form-control.is-invalid,
  .form-select.is-invalid {
    border-color: #ef4444 !important;
    box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.25) !important;
  }

  .invalid-feedback {
    color: #f87171;
    font-size: 0.8rem;
    margin-top: 4px;
  }
</style>
<div class="container py-4">
  <div class="p-4 shadow-sm rounded-3">
    <!-- Tiêu đề -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h3 class="fw-bold mb-1">Quản lý Người dùng</h3>
        <p class="text-muted mb-0">
          Xem, tìm kiếm, và quản lý tất cả người dùng trên nền tảng.
        </p>
      </div>
    </div>

    <!-- Bộ công cụ: tìm kiếm + bộ lọc -->
    <div class="row g-3 mb-3">
      <!-- Ô tìm kiếm -->
      <div class="col-md-6">
        <div class="search-box d-flex align-items-center gap-2">
          <i class="bi bi-search"></i>
          <input
            type="text"
            id="search"
            placeholder="Tìm theo tên hoặc email..."
            oninput="filterTable()"
          />
        </div>
      </div>

      <!-- Lọc trạng thái -->
      <div class="col-md-3">
        <select id="filter-status" class="form-select" onchange="filterTable()">
          <option value="">Trạng thái: Tất cả</option>
          <option value="Hoạt động">Hoạt động</option>
          <option value="Bị khóa">Bị khóa</option>
        </select>
      </div>

      <!-- Lọc vai trò -->
      <div class="col-md-3">
        <select id="filter-role" class="form-select" onchange="filterTable()">
          <option value="">Vai trò: Tất cả</option>
          <option value="Quản trị viên">Quản trị viên</option>
          <option value="Người dùng">Người dùng</option>
        </select>
      </div>
    </div>

    <!-- Bảng -->
    <div class="table-responsive">
      <table class="table align-middle">
        <thead class="table-light">
          <tr>
            <th>Tên</th>
            <th>Số điện thoại</th>
            <th>Giới tính</th>
            <th>Ngày sinh</th>
            <th>Trạng thái</th>
            <th>Vai trò</th>
            <th class="text-end">Hành động</th>
          </tr>
        </thead>

        <tbody id="user-table">
          <c:if test="${empty users}">
            <tr>
              <td colspan="7" class="text-center text-muted">
                Không có dữ liệu người dùng.
              </td>
            </tr>
          </c:if>

          <c:forEach var="u" items="${users}">
            <tr
              data-id="${u.id}"
              data-name="${u.fullname}"
              data-email="${u.email}"
              data-status="${u.active == null || u.active ? 'Hoạt động' : 'Bị khóa'}"
              data-active="${u.active == null || u.active ? 'true' : 'false'}"
              data-role="${u.admin ? 'Quản trị viên' : 'Người dùng'}"
              data-phone="${u.mobile}"
              data-gender="${u.gender ? 'Nam' : 'Nữ'}"
              data-dob="${u.birthdate}"
            >
              <td>
                <div class="d-flex align-items-center gap-2">
<%--                  <img--%>
<%--                    src="${empty u.avatar ? pageContext.request.contextPath.concat('/img/default-avatar.png') : u.avatar}"--%>
<%--                    class="avatar"--%>
<%--                  />--%>
                  <div>
                    <div class="fw-semibold">${u.fullname}</div>
                    <div class="text-muted small">${u.email}</div>
                  </div>
                </div>
              </td>
              <td>${u.mobile}</td>
              <td><c:out value="${u.gender ? 'Nam' : 'Nữ'}" /></td>
              <td>${u.birthdate}</td>
              <td>
                <c:choose>
                  <c:when test="${u.active == null || u.active}">
                    <span class="status-active">Hoạt động</span>
                  </c:when>
                  <c:otherwise>
                    <span class="status-block">Bị khóa</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:out value="${u.admin ? 'Quản trị viên' : 'Người dùng'}" />
              </td>
              <td class="text-end">
                <button class="btn btn-sm btn-outline-primary">
                  <i class="fa-regular fa-pen-to-square"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger">
                  <i class="fa-regular fa-trash-can"></i>
                </button>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>

    <!-- Phân trang -->
    <div class="d-flex justify-content-between mt-3">
      <div class="pagination-wrapper w-100">
        <div class="pagination-controls">
          <button type="button" class="pagination-btn prev" disabled>
            Trước
          </button>
          <div class="pagination-pages"></div>
          <button type="button" class="pagination-btn next">Sau</button>
        </div>
      </div>
    </div>
  </div>
  <!-- END ONE MAIN DIV -->
</div>
<script>
  const UserTablePager = (() => {
    const itemsPerPage = 6;
    const rows = () => Array.from(document.querySelectorAll("#user-table tr"));

    const prevBtn = () => document.querySelector(".pagination-btn.prev");
    const nextBtn = () => document.querySelector(".pagination-btn.next");
    const pagesContainer = () => document.querySelector(".pagination-pages");

    let currentPage = 1;
    let filtered = [];

    function isMatch(row) {
      const search = (
        document.getElementById("search").value || ""
      ).toLowerCase();
      const status = document.getElementById("filter-status").value || "";
      const role = document.getElementById("filter-role").value || "";

      const name = (row.dataset.name || "").toLowerCase();
      const email = (row.dataset.email || "").toLowerCase();
      const st = row.dataset.status || "";
      const rl = row.dataset.role || "";

      return (
        (search == "" || name.includes(search) || email.includes(search)) &&
        (status == "" || st == status) &&
        (role == "" || rl == role)
      );
    }

    function totalPages() {
      return Math.max(1, Math.ceil(filtered.length / itemsPerPage));
    }

    function renderPages() {
      const container = pagesContainer();
      if (!container) return;
      container.innerHTML = "";
      const pages = totalPages();
      for (let i = 1; i <= pages; i++) {
        const btn = document.createElement("button");
        btn.type = "button";
        btn.className = "pagination-page" + (i == currentPage ? " active" : "");
        btn.textContent = i;
        btn.addEventListener("click", () => goToPage(i));
        container.appendChild(btn);
      }
      updateNavButtons();
    }

    function updateNavButtons() {
      const p = prevBtn();
      const n = nextBtn();
      if (p) p.disabled = currentPage == 1;
      if (n) n.disabled = currentPage == totalPages();

      document.querySelectorAll(".pagination-page").forEach((btn, idx) => {
        btn.classList.toggle("active", idx + 1 == currentPage);
      });
    }

    function updateRows() {
      const all = rows();
      // Ẩn tất cả
      all.forEach((r) => (r.style.display = "none"));

      // Hiện theo trang hiện tại trong danh sách đã lọc
      const start = (currentPage - 1) * itemsPerPage;
      const end = start + itemsPerPage;

      filtered.slice(start, end).forEach((r) => (r.style.display = ""));
    }

    function goToPage(page) {
      currentPage = Math.min(Math.max(page, 1), totalPages());
      updateRows();
      updateNavButtons();
    }

    function recalcAndRender(goFirst = false) {
      filtered = rows().filter(isMatch);
      if (goFirst) currentPage = 1;
      const pages = totalPages();
      if (currentPage > pages) currentPage = pages;
      renderPages();
      updateRows();
    }

    function bindNav() {
      prevBtn()?.addEventListener("click", () => goToPage(currentPage - 1));
      nextBtn()?.addEventListener("click", () => goToPage(currentPage + 1));
    }

    function init() {
      bindNav();
      recalcAndRender(true);
    }

    return { init, recalcAndRender, goToPage };
  })();

  // Thay thân filterTable để dùng pager (giữ nguyên tên để không phải đổi HTML)
  function filterTable() {
    UserTablePager.recalcAndRender(true);
  }

  // Khởi tạo khi DOM sẵn sàng
  document.addEventListener("DOMContentLoaded", function () {
    UserTablePager.init();
  });
</script>

<!-- Modal chỉnh sửa người dùng - Dark Theme -->
<div class="modal fade" id="editUserModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content edit-modal-dark">
      <div class="modal-header">
        <h5 class="modal-title">
          <i class="fa-solid fa-user-pen me-2"></i>Chỉnh sửa Thông tin Người
          dùng
        </h5>
        <button
          type="button"
          class="btn-close btn-close-white"
          data-bs-dismiss="modal"
          aria-label="Đóng"
        ></button>
      </div>
      <div class="modal-body">
        <form id="editUserForm" novalidate>
          <input type="hidden" id="editUserId" />
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label">Họ và tên</label>
              <input
                type="text"
                class="form-control"
                id="editName"
                placeholder="Nhập họ tên..."
              />
              <div class="invalid-feedback" id="editNameError"></div>
            </div>
            <div class="col-md-6">
              <label class="form-label">Số điện thoại</label>
              <input
                type="text"
                class="form-control"
                id="editPhone"
                placeholder="Nhập SĐT (VD: 0912345678)..."
                maxlength="10"
              />
              <div class="invalid-feedback" id="editPhoneError"></div>
            </div>
            <div class="col-12">
              <label class="form-label">Email</label>
              <input
                type="email"
                class="form-control"
                id="editEmail"
                disabled
                title="Email không thể thay đổi"
              />
            </div>
            <div class="col-md-6">
              <label class="form-label">Giới tính</label>
              <select class="form-select" id="editGender">
                <option value="true">Nam</option>
                <option value="false">Nữ</option>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label">Ngày sinh</label>
              <input type="date" class="form-control" id="editDob" />
              <div class="invalid-feedback" id="editDobError"></div>
            </div>
            <!-- THÊM MỚI: Trạng thái -->
            <div class="col-12">
              <label class="form-label">Trạng thái tài khoản</label>
              <div class="status-toggle-group">
                <input
                  type="radio"
                  class="btn-check"
                  name="statusRadio"
                  id="statusActive"
                  value="true"
                />
                <label
                  class="btn status-btn status-active-btn"
                  for="statusActive"
                >
                  <i class="fa-solid fa-circle-check me-1"></i>Hoạt động
                </label>
                <input
                  type="radio"
                  class="btn-check"
                  name="statusRadio"
                  id="statusBlock"
                  value="false"
                />
                <label
                  class="btn status-btn status-block-btn"
                  for="statusBlock"
                >
                  <i class="fa-solid fa-ban me-1"></i>Bị khóa
                </label>
              </div>
            </div>
            <div class="col-12">
              <label class="form-label">Vai trò</label>
              <div class="role-toggle-group">
                <input
                  type="radio"
                  class="btn-check"
                  name="roleRadio"
                  id="roleAdmin"
                  value="true"
                />
                <label class="btn role-btn" for="roleAdmin">
                  <i class="fa-solid fa-user-shield me-1"></i>Quản trị viên
                </label>
                <input
                  type="radio"
                  class="btn-check"
                  name="roleRadio"
                  id="roleUser"
                  value="false"
                />
                <label class="btn role-btn" for="roleUser">
                  <i class="fa-solid fa-user me-1"></i>Người dùng
                </label>
              </div>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button
          type="button"
          class="btn btn-cancel"
          id="cancelBtn"
          data-bs-dismiss="modal"
        >
          <i class="fa-solid fa-xmark me-1"></i>Hủy
        </button>
        <button type="button" class="btn btn-save" id="saveChangesBtn">
          <i class="fa-solid fa-floppy-disk me-1"></i>Lưu thay đổi
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Modal xác nhận xóa người dùng -->
<div class="modal fade" id="deleteUserModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content edit-modal-dark">
      <div
        class="modal-header"
        style="
          background: linear-gradient(
            135deg,
            rgba(239, 68, 68, 0.15),
            rgba(220, 38, 38, 0.1)
          );
        "
      >
        <h5 class="modal-title">
          <i
            class="fa-solid fa-triangle-exclamation me-2"
            style="color: #ef4444"
          ></i
          >Xác nhận xóa người dùng
        </h5>
        <button
          type="button"
          class="btn-close btn-close-white"
          data-bs-dismiss="modal"
          aria-label="Đóng"
        ></button>
      </div>
      <div class="modal-body text-center py-4">
        <div style="font-size: 48px; color: #ef4444; margin-bottom: 16px">
          <i class="fa-solid fa-user-xmark"></i>
        </div>
        <input type="hidden" id="deleteUserId" />
        <p class="mb-2" style="font-size: 1.1rem">
          Bạn có chắc chắn muốn xóa người dùng:
        </p>
        <p
          class="fw-bold mb-3"
          style="font-size: 1.2rem; color: #fff"
          id="deleteUserName"
        ></p>
        <p class="text-muted small mb-0">
          <i class="fa-solid fa-circle-info me-1"></i>
          Hành động này không thể hoàn tác. Tất cả dữ liệu liên quan sẽ bị xóa
          vĩnh viễn.
        </p>
      </div>
      <div class="modal-footer justify-content-center">
        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
          <i class="fa-solid fa-xmark me-1"></i>Hủy bỏ
        </button>
        <button
          type="button"
          class="btn"
          id="confirmDeleteBtn"
          style="
            background: linear-gradient(135deg, #dc2626, #ef4444) !important;
            border: none !important;
            color: #fff !important;
            padding: 10px 24px;
            border-radius: 10px;
            font-weight: 600;
            box-shadow: 0 4px 14px rgba(239, 68, 68, 0.35);
            transition: all 0.25s ease;
          "
        >
          <i class="fa-solid fa-trash-can me-1"></i>Xóa người dùng
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Toast thông báo -->
<div
  class="toast-container position-fixed top-0 end-0 p-3"
  style="z-index: 9999"
>
  <div
    id="successToast"
    class="toast align-items-center border-0"
    role="alert"
    aria-live="assertive"
    aria-atomic="true"
  >
    <div class="d-flex">
      <div class="toast-body">
        <i class="fa-solid fa-circle-check me-2"></i>
        <span id="toastMessage">Cập nhật thành công!</span>
      </div>
      <button
        type="button"
        class="btn-close btn-close-white me-2 m-auto"
        data-bs-dismiss="toast"
        aria-label="Close"
      ></button>
    </div>
  </div>
</div>

<!-- Script bổ sung -->
<script>
  (function initEditModal() {
    const modalEl = document.getElementById("editUserModal");
    const deleteModalEl = document.getElementById("deleteUserModal");
    const toastEl = document.getElementById("successToast");
    const toastMessage = document.getElementById("toastMessage");
    let bsModal, bsDeleteModal, bsToast;

    function ensureBootstrapModal() {
      if (!bsModal) bsModal = new bootstrap.Modal(modalEl);
      return bsModal;
    }

    function ensureDeleteModal() {
      if (!bsDeleteModal) bsDeleteModal = new bootstrap.Modal(deleteModalEl);
      return bsDeleteModal;
    }

    function ensureBootstrapToast() {
      if (!bsToast) bsToast = new bootstrap.Toast(toastEl, { delay: 3000 });
      return bsToast;
    }

    function showToast(message, isError = false) {
      toastMessage.textContent = message;
      toastEl.classList.toggle("toast-error", isError);
      const icon = toastEl.querySelector(".toast-body i");
      icon.className = isError
        ? "fa-solid fa-circle-xmark me-2"
        : "fa-solid fa-circle-check me-2";
      ensureBootstrapToast().show();
    }

    // Validation functions
    function validateName(name) {
      if (!name || name.trim() === "") {
        return "Họ tên không được để trống!";
      }
      return null;
    }

    function validatePhone(phone) {
      if (!phone || phone.trim() === "") {
        return "Số điện thoại không được để trống!";
      }
      const phonePattern = /^0\d{9}$/;
      if (!phonePattern.test(phone.trim())) {
        return "Số điện thoại phải bắt đầu bằng số 0 và có đúng 10 chữ số!";
      }
      return null;
    }

    function validateDob(dob) {
      if (!dob) {
        return "Ngày sinh không được để trống!";
      }
      const dobDate = new Date(dob);
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      if (dobDate > today) {
        return "Ngày sinh không được vượt quá ngày hiện tại!";
      }
      return null;
    }

    function clearValidation() {
      document.querySelectorAll(".form-control, .form-select").forEach((el) => {
        el.classList.remove("is-invalid");
      });
      document.querySelectorAll(".invalid-feedback").forEach((el) => {
        el.textContent = "";
      });
    }

    function showFieldError(fieldId, errorId, message) {
      const field = document.getElementById(fieldId);
      const error = document.getElementById(errorId);
      if (field) field.classList.add("is-invalid");
      if (error) error.textContent = message;
    }

    // Event Delegation cho bảng user
    document
      .getElementById("user-table")
      .addEventListener("click", function (e) {
        // Xử lý nút SỬA
        const editBtn = e.target.closest(".btn-outline-primary");
        if (editBtn) {
          e.preventDefault();
          e.stopPropagation();

          const tr = editBtn.closest("tr");
          if (!tr) return;

          clearValidation();

          const id = tr.dataset.id || "";
          const name = tr.dataset.name || "";
          const email = tr.dataset.email || "";
          const phone = tr.dataset.phone || "";
          const gender = tr.dataset.gender || "";
          const dob = tr.dataset.dob || "";
          const role = tr.dataset.role || "";
          const active = tr.dataset.active || "true";

          document.getElementById("editUserId").value = id;
          document.getElementById("editName").value = name;
          document.getElementById("editEmail").value = email;
          document.getElementById("editPhone").value = phone;
          document.getElementById("editDob").value = dob;

          document.getElementById("editGender").value =
            gender === "Nam" ? "true" : "false";

          if (role === "Quản trị viên") {
            document.getElementById("roleAdmin").checked = true;
          } else {
            document.getElementById("roleUser").checked = true;
          }

          if (active === "true") {
            document.getElementById("statusActive").checked = true;
          } else {
            document.getElementById("statusBlock").checked = true;
          }

          ensureBootstrapModal().show();
          return;
        }

        // Xử lý nút XÓA
        const deleteBtn = e.target.closest(".btn-outline-danger");
        if (deleteBtn) {
          e.preventDefault();
          e.stopPropagation();

          const tr = deleteBtn.closest("tr");
          if (!tr) return;

          const id = tr.dataset.id || "";
          const name = tr.dataset.name || "";
          const email = tr.dataset.email || "";

          document.getElementById("deleteUserId").value = id;
          document.getElementById("deleteUserName").textContent =
            name + " (" + email + ")";

          ensureDeleteModal().show();
        }
      });

    // Sự kiện nút Hủy (Edit Modal)
    document.getElementById("cancelBtn").addEventListener("click", function () {
      document.getElementById("editUserForm").reset();
      clearValidation();
    });

    // Sự kiện nút Lưu
    document
      .getElementById("saveChangesBtn")
      .addEventListener("click", async function () {
        const saveBtn = this;

        clearValidation();

        const name = document.getElementById("editName").value;
        const phone = document.getElementById("editPhone").value;
        const dob = document.getElementById("editDob").value;

        let hasError = false;

        const nameError = validateName(name);
        if (nameError) {
          showFieldError("editName", "editNameError", nameError);
          hasError = true;
        }

        const phoneError = validatePhone(phone);
        if (phoneError) {
          showFieldError("editPhone", "editPhoneError", phoneError);
          hasError = true;
        }

        const dobError = validateDob(dob);
        if (dobError) {
          showFieldError("editDob", "editDobError", dobError);
          hasError = true;
        }

        if (hasError) {
          showToast("Vui lòng kiểm tra lại thông tin!", true);
          return;
        }

        const formData = new URLSearchParams();
        formData.append("id", document.getElementById("editUserId").value);
        formData.append("fullname", name.trim());
        formData.append("mobile", phone.trim());
        formData.append("email", document.getElementById("editEmail").value);
        formData.append("gender", document.getElementById("editGender").value);
        formData.append("birthdate", dob);
        formData.append(
          "admin",
          document.querySelector('input[name="roleRadio"]:checked')?.value ||
            "false"
        );
        formData.append(
          "active",
          document.querySelector('input[name="statusRadio"]:checked')?.value ||
            "true"
        );

        saveBtn.classList.add("loading");
        saveBtn.disabled = true;

        try {
          const response = await fetch(
            "${pageContext.request.contextPath}/admin/user/update",
            {
              method: "POST",
              headers: {
                "Content-Type": "application/x-www-form-urlencoded",
              },
              body: formData.toString(),
            }
          );

          const result = await response.json();

          if (result.success) {
            showToast("Cập nhật người dùng thành công!");
            ensureBootstrapModal().hide();
            setTimeout(() => {
              window.location.reload();
            }, 1000);
          } else {
            showToast(result.message || "Có lỗi xảy ra!", true);
          }
        } catch (error) {
          console.error("Update error:", error);
          showToast("Lỗi kết nối server!", true);
        } finally {
          saveBtn.classList.remove("loading");
          saveBtn.disabled = false;
        }
      });

    // Sự kiện nút XÁC NHẬN XÓA
    document
      .getElementById("confirmDeleteBtn")
      .addEventListener("click", async function () {
        const deleteBtn = this;
        const userId = document.getElementById("deleteUserId").value;

        if (!userId) {
          showToast("Không tìm thấy ID người dùng!", true);
          return;
        }

        deleteBtn.innerHTML =
          '<i class="fa-solid fa-spinner fa-spin me-1"></i>Đang xóa...';
        deleteBtn.disabled = true;

        try {
          const formData = new URLSearchParams();
          formData.append("id", userId);

          const response = await fetch(
            "${pageContext.request.contextPath}/admin/user/delete",
            {
              method: "POST",
              headers: {
                "Content-Type": "application/x-www-form-urlencoded",
              },
              body: formData.toString(),
            }
          );

          const result = await response.json();

          if (result.success) {
            ensureDeleteModal().hide();
            showToast("Xóa người dùng thành công!");
            setTimeout(() => {
              window.location.reload();
            }, 1000);
          } else {
            showToast(result.message || "Có lỗi xảy ra!", true);
          }
        } catch (error) {
          console.error("Delete error:", error);
          showToast("Lỗi kết nối server!", true);
        } finally {
          deleteBtn.innerHTML =
            '<i class="fa-solid fa-trash-can me-1"></i>Xóa người dùng';
          deleteBtn.disabled = false;
        }
      });

    // Reset form khi modal đóng
    modalEl.addEventListener("hidden.bs.modal", function () {
      document.getElementById("editUserForm").reset();
      clearValidation();
    });

    // Real-time validation
    document.getElementById("editName").addEventListener("input", function () {
      const error = validateName(this.value);
      if (error) {
        showFieldError("editName", "editNameError", error);
      } else {
        this.classList.remove("is-invalid");
        document.getElementById("editNameError").textContent = "";
      }
    });

    document.getElementById("editPhone").addEventListener("input", function () {
      this.value = this.value.replace(/[^0-9]/g, "");

      const error = validatePhone(this.value);
      if (error && this.value.length > 0) {
        showFieldError("editPhone", "editPhoneError", error);
      } else {
        this.classList.remove("is-invalid");
        document.getElementById("editPhoneError").textContent = "";
      }
    });

    document.getElementById("editDob").addEventListener("change", function () {
      const error = validateDob(this.value);
      if (error) {
        showFieldError("editDob", "editDobError", error);
      } else {
        this.classList.remove("is-invalid");
        document.getElementById("editDobError").textContent = "";
      }
    });
  })();
</script>
