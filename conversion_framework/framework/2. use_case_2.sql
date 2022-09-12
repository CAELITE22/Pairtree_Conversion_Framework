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
