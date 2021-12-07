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

CREATE INDEX teamName_idx 
    ON TeamInfo (name);