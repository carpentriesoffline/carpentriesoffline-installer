package com.jannetta.carpentriesadmin.controller;

import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class Utils {

    public static String getTimeStampISO8601() {
        String dateString = Instant.now().toString();
        return dateString;
    }
}
