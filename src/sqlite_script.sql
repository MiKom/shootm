CREATE TABLE clubs (
	id INTEGER NOT NULL PRIMARY KEY,
	name	VARCHAR(50) NOT NULL,
	city	VARCHAR(30) NOT NULL,
	province VARCHAR(25)
);

CREATE TABLE shooters (
	id INTEGER NOT NULL PRIMARY KEY,
	surname VARCHAR(30) NOT NULL,
	name VARCHAR(20) NOT NULL,
	dateOfBirth DATETIME,
	clubId INTEGER 
		CONSTRAINT fk_clubs_id REFERENCES clubs(id) ON DELETE SET NULL
);

CREATE TRIGGER fksn_shooters_clubId_clubs_id
BEFORE DELETE ON clubs
FOR EACH ROW BEGIN
	UPDATE shooters SET clubId = NULL WHERE shooters.clubId=OLD.id;
END;

CREATE TABLE eventTypes (
	id	INTEGER NOT NULL PRIMARY KEY,
	name	VARCHAR(10) NOT NULL,
	roundCount INTEGER NOT NULL,
	descr	VARCHAR(60)
);

-- Tables up until next comment are for single time events --

CREATE TABLE contests (
	id	INTEGER NOT NULL PRIMARY KEY,
	name	VARCHAR(60),
	eventDate	DATETIME,
	place	VARCHAR(30)
);

CREATE TABLE events (
	id		INTEGER NOT NULL PRIMARY KEY,
	contestId 	INTEGER NOT NULL 
		CONSTRAINT fk_contests_id REFERENCES contests(id) ON DELETE CASCADE,
	eventTypeId 	INTEGER NOT NULL 
		CONSTRAINT fk_eventtypes_id REFERENCES eventTypes(id) ON DELETE CASCADE,
	descr		VARCHAR(60)
);

CREATE TRIGGER fkdc_events_contestId_contest_id
BEFORE DELETE ON contests
FOR EACH ROW BEGIN 
    DELETE FROM events WHERE events.contestId = OLD.id;
END;

CREATE TRIGGER fkdc_events_eventTypeId_eventTypes_id
BEFORE DELETE ON eventTypes
FOR EACH ROW BEGIN
	DELETE FROM events WHERE events.eventTypeId=OLD.id;
END;

CREATE TABLE results (
	id		INTEGER NOT NULL PRIMARY KEY,
	shooterId	INTEGER NOT NULL 
		CONSTRAINT fk_shooters_id REFERENCES shooters(id) ON DELETE CASCADE,
	clubId		INTEGER 
		CONSTRAING fk_clubs_id REFERENCES clubs(id) ON DELETE SET NULL,
	eventId		INTEGER NOT NULL 
		CONSTRAINT fk_events_id REFERENCES events(id) ON DELETE CASCADE
);

CREATE TRIGGER fkdc_results_shooterId_shooters_id
BEFORE DELETE ON shooters
FOR EACH ROW BEGIN
	DELETE FROM results WHERE shooterId = OLD.id;
END;

CREATE TRIGGER fksn_results_clubId_clubs_id
BEFORE DELETE ON clubs
FOR EACH ROW BEGIN
	UPDATE results SET clubId = NULL WHERE results.clubId = OLD.id;
END;

CREATE TRIGGER fkdc_results_eventId_events_id
BEFORE DELETE ON events
FOR EACH ROW BEGIN
	DELETE FROM results WHERE results.eventId = OLD.id;
END;

CREATE TABLE rounds (
	id		INTEGER NOT NULL PRIMARY KEY,
	resultId 	INTEGER NOT NULL REFERENCES results(id) ON DELETE CASCADE,
	roundResult	FLOAT NOT NULL CHECK(roundResult>=0.0 AND roundResult<=109.0),
	roundNum	TINYINT NOT NULL CHECK(roundNum>0)
);

-- These tables are for cyclical contests, that's why their names start with c --

CREATE TABLE cycles (
	id	INTEGER NOT NULL PRIMARY KEY,
	name	VARCHAR(60)
);

CREATE TABLE cEvents (
	id		INTEGER NOT NULL PRIMARY KEY,
	cycleId 	INTEGER NOT NULL REFERENCES cycles(id) ON DELETE CASCADE,
	eventTypeId 	INTEGER NOT NULL REFERENCES eventTypes(id) ON DELETE CASCADE,
	descr		VARCHAR(60)
);

CREATE TRIGGER fkdc_cEvents_cycleId_cycles_id
BEFORE DELETE ON cycles
FOR EACH ROW BEGIN
	DELETE FROM cEvents WHERE cEvents.cycleId = OLD.id;
END;

CREATE TRIGGER fkdc_cEvents_eventTypeId_eventTypes_id
BEFORE DELETE ON eventTypes
FOR EACH ROW BEGIN
	DELETE FROM cEvents WHERE cEvents.eventTypeId = OLD.id;
END;

CREATE TABLE cContests (
	id	INTEGER NOT NULL PRIMARY KEY,
	cycleId INTEGER NOT NULL REFERENCES cycles(id) ON DELETE CASCADE,
	name	VARCHAR(60),
	eventDate	DATETIME,
	posInCycle	INTEGER NOT NULL CHECK(posInCycle>0),
	place	VARCHAR(30)
);

CREATE TRIGGER fkdc_cContests_cycleId_cycles_id
BEFORE DELETE ON cycles
FOR EACH ROW BEGIN
	DELETE FROM cContests WHERE cContests.cycleId = OLD.id;
END;

CREATE TABLE cResults (
	id		INTEGER NOT NULL PRIMARY KEY,
	shooterId	INTEGER NOT NULL REFERENCES shooters(id) ON DELETE CASCADE,
	clubId		INTEGER REFERENCES clubs(id) ON DELETE SET NULL,
	cContestId 	INTEGER NOT NULL REFERENCES cContests(id) ON DELETE CASCADE,
	cEventId	INTEGER NOT NULL REFERENCES cEvents(id) ON DELETE CASCADE
);

CREATE TRIGGER fkdc_cResults_shooterId_shooters_id
BEFORE DELETE ON shooters
FOR EACH ROW BEGIN
	DELETE FROM cResults WHERE cResults.shooterId = OLD.id;
END;

CREATE TRIGGER fksn_cResults_clubId_clubs_id
BEFORE DELETE ON clubs
FOR EACH ROW BEGIN
	UPDATE cResults SET clubId = NULL WHERE cResults.clubId = OLD.id;
END;

CREATE TRIGGER fkdc_cResults_cContestId_cContests_id
BEFORE DELETE ON cContests
FOR EACH ROW BEGIN
	DELETE FROM cResults WHERE cResults.cContestId = OLD.id;
END;

CREATE TRIGGER fkcd_cResults_cEventId_cEvents_id
BEFORE DELETE ON cEvents
FOR EACH ROW BEGIN
	DELETE FROM cResults WHERE cResults.cEventId = OLD.id;
END;

CREATE TABLE cRounds (
	id		INTEGER NOT NULL PRIMARY KEY,
	cResultId	INTEGER NOT NULL REFERENCES cResults(id) ON DELETE CASCADE,
	roundResult	FLOAT NOT NULL CHECK(roundResult>=0.0 AND roundResult<=109.0),
	roundNum	TINYINT NOT NULL CHECK(roundNum>0)
);

CREATE TRIGGER fkdc_cRounds_cResultId_cResults_id
BEFORE DELETE ON cResults
FOR EACH ROW BEGIN
	DELETE FROM cRounds WHERE cRounds.cResultId = OLD.id;
END;	
