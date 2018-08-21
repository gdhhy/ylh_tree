CREATE DEFINER=`root`@`%` PROCEDURE `recurBuildTree`(in p_member_no varchar(26), in p_level int, out p_childcount int, out p_childlevel int)
BEGIN
    -- 创建接收游标数据的变量
    declare v_member_no  varchar(26);
    declare v_directChild int;
    declare v_maxlevel int;
    -- 创建总数变量
    declare v_childtotal int;
    -- 创建结束标志变量
    declare done int default false;
    declare cur cursor for select member_no
                           from member_tree_0731 
                           where parent_no = p_member_no;
    -- 指定游标循环结束时的返回值
    declare continue HANDLER for not found set done = true;
    
    -- 递归深度
    set @@max_sp_recursion_depth=1000;

    set v_childtotal = 0, v_directChild = 0, v_maxlevel = 0;
    update member_tree_0731
    set cur_level = p_level + 1
    where member_no = p_member_no;

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

      call recurBuildTree(v_member_no, p_level + 1, @childcount, @childlevel);
      set v_childtotal = v_childtotal + 1 + COALESCE(@childcount, 0); -- ??  不用COALESCE也行
      set v_directChild = v_directChild + 1;
      set v_maxlevel = GREATEST(v_maxlevel, @childlevel);
      -- set childTotal = childTotal + c;
      -- 结束游标循环
    end loop;
    -- 关闭游标
    close cur;

    update member_tree_0731
    set child_total = v_childtotal, child_depth = v_maxlevel, direct_count = v_directChild
    where member_no = p_member_no;

    set p_childcount = v_childtotal, p_childlevel = v_maxlevel + 1;

  END