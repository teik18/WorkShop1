/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.AlertDAO;
import dao.StockDAO;
import dto.Alert;
import dto.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author ACER
 */
@WebServlet(name = "CreateAlertController", urlPatterns = {"/CreateAlertController"})
public class CreateAlertController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            User loginUser = (User) request.getSession().getAttribute("LOGIN_USER");
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            StockDAO stockDao = new StockDAO();
            String ticker = request.getParameter("ticker");
            String thresholdStr = request.getParameter("threshold");
            String direction = request.getParameter("direction");
            String status = request.getParameter("status");
            if (ticker == null || ticker.isEmpty() || thresholdStr == null || direction == null) {
                request.getRequestDispatcher("createAlert.jsp").forward(request, response);
                return;
            }

            float threshold;
            try {
                threshold = Float.parseFloat(thresholdStr);
                if (threshold <= 0) {
                    request.setAttribute("MSG", "Threshold must be greater than 0!!");
                    request.getRequestDispatcher("createAlert.jsp").forward(request, response);
                    return;
                }
                if (ticker.isEmpty() || direction.isEmpty()) {
                    request.setAttribute("MSG", "Please enter information!!");
                    request.getRequestDispatcher("createAlert.jsp").forward(request, response);
                    return;
                }
                if (!stockDao.isTickerExist(ticker)) {
                    request.setAttribute("MSG", "This ticker does not exist!!");
                    request.getRequestDispatcher("createAlert.jsp").forward(request, response);
                    return;
                }
                if (!direction.equals("increase") && !direction.equals("decrease")) {
                    request.setAttribute("MSG", "Direction must be decrease or increase!!");
                    request.getRequestDispatcher("createAlert.jsp").forward(request, response);
                    return;
                }
                AlertDAO alertDao = new AlertDAO();
                if (alertDao.isDuplicate(loginUser.getUserID(), ticker, threshold, direction)) {
                    request.setAttribute("MSG", "The alert has existed!!");
                    request.getRequestDispatcher("createAlert.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("MSG", "Failed to create alert.");
                request.getRequestDispatcher("createAlert.jsp").forward(request, response);
                return;
            }

            Alert alert = new Alert(0, loginUser.getUserID(), ticker, threshold, direction, status);
            AlertDAO dao = new AlertDAO();
            if (dao.createAlert(alert)) {
                request.setAttribute("MSG", "Alert created successfully.");
            } else {
                request.setAttribute("MSG", "Failed to create alert.");
            }
            request.getRequestDispatcher("createAlert.jsp").forward(request, response);
        } catch (Exception e) {
            log(e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
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
}
