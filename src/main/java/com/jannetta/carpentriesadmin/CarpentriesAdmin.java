package com.jannetta.carpentriesadmin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.jannetta.carpentriesadmin.controller.Configure;
import com.jannetta.carpentriesadmin.dao.Importing;
import com.jannetta.carpentriesadmin.model.Person;

import java.util.ArrayList;
import java.util.Scanner;

import static com.jannetta.carpentriesadmin.dao.Creating.dropTable;
import static com.jannetta.carpentriesadmin.dao.Importing.*;
import static com.jannetta.carpentriesadmin.dao.Retrieving.selectAll;

// /home/jannetta/CARPENTRIES/WorkshopBookings/2021-04-26-NCL-Online/2021-04-26_NLC_ONLINE.csv
public class CarpentriesAdmin {


     /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Configure configure = Configure.getInstance();
        Scanner scanner = new Scanner(System.in);
        int option = 0;
        String[] indices;
        int size;
        int[] indexlist;
        int skiplines;
        while (option != 999) {
            System.out.print("1) Import People, " +
                    "2) Import Workshops, 3) Import Helpers, " +
                    "4) Import Bookings, 5) Import Lessons, " +
                    "6) Import Instructors, " +
                    "\n21) List People, 22) List Workshops, " +
                    "\n51) Drop Table, " +
                    "\n61) Print JSON structure, 999) Quit:");
            String nl = scanner.nextLine();
            if (!nl.equals(""))
            option = Integer.valueOf(nl);
            switch (option) {
                case 1:
                    System.out.print("Enter Filename: ");
                    String CSVFile = scanner.nextLine();
                    System.out.println("personid, firstname, middlename, lastname, email, contactnumber, program, school, stage");
                    System.out.print("Enter indices: ");
                    indices = scanner.nextLine().split(",");
                    indexlist = new int[indices.length];// = {4,0,1,2,3,999,999,999,999};
                    size = indices.length;
                    for(int i=0; i<size; i++) {
                        indexlist[i] = Integer.parseInt(indices[i]);
                    }
                    System.out.print("Skip lines: ");
                    skiplines = Integer.parseInt(scanner.nextLine());
                    ArrayList<Person> people = Importing.importPeople(CSVFile, indexlist, skiplines);
                    break;
                case 2:
                    System.out.print("Enter Filename: ");
                    String workshopCSVFile = scanner.nextLine();
                    importWorkshops(workshopCSVFile);
                    break;
                case 3:
                    System.out.print("Enter Filename: ");
                    String helperCSVFile = scanner.nextLine();
                    System.out.print("Enter index: ");
                    int index = Integer.valueOf(scanner.nextLine().trim());
                    importHelpers(helperCSVFile,index);
                    break;
                case 4:
                    System.out.println("Enter Filename: ");
                    String bookingsFilename = scanner.nextLine();
                    System.out.println("Enter workshop ID: ");
                    String workshopID = scanner.nextLine();
                    System.out.println("Enter Lesson ID: ");
                    String lessonID = scanner.nextLine();
                    System.out.print("Enter indices: ");
                    indices = scanner.nextLine().split(",");
                    indexlist = new int[indices.length];// = {4,0,1,2,3,999,999,999,999};
                    size = indices.length;
                    System.out.println(indices + " (" + size + ")");
                    for(int i=0; i<size; i++) {
                        indexlist[i] = Integer.parseInt(indices[i]);
                    }
                    System.out.print("Skip lines: ");
                    skiplines = Integer.parseInt(scanner.nextLine());
                    importBookings(bookingsFilename, indexlist, skiplines, workshopID, lessonID);
                    /**
                     * data/Git_2020-10-26.csv
                     * 2020-10-26-NCL-SWC-ONLINE
                     * g1
                     * 0,4,999,999,2,9
                     * 1
                     */
                    break;
                case 5:
                    System.out.print("Enter Filename: ");
                    String lessonCSVFile = scanner.nextLine();
                    importLessons(lessonCSVFile);
                    break;
                case 6:
                    System.out.print("Enter Filename: ");
                    String instructorCSV = scanner.nextLine();
                    System.out.print("Enter index: ");
                    int ind = Integer.valueOf(scanner.nextLine().trim());
                    importInstructors(instructorCSV,ind);
                    break;
                case 21:
                    System.out.print("List People: ");
                    selectAll(0);
                    break;
                case 22:
                    System.out.print("List Workshops: ");
                    selectAll(1);
                    break;
                case 51:
                    System.out.print("Enter Table Name: ");
                    String tableName = scanner.nextLine();
                    dropTable(tableName);
                    break;
                case 61:
                    System.out.println("Print JSON structure.");
                    Gson gson = new GsonBuilder().setPrettyPrinting().create();
                    Person person = new Person("njss3","Jannetta","Sophia","Steyn",
                            "07801889997","","","","jannetta.steyn@newcastle.ac.uk");
                    String jsonOutput = gson.toJson(person);
                    System.out.println(jsonOutput);
                    break;
            }
        }
        scanner.close();
        System.out.println("Done.");
    }

}
