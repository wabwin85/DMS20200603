<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Empty.Master" AutoEventWireup="true" CodeBehind="UploadQRCode.aspx.cs" Inherits="DMS.WeChatClient.Page.QRCode.UploadQRCode" %>

<%@ Import Namespace="DMS.WeChatClient.Common" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHeader" runat="server">
    <script type="text/javascript" src="https://res2.wx.qq.com/open/js/jweixin-1.6.0.js"></script>
    <style type="text/css">
        .QRGrid {
            text-align: center;
            font-size: 0.8em;
            width: 100%;
            border-collapse: collapse;
        }

        .QRGrid_Header {
            text-align: center;
            font-size: 0.8em;
            width: 100%;
            border-collapse: collapse;
            height: 40px;
        }

            .QRGrid_Header tr:first-child {
                color: #3577BA;
                background-color: #F1F5F9;
                height: 40px;
            }

            .QRGrid_Header td {
                padding: 3px;
            }

        .QRGrid tr {
            border-bottom: 1px solid #E4E5E5;
        }

        .QRGrid td {
            padding: 3px;
        }

        .QRInfo {
            text-align: left;
        }

            .QRInfo .QRInfo_Title {
                color: #B7B7B8;
                display: inline-block;
                width: 33px;
            }

        /*.flex-column {
            display: flex !important;
            flex-direction: column !important;
        }*/

        .MainContent {
            display: flex;
            flex-direction: column;
        }

        /*.weui_cell {
            padding: 13px 15px !important;
        }*/

        /*.weui_tab_bd .weui_tab_bd_item {
            display: none !important;
        }

            .weui_tab_bd .weui_tab_bd_item.weui_tab_bd_item_active {
                display: flex !important;
                flex-direction: column !important;
            }

        .weui_tab {
            overflow: auto!important;
        }
*/
        #divDealerName {
            font-size: 17px;
            overflow: hidden;
            height: 25px;
        }

        .weui_cell_ft {
            max-width: 80%;
        }

        #tbListGrid td {
            padding: 10px 0px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphCondent" runat="server">
    <div class="weui_tab flex-column">
        <div class="weui_tab_bd flex-column">
            <div id="divScan" class="weui_tab_bd_item">
                <div class="weui_cells weui_cells_form flex-column" style="margin-top: 0;">
                    <div class="weui_cell weui_cell_switch">
                        <div class="weui-row" style="width: 100%;">
                            <div class="weui-col-70">
                                <div style="line-height: 40px;">
                                    单据号：<div id="divNo" style="color: #888; display: inline-block;"></div>
                                </div>
                            </div>
                            <div class="">
                                <div class=" weui_cell_primary" style="display: inline-block;">
                                    连扫
                                </div>
                                <div style="display: inline-block; vertical-align: middle;">
                                    <input id="btnConScan" class="weui_switch" type="checkbox">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="weui_cell">
                        <div class="weui_cell_bd weui_cell_primary">
                            <p>经销商</p>
                        </div>
                        <div class="weui_cell_ft">
                            <div id="divDealerName"></div>
                        </div>
                    </div>
                    <div class="weui_cell">
                        <div class="weui_cell_bd weui_cell_primary">
                            <textarea id="txtRemark" class="weui_textarea" placeholder="请输入备注" rows="2"></textarea>
                        </div>
                    </div>
                    <div class="weui_cell">
                        <div class="weui-row" style="width: 100%;">
                            <div class="weui-col-100">
                                <a id="btnScan" class="weui_btn gui_btn gui_btn_primary">扫码</a>
                            </div>
                            <%--<div class="weui-col-50">
                                <a id="btnSubmitAgain" class="weui_btn gui_btn gui_btn_default">再次提交</a>
                            </div>--%>
                        </div>
                    </div>
                    <div class="flex-column">
                        <table class="QRGrid_Header">
                            <tr>
                                <td style="width: 30px">序号</td>
                                <td>单据信息</td>
                                <td style="width: 58px">微信状态</td>
                                <td style="width: 60px">DMS状态</td>
                                <td style="width: 20px"></td>
                            </tr>
                        </table>
                        <div id="divQRGrid" style="overflow: hidden; position: relative;">
                            <table class="QRGrid" id="tbQRGrid">
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="weui-row gui_btngroup gui_btnbottom_flex">
                        <div class="weui-col-50">
                            <a id="btnSubmit" class="weui_btn gui_btn gui_btn_primary gui_btnGreen">提交</a>
                        </div>
                        <div class="weui-col-50">
                            <a id="btnExport" class="weui_btn gui_btn gui_btn_default gui_btnGray">导出</a>
                        </div>
                    </div>
                </div>
            </div>
            <div id="divList" class="weui_tab_bd_item">
                <div class="weui_search_bar weui_search_focusing" id="search_bar">
                    <div class="weui_search_outer">
                        <div class="weui_search_inner">
                            <i class="weui_icon_search"></i>
                            <input type="search" class="weui_search_input" id="search_input" placeholder="搜索二维码" required="">
                            <a href="javascript:" class="weui_icon_clear" id="search_clear"></a>
                        </div>
                        <label for="search_input" class="weui_search_text" id="search_text">
                            <i class="weui_icon_search"></i>
                            <span>搜索二维码</span>
                        </label>
                    </div>
                    <a href="javascript:" class="weui_search_cancel weui_btn gui_btn gui_btn_default" style="margin: auto!important; margin-left: 10px!important;" id="btnSearch">查询</a>
                </div>
                <div class="flex-column">
                    <table class="QRGrid_Header">
                        <tr>
                            <td style="width: 30px">序号</td>
                            <td>单据编号</td>
                            <td style="width: 40px">明细数</td>
                            <td style="width: 60px">状态</td>
                            <td style="width: 20px"></td>
                        </tr>
                    </table>
                    <div id="divListGrid" style="overflow: hidden; position: relative;">
                        <table class="QRGrid" id="tbListGrid">
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui_tabbar">
            <a id="Scan" href="#divScan" class="weui_tabbar_item">
                <div class="weui_tabbar_icon">
                    <img class="normal" src="<%=ResolveUrl("~/Resource/images/BottomMenu/Scan.png")%>" alt="">
                    <img class="active" style="display: none;" src="<%=ResolveUrl("~/Resource/images/BottomMenu/Scan_Active.png")%>" alt="">
                </div>
                <p class="weui_tabbar_label">扫码</p>
            </a>
            <a id="List" href="#divList" class="weui_tabbar_item">
                <div class="weui_tabbar_icon">
                    <img class="normal" src="<%=ResolveUrl("~/Resource/images/BottomMenu/List.png")%>" alt="">
                    <img class="active" style="display: none;" src="<%=ResolveUrl("~/Resource/images/BottomMenu/List_Active.png")%>" alt="">
                </div>
                <p class="weui_tabbar_label">列表</p>
            </a>
        </div>
    </div>
    <input type="hidden" id="hidTab" runat="server" clientidmode="Static" />
    <input type="hidden" id="hidDealerId" runat="server" clientidmode="Static" />
    <input type="hidden" id="hidNo" runat="server" clientidmode="Static" />
    <input type="hidden" id="hidUserId" runat="server" clientidmode="Static" />
    <input type="hidden" id="hidID" runat="server" clientidmode="Static" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphBottom" runat="server">
    <script>
        //产品明细信息html模版
        var template_QRInfo = "<tr><td style='width:30px'><span id='spRowIndex'>{0}</span><input id='hidDetailId' type='hidden' value='{1}'/></td>" +
                    "<td><div class='QRInfo'><div><div class='QRInfo_Title'>QR:</div>{2}</div>" +
                    "<div><div class='QRInfo_Title'>UPN:</div>{3}</div>" +
                    "<div><div class='QRInfo_Title'>LOT:</div>{4}</div></div></td>" +
                    "<td style='width:58px'>{5}</td>" +
                    "<td style='width:60px'>{6}</td>" +
                    "<td style='width:20px' class='.deleteQRInfo' onclick=\"DeleteQRInfo(this);\"><image src='../../Resource/images/delete.png' style='width:20px;'/></td></tr>";

        //列表明细信息html模版
        var template_ListInfo = "<tr><td style='width:30px'><span id='spRowIndex'>{0}</span><input id='hidHeaderId' type='hidden' value='{1}'/><input id='hidHeaderNo' type='hidden' value='{2}'/></td>" +
                    "<td><a style='color:#3577BA;text-decoration: underline;' onclick=\"ShowHeaderInfo(this);\">{2}</a></td>" +
                    "<td style='width:40px'>{3}</td>" +
                    "<td style='width:60px'>{4}</td>" +
                    "<td style='width:20px' class='.deleteQRInfo' onclick=\"DeleteHeaderInfo(this);\"><image src='../../Resource/images/delete.png' style='width:20px;'/></td></tr>";


        //扫描二维码之后执行的事件（往待提交的表中插入记录，并且显示在页面上）
        var Event_AfterScanQRCode = function (qrcode, callback) {
            var parm = { QRCode: qrcode, HeaderId: $("#hidID").val(), UserId: $("#hidUserId").val() };
            utility.CallService(config.ActionMethod.ScanQRCode.Action, config.ActionMethod.ScanQRCode.Method.InsertWechatQRCodeDetail, parm, function (data) {
                if (data.success) {
                    var dataResult = data.data;
                    var dataDetailInfo = dataResult.DetailInfo;
                    if (dataDetailInfo) {
                        for (var i = 0; i < dataDetailInfo.length; i++) {
                            GenerateHtml_QRCode(dataDetailInfo[i]);
                        }
                    }
                    callback();
                } else {
                    $.alert(data.msg);
                }
            });
        };

        //计算页面上的明细行号
        var CalcRowIndex_QRCode = function () {
            $("#tbQRGrid tbody tr").each(function (item) {
                $('#spRowIndex', this).html($("#tbQRGrid tbody tr").length - ($(this)[0].rowIndex));
            });
        };

        //根据二维码产品信息渲染页面html元素
        var GenerateHtml_QRCode = function (data) {
            var rowHtml = template_QRInfo.format('', data.ID, data.QRCode, data.UPN, data.Lot, data.WeChatStatus ? "已提交" : "待提交", data.DMSStatus ? "已接收" : "待接收");
            $("#tbQRGrid tbody").prepend(rowHtml);
            CalcRowIndex_QRCode();
            common.attachScrollerRefresh("divQRGrid");
        };

        //计算页面上的明细行号
        var CalcRowIndex_ListGrid = function () {
            $("#tbListGrid tbody tr").each(function (item) {
                //$('#spRowIndex', this).html($("#tbListGrid tbody tr").length - ($(this)[0].rowIndex));
                $('#spRowIndex', this).html($(this)[0].rowIndex + 1);
            });
        };

        //根据单据主信息渲染页面html元素
        var GenerateHtml_ListInfo = function (data) {
            var rowHtml = template_ListInfo.format('', data.ID, data.No, data.DetailCount, data.UploadStatus ? "已提交" : "待提交");
            $("#tbListGrid tbody").prepend(rowHtml);
            CalcRowIndex_ListGrid();
            common.attachScrollerRefresh("divListGrid");
        };

        //扫描二维码
        var ScanQRCode = function () {
            wx.scanQRCode({
                needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
                scanType: ["qrCode", "barCode"], // 可以指定扫二维码还是一维码，默认二者都有
                success: function (res) {
                    var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
                    Event_AfterScanQRCode(result, function () {
                        //如果开启了连扫模式，则再次打开微信二维码扫描功能
                        if ($('#btnConScan').prop("checked")) {
                            setTimeout(function() { ScanQRCode(); }, 500);
                        }
                    });
                }
            });
        };

        //初始化二维码单据信息
        var InitQRInfo = function () {
            $("#tbQRGrid tbody").html("");
            var parm = { QRHeaderNo: $("#hidNo").val(), DealerId: $("#hidDealerId").val(), UserId: $("#hidUserId").val() };
            utility.CallService(config.ActionMethod.ScanQRCode.Action, config.ActionMethod.ScanQRCode.Method.InitQRHeaderInfo, parm, function (data) {
                if (data.success) {
                    var dataResult = data.data;
                    var dataHeaderInfo = dataResult.HeaderInfo;
                    $("#hidNo").val(dataHeaderInfo.No);
                    $("#divNo").html(dataHeaderInfo.No);
                    $("#hidID").val(dataHeaderInfo.ID);
                    $("#txtRemark").val(dataHeaderInfo.Remark);
                    var dataDetailInfo = dataResult.DetailInfo;
                    if (dataDetailInfo) {
                        for (var i = 0; i < dataDetailInfo.length; i++) {
                            GenerateHtml_QRCode(dataDetailInfo[i]);
                        }
                    }
                } else {
                    $.alert(data.msg);
                }
            });
        };

        //提交二维码单据信息
        var SubmitQRCode = function () {
            var parm = { QRHeaderNo: $("#hidNo").val(), DealerId: $("#hidDealerId").val(), UserId: $("#hidUserId").val(), UserName: localStorage.getItem(config.LocalStrogeName.UserName), Remark: $("#txtRemark").val() };
            utility.CallService(config.ActionMethod.ScanQRCode.Action, config.ActionMethod.ScanQRCode.Method.SubmitQRHeaderInfo, parm, function (data) {
                if (data.success) {
                    $.alert("上传成功");
                    InitQRInfo();
                } else {
                    $.alert(data.msg);
                }
            });
        };

        //删除二维码产品信息
        var DeleteQRInfo = function (e) {
            $.confirm("您确认要删除吗?", function () {
                var obj = $(e).closest('tr');
                var parm = { DetailId: $('#hidDetailId', obj).val(), UserId: $("#hidUserId").val() };
                utility.CallService(config.ActionMethod.ScanQRCode.Action, config.ActionMethod.ScanQRCode.Method.DeleteWechatQRCodeDetail, parm, function (data) {
                    if (data.success) {
                        obj.remove();
                        CalcRowIndex_QRCode();
                        common.attachScrollerRefresh("divQRGrid");
                        $.toptip(config.CommonSuccessMsg, 'success');
                    } else {
                        $.alert(data.msg);
                    }
                });
            });
        };

        //导出二维码单据信息
        var ExportQRInfo = function () {
            var parm = { HeaderId: $("#hidID").val(), DealerId: $("#hidDealerId").val() };
            utility.CallService(config.ActionMethod.ScanQRCode.Action, config.ActionMethod.ScanQRCode.Method.ExportQRHeaderInfo, parm, function (data) {
                if (data.success) {
                    if (data.data) {
                        var FileUrl = config.Variables.BaseUrl_ServerFilePath + data.data;
                        if (common.CopyToClipboard(FileUrl)) {
                            $.alert("文件链接已复制到粘贴板，请粘贴后在浏览器中下载:<br/>" + FileUrl);
                        } else {
                            $.alert("请复制以下链接在浏览器中下载:<br/>" + FileUrl);
                        }
                    } else {
                        $.alert('文件获取失败，请稍候再试');
                    }
                } else {
                    $.alert(data.msg);
                }
            });
        };

        //搜索二维码单据信息
        var SearchHeaderInfo = function () {
            $("#tbListGrid tbody").html("");
            var parm = { KeyWord: $("#search_input").val(), DealerId: $("#hidDealerId").val() };
            utility.CallService(config.ActionMethod.ScanQRCode.Action, config.ActionMethod.ScanQRCode.Method.SearchHeaderInfo, parm, function (data) {
                if (data.success) {
                    var dataResult = data.data;
                    for (var i = 0; i < dataResult.length; i++) {
                        GenerateHtml_ListInfo(dataResult[i]);
                    }
                } else {
                    $.alert(data.msg);
                }
            });
        };

        //显示单据明细信息
        var ShowHeaderInfo = function (e) {
            var obj = $(e).closest('tr');
            var HeaderNo = $('#hidHeaderNo', obj).val();
            if (HeaderNo && HeaderNo != '') {
                localStorage.setItem(config.LocalStrogeName.QRHeaderNo, HeaderNo);
                $("#hidNo").val(HeaderNo);
                InitQRInfo();
                $("#Scan").click();
            } else {
                $.alert('获取当前单据信息失败');
            }
        };

        //删除单据信息
        var DeleteHeaderInfo = function (e) {
            $.confirm("您确认要删除吗?", function () {
                var obj = $(e).closest('tr');
                var parm = { HeaderId: $('#hidHeaderId', obj).val(), UserId: $("#hidUserId").val() };
                utility.CallService(config.ActionMethod.ScanQRCode.Action, config.ActionMethod.ScanQRCode.Method.DeleteHeaderInfo, parm, function (data) {
                    if (data.success) {
                        obj.remove();
                        CalcRowIndex_ListGrid();
                        common.attachScrollerRefresh("divListGrid");
                        $.toptip(config.CommonSuccessMsg, 'success');
                    } else {
                        $.alert(data.msg);
                    }
                });
            });
        };

        //初始化微信JSSDK信息
        var InitWeChatJSConfig = function () {
            var data = { url: window.location.href.split('#')[0] };
            $.ajax({
                type: "Post",
                url: "<%=ResolveUrl("~/Page/QRCode/UploadQRCode.aspx")%>/GetWxConfigParameter",
                data: JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                async: true,
                dataType: "json",
                success: function (data) {
                    if (data.d.success) {
                        var result = data.d.data;
                        wx.config({
                            debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
                            appId: result.appId, // 必填，公众号的唯一标识
                            timestamp: result.timestamp, // 必填，生成签名的时间戳
                            nonceStr: result.nonceStr, // 必填，生成签名的随机串
                            signature: result.signature,// 必填，签名，见附录1
                            jsApiList: ['scanQRCode'] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
                        });
                        wx.error(function (res) {
                            $.alert(res);
                        });
                    } else {
                        $.alert(data.d.msg);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.toptip("初始化微信JSSDK失败", 'warning');
                }
            });
        };

        $(function () {
            common.CheckUserInfo();
            $("a", ".weui_tabbar").unbind(config.EventName.click).bind(config.EventName.click, function () {
                $("img[class='active']").hide();
                $("img[class='normal']").show();
                $("img[class='active']", $(this)).show();
                $("img[class='normal']", $(this)).hide();
            });

            var currentTab = $("#hidTab").val();
            if (undefined == currentTab || "" == currentTab) {
                currentTab = "Scan";
            }
            $("#" + currentTab).click();
            $('#btnConScan').prop("checked", true);

            $("#divDealerName").html(localStorage.getItem(config.LocalStrogeName.DealerName));
            $("#hidDealerId").val(localStorage.getItem(config.LocalStrogeName.DealerId));
            $("#hidUserId").val(localStorage.getItem(config.LocalStrogeName.UserId));
            $("#hidNo").val(localStorage.getItem(config.LocalStrogeName.QRHeaderNo));
            //$("#MainContent").css("max-height", $(window).height());
            setTimeout(function () {
                $("#divQRGrid").css("height", $(window).height() - 390);
                common.attachScrollerRefresh("divQRGrid");

                $("#divListGrid").css("height", $(window).height() - 140);
                common.attachScrollerRefresh("divListGrid");
            }, 500);

            $("#btnScan").unbind(config.EventName.click).bind(config.EventName.click, function () {
                ScanQRCode();
            });

            $("#btnSubmit").unbind(config.EventName.click).bind(config.EventName.click, function () {
                SubmitQRCode();
            });

            $("#btnExport").unbind(config.EventName.click).bind(config.EventName.click, function () {
                ExportQRInfo();
            });

            $("#btnSearch").unbind(config.EventName.click).bind(config.EventName.click, function () {
                SearchHeaderInfo();
            });

            InitQRInfo();
            InitWeChatJSConfig();
        });
    </script>
</asp:Content>
