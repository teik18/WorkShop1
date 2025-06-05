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
        <link rel="stylesheet" type="text/css" href="css/pageStyle.css"> 
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
                <a href="MainController?action=SearchStock">Stock List</a>
                <a href="MainController?action=SearchTransaction">Transaction List</a>
                <a class="active" href="MainController?action=ViewAlerts">Alert List</a>
                <% if ("AD".equals(loginUser.getRoleID())) { %>
                <a href="MainController?action=SearchUser">User List</a>
                <% } %>
            </div>

            <div class="main-content">
                <div class="header">
                    <h1>Welcome, <c:out value="${sessionScope.LOGIN_USER.fullName}"/></h1>
                    <p><a href="${pageContext.request.contextPath}/LogoutController">Logout</a></p>
                </div>

                <hr>

                <div class="function-header">
                    <div class="function">
                        <!--search form-->
                        <form action="MainController" method="POST">
                            Search:
                            <input type="text" name="search" placeholder="Search" value="${requestScope.keyword}">
                            <select name="directionSearch">
                                <option value="" ${requestScope.directionSearch == '' ? 'selected' : ''}>Any</option>
                                <option value="increase" ${requestScope.directionSearch == 'increase' ? 'selected' : ''}>Increase</option>
                                <option value="decrease" ${requestScope.directionSearch == 'decrease' ? 'selected' : ''}>Decrease</option>
                            </select>

                            <select name="statusSearch">
                                <option value="" ${requestScope.statusSearch == '' ? 'selected' : ''}>Any</option>
                                <option value="active" ${requestScope.statusSearch == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${requestScope.statusSearch == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>

                            <button type="submit" name="action" value="ViewAlerts">Search</button>
                        </form>

                        <!--create form-->
                        <button id="showCreateForm" class="button-green" onclick="toggleCreateForm()">Create</button>
                        <div id="createForm" style="display: none;">
                            <h3>Create New Alert</h3> <hr>
                            <form action="MainController" method="POST">
                                <input type="hidden" name="action" value="CreateAlert"/>
                                <div class="form-group">
                                    <label for="ticker">Ticker:</label>
                                    <input type="text" id="ticker" name="ticker" value="${param.ticker}" required/>
                                </div>

                                <div class="form-group">
                                    <label for="threshold">Threshold:</label>
                                    <input type="text" id="threshold" name="threshold" value="${param.threshold}" required/>
                                </div>

                                <div class="form-group">
                                    <label for="direction">Direction:</label>
                                    <select id="direction" name="direction" required>
                                        <option value="increase" ${param.direction == 'increase' ? 'selected' : ''}>increase</option>
                                        <option value="decrease" ${param.direction == 'decrease' ? 'selected' : ''}>decrease</option>
                                    </select>
                                </div>
                                <button type="submit" class="button-green">Create</button>
                            </form>
                        </div>
                    </div>

                    <div class="message">
                        <%
                            String MSG = (String) request.getAttribute("MSG");
                            if ((MSG != null && MSG.contains("successfully")) || (MSG != null && MSG.contains("Successfully"))) {
                        %>
                        <h3 id="msg" class="msg success"  style="color: #3c763d; background-color: #e0ffe0;"> <%= MSG%> </h3>
                        <%
                            } else if (MSG != null) {
                        %>
                        <h3 id="msg" class="msg error" style="color: #a94442; background-color: #f2dede;"> <%= MSG%> </h3>
                        <% } %>
                    </div>
                </div>

                <%
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
                                    <button class="butDelete" type="submit" name="action" value="DeleteAlert" onclick="return confirm('Are you sure to delete this alert?')">Delete</button>
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
                <%
                    }
                %>
            </div>
        </div>

        <script>
            function toggleCreateForm() {
                const formDiv = document.getElementById("createForm");
                const btn = document.getElementById("showCreateForm");
                if (formDiv.style.display === "none") {
                    formDiv.style.display = "block";
                    btn.classList.remove("button-green");
                    btn.classList.add("button-red");
                    btn.innerHTML = "Close";
                } else {
                    formDiv.style.display = "none";
                    btn.classList.remove("button-red");
                    btn.classList.add("button-green");
                    btn.innerHTML = "Create";
                }
            }

            window.addEventListener("DOMContentLoaded", () => {
                const msg = document.getElementById("msg");
                if (msg) {
                    setTimeout(() => {
                        msg.style.opacity = "0"; // mờ dần
                        setTimeout(() => {
                            msg.style.display = "none"; // ẩn hoàn toàn sau khi mờ
                        }, 500); // delay đúng bằng transition ở CSS (0.5s)
                    }, 3000); // 3 giây trước khi bắt đầu mờ
                }
            });
        </script>
    </body>
</html>
