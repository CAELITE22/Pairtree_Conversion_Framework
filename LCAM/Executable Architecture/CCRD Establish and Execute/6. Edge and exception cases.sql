select 'unknown user' as "Case", converter.ccrd(240,'¬∞C',
    'Soil Temperature',42) as Result
Union All
select 'unknown uom', converter.ccrd(9,
    '¬∞P','Air Temperature',42)
Union All
select 'unknown category', converter.ccrd(9,
    '¬∞C','David Temperature',42)
Union All
select 'null value', converter.ccrd(15,
    '¬∞C','Air Temperature',null)