
create or replace function  startup_schema(
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
    END $$ language plpgsql;