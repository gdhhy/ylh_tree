CREATE DEFINER =`root`@`%` PROCEDURE `recurParent`(in p_member_no varchar(100), in p_maxlevel int)
  BEGIN
    declare v_parent_no varchar(26);
    declare v_member_no varchar(26);
    declare v_user_name varchar(100);
    declare v_parent_name varchar(100);
    declare v_real_name varchar(100);
    declare v_id_card varchar(100);
    declare v_phone varchar(100);
    declare v_level int;

    select parent_no, member_no, user_name, real_name, id_card, phone, level
        into v_parent_no, v_member_no, v_user_name, v_real_name, v_id_card, v_phone, v_level from member where member_no = p_member_no;
    -- todo 优化
    select A.user_name into v_parent_name from member A
                                                 left join member B on B.parent_no = A.member_no where B.member_no = p_member_no;

    set @maxlevel = p_maxlevel - 1;

    if @maxlevel > 1 and v_level > 1 then
      select parent_no into @parent_no from member where member_no = p_member_no;

      call recurParent(@parent_no, @maxlevel);
    end if;
    if v_level > 0 then
      insert into tmp_table(parent_no, member_no, user_name, parent_name, real_name, id_card, phone, level) values (v_parent_no, v_member_no, v_user_name, v_parent_name, v_real_name, v_id_card, v_phone, v_level);
    end if;
  END