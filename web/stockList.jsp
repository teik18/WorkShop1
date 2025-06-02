<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Stock List</title>

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
        
        <div class="container">

            <div class="sidebar">
                <h2>Menu</h2>
                <a href="MainController?action=SearchUser">User List</a>
                <a href="MainController?action=SearchTransaction">Transaction List</a>
                <a class="active" href="MainController?action=SearchStock">Stock List</a>
                <a href="MainController?action=SearchAlert">Alert List</a>
            </div>

            <div class="main-content">
                <div class="header">
                    <h1>Welcome, <c:out value="${sessionScope.LOGIN_USER.fullName}"/></h1>
                    <a href="${pageContext.request.contextPath}/LogoutController">Logout</a>
                </div>
                
                <!-- Price‐range search -->
                <form action="${pageContext.request.contextPath}/SearchPriceController" method="POST">
                    Price between
                    <input type="number" step="0.01" name="minPrice" placeholder="min"
                        value="${param.minPrice}" required/>
                    and
                    <input type="number" step="0.01" name="maxPrice" placeholder="max"
                        value="${param.maxPrice}" required/>
                    <button type="submit">Search Price</button>
                </form>
                    
                <form style="margin-top:8px;" action="MainController">
                    Search<input type="text" name="search" value="<%= search%>"/>
                    <button type="submit" name="action" value="SearchStock">Search Stock</button>
                </form>

                <!-- Sort links -->
                <p style="margin-top:8px;">
                    Sort by price:
                    <a href="${pageContext.request.contextPath}/MainController?sort=asc">Ascending</a> |
                    <a href="${pageContext.request.contextPath}/MainController?sort=desc">Descending</a> |
                    <a href="${pageContext.request.contextPath}/MainController">None</a>
                </p>

                <c:if test="${empty listStock}">
                    <p>No matching stocks found!</p>
                </c:if>

                <table>
                    <thead>
                        <tr>
                            <th>No</th><th>Ticker</th><th>Name</th><th>Sector</th><th>Price</th><th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="stock" items="${listStock}" varStatus="st">
                            <tr>
                                <form action="${pageContext.request.contextPath}/ActionController" method="POST">
                                    <td>${st.count}</td>
                                    <td>
                                        <input type="hidden" name="ticker" value="${stock.ticker}"/>
                                        ${stock.ticker}
                                    </td>
                                    <td><input type="text"  name="name"   value="${stock.name}"   required/></td>
                                    <td><input type="text"  name="sector" value="${stock.sector}" required/></td>
                                    <td><input type="number"step="0.01" name="price"  value="${stock.price}" required/></td>
                                    <td class="actions">
                                        <button type="submit" name="action" value="update">Update</button>
                                        <button type="submit" name="action" value="delete">Delete</button>
                                    </td>
                                </form>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
