CREATE DEFINER=`root`@`%` PROCEDURE `execBuildTree`()
BEGIN
    -- 创建接收游标数据的变量
    declare v_member_no varchar(26); 
    -- 创建结束标志变量
    declare done int default false;
    declare cur cursor for select member_no
                           from member_tree_0731
                           where  parent_no not in (select member_no from member_tree_0731) or member_no='0000000000_0000000000_0000';
    -- 指定游标循环结束时的返回值
    declare continue HANDLER for not found set done = true;
    
    -- 递归深度
    set @@max_sp_recursion_depth=1000; 

    -- 打开游标
    open cur;
    -- 开始循环游标里的数据
    read_loop: loop
      -- 根据游标当前指向的一条数据
      fetch cur
      into v_member_no;
      -- 判断游标的循环是否结束
      if done
      then
        leave read_loop;
      -- 跳出游标循环
      end if;
      -- 获取一条数据时，将count值进行累加操作，这里可以做任意你想做的操作， 
      call  recurBuildTree(v_member_no,0,@p_childcount,@p_childlevel);
      -- set childTotal = childTotal + c;
      -- 结束游标循环
    end loop;
    -- 关闭游标
    close cur;
 

  END