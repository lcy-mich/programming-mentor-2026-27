<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map.Entry" %>

<html>
<head>
    <%@ include file="/head.jsp" %>
</head>
<body>
    <%@ include file="/navbar.jsp" %>
    <div class="container mt-4">
        <h1 class="mb-4">Num of People per City</h1>
        <%
            HashMap<String, Integer> cityCounts = (HashMap<String, Integer>) request.getAttribute("cityCounts");
            if (cityCounts == null || cityCounts.isEmpty()) {
        %>
            <div class="alert alert-warning">No city data available.</div>
        <%
            } else {
        %>
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover">
                    <tr class="table-dark">
                        <th scope="col">City</th>
                        <th scope="col">Count</th>
                     </tr>
                    <%
                        for (Entry<String, Integer> entry : cityCounts.entrySet()) {
                    %>
                         <tr>
                            <td><%= entry.getKey() %></td>
                            <td><%= entry.getValue() %></td>
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