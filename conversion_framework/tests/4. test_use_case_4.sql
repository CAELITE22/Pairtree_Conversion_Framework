set search_path = "converter_tests";

create or replace function converter_tests.test_usecase_4(
) returns setof text as $$

    select has_function('converter', 'set_user_conversion_set', ARRAY['integer', 'integer'])
    union all

    select results_eq('select converter.set_user_conversion_set(1, NULL)', 'select ''conversion set or user ID can not be NULL''', 'does not accept null cs_id')
    union all
    select results_eq('select converter.set_user_conversion_set(NULL, 1)', 'select ''conversion set or user ID can not be NULL''', 'does not accept null user id')
    union all
    select results_eq('select converter.set_user_conversion_set(1, -50)', 'select ''conversion_set_id does not exist''', 'does not accept conversion sets that dont exist')
    union all
    select converter.add_conversion_set('1', 'test_uc_4')
    union all
    select results_eq('select converter.set_user_conversion_set(1, converter.get_conversion_set_id_from_name(1, ''test_uc_4''))', 'select ''user conversion set is now set to test_uc_4''', 'sets a user conversion set correctly, when supplied valid inputs')

$$ language sql;