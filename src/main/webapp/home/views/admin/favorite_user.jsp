<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/assets/css/theme.css"
/>
<style>
  :root {
    --primary: #4c57ff;
    --primary-hover: #5b64ff;
    --bg: #ffffff;
    --border: #d0d5ff;
    --muted: #777;
    --text: #111;
    --soft-bg: #f5f7ff;
    --radius-sm: 6px;
    --radius-md: 10px;
    --radius-lg: 12px;
    --shadow-sm: 0 2px 6px rgba(0, 0, 0, 0.05);
    --shadow-md: 0 6px 16px rgba(0, 0, 0, 0.08);
    --shadow-pop: 0 12px 32px -10px rgba(0, 0, 0, 0.18);
  }

  .search-panel {
    background: var(--bg);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-sm);
    padding: 18px 20px 24px;
    display: flex;
    flex-direction: column;
    gap: 16px;
    transition: box-shadow 0.25s, transform 0.25s;
  }
  .search-panel:hover {
    box-shadow: var(--shadow-md);
    transform: translateY(-2px);
  }

  .search-title {
    font-weight: 600;
    color: var(--text);
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 15px;
  }

  .main-search {
    display: flex;
    gap: 10px;
    align-items: stretch;
  }

  .search-wrap {
    flex: 1;
    position: relative;
    display: flex;
    align-items: center;
    gap: 8px;
    background: var(--soft-bg);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    padding: 8px 12px;
    transition: border-color 0.2s, background 0.2s;
  }
  .search-wrap:focus-within {
    border-color: var(--primary);
    background: #f1f4ff;
    box-shadow: 0 0 0 3px rgba(76, 87, 255, 0.18);
  }

  .search-wrap input {
    border: none;
    background: transparent;
    flex: 1;
    font-size: 14px;
    color: var(--text);
    outline: none;
  }

  .search-wrap .icon-left {
    color: var(--muted);
    font-size: 16px;
  }

  .btn-icon {
    min-width: 44px;
    border: 1px solid var(--border);
    background: #fff;
    color: var(--text);
    border-radius: var(--radius-md);
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 4px;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.2s;
    box-shadow: var(--shadow-sm);
  }
  .btn-icon:hover {
    background: var(--primary);
    color: #fff;
    border-color: var(--primary);
    box-shadow: 0 2px 6px rgba(76, 87, 255, 0.35);
  }

  .quick-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }
  .quick-tags button {
    border: 1px solid var(--border);
    background: #fff;
    color: #334;
    font-size: 13px;
    padding: 6px 12px;
    border-radius: var(--radius-sm);
    cursor: pointer;
    transition: 0.2s;
  }
  .quick-tags button:hover {
    background: var(--primary);
    color: #fff;
    border-color: var(--primary);
  }

  .adv-toggle {
    background: none;
    border: none;
    padding: 0;
    font-size: 13px;
    color: var(--primary);
    cursor: pointer;
    align-self: flex-start;
    transition: color 0.2s;
  }
  .adv-toggle:hover {
    color: var(--primary-hover);
    text-decoration: underline;
  }

  .advanced-box {
    display: none;
    animation: fade 0.25s;
  }
  @keyframes fade {
    from {
      opacity: 0;
      transform: translateY(-4px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .advanced-grid {
    display: grid;
    gap: 10px;
    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
  }

  .advanced-grid .form-select,
  .advanced-grid input {
    width: 100%;
    background: var(--soft-bg);
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    padding: 8px 10px;
    font-size: 13px;
    color: var(--text);
    outline: none;
    transition: 0.2s;
  }
  .advanced-grid .form-select:focus,
  .advanced-grid input:focus {
    background: #fff;
    border-color: var(--primary);
    box-shadow: 0 0 0 3px rgba(76, 87, 255, 0.2);
  }

  .suggest-box {
    position: absolute;
    top: calc(100% + 4px);
    left: 0;
    right: 0;
    background: #fff;
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    box-shadow: var(--shadow-pop);
    z-index: 20;
    overflow: hidden;
  }

  .suggest-item {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 12px;
    font-size: 13px;
    cursor: pointer;
    color: #334;
    transition: background 0.15s, color 0.15s;
  }
  .suggest-item:hover {
    background: var(--primary);
    color: #fff;
  }

  .page-title {
    font-size: 20px;
    font-weight: 600;
    margin: 28px 0 4px;
    color: var(--text);
  }
  .subtitle {
    font-size: 14px;
    color: var(--muted);
    margin-bottom: 18px;
  }

  .result-card {
    background: #fff;
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    padding: 12px 0;
    box-shadow: var(--shadow-sm);
    overflow: hidden;
  }

  .user-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 10px 18px;
    gap: 14px;
    transition: background 0.18s;
  }
  .user-row:hover {
    background: #f1f4ff;
  }

  .user-left {
    display: flex;
    align-items: center;
    gap: 12px;
  }

  .avatar {
    width: 44px;
    height: 44px;
    background: var(--primary);
    color: #fff;
    font-weight: 600;
    font-size: 15px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: none;
    letter-spacing: 0.5px;
  }

  .u-name {
    font-size: 14px;
    font-weight: 600;
    color: var(--text);
    line-height: 1.2;
  }
  .u-handle {
    font-size: 12px;
    color: var(--muted);
  }

  .like-col {
    font-size: 12px;
    color: var(--muted);
    display: flex;
    align-items: center;
    gap: 6px;
  }
  .like-col i {
    color: var(--primary);
    font-size: 16px;
  }

  .divider {
    height: 1px;
    background: linear-gradient(90deg, #e5e8ff, #fff);
    margin: 0;
  }

  .pagination .page-link {
    border: 1px solid var(--border);
    background: #fff;
    color: #334;
    font-size: 13px;
    font-weight: 500;
    min-width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: var(--radius-md);
    transition: 0.2s;
    box-shadow: var(--shadow-sm);
  }
  .pagination .page-item.active .page-link {
    background: var(--primary);
    border-color: var(--primary);
    color: #fff;
    box-shadow: 0 2px 6px rgba(76, 87, 255, 0.35);
  }
  .pagination .page-link:hover {
    background: #f1f4ff;
    color: #253060;
    border-color: var(--primary);
  }
  .pagination .page-item.active .page-link:hover {
    background: var(--primary);
  }

  @media (max-width: 640px) {
    .search-panel {
      padding: 16px 16px 20px;
    }
    .user-row {
      flex-direction: column;
      align-items: flex-start;
    }
    .like-col {
      align-self: flex-end;
    }
  }
</style>
<header class="search-shell">
  <div class="container">
    <div class="search-panel">
      <div class="search-title">
        <i class="bi bi-stars"></i> Tìm kiếm nội dung
      </div>
      <div class="main-search">
        <div class="search-wrap">
          <i class="bi bi-search icon-left"></i>
          <input
            id="searchInput"
            autocomplete="off"
            placeholder="Nhập từ khóa video, @kênh hoặc #chủ_đề..."
          />
          <div id="suggestBox" class="suggest-box"></div>
        </div>
        <button
          id="runSearch"
          type="button"
          class="btn-icon btn-search"
          aria-label="Tìm kiếm"
        >
          <i class="bi bi-search"></i>
        </button>
      </div>

      <div class="quick-tags">
        <button type="button" data-tag="react">
          <i class="bi bi-hash"></i>React
        </button>
        <button type="button" data-tag="frontend">
          <i class="bi bi-hash"></i>Frontend
        </button>
        <button type="button" data-tag="performance">
          <i class="bi bi-lightning-charge"></i>Hiệu năng
        </button>
        <button type="button" data-tag="hooks">
          <i class="bi bi-hash"></i>Hooks
        </button>
        <button type="button" data-tag="typescript">
          <i class="bi bi-hash"></i>TypeScript
        </button>
        <button type="button" data-tag="testing">
          <i class="bi bi-bug"></i>Testing
        </button>
      </div>

      <button class="adv-toggle" id="advToggle" type="button">
        Tùy chọn nâng cao
      </button>
      <div id="advancedBox" class="advanced-box">
        <div class="advanced-grid">
          <select class="form-select" id="selDuration">
            <option value="">Thời lượng</option>
            <option value="short">Dưới 10 phút</option>
            <option value="medium">10 - 30 phút</option>
            <option value="long">Trên 30 phút</option>
          </select>
          <select class="form-select" id="selSort">
            <option value="">Sắp xếp</option>
            <option value="new">Mới nhất</option>
            <option value="popular">Phổ biến</option>
            <option value="rating">Đánh giá cao</option>
          </select>
          <select class="form-select" id="selQuality">
            <option value="">Chất lượng</option>
            <option value="1080">1080p</option>
            <option value="720">720p</option>
            <option value="4k">4K</option>
          </select>
          <input type="text" id="creatorField" placeholder="@creator" />
          <input type="text" id="tagField" placeholder="#tag bổ sung" />
        </div>
      </div>
    </div>
  </div>
</header>
<main class="container">
  <h1 class="page-title">
    Kết quả cho "how to build a react app in 10 minutes"
  </h1>
  <div class="subtitle">Danh sách người dùng đã thích video này</div>
  <div class="result-card">
    <div class="user-row">
      <div class="user-left">
        <div class="avatar">AJ</div>
        <div>
          <div class="u-name">Alex Johnson</div>
          <div class="u-handle">@alexj</div>
        </div>
      </div>
      <div class="like-col">
        <i class="bi bi-hand-thumbs-up"></i><small>Đã thích 2 giờ trước</small>
      </div>
    </div>
    <div class="divider"></div>
    <div class="user-row">
      <div class="user-left">
        <div class="avatar">MG</div>
        <div>
          <div class="u-name">Maria Garcia</div>
          <div class="u-handle">@mariag</div>
        </div>
      </div>
      <div class="like-col">
        <i class="bi bi-hand-thumbs-up"></i><small>Đã thích 5 giờ trước</small>
      </div>
    </div>
    <div class="divider"></div>
    <div class="user-row">
      <div class="user-left">
        <div class="avatar">CW</div>
        <div>
          <div class="u-name">Chen Wei</div>
          <div class="u-handle">@chenw</div>
        </div>
      </div>
      <div class="like-col">
        <i class="bi bi-hand-thumbs-up"></i><small>Đã thích 1 ngày trước</small>
      </div>
    </div>
    <div class="divider"></div>
    <div class="user-row">
      <div class="user-left">
        <div class="avatar">SM</div>
        <div>
          <div class="u-name">Samantha Miller</div>
          <div class="u-handle">@sammiller</div>
        </div>
      </div>
      <div class="like-col">
        <i class="bi bi-hand-thumbs-up"></i><small>Đã thích 2 ngày trước</small>
      </div>
    </div>
    <div class="divider"></div>
    <div class="user-row">
      <div class="user-left">
        <div class="avatar">DK</div>
        <div>
          <div class="u-name">David Kim</div>
          <div class="u-handle">@davidk</div>
        </div>
      </div>
      <div class="like-col">
        <i class="bi bi-hand-thumbs-up"></i><small>Đã thích 3 ngày trước</small>
      </div>
    </div>
  </div>
  <div class="page-footer py-4">
    <nav aria-label="Page navigation">
      <ul class="pagination justify-content-center mb-0">
        <li class="page-item disabled"><a class="page-link">&laquo;</a></li>
        <li class="page-item active"><a class="page-link" href="#">1</a></li>
        <li class="page-item"><a class="page-link" href="#">2</a></li>
        <li class="page-item"><a class="page-link" href="#">3</a></li>
        <li class="page-item disabled"><a class="page-link">...</a></li>
        <li class="page-item"><a class="page-link" href="#">10</a></li>
        <li class="page-item"><a class="page-link">&raquo;</a></li>
      </ul>
    </nav>
  </div>
</main>
<script>
  // Gợi ý mẫu
  const suggestions = [
    "react hooks",
    "react performance",
    "typescript setup",
    "unit testing jest",
    "react context api",
    "frontend tooling",
    "state management",
  ];
  const input = document.getElementById("searchInput");
  const box = document.getElementById("suggestBox");

  // Lấy đúng các phần tử thay vì dùng biến global theo id
  const selDuration = document.getElementById("selDuration");
  const selSort = document.getElementById("selSort");
  const selQuality = document.getElementById("selQuality");
  const creatorField = document.getElementById("creatorField");
  const tagField = document.getElementById("tagField");

  function renderSuggest(list) {
    box.innerHTML = list
      .map(
        (s) => `<div class="suggest-item" data-v="${s}">
              <i class="bi bi-search"></i><span>${s}</span>
            </div>`
      )
      .join("");
    box.style.display = list.length ? "block" : "none";
  }

  input.addEventListener("input", () => {
    const v = input.value.trim().toLowerCase();
    if (!v) {
      renderSuggest([]);
      return;
    }
    renderSuggest(suggestions.filter((s) => s.includes(v)).slice(0, 6));
  });

  box.addEventListener("click", (e) => {
    const item = e.target.closest(".suggest-item");
    if (item) {
      input.value = item.dataset.v;
      box.style.display = "none";
    }
  });

  document.addEventListener("click", (e) => {
    if (!box.contains(e.target) && e.target !== input) {
      box.style.display = "none";
    }
  });

  // Quick tags
  document.querySelectorAll(".quick-tags button").forEach((btn) => {
    btn.addEventListener("click", () => {
      input.value = btn.dataset.tag;
      input.dispatchEvent(new Event("input"));
    });
  });

  // Advanced toggle
  const advToggle = document.getElementById("advToggle");
  const advBox = document.getElementById("advancedBox");
  advToggle.addEventListener("click", () => {
    const open = advBox.style.display === "block";
    advBox.style.display = open ? "none" : "block";
    advToggle.textContent = open ? "Tùy chọn nâng cao" : "Đóng tùy chọn";
  });

  // Submit search (nút icon)
  document.getElementById("runSearch").addEventListener("click", () => {
    const query = input.value.trim();
    const params = {
      q: query,
      duration: selDuration.value,
      sort: selSort.value,
      quality: selQuality.value,
      creator: creatorField.value.trim(),
      tagExtra: tagField.value.trim(),
    };
    console.log("Search params", params);
    alert("Search: " + JSON.stringify(params, null, 2));
  });
</script>
