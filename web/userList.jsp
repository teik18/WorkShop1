<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="dto.User"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User List</title>

        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background-color: #f9f8ff;
            }

            .containner {
                display: flex;
                height: 100vh;
            }

            .sidebar {
                width: 260px;
                background-color: #3f51b5;
                color: white;
                padding: 20px;
            }

            .sidebar h2 {
                font-size: 28px;
                margin: 20px 0;
            }

            .sidebar a {
                display: block;
                color: white;
                text-decoration: none;
                margin-bottom: 20px;
                font-weight: bold;
            }

            .sidebar a:hover {
                background-color: #303f9f;
                padding: 5px;
                border-radius: 4px;
            }

            .main-content {
                flex: 1;
                padding: 30px;
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
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

            .function-header {
                display: flex;
                justify-content: space-between;
                margin-top: 10px;
            }

            .function-header .msg {
                margin-top: 8px;
            }
            
            .inputSearch {
                margin: 5px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                border: 1px solid #ddd;
                padding: 8px;
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

            .actions {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 10px;
                position: relative;
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

            .button-green {
                background-color: #28a745; /* Màu xanh lá */
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 4px;
                cursor: pointer;
            }

            .button-red {
                background-color: #dc3545; /* Màu đỏ */
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 4px;
                cursor: pointer;
            }

            .button-green:hover {
                background-color: #218838;
            }

            .button-red:hover {
                background-color: #c82333;
            }

            .butDelete {
                background-color: #f44336; /* Delete button */
            }
            
            #showCreateForm {
                margin-bottom: 20px;
            }

            form {
                margin: 0;
            }

            #createForm {
                background-color: white;
                padding: 15px;
                box-shadow: 0 0 10px #ccc;
                margin-bottom: 20px;
                width: 460px;
            }

            #createForm form {
                display: flex;
                flex-direction: column;
                gap: 10px; /* Khoảng cách giữa các dòng */
                margin-top: 15px;
            }

            #createForm label {
                display: inline-block;
                width: 100px;
                margin-right: 10px;
                font-weight: bold;
            }

            #createForm .form-group {
                display: flex;
                align-items: center;
            }

            #createForm h3 {
                margin-top: 0;
            }
            input, select {
                padding: 3px;
            }

            .searchBtn  {
                padding: 8px 16px;
            }

            .msg {
                padding: 10px;
                border: 1px solid #5cb85c;
                border-radius: 4px;
                width: fit-content;
            }
            .msg.success {
                border: 2px solid #5cb85c;
            }
            .msg.error {
                border: 2px solid #ebccd1;
            }
            #msg {
                transition: opacity 0.5s ease-out;
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
            String search = request.getParameter("search");
            if (search == null) {
                search = "";
            }
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        <div class="containner">
            <div class="sidebar">
                <h2>Menu</h2>
                <a href="MainController?action=SearchStock">Stock List</a>
                <a href="MainController?action=SearchTransaction">Transaction List</a>
                <a href="MainController?action=ViewAlerts">Alert List</a>
                <% if ("AD".equals(loginUser.getRoleID())) { %>
                <a class="active" href="MainController?action=SearchUser">User List</a>
                <% } %>
            </div>

            <div class="main-content">
                <div class="header">
                    <h1>Welcome, <c:out value="${sessionScope.LOGIN_USER.fullName}"/></h1>
                    <a href="${pageContext.request.contextPath}/LogoutController">Logout</a>
                </div>
                
                <hr>

                <div class="function-header">
                    <div class="function">

                        <!-- search form -->
                        <form action="MainController">
                            Search<input type="text" class="inputSearch" name="search" value="<%= search%>" placeholder="Search"/>
                            <button type="submit" class="searchBtn" name="action" value="SearchUser">Search</button>
                        </form>
                            
                        <button id="showCreateForm" class="button-green" onclick="toggleCreateForm()">Create</button>
                        <!--create form-->
                        <div id="createForm" style="display: none;">
                            <h3>Create New User</h3> <hr>
                            <form action="MainController" method="POST">
                                <input type="hidden" name="action" value="CreateUser"/>
                                <div class="form-group">
                                    <label for="userID">User ID:</label>
                                    <input type="text" id="userID" name="userID" required>
                                </div>

                                <div class="form-group">
                                    <label for="fullName">Full Name:</label>
                                    <input type="text" id="fullName" name="fullName" required>
                                </div>

                                <div class="form-group">
                                    <label for="roleID">Role ID:</label>
                                    <select id="roleID" name="roleID" required>
                                        <option value="AD">Admin</option>
                                        <option value="NV">Staff</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="password">Password:</label>
                                    <input type="password" id="password" name="password" required>
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

                <table>
                    <thead>
                        <tr>
                            <th>No</th><th>User ID</th><th>Full Name</th><th>Role ID</th><th>Password</th><th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${listUser}" varStatus="st">
                            <tr>
                        <form action="MainController" method="POST">
                            <input type="hidden" name="search" value="<%= search%>"/>
                            <td>${st.count}</td>
                            <td>
                                <input type="hidden" name="userID" value="${user.userID}"/>
                                ${user.userID}
                            </td>
                            <td><input type="text"  name="fullName"   value="${user.fullName}"   required/></td>
                            <td><input type="text"  name="roleID" value="${user.roleID}" required/></td>
                            <td><input type="text"  name="password"  value="${user.password}" required/></td>
                            <td class="actions">
                                <button type="submit" name="action" value="UpdateUser">Update</button>
                                <button type="submit" class="butDelete" name="action" value="DeleteUser">Delete</button>
                            </td>
                        </form>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>




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