<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="jakarta.tags.core" prefix="c"%> <%@
taglib uri="jakarta.tags.functions" prefix="fn"%>
<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/assets/css/theme.css"
/>
<style>
  /* Layout & card */
  .main-card {
    background: var(--bg-panel);
    border: 1px solid var(--border-subtle);
    border-radius: 16px;
    padding: 24px;
    box-shadow: var(--shadow-soft);
    color: var(--gray-light);
  }
  .card {
    border-radius: 14px;
    border: 1px solid var(--border-subtle);
    background: var(--bg-panel);
  }

  /* Inputs */
  .form-control,
  .form-select,
  .post-search-input,
  #post-title,
  .upload-input-group .form-control,
  .editor {
    background: var(--bg-soft) !important;
    border: 1px solid var(--border-subtle) !important;
    color: var(--gray-light) !important;
    border-radius: 12px;
    box-shadow: none;
    transition: border-color 0.18s ease, box-shadow 0.18s ease,
      background 0.18s ease;
  }
  .form-control::placeholder {
    color: var(--gray-muted);
  }
  .form-control:focus,
  .form-select:focus,
  .post-search-input:focus,
  .editor:focus {
    border-color: var(--accent);
    box-shadow: 0 6px 18px -6px rgba(99, 102, 241, 0.28),
      0 0 0 4px rgba(99, 102, 241, 0.06);
    outline: none;
  }

  /* Search */
  .post-search {
    position: relative;
  }
  .post-search-icon,
  .search-input .fa-magnifying-glass {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--gray-icon);
    font-size: 14px;
  }
  .post-search-input {
    padding-left: 38px;
  }

  /* Filter buttons */
  .filter-btn-group {
    display: flex;
    gap: 10px;
    justify-content: flex-end;
    flex-wrap: wrap;
  }
  .filter-btn {
    color: white;
    background: rgba(99, 102, 241, 0.1);
    border: 1px solid rgba(99, 102, 241, 0.22);
    padding: 8px 16px;
    border-radius: 999px;
    font-weight: 600;
    transition: background 0.18s, color 0.18s, box-shadow 0.18s,
      border-color 0.18s;
  }
  .filter-btn:hover {
    background: rgba(99, 102, 241, 0.16);
    color: #fff;
  }
  .filter-btn.active {
    background: var(--accent);
    color: #fff;
    border-color: var(--accent);
    /*inset 0 -2px 0 rgba(0, 0, 0, 0.25);*/
  }

  /* Tabs (pill/boxed) */
  .nav-tabs.custom-tabs {
    border: 1px solid var(--border-subtle);
    background: var(--bg-soft);
    border-radius: 12px;
    padding: 6px;
    gap: 6px;
    box-shadow: var(--shadow-soft);
  }
  .custom-tabs .nav-link {
    border: 0 !important;
    background: transparent;
    color: var(--gray-light);
    padding: 8px 16px;
    border-radius: 10px;
    transition: background 0.18s ease, color 0.18s ease, transform 0.18s ease;
  }
  .custom-tabs .nav-link:hover {
    background: rgba(255, 255, 255, 0.06);
    color: #fff;
    transform: translateY(-1px);
  }
  .custom-tabs .nav-link::after {
    display: none;
  }
  .custom-tabs .nav-link.active {
    color: #fff;
    background: var(--accent);
    border: 1px solid var(--accent) !important;
  }

  /* Tab content transition */
  .tab-content .tab-pane {
    will-change: transform, opacity;
    transition: transform 240ms ease, opacity 240ms ease;
    transform: translateX(12px);
    opacity: 0;
  }
  .tab-content .tab-pane.active.show {
    transform: translateX(0);
    opacity: 1;
  }

  /* Post list header */
  .list-header {
    display: grid !important; /* force grid, avoid d-flex override */
    grid-template-columns: 1fr 140px 100px 160px 110px;
    align-items: center;
    background-color: var(--bg-panel) !important;
    border: 1px solid var(--border-subtle) !important;
    border-radius: 10px;
    padding: 16px 20px; /* match .post-table cell padding */
    gap: 0;
  }

  /* Header khớp lại width cho Ngày/Lượt xem */
  .list-header {
    grid-template-columns: 1fr 120px 120px 160px 110px;
  }

  /* Cột 2 (Ngày) và 3 (Lượt xem) đều nhau + số thẳng hàng */
  .post-table td:nth-child(2),
  .post-table th:nth-child(2),
  .post-table td:nth-child(3),
  .post-table th:nth-child(3) {
    width: 120px;
    text-align: center;
    font-variant-numeric: tabular-nums;
    -webkit-font-feature-settings: "tnum";
    font-feature-settings: "tnum";
    padding-left: 8px;
    padding-right: 8px;
  }

  /* Giữ padding tổng thể nhỏ gọn */
  .post-table td {
    padding: 12px 16px;
  }

  /* ========== TABLE (reset + match header) ========== */
  .post-table-wrapper {
    background: var(--bg-panel);
    border: 1px solid var(--border-subtle);
    border-radius: 12px;
    overflow: hidden;
    margin-top: 10px;
  }

  .post-table {
    width: 100%;
    border-collapse: collapse;
    table-layout: fixed;
  }

  /* Reset lại các nền/spacing cũ của Bootstrap & custom trước đó */
  .post-table td {
    padding: 12px 16px;
    background: transparent !important;
    vertical-align: middle;
    border-top: 1px solid var(--border-subtle);
  }
  .post-table tbody tr:first-child td {
    border-top: 0;
  }
  .post-table tbody tr:hover td {
    background: rgba(255, 255, 255, 0.03);
  }

  /* Khớp chiều rộng/căn với .list-header */
  .post-table td:nth-child(2),
  .post-table th:nth-child(2) {
    width: 136px;
    text-align: center;
  }
  .post-table td:nth-child(3),
  .post-table th:nth-child(3) {
    width: 100px;
    text-align: center;
  }
  .post-table td:nth-child(4),
  .post-table th:nth-child(4) {
    width: 160px;
    text-align: center;
  }
  .post-table td:nth-child(5),
  .post-table th:nth-child(5) {
    width: 152px;
    text-align: center !important;
  }

  /* Giữ layout meta bài viết */
  .post-meta {
    display: flex;
    align-items: center;
    gap: 14px;
  }
  .post-thumb {
    width: 56px;
    height: 56px;
    border-radius: 10px;
    object-fit: cover;
    flex: 0 0 64px;
  }

  @media (max-width: 992px) {
    .post-thumb {
      width: 48px;
      height: 48px;
    }
  }

  /* Buttons */
  .btn-cancel {
    background: transparent;
    color: var(--gray-subtle);
    border-radius: 10px;
    padding: 8px 12px;
  }
  .btn-outline-secondary {
    border-radius: 10px;
  }
  .btn-primary {
    border-radius: 10px;
    box-shadow: var(--shadow-accent);
  }

  /* Pagination */
  .page-item .page-link {
    background: var(--bg-soft);
    border: 1px solid var(--border-subtle);
    /*color: var(--text-secondary);*/
    border-radius: 10px;
    padding: 0.45rem 0.8rem;
  }
  .page-item.active .page-link {
    background: var(--accent);
    border-color: var(--accent);
    color: #fff;
    /*box-shadow: 0 10px 24px -12px var(--accent-glow);*/
  }

  /* Input group prefix */
  .input-group-text {
    background: var(--bg-soft) !important;
    border: 1px solid var(--border-subtle) !important;
    color: var(--gray-subtle) !important;
    border-radius: 10px;
  }

  /* Helper text */
  .form-text,
  .upload-help {
    color: var(--gray-light) !important;
    font-size: 0.95rem;
    line-height: 1.6;
    opacity: 1;
  }
  .form-text code {
    color: var(--gray-light) !important;
    background: rgba(255, 255, 255, 0.06);
    border: 1px solid var(--border-subtle);
    padding: 2px 6px;
    border-radius: 6px;
    font-weight: 600;
  }

  /* Responsive */
  @media (max-width: 992px) {
    .list-header {
      grid-template-columns: 1fr 120px 90px 140px 100px;
      padding: 10px 14px;
    }
    .post-thumb {
      width: 48px;
      height: 48px;
    }
  }

  /* Nhẹ padding mỗi hàng */
  .post-table td {
    padding: 12px 16px;
  }

  /* Thumbnail nhỏ gọn hơn */
  .post-thumb {
    width: 56px;
    height: 56px;
  }

  /* Tiêu đề/ mô tả gọn, tránh tràn */
  .post-title {
    width: 475px;
    font-weight: 600;
    color: #fff !important;
    margin-bottom: 4px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .post-desc {
    color: var(--gray-light);
    opacity: 0.9;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  /* Căn giữa cho ngày đăng, lượt xem, trạng thái */
  .post-table td:nth-child(2),
  .post-table td:nth-child(3),
  .post-table td:nth-child(4) {
    text-align: center;
  }

  /* Icon hành động rõ hơn, hover nổi */
  .action-icons i {
    color: var(--gray-icon);
    opacity: 0.85;
    transition: color 0.18s, transform 0.18s, opacity 0.18s;
    cursor: pointer;
  }
  .action-icons i:hover {
    color: #fff;
    opacity: 1;
    transform: translateY(-1px);
  }

  /* Badge đồng bộ màu */
  .badge-publish,
  .badge-draft {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 999px;
    font-weight: 600;
    border: 1px solid var(--border-subtle);
  }
  .badge-publish {
    background: rgba(99, 102, 241, 0.12);
    border-color: rgba(99, 102, 241, 0.28);
    color: #fff;
  }
  .badge-draft {
    background: rgba(255, 255, 255, 0.06);
  }

  /* Hover hàng nhẹ hơn */
  .post-table tbody tr:hover td {
    background: rgba(255, 255, 255, 0.02);
  }

  /* Header: giảm padding cho khớp bảng */
  .list-header {
    padding: 12px 16px;
  }

  /* Hiển thị rõ màu chữ cho các cột số liệu */
  .post-table th,
  .post-table td {
    color: #e6e9f2; /* màu chữ sáng hơn */
  }

  .post-table td:nth-child(2),
        .post-table th:nth-child(2), /* Ngày đăng */
        .post-table td:nth-child(3),
        .post-table th:nth-child(3), /* Lượt xem */
        .post-table td:nth-child(4),
        .post-table th:nth-child(4)  /* Trạng thái */ {
    color: #f0f3ff; /* sáng hơn nữa cho dễ đọc */
    opacity: 0.95;
  }

  /* ============ TYPOGRAPHY COLOR SYSTEM (dark) ============ */
  :root {
    --text-1: #eef2ff; /* tiêu đề/chính */
    --text-2: #d5daf0; /* nội dung thường */
    --text-3: #a6afc3; /* mô tả/phụ */
    --text-muted: #8e97ad; /* placeholder/nhãn mờ */
    --text-accent: #cfd2ff; /* nhấn nhẹ trên nền tối */
  }

  /* Base text */
  .main-card,
  .card,
  .post-table,
  .list-header {
    color: var(--text-2);
  }
  .main-card h1,
  .main-card h2,
  .main-card h3,
  .main-card h4,
  .main-card h5,
  .main-card h6 {
    color: var(--text-1);
  }

  /* Tabs */
  .custom-tabs .nav-link {
    color: var(--text-2);
  }
  .custom-tabs .nav-link:hover {
    color: var(--text-1);
  }

  /* Header hàng bảng */
  .list-header > div {
    color: var(--text-3);
    font-weight: 700;
    letter-spacing: 0.02em;
  }

  /* Bài viết: tiêu đề & mô tả */
  .post-title {
    color: var(--text-1);
  }
  .post-desc {
    color: var(--text-3);
    opacity: 1;
  }

  /* Ô nhập & placeholder */
  .form-control,
  .form-select,
  .post-search-input,
  .editor {
    color: var(--text-2) !important;
  }
  .form-control::placeholder,
  .post-search-input::placeholder {
    color: var(--text-muted) !important;
  }

  /* Bảng: chữ thường & cột số liệu nổi bật */
  .post-table th,
  .post-table td {
    color: var(--text-2);
  }

  .post-table td:nth-child(2),
      .post-table th:nth-child(2), /* Ngày đăng */
      .post-table td:nth-child(3),
      .post-table th:nth-child(3), /* Lượt xem */
      .post-table td:nth-child(4),
      .post-table th:nth-child(4)  /* Trạng thái */ {
    color: var(--text-1);
  }

  /* Badge trạng thái */
  .badge-publish {
    color: var(--text-1);
    background: rgba(99, 102, 241, 0.14);
    border-color: rgba(99, 102, 241, 0.28);
  }
  .badge-draft {
    color: var(--text-2);
    background: rgba(255, 255, 255, 0.06);
  }

  /* Icon hành động */
  .action-icons i {
    color: var(--text-3);
  }
  .action-icons i:hover {
    color: var(--text-1);
  }

  /* Preview boxes: luôn hiện khung + tỉ lệ 16:9 */
  .upload-preview {
    width: 100%;
    aspect-ratio: 16/9;
    min-height: 220px; /* fallback cho cột hẹp */
    border: 1px dashed var(--border-subtle);
    border-radius: 12px;
    background: var(--bg-soft);
    display: grid;
    place-items: center;
    overflow: hidden;
    position: relative;
  }

  /* Hiệu ứng shimmer khi chưa có nội dung */
  /* .upload-preview:not(.has-content)::before {
      content: "";
      position: absolute;
      inset: 0;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,.06), transparent);
      transform: translateX(-100%);
      animation: shimmer 1.6s infinite;
    }
    @keyframes shimmer { to { transform: translateX(100%); } } */

  /* Nội dung xem trước */
  .upload-preview img,
  .upload-preview iframe {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
    border: 0;
    border-radius: 12px;
  }

  /* Text trống/ lỗi trong khung */
  .upload-preview .text-secondary,
  .upload-preview .text-warning,
  .upload-preview .text-danger {
    z-index: 1;
    text-align: center;
    color: var(--text-muted) !important;
    font-size: 0.95rem;
  }

  /* Editor height */
  .editor {
    min-height: 700px !important; /* tăng chiều cao mặc định */
    resize: vertical; /* cho phép kéo dọc */
    line-height: 1.6;
  }

  /* Modal & form polish */
  #editVideoModal .modal-content {
    background: var(--bg-panel);
    border: 1px solid var(--border-subtle);
    border-radius: 14px;
    box-shadow: var(--shadow-soft);
  }
  #editVideoModal .modal-header {
    border-bottom: 1px solid var(--border-subtle);
  }
  #editVideoModal .modal-footer {
    border-top: 1px solid var(--border-subtle);
  }
  #editVideoForm .form-label {
    color: var(--text-2);
    font-weight: 600;
  }
  #editVideoForm .form-control,
  #editVideoForm .form-select {
    background: var(--bg-soft) !important;
    border: 1px solid var(--border-subtle) !important;
    color: var(--text-2) !important;
    border-radius: 10px;
  }
  #editVideoForm .form-text {
    color: var(--text-3);
  }

  /* ============ TOAST NOTIFICATION ============ */
  .toast-container {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 9999;
    display: flex;
    flex-direction: column;
    gap: 10px;
  }

  .toast-notification {
    min-width: 300px;
    max-width: 400px;
    padding: 16px 20px;
    border-radius: 10px;
    color: #fff;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    animation: slideIn 0.3s ease-out;
    cursor: pointer;
  }

  .toast-notification.success {
    background: linear-gradient(135deg, #28a745, #20c997);
  }

  .toast-notification.error {
    background: linear-gradient(135deg, #dc3545, #c82333);
  }

  .toast-notification.warning {
    background: linear-gradient(135deg, #ffc107, #e0a800);
    color: #212529;
  }

  .toast-notification i {
    font-size: 20px;
  }

  @keyframes slideIn {
    from {
      transform: translateX(100%);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }

  @keyframes slideOut {
    from {
      transform: translateX(0);
      opacity: 1;
    }
    to {
      transform: translateX(100%);
      opacity: 0;
    }
  }
</style>
<div class="container-fluid">
  <ul class="nav nav-tabs custom-tabs" id="managementTabs" role="tablist">
    <li class="nav-item" role="presentation">
      <button
        class="nav-link active"
        id="tab-create"
        data-bs-toggle="tab"
        data-bs-target="#tab-pane-create"
        type="button"
        role="tab"
        aria-controls="tab-pane-create"
        aria-selected="true"
      >
        Tạo bài viết mới
      </button>
    </li>
    <li class="nav-item" role="presentation">
      <button
        class="nav-link"
        id="tab-posts"
        data-bs-toggle="tab"
        data-bs-target="#tab-pane-posts"
        type="button"
        role="tab"
        aria-controls="tab-pane-posts"
        aria-selected="false"
      >
        Bài viết
      </button>
    </li>
  </ul>

  <div class="tab-content" id="managementTabsContent">
    <div
      class="tab-pane fade"
      id="tab-pane-posts"
      role="tabpanel"
      aria-labelledby="tab-posts"
    >
      <div class="main-card">
        <div class="d-flex align-items-center justify-content-between">
          <h2 class="fw-bold">Quản lý bài viết</h2>
        </div>

        <!-- Search + Filter -->
        <div class="row align-items-center mt-4 mb-4 gy-2">
          <div class="col-md-7">
            <div class="post-search">
              <i class="fa-solid fa-magnifying-glass post-search-icon"></i>
              <input
                type="text"
                class="form-control post-search-input"
                placeholder="Tìm kiếm bài viết theo tiêu đề..."
              />
            </div>
          </div>

          <div class="col-md-5">
            <div class="filter-btn-group">
              <button type="button" class="filter-btn active">Tất cả</button>
              <button type="button" class="filter-btn">Đã xuất bản</button>
              <button type="button" class="filter-btn">Nháp</button>
            </div>
          </div>
        </div>

        <!-- Header -->
        <div class="list-header">
          <!-- removed d-flex -->
          <div class="flex-grow-1">TIÊU ĐỀ</div>
          <div style="width: 140px">NGÀY ĐĂNG</div>
          <div style="width: 100px">LƯỢT XEM</div>
          <div style="width: 160px">TRẠNG THÁI</div>
          <div style="width: 110px">HÀNH ĐỘNG</div>
        </div>

        <!-- LIST -->
        <div class="post-table-wrapper">
          <table class="table post-table align-middle">
            <tbody id="postTableBody">
              <c:forEach var="v" items="${videos}">
                <tr
                  data-id="${v.id}"
                  data-linkyoutube="${fn:escapeXml(v.linkYoutube)}"
                  data-title="${fn:escapeXml(v.title)}"
                  data-content="${fn:escapeXml(v.content)}"
                  data-status="${v.status ? '1' : '0'}"
                  data-postingdate="${empty v.postingDate ? '' : v.postingDate}"
                  data-thumbnailurl="${fn:escapeXml(v.thumbnailUrl)}"
                  data-channelname="${fn:escapeXml(v.channelName)}"
                >
                  <%-- yyyy-MM-dd --%>
                  <td>
                    <div class="post-meta">
                      <img
                        src="${empty v.thumbnailUrl ? pageContext.request.contextPath.concat('/img/anh3.png') : v.thumbnailUrl}"
                        class="post-thumb"
                        alt="Thumbnail"
                      />
                      <div>
                        <div class="post-title" title="${v.title}">
                          ${v.title}
                        </div>
                        <div class="post-desc" title="${v.content}">
                          ${v.content}
                        </div>
                        <div class="small text-muted">ID: ${v.id}</div>
                        <div class="small text-muted">
                          Link: ${v.linkYoutube}
                        </div>
                      </div>
                    </div>
                  </td>
                  <td>
                    <c:out
                      value="${empty v.postingDate ? '-' : v.postingDate}"
                    />
                  </td>
                  <td>${v.views}</td>
                  <td>
                    <span class="${v.status ? 'badge-publish' : 'badge-draft'}">
                      ${v.status ? 'Đã xuất bản' : 'Nháp'}
                    </span>
                  </td>
                  <td class="text-end action-icons">
                    <button
                      type="button"
                      class="btn btn-sm btn-outline-primary btn-edit"
                    >
                      <i class="fa-regular fa-pen-to-square"></i>
                    </button>
                    <button
                      type="button"
                      class="btn btn-sm btn-outline-danger btn-delete"
                    >
                      <i class="fa-regular fa-trash-can"></i>
                    </button>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>

        <!-- Footer -->
        <div class="d-flex justify-content-center mt-4">
          <ul class="pagination mb-0" id="postPagination"></ul>
        </div>
      </div>
    </div>

    <!-- nội dung trong tạo bài -->
    <div
      class="tab-pane fade show active"
      id="tab-pane-create"
      role="tabpanel"
      aria-labelledby="tab-create"
    >
      <div class="main-card">
        <div class="empty-state">
          <div class="min-vh-100 d-flex flex-column">
            <main class="flex-grow-1 py-4">
              <div class="container-xxl">
                <div
                  class="d-flex flex-column flex-sm-row align-items-sm-center justify-content-sm-between gap-3 mb-4"
                >
                  <h1 class="display-6 fw-bold m-0">Tạo bài viết mới</h1>
                  <div class="d-flex align-items-center gap-2">
                    <button class="btn btn-cancel" id="btn-cancel-create">
                      Hủy
                    </button>
                    <button
                      class="btn btn-outline-secondary"
                      id="btn-save-draft"
                    >
                      Lưu nháp
                    </button>
                    <button class="btn btn-primary" id="btn-publish">
                      Đăng bài
                    </button>
                  </div>
                </div>

                <div class="row g-4">
                  <!-- Main column -->
                  <div class="col-lg-8 d-flex flex-column gap-4">
                    <div class="card">
                      <div class="card-body">
                        <label
                          for="post-title"
                          class="form-label text-start d-block"
                          >Tiêu đề bài viết</label
                        >
                        <input
                          id="post-title"
                          type="text"
                          class="form-control"
                          placeholder="Nhập tiêu đề ở đây..."
                        />
                      </div>
                    </div>

                    <div class="card">
                      <div class="card-body p-0">
                        <textarea
                          class="form-control editor"
                          placeholder="Bắt đầu viết nội dung của bạn ở đây..."
                        ></textarea>
                      </div>
                    </div>
                  </div>

                  <!-- Sidebar -->
                  <div class="col-lg-4 d-flex flex-column gap-4">
                    <div class="card upload-card">
                      <div class="card-body">
                        <label class="form-label upload-label"
                          >Ảnh đại diện</label
                        >
                        <form id="cover-form">
                          <div class="upload-input-group input-group mb-3">
                            <input
                              id="cover-url"
                              type="url"
                              class="form-control"
                              placeholder="Dán link ảnh (https://...)"
                            />
                            <button
                              id="btn-paste"
                              class="btn btn-outline-secondary"
                              type="button"
                              title="Dán từ clipboard"
                            >
                              Dán
                            </button>
                          </div>

                          <div class="upload-preview" id="cover-preview">
                            <div class="text-secondary small text-center">
                              Chưa có ảnh xem trước
                            </div>
                          </div>
                          <div class="upload-help mt-2">
                            Nhập link ảnh PNG, JPG, GIF. Ví dụ:
                            https://domain.com/image.jpg
                          </div>
                        </form>
                      </div>
                    </div>

                    <div class="card">
                      <div class="card-body">
                        <h3 class="h6 mb-3">Nhúng Video</h3>
                        <label for="video-id" class="form-label"
                          >ID YouTube</label
                        >
                        <div class="input-group">
                          <span class="input-group-text"
                            >https://www.youtube.com/embed/</span
                          >
                          <input
                            id="video-id"
                            type="text"
                            class="form-control"
                            placeholder="VIDEO_ID"
                          />
                        </div>

                        <div class="upload-preview mt-3" id="video-preview">
                          <div class="text-secondary small text-center">
                            Chưa có video xem trước
                          </div>
                        </div>
                        <div class="form-text mt-2">
                          Nhập ID video YouTube. Ví dụ: <code>DmjDQt7sEc</code>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </main>
          </div>
        </div>
      </div>
    </div>

    <div
      class="tab-pane fade"
      id="tab-pane-analytics"
      role="tabpanel"
      aria-labelledby="tab-analytics"
    >
      <div class="main-card">
        <div class="empty-state">
          <i class="fa-solid fa-chart-simple"></i>
          <p>Dữ liệu thống kê sẽ hiển thị khi có lượt xem và tương tác.</p>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<!-- Modal chỉnh sửa -->
<div class="modal fade" id="editVideoModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div
      class="modal-content"
      style="
        background: var(--bg-panel);
        border: 1px solid var(--border-subtle);
        border-radius: 14px;
      "
    >
      <div class="modal-header">
        <h5 class="modal-title" style="color: white">Sửa Video</h5>
        <button
          type="button"
          class="btn-close"
          data-bs-dismiss="modal"
          aria-label="Close"
        ></button>
      </div>
      <div class="modal-body">
        <form id="editVideoForm" novalidate>
          <input type="hidden" name="id" id="edit-id" />
          <div class="row g-3">
            <div class="col-md-8">
              <label class="form-label">Link Youtube</label>
              <input
                type="text"
                class="form-control"
                name="linkYoutube"
                id="edit-linkYoutube"
                data-required="true"
                data-field-name="Link Youtube"
              />
              <div class="form-text">
                Ví dụ: https://www.youtube.com/embed/xxxx
              </div>
            </div>
            <div class="col-md-4">
              <label class="form-label">Trạng thái</label>
              <select class="form-select" id="edit-status" name="status">
                <option value="0">Nháp</option>
                <option value="1">Xuất bản</option>
              </select>
            </div>
            <div class="col-md-8">
              <label class="form-label">Tiêu đề</label>
              <input
                type="text"
                class="form-control"
                name="title"
                id="edit-title"
                data-required="true"
                data-field-name="Tiêu đề"
              />
            </div>
            <div class="col-md-4">
              <label class="form-label">Ngày đăng</label>
              <input
                type="date"
                class="form-control"
                id="edit-postingDate"
                name="postingDate"
                disabled
              />
              <%--
              <div class="form-text">
                --%> <%-- Tự đặt theo trạng thái, bạn không thể sửa.--%> <%--
              </div>
              --%>
            </div>
            <div class="col-12">
              <label class="form-label">Nội dung</label>
              <textarea
                class="form-control"
                name="content"
                id="edit-content"
                rows="3"
                data-required="true"
                data-field-name="Nội dung"
              ></textarea>
            </div>
            <div class="col-md-8">
              <label class="form-label">Thumbnail URL</label>
              <input
                type="text"
                class="form-control"
                name="thumbnailUrl"
                id="edit-thumbnailUrl"
                data-required="true"
                data-field-name="Ảnh đại diện"
              />
              <div class="form-text" id="thumbnail-preview-status"></div>
            </div>
            <div class="col-md-4">
              <label class="form-label">Tên kênh</label>
              <input
                type="text"
                class="form-control"
                id="edit-channelName"
                disabled
                aria-disabled="true"
                title="Tác giả không thể sửa"
              />
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button class="btn btn-outline-secondary" data-bs-dismiss="modal">
          Hủy
        </button>
        <button class="btn btn-primary" id="btn-save-edit">Lưu</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal xác nhận xóa -->
<div
  class="modal fade"
  id="confirmDeleteModal"
  tabindex="-1"
  aria-hidden="true"
>
  <div class="modal-dialog modal-dialog-centered">
    <div
      class="modal-content"
      style="
        background: var(--bg-panel);
        border: 1px solid var(--border-subtle);
      "
    >
      <div class="modal-header">
        <h5 class="modal-title" style="color: #fff">Xác nhận xóa</h5>
        <button
          type="button"
          class="btn-close"
          data-bs-dismiss="modal"
          aria-label="Close"
        ></button>
      </div>
      <div class="modal-body" style="color: white">
        Bạn có chắc chắn muốn xóa video ID <span id="del-id-text"></span>? Thao
        tác này không thể hoàn tác.
      </div>
      <div class="modal-footer">
        <button
          type="button"
          class="btn btn-outline-secondary"
          data-bs-dismiss="modal"
        >
          Hủy
        </button>
        <button
          type="button"
          class="btn btn-danger"
          id="btn-confirm-delete"
          data-id=""
        >
          Xóa
        </button>
      </div>
    </div>
  </div>
</div>

<script>
  // ========== TOAST NOTIFICATION SYSTEM ==========
  function showToast(message, type = "error", duration = 4000) {
    const container = document.getElementById("toastContainer");
    if (!container) return;

    const toast = document.createElement("div");
    toast.className = "toast-notification " + type;

    let icon = "fa-circle-exclamation";
    if (type === "success") icon = "fa-circle-check";
    if (type === "warning") icon = "fa-triangle-exclamation";

    toast.innerHTML =
      '<i class="fa-solid ' + icon + '"></i><span>' + message + "</span>";
    container.appendChild(toast);

    // Click để đóng sớm
    toast.addEventListener("click", function () {
      toast.style.animation = "slideOut 0.3s ease-out forwards";
      setTimeout(() => toast.remove(), 300);
    });

    // Tự động đóng
    setTimeout(() => {
      if (toast.parentNode) {
        toast.style.animation = "slideOut 0.3s ease-out forwards";
        setTimeout(() => toast.remove(), 300);
      }
    }, duration);
  }

  // ========== VALIDATE YOUTUBE LINK ==========
  function isValidYoutubeLink(link) {
    if (!link || !link.trim()) return false;
    // Chấp nhận embed link hoặc watch link
    const patterns = [
      /youtube\.com\/embed\/[A-Za-z0-9_-]+/,
      /youtube\.com\/watch\?v=[A-Za-z0-9_-]+/,
      /youtu\.be\/[A-Za-z0-9_-]+/,
    ];
    return patterns.some((p) => p.test(link));
  }

  // ========== VALIDATE IMAGE URL ==========
  function validateImageUrl(url) {
    return new Promise((resolve) => {
      if (!url || !url.trim()) {
        resolve(false);
        return;
      }
      const img = new Image();
      img.onload = () => resolve(true);
      img.onerror = () => resolve(false);
      img.src = url;
      // Timeout sau 5 giây
      setTimeout(() => resolve(false), 5000);
    });
  }

  // Đợi DOM load xong hoàn toàn
  document.addEventListener("DOMContentLoaded", function () {
    const rowsPerPage = 6;
    const tbody = document.getElementById("postTableBody");
    if (!tbody) return;

    const allRows = Array.from(tbody.querySelectorAll("tr"));
    const pagination = document.getElementById("postPagination");
    let currentPage = 1;
    let filteredRows = [...allRows];

    // ========== KHAI BÁO SEARCH INPUT Ở ĐÂY ==========
    const searchInput = document.querySelector(".post-search-input");

    // Ẩn tất cả các dòng không thuộc filter
    function hideAllRows() {
      allRows.forEach((r) => {
        r.style.display = "none";
      });
    }

    function assignPageIndexes(rows) {
      rows.forEach((r, idx) => {
        const pageIndex = Math.floor(idx / rowsPerPage) + 1;
        r.dataset.page = pageIndex;
      });
    }

    function buildPagination(totalPages) {
      if (!pagination) return;
      pagination.innerHTML = "";

      const prev = document.createElement("li");
      prev.className = "page-item" + (currentPage === 1 ? " disabled" : "");
      prev.innerHTML = '<button class="page-link" type="button">Trước</button>';
      prev.onclick = () => currentPage > 1 && goToPage(currentPage - 1);
      pagination.appendChild(prev);

      for (let i = 1; i <= totalPages; i++) {
        const li = document.createElement("li");
        li.className = "page-item" + (i === currentPage ? " active" : "");
        li.innerHTML =
          '<button class="page-link" type="button">' + i + "</button>";
        li.onclick = () => goToPage(i);
        pagination.appendChild(li);
      }

      const next = document.createElement("li");
      next.className =
        "page-item" +
        (currentPage === totalPages || totalPages === 0 ? " disabled" : "");
      next.innerHTML = '<button class="page-link" type="button">Sau</button>';
      next.onclick = () =>
        currentPage < totalPages && goToPage(currentPage + 1);
      pagination.appendChild(next);
    }

    function goToPage(page) {
      currentPage = page;
      hideAllRows();
      filteredRows
        .filter((r) => +r.dataset.page === page)
        .forEach((r) => {
          r.style.display = "";
        });

      const totalPages = Math.max(
        1,
        Math.ceil(filteredRows.length / rowsPerPage)
      );
      buildPagination(totalPages);
    }

    // ========== FILTER BUTTONS ==========
    const filterBtns = document.querySelectorAll(
      ".filter-btn-group .filter-btn"
    );

    // Lưu trạng thái filter hiện tại
    let currentFilterType = "all";

    function setActiveBtn(btn) {
      filterBtns.forEach((b) => b.classList.remove("active"));
      btn.classList.add("active");
    }

    function switchToPostsTab() {
      const tabPosts = document.getElementById("tab-posts");
      const tabCreate = document.getElementById("tab-create");
      const panePost = document.getElementById("tab-pane-posts");
      const paneCreate = document.getElementById("tab-pane-create");

      if (tabPosts) {
        tabPosts.classList.add("active");
        tabPosts.setAttribute("aria-selected", "true");
      }
      if (tabCreate) {
        tabCreate.classList.remove("active");
        tabCreate.setAttribute("aria-selected", "false");
      }
      if (panePost) {
        panePost.classList.add("show", "active");
      }
      if (paneCreate) {
        paneCreate.classList.remove("show", "active");
      }
    }

    // ========== HÀM LỌC KẾT HỢP TÌM KIẾM + FILTER ==========
    function applyFilterAndSearch() {
      hideAllRows();
      const keyword = searchInput ? searchInput.value.trim().toLowerCase() : "";

      filteredRows = allRows.filter((r) => {
        const title = (r.dataset.title || "").toLowerCase();
        const st = r.dataset.status;

        // Kiểm tra từ khóa
        const matchKeyword = !keyword || title.includes(keyword);

        // Kiểm tra trạng thái theo filter hiện tại
        let matchStatus = true;
        if (currentFilterType === "published") matchStatus = st === "1";
        else if (currentFilterType === "draft") matchStatus = st === "0";

        return matchKeyword && matchStatus;
      });

      assignPageIndexes(filteredRows);
      currentPage = 1;
      goToPage(1);
    }

    // Thay thế hàm applyFilter cũ
    function applyFilter(type) {
      currentFilterType = type;
      applyFilterAndSearch();
    }

    filterBtns.forEach((btn, idx) => {
      btn.addEventListener("click", function (e) {
        e.preventDefault();
        e.stopPropagation();
        setActiveBtn(btn);
        switchToPostsTab();
        if (idx === 0) applyFilter("all");
        else if (idx === 1) applyFilter("published");
        else if (idx === 2) applyFilter("draft");
      });
    });

    // ========== EDIT / DELETE ==========
    const ctx = "${pageContext.request.contextPath}";
    const editModalEl = document.getElementById("editVideoModal");
    const delModalEl = document.getElementById("confirmDeleteModal");
    const statusEl = document.getElementById("edit-status");
    const pdInput = document.getElementById("edit-postingDate");
    const pdGroup = pdInput ? pdInput.parentElement : null;

    function getModal(el) {
      return window.bootstrap?.Modal
        ? new window.bootstrap.Modal(el)
        : { show() {}, hide() {} };
    }

    function todayYYYYMMDD() {
      const d = new Date();
      return (
        d.getFullYear() +
        "-" +
        String(d.getMonth() + 1).padStart(2, "0") +
        "-" +
        String(d.getDate()).padStart(2, "0")
      );
    }

    function applyPostingDateVisibility() {
      const isPublished = statusEl?.value === "1";
      if (isPublished) {
        if (pdInput && !pdInput.value) pdInput.value = todayYYYYMMDD();
        pdGroup?.classList.remove("d-none");
      } else {
        if (pdInput) pdInput.value = "";
        pdGroup?.classList.add("d-none");
      }
    }

    statusEl?.addEventListener("change", applyPostingDateVisibility);

    function fillFormFromRow(tr) {
      const get = (name) => tr.dataset[name] || "";
      document.getElementById("edit-id").value = get("id");
      document.getElementById("edit-linkYoutube").value = get("linkyoutube");
      document.getElementById("edit-title").value = get("title");
      document.getElementById("edit-content").value = get("content");
      document.getElementById("edit-thumbnailUrl").value = get("thumbnailurl");
      document.getElementById("edit-channelName").value = get("channelname");
      statusEl.value = get("status") === "1" ? "1" : "0";
      pdInput.value = get("postingdate") || "";
      applyPostingDateVisibility();
    }

    // Dùng event delegation cho nút Sửa/Xóa
    tbody.addEventListener("click", function (e) {
      const editBtn = e.target.closest(".btn-edit");
      const deleteBtn = e.target.closest(".btn-delete");
      const tr = e.target.closest("tr");

      if (editBtn && tr) {
        e.preventDefault();
        fillFormFromRow(tr);
        getModal(editModalEl).show();
        return;
      }

      if (deleteBtn && tr) {
        e.preventDefault();
        const id = tr.dataset.id;
        document.getElementById("btn-confirm-delete").dataset.id = id;
        document.getElementById("del-id-text").textContent = id;
        getModal(delModalEl).show();
        return;
      }
    });

    // ========== VALIDATION FORM EDIT ==========
    function validateEditForm() {
      const form = document.getElementById("editVideoForm");
      const requiredFields = form.querySelectorAll('[data-required="true"]');
      let errors = [];

      requiredFields.forEach((field) => {
        const value = field.value?.trim();
        const fieldName = field.dataset.fieldName || field.name;
        if (!value) {
          errors.push(fieldName);
          field.style.borderColor = "#dc3545";
        } else {
          field.style.borderColor = "";
        }
      });

      return errors;
    }

    // Lưu chỉnh sửa - với validation và kiểm tra ảnh
    document
      .getElementById("btn-save-edit")
      ?.addEventListener("click", async function () {
        const btn = this;

        // Validate các trường bắt buộc
        const errors = validateEditForm();
        if (errors.length > 0) {
          showToast("Vui lòng điền đầy đủ: " + errors.join(", "), "error");
          return;
        }

        // Validate YouTube link
        const linkYoutube = document
          .getElementById("edit-linkYoutube")
          .value.trim();
        if (!isValidYoutubeLink(linkYoutube)) {
          showToast(
            "Link Youtube không hợp lệ! Vui lòng nhập đúng định dạng.",
            "error"
          );
          document.getElementById("edit-linkYoutube").style.borderColor =
            "#dc3545";
          return;
        }

        // Validate thumbnail URL
        const thumbnailUrl = document
          .getElementById("edit-thumbnailUrl")
          .value.trim();
        btn.disabled = true;
        btn.textContent = "Đang kiểm tra...";

        const isImageValid = await validateImageUrl(thumbnailUrl);
        if (!isImageValid) {
          showToast(
            "Ảnh đại diện không hợp lệ! Không thể tải ảnh từ link này.",
            "error"
          );
          document.getElementById("edit-thumbnailUrl").style.borderColor =
            "#dc3545";
          btn.disabled = false;
          btn.textContent = "Lưu";
          return;
        }

        // Gửi request cập nhật
        btn.textContent = "Đang lưu...";

        const form = document.getElementById("editVideoForm");
        const formData = new FormData(form);
        const params = new URLSearchParams();
        formData.forEach((v, k) => params.append(k, v));

        fetch(ctx + "/admin/video/update", {
          method: "POST",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          },
          body: params.toString(),
        })
          .then((r) => r.text().then((t) => ({ ok: r.ok, text: t })))
          .then(({ ok, text }) => {
            if (ok) {
              showToast("Cập nhật video thành công!", "success");
              setTimeout(() => location.reload(), 1500);
            } else {
              showToast("Lỗi: " + text, "error");
            }
          })
          .catch((err) => showToast("Lỗi mạng: " + err, "error"))
          .finally(() => {
            btn.disabled = false;
            btn.textContent = "Lưu";
          });
      });

    // Xác nhận xóa
    document
      .getElementById("btn-confirm-delete")
      ?.addEventListener("click", function () {
        const id = this.dataset.id;
        if (!id) return;
        this.disabled = true;
        this.textContent = "Đang xóa...";

        fetch(ctx + "/admin/video/delete", {
          method: "POST",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          },
          body: "id=" + encodeURIComponent(id),
        })
          .then((r) => r.text().then((t) => ({ ok: r.ok, text: t })))
          .then(({ ok, text }) => {
            if (ok) {
              showToast("Xóa video thành công!", "success");
              setTimeout(() => location.reload(), 1500);
            } else {
              showToast("Lỗi: " + text, "error");
            }
          })
          .catch((err) => showToast("Lỗi mạng: " + err, "error"))
          .finally(() => {
            this.disabled = false;
            this.textContent = "Xóa";
          });
      });

    // ========== TẠO VIDEO MỚI ==========
    (function () {
      const ctx = "${pageContext.request.contextPath}";

      const titleInput = document.getElementById("post-title");
      const contentEditor = document.querySelector(".editor");
      const coverUrlInput = document.getElementById("cover-url");
      const videoIdInput = document.getElementById("video-id");
      const coverPreview = document.getElementById("cover-preview");
      const videoPreview = document.getElementById("video-preview");

      const btnCancel = document.getElementById("btn-cancel-create");
      const btnDraft = document.getElementById("btn-save-draft");
      const btnPublish = document.getElementById("btn-publish");
      const btnPaste = document.getElementById("btn-paste");

      let isCoverValid = false;
      let isVideoValid = false;

      // ===== Preview ảnh đại diện =====
      function updateCoverPreview() {
        const url = coverUrlInput?.value?.trim();
        if (!url) {
          coverPreview.innerHTML =
            '<div class="text-secondary small text-center">Chưa có ảnh xem trước</div>';
          isCoverValid = false;
          return;
        }

        const img = new Image();
        img.onload = function () {
          coverPreview.innerHTML = "";
          coverPreview.appendChild(img);
          isCoverValid = true;
        };
        img.onerror = function () {
          coverPreview.innerHTML =
            '<div class="text-danger small text-center">Không thể tải ảnh. Vui lòng kiểm tra lại link!</div>';
          isCoverValid = false;
        };
        img.src = url;
        img.style.width = "100%";
        img.style.height = "100%";
        img.style.objectFit = "cover";
        img.style.borderRadius = "8px";
      }

      coverUrlInput?.addEventListener("input", updateCoverPreview);
      coverUrlInput?.addEventListener("change", updateCoverPreview);

      btnPaste?.addEventListener("click", async function () {
        try {
          const text = await navigator.clipboard.readText();
          if (text) {
            coverUrlInput.value = text;
            updateCoverPreview();
          }
        } catch (err) {
          showToast(
            "Không thể đọc clipboard. Vui lòng dán thủ công.",
            "warning"
          );
        }
      });

      // ===== Preview video YouTube =====
      function updateVideoPreview() {
        const videoId = videoIdInput?.value?.trim();
        if (!videoId) {
          videoPreview.innerHTML =
            '<div class="text-secondary small text-center">Chưa có video xem trước</div>';
          isVideoValid = false;
          return;
        }

        if (!/^[A-Za-z0-9_-]{6,}$/.test(videoId)) {
          videoPreview.innerHTML =
            '<div class="text-danger small text-center">ID video không hợp lệ!</div>';
          isVideoValid = false;
          return;
        }

        const embedUrl = "https://www.youtube.com/embed/" + videoId;
        videoPreview.innerHTML =
          '<iframe src="' +
          embedUrl +
          '" frameborder="0" allowfullscreen style="width:100%;height:100%;border-radius:8px;"></iframe>';
        isVideoValid = true;
      }

      videoIdInput?.addEventListener("input", updateVideoPreview);
      videoIdInput?.addEventListener("change", updateVideoPreview);

      // ===== Validation =====
      function validateForm() {
        const title = titleInput?.value?.trim();
        const content = contentEditor?.value?.trim();
        const coverUrl = coverUrlInput?.value?.trim();
        const videoId = videoIdInput?.value?.trim();

        let errors = [];

        if (!title) {
          errors.push("Tiêu đề bài viết");
          if (titleInput) titleInput.style.borderColor = "#dc3545";
        } else {
          if (titleInput) titleInput.style.borderColor = "";
        }

        if (!content) {
          errors.push("Nội dung bài viết");
          if (contentEditor) contentEditor.style.borderColor = "#dc3545";
        } else {
          if (contentEditor) contentEditor.style.borderColor = "";
        }

        if (!coverUrl) {
          errors.push("Ảnh đại diện");
          if (coverUrlInput) coverUrlInput.style.borderColor = "#dc3545";
        } else {
          if (coverUrlInput) coverUrlInput.style.borderColor = "";
        }

        if (!videoId) {
          errors.push("ID Video YouTube");
          if (videoIdInput) videoIdInput.style.borderColor = "#dc3545";
        } else {
          if (videoIdInput) videoIdInput.style.borderColor = "";
        }

        if (errors.length > 0) {
          showToast("Vui lòng điền đầy đủ: " + errors.join(", "), "error");
          return false;
        }

        if (!isCoverValid) {
          showToast(
            "Ảnh đại diện chưa được tải thành công. Vui lòng kiểm tra lại link ảnh!",
            "error"
          );
          return false;
        }

        if (!isVideoValid) {
          showToast(
            "Video chưa được nhúng thành công. Vui lòng kiểm tra lại ID video YouTube!",
            "error"
          );
          return false;
        }

        return true;
      }

      // ===== Gửi form =====
      function submitCreate(action) {
        if (!validateForm()) return;

        const title = titleInput.value.trim();
        const content = contentEditor.value.trim();
        const thumbnailUrl = coverUrlInput.value.trim();
        const videoId = videoIdInput.value.trim();
        const linkYoutube = "https://www.youtube.com/embed/" + videoId;

        const params = new URLSearchParams();
        params.append("title", title);
        params.append("content", content);
        params.append("thumbnailUrl", thumbnailUrl);
        params.append("linkYoutube", linkYoutube);
        params.append("action", action);

        const btn = action === "publish" ? btnPublish : btnDraft;
        const originalText = btn.textContent;
        btn.disabled = true;
        btn.textContent = "Đang xử lý...";

        fetch(ctx + "/admin/video/create", {
          method: "POST",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          },
          body: params.toString(),
        })
          .then((r) => r.json())
          .then((data) => {
            if (data.success) {
              showToast(data.message, "success");
              setTimeout(() => location.reload(), 1500);
            } else {
              showToast("Lỗi: " + data.message, "error");
            }
          })
          .catch((err) => {
            showToast("Lỗi kết nối: " + err, "error");
          })
          .finally(() => {
            btn.disabled = false;
            btn.textContent = originalText;
          });
      }

      btnDraft?.addEventListener("click", function (e) {
        e.preventDefault();
        submitCreate("draft");
      });

      btnPublish?.addEventListener("click", function (e) {
        e.preventDefault();
        submitCreate("publish");
      });

      btnCancel?.addEventListener("click", function (e) {
        e.preventDefault();
        // Dùng modal xác nhận thay vì confirm()
        if (
          titleInput?.value ||
          contentEditor?.value ||
          coverUrlInput?.value ||
          videoIdInput?.value
        ) {
          showToast("Đã hủy form tạo video!", "warning");
        }
        titleInput.value = "";
        contentEditor.value = "";
        coverUrlInput.value = "";
        videoIdInput.value = "";
        updateCoverPreview();
        updateVideoPreview();
      });
    })();

    // Khởi tạo
    assignPageIndexes(filteredRows);
    goToPage(1);

    // ========== SEARCH BY TITLE ==========
    // Lắng nghe sự kiện input (gõ ký tự)
    if (searchInput) {
      searchInput.addEventListener("input", applyFilterAndSearch);

      // Tìm khi nhấn Enter
      searchInput.addEventListener("keyup", function (e) {
        if (e.key === "Enter") {
          applyFilterAndSearch();
        }
      });
    }
  });
</script>
