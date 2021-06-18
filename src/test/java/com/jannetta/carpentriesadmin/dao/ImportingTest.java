package com.jannetta.carpentriesadmin.dao;

import com.jannetta.carpentriesadmin.model.Person;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;

class ImportingTest {

    @org.junit.jupiter.api.Test
    void importPeople() {
        String filename = "data/Helpers.csv";
        int[] indexlist = {4,0,1,2,3,999,999,999,999};
        ArrayList<Person> people = Importing.importPeople(filename, indexlist,1);
        for (int i = 0; i < people.size(); i++) {
            System.out.println(i + ">>\t" + people.get(i).getFirstName());
        }
        assertEquals(14, people.size());
    }
}