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

