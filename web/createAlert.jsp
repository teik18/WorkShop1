<%-- 
    Document   : createAlert
    Created on : Jun 2, 2025, 4:45:30 PM
    Author     : ACER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.User"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Alert Page</title>
        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background-color: #f9f8ff;
            }

            .container {
                display: flex;
                height: 100vh;
            }

            .sidebar {
                width: 220px;
                background-color: #3f51b5;
                color: white;
                padding: 20px;
            }

            .sidebar h2 {
                font-size: 24px;
                margin-bottom: 20px;
            }

            .sidebar a {
                display: block;
                color: white;
                text-decoration: none;
                margin-bottom: 10px;
                font-weight: bold;
            }

            .sidebar a:hover {
                background-color: #303f9f;
                padding: 5px;
                border-radius: 4px;
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .header h1 {
                margin: 0;
                /* font-size: 22px; */
            }

            .header a {
                background-color: #4CAF50;
                color: white;
                padding: 6px 12px;
                text-decoration: none;
                border-radius: 4px;
            }

            .header a:hover {
                background-color: #45a049;
            }

            .main-content {
                flex: 1;
                padding: 30px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }

            th {
                background-color: #3f51b5;
                color: white;
            }

            tr:nth-child(even) {
                background-color: #f2f2f2;
            }

            tr:hover {
                background-color: #ddd;
            }

            .actions button {
                margin-right: 5px;
            }

            button {
                padding: 6px 12px;
                margin-right: 5px;
                background-color: #2196F3;
                color: white;
                border: none;
                cursor: pointer;
                border-radius: 4px;
            }

            button[type="submit"]:last-child {
                background-color: #f44336; /* Delete button */
            }
        </style>
    </head>
    <body>
        <%
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        <div class="container">
            <div class="sidebar">
                <h2>Menu</h2>
                <a href="MainController?action=SearchUser">Stocks List</a>
                <a href="MainController?action=SearchStock">Transactions List</a>
                <a href="MainController?action=ViewAlert">Alerts List</a>
                <% if ("AD".equals(loginUser.getRoleID())) { %>
                <a href="MainController?action=ViewUsers">Users List</a><br>
                <% } %>
            </div>

            <div class="main-content">
                <div class="header">
                    <h1>Welcome, <c:out value="${sessionScope.LOGIN_USER.fullName}"/></h1>
                    <p><a href="${pageContext.request.contextPath}/LogoutController">Logout</a></p>
                </div>
                <h1>Create Alert</h1>
                <form action="MainController" method="POST">
                    Ticker: <input type="text" name="ticker" placeholder="Enter ticker" required /><br/>
                    Threshold: <input type="number" name="threshold" placeholder="Enter threshold" step="0.01" required /><br/>
                    Direction: 
                    <select name="direction" required>
                        <option value="increase">increase</option>
                        <option value="decrease">decrease</option>
                    </select><br/>
                    <input type="submit" name="action" value="CreateAlert" /><br/>
                    <a href="MainController?action=ViewAlerts">Back to Alert List</a>
                </form>
                <% String msg = (String) request.getAttribute("MSG"); %>
                <% if (msg != null && msg.contains("successfully")) { %>
                <p style="color: green;"><%= msg %></p>
                <% } else if (msg != null) { %>
                <p style="color: red;"><%= msg %></p>
                <% } %>
            </div>
        </div>
    </body>
</html>
