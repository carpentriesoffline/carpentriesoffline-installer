-- BookingTable definition

CREATE TABLE Booking (
    BookingId     INTEGER PRIMARY KEY,
    PersonID TEXT,
    WorkshopID    TEXT,
    LessonID      TEXT,
    FOREIGN KEY (PersonID)
        REFERENCES Person (PersonID),
    FOREIGN KEY (WorkshopID, LessonID)
        REFERENCES Workshop (WorkshopID, LessonID)
);
