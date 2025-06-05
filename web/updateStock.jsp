<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.User"%>
<%@page import="dao.StockDAO"%>
<%@page import="dto.Stock"%>

<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String id = request.getParameter("ticker");
    if (id == null) {
        out.println("Invalid stock.");
        return;
    }
    
    StockDAO dao = new StockDAO();
    Stock stock = dao.getStockById(id);

    if (stock == null) {
        out.println("You are not allowed to update this stock.");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Stock Page</title>
        <link rel="stylesheet" type="text/css" href="css/updatePage.css">
    </head>
    <body>
        <div class="form-container">
            <h2>Update Stock</h2>
            <form action="UpdateStockController" method="POST">
                <label>Ticker</label>
                <input type="text" value="<%=stock.getTicker()%>" disabled />
                <input type="hidden" name="ticker" value="<%=stock.getTicker()%>" />
                
                <label>Name</label>
                <input type="text" name="name" value="<%=stock.getName()%>" required />

                <label>Sector</label>
                <input type="text" name="sector" value="<%=stock.getSector()%>" required />

                <label>Price</label>
                <input type="number" name="price" value="<%=stock.getPrice()%>" step="0.01" min="0" required />

                <button type="submit">Edit</button>
                <a href="MainController?action=SearchStock">Back to Stock List</a>
            </form>
        </div>
    </body>
</html>
