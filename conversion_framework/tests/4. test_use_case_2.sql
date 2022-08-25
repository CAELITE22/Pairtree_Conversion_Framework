set search_path = "converter_tests";
create or replace function  converter_tests.test_use_case_2(
) returns setof text as $$
    --verify required function has been created
    select has_function('converter','category_to_conversion_set',ARRAY['integer','integer','integer','integer','float'])
    union all

    --basic functionality testing at 0c and converting to desired sets.
    select results_eq('select converter.category_to_conversion_set(1,1,1,2,0)',
                        ARRAY[0::real], 'Convert with specified conversion set unit Test 1')
    union all
    select results_eq('select converter.category_to_conversion_set(1,1,1,1,0)',
                        ARRAY[0::real], 'Convert with specified conversion set unit Test 2')
    union all
    select results_eq('select converter.category_to_conversion_set(9,2,1,2,0)',
                        ARRAY[32::real], 'Convert with specified conversion set unit Test 3')
    union all
    select results_eq('select converter.category_to_conversion_set(9,2,1,1,0)',
                        ARRAY[32::real], 'Convert specifying conversion set unit Test 4')
    union all
    select results_eq('select converter.category_to_conversion_set(15,3,1,2,0)',
                        ARRAY[273.15::real], 'Convert specifying conversion set unit Test 5')
    union all
    select results_eq('select converter.category_to_conversion_set(15,3,1,2,0)',
        ARRAY[491.67::real], 'Convert specifying conversion set unit Test 6')
    union all
    --test randomized data.
    select results_eq('select converter.category_to_conversion_set(1,1,pairtreeTestData.uom,pairtreeTestData.metric,' ||
                      'pairtreeTestData.value) from pairtreeTestData',
                      'select resultsc from pairtreeTestData', 'Convert specifying conversion set unit Test 7')
    union all

    select results_eq('select converter.category_to_conversion_set(9,2,pairtreeTestData.uom,pairtreeTestData.metric,' ||
                      'pairtreeTestData.value) from pairtreeTestData',
                      'select resultsf from pairtreeTestData', 'Convert specifying conversion set unit Test 8');
$$ language sql;