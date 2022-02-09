


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
	review      TEXT

	PRIMARY KEY (user_id, film_id),
	CONSTRAINT valid_rating CHECK (rating >=0 AND rating <=10)
);


