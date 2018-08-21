package com.zcreate.ylh.pojo;

import java.io.Serializable;

public class TableConfig     implements Serializable ,Comparable{
    private Integer configID;
    private String tableName;
    private String version;
    private String dataType;
    private String varName;
    private String queryMethod;
    private String month;

    public Integer getConfigID() {
        return configID;
    }

    public void setConfigID(Integer configID) {
        this.configID = configID;
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

    public String getVarName() {
        return varName;
    }

    public void setVarName(String varName) {
        this.varName = varName;
    }

    public String getQueryMethod() {
        return queryMethod;
    }

    public void setQueryMethod(String queryMethod) {
        this.queryMethod = queryMethod;
    }

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    @Override
    public int compareTo(Object o) {
        String s1 = this.getVersion() + "_" + this.getTableName();
        String s2 = ((TableConfig) o).getVersion() + "_" + ((TableConfig) o).getTableName();
        return s1.compareTo(s2);
    }
}
