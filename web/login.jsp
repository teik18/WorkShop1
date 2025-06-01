
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
    </head>
    <body>
        <h2>Đăng nhập hệ thống</h2>
    
        <% if (request.getAttribute("MSG") != null) { %>
            <p style="color: red;"><%= request.getAttribute("MSG") %></p>
        <% } %>

        <form action="MainController" method="post">
            User ID: <input type="text" name="userID" required><br>
            Password: <input type="password" name="password" required><br>
            <input type="submit" name="action" value="Login">
        </form>
    </body>
</html>
