package com.jannetta.carpentriesadmin.dao;

import com.jannetta.carpentriesadmin.model.Bookings;
import com.jannetta.carpentriesadmin.model.Person;
import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvValidationException;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;

public class Importing {

    /**
     * Import records from the CSV filename provided. Skip the number of lines specified from the file.
     * The index list provided gives the index
     *
     * @param csvFilename
     * @param indexlist
     * @param skiplines   FirstName,MiddleNames,LastName,Email,StudentNumber,Programme
     *                    indexlist: (an index of 999 means the item is not available)
     *                    personid, firsname, middlename, lastname, email, contactnumber, program, school, stage
     *                    4,0,1,2,3,
     */
    public static ArrayList<Person> importPeople(String csvFilename, int[] indexlist, int skiplines) {
        ArrayList<Person> people = new ArrayList();
        try {
            Connection conn = Connect.getConnection();
            String sql = "INSERT INTO Person (PersonID, FirstName, MiddleNames, LastName, ContactNumber, Programme, Stage, School, Email) VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ?);";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            CSVReader reader = new CSVReader(new FileReader(csvFilename));
            reader.skip(skiplines);
            String[] nextLine;
            while ((nextLine = reader.readNext()) != null) {
                Person person = new Person();
                if (indexlist[0] != 999)
                    person.setPersonID(nextLine[indexlist[0]].trim());
                if (indexlist[1] != 999)
                    person.setFirstName(nextLine[indexlist[1]].trim());
                if (indexlist[2] != 999)
                    person.setMiddleNames(nextLine[indexlist[2]].trim());
                if (indexlist[3] != 999)
                    person.setLastName(nextLine[indexlist[3]].trim());
                if (indexlist[4] != 999)
                    person.setEmail(nextLine[indexlist[4]].trim());
                if (indexlist[5] != 999)
                    person.setContactNumber(nextLine[indexlist[5]].trim());
                if (indexlist[6] != 999)
                    person.setProgramme(nextLine[indexlist[6]].trim());
                if (indexlist[7] != 999)
                    person.setSchool(nextLine[indexlist[7]].trim());
                if (indexlist[8] != 999)
                    person.setStage(nextLine[indexlist[8]].trim());
                people.add(person);
                pstmt.setString(1, person.getPersonID()); // Person ID
                pstmt.setString(2, person.getFirstName()); // FirstName
                pstmt.setString(3, person.getMiddleNames()); // MiddleNames
                pstmt.setString(4, person.getLastName()); // LastName
                pstmt.setString(5, person.getContactNumber()); // ContactNumber
                pstmt.setString(6, person.getProgramme()); // Programme
                pstmt.setString(7, person.getStage()); // Stage
                pstmt.setString(8, person.getSchool()); // School
                pstmt.setString(9, person.getEmail()); // Email
                pstmt.addBatch();
            }
            pstmt.executeBatch();
            conn.close();
        } catch (FileNotFoundException e) {
            System.out.println("The filename that you entered does not exist. Please try again.");
        } catch (IOException | CsvValidationException e) {
            e.printStackTrace();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
        return people;
    }


    /**
     * @param bookingsFilename
     * @param indexlist
     * @param skiplines        BookingReference, BookingDate, WorkshopID, LessonID, PersonID, Attended
     */
    public static void importBookings(String bookingsFilename, int[] indexlist, int skiplines, String workshopID, String lessonID) {
        try {
            Connection conn = Connect.getConnection();
            String sql = "INSERT INTO Bookings (BookingReference, BookingDate, WorkshopID, LessonID, PersonID, Attended) VALUES( ?, ?, ?, ?, ?, ?);";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            CSVReader reader = new CSVReader(new FileReader(bookingsFilename));
            reader.skip(skiplines);
            String[] nextLine;
            while ((nextLine = reader.readNext()) != null) {
                Bookings booking = new Bookings();
                if (indexlist[0] != 999)
                    booking.setBookingReference(nextLine[indexlist[0]].trim());
                if (indexlist[1] != 999)
                    booking.setBookingDate(nextLine[indexlist[1]].trim());
                if (!workshopID.equals(""))
                    booking.setWorkshopID(workshopID.trim());
                else if (indexlist[2] != 999)
                    booking.setWorkshopID(nextLine[indexlist[2]].trim());
                if (!lessonID.equals(""))
                    booking.setLessonID(lessonID.trim());
                else if (indexlist[3] != 999)
                    booking.setLessonID(nextLine[indexlist[3]].trim());
                if (indexlist[4] != 999)
                    booking.setPersonID(nextLine[indexlist[4]].trim());
                if (indexlist[5] != 999)
                    booking.setAttended(nextLine[indexlist[5]].trim());

                pstmt.setString(1, booking.getBookingReference()); // Person ID
                pstmt.setString(2, booking.getBookingDate()); // FirstName
                pstmt.setString(3, booking.getWorkshopID()); // MiddleNames
                pstmt.setString(4, booking.getLessonID()); // LastName
                pstmt.setString(5, booking.getPersonID()); // ContactNumber
                pstmt.setString(6, booking.getAttended()); // Programme

                System.out.println("insert:" + booking.getBookingReference() + " " + booking.getBookingDate() +
                        " " + booking.getWorkshopID() + " " + booking.getLessonID() + " " + booking.getPersonID() +
                        " " + booking.getAttended());
                pstmt.addBatch();
            }
            pstmt.executeBatch();
            conn.close();
        } catch (FileNotFoundException e) {
            System.out.println("The filename that you entered does not exist. Please try again.");
        } catch (IOException | CsvValidationException e) {
            e.printStackTrace();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    public static void importWorkshops(String csvFileName) {
        try {
            CSVReader reader = new CSVReader(new FileReader(csvFileName));
            reader.skip(1);

            Connection conn = Connect.getConnection();
            String sql = "INSERT INTO Workshop (WorkshopID, WorkshopName, StartDate, EndDate, StartTime, " +
                    "EndTime, CommunityDocURL, PreWorkshopSurvey, PostWorkshopSurvey, SurveyResults, " +
                    "WorkshopWebsite) VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            String[] nextLine;
            while ((nextLine = reader.readNext()) != null) {

                pstmt.setString(1, nextLine[1]); // WorkshopID
                pstmt.setString(2, nextLine[1]); // WorkshopName
                pstmt.setString(3, nextLine[2]); // StartDate
                pstmt.setString(4, nextLine[3]); // EndDate
                pstmt.setString(5, nextLine[4]); // StartTime
                pstmt.setString(6, nextLine[5]); // EndTime
                pstmt.setString(7, nextLine[6]); // CommunityDocURL
                pstmt.setString(8, nextLine[7]); // PreWorkshopSurvey
                pstmt.setString(9, nextLine[8]); // PostWorkshopSurvey
                pstmt.setString(10, nextLine[9]); // SurveyResults
                pstmt.setString(11, nextLine[10]); // WorkshopWebsite

                pstmt.addBatch();
            }
            pstmt.executeBatch();
            conn.close();
        } catch (FileNotFoundException e) {
            System.out.println("The filename you specified could not be found. Please try again.");
        } catch (IOException e) {
            e.printStackTrace();
        } catch (CsvValidationException e) {
            e.printStackTrace();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    public static void importLessons(String csvFileName) {
        try {
            CSVReader reader = new CSVReader(new FileReader(csvFileName));
            reader.skip(1);

            Connection conn = Connect.getConnection();
            String sql = "INSERT INTO Lesson (LessonID, Description, URL) VALUES( ?, ?, ?);";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            String[] nextLine;
            while ((nextLine = reader.readNext()) != null) {

                pstmt.setString(1, nextLine[0]); // LessonID
                pstmt.setString(2, nextLine[1]); // Description
                pstmt.setString(3, nextLine[2]); // URL

                pstmt.addBatch();
            }
            pstmt.executeBatch();
            conn.close();
        } catch (FileNotFoundException e) {
            System.out.println("The filename you specified could not be found. Please try again.");
        } catch (IOException e) {
            e.printStackTrace();
        } catch (CsvValidationException e) {
            e.printStackTrace();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    public static void importHelpers(String csvFileName, int index) {
        try {
            CSVReader reader = new CSVReader(new FileReader(csvFileName));
            reader.skip(1);

            Connection conn = Connect.getConnection();
            String sql = "INSERT INTO HelperPool (PersonID) VALUES( ?);";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            String[] nextLine;
            while ((nextLine = reader.readNext()) != null) {
                pstmt.setString(1, nextLine[index].trim()); // PersonID
                System.out.println(nextLine[index].trim());
                pstmt.addBatch();
            }
            pstmt.executeBatch();
            conn.close();
        } catch (FileNotFoundException e) {
            System.out.println("The filename you specified could not be found. Please try again.");
        } catch (IOException e) {
            e.printStackTrace();
        } catch (CsvValidationException e) {
            e.printStackTrace();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }


    public static void importInstructors(String csvFileName, int index) {
        try {
            CSVReader reader = new CSVReader(new FileReader(csvFileName));
            reader.skip(1);

            Connection conn = Connect.getConnection();
            String sql = "INSERT INTO InstructorPool (PersonID) VALUES( ?);";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            String[] nextLine;
            while ((nextLine = reader.readNext()) != null) {
                pstmt.setString(1, nextLine[index].trim()); // PersonID
                System.out.println(nextLine[index].trim());
                pstmt.addBatch();
            }
            pstmt.executeBatch();
            conn.close();
        } catch (FileNotFoundException e) {
            System.out.println("The filename you specified could not be found. Please try again.");
        } catch (IOException e) {
            e.printStackTrace();
        } catch (CsvValidationException e) {
            e.printStackTrace();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

    }
}

