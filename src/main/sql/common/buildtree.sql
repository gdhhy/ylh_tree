CREATE   PROCEDURE `buildTree_v1`( )
BEGIN
	  -- 1、生成 curLevel
		-- 2、计算直接下级 direct_count
		-- 3、计算总下级
		-- 4、计算深度
	 declare v_level int;
	 declare v_max_level int;
	 set v_level=1;
	 	update member_v1 set cur_level=0,direct_count=0,child_depth=0,child_total=0;

	   -- 1、生成 curLevel
			update member_v1  A join  (select member_no
                           from member_v1
                           where  parent_no not in (select member_no from member_v1))  B
			 on A.member_no=B. member_no
			 set   A.cur_level=1;

  while ROW_COUNT() > 0 DO -- 循环开始

	   set v_level=v_level+1;
			update member_v1  A join  (select member_no
                           from member_v1
                           where  parent_no  in (select member_no from member_v1 where cur_level= v_level-1))  B
			 on A.member_no=B. member_no
			 set   A.cur_level=v_level;
 end while;

		-- 2、计算直接下级 direct_count
		/*set v_level=1;

		while ROW_COUNT() > 0 do
		  set v_level=v_level+1;
		   update member_v1  A join  (select parent_no,count(*) direct_count from member_v1 where cur_level= v_level group by parent_no )  B
			 on A.member_no=B.parent_no
			 set A.direct_count = B.direct_count
			 where A.cur_level= v_level-1;
		 end while;*/
		  update member_v1  A join  (select parent_no,count(*) direct_count from member_v1   group by parent_no )  B
			 on A.member_no=B.parent_no
			 set A.direct_count = B.direct_count;

  	-- 3、计算总下级
		-- 4、计算深度 ,从最大开始
		select max(cur_level) into v_max_level from member_v1 ;
		set v_level =0;

		while v_level < v_max_level do
				 update member_v1  A join  (select parent_no,sum(child_total) direct2_count from member_v1 where cur_level=  v_max_level- v_level  group by parent_no )  B
			 on A.member_no=B.parent_no
			 set A.child_total = B.direct2_count + A.direct_count;

			update member_v1 set child_depth = v_level where cur_level = v_max_level-v_level;

			set v_level=v_level + 1;
		end while;

  END