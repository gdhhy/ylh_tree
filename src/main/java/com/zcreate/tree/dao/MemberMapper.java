package com.zcreate.tree.dao;

import com.zcreate.tree.pojo.Member;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * Created by hhy on 17-5-5.
 */
@Mapper
public interface MemberMapper {
    int getMemberCount(@Param("param") Map<String, Object> param);

    List<Member> selectMember(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectOffline(@Param("list") List<Integer> param);

    int selectOfflineID(@Param("param") Map<String, Object> param);

    int selectOfflineCount();

    Member getMember(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectParent(@Param("param") Map<String, Object> param);

}
