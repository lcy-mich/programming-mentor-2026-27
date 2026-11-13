<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/head.jsp"%>
</head>
<body>
    <%@ include file="/navbar.jsp" %>
    <div class="container mt-4">
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h1 class="card-title h4 mb-0">Search Patient Records</h1>
            </div>
            <div class="card-body">
                <form method="GET" action="/runsearch">
                    <div class="mb-3">
                        <label for="searchstring" class="form-label">Input Field</label>
                        <input type="text" class="form-control" id="searchstring" name="searchstring" placeholder="Search any data...">
                    </div>
                    <button type="submit" class="btn btn-primary">Search</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>