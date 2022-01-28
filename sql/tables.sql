-- Create films table

CREATE TABLE IF NOT EXISTS films(
	film_id		 SERIAL 	 PRIMARY KEY,
	name 		 VARCHAR(50) NOT NULL,
	release_date DATE 		 NOT NULL,
	description  TEXT,
	minimun_age  INTEGER 	 NOT NULL,
	duration 	 VARCHAR(15) NOT NULL,
    created_at 	 TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT age_more_than_zero CHECK (minimun_age > 0),
	CONSTRAINT duration_string CHECK (duration SIMILAR TO '[0-9]{2}:[0-9]{2}:[0-9]{2}')
);

-- Create persons table

CREATE TABLE IF NOT EXISTS persons(
	person_id			SERIAL 		PRIMARY KEY,
	name 				VARCHAR(50) NOT NULL,
	role 				VARCHAR(10) NOT NULL,
	information 		TEXT,
	country_of_origin 	VARCHAR(30) NOT NULL,
	date_of_birth		DATE		NOT NULL,
	height				INTEGER,
    created_at 	        TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT positive_height CHECK (height > 0)
);

-- Create users table
CREATE TYPE user_type AS ENUM ('admin', 'customer')
CREATE TABLE IF NOT EXISTS users(
	user_id		SERIAL 		PRIMARY KEY,
	name 		VARCHAR(50) NOT NULL,
	email 		VARCHAR(30) NOT NULL,
	password	TEXT 		NOT NULL,
	type 		user_type   DEFAULT 'customer',
	created_at 	TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
	CONSTRAINT min_password_length CHECK (char_length(password) > 5),
	UNIQUE (email)
);


-- Create film_persons table to store the person related to the film

CREATE TABLE IF NOT EXISTS film_persons(
	film_id 	INTEGER REFERENCES films (film_id) ON DELETE CASCADE,
	person_id 	INTEGER REFERENCES persons (person_id) ON DELETE CASCADE,

	PRIMARY KEY (film_id, person_id)
);

-- Create user_films table to store the films watched by user

CREATE TABLE IF NOT EXISTS user_films(
	user_id 	INTEGER REFERENCES users (user_id) ON DELETE CASCADE,
	film_id 	INTEGER REFERENCES films (film_id) ON DELETE CASCADE,

	PRIMARY KEY (user_id, film_id)
);

-- Create ratings table to store the film ratings by user

CREATE TABLE IF NOT EXISTS ratings(
	film_id 	INTEGER REFERENCES films (film_id) ON DELETE CASCADE,
	user_id 	INTEGER REFERENCES users (user_id) ON DELETE CASCADE,
	rating 		INTEGER NOT NULL,    

	PRIMARY KEY (user_id, film_id),
	CONSTRAINT valid_rating CHECK (rating >=0 AND rating <=10)
);

-- Create film_groups table to store the subordinated films

CREATE TABLE IF NOT EXISTS flim_groups(
	group_id	SERIAL 		PRIMARY KEY,
	name 		VARCHAR(50) NULL,
	film_id		INTEGER REFERENCES films(film_id)
);

-- Create genre table to store the possible genre of films

CREATE TABLE IF NOT EXISTS genres(
	genre_id	SERIAL 		PRIMARY KEY,
	name 		VARCHAR(50) NOT NULL
);


-- Create film_genre table to store the film genre relation 

CREATE TABLE IF NOT EXISTS film_genres(
	film_id 	INTEGER REFERENCES films (film_id) ON DELETE CASCADE,
	genre_id 	INTEGER REFERENCES genres (genre_id) ON DELETE CASCADE,

	PRIMARY KEY (film_id, genre_id)
);