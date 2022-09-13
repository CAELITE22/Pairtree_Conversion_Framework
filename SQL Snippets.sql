begin;

select plan(0);
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
    select converter.get_uom_id_from_name(-1,'testcase1')::text;
    select converter.get_uom_rate_from_id(-1,(select converter.get_uom_id_from_name(-1,'testcase1')));

--     select ok((select converter.get_uom_rate_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1'))) = 24.67,'Confirmed rate added - Use Case 5')
--     union all
--     select ok((select converter.get_uom_constant_from_id(-1,converter.get_uom_id_from_name(-1,'testcase1'))) = 33.2,'Confirmed rate added - Use Case 6')
;
select * from finish();
rollback ;