-- create the tables BetterGamePlays & BetterGameGoals
CREATE TABLE IF NOT EXISTS BetterGamePlays LIKE GamePlays; --contain both playID and gameID
CREATE TABLE IF NOT EXISTS BetterGameGoals LIKE GameGoals; --contain only playID

-- Modify these tables by using “ALTER TABLE ... ADD COLUMN”
-- to add the attributes
-- – gameID (if necessary)
-- – playNumber
ALTER TABLE GamePlays (
ADD COLUMN playNumber  column_definition
        [FIRST | AFTER col_name]
  | ADD [COLUMN] (col_name column_definition,...)

ALTER TABLE tbl_name (
ADD [COLUMN] col_name column_definition
        [FIRST | AFTER col_name]
  | ADD [COLUMN] (col_name column_definition,...)

-- • Modify these tables a second time by using “ALTER TABLE ... DROP
-- COLUMN” to remove the playID attribute
-- • Populate these new tables from the original tables, GamePlays and
-- GameGoals
-- You will need to use regexp in this operation.
-- • Get rid of the original tables, GamePlays and GameGoals by using
-- “DROP TABLE”
-- • Create views GamePlays and GameGoals, based on BetterGame-
-- Plays and BetterGameGoals, that have an identical schema to the
-- original GamePlays and GameGoals tables.