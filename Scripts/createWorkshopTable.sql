-- WorkshopTable definition

CREATE TABLE
(
    WorkshopID               TEXT PRIMARY KEY,
    WorkshopName             TEXT,
    StartDate                TEXT,
    EndDate                  TEXT,
    StartTime                TEXT,
    EndTime                  TEXT,
    CommunityDocURL          TEXT,
    PreWorkshopSurvey        TEXT,
    PostWorkshopSurvey       TEXT,
    SurveyResults            TEXT,
    Host                     TEXT,
    HostInstitution          TEXT,
    WorkshopWebsite          TEXT,
    EmailReminderDate        TEXT, -- default to 2 weeks before ws
    PostWSSurveyReminderDate TEXT  -- default to day after end of ws
);



