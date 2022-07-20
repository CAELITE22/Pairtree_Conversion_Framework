-- # use case 8 - add/delete/update a data type

/*
 activity list:
 - add - add a datatype - return text "Datatype X has been created with id: Y"
 - enable - enable/disable a datatype return text "Datatype X has been disabled"
 - update - update a datatype return text "Datatype has been updated from X to Y"
 - get_id_from_data_type - search for a datatype - return ID if exists, return -1 no not exists
 */

-- Add a new data_type to the converter
CREATE OR REPLACE FUNCTION converter.add_data_type(in_user_id int, data_type_name text)

RETURNS text
language plpgsql
as
$$
--declare
--  outcome text;
begin
    -- ensure that the requested data_type does not already exist
    if (select count(*) from converter.data_type where name = data_type_name) > 0 then
        return concat('Error! The data type: "', data_type_name, '" already exists.');
    end if;
    -- create the new data_type
    insert into converter.data_type (name, translation, created, created_by, updated, updated_by, active)
            values (data_type_name, false, now(), in_user_id, now(), in_user_id, true);

    --check to confirm it was added.
    if (select count(*) from converter.data_type where name = data_type_name) = 0 then
        return concat('Error! There was a problem adding data type" "', data_type_name, '".');
    end if;

    -- return successful confirmation
    return concat('Data type: "', data_type_name, '" was added successfully.');
end
$$;

-- Update an existing data type
CREATE OR REPLACE FUNCTION converter.update_data_type(in_user_id int, old_data_type_name text, new_data_type_name text)

RETURNS text
language plpgsql
as
$$
-- declare
--     outcome text;
begin
    -- Ensure the old name exists
    if (select count(*) from converter.data_type where name = old_data_type_name) = 0 then
        return concat('Error! The data type: "', old_data_type_name, '" does not exist.');
    end if;

    -- Ensure the new name does not exist
    if (select count(*) from converter.data_type where name = new_data_type_name) > 0 then
        return concat('Error! The data type: "', new_data_type_name, '" already exists.');
    end if;

    UPDATE converter.data_type
    SET name = new_data_type_name,
        updated = now(),
        updated_by = in_user_id
    WHERE name = old_data_type_name;

    -- check to confirm the data type was updated
    -- Ensure the new name now exists
    if (select count(*) from converter.data_type where name = new_data_type_name) > 0 then
        -- Ensure the old name no longer exists
        if (select count(*) from converter.data_type where name = old_data_type_name) = 0 then
            return concat('Data type: "', old_data_type_name, '" was successfully updated to: "', new_data_type_name, '".');
        end if;
    end if;

    return concat('There was a problem adding data type: "', new_data_type_name, '".');
end
$$;

-- Enable/Disable an existing data type
CREATE OR REPLACE FUNCTION converter.set_enabled_data_type(in_user_id int, data_type_name text, isEnabled boolean)

RETURNS text
language plpgsql
as
$$
begin
    -- Ensure the old name exists
    if (select count(*) from converter.data_type where name = data_type_name) = 0 then
        return concat('Error! The data type: "', data_type_name, '" does not exist.');
    end if;

    -- Enable/Disable the data_type
    UPDATE converter.data_type
    SET active = isEnabled,
        updated = now(),
        updated_by = in_user_id
    WHERE name = data_type_name;

    -- check to confirm the data type was updated
    if (select count(*) from converter.data_type where name = data_type_name AND active = isEnabled) > 0 then
        if (isEnabled) then
            return concat('Data type: "', data_type_name, '" is now enabled.');
        else
            return concat('Data type: "', data_type_name, '" is now disabled.');
        end if;
    end if;

    return concat('There was a problem updating data type: "', data_type_name, '".');
end
$$;

-- Add a new data_type to the converter
CREATE OR REPLACE FUNCTION converter.get_id_from_data_type(in_user_id int, data_type_name text)

RETURNS real
language plpgsql
as
$$
declare
    outcome int;
    num_records int;
begin
    -- store the number of records for error checking - requires on one query.
    num_records = (select count(*) from converter.data_type where name = data_type_name);

    -- return the ID
    if (num_records) = 1 then
        outcome = (select id from converter.data_type where name = data_type_name);
        return outcome;
    end if;

    -- ensure that the requested data_type exists, or return -1 if it doesn't
    if (num_records) = 0 then
        return -1;
    end if;

    -- if there are multiple records containing the same data type, return -2
    if (num_records) > 1 then
        return -2;
    end if;
end
$$;