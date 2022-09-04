set search_path = "converter_tests";
create or replace function  converter_tests.test_use_case_7_add_uom(
) returns setof text as $$
    --verify function has been created.
    select has_function('converter','add_uom',ARRAY['integer','integer','text','text','integer','integer','integer','real','real','boolean'])
    union all
    select isa_ok((select converter.add_uom(-1, 1, 'testcase1', 'tc1'))
        ,'integer', 'Correct return from add_uom function - base inputs - Unit Test 1')
    union all
    select isa_ok((select converter.get_uom_id_from_name(-1,'testcase1')), 'integer','UOM added successfully - Unit Test 2')
    union all
    select isa_ok((select converter.add_uom(-1, 1, 'testcase2', 'tc2',
        2, 1, 1, 0.00, 10.00, true ))
        ,'integer', 'Correct return from add_uom function - all inputs - Unit Test 3')
    union all
    select isa_ok((select converter.get_uom_id_from_name(-1,'testcase1')), 'integer','UOM added successfully - Unit Test 4')
    union all
    -- test error states
    select throws_ok ('select converter.add_uom(null,2,''a'',''b'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'User ID cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.add_uom(-1,null,''a'',''b'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'Data Type cannot be null - Unit Test 6')
    union all
    select throws_ok ('select converter.add_uom(-1,2,null,''b'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM Name cannot be null - Unit Test 7')
    union all
    select throws_ok ('select converter.add_uom(-1,2,''a'',null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM Abbreviation cannot be null - Unit Test 8')
    union all
    select throws_ok ('select converter.add_uom(-1,2,''a'',''b'')', 'CF015', (select error_description from converter.response where error_code = 'CF015')::text,
    'Data Type cannot be found - Unit Test 9')
    union all
    select throws_ok ('select converter.add_uom(-1,2,''testcase1'',''b'')', 'CF016', (select error_description from converter.response where error_code = 'CF016')::text,
    'UOM Already exists - Unit Test 10')
$$ language sql;

CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_set_enabled_uom()
returns setof text as $$
    --prepare data
    select converter.add_uom(-1, 1, 'testcase1', 'tc1');
    --converter.set_enabled_uom(in_user_id int, in_uom_id int, isEnabled boolean)
    --verify function has been created.
    select has_function('converter','set_enabled_uom',ARRAY['integer','integer','bool'])
    union all
    select ok((select converter.set_enabled_uom(-1,converter.get_uom_id_from_name(-1,'testcase1'),false)),'UOM set to disabled - Unit Test 1')
    union all
    select ok((select converter.get_uom_status_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1')) = false),'Confirmed disabled - Unit Test 1a')
    union all
    select ok((select converter.set_enabled_uom(-1,converter.get_uom_id_from_name(-1,'testcase1'),true)),'UOM set to disabled - Unit Test 2')
    union all
    select ok((select converter.get_uom_status_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1'))),'Confirmed disabled - Unit Test 2a')
    union all
    -- test error states
    select throws_ok ('select converter.set_enabled_uom(null, 1, true)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.set_enabled_uom(-1, null, true)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.set_enabled_uom(-1, 1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'Status cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.set_enabled_uom(-1, -1, true)', 'CF005', (select error_description from converter.response where error_code = 'CF005')::text,
    'Confirmed UOM ID not found - Unit Test 6')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_data_type()
returns setof text as $$
    --prepare data
    select converter.add_uom(-1, 1, 'testcase1', 'tc1');
    --converter.update_uom_data_type(in_user_id int, in_uom_id int, in_data_type_id int)
    --verify function has been created.
    select has_function('converter','update_uom_data_type',ARRAY['integer','integer','integer'])
    union all
    select ok((select converter.update_uom_data_type(-1,converter.get_uom_id_from_name(-1,'testcase1'),2)),'Data Type Updated Successfully - Unit Test 1a')
    union all
    select ok((select converter.get_uom_data_type_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1')) = 2),'Confirmed Data Type updated - Use Case 1b')
    union all
    select ok((select converter.update_uom_data_type(-1,converter.get_uom_id_from_name(-1,'testcase1'),1)),'Data Type Reverted Successfully - Unit Test 2a')
    union all
    select ok((select converter.get_uom_data_type_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1')) = 1),'Confirmed Data Type Reverted - Use Case 2b')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_data_type_from_id(null, 1)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_data_type_from_id(-1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_data_type_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005')::text,
    'Confirmed UOM ID not found - Unit Test 6')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_name_and_abbr()
returns setof text as $$
    --converter.update_uom_name_and_abbr(in_user_id int, in_uom_id int, in_uom_name text, in_uom_abbreviation text)
    --prepare data
    select converter.add_uom(-1, 1, 'testcase1', 'tc1');
    --converter.update_uom_data_type(in_user_id int, in_uom_id int, in_data_type_id int)
    --verify function has been created.
    select has_function('converter','update_uom_name_and_abbr',ARRAY['integer','integer','text','text'])
    union all
    select ok((select concat((select converter.get_uom_name_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1'))),',',(select converter.get_uom_abbr_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1')))) = 'testcase1,tc1'),'Confirm current UOM name and abbr - Unit Test 1a')
    union all
    select ok((select converter.update_uom_name_and_abbr(-1,converter.get_uom_id_from_name(-1,'testcase1'),'testcase2','tc2')),'UOM Name and Abbreviation Updated Successfully - Unit Test 1b')
    union all
    select ok((select concat((select converter.get_uom_name_from_id(-1,converter.get_uom_id_from_name(-1,'testcase2'))),',',(select converter.get_uom_abbr_from_id(-1,converter.get_uom_id_from_name(-1,'testcase2')))) = 'testcase2,tc2'),'Confirm updated UOM name and abbr - Unit Test 1c')
    union all
    -- test error states
    select throws_ok ('select converter.update_uom_name_and_abbr(null,2,''a'',''b'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_uom_name_and_abbr(-1,null,''a'',''b'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_uom_name_and_abbr(-1,2,null,''b'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM Name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_uom_name_and_abbr(-1,2,''a'',null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM Abbreviation cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.update_uom_name_and_abbr(-1,-1,''a'',''b'')', 'CF005', (select error_description from converter.response where error_code = 'CF005')::text,
    'UOM ID cannot be found - Unit Test 6')
    union all
    select throws_ok ('select converter.update_uom_name_and_abbr(-1,2,''testcase2'',''b'')', 'CF017', (select error_description from converter.response where error_code = 'CF017')::text,
    'UOM Name already exists - Unit Test 7')
    union all
    select throws_ok ('select converter.update_uom_name_and_abbr(-1,2,''abc'',''tc2'')', 'CF017', (select error_description from converter.response where error_code = 'CF017')::text,
    'UOM Abbreviation already exists - Unit Test 8')
    union all
        select throws_ok ('select converter.update_uom_name_and_abbr(-1,2,''testcase2'',''tc2'')', 'CF017', (select error_description from converter.response where error_code = 'CF017')::text,
    'UOM Name and/or Abbreviation already exists - Unit Test 9')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_name()
returns setof text as $$
    --converter.update_uom_name(in_user_id int, in_uom_id int, in_uom_name text)
    --prepare data
    select converter.add_uom(-1, 1, 'testcase1', 'tc1');
    --converter.update_uom_data_type(in_user_id int, in_uom_id int, in_data_type_id int)
    --verify function has been created.
    select has_function('converter','update_uom_name',ARRAY['integer','integer','text','text'])
    union all
    select ok(((select converter.get_uom_name_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1'))) = 'testcase1'),'Confirm current UOM name - Unit Test 1a')
    union all
    select ok((select converter.update_uom_name(-1,converter.get_uom_id_from_name(-1,'testcase1'),'testcase2')),'UOM Name Updated Successfully - Unit Test 1b')
    union all
    select ok(((select converter.get_uom_name_from_id(-1,converter.get_uom_id_from_name(-1,'testcase2'))) = 'testcase2'),'Confirm updated UOM name - Unit Test 1c')
    union all
    -- test error states
    select throws_ok ('select converter.update_uom_name(null,2,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_uom_name(-1,null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_uom_name(-1,2,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM Name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_uom_name(-1,-1,''a'')', 'CF005', (select error_description from converter.response where error_code = 'CF005')::text,
    'UOM ID cannot be found - Unit Test 5')
    union all
    select throws_ok ('select converter.update_uom_name(-1,2,''testcase2'')', 'CF017', (select error_description from converter.response where error_code = 'CF017')::text,
    'UOM Name already exists - Unit Test 6')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_abbr()
returns setof text as $$
    --converter.update_uom_abbr(in_user_id int, in_uom_id int, in_uom_abbreviation text)
    --prepare data
    select converter.add_uom(-1, 1, 'testcase1', 'tc1');
    --converter.update_uom_data_type(in_user_id int, in_uom_id int, in_data_type_id int)
    --verify function has been created.
    select has_function('converter','update_uom_abbr',ARRAY['integer','integer','text'])
    union all
    select ok(((select converter.get_uom_abbr_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = 'tc1'),'Confirm current UOM abbreviation - Unit Test 1a')
    union all
    select ok((select converter.update_uom_abbr(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'),'tc2')),'UOM abbreviation Updated Successfully - Unit Test 1b')
    union all
    select ok(((select converter.get_uom_abbr_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc2'))) = 'tc2'),'Confirm updated UOM abbreviation - Unit Test 1c')
    union all
    -- test error states
    select throws_ok ('select converter.update_uom_abbr(null,2,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_uom_abbr(-1,null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_uom_abbr(-1,2,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM Name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_uom_abbr(-1,-1,''a'')', 'CF005', (select error_description from converter.response where error_code = 'CF005')::text,
    'UOM ID cannot be found - Unit Test 5')
    union all
    select throws_ok ('select converter.update_uom_abbr(-1,2,''testcase2'')', 'CF017', (select error_description from converter.response where error_code = 'CF017')::text,
    'UOM Name already exists - Unit Test 6')

$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_precision()
returns setof text as $$
    --converter.update_uom_precision(in_user_id int, in_uom_id int, in_prec int)


$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_lower()
returns setof text as $$
    --converter.update_uom_lower(in_user_id int, in_uom_id int, in_lower_boundary real default null, in_lower_uom int default null)


$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_upper()
returns setof text as $$
    --converter.update_uom_upper(in_user_id int, in_uom_id int, in_upper_boundary real default null, in_upper_uom int default null)


$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_is_active()
returns setof text as $$
    --converter.update_uom_is_active(in_user_id int, in_uom_id int, in_active boolean)


$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_id_from_name()
returns setof text as $$
    --converter.get_uom_id_from_name(in_user_id int, in_uom_name text)


$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_id_from_abbreviation()
returns setof text as $$
    --converter.get_uom_id_from_abbreviation(in_user_id int, in_uom_abbr text)


$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_status_from_id()
returns setof text as $$
    --converter.get_uom_details_from_id(in_user_id int, in_uom_id int)


$$ language sql;


set search_path = "converter_tests";
create or replace function  converter_tests.test_use_case_7_add_uom(
) returns setof text as $$
-- setup for test.
insert into converter.data_type (name, translation, created, created_by,
                                 updated, updated_by, active)
  values ('testDataType', FALSE, now(), -1, now(), -1, TRUE);
insert into converter.uom (data_type_id, uom_name, uom_abbreviation, precision, upper_boundary, lower_boundary,
                           upper_uom, lower_uom, owner_user_id, created, updated, created_by, updated_by, active)
    values (converter.get_data_type_id_from_name(-1,'testDataType'), 'testUOMtype','tut',2,10.0,0.0,1,1,-1,now(),now(),-1,-1,true);

    select has_function('converter','delete_uom',ARRAY['integer'])
    union all
--     select has_function('converter','update_uom')
--     union all
    select has_function('converter','update_uom_data_type',ARRAY['integer','integer','integer'])
    union all
    select has_function('converter','update_uom_name',ARRAY['integer','integer','text','text'])
    union all
    select has_function('converter','update_uom_precision',ARRAY['integer','integer','integer'])
    union all
    select has_function('converter','update_uom_lower',ARRAY['integer','integer','real','integer'])
    union all
    select has_function('converter','update_uom_upper',ARRAY['integer','integer','real','integer'])
    union all
    select has_function('converter','update_uom_is_active',ARRAY['integer','integer','boolean'])
    union all

-- check add_uom function
    select matches((select converter.add_uom(1, 1, 'testcase', 'tc',
        2, 0, 0, 0.00, 10.00, true ))
        ,'\d*', 'correct return from add_uom function')
    union all
    select is((select count(*) from converter.uom where uom_name = 'testcase'), 1 :: BIGINT,'Data Type added successfully')
    union all
    select results_eq('select converter.add_uom(NULL, 1, ''nullcase1'', ''tc'',
        2, 0, 0, 0.00, 10.00, true)', 'select ''ERROR! cannot input NULL values for in_user_id, data_type_id or uom_name''','NULL Input error')
    union all
    select results_eq('select count(*) from converter.uom where uom_name = ''nullcase1'' ',ARRAY[0 :: BIGINT],'nullcase1 confirmed')
    union all
        select results_eq('select converter.add_uom(1, NULL, ''nullcase2'', ''tc'',
        2, 0, 0, 0.00, 10.00, true)', 'select ''ERROR! cannot input NULL values for in_user_id, data_type_id or uom_name''','NULL Input error')
    union all
    select results_eq('select count(*) from converter.uom where uom_name = ''nullcase2'' ',ARRAY[0 :: BIGINT],'nullcase2 confirmed')
    union all
    select results_eq('select converter.add_uom(1, 1, NULL, ''tc'',
        2, 0, 0, 0.00, 10.00, true)', 'select ''ERROR! cannot input NULL values for in_user_id, data_type_id or uom_name''','NULL Input error')
    union all
    select results_eq('select count(*) from converter.uom where uom_name = NULL ',ARRAY[0 :: BIGINT],'nullcase3 confirmed')
    union all
    select results_eq('select converter.add_uom(1, 2147483647, ''testcase2'', ''tc'', 2, 0, 0, 0.00, 10.00, true)',
        'select ''ERROR! the entered data_type_id does not match a record the exists in the data_type table''','bad datatype Input error')
    union all
    select results_eq('select count(*) from converter.uom where uom_name = ''testcase2''',ARRAY[0 :: BIGINT],'bad datatype confirmed')
    union all
    select results_eq('select converter.add_uom(1, 1, ''testcase'', ''tc'',
        2, 0, 0, 0.00, 10.00, true)', 'select ''ERROR! the entered combination of uom_name and data_type_id already exist in the table''','Duplicate Input error')
    union all

-- Check delete_uom function
    select results_eq('select converter.delete_uom(2147483647)','select ''ERROR! the entered id does not match an entry in the UOM table''',
        'can''t delete invalid id')
    union all
    select matches((select converter.delete_uom((select converter.uom.id from converter.uom where converter.uom.uom_name = 'testcase'))),
       '\d*', 'delete return confirmation')

    union all
    select results_eq('select count(*) from converter.uom where uom_name = ''testcase'' ',ARRAY[0 :: BIGINT],'UOM DELECTED successfully')
    union all

-- Check update_uom_data_type function
    select results_eq('select converter.update_uom_data_type(1,2147483646,1)', 'select ''uom successfully updated''','uom update success');
    select is((select count(*) from converter.uom where id = 2147483646 and data_type_id =2147483646)::int, 0,'uom datatype changed')
    union all
    select is((select count(*) from converter.uom where id = 2147483646 and data_type_id =1)::int, 1, 'new datatype in uom')
    union all
    select results_eq('select converter.update_uom_data_type(null,2147483646,1)',
        'select ''in_user_id, in_uom_id or in_data_type_id cannot be null''','null userid test');
    select is((select count(*) from converter.uom where id = 2147483646 and data_type_id =1)::int, 1, 'no change to data type')
    union all
    select results_eq('select converter.update_uom_data_type(1,null,1)',
        'select ''in_user_id, in_uom_id or in_data_type_id cannot be null''','null uom_id test');
    select is((select count(*) from converter.uom where id = 2147483646 and data_type_id =1)::int, 1, 'no change to data type')
    union all
    select results_eq('select converter.update_uom_data_type(1,2147483646,null)',
        'select''in_user_id, in_uom_id or in_data_type_id cannot be null''','null data_type_id test');
    select is((select count(*) from converter.uom where id = 2147483646 and data_type_id =1)::int, 1, 'no change to data type');


-- Check update_uom_name function
    select results_eq('select converter.update_uom_name(1,2147483646,''changedUOM'',''cuom'')', 'select ''uom successfully updated''',
        'uom update success');
    select is((select count(*) from converter.uom where id = 2147483646 and uom_name ='testUOMtype' and uom_abbreviation = 'tut')::int,
        0,'uom name changed')
    union all
    select is((select count(*) from converter.uom where id = 2147483646 and uom_name ='changedUOM' and uom_abbreviation = 'cuom')::int,
        1, 'new datatype in uom')
    union all
    select results_eq('select converter.update_uom_name(null,2147483646,''testUOMnull'',''tun'')',
        'select ''in_user_id, in_uom_id, in_uom_name or in_uom_abbreviation cannot be null''','null userid test');
    select is((select count(*) from converter.uom where id = 2147483646 and uom_name ='changedUOM')::int, 1, 'no change to name')
    union all
    select results_eq('select converter.update_uom_name(1,null,''testUOMnull'',''tun'')',
        'select ''in_user_id, in_uom_id, in_uom_name or in_uom_abbreviation cannot be null''','null uom_id test');
    select is((select count(*) from converter.uom where uom_name = 'testUOMnull')::int, 0, 'no change to name')
    union all
    select results_eq('select converter.update_uom_name(1,2147483646,null,''tun'')',
        'select''in_user_id, in_uom_id, in_uom_name or in_uom_abbreviation cannot be null''','null data_type_id test');
    select is((select count(*) from converter.uom where id = 2147483646 and uom_name ='changedUOM')::int, 1, 'no change to data type')
    union all
        select results_eq('select converter.update_uom_name(1,2147483646,''testUOMnull'',null)',
        'select ''in_user_id, in_uom_id, in_uom_name or in_uom_abbreviation cannot be null''','null userid test');
    select is((select count(*) from converter.uom where id = 2147483646 and uom_name ='changedUOM')::int, 1, 'no change to name');

-- Check update_uom_precision function
    select results_eq('select converter.update_uom_precision(1,2147483646,5)', 'select ''uom successfully updated''','uom update success');
    select is((select count(*) from converter.uom where id = 2147483646 and precision =2)::int, 0,'uom precision changed')
    union all
    select is((select count(*) from converter.uom where id = 2147483646 and precision =5)::int, 1, 'new precision in uom')
    union all
    select results_eq('select converter.update_uom_precision(null,2147483646,1)',
        'select ''in_user_id, in_uom_id or in_prec cannot be null''','null userid test');
    select is((select count(*) from converter.uom where id = 2147483646 and precision =5)::int, 1, 'no change to data type')
    union all
    select results_eq('select converter.update_uom_precision(1,null,1)',
        'select ''in_user_id, in_uom_id or in_prec cannot be null''','null uom_id test');
    select is((select count(*) from converter.uom where id = 2147483646 and precision =5)::int, 1, 'no change to data type')
    union all
    select results_eq('select converter.update_uom_precision(1,2147483646,null)',
        'select''in_user_id, in_uom_id or in_prec cannot be null''','null data_type_id test');
    select is((select count(*) from converter.uom where id = 2147483646 and precision =5)::int, 1, 'no change to data type');

    -- Check update_uom_lower function
    select results_eq('select converter.update_uom_lower(1,2147483646,-5.0,2)', 'select ''uom successfully updated''','uom update success');
    select is((select count(*) from converter.uom where (id = 2147483646 and lower_boundary = 0.0 and lower_uom = 1))::int, 0,'uom lower bound changed')
    union all
    select is((select count(*) from converter.uom where id = 2147483646 and lower_boundary = -5.0 and lower_uom = 2)::int, 1,'new lower bound in db')
    union all
    select results_eq('select converter.update_uom_lower(null,2147483646,-5.0,2)',
        'select ''in_user_id or in_uom_id  cannot be null''','null userid test');
    select is((select count(*) from converter.uom where id = 2147483646 and precision =5)::int, 1, 'no change to data type')
    union all
    select results_eq('select converter.update_uom_lower(1,null,-5.0,2)',
        'select ''in_user_id or in_uom_id  cannot be null''','null uom_id test');
    select is((select count(*) from converter.uom where id = 2147483646 and precision =5)::int, 1, 'no change to data type')
    union all
    select results_eq('select converter.update_uom_lower(1,2147483647,-5.0,2)',
        'select ''uom with id: 2147483647 , does not exist''','none existent test');

        -- Check update_uom_upper function
    select results_eq('select converter.update_uom_upper(1,2147483646,-5.0,2)', 'select ''uom successfully updated''','uom update success');
    select is((select count(*) from converter.uom where (id = 2147483646 and lower_boundary = 0.0 and lower_uom = 1))::int, 0,'uom upper bound changed')
    union all
    select is((select count(*) from converter.uom where id = 2147483646 and lower_boundary = -5.0 and lower_uom = 2)::int, 1,'new upper bound in db')
    union all
    select results_eq('select converter.update_uom_upper(null,2147483646,-5.0,2)',
        'select ''in_user_id or in_uom_id cannot be null''','null userid test');
    select is((select count(*) from converter.uom where id = 2147483646 and precision =5)::int, 1, 'no change to data type')
    union all
    select results_eq('select converter.update_uom_upper(1,null,-5.0,2)',
        'select ''in_user_id or in_uom_id cannot be null''','null uom_id test');
    select is((select count(*) from converter.uom where id = 2147483646 and precision =5)::int, 1, 'no change to data type')
    union all
    select results_eq('select converter.update_uom_upper(1,2147483647,-5.0,2)',
        'select ''uom with id: 2147483647 , does not exist''','none existent test');

    $$ language sql;