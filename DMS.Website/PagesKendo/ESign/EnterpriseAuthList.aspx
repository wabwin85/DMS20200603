<%@ Page Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="EnterpriseAuthList.aspx.cs" Inherits="DMS.Website.PagesKendo.ESign.EnterpriseAuthList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">
    <style>
        .k-textbox {
            width: 100%;
        }

        .requiredHidden {
            color: #fff !important;
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main">
        <input type="hidden" id="hiddenDealerId" />
        <input type="hidden" id="hiddenSubDealerId" />
        <input type="hidden" id="hiddenAccountUId" />
        <input type="hidden" id="hiddenLastUpdateDate" />
        <input type="hidden" id="hiddenStatus" />
        <input type="hidden" id="hiddenPayStatus" />
        <div class="content-row" style="padding: 10px 10px 0px 10px;">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;企业实名认证</h3>
                </div>
            </div>
        </div>
        <div class="panel-body" id="PnlInfo">
            <table style="width: 100%" class="KendoTable">
                <tr style="line-height:1px;">
                    <td style="width: 100px;height:1px;">&nbsp;</td>
                    <td style="width: 80%;height:1px;">&nbsp;</td>
                </tr>
                <tr>
                    <td class="lableControl">
                        <label class="lableControl"><span class="required">*</span>&nbsp; 经销商：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtDealerName" disabled="disabled" />
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 企业名称：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtOrganName" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 企业注册类型：</label></td>
                    <td>
                        <label class="radio-inline">
                            <input type="radio" name="enterpriseRegisterTypeRadios" id="enterpriseRegisterType1" value="0" checked >统一社会信用代码
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="enterpriseRegisterTypeRadios" id="enterpriseRegisterType2" value="1" >组织机构代码号
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="enterpriseRegisterTypeRadios" id="enterpriseRegisterType3" value="2" >工商注册号
                        </label>    
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; <span id="labelOrganCode">统一社会信用代码</span>：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtOrganCode" />
                    </td>
                </tr>
                <tr id="trLegalName" >
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 法定代表姓名：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtLegalName" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required requiredHidden" style="color:#fff;">*</span>&nbsp; 法定代表身份证号：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtLegalIdNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 对公账户户名：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtAccountName" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 企业对公银行账号：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtCardNo" />
                    </td>
                </tr>
                <tr>
                    <td style="padding-right:0;">
                        <table style="width:100%;" >
                            <tr>
                                <td style="width:100%;padding: 0;"><label class="lableControl"><span class="required">*</span>&nbsp; 开户行名称：</label></td>
                                <td style="width:10px;padding: 0;cursor: pointer;"><i id="linkQueryBank" class='fa fa-search' onclick="$('#BankSearchWindow').data('kendoWindow').center().open();bindBank();" ></i></td>
                            </tr>
                        </table>
                    <td>
                        <input type="text" class="k-textbox" id="txtBank" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 开户行支行全称：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtSubBranch" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 开户行所在省份：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtProvice" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 开户行所在城市：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtCity" disabled="disabled" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 开户行的大额行号：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtPrcptcd" disabled="disabled" />
                    </td>
                </tr>
                <tr id="payMoneyTr" style="display:none;">
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 验证打款金额：</label></td>
                    <td>
                        <input id="txtPayMoney" style="width:250px;text-align:left;" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span style="color:#fff;">*</span>&nbsp; 企业认证状态：</label></td>
                    <td>
                        <label id="labelAuth" class="lableControl" style="width:350px;text-align:left;" ></label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="text-align: right; height: 40px; ">
                            <button id="BtnRealName" class="size-14"><i class="fa fa-hand-pointer-o"></i>&nbsp;&nbsp;提交实名认证请求&nbsp;</button>
                            <button id="BtnPaySubmit" class="size-14" hidden><i class="fa fa-hand-pointer-o"></i>&nbsp;&nbsp;打款金额认证&nbsp;</button>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div id="BankSearchWindow" style="padding: 0px;display:none;">
        <input type="hidden" id="selBankForDialog" />
        <table style="width: 100%" class="KendoTable">
            <tr>
                <td style="width: 150px;height:1px;">
                    <label class="lableControl"><span class="required">*</span>&nbsp; 开户行名称：</label></td>
                <td style="width: 30%;height:1px;">
                    <input type="text" class="k-textbox" id="txtWinBankName" />
                </td>
                <td style="width: 150px;height:1px;">
                    <label class="lableControl"><span class="required">*</span>&nbsp; 开户行支行名称：</label></td>
                <td style="width: 30%;height:1px;">
                    <input type="text" class="k-textbox" id="txtWinSubBranch" />
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <div style="text-align: right; height: 40px; ">
                        <button id="BtnQueryBank" class="size-14"><i class="fa fa-hand-pointer-o"></i>&nbsp;&nbsp;查询&nbsp;</button>
                    </div>
                </td>
            </tr>
        </table>
        <div id="divBank" style="margin: 10px;">
        </div>
        <div class="col-xs-12" style="position: absolute;bottom: 0;padding: 0px; height: 40px; line-height: 30px; bottom: 0px; text-align: right; background-color: #f5f5f5; border-top: solid 1px #ccc;">
            <button id="BtnBankSubmit" class="KendoButton size-14" style="margin-right: 10px;" ><i class='fa fa-hand-pointer-o'></i>&nbsp;&nbsp;确认</button>
            <button id="BtnBankClose" class="KendoButton size-14" style="margin-right: 10px;" ><i class='fa fa-window-close'></i>&nbsp;&nbsp;关闭</button>
        </div>
     </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript">
        var handlerPath = Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandler.ashx";
        var authResultDict = {"Wait" : "等待实名认证"
            , "RealNameSuccess" : "实名认证通过"
            , "RealNameError" : "实名认证错误"
            , "PayAuthSuccss" : "打款成功（等待用户回填打款金额）"
            , "PayAuthError" : "打款失败"
            , "Normal" : "已完成企业实名认证"};

        function GetModel(methodName) {
            var reqData = {
                DealerId: $("#hiddenDealerId").val(),
                SubDealerId: $("#hiddenSubDealerId").val(),
                DealerName: $("#txtDealerName").val(),
                AccountUid: $("#hiddenAccountUId").val(),
                OrganName: $("#txtOrganName").val(),
                ResisterType: $('input[name="enterpriseRegisterTypeRadios"]:checked').val(),
                OrganCode: $("#txtOrganCode").val(),
                LegalName: $("#txtLegalName").val(),
                LegalIdNo: $("#txtLegalIdNo").val(),
                AccountName: $("#txtAccountName").val(),
                CardNo: $("#txtCardNo").val(),
                Bank: $("#txtBank").val(),
                SubBranch: $("#txtSubBranch").val(),
                Provice: $("#txtProvice").val(),
                City: $("#txtCity").val(),
                Prcptcd: $("#txtPrcptcd").val(),
                PayMoney: $("#txtPayMoney").val()
            }
            var data = {
                Function: "EnterpriseAuth",
                Method: methodName,
                LastUpdateDate: $("#hiddenLastUpdateDate").val(),
                ReqData: JSON.stringify(reqData)
            }
            return data;
        }

        function GetToolModel(methodName) {
            var reqData = {
                BankName: $("#txtWinBankName").val(),
                SubBranch: $("#txtWinSubBranch").val()
            }
            var data = {
                Function: "EnterpriseTool",
                Method: methodName,
                ReqData: JSON.stringify(reqData)
            }
            return data;
        }

        $(document).ready(function () {
            $('input[name="enterpriseRegisterTypeRadios"]').change(function () {
                enterpriseRegisterTypeRadiosChange($(this).val());
            });
            
            $("#BtnRealName").FrameButton({
                onClick: function () {
                    SubmitRealName();
                }
            });

            $("#BtnPaySubmit").FrameButton({
                onClick: function () {
                    SubmitPayAuth();
                }
            });
            
            $("#txtPayMoney").kendoNumericTextBox({
                decimals: 2,
                format: "n",
                max: 1,
                min: 0,
                spinners: true,
                step: 0.01
            });

            $('#BankSearchWindow').kendoWindow({
                width: 790,
                height: 500,
                modal: true,
                visible: false,
                resizable: false,
                title: '开户行查询',
                actions: [
                    "Close"
                ]
            });

            $("#BtnQueryBank").FrameButton({
                onClick: function () {
                    bindBank();
                }
            }); 

            $("#BtnBankSubmit").FrameButton({
                onClick: function () {
                    setSelBankContent();
                }
            });

            $("#BtnBankClose").FrameButton({
                onClick: function () {
                    $('#BankSearchWindow').data('kendoWindow').center().close();
                }
            });

            hideLoading();

            InitPage();
        });

        function InitPage() {
            showLoading();
            var data = GetModel('Init');

            submitAjax(handlerPath, data, function (model) {

                var obj = JSON.parse(model.ResData)[0];
                if (obj != undefined && obj != null) {

                    var registerType;

                    $("#hiddenLastUpdateDate").val(obj.CreateDate);

                    $("#hiddenDealerId").val(obj.DmaId);
                    $("#hiddenSubDealerId").val(obj.ParentDmaId);

                    $("#txtDealerName").val(obj.DealerName);
                    $("#txtOrganName").val(obj.Name);
                    if (obj.UscCode != null && obj.UscCode != "") {
                        $("#enterpriseRegisterType1").attr("checked", true);
                        $("#txtOrganCode").val(obj.UscCode);
                        registerType = "0";
                    }
                    else if (obj.OrgCode != null && obj.OrgCode != "") {
                        $("#enterpriseRegisterType2").attr("checked", true);
                        $("#txtOrganCode").val(obj.OrgCode);
                        registerType = "1";
                    }
                    else if (obj.RegCode != null && obj.RegCode != "") {
                        $("#enterpriseRegisterType3").attr("checked", true);
                        $("#txtOrganCode").val(obj.RegCode);
                        registerType = "2";
                    }

                    enterpriseRegisterTypeRadiosChange(registerType);

                    $("#txtLegalName").val(obj.LegalName);
                    $("#txtLegalIdNo").val(obj.LegalIdNo);
                    $("#txtAccountName").val(obj.EnterpriseName);
                    $("#txtCardNo").val(obj.CardNo);
                    $("#txtSubBranch").val(obj.SubBranch);
                    $("#txtBank").val(obj.Bank);
                    $("#txtProvice").val(obj.Provice);
                    $("#txtCity").val(obj.City);
                    $("#txtPrcptcd").val(obj.Prcptcd);

                    $("#hiddenStatus").val(obj.Status);
                } else {
                    $("#hiddenStatus").val("Wait");
                }

                $("#labelAuth").text(authResultDict[$("#hiddenStatus").val()]);

                ///如果状态为打款成功，则只需要显示【打款金额确认】信息即可
                if ($("#hiddenStatus").val() == "PayAuthSuccss" 
                    || $("#hiddenStatus").val() == "PayAuthError") {

                    $("#linkQueryBank").hide();
                    $("#BtnRealName").hide();
                    $("#BtnPaySubmit").show();
                    $("#payMoneyTr").show();

                    contralStatus(true, false);

                } else if ($("#hiddenStatus").val() == "Normal") {
                    $("#linkQueryBank").hide();
                    $("#BtnRealName").hide();
                    $("#BtnPaySubmit").hide();
                    $("#payMoneyTr").hide();

                    contralStatus(true, true);

                } else {
                    $("#linkQueryBank").show();
                    $("#BtnRealName").show();
                    $("#BtnPaySubmit").hide();
                    $("#payMoneyTr").hide();

                    contralStatus(false, false);
                }

                hideLoading();
            });
        }

        function SubmitRealName() {

            var data = GetModel('RealName');
            var message = checkFormData(data);

            if (message.length > 0) {
                showAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: message,
                });
                return;
            }

            showLoading();
            submitAjax(handlerPath, data, function (model) {
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '提交成功',
                    callback: function () {
                        //重新绑定数据
                        InitPage();
                    }
                });
                hideLoading();
            }, function () { InitPage() });
        }

        function SubmitToPay() {
            showLoading();

            var data = GetModel('ToPay');
            submitAjax(handlerPath, data, function (model) {
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '提交成功',
                    callback: function () {
                        //重新绑定数据
                        InitPage();
                    }
                });
                hideLoading();
            }, function () { InitPage() });
        }

        function SubmitPayAuth() {
            
            var data = GetModel('PayAuth');

            var message = [];

            var reqData = JSON.parse(data.ReqData);

            if (reqData.PayMoney == '' || reqData.PayMoney == undefined) {
                message.push('请输入【打款金额】');
            }

            if (message.length > 0) {
                showAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: message,
                });
                return;
            }

            showLoading();
            submitAjax(handlerPath, data, function (model) {
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '提交成功',
                    callback: function () {
                        //重新绑定数据
                        InitPage();
                    }
                });
                hideLoading();
            }, function () { InitPage() });

        }

        var checkFormData = function (data) {
            var message = [];

            var reqData = JSON.parse(data.ReqData);

            if (reqData.DealerId == '' || reqData.DealerId == undefined) {
                message.push('经销商信息不存在');
            }
            if (reqData.OrganName == '' || reqData.OrganName == undefined) {
                message.push('请输入【企业名称】');
            }
            if (reqData.ResisterType == '' || reqData.ResisterType == undefined) {
                message.push('请选择【企业注册类型】');
            }
            if (reqData.OrganCode == '' || reqData.OrganCode == undefined) {
                message.push('请输入【' + $("#labelOrganCode").text() + '】');
            }
            if (reqData.LegalName == '' || reqData.LegalName == undefined) {
                message.push('请输入【法定代表姓名】');
            }
            if (reqData.AccountName == '' || reqData.AccountName == undefined) {
                message.push('请输入【对公账户户名】');
            }
            if (reqData.CardNo == '' || reqData.CardNo == undefined) {
                message.push('请输入【企业对公银行账号】');
            }
            if (reqData.SubBranch == '' || reqData.SubBranch == undefined) {
                message.push('请选择【开户行支行全称】');
            }
            if (reqData.Bank == '' || reqData.Bank == undefined) {
                message.push('请选择【开户行名称】');
            }
            if (reqData.Provice == '' || reqData.Provice == undefined) {
                message.push('请选择【开户行所在省份】');
            }
            if (reqData.City == '' || reqData.City == undefined) {
                message.push('请选择【开户行所在城市】');
            }
            if (reqData.Prcptcd == '' || reqData.Prcptcd == undefined) {
                message.push('请选择【开户行的大额行号】');
            }

            return message
        }

        function enterpriseRegisterTypeRadiosChange(value) {
            if (value == "0") {
                $("#labelOrganCode").text("统一社会信用代码");
            } else if (value == "1") {
                $("#labelOrganCode").text("组织机构代码号");
            } else if (value == "2") {
                $("#labelOrganCode").text("工商注册号");
            }
        }

        function contralStatus(isDisable,payIsDisbale) {
            if (isDisable) {
                $("#txtOrganName").attr("disabled", "true");
                $('input[name="enterpriseRegisterTypeRadios"]').attr("disabled", "true");
                $("#txtOrganCode").attr("disabled", "true");
                $("#txtLegalName").attr("disabled", "true");
                $("#txtLegalIdNo").attr("disabled", "true");
                $("#txtAccountName").attr("disabled", "true");
                $("#txtCardNo").attr("disabled", "true");

                if (payIsDisbale) {
                    $("#txtPayMoney").attr("disabled", "true");
                } else {
                    $("#txtPayMoney").removeAttr("disabled");
                }
            } else {
                $("#txtOrganName").removeAttr("disabled");
                $('input[name="enterpriseRegisterTypeRadios"]').removeAttr("disabled");
                $("#txtOrganCode").removeAttr("disabled");
                $("#txtLegalName").removeAttr("disabled");
                $("#txtLegalIdNo").removeAttr("disabled");
                $("#txtAccountName").removeAttr("disabled");
                $("#txtCardNo").removeAttr("disabled");
            }
        }

        function bindBank() {
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
                            var data = GetToolModel("QueryBank");
                            var parameter = {
                                page: options.page,
                                pageSize: options.pageSize,
                                take: options.take,
                                skip: options.skip,
                                bankName: $("#txtWinBankName").val(),
                                subBranch: $("#txtWinSubBranch").val()
                            };

                            data.ReqData = kendo.stringify(parameter);
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

            $("#divBank").kendoGrid({
                dataSource: dataSource,
                resizable: true,
                scrollable: false,
                editable: false,
                columns: [
                    {
                        title: "选择", width: '50px', encoded: false, headerAttributes: { "class": "center bold", "title": "选择" }, attributes: { "class": "center bold" }
                        , template: '<input type="radio" name="redioUser" value="#=Provice#!@|#=City#!@|#=BankName#!@|#=BankNbr#!@|#=SubBranch#" />',
                    },
                    { field: "Provice", title: "省份", width: "60px", headerAttributes: { "class": "center bold", "title": "省份" } },
                    { field: "City", title: "城市", width: "60px", headerAttributes: { "class": "center bold", "title": "城市" } },
                    { field: "BankName", title: "银行名称", width: "100px", headerAttributes: { "class": "center bold", "title": "银行名称" } },
                    { field: "BankNbr", title: "大额行号", width: "100px", headerAttributes: { "class": "center bold", "title": "大额行号" } },
                    { field: "SubBranch", title: "银行支行全称", headerAttributes: { "class": "center bold", "title": "银行支行全称" } }

                ], pageable: {
                    refresh: false,
                    pageSizes: true,
                    pageSize: 10
                }, dataBound: function () {
                    
                }
            });
        }

        function setSelBankContent() {

            var checkBankValues = $('input[name="redioUser"]:checked').val();

            if (checkBankValues == null || checkBankValues == undefined) {
                showAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: '请选择开户银行'
                });
                return;
            } else {
                var data = checkBankValues.split('!@|');
                $("#txtProvice").val(data[0]);
                $("#txtCity").val(data[1]);
                $("#txtBank").val(data[2]);
                $("#txtPrcptcd").val(data[3]);
                $("#txtSubBranch").val(data[4]);

                $('#BankSearchWindow').data('kendoWindow').center().close();
            }

        }

    </script>
</asp:Content>