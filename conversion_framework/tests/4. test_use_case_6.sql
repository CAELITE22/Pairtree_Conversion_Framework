set search_path = "converter_tests";
create or replace function converter_tests.test_use_case_6(

) returns setof text as $$
-- verify functions have been created
    select has_function('converter', 'update_default_conversion_set_category_uom', ARRAY['integer', 'text', 'text'])
    union all
    select has_function('converter', 'update_target_conversion_set_category', ARRAY['integer', 'text', 'text', 'text'])
    union all

    select results_eq('select converter.update_default_conversion_set_category_uom(NULL, ''test_case'', ''test_case'')', 'select ''Error! Cannot input <NULL> values.''', 'will not accept null user id')
    union all
    select results_eq('select converter.update_default_conversion_set_category_uom(1, NULL, ''test_case'')', 'select ''Error! Cannot input <NULL> values.''', 'will not accept null data category')
    union all
    select results_eq('select converter.update_default_conversion_set_category_uom(1, ''test_case'', NULL)', 'select ''Error! Cannot input <NULL> values.''', 'will not accept null uom')
    union all
    select results_eq('select converter.update_default_conversion_set_category_uom(1, ''use_case_6_test_dc'', ''use_case_6_test_uom'')', 'select ''Error! The specified data category does not exist.''', 'will not accept a data category that does not exist')
    union all
    -- create the data_category
    select converter.add_data_type(1, 'use_case_6_test_dt')
    union all
    select  converter.get_id_from_data_type(1, 'use_case_6_test_dt')::text
    union all
    select converter.get_id_from_data_type(1, 'use_case_6_test_dt')::text
    union all
    select converter.add_data_category(1, 'use_case_6_test_dc', (converter.get_id_from_data_type(1, 'use_case_6_test_dt'))::INT)
    union all
    select results_eq('select converter.update_default_conversion_set_category_uom(1, ''use_case_6_test_dc'', ''use_case_6_test_uom'')', 'select ''Error! The specified uom does not exist''', 'will not accept data type that doesnt exist')
    union all
    select converter.add_uom(
                1,
                converter.get_id_from_data_type(1, 'use_case_6_test_dt')::int,
                'use_case_6_test_uom',
                'uc6',
                1,
                NULL,
                NULL,
                NULL,
                NULL,
                true
               )
    union all
    select results_eq('select converter.update_default_conversion_set_category_uom(1, ''use_case_6_test_dc'', ''use_case_6_test_uom'')', 'select ''Conversion set was updated successfully''', 'functions works correctly')
    union all

    select results_eq('update_target_conversion_set_category(1, ''failed_cs_name'', ''failed_dc_name'', ''failed_uom_name'')', '','')

$$ language sql;