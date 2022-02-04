---------------------------FUNCTIONS START ------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE OR REPLACE FUNCTION get_genres ()
    RETURNS TABLE (
        id INT,
        name VARCHAR
    )
AS $$
BEGIN
    RETURN QUERY 
        SELECT genres.genre_id, genres.name
        FROM genres;
END;
$$ LANGUAGE plpgsql;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE OR REPLACE FUNCTION get_non_subordinated_movies ()
    RETURNS TABLE (
        id INT,
        title TEXT
    )
AS $$
BEGIN
    RETURN QUERY 
        SELECT films.film_id, CONCAT(films.title, ' (', EXTRACT(YEAR FROM DATE (films.release_date)) ,')')
        FROM films
        WHERE film_type = 'movie' AND subordinated_to IS NULL;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_non_subordinated_series ()
    RETURNS TABLE (
        id INT,
        title TEXT
    )
AS $$
BEGIN
    RETURN QUERY 
        SELECT films.film_id, CONCAT(films.title, ' (', EXTRACT(YEAR FROM DATE (films.release_date)) ,')')
        FROM films
        WHERE film_type = 'series' AND subordinated_to IS NULL;
END;
$$ LANGUAGE plpgsql;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE OR REPLACE FUNCTION insert_film_genres(film_id INT, genre_id_array INT[]) 
    RETURNS BOOL 
AS $$
    DECLARE
    genre_id INT;
    BEGIN
        IF((film_id IS NULL) OR (array_length(genre_id_array, 1) = 0)) THEN
            RETURN FALSE;
        ELSE
            FOREACH genre_id IN ARRAY genre_id_array LOOP
                INSERT INTO film_genres VALUES(film_id, genre_id);
            END LOOP;
        RETURN TRUE;
        END IF;
    END;
$$ LANGUAGE plpgsql;
-------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION insert_film_persons(film_id INT, person_id_array INT[]) 
    RETURNS BOOL 
AS $$
    DECLARE
    person_id INT;
    BEGIN
        IF((film_id IS NULL) OR (array_length(person_id_array, 1) = 0)) THEN
            RETURN FALSE;
        ELSE
            FOREACH person_id IN ARRAY person_id_array LOOP
                INSERT INTO film_persons VALUES(film_id, person_id);
            END LOOP;
        RETURN TRUE;
        END IF;
    END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION insert_film (
	title 				VARCHAR(30),
	release_date 		DATE,
	film_type 			VALID_FILM_TYPES,
	production_country 	VARCHAR(20),
	minimum_age 		INT,
	persons				INT [],
	genres				INT [],
	duration			TEXT DEFAULT NULL,
	subordinated_to 	INT DEFAULT 0,
	image_path 			VARCHAR(20) DEFAULT NULL,
	description 		TEXT DEFAULT ""
) 
    RETURNS INT
AS $$
	DECLARE
		created_film_id INT;
	BEGIN
-- 		Check for required field
        IF (
            (title IS NULL) OR (release_date IS NULL) OR (film_type IS NULL) 
            OR (production_country IS NULL) OR (minimum_age IS NULL) 
			OR (array_length(genres, 1) < 1)
			OR (array_length(persons, 1) < 1)
        ) THEN
            RAISE EXCEPTION 'Validation Error: Provide all required fields';
            RETURN 0;
        ELSE
-- 			Insert new film in films table
            INSERT INTO films (title, release_date, film_type, production_country, minimum_age, 
                subordinated_to, image_path, description) 
            VALUES (title, release_date, film_type, production_country, minimum_age, 
                subordinated_to, image_path, description)
			RETURNING films.film_id INTO created_film_id;
			
-- 			Insert film_genres relation records
			PERFORM insert_film_genres(created_film_id, genres);
			
-- 			Insert film_persons relation records
			PERFORM insert_film_persons(created_film_id, persons);
            
            RETURN create_film_id;
        END IF;
	END;
$$ LANGUAGE plpgsql;
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CREATE OR REPLACE FUNCTION get_film_list()
	RETURNS TABLE (
		id INT, 
		title TEXT,
		description TEXT,
		image_path VARCHAR,
		genres JSONB, 
		persons JSONB
	)
AS $$
	BEGIN
		RETURN QUERY 
			SELECT 
			films.film_id, CONCAT(films.title, ' (', EXTRACT(YEAR FROM DATE(films.release_date)), ')'), 
			films.description, films.image_path, jsonb_agg(temp1.genres), jsonb_agg(temp2.persons)
			FROM films 
			LEFT JOIN (
				SELECT film_genres.film_id, jsonb_build_object(
					'id', genres.genre_id,
					'title', genres.name
				) genres
				FROM film_genres 
				JOIN genres ON genres.genre_id = film_genres.genre_id
			) temp1 ON temp1.film_id = films.film_id
			LEFT JOIN (
				SELECT film_persons.film_id, jsonb_build_object(
					'id', persons.person_id,
					'title', CONCAT(persons.name, ' (',  INITCAP(persons.role::VARCHAR), ')')
				) persons
				FROM film_persons
				JOIN persons ON persons.person_id = film_persons.person_id
			) temp2 ON temp2.film_id = films.film_id
			
			GROUP BY films.film_id;
	END;
$$ LANGUAGE plpgsql;


----------------------------- FUNCTIONS END -----------------------------------------


CREATE OR REPLACE FUNCTION get_film (p_pattern VARCHAR) 
    RETURNS TABLE (
        film_title VARCHAR,
        film_release_year INT
) 
AS $$
BEGIN
    RETURN QUERY SELECT
        title,
        cast( release_year as integer)
    FROM
        films
    WHERE
        title ILIKE p_pattern ;
END; $$ 

LANGUAGE 'plpgsql';


----------------

CREATE OR REPLACE FUNCTION get_film (i_pattern TEXT, i_year INT) 
    RETURNS TABLE (
        o_title 			VARCHAR,
		o_description     	TEXT
        o_release_year  	INT
) AS $$
DECLARE 
    var_r record;
BEGIN
    FOR var_r IN(SELECT 
                title, 
				description,
                YEAR(CAST(release_date as DATE) AS release_year 
                FROM films 
                WHERE title ILIKE p_pattern AND 
                release_year = p_year)  
    LOOP
        o_title 		:= upper(var_r.title) ; 
        o_release_year 	:= var_r.release_year;
        RETURN NEXT;
    END LOOP;
END; $$ 
LANGUAGE 'plpgsql';
