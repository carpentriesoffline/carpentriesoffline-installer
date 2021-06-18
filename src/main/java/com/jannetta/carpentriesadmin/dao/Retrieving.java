package com.jannetta.carpentriesadmin.dao;

import java.sql.*;
import java.util.ArrayList;

public class Retrieving {
    public static void selectAll(int table) {
        String[] tables = {"Person", "Workshop"};
        String sql = "SELECT * from " + tables[table];
        System.out.println(sql);
        Connection conn = Connect.getConnection();
        try {
            Statement statement = conn.createStatement();
            ResultSet resultSet = statement.executeQuery(sql);
            ResultSetMetaData rsmd = resultSet.getMetaData();
            int columnsNumber = rsmd.getColumnCount();
            int counter = 0;
            while (resultSet.next()) {
                counter++;
                System.out.print(String.format("%5d\t",counter));
                System.out.print(String.format("%10s",resultSet.getString(1)) );// id
                System.out.print(String.format("%10s",resultSet.getString(2)) );// firstname
                System.out.print(String.format("%20s",resultSet.getString(3)) );// middlenames
                System.out.print(String.format("%20s",resultSet.getString(4)) );// lastname
                System.out.print(String.format("%15s",resultSet.getString(5)) );// contactnumber
                System.out.print(String.format("%40s",resultSet.getString(9)) );// email
                System.out.print(String.format("%20s",resultSet.getString(7)) );// stage
                String school = resultSet.getString(8);
                System.out.print(String.format("%30s", (school.length()>20?school.substring(0,19):school)));// school
                String programme = resultSet.getString(6);
                System.out.print(String.format("%20s",(programme.length()>18?programme.substring(0,17):programme)) );// programme
                System.out.println();
            }
            conn.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public static ArrayList<String> getHelpers() {
        String sql = "SELECT P.FirstName, P.Email, P.PersonID FROM HelperPool h JOIN Person P ON P.PersonID=h.PersonID";
        ArrayList<String> returnArray = new ArrayList<>();
        Connection conn = Connect.getConnection();
        try {
            Statement statement = conn.createStatement();
            ResultSet resultSet = statement.executeQuery(sql);
            ResultSetMetaData rsmd = resultSet.getMetaData();
            int columnsNumber = rsmd.getColumnCount();
            while (resultSet.next()) {
                returnArray.add(resultSet.getString(1) + "," + resultSet.getString(2) +
                        "," + resultSet.getString(3));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return returnArray;
    }
}
