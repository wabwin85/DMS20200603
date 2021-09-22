<%@ Page Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="EnterpriseAuthList.aspx.cs" Inherits="DMS.Website.PagesKendo.ESign.EnterpriseAuthList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">
    <style>
        .k-textbox {
            width: 100%;
        }

        .requiredHidden {
            color: #fff !important;
        }

        .customer-photo {
            display: inline-block;
            width: 157px;
            /*height: 50px;*/
            border-radius: 50%;
            background-size: 50px 50px;
            background-position: center center;
            vertical-align: middle;
            line-height: 100px;
            box-shadow: inset 0 0 1px #999, inset 0 0 10px rgba(0,0,0,.2);
            margin-left: 20px;
        }

        .customer-img {
            display: inline-block;
            width: 100px;
            background-size: 50px 50px;
            background-position: center center;
            vertical-align: middle;
            line-height: 100px;
            margin-left: 20px;
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main">
        <input type="hidden" id="hiddenDealerId" />
        <input type="hidden" id="hiddenSubDealerId" />
        <input type="hidden" id="hiddenAccountUId" />
        <input type="hidden" id="hiddenLegalAccountUId" />
        <input type="hidden" id="hiddenLastUpdateDate" />
        <input type="hidden" id="hiddenStatus" />
        <div class="content-row" style="padding: 10px 10px 0px 10px;">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;电子签章用户信息注册认证</h3>
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
                            <input type="radio" name="enterpriseRegisterTypeRadios" id="enterpriseRegisterType2" value="0" >组织机构代码号
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="enterpriseRegisterTypeRadios" id="enterpriseRegisterType1" value="1" checked >统一社会信用代码
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
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 开户行账号：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtCardNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                       <label class="lableControl"><span class="required">*</span>&nbsp; 开户行名称：</label>
                    <td>
                        <input type="text" class="k-textbox" id="txtBank" />
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
                <tr id="trLegalName" >
                    <td>
                        <label class="lableControl"><span class="required">*</span>&nbsp; 法定代表姓名：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtLegalName" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span class="required">*</span >&nbsp; <span id="labelLegalIdNo" >法定代表身份证号</span>：</label></td>
                    <td>
                        <input type="text" class="k-textbox" id="txtLegalIdNo" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="lableControl"><span style="color:#fff;">&nbsp;</span>&nbsp; </label></td>
                    <td>
                        <label class="lableControl" style="color:red;" ><span class="fa fa-exclamation-circle fa-lg required"></span>&nbsp;电子签章盖章之前将验证码发至该号码，DMS系统中输入验证码方可盖章。【手机号】应为贵公司处理合同/协议人员的手机号码。</label>
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
                        <label class="lableControl"><span style="color:#fff;">*</span>&nbsp; 状态：</label></td>
                    <td>
                        <label id="labelAuth" class="lableControl" style="width:350px;text-align:left;" ></label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="text-align: right; height: 40px; ">
                            <button id="BtnRealName" class="size-14"><i class="fa fa-hand-pointer-o"></i>&nbsp;&nbsp;提交&nbsp;</button>
                        </div>
                    </td>
                </tr>
                <tr id="enterpriseSealDiv" hidden>
                    <td>
                        <label class="lableControl"><span style="color:#fff;">*</span>&nbsp; 企业印章：</label></td>
                    <td>
                        <img id="imgEnterpriseSeal" class="customer-photo" src=""/>
                    </td>
                </tr>
                <tr id="legalSealDiv" hidden>
                    <td>
                        <label class="lableControl"><span style="color:#fff;">*</span>&nbsp; 法人印章：</label></td>
                    <td>
                        <img id="imgLegalSeal" class="customer-img" src=""/>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript">
        var handlerPath = Common.AppVirtualPath + "PagesKendo/ESign/handler/ESignHandler.ashx";
        var authResultDict = {"Wait" : "等待实名认证"
            , "RealNameError": "实名认证错误"
            , "EnterpriseRegError": "企业注册失败"
            , "EnterpriseSealError": "企业制章失败"
            , "LegalRegError": "法人注册失败"
            , "LegalSealError": "法人制章失败"
            , "Normal" : "已完成企业注册"};

        function GetModel(methodName) {
            var reqData = {
                DealerId: $("#hiddenDealerId").val(),
                SubDealerId: $("#hiddenSubDealerId").val(),
                DealerName: $("#txtDealerName").val(),
                AccountUid: $("#hiddenAccountUId").val(),
                LegalAccountUid: $("#hiddenLegalAccountUId").val(),
                OrganName: $("#txtOrganName").val(),
                OrganType: $('input[name="organTypeRadios"]:checked').val(),
                EnterpriseResisterType: $('input[name="enterpriseRegisterTypeRadios"]:checked').val(),
                OrganCode: $("#txtOrganCode").val(),
                LegalName: $("#txtLegalName").val(),
                LegalIdNo: $("#txtLegalIdNo").val(),
                AgentName: $("#txtAgentName").val(),
                AgentIdNo: $("#txtAgentIdNo").val(),
                Moblie: $("#txtMoblie").val(),
                Email: $("#txtEmail").val(),
                CardNo: $("#txtCardNo").val(),
                Bank: $("#txtBank").val(),
                LegalArea: $('input[name="legalAreaRadios"]:checked').val(),
                UserType: $('input[name="registerTypeRadios"]:checked').val()
            }
            var data = {
                Function: "EnterpriseAuth",
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

            $('input[name="legalAreaRadios"]').change(function () {
                legalAreaRadiosChange($(this).val());
            }); 

            $("#BtnRealName").FrameButton({
                onClick: function () {
                    SubmitRealName();
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

                console.log(obj);

                if (obj != undefined && obj != null) {

                    var registerType;

                    $("#hiddenLastUpdateDate").val(obj.CreateDate);

                    $("#hiddenDealerId").val(obj.DmaId);
                    $("#hiddenSubDealerId").val(obj.ParentDmaId);

                    $("#hiddenAccountUId").val(obj.EnterpriseAccounUid);
                    $("#hiddenLegalAccountUId").val(obj.LegalAccounUid);

                    $("#txtDealerName").val(obj.DealerName);
                    $("#txtOrganName").val(obj.Name);

                    if (obj.OrganType == "0") {
                        $("input[name='organTypeRadios'][value=0]").attr("checked", true);
                    } else if (obj.OrganType == "1") {
                        $("input[name='organTypeRadios'][value=1]").attr("checked", true);
                    } else if (obj.OrganType == "2") {
                        $("input[name='organTypeRadios'][value=2]").attr("checked", true);
                    } else if (obj.OrganType == "3") {
                        $("input[name='organTypeRadios'][value=3]").attr("checked", true);
                    } else if (obj.OrganType == "4") {
                        $("input[name='organTypeRadios'][value=4]").attr("checked", true);
                    }

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

                    $("#txtCardNo").val(obj.CardNo);
                    $("#txtBank").val(obj.Bank);

                    $("#labelLegalIdNo").text("法定代表护照号");
                    if (obj.PersonArea == "0") {
                        $("input[name='legalAreaRadios'][value=0]").attr("checked", true);
                        $("#labelLegalIdNo").text("法定代表身份证号");
                    } else if (obj.OrganType == "1") {
                        $("input[name='legalAreaRadios'][value=1]").attr("checked", true);
                    } else if (obj.OrganType == "2") {
                        $("input[name='legalAreaRadios'][value=2]").attr("checked", true);
                    } else if (obj.OrganType == "3") {
                        $("input[name='legalAreaRadios'][value=3]").attr("checked", true);
                    } else if (obj.OrganType == "4") {
                        $("input[name='legalAreaRadios'][value=4]").attr("checked", true);
                    }


                    if (obj.UserType == "0") {
                        $("input[name='registerTypeRadios'][value=0]").attr("checked", true);
                    } else if (obj.UserType == "1") {
                        $("input[name='registerTypeRadios'][value=1]").attr("checked", true);
                    } else if (obj.UserType == "2") {
                        $("input[name='registerTypeRadios'][value=2]").attr("checked", true);
                    }
                    registerTypeRadiosChange(obj.UserType);

                    $("#txtAgentName").val(obj.AgentName);
                    $("#txtAgentIdNo").val(obj.AgentIdNo);
                    $("#txtLegalName").val(obj.LegalName);
                    $("#txtLegalIdNo").val(obj.LegalIdNo);
                    $("#txtAccountName").val(obj.EnterpriseName);
                    
                    $("#txtMoblie").val(obj.Phone);
                    $("#txtEmail").val(obj.Email);

                    $("#hiddenStatus").val(obj.Status);

                    if (obj.EnterpriseSeal != undefined && obj.EnterpriseSeal!=''){
                        $("#enterpriseSealDiv").show();
                        $("#imgEnterpriseSeal").attr("src", "data:image/png;base64," + obj.EnterpriseSeal);
                    }

                    if (obj.LegalSeal != undefined && obj.LegalSeal != '') {
                        $("#legalSealDiv").show();
                        $("#imgLegalSeal").attr("src", "data:image/png;base64," + obj.LegalSeal);
                    }
                } else {
                    $("#hiddenStatus").val("Wait");
                }

                $("#labelAuth").text(authResultDict[$("#hiddenStatus").val()]);

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
        
        var checkFormData = function (data) {
            var message = [];

            var reqData = JSON.parse(data.ReqData);

            if (reqData.DealerId == '' || reqData.DealerId == undefined) {
                message.push('经销商信息不存在');
            }
            if (reqData.OrganName == '' || reqData.OrganName == undefined) {
                message.push('请输入【企业名称】');
            }
            if (reqData.OrganType == '' || reqData.OrganType == undefined) {
                message.push('请选择【单位类型】');
            }
            if (reqData.EnterpriseResisterType == '' || reqData.EnterpriseResisterType == undefined) {
                message.push('请选择【企业注册类型】');
            }
            if (reqData.OrganCode == '' || reqData.OrganCode == undefined) {
                message.push('请输入【' + $("#labelOrganCode").text() + '】');
            }
            if (reqData.CardNo == '' || reqData.CardNo == undefined) {
                message.push('请输入【开户行账号】');
            }
            if (reqData.Bank == '' || reqData.Bank == undefined) {
                message.push('请输入【开户行名称】');
            }
            if (reqData.LegalArea == '' || reqData.LegalArea == undefined) {
                message.push('请选择【法定代表归属地】');
            }
            if (reqData.UserType == '' || reqData.UserType == undefined) {
                message.push('请选择【注册类型】');
            }

            if (reqData.UserType == '1') {
                if (reqData.AgentName == '' || reqData.AgentName == undefined) {
                    message.push('请输入【代理人姓名】');
                }
                if (reqData.AgentIdNo == '' || reqData.AgentIdNo == undefined) {
                    message.push('请输入【代理人身份证号】');
                }
            }

            if (reqData.LegalName == '' || reqData.LegalName == undefined) {
                message.push('请输入【法定代表姓名】');
            }
            if (reqData.LegalIdNo == '' || reqData.LegalIdNo == undefined) {
                message.push('请输入【法定代表身份证号】');
            }
            if (reqData.Moblie == '' || reqData.Moblie == undefined) {
                message.push('请输入【手机号】');
            }
            if (reqData.Email == '' || reqData.Email == undefined) {
                message.push('请输入【邮箱】');
            }

            return message
        }

        function enterpriseRegisterTypeRadiosChange(value) {
            if (value == "0") {
                $("#labelOrganCode").text("组织机构代码号");
            } else if (value == "1") {
                $("#labelOrganCode").text("统一社会信用代码");
            } else if (value == "2") {
                $("#labelOrganCode").text("工商注册号");
            }
        }

        function legalAreaRadiosChange(value) {            
            if (value == "0") {
                $("#labelLegalIdNo").text("法定代表身份证号");
            } else {
                $("#labelLegalIdNo").text("法定代表护照号");
            }
        }

        function registerTypeRadiosChange(value) {
            if (value == "0") {
                $("#trAgentName").hide();
                $("#trAgentNo").hide();
            } else if (value == "1") {
                $("#trAgentName").show();
                $("#trAgentNo").show();
            } else if (value == "2") {
                $("#trAgentName").hide();
                $("#trAgentNo").hide();
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

    </script>
</asp:Content>