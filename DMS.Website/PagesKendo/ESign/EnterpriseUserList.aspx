<%@ Page Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="EnterpriseUserList.aspx.cs" Inherits="DMS.Website.PagesKendo.ESign.EnterpriseUserList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">
    <style>
        .k-textbox {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main">
        <input type="hidden" id="hiddenDealerId" />
        <input type="hidden" id="hiddenSubDealerId" />
        <input type="hidden" id="hiddenAccountUId" />
        <input type="hidden" id="hiddenLastUpdateDate" />
        <div class="content-row" style="padding: 10px 10px 0px 10px;">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;电子签章用户信息注册</h3>
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
                        <label class="lableControl"><span class="required">*</span>&nbsp; 机构名称：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtOrganName" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 手机号：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtMoblie" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 邮箱：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtEmail" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 单位类型：</label></td>
                    <td>
                        <label class="radio-inline">
                            <input type="radio" name="organTypeRadios" id="type1" value="0" checked>普通企业
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="organTypeRadios" id="type2" value="1" >社会团体
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="organTypeRadios" id="type3" value="2" >事业单位
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="organTypeRadios" id="type4" value="3" >民办非企业单位
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="organTypeRadios" id="type5" value="4" >党政及国家机构
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 企业注册类型：</label></td>
                    <td>
                        <label class="radio-inline">
                            <input type="radio" name="enterpriseRegisterTypeRadios" id="enterpriseRegisterType1" value="0" checked >组织机构代码号
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="enterpriseRegisterTypeRadios" id="enterpriseRegisterType2" value="1" >多证合一
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="enterpriseRegisterTypeRadios" id="enterpriseRegisterType3" value="2" >工商注册号
                        </label>    
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; <span id="labelOrganCode">组织机构代码号</span>：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtOrganCode" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 注册类型：</label></td>
                    <td>
                        <label class="radio-inline">
                            <input type="radio" name="registerTypeRadios" id="registerType1" value="0" checked >缺省注册
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="registerTypeRadios" id="registerType2" value="1" >代理人注册
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="registerTypeRadios" id="registerType3" value="2" >法人注册
                        </label>    
                    </td>
                </tr>
                <tr id="trLegalName" hidden >
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 法定代表姓名：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtLegalName" />
                    </td>
                </tr>
                <tr id="trLegalNo" hidden >
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 法定代表身份证号：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtLegalIdNo" />
                    </td>
                </tr>
                <tr id="trAgentName" hidden >
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 代理人姓名：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtAgentName" />
                    </td>
                </tr>
                 <tr id="trAgentNo" hidden >
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 代理人身份证号：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtAgentIdNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 法定代表归属地：</label></td>
                    <td>
                        <label class="radio-inline">
                            <input type="radio" name="legalAreaRadios" id="legalArea1" value="0" checked >大陆
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="legalAreaRadios" id="legalArea2" value="1" >香港
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="legalAreaRadios" id="legalArea3" value="2" >澳门
                        </label>    
                        <label class="radio-inline">
                            <input type="radio" name="legalAreaRadios" id="legalArea4" value="3" >台湾
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="legalAreaRadios" id="legalArea5" value="4" >外籍
                        </label>    
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="text-align: right; height: 40px;">
                            <button id="BtnSubmit" class="size-14"><i class="fa fa-hand-pointer-o"></i>&nbsp;&nbsp;提交&nbsp;</button>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript">
        var handlerPath = Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandler.ashx";

        function GetModel(methodName) {
            var userType = $('input[name="registerTypeRadios"]:checked').val();

            if (userType == "0") {
                $("#txtLegalName").val("");
                $("#txtLegalIdNo").val("");
                $("#txtAgentName").val("");
                $("#txtAgentIdNo").val("");
            } else if (userType == "1") {
                $("#txtLegalName").val("");
                $("#txtLegalIdNo").val("");
            }
            else if (userType == "2") {
                $("#txtAgentName").val("");
                $("#txtAgentIdNo").val("");
            }

            var reqData = {
                DealerId: $("#hiddenDealerId").val(),
                SubDealerId: $("#hiddenSubDealerId").val(),
                DealerName: $("#txtDealerName").val(),
                AccountUid: $("#hiddenAccountUId").val(),
                Phone: $("#txtMoblie").val(),
                Email: $("#txtEmail").val(),
                Name: $("#txtOrganName").val(),
                OrganType: $('input[name="organTypeRadios"]:checked').val(),
                RegType: $('input[name="enterpriseRegisterTypeRadios"]:checked').val(),
                OrganCode: $("#txtOrganCode").val(),
                UserType: $('input[name="registerTypeRadios"]:checked').val(),
                LegalName: $("#txtLegalName").val(),
                LegalIdNo: $("#txtLegalIdNo").val(),
                LegalArea: $('input[name="legalAreaRadios"]:checked').val(),
                AgentName: $("#txtAgentName").val(),
                AgentIdNo: $("#txtAgentIdNo").val()
            }
            var data = {
                Function: "EnterpriseUser",
                Method: methodName,
                LastUpdateDate: $("#hiddenLastUpdateDate").val(),
                ReqData: JSON.stringify(reqData)
            }
            return data;
        }

        $(document).ready(function () {
            $('input[name="enterpriseRegisterTypeRadios"]').change(function () {
                enterpriseRegisterTypeRadiosChange($(this).val());
            });

            $('input[name="registerTypeRadios"]').change(function () {
                registerTypeRadiosChange($(this).val());
            });

            $("#BtnSubmit").FrameButton({
                onClick: function () {
                    SubmitUser();
                }
            });

            hideLoading();

            InitPage();
        });

        function InitPage() {
            showLoading();
            var data = GetModel('Init');
            submitAjax(handlerPath, data, function (model) {

                var d = JSON.parse(model.ResData)[0];

                if (d != undefined && d != null) {
                    $("#hiddenDealerId").val(d.DmaId);
                    $("#hiddenSubDealerId").val(d.ParentDmaId);
                    $("#hiddenAccountUId").val(d.AccountUid);
                    $("#txtMoblie").val(d.Phone);
                    $("#txtEmail").val(d.Email);
                    $("#txtOrganName").val(d.Name);
                    $("#txtDealerName").val(d.DealerName);

                    if (d.OrganType == "0") {
                        $("input[name='organTypeRadios'][value=0]").attr("checked", true);
                    } else if (d.OrganType == "1") {
                        $("input[name='organTypeRadios'][value=1]").attr("checked", true);
                    } else if (d.OrganType == "2") {
                        $("input[name='organTypeRadios'][value=2]").attr("checked", true);
                    } else if (d.OrganType == "3") {
                        $("input[name='organTypeRadios'][value=3]").attr("checked", true);
                    } else if (d.OrganType == "4") {
                        $("input[name='organTypeRadios'][value=4]").attr("checked", true);
                    }

                    if (d.RegType == "0") {
                        $("input[name='enterpriseRegisterTypeRadios'][value=0]").attr("checked", true);
                    } else if (d.RegType == "1") {
                        $("input[name='enterpriseRegisterTypeRadios'][value=1]").attr("checked", true);
                    } else if (d.RegType == "2") {
                        $("input[name='enterpriseRegisterTypeRadios'][value=2]").attr("checked", true);
                    }

                    enterpriseRegisterTypeRadiosChange(d.RegType);

                    if (d.UserType == "0") {
                        $("input[name='registerTypeRadios'][value=0]").attr("checked", true);
                    } else if (d.UserType == "1") {
                        $("input[name='registerTypeRadios'][value=1]").attr("checked", true);
                    } else if (d.UserType == "2") {
                        $("input[name='registerTypeRadios'][value=2]").attr("checked", true);
                    }
                    registerTypeRadiosChange(d.UserType);

                    if (d.LegalArea == "0") {
                        $("input[name='legalAreaRadios'][value=0]").attr("checked", true);
                    } else if (d.LegalArea == "1") {
                        $("input[name='legalAreaRadios'][value=1]").attr("checked", true);
                    } else if (d.LegalArea == "2") {
                        $("input[name='legalAreaRadios'][value=2]").attr("checked", true);
                    } else if (d.LegalArea == "3") {
                        $("input[name='legalAreaRadios'][value=3]").attr("checked", true);
                    } else if (d.LegalArea == "4") {
                        $("input[name='legalAreaRadios'][value=4]").attr("checked", true);
                    }
                    $("#txtOrganCode").val(d.OrganCode);
                    $("#txtLegalName").val(d.LegalName);
                    $("#txtLegalIdNo").val(d.LegalIdNo);

                    $("#txtAgentName").val(d.AgentName);
                    $("#txtAgentIdNo").val(d.AgentIdNo);

                    if (d.AccountUid != null && d.AccountUid != undefined) {
                        $("#txtOrganName").attr("disabled", "disabled");
                        $("#txtDealerName").attr("disabled", "disabled");

                        $("#txtOrganCode").attr("disabled", "disabled");
                        $("#txtLegalName").attr("disabled", "disabled");
                        $("#txtLegalIdNo").attr("disabled", "disabled");
                        $("#txtAgentName").attr("disabled", "disabled");
                        $("#txtAgentIdNo").attr("disabled", "disabled");

                        $("input[name='organTypeRadios']").attr("disabled", "true");
                        $("input[name='enterpriseRegisterTypeRadios']").attr("disabled", "true");
                        $("input[name='registerTypeRadios']").attr("disabled", "true");
                        $("input[name='legalAreaRadios']").attr("disabled", "true");
                    }
                }
                
                hideLoading();
            });
        }

        function SubmitUser() {
            var data = GetModel('Create');

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
            });
        }

        var checkFormData = function (data) {
            var message = [];

            var reqData = JSON.parse(data.ReqData);

            if (reqData.DealerId == '' || reqData.DealerId == undefined) {
                message.push('经销商信息不存在');
            }
            if (reqData.Phone == '' || reqData.Phone == undefined) {
                message.push('请输入【手机号】');
            }
            if (reqData.Email == '' || reqData.Email == undefined) {
                message.push('请输入【邮箱】');
            }
            if (reqData.Name == '' || reqData.Name == undefined) {
                message.push('请输入【机构名称】');
            }
            if (reqData.OrganType == '' || reqData.OrganType == undefined) {
                message.push('请选择【单位类型】');
            }
            if (reqData.RegType == '' || reqData.RegType == undefined) {
                message.push('请选择【企业注册类型】');
            }
            if (reqData.OrganCode == '' || reqData.OrganCode == undefined) {
                message.push('请输入【' + $("#labelOrganCode").text() + '】');
            }
            if (reqData.UserType == '' || reqData.UserType == undefined) {
                message.push('请选择【注册类型】');
            }
            if (reqData.UserType == '1' && (reqData.LegalName == '' || reqData.LegalName == undefined)) {
                message.push('请输入【法定代表姓名】');
            }
            if (reqData.UserType == '1' && (reqData.LegalIdNo == '' || reqData.LegalIdNo == undefined)) {
                message.push('请输入【法定代表身份证号】');
            }
            if (reqData.UserType == '2' && (reqData.AgentName == '' || reqData.AgentName == undefined)) {
                message.push('请输入【代理人姓名】');
            }
            if (reqData.UserType == '2' && (reqData.AgentIdNo == '' || reqData.AgentIdNo == undefined)) {
                message.push('请输入【代理人身份证号】');
            }
            if (reqData.LegalArea == '' || reqData.LegalArea == undefined) {
                message.push('请选择【法定代表归属地】');
            }

            return message
        }

        function enterpriseRegisterTypeRadiosChange(value) {
            if (value == "0") {
                $("#labelOrganCode").text("组织机构代码号");
            } else if (value == "1") {
                $("#labelOrganCode").text("社会信用代码号");
            } else if (value == "2") {
                $("#labelOrganCode").text("工商注册号");
            }
        }

        function registerTypeRadiosChange(value) {
            if (value == "0") {
                $("#trLegalName").hide();
                $("#trLegalNo").hide();
                $("#trAgentName").hide();
                $("#trAgentNo").hide();
            } else if (value == "1") {
                $("#trLegalName").hide();
                $("#trLegalNo").hide();
                $("#trAgentName").show();
                $("#trAgentNo").show();
            } else if (value == "2") {
                $("#trLegalName").show();
                $("#trLegalNo").show();
                $("#trAgentName").hide();
                $("#trAgentNo").hide();
            }
        }

    </script>
</asp:Content>