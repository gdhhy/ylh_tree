CREATE DEFINER=``@`` PROCEDURE `deleteNoDataTable`()
  BEGIN
    -- 创建接收游标数据的变量
    declare v_table_name varchar(26);

    -- 创建结束标志变量
    declare done int default false;
    declare cur cursor for select TABLE_NAME from information_schema.tables where table_schema = 'beidou' and table_type = 'base table';

    -- 指定游标循环结束时的返回值
    declare continue HANDLER for not found set done = true;

    -- 打开游标
    open cur;
    -- 开始循环游标里的数据
    read_loop: loop
      -- 根据游标当前指向的一条数据
      fetch cur
      into v_table_name;
      -- 判断游标的循环是否结束
      if done
      then
        leave read_loop;
      -- 跳出游标循环
      end if;
      set @v_sql = concat('select count(*) into @record_count from ' , v_table_name);
      prepare stmt from @v_sql; -- 预处理需要执行的动态SQL，其中stmt是一个变量
      EXECUTE stmt; -- 执行SQL语句
      deallocate prepare stmt; -- 释放掉预处理段
      -- set v_table_name, @record_count;
      if @record_count =0 then
        -- select concat('delete last table ',v_table_name);
        set @v_sql = concat('drop table   ' , v_table_name);
        prepare stmt from @v_sql; -- 预处理需要执行的动态SQL，其中stmt是一个变量
        EXECUTE stmt; -- 执行SQL语句
        deallocate prepare stmt; -- 释放掉预处理段
      end if;

      -- 结束游标循环
    end loop;
    -- 关闭游标
    close cur;


  END