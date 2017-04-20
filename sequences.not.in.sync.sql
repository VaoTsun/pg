do --check seq not in sync
$$
declare
 _r record;
 _i bigint;
 _m bigint;
begin
  for _r in (
    SELECT relname,nspname,d.refobjid::regclass, a.attname, refobjid
    FROM   pg_depend    d
    JOIN   pg_attribute a ON a.attrelid = d.refobjid AND a.attnum = d.refobjsubid
    JOIN pg_class r on r.oid = objid
    JOIN pg_namespace n on n.oid = relnamespace
    WHERE  d.refobjsubid > 0 and  relkind = 'S'
   ) loop
    execute format('select last_value from %I.%I',_r.nspname,_r.relname) into _i;
    execute format('select max(%I) from %s',_r.attname,_r.refobjid) into _m;
    if coalesce(_m,0) > _i then
      raise info '%',coalesce(_r.nspname,'.',_r.relname' ',_i,' ',_m);
      execute format('alter sequence %I.%I restart with %s',_r.nspname,_r.relname,_m+1);
    end if;
  end loop;

end;
$$
;
