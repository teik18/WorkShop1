<%@page import="java.util.ArrayList"%>
<%@page import="dto.Transaction"%>
<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Transaction List Page</title>

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
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <div class="container">
            <div class="sidebar">
                <h2>Menu</h2>
                <a href="MainController?action=SearchUser">User List</a>
                <a class="active" href="MainController?action=SearchTransaction">Transaction List</a>
                <a href="MainController?action=SearchStock">Stock List</a>
                <a href="MainController?action=ViewAlerts">Alert List</a>
            </div>

            <div class="main-content">

                <div class="header">
                    <h1>Welcome: <%= loginUser.getFullName()%></h1>
                    <a href="${pageContext.request.contextPath}/LogoutController">Logout</a>
                </div>

                <button id="showCreateForm" type="button" onclick="toggleCreateForm()">Show Create Form</button>
                <!--create form-->
                <div id="createForm" style="display: none;">
                    <h3>Create New Transaction</h3>
                    <form action="MainController" method="POST">
                        <input type="hidden" name="action" value="CreateTransaction"/>
                        Ticker: <input type="text" name="ticker" placeholder="Enter ticker" required /><br/>
                        Type: 
                        <select name="type" required>
                            <option value="buy">Buy</option>
                            <option value="sell">Sell</option>
                        </select><br/>
                        Quantity: <input type="number" name="quantity" placeholder="Enter quantity" min="1" required /><br/>
                        Price: <input type="number" name="price" placeholder="Enter price" step="0.01" min="0.01" required /><br/>
                        <button type="submit">Create</button>
                    </form>
                </div>
                
                <!-- search form -->
                <form action="MainController" method="POST">
                    <input type="text" name="search" placeholder="Search">
                    <button type="submit" name="action" value="SearchTransaction">Search</button>
                </form>
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
                        <% if (loginUser != null && "AD".equals(loginUser.getRoleID())) { %>
                        <th>Function</th>   
                        <% } %>
                    </tr>
                    <%
                        int count = 0;
                        for (Transaction transaction : list) {
                            count++;
                    %>
                    <tr>
                        <form action="MainController" method="POST">
                            <td><%= count%></td>
                            <td><%= transaction.getUserID()%></td>
                            <td><%= transaction.getTicker()%></td>
                            <td><%= transaction.getType()%></td>
                            <td><%= transaction.getQuantity()%></td>
                            <td><%= transaction.getPrice()%></td>
                            <td><%= transaction.getStatus()%></td>
                            <input type="hidden" name="id" value="<%= transaction.getId()%>">
                            <td>
                                <% if ("pending".equals(transaction.getStatus()) && loginUser != null && "AD".equals(loginUser.getRoleID())) {%>
                                <form action="MainController" method="POST">
                                    <input type="hidden" name="transactionId" value="<%= transaction.getId()%>" />
                                    <input type="hidden" name="status" value="executed" />
                                    <button type="submit" name="action" value="UpdateTransaction">Update</button>
                                </form>
                                <% } %>
                            </td>
                        </form>
                    </tr>
                <% } %>
                </table>
                <% } %>

                <%
                    String MSG = (String) request.getAttribute("MSG");
                    if (MSG != null) {
                %>
                    <h3 class="msg"> <%= MSG%> </h3>
                <% } %>
            </div>
        </div>

        <script>
            function toggleCreateForm() {
                const formDiv = document.getElementById("createForm");
                const btn = document.getElementById("showCreateForm");
                if (formDiv.style.display === "none") {
                    formDiv.style.display = "block";
                    btn.innerHTML = "Close Create Form";
                } else {
                    formDiv.style.display = "none";
                    btn.innerHTML = "Show Create Form";
                }
            }
        </script>
    </body>
</html>