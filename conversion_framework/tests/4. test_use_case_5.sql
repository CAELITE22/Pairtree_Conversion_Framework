set search_path = "converter_tests";

create or replace function converter_tests.test_use_case_5_add_conversion_set(
) returns setof text as $$
-- check if all functions exist
    select has_function('converter', 'add_conversion_set', ARRAY['integer', 'text'])
    union all

-- test add_conversion_set

    select isa_ok((select converter.add_conversion_set(-1, 'TestConversionSet')),
       'integer', 'Conversion set was successfully created - Unit Test 1')
    union all
    select throws_ok ('select converter.add_conversion_set(null,''Metric'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.add_conversion_set(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Conversion Set Name cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.add_conversion_set(-1,''TestConversionSet'')', 'CF011', (select error_description from converter.response where error_code = 'CF011')::text,
        'Conversion Set Already Exists - Unit Test 4')
$$ language sql;

create or replace function converter_tests.test_use_case_5_clone_conversion_set(
) returns setof text as $$
-- check if all functions exist
    select has_function('converter', 'clone_conversion_set', ARRAY['integer', 'text', 'text'])
    union all
    select isa_ok((select converter.clone_conversion_set(-1, 'Metric','TestConversionSet')),
       'integer', 'Conversion set was successfully cloned - Unit Test 1')
    union all
    select throws_ok ('select converter.clone_conversion_set(null,''Metric'',''TestConversionSet'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.clone_conversion_set(-1,null,''Metric'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Source Conversion Set Name cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.clone_conversion_set(-1,''Metric'',null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Destination Conversion Set Name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.clone_conversion_set(-1,''Metric'',''TestConversionSet'')', 'CF011', (select error_description from converter.response where error_code = 'CF011')::text,
        'Destination Conversion Set Already Exists - Unit Test 5')
    union all
    select throws_ok ('select converter.clone_conversion_set(-1,''noExist'',''TestConversionSet2'')', 'CF012', (select error_description from converter.response where error_code = 'CF012')::text,
        'Source Conversion Set Does not exists - Unit Test 6')
$$ language sql;

set search_path = "converter_tests";

create or replace function converter_tests.test_usecase_5_add_conversion_set(
) returns setof text as $$
    select has_function('converter', 'get_conversion_set_id_from_name', ARRAY['integer', 'text'])
    union all
    select isa_ok((select converter.get_conversion_set_id_from_name(-1, 'Metric')),
       'integer', 'Conversion set was successfully cloned - Unit Test 1')
    union all
    select throws_ok ('select converter.add_conversion_set(null,''Metric'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.add_conversion_set(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Source Conversion Set Name cannot be null - Unit Test 3')
$$ language sql;