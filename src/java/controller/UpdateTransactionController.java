/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.TransactionDAO;
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
@WebServlet(name="UpdateTransactionController", urlPatterns={"/UpdateTransactionController"})
public class UpdateTransactionController extends HttpServlet {
   

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            User loginUser = (User) request.getSession().getAttribute("LOGIN_USER");
            if (loginUser == null || !"AD".equals(loginUser.getRoleID())) {
                request.setAttribute("MSG", "Only admin can update transaction status.");
                request.getRequestDispatcher("SearchTransactionController").forward(request, response);
                return;
            }

            int transactionId = Integer.parseInt(request.getParameter("transactionId"));
            String status = request.getParameter("status");

            TransactionDAO dao = new TransactionDAO();
            if (dao.update(transactionId, status)) {
                request.setAttribute("MSG", "Transaction status updated successfully.");
            } else {
                request.setAttribute("MSG", "Failed to update transaction status.");
            }
            request.getRequestDispatcher("SearchTransactionController").forward(request, response);
        } catch (Exception e) {
            log(e.getMessage());
        }
    }



}
