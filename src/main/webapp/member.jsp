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
    <script src="js/jquery-ui/jquery-ui.min.js"></script>

    <%--<script src="js/jquery.form.js"></script>--%>
    <script src="js/func.js"></script>

    <script src="js/common.js"></script>
    <link rel="stylesheet" href="css/jqueryui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="components/jquery-ui.custom/jquery-ui.custom.css"/>

    <script type="text/javascript">
        jQuery(function ($) {
            var memberNos = $.getUrlParam("memberNos");
            var url = "/listMember.jspx";
            if (memberNos !== null) url += '?memberNos=' + memberNos;
            //console.log('memberNos='+memberNos);
            var myTable = $('#dynamic-table')
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
                .DataTable({
                    bAutoWidth: false,
                    "columns": [
                        {"data": "memberId", "sClass": "center"},
                        {"data": "memberNo", "sClass": "center"},
                        {"data": "username", "sClass": "center"},
                        {"data": "idCard", "sClass": "center"},
                        {"data": "phone", "sClass": "center"},
                        {"data": "parentNo", "sClass": "center"},
                        {"data": "curLevel", "sClass": "center"},
                        {"data": "childTotal", "sClass": "center"},
                        {"data": "childDepth", "sClass": "center"},
                        {"data": "directCount", "sClass": "center"},
                        {"data": "memberNo", "sClass": "center"},
                        {"data": "memberNo", "sClass": "center"}
                    ],

                    'columnDefs': [
                        {"orderable": false, "searchable": false, className: 'text-center', "targets": 0, render: function (data, type, row, meta) {
                                return meta.row + 1 + meta.settings._iDisplayStart;
                            }},
                        {
                            "orderable": false, className: 'text-center', "targets": 1, render: function (data, type, row, meta) {
                                return '<a href="#" name="memberNo">{0}</a>'.format(data);
                            }
                        },
                        {
                            "orderable": false, className: 'text-center', "targets": 2/*, render: function (data, type, row, meta) {
                                return '<a href="#" class="research" name="username">{0}</a>'.format(data);
                            }*/
                        },
                        {
                            "orderable": false, className: 'text-center', "targets": 3/*, render: function (data, type, row, meta) {
                                return '<a href="#"  class="research" name="idCard">{0}</a>'.format(data);
                            }*/
                        },
                        {
                            "orderable": false, className: 'text-center', "targets": 4/*, render: function (data, type, row, meta) {
                                return '<a href="#" class="research" name="phone">{0}</a>'.format(data);
                            }*/
                        },
                        {
                            "orderable": false, "searchable": false, className: 'text-center', "targets": 5, render: function (data, type, row, meta) {
                                return '<a href="#" class="research" name="parentNo">{0}</a>'.format(data);
                            }
                        },
                        {"orderable": false, 'targets': 6, 'searchable': false},
                        {"orderable": false, "searchable": false, className: 'text-center', "targets": 7},
                        {"orderable": false, "searchable": false, className: 'text-center', "targets": 8},
                        {"orderable": false, 'searchable': false, 'targets': 9},
                        {
                            "orderable": false, 'searchable': false, 'targets': 10,
                            render: function (data, type, row, meta) {
                                return '<div class="hidden-sm hidden-xs action-buttons">' +
                                    '<a class="green" href="#" data-memberNo="{0}" data-username="{1}">'.format(data, row["username"]) +
                                    '<i class="ace-icon glyphicon glyphicon-arrow-up bigger-130"></i>' +
                                    '</a>' +
                                    '</div>';
                            }
                        },
                        {
                            "orderable": false, 'searchable': false, 'targets': 11,
                            render: function (data, type, row, meta) {
                                return '<div class="hidden-sm hidden-xs action-buttons">' +
                                    '<a class="green" href="#" data-memberNo="{0}" data-username="{1}">'.format(data, row["username"]) +
                                    '<i class="ace-icon fa fa-film bigger-130"></i>' +
                                    '</a>' +
                                    '</div>';
                            }
                        }
                    ],
                    "aLengthMenu": [[20, 100], ["20", "100"]],//二组数组，第一组数量，第二组说明文字;
                    "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                    language: {
                        url: '/js/datatables/datatables.chinese.json'
                    },
                    searching: false,
                    scrollY: '58vh',
                    "ajax": url,
                    "processing": true,
                    "serverSide": true,
                    select: {style: 'single'}
                });
            myTable.on('order.dt search.dt', function () {
                myTable.column(0, {search: 'applied', order: 'applied'}).nodes().each(function (cell, i) {
                    cell.innerHTML = i + 1;
                });
            });
            myTable.on('draw', function () {
                $('#dynamic-table tr').find('a:eq(0)').click(function () {
                    var url = "/memberInfo2.jspx?memberNo={0}".format($(this).text());
                    window.open(url, "_blank");
                });
                $('#dynamic-table tr').find('.research').click(function () {
                    var url = "/listMember.jspx?{0}={1}".format($(this).attr("name"), $(this).text());
                    $('.form-search')[0].reset();
                    $('input[name="' + $(this).attr("name") + '"]').val($(this).text());
                    myTable.ajax.url(encodeURI(encodeURI(url))).load();
                });
                $('#dynamic-table tr').find('a:eq(2)').click(function () {
                    var url = "/memberParent.jsp?memberNo={0}&username={1}".format($(this).attr("data-memberNo"), $(this).attr("data-username"));
                    window.open(encodeURI(encodeURI(url)), "_blank");
                });
                $('#dynamic-table tr').find('a:eq(3)').click(function () {
                    var url = "/memberRecordCount.jsp?memberNo={0}&username={1}".format($(this).attr("data-memberNo"), $(this).attr("data-username"));
                    window.open(encodeURI(encodeURI(url)), "_blank");
                });
                $('#dynamic-table tr').find('.hasDetail').click(function () {
                    window.open($(this).attr("data-Url"), "_blank");
                });
            });
            $('.btn-success').click(function () {
                search();
            });
            $('.form-search :text:lt(2)').each(function () {
                $(this).width(80);
            });
            $('.form-search :text:gt(2)').each(function () {
                $(this).width(100);
            });
            $('.form-search :text').keydown(function (event) {
                if (event.keyCode === 13)
                    search();
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

            function search() {
                var url = "/listMember.jspx";
                var searchParam = "?threeThirty=" + $('#three_thirty').is(':checked');
                $('.form-search :text').each(function () {
                    if ($(this).val())
                        searchParam += "&" + $(this).attr("name") + "=" + $(this).val();
                });
                if (searchParam !== "")
                    url = "/listMember.jspx" + searchParam;
                //url = "/listMember.jspx" + searchParam.replace(/&/, "?");
                myTable.ajax.url(encodeURI(url)).load();
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

            <div class="breadcrumbs" id="breadcrumbs">
                <ul class="breadcrumb">
                    <form class="form-search form-inline">
                        <label>UID ：</label>
                        <input type="text" name="memberNo" placeholder="用户ID……" class="nav-search-input" autocomplete="off"/>
                        会员ID：
                        <input type="text" name="username" placeholder="用户名……" class="nav-search-input" autocomplete="off"/>
                        证件号：
                        <input type="text" name="idCard" placeholder="证件号……" class="nav-search-input" autocomplete="off"/>
                        手机号：
                        <input type="text" name="phone" placeholder="手机号……" class="nav-search-input" autocomplete="off"/>
                        上级ID ：
                        <input type="text" name="parentNo" placeholder="上级用户ID……" class="nav-search-input" autocomplete="off"/>&nbsp;&nbsp;&nbsp;
                        三层30人：
                        <input type="checkbox" id="three_thirty">&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-sm btn-reset" type="reset">
                            <i class="ace-icon fa fa-undo bigger-110"></i>
                            复位
                        </button>
                    </form>
                </ul>
                <!-- #section:basics/content.searchbox -->
                <div class="nav-search" id="nav-search">
                    <button type="button" class="btn btn-sm btn-success">
                        搜索
                        <i class="ace-icon fa fa-arrow-right icon-on-right bigger-110"></i>
                    </button>
                </div><!-- /.nav-search -->

                <!-- /section:basics/content.searchbox -->
            </div>
            <!-- /section:basics/content.breadcrumbs -->
            <div class="page-content">

                <div class="row">
                    <div class="col-xs-12">

                        <div class="row">

                            <div class="col-xs-12">
                                <div class="table-header">
                                    成员列表 "全部列表"
                                    <div class="pull-right tableTools-container"></div>
                                </div>
                                <!-- div.table-responsive -->

                                <!-- div.dataTables_borderWrap -->
                                <div>
                                    <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                                        <thead>
                                        <tr>
                                            <th></th>
                                            <th>UID</th>
                                            <th>会员ID</th>
                                            <th>证件号</th>
                                            <th>手机号</th>
                                            <th>上级UID</th>
                                            <th>当前层级</th>
                                            <th>下级总数</th>
                                            <th>最深级数</th>
                                            <th>直接下级数</th>
                                            <th>查看上线</th>
                                            <th>积分账户流水</th>
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