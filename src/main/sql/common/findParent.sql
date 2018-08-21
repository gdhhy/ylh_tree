CREATE DEFINER =``@`` PROCEDURE `findParent`(in p_user_name varchar(100), in p_maxlevel int)
  BEGIN
    -- 递归深度
    set @@max_sp_recursion_depth = 1000;

    drop table if exists tmp_table;
    CREATE TEMPORARY TABLE tmp_table (
      parent_no   VARCHAR(26),
      member_no   varchar(26),
      user_name   varchar(100),
      parent_name varchar(100),
      real_name   varchar(100),
      id_card     varchar(100),
      phone       varchar(100),
      level       int
    );
    delete from tmp_table;
    select A.user_name into @parent_name from member A
                                                left join member B on B.parent_no = A.member_no where B.user_name = p_user_name;

    insert into tmp_table(parent_no, member_no, user_name, parent_name, real_name, id_card, phone, level) select parent_no, member_no, user_name, @parent_name, real_name, id_card, phone, level from member where user_name = p_user_name;

    select parent_no into @member_no from member where user_name = p_user_name;
    if @member_no is not null and exists(select * from tmp_table where level > 1)  then
      call recurParent(@member_no, p_maxlevel);
    end if;

    select level ''所在层级 '', member_no ''用户ID '', user_name ''用户名 '', parent_name ''推荐人 '', id_card ''身份证号 '', phone ''电话 '' from tmp_table order by level desc;

    --  select * from tmp_table;

  END