package com.jannetta.carpentriesadmin.dao;


import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class Creating {
    public static void dropTable(String tablename) {
        if (tablename.equals("") || tablename == null) {
            System.out.println("You have to specify a table name.");
        } else {
            String sql = "DROP TABLE IF EXISTS " + tablename;
            Connection conn = Connect.getConnection();
            Statement statement = null;
            try {
                statement = conn.createStatement();
                statement.execute(sql);
                conn.close();
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }

}
