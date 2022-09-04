set search_path = "converter_tests";
create or replace function  converter_tests.test_use_case_2_convert_by_conversion_set(
) returns setof text as $$
    --data setup
    INSERT INTO converter.data_category (id,name, type_id, created, updated, created_by, updated_by, active)
    VALUES (-4, 'TESTCATEGORY', 1, now(), now(), -1, -1, true);

    -- label testing
    select '# # # Testing Use Case 2 - Convert using users a specific conversion set # # #'
    union all
    --verify required function has been created
    select has_function('converter','convert_by_conversion_set',ARRAY['integer','integer','integer','integer','float'])
    union all
    --basic functionality testing at 0c and converting to desired sets.
    select results_eq('select converter.convert_by_conversion_set(-1,1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Air Temperature'')),0)',
                        ARRAY[0::real], 'Convert Celsius to Celsius unit Test 1')
    union all
    select results_eq('select converter.convert_by_conversion_set(-1,1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Soil Temperature'')),100)',
                        ARRAY[100::real], 'Convert Celsius to Celsius unit Test 2')
    union all
    select results_eq('select converter.convert_by_conversion_set(-1,2,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Air Temperature'')),0)',
                        ARRAY[32::real], 'Convert Celsius to Fahrenheit unit Test 3')
    union all
    select results_eq('select converter.convert_by_conversion_set(-1,2,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Soil Temperature'')),37.5)',
                        ARRAY[99.5::real], 'Convert Celsius to Fahrenheit unit Test 4')
    union all
    select results_eq('select converter.convert_by_conversion_set(-1,1,(select converter.get_uom_id_from_abbreviation(-1,''m'')),(select converter.get_data_category_id_from_name(-1,''Height'')),0.8)',
                        ARRAY[800::real], 'Convert Metres to Millimetres unit Test 5')
    union all
    select results_eq('select converter.convert_by_conversion_set(-1,2,(select converter.get_uom_id_from_abbreviation(-1,''mm'')),(select converter.get_data_category_id_from_name(-1,''Height'')),127)',
                        ARRAY[5::real], 'Convert Millimetres to Inches unit Test 6')
    union all
    select ok((select converter.convert_by_conversion_set(-1,1,1,1,null) is null),'Confirm Null value conversion - Unit Test 7')
    union all
    -- test error states
    select throws_ok ('select converter.convert_by_conversion_set(null,1,2,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 8')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-4,null,2,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Conversion Set ID cannot be null - Unit Test 9')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-4,1,null,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'UOM ID cannot be null - Unit Test 10')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-4,1,2,null,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Data Category ID cannot be null - Unit Test 11')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-1,-1,2,2,2)', 'CF007', (select error_description from converter.response where error_code = 'CF007')::text,
        'No default conversion set unit Test 12')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-1,2,2,-1,2)', 'CF003', (select error_description from converter.response where error_code = 'CF003')::text,
        'Data category ID not found - Unit Test 13')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-1,2,2,-4,2)', 'CF004', (select error_description from converter.response where error_code = 'CF004')::text,
        'This data category is not defined in the users conversion set - Unit Test 14')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-1,2,-1,1,2)', 'CF005', (select error_description from converter.response where error_code = 'CF005')::text,
        'The UOM found in the conversion set does not exist - Unit test 15')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-1,1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Height'')),2)', 'CF006', (select error_description from converter.response where error_code = 'CF006')::text,
        'The source UOM and data category are different data types - Unit test 16')
$$ language sql;