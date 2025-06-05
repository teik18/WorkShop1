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
import java.sql.SQLException;
import java.util.List;

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
            AlertDAO dao = new AlertDAO();
            String ticker = request.getParameter("ticker");
            String thresholdStr = request.getParameter("threshold");
            String direction = request.getParameter("direction");
            String status = request.getParameter("status") != null ? request.getParameter("status") : "inactive"; // Mặc định status là inactive
            String keyword = request.getParameter("search") != null ? request.getParameter("search") : "";
            String searchDirection = request.getParameter("directionSearch") != null ? request.getParameter("directionSearch") : "";
            String searchStatus = request.getParameter("statusSearch") != null ? request.getParameter("statusSearch") : "";
            if (ticker == null || ticker.isEmpty() || thresholdStr == null || direction == null) {
                setAlertListAttributes(request, loginUser, keyword, searchDirection, searchStatus);
                request.getRequestDispatcher("alertList.jsp").forward(request, response);
                return;
            }

            float threshold;
            try {
                threshold = Float.parseFloat(thresholdStr);
                if (threshold <= 0) {
                    request.setAttribute("MSG", "Threshold must be greater than 0!!");
                    setAlertListAttributes(request, loginUser, keyword, searchDirection, searchStatus);
                    request.getRequestDispatcher("alertList.jsp").forward(request, response);
                    return;
                }
                if (ticker.isEmpty() || direction.isEmpty()) {
                    request.setAttribute("MSG", "Please enter information!!");
                    setAlertListAttributes(request, loginUser, keyword, searchDirection, searchStatus);
                    request.getRequestDispatcher("alertList.jsp").forward(request, response);
                    return;
                }
                if (!stockDao.isTickerExist(ticker)) {
                    request.setAttribute("MSG", "This ticker does not exist!!");
                    setAlertListAttributes(request, loginUser, keyword, searchDirection, searchStatus);
                    request.getRequestDispatcher("alertList.jsp").forward(request, response);
                    return;
                }
                if (!direction.equals("increase") && !direction.equals("decrease")) {
                    request.setAttribute("MSG", "Direction must be decrease or increase!!");
                    setAlertListAttributes(request, loginUser, keyword, searchDirection, searchStatus);
                    request.getRequestDispatcher("alertList.jsp").forward(request, response);
                    return;
                }
                if (dao.isDuplicate(loginUser.getUserID(), ticker, threshold, direction)) {
                    request.setAttribute("MSG", "The alert already existed!!");
                    setAlertListAttributes(request, loginUser, keyword, searchDirection, searchStatus);
                    request.getRequestDispatcher("alertList.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("MSG", "Invalid threshold format!!");
                request.getRequestDispatcher("alertList.jsp").forward(request, response);
                return;
            }

            Alert alert = new Alert(0, loginUser.getUserID(), ticker, threshold, direction, status);
            if (dao.createAlert(alert)) {
                request.setAttribute("MSG", "Alert created successfully.");
            } else {
                request.setAttribute("MSG", "Failed to create alert.");
            }
            setAlertListAttributes(request, loginUser, keyword, searchDirection, searchStatus);
            request.getRequestDispatcher("alertList.jsp").forward(request, response);
        } catch (Exception e) {
            log(e.getMessage());
            setAlertListAttributes(request, (User) request.getSession().getAttribute("LOGIN_USER"), "", "", "");
            request.getRequestDispatcher("alertList.jsp").forward(request, response);
        }
    }
    
    // Hàm hỗ trợ để lấy danh sách alert và đặt các thuộc tính cần thiết
    private void setAlertListAttributes(HttpServletRequest request, User loginUser, String keyword, String direction, String status) {
        try {
            AlertDAO dao = new AlertDAO();
            List<Alert> list = dao.getAlertsByUser(loginUser.getUserID(), keyword, direction, status);
            request.setAttribute("ALERT_LIST", list);
            request.setAttribute("list", list);
            request.setAttribute("keyword", keyword);
            request.setAttribute("directionSearch", direction);
            request.setAttribute("statusSearch", status);
        } catch (SQLException e) {
            e.printStackTrace();
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
