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
        WHERE film_type = 'movie' AND subordinated_to = 0;
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
        WHERE film_type = 'series' AND subordinated_to = 0;
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
        release_date VARCHAR,
		film_type VARCHAR,
		min_age INT,
		production_country VARCHAR,
		duration VARCHAR,
		image_path VARCHAR,
		genres JSONB, 
		persons JSONB
	)
AS $$
	BEGIN
		RETURN QUERY 
			SELECT 
				films.film_id, CONCAT(films.title, ' (', EXTRACT(YEAR FROM DATE(films.release_date)), ')'),
				to_char(films.release_date,'DD MONTH YYYY')::VARCHAR as release_date,
				films.film_type::VARCHAR, films.minimum_age, films.production_country, 
				films.duration, films.image_path, 
				temp_genres.genres, temp_persons.persons
			FROM films 
 			LEFT JOIN (
 				SELECT film_genres.film_id, jsonb_agg(jsonb_build_object(
 					'id',    genres.genre_id,
 					'title', genres.name
 				)) as genres
 				FROM film_genres 
 				JOIN genres ON genres.genre_id = film_genres.genre_id
				GROUP BY film_genres.film_id
 			) temp_genres ON temp_genres.film_id = films.film_id
			LEFT JOIN (
				SELECT film_persons.film_id, jsonb_agg(jsonb_build_object(
					'id',    persons.person_id,
					'title', CONCAT(persons.name, ' (',  INITCAP(persons.role::VARCHAR), ')')
				)) persons
				FROM film_persons
				JOIN persons ON persons.person_id = film_persons.person_id
				GROUP BY film_persons.film_id
			) temp_persons ON temp_persons.film_id = films.film_id
			WHERE films.film_type in ('series', 'movie');
	END;
$$ LANGUAGE plpgsql;
----------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_film_by_id(i_id int)
	RETURNS TABLE (
		id INT, 
		title TEXT,
        release_date VARCHAR,
		film_type VARCHAR,
		min_age INT,
		production_country VARCHAR,
		duration VARCHAR,
		description TEXT,
		image_path VARCHAR,
		subordinates JSONB,
		genres JSONB, 
		persons JSONB
	)
AS $$
	BEGIN
		RETURN QUERY 
			SELECT 
				films.film_id, CONCAT(films.title, ' (', EXTRACT(YEAR FROM DATE(films.release_date)), ')'),
				to_char(films.release_date,'DD MONTH YYYY')::VARCHAR as release_date,
				films.film_type::VARCHAR, films.minimum_age, films.production_country, 
				films.duration, films.description, films.image_path, 
				temp_films.subordinates, temp_genres.genres, temp_persons.persons
			FROM films 
			
-- 			join the film table with the subordinates list
			LEFT JOIN (
				SELECT films.film_id, films.film_type, jsonb_agg(jsonb_build_object(
				'id', temp_film.film_id,
				'title', CONCAT(temp_film.title, ' (', EXTRACT(YEAR FROM DATE(temp_film.release_date)), ')')
				)) subordinates
				FROM films
				JOIN films as temp_film ON films.film_id = temp_film.subordinated_to
  				WHERE films.film_id = i_id
				GROUP BY films.film_id
			) temp_films ON temp_films.film_id = films.film_id
			
-- 			join the film table with genres list
 			LEFT JOIN (
 				SELECT film_genres.film_id, jsonb_agg(jsonb_build_object(
 					'id',    genres.genre_id,
 					'title', genres.name
 				)) as genres
 				FROM film_genres 
 				JOIN genres ON genres.genre_id = film_genres.genre_id
				WHERE film_genres.film_id = i_id
				GROUP BY film_genres.film_id
 			) temp_genres ON temp_genres.film_id = films.film_id
-- 			join the film table with persons list
			LEFT JOIN (
				SELECT film_persons.film_id, jsonb_agg(jsonb_build_object(
					'id',    persons.person_id,
					'title', CONCAT(persons.name, ' (',  INITCAP(persons.role::VARCHAR), ')')
				)) persons
				FROM film_persons
				JOIN persons ON persons.person_id = film_persons.person_id
				WHERE film_persons.film_id = i_id
				GROUP BY film_persons.film_id
			) temp_persons ON temp_persons.film_id = films.film_id
			WHERE films.film_id = i_id;
	END;
$$ LANGUAGE plpgsql;

-------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_basic_film_by_id(i_id INT)
	RETURNS TABLE (
		id INT, 
		title VARCHAR,
        release_date DATE,
		film_type VALID_FILM_TYPES,
		min_age INT,
		production_country VARCHAR,
		duration VARCHAR,
		image_path VARCHAR
	)
AS $$
	BEGIN
		RETURN QUERY
			SELECT 
				films.film_id, films.title, films.release_date, films.film_type,
				films.minimum_age, films.production_country, films.duration, films.image_path
			FROM films
			WHERE films.film_id = i_id;
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


-----------------------------------
CREATE OR REPLACE FUNCTION delete_film(i_film_id INT) 
    RETURNS BOOL
AS $$
BEGIN
    IF (i_film_id IS NULL) THEN
        RAISE EXCEPTION 'Validation Error: Id film is required';
        RETURN FALSE;
    ELSE
        DELETE FROM films WHERE films.film_id = i_film_id;
        RETURN TRUE;
    END IF;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE function delete_subordinated_films() 
    RETURNS TRIGGER 
AS $$
BEGIN
    DELETE FROM films WHERE subordinated_to = old.film_id;
    RETURN old;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER delete_film_linkage
AFTER DELETE ON films
FOR EACH ROW EXECUTE PROCEDURE delete_subordinated_films();


--------------------------------------------------------------------------------