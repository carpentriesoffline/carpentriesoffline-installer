CREATE TABLE EmailsSent
(
    WorkshopID TEXT NOT NULL,
    PersonID   TEXT NOT NULL,
    TimeStamp  TEXT NOT NULL,
    EmailID    TEXT NOT NULL,

    FOREIGN KEY (PersonID)
        REFERENCES Person (PersonID),
    FOREIGN KEY (WorkshopID)
        REFERENCES Workshop (WorkshopID),
    FOREIGN KEY (EmailID)
        REFERENCES EmailTemplate (EmailID)
);