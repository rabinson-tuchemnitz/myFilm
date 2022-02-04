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

CREATE OR REPLACE FUNCTION get_non_subordinated_films ()
    RETURNS TABLE (
        id INT,
        title VARCHAR
    )
AS $$
BEGIN
    RETURN QUERY 
        SELECT films.film_id, films.title
        FROM films
        WHERE subordinated_to IS NULL;
END;
$$ LANGUAGE plpgsql;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE OR REPLACE FUNCTION insert_film (
	title 				VARCHAR(30),
	release_date 		DATE,
	film_type 			VALID_FILM_TYPES,
	production_country 	VARCHAR(20),
	minimum_age 		INT,
	duration			TEXT DEFAULT NULL,
	subordinated_to 	INT DEFAULT NULL,
	image_path 			VARCHAR(20) DEFAULT NULL,
	description 		TEXT DEFAULT NULL
) 
    RETURNS BOOL
AS $$
	BEGIN
        IF (
            (title IS NULL) OR (release_date IS NULL) OR (film_type IS NULL) 
            OR (production_country IS NULL) OR (minimum_age IS NULL)
        ) THEN
            RAISE EXCEPTION 'Validation Error: Provide all required fields';
            RETURN FALSE;
        ELSE
            INSERT INTO films (title, release_date, film_type, production_country, minimum_age, 
                subordinated_to, image_path, description) 
            VALUES (title, release_date, film_type, production_country, minimum_age, 
                subordinated_to, image_path, description);												
            
            RETURN TRUE;
        END IF;
	END;
$$ LANGUAGE plpgsql;

SELECT insert_film(title:='new film', film_type:='movie', release_date:='2021-01-01', production_country:='Germany', minimum_age:=13)

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
