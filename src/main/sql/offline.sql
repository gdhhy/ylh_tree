drop table order_offline_v4;

create table order_offline_v4(
  offline_id    int           auto_increment primary key,
  ordersn varchar(30),
  buyer_id varchar(35),
  seller_id varchar(35),
  memo varchar(100),
  trade_time int,
  money decimal(20,2),
  ver varchar(10)
);


insert into order_offline_v4
    (ordersn,buyer_id,seller_id,memo,trade_time,money,ver)
select ordersn,m_id,sup_id,memo,register_date,money/100.0,'v4' from order_table_offline_3 where money >=100*10000;

update order_offline_v4 A join member_table B on A.m_uid=B.uid set A.buyer_id=B.member_id;
update order_offline_v4 A join member_table B on A.supplier_id=B.uid set A.seller_id=B.member_id;

drop table order_offline_v3;

create table order_offline_v3(
  offline_id    int           auto_increment primary key,
  ordersn varchar(30),
  buyer_id varchar(35),
  seller_id varchar(35),
  memo varchar(100),
  trade_time int,
  money decimal(20,2),
  ver varchar(10)
);


insert into order_offline_v3
    (ordersn,buyer_id,seller_id,memo,trade_time,money,ver)
select ordersn,m_id,sup_id,'',register_date,goods_amount,'v3' from mvm_order_offline_new where goods_amount >=10000;

insert into order_offline_v4
    (ordersn,buyer_id,seller_id,memo,trade_time,money,ver)
select ordersn,buyer_id,seller_id,memo,trade_time,money,ver from  order_offline_v3;
select count(*) from  order_offline_v4 where money>=1000*10000;
select count(*) from  order_offline_v4 where money<1000*10000 and money >=100*10000;
select count(*) from  order_offline_v4 where money<100*10000 and money >=10*10000;
select count(*) from  order_offline_v4 where money<10*10000;

alter table order_offline
  add index ix_offline_money (money);

insert into order_offline (ordersn,buyer_id,seller_id,memo,trade_time,money,ver)
select ordersn,buyer_id,seller_id,memo,trade_time,money,ver from order_offline_old order by money desc