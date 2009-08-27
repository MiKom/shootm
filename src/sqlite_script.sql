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
	clubId INTEGER REFERENCES clubs(id) ON DELETE SET NULL
);

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
	contestId 	INTEGER NOT NULL REFERENCES contests(id) ON DELETE CASCADE,
	eventTypeId 	INTEGER NOT NULL REFERENCES eventTypes(id) ON DELETE SET NULL,
	descr		VARCHAR(60)
);

CREATE TABLE results (
	id		INTEGER NOT NULL PRIMARY KEY,
	shooterId	INTEGER NOT NULL REFERENCES shooters(id) ON DELETE CASCADE,
	clubId		INTEGER REFERENCES clubs(id) ON DELETE SET NULL,
	eventId		INTEGER NOT NULL REFERENCES events(id) ON DELETE CASCADE
);

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
	id	INTEGER NOT NULL PRIMARY KEY,
	cycleId INTEGER NOT NULL REFERENCES cycles(id) ON DELETE CASCADE,
	eventTypeId 	INTEGER NOT NULL REFERENCES eventTypes(id) ON DELETE SET NULL,
	descr		VARCHAR(60)
);


CREATE TABLE cContests (
	id	INTEGER NOT NULL PRIMARY KEY,
	cycleId INTEGER NOT NULL REFERENCES cycles(id),
	name	VARCHAR(60),
	eventDate	DATETIME,
	posInCycle	INTEGER NOT NULL CHECK(posInCycle>0),
	place	VARCHAR(30)
);

CREATE TABLE cResults (
	id		INTEGER NOT NULL PRIMARY KEY,
	shooterId	INTEGER NOT NULL REFERENCES shooters(id) ON DELETE CASCADE,
	clubId		INTEGER REFERENCES clubs(id) ON DELETE SET NULL,
	cContestId 	INTEGER NOT NULL REFERENCES cContests(id) ON DELETE CASCADE,
	cEventId	INTEGER NOT NULL REFERENCES cEvents(id) ON DELETE CASCADE
);

CREATE TABLE cRounds (
	id		INTEGER NOT NULL PRIMARY KEY,
	cResultId	INTEGER NOT NULL REFERENCES cResults(id) ON DELETE CASCADE,
	roundResult	FLOAT NOT NULL CHECK(roundResult>=0.0 AND roundResult<=109.0),
	roundNum	TINYINT NOT NULL CHECK(roundNum>0)
);	
