<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.LinkedHashSet" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <%@ include file="/head.jsp" %>
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
        <%
            ArrayList<HashMap<String, String>> patients =
                (ArrayList<HashMap<String, String>>) request.getAttribute("result");
            String searchString = request.getParameter("searchstring");
            int size = (patients == null) ? 0 : patients.size();
        %>

        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h2 class="h5 mb-0">Search Again</h2>
            </div>
            <div class="card-body">
                <form method="GET" action="/runsearch" class="row g-3">
                    <div class="col-auto">
                        <input type="text" class="form-control" name="searchstring"
                               value="<%= escapeHtml(searchString) %>"
                               placeholder="Enter keyword...">
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary">Search</button>
                    </div>
                </form>
            </div>
        </div>

        <h3 class="mb-3">Found <%= size %> entries for "<%= escapeHtml(searchString) %>"</h3>

        <%
            if (size == 0) {
        %>
            <div class="alert alert-warning">
                <p>No results found with: <strong><%= escapeHtml(searchString) %></strong></p>
                <p class="mb-0">Maybe try something broader?</p>
            </div>
        <%
            } else {
                // Collect all unique column names from all patients (excluding ID and Fullname)
                Set<String> allKeys = new LinkedHashSet<>();
                for (HashMap<String, String> patient : patients) {
                    allKeys.addAll(patient.keySet());
                }
                List<String> extraColumns = new ArrayList<>();
                for (String key : allKeys) {
                    if (!"ID".equals(key) && !"Fullname".equals(key)) {
                        extraColumns.add(key);
                    }
                }
        %>
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover">
                    <tr class="table-dark">
                        <th scope="col">Full Name</th>
                        <th scope="col">ID</th>
                        <%
                            for (String colName : extraColumns) {
                        %>
                            <th scope="col"><%= escapeHtml(colName) %></th>
                        <%
                            }
                        %>
                    </tr>
                    <%
                        for (HashMap<String, String> patient : patients) {
                            String patientId = patient.get("ID");
                            String fullName = patient.get("Fullname");
                    %>
                         <tr>
                            <td><a href="/patientInfo?id=<%= patientId %>" class="link-primary"><%= escapeHtml(fullName) %></a></td>
                            <td><a href="/patientInfo?id=<%= patientId %>" class="link-primary"><%= escapeHtml(patientId) %></a></td>
                            <%
                                for (String colName : extraColumns) {
                                    String value = patient.get(colName);
                                    if (value == null) value = "";
                            %>
                                <td><%= escapeHtml(value) %></td>
                            <%
                                }
                            %>
                         </tr>
                    <%
                        }
                    %>
                </table>
            </div>
        <%
            }
        %>
    </div>
</body>
</html>