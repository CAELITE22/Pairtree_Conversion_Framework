-- Add a new empty conversion_set to the converter
CREATE OR REPLACE FUNCTION converter.add_conversion_set(in_user_id int, conversion_set_name text)

RETURNS int
language plpgsql
as
$$
declare
 conversion_set_id int;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR conversion_set_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- ensure that the requested conversion_set_name does not already exist
    if (select count(*) from converter.conversion_set where name = conversion_set_name) > 0 then
        RAISE EXCEPTION SQLSTATE 'CF011' USING MESSAGE = (select error_description from converter.response where error_code = 'CF011');
    end if;
    -- create the new conversion_set
    insert into converter.conversion_set (name, created, created_by, updated, updated_by, owner_user_id, active)
            values (conversion_set_name, now(), in_user_id, now(), in_user_id, in_user_id, true);

    --check to confirm it was added.
    conversion_set_id = (select id from converter.conversion_set where name = conversion_set_name);
    if (conversion_set_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    -- return successful confirmation
    return conversion_set_id;
end
$$;

-- Creating a new conversion set and cloning the category to conversion set relationships from the source_conversion_set to the destination_conversion_set
CREATE OR REPLACE FUNCTION converter.clone_conversion_set(in_user_id int, source_conversion_set_name text, destination_conversion_set_name text)

RETURNS int
language plpgsql
as
$$
declare
    source_id int;
    destination_id int;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR source_conversion_set_name is NULL OR destination_conversion_set_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- ensure that the requested new_conversion_set_name does not already exist
    if (select count(*) from converter.conversion_set where name = destination_conversion_set_name) > 0 then
        RAISE EXCEPTION SQLSTATE 'CF011' USING MESSAGE = (select error_description from converter.response where error_code = 'CF011');
    end if;

    -- ensure that the requested source_conversion_set_name exists and get the source_id
    source_id = (converter.get_conversion_set_id_from_name(in_user_id, source_conversion_set_name));
    if (source_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF012' USING MESSAGE = (select error_description from converter.response where error_code = 'CF012');
    end if;

    -- create the new conversion_set
    insert into converter.conversion_set (name, created, created_by, updated, updated_by, owner_user_id, active)
    values (destination_conversion_set_name, now(), in_user_id, now(), in_user_id, in_user_id, true);

    --check to confirm destination_conversion_set was added
    destination_id = (converter.get_conversion_set_id_from_name(in_user_id, destination_conversion_set_name));
    if (destination_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    -- cloning the category to conversion set relationships from the source_conversion_set to the destination_conversion_set
    INSERT INTO converter.category_to_conversion_set(conversion_set_id, data_category_id, uom_id, created, updated, created_by, updated_by, active)
    SELECT destination_id, data_category_id, uom_id, created, updated, created_by, updated_by, active FROM converter.category_to_conversion_set
    WHERE conversion_set_id = source_id AND active = TRUE;

    -- return successful confirmation
    return destination_id;
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
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR conversion_set_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    outcome = (select id from converter.conversion_set where name = conversion_set_name and active = true);
    if (outcome is null) then
        RAISE EXCEPTION SQLSTATE 'CF012' USING MESSAGE = (select error_description from converter.response where error_code = 'CF012');
    end if;

    --return value if no exception is raised.
        return outcome;
end
    $$;
