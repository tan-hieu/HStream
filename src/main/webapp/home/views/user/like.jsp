<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/assets/css/theme.css"
/>
<style>
  /* Sidebar theo dark theme */
  .left-box {
    background:
      linear-gradient(180deg, rgba(99,102,241,0.14), rgba(139,92,246,0.10)),
      var(--bg-panel);
    color: var(--gray-light);
    min-height: calc(100vh - 128px);
    padding: 18px;
    border-radius: 14px;
    border: 1px solid var(--border-subtle);
    box-shadow: var(--shadow-soft);
  }

  @media (min-width: 992px) {
    .sidebar-fixed .left-box {
      position: fixed;
      top: 65px;
      left: 240px;
      width: 380px;
      overflow-y: auto;
    }
    .content-area {
      margin-left: 360px;
    }
  }

  @media (max-width: 991.98px) {
    .sidebar-fixed .left-box {
      position: static;
      width: 100%;
    }
    .content-area {
      margin-left: 0;
    }
  }

  .video-thumb {
    width: 100%;
    border-radius: 12px;
    border: 1px solid var(--border-soft);
    background: var(--bg-soft);
  }

  /* Item bên phải */
  .video-item {
    background: var(--bg-soft);
    border: 1px solid var(--border-subtle);
    border-radius: 14px;
    padding: 10px 12px;
    transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease, background .18s ease;
  }

  .video-item:hover {
    background: var(--bg-panel);
    border-color: var(--accent);
    box-shadow: var(--shadow-accent);
    transform: translateY(-1px);
  }

  .video-item:active {
    transform: translateY(0);
    box-shadow: none;
  }

  .video-item img {
    width: 220px;
    height: 125px;
    object-fit: cover;
    border-radius: 12px;
    border: 1px solid var(--border-soft);
    background: var(--layer-soft);
  }

  /* Buttons */
  .btn-custom {
    border-radius: 30px;
    padding: 10px 22px;
    font-weight: 600;
  }

  /* Đồng bộ btn-light với dark theme */
  .btn-light {
    background: var(--layer-soft) !important;
    color: var(--gray-subtle) !important;
    border: 1px solid var(--border-soft) !important;
  }
  .btn-light:hover,
  .btn-light:focus {
    color: var(--gray-light) !important;
    border-color: var(--accent) !important;
    box-shadow: 0 0 0 2px rgba(99,102,241,0.25) !important;
  }

  .btn-mix {
    background: var(--accent-grad);
    color: #fff;
    border: 0;
    box-shadow: var(--shadow-accent);
  }
  .btn-mix:hover,
  .btn-mix:focus {
    filter: brightness(1.05);
    box-shadow: 0 8px 22px -6px rgba(99,102,241,0.7);
  }

  .btn-mix:disabled,
  #btnPlayAll:disabled {
    opacity: .6;
    cursor: not-allowed;
    box-shadow: none;
  }

  .video-title {
    font-size: 17px;
    font-weight: 600;
    color: var(--gray-light);
  }

  .video-meta {
    font-size: 14px;
    color: var(--gray-muted);
  }

  /* Grid widths tweak */
  @media (min-width: 992px) {
    .col-lg-3 { flex: 0 0 auto; }
    .col-lg-9 { flex: 0 0 auto; width: 70%; }
  }
</style>

<div class="container-fluid">
  <div class="row">
    <!-- LEFT SIDEBAR -->
    <div class="left-box shadow col-md-4 col-lg-3 sidebar-fixed">
      <c:set
        var="leftThumb"
        value="${not empty likedVideos and not empty likedVideos[0].thumbnailUrl
                      ? likedVideos[0].thumbnailUrl
                      : pageContext.request.contextPath.concat('/img/anh7.png')}"
      />
      <img src="${leftThumb}" class="video-thumb mb-4" />

      <h3 class="fw-bold">Video đã thích</h3>
      <p>
        <c:if test="${likedCount > 0}">
          Bạn đã thích <strong>${likedCount}</strong> video.
        </c:if>
        <c:if test="${likedCount == 0}">
          Chưa có video yêu thích.
        </c:if>
      </p>

      <div class="d-flex gap-3 mt-4">
        <button id="btnPlayAll"
                class="btn btn-light btn-custom"
                data-first-id="${not empty likedVideos ? likedVideos[0].id : ''}"
                <c:if test="${empty likedVideos}">disabled</c:if>>
          <i class="fa-solid fa-play"></i>Phát tất cả
        </button>

        <!-- đổi từ <a> sang button, phát ngẫu nhiên 1 bài trong danh sách yêu thích -->
        <button id="btnShuffle"
                class="btn btn-mix btn-custom"
                <c:if test="${empty likedVideos}">disabled</c:if>>
          <i class="fa-solid fa-shuffle"></i>Trộn bài
        </button>
      </div>
    </div>

    <!-- RIGHT LIST -->
    <div class="col-md-8 col-lg-9">
      <c:if test="${empty likedVideos}">
        <div class="text-muted">Bạn chưa thích video nào.</div>
      </c:if>

      <c:forEach var="v" items="${likedVideos}">
        <c:set
          var="thumb"
          value="${empty v.thumbnailUrl ? pageContext.request.contextPath.concat('/img/anh7.png') : v.thumbnailUrl}"
        />
        <a
          href="${pageContext.request.contextPath}/home?page=details&id=${v.id}"
          style="text-decoration: none; color: inherit"
        >
          <!-- thêm data-id để JS thu thập danh sách id -->
          <div class="d-flex mb-4 video-item" data-id="${v.id}">
            <img src="${thumb}" alt="${v.title}" />
            <div class="ms-3">
              <div class="video-title"><c:out value="${v.title}" /></div>
              <div class="video-meta">
                <c:out value="${v.views != null ? v.views : 0}" /> lượt xem •
                <c:out value="${v.postingDate}" />
              </div>
            </div>
          </div>
        </a>
      </c:forEach>
    </div>
  </div>
</div>

<script>
(function() {
  const base = '<c:out value="${pageContext.request.contextPath}"/>';
  const btnPlay = document.getElementById('btnPlayAll');
  const btnShuffle = document.getElementById('btnShuffle');

  // Phát bài đầu tiên
  if (btnPlay) {
    btnPlay.addEventListener('click', function() {
      const firstId = btnPlay.getAttribute('data-first-id');
      if (firstId) {
        window.location.href = base + '/home?page=details&id=' + firstId + '&source=liked';
      }
    });
  }

  // Trộn bài: chọn ngẫu nhiên 1 id trong danh sách yêu thích và phát ngay
  if (btnShuffle) {
    btnShuffle.addEventListener('click', function() {
      const ids = Array.from(document.querySelectorAll('.video-item'))
        .map(el => el.getAttribute('data-id'))
        .filter(Boolean);
      if (ids.length > 0) {
        // Fisher–Yates shuffle
        for (let i = ids.length - 1; i > 0; i--) {
          const j = Math.floor(Math.random() * (i + 1));
          [ids[i], ids[j]] = [ids[j], ids[i]];
        }
        window.location.href = base + '/home?page=details&id=' + ids[0] + '&source=liked&shuffle=1';
      }
    });
  }
})();
</script>
