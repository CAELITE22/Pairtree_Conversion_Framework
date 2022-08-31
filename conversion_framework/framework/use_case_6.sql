-- Add a new empty conversion_set to the converter

CREATE OR REPLACE FUNCTION converter.update_default_conversion_set_category_uom(in_user_id int, in_data_category_name text, in_uom_name text)

RETURNS bool
language plpgsql
as
$$
declare
    lu_data_category_id int;
    lu_uom_id int;
    lu_user_conversion_set_id int;
--  outcome text;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_category_name is NULL or in_uom_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- ensure that the requested data_category exists
    lu_data_category_id = (select id from converter.data_category where name = in_data_category_name);
    if (lu_data_category_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF014' USING MESSAGE = (select error_description from converter.response where error_code = 'CF014');
    end if;

    -- ensure that the requested uom exists
    lu_uom_id = (select id from converter.uom where uom_name = in_uom_name);
    if (lu_uom_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF009' USING MESSAGE = (select error_description from converter.response where error_code = 'CF009');
    end if;

    -- ensure that the requested conversion set exists
    lu_user_conversion_set_id = (select conversion_set_id from converter.user_conversion_set ucs where ucs.user_id = in_user_id and ucs.active = true);
    if (lu_user_conversion_set_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF002' USING MESSAGE = (select error_description from converter.response where error_code = 'CF002');
    end if;

        -- update or create the category_uom record
    if (select count(*) from converter.category_to_conversion_set ctcs
            where ctcs.conversion_set_id = lu_user_conversion_set_id and data_category_id = lu_data_category_id) = 1 then
        update converter.category_to_conversion_set  set uom_id = uom_id, updated = now(), updated_by = in_user_id
            where conversion_set_id = lu_user_conversion_set_id and data_category_id = lu_data_category_id;
    else
         insert into converter.category_to_conversion_set
            (active, conversion_set_id,data_category_id, uom_id, created, created_by, updated, updated_by)
        values
            (true, lu_user_conversion_set_id, lu_data_category_id, lu_uom_id, now(), in_user_id, now(), in_user_id);
     end if;

    --check to confirm it was added.
    if (select count(*) from converter.category_to_conversion_set ctcs
            where ctcs.conversion_set_id = lu_user_conversion_set_id
                and ctcs.data_category_id = lu_data_category_id
                and ctcs.uom_id = lu_uom_id) = 0
        then
        raise exception sqlstate 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    -- return successful confirmation
    return true;
end
$$;

-- Add a new empty conversion_set to the converter
CREATE OR REPLACE FUNCTION converter.update_target_conversion_set_category(in_user_id int, in_conversion_set_name text,
                                    in_data_category_name text, in_uom_name text)

RETURNS bool
language plpgsql
as
$$
declare
    lu_data_category_id int;
    lu_uom_id int;
    lu_conversion_set_id int;
--  outcome text;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_category_name is NULL or in_uom_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- ensure that the requested data_category exists
    lu_data_category_id = (select id from converter.data_category where name = in_data_category_name);
    if (lu_data_category_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF014' USING MESSAGE = (select error_description from converter.response where error_code = 'CF014');
    end if;

    -- ensure that the requested uom exists
    lu_uom_id = (select id from converter.uom where uom_name = in_uom_name);
    if (lu_uom_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF009' USING MESSAGE = (select error_description from converter.response where error_code = 'CF009');
    end if;

    -- ensure that the requested conversion set exists
    lu_conversion_set_id = (select id from converter.conversion_set  where name = in_conversion_set_name and active = true);
    if (lu_conversion_set_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF013' USING MESSAGE = (select error_description from converter.response where error_code = 'CF013');
    end if;

    -- update or create the category_uom record
    if (select count(*) from converter.category_to_conversion_set ctcs
            where ctcs.conversion_set_id = lu_conversion_set_id and ctcs.data_category_id = lu_data_category_id) = 1 then
        update converter.category_to_conversion_set set uom_id = uom_id, updated = now(), updated_by = in_user_id
            where conversion_set_id = lu_conversion_set_id and data_category_id = lu_data_category_id;
    else
         insert into converter.category_to_conversion_set
            (active, conversion_set_id,data_category_id, uom_id, created, created_by, updated, updated_by)
        values
            (true, lu_conversion_set_id, lu_data_category_id, lu_uom_id, now(), in_user_id, now(), in_user_id);
    end if;

    --check to confirm it was added.
    if (select count(*) from converter.category_to_conversion_set ctcs
            where ctcs.conversion_set_id = lu_conversion_set_id
                and ctcs.data_category_id = lu_data_category_id
                and ctcs.uom_id = lu_uom_id) = 0
        then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    -- return successful confirmation
    return true;
end
$$;