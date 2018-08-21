package com.zcreate.ylh.service;

import com.zcreate.ylh.RecordCountThread;
import com.zcreate.ylh.dao.TableConfigMapper;
import com.zcreate.ylh.pojo.RecordCount;
import com.zcreate.ylh.pojo.TableConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Service
public class YlhService implements ApplicationContextAware {
    private static Logger log = LoggerFactory.getLogger(YlhService.class);
    @Autowired
    private TableConfigMapper tableConfigMapper;

    private ApplicationContext applicationContext;

    private static List<TableConfig> tableConfigList;
    private static ConcurrentHashMap<String, List<RecordCountThread>> countingMemberMap = new ConcurrentHashMap<>();
    private static HashMap<String, ExecutorService> pool = new HashMap<>();
    private static HashMap<String, com.zcreate.ylh.dao.YlhMapper> mapperVariable = new HashMap<>();

    @PostConstruct
    private void init() {
        //System.out.println("@PostConstruct将在依赖注入完成后被自动调用");
        if (tableConfigList == null)
            tableConfigList = tableConfigMapper.selectTableConfig(new HashMap<>());
        if (pool.size() == 0) {
            List<String> variableList = tableConfigMapper.selectDistinctVariable();

            for (String var : variableList) {
                pool.put(var, Executors.newFixedThreadPool(2));
                mapperVariable.put(var, (com.zcreate.ylh.dao.YlhMapper) applicationContext.getBean(var));

                if (mapperVariable.get(var) == null) {
                    log.warn("未设置变量" + var + "，请检查配置");
                }
            }
        }
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }

    @PreDestroy
    private void destroy() {
        pool.forEach((k, v) -> v.shutdown());
    }

    public List<RecordCount> getRecordCount(String memberNo, String username) {
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        //param.put("username", username);
        List<RecordCount> recordCounts = tableConfigMapper.selectRecordCount(param);
        if (recordCounts.size() < tableConfigList.size()) {
            //countingMemberMap.putIfAbsent(memberNo, startCounting(memberNo, username));
            if (null == countingMemberMap.get(memberNo))
                countingMemberMap.put(memberNo, startCounting(memberNo,username));
            log.debug("memberNo=" + memberNo + ", countingMemberMap.size()=" + countingMemberMap.size());
        } else
            countingMemberMap.remove(memberNo);

        return recordCounts;
    }

    private List<RecordCountThread> startCounting(String memberNo, String username) {
        List<RecordCountThread> memberCountThread = new ArrayList<>();
        HashMap<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        //param.put("username", username);
        List<TableConfig> notCount = tableConfigMapper.selectNotCountTableConfig(param);
        for (TableConfig tc : notCount) {
            try {
                RecordCountThread thread = new RecordCountThread(memberNo, username, tc, mapperVariable.get(tc.getVarName()), tableConfigMapper);
                pool.get(tc.getVarName()).execute(thread);
                //Future future=pool.get(tc.getVarName()).submit(thread);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return memberCountThread;
    }

}
