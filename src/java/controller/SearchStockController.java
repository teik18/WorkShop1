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
@WebServlet(name="SearchStockController", urlPatterns={"/SearchStockController"})
public class SearchStockController extends HttpServlet {
    
    private StockDAO dao = new StockDAO();
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String search = request.getParameter("search");
        String sort = request.getParameter("sort");
        //tìm giá
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");

        List<Stock> list;

        try {
            if (minPriceStr != null && maxPriceStr != null) {
                try {
                    double minPrice = Double.parseDouble(minPriceStr);
                    double maxPrice = Double.parseDouble(maxPriceStr);
                    list = dao.searchByPriceRange(minPrice, maxPrice);
                } catch (NumberFormatException e) {
                    // fallback: hiển thị tất cả nếu lỗi format
                    list = dao.findAll();
                    request.setAttribute("error", "Invalid price range");
                }

            } else if (search != null && !search.trim().isEmpty()) {
                list = dao.search(search.trim());
            } else if ("asc".equalsIgnoreCase(sort)) {
                list = dao.findAllOrderByPriceAsc();
            } else if ("desc".equalsIgnoreCase(sort)) {
                list = dao.findAllOrderByPriceDesc();
            } else {
                list = dao.findAll(); // mặc định hiển thị toàn bộ
            }

            request.setAttribute("listStock", list);
            request.getRequestDispatcher("/stockList.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Error in SearchStockController", e);
        }
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
