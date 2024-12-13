CREATE FUNCTION get_initials_with_surname(surname varchar(30),
										  name varchar(30),
										  patronymic varchar(30))
RETURNS varchar(36) AS $$
BEGIN
	IF patronymic IS NULL OR patronymic = '' THEN
		RETURN substring(name for 1) || '. ' || surname;
	ELSE
		RETURN substring(name for 1) || '. ' || substring(patronymic for 1) || '. ' || surname;
	END IF;
END$$ LANGUAGE plpgsql;