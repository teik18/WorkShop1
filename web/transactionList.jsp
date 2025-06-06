<%@page import="java.util.ArrayList"%>
<%@page import="dto.Transaction"%>
<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Transaction List Page</title>
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
                <a class="active" href="MainController?action=SearchTransaction">Transaction List</a>
                <a href="MainController?action=ViewAlerts">Alert List</a>
                <% if ("AD".equals(loginUser.getRoleID())) { %>
                <a href="MainController?action=SearchUser">User List</a>
                <% } %>
            </div>

            <div class="main-content">
                <div class="header">
                    <h1>Welcome, <%= loginUser.getFullName()%></h1>
                    <a href="${pageContext.request.contextPath}/LogoutController">Logout</a>
                </div>
                
                <hr>

                <div class="function-header">
                    <div class="function">
                        <!-- Search form -->
                        <form action="MainController" method="POST">
                            Search <input type="text" name="search" placeholder="Search" value="<%= search%>"/>
                            <button type="submit" class="searchBtn" name="action" value="SearchTransaction">Search</button>
                        </form>

                        <!-- Create form -->
                        <button id="showCreateForm" class="button-green" onclick="toggleCreateForm()">Create</button>
                        <div id="createForm" style="display: none;">
                            <h3>Create New Transaction</h3> <hr>
                            <form action="MainController" method="POST">
                                <input type="hidden" name="action" value="CreateTransaction"/>
                                <div class="form-group">
                                    <label for="ticker">Ticker:</label>
                                    <input type="text" id="ticker" name="ticker" required/>
                                </div>
                                <div class="form-group">
                                    <label for="type">Type:</label>
                                    <select id="type" name="type" required>
                                        <option value="buy">Buy</option>
                                        <option value="sell">Sell</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="quantity">Quantity:</label>
                                    <input type="number" id="quantity" name="quantity" min="1" required/>
                                </div>
                                <div class="form-group">
                                    <label for="price">Price:</label>
                                    <input type="number" step="0.01" id="price" name="price" min="0.01" required/>
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
                    
                <c:if test="${empty list}">
                    <p style="margin:10px 0;" >No matching transactions found!</p>
                </c:if>

                <%
                    ArrayList<Transaction> list = (ArrayList<Transaction>) request.getAttribute("list");
                    if (list != null) {
                %>
                <table>
                    <tr>
                        <th>No</th>
                        <th>User ID</th>
                        <th>Ticker</th>
                        <th>Type</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Function</th>   
                    </tr>
                    <%
                        int count = 0;
                        for (Transaction transaction : list) {
                            count++;
                    %>
                    <tr>
                        <td><%= count%></td>
                        <td><%= transaction.getUserID()%></td>
                        <td><%= transaction.getTicker()%></td>
                        <td><%= transaction.getType()%></td>
                        <td><%= transaction.getQuantity()%></td>
                        <td><%= transaction.getPrice()%></td>
                        <td><%= transaction.getStatus()%></td>
                        <td>
                            <!--neu la admin thi update status-->
                            <% if (loginUser != null && "AD".equals(loginUser.getRoleID())) {%>
                            <form action="MainController" method="POST">
                                <input type="hidden" name="transactionId" value="<%= transaction.getId()%>" />
                                <input type="hidden" name="status" value="executed" />
                                <% if ("pending".equals(transaction.getStatus())) {%>
                                <button type="submit" name="action" value="UpdateTransaction">Update</button>
                                <% } %>
                                <button class="butDelete" type="submit" name="action" value="DeleteTransaction" onclick="return confirm('Are you sure to delete this transaction?')">Delete</button>
                            </form>
                            <% } else if ("pending".equals(transaction.getStatus()) && loginUser != null && "NV".equals(loginUser.getRoleID())) {%>
                            <form action="MainController" method="POST">
                                <input type="hidden" name="transactionId" value="<%= transaction.getId()%>" />
                                <button type="submit" name="action" value="UpdateTransactionByNV">Update</button>
                                <button class="butDelete" type="submit" name="action" value="DeleteTransaction" onclick="return confirm('Are you sure to delete this transaction?')">Delete</button>
                            </form>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </table>
                <% } %>
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
                        msg.style.opacity = "0";
                        setTimeout(() => {
                            msg.style.display = "none";
                        }, 500);
                    }, 3000);
                }
            });
        </script>
    </body>
</html>