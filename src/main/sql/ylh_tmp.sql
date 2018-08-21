select * from recordcount where config_id in(select config_id from recordcount group by config_id,member_no having count(config_id)>1) order by config_id;

delete from recordcount where count_id in
(
select a.count_id from
(select max(count_id) count_id from recordcount group by config_id,member_no having count(config_id)>1 ) a );

select * from information_schema.columns where table_name='wpoint_table_201804';


insert into member_v3(member_no,user_name,real_name,phone,id_card,parent_no)
select uid,member_id,member_name,member_tel1,id_card,  rcm_uid from mvm_member_table;

call buildTree_v3();