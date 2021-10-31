DROP TABLE IF EXISTS BetterGameGoals;
DROP TABLE IF EXISTS BetterGamePlays;

-- create the tables BetterGamePlays & BetterGameGoals
CREATE TABLE BetterGamePlays LIKE GamePlays;
CREATE TABLE BetterGameGoals LIKE GameGoals;

-- Modify these tables to add the attributes gameID (if necessary), playNumber
ALTER TABLE BetterGamePlays ADD COLUMN playNumber DECIMAL(3) AFTER gameID;
ALTER TABLE BetterGameGoals ADD COLUMN gameID DECIMAL(10) FIRST,
                            ADD COLUMN playNumber DECIMAL(3) AFTER gameID;

-- Modify these tables a second time to remove the playID attribute
ALTER TABLE BetterGamePlays DROP COLUMN playID;
ALTER TABLE BetterGameGoals DROP COLUMN playID;

-- Populate these new tables from the original tables, GamePlays and GameGoals
INSERT INTO BetterGamePlays
  SELECT
    CAST(LEFT(playID, REGEXP_INSTR(playID, '_') - 1) AS DECIMAL(10)) AS gameID,
    CAST(RIGHT(playID, CHAR_LENGTH(playID) - REGEXP_INSTR(playID, '_')) AS DECIMAL(3)) AS playNumber,
    teamIDfor,
    teamIDagainst,
    playType,
    secondaryType,
    x,
    y,
    period,
    periodType,
    periodTime,
    periodTimeRemaining,
    dateTime,
    goalsAway,
    goalsHome,
    description    
  FROM GamePlays;

INSERT INTO BetterGameGoals
  SELECT
    CAST(LEFT(playID, REGEXP_INSTR(playID, '_') - 1) AS DECIMAL(10)) AS gameID,
    CAST(RIGHT(playID, CHAR_LENGTH(playID) - REGEXP_INSTR(playID, '_')) AS DECIMAL(3)) AS playNumber,
    strength,
    gameWinningGoal,
    emptyNet
  FROM GameGoals;

-- Get rid of the original tables, GamePlays and GameGoals by using “DROP TABLE”
DROP TABLE IF EXISTS GameGoals;
DROP TABLE IF EXISTS GamePlays;

-- • Create views GamePlays and GameGoals, based on BetterGamePlays and BetterGameGoals, that have an identical schema to the original GamePlays and GameGoals tables
