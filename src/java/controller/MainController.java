/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.StockDAO;
import dto.Stock;
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
@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String LOGIN = "Login";
    private static final String LOGIN_CONTROLLER = "LoginController";
    private static final String SEARCH_USER = "SearchUser";
    private static final String SEARCH_USER_CONTROLLER = "SearchUserController";
    private static final String UPDATE_USER = "UpdateUser";
    private static final String UPDATE_USER_CONTROLLER = "UpdateUserController";
    private static final String DELETE_USER = "DeleteUser";
    private static final String DELETE_USER_CONTROLLER = "DeleteUserController";
    private static final String CREATE_USER = "CreateUser";
    private static final String CREATE_USER_CONTROLLER = "CreateUserController";
    private static final String SEARCH_TRANSACTION = "SearchTransaction";
    private static final String SEARCH_TRANSACTION_CONTROLLER = "SearchTransactionController";
    private static final String CREATE_TRANSACTION = "CreateTransaction";
    private static final String CREATE_TRANSACTION_CONTROLLER = "CreateTransactionController";
    private static final String UPDATE_TRANSACTION = "UpdateTransaction";
    private static final String UPDATE_TRANSACTION_CONTROLLER = "UpdateTransactionController";
    private static final String DELETE_TRANSACTION = "DeleteTransaction";
    private static final String DELETE_TRANSACTION_CONTROLLER = "DeleteTransactionController";
    private static final String SEARCH_ALERT = "ViewAlerts";
    private static final String SEARCH_ALERT_CONTROLLER = "SearchAlertController";
    private static final String CREATE_ALERT = "CreateAlert";
    private static final String CREATE_ALERT_CONTROLLER = "CreateAlertController";
    private static final String UPDATE_ALERT = "UpdateAlert";
    private static final String UPDATE_ALERT_CONTROLLER = "UpdateAlertController";
    private static final String DELETE_ALERT = "DeleteAlert";
    private static final String DELETE_ALERT_CONTROLLER = "DeleteAlertController";
    private static final String UPDATE_STOCK = "UpdateStock";
    private static final String UPDATE_STOCK_CONTROLLER = "UpdateStockController";
    private static final String DELETE_STOCK = "DeleteStock";
    private static final String DELETE_STOCK_CONTROLLER = "DeleteStockController";
    private static final String CREATE_STOCK = "CreateStock";
    private static final String CREATE_STOCK_CONTROLLER = "CreateStockController";
    private static final String SEARCH_STOCK = "SearchStock";
    private static final String SEARCH_STOCK_CONTROLLER = "SearchStockController";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "error.jsp";
        try {
            String action = request.getParameter("action");
            if (LOGIN.equals(action)) {
                url = LOGIN_CONTROLLER;
            } else if (SEARCH_TRANSACTION.equals(action)) {
                url = SEARCH_TRANSACTION_CONTROLLER;
            } else if (SEARCH_USER.equals(action)) {
                url = SEARCH_USER_CONTROLLER;
            } else if (UPDATE_USER.equals(action)) {
                url = "updateUser.jsp";
            } else if (DELETE_USER.equals(action)) {
                url = DELETE_USER_CONTROLLER;
            } else if (CREATE_USER.equals(action)) {
                url = CREATE_USER_CONTROLLER;
            } else if (CREATE_TRANSACTION.equals(action)) {
                url = CREATE_TRANSACTION_CONTROLLER;
            } else if (UPDATE_TRANSACTION.equals(action)) {
                url = UPDATE_TRANSACTION_CONTROLLER;
            } else if ("UpdateTransactionByNV".equals(action)) {
                url = "updateTransaction.jsp";
            } else if (DELETE_TRANSACTION.equals(action)) {
                url = DELETE_TRANSACTION_CONTROLLER;
            } else if (SEARCH_ALERT.equals(action)) {
                url = SEARCH_ALERT_CONTROLLER;
            } else if (CREATE_ALERT.equals(action)) {
                url = CREATE_ALERT_CONTROLLER;
            } else if (UPDATE_ALERT.equals(action)) {
                url = UPDATE_ALERT_CONTROLLER;
            } else if (DELETE_ALERT.equals(action)) {
                url = DELETE_ALERT_CONTROLLER;
            } else if (UPDATE_STOCK.equals(action)) {
                url = "updateStock.jsp";
            } else if(DELETE_STOCK.equals(action)){
                url = DELETE_STOCK_CONTROLLER;
            } else if (CREATE_STOCK.equals(action)) {
                url = CREATE_STOCK_CONTROLLER;
            } else if (SEARCH_STOCK.equals(action)) {
                url = SEARCH_STOCK_CONTROLLER;
            } else {
                url = "login.jsp";
            }
        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST cũng xử lý giống GET
        doGet(request, response);
    }
}



   
