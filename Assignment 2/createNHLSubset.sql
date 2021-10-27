-- NHL 356 Database

tee a2-outfile.txt;

drop table if exists GameGoals;
drop table if exists GamePlays;
drop table if exists Game;

select '---------------------------------------------------------------------------------------' as '';
-- Game Information: note that the ignore option on data loading means that a few thousand duplicate
-- primary keys are rejected, but so are half-a-dozen foreign key constraint violations
-- If replace is used, it will override the existing PK data but will get a rejection on an FK violation

select 'Create Game' as '';

create table Game (gameID decimal(10),
       	     	   season decimal(8),
		   gameType char(1),
		   dateTimeGMT datetime,
		   awayTeamID int,
		   homeTeamID int,
		   awayGoals int check(awayGoals >= 0),
		   homeGoals int check(homeGoals >= 0),
		   outcome char(12),
		   homeRinkSideStart char(50),
		   venue varchar(64),
		   venueTimeZoneID char(20),
		   venueTimeZoneOffset char(50),
		   venueTimeZoneTZ char(3) not null
		  );

create index GPKSubstitute on Game(gameID);

load data infile '/var/lib/mysql-files/NHL_356/game.csv' ignore into table Game
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n';

show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlays' as '';

create table GamePlays (playID char(14),
			gameID decimal(10),
			teamIDfor char(4),
			teamIDagainst char(4),
			playType varchar(25),
			secondaryType varchar(40),
			x char(4),
			y char(4),
			period decimal(1),
			periodType char(8),
			periodTime int,
			periodTimeRemaining char(4),
			dateTime datetime,
			goalsAway int,
			goalsHome int,
			description varchar(255)
-- Additional Constraints
		       );

create index GPPKSubstituteIndex on GamePlays(playID);
create index GPgameIDIndex on GamePlays(gameID);

load data infile '/var/lib/mysql-files/NHL_356/game_plays.csv' ignore into table GamePlays
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n';
--     ignore 1 lines;

show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
select 'Create GameGoals' as '';

create table GameGoals (playID char(14), -- primary key,
       	     	        strength char(12),
			gameWinningGoal char(5),
			emptyNet char(5)
-- Additional Constraints
   		       );

create index GGPKSubstitute on GameGoals(playID);

load data infile '/var/lib/mysql-files/NHL_356/game_goals.csv' ignore into table GameGoals
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n';
--     ignore 1 lines;

show warnings limit 10;

