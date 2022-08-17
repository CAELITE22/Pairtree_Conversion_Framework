create or replace function  converter.set_user_conversion_set(
    in_user_id int,
    in_cs_id int
)

returns text
language plpgsql
as
$$
declare
    conversion_set_name text;

BEGIN
    conversion_set_name = (select name from converter.conversion_set where id = in_cs_id)::text;
    if (in_cs_id is null or in_user_id is null) then
        return concat('conversion set or user ID can''t be NULL');
    end if;
    
    if (in_cs_id not in (select id from converter.conversion_set)) then
        return concat('conversion_set_id does not exist');
    end if;
    
    if (in_user_id not in (select user_id from converter.user_conversion_set)) then
        insert into converter.user_conversion_set (user_id, conversion_set_id, created, updated, updated_by, created_by, active)
            values (in_user_id, in_cs_id,now(),now(),in_user_id,in_user_id,active);
    end if;

    if (in_user_id in (select user_id from converter.user_conversion_set)) then
        update converter.user_conversion_set
        set
            conversion_set_id = in_cs_id,
            updated_by = in_user_id,
            updated = now()
        where user_id = in_user_id;
    end if;

    if (select count(*) from converter.user_conversion_set where user_id = in_user_id and conversion_set_id = in_cs_id) = 1 then
        return concat('user conversion set is now set to ', conversion_set_name );
    end if;
    
    return concat('There was an error setting the conversion set');
end
$$
