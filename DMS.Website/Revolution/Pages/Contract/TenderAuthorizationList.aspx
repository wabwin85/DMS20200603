<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="TenderAuthorizationList.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Contract.TenderAuthorizationList" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-filter'></i>&nbsp;查询条件</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">                                
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        授权书编号
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryAuthorizationNo" class="FrameControl"></div>
                                    </div>
                                </div> 
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        授权开始时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryAuthorizationStart" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        授权结束时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryAuthorizationEnd" class="FrameControl"></div>
                                    </div>
                                </div>                                                                                            
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        经销商
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryDealer" class="FrameControl"></div>
                                    </div>
                                </div>  
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        审批状态
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryApproveStatus" class="FrameControl"></div>
                                    </div>
                                </div>
                               <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        审批完成时间
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryApproveDate" class="FrameControl"></div>
                                    </div>
                                </div>                                                                                            
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        医院名称
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryHospital" class="FrameControl"></div>
                                    </div>
                                </div>  
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        授权类型
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryAuthorizationType" class="FrameControl"></div>
                                    </div>
                                </div>                                                                                            
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom" id="PnlButton">
                                    <a id="BtnQuery"></a>                                    
                                    <a id="BtnExport"></a>
                                    <a id="BtnAdd"></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
           
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;查询结果</h3>
                    </div>
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div id="RstResultList" class="k-grid-page-20"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div style="display: none">
        <div id="DTMID" class="FrameControl"></div>
    </div>
    <div id="windowLayout" style="display: none;">
        <style>
            #windowLayout .row {
                margin: 0px;
            }

            .windowsfoot-btn {
                width: 100%;
                margin-top: 20px;
                text-align: center;
            }
        </style>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    合同类型:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="ConstractType" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    授权类型:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="IptAuthorizationTypeExt" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="windowsfoot-btn">
            <a id="export"></a>
            <a id="colse"></a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom">
       
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/TenderAuthorizationList.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            TenderAuthorizationList.Init();
        });
    </script>
</asp:Content>