-- # use case 9 - add/delete/update a data category

/*
 activity list:
converter.add_data_category(in_user_id int, data_category_name text, data_type_id int)
converter.update_data_category_name(in_user_id int, old_data_category_name text, new_data_category_name text)
converter.update_data_category_data_type(in_user_id int, data_category_name text, new_data_type_id int)
converter.set_enabled_data_category(in_user_id int, data_category_name text, isActive boolean)
converter.check_data_category_in_conversion_sets(data_category_id)
select count(*) from converter.category_to_conversion_set where data_category_id = <id> and active = true;
if >0 in use, else inactive
converter.get_id_from_data_category(in_user_id int, data_category_name text)
 */

-- Add a new data_type to the converter
CREATE OR REPLACE FUNCTION converter.add_data_category(in_user_id int, data_category_name text, data_type_id int)

RETURNS text
language plpgsql
as
$$
--declare
--  outcome text;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR data_category_name is NULL OR data_type_id is NULL) then
        return concat('Error! Cannot input <NULL> values.');
    end if;

    -- ensure that the requested data_category does not already exist
    if (select count(*) from converter.data_category where name = data_category_name) > 0 then
        return concat('Error! The data category: "', data_category_name, '" already exists.');
    end if;

    -- Ensure that the request data_type exists
    if (select count(*) from converter.data_type where id = data_type_id) = 0 then
        return concat('Error! The data type association "', data_type_id, '" does not exist.');
    end if;

    -- create the new data_category
    insert into converter.data_category (name, type_id, created, created_by, updated, updated_by, active)
            values (data_category_name, data_type_id, now(), in_user_id, now(), in_user_id, true);

    --check to confirm it was added.
    if (select count(*) from converter.data_category where name = data_category_name) = 0 then
        return concat('Error! There was a problem adding data category: "', data_category_name, '".');
    end if;

    -- return successful confirmation
    return concat('Data category: "', data_category_name, '" was added successfully.');
end
$$;

-- Update an existing data category
CREATE OR REPLACE FUNCTION converter.update_data_category_name(in_user_id int, old_data_category_name text, new_data_category_name text)

RETURNS text
language plpgsql
as
$$
-- declare
--     outcome text;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR old_data_category_name is NULL OR new_data_category_name is NULL) then
        return concat('Error! Cannot input <NULL> values.');
    end if;

    -- Ensure the old name exists
    if (select count(*) from converter.data_category where name = old_data_category_name) = 0 then
        return concat('Error! The data category: "', old_data_category_name, '" does not exist.');
    end if;

    -- Ensure the new name does not exist
    if (select count(*) from converter.data_category where name = new_data_category_name) > 0 then
        return concat('Error! The data category: "', new_data_category_name, '" already exists.');
    end if;

    UPDATE converter.data_category
    SET name = new_data_category_name,
        updated = now(),
        updated_by = in_user_id
    WHERE name = old_data_category_name;

    -- check to confirm the data category was updated
    -- Ensure the new name now exists
    if (select count(*) from converter.data_category where name = new_data_category_name) > 0 then
        -- Ensure the old name no longer exists
        if (select count(*) from converter.data_category where name = old_data_category_name) = 0 then
            return concat('Data category: "', old_data_category_name, '" was successfully updated to: "', new_data_category_name, '".');
        end if;
    end if;

    return concat('There was a problem updating data category: "', old_data_category_name, '" to: "', new_data_category_name, '".');
end
$$;


-- Update an existing data type association in a data category WORKING HERE
CREATE OR REPLACE FUNCTION converter.update_data_category_data_type(in_user_id int, data_category_name text, new_data_type_id int)

RETURNS text
language plpgsql
as
$$
-- declare
--     outcome text;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR data_category_name is NULL OR new_data_type_id is NULL) then
        return concat('Error! Cannot input <NULL> values.');
    end if;

    -- Ensure the data_category_name exists
    if (select count(*) from converter.data_category where name = data_category_name) = 0 then
        return concat('Error! The data category: "', data_category_name, '" does not exist.');
    end if;

    -- Ensure the data_type exists
    if (select count(*) from converter.data_type where id = new_data_type_id) = 0 then
        return concat('Error! The data type association "', new_data_type_id, '" does not exist.');
    end if;

    UPDATE converter.data_category
    SET type_id = new_data_type_id,
        updated = now(),
        updated_by = in_user_id
    WHERE name = data_category_name; -- can someone confirm this is correct?

    -- check to confirm the data category was updated
    -- Ensure the new type now exists
    if (select count(*) from converter.data_category where name = data_category_name AND type_id = new_data_type_id) > 0 then -- check syntax
        return concat('Data category: "', data_category_name, '" was successfully updated to use data type: "', new_data_type_id, '".');
    end if;

    return concat('There was a problem updating data category: "', data_category_name, '" to: "', new_data_type_id, '".');
end
$$;


-- Enable/Disable an existing data category
CREATE OR REPLACE FUNCTION converter.set_enabled_data_category(in_user_id int, data_category_name text, isEnabled boolean)

RETURNS text
language plpgsql
as
$$
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR data_category_name is NULL OR isEnabled is NULL) then
        return concat('Error! Cannot input <NULL> values.');
    end if;

    -- Ensure the old name exists
    if (select count(*) from converter.data_category where name = data_category_name) = 0 then
        return concat('Error! The data category: "', data_category_name, '" does not exist.');
    end if;

    -- TODO - Needs to check if category exists in a conversion set before disabling. Make separate function

    -- Enable/Disable the data_category
    UPDATE converter.data_category
    SET active = isEnabled,
        updated = now(),
        updated_by = in_user_id
    WHERE name = data_category_name;

    -- check to confirm the data category was updated
    if (select count(*) from converter.data_category where name = data_category_name AND active = isEnabled) > 0 then
        if (isEnabled) then
            return concat('Data category: "', data_category_name, '" is now enabled.');
        else
            return concat('Data category: "', data_category_name, '" is now disabled.');
        end if;
    end if;

    return concat('Error! There was a problem updating data category: "', data_category_name, '".');
end
$$;


-- get the id from a data_category
CREATE OR REPLACE FUNCTION converter.get_id_from_data_category(in_user_id int, data_category_name text)

RETURNS real
language plpgsql
as
$$
declare
    outcome int;
    num_records int;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR data_category_name is NULL) then
        return concat('Error! Cannot input <NULL> values.');
    end if;

    -- store the number of records for error checking - requires on one query.
    num_records = (select count(*) from converter.data_category where name = data_category_name);

    -- return the ID
    if (num_records) = 1 then
        outcome = (select id from converter.data_category where name = data_category_name);
        return outcome;
    end if;

    -- ensure that the requested data_category exists, or return -1 if it doesn't
    if (num_records) = 0 then
        return -1;
    end if;

    -- if there are multiple records containing the same data category, return -2
    if (num_records) > 1 then
        return -2; -- document this error code
    end if;
end
$$;

-- check if a data_category exists in an active conversion set - used before disabling
CREATE OR REPLACE FUNCTION converter.is_data_category_dependency(in_user_id int, data_category_id int)

RETURNS text -- todo what do we want this to return?
language plpgsql
as
$$
declare
    outcome text;
    num_records int;
begin
    -- look at the conversion sets for an active set containing this data category
    -- return the conversion set id? for each data category? maybe will we also need user id for each set?
    -- maybe something like {id, set_id; id, set_id)

        return ""; -- todo

end
$$;