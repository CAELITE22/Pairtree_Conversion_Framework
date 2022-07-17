-- # use case 8 - add/delete/update a data type


/*
 activity list:
 - add - add a datatype - return text "Datatype X has been created with id: Y"
 - delete - deactivate a datatype return text "Datatype X has been disabled"
 - update - update a datatype return text "Datatype has been updated from X to Y"
 - search - search for a datatype - return ID if exists, return -1 no not exists
 */

CREATE OR REPLACE FUNCTION converter.add_data_type(in_user_id int, data_type_name text)
-- in_user_id int, in_uom text, in_data_category text, in_value float)
RETURNS text
language plpgsql
as
$$
declare
    outcome text;
begin
    if (select count(*) from converter.data_type where name = data_type_name) > 0 then
        return concat('The data type ',data_type_name, ' already exists');
    end if;
    insert into converter.data_type (name, translation, created, created_by, updated, updated_by, active)
            values (data_type_name, false, now(), in_user_id, now(), in_user_id, true);
        --check to confirm it was added
    if (select count(*) from converter.data_type where name = data_type_name) > 0 then
        return concat('Data type ', data_type_name, ' was added successfully');
    end if;
    return concat('There was a problem adding data type ',data_type_name);
end
$$;


CREATE OR REPLACE FUNCTION converter.update_data_type(in_user_id int, data_type_name text, new_type_name text)
-- in_user_id int, in_uom text, in_data_category text, in_value float)
RETURNS text
language plpgsql
as
$$
declare
    outcome text;
begin
    if (select count(*) from converter.data_type where name = data_type_name) > 0 then
        return concat('The data type ',data_type_name, ' already exists');
    end if;
    insert into converter.data_type (name, translation, created, created_by, updated, updated_by, active)
            values (data_type_name, false, now(), in_user_id, now(), in_user_id, true);
        --check to confirm it was added
    if (select count(*) from converter.data_type where name = data_type_name) > 0 then
        return concat('Data type ', data_type_name, ' was added successfully');
    end if;
    return concat('There was a problem adding data type ',data_type_name);
end
$$;
