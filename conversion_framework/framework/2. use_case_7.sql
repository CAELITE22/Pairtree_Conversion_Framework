-- # use case 7 - add/delete/update a UOM
-- add a new UOM
DROP FUNCTION IF EXISTS converter.add_uom;

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
DROP FUNCTION IF EXISTS converter.set_enabled_uom;
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

DROP FUNCTION IF EXISTS converter.update_uom_data_type;
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
DROP FUNCTION IF EXISTS converter.update_uom_name_and_abbr;

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

DROP FUNCTION IF EXISTS converter.update_uom_name;

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

DROP FUNCTION IF EXISTS converter.update_uom_abbr;
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

DROP FUNCTION IF EXISTS converter.update_uom_rate_constant;
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

DROP FUNCTION IF EXISTS converter.update_uom_precision;
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

DROP FUNCTION IF EXISTS converter.update_uom_lower;
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

DROP FUNCTION IF EXISTS converter.update_uom_upper;
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

DROP FUNCTION IF EXISTS converter.get_uom_id_from_name;
CREATE OR REPLACE FUNCTION converter.get_uom_id_from_name(
    in_user_id int,
    in_uom_name text,
    in_throw boolean default true
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
    if uom_id is null and in_throw then
        RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = (select error_description from converter.response where error_code = 'CF005');
    end if;

    return uom_id;
end
$$;

DROP FUNCTION IF EXISTS converter.get_uom_id_from_abbreviation;
CREATE OR REPLACE FUNCTION converter.get_uom_id_from_abbreviation(
    in_user_id int,
    in_uom_abbr text,
    in_throw boolean default true
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
    if uom_id is null and in_throw then
        RAISE EXCEPTION SQLSTATE 'CF010' USING MESSAGE = (select error_description from converter.response where error_code = 'CF010');
    end if;

    return uom_id;
end
$$;

DROP FUNCTION IF EXISTS converter.get_uom_status_from_id;
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

DROP FUNCTION IF EXISTS converter.get_uom_data_type_from_id;
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

DROP FUNCTION IF EXISTS converter.get_uom_abbr_from_id;
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


DROP FUNCTION IF EXISTS converter.get_uom_name_from_id;
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

DROP FUNCTION IF EXISTS converter.get_uom_name_abbr_from_id;
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

DROP FUNCTION IF EXISTS converter.get_uom_prec_from_id;
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

DROP FUNCTION IF EXISTS converter.get_uom_lower_from_id;
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

DROP FUNCTION IF EXISTS converter.get_uom_upper_from_id;
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

DROP FUNCTION IF EXISTS converter.get_uom_rate_from_id;
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

DROP FUNCTION IF EXISTS converter.get_uom_constant_from_id;
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
$$;