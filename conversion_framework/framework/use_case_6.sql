-- Add a new empty conversion_set to the converter

CREATE OR REPLACE FUNCTION converter.update_default_conversion_set_category_uom(in_user_id int, in_data_category_id int, in_uom_id int)

RETURNS bool
language plpgsql
as
$$
declare
    lu_user_conversion_set_id int;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_category_id is NULL or in_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- ensure that the requested data_category exists
    if ((select id from converter.data_category where id = in_data_category_id) is null) then
        RAISE EXCEPTION SQLSTATE 'CF014' USING MESSAGE = (select error_description from converter.response where error_code = 'CF014');
    end if;

    -- ensure that the requested uom exists
    if ((select id from converter.uom where id = in_uom_id) is null) then
        RAISE EXCEPTION SQLSTATE 'CF009' USING MESSAGE = (select error_description from converter.response where error_code = 'CF009');
    end if;

    -- ensure that the requested conversion set exists
    lu_user_conversion_set_id = (select conversion_set_id from converter.user_conversion_set ucs where ucs.user_id = in_user_id and ucs.active = true);
    if (lu_user_conversion_set_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF002' USING MESSAGE = (select error_description from converter.response where error_code = 'CF002');
    end if;

        -- update or create the category_uom record
    if (select count(*) from converter.category_to_conversion_set ctcs
            where ctcs.conversion_set_id = lu_user_conversion_set_id and data_category_id = in_data_category_id) = 1 then
        update converter.category_to_conversion_set  set uom_id = in_uom_id, updated = now(), updated_by = in_user_id
            where conversion_set_id = lu_user_conversion_set_id and data_category_id = in_data_category_id;
    else
         insert into converter.category_to_conversion_set
            (active, conversion_set_id,data_category_id, uom_id, created, created_by, updated, updated_by)
        values
            (true, lu_user_conversion_set_id, in_data_category_id, in_uom_id, now(), in_user_id, now(), in_user_id);
     end if;

    --check to confirm it was added.
    if (select count(*) from converter.category_to_conversion_set ctcs
            where ctcs.conversion_set_id = lu_user_conversion_set_id
                and ctcs.data_category_id = in_data_category_id
                and ctcs.uom_id = in_uom_id) = 0
        then
        raise exception sqlstate 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    -- return successful confirmation
    return true;
end
$$;

-- Add a new empty conversion_set to the converter
CREATE OR REPLACE FUNCTION converter.update_target_conversion_set_category(in_user_id int, in_conversion_set_id int,
                                    in_data_category_id int, in_uom_id int)

RETURNS bool
language plpgsql
as
$$
-- declare
--  outcome text;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_conversion_set_id is null OR in_data_category_id is NULL or in_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- ensure that the requested data_category exists
    if ((select id from converter.data_category where id = in_data_category_id) is null) then
        RAISE EXCEPTION SQLSTATE 'CF014' USING MESSAGE = (select error_description from converter.response where error_code = 'CF014');
    end if;

    -- ensure that the requested uom exists
    if ((select id from converter.uom where id = in_uom_id) is null) then
        RAISE EXCEPTION SQLSTATE 'CF009' USING MESSAGE = (select error_description from converter.response where error_code = 'CF009');
    end if;

    -- ensure that the requested conversion set exists
    if ((select id from converter.conversion_set  where id = in_conversion_set_id and active = true) is null) then
        RAISE EXCEPTION SQLSTATE 'CF013' USING MESSAGE = (select error_description from converter.response where error_code = 'CF013');
    end if;

    -- update or create the category_uom record
    if (select count(*) from converter.category_to_conversion_set ctcs
            where ctcs.conversion_set_id = in_conversion_set_id and ctcs.data_category_id = in_data_category_id) = 1 then
        update converter.category_to_conversion_set set uom_id = in_uom_id, updated = now(), updated_by = in_user_id
            where conversion_set_id = in_conversion_set_id and data_category_id = in_data_category_id;
    else
         insert into converter.category_to_conversion_set
            (active, conversion_set_id,data_category_id, uom_id, created, created_by, updated, updated_by)
        values
            (true, in_conversion_set_id, in_data_category_id, in_uom_id, now(), in_user_id, now(), in_user_id);
    end if;

    --check to confirm it was added.
    if (select count(*) from converter.category_to_conversion_set ctcs
            where ctcs.conversion_set_id = in_conversion_set_id
                and ctcs.data_category_id = in_data_category_id
                and ctcs.uom_id = in_uom_id) = 0
        then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    -- return successful confirmation
    return true;
end
$$;