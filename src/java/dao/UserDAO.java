/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

/**
 *
 * @author Admin
 */
public class UserDAO {
    /**
     * Trả về User nếu login thành công, ngược lại trả về null.Không bắt Exception âm thầm nữa, để controller log hoặc ném lên.
     * @param userID
     * @param password
     * @return 
     * @throws java.lang.ClassNotFoundException
     * @throws java.sql.SQLException
     */
    public User login(String userID, String password) throws ClassNotFoundException, SQLException {
        // Debug đầu vào
        System.out.println("UserDAO.login(): userID=" + userID + ", password=" + password);

        String sql = "SELECT fullName, roleID FROM tblUsers WHERE userID = ? AND password = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userID);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String fullName = rs.getString("fullName");
                    String roleID   = rs.getString("roleID");
                    System.out.println("Login successful for " + userID + ", fullName=" + fullName + ", roleID=" + roleID);
                    // *** LƯU Ý: tham số cuối "***" chỉ dùng tạm, không quan trọng
                    return new User(userID, fullName, roleID, "***");
                } else {
                    System.out.println("Login failed: no matching record");
                }
            }
        }
        return null;
    }
    
    public List<User> search(String kw) throws SQLException, ClassNotFoundException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM tblUsers WHERE userID LIKE ? OR fullName LIKE ? OR roleID LIKE ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            String pattern = "%" + kw + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }
    
    public boolean update(User s)
            throws SQLException, ClassNotFoundException {
        String sql = "UPDATE tblUsers SET fullName=?, roleID=?, password=? WHERE userID=?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getFullName());
            ps.setString(2, s.getRoleID());
            ps.setString(3, s.getPassword());
            ps.setString(4, s.getUserID());
            return ps.executeUpdate() > 0;
        }
    }
    
    public boolean create(User user) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO tblUsers(userID, fullName, roleID, password) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUserID());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getRoleID());
            ps.setString(4, user.getPassword());
            return ps.executeUpdate() > 0;
       }
    }
    
    public boolean delete(String userID)
            throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM tblUsers WHERE userID = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userID);
            return ps.executeUpdate() > 0;
        }
    }

    public User getUserById(String id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM tblUsers WHERE userID = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private User mapRow(ResultSet rs) throws SQLException {
        return new User(
                rs.getString("userID"),
                rs.getString("fullName"),
                rs.getString("roleID"),
                rs.getString("password")
        );
    }
}
