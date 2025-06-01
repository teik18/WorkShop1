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
import java.util.List;

/**
 *
 * @author Admin
 */
@WebServlet(name="CreateUserController", urlPatterns={"/CreateUserController"})
public class CreateUserController extends HttpServlet {
    
    private UserDAO dao = new UserDAO();
   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String userID = request.getParameter("userID");
        String fullName = request.getParameter("fullName");
        String roleID = request.getParameter("roleID");
        String password = request.getParameter("password");
        
        User user = new User(userID, fullName, roleID, password);
        try {
            dao.create(user); // thêm phương thức create vào UserDAO
            request.setAttribute("MSG", "User Created Successfully!");
        } catch (Exception e) {
            request.setAttribute("MSG", "User Created Failed!");
        }

        // Load lại danh sách
        request.getRequestDispatcher("SearchUserController").forward(request, response);
    }
}
