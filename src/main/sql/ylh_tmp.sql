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

update  tt6 set `地址`='乌鲁木齐市水磨沟区南湖东路北一巷1号5号楼3单元401室' where `会员uid`= '0000000000_0001069511_0000';



update tt6 set `qq`=REPLACE(`qq`,'\\','') ; -- 1
update tt6 set `qq`=REPLACE(`qq`,'	','')  ; -- 4
update tt6 set `qq`= REPLACE(REPLACE(`qq`, CHAR(10), ''), CHAR(13),'');  -- 1

update tt6 set 地址=REPLACE(地址,'\\',''); -- 21 twice
update tt6 set  `地址`=REPLACE(`地址`,'	','');-- 32
update tt6 set  `地址`=REPLACE(`地址`,'','') ;-- 63
update tt6 set `地址`= REPLACE(REPLACE(地址, CHAR(10), ''), CHAR(13),''); -- 75

update tt6 set `提现人姓名`=REPLACE(`提现人姓名`,'	','');  -- 66 line
update tt6 set `提现人姓名`=REPLACE(`提现人姓名`,'','');  -- 66 line
update tt6 set `提现人姓名`= REPLACE(REPLACE(提现人姓名, CHAR(10), ''), CHAR(13),''); -- 2


update tt6 set  `提现银行账号`=REPLACE(`提现银行账号`,'	','');-- 4
update tt6 set `提现银行账号`=REPLACE(`提现银行账号`,'','');--1

update tt6 set  `提现银行地址`= REPLACE(REPLACE(提现银行地址, CHAR(10), ''), CHAR(13),'');

select A.*,B.w_point `w_point(sys_sta_per_day)`,B.w_point_out `w_point_out(sys_sta_per_day)`  from
(select cur_day,sum(case when point_add>0 then point_add else 0 end) `point_add(w_point_table)`,
sum(case when point_add<0 then point_add else 0 end)  `point_add_out(w_point_table)`
from wpoint_table_201805 where cur_day>='20180503' and cur_day<'20180508' group by cur_day) A
left join
(SELECT from_unixtime(day_stamp+60*60*24,'%Y%m%d') daystamp,w_point ,w_point_out
FROM `sys_sta_per_day` where day_stamp>=1525363200  and day_stamp<1525708800  order by day_stamp) B
on A.cur_day=B.daystamp

--v4
insert into member_tree(member_no,user_name,real_name,parent_no)
select uid,member_id,member_name,  rcm_uid from  ylhdata.member_table;
call buildTree_tree();

update member_tree A ,ylhdata.member_base_file B set   A.id_card =B.id_card,A.phone=B.mobile where A.member_no=B.uid  and A.id_card is null;

update withdrow_account set m_name=REPLACE(m_name,'	','');  -- 66 line
update withdrow_account set m_name=REPLACE(m_name,'','');  -- 66 line
update withdrow_account set m_name= REPLACE(REPLACE(m_name, CHAR(10), ''), CHAR(13),''); -- 2


update withdrow_account set  account=REPLACE(account,'	','');-- 4
update withdrow_account set account=REPLACE(account,'','');-- 1

SET GLOBAL group_concat_max_len=8191;
update member_tree A,(
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
ifnull(concat('"提现":',W.withdrow,','),''),
'"地址":{',
'"省":"',`省`,
'","市":"',`市`,
'","区县":"',`区县`,
'","街道":"',`街道`,
'","村":"',`村`,
'","地址":"',`地址`,'"}',
'}') json,
`推荐人uid`,`所在层级`,`下线层数`,`直接下级人数`,`所有下级人数`
 from tt6 A  left join (select m_id,concat('[',GROUP_CONCAT('{','"账号":"',ifnull(account,''),'"',
',"开户姓名":"',m_name,'"',
',"银行":"',bank,'"',
',"申请金额":',money,
',"实际金额":',money_real,
',"笔数":',times,
'}'),']') withdrow from withdrow_account
group by m_id ) W on A.`会员id`= W.m_id) B set A.member_info=B.json where A.member_no=B.`会员uid`;


update   member_tree A,(
select B.member_name,A.uid,
CONCAT('{"基本信息":{"推荐人id":"',B.rcm_uid,'","电子邮箱":"',A.email,'","QQ":"',A.qq,'","性别":"',
case A.sex when 1 then '男'  when 2 then '女' else '不明' end ,
'","注册时间":"',FROM_UNIXTIME(B.register_date),
'"},',
'"账户":{',
'"白积分账户余额":',C.w_point,
',"红积分账户余额":',C.r_point,
',"库存积分账户余额":',C.point,
',"创业账户余额":',C.money_trade,
',"预付款账户余额":',C.money_wallet,
',"交易账户余额":',C.money_business,
',"服务账户余额":',C.money_service,
'},',
'"提现":',ifnull(W.withdrow,''),
'"地址":{',
'"省":"',A.province,
'","市":"',A.city,
'","区县":"',A.county,
'","街道":"',A.street,
'","村":"',A.village,
'","地址":"',A.address,'"}',
'}') json
 from ylhdata.member_base_file A
 left join ylhdata.member_table B  on A.uid=B.uid
 left join ylhdata.member_account C  on A.uid=B.uid
 left join (select m_id,concat('[',GROUP_CONCAT('{','"账号":"',ifnull(account,''),'"',
',"开户姓名":"',m_name,'"',
',"银行":"',bank,'"',
',"申请金额":',money,
',"实际金额":',money_real,
',"笔数":',times,
'}'),']') withdrow from withdrow_account
group by m_id ) W on B.member_id= W.m_id) B set A.member_info=B.json where A.member_no=B.uid and A.member_info is null; --- 考虑到很多字段含json的非法字符，不用