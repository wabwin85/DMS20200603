<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Empty.Master" AutoEventWireup="true" CodeBehind="UploadQRCode_bak.aspx.cs" Inherits="DMS.WeChatClient.Page.QRCode.UploadQRCode_bak" %>

<%@ Import Namespace="DMS.WeChatClient.Common" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHeader" runat="server">
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
                color: #B7B7B8;
                background-color: #E4E5E5;
                height: 40px;
            }

            .QRGrid_Header td {
                padding: 0.5em 0.3em;
            }

        .QRGrid td {
            padding: 0.5em 0.3em;
        }

        .QRInfo {
            text-align: left;
        }

            .QRInfo .QRInfo_Title {
                color: #B7B7B8;
                display: inline-block;
                width: 33px;
            }

        .flex-column {
            display: flex !important;
            flex-direction: column !important;
        }

        .MainContent {
            display: flex;
            flex-direction: column;
        }

        .weui_cell {
            padding: 13px 15px !important;
        }

        .weui_tab_bd .weui_tab_bd_item {
            display: none !important;
        }

            .weui_tab_bd .weui_tab_bd_item.weui_tab_bd_item_active {
                display: flex !important;
                flex-direction: column !important;
            }

        #spDealerName {
            font-size: 17px;
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
                                    单据号：<span id="spNo" style="color:#888">20200217-1</span>
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
                            <span id="spDealerName">上海葡萄城技术有限公司</span>
                        </div>
                    </div>
                    <div class="weui_cell">
                        <div class="weui_cell_bd weui_cell_primary">
                            <textarea id="txtRemark" class="weui_textarea" placeholder="请输入备注" rows="2"></textarea>
                        </div>
                    </div>
                    <div class="weui_cell">
                        <div class="weui-row" style="width: 100%;">
                            <div class="weui-col-50">
                                <a id="btnScan" class="weui_btn gui_btn gui_btn_primary">扫码</a>
                            </div>
                            <div class="weui-col-50">
                                <a id="btnSubmitAgain" class="weui_btn gui_btn gui_btn_default">再次提交</a>
                            </div>
                        </div>
                    </div>
                    <div style="overflow: auto;" class="flex-column">
                        <table class="QRGrid_Header">
                            <tr>
                                <td style="width: 30px">序号</td>
                                <td>单据信息</td>
                                <td style="width: 70px">微信状态</td>
                                <td style="width: 70px">DMS状态</td>
                                <td style="width: 20px"></td>
                            </tr>
                        </table>
                        <div style="overflow: auto;">
                            <table class="QRGrid" id="tbQRGrid">
                                <tr>
                                    <td style="width: 30px">1</td>
                                    <td>
                                        <div class="QRInfo">
                                            <div>
                                                <div class="QRInfo_Title">QR:</div>
                                                1234567890ABCDF
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">UPN:</div>
                                                M00535920
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">LOT:</div>
                                                20591186
                                            </div>
                                        </div>
                                    </td>
                                    <td style="width: 70px">待提交</td>
                                    <td style="width: 70px">未接收</td>
                                    <td style="width: 20px">删</td>
                                </tr>
                                <tr>
                                    <td>1</td>
                                    <td>
                                        <div class="QRInfo">
                                            <div>
                                                <div class="QRInfo_Title">QR:</div>
                                                1234567890ABCDF
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">UPN:</div>
                                                M00535920
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">LOT:</div>
                                                20591186
                                            </div>
                                        </div>
                                    </td>
                                    <td>待提交</td>
                                    <td>未接收</td>
                                    <td>删</td>
                                </tr>
                                <tr>
                                    <td>1</td>
                                    <td>
                                        <div class="QRInfo">
                                            <div>
                                                <div class="QRInfo_Title">QR:</div>
                                                1234567890ABCDF
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">UPN:</div>
                                                M00535920
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">LOT:</div>
                                                20591186
                                            </div>
                                        </div>
                                    </td>
                                    <td>待提交</td>
                                    <td>未接收</td>
                                    <td>删</td>
                                </tr>
                                <tr>
                                    <td>1</td>
                                    <td>
                                        <div class="QRInfo">
                                            <div>
                                                <div class="QRInfo_Title">QR:</div>
                                                1234567890ABCDF
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">UPN:</div>
                                                M00535920
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">LOT:</div>
                                                20591186
                                            </div>
                                        </div>
                                    </td>
                                    <td>待提交</td>
                                    <td>未接收</td>
                                    <td>删</td>
                                </tr>
                                <tr>
                                    <td>1</td>
                                    <td>
                                        <div class="QRInfo">
                                            <div>
                                                <div class="QRInfo_Title">QR:</div>
                                                1234567890ABCDF
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">UPN:</div>
                                                M00535920
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">LOT:</div>
                                                20591186
                                            </div>
                                        </div>
                                    </td>
                                    <td>待提交</td>
                                    <td>未接收</td>
                                    <td>删</td>
                                </tr>
                                <tr>
                                    <td>1</td>
                                    <td>
                                        <div class="QRInfo">
                                            <div>
                                                <div class="QRInfo_Title">QR:</div>
                                                1234567890ABCDF
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">UPN:</div>
                                                M00535920
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">LOT:</div>
                                                20591186
                                            </div>
                                        </div>
                                    </td>
                                    <td>待提交</td>
                                    <td>未接收</td>
                                    <td>删</td>
                                </tr>
                                <tr>
                                    <td>1</td>
                                    <td>
                                        <div class="QRInfo">
                                            <div>
                                                <div class="QRInfo_Title">QR:</div>
                                                1234567890ABCDF
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">UPN:</div>
                                                M00535920
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">LOT:</div>
                                                20591186
                                            </div>
                                        </div>
                                    </td>
                                    <td>待提交</td>
                                    <td>未接收</td>
                                    <td>删</td>
                                </tr>
                                <tr>
                                    <td>1</td>
                                    <td>
                                        <div class="QRInfo">
                                            <div>
                                                <div class="QRInfo_Title">QR:</div>
                                                1234567890ABCDF
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">UPN:</div>
                                                M00535920
                                            </div>
                                            <div>
                                                <div class="QRInfo_Title">LOT:</div>
                                                20591186
                                            </div>
                                        </div>
                                    </td>
                                    <td>待提交</td>
                                    <td>未接收</td>
                                    <td>删</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="weui-row gui_btngroup gui_btnbottom_flex">
                        <div class="weui-col-50">
                            <a id="btnSubmit" class="weui_btn gui_btn gui_btn_primary">提交</a>
                        </div>
                        <div class="weui-col-50">
                            <a id="btnExport" class="weui_btn gui_btn gui_btn_default">导出</a>
                        </div>
                    </div>
                </div>
            </div>
            <div id="divList" class="weui_tab_bd_item">
            </div>
        </div>
        <div class="weui_tabbar">
            <a id="Scan" href="#divScan" class="weui_tabbar_item">
                <div class="weui_tabbar_icon">
                    <img class="normal" src="../../Resource/images/BottomMenu/HR.png" alt="">
                    <img class="active" style="display: none;" src="../../Resource/images/BottomMenu/HR_Active.png" alt="">
                </div>
                <p class="weui_tabbar_label">扫码</p>
            </a>
            <a id="List" href="#divList" class="weui_tabbar_item">
                <div class="weui_tabbar_icon">
                    <img class="normal" src="../../Resource/images/BottomMenu/My.png" alt="">
                    <img class="active" style="display: none;" src="../../Resource/images/BottomMenu/My_Active.png" alt="">
                </div>
                <p class="weui_tabbar_label">列表</p>
            </a>
        </div>
    </div>
    <input type="hidden" id="hidTab" runat="server" clientidmode="Static" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphBottom" runat="server">
    <script>

        var template_QRInfo = "<tr><td style='width:30px'>{0}</td>" +
                    "<td><div class='QRInfo'><div><div class='QRInfo_Title'>QR:</div>{1}<input id='hidQRCode' type='hidden' value='{1}'/></div>" +
                    "<div><div class='QRInfo_Title'>UPN:</div>{2}</div>" +
                    "<div><div class='QRInfo_Title'>LOT:</div>{3}</div></div></td>" +
                    "<td style='width:70px'>{4}</td>" +
                    "<td style='width:70px'>{5}</td>" +
                    "<td style='width:20px' class='.deleteQRInfo' onclick=\"DeleteQRInfo(this);\"><span style='color:red;'>✖</span></td></tr>";

        var GetProductInfoByQRCode = function (qrcode, callback) {
            var result = {
                isSuccess: true,
                QRInfo: { Index: 2, QR: "QR1234567890ABC", UPN: "M00535920", LOT: "20591186", WeChatStatus: "待提交", DMSStatus: "未接收" }
            };
            callback(result);
        };

        var ScanQRCode = function () {
            GetProductInfoByQRCode("", function (result) {
                var data = result.QRInfo;
                var rowHtml = template_QRInfo.format(data.Index, data.QR, data.UPN, data.LOT, data.WeChatStatus, data.DMSStatus);
                $("#tbQRGrid tbody").prepend(rowHtml);
            });
        };

        //var BindDeleteQRInfo = function() {
        //    $(".deleteQRInfo").unbind(config.EventName.click).bind(config.EventName.click, function (e) {
        //        var obj = $(e);
        //    });
        //};

        var DeleteQRInfo = function (e) {
            var obj = $(e).closest('tr');
            var qrCode = $('#hidQRCode', obj).val();
            obj.remove();
        };

        $(function () {
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
            $("#MainContent").css("max-height", $(window).height());


            /*
            var pageindex = $("#hidPageIndex").val();
            pageindex = parseInt(pageindex) + 1;
            var data = { openId: $("#hdfOpenID").val(), startTime: $("#txtStartTime").val(), endTime: $("#txtEndTime").val(), status: status, agreement: agreement, pageindex: pageindex, pagesize: $("#hidPageSize").val() };
            $.ajax({
                type: "Post",
                url: "AttendanceQueryList.aspx/GetAttendanceApplyList",
                data: JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                async: true,
                dataType: "json",
                success: function (data) {
                    if (data.d.success) {
                        $("#hidPageIndex").val(pageindex);
                        var dataResult = JSON.parse(data.d.data);
                        var totalCount = parseInt(dataResult.pagetotalcount);
                        $("#hidPageTotalCount").val(totalCount);
                        var divListContent = $("#divListContent");
                        if (!isAppend) {
                            divListContent.empty();
                        }
                        if (totalCount > 0) {
                            var template = "<tr><td style='width:30px'>1</td>" +
                                "<td><div class='QRInfo'><div><div class='QRInfo_Title'>QR:</div>{0}</div>" +
                                "<div><div class='QRInfo_Title'>UPN:</div>{1}</div>" +
                                "<div><div class='QRInfo_Title'>LOT:</div>{2}</div></div></td>" +
                                "<td style='width:70px'>{3}</td>" +
                                "<td style='width:70px'>{4}</td>" +
                                "<td style='width:20px'>{5}</td></tr>";
                            for (var i = 0; i < dataResult.data.length; i++) {
                                var itemdata = dataResult.data[i];
                                var innerHtml = template.format(itemdata.ID, itemdata.Name_cn, itemdata.Emp_No, common.ConvertToDateTime(itemdata.InTime).format("yyyy-MM-dd HH:mm"), common.ConvertToDateTime(itemdata.OutTime).format("yyyy-MM-dd HH:mm"), itemdata.Remark, itemdata.Status, itemdata.Agreement);
                                $(innerHtml).appendTo(divListContent);
                            }
                        } else {
                            $("<div class='tipEmpty'><span>暂无数据</span></div>").appendTo(divListContent);
                        }
                    } else {
                        $.alert(data.d.msg);
                    }
                    $.hideLoading();
                    callback();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.toptip(config.CommonErrorMsg, 'warning');
                    $.hideLoading();
                    callback();
                }
            });
            */


            ScanQRCode();
            ScanQRCode();
        });
    </script>
</asp:Content>
