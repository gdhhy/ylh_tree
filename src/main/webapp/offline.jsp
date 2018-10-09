<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>云联惠传销查询系统</title>
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

    <script src="components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
    <script src="components/datatables.net-buttons/js/buttons.html5.min.js"></script>
    <script src="components/datatables.net-buttons/js/buttons.print.min.js"></script>
    <script src="js/datatables/dataTables.select.min.js"></script>

    <script type="text/javascript" src="js/datatables/scrolling.js"></script>
    <script src="js/jquery-ui/jquery-ui.min.js"></script>

    <%--<script src="js/jquery.form.js"></script>--%>
    <script src="js/func.js"></script>

    <script src="js/common.js"></script>
    <link rel="stylesheet" href="css/jqueryui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="components/jquery-ui.custom/jquery-ui.custom.css"/>

    <script type="text/javascript">
        jQuery(function ($) {
            var url = "/offlineOrder.jspx";
            var myTable = $('#dynamic-table')
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
                .DataTable({
                    bAutoWidth: false,
                    "columns": [
                        {"data": "ordersn", "sClass": "center"},
                        {"data": "buyer_id", "sClass": "center"},
                        {"data": "seller_id", "sClass": "center"},
                        {"data": "memo", "sClass": "center"},
                        {"data": "trade_time", "sClass": "center"},
                        {"data": "money", "sClass": "center"},
                        {"data": "ver", "sClass": "center"}
                    ],

                    'columnDefs': [
                        {"orderable": false, className: 'text-center', "targets": 0, width: "80px"},
                        {"orderable": false, className: 'text-center', "targets": 1, width: "250px"},
                        {"orderable": false, className: 'text-center', "targets": 2, width: "250px"},
                        {"orderable": false, className: 'text-center', "targets": 3},
                        {"orderable": false, className: 'text-center', "targets": 4, width: "140px"},
                        {"orderable": false, 'targets': 5},
                        {"orderable": false, 'targets': 6, width: "50px"}
                    ],
                    //"aLengthMenu": [[10, 15, 20, 100], ["10", "15", "20", "100"]],//二组数组，第一组数量，第二组说明文字;
                    "bLengthChange": false, //改变每页显示数据数量
                    "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                    language: {
                        url: '/js/datatables/datatables.chinese.json'
                    },
                    searching: false,
                    scrollY: '58vh',
                    //"sPaginationType": "scrolling",
                    "ajax": {
                        url: url,
                        "data": function (d) {//删除多余请求参数
                            for (var key in d)
                                if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0)  //以columns开头的参数删除
                                    delete d[key];
                        }
                    },
                    //"processing": true,
                    "bFilter": false, //过滤功能
                    "bSort": false, //排序功能
                    "serverSide": true,
                    select: {style: 'single'}
                });

            var loop = false;
            myTable.on('draw.dt', function () {
                //console.log("loop=" + loop);
                if (loop) {
                    setTimeout(function () {
                        myTable.page('next').draw(false);
                    }, 100);
                }
            });

            // var t;

            $('.btn-group-justified').find("button:first").click(function (event) {
                $(this).hide();
                $('.btn-group-justified').find("button:last").show();
                myTable.page('next').draw(false);
                loop = true;
                //$('.dataTables_paginate').find("a:last").trigger('click');

                /*t = setInterval(function () {
                    $('.dataTables_paginate').find("a:last").trigger('click');
                }, 2000);*/
            });
            $('.btn-group-justified').find("button:last").click(function (event) {
                $(this).hide();
                $('.btn-group-justified').find("button:first").show();
                loop = false;
                //clearInterval(t);
            });
            $('.btn-group-justified').find("button:last").hide();
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

            <div class="breadcrumbs" id="breadcrumbs">
                <ul class="breadcrumb btn-group btn-group-justified">
                    <div class="center">
                        <button class="btn btn-app btn-purple btn-sm">
                            <i class="ace-icon fa fa-play bigger-120"></i>
                            开始
                        </button>
                        <button class="btn btn-app btn-purple btn-sm">
                            <i class="ace-icon fa fa-stop bigger-120"></i>
                            停止
                        </button>
                    </div>
                </ul>
            </div>
            <!-- /section:basics/content.breadcrumbs -->
            <div class="page-content">

                <div class="row">
                    <div class="col-xs-12">

                        <div class="row">

                            <div class="col-xs-12">
                                <div class="table-header">
                                    云联惠线下交易数据随机抽样展示
                                    <div class="pull-right tableTools-container"></div>
                                </div>
                                <!-- div.table-responsive -->

                                <!-- div.dataTables_borderWrap -->
                                <div>
                                    <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                                        <thead>
                                        <tr>
                                            <th>订单号</th>
                                            <th>买家</th>
                                            <th>卖家</th>
                                            <th>备注</th>
                                            <th>交易时间</th>
                                            <th>金额(元)</th>
                                            <th>版本</th>
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