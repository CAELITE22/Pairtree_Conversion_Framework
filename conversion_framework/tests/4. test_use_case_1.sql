set search_path = "converter_tests";
create or replace function  converter_tests.test_use_case_1(
) returns setof text as $$
    --verify required function has been created
    select has_function('converter','ccrd',ARRAY['integer','text','text','float'])
    union all

    --basic functionality testing at 0c and converting to desired sets.
    select results_eq('select converter.ccrd(1,''¬∞C'',''Air Temperature'',0)',
                        ARRAY[0::real], 'CCRD unit Test 1')
    union all
    select results_eq('select converter.ccrd(1,''¬∞C'',''Soil Temperature'',0)',
                        ARRAY[0::real], 'CCRD unit Test 2')
    union all
    select results_eq('select converter.ccrd(9,''¬∞C'',''Air Temperature'',0)',
                        ARRAY[32::real], 'CCRD unit Test 3')
    union all
    select results_eq('select converter.ccrd(9,''¬∞C'',''Soil Temperature'',0)',
                        ARRAY[32::real], 'CCRD unit Test 4')

    union all
    select results_eq('select converter.ccrd(15,''¬∞C'',''Air Temperature'',0)',
                        ARRAY[273.15::real], 'CCRD unit Test 5')
    union all
    select results_eq('select converter.ccrd(15,''¬∞C'',''Soil Temperature'',0)',
        ARRAY[491.67::real], 'CCRD unit Test 6')
    union all
    --test randomized data.
    select results_eq('select converter.ccrd(1,pairtreeTestData.uom,pairtreeTestData.metric,' ||
                      'pairtreeTestData.value) from pairtreeTestData',
                      'select resultsc from pairtreeTestData', 'CCRD unit Test 7')
    union all

    select results_eq('select converter.ccrd(9,pairtreeTestData.uom,pairtreeTestData.metric,' ||
                      'pairtreeTestData.value) from pairtreeTestData',
                      'select resultsf from pairtreeTestData', 'CCRD unit Test 8');
$$ language sql;