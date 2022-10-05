-- # use case 8 - add/delete/update a data type
-- Add a new data_type to the converter
DROP FUNCTION IF EXISTS converter.add_data_type;
CREATE OR REPLACE FUNCTION converter.add_data_type(in_user_id int, data_type_name text)

RETURNS int
language plpgsql
as
$$
declare
 data_type_id int;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR data_type_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- ensure that the requested data_type does not already exist
    if (select count(*) from converter.data_type where lower(name) = lower(data_type_name)) > 0 then
        RAISE EXCEPTION SQLSTATE 'CF021' USING MESSAGE = (select error_description from converter.response where error_code = 'CF021');
    end if;
    -- create the new data_type
    insert into converter.data_type (name, translation, created, created_by, updated, updated_by, active)
            values (data_type_name, false, now(), in_user_id, now(), in_user_id, true);

    --check to confirm it was added.
    data_type_id = (select id from converter.data_type where name = data_type_name);

    if (data_type_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    -- return successful confirmation
    return data_type_id;
end
$$;

-- Update an existing data type
DROP FUNCTION IF EXISTS converter.update_data_type;
CREATE OR REPLACE FUNCTION converter.update_data_type(in_user_id int, in_data_type_id int, new_data_type_name text)

RETURNS bool
language plpgsql
as
$$
-- declare
--     outcome text;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_type_id is NULL OR new_data_type_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- Ensure the old name exists
    if ((select count(*) from converter.data_type where id = in_data_type_id) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF015' USING MESSAGE = (select error_description from converter.response where error_code = 'CF015');
    end if;

    -- Ensure the new name does not exist
    if ((select count(*) from converter.data_type where lower(name) = lower(new_data_type_name)) > 0) then
        RAISE EXCEPTION SQLSTATE 'CF021' USING MESSAGE = (select error_description from converter.response where error_code = 'CF021');
    end if;

    UPDATE converter.data_type
    SET name = new_data_type_name,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_data_type_id;

    -- check to confirm the data type was updated
    -- Ensure the new name now exists
    if ((select count(*) from converter.data_type where name = new_data_type_name) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

-- Enable/Disable an existing data type
DROP FUNCTION IF EXISTS converter.set_enabled_data_type;
CREATE OR REPLACE FUNCTION converter.set_enabled_data_type(in_user_id int, in_data_type_id int, isEnabled boolean)

RETURNS bool
language plpgsql
as
$$
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_type_id is NULL OR isEnabled is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- Ensure the old name exists
    if (select count(*) from converter.data_type where id = in_data_type_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF015' USING MESSAGE = (select error_description from converter.response where error_code = 'CF015');
    end if;

    -- Enable/Disable the data_type
    UPDATE converter.data_type
    SET active = isEnabled,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_data_type_id;

    -- check to confirm the data type was updated
    if ((select active from converter.data_type where id = in_data_type_id) <> isEnabled) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

-- Get the id from a data_type

DROP FUNCTION IF EXISTS converter.get_data_type_id_from_name;
CREATE OR REPLACE FUNCTION converter.get_data_type_id_from_name(in_user_id int, in_data_type_name text, in_throw boolean DEFAULT TRUE)

RETURNS int
language plpgsql
as
$$
declare
    outcome int;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_type_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- store the id for error checking - requires on one query.
        outcome = (select id from converter.data_type where lower(name) = lower(in_data_type_name));

    -- return the ID
    if (outcome is null and in_throw)  then
        RAISE EXCEPTION SQLSTATE 'CF022' USING MESSAGE = (select error_description from converter.response where error_code = 'CF022');
    end if;

    return outcome;
end
$$;

-- Get the id from a data_type
DROP FUNCTION IF EXISTS converter.get_data_type_status_from_id;
CREATE OR REPLACE FUNCTION converter.get_data_type_status_from_id(in_user_id int, in_data_type_id int)

RETURNS bool
language plpgsql
as
$$
declare
    data_type_status bool;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_type_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- store the number of records for error checking - requires on one query.
    data_type_status = (select active from converter.data_type where id = in_data_type_id);

    -- return the ID
    if (data_type_status is null) then
        RAISE EXCEPTION SQLSTATE 'CF015' USING MESSAGE = (select error_description from converter.response where error_code = 'CF015');
    end if;

    return data_type_status;
end
$$;

DROP FUNCTION IF EXISTS converter.get_data_type_si_unit_id;
CREATE OR REPLACE FUNCTION converter.get_data_type_si_unit_id(
    in_user_id int,
    in_data_type_id int
)

RETURNS int
language plpgsql
as
$$
declare
    output int;
begin
    if(in_user_id is NULL or in_data_type_id is NULL) then
                RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    output = (SELECT uom_id FROM converter.conversion_rate
                    WHERE rate = 1 AND  constant = 0 AND uom_id IN
                           (SELECT id FROM converter.uom WHERE data_type_id = in_data_type_id));

    IF (output IS NULL) THEN
        RAISE  EXCEPTION SQLSTATE 'CF026' USING MESSAGE = (select error_description from converter.response where error_code = 'CF026');
    end if;

    RETURN output;
end
$$;