/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.TransactionDAO;
import dto.Transaction;
import dto.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
@WebServlet(name="SearchTransactionController", urlPatterns={"/SearchTransactionController"})
public class SearchTransactionController extends HttpServlet {
    
    private TransactionDAO dao = new TransactionDAO();
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("LOGIN_USER");
        
        if (loginUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String search = request.getParameter("search");
        if(search == null) {
            search = "";
        }
        
        List<Transaction> list = new ArrayList<>();
        if ("AD".equals(loginUser.getRoleID())) {
            // Admin thấy tất cả
            try {
                list = dao.search(search);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            // Nhân viên chỉ thấy của mình
            try {
                list = dao.getTransactionsByUserID(loginUser.getUserID(), search);
                
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
            }
        }
        request.setAttribute("list", list);
        request.getRequestDispatcher("transactionList.jsp").forward(request, response);
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
