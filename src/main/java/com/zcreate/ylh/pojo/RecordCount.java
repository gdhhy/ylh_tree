package com.zcreate.ylh.pojo;

import java.sql.Timestamp;

public class RecordCount {
    private int countID;
    private int configID;
    private String memberNo;
    private int recordCount;
    private long queryTime;
    private Timestamp createTime;

    //查询用
    private String tableName;
    private String version;
    private String dataType;

    public int getCountID() {
        return countID;
    }

    public void setCountID(int countID) {
        this.countID = countID;
    }

    public int getConfigID() {
        return configID;
    }

    public void setConfigID(int configID) {
        this.configID = configID;
    }

    public String getMemberNo() {
        return memberNo;
    }

    public void setMemberNo(String memberNo) {
        this.memberNo = memberNo;
    }


    public int getRecordCount() {
        return recordCount;
    }

    public void setRecordCount(int recordCount) {
        this.recordCount = recordCount;
    }

    public long getQueryTime() {
        return queryTime;
    }

    public void setQueryTime(long queryTime) {
        this.queryTime = queryTime;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }
}
