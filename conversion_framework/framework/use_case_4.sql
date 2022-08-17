-- This function sets the default conversion set.
-- The default conversion ID is always -1
-- The default conversion is a copy of the reference conversion set to prevent inadvertent modification of the default.


create or replace function  converter.set_default_conversion_set(
    in_user_id int,
    in_cs_id int
)

returns text
language plpgsql
as
$$
declare
    cs_name text;

BEGIN
    if (in_cs_id is null or in_user_id is null) then
        return concat('conversion set or user ID can''t be NULL');
    end if;
    if (in_cs_id not in (select id from converter.conversion_set)) then
        return concat('conversion_set_id does not exist');
    end if;

    cs_name = (select name from converter.conversion_set where id = in_cs_id) :: text;

    delete from converter.conversion_set where id = -1;
    insert into converter.conversion_set (id, name, owner_user_id, created, updated, created_by, updated_by, active)
    select -1, concat(name,'*')::text, -1, created, now(), created_by, in_user_id, active
    from converter.conversion_set
    where id = in_cs_id;

    if (select count(*) from converter.conversion_set where name = concat(cs_name,'*')::text) = 1 then
        return concat('default conversion set is now ',cs_name);
    end if;
    return concat('There was an error setting default conversion set');
end;
$$
