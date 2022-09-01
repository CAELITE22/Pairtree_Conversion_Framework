set search_path = "converter_tests";
create or replace function converter_tests.test_use_case_4(
) returns setof text as $$
    -- label testing
    select '# # # Testing Use Case 4 - Set users conversion set # # #'
    union all
    --verify required function has been created
    select has_function('converter', 'set_user_conversion_set', ARRAY['integer', 'integer'])
    union all
    --verify function
    select ok((select converter.set_user_conversion_set(-1,2) = true),'Confirm happy path - Unit Test 1a')
    union all
    select results_eq('select count(*) from converter.user_conversion_set where active = true and user_id = -1 and conversion_set_id = 2',
        ARRAY[1::bigint], 'Confirm user conversion set updated - Unit Test 1b')
    union all
    select results_eq('select count(*) from converter.user_conversion_set where active = true and user_id = -4',
        ARRAY[0::bigint], 'confirm user conversion set does not exist before adding new user - Unit Test 2a')
    union all
    select ok((select converter.set_user_conversion_set(-4,2)),'Confirm happy path - Unit Test 2b')
    union all
    select results_eq('select count(*) from converter.user_conversion_set where active = true and user_id = -4 and conversion_set_id = 2',
        ARRAY[1::bigint], 'Confirm new user conversion set added - Unit Test 2c')
    union all

    -- test error states
    select throws_ok ('select converter.set_user_conversion_set(null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.set_user_conversion_set(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Conversion Set ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.set_user_conversion_set(-1,-5)', 'CF007', (select error_description from converter.response where error_code = 'CF007')::text,
        'Conversion Set ID cannot be found - Unit Test 5')
$$ language sql;