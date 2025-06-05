<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.UserDAO"%>
<%@page import="dto.User"%>

<%
    User loginUser = (User) session.getAttribute("LOGIN_USER");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userId = request.getParameter("userID");
    if (userId == null) {
        out.println("Invalid user ID.");
        return;
    }

    UserDAO dao = new UserDAO();
    User user = dao.getUserById(userId);

    if (user == null) {
        out.println("User doesn't exist.");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update User Page</title>
        <link rel="stylesheet" type="text/css" href="css/updatePage.css">
    </head>
    <body>
        <div class="form-container">
            <h2>Update User</h2>
            <form action="UpdateUserController" method="POST">
                <input type="hidden" name="userId" value="<%= user.getUserID() %>" />
                
                <label>User ID </label>
                <input type="text" value="<%= user.getUserID() %>" disabled /><br/>

                <label>Full Name </label>
                <input type="text" name="fullName" value="<%= user.getFullName() %>" required /> <br>

                <label>Role ID </label>
                <select name="roleID" required>
                    <option value="AD" <%= user.getRoleID().equals("AD") ? "selected" : "" %>>Admin</option>
                    <option value="NV" <%= user.getRoleID().equals("NV") ? "selected" : "" %>>Nhân viên</option>
                </select> <br/>

                <label>Password</label>
                <input type="text" name="password"  value="<%= user.getPassword() %>" required/><br/>
                <button type="submit">Edit</button>
                <a href="MainController?action=SearchUser">Back to User List</a>
            </form>
        </div>
    </body>
</html>
