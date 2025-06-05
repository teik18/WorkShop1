/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.TransactionDAO;
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
@WebServlet(name="DeleteTransactionController", urlPatterns={"/DeleteTransactionController"})
public class DeleteTransactionController extends HttpServlet {
    private TransactionDAO dao = new TransactionDAO();
   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int transactionId = Integer.parseInt(request.getParameter("transactionId"));
        try {
            dao.delete(transactionId);
            request.setAttribute("MSG", "User deleted successfully!");
        } catch(Exception e) {
            request.setAttribute("MSG", "User deleted failed!");
            e.printStackTrace();
        }
        request.getRequestDispatcher("SearchTransactionController").forward(request, response);
    }


    
}
