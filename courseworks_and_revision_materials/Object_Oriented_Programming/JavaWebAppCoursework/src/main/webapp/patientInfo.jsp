<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/head.jsp" %>
    <title>Patient Information</title>
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
        <h1 class="mb-4">Patient Information</h1>
        <%
            String[] record = (String[]) request.getAttribute("record");
            String[] columnNames = (String[]) request.getAttribute("columnNames");

            if (record == null || columnNames == null || record.length == 0) {
        %>
            <div class="alert alert-warning">No data available for this patient.</div>
        <%
            } else {
        %>
            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <% for (int i = 0; i < columnNames.length; i++) { %>
                         <tr>
                            <th scope="row" class="table-dark" style="width: 30%;"><%= escapeHtml(columnNames[i]) %></th>
                            <td><%= escapeHtml(record[i]) %></td>
                         </tr>
                    <% } %>
                 </table>
            </div>
        <%
            }
        %>
    </div>
</body>
</html>