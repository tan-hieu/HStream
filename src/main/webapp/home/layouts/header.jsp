<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="<c:url value='/assets/css/theme.css'/>" />

<%
    String p = request.getParameter("page");
    String uri = request.getRequestURI();
    String servletPath = request.getServletPath();
    
    // DEBUG: In ra console để kiểm tra
    System.out.println("========== HEADER DEBUG ==========");
    System.out.println("Parameter 'page': " + p);
    System.out.println("URI: " + uri);
    System.out.println("ServletPath: " + servletPath);
    
    // QUAN TRỌNG: Kiểm tra trang admin - bao gồm cả URI và parameter
    boolean isAdminPage = uri.contains("/admin") 
                       || servletPath.contains("/admin")
                       || (p != null && (
                           p.equals("video-management") 
                           || p.equals("user-management") 
                           || p.equals("favorite-report")
                           || p.startsWith("video-management")
                           || p.startsWith("user-management")
                           || p.startsWith("favorite-report")
                       ));
    
    System.out.println("isAdminPage: " + isAdminPage);

    // Trang chủ: chỉ khi page=home hoặc null/rỗng VÀ không phải trang admin
    boolean isHome = !isAdminPage && (p == null || p.isEmpty() || "home".equals(p));
    
    System.out.println("isHome: " + isHome);

    // Mở rộng sidebar CHỈ khi ở trang chủ
    boolean shouldExpand = isHome;
    
    // Kiểm tra trang auth
    boolean isAuthByParam = "login".equals(p) || "register".equals(p) || "forgot-password".equals(p) 
                           || "verify-otp".equals(p) || "send-otp".equals(p) || "reset-password".equals(p)
                           || "verify-reset-otp".equals(p);
    boolean isAuthByUri = uri.contains("/login") || uri.contains("/register") 
                         || uri.contains("/forgot-password") || uri.contains("/verify-otp") 
                         || uri.contains("/send-otp") || uri.contains("/reset-password")
                         || uri.contains("/verify-reset-otp") || uri.contains("/resend-otp");
    boolean isAuth = isAuthByParam || isAuthByUri;
    
    // THÊM: Kiểm tra auth bằng forward (để xử lý case chuyển hướng từ trang admin về trang login)
    String fwdUri  = (String) request.getAttribute("jakarta.servlet.forward.request_uri");
    String fwdPath = (String) request.getAttribute("jakarta.servlet.forward.servlet_path");

    boolean isAuthByForward =
        (fwdUri != null && (
            fwdUri.contains("/login") || fwdUri.contains("/register") ||
            fwdUri.contains("/forgot-password") || fwdUri.contains("/verify-otp") ||
            fwdUri.contains("/send-otp") || fwdUri.contains("/reset-password") ||
            fwdUri.contains("/verify-reset-otp") || fwdUri.contains("/resend-otp")
        )) ||
        (fwdPath != null && (
            fwdPath.contains("/login") || fwdPath.contains("/register") ||
            fwdPath.contains("/forgot-password") || fwdPath.contains("/verify-otp") ||
            fwdPath.contains("/send-otp") || fwdPath.contains("/reset-password") ||
            fwdPath.contains("/verify-reset-otp") || fwdPath.contains("/resend-otp")
        ));
    
    isAuth = isAuth || isAuthByForward;
    
    System.out.println("isAuth: " + isAuth);
    System.out.println("shouldExpand: " + shouldExpand);
    System.out.println("==================================");
%>
<style>
  .body {
    margin: 0;
    font-family: Arial, sans-serif;
  }

  /* Header ngang */
  .header {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    height: 60px;
    background-color: var(--bg-panel);
    z-index: 1000;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 6px 16px;
    box-shadow: var(--shadow-soft);
  }

  .left-section {
    display: flex;
    align-items: center;
    gap: 12px;
  }

  /* Nút 3 gạch tròn */
  .menu-btn {
    width: 38px;
    height: 38px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: var(--layer-soft);
    border: 1px solid var(--border-soft);
    border-radius: 50%;
    font-size: 22px;
    cursor: pointer;
    transition: background 0.2s, box-shadow 0.2s, color 0.2s;
  }
  .menu-btn i {
    color: var(--gray-light);
  }
  .menu-btn:hover {
    background-color: var(--bg-soft);
    box-shadow: var(--shadow-soft);
  }
  .menu-btn:hover i {
    color: var(--accent-light);
  }

  .logo {
    display: flex;
    align-items: center;
    gap: 6px;
    font-weight: bold;
    font-size: 20px;
    text-decoration: none;
    color: var(--gray-light);
  }

  .logo img {
    height: 65px;
  }

  /* Thanh tìm kiếm */
  .search-bar {
    flex: 1;
    max-width: 600px;
    display: flex;
    align-items: center;
  }

  .search-input {
    flex: 1;
    background: var(--bg-soft);
    border: 1px solid var(--border-subtle);
    border-right: none;
    border-radius: 20px 0 0 20px;
    padding: 6px 12px;
    outline: none;
    color: var(--gray-light);
  }

  .search-btn {
    background: var(--bg-soft);
    border: 1px solid var(--border-subtle);
    border-left: none;
    border-radius: 0 20px 20px 0;
    padding: 6px 12px;
    cursor: pointer;
    color: var(--gray-subtle);
  }

  .search-btn:hover {
    background: var(--layer-soft);
    color: var(--accent-light);
  }

  .right-section {
    display: flex;
    align-items: center;
    gap: 16px;
  }

  /* Nút đăng nhập */
  .login-btn {
    display: flex;
    align-items: center;
    gap: 6px;
    background: var(--accent-grad);
    border: none;
    border-radius: 20px;
    color: #fff;
    font-weight: 500;
    padding: 6px 14px;
    cursor: pointer;
    box-shadow: var(--shadow-accent);
    transition: filter 0.2s, box-shadow 0.2s;
  }
  .login-btn:hover,
  .login-btn:focus{
    filter: brightness(1.06);
    box-shadow: var(--shadow-accent);
    color: #fff !important;
  }
  .login-btn i {
    font-size: 18px;
    color: #fff;
  }

  /* ----- PROFILE DROPDOWN ----- */
  .profile-dropdown {
    position: relative;
    display: flex;
    align-items: center;
    cursor: pointer;
  }

  .profile-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    border: 1px solid var(--border-soft);
    transition: box-shadow 0.2s, transform 0.2s;
    cursor: pointer;
  }

  .profile-avatar:hover {
    box-shadow: var(--shadow-soft);
    transform: scale(1.03);
  }

  .profile-menu {
    position: absolute;
    top: 48px;
    right: 0;
    width: 210px;
    background: var(--bg-panel);
    border: 1px solid var(--border-soft);
    border-radius: 10px;
    box-shadow: var(--shadow-soft);
    display: none;
    flex-direction: column;
    padding: 6px 0;
    z-index: 2000;
    animation: fadeIn 0.15s ease;
  }

  .profile-menu a {
    padding: 10px 16px;
    display: flex;
    align-items: center;
    gap: 10px;
    color: var(--gray-subtle);
    text-decoration: none;
    font-size: 14px;
    transition: background 0.18s, color 0.18s, filter 0.18s;
    border-radius: 8px;
  }

  .profile-menu a:hover {
    background: var(--accent-grad);
    color: #fff;
    filter: brightness(1.03);
  }

  .profile-menu a:hover i {
    color: #fff;
  }

  .profile-dropdown.open .profile-menu {
    display: flex;
  }

  @keyframes fadeIn {
    from {
      opacity: 0;
      transform: translateY(-4px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  /* ===== SIDEBAR DỌC ===== */
  .sidebar {
    position: fixed;
    top: 50px;
    left: 0;
    width: 230px;
    height: calc(100% - 50px);
    background-color: var(--bg-panel);
    border-right: 1px solid var(--border-subtle);
    padding-top: 20px;
    display: flex;
    flex-direction: column;
  }

  .sidebar a {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 11px 18px;
    text-decoration: none;
    color: var(--gray-subtle);
    font-size: 15px;
    border-radius: 8px;
    position: relative;
    transition: background 0.18s, color 0.18s;
  }

  .sidebar a:hover {
    background-color: var(--layer-soft);
    color: var(--accent);
  }

  .sidebar a.active {
    background: var(--accent-grad);
    color: #fff;
    font-weight: 600;
    box-shadow: var(--shadow-accent);
  }

  .sidebar a:active {
    background-color: var(--accent-dark);
  }

  .sidebar hr {
    margin: 16px 0;
    border: 0.5px solid var(--border-subtle);
  }

  .sidebar {
    transition: width .25s ease, transform .25s ease;
  }

  .sidebar.collapsed {
    width: 70px;
  }

  .sidebar.collapsed a {
    justify-content: center;
    padding: 11px 8px;
  }

  .sidebar.collapsed a span.link-text {
    display: none;
  }

  .sidebar.hidden {
    transform: translateX(-240px);
  }

  .sidebar.overlay {
    box-shadow: 0 4px 16px rgba(0,0,0,.35);
    z-index: 1500;
  }

  @media (max-width: 991.98px){
    .sidebar {
      transform: translateX(-240px);
    }
    .sidebar.show {
      transform: translateX(0);
    }
  }

  /* Badge hiển thị tooltips khi thu gọn */
  .sidebar.collapsed a:hover::after {
    content: attr(data-title);
    position: absolute;
    left: 74px;
    top: 50%;
    transform: translateY(-50%);
    background: var(--accent-grad);
    color:#fff;
    font-size:12px;
    padding:4px 8px;
    border-radius:6px;
    white-space:nowrap;
    box-shadow: var(--shadow-accent);
    z-index: 10;
  }

  /* Body khi sidebar thu gọn */
  body.has-collapsed .main-content,
  body.has-collapsed .footer-wrapper {
    margin-left: 90px !important;
  }
  body.has-hidden .main-content,
  body.has-hidden .footer-wrapper {
    margin-left: 0 !important;
  }

  .menu-btn {
    width: 38px;
    height: 38px;
  }

  .sidebar.slide-in {
    transform: translateX(0);
  }
  .sidebar.transitioning {
    pointer-events:none;
  }

  .sidebar.collapsed {
    overflow-x: hidden;
  }
  
  /* QUAN TRỌNG: Force collapse sidebar cho admin pages */
  /* body.admin-page .sidebar {
    width: 70px !important;
  }
  
  body.admin-page .sidebar a {
    justify-content: center;
    padding: 11px 8px;
  }
  
  body.admin-page .sidebar a span.link-text {
    display: none !important;
  }
  
  body.admin-page .main-content,
  body.admin-page .footer-wrapper {
    margin-left: 90px !important;
  } */
</style>
<div class="body container-fluid">
  <!-- Header ngang -->
  <header class="header">
    <div class="left-section">
      <!-- nút 3 gạch -->
      <button class="menu-btn" id="hamburgerBtn" title="Menu">
        <i class="fa-solid fa-bars"></i>
      </button>

      <!-- logo là thẻ a -->
      <a href="<c:url value='/home'/>" class="logo">
        <!-- THÊM: logo -->
        <img src="${pageContext.request.contextPath}/img/ava.png" alt="Logo" />
      </a>
    </div>

    <div class="search-bar">
      <input type="text" class="search-input" id="headerSearchInput" placeholder="Tìm kiếm video..." />
      <button class="search-btn" type="button" id="headerSearchBtn" title="Tìm kiếm">
        <i class="bi bi-search"></i>
      </button>
    </div>

    <div class="right-section">
      <c:choose>
        <c:when test="${not empty sessionScope.currentUser}">
          <!-- THÊM: dropdown hồ sơ -->
          <div id="profileDropdown" class="profile-dropdown">
            <img
              class="profile-avatar"
              src="<c:url value='${empty sessionScope.currentUser.avatar ? "/img/" : sessionScope.currentUser.avatar}'/>"
              alt="Avatar"
            />
            <div class="profile-menu">
              <a href="<c:url value='/home?page=profile'/>">
                <i class="fa-solid fa-user"></i> Hồ sơ
              </a>
              <a href="<c:url value='/logout'/>">
                <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
              </a>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <!-- THÊM: nút đăng nhập -->
          <a class="login-btn text-decoration-none" href="<c:url value='/home?page=login'/>">
            <i class="fa-solid fa-arrow-right-to-bracket"></i> Đăng nhập
          </a>
        </c:otherwise>
      </c:choose>
    </div>
  </header>
  
  <!-- Header dọc -->
  <nav class="sidebar" id="appSidebar"
     data-initial="<%= isAuth ? "hidden" : (shouldExpand ? "expanded" : "collapsed") %>"
     data-is-admin="<%= isAdminPage %>"
     data-is-home="<%= isHome %>"
     data-is-auth="<%= isAuth %>">
    <c:choose>
      <c:when test="${not empty sessionScope.currentUser and sessionScope.currentUser.admin}">
        <!-- THÊM: menu admin -->
        <a href="<c:url value='/home?page=home'/>" data-title="Trang chủ">
          <i class="fa-solid fa-house"></i> <span class="link-text">Trang chủ</span>
        </a>
        <a href="<c:url value='/admin?page=video-management'/>" data-title="Quản lý tiểu phẩm" data-admin-link="video">
          <i class="fa-solid fa-film"></i> <span class="link-text">Quản lý tiểu phẩm</span>
        </a>
        <a href="<c:url value='/admin?page=user-management'/>" data-title="Quản lý người dùng" data-admin-link="user">
          <i class="fa-solid fa-users"></i> <span class="link-text">Quản lý người dùng</span>
        </a>
        <a href="<c:url value='/admin?page=favorite-report'/>" data-title="Báo cáo thống kê" data-admin-link="favorite">
          <i class="fa-solid fa-chart-line"></i> <span class="link-text">Báo cáo thống kê</span>
        </a>
      </c:when>
      <c:otherwise>
        <!-- THÊM: menu người dùng -->
        <a href="<c:url value='/home?page=home'/>" data-title="Trang chủ">
          <i class="fa-solid fa-house"></i> <span class="link-text">Trang chủ</span>
        </a>
        <a href="<c:url value='/home?page=like'/>" data-title="Đã thích">
          <i class="fa-solid fa-thumbs-up"></i> <span class="link-text">Đã thích</span>
        </a>
<%--        <a href="<c:url value='/home?page=history'/>" data-title="Nhật ký xem">--%>
<%--          <i class="fa-solid fa-clock-rotate-left"></i> <span class="link-text">Nhật ký xem</span>--%>
<%--        </a>--%>
      </c:otherwise>
    </c:choose>
  </nav>
</div>

<script>
// KHỞI TẠO SIDEBAR NGAY LẬP TỨC để tránh nháy
(function(){
  const sidebar = document.getElementById('appSidebar');
  if(!sidebar) return;
  
  const isAuth = sidebar.dataset.isAuth === 'true';
  const isAdmin = sidebar.dataset.isAdmin === 'true';
  const isHome = sidebar.dataset.isHome === 'true';
  
  console.log('========== SIDEBAR INIT DEBUG ==========');
  console.log('isAuth:', isAuth);
  console.log('isAdmin:', isAdmin);
  console.log('isHome:', isHome);
  console.log('URL:', window.location.href);
  console.log('Pathname:', window.location.pathname);
  console.log('Search:', window.location.search);
  
  // THÊM: Kiểm tra xem có đang ở admin context không (bằng cách kiểm tra localStorage)
  const adminContext = localStorage.getItem('adminContext');
  console.log('Admin Context from localStorage:', adminContext);
  
  // Ẩn hoàn toàn nếu là trang auth
  if(isAuth) {
    sidebar.classList.add('hidden');
    document.body.classList.add('has-hidden');
    localStorage.removeItem('adminContext'); // Clear admin context
    console.log('→ Action: Hiding sidebar (auth page)');
    console.log('========================================');
    return;
  }
  
  // QUAN TRỌNG: Trang admin HOẶC có admin context → LUÔN thu gọn
  if(isAdmin || adminContext === 'true') {
    sidebar.classList.add('collapsed');
    document.body.classList.add('has-collapsed', 'admin-page');
    console.log('→ Action: Collapsing sidebar (admin page or admin context)');
    console.log('========================================');
    return;
  }
  
  // Trang chủ → mở rộng
  if(isHome) {
    sidebar.classList.remove('collapsed', 'hidden');
    document.body.classList.remove('has-collapsed', 'has-hidden', 'admin-page');
    localStorage.removeItem('adminContext'); // Clear admin context
    console.log('→ Action: Expanding sidebar (home page)');
    console.log('========================================');
    return;
  }
  
  // Các trang khác → thu gọn
  sidebar.classList.add('collapsed');
  document.body.classList.add('has-collapsed');
  console.log('→ Action: Collapsing sidebar (other page)');
  console.log('========================================');
})();

// Toggle sidebar khi nhấn nút hamburger
(function(){
  const sidebar = document.getElementById('appSidebar');
  const btn = document.getElementById('hamburgerBtn');
  const body = document.body;
  if(!sidebar || !btn) return;

  function applyBodyState() {
    body.classList.remove('has-collapsed','has-hidden');
    if(sidebar.classList.contains('collapsed')) body.classList.add('has-collapsed');
    if(sidebar.classList.contains('hidden')) body.classList.add('has-hidden');
  }

  function toggle() {
    const isAuth = sidebar.dataset.isAuth === 'true';
    
    // Auth pages: hidden -> slide-in collapsed -> expanded
    if (sidebar.classList.contains('hidden')) {
      sidebar.classList.remove('hidden');
      sidebar.classList.add('collapsed','overlay','slide-in');
      applyBodyState();
      setTimeout(()=> sidebar.classList.remove('slide-in'),250);
      return;
    }
    
    // Toggle collapse/expand cho TẤT CẢ trang (bao gồm cả admin)
    if (sidebar.classList.contains('collapsed')) {
      // Mở rộng ra full
      sidebar.classList.remove('collapsed');
      sidebar.classList.remove('overlay');
      body.classList.remove('has-collapsed');
    } else {
      // Thu gọn lại
      sidebar.classList.add('collapsed');
      body.classList.add('has-collapsed');
    }
    applyBodyState();
  }

  btn.addEventListener('click', toggle);

  // Click ngoài để đóng overlay khi ở hidden mở ra (mobile/auth)
  document.addEventListener('click',(e)=>{
    const isAuth = sidebar.dataset.isAuth === 'true';
    if(!sidebar.contains(e.target) && !btn.contains(e.target)){
      if (sidebar.classList.contains('overlay') && sidebar.classList.contains('collapsed') && isAuth){
        sidebar.classList.add('hidden');
        sidebar.classList.remove('collapsed','overlay');
        applyBodyState();
      }
    }
  });

  // ESC đóng khi ở overlay auth
  document.addEventListener('keydown',(e)=>{
    const isAuth = sidebar.dataset.isAuth === 'true';
    if(e.key == 'Escape' && sidebar.classList.contains('overlay') && isAuth){
      sidebar.classList.add('hidden');
      sidebar.classList.remove('collapsed','overlay');
      applyBodyState();
    }
  });
})();

// Toggle profile dropdown
(function(){
  const dropdown = document.getElementById('profileDropdown');
  if(!dropdown) return;
  const menu = dropdown.querySelector('.profile-menu');
  let open = false;
  function show(){ menu.style.display = 'flex'; open = true; dropdown.classList.add('open'); }
  function hide(){ menu.style.display = 'none'; open = false; dropdown.classList.remove('open'); }
  dropdown.addEventListener('click', (e) => {
    e.stopPropagation();
    open ? hide() : show();
  });
  document.addEventListener('click', () => { if(open) hide(); });
  document.addEventListener('keydown', (e) => { if (e.key == 'Escape' && open) hide(); });
  window.addEventListener('blur', hide);
})();

// Active link và xử lý click vào link admin
(function(){
  const sidebar = document.getElementById('appSidebar');
  if(!sidebar) return;
  const links = Array.from(sidebar.querySelectorAll('a'));
  const body = document.body;

  function applyBodyState() {
    body.classList.remove('has-collapsed','has-hidden');
    if(sidebar.classList.contains('collapsed')) body.classList.add('has-collapsed');
    if(sidebar.classList.contains('hidden')) body.classList.add('has-hidden');
  }

  function setActive(el){
    links.forEach(l => l.classList.remove('active'));
    if(el) el.classList.add('active');
  }

  function getHomeLink(){
    return links.find(l => {
      const href = l.getAttribute('href') || '';
      return href.includes('page=home') || href.endsWith('/home') || href.endsWith('/home/');
    }) || links[0];
  }

  // QUAN TRỌNG: Xử lý click vào TẤT CẢ link admin - thu gọn sidebar VÀ lưu context
  links.forEach(link => {
    const href = link.getAttribute('href') || '';
    const isAdminLink = link.hasAttribute('data-admin-link');

    // Kiểm tra nếu là link admin
    if (isAdminLink || href.includes('video-management') || 
        href.includes('user-management') || 
        href.includes('favorite-report')) {
      link.addEventListener('click', function (e) {
        console.log('Clicked admin link:', href);
        
        // Lưu admin context vào localStorage
        localStorage.setItem('adminContext', 'true');
        
        // Thu gọn sidebar NGAY LẬP TỨC khi click
        sidebar.classList.add('collapsed');
        sidebar.classList.remove('hidden', 'overlay');
        body.classList.add('admin-page');
        applyBodyState();
        
        // active link ngay
        setActive(link);
      });
    } else {
      // Link không phải admin → clear admin context
      link.addEventListener('click', function() {
        if(href.includes('page=home') || href.endsWith('/home')) {
          localStorage.removeItem('adminContext');
          body.classList.remove('admin-page');
        }
      });
    }
  });

  function restoreActive(){
    const params = new URLSearchParams(location.search);
    const page = params.get('page');
    const path = location.pathname;
    
    console.log('========== RESTORE ACTIVE DEBUG ==========');
    console.log('page parameter:', page);
    console.log('pathname:', path);
    
    // QUAN TRỌNG: Kiểm tra các trang admin
    if(page === 'video-management' || path.includes('/video-management') || path.includes('/admin') && path.includes('/video')){
      const match = links.find(l => (l.getAttribute('href')||'').includes('video-management'));
      if(match) {
        localStorage.setItem('adminContext', 'true');
        console.log('→ Activating: video-management');
        console.log('==========================================');
        return setActive(match);
      }
    }
    if(page === 'user-management' || path.includes('/user-management') || path.includes('/admin') && path.includes('/user')){
      const match = links.find(l => (l.getAttribute('href')||'').includes('user-management'));
      if(match) {
        localStorage.setItem('adminContext', 'true');
        console.log('→ Activating: user-management');
        console.log('==========================================');
        return setActive(match);
      }
    }
    if(page === 'favorite-report' || path.includes('/favorite-report') || path.includes('/admin') && path.includes('/favorite')){
      const match = links.find(l => (l.getAttribute('href')||'').includes('favorite-report'));
      if(match) {
        localStorage.setItem('adminContext', 'true');
        console.log('→ Activating: favorite-report');
        console.log('==========================================');
        return setActive(match);
      }
    }
    
    // Các trang user khác
    if(page && page !== 'home' && page !== ''){
      const match = links.find(l => (l.getAttribute('href')||'').includes('page=' + page));
      if(match) {
        console.log('→ Activating page:', page);
        console.log('==========================================');
        return setActive(match);
      }
    }
    
    // Mặc định: active Trang chủ
    console.log('→ Activating: home (default)');
    console.log('==========================================');
    setActive(getHomeLink());
  }

  restoreActive();
})();

// ========== TÌM KIẾM VIDEO ==========
(function(){
  const searchInput = document.getElementById('headerSearchInput');
  const searchBtn = document.getElementById('headerSearchBtn');
  
  if(!searchInput || !searchBtn) return;
  
  const contextPath = '${pageContext.request.contextPath}';
  
  function performSearch() {
    const keyword = searchInput.value.trim();
    if(keyword === '') {
      // Nếu không có từ khóa, về trang chủ
      window.location.href = contextPath + '/home';
      return;
    }
    // Chuyển đến trang tìm kiếm với từ khóa
    window.location.href = contextPath + '/home?page=home&search=' + encodeURIComponent(keyword);
  }
  
  // Click nút tìm kiếm
  searchBtn.addEventListener('click', performSearch);
  
  // Nhấn Enter để tìm kiếm
  searchInput.addEventListener('keyup', function(e) {
    if(e.key === 'Enter') {
      performSearch();
    }
  });
  
  // Giữ lại từ khóa tìm kiếm trong ô input khi load trang
  const params = new URLSearchParams(window.location.search);
  const searchKeyword = params.get('search');
  if(searchKeyword) {
    searchInput.value = searchKeyword;
  }
})();

// Set max date cho ngày sinh là hôm nay
const today = new Date().toISOString().split('T')[0];
document.getElementById('editBirthdate').setAttribute('max', today);

// Thiết lập avatar preview dựa trên avatar hiện tại của session
const avatarPreview = document.getElementById('avatarPreview');
const ctx = '${pageContext.request.contextPath}';
const currentAvatar = '${sessionScope.currentUser.avatar}';
if (avatarPreview) {
    if (currentAvatar && currentAvatar.trim() !== '') {
        let url = currentAvatar;
        if (url.startsWith('/')) url = ctx + url;
        else if (!url.startsWith('http')) url = ctx + '/' + url;
        avatarPreview.src = url;
        avatarPreview.style.display = '';
    } else {
        avatarPreview.src = '';
        avatarPreview.style.display = 'none';
    }
}
</script>

