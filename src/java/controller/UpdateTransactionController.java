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
   
    private TransactionDAO dao = new TransactionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (request.getSession().getAttribute("LOGIN_USER") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User loginUser = (User) request.getSession().getAttribute("LOGIN_USER");
        if ("AD".equals(loginUser.getRoleID())) {
            try {
                int transactionId = Integer.parseInt(request.getParameter("transactionId"));
                String status = request.getParameter("status");
                
                if (dao.update(transactionId, status)) {
                    request.setAttribute("MSG", "Transaction status updated successfully.");
                } else {
                    request.setAttribute("MSG", "Failed to update transaction status.");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if("NV".equals(loginUser.getRoleID())) {
            try {
                int transactionId = Integer.parseInt(request.getParameter("transactionId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                double price = Double.parseDouble(request.getParameter("price"));
                
                if (dao.updateByNV(transactionId, quantity, price)) {
                    request.setAttribute("MSG", "Transaction status updated successfully.");
                } else {
                    request.setAttribute("MSG", "Failed to update transaction status.");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        request.getRequestDispatcher("SearchTransactionController").forward(request, response);
    }



}
