
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

--------------------------------------------------------------------------------------