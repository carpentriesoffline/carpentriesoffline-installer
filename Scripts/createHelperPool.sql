-- InstructorPool definition

CREATE TABLE HelperPool (
    PersonID TEXT PRIMARY KEY,
    Active TEXT NOT NULL,
    FOREIGN KEY (PersonID)
        REFERENCES Person (PersonID)
);
