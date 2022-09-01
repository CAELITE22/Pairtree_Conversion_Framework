set search_path = "converter_tests";
drop function converter_tests.test_usecase_7;
create or replace function  converter_tests.test_usecase_7(
) returns setof text as $$
-- setup for test.
insert into converter.data_type (id, name, translation, created, created_by,
                                 updated, updated_by, active)
  values (2147483646,'testDataType', FALSE, now(), -1, now(), -1, TRUE);
insert into converter.uom (id, data_type_id, uom_name, uom_abbreviation, precision, upper_boundary, lower_boundary,
                           upper_uom, lower_uom, owner_user_id, created, updated, created_by, updated_by, active)
    values (2147483646, 2147483646, 'testUOMtype','tut',2,10.0,0.0,1,1,-1,now(),now(),-1,-1,true);

--verify functions have been created. - DONE
    select has_function('converter','add_uom',ARRAY['integer','integer','text','text','integer','integer','integer','real','real','boolean'])
    union all
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
        ,'\d*', 'correct return from add_uom function');
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