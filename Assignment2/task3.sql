ALTER TABLE Game ADD PRIMARY KEY (gameID);

ALTER TABLE BetterGamePlays ADD PRIMARY KEY (gameID, playNumber),
                            ADD FOREIGN KEY (gameID) REFERENCES Game(gameID);

ALTER TABLE BetterGameGoals ADD PRIMARY KEY (gameID, playNumber),
                            ADD FOREIGN KEY (gameID) REFERENCES Game(gameID);