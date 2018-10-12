<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>云联惠传销查询系统 - 积分历史</title>
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
            var myTable;

            var pMemberNo = $.getUrlParam("memberNo");
            var pTableName = $.getUrlParam("tableName");

            var pUsername = decodeURI($.getUrlParam("username"));
            //$('#username').text(pUsername);
            $.getJSON("/listMember.jspx?memberNo=" + pMemberNo, function (result) { //https://www.cnblogs.com/liuling/archive/2013/02/07/sdafsd.html
                if (result.data.length > 0) {
                    //var memberInfo = JSON.parse(result.data[0].memberInfo);
                    $('#username').text(result.data[0].username+" 身份证号："+result.data[0].idCard);
                }
            });
            function getDataType(version) {
                $.getJSON("/getDataType.jspx?memberNo=" + pMemberNo + '&version=' + version, function (result) {
                    if (result.recordsTotal > 0) {
                        $("#dataType option:gt(0)").remove();
                        $.each(result.data, function (n, value) {
                            $('#dataType').append('<option value="{0}"  selected="selected">{1}</option>'
                                .format(value.value, value.name));
                        });
                        $('#dataType').val("");
                        getTableName(version, "");
                    }
                });
            }


            function getTableName(version, dataType) {
                var url = "/getTableName.jspx?memberNo={0}&version={1}&dataType={2}".format(pMemberNo, version, dataType);

                $.getJSON(url, function (result) { //https://www.cnblogs.com/liuling/archive/2013/02/07/sdafsd.html
                    //console.log("tableNameParam:" + pTableName);
                    if (result.recordsTotal > 0) {
                        $("#tableName").empty();
                        $.each(result.data, function (n, value) {
                            $('#tableName').append('<option value="{0}" selected="selected">{1}</option>'.format(value.value, value.name));
                        });
                        //$('#tableName').val("");
                        if (pTableName === null)
                            $("#tableName").trigger("change");
                        else {
                            $('#tableName').val(pTableName);
                            pTableName = null;
                        }
                    }
                });
            }

            var pVersion = $.getUrlParam("version");
            var pRecordCount = $.getUrlParam("recordCount");

            $('#version').val(pVersion);
            getDataType(pVersion);
            getColumns(pVersion, pTableName, pRecordCount);


            $('#version').change(function () {
                var version = $(this).children('option:selected').val();
                getDataType(version);
            });
            $('#dataType').change(function () {
                var version = $('#version').children('option:selected').val();
                var dataType = $(this).children('option:selected').val();
                getTableName(version, dataType);
            });
            $('#tableName').change(function () {
                var version = $('#version').children('option:selected').val();
                var tableNameOption = $(this).children('option:selected').val();
                var optionText = $(this).children('option:selected').text();
                var recordCount = optionText.substring(optionText.indexOf('(') + 1, optionText.indexOf(')'));
                getColumns(version, tableNameOption, recordCount);
            });


            function getColumns(version, tableName, recordCount) {//实际上开始执行查询
                var url = "/getColumn.jspx?version={0}&tableName={1}".format(version, tableName);
                showMask();
                $.getJSON(url, function (result) {
                    if (result.recordsTotal > 0) {
                        if (myTable) {
                            myTable.destroy();
                            $('#dynamic-table').empty();
                        }
                        createTable(version, tableName, recordCount, result.columns, result.columnDefs);
                    }
                    hideMask();
                });

            }

            function createTable(version, tableName, recordCount, columns, columnDefs) {
                var url = "/getData.jspx?version={0}&tableName={1}&memberNo={2}&username={3}&recordCount={4}".format(version, tableName, pMemberNo, pUsername, recordCount);
                myTable = $('#dynamic-table').DataTable({
                    bAutoWidth: false,
                    columns: columns,
                    columnDefs: columnDefs,

                    "aLengthMenu": [[20, 100, 1000], ["20", "100", "1000"]],//二组数组，第一组数量，第二组说明文字;
                    "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                    "destroy": true,
                    language: {
                        url: '/js/datatables/datatables.chinese.json'
                    },
                    scrollY: '65vh',
                    "ajax": {
                        url: url,
                        "data": function (d) {//删除多余请求参数
                            for (var key in d)
                                if (key.indexOf("columns") === 0 || key.indexOf("order") === 0 || key.indexOf("search") === 0)  //以columns开头的参数删除
                                    delete d[key];
                        }
                    },
                    "processing": true,
                    "serverSide": true,
                    searching: false,
                    select: {style: 'single'}
                });
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
                });
                myTable.buttons().container().appendTo($('.tableTools-container'));
            }

            //显示遮罩层
            function showMask() {
                $("#mask").css("height", $(document).height());
                $("#mask").css("width", $(document).width());
                $("#mask").show();
            }

            //隐藏遮罩层
            function hideMask() {
                $("#mask").hide();
            }

            //$.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';


        })
    </script>
    <style type="text/css">
        .mask {
            position: absolute;
            top: 0px;
            filter: alpha(opacity=60);
            background-color: #777;
            z-index: 1002;
            left: 0px;
            opacity: 0.5;
            -moz-opacity: 0.5;
        }
    </style>
</head>
<body class="no-skin">
<div id="mask" class="mask"></div>
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
                <ul class="breadcrumb">
                    <form class="form-search form-inline">
                        <label>版本 ：</label>
                        <select id="version" class="nav-search-input">
                            <option value="v1">V1</option>
                            <option value="v2">V2</option>
                            <option value="v3">V3</option>
                            <option value="v4" selected>V4</option>
                        </select>
                        <label>积分类型 ：</label>
                        <select id="dataType" class="nav-search-input">
                            <option value="" selected>全部</option>
                        </select>
                        <label>表名 ：</label>
                        <select id="tableName" class="nav-search-input"></select>
                    </form>
                </ul>

            </div>
            <!-- /section:basics/content.breadcrumbs -->
            <div class="page-content">

                <div class="row">
                    <div class="col-xs-12">

                        <div class="row">

                            <div class="col-xs-12">
                                <div class="table-header">
                                    <span id="username"></span> 流水
                                    <div class="pull-right tableTools-container"></div>
                                </div>
                                <!-- div.table-responsive -->

                                <!-- div.dataTables_borderWrap -->
                                <div>
                                    <table id="dynamic-table" class="table table-striped table-bordered table-hover">
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