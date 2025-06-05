package controller;

import dao.StockDAO;
import dto.Stock;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "CreateStockController", urlPatterns = {"/CreateStockController"})
public class CreateStockController extends HttpServlet {

    private static final String ERROR_PAGE = "SearchStockController";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    response.setContentType("text/html;charset=UTF-8");
    try {
        HttpSession session = request.getSession(); // getSession() thay vì getSession(false)
        if (session == null || session.getAttribute("LOGIN_USER") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String ticker = request.getParameter("ticker");
        String name = request.getParameter("name");
        String sector = request.getParameter("sector");
        float price;

        try {
            price = Float.parseFloat(request.getParameter("price"));
        } catch (NumberFormatException e) {
            request.setAttribute("MSG", "Invalid price format");
            request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
            return;
        }

        Stock stock = new Stock(ticker, name, sector, price, true);
        StockDAO dao = new StockDAO();

        try {
            boolean result = dao.create(stock);

            if (result) {
                session.setAttribute("MSG", "Stock created successfully!");
                response.sendRedirect("MainController?action=SearchStock");
            } else {
                request.setAttribute("MSG", "Create failed");
                request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
            }

        } catch (java.sql.SQLException ex) {
            if (ex.getMessage().contains("PRIMARY KEY")) {
                request.setAttribute("MSG", "Ticker đã tồn tại. Vui lòng nhập mã khác.");
            } else {
                request.setAttribute("MSG", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            }
            request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
        }

    } catch (Exception e) {
        throw new ServletException("Error in CreateStockController", e);
    }
}

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ERROR_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
