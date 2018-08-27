CREATE DEFINER=`root`@`%` PROCEDURE `recurParent_v3`(in p_member_no varchar(100), in p_maxlevel int)
BEGIN
    declare v_parent_no varchar(26);
    declare v_user_name varchar(100);
    declare v_parent_name varchar(100);
    declare v_real_name varchar(100);
    declare v_id_card varchar(100);
    declare v_phone varchar(100);
    declare v_level int;

    select parent_no, user_name, real_name, id_card, phone, cur_level
        into v_parent_no, v_user_name, v_real_name, v_id_card, v_phone, v_level
    from member_v3
    where member_no = p_member_no;
    -- todo 优化
    select A.user_name into v_parent_name
    from member_v3 A
           left join member_v3 B on B.parent_no = A.member_no
    where B.member_no = p_member_no;

    set @maxlevel = p_maxlevel - 1;
    select parent_no into @parent_no from member_v3 where member_no = p_member_no;

    if @maxlevel > 1 and @parent_no is not null and v_level>1 then
      call recurParent_v3(@parent_no, @maxlevel);
    end if;
    insert into tmp_table (parent_no, user_name, parent_name, real_name, id_card, phone, cur_level)
    values (v_parent_no, v_user_name, v_parent_name, v_real_name, v_id_card, v_phone, v_level);
  END