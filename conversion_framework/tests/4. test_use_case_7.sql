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
    select throws_ok ('select converter.add_uom(null,2,''a'',''b'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.add_uom(-1,null,''a'',''b'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type cannot be null - Unit Test 6')
    union all
    select throws_ok ('select converter.add_uom(-1,2,null,''b'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Name cannot be null - Unit Test 7')
    union all
    select throws_ok ('select converter.add_uom(-1,2,''a'',null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Abbreviation cannot be null - Unit Test 8')
    union all
    select throws_ok ('select converter.add_uom(-1,2,''a'',''b'')', 'CF015', (select error_description from converter.response where error_code = 'CF015'),
    'Data Type cannot be found - Unit Test 9')
    union all
    select throws_ok ('select converter.add_uom(-1,2,''testcase1'',''b'')', 'CF016', (select error_description from converter.response where error_code = 'CF016'),
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
    select throws_ok ('select converter.set_enabled_uom(null, 1, true)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.set_enabled_uom(-1, null, true)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.set_enabled_uom(-1, 1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Status cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.set_enabled_uom(-1, -1, true)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
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
    select throws_ok ('select converter.get_uom_data_type_from_id(null, 1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_data_type_from_id(-1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_data_type_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
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
    select ok((select (select converter.get_uom_name_abbr_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1'))) = 'testcase1|tc1'),'Confirm current UOM name and abbr - Unit Test 1a')
    union all
    select ok((select converter.update_uom_name_and_abbr(-1,converter.get_uom_id_from_name(-1,'testcase1'),'testcase2','tc2')),'UOM Name and Abbreviation Updated Successfully - Unit Test 1b')
    union all
    select ok((select (select converter.get_uom_name_abbr_from_id(-1,converter.get_uom_id_from_name(-1,'testcase2'))) = 'testcase2|tc2'),'Confirm current UOM name and abbr - Unit Test 1a')
    union all
    -- test error states
    select throws_ok ('select converter.update_uom_name_and_abbr(null,2,''a'',''b'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_uom_name_and_abbr(-1,null,''a'',''b'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_uom_name_and_abbr(-1,2,null,''b'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_uom_name_and_abbr(-1,2,''a'',null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Abbreviation cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.update_uom_name_and_abbr(-1,-1,''a'',''b'')', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'UOM ID cannot be found - Unit Test 6')
    union all
    select throws_ok ('select converter.update_uom_name_and_abbr(-1,2,''testcase2'',''b'')', 'CF017', (select error_description from converter.response where error_code = 'CF017'),
    'UOM Name already exists - Unit Test 7')
    union all
    select throws_ok ('select converter.update_uom_name_and_abbr(-1,2,''abc'',''tc2'')', 'CF017', (select error_description from converter.response where error_code = 'CF017'),
    'UOM Abbreviation already exists - Unit Test 8')
    union all
        select throws_ok ('select converter.update_uom_name_and_abbr(-1,2,''testcase2'',''tc2'')', 'CF017', (select error_description from converter.response where error_code = 'CF017'),
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
    select throws_ok ('select converter.update_uom_name(null,2,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_uom_name(-1,null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_uom_name(-1,2,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_uom_name(-1,-1,''a'')', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'UOM ID cannot be found - Unit Test 5')
    union all
    select throws_ok ('select converter.update_uom_name(-1,2,''testcase2'')', 'CF017', (select error_description from converter.response where error_code = 'CF017'),
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
    select throws_ok ('select converter.update_uom_abbr(null,2,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_uom_abbr(-1,null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_uom_abbr(-1,2,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_uom_abbr(-1,-1,''a'')', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'UOM ID cannot be found - Unit Test 5')
    union all
    select throws_ok ('select converter.update_uom_abbr(-1,2,''testcase2'')', 'CF017', (select error_description from converter.response where error_code = 'CF017'),
    'UOM Name already exists - Unit Test 6')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_precision()
returns setof text as $$
    --converter.update_uom_precision(in_user_id int, in_uom_id int, in_prec int)
    --prepare data
    select converter.add_uom(-1, 1, 'testcase1', 'tc1',1);
    select converter.add_uom(-1, 1, 'testcase2', 'tc2');

    --verify function has been created.
    select has_function('converter','update_uom_precision',ARRAY['integer','integer','integer'])
    union all
    select ok(((select converter.get_uom_prec_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = 1),'Confirm current specified UOM precision - Unit Test 1a')
    union all
    select ok((select converter.update_uom_precision(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'),5)),'UOM precision Updated Successfully - Unit Test 1b')
    union all
    select ok(((select converter.get_uom_prec_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = 5),'Confirm updated UOM precision - Unit Test 1c')
    union all
    select ok(((select converter.get_uom_prec_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc2'))) = 3),'Confirm current specified UOM precision - Unit Test 2a')
    union all
    select ok((select converter.update_uom_precision(-1,converter.get_uom_id_from_abbreviation(-1,'tc2'),5)),'UOM precision Updated Successfully - Unit Test 2b')
    union all
    select ok(((select converter.get_uom_prec_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc2'))) = 5),'Confirm updated UOM precision - Unit Test 2c')
    union all
    -- test error states
    select throws_ok ('select converter.update_uom_precision(null,2,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_uom_precision(-1,null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_uom_precision(-1,2,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_uom_abbr(-1,-1,1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'UOM ID cannot be found - Unit Test 5')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_lower()
returns setof text as $$
    --converter.update_uom_lower(in_user_id int, in_uom_id int, in_lower_boundary real default null, in_lower_uom int default null)
    --prepare data
    select converter.add_uom(-1, 1, 'testcase1', 'tc1');
    select converter.add_uom(-1, 1, 'testcase2', 'tc2');
    select converter.add_uom(-1, 2, 'testcase3', 'tc3');

    --verify function has been created.
    select has_function('converter','update_uom_lower',ARRAY['integer','integer','real','integer'])
    union all
    select ok(((select converter.get_uom_lower_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) is null),'Confirm current specified UOM lower and boundary - Unit Test 1a')
    union all
    select ok((select converter.update_uom_lower(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'),20,converter.get_uom_id_from_abbreviation(-1,'tc2'))),'UOM lower and boundary Updated Successfully - Unit Test 1b')
    union all
    select ok(((select converter.get_uom_lower_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = (select converter.get_uom_id_from_abbreviation(-1,'tc2') || '|20')),'Confirm updated UOM lower and boundary - Unit Test 1c')
    union all
    -- test error states
    select throws_ok ('select converter.update_uom_lower(null,2,1,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_uom_lower(-1,null,1,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_uom_lower(-1,1,null,1)', 'CF018', (select error_description from converter.response where error_code = 'CF018'),
    'Lower Boundary and ID must both be set or both be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_uom_lower(-1,1,1,null)', 'CF018', (select error_description from converter.response where error_code = 'CF018'),
    'Lower Boundary and ID must both be set or both be null - Unit Test 5')
    union all
    select throws_ok ('select converter.update_uom_lower(-1,1,1,null)', 'CF018', (select error_description from converter.response where error_code = 'CF018'),
    'Lower Boundary and ID must both be set or both be null - Unit Test 5')
    union all
    select throws_ok ('select converter.update_uom_lower(-1,-1,1,1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Source UOM cannot be found - Unit Test 6')
    union all
    select throws_ok ('select converter.update_uom_lower(-1,1,1,-1)', 'CF020', (select error_description from converter.response where error_code = 'CF020'),
    'Lower UOM cannot be found - Unit Test 7')
    union all
    select throws_ok ('select converter.update_uom_lower(-1,converter.get_uom_id_from_abbreviation(-1,''tc1''),1,converter.get_uom_id_from_abbreviation(-1,''tc3''))', 'CF019', (select error_description from converter.response where error_code = 'CF019'),
    'Source and boundary UOM are not of the same data type - Unit Test 7')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_upper()
returns setof text as $$
    --converter.update_uom_upper(in_user_id int, in_uom_id int, in_upper_boundary real default null, in_upper_uom int default null)
    --prepare data
    select converter.add_uom(-1, 1, 'testcase1', 'tc1');
    select converter.add_uom(-1, 1, 'testcase2', 'tc2');
    select converter.add_uom(-1, 2, 'testcase3', 'tc3');

    --verify function has been created.
    select has_function('converter','update_uom_upper',ARRAY['integer','integer','real','integer'])
    union all
    select ok(((select converter.get_uom_upper_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) is null),'Confirm current specified UOM lower and boundary - Unit Test 1a')
    union all
    select ok((select converter.update_uom_upper(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'),20,converter.get_uom_id_from_abbreviation(-1,'tc2'))),'UOM lower and boundary Updated Successfully - Unit Test 1b')
    union all
    select ok(((select converter.get_uom_upper_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = (select converter.get_uom_id_from_abbreviation(-1,'tc2') || '|20')),'Confirm updated UOM lower and boundary - Unit Test 1c')
    union all
    -- test error states
    select throws_ok ('select converter.update_uom_upper(null,2,1,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_uom_upper(-1,null,1,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_uom_upper(-1,1,null,1)', 'CF018', (select error_description from converter.response where error_code = 'CF018'),
    'Lower Boundary and ID must both be set or both be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_uom_upper(-1,1,1,null)', 'CF018', (select error_description from converter.response where error_code = 'CF018'),
    'Lower Boundary and ID must both be set or both be null - Unit Test 5')
    union all
    select throws_ok ('select converter.update_uom_upper(-1,1,1,null)', 'CF018', (select error_description from converter.response where error_code = 'CF018'),
    'Lower Boundary and ID must both be set or both be null - Unit Test 5')
    union all
    select throws_ok ('select converter.update_uom_upper(-1,-1,1,1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Source UOM cannot be found - Unit Test 6')
    union all
    select throws_ok ('select converter.update_uom_upper(-1,1,1,-1)', 'CF020', (select error_description from converter.response where error_code = 'CF020'),
    'Lower UOM cannot be found - Unit Test 7')
    union all
    select throws_ok ('select converter.update_uom_upper(-1,converter.get_uom_id_from_abbreviation(-1,''tc1''),1,converter.get_uom_id_from_abbreviation(-1,''tc3''))', 'CF019', (select error_description from converter.response where error_code = 'CF019'),
    'Source and boundary UOM are not of the same data type - Unit Test 7')
$$ language sql;



CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_id_from_name()
returns setof text as $$
    --converter.get_uom_id_from_name(in_user_id int, in_uom_name text)
    --verify function has been created.
    select has_function('converter','get_uom_id_from_name',ARRAY['integer','integer','real','integer'])
    union all
    select ok((select converter.add_uom(-1, 1, 'testcase1', 'tc1') = (select converter.get_uom_id_from_name(-1,'testcase1'))),'Confirmed correct ID returned from name - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_id_from_name(null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.get_uom_id_from_name(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Name cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_id_from_name(-1,''a'')', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'UOM Name cannot be found - Unit Test 4')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_id_from_abbreviation()
returns setof text as $$
  --converter.get_uom_id_from_abbreviation(in_user_id int, in_uom_abbr text)
    --verify function has been created.
    select has_function('converter','get_uom_id_from_abbreviation',ARRAY['integer','text'])
    union all
    select ok((select converter.add_uom(-1, 1, 'testcase1', 'tc1') = (select converter.get_uom_id_from_abbreviation(-1,'tc1'))),'Confirmed correct ID returned from abbreviation - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_id_from_abbreviation(null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.get_uom_id_from_abbreviation(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Name cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_id_from_abbreviation(-1,''a'')', 'CF010', (select error_description from converter.response where error_code = 'CF010'),
    'UOM abbreviation cannot be found - Unit Test 4')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_status_from_id()
returns setof text as $$
    --converter.get_uom_status_from_id(in_user_id int, in_uom_id int)
    --prepare data
    select converter.add_uom(-1, 1, 'testcase1', 'tc1');
    --verify function has been created.
    select has_function('converter','get_uom_status_from_id',ARRAY['integer','integer'])
    union all
    select ok((select converter.get_uom_status_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1')) = true),'Confirmed enabled - Unit Test 1a')
    union all
    select ok((select converter.set_enabled_uom(-1,converter.get_uom_id_from_name(-1,'testcase1'),false)),'UOM set to disabled - Unit Test 1b')
    union all
    select ok((select converter.get_uom_status_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1')) = false),'Confirmed disabled - Unit Test 1c')
    union all
    select ok((select converter.set_enabled_uom(-1,converter.get_uom_id_from_name(-1,'testcase1'),true)),'UOM set to enabled - Unit Test 2a')
    union all
    select ok((select converter.get_uom_status_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1'))),'Confirmed enabled - Unit Test 2b')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_status_from_id(null, 1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_status_from_id(-1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_status_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Confirmed UOM ID not found - Unit Test 5')
$$ language sql;

CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_abbr_from_id()
returns setof text as $$
    --converter.get_uom_abbr_from_id(in_user_id int, in_uom_id int)
    --prepare data
    select converter.add_uom(-1, 1, 'testcase1', 'tc1');
    --verify function has been created.
    select has_function('converter','get_uom_abbr_from_id',ARRAY['integer','integer'])
    union all
    select ok((select converter.get_uom_abbr_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1'))) = 'tc1','Confirmed abbreviation correct - Unit Test 1b')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_abbr_from_id(null, 1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_abbr_from_id(-1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_abbr_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Confirmed UOM ID not found - Unit Test 5')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_data_type_from_id()
returns setof text as $$
    --converter.get_uom_data_type_from_id(in_user_id int, in_uom_id int)
    --prepare data
    select converter.add_uom(-1, 3, 'testcase1', 'tc1');
    --verify function has been created.
    select has_function('converter','get_uom_data_type_from_id',ARRAY['integer','integer'])
    union all
    select ok((select converter.get_uom_data_type_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1'))) = 3,'Confirmed data type correct - Unit Test 1b')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_data_type_from_id(null, 1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_data_type_from_id(-1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_data_type_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Confirmed UOM ID not found - Unit Test 5')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_lower_from_id()
returns setof text as $$
    --converter.get_uom_lower_from_id(in_user_id int, in_uom_id int)
    --prepare data
    select converter.add_uom(-1, 3, 'testcase1', 'tc1');
    select converter.add_uom(-1, 3, 'testcase3', 'tc3');
    select converter.add_uom(-1, 3, 'testcase2', 'tc2',3,converter.get_uom_id_from_abbreviation(-1,'tc3'),converter.get_uom_id_from_abbreviation(-1,'tc1'),1000,100);
    --verify function has been created.
    select has_function('converter','get_uom_lower_from_id',ARRAY['integer','integer'])
    union all
    select ok((select converter.get_uom_lower_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc2'))) = concat(converter.get_uom_id_from_abbreviation(-1,'tc1') || '|100'),'Confirmed lower uom and boundary correct - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_lower_from_id(null, 1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_lower_from_id(-1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_lower_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Confirmed UOM ID not found - Unit Test 5')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_upper_from_id()
returns setof text as $$
    --converter.get_uom_upper_from_id(in_user_id int, in_uom_id int)
    --prepare data
    select converter.add_uom(-1, 3, 'testcase1', 'tc1');
    select converter.add_uom(-1, 3, 'testcase3', 'tc3');
    select converter.add_uom(-1, 3, 'testcase2', 'tc2',3,converter.get_uom_id_from_abbreviation(-1,'tc3'),converter.get_uom_id_from_abbreviation(-1,'tc1'),1000,100);
    --verify function has been created.
    select has_function('converter','get_uom_upper_from_id',ARRAY['integer','integer'])
    union all
    select ok((select converter.get_uom_upper_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc2'))) = concat(converter.get_uom_id_from_abbreviation(-1,'tc3') || '|1000'),'Confirmed upper uom and boundary correct - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_upper_from_id(null, 1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_upper_from_id(-1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_upper_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Confirmed UOM ID not found - Unit Test 5')
$$ language sql;

CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_name_abbr_from_id()
returns setof text as $$
    --converter.get_uom_name_abbr_from_id(in_user_id int, in_uom_id int)
    --prepare data
    select converter.add_uom(-1, 3, 'testcase1', 'tc1');
    --verify function has been created.
    select has_function('converter','get_uom_name_abbr_from_id',ARRAY['integer','integer'])
    union all
    select ok(((select converter.get_uom_name_abbr_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = 'testcase1|tc1'),'Confirmed UOM name and abbreviation correct - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_name_abbr_from_id(null, 1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_name_abbr_from_id(-1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_name_abbr_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Confirmed UOM ID not found - Unit Test 5')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_name_from_id()
returns setof text as $$
    --converter.get_uom_name_from_id(in_user_id int, in_uom_id int)
    --prepare data
    select converter.add_uom(-1, 3, 'testcase1', 'tc1');
    --verify function has been created.
    select has_function('converter','get_uom_name_from_id',ARRAY['integer','integer'])
    union all
    select ok(((select converter.get_uom_name_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = 'testcase1'),'Confirmed UOM name correct - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_name_from_id(null, 1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_name_from_id(-1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_name_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Confirmed UOM ID not found - Unit Test 5')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_prec_from_id()
returns setof text as $$
    --converter.get_uom_prec_from_id(in_user_id int, in_uom_id int)
    --prepare data
    select converter.add_uom(-1, 3, 'testcase1', 'tc1',3);
    --verify function has been created.
    select has_function('converter','get_uom_prec_from_id',ARRAY['integer','integer'])
    union all
    select ok(((select converter.get_uom_prec_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = 3),'Confirmed UOM precision correct - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_prec_from_id(null, 1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_prec_from_id(-1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_prec_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Confirmed UOM ID not found - Unit Test 5')
$$ language sql;