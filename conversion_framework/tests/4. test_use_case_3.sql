set search_path = "converter_tests";
create or replace function  converter_tests.test_usecase_3(
) returns setof text as $$
    --verify required function has been created
    --convert_by_uom(in_user_id int, in_uom_id int, out_uom_id int, in_value float)
    select has_function('converter','convert_by_uom',ARRAY['integer','integer','integer','float'])
    union all

    --basic functionality testing at 0c and converting to desired sets.
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_uom_id_from_abbreviation(-1,''°C'')),0)',
                        ARRAY[0::real], 'Convert with specified UOM unit Test 1')
    union all
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_uom_id_from_abbreviation(-1,''°C'')),0)',
                        ARRAY[32::real], 'Convert with specified UOM unit Test 2')
    union all
    select results_eq('select converter.convert_by_uom(1,2,1,32)',
                        ARRAY[0::real], 'Convert with specified UOM unit Test 3')
    union all
    select results_eq('select converter.convert_by_uom(1,1,4,0)',
                        ARRAY[491.67::real], 'Convert specifying UOM unit Test 4')
    union all
    select results_eq('select converter.convert_by_uom(1,1,3,0)',
                        ARRAY[273.15::real], 'Convert specifying UOM unit Test 5')
    union all
    select results_eq('select converter.convert_by_uom(15,3,1,0)',
        ARRAY[-273.15::real], 'Convert specifying UOM unit Test 6')
$$ language sql;