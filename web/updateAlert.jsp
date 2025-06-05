<%-- 
    Document   : updateAlert
    Created on : Jun 2, 2025, 4:46:23 PM
    Author     : ACER
--%>

<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="dto.Alert"%>
<!DOCTYPE html>
<html>
    <head>
        <title>UPDATE ALERT</title>
        <link rel="stylesheet" type="text/css" href="css/updatePage.css">
    </head>
    <body>
        <%
            Alert alert = (Alert) request.getAttribute("ALERT");
            if (alert == null) {
                response.sendRedirect("alertList.jsp");
                return;
            }
        %>
        <%
                User loginUser = (User) session.getAttribute("LOGIN_USER");
                if (loginUser == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
        %>
        <div class="form-container">
            <h2>Update Alert</h2>
            <form action="MainController" method="POST">
                <label>ID </label>
                <input type="text" name="alertID" value="<%= alert.getAlertID() %>" readonly><br>

                <label>Ticker </label>
                <input type="text" name="ticker" value="<%= alert.getTicker() %>" readonly><br>

                <label>Threshold </label>
                <input type="number" name="threshold" value="<%= alert.getThreshold() %>" step="0.01" required><br>

                <label>Direction </label>
                <select name="direction">
                    <option value="increase" <%= "increase".equals(alert.getDirection()) ? "selected" : "" %>>Increase</option>
                    <option value="decrease" <%= "decrease".equals(alert.getDirection()) ? "selected" : "" %>>Decrease</option>
                </select><br>

                <label>Status </label>
                <select name="status">
                    <option value="inactive" <%= "inactive".equals(alert.getStatus()) ? "selected" : "" %>>Inactive</option>
                    <option value="active" <%= "active".equals(alert.getStatus()) ? "selected" : "" %>>Active</option>
                    <option value="pending" <%= "pending".equals(alert.getStatus()) ? "selected" : "" %>>Pending</option>
                </select><br>
                <button type="submit" name="action" value="UpdateAlert">Edit</button>
                <a href="MainController?action=ViewAlerts">Back to Alert List</a>
            </form>
        </div>
    </body>
</html>
