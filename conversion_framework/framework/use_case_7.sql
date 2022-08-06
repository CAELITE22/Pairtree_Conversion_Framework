-- # use case 7 - add/delete/update a UOM

/*
 activity list:
 add - add a UOM - return new UOM id if added, if error return -1
 delete - delete a datatype by id + delete a datatype by name - if succesful return text "datatype X has been deleted else return descript error,
 "data type X does not exist"
 update - update a UOM with defined ID, or name, with the passed parameters

 [ UOM
    active: boolean,
    created: timestamp,
    created_by: id,
    updated: timestamp,
    updated_by: id
    data_type_id: id (FK),
    id: id,
    lower_boundary: real,
    upper_boundary: real,
    upper_uom: id,
    lower_uom: id,
    owner_user_id: id (FK),
    uom_name: text,
    uom_abbreviation: text,
    precision: int,
    active: bool

 ]
 */

-- add a new UOM
CREATE OR REPLACE FUNCTION converter.add_uom(
    in_user_id int,
    in_data_type_id int,
    in_uom_name text,
    in_uom_abbreviation text,
    in_prec int, in_upper_uom int,
    in_lower_uom int,
    in_upper_boundary real,
    in_lower_boundary real,
    in_active boolean
    )

RETURNS text
language plpgsql
as
$$
DECLARE new_id int;
-- declare variables
begin

    -- ensure that the non-nullable values - in_user_id, data_type_id, uom_name are not null
    -- if uom_abbreviation is NULL, it defaults to uom_name
    -- currently unsure about what to do about prec
    -- upper_uom, lower_uom, upper_boundary, lower_boundary are completely nullable
    -- active defaults to false
    if(in_user_id is NULL OR in_data_type_id is NULL OR in_uom_name is NULL OR in_uom_abbreviation is NULL) then
        return concat('ERROR! cannot input NULL values for in_user_id, data_type_id or uom_name');
    end if;

    -- ensure that data_type_id exists
    if (select count(*) from converter.data_type where id = in_data_type_id) = 0 then
        return concat('ERROR! the entered data_type_id does not match a record the exists in the data_type table');
    end if;

    -- need to ask a question about owner_user_id here
    -- is it possible for multiples of the same uom_text to exist, so long as they don't belong to the same owner_user_id?
    -- that is, can two different users create a uom with the same name, that belongs to the same data_type, but perhaps has a different upper_uom?
    -- either way, something probably needs to be put here, to at the minimum make sure two exact uom's don't be created
    if (select count(*) from converter.uom where data_type_id = in_data_type_id AND uom_name = in_uom_name) > 0 then
        return concat('ERROR! the entered combination of uom_name and data_type_id already exist in the table');
    end if;

    -- create the new uom
    insert into converter.uom (data_type_id, uom_name, uom_abbreviation, precision, upper_boundary, lower_boundary, upper_uom, lower_uom, owner_user_id, created, updated, created_by, updated_by, active)
                values        (in_data_type_id, in_uom_name, in_uom_abbreviation, in_prec, in_upper_boundary, in_lower_boundary, in_upper_uom, in_lower_uom, in_user_id, now(), now(), in_user_id, in_user_id, in_active);

    -- get the id of the recently added uom
    select id from converter.uom where data_type_id = in_data_type_id AND uom_name = in_uom_name into new_id;

    return concat(new_id);

end
$$;
-- a function to delete by uom_id
    -- i'm not entirely sure a function the deletes by uom_name makes sense
    -- because it is entirely reasonable that two uom's share the same name
    -- even that have the same data_type_id
    -- consider the case of m2, two different people might prefer there upper_uom to be two different things, name hectares and acres.
    -- where all of the other fields will be exact
    -- is it more reasonable to allow uom's to be deleted by name, unless a count query returns something >1?
CREATE OR REPLACE FUNCTION converter.delete_uom(
    in_uom_id int
    )

RETURNS text
language plpgsql
as
$$
-- declare
--     outcome text;
begin

    if(select count(*) from converter.uom where id = in_uom_id) = 0 then
        return concat('ERROR! the entered id does not match an entry in the UOM table');
    end if;
    -- this will not fail or throw an error if the previous if does not end the function
    DELETE FROM converter.uom
    WHERE id = in_uom_id;

    return concat(in_uom_id);

end
$$;

/*
    a function to update a uom
    many questions about this, namely if it's going to be one function, how do we differentiate between fields that are to be updated? null is not a reasonable value to pass through
    as some values in the table may in fact be null, namely upper_uom, precision? maybe?, lower_boundary etc.
 */
CREATE OR REPLACE FUNCTION converter.update_uom()

RETURNS text
language plpgsql
as
$$
-- declare
--     outcome text;
begin


end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_data_type(
    in_user_id int,
    in_uom_id int,
    in_data_type_id int
)

RETURNS text
language plpgsql
as
$$
-- declare
--     outcome text;
begin
    if(in_user_id is NULL OR in_uom_id is NULL or in_data_type_id is NULL) then
        return concat('in_user_id, in_uom_id or in_data_type_id cannot be null');
    end if;

    if(select(*) from converter.uom where id = in_uom_id) = 0 then
        return concat('uom with id: ' + in_uom_id + ' , does not exist');
    end if;

    if(select(*) from converter.data_type where id = in_data_type_id) = 0 then
        return concat('data_type with id: ' + in_data_type_id + ' , does not exist');
    end if;

    UPDATE converter.uom
    SET
        data_type_id = in_data_type_id,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if(select count(*) from converter.uom WHERE id = in_uom_id AND data_type_id = in_data_type_id) then
        return concat('uom successfully updated');
    end if;

    return concat('error updating uom');
end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_name(
    in_user_id int,
    in_uom_id int,
    in_uom_name text,
    in_uom_abbreviation text
)

RETURNS text
language plpgsql
as
$$
-- declare
--     outcome text;
begin

    if(in_user_id is NULL OR in_uom_id is NULL OR in_uom_name is NULL OR in_uom_abbreviation is NULL) then
        return concat('in_user_id, in_uom_id, in_uom_name or in_uom_abbreviation cannot be null');
    end if;

    if(select(*) from converter.uom where id = in_uom_id) = 0 then
        return concat('uom with id: ' + in_uom_id + ' , does not exist');
    end if;

    UPDATE converter.uom
    SET
        uom_name = in_uom_name,
        uom_abbreviation = in_uom_abbreviation,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if(select count(*) from converter.uom WHERE id = in_uom_id AND uom_name = in_uom_name AND uom_abbreviation = in_uom_abbreviation) then
        return concat('uom successfully updated');
    end if;

    return concat('error updating uom');
end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_precision(
    in_user_id int,
    in_uom_id int,
    in_prec int
)

RETURNS text
language plpgsql
as
$$
-- declare
--     outcome text;
begin
    if(in_user_id is NULL OR in_uom_id is NULL or in_prec is NULL) then
        return concat('in_user_id, in_uom_id or in_prec cannot be null');
    end if;

    if(select(*) from converter.uom where id = in_uom_id) = 0 then
        return concat('uom with id: ' + in_uom_id + ' , does not exist');
    end if;

    UPDATE converter.uom
    SET
        precision = in_prec,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if(select count(*) from converter.uom WHERE id = in_uom_id AND precision = in_prec) then
        return concat('uom successfully updated');
    end if;

    return concat('error updating uom');

end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_lower(
    in_user_id int,
    in_uom_id int,
    in_lower_boundary real,
    in_lower_uom int
)

RETURNS text
language plpgsql
as
$$
-- declare
--     outcome text;
begin
    if(in_user_id is NULL OR in_uom_id is NULL) then
        return concat('in_user_id or in_uom_id  cannot be null');
    end if;

    if(select(*) from converter.uom where id = in_uom_id) = 0 then
        return concat('uom with id: ' + in_uom_id + ' , does not exist');
    end if;

    UPDATE converter.uom
    SET
        lower_boundary = in_lower_boundary,
        lower_uom = in_lower_uom,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if(select count(*) from converter.uom WHERE id = in_uom_id AND lower_boundary = in_lower_boundary AND lower_uom = in_lower_uom) then
        return concat('uom successfully updated');
    end if;

    return concat('error updating uom');

end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_upper(
    in_user_id int,
    in_uom_id int,
    in_upper_boundary real,
    in_upper_uom int
)

RETURNS text
language plpgsql
as
$$
-- declare
--     outcome text;
begin
    if(in_user_id is NULL OR in_uom_id is NULL ) then
        return concat('in_user_id or in_uom_id cannot be null');
    end if;

    if(select(*) from converter.uom where id = in_uom_id) = 0 then
        return concat('uom with id: ' + in_uom_id + ' , does not exist');
    end if;

    UPDATE converter.uom
    SET
        upper_boundary = in_upper_boundary,
        upper_uom = in_upper_uom,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if(select count(*) from converter.uom WHERE id = in_uom_id AND upper_boundary = in_upper_boundary AND upper_uom = in_upper_uom) then
        return concat('uom successfully updated');
    end if;

    return concat('error updating uom');
end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_isActive(
    in_user_id int,
    in_uom_id int,
    in_active boolean
)

RETURNS text
language plpgsql
as
$$
-- declare
--     outcome text;
begin

    if(in_user_id is NULL OR in_uom_id is NULL or in_active is NULL) then
        return concat('in_user_id, in_uom_id or in_active cannot be null');
    end if;

    if(select(*) from converter.uom where id = in_uom_id) = 0 then
        return concat('uom with id: ' + in_uom_id + ' , does not exist');
    end if;

    UPDATE converter.uom
    SET
        active = in_active,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if(select count(*) from converter.uom WHERE id = in_uom_id AND active = in_active) then
        return concat('uom successfully updated');
    end if;

    return concat('error updating uom');
end
$$;

