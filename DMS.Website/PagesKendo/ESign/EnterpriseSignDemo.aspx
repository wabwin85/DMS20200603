<%@ Page Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master"  AutoEventWireup="true" CodeBehind="EnterpriseSignDemo.aspx.cs" Inherits="DMS.Website.PagesKendo.ESign.EnterpriseSignDemo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">
    <style>
        .k-textbox {
            width: 100%;
        }
        .square-radio {
            height: 97px;
        }
        .square {
            width: 97px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main">
        <input type="hidden" id="hiddenApplyId" />
        <input type="hidden" id="hiddenFileId" />
        <input type="hidden" id="hiddenDealerId" />
        <input type="hidden" id="hiddenAccountUId" />
        <input type="hidden" id="hiddenLastUpdateDate" />
        <input type="hidden" id="hiddenSignType" />
        <div class="content-row" style="padding: 10px 10px 0px 10px;">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;合同查询条件</h3>
                </div>
            </div>
        </div>
        <div class="panel-body" >
            <table style="width: 100%" class="KendoTable">
                <tr style="line-height:1px;">
                    <td style="width: 100px;height:1px;">&nbsp;</td>
                    <td style="width: 40%;height:1px;">&nbsp;</td>
                    <td style="width: 100px;height:1px;">&nbsp;</td>
                    <td style="width: 40%;height:1px;">&nbsp;</td>
                </tr>
                <tr>
                    <td class="lableControl">
                        <label class="lableControl">经销商：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtDealerName" disabled="disabled" readonly /></td>
                    <td>
                        <label class="lableControl">合同号：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtContractNo" /></td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl">合同生成时间 始：</label></td>
                    <td>
                        <table style="width:100%" >
                            <tr>
                                <td style="width:45%;padding:0;"><input type="text" class="k-textbox" id="txtBeginDate" /></td>
                                <td style="width:10%"><label class="lableControl">至</label></td>
                                <td style="width:45%;padding:0;"><input type="text" class="k-textbox" id="txtEndDate" /></td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <label class="lableControl">合同状态：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtStatus" /></td>
                </tr>
                <tr>
                    <td colspan="4">
                        <div style="text-align: right; height: 40px; margin-right: 30px;">
                            <button id="BtnSearch" class="size-14"><i class="fa fa-hand-pointer-o"></i>&nbsp;&nbsp;查询&nbsp;</button>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="content-row" style="padding: 10px 10px 0px 10px;">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;合同查询结果</h3>
                </div>
            </div>
        </div>
        <div class="panel-body" >
            <div id="ContractList" style="margin: 10px 7px 0 7px;">
            </div>
        </div>
    </div>

     <div id="ContractWindow" style="padding: 0px;display:none;">
         <div id="divContractContent" style="position: relative;height: 90%;overflow: auto;outline: 0;">
         </div>
         <div class="col-xs-12" style="position: absolute;bottom: 0;padding: 0px; height: 40px; line-height: 30px; bottom: 0px; text-align: right; background-color: #f5f5f5; border-top: solid 1px #ccc;">
            <button id="BtnFileDigest" class="KendoButton size-14" style="margin-right: 10px;"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;文档保全</button>
            <button id="BtnSign" class="KendoButton size-14" style="margin-right: 10px;"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;经销商签章</button>
            <button id="BtnLocalSign" class="KendoButton size-14" style="margin-right: 10px;"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;波科签章</button>
            <button id="BtnCanelSign" class="KendoButton size-14" style="margin-right: 10px;"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;经销商作废</button>
            <button id="BtnLocalCanelSign" class="KendoButton size-14" style="margin-right: 10px;"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;波科作废</button>
            <button id="BtnDown" class="KendoButton size-14" style="margin-right: 10px;"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;下载PDF</button>
            <button id="BtnClose" class="KendoButton size-14" style="margin-right: 10px;" onclick="$('#ContractWindow').data('kendoWindow').center().close();"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;关闭</button>
        </div>
     </div>

    <div id="VerificationCodeWindow" style="padding: 0px;display:none;">
         <table style="width: 100%" class="KendoTable">
            <tr style="line-height:1px;">
                <td style="width: 25%;height:1px;">&nbsp;</td>
                <td style="width: 40%;height:1px;">&nbsp;</td>
                <td style="width: 35%;height:1px;">&nbsp;</td>
            </tr>
            <tr>
                <td class="lableControl" style="padding: 2px 10px 2px 10px !important;">
                    <label class="lableControl">短信验证码：</label></td>
                <td>
                    <input type="text" class="k-textbox" id="txtVerificationCode" /></td>
                <td>
                    <button id="BtnSendCode" class="size-14"><i class="fa fa-send-o"></i>发送验证码</button>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <label id="labelVerifiactionPhone" class="lableControl" ></label>
                </td>
            </tr>
         </table>
         <div class="col-xs-12" style="position: absolute;bottom: 0;padding: 0px; height: 40px; line-height: 30px; bottom: 0px; text-align: right; background-color: #f5f5f5; border-top: solid 1px #ccc;">
             <button id="BtnSubmtSign" class="KendoButton size-14" style="margin-right: 10px;"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;确认</button>
             <button id="BtnClose1" class="KendoButton size-14" style="margin-right: 10px;" onclick="$('#VerificationCodeWindow').data('kendoWindow').center().close();"><i class='fa fa-window-close'></i>&nbsp;&nbsp;关闭</button>
        </div>
     </div>

    <div id="HistoryWindow" style="padding: 0px;display:none;">
         <div id="divHistory" style="margin: 10px;">
         </div>
         <div class="col-xs-12" style="position: absolute;bottom: 0;padding: 0px; height: 40px; line-height: 30px; bottom: 0px; text-align: right; background-color: #f5f5f5; border-top: solid 1px #ccc;">
            <button class="KendoButton size-14" style="margin-right: 10px;" onclick="$('#HistoryWindow').data('kendoWindow').center().close();"><i class='fa fa-window-close'></i>&nbsp;&nbsp;关闭</button>
        </div>
     </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript">
        function GetModel(methodName) {
            var reqData = {
                DealerId: $("#hiddenDealerId").val(),
                AccountUid: $("#hiddenAccountUId").val(),
                DealerName: $("#txtDealerName").val(),
                Code: $("#txtVerificationCode").val(),
                FileSrcPath: '',
                FileSrcName: '',
                ApplyId: $("#hiddenApplyId").val(),
                FileId: $("#hiddenFileId").val()
            }
            var data = {
                Function: "EnterpriseSign",
                Method: methodName,
                ReqData: JSON.stringify(reqData)
            }
            return data;
        }

        $(document).ready(function () {
            $("#BtnSearch").FrameButton({
                onClick: function () {
                    bindGrid();
                }
            });

            $("#BtnFileDigest").FrameButton({
                onClick: function () {
                    var data = GetModel('FileDigest');

                    showLoading();
                    submitAjax(Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandlerDemo.ashx", data, function (model) {

                        showAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '文档保全上传成功!'
                        });

                        hideLoading();
                    });
                }
            }); 

            $("#BtnSign").FrameButton({
                onClick: function () {
                    
                    $('#hiddenSignType').val("Sign");
                    $("#labelVerifiactionPhone").html("");
                    $('#txtVerificationCode').val("");
                    $('#VerificationCodeWindow').data('kendoWindow').center().open();
                }
            });

            $("#BtnDown").FrameButton({
                onClick: function () {

                }
            }); 

            $("#BtnClose").FrameButton({
                onClick: function () {

                    $('#VerificationCodeWindow').data('kendoWindow').center().close();
                }
            }); 

            $("#BtnLocalSign").FrameButton({
                onClick: function () {
                    var data = GetModel('LocalSign');

                    showLoading();
                    submitAjax(Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandlerDemo.ashx", data, function (model) {

                        showConfirm({
                            target: 'top',
                            alertType: 'info',
                            message: '签章成功',
                            confirmCallback: function () {
                                var d = JSON.parse(model.ResData);
                                previewPdf(d.FileSrcPath, d.FileSrcName);
                            },
                            cancelCallback: function () {
                                $('#ContractWindow').data('kendoWindow').center().close();
                            },
                            confirmLabel: '继续预览合同',
                            cancelLabel: '返回主页面'
                        });

                        hideLoading();
                    });
                }
            });

            $("#BtnCanelSign").FrameButton({
                onClick: function () {

                    $('#hiddenSignType').val("CanelSign");
                    $("#labelVerifiactionPhone").html("");
                    $('#txtVerificationCode').val("");
                    $('#VerificationCodeWindow').data('kendoWindow').center().open();
                }
            }); 

            $("#BtnLocalCanelSign").FrameButton({
                onClick: function () {
                    var data = GetModel('LocalCanelSign');

                    showLoading();
                    submitAjax(Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandlerDemo.ashx", data, function (model) {

                        showConfirm({
                            target: 'top',
                            alertType: 'info',
                            message: '作废成功',
                            confirmCallback: function () {
                                var d = JSON.parse(model.ResData);
                                previewPdf(d.FileSrcPath, d.FileSrcName);
                            },
                            cancelCallback: function () {
                                $('#ContractWindow').data('kendoWindow').center().close();
                            },
                            confirmLabel: '继续预览合同',
                            cancelLabel: '返回主页面'
                        });

                        hideLoading();
                    });
                }
            });

            $("#BtnSendCode").FrameButton({
                onClick: function () {
                    var data = GetModel('SendCode');

                    showLoading();

                    submitAjax(Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandlerDemo.ashx", data, function (model) {

                        showAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '发送成功'
                        });

                        $("#labelVerifiactionPhone").html("已向手机号：" + JSON.parse(model.ResData).Phone + " 发送验证码，请查收！");
                        
                        disableSeconds("BtnSendCode", "请稍后", '<i class="fa fa-send-o"></i>发送验证码', 30);
                        
                        hideLoading();
                    });
                    
                }
            });

            $("#BtnSubmtSign").FrameButton({
                onClick: function () {

                    var data = GetModel($('#hiddenSignType').val());

                    $('#VerificationCodeWindow').data('kendoWindow').center().close();
                    showLoading();
                    submitAjax(Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandlerDemo.ashx", data, function (model) {

                        var message = $('#hiddenSignType').val() == "Sign" ? "签章成功" : "作废成功";

                        showConfirm({
                            target: 'top',
                            alertType: 'info',
                            message: message,
                            confirmCallback: function () {
                                var d = JSON.parse(model.ResData);
                                previewPdf(d.FileSrcPath, d.FileSrcName);
                            },
                            cancelCallback: function () {
                                $('#ContractWindow').data('kendoWindow').center().close();
                            },
                            confirmLabel: '继续预览合同',
                            cancelLabel: '返回主页面'
                        });

                        hideLoading();
                    });
                }
            }); 

            $('#ContractWindow').kendoWindow({
                width: 800,
                height: 500,
                modal: true,
                visible: false,
                resizable: true,
                title: '合同预览',
                actions: [
                    "Maximize",
                    "Close"
                    
                ]
            });

            $('#VerificationCodeWindow').kendoWindow({
                width: 390,
                height: 200,
                modal: true,
                visible: false,
                resizable: false,
                title: '短信验证码',
                actions: [
                    "Close"
                ]
            });

            $('#HistoryWindow').kendoWindow({
                width: 600,
                height: 500,
                modal: true,
                visible: false,
                resizable: true,
                title: '签章日志',
                actions: [
                    "Maximize",
                    "Close"

                ]
            });

            hideLoading();

            InitPage();
        });

        function InitPage() {
            showLoading();
            var data = GetModel('Init');
            submitAjax(Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandlerDemo.ashx", data, function (model) {

                var d = JSON.parse(model.ResData)[0];

                if (d != undefined && d != null) {
                    $("#hiddenDealerId").val(d.DmaId);
                    $("#hiddenAccountUId").val(d.AccountUid);
                    $("#txtDealerName").val(d.DealerName);
                }

                bindGrid();

                hideLoading();
            });
        }

        function bindGrid() {
            var dataSource = new kendo.data.DataSource({
                schema: {
                    model: {
                        id: "Id"
                    },
                    data: function (res) {
                        if (res.ResData != undefined) {
                            return $.parseJSON(res.ResData).data;
                        }
                        else {
                            return res;
                        }
                    },
                    total: function (res) {
                        var response = $.parseJSON(res.ResData);
                        return response.total;
                    },
                    parse: function (d) {
                        return d;
                    }, errors: "error"
                },
                batch: true,
                transport: {
                    read: {
                        type: "post",
                        url: Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandlerDemo.ashx",
                        dataType: "json",
                        contentType: "application/json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var data = GetModel("Search");
                            var parameter = {
                                page: options.page,
                                pageSize: options.pageSize,
                                take: options.take,
                                skip: options.skip
                            };

                            var obj = JSON.parse(data.ReqData);
                            obj.page = options.page;
                            obj.pageSize = options.pageSize;
                            obj.take = options.take;
                            obj.skip = options.skip;

                            data.ReqData = kendo.stringify(obj);
                            return kendo.stringify(data);
                        }
                        else if (operation !== "read" && options.models) {
                            return { models: kendo.stringify(options.models) };
                        }
                    }
                },
                pageSize: 10,
                serverPaging: true
            });

            $("#ContractList").kendoGrid({
                dataSource: dataSource,
                resizable: true,
                scrollable: false,
                editable: false,
                columns: [
                    { field: "DealerName", title: "经销商名称", headerAttributes: { "class": "center bold", "title": "经销商名称" } },
                    { field: "ContractNo", title: "合同编号", width: "220px", headerAttributes: { "class": "center bold", "title": "合同编号" } },
                    {
                        title: "签章",
                        field: "edit",
                        template: "<a id=\"showContract\" ><span class=\"fa fa-edit\"></span></a>",
                        width: 50,
                        headerAttributes: { "class": "center bold", "title": "签章" },
                        attributes: { "class": "center", "data-name": "edit" }
                    }, {
                        title: "查看签章日志",
                        field: "show",
                        template: "<a id=\"showHistory\" ><span class=\"fa fa-search\"></span></a>",
                        width: 90,
                        headerAttributes: { "class": "center bold", "title": "查看签章日志" },
                        attributes: { "class": "center", "data-name": "show" }
                    }
                ], pageable: {
                    refresh: true,
                    pageSizes: true
                }, dataBound: function () {

                    $("a[id=showContract]").bind("click", function (e) {
                        var row = $(this).closest("tr"),
                            grid = $("#ContractList").data("kendoGrid"),
                            dataItem = grid.dataItem(row);

                        $("#hiddenApplyId").val(dataItem.Id);
                        $("#hiddenFileId").val(dataItem.Id);
                        previewPdf("/Upload/", "DM-RN-2016-0070-V-20171220-145121.pdf");

                    });

                    $("a[id=showHistory]").bind("click", function (e) {
                        var row = $(this).closest("tr"),
                            grid = $("#ContractList").data("kendoGrid"),
                            dataItem = grid.dataItem(row);

                        bindLog(dataItem.Id, null);
                        $('#HistoryWindow').data('kendoWindow').center().open();
                    });
                }
            });
        }

        function previewPdf(filePath, fileName) {
            var data = GetModel('ShowPdf');
            var o = JSON.parse(data.ReqData);
            o.FileSrcPath = filePath;
            o.FileSrcName = fileName;

            data.ReqData = JSON.stringify(o);

            showLoading();
            submitAjax(Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandlerDemo.ashx", data, function (model) {

                $("#divContractContent").text("");
                var content = "";
                var jsonData = JSON.parse(model.ResData);
                $.each(jsonData, function (index, item) {
                    content = content + TemplateImageHtml(item.imgSrc);
                });

                $("#divContractContent").append(content);
                $('#ContractWindow').data("kendoWindow").center().open();
                hideLoading();
            });
        }

        function TemplateImageHtml(srcUrl) {
            return "<img src='" + srcUrl + "' style='width:100%;'> <br/>";
        }

        function bindLog(applyId, fileId) {
            var dataSource = new kendo.data.DataSource({
                schema: {
                    model: {
                        id: "Id"
                    },
                    data: function (res) {
                        if (res.ResData != undefined) {
                            return $.parseJSON(res.ResData).data;
                        }
                        else {
                            return res;
                        }
                    },
                    total: function (res) {
                        var response = $.parseJSON(res.ResData);
                        return response.total;
                    },
                    parse: function (d) {
                        return d;
                    }, errors: "error"
                },
                batch: true,
                transport: {
                    read: {
                        type: "post",
                        url: Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandlerDemo.ashx",
                        dataType: "json",
                        contentType: "application/json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var data = GetModel("ShowLog");

                            var o = JSON.parse(data.ReqData);

                            o.ApplyId = applyId;
                            o.FileId = fileId;

                            data.ReqData = JSON.stringify(o);

                            return kendo.stringify(data);
                        }
                        else if (operation !== "read" && options.models) {
                            return { models: kendo.stringify(options.models) };
                        }
                    }
                }
            });

            $("#divHistory").kendoGrid({
                dataSource: dataSource,
                resizable: true,
                scrollable: false,
                editable: false,
                columns: [
                    { field: "CreateUserName", title: "操作人", headerAttributes: { "class": "center bold", "title": "操作人" } },
                    { field: "CreateDate", title: "操作时间", width: "200px", headerAttributes: { "class": "center bold", "title": "操作时间" } },
                    { field: "Version", title: "版本号", width: "100px", headerAttributes: { "class": "center bold", "title": "版本号" } }
                ], dataBound: function () {

                }
            });
        }

        //倒数秒
        function disableSeconds(buttonId, changingValue, changedValue, seconds) {
            $("#" + buttonId).attr("disabled", "disabled");
            for (i = 0; i <= seconds; i++) {
                window.setTimeout("updateSeconds('" + buttonId + "','" + changingValue + "','" + changedValue + "'," + seconds + "," + i + ")", i * 1000);
            }
        }

        function updateSeconds(buttonId, changingValue, changedValue, seconds, num) {
            var printnr;
            if (num == seconds) {
                $("#" + buttonId).html(changedValue);
                $("#" + buttonId).attr("disabled", false);
            }
            else {
                printnr = seconds - num;
                $("#" + buttonId).html(changingValue + " (" + printnr + ")");
            }
        }

    </script>
</asp:Content>