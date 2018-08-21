package com.zcreate.ylh.dao;

import com.zcreate.tree.pojo.Member;
import com.zcreate.ylh.pojo.RecordCount;
import com.zcreate.ylh.pojo.TableConfig;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * Created by hhy on 17-5-5.
 */
@Mapper
public interface TableConfigMapper {
    int getTableConfigCount(@Param("param") Map<String, Object> param);

    List<TableConfig> selectTableConfig(@Param("param") Map<String, Object> param);

    List<TableConfig> selectNotCountTableConfig(@Param("param") Map<String, Object> param);

    List<String> selectDistinctVariable();


    int insertRecordCount(@Param("pojo") RecordCount recordCount);

    List<RecordCount> selectRecordCount(@Param("param") Map<String, Object> param);


    List<Map<String, Object>> selectDataTypeOption(@Param("param") Map<String, Object> param);

    List<Map<String, Object>> selectTableNameOption(@Param("param") Map<String, Object> param);

}
