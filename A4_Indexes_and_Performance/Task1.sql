-- orginal queries given
explain
select firstName,lastName from PlayerInfo
	inner join GamePlaysPlayers using (playerID)
	inner join GamePlays using (gameID,playNumber)
where playerRole = 'Scorer' and 
	  dateTime = (
		select min(dateTime) from Game
			inner join GamePlays using (gameID)
			inner join TeamInfo on (teamIDfor = teamID)
		where playType = 'Goal' and
			  name = 'Maple Leafs' and
			  season = 20192020);

explain analyze 
select firstName,lastName from PlayerInfo inner join GamePlaysPlayers using (playerID) inner join GamePlays using (gameID,playNumber) where playerRole = 'Scorer' and dateTime = ( select min(dateTime) from Game inner join GamePlays using (gameID) inner join TeamInfo on (teamIDfor = teamID) where playType = 'Goal' and name = 'Maple Leafs' and season = 20192020);

explain
with FirstGoalTime as(
	select gameID
		,playNumber
	from GamePlays
	where dateTime = (
		select min(dateTime) from Game
			inner join GamePlays using (gameID)
			inner join TeamInfo on (teamIDfor = teamID)
		where playType = 'Goal' and
			  name = 'Maple Leafs' and
			  season = 20192020)
)
,player as(
	select playerID from GamePlaysPlayers
		where (gameID, playNumber) in (select gameID, playNumber from FirstGoalTime)
		and playerRole = 'Scorer'
)
select firstName,lastName 
from PlayerInfo
where playerID = (select playerID from player);


--analyze commands
ANALYZE
    TABLE tbl_name
    UPDATE HISTOGRAM ON col_name [, col_name] ...

ANALYZE
    TABLE GamePlays
    UPDATE HISTOGRAM ON playType;
	
ANALYZE
    TABLE GamePlaysPlayers
    UPDATE HISTOGRAM ON playerRole;

ANALYZE
    TABLE TeamInfo
    UPDATE HISTOGRAM ON name;

ANALYZE
    TABLE Game
    UPDATE HISTOGRAM ON season;
	
--Task 2
CREATE [UNIQUE | FULLTEXT | SPATIAL] INDEX index_name
    [index_type]
    ON tbl_name (key_part,...)
    [index_option]
    [algorithm_option | lock_option] ...

key_part: {col_name [(length)] | (expr)} [ASC | DESC]


--Task 3
CREATE INDEX teamName_idx 
    ON TeamInfo (name);
original qry 0.8
my qry 0.7

--extra exploration, they are added on top of each other
--meaning that all the idexes added with previous codes also exists
CREATE INDEX playType_idx 
    ON GamePlays (playType);
original qry 0.96
my qry 0.50

CREATE INDEX season_idx 
    ON Game (season);
original qry 0.71
my qry 0.85

drop INDEX teamName_idx ON TeamInfo;
drop INDEX playType_idx ON GamePlays;
drop INDEX season_idx ON Game;
