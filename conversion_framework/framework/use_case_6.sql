-- Add a new empty conversion_set to the converter
CREATE OR REPLACE FUNCTION converter.update_default_conversion_set_category_uom(in_user_id int, in_data_category_name text, in_uom_name text)

RETURNS text
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
        return concat('Error! Cannot input <NULL> values.');
    end if;

    -- ensure that the requested data_category exists
    lu_data_category_id = (select id from converter.data_category where name = in_data_category_name);
    if (lu_data_category_id = -1) then
        return concat('Error! The specified data category does not exist.');
    end if;

    -- ensure that the requested uom exists
    lu_uom_id = (select id from converter.uom where uom_name = in_uom_name);
    if (lu_uom_id = -1) then
        return concat('Error! The specified uom does not exist.');
    end if;

    -- ensure that the requested conversion set exists
    lu_user_conversion_set_id = (select conversion_set_id from converter.user_conversion_set ucs where ucs.user_id = in_user_id and ucs.active = true);
    if (lu_user_conversion_set_id = -1) then
        return concat('Error! The specified user does not have a default conversion set.');
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
        return concat('Error! There was a problem updating the conversion set.');
    end if;

    -- return successful confirmation
    return concat('Conversion set was updated successfully.');
end
$$;


-- Add a new empty conversion_set to the converter
CREATE OR REPLACE FUNCTION converter.update_target_conversion_set_category(in_user_id int, in_conversion_set_name text,
                                    in_data_category_name text, in_uom_name text)

RETURNS text
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
        return concat('Error! Cannot input <NULL> values.');
    end if;

    -- ensure that the requested data_category exists
    lu_data_category_id = (select id from converter.data_category where name = in_data_category_name);
    if (lu_data_category_id = -1) then
        return concat('Error! The specified data category does not exist.');
    end if;

    -- ensure that the requested uom exists
    lu_uom_id = (select id from converter.uom where uom_name = in_uom_name);
    if (lu_uom_id = -1) then
        return concat('Error! The specified uom does not exist.');
    end if;

    -- ensure that the requested conversion set exists
    lu_conversion_set_id = (select id from converter.conversion_set  where name = in_conversion_set_name and active = true);
    if (lu_conversion_set_id = -1) then
        return concat('Error! The specified user does not have a default conversion set.');
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
        return concat('Error! There was a problem updating the conversion set.');
    end if;

    -- return successful confirmation
    return concat('Conversion set was updated successfully.');
end
$$;