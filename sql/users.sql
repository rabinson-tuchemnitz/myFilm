
CREATE OR REPLACE FUNCTION add_user(i_name TEXT, i_email TEXT, i_pass TEXT, i_type user_type)
RETURNS VOID
AS $$
BEGIN 
   INSERT INTO users (name, email, password, type) VALUES (i_name, i_email, i_pass, i_type);
END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION login(i_email TEXT, i_pass TEXT) 
RETURNS BOOL
AS $$
BEGIN
	IF EXISTS (
		SELECT * FROM users 
		WHERE users.email = i_email AND users.password = i_pass
	) THEN 
		RETURN TRUE;
 	ELSE 
 		RETURN FALSE;
	END IF;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------
CREATE OR REPLACE FUNCTION get_user_from_credentials(i_email text,i_pass text)
RETURNS TABLE(user_id integer, email varchar, name varchar, user_role user_type) 
AS $$
 BEGIN
 	RETURN QUERY SELECT users.user_id, users.email, users.name, users.type FROM users
 	WHERE users.email = i_email AND users.password = i_pass;
 END;
 
$$ LANGUAGE plpgsql;


------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_user_by_id (i_id integer)
RETURNS TABLE (
		user_id integer, email varchar, name varchar, user_role user_type, 
		description text, created_at text
 	)
AS $$
	BEGIN
		RETURN QUERY SELECT 
			users.user_id, users.email, users.name, users.type,
			users.description,  to_char( users.created_at, 'DD-MON-YYYY')
		FROM users
		WHERE users.user_id = i_id;
	END;
$$ LANGUAGE plpgsql;


-------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_user_by_id (i_id integer, i_name varchar default null, i_description text default null)
RETURNS VOID 
AS $$
	BEGIN
		IF (i_id IS NULL ) THEN
			RAISE EXCEPTION 'User id cannot be null';
		END IF;
		IF (i_name IS NOT NULL) THEN 
			UPDATE users SET name = i_name WHERE users.user_id = i_id;
		END IF;
		IF (i_description IS NOT NULL) THEN 
			UPDATE users SET description = i_description WHERE users.user_id = i_id;
		END IF;
	END;
$$ LANGUAGE plpgsql;

====>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>===============





CREATE OR REPLACE FUNCTION insert_a_record(table_name text, records text[])
RETURNS VOID 
AS $$

DECLARE 
	query_text text;
	i int;
	array_length = 0;
BEGIN
	query_text = 'INSERT INTO % VALUES ', table_name;
	array_length = array_length(records)
	
	FOR i IN 0..array_upper

$$ LANGUAGE plpgsql;


--------------------
 CREATE OR REPLACE FUNCTION insert_record(table_text text, input jsonb)
    RETURNS jsonb
    LANGUAGE plpgsql AS  -- language declaration required
 $func$
 DECLARE
    currentType text;
    _key   text;
    _value text;
 BEGIN
     FOR _key, _value IN
        SELECT * FROM jsonb_each_text($2)
     LOOP
 		-- get the column type from table
 		select data_type FROM information_schema.columns 
 		INTO currentType
 		WHERE table_name = table_text AND column_name = _key;
        -- do some math operation on its corresponding value
        RAISE NOTICE '%: %', _key, currentType;
     END LOOP;
 END
 $func$;


SELECT insert_record('users','{"name": "Rabinson"}');


-------------------------
  CREATE OR REPLACE FUNCTION insert_record(table_text text, input jsonb)
    RETURNS text
    LANGUAGE plpgsql AS  -- language declaration required
 $func$
 DECLARE
 	insertQuery text;
	columnText text;
	valueText text;
    currentType text;
    _key   text;
    _value text;
 BEGIN
 	insertQuery = 'INSERT INTO % VALUES ', table_text;
	columnText = '';
	valueText = '';
     FOR _key, _value IN
        SELECT * FROM jsonb_each_text($2)
     LOOP
 		-- get the column type from table
--  		select data_type FROM information_schema.columns 
--  		INTO currentType
--  		WHERE table_name = table_text AND column_name = _key;
		
		columnText = columnText || ',' || _key;
		valueText = valueText || ',' || __value;
		-- insert the single record in given table
-- 		insertQuery = insertQuery || '(null,' || ')'
        -- do some math operation on its corresponding value
     END LOOP;
	 
	 RAISE NOTICE '% | %', columnText, valueText;
 END
 $func$;

 --------------------------------
  CREATE OR REPLACE FUNCTION insert_records(table_text text, input jsonb)
    RETURNS text
    LANGUAGE plpgsql AS  -- language declaration required
 $func$
 DECLARE
 	insertQuery text = '';
	columnText text = '';
	valueText text = '';
    _key   text;
    _value text;
	loop_counter integer = 0;
 BEGIN
 	insertQuery = 'INSERT INTO % VALUES ', table_text;
     FOR _key, _value IN
        SELECT * FROM jsonb_each_text($2)
     LOOP
	 	RAISE NOTICE '% : %', _key, _value;
--  		IF loop_counter > 0 THEN 
-- 			columnText = ', %', columnText;
-- 			valueText = ', %', valueText;
-- 		ELSE 
-- 			columnText = columnText;
			
-- 		loop_counter = loop_counter + 1;
     END LOOP;
-- 	 RAISE NOTICE '% (%) VALUES (%)', insertQuery, columnText, valueText;
 END
 $func$;