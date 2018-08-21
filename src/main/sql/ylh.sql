create table table_config (
  config_id    int primary key auto_increment,
  table_name   varchar(100),
  version      varchar(10), -- v1 v2 v3 v4
  data_type    varchar(20),
  /*
白积分、红积分
  交易账户		 	服务账户		 	创业账户		 	预付款账户
*/
  var_name     varchar(20),
  query_method varchar(20),
  month        varchar(6)
);
create index index_tc_tn
  on table_config (table_name);

create table recordcount (
  count_id     int primary key auto_increment,
  config_id    int references table_config,
  member_no    varchar(100),
  record_count int,
  query_time   int, -- 毫秒
  create_time  timestamp       default now()
);
CREATE INDEX INDEX_rc_member_no
  on recordcount (member_no);
CREATE UNIQUE INDEX index_config_member
  ON recordcount (config_id, member_no);

create table column_config (
  colID            int primary key auto_increment,
  talbe_name       varchar(100),
  col_name         varchar(100),
  chiness          varchar(100),
  tip              varchar(100),
  query_param_name varchar(100),
  order_id         int

)

  child_total