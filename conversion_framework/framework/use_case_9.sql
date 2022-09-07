-- # use case 9 - add/delete/update a data category
-- Add a new data_type to the converter
CREATE OR REPLACE FUNCTION converter.add_data_category(in_user_id int, in_data_category_name text, in_data_type_id int)

RETURNS int
language plpgsql
as
$$
declare
 data_category_id int;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_category_name is NULL OR in_data_type_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- ensure that the requested data_category does not already exist
    if (select count(*) from converter.data_category where name = in_data_category_name) > 0 then
        RAISE EXCEPTION SQLSTATE 'CF023' USING MESSAGE = (select error_description from converter.response where error_code = 'CF023');
    end if;

    -- Ensure that the request data_type exists
    if (select count(*) from converter.data_type where id = in_data_type_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF015' USING MESSAGE = (select error_description from converter.response where error_code = 'CF015');
    end if;

    -- create the new data_category
    insert into converter.data_category (name, type_id, created, created_by, updated, updated_by, active)
            values (in_data_category_name, in_data_type_id, now(), in_user_id, now(), in_user_id, true);

    --check to confirm it was added.
    data_category_id = (select id from converter.data_category where name = in_data_category_name);
    if (data_category_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    -- return successful confirmation
    return data_category_id;
end
$$;

-- Update an existing data category
CREATE OR REPLACE FUNCTION converter.update_data_category_name(in_user_id int, in_data_category_id int, new_data_category_name text)

RETURNS bool
language plpgsql
as
$$
-- declare
--     outcome text;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_category_id is NULL OR new_data_category_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- Ensure the old name exists
    if (select count(*) from converter.data_category where id = in_data_category_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF014' USING MESSAGE = (select error_description from converter.response where error_code = 'CF014');
    end if;

    -- Ensure the new name does not exist
    if (select count(*) from converter.data_category where name = new_data_category_name) > 0 then
        RAISE EXCEPTION SQLSTATE 'CF023' USING MESSAGE = (select error_description from converter.response where error_code = 'CF023');
    end if;

    UPDATE converter.data_category
    SET name = new_data_category_name,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_data_category_id;

    -- check to confirm the data category was updated
    -- Ensure the new name now exists
    if ((select count(*) from converter.data_category where name = new_data_category_name) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;


-- Update an existing data type association in a data category
CREATE OR REPLACE FUNCTION converter.update_data_category_data_type(in_user_id int, in_data_category_id int, new_data_type_id int)

RETURNS bool
language plpgsql
as
$$
-- declare
--     outcome text;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_category_id is NULL OR new_data_type_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    -- Ensure the data_category_id exists
    if (select count(*) from converter.data_category where id = in_data_category_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF014' USING MESSAGE = (select error_description from converter.response where error_code = 'CF014');
    end if;

    -- Ensure the data_type exists
    if (select count(*) from converter.data_type where id = new_data_type_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF015' USING MESSAGE = (select error_description from converter.response where error_code = 'CF015');
    end if;

    UPDATE converter.data_category
    SET type_id = new_data_type_id,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_data_category_id; -- can someone confirm this is correct?

    -- check to confirm the data category was updated
    -- Ensure the new type now exists
    if (select count(*) from converter.data_category where id = in_data_category_id AND type_id = new_data_type_id) = 0 then -- check syntax
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;


-- Enable/Disable an existing data category
CREATE OR REPLACE FUNCTION converter.set_enabled_data_category(in_user_id int, in_data_category_id int, isEnabled boolean)

RETURNS bool
language plpgsql
as
$$
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_category_id is NULL OR isEnabled is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- Ensure the id exists
    if (select count(*) from converter.data_category where id = in_data_category_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF014' USING MESSAGE = (select error_description from converter.response where error_code = 'CF014');
    end if;

    if (isEnabled = false) then
        if (converter.is_data_category_dependency(-1,in_data_category_id)) then
            RAISE EXCEPTION SQLSTATE 'CF024' USING MESSAGE = (select error_description from converter.response where error_code = 'CF024');
        end if;
    end if;
    -- Enable/Disable the data_category
    UPDATE converter.data_category
    SET active = isEnabled,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_data_category_id;

    -- check to confirm the data category was updated
    if (select count(*) from converter.data_category where id = in_data_category_id AND active = isEnabled) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

-- get the id from a data_category
CREATE OR REPLACE FUNCTION converter.get_data_category_id_from_name(in_user_id int, in_data_category_name text)

RETURNS int
language plpgsql
as
$$
declare
    data_category_id int;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_category_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- get the category id from name
    data_category_id = (select id from converter.data_category where name = in_data_category_name);

    --ensure id is not null
    if (data_category_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF025' USING MESSAGE = (select error_description from converter.response where error_code = 'CF025');
    end if;

    -- return the ID
    return data_category_id;
end
$$;

-- get the id from a data_category
CREATE OR REPLACE FUNCTION converter.get_data_category_status_from_id(in_user_id int, in_data_category_id int)

RETURNS bool
language plpgsql
as
$$
declare
    data_type_status bool;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_category_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

   -- get the category id from name
    data_type_status = (select active from converter.data_category where id = in_data_category_id);

    --ensure id is not null
    if (data_type_status is null) then
        RAISE EXCEPTION SQLSTATE 'CF014' USING MESSAGE = (select error_description from converter.response where error_code = 'CF014');
    end if;

    -- return the status
    return data_type_status;
end
$$;

-- get the id from a data_category
CREATE OR REPLACE FUNCTION converter.get_data_category_data_type_id_from_id(in_user_id int, in_data_category_id int)

RETURNS int
language plpgsql
as
$$
declare
    data_type_id int;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_category_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- get the category id from name
    data_type_id = (select type_id from converter.data_category where id = in_data_category_id);

    --ensure id is not null
    if (data_type_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF014' USING MESSAGE = (select error_description from converter.response where error_code = 'CF014');
    end if;

    -- return the ID
    return data_type_id;
end
$$;

-- check if a data_category exists in an active conversion set - used before disabling
CREATE OR REPLACE FUNCTION converter.is_data_category_dependency(in_user_id int, in_data_category_id int)

RETURNS bool
language plpgsql
as
$$
declare
    num_records int;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_category_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

        -- Ensure the id exists
    if (select count(*) from converter.data_category where id = in_data_category_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF014' USING MESSAGE = (select error_description from converter.response where error_code = 'CF014');
    end if;

    num_records = (select count(*) from converter.category_to_conversion_set ctcs
                    inner join converter.conversion_set cs on ctcs.conversion_set_id = cs.id
                    where ctcs.data_category_id = in_data_category_id and ctcs.active = true and cs.active = true);

    if (num_records > 0) then
        return true;
    end if;

    return false;

end
$$;)