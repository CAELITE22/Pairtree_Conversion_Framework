--Setup tests
BEGIN;
select plan(28)
union all

--this test should fail as verification
select ok(false)
union all

--verifies the schema has been created correctly by script
select has_schema('converter')
union all

--Verify tables are created and are only the required tables
select has_table('converter'::name,'data_type'::name)
union all
select has_table('converter'::name,'uom'::name)
union all
select has_table('converter'::name,'default_units'::name)
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
select tables_are('converter'::name, ARRAY['data_type','uom','default_units','data_category',
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
select columns_are('converter','default_units',ARRAY['id','data_type_id','default_uom_id',
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
select columns_are('converter','response',ARRAY['id','description'])
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
    'created','updated','created_by','updated_by','active'])
union all

--verify required function has been created
select has_function('converter','ccrd',ARRAY['integer','text','text','float'])
union all

--Close out tests
select * from finish();

rollback;
