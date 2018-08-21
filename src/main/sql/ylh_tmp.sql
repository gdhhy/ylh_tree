select * from recordcount where config_id in(select config_id from recordcount group by config_id,member_no having count(config_id)>1) order by config_id;

delete from recordcount where count_id in
(
select a.count_id from
(select max(count_id) count_id from recordcount group by config_id,member_no having count(config_id)>1 ) a );

select * from information_schema.columns where table_name='wpoint_table_201804';