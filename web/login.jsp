
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>

        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background-color: #f9f8ff;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }

            .login-container {
                background-color: white;
                padding: 40px;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                width: 350px;
            }

            h2 {
                text-align: center;
                color: #3f51b5;
            }

            form {
                display: flex;
                flex-direction: column;
            }

            input[type="text"],
            input[type="password"] {
                padding: 10px;
                margin: 8px 0;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            input[type="submit"] {
                padding: 10px;
                margin-top: 15px;
                background-color: #3f51b5;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
            }

            input[type="submit"]:hover {
                background-color: #303f9f;
            }

            .error-msg {
                color: red;
                text-align: center;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <h2>Login</h2>

            <% if (request.getAttribute("MSG") != null) { %>
                <p class="error-msg"><%= request.getAttribute("MSG") %></p>
            <% } %>

            <form action="MainController" method="post">
                <label>User ID:</label>
                <input type="text" name="userID" required>

                <label>Password:</label>
                <input type="password" name="password" required>

                <input type="submit" name="action" value="Login">
            </form>
        </div>
    </body>
</html>
