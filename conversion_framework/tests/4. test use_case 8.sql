set search_path = "converter_tests";
create or replace function  converter_tests.test_usecase_8(
) returns setof text as $$
--verify functions have been created.
    select has_function('converter','add_data_type',ARRAY['integer','text'])
    union all
    select has_function('converter','update_data_type',ARRAY['integer','text','text'])
    union all
    select has_function('converter','set_enabled_data_type',ARRAY['integer','text','boolean'])
    union all

--Check Add sub case
    select results_eq('select converter.add_data_type(1, ''testcase'')','select ''Data type: "testcase" was added successfully.''','add_data_type success return')
    union all
    select results_eq('select count(*) from converter.data_type where name = ''testcase'' ',ARRAY[1 :: BIGINT],'Data Type added successfully' )
    union all
    select results_eq('select converter.add_data_type(NULL,NULL)','select ''Error! Cannot input <NULL> values.''','\NULL Value Error Caught')
    union all
    select results_eq('select count(*) from converter.data_type where name is NULL ',ARRAY[0 :: BIGINT],'\NULL VALUE NOT added')
    union all
    select results_eq('select converter.add_data_type(1, ''testcase'')','select ''Error! The data type: "testcase" already exists.''','add_data_type failure duplicate')
    union all
    select results_eq('select count(*) from converter.data_type where name = ''testcase'' ',ARRAY[1 :: BIGINT],'Confirmed duplicate entry not added' )
    union all

--Check update sub case. Current add value is testcase plus values existing in the database
    select results_eq('select converter.update_data_type(1, ''testcase'',''testcaseTwo'')','select ''Data type: "testcase" was successfully updated to: "testcaseTwo".''','testcase updated to testcaseTwo')
    union all
    select results_eq('select count(*) from converter.data_type where name = ''testcaseTwo'' ',ARRAY[1 :: BIGINT],'testcaseTwo now in database after Update' )
    union all
    select results_eq('select count(*) from converter.data_type where name = ''testcase'' ',ARRAY[0 :: BIGINT],'testcase is not in database after Update' )
    union all
    select converter.add_data_type(1, 'testcase')
    union all
    select results_eq('select converter.update_data_type(1, ''testcaseTwo'',''testcase'')','select ''Error! The data type: "testcase" already exists.''')
    union all
    select results_eq('select count(*) from converter.data_type where name = ''testcaseTwo'' ',ARRAY[1 :: BIGINT],'testcaseTwo has not been updated in database after dup error' )
    union all
    select results_eq('select converter.update_data_type(NULL,''testcase'',NULL)','select ''Error! Cannot input <NULL> values.''','\NULL Value Error Caught')
    union all
    select results_eq('select count(*) from converter.data_type where name is NULL ',ARRAY[0 :: BIGINT],'\NULL VALUE NOT added during update')
    union all

--Check enable/disable sub case
    select results_eq('select converter.set_enabled_data_type(1, ''testcase'',FALSE)','select ''Data type: "testcase" is now disabled.''','testcase success disabled data type returned')
    union all
    select results_eq('select count(*) from converter.data_type where name = ''testcase'' and active = FALSE ',ARRAY[1 :: BIGINT],'Data Type testcase was disabled' )
    union all
    select results_eq('select converter.set_enabled_data_type(1, ''testcase'',TRUE)','select ''Data type: "testcase" is now enabled.''','testcase success enabled data type returned')
    union all
    select results_eq('select count(*) from converter.data_type where name = ''testcase'' and active = TRUE ',ARRAY[1 :: BIGINT],'Data Type testcase was enabled' )
    union all
    select results_eq('select converter.set_enabled_data_type(NULL,NULL,FALSE)','select ''Error! Cannot input <NULL> values.''','\NULL Value Error Caught')
    union all
    select results_eq('select count(*) from converter.data_type where name is NULL and active = FALSE',ARRAY[0 :: BIGINT],'\NULL VALUE NOT set to false')
    union all
    select results_eq('select count(*) from converter.data_type where name is NULL and active = TRUE',ARRAY[0 :: BIGINT],'\NULL VALUE NOT set to true')
    union all
    select results_eq('select converter.set_enabled_data_type(1, ''doesNotExist'',FALSE)','select ''Error! The data type: "doesNotExist" does not exist.''','None existent datatype error confirmed')
    union all
    select results_eq('select count(*) from converter.data_type where name = ''doesNotExist'' and active = FALSE ',ARRAY[0 :: BIGINT],'Data Type does not exist not in database')
    union all

--check the datatype getter

    select results_eq('select converter.get_id_from_data_type(1,''testcase'')::INT','select id from converter.data_type where name = ''testcase''','ID retrieved.')
    union all
    select results_eq('select converter.get_id_from_data_type(1,''testcase23'')::INT',ARRAY[-1],'ID does not exist')
;
    $$ language sql;