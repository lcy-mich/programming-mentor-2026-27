<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import ="java.util.HashMap"%>
<%@ page import ="java.util.Map.Entry"%>

<html>
<head>
    <%@ include file="/head.jsp"%>
</head>
<body>
    <%@ include file="/navbar.jsp" %>
    <div class="container mt-4">
        <h1 class="mb-4">Patient ID List</h1>
        <%
            HashMap<String, String> patients = (HashMap<String, String>) request.getAttribute("idAndPatientNames");
            if (patients == null || patients.isEmpty()) {
        %>
            <div class="alert alert-info">No patients found.</div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover">
                    <tr class="table-dark">
                        <th scope="col">ID</th>
                        <th scope="col">Full Name</th>
                    </tr>
                    <% for (Entry<String, String> patient : patients.entrySet()) { %>
                        <tr>
                            <td><a href="/patientInfo?id=<%= patient.getKey() %>" class="link-primary"><%= patient.getKey() %></a></td>
                            <td><a href="/patientInfo?id=<%= patient.getKey() %>" class="link-primary"><%= patient.getValue() %></a></td>
                        </tr>
                    <% } %>
                </table>
            </div>
        <% } %>
    </div>
</body>
</html>