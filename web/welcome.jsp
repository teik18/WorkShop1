<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dto.User" %>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Welcome</title>
    </head>
    <body>
        <%
            User user = (User) session.getAttribute("LOGIN_USER");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        
        
        <h2>Chào mừng <%= user.getFullName() %>!</h2>

        <% if ("AD".equals(user.getRoleID())) { %>
            <a href="MainController?action=ViewUsers">Quản lý người dùng</a><br>
        <% } %>

        <a href="MainController?action=ViewStocks">Xem cổ phiếu</a><br>
        <a href="MainController?action=ViewTransactions">Xem giao dịch</a><br>
        <a href="MainController?action=ViewAlerts">Xem cảnh báo</a><br>
        <a href="MainController?action=Logout">Đăng xuất</a>
    </body>
</html>
