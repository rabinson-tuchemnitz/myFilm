----- Create films table
CREATE TYPE VALID_FILM_TYPES AS ENUM ('movie', 'series', 'season', 'episode');
CREATE TABLE films(
	film_id 			SERIAL PRIMARY KEY,
	title 				VARCHAR(30) NOT NULL,
	release_date 		DATE NOT NULL,
	film_type 			VALID_FILM_TYPES NOT NULL,
	subordinated_to 	INT DEFAULT 0,
	production_country  VARCHAR(30) NOT NULL,
	minimum_age 		INT CHECK ( minimum_age > 0 ) NOT NULL,
	image_path 			VARCHAR(50),
	description 		TEXT, 
	duration			VARCHAR,
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
---------------------------------------------------------------------------------------------
-- Create persons table
CREATE TYPE PERSON_ROLE_TYPE AS ENUM ('producer', 'director', 'actor', 'actress');
CREATE TYPE GENDER_TYPE AS ENUM ('male', 'female', 'others');

CREATE TABLE IF NOT EXISTS persons(
	person_id			SERIAL 		PRIMARY KEY,
	name 				VARCHAR(50) NOT NULL,
    gender				GENDER_TYPE NOT NULL,
    dob		            DATE NOT NULL,
	role 				PERSON_ROLE_TYPE NOT NULL,
	nationality 	    VARCHAR(30) NOT NULL,
	image_path 				VARCHAR(50),
    description 		TEXT,
    created_at 	        TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT valid_dob CHECK (dob < current_date)
);

------------------------------------------------------------------------------------
CREATE TABLE film_persons(
	film_id INT NOT NULL,
	person_id INT NOT NULL,
	
	CONSTRAINT fk_key_films
	FOREIGN KEY(film_id) REFERENCES films(film_id)
	ON DELETE CASCADE,

	CONSTRAINT fk_key_persons
	FOREIGN KEY(person_id) REFERENCES persons(person_id)
	ON DELETE CASCADE
);

---------------------------------------------------------------------------------------------------



-- Create users table
CREATE TYPE user_type AS ENUM ('admin', 'customer');
CREATE TABLE IF NOT EXISTS users(
	user_id		SERIAL 		PRIMARY KEY,
	name 		VARCHAR(50) NOT NULL,
	email 		VARCHAR(30) NOT NULL,
	password	TEXT 		NOT NULL,
	type 		user_type   DEFAULT 'customer',
	description TEXT NULL,
	created_at 	TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
	CONSTRAINT min_password_length CHECK (char_length(password) > 5),
	UNIQUE (email)
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
	review      TEXT,

	PRIMARY KEY (user_id, film_id),
	CONSTRAINT valid_rating CHECK (rating >=0 AND rating <=10)
);


