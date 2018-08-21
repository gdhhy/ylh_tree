package com.zcreate.ylh.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * Created by hhy on 17-5-5.
 */
@Mapper
public interface YlhMapper {
    int getRecordCount(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectPoint(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectAccount(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectWithdraw(@Param("param") Map<String, Object> param);

}
