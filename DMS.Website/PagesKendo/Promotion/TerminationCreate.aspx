<%@Page Title="" Language="C#" MasterPageFile="~/MasterPageKendo/Site.Master" AutoEventWireup="true" CodeBehind="TerminationCreate.aspx.cs" Inherits="DMS.Website.PagesKendo.Promotion.TerminationCreate" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
    <style type="text/css">
        .ClassWrapper {
            height: 225px;
            overflow-y: auto;
        }

            .ClassWrapper .ClassItem {
                border-bottom: 1px dashed #ccc;
                height: 40px;
                line-height: 40px;
                vertical-align: middle;
                font-size: 14px;
                padding: 0px 10px 0px 30px;
                cursor: pointer;
            }

            .ClassWrapper .ClassTemplateItem {
                border-bottom: 1px dashed #ccc;
                height: 40px;
                line-height: 40px;
                vertical-align: middle;
                font-size: 14px;
                padding: 0px 10px 0px 30px;
                cursor: pointer;
            }

            .ClassWrapper .SelectItem {
                background-color: #337ab7;
                color: #fff;
            }
    </style>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="IptPolicyStyle" />
    <input type="hidden" id="IptPolicyStyleSub" />
    <input type="hidden" id="TermainationId" class="FrameControl"/>
    <div class="content-main">
        <div class="col-xs-12 content-row" style="padding: 10px 10px 0px 10px;">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class='fa fa-navicon' style="padding-left: 15px;"></i>&nbsp;促销终止</h3>
                </div>
                <div class="panel-body">
                    <table style="width: 100%;" class="KendoTable">
                        <tr>
                            

                            <td style="width: 15%;"><i class='fa fa-blank'></i>&nbsp;促销编号<span style="color:red">*</span></td>
                            <td style="width: 35%;">
                               <%-- <div id="QryPolicyNo" class="FrameControl"></div>--%>


                            <input id="QryPolicyNo" style="width: 350px; display: none;" />
                            <%--    <div id="QryPolicy" style="display: none;"></div>--%>
                            </td>
                            <td style="width: 15%;"><i class='fa fa-blank'></i>&nbsp;促销名称</td>
                            <td style="width: 35%;">
                                <div id="QryPolicyName" class="FrameControl"></div>
                            </td>
                            
                        </tr>
                        <tr>
                            <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;归类名称</td>
                            <td style="width: 24%;">
                                <div id="QryPolicyGroupName" class="FrameControl"></div>
                            </td>
                             <td style="width: 10%;"><i class='fa fa-blank'></i>&nbsp;产品线</td>
                            <td style="width: 24%;">
                                <div id="QryProductLine" class="FrameControl"></div>
                            </td>
                        </tr>
                        <tr>
                          
                            <td><i class='fa fa-blank'></i>&nbsp;开始时间</td>
                            <td>
                                <div id="QryStartDate" class="FrameControl"></div>
                            </td>
                            <td><i class='fa fa-blank'></i>&nbsp;结束时间</td>
                            <td>
                                <div id="QryEndDate" class="FrameControl"></div>
                            </td>
                         
                        </tr>
                        <tr>
                            <td><i class='fa fa-blank'></i>&nbsp;SubBu</td>
                            <td>
                                <div id="QrySubBu" class="FrameControl"></div>
                            </td>
                              <td><i class='fa fa-blank' id=""></i>&nbsp;终止类型<span style="color:red">*</span></td>
                            <td>
                                <div id="QryTemainationType" class="FrameControl"></div>
                            </td>
                            
                          
                        </tr>
                        <tr>
                            <td><i class='fa fa-blank'></i>&nbsp;终止生效时间<span style="color:red">*</span></td>
                            <td>
                                <div id="QryTemainationSDate" class="FrameControl"></div>
                            </td>

                        </tr>
                        <tr>
                            <td><i class='fa fa-blank'></i>&nbsp;备注</td>
                            <td>
                                <div id="QryRemark" class="FrameControl"></div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" style="height: 40px; text-align: right;">
                                <button id="BtnSubmit" class="KendoButton"><i class='fa fa-file-o'></i>&nbsp;&nbsp;提交</button>
                                <button id="BtnSave" class="KendoButton"><i class='fa fa-file-o'></i>&nbsp;&nbsp;保存</button>
                                <button id="BtnClose" class="KendoButton"><i class='fa fa-window-close-o'></i>&nbsp;&nbsp;关闭</button>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
           
        </div>
    </div>
  
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/TerminationCreate.js?v=1.88"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            TerminationCreate.InitPage();
        });
    </script>
</asp:Content>
