set search_path = "converter_tests";
create or replace function  converter_tests.test_usecase_3(
) returns setof text as $$
    --verify required function has been created
    --convert_by_uom(in_user_id int, in_uom_id int, out_uom_id int, in_value float)
    select has_function('converter','convert_by_uom',ARRAY['integer','integer','integer','float'])
    union all

    --basic functionality testing at 0c and converting to desired sets.
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_uom_id_from_abbreviation(-1,''°C'')),0)',
                        ARRAY[0::real], 'Convert with specified UOM (Celsius to Celsius) - Unit Test 1')
    union all
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_uom_id_from_abbreviation(-1,''°F'')),0)',
                        ARRAY[32::real], 'Convert with specified UOM (Celsius to Farenheit) - Unit Test 2')
    union all
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°F'')),(select converter.get_uom_id_from_abbreviation(-1,''°C'')),32)',
                        ARRAY[0::real], 'Convert with specified UOM (Farenheit to Celsius) - Unit Test 3')
    union all
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_uom_id_from_abbreviation(-1,''°Ra'')),0)',
                        ARRAY[491.67::real], 'Convert with specified UOM (Celsius to Rankine) - Unit Test 4')
    union all
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_uom_id_from_abbreviation(-1,''°K'')),0)',
                        ARRAY[273.15::real], 'Convert with specified UOM (Celsius to Kelvin) - Unit Test 5')
    union all
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°K'')),(select converter.get_uom_id_from_abbreviation(-1,''°C'')),0)',
                        ARRAY[-273.15::real], 'Convert with specified UOM (Celsius to Kelvin) - Unit Test 6')
    union all
        -- test error states
    select throws_ok ('select converter.convert_by_uom(null,2,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 7')
    union all
    select throws_ok ('select converter.convert_by_uom(-1,null,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 8')
    union all
    select throws_ok ('select converter.convert_by_uom(-1,2,null,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 9')
    union all
    select throws_ok ('select converter.convert_by_uom(-1,2,2,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 10')
    union all
    select throws_ok ('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),-1,0)', 'CF008', (select error_description from converter.response where error_code = 'CF008')::text,
        'Out UOM ID does not exist - Unit Test 11')
    union all
    select throws_ok ('select converter.convert_by_uom(-1,-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),0)', 'CF005', (select error_description from converter.response where error_code = 'CF005')::text,
        'In UOM ID does not exist - Unit Test 12')
    union all
    select throws_ok ('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_uom_id_from_abbreviation(-1,''m'')),0)', 'CF006', (select error_description from converter.response where error_code = 'CF006')::text,
        'In UOM ID does not exist - Unit Test 13')
$$ language sql;