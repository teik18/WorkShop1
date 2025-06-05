/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.StockDAO;
import dto.Stock;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "UpdateStockController", urlPatterns = {"/UpdateStockController"})
public class UpdateStockController extends HttpServlet {

    private static final String SUCCESS = "MainController?action=SearchStock";
    private static final String ERROR = "error.jsp";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("LOGIN_USER") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String url = ERROR;

        try {
            String ticker = req.getParameter("ticker");
            String name = req.getParameter("name");
            String sector = req.getParameter("sector");
            float price = Float.parseFloat(req.getParameter("price"));

            Stock stock = new Stock(ticker, name, sector, price, true);
            boolean result = new StockDAO().update(stock);

            if (result) {
                session.setAttribute("MSG", "Update stock successfully!");
            } else {
                session.setAttribute("MSG", "Update failed!");
            }

            url = SUCCESS;
        } catch (Exception e) {
            log("Error at UpdateStockController: " + e.toString());
        } finally {
            resp.sendRedirect(url);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect("MainController");
    }
}
