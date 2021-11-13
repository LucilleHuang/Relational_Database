-- Q1 start
SELECT DISTINCT penaltySeverity
FROM GamePenalties;
-- Q1 end

-- Q2 start
SELECT COUNT(DISTINCT playType)
FROM GamePlays;
-- Q2 end

-- Q3 start
WITH PbT AS 
	(SELECT playType,
			COUNT(playID) AS numPlays
		FROM GamePlays
		GROUP BY playType)
SELECT playType
	FROM PbT
	WHERE numPlays =
	(SELECT MAX(numPlays)
		FROM PbT);
-- Q3 end

--Q4 start
WITH PbT AS 
	(SELECT playType,
			COUNT(playID) AS numPlays
		FROM GamePlays INNER JOIN Game USING(gameID)
		WHERE gameType = 'P'
		GROUP BY playType)
SELECT playType
	FROM PbT
	WHERE numPlays =
	(SELECT MAX(numPlays)
		FROM PbT);
-- Q4 end