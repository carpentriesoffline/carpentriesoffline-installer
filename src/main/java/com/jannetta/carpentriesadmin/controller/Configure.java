package com.jannetta.carpentriesadmin.controller;

import java.io.*;
import java.util.Properties;

/**
 * Class holding all configuration settings for the application
 */
public class Configure {
    private static Configure configure = null;

    private static Properties systemProperties = new Properties();
    private static Properties smtpProperties = new Properties();
    private static String smtpPropertiesFile = "smtp.properties";
    private static String systemPropertiesFile = "system.properties";


    /**
     * Singleton return an instance of itself
     *
     * @return configure
     */
    public static Configure getInstance() {
        try {
            if (configure == null) {
                configure = new Configure();
                File file_systemProperties = new File(systemPropertiesFile);
                File file_smtpProperties = new File(smtpPropertiesFile);
                OutputStream out;
                // If system.properties does not exist, create it
                if (!file_systemProperties.exists()) {
                    out = new FileOutputStream(file_systemProperties);
                    out.close();
                }
                // If smtp.properties does not exists, create it
                if (!file_smtpProperties.exists()) {
                    out = new FileOutputStream(file_smtpProperties);
                    out.close();
                }
                // Read the system properties
                InputStream is = new FileInputStream(file_systemProperties);
                systemProperties.load(is);
                is.close();
                // Read the smtp properties
                is = new FileInputStream(file_smtpProperties);
                smtpProperties.load(is);
                is.close();;

                // If there are no properties yet, set STORAGE to the default value of /upload
                if (smtpProperties.size() == 0) {
                    smtpProperties.put("mail.smtp.host", ""); //SMTP Host
                    smtpProperties.put("mail.smtp.port", ""); //TLS Port
                    smtpProperties.put("mail.smtp.auth", ""); //enable authentication
                    smtpProperties.put("mail.smtp.starttls.enable", ""); //enable STARTTLS
                }
                FileOutputStream os = new FileOutputStream("system.properties");
                smtpProperties.store(os, "");

            }
        } catch (FileNotFoundException e) {

        } catch (IOException e) {
            e.printStackTrace();
        }
        return configure;
    }

    public static Properties getSystemProperties() {
        return systemProperties;
    }

    public static void setSystemProperties(Properties systemProperties) {
        Configure.systemProperties = systemProperties;
    }

    public static Properties getSmtpProperties() {
        return smtpProperties;
    }

    public static void setSmtpProperties(Properties smtpProperties) {
        Configure.smtpProperties = smtpProperties;
    }
}
