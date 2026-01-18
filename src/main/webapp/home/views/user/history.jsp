<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter, java.util.*" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css" />
<style>
  /* Layout */
  .video-card {
    display: flex;
    gap: 15px;
    margin-bottom: 25px;
    cursor: pointer;
  }

  /* Hình thu nhỏ */
  .thumbnail {
    width: 250px;
    height: 140px;
    border-radius: 12px;
    object-fit: cover;
    border: 1px solid var(--border-subtle);
    background: var(--layer-soft);
  }

  /* Tiêu đề + meta */
  .video-title {
    font-size: 18px;
    font-weight: 500;
    line-height: 1.3;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
    overflow: hidden;
    text-overflow: ellipsis;
    color: var(--gray-light);
  }
  .video-meta {
    font-size: 14px;
    color: var(--gray-muted);
  }

  /* 3 chấm */
  .three-dots {
    cursor: pointer;
    font-size: 20px;
    margin-left: 10px;
    color: var(--gray-icon);
  }
  .three-dots:hover {
    color: var(--accent-light);
  }

  /* Search */
  .search-bar {
    color: var(--gray-light);
    border-radius: 10px;
    padding: 10px 12px;
  }
  .search-bar:focus {
    border-color: var(--accent);
    box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.35);
  }
  .search-bar1 {
    border: none; /* vô hiệu hoá đường kẻ xám cứng tay */
  }

  /* Search underline style */
  .search-underline {
    display: flex;
    align-items: center;
    gap: 12px;
    border-bottom: 2px solid var(--border-subtle);
    padding: 6px 8px;
  }
  .search-underline:focus-within {
    border-color: var(--accent);
  }
  .search-icon {
    font-size: 20px;
    color: var(--gray-icon);
  }
  .search-underline:focus-within .search-icon {
    color: var(--accent-light);
  }

  /* Input chỉ gạch chân, bỏ mọi bo/viền/nền */
  .history-search {
    width: 100%;
    background: transparent !important;
    border: 0 !important;
    border-radius: 0 !important;
    outline: none !important;
    box-shadow: none !important;
    padding: 0 !important;
    color: var(--gray-light);
    -webkit-appearance: none;
    appearance: none;
  }
  .history-search::placeholder {
    color: var(--gray-muted);
  }

  /* Right menu */
  .right-menu-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 10px 12px;
    font-size: 16px;
    cursor: pointer;
    color: var(--gray-subtle);
    border-radius: 10px;
  }
  .right-menu-item:hover {
    background: var(--layer-soft);
    color: var(--accent-light);
  }
  .right-menu-item i {
    font-size: 20px;
    color: var(--gray-icon);
  }
  .right-menu-sub {
    color: var(--gray-muted);
    margin-left: 32px;
    margin-top: -5px;
  }

  /* Khung chính */
  .main-content {
    margin-right: 320px;
  }
  .right-sidebar {
    position: fixed;
    top: 100px;
    right: calc((100vw - 1140px) / 2);
    width: 300px;
  }
  .history-wrapper {
    padding-left: 0;
    padding-right: clamp(16px, 4vw, 48px);
    margin-left: 0;
    max-width: 1200px;
  }
  .history-wrapper > h2,
  .history-wrapper h5 {
    color: var(--gray-light);
    margin-top: 0;
  }

  @media (max-width: 991.98px) {
    .main-content {
      margin-right: 0;
    }
    .right-sidebar {
      position: static;
      width: auto;
      top: auto;
      right: auto;
    }
    .history-wrapper {
      padding-inline: 16px;
    }
  }
  @media (min-width: 992px) {
    .col-lg-8 {
      flex: 0 0 auto;
      width: 80%;
    }
  }

  /* Bo góc cho card + cắt tràn để ảnh khớp mép */
  .video-card {
    border-radius: 14px;
    overflow: hidden;
  }

  /* Ảnh khớp bo góc của card (tránh bo 2 lớp) */
  .thumbnail {
    border-radius: 0;
  }

  /* Control bên phải cũng bo góc đều tay */
  .search-bar,
  .right-menu-item {
    border-radius: 12px;
  }
</style>

<div>
  <div class="history-wrapper mt-4">
    <h2 class="fw-bold mb-4">Nhật ký xem</h2>
    <div class="row">
      <!-- LEFT SIDE -->
      <div class="col-lg-8 main-content">
        <%
          Map<LocalDate, java.util.List<entity.Video>> grouped =
                  (Map<LocalDate, java.util.List<entity.Video>>) request.getAttribute("groupedHistory");
          if (grouped == null || grouped.isEmpty()) {
        %>
          <p class="text-muted">Chưa có lịch sử xem trong khoảng thời gian này.</p>
        <%
          } else {
            LocalDate today = LocalDate.now();
            LocalDate yesterday = today.minusDays(1);
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            for (Map.Entry<LocalDate, java.util.List<entity.Video>> e : grouped.entrySet()) {
              LocalDate d = e.getKey();
              String label = d.equals(today) ? "Hôm nay" : (d.equals(yesterday) ? "Hôm qua" : fmt.format(d));
        %>
          <h5 class="fw-semibold mb-4"><%= label %></h5>
          <%
              for (entity.Video v : e.getValue()) {
                String thumb = v.getThumbnailUrl() == null ? "" : v.getThumbnailUrl();
                String title = v.getTitle() == null ? "(Không có tiêu đề)" : v.getTitle();
                String channel = v.getChannelName() == null ? "" : v.getChannelName();
          %>
            <a href="<%= request.getContextPath() %>/home?page=details&id=<%= v.getId() %>" class="text-decoration-none">
              <div class="video-card">
                <img src="<%= thumb %>" class="thumbnail" alt="thumbnail" />
                <div class="flex-grow-1">
                  <div class="d-flex justify-content-between">
                    <p class="video-title"><%= title %></p>
                    <i class="bi bi-three-dots-vertical three-dots"></i>
                  </div>
                  <p class="video-meta"><%= channel %> • <%= (v.getViews()==null?0:v.getViews()) %> lượt xem</p>
                </div>
              </div>
            </a>
          <%
              } // end videos
            } // end days
          } // end else
        %>
      </div>

      <!-- RIGHT SIDE -->
      <div class="col-lg-4 right-sidebar">
        <div class="search-underline mb-4">
          <i class="bi bi-search search-icon"></i>
          <input type="text" class="history-search" placeholder="Tìm kiếm trong danh sách video..." id="historySearch"/>
        </div>

        <div class="mt-2">
          <div class="right-menu-item" id="clearHistoryBtn">
            <i class="fa-solid fa-trash"></i><span>Xóa tất cả nhật ký xem</span>
          </div>
          <div class="right-menu-item" id="pauseHistoryBtn">
            <i class="fa-solid fa-circle-pause"></i><span>Tạm dừng lưu nhật ký xem</span>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    // Tìm kiếm đơn giản theo tiêu đề
    document.getElementById('historySearch')?.addEventListener('input', function() {
      const q = this.value.toLowerCase();
      document.querySelectorAll('.video-card').forEach(card => {
        const title = card.querySelector('.video-title')?.textContent.toLowerCase() || '';
        card.style.display = title.includes(q) ? '' : 'none';
      });
    });
  </script>
</div>
