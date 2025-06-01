/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.StockDAO;
import dao.TransactionDAO;
import dto.Transaction;
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
@WebServlet(name="CreateTransactionController", urlPatterns={"/CreateTransactionController"})
public class CreateTransactionController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String ticker = request.getParameter("ticker");
            String type = request.getParameter("type");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            float price = Float.parseFloat(request.getParameter("price"));

            if (quantity <= 0 || price <= 0) {
                request.setAttribute("MSG", "Quantity and price must be greater than 0.");
                request.getRequestDispatcher("SearchTransactionController").forward(request, response);
                return;
            }

            StockDAO stockDAO = new StockDAO();
            if (!stockDAO.isTickerExist(ticker)) {
                request.setAttribute("MSG", "Ticker does not exist.");
                request.getRequestDispatcher("SearchTransactionController").forward(request, response);
                return;
            }

            User loginUser = (User) request.getSession().getAttribute("LOGIN_USER");
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            Transaction transaction = new Transaction(0, loginUser.getUserID(), ticker, type, quantity, price, "pending");
            TransactionDAO transactionDAO = new TransactionDAO();
            if (transactionDAO.create(transaction)) {
                request.setAttribute("MSG", "Transaction created successfully.");
            } else {
                request.setAttribute("MSG", "Failed to create transaction.");
            }
            request.getRequestDispatcher("SearchTransactionController").forward(request, response);
        } catch (Exception e) {
            log(e.getMessage());
        }
    }


}
