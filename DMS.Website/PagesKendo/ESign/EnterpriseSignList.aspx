<%@ Page Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="EnterpriseSignList.aspx.cs" Inherits="DMS.Website.PagesKendo.ESign.EnterpriseSignList" %>


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
        .cursor {
            cursor: pointer;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main">
        <input type="hidden" id="hiddenApplyId" />
        <input type="hidden" id="hiddenFileId" />
        <input type="hidden" id="hiddenDealerId" />
        <input type="hidden" id="hiddenDealerName" />
        <input type="hidden" id="hiddenAccountUId" />
        <input type="hidden" id="hiddenLegalAccountUid" />
        <input type="hidden" id="hiddenFileSrcPath" />
        <input type="hidden" id="hiddenFileSrcName" />
        <input type="hidden" id="hiddenFileDstPath" />
        <input type="hidden" id="hiddenFileName" />
        <input type="hidden" id="hiddenLastUpdateDate" />
        <input type="hidden" id="hiddenSignType" />
        <input type="hidden" id="hiddenDealerType" />
        <input type="hidden" id="hiddenContractDealerType" />
        <input type="hidden" id="hiddenContractID" />
        <input type="hidden" id="hiddenContractType" />
        <input type="hidden" id="hiddenDeptId" />
        <input type="hidden" id="hiddenHasSignRole" />
        <input type="hidden" id="hiddenDealerMasterType" />
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
                        <%--  <div id="QryCCNameCN" class="FrameControl"></div>--%>
                        <input type="text"  class="k-input" style="width:478.2px;"  id="txtDealerName"/></td>
                   
                    <td>
                        <label class="lableControl">合同号：</label></td>
                    <td>
                        <input type="text" class="k-textbox" style="width:478.2px;" id="txtContractNo" /></td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl">合同生成时间 始：</label></td>
                    <td>
                        <table style="width:100%" >
                            <tr>
                                <td style="width:45%;padding:0;"><input type="text" class="k-input" style="width:195px;" id="txtBeginDate" /></td>
                                <td style="width:10%"><label class="lableControl">至</label></td>
                                <td style="width:45%;padding:0;"><input type="text" class="k-input" style="width:195px;" id="txtEndDate" /></td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <label class="lableControl">合同状态：</label></td>
                    <td>
                        <input type="text" class="k-input" style="width:478.2px;" id="txtStatus" /></td>
                </tr>
                <tr>
                     <td class="lableControl">
                        <label class="lableControl">产品线：</label></td>
                    <td>
                        <%--  <div id="QryCCNameCN" class="FrameControl"></div>--%>
                        <input type="text"  class="k-input" style="width:478.2px;"  id="txtProductline"/></td>
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
            <button id="BtnSign" class="KendoButton size-14" style="margin-right: 10px; display:none"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;经销商签章</button>
            <button id="BtnLocalSign" class="KendoButton size-14" style="margin-right: 10px;display:none"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;蓝威签章</button>
            <button id="BtnLPSign" class="KendoButton size-14" style="margin-right: 10px;display:none"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;平台签章</button>
            <button id="BtnCanelSign" class="KendoButton size-14" style="margin-right: 10px;display:none"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;经销商作废</button>
            <button id="BtnLocalCanelSign" class="KendoButton size-14" style="margin-right: 10px;display:none"><i class='fa fa-sign-in'></i>&nbsp;&nbsp;蓝威作废</button>
            <button id="BtnDown" class="KendoButton size-14" style="margin-right: 10px;"><i class='fa fa-download'></i>&nbsp;&nbsp;下载PDF</button>
            <button id="BtnClose" class="KendoButton size-14" style="margin-right: 10px;"><i class='fa fa-window-close'></i>&nbsp;&nbsp;关闭</button>
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
             <button id="BtnCloseCodeWin" class="KendoButton size-14" style="margin-right: 10px;" ><i class='fa fa-window-close'></i>&nbsp;&nbsp;关闭</button>
        </div>
     </div>

    <div id="HistoryWindow" style="padding: 0px;display:none;">
         <div id="divHistory" style="margin: 10px;">
         </div>
         <div class="col-xs-12" style="position: absolute;bottom: 0;padding: 0px; height: 40px; line-height: 30px; bottom: 0px; text-align: right; background-color: #f5f5f5; border-top: solid 1px #ccc;">
            <button class="KendoButton size-14 k-button" style="margin-right: 10px;" onclick="$('#HistoryWindow').data('kendoWindow').center().close();"><i class='fa fa-window-close'></i>&nbsp;&nbsp;关闭</button>
        </div>
     </div>

    <div id="ReadFileWindow" style="padding: 0px;display:none;">
        <div id="ReadTemplateList" style="margin: 10px;">
        </div>
        <div class="col-xs-12" style="position: absolute;bottom: 0;padding: 0px; height: 40px; line-height: 30px; bottom: 0px; text-align: right; background-color: #f5f5f5; border-top: solid 1px #ccc;">
            <button class="KendoButton size-14 k-button" style="margin-right: 10px;" onclick="$('#ReadFileWindow').data('kendoWindow').center().close();"><i class='fa fa-window-close'></i>&nbsp;&nbsp;关闭</button>
        </div>
    </div>

    <div id="TrainingWindow" style="padding: 0px;display:none;">
        <div id="TrainingLogList" style="margin: 10px;font-size:12px;">
        </div>
        <div class="col-xs-12" style="position: absolute;bottom: 0;padding: 0px; height: 40px; line-height: 30px; bottom: 0px; text-align: right; background-color: #f5f5f5; border-top: solid 1px #ccc;">
            <button class="KendoButton size-14 k-button" style="margin-right: 10px;" onclick="$('#TrainingWindow').data('kendoWindow').center().close();"><i class='fa fa-window-close'></i>&nbsp;&nbsp;关闭</button>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript">
        var handlerPath = Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandler.ashx";
       $("#hiddenDealerType").val('<%=this._context.User.IdentityType%>');
        var IsLoad = true;
     
        function GetModel(methodName) {
            var reqData = {

                DealerId: $("#hiddenDealerId").val(),
                AccountUid: $("#hiddenAccountUId").val(),
                LegalAccountUid: $("#hiddenLegalAccountUid").val(),
                DealerName: $("#txtDealerName").val(),
                Code: $("#txtVerificationCode").val(),
                FileSrcPath: $("#hiddenFileSrcPath").val(),
                FileSrcName: $("#hiddenFileSrcName").val(),
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

        function bindDownloadFile()
        {
            //重新绑定
            $("#BtnDown").FrameButton({
                onClick: function () {
                    var Url = Common.AppVirtualPath + "PagesKendo/Download.aspx?FilePath=" + $("#hiddenFileDstPath").val() + "&FileName=" + $("#hiddenFileName").val();
                    window.open(Url, "Download");
                }
            });
        }

        $(document).ready(function () {
         
            $("#BtnSearch").FrameButton({
                onClick: function () {
                    bindGrid();
                }
            });

            $("#BtnSign").FrameButton({
                onClick: function () {
                   
                    showConfirm({
                        target: 'top',
                        message: '确定签章？',
                        confirmCallback: function () {

                                    $('#hiddenSignType').val("Sign");
                                    $("#labelVerifiactionPhone").html("");
                                    $('#txtVerificationCode').val("");
                                    $('#VerificationCodeWindow').data('kendoWindow').center().open();
                        }
                    });
                   
                }
            });

            bindDownloadFile();

            $("#BtnClose").FrameButton({
                onClick: function () {

                    $('#ContractWindow').data('kendoWindow').center().close();
                }
            });

            $("#BtnCloseCodeWin").FrameButton({
                onClick: function () {

                    $('#VerificationCodeWindow').data('kendoWindow').center().close();
                }
            });

            $("#txtBeginDate").kendoDatePicker({
                format: "yyyy-MM-dd",
                depth: "month",
                start: "month",
            });

            $("#txtEndDate").kendoDatePicker({
                format: "yyyy-MM-dd",
                depth: "month",
                start: "month",
            });

            $("#BtnLocalSign").FrameButton({
                onClick: function () {
                    showConfirm({
                        target: 'top',
                        message: '确定签章？',
                        confirmCallback: function () {

                            var data = GetModel('LocalSign');

                            showLoading();
                            submitAjax(handlerPath, data, function (model) {

                                showConfirm({
                                    target: 'top',
                                    alertType: 'info',
                                    message: '签章成功',
                                    confirmCallback: function () {
                                        var d = JSON.parse(model.ResData);

                                        //附件信息重新赋值
                                        $("#hiddenFileDstPath").val(d.FileSrcPath + d.FileSrcName);
                                        //$("#hiddenFileName").val(d.ContractNo);

                                        bindDownloadFile();

                                        previewPdf($("#hiddenFileId").val());
                                        $("#BtnLocalSign").hide();
                                        $("#ContractList").data("kendoGrid").dataSource.read();
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
             
                }
            });


            $("#BtnLPSign").FrameButton({
                onClick: function () {
                    showConfirm({
                        target: 'top',
                        message: '确定签章？',
                        confirmCallback: function () {

                            var data = GetModel('LPSign');

                            showLoading();
                            submitAjax(handlerPath, data, function (model) {

                                showConfirm({
                                    target: 'top',
                                    alertType: 'info',
                                    message: '签章成功',
                                    confirmCallback: function () {
                                        var d = JSON.parse(model.ResData);

                                        //附件信息重新赋值
                                        $("#hiddenFileDstPath").val(d.FileSrcPath + d.FileSrcName);
                                        //$("#hiddenFileName").val(d.ContractNo);

                                        bindDownloadFile();

                                        previewPdf($("#hiddenFileId").val());
                                        $("#BtnLPSign").hide();
                                        $("#ContractList").data("kendoGrid").dataSource.read();
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

                }
            });

            $("#BtnCanelSign").FrameButton({
                onClick: function () {
                    showConfirm({
                        target: 'top',
                        message: '确定废弃？',
                        confirmCallback: function () {

                            $('#hiddenSignType').val("CanelSign");
                            $("#labelVerifiactionPhone").html("");
                            $('#txtVerificationCode').val("");
                            $('#VerificationCodeWindow').data('kendoWindow').center().open();
                           
                        }
                    });
                }
            }); 

            $("#BtnLocalCanelSign").FrameButton({
                onClick: function () {

                    showConfirm({
                        target: 'top',
                        message: '确定废弃？',
                        confirmCallback: function () {

                            var data = GetModel('LocalCanelSign');

                            showLoading();
                            submitAjax(handlerPath, data, function (model) {

                                showConfirm({
                                    target: 'top',
                                    alertType: 'info',
                                    message: '作废成功',
                                    confirmCallback: function () {
                                        var d = JSON.parse(model.ResData);

                                        $("#hiddenFileDstPath").val(fileSrcPath);
                                        $("#hiddenFileName").val(fileSrcName);

                                        previewPdf($("#hiddenFileId").val());
                                        $("#ContractList").data("kendoGrid").dataSource.read();
                                    },
                                    cancelCallback: function () {
                                        $('#ContractWindow').data('kendoWindow').center().close();
                                        $("#ContractList").data("kendoGrid").dataSource.read();
                                    },
                                    confirmLabel: '继续预览合同',
                                    cancelLabel: '返回主页面'
                                });

                                hideLoading();
                            });

                        }
                    });
           
                }
            });

            $("#BtnSendCode").FrameButton({
                onClick: function () {
                    var data = GetModel('SendCode');

                    showLoading();

                    submitAjax(handlerPath, data, function (model) {

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
                    submitAjax(handlerPath, data, function (model) {

                        var message = $('#hiddenSignType').val() == "Sign" ? "签章成功" : "作废成功";

                        showConfirm({
                            target: 'top',
                            alertType: 'info',
                            message: message,
                            confirmCallback: function () {
                                var d = JSON.parse(model.ResData);

                                //附件信息重新赋值
                                $("#hiddenFileDstPath").val(d.FileSrcPath + d.FileSrcName);
                                //$("#hiddenFileName").val(d.FileSrcName);
                                
                                bindDownloadFile();

                                previewPdf($("#hiddenFileId").val());
                                $("#BtnSign").hide();
                                $("#ContractList").data("kendoGrid").dataSource.read();
                            },
                            cancelCallback: function () {
                                $('#ContractWindow').data('kendoWindow').center().close();
                                $("#ContractList").data("kendoGrid").dataSource.read();
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
                height: 390,
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

            $('#ReadFileWindow').kendoWindow({
                width: 1000,
                height: 500,
                modal: true,
                visible: false,
                resizable: true,
                title: '阅读文件',
                actions: [
                    "Maximize",
                    "Close"

                ]
            });

            $('#TrainingWindow').kendoWindow({
                width: 500,
                height: 150,
                modal: true,
                visible: false,
                resizable: true,
                title: '培训记录',
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
        
            if ($("#hiddenDealerType").val() != "User") {
                var data = GetModel('Init');

                submitAjax(handlerPath, data, function (model) {

                    //var d = JSON.parse(model.ResData)[0];
                    var d = JSON.parse(model.ResData);
                    console.log(d);

                    if (d != undefined && d != null) {

                        $("#hiddenDealerId").val(d.Id);
                        //$("#hiddenAccountUId").val(d.AccountUid);
                        //$("#hiddenDealerName").val(d.ChineseName);
                        //$("#txtDealerName").val(d.DealerName);
                    }
                    bindDealerLsit();

                    hideLoading();
                });
            }
            else {
                bindDealerLsit();
                hideLoading();
            }
         
        }
        function bindDealerLsit() {

            
            $("#txtDealerName").kendoComboBox({
                placeholder: "--请选择经销商--",
                dataTextField: "ShortName",
                dataValueField: "Id",
                filter: "contains",
                dataSource: {},
     
            });
   
            $("#txtStatus").kendoComboBox({
                placeholder: "--请选择产状态--",
                dataTextField: "Value",
                dataValueField: "Key",
                filter: "contains",
                dataSource: {},

            });
            $("#txtProductline").kendoComboBox({
                placeholder: "--请选择产品线--",
                dataTextField: "ProductLineName",
                dataValueField: "DivisionCode",
                filter: "contains",
                dataSource: {},

            });
            
            var data = GetModel("InitQuery");

            submitAjax(handlerPath, data, function (model) {
                var Obj = $.parseJSON(model.ResData);
             
               // $('#QryCCNameCN').FrameDropdownList('setDataSource', Obj.ResDelaer);
                 $("#txtDealerName").data("kendoComboBox").setDataSource(Obj.ResDelaer);

                 $("#txtStatus").data("kendoComboBox").setDataSource(Obj.SingStatus);
                 $("#txtProductline").data("kendoComboBox").setDataSource(Obj.ProductLineName);
                 var DealerType = $("#hiddenDealerType").val();
                 $("#hiddenDealerMasterType").val(Obj.DealerType);
                 if (DealerType == "Dealer") {

                 if (Obj.DealerType == "T1" || Obj.DealerType == "T2") {
                     //$("#txtDealerName").data("kendoComboBox").value("All")
                     $("#txtDealerName").data("kendoComboBox").value()
                     $("#txtDealerName").data("kendoComboBox").value($("#hiddenDealerId").val().toUpperCase())
                     $("#txtDealerName").data("kendoComboBox").readonly(true);
                 }
                 else if (Obj.DealerType == "LP" || Obj.DealerType == "LS") {
                 
                     $("#txtDealerName").data("kendoComboBox").value("All")
                 }
                 }
                 else {
                     $("#txtDealerName").data("kendoComboBox").value("All")
                 }

                 $("#hiddenHasSignRole").val(Obj.hasSignRole);

                 bindGrid();
            })
        };

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
                        url: handlerPath,
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
                            obj.DealerId = $("#txtDealerName").data("kendoComboBox").value();
                            obj.page = options.page;
                            obj.pageSize = options.pageSize;
                            obj.take = options.take;
                            obj.skip = options.skip;
                            obj.BeginDate = $("#txtBeginDate").data("kendoDatePicker").value();
                            obj.EndDate = $("#txtEndDate").data("kendoDatePicker").value();
                            obj.ProductLine = $("#txtProductline").data("kendoComboBox").value();
                            obj.ContractNo = $("#txtContractNo").val();
                            obj.ContractStatus = $("#txtStatus").val();
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
                    { field: "DMA_ChineseName", title: "经销商名称", headerAttributes: { "class": "center bold", "title": "经销商名称" } },
                    { field: "ContractNo", title: "合同编号", width: 170, headerAttributes: { "class": "center bold", "title": "合同编号" } },
                    { field: "VersionNo", title: "合同版本", width: 170, headerAttributes: { "class": "center bold", "title": "合同版本" } },
                    { field: "ContractType", title: "合同类型", width: 170, headerAttributes: { "class": "center bold", "title": "合同类型" } },
                    { field: "SubProductName", title: "产品线", width: 170, headerAttributes: { "class": "center bold", "title": "产品线" } },
                    { field: "DeptName", title: "部门", width: 170, headerAttributes: { "class": "center bold", "title": "部门" } },
                    { field: "StatusName", title: "状态", width: 120, headerAttributes: { "class": "center bold", "title": "合同编号" } },
                    {
                        title: "签章",
                        field: "sign",
                        template: "# if($('\\#hiddenHasSignRole').val().toUpperCase() == 'TRUE') { # <a id=\"showContract\" ><span class=\"fa fa-edit cursor\"></span></a> #} else {# <i></i> #}#",
                        width: 50,
                        headerAttributes: { "class": "center bold", "title": "签章" },
                        attributes: { "class": "center", "data-name": "sign" }
                    }, {
                        title: "下载",
                        field: "download",
                        template: "<a id=\"showDownload\" ><span class=\"fa fa-download cursor\"></span></a>",
                        width: 50,
                        headerAttributes: { "class": "center bold", "title": "下载" },
                        attributes: { "class": "center", "data-name": "download" }
                    }, {
                        title: "阅读文件",
                        field: "read",
                        template: "#if(((DMA_DealerType=='T1' || DMA_DealerType=='T2')&&ContractType != 'Amendment'&&ContractType != 'Termination')||(DMA_DealerType=='LP'&&ContractType!='Amendment')){#<a id=\"ShowReadFile\" ><span class=\"fa fa-search cursor\"></span></a>#} else {# <i></i> #}#",
                        width: 70,
                        headerAttributes: { "class": "center bold", "title": "查看阅读文件" },
                        attributes: { "class": "center", "data-name": "read" }
                    }, {
                        title: "签章日志",
                        field: "log",
                        template: "<a id=\"showHistory\" ><span class=\"fa fa-search cursor\"></span></a>",
                        width: 70,
                        headerAttributes: { "class": "center bold", "title": "查看签章日志" },
                        attributes: { "class": "center", "data-name": "log" }
                    }, {
                        title: "培训状态",
                        field: "training",
                        template: "#if((ContractType == 'Appointment' || ContractType == 'Renewal') && VersionStatus=='WaitBscSign') { # <a id=\"showTraining\" ><span class=\"fa fa-search cursor\"></span></a># } else { # <i></i> #}#",
                        width: 70,
                        headerAttributes: { "class": "center bold", "title": "查看经销商培训状态" },
                        attributes: { "class": "center", "data-name": "training" }
                    }
                ], pageable: {
                    refresh: true,
                    pageSizes: true
                }, dataBound: function () {

                    $("a[id=showContract]").bind("click", function (e) {
                        var row = $(this).closest("tr"),
                            grid = $("#ContractList").data("kendoGrid"),
                            dataItem = grid.dataItem(row);

                        var model = $.getModel();
                        model.DealerId = dataItem.DMA_ID;
                        model.ContractId = dataItem.ContractId;
                        model.DealerType = dataItem.DMA_DealerType;
                        model.ContractType = dataItem.ContractType;
                        model.VisionStatus = dataItem.VersionStatus;
                        model.DeptId = dataItem.DivisionCode;
                        model.Method = 'IsReadFile';
                        var data = model;

                        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
                            
                                if (model.IsRead == false) {

                                    showAlert({
                                        target: 'top',
                                        alertType: 'info',
                                        message: '请先阅读文件，再签章',
                                    });
                                    hideLoading();
                                }
                            
                           
                            else if (model.TraningOneStatus == false || model.TraningTwoStatus == false) {

                                showAlert({
                                    target: 'top',
                                    alertType: 'info',
                                    message: '经销商在90天内没有培训通过记录',
                                });
                                hideLoading();
                            }
                            else
                            {
                                var IsSinge = dataItem.IsSinge;
                                $("#hiddenDealerId").val('');
                                $("#hiddenDealerId").val(dataItem.DMA_ID);
                                $("#hiddenApplyId").val(dataItem.ContractId);
                                $("#hiddenFileId").val(dataItem.ExportId);
                                $("#hiddenFileSrcPath").val('');
                                $("#hiddenFileSrcName").val('');
                                $("#hiddenFileDstPath").val('');
                                $("#hiddenFileName").val('');
                                $("#hiddenFileSrcPath").val(dataItem.FileSrcPath + '/');
                                $("#hiddenFileSrcName").val(dataItem.FileSrcName);
                                $("#hiddenFileDstPath").val(dataItem.UploadFilePath);
                                $("#hiddenFileName").val(dataItem.FileSrcName);
                                previewPdf($("#hiddenFileId").val(), dataItem.VersionStatus, dataItem.DMA_ChineseName,model.DealerName);
                            }
                        });
                    });

                    $("a[id=showHistory]").bind("click", function (e) {
                        var row = $(this).closest("tr"),
                            grid = $("#ContractList").data("kendoGrid"),
                            dataItem = grid.dataItem(row);

                        bindLog(dataItem.ContractId, null);
                        $('#HistoryWindow').data('kendoWindow').center().open();
                    });

                    $("a[id=ShowReadFile]").bind("click", function (e) {

                        var row = $(this).closest("tr"),
                            grid = $("#ContractList").data("kendoGrid"),
                            dataItem = grid.dataItem(row);
                        var model = $.getModel();
                        model.ContractId = dataItem.ContractId;
                        model.DealerType = dataItem.DMA_DealerType;
                        model.ContractType = dataItem.ContractType;
                        model.DeptId = dataItem.DivisionCode;
                        model.Method = 'GetReadTemplateList';
                        var data = model;
                        $("#hiddenContractDealerType").val(dataItem.DMA_DealerType)
                        $("#hiddenContractID").val(dataItem.ContractId)
                        $("#hiddenContractType").val(dataItem.ContractType)
                        $("#hiddenDeptId").val(dataItem.DivisionCode)
                        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {

                            createReadRedTemplate(model);
                        });
                        
                        $('#ReadFileWindow').data('kendoWindow').center().open();
                    });

                    $("a[id=showDownload]").bind("click", function (e) {
                        var row = $(this).closest("tr"),
                            grid = $("#ContractList").data("kendoGrid"),
                            dataItem = grid.dataItem(row);

                        var Url = Common.AppVirtualPath + "PagesKendo/Download.aspx?FilePath=" + dataItem.UploadFilePath + "&FileName=" + dataItem.FileName;
                        window.open(Url, "Download");
                    });

                    $("a[id=showTraining]").bind("click", function (e) {
                        var row = $(this).closest("tr"),
                            grid = $("#ContractList").data("kendoGrid"),
                            dataItem = grid.dataItem(row);

                        var model = $.getModel();
                        model.DealerId = dataItem.DMA_ID;
                        model.DealerType = dataItem.DMA_DealerType;
                        model.ContractType = dataItem.ContractType;
                        model.VisionStatus = dataItem.VersionStatus;
                        model.Method = 'TrainingInfo';
                        var data = model;

                        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {

                            TrainingLogList.innerHTML = model.TraningResult;
                            $('#TrainingWindow').data('kendoWindow').center().open();
                            hideLoading();
                        });
                    });
                }
            });
        }

        function previewPdf(ExportId, VersionStatus,DealerName,MdDealerName) {
            var data = GetModel('ShowPdf');
            var DealerType = $("#hiddenDealerType").val();
            
            //alert(DealerName+'-'+MdDealerName)
            //alert(VersionStatus + '-' + DealerType)
            if (VersionStatus == 'WaitDealerSign') {
                if (DealerType == "Dealer") {
                   
                    $("#BtnLocalSign").hide();
                    $("#BtnCanelSign").hide();
                    $("#BtnLocalCanelSign").hide();
                    if (DealerName == MdDealerName) {
                        $("#BtnSign").show();
                    }
                    else {
                        $("#BtnSign").hide();
                    }
                    
                    
                }
                else {
                    $("#BtnSign").hide();
                    $("#BtnLocalSign").hide();
                    $("#BtnCanelSign").hide();
                    $("#BtnLocalCanelSign").hide();
                }
            }
         

            if (VersionStatus == 'WaitBscSign') {
            
                if (DealerType == "User") {
                    $("#BtnSign").hide();
                    $("#BtnLocalSign").show();
                    //LP
                    //$("#BtnLPSign").show();

                    $("#BtnCanelSign").hide();
                    $("#BtnLocalCanelSign").hide();
                }
                else {
                    $("#BtnSign").hide();
                    $("#BtnLocalSign").hide();
                    $("#BtnCanelSign").hide();
                    $("#BtnLocalCanelSign").hide();
                }
               
            }
          
            if (VersionStatus == 'WaitLPSign') {
                if (DealerType == "Dealer")
                {
                    if ($("#hiddenDealerMasterType").val() == "LP" || $("#hiddenDealerMasterType").val() == "LS") {
                        $("#BtnSign").hide();
                        //$("#BtnLocalSign").show();
                        //LP
                        $("#BtnLPSign").show();

                        $("#BtnCanelSign").hide();
                        $("#BtnLocalCanelSign").hide();
                    }
                    else {
                        $("#BtnSign").hide();
                        $("#BtnLocalSign").hide();
                        $("#BtnCanelSign").hide();
                        $("#BtnLocalCanelSign").hide();
                    }
                }
                else {
                    $("#BtnSign").hide();
                    $("#BtnLocalSign").hide();
                    $("#BtnCanelSign").hide();
                    $("#BtnLocalCanelSign").hide();
                }

            }

         
            if (VersionStatus == 'Complete') {
                if (DealerType == "User") {
                    $("#BtnSign").hide();
                    $("#BtnLocalSign").hide();
                    $("#BtnCanelSign").hide();
                    $("#BtnLocalCanelSign").show();
                }
                else {
                    $("#BtnSign").hide();
                    $("#BtnLocalSign").hide();
                    $("#BtnCanelSign").hide();
                    $("#BtnLocalCanelSign").hide();
                }
               
            }
           

            if (VersionStatus == 'WaitDealerAbandonment') {
                if (DealerType == "Dealer") {
                    $("#BtnSign").hide();
                    $("#BtnLocalSign").hide();
                    $("#BtnCanelSign").show();
                    $("#BtnLocalCanelSign").hide();
                }
                else {
                    $("#BtnSign").hide();
                    $("#BtnLocalSign").hide();
                    $("#BtnCanelSign").hide();
                    $("#BtnLocalCanelSign").hide();
                }
               
            }
            if (VersionStatus == 'Abandonment') {
              
                $("#BtnSign").hide();
                $("#BtnLocalSign").hide();
                $("#BtnCanelSign").hide();
                $("#BtnLocalCanelSign").hide();
            }
            if (VersionStatus == "Cancelled")
            {
                $("#BtnSign").hide();
                $("#BtnLocalSign").hide();
                $("#BtnCanelSign").hide();
                $("#BtnLocalCanelSign").hide();
            }
            
           

            showLoading();
            submitAjax(handlerPath, data, function (model) {

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

        var createReadRedTemplate = function (model) {
            $("#ReadTemplateList").kendoGrid({
                dataSource: model.QryList,
                sortable: false,
                resizable: false,
                scrollable: false,
                columns: [

                     {
                         field: "IsRequired", title: "必读", width: '60',
                         headerAttributes: { "class": "center bold", "title": "必读" }
                     },
                    {
                        field: "DocumentName", title: "阅读文件",
                        headerAttributes: { "class": "center bold", "title": "阅读文件" }
                    },
                     {
                         field: "ReadUserName", title: "阅读人", width: '90',
                         headerAttributes: { "class": "center bold", "title": "阅读人" }
                     },
                    {
                        field: "ReadDate", title: "阅读时间", width: '170',
                        headerAttributes: { "class": "center bold", "title": "阅读时间" }
                    },
                    {
                        field: "Confirm", title: "确认阅读", width: '60',
                        headerAttributes: { "class": "center bold", "title": "确认阅读" },
                        template: "#if(Confirm == null){#<i class='fa fa-file-pdf-o' style='font-size: 14px; cursor: pointer;' name='Confirm'></i>#} else {# <i></i> #}#",
                        attributes: {
                            "class": "center"
                        }

                    },
                    {
                        title: "下载", width: "60",
                        headerAttributes: {
                            "class": "center bold"
                        },
                        template: "<a id='bb' href='' download><i class='fa fa-cloud-download' style='font-size: 14px; cursor: pointer;' name='Download'></i></a>",
                        attributes: {
                            "class": "center"
                        }
                    }
                ],
                pageable: {
                    refresh: false,
                    pageSizes: false,
                    pageSize: 20,
                    input: true,
                    numeric: false
                },
                dataBound: function (e) {
                    var grid = e.sender;
                    //var curWwwPath = window.document.location.href;
                    //var pathName = window.document.location.pathname;
                    //var pos = curWwwPath.indexOf(pathName);
                    //var localhostPaht = curWwwPath.substring(0, pos);

                    $("#ReadTemplateList").find("i[name='Download']").bind('click', function (e) {
                        var tr = $(this).closest("tr");
                        var data = grid.dataItem(tr);

                        $("#bb", tr).attr("href", Common.AppVirtualPath + data.DocumentFile);
                    });

                    $("#ReadTemplateList").find("i[name='Confirm']").bind('click', function (e) {
                        //var tr = $(this).closest("tr")
                        //var Item = grid.dataItem(tr);

                        var row = $(this).closest("tr"),
                           grid = $("#ReadTemplateList").data("kendoGrid"),
                           dataItem = grid.dataItem(row);
                        

                        //var data = that.GetModel('InsertDetail');
                        //data.ReadID = Item.ReadId;

                        var model = $.getModel();
                        model.ContractId = $("#hiddenContractID").val();
                        model.DealerType = $("#hiddenContractDealerType").val();
                        model.ContractType = $("#hiddenContractType").val();
                        model.DeptId = $("#hiddenDeptId").val();
                        model.ReadID = dataItem.ReadId;
                        model.Method = 'InsertDetail';
                        var data = model;

                        showConfirm({
                            target: 'top',
                            message: '确定阅读吗？',
                            confirmCallback: function () {
                                submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
                                    //showAlert({
                                    //    target: 'top',
                                    //    alertType: 'info',
                                    //    message: "阅读成功",
                                    //    callback: function () {

                                    //    }
                                    //});
                                    createReadRedTemplate(model)
                                    hideLoading();
                                });
                            }
                        });
                    });
                }
            });
        }

        function bindLog(applyId, fileId) {
            var dataSource = new kendo.data.DataSource({
                schema: {
                    model: {
                        id: "Id",
                        fields: {
                            Id: { editable: false, nullable: true },
                            CreateUserName: {type: "string" },
                            CreateDate: { type: "date" },
                            Version: {  type: "string" },
                        }
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
                        url: handlerPath,
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
                    { field: "CreateDate", title: "操作时间", width: "200px", headerAttributes: { "class": "center bold", "title": "操作时间" }, format: "{0: yyyy-MM-dd HH:mm:ss}" },
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