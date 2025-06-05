package controller;

import dao.StockDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Controller dùng để xóa Stock theo mã ticker.
 */
@WebServlet(name = "DeleteStockController", urlPatterns = {"/DeleteStockController"})
public class DeleteStockController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ticker = request.getParameter("ticker").trim();


        try {
            new StockDAO().delete(ticker);  // gọi DAO để xóa Stock theo ticker
            request.setAttribute("MSG", "Stock deleted successfully!");
        } catch (Exception e) {
            log("Error deleting stock: " + ticker, e);
            request.setAttribute("MSG", "Failed to delete stock.");
        }

        // Trở về MainController để load lại danh sách Stock
        request.getRequestDispatcher("/MainController?action=SearchStock").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "DeleteStockController - Xóa cổ phiếu theo ticker";
    }
}
