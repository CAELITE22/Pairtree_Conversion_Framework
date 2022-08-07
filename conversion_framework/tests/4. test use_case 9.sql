create schema converter_tests;

set search_path = "kris.converter_tests";
create or replace function  converter_tests.test_usecase_9 (
) returns setof text as $$
--verify functions have been created.
    select has_function('converter','add_data_category',ARRAY['integer','text','integer'])
    union all
    select has_function('converter','update_data_category_name',ARRAY['integer','text','text'])
    union all
    select has_function('converter','update_data_category_data_type',ARRAY['integer','text','integer'])
    union all
    select has_function('converter','set_enabled_data_category',ARRAY['integer','text','boolean'])
    union all
    select has_function('converter','get_id_from_data_category',ARRAY['integer','text'])
    union all

--Check Add sub case
    select results_eq('select converter.add_data_category(1, ''testcase'', 1)','select ''Data category: "testcase" was added successfully.''','add_data_category success return')
    union all
    select results_eq('select count(*) from converter.data_category where name = ''testcase'' ',ARRAY[1 :: BIGINT],'Data Category added successfully' )
    union all
    select results_eq('select converter.add_data_category(NULL,NULL,NULL)','select ''Error! Cannot input <NULL> values.''','\NULL Value Error Caught')
    union all
    select results_eq('select count(*) from converter.data_category where name is NULL ',ARRAY[0 :: BIGINT],'\NULL VALUE NOT added')
    union all
    select results_eq('select converter.add_data_category(1, ''testcase'')','select ''Error! The data category: "testcase" already exists.''','add_data_category failure duplicate')
    union all
    select results_eq('select count(*) from converter.data_category where name = ''testcase'' and type_id = 1',ARRAY[1 :: BIGINT],'Confirmed duplicate entry not added' )
    union all

--Check update sub case. Current add value is testcase plus values existing in the database
    select results_eq('select converter.update_data_category_data_type(1,''testcase'', 2)','select ''Data category: "testcase" was successfully updated to use data type: "2".','testcase updated to data_type: 2')
    union all
    select results_eq('select count(*) from converter.data_category where name = ''testcase'' and type_id = 2',ARRAY[1 :: BIGINT],'Confirmed testcase is using datatype 2' )
    union all
    select results_eq('select converter.update_data_category_name(1, ''testcase'',''testcaseTwo'')','select ''Data category: "testcase" was successfully updated to: "testcaseTwo".''','testcase updated to testcaseTwo')
    union all
    select results_eq('select count(*) from converter.data_category where name = ''testcaseTwo'' and type_id = 2',ARRAY[1 :: BIGINT],'testcaseTwo now in database after Update' )
    union all
    select results_eq('select count(*) from converter.data_category where name = ''testcase'' ',ARRAY[0 :: BIGINT],'testcase is not in database after Update' )
    union all
    select converter.add_data_category(1, 'testcase', 1)
    union all
    select results_eq('select converter.update_data_category_name(1, ''testcaseTwo'',''testcase'')','select ''Error! The data category: "testcase" already exists.''')
    union all
    select results_eq('select count(*) from converter.data_category where name = ''testcaseTwo'' ',ARRAY[1 :: BIGINT],'testcaseTwo has not been updated in database after dup error' )
    union all
    select results_eq('select converter.update_data_category_name(NULL,''testcase'',NULL)','select ''Error! Cannot input <NULL> values.''','\NULL Value Error Caught')
    union all
    select results_eq('select count(*) from converter.data_category where name is NULL ',ARRAY[0 :: BIGINT],'\NULL VALUE NOT added during update')
    union all
    select results_eq('select converter.update_data_category_data_type(1,''testcase'',NULL)','select ''Error! Cannot input <NULL> values.''','\NULL Value Error Caught')
    union all
    select results_eq('select count(*) from converter.data_category where name = "testcase" and type_id is NULL ',ARRAY[0 :: BIGINT],'\NULL VALUE NOT added during update')
    union all

--Check enable/disable sub case
    select results_eq('select converter.set_enabled_data_category(1, ''testcase'',FALSE)','select ''Data category: "testcase" is now disabled.''','testcase success disabled data category returned')
    union all
    select results_eq('select count(*) from converter.data_category where name = ''testcase'' and active = FALSE ',ARRAY[1 :: BIGINT],'Data Category testcase was disabled' )
    union all
    select results_eq('select converter.set_enabled_data_category(1, ''testcase'',TRUE)','select ''Data category: "testcase" is now enabled.''','testcase success enabled data category returned')
    union all
    select results_eq('select count(*) from converter.data_category where name = ''testcase'' and active = TRUE ',ARRAY[1 :: BIGINT],'Data Category testcase was enabled' )
    union all
    select results_eq('select converter.set_enabled_data_category(NULL,NULL,FALSE)','select ''Error! Cannot input <NULL> values.''','\NULL Value Error Caught')
    union all
    select results_eq('select count(*) from converter.data_category where name is NULL and active = FALSE',ARRAY[0 :: BIGINT],'\NULL VALUE NOT set to false')
    union all
    select results_eq('select count(*) from converter.data_category where name is NULL and active = TRUE',ARRAY[0 :: BIGINT],'\NULL VALUE NOT set to true')
    union all
    select results_eq('select converter.set_enabled_data_category(1, ''doesNotExist'',FALSE)','select ''Error! The data category: "doesNotExist" does not exist.''','None existent Data Category error confirmed')
    union all
    select results_eq('select count(*) from converter.data_category where name = ''doesNotExist'' and active = FALSE ',ARRAY[0 :: BIGINT],'Data Category does not exist not in database')
    union all

--check the datatype getter

    select results_eq('select converter.get_id_from_data_category(1,''testcase'')::INT','select id from converter.data_category where name = ''testcase''','ID retrieved.')
    union all
    select results_eq('select converter.get_id_from_data_category(1,''testcase23'')::INT',ARRAY[-1],'ID does not exist')
;
    $$ language sql;