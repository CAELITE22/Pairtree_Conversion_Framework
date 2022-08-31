-- Add a new empty conversion_set to the converter
CREATE OR REPLACE FUNCTION converter.add_conversion_set(in_user_id int, conversion_set_name text)

RETURNS int
language plpgsql
as
$$
--declare
--  outcome text;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR conversion_set_name is NULL) then
        return concat('Error! Cannot input <NULL> values.');
    end if;

    -- ensure that the requested conversion_set_name does not already exist
    if (select count(*) from converter.conversion_set where name = conversion_set_name) > 0 then
        return concat('Error! The conversion set: "', conversion_set_name, '" already exists.');
    end if;
    -- create the new conversion_set
    insert into converter.conversion_set (name, created, created_by, updated, updated_by, owner_user_id, active)
            values (conversion_set_name, now(), in_user_id, now(), in_user_id, in_user_id, true);

    --check to confirm it was added.
    if (select count(*) from converter.conversion_set where name = conversion_set_name) = 0 then
        return concat('Error! There was a problem adding conversion set: "', conversion_set_name, '".');
    end if;

    -- return successful confirmation
    return concat('Conversion set: "', conversion_set_name, '" was added successfully.');
end
$$;

-- Creating a new conversion set and cloning the category to conversion set relationships from the source_conversion_set to the destination_conversion_set
CREATE OR REPLACE FUNCTION converter.clone_conversion_set(in_user_id int, source_conversion_set_name text, destination_conversion_set_name text)

RETURNS text
language plpgsql
as
$$
declare
    source_id int;
    destination_id int;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR source_conversion_set_name is NULL OR destination_conversion_set_name is NULL) then
        return concat('Error! Cannot input <NULL> values.');
    end if;

    -- ensure that the requested new_conversion_set_name does not already exist
    if (select count(*) from converter.conversion_set where name = destination_conversion_set_name) > 0 then
        return concat('Error! The conversion set: "', destination_conversion_set_name, '" already exists.');
    end if;

    -- ensure that the requested source_conversion_set_name exists and get the source_id
    source_id = (converter.get_conversion_set_id_from_name(in_user_id, source_conversion_set_name));
    if (source_id = (-1)) then
        return concat('Error! The source conversion set: "', source_conversion_set_name, '" does not exist.');
    end if;

    -- create the new conversion_set
    insert into converter.conversion_set (name, created, created_by, updated, updated_by, owner_user_id, active)
    values (destination_conversion_set_name, now(), in_user_id, now(), in_user_id, in_user_id, true);

    --check to confirm destination_conversion_set was added
    destination_id = (converter.get_conversion_set_id_from_name(in_user_id, destination_conversion_set_name));
    if (destination_id = (-1)) then
        return concat('Error! The destination Conversion set: "', destination_conversion_set_name, '" does not exist.');
    end if;

    -- cloning the category to conversion set relationships from the source_conversion_set to the destination_conversion_set
    INSERT INTO converter.category_to_conversion_set(conversion_set_id, data_category_id, uom_id, created, updated, created_by, updated_by, active)
    SELECT destination_id, data_category_id, uom_id, created, updated, created_by, updated_by, active FROM converter.category_to_conversion_set
    WHERE conversion_set_id = source_id AND active = TRUE;

    -- return successful confirmation
    return concat('Conversion set: "', destination_conversion_set_name, '" was added successfully.');
end
$$;


CREATE OR REPLACE FUNCTION converter.get_conversion_set_id_from_name(in_user_id int, conversion_set_name text)

RETURNS int
language plpgsql
as
$$
declare
  outcome int;
begin
    if (select count(*) from converter.conversion_set where name = conversion_set_name and active = true) = 1 then
        outcome = (select id from converter.conversion_set where name = conversion_set_name and active = true);
        return outcome;
    end if;

    -- return -1 if an error occurs
    return -1;
end
    $$;
