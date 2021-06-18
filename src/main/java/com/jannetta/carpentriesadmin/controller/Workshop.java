package com.jannetta.carpentriesadmin.controller;

public class Workshop {
    String workshopID;
    String workshopName;
    String startDate;
    String endDate;
    String startTime;
    String endTime;
    String communityDocURL;
    String preWorkshopSurveyURL;
    String postWorkshopSurveyURL;
    String surveyResults;
    String host;
    String hostInstitution;
    String workshopWebsite;
    String emailRemindDate;
    String postWorkshopSurveyRemindDate;

    public String getWorkshopID() {
        return workshopID;
    }

    public void setWorkshopID(String workshopID) {
        this.workshopID = workshopID;
    }

    public String getWorkshopName() {
        return workshopName;
    }

    public void setWorkshopName(String workshopName) {
        this.workshopName = workshopName;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getCommunityDocURL() {
        return communityDocURL;
    }

    public void setCommunityDocURL(String communityDocURL) {
        this.communityDocURL = communityDocURL;
    }

    public String getPreWorkshopSurveyURL() {
        return preWorkshopSurveyURL;
    }

    public void setPreWorkshopSurveyURL(String preWorkshopSurveyURL) {
        this.preWorkshopSurveyURL = preWorkshopSurveyURL;
    }

    public String getPostWorkshopSurveyURL() {
        return postWorkshopSurveyURL;
    }

    public void setPostWorkshopSurveyURL(String postWorkshopSurveyURL) {
        this.postWorkshopSurveyURL = postWorkshopSurveyURL;
    }

    public String getSurveyResults() {
        return surveyResults;
    }

    public void setSurveyResults(String surveyResults) {
        this.surveyResults = surveyResults;
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public String getHostInstitution() {
        return hostInstitution;
    }

    public void setHostInstitution(String hostInstitution) {
        this.hostInstitution = hostInstitution;
    }

    public String getWorkshopWebsite() {
        return workshopWebsite;
    }

    public void setWorkshopWebsite(String workshopWebsite) {
        this.workshopWebsite = workshopWebsite;
    }

    public String getEmailRemindDate() {
        return emailRemindDate;
    }

    public void setEmailRemindDate(String emailRemindDate) {
        this.emailRemindDate = emailRemindDate;
    }

    public String getPostWorkshopSurveyRemindDate() {
        return postWorkshopSurveyRemindDate;
    }

    public void setPostWorkshopSurveyRemindDate(String postWorkshopSurveyRemindDate) {
        this.postWorkshopSurveyRemindDate = postWorkshopSurveyRemindDate;
    }

    public Workshop() {
    }

    public Workshop(String workshopID, String workshopName, String startDate, String endDate,
                    String startTime, String endTime, String communityDocURL, String preWorkshopSurveyURL,
                    String postWorkshopSurveyURL, String surveyResults, String host, String hostInstitution,
                    String workshopWebsite, String emailRemindDate, String postWorkshopSurveyRemindDate) {
        this.workshopID = workshopID;
        this.workshopName = workshopName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.communityDocURL = communityDocURL;
        this.preWorkshopSurveyURL = preWorkshopSurveyURL;
        this.postWorkshopSurveyURL = postWorkshopSurveyURL;
        this.surveyResults = surveyResults;
        this.host = host;
        this.hostInstitution = hostInstitution;
        this.workshopWebsite = workshopWebsite;
        this.emailRemindDate = emailRemindDate;
        this.postWorkshopSurveyRemindDate = postWorkshopSurveyRemindDate;
    }
}
