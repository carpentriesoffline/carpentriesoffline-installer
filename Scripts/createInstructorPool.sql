-- HelperPool definition

CREATE TABLE InstructorPool (
                                PersonID TEXT PRIMARY KEY,
                                FOREIGN KEY (PersonID)
                                    REFERENCES Person (PersonID)
);
