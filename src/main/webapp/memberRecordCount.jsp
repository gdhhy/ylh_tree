<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>云联惠传销查询系统 - 会员记录</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <!-- bootstrap & fontawesome -->
    <link href="components/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="components/font-awesome/css/font-awesome.css"/>

    <!-- page specific plugin styles -->
    <!-- ace styles -->
    <link rel="stylesheet" href="assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/> <!--重要-->

    <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

    <!--[if lte IE 8]-->
    <%--  <script src="js/html5shiv/dist/html5shiv.js"></script>
      <script src="js/respond/dest/respond.min.js"></script>--%>
    <!--[endif]-->
    <!-- basic scripts -->

    <script src="js/jquery-3.2.0.min.js"></script>

    <!--<script src="components/bootstrap/dist/js/bootstrap.js"></script>-->
    <script src="js/bootstrap.min.js"></script>

    <!-- page specific plugin scripts -->
    <!-- static.html end-->
    <script src="js/datatables/jquery.dataTables.min.js"></script>
    <script src="js/datatables/jquery.dataTables.bootstrap.min.js"></script>
    <%--<script src="js/datatables.net-buttons/dataTables.buttons.min.js"></script>--%>

    <script src="components/datatables.net-buttons/js/dataTables.buttons.js"></script>
    <script src="components/datatables.net-buttons/js/buttons.html5.js"></script>
    <script src="components/datatables.net-buttons/js/buttons.print.js"></script>
    <script src="js/datatables/dataTables.select.min.js"></script>
    <script src="js/jquery-ui/jquery-ui.min.js"></script>

    <%--<script src="js/jquery.form.js"></script>--%>
    <script src="js/func.js"></script>
    <script src="js/common.js"></script>

    <link rel="stylesheet" href="css/jqueryui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="components/jquery-ui.custom/jquery-ui.custom.css"/>

    <script type="text/javascript">
        jQuery(function ($) {
            var memberNo = $.getUrlParam("memberNo");
            var username = decodeURI($.getUrlParam("username"));
           // $('#username').text(username);
            $.getJSON("/listMember.jspx?memberNo=" + memberNo, function (result) { //https://www.cnblogs.com/liuling/archive/2013/02/07/sdafsd.html
                if (result.data.length > 0) {
                    //var memberInfo = JSON.parse(result.data[0].memberInfo);
                    $('#username').text(result.data[0].username+" 身份证号："+result.data[0].idCard);
                }
            });
            var url = "/getRecordCount.jspx?memberNo=" + memberNo + "&username=" + username;

            var myTable = $('#dynamic-table')
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
                .DataTable({
                    bAutoWidth: false,
                    "columns": [
                        {"data": "countID", "sClass": "center"},
                        {"data": "version", "sClass": "center"},
                        {"data": "dataType", "sClass": "center"},
                        {"data": "tableName", "sClass": "center"},
                        {"data": "recordCount", "sClass": "center"},
                        {"data": "queryTime", "sClass": "center"},
                        {"data": "createTime", "sClass": "center"}
                    ],

                    'columnDefs': [
                        {"orderable": false, className: 'text-center', "targets": 0},
                        {"orderable": true, className: 'text-center', "targets": 1},
                        {"orderable": true, className: 'text-center', "targets": 2},
                        {"orderable": true, className: 'text-center', "targets": 3},
                        {
                            "orderable": true, className: 'text-center', "targets": 4,
                            render: function (data, type, row, meta) {
                                return '<a  href="#" class="showDetail" data-version="{0}" data-dataType="{1}" data-tableName="{2}">{3}</a>'
                                    .format(row["version"], row["dataType"], row["tableName"], data);
                            }
                        },
                        {
                            "orderable": true, className: 'text-center', 'targets': 5, render: function (data, type, row, meta) {
                                var value;
                                value = [0.0, 0, 0];
                                value[2] = data > 3600000 ? parseInt(data / 3600000) : 0;
                                value[1] = data > 60000 ? parseInt((data % 3600000) / 60000) : 0;
                                value[0] = (data % 60000) / 1000.0;
                                if (value[0] > 10) value[0] = parseInt(value[0] * 100) / 100;
                                else if (value[0] > 1.001) value[0] = parseInt(value[0] * 10) / 10.0;
                                //console.log("data=" + data + ",value=" + value);
                                if (value[2] > 0) return value[2] + "小时" + value[1] + "分";
                                else if (value[1] > 0) return value[1] + "分" + Math.round(value[0]) + "秒";
                                else return value[0] + "秒";

                            }
                        },
                        {"orderable": true, className: 'text-center', 'targets': 6}
                    ],
                    // "aLengthMenu": [[20, 100, -1], ["20", "100", "全部"]],//二组数组，第一组数量，第二组说明文字;
                    "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                    language: {
                        url: '/js/datatables/datatables.chinese.json'
                    },
                    //"scrollY":        $(document).height()-290,
                    scrollY:        '65vh',
                    "scrollCollapse": true,
                    "ajax": url,
                    //"processing": true, //显示：处理中。。。
                    "paging": false, // 禁止分页
                    //"serverSide": true, //搜索时是否服务器端处理
                    select: {style: 'single'}
                });
            myTable.on('order.dt search.dt', function () {
                myTable.column(0, {search: 'applied', order: 'applied'}).nodes().each(function (cell, i) {
                    cell.innerHTML = i + 1;
                });
            });
            myTable.on('xhr', function (e, settings, json, xhr) {
                if (json.executingThreadCount>0) {
                    setTimeout(refresh, 500);
                    $('#executing').text('有 '+json.executingThreadCount+' 个线程在统计数据量');
                }else
                    $('#executing').text('');
            });

            myTable.on('draw', function () {
                $('#dynamic-table tr').find('.showDetail').click(function () {
                    //console.log("url1");
                    var url = "/memberDetail.jsp?memberNo={0}&version={1}&dataType={2}&tableName={3}&recordCount={4}&username={5}"
                        .format(memberNo, $(this).attr("data-version"), $(this).attr("data-dataType"), $(this).attr("data-tableName"), $(this).text(), username);
                    //console.log("url=" + url);
                    window.open(encodeURI(encodeURI(url)), "_blank");
                });
                //console.log("height:"+$(document).height());
            });


            //$.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';
            new $.fn.dataTable.Buttons(myTable, {
                buttons: [
                    {
                        "extend": "copy",
                        "text": "<i class='fa fa-copy bigger-110 pink'></i> <span class='hidden'>Copy to clipboard</span>",
                        "className": "btn btn-white btn-primary btn-bold"
                    },
                    {
                        "extend": "csv",
                        "text": "<i class='fa fa-database bigger-110 orange'></i> <span class='hidden'>Export to CSV</span>",
                        "className": "btn btn-white btn-primary btn-bold"
                    },
                    {
                        "extend": "excel",
                        "text": "<i class='fa fa-file-excel-o bigger-110 green'></i> <span class='hidden'>Export to Excel</span>",
                        "className": "btn btn-white btn-primary btn-bold"
                    },
                    {
                        "extend": "pdf",
                        "text": "<i class='fa fa-file-pdf-o bigger-110 red'></i> <span class='hidden'>Export to PDF</span>",
                        "className": "btn btn-white btn-primary btn-bold"
                    },
                    {
                        "extend": "print",
                        "text": "<i class='fa fa-print bigger-110 grey'></i> <span class='hidden'>Print</span>",
                        "className": "btn btn-white btn-primary btn-bold",
                        autoPrint: false
                    }
                ]
            }); // todo why only copy csv print
            myTable.buttons().container().appendTo($('.tableTools-container'));

            function refresh() {
                myTable.ajax.reload()
            }
        })
    </script>
</head>
<body class="no-skin">
<div class="main-container ace-save-state" id="main-container">
    <script type="text/javascript">
        try {
            ace.settings.loadState('main-container')
        } catch (e) {
        }
    </script>
    <div class="main-content">
        <div class="main-content-inner">

            <div class="page-content">

                <div class="row">
                    <div class="col-xs-12">

                        <div class="row">

                            <div class="col-xs-12">
                                <div class="table-header">
                                    <span id="username"></span> 数据量统计 &nbsp;&nbsp;&nbsp;<span id="executing"></span>
                                    <div class="pull-right tableTools-container"></div>
                                </div>
                                <!-- div.table-responsive -->

                                <!-- div.dataTables_borderWrap -->
                                <div>
                                    <table id="dynamic-table" class="table table-striped table-bordered table-hover" width="600">
                                        <thead>
                                        <tr>
                                            <th></th>
                                            <th>版本</th>
                                            <th>数据类型</th>
                                            <th>表名</th>
                                            <th>记录数</th>
                                            <th>耗时</th>
                                            <th>统计时间</th>
                                        </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- PAGE CONTENT ENDS -->
                    </div><!-- /.col -->
                </div><!-- /.row -->

            </div><!-- /.page-content -->
        </div><!-- /.main-container-inner -->
    </div><!-- /.main-content -->
    <div class="footer">
        <div class="footer-inner">
            <!-- #section:basics/footer -->
            <div class="footer-content">
                <span class="bigger-120"><span class="blue bolder">广东鑫证</span>司法鉴定所 &copy; 2018
                </span>
            </div>
            <!-- /section:basics/footer -->
        </div>
    </div>
</div><!-- /.main-container -->

</body>
</html>