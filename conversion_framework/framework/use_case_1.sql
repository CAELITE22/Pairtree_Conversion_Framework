-- # this conversion process uses the users default conversion set - numerical values only
CREATE OR REPLACE FUNCTION converter.convert(in_user_id int, in_uom int, in_data_category int, in_value float)
RETURNS real
language plpgsql
as
$$
declare
    lu_conversion_set_id integer;
    out_uom_id integer;
    in_values record;
    out_values record;
    lu_precision integer;
    converted_value real;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_uom is NULL OR in_data_category is NULL OR in_value is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = 'Error! Cannot input <NULL> values.';
    end if;

    lu_conversion_set_id = (select conversion_set_id from converter.user_conversion_set a
        where a.user_id = in_user_id and a.active = TRUE);
    if (lu_conversion_set_id is null) then
            RAISE EXCEPTION SQLSTATE 'CF002' USING MESSAGE = 'Error! User does not have a default conversion set.';
    end if;

    if ((select count(id) from converter.data_category where id = in_data_category) = 0) then
            RAISE EXCEPTION SQLSTATE 'CF003' USING MESSAGE = 'Error! The specified data_category ID does not exist.';
    end if;

    out_uom_id = (select uom_id from converter.category_to_conversion_set
        where conversion_set_id = lu_conversion_set_id and data_category_id = in_data_category);
    if (out_uom_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF004' USING MESSAGE = 'Error! The UOM for this data category is not set in the conversion set.';
    end if;

    if ((select count(id) from converter.uom where id = in_uom) = 0) then
            RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = 'Error! The supplied IN_UOM ID is not found in the UOM list.';
    end if;

    if ((select data_type_id from converter.uom where id = in_uom) <> (select data_type_id from converter.uom where id = out_uom_id)) then
        RAISE EXCEPTION SQLSTATE 'CF006' USING MESSAGE = 'Error! The origin and destination UOMs are not of the same data type.';
    end if;

    if in_uom <> out_uom_id then
        select rate, constant into in_values from converter.conversion_rate
            where uom_id = in_uom;
        select rate, constant into out_values from converter.conversion_rate
            where uom_id = out_uom_id;
        lu_precision := precision from converter.uom where id = out_uom_id;
        converted_value = (out_values.rate*(in_value-in_values.constant))/in_values.rate
                              + out_values.constant;
        converted_value = round(converted_value::numeric,lu_precision);
        return converted_value;
    end if;
    return in_value;
end;
$$;
