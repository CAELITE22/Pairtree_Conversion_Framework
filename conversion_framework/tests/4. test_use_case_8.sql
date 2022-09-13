set search_path = "converter_tests";

create or replace function  converter_tests.test_use_case_8_add_data_type(
) returns setof text as $$
--verify functions have been created.
    select has_function('converter','add_data_type',ARRAY['integer','text'])
    union all
    select isa_ok((select converter.add_data_type(-1, 'testcase')),'integer','Data Type added successfully - Unit Test 1')
    union all
    select results_eq('select count(*) from converter.data_type where name = ''testcase'' ',ARRAY[1 :: BIGINT],'Confrimed Data Type added successfully - Unit Test 2' )
    union all
    -- test error states
    select throws_ok ('select converter.add_data_type(null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.add_data_type(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.add_data_type(-1,''testcase'')', 'CF021', (select error_description from converter.response where error_code = 'CF021'),
    'Data Type already exists - Unit Test 5')
$$ language sql;


create or replace function  converter_tests.test_use_case_8_update_data_type(
) returns setof text as $$
    select converter.add_data_type(1, 'testcase');
    --verify functions have been created.
    select has_function('converter','update_data_type',ARRAY['integer','integer','text'])
    union all
    select throws_ok ('select converter.get_data_type_id_from_name(-1,''testcase2'')', 'CF022', (select error_description from converter.response where error_code = 'CF022'),
    'Confirm new name does not exist - Unit Test 1a')
    union all
    select ok((select converter.update_data_type(1, (select converter.get_data_type_id_from_name(-1,'testcase')),'testcase2')),'Data Type updated successfully - Unit Test 1b')
    union all
    select isa_ok((select converter.get_data_type_id_from_name(-1,'testcase2')),'integer','Confrimed Data Type update successfully - Unit Test 1c' )
    union all
    -- test error states
    select throws_ok ('select converter.update_data_type(null,1,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_data_type(-1,null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_data_type(-1,null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_data_type(-1,-1,''a'')', 'CF015', (select error_description from converter.response where error_code = 'CF015'),
    'Data Type does not exist - Unit Test 5')
    union all
    select throws_ok ('select converter.update_data_type(-1,1,''testcase2'')', 'CF021', (select error_description from converter.response where error_code = 'CF021'),
    'Data Type already exists - Unit Test 6')
$$ language sql;

create or replace function  converter_tests.test_use_case_8_set_enabled_data_type(
) returns setof text as $$
    select converter.add_data_type(1, 'testcase');
    --verify functions have been created.
    select has_function('converter','set_enabled_data_type',ARRAY['integer','integer','boolean'])
    union all
    select ok((select converter.get_data_type_status_from_id(-1,converter.get_data_type_id_from_name(-1,'testcase')) = true), 'Confirm type is active - Unit Test 1a')
    union all
    select ok((select converter.set_enabled_data_type(1, (select converter.get_data_type_id_from_name(-1,'testcase')),false)),'Data Type status updated to false - Unit Test 1b')
    union all
    select ok((select converter.get_data_type_status_from_id(-1,converter.get_data_type_id_from_name(-1,'testcase')) = false), 'Confirm type is inactive - Unit Test 1c')
    union all
    -- test error states
    select throws_ok ('select converter.set_enabled_data_type(null,1,true)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.set_enabled_data_type(-1,null,true)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.set_enabled_data_type(-1,1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type status cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_data_type(-1,-1,''a'')', 'CF015', (select error_description from converter.response where error_code = 'CF015'),
    'Data Type does not exist - Unit Test 5')
$$ language sql;

create or replace function  converter_tests.test_use_case_8_get_data_type_id_from_name(
) returns setof text as $$
    --verify functions have been created.
    select has_function('converter','get_data_type_id_from_name',ARRAY['integer','text'])
    union all
    select ok((select converter.add_data_type(1, 'testcase')) = (select converter.get_data_type_id_from_name(-1,'testcase')),'Confirm get ID function - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_data_type_id_from_name(null,''testcase'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.get_data_type_id_from_name(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_data_type_id_from_name(-1,''asdfasdfeasdfe'')', 'CF022', (select error_description from converter.response where error_code = 'CF022'),
    'Data Type name does not exist - Unit Test 3')
$$ language sql;

create or replace function  converter_tests.test_use_case_8_get_data_type_status_from_id(
) returns setof text as $$
    select converter.add_data_type(1, 'testcase');
    --verify functions have been created.
    select has_function('converter','get_data_type_status_from_id',ARRAY['integer','integer'])
    union all
    select ok((select converter.get_data_type_status_from_id(-1,converter.get_data_type_id_from_name(-1,'testcase')) = true), 'Confirm type is active - Unit Test 1a')
    union all
    select ok((select converter.set_enabled_data_type(1, (select converter.get_data_type_id_from_name(-1,'testcase')),false)),'Data Type status updated to false - Unit Test 1b')
    union all
    select ok((select converter.get_data_type_status_from_id(-1,converter.get_data_type_id_from_name(-1,'testcase')) = false), 'Confirm type is inactive - Unit Test 1c')
    union all
    -- test error states
    select throws_ok ('select converter.get_data_type_status_from_id(null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.get_data_type_status_from_id(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_data_type_status_from_id(-1,-1)', 'CF015', (select error_description from converter.response where error_code = 'CF015'),
    'Data Type id cannot be found - Unit Test 4')
$$ language sql;