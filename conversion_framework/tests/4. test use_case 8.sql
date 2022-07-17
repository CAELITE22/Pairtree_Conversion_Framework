create or replace function  test_usecase_8(
) returns setof text as $$
    select has_function('converter','add_data_type',ARRAY['integer','text'])
    union all
    select has_function('converter','update_data_type',ARRAY['integer','text','text'])
    union all
    select has_function('converter','enable_data_type',ARRAY['integer','text','boolean']);
    $$ language sql;