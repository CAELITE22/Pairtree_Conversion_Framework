create or replace function converter.set_user_conversion_set(
    in_user_id int,
    in_conversion_set_id int
)

returns bool
language plpgsql
as
$$
-- declare
BEGIN
    if (in_conversion_set_id is null or in_user_id is null) then
        RAISE EXCEPTION SQLSTATE 'CF001' USING MESSAGE = (select error_description from converter.response where error_code = 'CF001');
    end if;
    
    if ((select count(*) from converter.conversion_set where id = in_conversion_set_id) = 0) then
        RAISE EXCEPTION SQLSTATE 'CF007' USING MESSAGE = (select error_description from converter.response where error_code = 'CF007');
    end if;
    
    if (in_user_id not in (select user_id from converter.user_conversion_set)) then
        insert into converter.user_conversion_set (user_id, conversion_set_id, created, updated, updated_by, created_by, active)
            values (in_user_id, in_conversion_set_id,now(),now(),in_user_id,in_user_id,true);
    else
        update converter.user_conversion_set
        set
            conversion_set_id = in_conversion_set_id,
            updated_by = in_user_id,
            updated = now()
        where user_id = in_user_id;
    end if;

    if (select count(*) from converter.user_conversion_set where user_id = in_user_id and conversion_set_id = in_conversion_set_id) = 0 then
        RAISE EXCEPTION SQLSTATE 'CF000' USING MESSAGE = (select error_description from converter.response where error_code = 'CF000');
    end if;

    return true;
end
$$
