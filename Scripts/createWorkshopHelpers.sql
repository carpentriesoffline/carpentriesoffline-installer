CREATE TABLE WorkshopHelpers (
     LessonID   TEXT,
     WorkshopID TEXT,
     PersonID TEXT,
     FOREIGN KEY (WorkshopID, LessonID) REFERENCES WorkshopLessons,
     FOREIGN KEY (PersonID) REFERENCES HelperPool

)