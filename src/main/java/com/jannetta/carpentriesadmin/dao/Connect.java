package com.jannetta.carpentriesadmin.dao;


import org.sqlite.SQLiteConfig;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author sqlitetutorial.net
 */
public class Connect {
    public static final String DB_URL = "jdbc:sqlite:data/CarpentryAdmin.db";
    public static final String DRIVER = "org.sqlite.JDBC";
    static Connection conn = null;
    /**
     * Connect to a sample database
     */
    public static Connection getConnection() {
        try {
            SQLiteConfig config = new SQLiteConfig();
            config.enforceForeignKeys(true);
            // create a connection to the database
            conn = DriverManager.getConnection(DB_URL,config.toProperties());

            System.out.println("Connection to SQLite has been established.");

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return conn;
    }

    public static void closeConnection(Connection conn) {
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

}