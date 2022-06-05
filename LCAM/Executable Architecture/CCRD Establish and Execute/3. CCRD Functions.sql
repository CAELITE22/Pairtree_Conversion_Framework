-- # FINAL CCRD Conversion Function
CREATE OR REPLACE FUNCTION converter.ccrd_final(in_user_id int, in_uom text, in_data_category text, in_value float)
RETURNS real
language plpgsql
as
$$
declare
    fconversion_set_id integer := conversion_set_id from converter.user_conversion_set a where a.user_id = in_user_id and active = TRUE;
    fcategory_id integer := id from converter.data_category where name = in_data_category;
    out_uom_id integer  := uom_id from converter.category_to_conversion_set where conversion_set_id = fconversion_set_id and data_category_id = fcategory_id;
    in_uom_id integer := id from converter.uom where uom_abbreviation = in_uom;
    in_values record;
    out_values record;
    fprecision integer;
    converted_value real;
begin
    if in_uom_id <> out_uom_id then
        select rate, constant into in_values from converter.conversion_rate where uom_id = in_uom_id;
        select rate, constant into out_values from converter.conversion_rate where uom_id = out_uom_id;
        fprecision := precision from converter.uom where id = out_uom_id;
        converted_value = (out_values.rate*(in_value-in_values.constant))/in_values.rate + out_values.constant;
        converted_value = round(converted_value::numeric,fprecision);
        return converted_value;
    end if;
    return in_value;
end;
$$;
