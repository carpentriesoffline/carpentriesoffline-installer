-- LessonWorkshop

CREATE TABLE WorkshopLessons (
    LessonID   TEXT,
    WorkshopID TEXT,
    LessonStartDate TEXT,
    Notes TEXT,
    PRIMARY KEY (WorkshopID,LessonID),
    FOREIGN KEY (WorkshopID)
        REFERENCES Workshop (WorkshopID),
    FOREIGN KEY (LessonID)
        REFERENCES Lesson (LessonID)
)