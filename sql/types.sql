CREATE TYPE GENDER_TYPE AS ENUM ('male', 'female', 'others');
CREATE TYPE BASIC_RESOURCE_TYPE AS (
	id INT,
	title TEXT
)
CREATE TYPE VALID_FILM_TYPES AS ENUM ('movie', 'series', 'season', 'episode')

CREATE TYPE FILM_LIST_ITEM_TYPE AS (
    title TEXT,
    release_date DATE,
    description TEXT,
    duration VARCHAR,
    genre TEXT,
    image_path TEXT,
    persons BASIC_RESOURCE_TYPE[]
)