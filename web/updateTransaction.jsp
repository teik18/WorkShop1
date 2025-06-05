<%-- 
    Document   : updateTransaction
    Created on : Jun 2, 2025, 9:48:03 PM
    Author     : ACER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Transaction"%>
<%@page import="dao.TransactionDAO"%>
<%@page import="dto.User"%>

<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idStr = request.getParameter("transactionId");
    if (idStr == null) {
        out.println("Invalid transaction ID.");
        return;
    }

    int id = Integer.parseInt(idStr);
    TransactionDAO dao = new TransactionDAO();
    Transaction transaction = dao.getTransactionById(id);

    if (transaction == null || !"pending".equals(transaction.getStatus()) || !loginUser.getUserID().equals(transaction.getUserID())) {
        out.println("You are not allowed to update this transaction.");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Transaction Page</title>
        <link rel="stylesheet" type="text/css" href="css/updatePage.css">
        
    </head>
    <body>
        <div class="form-container">
            <h2>Update Transaction</h2>
            <form action="MainController" method="POST">
                <input type="hidden" name="transactionId" value="<%= transaction.getId() %>"/>

                <label>Ticker: </label>
                <input type="text" value="<%= transaction.getTicker() %>" disabled /><br/>

                <label>Type: </label>
                <input type="text" value="<%= transaction.getType() %>" disabled /><br/>

                <label>Quantity: </label>
                <input type="number" name="quantity" value="<%= transaction.getQuantity() %>" required min="1"/><br/>

                <label>Price: </label>
                <input type="number" name="price" step="0.01" value="<%= transaction.getPrice() %>" required min="0.01"/><br/>

                <button type="submit" name="action" value="UpdateTransaction">Edit</button>
            </form>
        </div>
    </body>
</html>

