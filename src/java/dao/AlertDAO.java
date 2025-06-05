/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;
import dto.Alert;

/**
 *
 * @author Admin
 */
public class AlertDAO {

    public ArrayList<Alert> search(String search) throws SQLException {
        ArrayList<Alert> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT * FROM tblAlerts WHERE userID LIKE ? OR ticker LIKE ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, '%' + search + '%');
                ps.setString(2, '%' + search + '%');
                rs = ps.executeQuery();
                while (rs.next()) {
                    int alertID = rs.getInt("alertID");
                    String userID = rs.getString("userID");
                    String ticker = rs.getString("ticker");
                    float threshold = rs.getFloat("threshold");
                    String direction = rs.getString("direction");
                    String status = rs.getString("status");
                    list.add(new Alert(alertID, userID, ticker, threshold, direction, status));
                }
            }
        } catch (Exception e) {
        } finally {
            if (conn != null) {
                conn.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (rs != null) {
                rs.close();
            }
        }
        return list;
    }

    public boolean createAlert(Alert alert) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean isCreated = false;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "INSERT INTO tblAlerts(userID, ticker, threshold, direction) VALUES(?, ?, ?, ?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, alert.getUserID());
                ps.setString(2, alert.getTicker());
                ps.setFloat(3, alert.getThreshold());
                ps.setString(4, alert.getDirection());
                isCreated = ps.executeUpdate() > 0;
            }
        } finally {
            if (conn != null) {
                conn.close();
            }
            if (ps != null) {
                ps.close();
            }
        }
        return isCreated;
    }

    public boolean updateAlert(Alert alert) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean isUpdated = false;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "UPDATE tblAlerts SET threshold = ?, direction = ?, status = ? WHERE alertID = ? AND userID = ?";
                ps = conn.prepareStatement(sql);
                ps.setFloat(1, alert.getThreshold());
                ps.setString(2, alert.getDirection());
                ps.setString(3, alert.getStatus());
                ps.setInt(4, alert.getAlertID());
                ps.setString(5, alert.getUserID());
                isUpdated = ps.executeUpdate() > 0;
            }
        } finally {
            if (conn != null) {
                conn.close();
            }
            if (ps != null) {
                ps.close();
            }
        }
        return isUpdated;
    }

    public boolean deleteAlert(int alertID) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean isDeleted = false;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "DELETE FROM tblAlerts WHERE alertID = ? AND status = 'inactive'";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, alertID);
                isDeleted = ps.executeUpdate() > 0;
            }
        } finally {
            if (conn != null) {
                conn.close();
            }
            if (ps != null) {
                ps.close();
            }
        }
        return isDeleted;
    }
    public boolean isDuplicate(String userID, String ticker, float threshold, String direction) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean isDuplicated = false;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT * FROM tblAlerts WHERE userID = ? AND ticker = ? AND threshold = ? AND direction = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, userID);
                ps.setString(2, ticker);
                ps.setFloat(3, threshold);
                ps.setString(4, direction);
                rs = ps.executeQuery();
                isDuplicated = rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                conn.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (rs != null) {
                rs.close();
            }
        }
        return isDuplicated;
    }
    public Alert getAlertById(int alertID) throws SQLException {
        String sql = "SELECT * FROM tblAlerts WHERE alertID = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, alertID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Alert(rs.getInt("alertID"), rs.getString("userID"), rs.getString("ticker"), rs.getFloat("threshold"), rs.getString("direction"), rs.getString("status"));
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Alert> getAlertsByUser(String userID, String keyword, String direction, String status) throws SQLException {
        List<Alert> list = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM tblAlerts WHERE userID = ? AND ticker LIKE ? AND direction LIKE ? AND status LIKE ?");) {
            ps.setString(1, userID);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + direction + "%");
            ps.setString(4, "%" + status + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Alert alert = new Alert(rs.getInt("alertID"), rs.getString("userID"), rs.getString("ticker"), rs.getFloat("threshold"), rs.getString("direction"), rs.getString("status")); // mapping fields
                list.add(alert);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
