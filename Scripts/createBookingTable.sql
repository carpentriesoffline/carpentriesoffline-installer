-- BookingTable definition

CREATE TABLE Bookings (
    BookingReference TEXT PRIMARY KEY,
    BookingDate TEXT,
    WorkshopID TEXT,
    LessonID TEXT,
    PersonID TEXT,
    Attended TEXT,
    FOREIGN KEY (WorkshopID,LessonID)
        REFERENCES WorkshopLessons,
    FOREIGN KEY (PersonID)
        REFERENCES Person
);

