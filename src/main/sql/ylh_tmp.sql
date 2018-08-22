select * from recordcount where config_id in(select config_id from recordcount group by config_id,member_no having count(config_id)>1) order by config_id;

delete from recordcount where count_id in
(
select a.count_id from
(select max(count_id) count_id from recordcount group by config_id,member_no having count(config_id)>1 ) a );

select * from information_schema.columns where table_name='wpoint_table_201804';


insert into member_v3(member_no,user_name,real_name,phone,id_card,parent_no)
select uid,member_id,member_name,member_tel1,id_card,  rcm_uid from mvm_member_table;

call buildTree_v3();


insert into member_v4 (member_no,user_name,real_name,phone,id_card,member_info,parent_no,cur_level,child_depth,direct_count,child_total)

select `会员uid`,`会员id`,`会员姓名`,`手机号码`,`证件号码`,
CONCAT('{"基本信息":{"推荐人id":"',`推荐人id`,'","电子邮箱":"',`电子邮箱`,'","QQ":"',`QQ`,'","性别":"',`性别`,
'","注册时间":"',`注册时间`,
'"},',
'"账户":{',
'"白积分账户余额":',`白积分账户余额`,
',"红积分账户余额":',`红积分账户余额`,
',"库存积分账户余额":',`库存积分账户余额`,
',"创业账户余额":',`创业账户余额`,
',"预付款账户余额":',`预付款账户余额`,
',"交易账户余额":',`交易账户余额`,
',"服务账户余额":',`服务账户余额`,
'},',
'"提现":{',
'"提现金额":',`提现金额`,
',"实际提现金额":',`实际提现金额`,
',"提现人姓名":"',ifnull(`提现人姓名`,''),
'","提现银行账号":"',ifnull(`提现银行账号`,''),
'","提现银行地址":"',ifnull(`提现银行地址`,''),
'"},',
'"地址":{',
'"省":"',`省`,
'","市":"',`市`,
'","区县":"',`区县`,
'","街道":"',`街道`,
'","村":"',`村`,
'","地址":"',`地址`,'"}',
'}') json,
`推荐人uid`,`所在层级`,`下线层数`,`直接下级人数`,`所有下级人数`
 from tt6;



update tt6 set  `地址` ='玑东路华英名都D1-D3幢市场1卡' where `会员uid`='1502251156_2886872691_1mp2';
update tt6 set  `地址` ='>alert()' where `会员uid`='0000000000_0028932674_0000';
update tt6 set  `地址` ='黑龙江省五大连池市双泉乡青石村01组115号' where `会员uid`='1519524172_2886872656_t6ki';
update tt6 set `提现人姓名`=REPLACE(`提现人姓名`,'	','')  --66 line
update tt6 set `qq`=REPLACE(`qq`,'\\','') ; -- 1

update tt6 set `地址`= REPLACE(REPLACE(地址, CHAR(10), ''), CHAR(13),''); --75
update tt6 set `qq`=REPLACE(`qq`,'	','')  ; --4
update tt6 set `提现人姓名`= REPLACE(REPLACE(提现人姓名, CHAR(10), ''), CHAR(13),''); -- 2
update tt6 set  `地址`=REPLACE(`地址`,'','') ;--63
update tt6 set  `地址`=REPLACE(`地址`,'	','');-- 32
update  tt6 set `地址`='乌鲁木齐市水磨沟区南湖东路北一巷1号5号楼3单元401室' where `会员uid`= '0000000000_0001069511_0000';

update tt6 set  `提现银行账号`=REPLACE(`提现银行账号`,'	','');-- 4