set search_path = "converter_tests";
create or replace function converter_tests.test_use_case_6_update_default_conversion_set_category_uom(

) returns setof text as $$

-- verify functions have been created
    select has_function('converter', 'update_default_conversion_set_category_uom', ARRAY['integer', 'integer', 'integer'])
    union all
    select ok((select converter.update_default_conversion_set_category_uom(-1,converter.get_data_category_id_from_name(-1,'Air Temperature'), converter.get_uom_id_from_abbreviation(-1,'°F'))),'UOM updated OK - Unit Test 1')
    union all
    select results_eq('select uom_id from converter.category_to_conversion_set where conversion_set_id = (select conversion_set_id from converter.user_conversion_set where user_id = -1) and data_category_id = converter.get_data_category_id_from_name(-1,''Air Temperature'')',
        'select converter.get_uom_id_from_abbreviation(-1,''°F'')','Confirm update ran successfully - Unit Test 2')
    union all
   -- test error states
    select throws_ok ('select converter.update_default_conversion_set_category_uom(null,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_default_conversion_set_category_uom(2,null,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'Data Category cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_default_conversion_set_category_uom(2,2,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM ID cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.update_default_conversion_set_category_uom(2,-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')))', 'CF014', (select error_description from converter.response where error_code = 'CF014')::text,
    'Supplied Data Category ID does not exist - Unit Test 6')
    union all
    select throws_ok ('select converter.update_default_conversion_set_category_uom(2,(select converter.get_data_category_id_from_name(-1,''Air Temperature'')),-1)', 'CF009', (select error_description from converter.response where error_code = 'CF009')::text,
    'Supplied UOM ID does not exist - Unit Test 7')
    union all
    select throws_ok ('select converter.update_default_conversion_set_category_uom(-5,(select converter.get_data_category_id_from_name(-1,''Air Temperature'')),(select converter.get_uom_id_from_abbreviation(-1,''°C'')))', 'CF002', (select error_description from converter.response where error_code = 'CF002')::text,
    'User has no default conversion set - Unit Test 8')
$$ language sql;

set search_path = "converter_tests";
create or replace function converter_tests.test_use_case_6_update_target_conversion_set_category_uom(

) returns setof text as $$
    -- verify functions have been created
    --converter.update_target_conversion_set_category(in_user_id int, in_conversion_set_id int, in_data_category_id int, in_uom_id int)
    select has_function('converter', 'update_target_conversion_set_category_uom', ARRAY['integer', 'integer', 'integer', 'integer'])
    union all
    select ok((select converter.update_target_conversion_set_category_uom(-1, converter.get_conversion_set_id_from_name(-1,'Metric'),converter.get_data_category_id_from_name(-1,'Air Temperature'), converter.get_uom_id_from_abbreviation(-1,'°F'))),'Category updated OK - Unit Test 1')
    union all
    select results_eq('select uom_id from converter.category_to_conversion_set where conversion_set_id = (converter.get_conversion_set_id_from_name(-1,''Metric'')) and data_category_id = converter.get_data_category_id_from_name(-1,''Air Temperature'')',
        'select converter.get_uom_id_from_abbreviation(-1,''°F'')','Confirm update ran successfully - Unit Test 2')
    union all
    -- test error states
    select throws_ok ('select converter.update_target_conversion_set_category_uom(null,2,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_target_conversion_set_category_uom(2,null,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'Conversion Set ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_target_conversion_set_category_uom(2,2,null,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'Data Category cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.update_target_conversion_set_category_uom(2,2,2,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM ID cannot be null - Unit Test 6')
    union all
    select throws_ok ('select converter.update_target_conversion_set_category_uom(2,2,-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')))', 'CF014', (select error_description from converter.response where error_code = 'CF014')::text,
    'Supplied Data Category ID does not exist - Unit Test 7')
    union all
    select throws_ok ('select converter.update_target_conversion_set_category_uom(2,2,(select converter.get_data_category_id_from_name(-1,''Air Temperature'')),-1)', 'CF009', (select error_description from converter.response where error_code = 'CF009')::text,
    'Supplied UOM ID does not exist - Unit Test 8')
$$ language sql;
