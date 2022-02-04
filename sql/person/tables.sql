-- Create persons table
CREATE TYPE PERSON_ROLE_TYPE AS ENUM ('producer', 'director', 'actor', 'actress')
CREATE TYPE GENDER_TYPE AS ENUM ('male', 'female', 'others');

CREATE TABLE IF NOT EXISTS persons(
	person_id			SERIAL 		PRIMARY KEY,
	name 				VARCHAR(50) NOT NULL,
    gender				GENDER_TYPE NOT NULL,
    dob		            DATE NOT NULL,
	role 				PERSON_ROLE_TYPE NOT NULL,
	nationality 	    VARCHAR(30) NOT NULL,
    description 		TEXT,
	height				INTEGER,
    created_at 	        TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT positive_height CHECK (height > 0),
    CONSTRAINT valid_dob CHECK (dob < current_date)
);