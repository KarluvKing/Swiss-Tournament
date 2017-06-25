-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

CREATE DATABASE tournament;

\c tournament

CREATE TABLE players (id SERIAL PRIMARY KEY, name TEXT);

CREATE TABLE match (id SERIAL PRIMARY KEY,
	                player_winner INTEGER REFERENCES players(id),
	                player_loser INTEGER REFERENCES players(id));

-- view play WINS --
CREATE VIEW Vplay_wins AS
SELECT players.id, players.name, COUNT(match.player_winner) AS player_win
FROM players LEFT OUTER JOIN match 
ON players.id = match.player_winner
GROUP BY players.name, players.id
ORDER BY player_win;

-- view play LOSES --
CREATE VIEW Vplay_lose AS
SELECT players.id, players.name, COUNT(match.player_loser) AS player_loser
FROM players LEFT OUTER JOIN match 
ON players.id = match.player_loser
GROUP BY players.name, players.id
ORDER BY player_loser;

-- view final result --
CREATE VIEW Vplay_total AS
SELECT Vplay_wins.id AS id_player, Vplay_wins.name AS player, Vplay_wins.player_win AS win_games, 
       Vplay_wins.player_win + Vplay_lose.player_loser AS total_games
FROM Vplay_lose INNER JOIN Vplay_wins 
ON Vplay_lose.id = Vplay_wins.id
ORDER BY win_games DESC;