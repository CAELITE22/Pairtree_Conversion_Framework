set search_path = "converter_tests";
create or replace function  converter_tests.test_use_case_9_add_data_category (
) returns setof text as $$
    --verify functions have been created.
    select has_function('converter','add_data_category',ARRAY['integer','text','integer'])
    union all
    select isa_ok((select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'Temperature'))),'integer','Data Category added successfully - Unit Test 1')
    union all
    select isa_ok((select converter.get_data_category_id_from_name(-1, 'testcase')),'integer','Confirmed Data Category exists - Unit Test 2')
    union all
    -- test error states
    select throws_ok ('select converter.add_data_category(null,''a'',1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.add_data_category(-1,null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category Name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.add_data_category(-1,''a'',null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type ID cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.add_data_category(-1,''testcase'',1)', 'CF023', (select error_description from converter.response where error_code = 'CF023'),
    'Data Category already exists - Unit Test 6')
    union all
    select throws_ok ('select converter.add_data_category(-1,''testcase'',-1)', 'CF015', (select error_description from converter.response where error_code = 'CF015'),
    'Data Category already exists - Unit Test 7')
$$ language sql;

create or replace function  converter_tests.test_use_case_9_update_data_category_name (
) returns setof text as $$
    --prepare data
    select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature'));
    --verify functions have been created.
    select has_function('converter','update_data_category_name',ARRAY['integer','integer','text'])
    union all
    select isa_ok((select converter.get_data_category_id_from_name(-1, 'testcase')),'integer','Confirmed Data Category exists - Unit Test 1a')
    union all
    select ok((select converter.update_data_category_name(-1, converter.get_data_category_id_from_name(-1, 'testcase'),'testcase2')),'Updated Data Category name - Unit Test 1b')
    union all
    select isa_ok((select converter.get_data_category_id_from_name(-1, 'testcase2')),'integer','Confirmed New Data Category Name exists - Unit Test 1c')
    union all
    select throws_ok ('select converter.get_data_category_id_from_name(-1,''testcase'')', 'CF025', (select error_description from converter.response where error_code = 'CF025'),
    'Confirm old name does not exist - Unit Test 1d')
    union all
    -- test error states
    select throws_ok ('select converter.update_data_category_name(null,1,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_data_category_name(-1,null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_data_category_name(-1,1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category Name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.add_data_category(-1,-1,1)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
    union all
    select throws_ok ('select converter.add_data_category(-1,converter.get_data_category_id_from_name(-1, ''testcase2''),''testcase2'')', 'CF023', (select error_description from converter.response where error_code = 'CF023'),
    'Data Category name already exists - Unit Test 7')
$$ language sql;


create or replace function  converter_tests.test_use_case_9_update_data_category_data_type (
) returns setof text as $$
    --prepare data
    select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature'));
    --verify functions have been created.
    select has_function('converter','update_data_category_data_type',ARRAY['integer','integer','integer'])
    union all
    select ok((select converter.update_data_category_data_type(-1,converter.get_data_category_id_from_name(-1, 'testcase'),2)),'Data Category Data Type updated - Unit Test 1a')
    union all
    select ok((select converter.get_data_category_data_type_id_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase')) = 2),'Confirm Data Category Data Type updated - Unit Test 1b')
    union all
    -- test error states
    select throws_ok ('select converter.update_data_category_data_type(null,1,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_data_category_data_type(-1,null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_data_category_data_type(-1,1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_data_category_data_type(-1,-1,1)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
    union all
    select throws_ok ('select converter.update_data_category_data_type(-1,converter.get_data_category_id_from_name(-1, ''testcase''),-1)', 'CF015', (select error_description from converter.response where error_code = 'CF015'),
    'Data Type ID does not exist - Unit Test 7')
$$ language sql;


create or replace function  converter_tests.test_use_case_9_set_enabled_data_category (
) returns setof text as $$
    --prepare data
    select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature'));
    --verify functions have been created.
    select has_function('converter','set_enabled_data_category',ARRAY['integer','integer','boolean'])
    union all
    select ok((select converter.get_data_category_status_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase'))),'Confirmed Data Category active - Unit Test 1a')
    union all
    select ok((select converter.set_enabled_data_category(-1,converter.get_data_category_id_from_name(-1, 'testcase'),false)),'Data Category Data Disabled - Unit Test 1b')
    union all
    select ok((select converter.get_data_category_status_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase')) = false),'Confirmed Data Category disabled - Unit Test 1c')
    union all
    select ok((select converter.set_enabled_data_category(-1,converter.get_data_category_id_from_name(-1, 'testcase'),true)),'Data Category Data Enabled - Unit Test 2a')
    union all
    select ok((select converter.get_data_category_status_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase'))),'Confirmed Data Category enabled - Unit Test 2b')
    union all
    -- test error states
    select throws_ok ('select converter.set_enabled_data_category(null,1,true)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.set_enabled_data_category(-1,null,true)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.set_enabled_data_category(-1,1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category Status cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.set_enabled_data_category(-1,-1,true)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
    union all
    select throws_ok ('select converter.set_enabled_data_category(-1,converter.get_data_category_id_from_name(-1, ''Air Temperature''),false)', 'CF024', (select error_description from converter.response where error_code = 'CF024'),
    'Data Type ID does not exist - Unit Test 7')
$$ language sql;

create or replace function  converter_tests.test_use_case_9_get_data_category_data_type_id_from_id (
) returns setof text as $$
    --prepare data
    select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature'));
    --verify functions have been created.
    select has_function('converter','get_data_category_data_type_id_from_id',ARRAY['integer','integer'])
    union all
    select ok((select converter.get_data_category_data_type_id_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase')) = converter.get_data_type_id_from_name(-1,'temperature')),'Confirm Data Type correct - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.update_data_category_data_type(null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_data_category_data_type(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_data_category_data_type(-1,-1)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
    union all
$$ language sql;

create or replace function  converter_tests.test_use_case_9_get_data_category_id_from_name (
) returns setof text as $$
    --verify functions have been created.
    select has_function('converter','get_data_category_id_from_name',ARRAY['integer','text'])
    union all
    select ok((select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature')) = converter.get_data_category_id_from_name(-1,'testcase')),'Confirm Data category id correct - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_data_category_id_from_name(null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.get_data_category_id_from_name(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_data_category_id_from_name(-1,-1)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
$$ language sql;

create or replace function  converter_tests.test_use_case_9_is_data_category_dependency (
) returns setof text as $$
    --prepare data
    select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature'));
    --verify functions have been created.
    select has_function('converter','is_data_category_dependency',ARRAY['integer','integer'])
    union all
    
$$ language sql;

create or replace function  converter_tests.test_use_case_9_get_data_category_status_from_id (
) returns setof text as $$
    --prepare data
    select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature'));
    --verify functions have been created.
    select has_function('converter','get_data_category_status_from_id',ARRAY['integer','integer'])
    union all
    select ok((select converter.get_data_category_status_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase'))),'Confirmed Data Category active - Unit Test 1a')
    union all
    select ok((select converter.set_enabled_data_category(-1,converter.get_data_category_id_from_name(-1, 'testcase'),false)),'Data Category Data Disabled - Unit Test 1b')
    union all
    select ok((select converter.get_data_category_status_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase')) = false),'Confirmed Data Category disabled - Unit Test 1c')
    union all
    select ok((select converter.set_enabled_data_category(-1,converter.get_data_category_id_from_name(-1, 'testcase'),true)),'Data Category Data Enabled - Unit Test 2a')
    union all
    select ok((select converter.get_data_category_status_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase'))),'Confirmed Data Category enabled - Unit Test 2b')
    union all
    -- test error states
    select throws_ok ('select converter.get_data_category_status_from_id(null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_data_category_status_from_id(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_data_category_status_from_id(-1,-1)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
$$ language sql;
