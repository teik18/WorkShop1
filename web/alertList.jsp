<%-- 
    Document   : alertList
    Created on : Jun 2, 2025, 4:43:12 PM
    Author     : ACER
--%>

<%@page import="dto.Alert"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alert List Page</title>
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
            
            th, td:nth-child(1), td:nth-child(2), td:nth-child(6) {
                text-align: center;
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

            .function-buttons {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 10px; 
                position: relative;
            }

            .function-buttons form {
                margin: 0;
            }

            button {
                padding: 10px 12px;
                background-color: #2196F3;
                color: white;
                border: none;
                cursor: pointer;
                border-radius: 4px;
                width: 70px; 
                text-align: center;
            }

            .butDelete {
                background-color: #f44336; /* Delete button */
            }
            .formUpdate {
                position: relative;
                margin-right: 10px; /* Khoảng cách giữa Update và gạch dọc */
            }
            .delete-placeholder {
                width: 70px; /* Cùng chiều rộng với nút Delete */
                height: 28px; /* Cùng chiều cao với nút */
            }
            .sidebar a.active {
                background-color: #283593;
                padding: 5px;
                border-radius: 4px;
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
                <% if ("AD".equals(loginUser.getRoleID())) { %>
                <a href="MainController?action=SearchUser">User List</a>
                <% } %>
                <a href="MainController?action=SearchTransaction">Transaction List</a>
                <a href="MainController?action=SearchStock">Stock List</a>
                <a class="active" href="MainController?action=ViewAlerts">Alert List</a>
            </div>

            <div class="main-content">
                <div class="header">
                    <h1>Welcome, <c:out value="${sessionScope.LOGIN_USER.fullName}"/></h1>
                    <p><a href="${pageContext.request.contextPath}/LogoutController">Logout</a></p>
                </div>


                <form action="MainController" method="POST">
                    <input type="text" name="search" placeholder="Search">
                    <select name="direction">
                        <option value="">Any</option>
                        <option value="increase">Increase</option>
                        <option value="decrease">Decrease</option>
                    </select>

                    <select name="status">
                        <option value="">Any</option>
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                    </select>

                    <button type="submit" name="action" value="ViewAlerts">Search</button>
                </form>
                <a href="MainController?action=CreateAlert">Create New Alert</a><br/>

                <%
                    String MSG = (String) request.getAttribute("MSG");
                    if (MSG != null && MSG.contains("successfully")) {
                %>
                <h3 style="color: green;"> <%= MSG%> </h3>
                <%
                    } else if (MSG != null) {
                %>
                <h3 style="color: red;"> <%= MSG%> </h3>
                <%
                    }
                    ArrayList<Alert> list = (ArrayList<Alert>) request.getAttribute("list");
                    if (list != null) {
                %>
                <table>
                    <tr>
                        <th>No</th>
                        <th>Ticker</th>
                        <th>Threshold</th>
                        <th>Direction</th>
                        <th>Status</th>
                        <th>Function</th>
                    </tr>
                    <%
                        int count = 0;
                        for (Alert alert : list) {
                            count++;
                    %>
                    <tr>
                        <td><%= count%></td>
                        <td><%= alert.getTicker()%></td>
                        <td><input type="text" name="threshold" value="<%= alert.getThreshold()%>" readonly></td>
                        <td><input type="text" name="direction" value="<%= alert.getDirection()%>" readonly></td>
                        <td><input type="text" name="status" value="<%= alert.getStatus()%>" readonly></td>
                        <td>
                            <div class="function-buttons">
                                <form action="MainController" method="POST">
                                    <input type="hidden" name="alertID" value="<%= alert.getAlertID() %>">
                                    <button type="submit" name="action" value="UpdateAlert">Update</button>
                                </form>
                                <% if ("inactive".equals(alert.getStatus())) { %>
                                <form action="MainController" method="POST">
                                    <input type="hidden" name="alertID" value="<%= alert.getAlertID() %>">
                                    <button class="butDelete" type="submit" name="action" value="DeleteAlert">Delete</button>
                                </form>
                                <% } else { %>
                                <div class="delete-placeholder"></div>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% }
                    %>
                </table>
                <% String msg = (String) request.getAttribute("MSG"); %>
                <% if (msg != null) { %>
                <p style="color: red;"><%= msg %></p>
                <% } %>
                <%
                    }
                %>
            </div>
        </div>
    </body>
</html>
