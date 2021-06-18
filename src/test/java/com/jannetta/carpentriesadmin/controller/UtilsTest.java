package com.jannetta.carpentriesadmin.controller;

import org.junit.jupiter.api.Test;

import java.time.Clock;
import java.time.Instant;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

class UtilsTest {

    @Test
    void getTimeStampISO8601() {
        String now = Instant.now().toString();

        assertEquals(now, Utils.getTimeStampISO8601());
    }
}