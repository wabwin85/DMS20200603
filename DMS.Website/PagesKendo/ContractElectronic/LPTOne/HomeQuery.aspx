<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="HomeQuery.aspx.cs" Inherits="DMS.Website.Pages.ContractKendo.HomeQuery" %>
<asp:Content ID="Content1" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="hidContractId" />
    <input type="hidden" id="hidDealerId" />
    <input type="hidden" id="hidDealerName" />
    <input type="hidden" id="hidDealerType" />
    <input type="hidden" id="hidParmetType" />
    <input type="hidden" id="hidEffectiveDate" />
    <input type="hidden" id="hidSuBU" />
    <input type="hidden" id="hidExpirationDate" />

    <div class="content-main">
        <div class="col-xs-12 content-row" style="padding: 10px 10px 0px 10px;">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;查询条件</h3>
                </div>
                <div class="panel-body">
                    <table style="width: 100%;" class="KendoTable">
                        <tr>
                            <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;合同号</td>
                            <td style="width: 23%;">
                                <div id="QryContractNO" class="FrameControl"></div>
                            </td>
                            <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;产品线</td>
                            <td style="width: 23%;">
                                <div id="QryProductLine" class="FrameControl"></div>
                            </td>
                            <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;合同分类</td>
                            <td style="width: 24%;">
                                <div id="QryCCNameCN" class="FrameControl"></div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;经销商类型</td>
                            <td style="width: 23%;">
                                <div id="QryDealerType" class="FrameControl"></div>
                            </td>
                            <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;经销商</td>
                            <td style="width: 23%;">
                                <div id="QryDealerName" class="FrameControl"></div>
                            </td>
                            <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;是否生成合同</td>
                               <td style="width: 23%;">
                                <div id="IsNewContract" class="FrameControl"></div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" style="height: 40px; text-align: right;">
                                <button id="BtnQuery" class="KendoButton"><i class='fa fa-search'></i>&nbsp;&nbsp;查询</button>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="panel panel-primary" style="margin-top: 10px; margin-bottom: 10px;">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;合同列表</h3>
                </div>
                <div class="panel-body" style="padding: 0px;">
                    <div id="ContractList" style="border-width: 0px;"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="winEffectStateLayout" style="display:none;height:200px;">
        <style>
            #winEffectStateLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="panel panel-primary" style="/*margin-top: 10px; margin-bottom: 10px;*/">
            <div class="panel-body" style="/*padding: 0px;*/">
                <div id="EffectStateList" style="border-width: 0px;"></div>
            </div>
        </div>
    </div>
    <div id="winAuthorizationLayout" style="display:none;">
        <style>
            #winAuthorizationLayout .row {
                margin: 0 auto;
            }
        </style>
        <div class="col-xs-12 content-row" style="padding: 0px;">
            <div class="panel panel-primary">
                <div class="panel-body">
                    <table style="width: 100%;" class="KendoTable">
                        <tr>
                            <td style="width: 32%;"><i class='fa fa-blank'></i>&nbsp;请填写授权编号</td>
                            <td>
                                <div id="IptAuthorizationCode" class="FrameControl"></div>
                            </td>
                        </tr>
                        <tr id="trContacts">
                            <td style="width:32%;"><i class='fa fa-blank'></i>&nbsp;请填写联系人</td>
                            <td>
                                <div id="IptAuthorizationContacts" class="FrameControl"></div>
                            </td>
                        </tr>
                        <tr id="trPhone">
                            <td style="width: 32%;"><i class='fa fa-blank'></i>&nbsp;请填写联系方式</td>
                            <td>
                                <div id="IptAuthorizationPhone" class="FrameControl"></div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="height: 40px; text-align: center;">
                                <button id="BtnAuthorizationPDF" class="KendoButton"><i class='fa fa-file-pdf-o'></i>&nbsp;&nbsp;生成授权书</button>
                                <button id="BtnAuthorizationClose" class="KendoButton"><i class='fa fa-times-circle'></i>&nbsp;&nbsp;关闭</button>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="../script/HomeQuery.js?v=2"></script>
    <script>
        $(document).ready(function () {
            Page.InitPage();
        })      
    </script>
</asp:Content>
