--setup tests
BEGIN;
select plan(9);

--this test should fail as verification
select ok(false);

--basic functionality testing at 0c and converting to desired sets.
select results_eq('select converter.ccrd(1,''¬∞C'',''Air Temperature'',0)',ARRAY[0::real]);
select results_eq('select converter.ccrd(1,''¬∞C'',''Soil Temperature'',0)',ARRAY[0::real]);
select results_eq('select converter.ccrd(9,''¬∞C'',''Air Temperature'',0)',ARRAY[32::real]);
select results_eq('select converter.ccrd(9,''¬∞C'',''Soil Temperature'',0)',ARRAY[32::real]);
select results_eq('select converter.ccrd(15,''¬∞C'',''Air Temperature'',0)',ARRAY[273.15::real]);
select results_eq('select converter.ccrd(15,''¬∞C'',''Soil Temperature'',0)',ARRAY[491.67::real]);

--Test on a randomized data set converting to the metric conversion set.

--Build Randomized data set using hardcoded converted value for testing.
drop table if exists pairtreeTestData;
create table pairtreeTestData (value real, metric text, uom text, resultsc real, resultsf real);

DO $$
declare
    currentrecord INT = 1;
    adjustment INT;
    randomValue real;
begin
    WHILE currentrecord <= 1000 loop
    adjustment = mod((floor(random()*39+1)::int),4);
    randomValue = floor(random()*70000)/1000-20;
    insert into pairtreeTestData (value, metric, uom,resultsc,resultsf) values (randomValue,
      case when mod((floor(random()*10)::int),2)= 0 then'Air Temperature' else 'Soil Temperature' end,
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
END $$;

--test randomized data.
select results_eq('select converter.ccrd(1,pairtreeTestData.uom,pairtreeTestData.metric,pairtreeTestData.value) from pairtreeTestData',
    'select resultsc from pairtreeTestData');

select results_eq('select converter.ccrd(9,pairtreeTestData.uom,pairtreeTestData.metric,pairtreeTestData.value) from pairtreeTestData',
    'select resultsf from pairtreeTestData');

select finish();
rollback;
