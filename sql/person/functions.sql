---------------------------FUNCTIONS START ------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE OR REPLACE FUNCTION insert_person (
	name VARCHAR(50),
    gender GENDER_TYPE,
    dob DATE,
    nationality VARCHAR(30),
    role PERSON_ROLE_TYPE,
    description TEXT DEFAULT NULL
)
    RETURNS BOOL
AS $$
    BEGIN
        IF (
            (name IS NULL) OR (role IS NULL) OR (nationality IS NULL) 
            OR (dob IS NULL) OR (gender IS NULL)
        ) THEN
            RAISE EXCEPTION 'Validation Error: Provide all required fields';
            RETURN FALSE;
        ELSE
            INSERT INTO persons (name, role, nationality, dob, gender, description) 
            VALUES(name, role, nationality, dob, gender, description);

            RETURN TRUE;
        END IF;
    END;
$$ LANGUAGE plpgsql;
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE OR REPLACE FUNCTION get_person_list()
	RETURNS TABLE (
		id INT,
		name VARCHAR,
		gender GENDER_TYPE,
		role PERSON_ROLE_TYPE,
		nationality VARCHAR,
		image_path VARCHAR
	)
AS $$
	BEGIN
	RETURN QUERY
		SELECT 
			persons.person_id, persons.name, persons.gender, 
			persons.role, persons.nationality, persons.image_path
		FROM persons;
	END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_person_by_id(i_id INT)
	RETURNS TABLE (
		id INT,
		name VARCHAR,
		gender GENDER_TYPE,
		role PERSON_ROLE_TYPE,
		nationality VARCHAR,
		image_path VARCHAR,
		description TEXT
	)
AS $$
	BEGIN
	RETURN QUERY
		SELECT 
			persons.person_id, persons.name, persons.gender, 
			persons.role, persons.nationality, persons.image_path, persons.description
		FROM persons
		WHERE persons.person_id = i_id;
	END;
$$ LANGUAGE plpgsql;


--For the options selection in film related person
CREATE OR REPLACE FUNCTION get_basic_person_list ()
    RETURNS TABLE (
        id INT,
        name TEXT
    )
AS $$
BEGIN
    RETURN QUERY 
        SELECT persons.person_id, CONCAT(persons.name , ' (', INITCAP(persons.role::VARCHAR), ')')
        FROM persons;
END;
$$ LANGUAGE plpgsql;


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CREATE OR REPLACE FUNCTION delete_person(i_person_id int) 
	RETURNS BOOL
AS $$
	BEGIN
	IF (i_person_id is NULL) THEN 
		RETURN False;
	ELSE
		DELETE FROM persons WHERE person_id = i_person_id;
		RETURN True;
	END IF;
	END;
$$ LANGUAGE plpgsql;
