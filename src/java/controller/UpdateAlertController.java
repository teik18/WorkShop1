/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.AlertDAO;
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
@WebServlet(name = "UpdateAlertController", urlPatterns = {"/UpdateAlertController"})
public class UpdateAlertController extends HttpServlet {
    private static final String ALERT_LIST_PAGE = "SearchAlertController";
    private static final String UPDATE_ALERT_PAGE = "updateAlert.jsp";

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
        String url = ALERT_LIST_PAGE;
        try {
            User loginUser = (User) request.getSession().getAttribute("LOGIN_USER");
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            int alertID = Integer.parseInt(request.getParameter("alertID"));
            AlertDAO dao = new AlertDAO();
            Alert alert = dao.getAlertById(alertID);

            if (alert == null) {
                request.setAttribute("MSG", "Cannot find the alert!!");
                url = ALERT_LIST_PAGE;
                request.getRequestDispatcher(url).forward(request, response);
                return;
            } 
            if (!alert.getUserID().equals(loginUser.getUserID())) {
                request.setAttribute("MSG", "Access denied!!");
                url = ALERT_LIST_PAGE;
            } else {
                String thresholdParam = request.getParameter("threshold");
                String direction = request.getParameter("direction");
                String status = request.getParameter("status");
                if (thresholdParam == null && direction == null && status == null) {
                    request.setAttribute("ALERT", alert);
                    url = UPDATE_ALERT_PAGE;
                    request.getRequestDispatcher(url).forward(request, response);
                    return;
                } else {
                    if (!alert.getStatus().equalsIgnoreCase("inactive")) {
                        request.setAttribute("MSG", "Cannot change the active alert!!");
                        request.setAttribute("ALERT", alert);
                        url = ALERT_LIST_PAGE;
                    } else {
                        float threshold = Float.parseFloat(thresholdParam);
                        if (threshold <= 0) {
                            request.setAttribute("MSG", "Threshold must be greater than 0!!");
                            request.setAttribute("ALERT", alert);
                            url = UPDATE_ALERT_PAGE;
                        } else if (!"increase".equalsIgnoreCase(direction) && !"decrease".equalsIgnoreCase(direction)) {
                            request.setAttribute("MSG", "Direction must be decrease or increase!!");
                            request.setAttribute("ALERT", alert);
                            url = UPDATE_ALERT_PAGE;
                        } else if (!"inactive".equalsIgnoreCase(status) && !"active".equalsIgnoreCase(status) && !"pending".equalsIgnoreCase(status)) {
                            request.setAttribute("MSG", "Invalid status value!!");
                            request.setAttribute("ALERT", alert);
                            url = UPDATE_ALERT_PAGE;
                        } else {
                            alert.setThreshold(threshold);
                            alert.setDirection(direction);
                            alert.setStatus(status);
                            if (dao.updateAlert(alert)) {
                                request.setAttribute("MSG", "Update Successfully!!");
                                url = ALERT_LIST_PAGE;
                            } else {
                                request.setAttribute("MSG", "Update Failed!!");
                                request.setAttribute("ALERT", alert);
                                url = UPDATE_ALERT_PAGE;
                            }
                        }
                    }
                }
            } 
            request.getRequestDispatcher(url).forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("MSG", "Invalid format input!!");
            request.getRequestDispatcher(ALERT_LIST_PAGE).forward(request, response);
        } catch (Exception e) {
            log("Error at UpdateAlertController: " + e.toString());
            request.setAttribute("MSG", "Error System: " + e.getMessage());
            request.getRequestDispatcher(ALERT_LIST_PAGE).forward(request, response);
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
