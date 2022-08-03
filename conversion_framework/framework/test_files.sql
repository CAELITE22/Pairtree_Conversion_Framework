select converter.add_uom(
    1,
    1,
    'kilometers',
    'km',
    '1',
    2,
    0,
    100000,
    0.001,
    true
           );

select converter.delete_uom(
    5
           );

select * FROM converter.uom;