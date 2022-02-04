----- Create films table
CREATE TYPE VALID_FILM_TYPES AS ENUM ('movie', 'series')

CREATE TABLE films(
	film_id 			SERIAL PRIMARY KEY,
	title 				VARCHAR(30) NOT NULL,
	release_date 		DATE NOT NULL,
	film_type 			VALID_FILM_TYPES NOT NULL,
	subordinated_to 	INT DEFAULT NULL,
	production_country  VARCHAR(30) NOT NULL,
	minimum_age 		INT CHECK ( minimum_age > 0 ) NOT NULL,
	image_path 			VARCHAR(50),
	description 		TEXT, 
	duration			TEXT,
	created_at 	 TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT age_more_than_zero CHECK (minimum_age > 0),
	CONSTRAINT duration_string CHECK (duration SIMILAR TO '[0-9]{2}:[0-9]{2}:[0-9]{2}')
);

----- Create genre table to store the possible genre of films

CREATE TABLE IF NOT EXISTS genres(
	genre_id	SERIAL 		PRIMARY KEY,
	name 		VARCHAR(50) NOT NULL
);


----- Create film_genre table to store the film genre relation 

CREATE TABLE IF NOT EXISTS film_genres(
	film_id 	INTEGER REFERENCES films (film_id) ON DELETE CASCADE,
	genre_id 	INTEGER REFERENCES genres (genre_id) ON DELETE CASCADE,

	PRIMARY KEY (film_id, genre_id)
);

