package com.jannetta.carpentriesadmin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Inserting {

    public static int insertEmailSent(String workshopID, String personID, String emailID, String timeStamp) {
        int ret = -1;
        String sql = "INSERT INTO EmailsSent (WorkshopID, PersonID, EmailID, TimeStamp) VALUES (?,?,?,?)";
        Connection conn = Connect.getConnection();
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, workshopID);
            pstmt.setString(2, personID);
            pstmt.setString(3, emailID);
            pstmt.setString(4, timeStamp);
            ret = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            ret = -1;
        }
        return ret;
    }
}
