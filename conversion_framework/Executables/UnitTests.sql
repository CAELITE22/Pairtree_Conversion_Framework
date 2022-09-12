DROP SCHEMA if exists converter_tests CASCADE;
CREATE SCHEMA converter_tests;
CREATE EXTENSION pgtap SCHEMA converter_tests;set search_path = "converter_tests";
create or replace function  converter_tests.startup_schema(
) returns setof text as $$
    declare
        currentrecord INT = 1;
        adjustment INT;
        randomValue real;
    begin
        drop table if exists pairtreeTestData;
        create table pairtreeTestData (value real, metric text, uom text, resultsc real,
                    resultsf real);
        WHILE currentrecord <= 1000 loop
        adjustment = mod((floor(random()*39+1)::int),4);
        randomValue = floor(random()*70000)/1000-20;
        insert into pairtreeTestData (value, metric, uom,resultsc,resultsf) values (randomValue,
          case when mod((floor(random()*10)::int),2)= 0 then'Air Temperature'
              else 'Soil Temperature' end,
          case when adjustment = 0 then '¬∞C'
          when adjustment = 1 then '¬∞F'
          when adjustment = 2 then '¬∞Ra'
          when adjustment = 3 then '¬∞K'
          end,
          case when adjustment = 0 then round(randomValue::decimal,3)::real
          when adjustment = 1 then round((((randomValue-32.0)*5)/9)::decimal,3)::real
          when adjustment = 2 then round((((randomValue-491.67)*5)/9)::decimal,3)::real
          when adjustment = 3 then round((randomValue-273.15)::decimal,3)::real
          end,
          case when adjustment = 0 then round(((randomValue) * 1.8 + 32)::decimal,3)::real
          when adjustment = 1 then round(randomValue::decimal,3)::real
          when adjustment = 2 then round((randomValue - 459.67)::decimal,3)::real
          when adjustment = 3 then round(((randomValue-273.15)*1.8 + 32)::decimal,3)::real
          end);
          currentrecord := currentrecord + 1;
        end loop;
    END $$ language plpgsql;set search_path = "converter_tests";
create or replace function  converter_tests.test_schema(
) returns setof text as $$
    -- label testing
    select '# # # Testing Schema Build and Structure # # #'
    union all
    --verifies the schema has been created correctly by script
    select has_schema('converter')
    union all

    --Verify tables are created and are only the required tables
    select has_table('converter'::name,'data_type'::name)
    union all
    select has_table('converter'::name,'uom'::name)
    union all
    select has_table('converter'::name,'data_category'::name)
    union all
    select has_table('converter'::name,'permission'::name)
    union all
    select has_table('converter'::name,'access_rights'::name)
    union all
    select has_table('converter'::name,'response'::name)
    union all
    select has_table('converter'::name,'conversion_set'::name)
    union all
    select has_table('converter'::name,'user_conversion_set'::name)
    union all
    select has_table('converter'::name,'category_to_conversion_set'::name)
    union all
    select has_table('converter'::name,'translation_table'::name)
    union all
    select has_table('converter'::name,'conversion_rate'::name)
    union all
    select tables_are('converter'::name, ARRAY['data_type','uom','data_category',
        'permission','response','conversion_set','translation_table','conversion_rate',
        'access_rights','category_to_conversion_set','user_conversion_set'])
    union all
    --Verify correct columns are present
    select columns_are('converter','data_type',ARRAY['id','name','translation','created',
        'updated','created_by','updated_by','active'])
    union all
    select columns_are('converter','uom',ARRAY['id','data_type_id','uom_name','uom_abbreviation',
        'precision','upper_boundary','lower_boundary','upper_uom','lower_uom','owner_user_id',
        'created','updated','created_by','updated_by','active'])
    union all
    select columns_are('converter','data_category',ARRAY['id','name','type_id','created',
        'updated','created_by','updated_by','active'])

    union all
    select columns_are('converter','permission',ARRAY['id','name'])
    union all
    select columns_are('converter','access_rights',ARRAY['id','owner_id','user_id','created',
        'updated','created_by','updated_by','active','permission_id'])
    union all
    select columns_are('converter','response',ARRAY['id','error_code','error_description'])
    union all
    select columns_are('converter','conversion_set',ARRAY['id','name','owner_user_id','created',
        'updated','created_by','updated_by','active'])
    union all
    select columns_are('converter','user_conversion_set',ARRAY['id','user_id','conversion_set_id',
        'created','updated','created_by','updated_by','active'])
    union all
    select columns_are('converter','category_to_conversion_set',ARRAY['id','conversion_set_id',
        'data_category_id','uom_id','created','updated','created_by','updated_by','active'])
    union all
    select columns_are('converter','translation_table',ARRAY['id','source_uom_id','source_val',
        'destination_uom_id','destination_val','created','updated','created_by','updated_by',
        'active'])
    union all
    select columns_are('converter','conversion_rate',ARRAY['id','uom_id','rate','constant',
        'created','updated','created_by','updated_by','active']);


$$ language sql;
set search_path = "converter_tests";
create or replace function  converter_tests.test_use_case_1_convert(
) returns setof text as $$
    --data setup
    INSERT INTO converter.data_category (id,name, type_id, created, updated, created_by, updated_by, active)
    VALUES (-4, 'TESTCATEGORY', 1, now(), now(), -1, -1, true);
    -- label testing
    select '# # # Testing Use Case 1 - Convert using users default conversion set # # #'
    union all
    --verify required function has been created
    select has_function('converter','convert',ARRAY['integer','integer','integer','float'])
    union all
    --basic functionality testing at 0c and converting to desired sets.
    select results_eq('select converter.convert(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Air Temperature'')),0)',
                        ARRAY[0::real], 'Convert Celsius to Celsius - Unit Test 1')
    union all
    select results_eq('select converter.convert(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Soil Temperature'')),100)',
                        ARRAY[100::real], 'Convert Celsius to Celsius - Unit Test 2')
    union all
    select results_eq('select converter.convert(-2,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Air Temperature'')),0)',
                        ARRAY[32::real], 'Convert Celsius to Fahrenheit - Unit Test 3')
    union all
    select results_eq('select converter.convert(-2,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Soil Temperature'')),37.5)',
                        ARRAY[99.5::real], 'Convert Celsius to Fahrenheit - Unit Test 4')
    union all
    select results_eq('select converter.convert(-1,(select converter.get_uom_id_from_abbreviation(-1,''m'')),(select converter.get_data_category_id_from_name(-1,''Height'')),0.8)',
                        ARRAY[800::real], 'Convert Metres to Millimetres - Unit Test 5')
    union all
    select results_eq('select converter.convert(-2,(select converter.get_uom_id_from_abbreviation(-1,''mm'')),(select converter.get_data_category_id_from_name(-1,''Height'')),127)',
                        ARRAY[5::real], 'Convert Millimetres to Inches - Unit Test 6')
    union all
    select ok((select converter.convert(-1,1,1,null) is null),'Confirm Null value conversion - Unit Test 7')
    union all

    -- test error states
    select throws_ok ('select converter.convert(null,2,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 8')
    union all
    select throws_ok ('select converter.convert(-4,null,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'UOM cannot be null - Unit Test 9')
    union all
    select throws_ok ('select converter.convert(-4,2,null,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Data Category cannot be null - Unit Test 10')
    union all
    select throws_ok ('select converter.convert(-4,2,2,2)', 'CF002', (select error_description from converter.response where error_code = 'CF002')::text,
        'No default conversion set unit Test 11')
    union all
    select throws_ok ('select converter.convert(-1,2,-1,2)', 'CF003', (select error_description from converter.response where error_code = 'CF003')::text,
        'Data category ID not found - Unit Test 12')
    union all
    select throws_ok ('select converter.convert(-1,2,-4,2)', 'CF004', (select error_description from converter.response where error_code = 'CF004')::text,
        'This data category is not defined in the users conversion set - Unit Test 13')
    union all
    select throws_ok ('select converter.convert(-1,-1,1,2)', 'CF005', (select error_description from converter.response where error_code = 'CF005')::text,
        'The UOM found in the conversion set does not exist - Unit test 14')
    union all
    select throws_ok ('select converter.convert(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Height'')),2)', 'CF006', (select error_description from converter.response where error_code = 'CF006')::text,
        'The source UOM and data category are different data types - Unit test 15')
$$ language sql;set search_path = "converter_tests";
create or replace function  converter_tests.test_use_case_2_convert_by_conversion_set(
) returns setof text as $$
    --data setup
    INSERT INTO converter.data_category (id,name, type_id, created, updated, created_by, updated_by, active)
    VALUES (-4, 'TESTCATEGORY', 1, now(), now(), -1, -1, true);

    -- label testing
    select '# # # Testing Use Case 2 - Convert using users a specific conversion set # # #'
    union all
    --verify required function has been created
    select has_function('converter','convert_by_conversion_set',ARRAY['integer','integer','integer','integer','float'])
    union all
    --basic functionality testing at 0c and converting to desired sets.
    select results_eq('select converter.convert_by_conversion_set(-1,1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Air Temperature'')),0)',
                        ARRAY[0::real], 'Convert Celsius to Celsius unit Test 1')
    union all
    select results_eq('select converter.convert_by_conversion_set(-1,1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Soil Temperature'')),100)',
                        ARRAY[100::real], 'Convert Celsius to Celsius unit Test 2')
    union all
    select results_eq('select converter.convert_by_conversion_set(-1,2,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Air Temperature'')),0)',
                        ARRAY[32::real], 'Convert Celsius to Fahrenheit unit Test 3')
    union all
    select results_eq('select converter.convert_by_conversion_set(-1,2,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Soil Temperature'')),37.5)',
                        ARRAY[99.5::real], 'Convert Celsius to Fahrenheit unit Test 4')
    union all
    select results_eq('select converter.convert_by_conversion_set(-1,1,(select converter.get_uom_id_from_abbreviation(-1,''m'')),(select converter.get_data_category_id_from_name(-1,''Height'')),0.8)',
                        ARRAY[800::real], 'Convert Metres to Millimetres unit Test 5')
    union all
    select results_eq('select converter.convert_by_conversion_set(-1,2,(select converter.get_uom_id_from_abbreviation(-1,''mm'')),(select converter.get_data_category_id_from_name(-1,''Height'')),127)',
                        ARRAY[5::real], 'Convert Millimetres to Inches unit Test 6')
    union all
    select ok((select converter.convert_by_conversion_set(-1,1,1,1,null) is null),'Confirm Null value conversion - Unit Test 7')
    union all
    -- test error states
    select throws_ok ('select converter.convert_by_conversion_set(null,1,2,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 8')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-4,null,2,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Conversion Set ID cannot be null - Unit Test 9')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-4,1,null,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'UOM ID cannot be null - Unit Test 10')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-4,1,2,null,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Data Category ID cannot be null - Unit Test 11')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-1,-1,2,2,2)', 'CF007', (select error_description from converter.response where error_code = 'CF007')::text,
        'No default conversion set unit Test 12')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-1,2,2,-1,2)', 'CF003', (select error_description from converter.response where error_code = 'CF003')::text,
        'Data category ID not found - Unit Test 13')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-1,2,2,-4,2)', 'CF004', (select error_description from converter.response where error_code = 'CF004')::text,
        'This data category is not defined in the users conversion set - Unit Test 14')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-1,2,-1,1,2)', 'CF005', (select error_description from converter.response where error_code = 'CF005')::text,
        'The UOM found in the conversion set does not exist - Unit test 15')
    union all
    select throws_ok ('select converter.convert_by_conversion_set(-1,1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_data_category_id_from_name(-1,''Height'')),2)', 'CF006', (select error_description from converter.response where error_code = 'CF006')::text,
        'The source UOM and data category are different data types - Unit test 16')
$$ language sql;set search_path = "converter_tests";
create or replace function  converter_tests.test_use_case_3_convert_by_uom(
) returns setof text as $$
    -- label testing
    select '# # # Testing Use Case 3 - Convert using source and destination UOM # # #'
    union all
    --verify required function has been created
    --convert_by_uom(in_user_id int, in_uom_id int, out_uom_id int, in_value float)
    select has_function('converter','convert_by_uom',ARRAY['integer','integer','integer','float'])
    union all

    --basic functionality testing at 0c and converting to desired sets.
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_uom_id_from_abbreviation(-1,''°C'')),0)',
                        ARRAY[0::real], 'Convert with specified UOM (Celsius to Celsius) - Unit Test 1')
    union all
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_uom_id_from_abbreviation(-1,''°F'')),0)',
                        ARRAY[32::real], 'Convert with specified UOM (Celsius to Farenheit) - Unit Test 2')
    union all
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°F'')),(select converter.get_uom_id_from_abbreviation(-1,''°C'')),32)',
                        ARRAY[0::real], 'Convert with specified UOM (Farenheit to Celsius) - Unit Test 3')
    union all
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_uom_id_from_abbreviation(-1,''°Ra'')),0)',
                        ARRAY[491.67::real], 'Convert with specified UOM (Celsius to Rankine) - Unit Test 4')
    union all
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_uom_id_from_abbreviation(-1,''°K'')),0)',
                        ARRAY[273.15::real], 'Convert with specified UOM (Celsius to Kelvin) - Unit Test 5')
    union all
    select results_eq('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°K'')),(select converter.get_uom_id_from_abbreviation(-1,''°C'')),0)',
                        ARRAY[-273.15::real], 'Convert with specified UOM (Celsius to Kelvin) - Unit Test 6')
    union all
    select ok((select converter.convert_by_uom(-1,1,1,null) is null),'Confirm Null value conversion - Unit Test 7')
    union all
        -- test error states
    select throws_ok ('select converter.convert_by_uom(null,2,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 8')
    union all
    select throws_ok ('select converter.convert_by_uom(-1,null,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Source UOM ID cannot be null - Unit Test 9')
    union all
    select throws_ok ('select converter.convert_by_uom(-1,2,null,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Destination UOM ID cannot be null - Unit Test 10')
    union all
    select throws_ok ('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),-1,0)', 'CF008', (select error_description from converter.response where error_code = 'CF008')::text,
        'Out UOM ID does not exist - Unit Test 11')
    union all
    select throws_ok ('select converter.convert_by_uom(-1,-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),0)', 'CF005', (select error_description from converter.response where error_code = 'CF005')::text,
        'In UOM ID does not exist - Unit Test 12')
    union all
    select throws_ok ('select converter.convert_by_uom(-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')),(select converter.get_uom_id_from_abbreviation(-1,''m'')),0)', 'CF006', (select error_description from converter.response where error_code = 'CF006')::text,
        'In UOM ID does not exist - Unit Test 13')
$$ language sql;set search_path = "converter_tests";
create or replace function converter_tests.test_use_case_4_set_user_conversion_set(
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

create or replace function converter_tests.test_use_case_4_get_user_conversion_set_id(
) returns setof text as $$
    -- label testing
    select '# # # Testing Use Case 4 - Set users conversion set # # #'
    union all
    --verify required function has been created
    select has_function('converter', 'get_user_conversion_set_id', ARRAY['integer'])
    union all
    --verify function
    select ok((select converter.get_user_conversion_set_id(-1) = 1),'Confirm happy path - Unit Test 1a')
    union all
    -- test error states
    select throws_ok ('select converter.get_user_conversion_set_id(null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.set_user_conversion_set(-5)', 'CF002', (select error_description from converter.response where error_code = 'CF001')::text,
        'Conversion Set ID cannot be null - Unit Test 3')
$$ language sql;set search_path = "converter_tests";
create or replace function converter_tests.test_use_case_5_add_conversion_set(
) returns setof text as $$
    -- label testing
    select '# # # Testing Use Case 5 - Add Conversion Set # # #'
    union all
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
    -- label testing
    select '# # # Testing Use Case 5 - Clone Conversion Set # # #'
    union all
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

create or replace function converter_tests.test_use_case_5_get_conversion_set_id_from_name(
) returns setof text as $$
    -- label testing
    select '# # # Testing Use Case 5 - Clone Conversion Set # # #'
    union all
    --confirm function exists
    select has_function('converter', 'get_conversion_set_id_from_name', ARRAY['integer', 'text'])
    union all
    --test operation
    select isa_ok((select converter.get_conversion_set_id_from_name(-1, 'Metric')),
       'integer', 'Conversion set was successfully cloned - Unit Test 1')
    union all
    --test error states
    select throws_ok ('select converter.add_conversion_set(null,''Metric'')', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.add_conversion_set(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
        'Source Conversion Set Name cannot be null - Unit Test 3')
$$ language sql;set search_path = "converter_tests";
create or replace function converter_tests.test_use_case_6_update_default_conversion_set_category_uom(

) returns setof text as $$

-- verify functions have been created
    select has_function('converter', 'update_default_conversion_set_category_uom', ARRAY['integer', 'integer', 'integer'])
    union all
    select ok((select converter.update_default_conversion_set_category_uom(-1,converter.get_data_category_id_from_name(-1,'Air Temperature'), converter.get_uom_id_from_abbreviation(-1,'°F'))),'UOM updated OK - Unit Test 1')
    union all
    select results_eq('select uom_id from converter.category_to_conversion_set where conversion_set_id = (select conversion_set_id from converter.user_conversion_set where user_id = -1) and data_category_id = converter.get_data_category_id_from_name(-1,''Air Temperature'')',
        'select converter.get_uom_id_from_abbreviation(-1,''°F'')','Confirm update ran successfully - Unit Test 2')
    union all
   -- test error states
    select throws_ok ('select converter.update_default_conversion_set_category_uom(null,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_default_conversion_set_category_uom(2,null,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'Data Category cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_default_conversion_set_category_uom(2,2,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM ID cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.update_default_conversion_set_category_uom(2,-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')))', 'CF014', (select error_description from converter.response where error_code = 'CF014')::text,
    'Supplied Data Category ID does not exist - Unit Test 6')
    union all
    select throws_ok ('select converter.update_default_conversion_set_category_uom(2,(select converter.get_data_category_id_from_name(-1,''Air Temperature'')),-1)', 'CF009', (select error_description from converter.response where error_code = 'CF009')::text,
    'Supplied UOM ID does not exist - Unit Test 7')
    union all
    select throws_ok ('select converter.update_default_conversion_set_category_uom(-5,(select converter.get_data_category_id_from_name(-1,''Air Temperature'')),(select converter.get_uom_id_from_abbreviation(-1,''°C'')))', 'CF002', (select error_description from converter.response where error_code = 'CF002')::text,
    'User has no default conversion set - Unit Test 8')
$$ language sql;

set search_path = "converter_tests";
create or replace function converter_tests.test_use_case_6_update_target_conversion_set_category_uom(

) returns setof text as $$
    -- verify functions have been created
    --converter.update_target_conversion_set_category(in_user_id int, in_conversion_set_id int, in_data_category_id int, in_uom_id int)
    select has_function('converter', 'update_target_conversion_set_category', ARRAY['integer', 'integer', 'integer', 'integer'])
    union all
    select ok((select converter.update_target_conversion_set_category_uom(-1, converter.get_conversion_set_id_from_name(-1,'Metric'),converter.get_data_category_id_from_name(-1,'Air Temperature'), converter.get_uom_id_from_abbreviation(-1,'°F'))),'Category updated OK - Unit Test 1')
    union all
    select results_eq('select uom_id from converter.category_to_conversion_set where conversion_set_id = (converter.get_conversion_set_id_from_name(-1,''Metric'')) and data_category_id = converter.get_data_category_id_from_name(-1,''Air Temperature'')',
        'select converter.get_uom_id_from_abbreviation(-1,''°F'')','Confirm update ran successfully - Unit Test 2')
    union all
    -- test error states
    select throws_ok ('select converter.update_target_conversion_set_category(null,2,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_target_conversion_set_category(2,null,2,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'Conversion Set ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_target_conversion_set_category(2,2,null,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'Data Category cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.update_target_conversion_set_category(2,2,2,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001')::text,
    'UOM ID cannot be null - Unit Test 6')
    union all
    select throws_ok ('select converter.update_target_conversion_set_category(2,2,-1,(select converter.get_uom_id_from_abbreviation(-1,''°C'')))', 'CF014', (select error_description from converter.response where error_code = 'CF014')::text,
    'Supplied Data Category ID does not exist - Unit Test 7')
    union all
    select throws_ok ('select converter.update_target_conversion_set_category(2,2,(select converter.get_data_category_id_from_name(-1,''Air Temperature'')),-1)', 'CF009', (select error_description from converter.response where error_code = 'CF009')::text,
    'Supplied UOM ID does not exist - Unit Test 8')
$$ language sql;
set search_path = "converter_tests";
create or replace function  converter_tests.test_use_case_7_add_uom(
) returns setof text as $$
    --verify function has been created.
    select has_function('converter','add_uom',ARRAY['integer','integer','text','text','real','real','integer','integer','integer','real','real','boolean'])
    union all
    select isa_ok((select converter.add_uom(-1, 1, 'testcase1', 'tc1',24.67,33.2)),'integer', 'Correct return from add_uom function - base inputs - Unit Test 1')
    union all
    select isa_ok((select converter.get_uom_id_from_name(-1,'testcase1')), 'integer','UOM added successfully - Unit Test 2')
    union all
    select isa_ok((select converter.add_uom(-1, 1, 'testcase2', 'tc2',
        1,0,2, 1, 1, 0.00, 10.00, true ))
        ,'integer', 'Correct return from add_uom function - all inputs - Unit Test 3')
    union all
    select isa_ok((select converter.get_uom_id_from_name(-1,'testcase1')), 'integer','UOM added successfully - Unit Test 4')
    union all
    select ok((select converter.get_uom_rate_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1'))) = 24.67,'Confirmed rate added - Use Case 5')
    union all
    select ok((select converter.get_uom_constant_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1'))) = 33.2,'Confirmed rate added - Use Case 6')
    union all
    -- test error states
    select throws_ok ('select converter.add_uom(null,2,''a'',''b'',1,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 7')
    union all
    select throws_ok ('select converter.add_uom(-1,null,''a'',''b'',1,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type cannot be null - Unit Test 8')
    union all
    select throws_ok ('select converter.add_uom(-1,2,null,''b'',1,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Name cannot be null - Unit Test 8')
    union all
    select throws_ok ('select converter.add_uom(-1,2,''a'',null,1,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Abbreviation cannot be null - Unit Test 9')
    union all
    select throws_ok ('select converter.add_uom(-1,2,''a'',''bb'',null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Rate cannot be null - Unit Test 10')
    union all
    select throws_ok ('select converter.add_uom(-1,2,''a'',''bb'',1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM Constant cannot be null - Unit Test 11')
    union all
    select throws_ok ('select converter.add_uom(-1,-1,''a'',''b'',1,1)', 'CF015', (select error_description from converter.response where error_code = 'CF015'),
    'Data Type cannot be found - Unit Test 12')
    union all
    select throws_ok ('select converter.add_uom(-1,1,''testcase1'',''b'',1,1)', 'CF016', (select error_description from converter.response where error_code = 'CF016'),
    'UOM Already exists in this data type - Unit Test 13')
    union all
    select throws_ok ('select converter.add_uom(-1,2,''testcase1'',''b'',1,1)', 'CF017', (select error_description from converter.response where error_code = 'CF017'),
    'UOM Name Already exists - Unit Test 14')
    union all
    select throws_ok ('select converter.add_uom(-1,2,''a'',''tc1'',1,1)', 'CF017', (select error_description from converter.response where error_code = 'CF017'),
    'UOM Abbreviation Already exists - Unit Test 15')
$$ language sql;

CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_set_enabled_uom()
returns setof text as $$
    --prepare data
    select converter.add_uom(-1, 1, 'testcase1', 'tc1',1,0);
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
    select converter.add_uom(-1, 1, 'testcase1', 'tc1',1,0);
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
    select converter.add_uom(-1, 1, 'testcase1', 'tc1',1,0);
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
    select converter.add_uom(-1, 1, 'testcase1', 'tc1',1,0);
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
    select converter.add_uom(-1, 1, 'testcase1', 'tc1',1,0);
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
    select throws_ok ('select converter.update_uom_abbr(-1,-1,''a'')', 'CF009', (select error_description from converter.response where error_code = 'CF009'),
    'UOM ID cannot be found - Unit Test 5')
    union all
    select throws_ok ('select converter.update_uom_abbr(-1,2,''testcase2'')', 'CF017', (select error_description from converter.response where error_code = 'CF017'),
    'UOM Name already exists - Unit Test 6')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_precision()
returns setof text as $$
    --converter.update_uom_precision(in_user_id int, in_uom_id int, in_prec int)
    --prepare data
    select converter.add_uom(-1, 1, 'testcase1', 'tc1',1,0,1);
    select converter.add_uom(-1, 1, 'testcase2', 'tc2',1,0);

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
    select converter.add_uom(-1, 1, 'testcase1', 'tc1',1,0);
    select converter.add_uom(-1, 1, 'testcase2', 'tc2',1,0);
    select converter.add_uom(-1, 2, 'testcase3', 'tc3',1,0);

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
    select converter.add_uom(-1, 1, 'testcase1', 'tc1',1,0);
    select converter.add_uom(-1, 1, 'testcase2', 'tc2',1,0);
    select converter.add_uom(-1, 2, 'testcase3', 'tc3',1,0);

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
    select ok((select converter.add_uom(-1, 1, 'testcase1', 'tc1',1,0) = (select converter.get_uom_id_from_name(-1,'testcase1'))),'Confirmed correct ID returned from name - Unit Test 1')
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
    select ok((select converter.add_uom(-1, 1, 'testcase1', 'tc1',1,0) = (select converter.get_uom_id_from_abbreviation(-1,'tc1'))),'Confirmed correct ID returned from abbreviation - Unit Test 1')
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
    select converter.add_uom(-1, 1, 'testcase1', 'tc1',1,0);
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
    select converter.add_uom(-1, 1, 'testcase1', 'tc1',1,0);
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
    select converter.add_uom(-1, 3, 'testcase1', 'tc1',1,0);
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
    select converter.add_uom(-1, 3, 'testcase1', 'tc1',1,0);
    select converter.add_uom(-1, 3, 'testcase3', 'tc3',1,0);
    select converter.add_uom(-1, 3, 'testcase2', 'tc2',1,0,3,converter.get_uom_id_from_abbreviation(-1,'tc3'),converter.get_uom_id_from_abbreviation(-1,'tc1'),1000,100);
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
    select converter.add_uom(-1, 3, 'testcase1', 'tc1',1,0);
    select converter.add_uom(-1, 3, 'testcase3', 'tc3',1,0);
    select converter.add_uom(-1, 3, 'testcase2', 'tc2',1,0,3,converter.get_uom_id_from_abbreviation(-1,'tc3'),converter.get_uom_id_from_abbreviation(-1,'tc1'),1000,100);
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
    select converter.add_uom(-1, 3, 'testcase1', 'tc1',1,0);
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
    select converter.add_uom(-1, 3, 'testcase1', 'tc1',1,0);
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
    select converter.add_uom(-1, 3, 'testcase1', 'tc1',1,0,3);
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

CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_prec_from_id()
returns setof text as $$
    --converter.get_uom_prec_from_id(in_user_id int, in_uom_id int)
    --prepare data
    select converter.add_uom(-1, 3, 'testcase1', 'tc1',1,0,3);
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


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_rate_from_id()
returns setof text as $$
    --converter.get_uom_rate_from_id(in_user_id int, in_uom_id int)
    --prepare data
    select converter.add_uom(-1, 3, 'testcase1', 'tc1',589.78,0,3);
    --verify function has been created.
    select has_function('converter','get_uom_rate_from_id',ARRAY['integer','integer'])
    union all
    select ok(((select converter.get_uom_rate_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = 589.78),'Confirmed UOM rate correct - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_rate_from_id(null, 1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_rate_from_id(-1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_rate_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Confirmed UOM ID not found - Unit Test 5')
$$ language sql;

CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_get_uom_constant_from_id()
returns setof text as $$
    --converter.get_uom_rate_from_id(in_user_id int, in_uom_id int)
    --prepare data
    select converter.add_uom(-1, 3, 'testcase1', 'tc1',589.78,2986.04,3);
    --verify function has been created.
    select has_function('converter','get_uom_constant_from_id',ARRAY['integer','integer'])
    union all
    select ok(((select converter.get_uom_constant_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = 2986.04),'Confirmed UOM Constant correct - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_uom_constant_from_id(null, 1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_constant_from_id(-1, null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_constant_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Confirmed UOM ID not found - Unit Test 5')
$$ language sql;


CREATE OR REPLACE FUNCTION converter_tests.test_use_case_7_update_uom_rate_constant()
returns setof text as $$
    --converter.update_uom_rate_constant(in_user_id int, in_uom_id int, in_rate real, in_constant real)
    --prepare data
    select converter.add_uom(-1, 3, 'testcase1', 'tc1',589.78,2986.04,3);
    --verify function has been created.
    select has_function('converter','update_uom_rate_constant',ARRAY['integer','integer','real','real'])
    union all
    select ok(((select converter.get_uom_rate_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = 589.78::real),'Confirmed UOM rate correct - Unit Test 1a')
    union all
    select ok(((select converter.get_uom_constant_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = 2986.04::real),'Confirmed UOM Constant correct - Unit Test 1b')
    union all
    select ok((select converter.update_uom_rate_constant(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'),0.12345,12345.6)),'Update Rate and Constant successfully - Unit Test 1c')
    union all
    select ok(((select converter.get_uom_rate_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = 0.12345::real),'Confirmed UOM rate updated correctly - Unit Test 1d')
    union all
    select ok(((select converter.get_uom_constant_from_id(-1,converter.get_uom_id_from_abbreviation(-1,'tc1'))) = 12345.6::real),'Confirmed UOM Constant updated correctly - Unit Test 1e')
    union all
    -- test error states
    select throws_ok ('select converter.update_uom_rate_constant(null, 1,1,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_uom_constant_from_id(-1, null,1,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'UOM ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_uom_constant_from_id(-1, 1,null,2)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Rate cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.get_uom_constant_from_id(-1, 1,1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Constant cannot be null - Unit Test 6')
    union all
    select throws_ok ('select converter.get_uom_constant_from_id(-1, -1)', 'CF005', (select error_description from converter.response where error_code = 'CF005'),
    'Confirmed UOM ID not found - Unit Test 7')
    union all
    select throws_ok ('select converter.get_uom_constant_from_id(-1, -1)', 'CF009', (select error_description from converter.response where error_code = 'CF009'),
    'Confirmed UOM ID not found - Unit Test 7')
$$ language sql;set search_path = "converter_tests";

create or replace function  converter_tests.test_use_case_8_add_data_type(
) returns setof text as $$
--verify functions have been created.
    select has_function('converter','add_data_type',ARRAY['integer','text'])
    union all
    select isa_ok((select converter.add_data_type(-1, 'testcase')),'integer','Data Type added successfully - Unit Test 1')
    union all
    select results_eq('select count(*) from converter.data_type where name = ''testcase'' ',ARRAY[1 :: BIGINT],'Confrimed Data Type added successfully - Unit Test 2' )
    union all
    -- test error states
    select throws_ok ('select converter.add_data_type(null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.add_data_type(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.add_data_type(-1,''testcase'')', 'CF021', (select error_description from converter.response where error_code = 'CF021'),
    'Data Type already exists - Unit Test 5')
$$ language sql;


create or replace function  converter_tests.test_use_case_8_update_data_type(
) returns setof text as $$
    select converter.add_data_type(1, 'testcase');
    --verify functions have been created.
    select has_function('converter','update_data_type',ARRAY['integer','integer','text'])
    union all
    select throws_ok ('select converter.get_data_type_id_from_name(-1,''testcase2'')', 'CF022', (select error_description from converter.response where error_code = 'CF022'),
    'Confirm new name does not exist - Unit Test 1a')
    union all
    select ok((select converter.update_data_type(1, (select converter.get_data_type_id_from_name(-1,'testcase')),'testcase2')),'Data Type updated successfully - Unit Test 1b')
    union all
    select isa_ok((select converter.get_data_type_id_from_name(-1,'testcase2')),'integer','Confrimed Data Type update successfully - Unit Test 1c' )
    union all
    -- test error states
    select throws_ok ('select converter.update_data_type(null,1,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_data_type(-1,null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_data_type(-1,null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_data_type(-1,-1,''a'')', 'CF015', (select error_description from converter.response where error_code = 'CF015'),
    'Data Type does not exist - Unit Test 5')
    union all
    select throws_ok ('select converter.update_data_type(-1,1,''testcase2'')', 'CF021', (select error_description from converter.response where error_code = 'CF021'),
    'Data Type already exists - Unit Test 6')
$$ language sql;

create or replace function  converter_tests.test_use_case_8_set_enabled_data_type(
) returns setof text as $$
    select converter.add_data_type(1, 'testcase');
    --verify functions have been created.
    select has_function('converter','set_enabled_data_type',ARRAY['integer','integer','boolean'])
    union all
    select ok((select converter.get_data_type_status_from_id(-1,converter.get_data_type_id_from_name(-1,'testcase')) = true), 'Confirm type is active - Unit Test 1a')
    union all
    select ok((select converter.set_enabled_data_type(1, (select converter.get_data_type_id_from_name(-1,'testcase')),false)),'Data Type status updated to false - Unit Test 1b')
    union all
    select ok((select converter.get_data_type_status_from_id(-1,converter.get_data_type_id_from_name(-1,'testcase')) = false), 'Confirm type is inactive - Unit Test 1c')
    union all
    -- test error states
    select throws_ok ('select converter.set_enabled_data_type(null,1,true)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.set_enabled_data_type(-1,null,true)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.set_enabled_data_type(-1,1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type status cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_data_type(-1,-1,''a'')', 'CF015', (select error_description from converter.response where error_code = 'CF015'),
    'Data Type does not exist - Unit Test 5')
$$ language sql;

create or replace function  converter_tests.test_use_case_8_get_data_type_id_from_name(
) returns setof text as $$
    --verify functions have been created.
    select has_function('converter','get_data_type_id_from_name',ARRAY['integer','text'])
    union all
    select ok((select converter.add_data_type(1, 'testcase')) = (select converter.get_data_type_id_from_name(-1,'testcase')),'Confirm get ID function - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_data_type_id_from_name(null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.get_data_type_id_from_name(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_data_type_id_from_name(-1,''asdfasdfeasdfe'')', 'CF022', (select error_description from converter.response where error_code = 'CF022'),
    'Data Type name does not exist - Unit Test 3')
$$ language sql;

create or replace function  converter_tests.test_use_case_8_set_enabled_data_type(
) returns setof text as $$
    select converter.add_data_type(1, 'testcase');
    --verify functions have been created.
    select has_function('converter','get_data_type_status_from_id',ARRAY['integer','integer'])
    union all
    select ok((select converter.get_data_type_status_from_id(-1,converter.get_data_type_id_from_name(-1,'testcase')) = true), 'Confirm type is active - Unit Test 1a')
    union all
    select ok((select converter.set_enabled_data_type(1, (select converter.get_data_type_id_from_name(-1,'testcase')),false)),'Data Type status updated to false - Unit Test 1b')
    union all
    select ok((select converter.get_data_type_status_from_id(-1,converter.get_data_type_id_from_name(-1,'testcase')) = false), 'Confirm type is inactive - Unit Test 1c')
    union all
    -- test error states
    select throws_ok ('select converter.get_data_type_status_from_id(null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.get_data_type_status_from_id(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.set_enabled_data_type(-1,-1)', 'CF015', (select error_description from converter.response where error_code = 'CF015'),
    'Data Type id cannot be found - Unit Test 4')
$$ language sql;set search_path = "converter_tests";
create or replace function  converter_tests.test_use_case_9_add_data_category (
) returns setof text as $$
    --verify functions have been created.
    select has_function('converter','add_data_category',ARRAY['integer','text','integer'])
    union all
    select isa_ok((select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'Temperature'))),'integer','Data Category added successfully - Unit Test 1')
    union all
    select isa_ok((select converter.get_data_category_id_from_name(-1, 'testcase')),'integer','Confirmed Data Category exists - Unit Test 2')
    union all
    -- test error states
    select throws_ok ('select converter.add_data_category(null,''a'',1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.add_data_category(-1,null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category Name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.add_data_category(-1,''a'',null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type ID cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.add_data_category(-1,''testcase'',1)', 'CF023', (select error_description from converter.response where error_code = 'CF023'),
    'Data Category already exists - Unit Test 6')
    union all
    select throws_ok ('select converter.add_data_category(-1,''testcase'',-1)', 'CF023', (select error_description from converter.response where error_code = 'CF023'),
    'Data Category already exists - Unit Test 7')
$$ language sql;

create or replace function  converter_tests.test_use_case_9_update_data_category_name (
) returns setof text as $$
    --prepare data
    select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature'));
    --verify functions have been created.
    select has_function('converter','update_data_category_name',ARRAY['integer','integer','text'])
    union all
    select isa_ok((select converter.get_data_category_id_from_name(-1, 'testcase')),'integer','Confirmed Data Category exists - Unit Test 1a')
    union all
    select ok((select converter.update_data_category_name(-1, converter.get_data_category_id_from_name(-1, 'testcase'),'testcase2')),'Updated Data Category name - Unit Test 1b')
    union all
    select isa_ok((select converter.get_data_category_id_from_name(-1, 'testcase2')),'integer','Confirmed New Data Category Name exists - Unit Test 1c')
    union all
    select throws_ok ('select converter.get_data_category_id_from_name(-1,''testcase'')', 'CF025', (select error_description from converter.response where error_code = 'CF025'),
    'Confirm old name does not exist - Unit Test 1d')
    union all
    -- test error states
    select throws_ok ('select converter.update_data_category_name(null,1,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_data_category_name(-1,null,''a'')', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_data_category_name(-1,1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category Name cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.add_data_category(-1,-1,1)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
    union all
    select throws_ok ('select converter.add_data_category(-1,converter.get_data_category_id_from_name(-1, ''testcase2''),''testcase2'')', 'CF023', (select error_description from converter.response where error_code = 'CF023'),
    'Data Category name already exists - Unit Test 7')
$$ language sql;


create or replace function  converter_tests.test_use_case_9_update_data_category_data_type (
) returns setof text as $$
    --prepare data
    select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature'));
    --verify functions have been created.
    select has_function('converter','update_data_category_data_type',ARRAY['integer','integer','integer'])
    union all
    select ok((select converter.update_data_category_data_type(-1,converter.get_data_category_id_from_name(-1, 'testcase'),2)),'Data Category Data Type updated - Unit Test 1a')
    union all
    select ok((select converter.get_data_category_data_type_id_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase')) = 2),'Confirm Data Category Data Type updated - Unit Test 1b')
    union all
    -- test error states
    select throws_ok ('select converter.update_data_category_data_type(null,1,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_data_category_data_type(-1,null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_data_category_data_type(-1,1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Type ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.update_data_category_data_type(-1,-1,1)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
    union all
    select throws_ok ('select converter.update_data_category_data_type(-1,converter.get_data_category_id_from_name(-1, ''testcase''),-1)', 'CF015', (select error_description from converter.response where error_code = 'CF015'),
    'Data Type ID does not exist - Unit Test 7')
$$ language sql;


create or replace function  converter_tests.test_use_case_9_set_enabled_data_category (
) returns setof text as $$
    --prepare data
    select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature'));
    --verify functions have been created.
    select has_function('converter','set_enabled_data_category',ARRAY['integer','integer','boolean'])
    union all
    select ok((select converter.get_data_category_status_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase'))),'Confirmed Data Category active - Unit Test 1a')
    union all
    select ok((select converter.set_enabled_data_category(-1,converter.get_data_category_id_from_name(-1, 'testcase'),false)),'Data Category Data Disabled - Unit Test 1b')
    union all
    select ok((select converter.get_data_category_status_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase')) = false),'Confirmed Data Category disabled - Unit Test 1c')
    union all
    select ok((select converter.set_enabled_data_category(-1,converter.get_data_category_id_from_name(-1, 'testcase'),true)),'Data Category Data Enabled - Unit Test 2a')
    union all
    select ok((select converter.get_data_category_status_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase'))),'Confirmed Data Category enabled - Unit Test 2b')
    union all
    -- test error states
    select throws_ok ('select converter.set_enabled_data_category(null,1,true)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.set_enabled_data_category(-1,null,true)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.set_enabled_data_category(-1,1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category Status cannot be null - Unit Test 5')
    union all
    select throws_ok ('select converter.set_enabled_data_category(-1,-1,true)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
    union all
    select throws_ok ('select converter.set_enabled_data_category(-1,converter.get_data_category_id_from_name(-1, ''Air Temperature''),false)', 'CF024', (select error_description from converter.response where error_code = 'CF024'),
    'Data Type ID does not exist - Unit Test 7')
$$ language sql;

create or replace function  converter_tests.test_use_case_9_get_data_category_data_type_id_from_id (
) returns setof text as $$
    --prepare data
    select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature'));
    --verify functions have been created.
    select has_function('converter','get_data_category_data_type_id_from_id',ARRAY['integer','integer'])
    union all
    select ok((select converter.get_data_category_data_type_id_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase')) = converter.get_data_type_id_from_name(-1,'temperature')),'Confirm Data Type correct - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.update_data_category_data_type(null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.update_data_category_data_type(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.update_data_category_data_type(-1,-1)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
$$ language sql;

create or replace function  converter_tests.test_use_case_9_get_data_category_id_from_name (
) returns setof text as $$
    --verify functions have been created.
    select has_function('converter','get_data_category_id_from_name',ARRAY['integer','text'])
    union all
    select ok((select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature')) = converter.get_data_category_id_from_name(-1,'testcase')),'Confirm Data category id correct - Unit Test 1')
    union all
    -- test error states
    select throws_ok ('select converter.get_data_category_id_from_name(null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.get_data_category_id_from_name(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_data_category_id_from_name(-1,-1)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
$$ language sql;

create or replace function  converter_tests.test_use_case_9_is_data_category_dependency (
) returns setof text as $$
    --prepare data
    select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature'));
    --verify functions have been created.
    select has_function('converter','is_data_category_dependency',ARRAY['integer','integer'])
    union all
    select ok((select converter.is_data_category_dependency(-1,converter.get_data_category_id_from_name(-1, 'testcase')) = false),'Confirmed Data Category has no dependency - Unit Test 1')
    union all
    select ok((select converter.is_data_category_dependency(-1,converter.get_data_category_id_from_name(-1, 'Air Temperature'))),'Confirmed Data Category has dependency - Unit Test 2')
    union all
    -- test error states
    select throws_ok ('select converter.is_data_category_dependency(null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 2')
    union all
    select throws_ok ('select converter.is_data_category_dependency(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.is_data_category_dependency(-1,-1)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
$$ language sql;

create or replace function  converter_tests.test_use_case_9_get_data_category_status_from_id (
) returns setof text as $$
    --prepare data
    select converter.add_data_category(-1, 'testcase', converter.get_data_type_id_from_name(-1,'temperature'));
    --verify functions have been created.
    select has_function('converter','get_data_category_status_from_id',ARRAY['integer','integer'])
    union all
    select ok((select converter.get_data_category_status_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase'))),'Confirmed Data Category active - Unit Test 1a')
    union all
    select ok((select converter.set_enabled_data_category(-1,converter.get_data_category_id_from_name(-1, 'testcase'),false)),'Data Category Data Disabled - Unit Test 1b')
    union all
    select ok((select converter.get_data_category_status_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase')) = false),'Confirmed Data Category disabled - Unit Test 1c')
    union all
    select ok((select converter.set_enabled_data_category(-1,converter.get_data_category_id_from_name(-1, 'testcase'),true)),'Data Category Data Enabled - Unit Test 2a')
    union all
    select ok((select converter.get_data_category_status_from_id(-1,converter.get_data_category_id_from_name(-1, 'testcase'))),'Confirmed Data Category enabled - Unit Test 2b')
    union all
    -- test error states
    select throws_ok ('select converter.get_data_category_status_from_id(null,1)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'User ID cannot be null - Unit Test 3')
    union all
    select throws_ok ('select converter.get_data_category_status_from_id(-1,null)', 'CF001', (select error_description from converter.response where error_code = 'CF001'),
    'Data Category ID cannot be null - Unit Test 4')
    union all
    select throws_ok ('select converter.get_data_category_status_from_id(-1,-1)', 'CF014', (select error_description from converter.response where error_code = 'CF014'),
    'Data Category does not exist - Unit Test 6')
$$ language sql;
