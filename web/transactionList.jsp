<%-- 
    Document   : transactionList
    Created on : May 31, 2025, 3:35:13 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dto.Transaction"%>
<%@page import="dto.User"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="MainController">
            Search: <input type="text" name="search">
            <input type="submit" name="action" value="searchTransaction">
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
                
                </td>
            </form>
        </tr>
        <% }
        %>
    </table>
    <%
        }
    %>
</body>
</html>
