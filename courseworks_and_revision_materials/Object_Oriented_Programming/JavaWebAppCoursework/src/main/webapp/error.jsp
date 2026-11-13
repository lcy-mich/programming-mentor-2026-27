<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/head.jsp"%>
</head>
<body>
  <%@ include file="/navbar.jsp" %>
  <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
  <div class="container mt-4">
    <div class="alert alert-danger" role="alert">
      <h1 class="alert-heading">ERROR</h1>
      <p><%= errorMessage != null ? errorMessage : "An unexpected error occurred." %></p>
    </div>
  </div>
</body>
</html>