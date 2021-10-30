drop table if exists BetterGameGoals;
drop table if exists BetterGamePlays;

-- create the tables BetterGamePlays & BetterGameGoals
CREATE TABLE BetterGamePlays LIKE GamePlays; --contain both playID and gameID
CREATE TABLE BetterGameGoals LIKE GameGoals; --contain only playID

-- Modify these tables to add the attributes
-- • gameID (if necessary)
-- • playNumber
ALTER TABLE BetterGamePlays ADD COLUMN playNumber DECIMAL(3) AFTER gameID;
ALTER TABLE BetterGameGoals ADD COLUMN gameID DECIMAL(10) FIRST,
                            ADD COLUMN playNumber DECIMAL(3) AFTER gameID;

-- Modify these tables a second time by using “ALTER TABLE ... DROP COLUMN” to remove the playID attribute
ALTER TABLE BetterGamePlays DROP COLUMN playID;
ALTER TABLE BetterGameGoals DROP COLUMN playID;

-- Populate these new tables from the original tables, GamePlays and GameGoals. You will need to use regexp in this operation.

-- • Get rid of the original tables, GamePlays and GameGoals by using “DROP TABLE”
-- • Create views GamePlays and GameGoals, based on BetterGamePlays and BetterGameGoals, that have an identical schema to the original GamePlays and GameGoals tables
