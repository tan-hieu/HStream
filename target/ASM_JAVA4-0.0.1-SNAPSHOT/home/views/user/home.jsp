<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
taglib prefix="fn" uri="jakarta.tags.functions" %>

<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/assets/css/theme.css"
/>

<style>
  .video-card {
    background: var(--bg-soft);
    border: 1px solid var(--border-subtle);
    border-radius: 12px;
    overflow: hidden;
    transition: transform 0.2s ease, box-shadow 0.2s ease,
      border-color 0.2s ease;
    box-shadow: var(--shadow-soft);
    height: 100%;
    position: relative;
    text-decoration: none;
    color: var(--gray-light);
    display: block;
  }
  .video-card:hover {
    background: var(--bg-panel);
    border-color: var(--accent);
    box-shadow: var(--shadow-accent);
    transform: translateY(-2px);
  }
  .thumbnail {
    width: 100%;
    height: 200px;
    object-fit: cover;
    display: block;
    border-bottom: 1px solid var(--border-subtle);
  }
  .video-info {
    padding: 12px 14px 16px;
  }
  .title {
    font-size: 16px;
    font-weight: 600;
    color: var(--gray-light);
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    text-overflow: ellipsis;
    margin: 8px 0 6px;
  }
  .title:hover {
    color: var(--accent-light);
  }
  .author-row {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 8px;
  }
  .author-avatar {
    width: 28px;
    height: 28px;
    border-radius: 50%;
    object-fit: cover;
    border: 1px solid var(--border-subtle);
    background: var(--layer-soft);
  }
  .author-name {
    color: var(--gray-subtle);
    font-size: 14px;
    font-weight: 500;
  }
  .meta {
    font-size: 13px;
    color: var(--gray-muted);
  }
  .stats {
    margin-top: 6px;
    font-size: 13px;
    color: var(--gray-muted);
    display: flex;
    justify-content: space-between; /* THÊM: tách 2 bên */
    align-items: center;
    flex-wrap: nowrap; /* giữ trên 1 dòng */
    gap: 12px;
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
    padding: 6px 12px;
    border-radius: 8px;
    border: 1px solid var(--border-soft);
    background: var(--layer-soft);
    color: var(--gray-light);
  }
  .pagination-page.active {
    border-color: var(--accent);
    color: var(--accent-light);
  }
</style>

<div class="container">
  <!-- THÊM: Hiển thị thông báo tìm kiếm -->
  <c:if test="${not empty searchKeyword}">
    <div
      class="search-result-info"
      style="
        margin-bottom: 20px;
        padding: 12px 16px;
        background: var(--bg-soft);
        border: 1px solid var(--border-subtle);
        border-radius: 10px;
        color: var(--gray-light);
      "
    >
      <i class="bi bi-search me-2"></i>
      Kết quả tìm kiếm cho: <strong>"${fn:escapeXml(searchKeyword)}"</strong>
      <span style="color: var(--gray-muted)"> - ${totalItems} video</span>
      <a
        href="${pageContext.request.contextPath}/home"
        style="margin-left: 12px; color: var(--accent-light)"
      >
        <i class="bi bi-x-circle"></i> Xóa bộ lọc
      </a>
    </div>
  </c:if>

  <div class="row g-4">
    <c:forEach var="v" items="${videos}">
      <div class="col-lg-4 col-md-6 col-12">
        <a
          href="${pageContext.request.contextPath}/home?page=details&id=${v.id}"
          class="video-card"
        >
          <c:choose>
            <c:when test="${not empty v.thumbnailUrl}">
              <c:set var="thumbUrl" value="${v.thumbnailUrl}" />
              <c:if
                test="${not fn:startsWith(thumbUrl,'http') && not fn:startsWith(thumbUrl,'/')}"
              >
                <c:set
                  var="thumbUrl"
                  value="${pageContext.request.contextPath}/${thumbUrl}"
                />
              </c:if>
              <c:if
                test="${not fn:startsWith(thumbUrl,'http') && fn:startsWith(thumbUrl,'/')}"
              >
                <c:set
                  var="thumbUrl"
                  value="${pageContext.request.contextPath}${thumbUrl}"
                />
              </c:if>
            </c:when>
            <c:otherwise>
              <c:set
                var="thumbUrl"
                value="${pageContext.request.contextPath}/img/default-thumb.png"
              />
            </c:otherwise>
          </c:choose>

          <img
            src="${thumbUrl}"
            class="thumbnail"
            alt="${fn:escapeXml(v.title)}"
          />
          <div class="video-info">
            <div class="title">${v.title}</div>

            <div class="author-row">
<%--              <img class="author-avatar" src="<c:out--%>
<%--                value='${empty v.channelName ? pageContext.request.contextPath.concat("/img/default-avatar.png") : pageContext.request.contextPath.concat("/img/default-avatar.png")}'--%>
<%--              />" alt="avatar" />--%>
              <div class="author-name">
                <c:choose>
                  <c:when test="${not empty v.channelName}">
                    ${v.channelName}
                  </c:when>
                  <c:otherwise>${fn:escapeXml(v.content)}</c:otherwise>
                </c:choose>
              </div>
            </div>

            <!-- Gộp views (trái) và ngày (phải) vào cùng một hàng -->
            <div class="stats">
              <span
                ><i class="bi bi-eye"></i> <c:out value="${v.views}"
              /></span>
              <span>
                <c:choose>
                  <c:when test="${v.postingDate != null}"
                    >${v.postingDate}</c:when
                  >
                  <c:otherwise>Không rõ ngày</c:otherwise>
                </c:choose>
              </span>
            </div>
          </div>
        </a>
      </div>
    </c:forEach>

    <c:if test="${empty videos}">
      <div class="col-12">Không có video nào.</div>
    </c:if>
  </div>

  <div class="pagination-wrapper">
    <div class="pagination-controls">
      <a
        class="pagination-btn"
        href="${pageContext.request.contextPath}/home?page=home&p=${currentPage-1}<c:if test='${not empty searchKeyword}'>&search=${fn:escapeXml(searchKeyword)}</c:if>"
        style="<c:if test='${currentPage == 1}'>pointer-events:none;opacity:.6</c:if>"
        >Trước</a
      >

      <c:forEach begin="1" end="${totalPages}" var="i">
        <a
          class="pagination-page <c:if test='${i==currentPage}'>active</c:if>"
          href="${pageContext.request.contextPath}/home?page=home&p=${i}<c:if test='${not empty searchKeyword}'>&search=${fn:escapeXml(searchKeyword)}</c:if>"
          >${i}</a
        >
      </c:forEach>

      <a
        class="pagination-btn"
        href="${pageContext.request.contextPath}/home?page=home&p=${currentPage+1}<c:if test='${not empty searchKeyword}'>&search=${fn:escapeXml(searchKeyword)}</c:if>"
        style="<c:if test='${currentPage == totalPages}'>pointer-events:none;opacity:.6</c:if>"
        >Sau</a
      >
    </div>
    <div style="color: var(--gray-muted); font-size: 13px">
      Trang ${currentPage} / ${totalPages} • Tổng ${totalItems} video
    </div>
  </div>
</div>
