truncate table converter.response;
insert into converter.response (error_code, error_description) values
('CF000','Error! An unknown error occurred while performing this action.'),
('CF001','Error! Cannot input <NULL> values.'),
('CF002','Error! User does not have a default conversion set.'),
('CF003','Error! The supplied in_data_category_id does not exist.'),
('CF004','Error! The UOM for this data category is not set in the conversion set.'),
('CF005','Error! The supplied in_uom_name is not found in the UOM list.'),
('CF006','Error! The origin and destination UOMs are not of the same data type.'),
('CF007','Error! The supplied in_conversion_set does not exist.'),
('CF008','Error! The supplied out_oum_id does not exist.'),
('CF009','Error! The supplied in_uom_id does not exist.'),
('CF010','Error! The supplied in_uom_abbr does not exist.'),
('CF011','Error! The supplied destination_conversion_set_name already exists.'),
('CF012','Error! The supplied source_conversion_set_name does not exist.'),
('CF013','Error! The supplied in_conversion_set_name does not exist.'),
('CF014','Error! The supplied in_data_category_id does not exist.'),
('CF015','Error! The supplied in_data_type_id does not exist.'),
('CF016','Error! The supplied UOM already exists in this data type.'),
('CF017','Error! The supplied in_uom_name or in_uom_abbr already exists.'),
('CF018','Error! Boundary and UOM values must either be specified or both be null.'),
('CF019','Error! The UOM and boundary UOM are not of the same type.'),
('CF020','Error! The supplied boundary UOM does not exist.'),
('CF021','Error! The supplied data_type_name already exists.'),
('CF022','Error! The supplied in_data_type_name is not found in the Data Type list.'),
('CF023','Error! The supplied in_data_category_name already exists.'),
('CF024','Error! The supplied in_data_category_id has dependencies and cannot be disabled.'),
('CF025','Error! The supplied in_data_category_name is not found in the Data Category list.');-- # this conversion process uses the users default conversion set - numerical values only
CREATE OR REPLACE FUNCTION converter.convert(in_user_id int, in_uom_id int, in_data_category_id int, in_value float)
RETURNS real
language plpgsql
as
$$
declare
    lu_conversion_set_id integer;
    out_uom_id integer;
    in_values record;
    out_values record;
    out_precision integer;
    converted_value real;
begin
    -- check for null value input
    if (in_value is NULL) then
        return null;
    end if;
    -- Ensure there are no other NULL values
    if (in_user_id is NULL OR in_uom_id is NULL OR in_data_category_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    lu_conversion_set_id = (select conversion_set_id from converter.user_conversion_set a
        where a.user_id = in_user_id and a.active = TRUE);
    if (lu_conversion_set_id is null) then
            RAISE EXCEPTION SQLSTATE 'CF002' USING MESSAGE = (select error_description from converter.response where error_code = 'CF002');
    end if;

    if ((select count(id) from converter.data_category where id = in_data_category_id) = 0) then
            RAISE EXCEPTION SQLSTATE 'CF003' USING MESSAGE = (select error_description from converter.response where error_code = 'CF003');
    end if;

    out_uom_id = (select uom_id from converter.category_to_conversion_set
        where conversion_set_id = lu_conversion_set_id and data_category_id = in_data_category_id);
    if (out_uom_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF004' USING MESSAGE = (select error_description from converter.response where error_code = 'CF004');
    end if;

    if ((select count(id) from converter.uom where id = in_uom_id) = 0) then
            RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    if ((select data_type_id from converter.uom where id = in_uom_id) <> (select data_type_id from converter.uom where id = out_uom_id)) then
        RAISE EXCEPTION SQLSTATE 'CF006' USING MESSAGE = (select error_description from converter.response where error_code = 'CF006');
    end if;

    if in_uom_id <> out_uom_id then
        select rate, constant into in_values from converter.conversion_rate
            where uom_id = in_uom_id;
        select rate, constant into out_values from converter.conversion_rate
            where uom_id = out_uom_id;
        out_precision := precision from converter.uom where id = out_uom_id;
        converted_value = (out_values.rate*(in_value-in_values.constant))/in_values.rate
                              + out_values.constant;

        if (out_precision is not null) then
                converted_value = round(converted_value::numeric,out_precision);
        end if;
        return converted_value;
    end if;
    return in_value;
end;
$$;
-- # this conversion process uses the users default conversion set - numerical values only

CREATE OR REPLACE FUNCTION converter.convert_by_conversion_set(in_user_id int, in_conversion_set_id int, in_uom_id int, in_data_category_id int, in_value float)
RETURNS real
language plpgsql
as
$$
declare
    out_uom_id integer;
    in_values record;
    out_values record;
    out_precision integer;
    converted_value real;
begin
    -- check for null value input
    if (in_value is NULL) then
        return null;
    end if;
    -- Ensure there are no other NULL values
    if (in_user_id is NULL OR in_uom_id is NULL OR in_data_category_id is NULL OR in_conversion_set_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    if ((select count(id) from converter.conversion_set where id = in_conversion_set_id) = 0) then
            RAISE EXCEPTION SQLSTATE 'CF007' USING MESSAGE = (select error_description from converter.response where error_code = 'CF007');
    end if;

    if ((select count(id) from converter.data_category where id = in_data_category_id) = 0) then
            RAISE EXCEPTION SQLSTATE 'CF003' USING MESSAGE = (select error_description from converter.response where error_code = 'CF003');
    end if;

    out_uom_id = (select uom_id from converter.category_to_conversion_set
        where conversion_set_id = in_conversion_set_id and data_category_id = in_data_category_id);
    if (out_uom_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF004' USING MESSAGE = (select error_description from converter.response where error_code = 'CF004');
    end if;

    if ((select count(id) from converter.uom where id = in_uom_id) = 0) then
            RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    if ((select data_type_id from converter.uom where id = in_uom_id) <> (select data_type_id from converter.uom where id = out_uom_id)) then
        RAISE EXCEPTION SQLSTATE 'CF006' USING MESSAGE = (select error_description from converter.response where error_code = 'CF006');
    end if;

    if in_uom_id <> out_uom_id then
        select rate, constant into in_values from converter.conversion_rate
            where uom_id = in_uom_id;
        select rate, constant into out_values from converter.conversion_rate
            where uom_id = out_uom_id;
        out_precision := precision from converter.uom where id = out_uom_id;
        converted_value = (out_values.rate*(in_value-in_values.constant))/in_values.rate
                              + out_values.constant;
        if (out_precision is not null) then
                converted_value = round(converted_value::numeric,out_precision);
        end if;
        return converted_value;
    end if;
    return in_value;
end;
$$;
-- # this conversion process uses the specified UOM
CREATE OR REPLACE FUNCTION converter.convert_by_uom(in_user_id int, in_uom_id int, out_uom_id int, in_value float)
RETURNS real
language plpgsql
as
$$
declare
    in_values record;
    out_values record;
    out_precision integer;
    converted_value real;
begin
    -- check for null value input
    if (in_value is NULL) then
        return null;
    end if;
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_uom_id is NULL OR out_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    if ((select count(id) from converter.uom where id = out_uom_id) = 0) then
            RAISE EXCEPTION SQLSTATE 'CF008' USING MESSAGE = (select error_description from converter.response where error_code = 'CF008');
    end if;

    if ((select count(id) from converter.uom where id = in_uom_id) = 0) then
            RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    if ((select data_type_id from converter.uom where id = in_uom_id) <> (select data_type_id from converter.uom where id = out_uom_id)) then
        RAISE EXCEPTION SQLSTATE 'CF006' USING MESSAGE = (select error_description from converter.response where error_code = 'CF006');
    end if;

    if in_uom_id <> out_uom_id then
        select rate, constant into in_values from converter.conversion_rate
            where uom_id = in_uom_id;
        select rate, constant into out_values from converter.conversion_rate
            where uom_id = out_uom_id;
        out_precision = (select precision from converter.uom where id = out_uom_id);
        converted_value = (out_values.rate*(in_value-in_values.constant))/in_values.rate
                              + out_values.constant;
        if (out_precision is not null) then
                converted_value = round(converted_value::numeric,out_precision);
        end if;

        return converted_value;
    end if;
    return in_value;
end;
$$;create or replace function converter.set_user_conversion_set(
    in_user_id int,
    in_conversion_set_id int
)

returns bool
language plpgsql
as
$$
-- declare
BEGIN
    if (in_conversion_set_id is null or in_user_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;
    
    if ((select count(*) from converter.conversion_set where id = in_conversion_set_id) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF007' USING MESSAGE = (select error_description from converter.response where error_code = 'CF007');
    end if;
    
    if (in_user_id not in (select user_id from converter.user_conversion_set)) then
        insert into converter.user_conversion_set (user_id, conversion_set_id, created, updated, updated_by, created_by, active)
            values (in_user_id, in_conversion_set_id,now(),now(),in_user_id,in_user_id,true);
    else
        update converter.user_conversion_set
        set
            conversion_set_id = in_conversion_set_id,
            updated_by = in_user_id,
            updated = now()
        where user_id = in_user_id;
    end if;

    if (select count(*) from converter.user_conversion_set where user_id = in_user_id and conversion_set_id = in_conversion_set_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

create or replace function converter.get_user_conversion_set_id(
    in_user_id int
)

returns int
language plpgsql
as
$$
declare
    out_conversion_set_id int;
BEGIN
    if (in_user_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    out_conversion_set_id = (select conversion_set_id from converter.user_conversion_set where user_id = in_user_id and active = true);
    if (out_conversion_set_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF002' USING MESSAGE = (select error_description from converter.response where error_code = 'CF002');
    end if;

    return out_conversion_set_id;
end
$$;-- Add a new empty conversion_set to the converter
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
    if (select count(*) from converter.conversion_set where lower(name) = lower(conversion_set_name)) > 0 then
        RAISE EXCEPTION SQLSTATE 'CF011' USING MESSAGE = (select error_description from converter.response where error_code = 'CF011');
    end if;
    -- create the new conversion_set
    insert into converter.conversion_set (name, created, created_by, updated, updated_by, owner_user_id, active)
            values (conversion_set_name, now(), in_user_id, now(), in_user_id, in_user_id, true);

    --check to confirm it was added.
    conversion_set_id = (select id from converter.conversion_set where lower(name) = lower(conversion_set_name));
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
    if (select count(*) from converter.conversion_set where lower(name) = lower(destination_conversion_set_name)) > 0 then
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

    outcome = (select id from converter.conversion_set where lower(name) = lower(conversion_set_name) and active = true);
    if (outcome is null) then
        RAISE EXCEPTION SQLSTATE 'CF012' USING MESSAGE = (select error_description from converter.response where error_code = 'CF012');
    end if;

    --return value if no exception is raised.
        return outcome;
end
    $$;
-- Updates a category UOM in the users default conversion set
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

-- Updates a category UOM in a specified conversion set
CREATE OR REPLACE FUNCTION converter.update_target_conversion_set_category_uom(in_user_id int, in_conversion_set_id int,
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
$$;-- # use case 7 - add/delete/update a UOM
-- add a new UOM
CREATE OR REPLACE FUNCTION converter.add_uom(
    in_user_id int,
    in_data_type_id int,
    in_uom_name text,
    in_uom_abbreviation text,
    in_rate real,
    in_constant real,
    in_prec int default 3,
    in_upper_uom int default null,
    in_lower_uom int default null,
    in_upper_boundary real default null,
    in_lower_boundary real default null,
    in_active boolean default true
    )

RETURNS int
language plpgsql
as
$$
DECLARE new_id int;
-- declare variables
begin

    -- ensure that the non-nullable values - in_user_id, data_type_id, uom_name are not null
    -- if uom_abbreviation is NULL, it defaults to uom_name
    -- upper_uom, lower_uom, upper_boundary, lower_boundary are completely nullable
    -- active defaults to true
    if (in_user_id is NULL OR in_data_type_id is NULL OR in_uom_name is NULL OR in_uom_abbreviation is NULL OR
        in_rate is NULL or in_constant is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- ensure that data_type_id exists
    if (select count(*) from converter.data_type where id = in_data_type_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF015' USING MESSAGE = (select error_description from converter.response where error_code = 'CF015');
    end if;

    --check that the name does not exist for that data type
    if (select count(*) from converter.uom where data_type_id = in_data_type_id AND lower(uom_name) = lower(in_uom_name)) > 0 then
        RAISE EXCEPTION SQLSTATE 'CF016' USING MESSAGE = (select error_description from converter.response where error_code = 'CF016');
    end if;

    --check that the name and abbreviation does not exist
    if (select count(*) from converter.uom where uom_name = in_uom_name or uom_abbreviation = in_uom_abbreviation) > 0 then
        RAISE EXCEPTION SQLSTATE 'CF017' USING MESSAGE = (select error_description from converter.response where error_code = 'CF017');
    end if;

    -- create the new uom
    insert into converter.uom (data_type_id, uom_name, uom_abbreviation, precision, upper_boundary, lower_boundary, upper_uom, lower_uom, owner_user_id, created, updated, created_by, updated_by, active)
                values (in_data_type_id, in_uom_name, in_uom_abbreviation, in_prec, in_upper_boundary, in_lower_boundary, in_upper_uom, in_lower_uom, in_user_id, now(), now(), in_user_id, in_user_id, in_active);

    -- get the id of the recently added uom
    new_id = (select id from converter.uom where data_type_id = in_data_type_id AND uom_name = in_uom_name);

    if (new_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    insert into converter.conversion_rate (uom_id, rate, constant, created, updated, created_by, updated_by, active)
        values (new_id, in_rate, in_constant, now(), now(), in_user_id, in_user_id, true);
    return new_id;

end
$$;

-- Enable/Disable an existing data type
CREATE OR REPLACE FUNCTION converter.set_enabled_uom(in_user_id int, in_uom_id int, isEnabled boolean)

RETURNS bool
language plpgsql
as
$$
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_uom_id is NULL OR isEnabled is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- Ensure the id exists
    if (select count(*) from converter.uom where id = in_uom_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    -- Enable/Disable the uom
    UPDATE converter.uom
    SET active = isEnabled,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    -- check to confirm the data type was updated
    if (select count(*) from converter.uom where id = in_uom_id AND active = isEnabled) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_data_type(
    in_user_id int,
    in_uom_id int,
    in_data_type_id int
)

RETURNS bool
language plpgsql
as
$$
-- declare
--     outcome text;
begin
    if(in_user_id is NULL OR in_uom_id is NULL or in_data_type_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    if(select count(*) from converter.uom where id = in_uom_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    if(select count(*) from converter.data_type where id = in_data_type_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF015' USING MESSAGE = (select error_description from converter.response where error_code = 'CF015');
    end if;

    UPDATE converter.uom
    SET
        data_type_id = in_data_type_id,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if ((select count(*) from converter.uom WHERE id = in_uom_id AND data_type_id = in_data_type_id)=0) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_name_and_abbr(
    in_user_id int,
    in_uom_id int,
    in_uom_name text,
    in_uom_abbreviation text
)

RETURNS bool
language plpgsql
as
$$
-- declare
--     outcome text;
begin

    if(in_user_id is NULL OR in_uom_id is NULL OR in_uom_name is NULL OR in_uom_abbreviation is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    if(select count(*) from converter.uom where id = in_uom_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    if((((select count(*) from converter.uom where lower(uom_name) = lower(in_uom_name)) > 0) or ((select count(*) from converter.uom where uom_abbreviation = in_uom_abbreviation) > 0 ))) then
        RAISE EXCEPTION SQLSTATE 'CF017' USING MESSAGE = (select error_description from converter.response where error_code = 'CF017');
    end if;

    UPDATE converter.uom
    SET
        uom_name = in_uom_name,
        uom_abbreviation = in_uom_abbreviation,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if ((select count(*) from converter.uom WHERE id = in_uom_id AND uom_name = in_uom_name AND uom_abbreviation = in_uom_abbreviation) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_name(
    in_user_id int,
    in_uom_id int,
    in_uom_name text
)

RETURNS bool
language plpgsql
as
$$
-- declare
--     outcome text;
begin

    if(in_user_id is NULL OR in_uom_id is NULL OR in_uom_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    if(select count(*) from converter.uom where id = in_uom_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    if(select count(*) from converter.uom where lower(uom_name) = lower(in_uom_name)) > 0 then
        RAISE EXCEPTION SQLSTATE 'CF017' USING MESSAGE = (select error_description from converter.response where error_code = 'CF017');
    end if;

    UPDATE converter.uom
    SET
        uom_name = in_uom_name,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if ((select count(*) from converter.uom WHERE id = in_uom_id AND uom_name = in_uom_name) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_abbr(
    in_user_id int,
    in_uom_id int,
    in_uom_abbreviation text
)

RETURNS bool
language plpgsql
as
$$
-- declare
--     outcome text;
begin

    if(in_user_id is NULL OR in_uom_id is NULL OR in_uom_abbreviation is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    if(select count(*) from converter.uom where id = in_uom_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF009' USING MESSAGE = (select error_description from converter.response where error_code = 'CF009');
    end if;

    if(select count(*) from converter.uom where uom_abbreviation = in_uom_abbreviation) > 0 then
        RAISE EXCEPTION SQLSTATE 'CF017' USING MESSAGE = (select error_description from converter.response where error_code = 'CF017');
    end if;

    UPDATE converter.uom
    SET
        uom_abbreviation = in_uom_abbreviation,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if ((select count(*) from converter.uom WHERE id = in_uom_id AND uom_abbreviation = in_uom_abbreviation) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_rate_constant(
    in_user_id int,
    in_uom_id int,
    in_rate real,
    in_constant real
)

RETURNS bool
language plpgsql
as
$$
BEGIN
    if (in_user_id is NULL or in_uom_id is NULL or in_constant is NULL or in_rate is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    if((select count(*) from converter.conversion_rate where uom_id = in_uom_id) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF009' USING MESSAGE = (select error_description from converter.response where error_code = 'CF009');
    end if;

    UPDATE converter.conversion_rate
    SET
        rate = in_rate,
        constant = in_constant,
        updated = now(),
        updated_by = in_user_id
    where uom_id = in_uom_id;

    if ((select count(*) from converter.conversion_rate cr WHERE uom_id = in_uom_id and rate = in_rate and cr.constant = in_constant) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end;
$$;



CREATE OR REPLACE FUNCTION converter.update_uom_precision(
    in_user_id int,
    in_uom_id int,
    in_prec int
)

RETURNS bool
language plpgsql
as
$$
-- declare
--     outcome text;
begin
    if(in_user_id is NULL OR in_uom_id is NULL or in_prec is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    if(select count(*) from converter.uom where id = in_uom_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    UPDATE converter.uom
    SET
        precision = in_prec,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if ((select count(*) from converter.uom WHERE id = in_uom_id AND precision = in_prec) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;

end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_lower(
    in_user_id int,
    in_uom_id int,
    in_lower_boundary real default null,
    in_lower_uom int default null
)

RETURNS bool
language plpgsql
as
$$
-- declare
--     outcome text;
begin
    if(in_user_id is NULL OR in_uom_id is NULL ) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    if((in_lower_uom is NULL and in_lower_boundary is not NULL) OR (in_lower_uom is not NULL and in_lower_boundary is NULL)) then
        RAISE EXCEPTION SQLSTATE 'CF018' USING MESSAGE = (select error_description from converter.response where error_code = 'CF018');
    end if;

    if(select count(*) from converter.uom where id = in_uom_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    if(select count(*) from converter.uom where id = in_lower_uom) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF020' USING MESSAGE = (select error_description from converter.response where error_code = 'CF020');
    end if;

    if(select data_type_id from converter.uom where id = in_uom_id) <> (select data_type_id from converter.uom where id = in_lower_uom) then
        RAISE EXCEPTION SQLSTATE 'CF019' USING MESSAGE = (select error_description from converter.response where error_code = 'CF019');
    end if;

    UPDATE converter.uom
    SET
        lower_boundary = in_lower_boundary,
        lower_uom = in_lower_uom,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if ((select count(*) from converter.uom WHERE id = in_uom_id AND lower_boundary = in_lower_boundary AND lower_uom = in_lower_uom) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

CREATE OR REPLACE FUNCTION converter.update_uom_upper(
    in_user_id int,
    in_uom_id int,
    in_upper_boundary real default null,
    in_upper_uom int default null
)

RETURNS bool
language plpgsql
as
$$
-- declare
--     outcome text;
begin
    if(in_user_id is NULL OR in_uom_id is NULL ) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    if((in_upper_uom is NULL and in_upper_boundary is not NULL) OR (in_upper_uom is not NULL and in_upper_boundary is NULL)) then
        RAISE EXCEPTION SQLSTATE 'CF018' USING MESSAGE = (select error_description from converter.response where error_code = 'CF018');
    end if;

    if(select count(*) from converter.uom where id = in_uom_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    if(select count(*) from converter.uom where id = in_upper_uom) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF020' USING MESSAGE = (select error_description from converter.response where error_code = 'CF020');
    end if;

    if(select data_type_id from converter.uom where id = in_uom_id) <> (select data_type_id from converter.uom where id = in_upper_uom) then
        RAISE EXCEPTION SQLSTATE 'CF019' USING MESSAGE = (select error_description from converter.response where error_code = 'CF019');
    end if;

    UPDATE converter.uom
    SET
        upper_boundary = in_upper_boundary,
        upper_uom = in_upper_uom,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_uom_id;

    if ((select count(*) from converter.uom WHERE id = in_uom_id AND upper_boundary = in_upper_boundary AND upper_uom = in_upper_uom) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

CREATE OR REPLACE FUNCTION converter.get_uom_id_from_name(
    in_user_id int,
    in_uom_name text
)

RETURNS int
language plpgsql
as
$$
declare
    uom_id int;
begin

    if(in_user_id is NULL OR in_uom_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = 'Error! Cannot input <NULL> values.';
    end if;

    uom_id = (select id from converter.uom where lower(uom_name) = lower(in_uom_name));
    if uom_id is null then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    return uom_id;
end
$$;

CREATE OR REPLACE FUNCTION converter.get_uom_id_from_abbreviation(
    in_user_id int,
    in_uom_abbr text
)

RETURNS int
language plpgsql
as
$$
declare
    uom_id int;
begin

    if(in_user_id is NULL OR in_uom_abbr is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    uom_id = (select id from converter.uom where uom_abbreviation = in_uom_abbr);
    if uom_id is null then
        RAISE EXCEPTION SQLSTATE 'CF010' USING MESSAGE = (select error_description from converter.response where error_code = 'CF010');
    end if;

    return uom_id;
end
$$;

CREATE OR REPLACE FUNCTION converter.get_uom_status_from_id(
    in_user_id int,
    in_uom_id int
)

RETURNS bool
language plpgsql
as
$$
declare
    uom_status bool;
begin

    if(in_user_id is NULL OR in_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    uom_status = (select active from converter.uom where id = in_uom_id);
    if uom_status is null then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    return uom_status;
end
$$;

CREATE OR REPLACE FUNCTION converter.get_uom_data_type_from_id(
    in_user_id int,
    in_uom_id int
)

RETURNS int
language plpgsql
as
$$
declare
    uom_data_type_id int;
begin

    if(in_user_id is NULL OR in_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    uom_data_type_id = (select data_type_id from converter.uom where id = in_uom_id);
    if uom_data_type_id is null then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    return uom_data_type_id;
end
$$;

CREATE OR REPLACE FUNCTION converter.get_uom_abbr_from_id(
    in_user_id int,
    in_uom_id int
)

RETURNS text
language plpgsql
as
$$
declare
    uom_abbr text;
begin

    if(in_user_id is NULL OR in_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    uom_abbr = (select uom_abbreviation from converter.uom where id = in_uom_id);
    if uom_abbr is null then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    return uom_abbr;
end
$$;


CREATE OR REPLACE FUNCTION converter.get_uom_name_from_id(
    in_user_id int,
    in_uom_id int
)

RETURNS text
language plpgsql
as
$$
declare
    out_uom_name text;
begin

    if(in_user_id is NULL OR in_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    out_uom_name = (select uom_name from converter.uom where id = in_uom_id);
    if out_uom_name is null then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    return out_uom_name;
end
$$;

CREATE OR REPLACE FUNCTION converter.get_uom_name_abbr_from_id(
    in_user_id int,
    in_uom_id int
)

RETURNS text
language plpgsql
as
$$
declare
    out_uom_concat text;
begin

    if(in_user_id is NULL OR in_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    out_uom_concat = (select (uom_name || '|' || uom.uom_abbreviation) from converter.uom where id = in_uom_id);
    if out_uom_concat is null then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    return out_uom_concat;
end
$$;

CREATE OR REPLACE FUNCTION converter.get_uom_prec_from_id(
    in_user_id int,
    in_uom_id int
)

RETURNS int
language plpgsql
as
$$
declare
    out_uom_prec text;
begin

    if(in_user_id is NULL OR in_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    out_uom_prec = (select precision from converter.uom where id = in_uom_id);
    if out_uom_prec is null then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    return out_uom_prec;
end
$$;

CREATE OR REPLACE FUNCTION converter.get_uom_lower_from_id(
    in_user_id int,
    in_uom_id int
)

RETURNS text
language plpgsql
as
$$
declare
    out_uom_concat text;
begin

    if(in_user_id is NULL OR in_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    if (select id from converter.uom where id = in_uom_id) is null then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;
    out_uom_concat = (select (lower_uom || '|' || lower_boundary) from converter.uom where id = in_uom_id);

    return out_uom_concat;
end
$$;

CREATE OR REPLACE FUNCTION converter.get_uom_upper_from_id(
    in_user_id int,
    in_uom_id int
)

RETURNS text
language plpgsql
as
$$
declare
    out_uom_concat text;
begin

    if(in_user_id is NULL OR in_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    if (select id from converter.uom where id = in_uom_id) is null then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;
    out_uom_concat = (select (upper_uom || '|' || upper_boundary) from converter.uom where id = in_uom_id);

    return out_uom_concat;
end
$$;

CREATE OR REPLACE FUNCTION converter.get_uom_rate_from_id(
    in_user_id int,
    in_uom_id int
)

RETURNS real
language plpgsql
as
$$
declare
    output real;
begin

    if(in_user_id is NULL OR in_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    output = (select rate from converter.conversion_rate where uom_id = in_uom_id);

    if (output is null) then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    return output;
end
$$;

CREATE OR REPLACE FUNCTION converter.get_uom_constant_from_id(
    in_user_id int,
    in_uom_id int
)

RETURNS real
language plpgsql
as
$$
declare
    output real;
begin

    if(in_user_id is NULL OR in_uom_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    output = (select constant from converter.conversion_rate where uom_id = in_uom_id);

    if (output is null) then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    return output;
end
$$;-- # use case 8 - add/delete/update a data type
-- Add a new data_type to the converter
CREATE OR REPLACE FUNCTION converter.add_data_type(in_user_id int, data_type_name text)

RETURNS int
language plpgsql
as
$$
declare
 data_type_id int;
begin

    -- Ensure there are no NULL values
    if (in_user_id is NULL OR data_type_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- ensure that the requested data_type does not already exist
    if (select count(*) from converter.data_type where lower(name) = lower(data_type_name)) > 0 then
        RAISE EXCEPTION SQLSTATE 'CF021' USING MESSAGE = (select error_description from converter.response where error_code = 'CF021');
    end if;
    -- create the new data_type
    insert into converter.data_type (name, translation, created, created_by, updated, updated_by, active)
            values (data_type_name, false, now(), in_user_id, now(), in_user_id, true);

    --check to confirm it was added.
    data_type_id = (select id from converter.data_type where name = data_type_name);

    if (data_type_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    -- return successful confirmation
    return data_type_id;
end
$$;

-- Update an existing data type
CREATE OR REPLACE FUNCTION converter.update_data_type(in_user_id int, in_data_type_id int, new_data_type_name text)

RETURNS bool
language plpgsql
as
$$
-- declare
--     outcome text;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_type_id is NULL OR new_data_type_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- Ensure the old name exists
    if ((select count(*) from converter.data_type where id = in_data_type_id) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF015' USING MESSAGE = (select error_description from converter.response where error_code = 'CF015');
    end if;

    -- Ensure the new name does not exist
    if ((select count(*) from converter.data_type where lower(name) = lower(new_data_type_name)) > 0) then
        RAISE EXCEPTION SQLSTATE 'CF021' USING MESSAGE = (select error_description from converter.response where error_code = 'CF021');
    end if;

    UPDATE converter.data_type
    SET name = new_data_type_name,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_data_type_id;

    -- check to confirm the data type was updated
    -- Ensure the new name now exists
    if ((select count(*) from converter.data_type where name = new_data_type_name) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

-- Enable/Disable an existing data type
CREATE OR REPLACE FUNCTION converter.set_enabled_data_type(in_user_id int, in_data_type_id int, isEnabled boolean)

RETURNS bool
language plpgsql
as
$$
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_type_id is NULL OR isEnabled is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- Ensure the old name exists
    if (select count(*) from converter.data_type where id = in_data_type_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF015' USING MESSAGE = (select error_description from converter.response where error_code = 'CF015');
    end if;

    -- Enable/Disable the data_type
    UPDATE converter.data_type
    SET active = isEnabled,
        updated = now(),
        updated_by = in_user_id
    WHERE id = in_data_type_id;

    -- check to confirm the data type was updated
    if ((select active from converter.data_type where id = in_data_type_id) <> isEnabled) then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$;

-- Get the id from a data_type
CREATE OR REPLACE FUNCTION converter.get_data_type_id_from_name(in_user_id int, in_data_type_name text)

RETURNS int
language plpgsql
as
$$
declare
    outcome int;
    num_records int;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_type_name is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- store the number of records for error checking - requires on one query.
    num_records = (select count(*) from converter.data_type where lower(name) = lower(in_data_type_name));

    -- return the ID
    if (num_records) = 1 then
        outcome = (select id from converter.data_type where lower(name) = lower(in_data_type_name));
        return outcome;
    end if;

    -- ensure that the requested data_type exists, or return -1 if it doesn't
    if (num_records) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF022' USING MESSAGE = (select error_description from converter.response where error_code = 'CF022');
    end if;

    -- if there are multiple records containing the same data type, return -2
    if (num_records) > 1 then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;
end
$$;

-- Get the id from a data_type
CREATE OR REPLACE FUNCTION converter.get_data_type_status_from_id(in_user_id int, in_data_type_id int)

RETURNS bool
language plpgsql
as
$$
declare
    data_type_status bool;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_data_type_id is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;

    -- store the number of records for error checking - requires on one query.
    data_type_status = (select active from converter.data_type where id = in_data_type_id);

    -- return the ID
    if (data_type_status is null) then
        RAISE EXCEPTION SQLSTATE 'CF015' USING MESSAGE = (select error_description from converter.response where error_code = 'CF015');
    end if;

    return data_type_status;
end
$$;-- # use case 9 - add/delete/update a data category
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
    if (select count(*) from converter.data_category where lower(name) = lower(in_data_category_name)) > 0 then
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
    if (select count(*) from converter.data_category where lower(name) = lower(new_data_category_name)) > 0 then
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
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
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
    data_category_id = (select id from converter.data_category where lower(name) = lower(in_data_category_name));

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
$$;