-- NHL Database: Replicate the existing DB with PKs and FKs
-- Uses playNumber not playID

--\! rm -f a4-outfile-replicate.txt;
tee a4-outfile-replicate.txt;

warnings;

drop table if exists GameShifts;
drop table if exists GameScratches;
drop table if exists GamePlaysPlayers;
drop table if exists GamePenalties;
drop table if exists GameOfficials;
drop table if exists GameGoals;
drop table if exists PlayerInfo;
drop table if exists GamePlays;
drop table if exists Game;
drop table if exists TeamInfo;

select '----------------------------------------------------------------' as '';
select 'Create TeamInfo' as '';

create table TeamInfo (teamID int primary key,
       	     	       franchiseID int not null,
		       city char(15) not null,
		       name char(15) not null,
		       abbreviation char(3) unique not null);

insert into TeamInfo table NHL_FK.TeamInfo; 

select '----------------------------------------------------------------' as '';
select 'Create Game' as '';

create table Game (gameID decimal(10) primary key,
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

insert into Game table NHL_FK.Game; 

select '----------------------------------------------------------------' as '';
select 'Create GamePlays' as '';

create table GamePlays (gameID decimal(10),
       	     	        playNumber int,
			teamIDfor int,
			teamIDagainst int,
 			playType varchar(25),
			secondaryType varchar(40),
			x int,
			y int,
			period decimal(1),
			periodType char(8),
			periodTime int,
			periodTimeRemaining int,
			dateTime datetime,
			goalsAway int,
			goalsHome int,
			description varchar(255),
-- Key Constraints
			primary key (gameID, playNumber),
			foreign key (gameID) references Game(gameID),
			foreign key (teamIDfor) references TeamInfo(teamID),
			foreign key (teamIDagainst) references TeamInfo(teamID)
		       );

insert into GamePlays table NHL_FK.GamePlays; 

select '----------------------------------------------------------------' as '';
select 'Create PlayerInfo' as '';

create table PlayerInfo (playerID decimal(7) primary key,
			 firstName char(15),
			 lastName char(20),
			 nationality char(3),
			 birthCity char(30),
			 primaryPosition char(15),
			 birthDate datetime,
			 birthStateProvince char(20),
			 height char(7),
			 heightInCM decimal(5,2),
			 weight decimal(5,2),
			 shootsCatches char(2)
-- Additional Constraints
			 );

insert into PlayerInfo table NHL_FK.PlayerInfo; 

select '----------------------------------------------------------------' as '';
select 'Create GameGoals' as '';

create table GameGoals (gameID decimal(10),
       	     	        playNumber int,
       	     	        strength char(12),
			gameWinningGoal bool,
			emptyNet bool,
-- Key Constraints
			primary key (gameID, playNumber),
			foreign key (gameID, playNumber) references GamePlays (gameID, playNumber)
   		       );

insert into GameGoals table NHL_FK.GameGoals; 

select '----------------------------------------------------------------' as '';
select 'Create GameOfficials' as '';

create table GameOfficials (gameID decimal(10),
       	     		    officialName char(20),
			    officialType char(20),
-- Key Constraints
			    primary key (gameID, officialName),
			    foreign key (gameID) references Game(gameID)
			   );

insert into GameOfficials table NHL_FK.GameOfficials; 

select '----------------------------------------------------------------' as '';
select 'Create GamePenalties' as '';

create table GamePenalties (gameID decimal(10),
       	     	            playNumber int,
              	     	    penaltySeverity char(15),
			    penaltyMinutes decimal(2),
-- Key Constraints
			    primary key (gameID, playNumber),
			    foreign key (gameID, playNumber) references GamePlays(gameID, playNumber)
			   );

insert into GamePenalties table NHL_FK.GamePenalties; 

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlaysPlayers' as '';

create table GamePlaysPlayers (gameID decimal(10),
       	     	               playNumber int,
			       playerID decimal(7),
			       playerRole char(10),
-- Key Constraints
			       primary key (gameID, playNumber, playerID),
			       foreign key (gameID, playNumber) references GamePlays(gameID, playNumber),
			       foreign key (playerID) references PlayerInfo(playerID)
			      );

insert into GamePlaysPlayers table NHL_FK.GamePlaysPlayers; 

select '---------------------------------------------------------------------------------------' as '';
select 'Create GameScratches' as '';

create table GameScratches (gameID decimal(10),
       	     		    teamID int,
			    playerID decimal(7),
-- Key Constraints
			    primary key (gameID, playerID),
			    foreign key (gameID) references Game(gameID),
			    foreign key (teamID) references TeamInfo(teamID),
			    foreign key (playerID) references PlayerInfo(playerID)
			   );			    

insert into GameScratches table NHL_FK.GameScratches; 

select '----------------------------------------------------------------' as '';
select 'Create GameShifts' as '';

create table GameShifts (gameID decimal(10),
       	     		 playerID decimal(7),
			 period decimal(1),
			 start int,
			 end int,
-- Key Constraints
			 primary key (gameID, playerID, start),
			 foreign key (gameID) references Game(gameID),
			 foreign key (playerID) references PlayerInfo(playerID)
			);

insert into GameShifts table NHL_FK.GameShifts; 

nowarning;
notee;
