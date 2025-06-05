/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.UserDAO;
import dto.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name="UpdateUserController", urlPatterns={"/UpdateUserController"})
public class UpdateUserController extends HttpServlet {

    private UserDAO dao = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (request.getSession().getAttribute("LOGIN_USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.setCharacterEncoding("UTF-8");
        String search = request.getParameter("search");
        try {
            String userID = request.getParameter("userID");
            String fullName = request.getParameter("fullName");
            String roleID = request.getParameter("roleID");
            String password = request.getParameter("password");
            
            User user = new User(userID, fullName, roleID, password);
            boolean updated = dao.update(user);
            
            if(updated) {
                request.setAttribute("MSG", "Updated successfully!");
            } else {
                request.setAttribute("MSG", "Updated failed!");
            }
            request.setAttribute("search", search);
            request.getRequestDispatcher("SearchUserController").forward(request, response);
        } catch (Exception e) {
            log("Update error", e);
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật!");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }



}
