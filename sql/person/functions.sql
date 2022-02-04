---------------------------FUNCTIONS START ------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE OR REPLACE FUNCTION insert_person (
	name VARCHAR(50),
    gender GENDER_TYPE,
    dob DATE,
    nationality VARCHAR(30),
    role PERSON_ROLE_TYPE,
    description TEXT DEFAULT NULL, 
    height INT DEFAULT NULL
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
            INSERT INTO persons (name, role, nationality, dob, gender, description, height) 
            VALUES(name, role, nationality, dob, gender, description, height);

            RETURN TRUE;
        END IF;
    END;
$$ LANGUAGE plpgsql;

SELECT * FROM insert_person(name:='Angelina Jolie', dob:='1975-01-01', gender:='female', nationality:='US', role:='actress');

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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