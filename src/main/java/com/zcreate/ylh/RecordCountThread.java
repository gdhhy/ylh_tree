package com.zcreate.ylh;

import com.zcreate.ylh.dao.TableConfigMapper;
import com.zcreate.ylh.dao.YlhMapper;
import com.zcreate.ylh.pojo.RecordCount;
import com.zcreate.ylh.pojo.TableConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;

public class RecordCountThread implements Runnable {
    private static Logger log = LoggerFactory.getLogger(RecordCountThread.class);
    private TableConfigMapper tableConfigMapper;
    private String memberNo;
    private String username;
    private TableConfig tc;
    private YlhMapper mapper;
    //private ConcurrentHashMap<String, List<RecordCountThread>> concurrentHashMap;

    public RecordCountThread(String memberNo, String username, TableConfig tc, YlhMapper mapper, TableConfigMapper tableConfigMapper) {
        this.memberNo = memberNo;
        this.username = username;
        this.tc = tc;
        this.mapper = mapper;
        this.tableConfigMapper = tableConfigMapper;
        //  this.concurrentHashMap = concurrentHashMap;
    }

    @Override
    public void run() {
        long startTime = System.currentTimeMillis();
        HashMap<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("username", username);
        param.put("tableName", tc.getTableName());
        //log.debug("mapper=" + mapper);
        if (mapper == null) {
            log.error("找不到数据源");
            return;
        }
        int count = mapper.getRecordCount(param);
        //log.debug("count=" + count);

        RecordCount rc = new RecordCount();
        rc.setConfigID(tc.getConfigID());
        rc.setMemberNo(memberNo);
        rc.setRecordCount(count);
        rc.setQueryTime(System.currentTimeMillis() - startTime);
        log.debug("memberNo=" + memberNo + ",tableName=" + tc.getTableName() + ",count=" + count);
        tableConfigMapper.insertRecordCount(rc);
    }
}
