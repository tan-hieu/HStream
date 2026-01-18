<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
taglib prefix="fn" uri="jakarta.tags.functions" %>
<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/assets/css/theme.css"
/>

<style>
  /* giữ nguyên style */
  .video-frame {
    background: var(--bg-soft);
    aspect-ratio: 16/9;
    width: 100%;
    border: 1px solid var(--border-subtle);
    border-radius: 12px;
    overflow: hidden;
    box-shadow: var(--shadow-soft);
  }
  iframe {
    width: 100%;
    height: 100%;
  }
  .related-video {
    display: flex;
    gap: 12px;
    margin-bottom: 16px;
    cursor: pointer;
    border-radius: 12px;
    padding: 10px;
    transition: all 0.22s ease;
    background: var(--bg-soft) !important;
    border: 1px solid var(--border-subtle);
  }
  .related-video:hover {
    background: var(--bg-panel) !important;
    border-color: var(--accent);
    box-shadow: var(--shadow-accent);
    transform: translateY(-3px);
  }
  .related-video img {
    width: 160px;
    height: 90px;
    border-radius: 8px;
    object-fit: cover;
    border: 1px solid var(--border-subtle);
  }
  .related-video h6 {
    margin: 0 0 4px;
    font-weight: 600;
    color: var(--gray-light);
  }
  .related-video p {
    font-size: 0.78rem;
    line-height: 1.1rem;
  }
  .video-actions {
    text-align: right;
  }
  .description-box,
  .comment-section {
    background: var(--bg-panel);
    border: 1px solid var(--border-subtle);
    border-radius: 14px;
    padding: 18px 20px;
    box-shadow: var(--shadow-soft);
  }
  .description-meta {
    display: flex;
    flex-wrap: wrap;
    gap: 6px 10px;
    font-size: 0.85rem;
    color: var(--accent-light);
    margin-bottom: 10px;
  }
  .description-meta .dot {
    opacity: 0.5;
  }
  .description-content p {
    margin-bottom: 12px;
    line-height: 1.4rem;
  }
  .info-list {
    list-style: none;
    padding: 0;
    margin: 0;
    display: grid;
    gap: 6px;
    font-size: 0.78rem;
  }
  .info-list li {
    padding: 6px 10px;
    background: var(--bg-soft);
    border: 1px solid var(--border-subtle);
    border-radius: 8px;
    line-height: 1.15rem;
  }
  .info-list li strong {
    color: var(--accent-light);
    font-weight: 600;
  }
  .info-list a {
    color: var(--accent);
  }
  .info-list a:hover {
    color: var(--accent-light);
    text-decoration: underline;
  }
  .description-box strong {
    color: var(--accent-light);
    font-weight: 600;
  }
  .description-box h6 {
    font-weight: 600;
    color: var(--gray-subtle);
  }
  .comment {
    border-bottom: 1px solid var(--border-subtle);
    padding: 12px 0;
  }
  .comment:last-child {
    border-bottom: none;
  }
  .comment-author {
    font-weight: 600;
    font-size: 0.85rem;
    color: var(--accent-light);
  }
  .comment-text {
    margin-top: 4px;
    font-size: 0.85rem;
    color: var(--gray-subtle);
  }
  #commentInput {
    background: var(--bg-soft) !important;
  }
  h4.fw-bold {
    color: var(--gray-light);
  }
  h5.fw-bold {
    color: var(--gray-light);
  }

  /* Related: compact smaller cards */
  .related-list {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }
  .video-card {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px;
    border: 1px solid var(--border-subtle);
    border-radius: 10px;
    background: var(--bg-soft);
    transition: transform 0.15s ease, box-shadow 0.15s ease,
      border-color 0.15s ease;
  }
  .video-card:hover {
    transform: translateY(-2px);
    border-color: var(--accent);
    box-shadow: var(--shadow-accent);
  }
  .thumbnail {
    width: 120px;
    height: 68px;
    border-radius: 8px;
    object-fit: cover;
    border: 1px solid var(--border-subtle);
  }
  .video-info {
    padding: 0;
    flex: 1;
    min-width: 0;
  }
  .title {
    font-size: 0.9rem;
    font-weight: 600;
    margin: 0 0 4px;
    color: var(--gray-light);
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .stats {
    font-size: 0.75rem;
    color: var(--gray-subtle);
    display: flex;
    gap: 8px;
  }

  /* ============ TOAST NOTIFICATION (giống video_management) ============ */
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

  .toast-notification.info {
    background: linear-gradient(135deg, #17a2b8, #138496);
  }

  .toast-notification i {
    font-size: 20px;
  }

  .toast-notification .toast-text {
    flex: 1;
    font-weight: 500;
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

  /* LOGIN PROMPT (thay confirm) */
  .dialog-backdrop {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.45);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 2500;
    animation: fadeIn 0.25s ease;
  }
  .login-prompt {
    width: 340px;
    background: var(--bg-panel);
    border: 1px solid var(--border-subtle);
    border-radius: 18px;
    padding: 22px 22px 18px;
    box-shadow: var(--shadow-accent);
    animation: scaleIn 0.25s ease;
  }
  .login-prompt h6 {
    margin: 0 0 6px;
    font-weight: 600;
    color: var(--gray-light);
    font-size: 0.95rem;
  }
  .login-prompt p {
    font-size: 0.78rem;
    line-height: 1.15rem;
    color: var(--gray-subtle);
    margin: 0 0 14px;
  }
  .login-prompt .actions {
    display: flex;
    gap: 10px;
    justify-content: flex-end;
  }
  .login-prompt button {
    border-radius: 40px;
    font-size: 0.72rem;
    padding: 6px 16px;
  }
  @keyframes scaleIn {
    from {
      opacity: 0;
      transform: scale(0.92);
    }
    to {
      opacity: 1;
      transform: scale(1);
    }
  }
  @keyframes fadeIn {
    from {
      opacity: 0;
    }
    to {
      opacity: 1;
    }
  }

  /* Like button: khi đã like giữ nguyên màu hover */
  .btn.liked,
  .btn.liked:hover,
  .btn.liked:focus {
    background: var(--accent);
    color: #fff;
    border-color: var(--accent);
    box-shadow: var(--shadow-accent);
    transform: none;
  }

  .btn.liked .bi {
    color: #fff;
  }

  /* Giữ các biến đổi hover cho nút chưa like (không thay đổi) */

  /* Unliked (outline) — giống ảnh 1 */
  .video-actions .btn.btn-outline-primary {
    color: var(--accent);
    border-color: var(--accent);
    background: transparent;
    box-shadow: none;
    transition: background 160ms ease, color 160ms ease, box-shadow 160ms ease,
      transform 120ms ease;
  }
  .video-actions .btn.btn-outline-primary .bi {
    color: inherit;
    margin-right: 6px;
  }

  /* Hover cho unliked: nhẹ đổi nền (keeps outline -> becomes filled on hover) */
  .video-actions .btn.btn-outline-primary:hover,
  .video-actions .btn.btn-outline-primary:focus {
    background: var(--accent);
    color: #fff;
    border-color: var(--accent);
    box-shadow: var(--shadow-accent);
  }

  /* Liked (giống ảnh 2) — ưu tiên cao để override outline rules */
  .video-actions .btn.liked,
  .video-actions .btn.btn-outline-primary.liked,
  btn.liked,
  btn.liked:hover,
  btn.liked:focus {
    background: var(--accent);
    color: #fff !important;
    border-color: var(--accent);
    box-shadow: var(--shadow-accent);
    transform: none;
  }
  .video-actions .btn.liked .bi,
  btn.liked .bi {
    color: #fff;
  }
</style>

<div class="container-fluid mt-4">
  <div class="row">
    <!-- Video chính -->
    <div class="col-lg-8 col-md-7 mb-4">
      <div class="video-frame mb-3">
        <iframe
          id="videoIframe"
          src="${embedUrl}"
          frameborder="0"
          allowfullscreen
        ></iframe>
      </div>

      <h4 class="fw-bold"><c:out value="${video.title}" /></h4>
      <%--
      <p class="text-muted mb-1"><c:out value="${video.content}" /></p>
      --%>

      <div class="video-actions mb-3">
        <button
          class="btn btn-outline-primary btn-sm ${isLiked ? 'liked' : ''}"
          id="likeBtn"
          data-video-id="${video.id}"
        >
          <i
            id="likeIcon"
            class="bi ${isLiked ? 'bi-hand-thumbs-up-fill' : 'bi-hand-thumbs-up'}"
          ></i>
          <span id="likeText"
            ><c:out value="${isLiked ? 'Đã thích' : 'Thích'}"
          /></span>
          (<span id="likeCount"><c:out value="${totalLikes}" /></span>)
        </button>
        <button
          class="btn btn-outline-secondary btn-sm"
          id="shareBtn"
          data-video-id="${video.id}"
          data-share-link="${video.linkYoutube}"
        >
          <i class="bi bi-share"></i> Chia sẻ
        </button>
      </div>

      <!-- Mô tả -->
      <div class="description-box">
        <div class="description-meta">
          <span class="views"
            ><i class="bi bi-eye"></i> <c:out value="${video.views}" /> lượt
            xem</span
          >
          <span class="dot">•</span>
          <span class="date">
            <c:choose>
              <c:when test="${video.postingDate != null}"
                ><c:out value="${video.postingDate}"
              /></c:when>
              <c:otherwise>Không rõ ngày</c:otherwise>
            </c:choose>
          </span>
        </div>
        <h6 class="fw-semibold mb-3">Mô tả:</h6>
        <div class="description-content">
          <p><c:out value="${video.content}" /></p>
          <%--
          <ul class="tag-list">
            --%> <%--
            <li>#video</li>
            --%> <%--
            <li>#music</li>
            --%> <%--
            <li>#hstream</li>
            --%> <%--
          </ul>
          --%>
          <ul class="info-list">
            <li>
              <strong>Kênh:</strong>
              <c:out
                value="${empty video.channelName ? 'Không rõ' : video.channelName}"
              />
            </li>
            <li>
              <strong>Link gốc:</strong>
              <a
                href="<c:out value='${video.linkYoutube}'/>"
                target="_blank"
                rel="noopener"
                >Mở trên YouTube</a
              >
            </li>
          </ul>
        </div>
      </div>

      <!-- Bình luận -->
      <div class="comment-section mt-3">
        <h6 class="fw-bold mb-3">Bình luận</h6>
        <div class="input-group mb-3">
          <input
            id="commentInput"
            type="text"
            class="form-control"
            placeholder="Viết bình luận của bạn..."
            maxlength="500"
          />
          <button class="btn btn-primary" type="button" id="sendCommentBtn">
            <i class="bi bi-send"></i> Gửi
          </button>
        </div>

        <div id="commentList">
          <c:forEach var="cmt" items="${comments}">
            <div class="comment">
              <div class="comment-author">
                <c:out value="${cmt.user.fullname}" />
              </div>
              <div class="comment-text"><c:out value="${cmt.content}" /></div>
            </div>
          </c:forEach>
          <c:if test="${empty comments}">
            <div class="text-muted">Chưa có bình luận.</div>
          </c:if>
        </div>
      </div>
    </div>

    <!-- Video liên quan -->
    <div class="col-lg-4 col-md-5">
      <h5 class="mb-3 fw-bold">Video liên quan</h5>

      <div class="related-list">
        <c:forEach var="rv" items="${relatedVideos}">
          <a
            class="video-card"
            href="${pageContext.request.contextPath}/home?page=details&id=${rv.id}"
          >
            <img class="thumbnail" src="<c:out
              value='${empty rv.thumbnailUrl ? pageContext.request.contextPath.concat("/img/default-thumb.png") : rv.thumbnailUrl}'
            />" alt="${fn:escapeXml(rv.title)}" />
            <div class="video-info">
              <div class="title">${rv.title}</div>
              <div class="stats">
                <span
                  ><i class="bi bi-eye"></i> <c:out value="${rv.views}"
                /></span>
                <span>
                  <c:choose>
                    <c:when test="${rv.postingDate != null}"
                      >${rv.postingDate}</c:when
                    >
                    <c:otherwise>Không rõ ngày</c:otherwise>
                  </c:choose>
                </span>
              </div>
            </div>
          </a>
        </c:forEach>
      </div>
      <c:if test="${empty relatedVideos}">
        <div class="text-muted">Không có video liên quan.</div>
      </c:if>
    </div>
  </div>
</div>

<!-- NEW: notify container -->
<div class="notify-wrapper" id="notifyWrapper"></div>

<!-- Toast Container (giống video_management) -->
<div class="toast-container" id="toastContainer"></div>

<!-- CUSTOM LOGIN PROMPT CONTAINER -->
<div id="dialogHost"></div>
<!-- Share modal container -->
<div id="shareDialogHost"></div>

<script>
  const isLoggedIn = ${sessionScope.currentUser != null ? 'true' : 'false'};

  // Sinh URL tuyệt đối an toàn theo context path
  const favUrl = '<c:url value="/favourite"/>';
  const loginUrl = '<c:url value="/login"/>';
  const shareUrl = '<c:url value="/share"/>';
  const commentUrl = '<c:url value="/comment"/>';

  // ========== TOAST NOTIFICATION (giống video_management) ==========
  function showToast(message, type = 'error', duration = 4000) {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    const toast = document.createElement('div');
    toast.className = 'toast-notification ' + type;

    let icon = 'fa-circle-exclamation';
    if (type === 'success') icon = 'fa-circle-check';
    if (type === 'warning') icon = 'fa-triangle-exclamation';
    if (type === 'info') icon = 'fa-circle-info';

    toast.innerHTML = '<i class="fa-solid ' + icon + '"></i><span class="toast-text">' + message + '</span>';
    container.appendChild(toast);

    // Click để đóng sớm
    toast.addEventListener('click', function() {
      toast.style.animation = 'slideOut 0.3s ease-out forwards';
      setTimeout(() => toast.remove(), 300);
    });

    // Tự động đóng
    setTimeout(() => {
      if (toast.parentNode) {
        toast.style.animation = 'slideOut 0.3s ease-out forwards';
        setTimeout(() => toast.remove(), 300);
      }
    }, duration);
  }

  // Tạo dialog hỏi đăng nhập (Promise)
  function askLogin(actionName) {
    return new Promise(resolve => {
      const host = document.getElementById('dialogHost');
      const backdrop = document.createElement('div');
      backdrop.className = 'dialog-backdrop';
      backdrop.innerHTML = `
        <div class="login-prompt">
          <h6>Yêu cầu đăng nhập</h6>
          <p>Bạn cần đăng nhập để ${actionName}. Bạn có muốn chuyển đến trang đăng nhập?</p>
          <div class="actions">
            <button type="button" class="btn btn-light btn-sm" data-act="cancel">Để sau</button>
            <button type="button" class="btn btn-primary btn-sm" data-act="ok">Đăng nhập</button>
          </div>
        </div>
      `;
      host.appendChild(backdrop);
      const close = (val) => {
        backdrop.classList.add('closing');
        backdrop.remove();
        resolve(val);
      };
      backdrop.addEventListener('click', e => {
        if (e.target === backdrop) close(false);
      });
      backdrop.querySelector('[data-act="cancel"]').onclick = () => close(false);
      backdrop.querySelector('[data-act="ok"]').onclick = () => close(true);
    });
  }

  // Sửa requireLogin: bỏ confirm
  function requireLogin(actionName, callbackIfLoggedIn) {
    if (!isLoggedIn) {
      askLogin(actionName).then(go => {
        if (go) {
          const returnUrl = encodeURIComponent(window.location.pathname + window.location.search);
            window.location.href = loginUrl + '?return=' + returnUrl;
        } else {
          showToast('Đã hủy hành động.', 'info');
        }
      });
      return false;
    }
    if (typeof callbackIfLoggedIn === 'function') callbackIfLoggedIn();
    return true;
  }

  // Like
  document.getElementById('likeBtn').addEventListener('click', () => {
    requireLogin('thực hiện hành động Thích', toggleLike);
  });

  function toggleLike() {
    const btn = document.getElementById('likeBtn');
    const videoId = btn.getAttribute('data-video-id');

    fetch(favUrl, {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'videoId=' + encodeURIComponent(videoId)
    }).then(r => {
      if (!r.ok) throw new Error('Fail');
      return r.json();
    }).then(data => {
      const icon = document.getElementById('likeIcon');

      document.getElementById('likeText').innerText = data.liked ? 'Đã thích' : 'Thích';
      document.getElementById('likeCount').innerText = data.totalLikes;

      // cập nhật class hiển thị và icon
      btn.classList.toggle('liked', !!data.liked);
      icon.className = 'bi ' + (data.liked ? 'bi-hand-thumbs-up-fill' : 'bi-hand-thumbs-up');

      // Nếu người dùng vừa bỏ thích, loại focus/active ngay lập tức để hiển thị outline.
      if (!data.liked) {
        btn.blur();
        // chống trường hợp vẫn còn trạng thái :active ở một số trình duyệt
        setTimeout(() => btn.classList.remove('active'), 10);
      }

      showToast(data.liked ? 'Đã thích video!' : 'Đã bỏ thích.', 'success');
    }).catch(() => {
      showToast('Lỗi khi xử lý Like.', 'error');
    });
  }

  // Share modal
  function openShareModal() {
    const host = document.getElementById('shareDialogHost');
    const videoId = document.getElementById('shareBtn').getAttribute('data-video-id');
    const link = document.getElementById('shareBtn').getAttribute('data-share-link');

    const backdrop = document.createElement('div');
    backdrop.className = 'dialog-backdrop';
    backdrop.innerHTML = `
      <div class="login-prompt">
        <h6>Chia sẻ video</h6>
        <p>Nhập email người nhận. Chúng tôi sẽ gửi link video đến họ.</p>
        <div class="mb-2">
          <input type="email" class="form-control form-control-sm" id="shareEmailInput" placeholder="email@domain.com" />
        </div>
        <div class="actions">
          <button type="button" class="btn btn-light btn-sm" data-act="cancel">Hủy</button>
          <button type="button" class="btn btn-primary btn-sm" data-act="send">Gửi</button>
        </div>
      </div>
    `;
    host.appendChild(backdrop);

    const close = () => { backdrop.remove(); };

    backdrop.addEventListener('click', e => { if (e.target === backdrop) close(); });
    backdrop.querySelector('[data-act="cancel"]').onclick = () => close();
    backdrop.querySelector('[data-act="send"]').onclick = () => {
      const email = backdrop.querySelector('#shareEmailInput').value.trim();
      if (!/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(email)) {
        showToast('Email không hợp lệ.', 'error');
        return;
      }
      fetch(shareUrl, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: new URLSearchParams({ email, videoId, link }).toString()
      }).then(r => {
        if (!r.ok) return r.json().then(e => { throw e; });
        return r.json();
      }).then(data => {
        close();
        setTimeout(() => showToast(data.message || 'Đã gửi thành công.', 'success'), 0);
      }).catch(err => {
        const code = err && err.error ? err.error : 'Lỗi gửi chia sẻ.';
        showToast(code == 'MAIL_SEND_FAILED' ? 'Không gửi được email.' :
                   code == 'UNAUTHORIZED' ? 'Cần đăng nhập.' :
                   'Lỗi khi chia sẻ.', 'error');
      });
    };
  }

  // Share
  document.getElementById('shareBtn').addEventListener('click', () => {
    requireLogin('Chia sẻ', openShareModal);
  });

  // Bình luận
  document.getElementById('sendCommentBtn').addEventListener('click', () => {
    requireLogin('bình luận', addComment);
  });

  // Enter để gửi
  document.getElementById('commentInput').addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      e.preventDefault();
      requireLogin('bình luận', addComment);
    }
  });

  // Disable input nếu chưa đăng nhập (UX)
  if (!isLoggedIn) {
    document.getElementById('commentInput').setAttribute('placeholder', 'Bạn cần đăng nhập để bình luận');
  }

  function setVideo(url) {
    const videoId = extractYouTubeID(url);
    if (videoId) {
      document.getElementById("videoIframe").src =
        "https://www.youtube.com/embed/" + videoId;
      showToast('Đã tải video.', 'success');
    } else {
      showToast('Link YouTube không hợp lệ!', 'error');
    }
  }

  function extractYouTubeID(url) {
    if (!url) return null;
    const patterns = [/(?:youtube\.com\/.*v=|youtu\.be\/)([^&?/]+)/];
    for (const pattern of patterns) {
      const match = url.match(pattern);
      if (match && match[1]) return match[1];
    }
    return null;
  }

  function addComment() {
    const input = document.getElementById("commentInput");
    const btn = document.getElementById("sendCommentBtn");
    const text = input.value.trim();
    if (!text) {
      showToast('Nội dung bình luận trống.', 'error');
      return;
    }
    if (text.length > 500) {
      showToast('Bình luận tối đa 500 ký tự.', 'error');
      return;
    }

    const videoId = document.getElementById('likeBtn').getAttribute('data-video-id');
    btn.disabled = true;

    fetch(commentUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
      body: new URLSearchParams({ videoId, content: text }).toString()
    })
    .then(async r => {
      const data = await r.json().catch(() => ({}));
      if (!r.ok) {
        const code = data && data.error ? data.error : 'SERVER_ERROR';
        throw new Error(code);
      }
      return data;
    })
    .then(data => {
      const commentList = document.getElementById("commentList");
      const div = document.createElement("div");
      div.classList.add("comment");

      const authorEl = document.createElement('div');
      authorEl.className = 'comment-author';
      authorEl.textContent = data.author || 'Bạn';

      const textEl = document.createElement('div');
      textEl.className = 'comment-text';
      textEl.textContent = data.content || text;

      div.append(authorEl, textEl);
      commentList.prepend(div);

      input.value = "";
      showToast('Đã thêm bình luận.', 'success');
    })
    .catch(err => {
      const code = err.message || 'SERVER_ERROR';
      const msg =
        code === 'UNAUTHORIZED' ? 'Bạn cần đăng nhập.' :
        code === 'MISSING_VIDEO_ID' ? 'Thiếu video.' :
        code === 'INVALID_VIDEO_ID' ? 'Video không hợp lệ.' :
        code === 'EMPTY_CONTENT' ? 'Nội dung bình luận trống.' :
        code === 'CONTENT_TOO_LONG' ? 'Bình luận quá dài (<= 500).' :
        code === 'VIDEO_NOT_FOUND' ? 'Không tìm thấy video.' :
        'Lỗi máy chủ. Vui lòng thử lại.';
      showToast(msg, 'error');
    })
    .finally(() => {
      btn.disabled = false;
    });
  }
</script>
