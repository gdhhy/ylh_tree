package com.zcreate.tree.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.zcreate.Ognl;
import com.zcreate.tree.dao.MemberMapper;
import com.zcreate.tree.pojo.Member;
import com.zcreate.ylh.dao.TableConfigMapper;
import com.zcreate.ylh.dao.YlhMapper;
import com.zcreate.ylh.pojo.RecordCount;
import com.zcreate.ylh.pojo.TableConfig;
import com.zcreate.ylh.service.YlhService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.PostConstruct;
import java.util.*;

@Controller

@RequestMapping("/")
public class MemberController implements ApplicationContextAware {
    private static Logger log = LoggerFactory.getLogger(MemberController.class);
    @Autowired
    private MemberMapper memberMapper;
    @Autowired
    private TableConfigMapper tableConfigMapper;
    @Autowired
    private YlhService service;

    private ApplicationContext applicationContext;
    private static List<TableConfig> tableConfigList;
    private static HashMap<String, com.zcreate.ylh.dao.YlhMapper> mapperVariable = new HashMap<>();
    private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();


    private java.util.Random random = new java.util.Random(System.currentTimeMillis());
    //private static int offlineID1 = 1, offlineID2, offlineID3, offlineID4, offlineCount;

    private static List<Integer> randomInt1 = new ArrayList<>(1000);
    private static List<Integer> randomInt2 = new ArrayList<>(3 * 10000);
    private static List<Integer> randomInt3 = new ArrayList<>(50 * 10000);
    private static List<Integer> randomInt4 = new ArrayList<>(300 * 10000);

    @PostConstruct
    private void init() {
        if (tableConfigList == null)
            tableConfigList = tableConfigMapper.selectTableConfig(new HashMap<>());

        if (mapperVariable.size() == 0) {
            List<String> variableList = tableConfigMapper.selectDistinctVariable();
            for (String var : variableList) {
                mapperVariable.put(var, (com.zcreate.ylh.dao.YlhMapper) applicationContext.getBean(var));

                if (mapperVariable.get(var) == null) {
                    log.warn("未设置变量" + var + "，请检查配置");
                }
            }
        }
        // loadOfflineRandom();
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }

    private void loadOfflineRandom() {
        Map<String, Object> param = new HashMap<>();

        int startValue = 1;
        param.put("upMoney", 1000 * 10000);
        int offlineID = memberMapper.selectOfflineID(param);
        while (randomInt1.size() < offlineID - startValue)
            randomInt1.add(startValue + random.nextInt(offlineID - startValue));//between zero (inclusive) and bound (exclusive)
        // printMinMax(randomInt1);

        startValue = randomInt1.size() + 1;
        param.put("upMoney", 100 * 10000);
        offlineID = memberMapper.selectOfflineID(param);
        log.debug("offlineID:" + offlineID);
        while (randomInt2.size() < offlineID - startValue)
            randomInt2.add(startValue + random.nextInt(offlineID - startValue));
        // printMinMax(randomInt2);

        startValue = randomInt1.size() + randomInt2.size() + 1;
        param.put("upMoney", 10 * 10000);
        offlineID = memberMapper.selectOfflineID(param);
        while (randomInt3.size() < offlineID - startValue)
            randomInt3.add(startValue + random.nextInt(offlineID - startValue));
        // printMinMax(randomInt3);

        startValue = randomInt1.size() + randomInt2.size() + randomInt3.size() + 1;
        offlineID = memberMapper.selectOfflineCount() + 1;
        while (randomInt4.size() < offlineID - startValue)
            randomInt4.add(startValue + random.nextInt(offlineID - startValue));
        /* printMinMax(randomInt4);*/
    }

    public void printMinMax(List<Integer> list) {
        // System.out.println("size() = " + list.size());
        int min = Integer.MAX_VALUE, max = Integer.MIN_VALUE;
        for (Integer i : list) {
            if (min > i) min = i;
            if (max < i) max = i;
        }
        System.out.println("min = " + min + ", max=" + max);
    }

    @ResponseBody
    @RequestMapping(value = "/offlineOrder", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String offlineOrder(@RequestParam(value = "draw", required = false) Integer draw,
                               @RequestParam(value = "version", required = false, defaultValue = "v1") String version,
                               @RequestParam(value = "start", required = false) Integer start,
                               @RequestParam(value = "length", required = false, defaultValue = "100") Integer length) {
        if (randomInt1.size() == 0) loadOfflineRandom();
        if (length == -1) length = 10;
        List<Integer> list;
        int size = 0;
        // 1000万以上，100万-1000万，10万-100万，1万-10万
        switch (version) {
            case "v1":
                list = randomInt1.subList(start, start + length);
                size = randomInt1.size();
                break;
            case "v2":
                list = randomInt2.subList(start, start + length);
                size = randomInt2.size();
                break;
            case "v3":
                list = randomInt3.subList(start, start + length);
                size = randomInt3.size();
                break;
            default:
                list = randomInt4.subList(start, start + length);
                size = randomInt4.size();
        }
        List<Map<String, Object>> offlines = memberMapper.selectOffline(list);

        //保持list的整数顺序
        List<Map<String, Object>> orderOffline = new ArrayList<>(offlines.size());
        for (Integer offlineID : list) {
            for (Map map : offlines) {
                if (offlineID.equals(map.get("offline_id"))) {
                    orderOffline.add(map);
                    //offlines.remove(map);
                    break;
                }
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("data", orderOffline);
        result.put("draw", draw);//draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。
        result.put("recordsTotal", size);
        result.put("recordsFiltered", size);
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/listMember", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String listMember(@RequestParam(value = "memberNo", required = false) String memberNo,
                             @RequestParam(value = "memberNos", required = false) String memberNos,
                             @RequestParam(value = "phone", required = false) String phone,
                             @RequestParam(value = "idCard", required = false) String idCard,
                             @RequestParam(value = "parentNo", required = false) String parentNo,
                             @RequestParam(value = "realName", required = false) String realName,
                             @RequestParam(value = "username", required = false) String username,
                             @RequestParam(value = "threeThirty", required = false) Boolean threeThirty,

                             //@RequestParam(value = "search[value]", required = false) String searchValue,
                             @RequestParam(value = "draw", required = false) Integer draw,
                             @RequestParam(value = "start", required = false) Integer start,
                             @RequestParam(value = "length", required = false, defaultValue = "100") Integer length
    ) {
        /*log.debug("searchValue=" + searchValue);
        log.debug("threeThirty=" + threeThirty);
        log.debug("memberNo={}", memberNo);*/
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        if (memberNos != null)
            param.put("memberNos", memberNos.split(","));
        param.put("phone", phone);
        param.put("idCard", idCard);
        param.put("realName", realName);
        param.put("username", username);
        param.put("threeThirty", threeThirty);
        param.put("parentNo", parentNo);
        param.put("start", start);
        if (parentNo == null)
            param.put("length", length);
        List<Member> members = memberMapper.selectMember(param);
        int recordCount;
        if (Ognl.isEmpty(memberNo) && Ognl.isEmpty(phone) && Ognl.isEmpty(idCard) && Ognl.isEmpty(memberNos) &&
                Ognl.isEmpty(realName) && Ognl.isEmpty(username) && Ognl.isEmpty(parentNo) &&
                (Boolean.FALSE == threeThirty || null == threeThirty))
            recordCount = 8958637;
        else
            recordCount = memberMapper.getMemberCount(param);

        Map<String, Object> result = new HashMap<>();
        result.put("data", members);
        result.put("draw", draw);//draw——number类型——请求次数计数器，每次发送给服务器后原封返回，因为请求是异步的，为了确保每次请求都能对应到服务器返回到的数据。
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/memberTree", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String memberTree(@RequestParam(value = "memberNo", required = false) String memberNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("parentNo", memberNo);
        List<Member> members = memberMapper.selectMember(param);

        Map<String, Object> result = new HashMap<>();
        Map<String, Object> obj = new HashMap<>();
        //List<Map<String, Object>> oj = new List<HashMap<>>();
        for (Member member : members) {
            Map<String, Object> item = new HashMap<>();
            String baseText = "层级:" + member.getCurLevel() + "，" + member.getUsername() + "，证件号：" + member.getIdCard() + "，手机：" + member.getPhone();
            if (member.getDirectCount() > 0) {
                baseText += "，下级深度：" + member.getChildDepth() + "，下级总数：" + member.getChildTotal();
                item.put("type", "folder");
            } else {
                baseText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i class='ace-icon fa fa-user'></i>&nbsp;" + baseText;
                item.put("type", "item");
            }
            if (member.getType() == 1)
                item.put("text", "<span style='color:#FF00FF'>" + baseText + "</span>");
            else
                item.put("text", baseText);

            Map<String, Object> addParam = new HashMap<>();
            addParam.put("children", member.getDirectCount() > 0 ? true : null);
            addParam.put("id", member.getMemberNo());
            //addParam.put("info", member.getMemberInfo());

            item.put("additionalParameters", addParam);

            obj.put("node_" + member.getMemberNo(), item);
        }

        result.put("data", obj);
        result.put("status", "OK");
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/memberZTree", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
    public String memberZTree(@RequestParam(value = "id", required = false) String memberNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("parentNo", memberNo);
        List<Member> members = memberMapper.selectMember(param);

        //Map<String, Object> result = new HashMap<>();
        //Map<String, Object> obj = new HashMap<>();
        List<Map<String, Object>> list = new ArrayList<>();
        for (Member member : members) {
            Map<String, Object> item = new HashMap<>();
            String value = member.getRealName() + "，证件号：" + member.getIdCard() + "，手机：" + member.getPhone();
            if (member.getDirectCount() > 0)// item.put("name", member.getRealName() + "，下级深度：" + member.getChildDepth() + "，下级总数：" + member.getChildTotal());
                value += "，下级深度：" + member.getChildDepth() + "，下级总数：" + member.getChildTotal();

            item.put("name", value);
            item.put("isParent", member.getDirectCount() > 0);
            item.put("id", member.getMemberNo());

            list.add(item);
        }

        return gson.toJson(list);
    }

    @ResponseBody
    @RequestMapping(value = "/memberOrg", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String memberOrg(@RequestParam(value = "id", required = false) String memberNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        Member root = memberMapper.getMember(param);
        HashMap<String, Object> result = new HashMap<>();
        result.put("name", root.getUsername());
        result.put("title", "" + root.getIdCard() + "\n下级总数：" + root.getChildTotal());

        param.clear();
        param.put("parentNo", memberNo);
        param.put("orderBy", "direct_count desc");
        List<Member> members1 = memberMapper.selectMember(param);
        List<Map<String, Object>> list = new ArrayList<>();
        //for (Member member : members1) {
        for (int i = 0; i < 10 && i < members1.size(); i++) {
            Map<String, Object> item = new HashMap<>();
            String value = "" + members1.get(i).getIdCard();
            if (members1.get(i).getDirectCount() > 0)
                value += "下级总数：" + members1.get(i).getChildTotal();

            item.put("name", members1.get(i).getUsername());
            item.put("title", value);
            if (members1.get(i).getDirectCount() > 0) {
                param.put("parentNo", memberNo);
                List<Member> members2 = memberMapper.selectMember(param);
                List<Map<String, Object>> list2 = new ArrayList<>();
                for (int j = 0; j < 3 && j < members2.size(); j++) {
                    Map<String, Object> item2 = new HashMap<>();
                    String value2 = "" + members1.get(i).getIdCard();
                    if (members2.get(j).getDirectCount() > 0)
                        value2 += "下级总数：" + members2.get(j).getChildTotal();

                    item2.put("name", members2.get(j).getUsername());
                    item2.put("title", value2);

                    list2.add(item2);
                }
                item.put("children", list2);
            }

            list.add(item);
        }
        if (members1.size() > 0) result.put("children", list);

        return gson.toJson(result);
    }

    @RequestMapping(value = "/member", method = RequestMethod.GET)
    public String member(@RequestParam(value = "searchKey", required = false) String searchKey, ModelMap model) {
        log.debug("url = member");

        //model.addAttribute("systemTitle", "系统登录");
        return "/member";
    }

    @RequestMapping(value = "/memberInfo", method = RequestMethod.GET)
    public String memberInfo(@RequestParam(value = "memberNo", required = false) String memberNo, ModelMap model) {
        //log.debug("url = memberInfo");
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);

        List<Member> members = memberMapper.selectMember(param);
        if (members.size() >= 1)
            model.addAttribute("member", members.get(0));


        //model.addAttribute("systemTitle", "系统登录");
        return "/memberInfo";
    }

    @RequestMapping(value = "/memberInfo2", method = RequestMethod.GET)
    public String memberInfo2(@RequestParam(value = "memberNo", required = false) String memberNo, ModelMap model) {
        //log.debug("url = memberInfo");
        Map<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        List<Member> members = memberMapper.selectMember(param);
        if (members.size() >= 1)
            model.addAttribute("member", members.get(0));


        //model.addAttribute("systemTitle", "系统登录");
        return "/memberInfo2";
    }

    @ResponseBody
    @RequestMapping(value = "/getParent", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getParent(@RequestParam(value = "username") String username, @RequestParam(value = "maxlevel", required = false, defaultValue = "30") Integer maxlevel) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("username", username);
        param.put("maxlevel", maxlevel);
        List<Map<String, Object>> recordCounts = memberMapper.selectParent(param);

        Map<String, Object> result = new HashMap<>();
        result.put("data", recordCounts);
        result.put("recordsTotal", recordCounts.size());
        result.put("recordsFiltered", recordCounts.size());
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/getRecordCount", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getRecordCount(@RequestParam(value = "memberNo") String memberNo, @RequestParam(value = "username") String username/*,
                                 @RequestParam(value = "draw", required = false) Integer draw*/) {
        List<RecordCount> recordCounts = service.getRecordCount(memberNo, username);

        Map<String, Object> result = new HashMap<>();
        result.put("data", recordCounts);
        //result.put("draw", draw);
        result.put("executingThreadCount", tableConfigList.size() - recordCounts.size());
        result.put("recordsTotal", recordCounts.size());
        result.put("recordsFiltered", recordCounts.size());
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/getDataType", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getDataType(@RequestParam(value = "memberNo") String memberNo, @RequestParam(value = "version") String version) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("version", version);
        List<Map<String, Object>> recordCounts = tableConfigMapper.selectDataTypeOption(param);

        Map<String, Object> result = new HashMap<>();
        result.put("data", recordCounts);
        result.put("recordsTotal", recordCounts.size());
        result.put("recordsFiltered", recordCounts.size());
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/getTableName", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getTableName(@RequestParam(value = "memberNo") String memberNo, @RequestParam(value = "version") String version,
                               @RequestParam(value = "dataType", required = false) String dataType) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("version", version);
        param.put("dataType", dataType);
        List<Map<String, Object>> recordCounts = tableConfigMapper.selectTableNameOption(param);

        Map<String, Object> result = new HashMap<>();
        result.put("data", recordCounts);
        result.put("recordsTotal", recordCounts.size());
        result.put("recordsFiltered", recordCounts.size());
        return gson.toJson(result);
    }

    @ResponseBody
    @RequestMapping(value = "/getData", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getData(@RequestParam(value = "memberNo") String memberNo, @RequestParam(value = "username") String username,
                          @RequestParam(value = "tableName") String tableName, @RequestParam(value = "version") String version,
                          @RequestParam(value = "recordCount", required = false, defaultValue = "20") Integer recordCount,
                          @RequestParam(value = "start", required = false) Integer start,
                          @RequestParam(value = "length", required = false, defaultValue = "100") Integer length) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("tableName", tableName);
        param.put("version", version);
        List<TableConfig> tables = tableConfigMapper.selectTableConfig(param);
        List<Map<String, Object>> data = new ArrayList<>();
        if (tables.size() == 1) {
            param.remove("version");
            param.put("memberNo", memberNo);
            param.put("username", username);
            param.put("start", start);
            param.put("length", length);
            YlhMapper mapper = mapperVariable.get(tables.get(0).getVarName());

            switch (tables.get(0).getQueryMethod()) {
                case "selectPoint":
                    data = mapper.selectPoint(param);
                    break;
                case "selectAccount":
                    data = mapper.selectAccount(param);
                    break;
                default://selectWithdraw
                    data = mapper.selectWithdraw(param);
            }
        }
        if ("v2".equals(version))
            for (Map<String, Object> map : data) {
                Iterator iterator = map.keySet().iterator();
                while (iterator.hasNext()) {
                    String key = (String) iterator.next();
                    if (map.get(key) instanceof String)
                        map.put(key, forceReturn(map.get(key).toString(), 15, 10));
                }
            }

        Map<String, Object> result = new HashMap<>();
        result.put("data", data);
        result.put("recordsTotal", recordCount);
        result.put("recordsFiltered", recordCount);
        return gson.toJson(result);
    }

    public static void main(String[] args) {
        List<Integer> randomInt = new ArrayList<>(500 * 10000);
        long startTime = System.currentTimeMillis();
        java.util.Random random = new java.util.Random(startTime);
        for (int i = 0; i < 500 * 10000; i++)
            randomInt.add(random.nextInt(500 * 10000));
        System.out.println("time = " + (System.currentTimeMillis() - startTime));
    }

    private static String forceReturn(String line, int maxLength, int lineLength) {
        if (line.length() > maxLength) {
            StringBuilder ret = new StringBuilder();
            int count = (int) Math.ceil(line.length() / lineLength);
            //System.out.println("count = " + count);
            for (int k = 0; k < count; k++) {
                ret.append(line.substring(k * lineLength, (k + 1) * lineLength));
                ret.append(" ");
            }
            if (line.length() % lineLength > 0)
                ret.append(line.substring((int) Math.floor(line.length() / lineLength) * lineLength));

            return ret.toString();
        } else
            return line;
    }

    @SuppressWarnings("unchecked")
    @ResponseBody
    @RequestMapping(value = "/getColumn", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
    public String getColumn(@RequestParam(value = "tableName") String tableName, @RequestParam(value = "version") String version) {
        HashMap<String, Object> param = new HashMap<>();
        param.put("tableName", tableName);
        param.put("version", version);
        List<TableConfig> tables = tableConfigMapper.selectTableConfig(param);
       /* TableConfig searchtable = new TableConfig();
        searchtable.setTableName(tableName);
        searchtable.setVersion(version);
        Collections.sort(tableConfigList);
        int kk= Collections.binarySearch(tableConfigList, searchtable);*/
        List<Map<String, Object>> data = new ArrayList<>();
        if (tables.size() == 1) {
            param.remove("version");
            param.put("length", 1);
            YlhMapper mapper = mapperVariable.get(tables.get(0).getVarName());

            switch (tables.get(0).getQueryMethod()) {
                case "selectAccount":
                    data = mapper.selectAccount(param);
                    break;
                case "selectPoint":
                    data = mapper.selectPoint(param);
                    break;
                default://selectWithdraw
                    data = mapper.selectWithdraw(param);
            }
        }
        Map<String, Object> result = new HashMap<>();
        if (data.size() == 1) {
            Set key = data.get(0).keySet();
            String[] colString = new String[key.size()];
            key.toArray(colString);
            List<Map<String, Object>> columns = new ArrayList<>();
            List<Map<String, Object>> columnDefs = new ArrayList<>();
            int targetsIndex = 0;
            HashMap<String, Object> defMap = new HashMap<>();
            defMap.put("orderable", false);
            defMap.put("className", "text-center");

            for (String aColString : colString) {
                HashMap<String, Object> map = new HashMap<>();

                map.put("data", aColString);
                map.put("title", aColString);
                map.put("sClass", "center");
                map.put("defaultContent", "");
                columns.add(map);

                defMap.put("targets", targetsIndex++);
                columnDefs.add((Map) defMap.clone());
            }

            result.put("columns", columns);
            result.put("columnDefs", columnDefs);
            result.put("recordsTotal", columns.size());
            result.put("recordsFiltered", columns.size());
        }
        return gson.toJson(result);
    }

}