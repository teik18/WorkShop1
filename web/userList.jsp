<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="dto.User"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User List</title>
        <link rel="stylesheet" type="text/css" href="css/pageStyle.css">        
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
        <div class="container">
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

                        <c:if test="${empty listUser}">
                            <p style="margin: 10px 0 0;">No matching users found!</p>
                        </c:if>
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
                                    <td>${user.fullName}</td>
                                    <td>${user.roleID}</td>
                                    <td>${user.password}</td>
                                    <td class="actions">
                                        <button type="submit" name="action" value="UpdateUser">Update</button>
                                        <button class="butDelete" type="submit" name="action" value="DeleteUser" onclick="return confirm('Are you sure to delete this user?')">Delete</button>
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