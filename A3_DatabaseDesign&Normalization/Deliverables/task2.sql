--Pk, FK, not Null

create table NonExecutablePlays(
    playNumber          int         not null,
    dateTime            datetime,
    playType            varchar(25),
    period              decimal(1,0),
    periodType          char(8),
    periodTime          int,
    periodTimeRemaining int,
    description         varchar(255),
    primary key (playNumber)
);

create table Game(
    gameID      decimal(10,0)    not null,
    gameType    char(1),
    primary key (gameID)
);

create table PlayerInfo(
    playerID    decimal(7,0)    not null,
    primary key (playerID)
);

create table GamePlaysPlayers(
    gameID      decimal(10,0)   not null,
    playNumber  int             not null,
    playerID    decimal(7,0)    not null,
    playerRole  char(10),
    primary key (gameID, playNumber, playerID),
    foreign key (gameID) references Game(gameID),
    foreign key (playNumber) references NonExecutablePlays(playNumber),
    foreign key (playerID) references PlayerInfo(playerID)
);

create table TeamInfo(
    teamID      int     not null,
    primary key (teamID)
);

create table GamePlaysPlayers2(
    gameID          decimal(10,0)   not null,
    playNumber      int             not null,
    playerID        decimal(7,0)    not null,
    teamIDfor       int             not null,
    teamIDagainst   int             not null,
    primary key (gameID, playNumber, playerID),
    foreign key (gameID) references GamePlaysPlayers(gameID),
    foreign key (playNumber) references GamePlaysPlayers(playNumber),
    foreign key (playerID) references GamePlaysPlayers(playerID),
    foreign key (teamIDfor) references TeamInfo(teamID),
    foreign key (teamIDagainst) references TeamInfo(teamID),
);

create table ExecutablePlays(
    playNumber  int         not null,
    x           int,
    y           int,
    primary key (playNumber),
    foreign key (playNumber) references NonExecutablePlays(playNumber)
);

create table GameShots(
    playNumber      int         not null,
    secondaryType   varchar(40),
    primary key (playNumber),
    foreign key (playNumber) references ExecutablePlays(playNumber)
);

create table GamePenalties(
    playNumber      int         not null,
    penaltySeverity char(15), 
    penaltyMinutes  decimal(2,0),
    secondaryType   varchar(40),
    primary key (playNumber),
    foreign key (playNumber) references ExecutablePlays(playNumber)
);

create table GameGoals(
    playNumber      int         not null,
    strength        char(12),
    gameWinningGoal tinyint(1),
    emptyNet        tinyint(1),
    secondaryType   varchar(40),
    primary key (playNumber),
    foreign key (playNumber) references ExecutablePlays(playNumber)
);

create table GamePlaysPlayers3(
    gameID          decimal(10,0)   not null,
    playNumber      int             not null,
    playerID        decimal(7,0)    not null,
    playerRole      char(10)        not null,
    primary key (gameID, playNumber, playerID),
    foreign key (gameID) references GamePlaysPlayers2(gameID),
    foreign key (playNumber) references GamePlaysPlayers2(playNumber),
    foreign key (playerID) references GamePlaysPlayers2(playerID)
);