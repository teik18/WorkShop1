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
                
                <!-- Price‐range search -->
                <form style="margin-top:8px;" action="${pageContext.request.contextPath}/SearchStockController" method="POST">
                    Price between
                    <input type="number" step="0.01" name="minPrice" placeholder="min" value="${param.minPrice}" required />
                    and
                    <input type="number" step="0.01" name="maxPrice" placeholder="max" value="${param.maxPrice}" required />
                    <button type="submit">Search</button>
                </form>
                    
                <!-- Keyword search form -->
                <form style="margin-top:8px;" action="MainController" method="GET">
                    Search:
                    <input type="text" name="search" placeholder="Search" value="<%= search %>" />
                    <button type="submit" name="action" value="SearchStock">Search</button>
                </form>

                <!-- Sort links -->
                <p style="margin-top:8px;">
                    Sort by price:
                    <a href="MainController?action=SearchStock&sort=asc">Ascending</a> |
                    <a href="MainController?action=SearchStock&sort=desc">Descending</a> |
                    <a href="MainController?action=SearchStock">None</a>
                </p>
                
                <% if ("AD".equals(loginUser.getRoleID())) { %>
                <button class="button-green" type="button" onclick="toggleCreateForm()">Create</button> 
                <% } %>

                <div id="createForm" style="display: none;">
                    <h3>Create New Stock</h3> <hr>
                    <form action="MainController" method="POST">
                        <div class="form-group">
                            <label>Ticker:</label>
                            <input type="text" name="ticker" placeholder="Ticker" required/>
                        </div>
                        <div class="form-group">
                            <label>Name:</label>
                            <input type="text" name="name" placeholder="Stock Name" required/>
                        </div>
                        <div class="form-group">
                            <label>Sector:</label>
                            <input type="text" name="sector" placeholder="Sector" required/>
                        </div>
                        <div class="form-group">
                            <label>Price:</label>
                            <input type="number" step="0.01" name="price" placeholder="Price" required/>
                        </div>
                        <button type="submit" name="action" value="CreateStock">Create</button>
                    </form>
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
                                    <td>
                                        <input type="hidden"  name="name"   value="${stock.name}"/> 
                                        ${stock.name}</td>
                                    <td>
                                        <input type="hidden"  name="sector" value="${stock.sector}"/>
                                        ${stock.sector}</td>
                                    <td>
                                        <input type="hidden" name="price"  value="${stock.price}"/>
                                        ${stock.price}
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
