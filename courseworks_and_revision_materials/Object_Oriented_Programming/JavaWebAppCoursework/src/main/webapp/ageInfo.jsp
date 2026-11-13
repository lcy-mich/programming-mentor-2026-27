<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.HashMap" %>
<html>
<head>
    <%@ include file="/head.jsp" %>
    <title>Age Statistics</title>
</head>
<body>
    <%@ include file="/navbar.jsp" %>

    <%!
        private String escapeHtml(String input) {
            if (input == null) return "";
            return input.replace("&", "&amp;")
                        .replace("<", "&lt;")
                        .replace(">", "&gt;")
                        .replace("\"", "&quot;")
                        .replace("'", "&#39;");
        }
    %>

    <div class="container mt-4">
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h1 class="card-title h4 mb-0">Patient Age Statistics</h1>
            </div>
            <div class="card-body">
                <%
                    HashMap<String, String> stats = (HashMap<String, String>) request.getAttribute("stats");
                    if (stats == null || stats.isEmpty()) {
                %>
                    <div class="alert alert-warning">No age data available.</div>
                <%
                    } else {
                %>
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped">
                            <tr class="table-dark">
                                <th scope="col">Statistic</th>
                                <th scope="col">Value</th>
                             </tr>
                            <tr>
                                <th scope="row">Maximum Age</th>
                                <td><%= escapeHtml(stats.get("maxAge")) %> years</td>
                             </tr>
                            <tr>
                                <th scope="row">Minimum Age</th>
                                <td><%= escapeHtml(stats.get("minAge")) %> years</td>
                             </tr>
                            <tr>
                                <th scope="row">Average Age</th>
                                <td><%= escapeHtml(stats.get("avgAge")) %> years</td>
                             </tr>
                            <tr>
                                <th scope="row">Age Range</th>
                                <td><%= escapeHtml(stats.get("ageRange")) %> years</td>
                             </tr>
                         </table>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>