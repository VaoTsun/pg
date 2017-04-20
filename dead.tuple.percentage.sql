SELECT pg_stat_get_live_tuples(c.oid) AS n_live_tup
     , pg_stat_get_dead_tuples(c.oid) AS n_dead_tup
     , c.relname
     , (pg_stat_get_dead_tuples(c.oid) * 100 ) / pg_stat_get_live_tuples(c.oid)  "%"
FROM   pg_class c
where true
  and pg_stat_get_live_tuples(c.oid) > 0 
  and (pg_stat_get_dead_tuples(c.oid) * 100 ) / pg_stat_get_live_tuples(c.oid) > 0
  and relname like 'so%'
order by 4 desc
;
