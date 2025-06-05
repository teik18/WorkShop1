<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="dto.User"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Stock List</title>
        <link rel="stylesheet" type="text/css" href="css/pageStyle.css">
    </head>
    <body>
        <%
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
    
            String search = request.getParameter("search");
            if (search == null) {
                search = "";
            }
        %>
        
        <div class="container">

            <div class="sidebar">
                <h2>Menu</h2>
                <a class="active" href="MainController?action=SearchStock">Stock List</a>
                <a href="MainController?action=SearchTransaction">Transaction List</a>
                <a href="MainController?action=ViewAlerts">Alert List</a>
                <% if ("AD".equals(loginUser.getRoleID())) { %>
                <a href="MainController?action=SearchUser">User List</a>
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
                        <!-- Price-range search -->
                        <form action="${pageContext.request.contextPath}/SearchPriceController" method="POST">
                            Price between
                            <input type="number" step="0.01" name="minPrice" placeholder="min" value="${param.minPrice}" required/>
                            and
                            <input type="number" step="0.01" name="maxPrice" placeholder="max" value="${param.maxPrice}" required/>
                            <button type="submit" class="searchBtn">Search Price</button>
                        </form>

                        <!-- Search form -->
                        <form style="margin-top:8px;" action="MainController" method="POST">
                            Search <input type="text" name="search" value="<%= search%>" placeholder="Search"/>
                            <button type="submit" class="searchBtn" name="action" value="SearchStock">Search Stock</button>
                        </form>

                        <!-- Sort links -->
                        <p style="margin-top:8px;">
                            Sort by price:
                            <a href="${pageContext.request.contextPath}/MainController?sort=asc">Ascending</a> |
                            <a href="${pageContext.request.contextPath}/MainController?sort=desc">Descending</a> |
                            <a href="${pageContext.request.contextPath}/MainController">None</a>
                        </p>

                        <!-- Create form -->
                        <button id="showCreateForm" class="button-green" onclick="toggleCreateForm()">Create</button>
                        <div id="createForm" style="display: none;">
                            <h3>Create New Stock</h3> <hr>
                            <form action="MainController" method="POST">
                                <input type="hidden" name="action" value="CreateStock"/>
                                <div class="form-group">
                                    <label for="ticker">Ticker:</label>
                                    <input type="text" id="ticker" name="ticker" required/>
                                </div>
                                <div class="form-group">
                                    <label for="name">Name:</label>
                                    <input type="text" id="name" name="name" required/>
                                </div>
                                <div class="form-group">
                                    <label for="sector">Sector:</label>
                                    <input type="text" id="sector" name="sector" required/>
                                </div>
                                <div class="form-group">
                                    <label for="price">Price:</label>
                                    <input type="number" step="0.01" id="price" name="price" required/>
                                </div>
                                <div class="form-group">
                                    <label for="status">Status:</label>
                                    <select id="status" name="status" required>
                                        <option value="active">Active</option>
                                        <option value="inactive">Inactive</option>
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
                        <h3 id="msg" class="msg success" style="color: #3c763d; background-color: #e0ffe0;"> <%= MSG%> </h3>
                        <% } else if (MSG != null) { %>
                        <h3 id="msg" class="msg error" style="color: #a94442; background-color: #f2dede;"> <%= MSG%> </h3>
                        <% } %>
                    </div>
                </div>
                    
                <c:if test="${empty listStock}">
                    <p style="margin:10px 0 0;" >No matching stocks found!</p>
                </c:if>

                <table style="margin-top:10px;">
                    <thead>
                        <tr>
                            <th>No</th><th>Ticker</th><th>Name</th><th>Sector</th><th>Price</th>
                            <% if ("AD".equals(loginUser.getRoleID())) { %>
                            <th>Action</th>
                            <% } %>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="stock" items="${listStock}" varStatus="st">
                            <tr>
                                <form action="MainController" method="POST">
                                    <td>${st.count}</td>
                                    <td>
                                        <input type="hidden" name="ticker" value="${stock.ticker}"/>
                                        ${stock.ticker}
                                    </td>
<<<<<<< HEAD
                                    <td>
                                        <input type="hidden"  name="name"   value="${stock.name}"/> 
                                        ${stock.name}</td>
                                    <td>
                                        <input type="hidden"  name="sector" value="${stock.sector}"/>
                                        ${stock.sector}</td>
                                    <td>
                                        <input type="hidden" name="price"  value="${stock.price}"/>
                                        ${stock.price}
=======
                                    <td><input type="text"  name="name"   value="${stock.name}"   required/></td>
                                    <td><input type="text"  name="sector" value="${stock.sector}" required/></td>
                                    <td><input type="number"step="0.01" name="price"  value="${stock.price}" required/></td>
                                    <td>
                                        <div class="function-buttons">
                                            <button type="submit" name="action" value="update">Update</button><!-- Error --> 
                                            <button type="submit" class="butDelete" name="action" value="delete">Delete</button><!-- Error --> 
                                        </div>
>>>>>>> origin/anh-feature
                                    </td>
                                    <% if ("AD".equals(loginUser.getRoleID())) { %>
                                    <td class="actions">
                                        <button type="submit" name="action" value="UpdateStock">Update</button>
                                        <button class="butDelete" onclick="return confirm('Are you sure to delete this stock?')" type="submit" name="action" value="DeleteStock">Delete</button>
                                    </td>
                                    <% } %>
                                </form>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
<<<<<<< HEAD
                
=======
                    
>>>>>>> origin/anh-feature
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
<<<<<<< HEAD
                        msg.style.opacity = "0"; // mờ dần
                        setTimeout(() => {
                            msg.style.display = "none"; // ẩn hoàn toàn sau khi mờ
                        }, 500); // delay đúng bằng transition ở CSS (0.5s)
                    }, 3000); // 3 giây trước khi bắt đầu mờ
=======
                        msg.style.opacity = "0";
                        setTimeout(() => {
                            msg.style.display = "none";
                        }, 500);
                    }, 3000);
>>>>>>> origin/anh-feature
                }
            });
        </script>
    </body>
</html>
