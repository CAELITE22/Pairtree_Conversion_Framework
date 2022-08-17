set search_path = "converter_tests";

create or replace function converter_tests.test_usecase_5(
) returns setof text as $$
-- check if all functions exist
    select has_function('converter', 'add_conversion_set', ARRAY['integer', 'text'])
    union all
    select has_function('converter', 'clone_conversion_set', ARRAY['integer', 'text', 'text'])
    union all
    select has_function('converter', 'get_conversion_set_id_from_name', ARRAY['integer', 'text'])
    union all
-- test add_conversion_set
    select results_eq('select converter.add_conversion_set(1, ''metric'')', 'select ''Conversion set: "metric" was added successfully.''', 'add_conversion_set success')
    union all
    select results_eq('select count(*) from converter.conversion_set where name=''metric'' ', ARRAY[1 :: BIGINT], 'conversion set added succesfully')
    union all
    select results_eq('select converter.add_conversion_set(NULL, ''metric'')', 'select ''Error! Cannot input <NULL> values.''', 'does not accept null values')
    union all
    select results_eq('select count(*) from converter.conversion_set where id=NULL ', ARRAY[0 :: BIGINT], 'NULL value not added')
    union all
    select results_eq('select converter.add_conversion_set(1, ''metric'')', 'select ''Error! The conversion set: "metric" already exists.''', 'does not allow entering duplicate conversion sets')
    union all
    select results_eq('select count(*) from converter.conversion_set where name=''metric'' ', ARRAY[1 :: BIGINT], 'Duplicate name not added')
    union all

    -- test get_conversion_set_id_from_name
    -- start by creating a new conversion set - imperial, metric was created in the add conversion set tests
    select results_eq('select converter.add_conversion_set(1, ''imperial'')', 'select ''Conversion set: "imperial" was added successfully.''', 'add_conversion_set success')
    union all
    select results_eq('select converter.get_conversion_set_id_from_name(1, ''imperial'')', 'select id from converter.conversion_set where name = ''imperial''', 'correctly returns id by name')
    union all
    select results_eq('select converter.get_conversion_set_id_from_name(1, ''chicken_tenders'')', ARRAY[-1], 'returns -1 if name doesnt exist in conversion_set')
    union all
    -- test clone conversion set
    select results_eq('select converter.clone_conversion_set(1, ''Metric'', ''Cloned_Test'')', 'select ''Conversion set: "Cloned_Test" was added successfully.''', 'clone conversion set works correctly')
    union all
    select results_eq('select count(*) from converter.category_to_conversion_set WHERE conversion_set_id = converter.get_conversion_set_id_from_name(1, ''Cloned_Test'')', 'select count(*) from converter.category_to_conversion_set WHERE conversion_set_id = converter.get_conversion_set_id_from_name(1, ''Metric'')', 'clones successfully' )
    union all
    select results_eq('select converter.clone_conversion_set(1, ''Metric'', NULL)','select ''Error! Cannot input <NULL> values.''','does not accept null values''')
    union all
    select results_eq('select count(*) from converter.conversion_set WHERE name=NULL',ARRAY[0 :: BIGINT], 'Null value not added to DB')
    union all
    select results_eq('select converter.clone_conversion_set(1, ''Metric'', ''Cloned_Test'')', 'select ''Error! The conversion set: "Cloned_Test" already exists.''', 'Does not allow cloning to sets that already exist')
    union all
    select results_eq('select converter.clone_conversion_set(1, ''Set_That_Doesnt_Exist'', ''New_Cloned_Test'' )', 'select ''Error! The source conversion set: "Set_That_Doesnt_Exist" does not exist.''', 'does not allow cloning from a source conversion set that does not exist')

$$ language sql;