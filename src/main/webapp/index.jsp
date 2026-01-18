<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Trang chủ</title>
    <link
      rel="icon"
      type="image/png"
      href="${pageContext.request.contextPath}/img/logo.png"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
      crossorigin="anonymous"
    />
    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
      crossorigin="anonymous"
    ></script>
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css"
    />
    <!-- Font awsome -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/theme.css"
    />
    <style>
      /* THÊM: CSS cho layout chính */
      body {
        margin: 0;
        padding: 0;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
      }

      .main-content {
        margin-left: 230px;
        margin-top: 60px;
        padding: 20px;
        flex: 1;
      }

      /* THÊM: Footer luôn ở dưới cùng */
      /*.footer-wrapper {*/
      /*  margin-left: 230px; !* Bằng width của sidebar *!*/
      /*  margin-top: auto;*/
      /*}*/
    </style>
  </head>
  <body class="app-radial">
    <%@ include file="home/layouts/header.jsp" %>
    <div class="main-wrapper">
      <!-- Content area -->
      <div class="main-content">
        <jsp:include
          page="${page != null ? page : 'home/views/user/home.jsp'}"
        />
      </div>
    </div>
<%--    <div class="footer-wrapper">--%>
<%--      <%@ include file="home/layouts/footer.jsp" %>--%>
<%--    </div>--%>
  </body>
</html>
