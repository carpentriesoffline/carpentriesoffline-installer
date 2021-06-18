package com.jannetta.carpentriesadmin;

import com.jannetta.carpentriesadmin.controller.Configure;
import com.jannetta.carpentriesadmin.controller.EmailUtil;
import com.jannetta.carpentriesadmin.dao.Inserting;
import com.jannetta.carpentriesadmin.dao.Retrieving;

import javax.mail.*;
import java.io.File;
import java.io.FileNotFoundException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Properties;
import java.util.Scanner;

public class SendMail {

    public static void main(String[] args) {

        final Configure configure = Configure.getInstance();
        Properties props = configure.getSmtpProperties();
        String fromEmail = ""; //requires valid gmail id
        final  String password = ""; // correct password for gmail id
        String toEmail = ""; // can be any email id



        //create Authenticator object to pass in Session.getInstance argument
        Authenticator auth = new Authenticator() {
            //override the getPasswordAuthentication method
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        };
        Session session = Session.getInstance(props, auth);
        final Scanner scin = new Scanner(System.in);
        System.out.println("File containing template: " );
        String template = scin.nextLine();
        System.out.println("From: ");
        String emailFrom = scin.nextLine();
        System.out.println("ReplyTo: ");
        String replyTo = scin.nextLine();
        System.out.println("WorkshopID: ");
        String workshopID = scin.nextLine();
        System.out.println("EmailID: ");
        String emailID = scin.nextLine();

        try {
            Scanner sc = new Scanner(new File(template));
            String line = sc.nextLine();
            String subject = line.substring(1,line.length()-1).split(":")[1].trim();

            System.out.println("Sending email: " + subject);

            StringBuilder stringBuilder = new StringBuilder();
            String name = "John";
            while (sc.hasNext()) {
                line = sc.nextLine();
                stringBuilder.append(line + "\n");
            }
            ArrayList<String> nameList = Retrieving.getHelpers();
            nameList.forEach((recipient) -> {
                String body = stringBuilder.toString().replace("<FirstName>", recipient.split(",")[0]);
                int sent = Inserting.insertEmailSent(workshopID, // workshop
                        recipient.split(",")[2], // person
                        emailID, // email
                        Instant.now().toString()); // time
                if (sent > -1) {
                    if ((EmailUtil.sendEmail(session, recipient.split(",")[1], subject, body,
                            emailFrom, replyTo))> -1) {
                        System.out.println(body);
                    } else {
                        System.out.println("Email failed to send.");
                    }
                } else {
                    System.out.println("Error sending email: " + recipient);
                }
            });
        } catch (FileNotFoundException e) {
            System.out.println("The file containing the email template could not be found.");
        }

    }
}
