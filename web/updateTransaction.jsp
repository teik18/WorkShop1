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

        <style>
            * {
                box-sizing: border-box;
            }

            body {
                background-color: #f7f9ff;
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }
            .form-container {
                background-color: white;
                padding: 30px 40px;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                width: 400px;
            }
            .form-container h2 {
                text-align: center;
                color: #333;
                margin-bottom: 20px;
            }
            label {
                font-weight: bold;
            }
            input[type="text"], input[type="number"] {
                width: 100%;
                padding: 10px;
                margin: 8px 0 16px;
                border: 1px solid #ccc;
                border-radius: 6px;
            }
            button {
                width: 100%;
                padding: 12px;
                background-color: #3b5bdb;
                color: white;
                font-weight: bold;
                border: none;
                border-radius: 6px;
                cursor: pointer;
            }
            button:hover {
                background-color: #2f4cc0;
            }
        </style>

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

