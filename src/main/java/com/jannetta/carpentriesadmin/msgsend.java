package com.jannetta.carpentriesadmin;

import com.jannetta.carpentriesadmin.controller.EmailUtil;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Properties;
import java.util.Scanner;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;

public class msgsend {

    /**
     Outgoing Mail (SMTP) Server
     requires TLS or SSL: smtp.gmail.com (use authentication)
     Use Authentication: Yes
     Port for TLS/STARTTLS: 587
     */
    public static void main(String[] args) {
        final String fromEmail = "njss3@newcastle.ac.uk"; //requires valid gmail id
        final String password = "rb5xm3LYxz3Moa"; // correct password for gmail id
        final String toEmail = "jannetta@henning.org"; // can be any email id

        System.out.println("TLSEmail Start");
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.office365.com"); //SMTP Host
        props.put("mail.smtp.port", "587"); //TLS Port
        props.put("mail.smtp.auth", "true"); //enable authentication
        props.put("mail.smtp.starttls.enable", "true"); //enable STARTTLS

        //create Authenticator object to pass in Session.getInstance argument
        Authenticator auth = new Authenticator() {
            //override the getPasswordAuthentication method
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        };
        Session session = Session.getInstance(props, auth);
        String template = "data/EmailTemplates/InviteHelpers.txt";
        try (Scanner sc = new Scanner(new File(template))) {
            EmailUtil.sendEmail(session, toEmail,"Admin Testing Subject", "TLSEmail Testing Body","","");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }


    }


}