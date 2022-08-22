-- # this conversion process uses the specified UOM
CREATE OR REPLACE FUNCTION converter.convert_by_uom(in_user_id int, in_uom int, out_uom int, in_value float)
RETURNS real
language plpgsql
as
$$
declare
    in_values record;
    out_values record;
    in_precision integer;
    converted_value real;
begin
    -- Ensure there are no NULL values
    if (in_user_id is NULL OR in_uom is NULL OR out_uom is NULL OR in_value is NULL) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = 'Error! Cannot input <NULL> values.';
    end if;

    if ((select count(id) from converter.uom where id = out_uom) = 0) then
            RAISE EXCEPTION SQLSTATE 'CF008' USING MESSAGE = 'Error! The specified OUT_UOM ID does not exist.';
    end if;

    if ((select count(id) from converter.uom where id = in_uom) = 0) then
            RAISE EXCEPTION SQLSTATE 'CF005' USING MESSAGE = 'Error! The specified IN_UOM ID does not exist.';
    end if;

    if ((select data_type_id from converter.uom where id = in_uom) <> (select data_type_id from converter.uom where id = out_uom)) then
        RAISE EXCEPTION SQLSTATE 'CF006' USING MESSAGE = 'Error! The origin and destination UOMs are not of the same data type.';
    end if;

    if in_uom <> out_uom then
        select rate, constant into in_values from converter.conversion_rate
            where uom_id = in_uom;
        select rate, constant into out_values from converter.conversion_rate
            where uom_id = out_uom;
        in_precision := precision from converter.uom where id = out_uom;
        converted_value = (out_values.rate*(in_value-in_values.constant))/in_values.rate
                              + out_values.constant;
        converted_value = round(converted_value::numeric,in_precision);
        return converted_value;
    end if;
    return in_value;
end;
$$;