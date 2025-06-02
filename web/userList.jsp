<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User List</title>
        
        <style>
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

            form {
                margin: 0;
            }

            #createForm {
                background-color: white;
                padding: 15px;
                box-shadow: 0 0 10px #ccc;
                margin-bottom: 20px;
            }

            #createForm h3 {
                margin-top: 0;
            }
            #showCreateForm {
                background-color: #4CAF50;
                color: white;
                padding: 6px 12px;
                border: none;
                cursor: pointer;
                border-radius: 4px;
            }
            #showCreateForm:hover {
                background-color: #45a049;
            }

            .msg {
                margin-top: 15px;
                padding: 10px;
                background-color: #e0ffe0;
                border: 1px solid #5cb85c;
                color: #3c763d;
                border-radius: 4px;
                width: fit-content;
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
        %>
        <div class="containner">
            <div class="sidebar">
                <h2>Menu</h2>
                <a class="active" href="MainController?action=SearchUser">User List</a>
                <a href="MainController?action=SearchTransaction">Transaction List</a>
                <a href="MainController?action=SearchStock">Stock List</a>
                <a href="MainController?action=SearchAlert">Alert List</a>
            </div>

            <div class="main-content">
                <div class="header">
                    <h1>Welcome, <c:out value="${sessionScope.LOGIN_USER.fullName}"/></h1>
                    <a href="${pageContext.request.contextPath}/LogoutController">Logout</a>
                </div>

                <button id="showCreateForm" type="button" onclick="toggleCreateForm()">Create</button>
                <!--create form-->
                <div id="createForm" style="display: none;">
                    <h3>Create New User</h3>
                    <form action="MainController" method="POST">
                        <input type="hidden" name="action" value="CreateUser"/>
                        User ID: <input type="text" name="userID" required/> <br>
                        Full Name: <input type="text" name="fullName" required/> <br>
                        Role ID: 
                        <select name="roleID" required>
                            <option value="AD">Admin</option>
                            <option value="NV">Nhân viên</option>
                        </select> <br>
                        Password: <input type="password" name="password" required/> <br>
                        <button type="submit">Create</button>
                    </form>
                </div>

                <!-- search form -->
                <form action="MainController">
                    Search<input type="text" name="search" value="<%= search%>"/>
                    <button type="submit" name="action" value="SearchUser">Search User</button>
                </form>

                <c:if test="${empty listUser}">
                    <p>No matching stocks found!</p>
                </c:if>

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
                                        <button type="submit" name="action" value="DeleteUser">Delete</button>
                                    </td>
                                </form>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${not empty MSG}">
                    <p class="msg">${MSG}</p>
                </c:if>
            </div>
        </div>
            
        <script>
            function toggleCreateForm() {
                const formDiv = document.getElementById("createForm");
                const btn = document.getElementById("showCreateForm");
                if (formDiv.style.display === "none") {
                    formDiv.style.display = "block";
                    btn.innerHTML = "Close";
                } else {
                    formDiv.style.display = "none";
                    btn.innerHTML = "Create";
                }
            }
        </script>
    </body>
</html>