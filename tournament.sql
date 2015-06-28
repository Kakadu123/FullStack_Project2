-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.


-- Table with player details

CREATE TABLE players (
			id SERIAL PRIMARY KEY,
			name TEXT
                      );

-- Table with match details

CREATE TABLE matches (
			id SERIAL PRIMARY KEY,
			winner INTEGER REFERENCES players (id),
			loser INTEGER REFERENCES players (id),
                      );

-- View counting wins by player

CREATE VIEW wins AS
			SELECT
				winner,
				count(winner)
			FROM
				matches
			GROUP BY
				winner
;

-- View counting loses by player

CREATE VIEW loses AS
			SELECT
				loser,
				count(loser)
			FROM
				matches
			GROUP BY
				loser
;

-- View counting matches by player

CREATE VIEW matchesByPlayer AS
			SELECT
				p.id,
				p.name,
				0 + COALESCE(w.count, 0) + COALESCE(l.count, 0) AS Count
			FROM
				players AS p
			LEFT JOIN
				wins AS w
			ON w.winner = p.id
			LEFT JOIN
				loses AS l
			ON l.loser = p.id
;

-- View consolidating player details, wins and matches by player

CREATE VIEW playerStanding AS
			SELECT
				m.id,
				m.name,
				COALESCE(w.count, 0) AS wins,
				m.Count AS matches
			FROM
				matchesByPlayer AS m
			LEFT JOIN
				wins AS w
			ON w.winner = m.id
			ORDER BY
				wins DESC
;
