<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="DealerContractList.aspx.cs" Inherits="DMS.Website.Revolution.Pages.MasterDatas.DealerContractList" %>

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
                                        <i class="fa fa-fw fa-blank"></i>经销商
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryDealer" class="FrameControl"></div>
                                    </div>
                                </div>
                               <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        合同编号
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryContractNumber" class="FrameControl"></div>
                                    </div>
                                </div> 
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-4 col-label">
                                        合同有效期
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryContractYears" class="FrameControl"></div>
                                    </div>
                                </div>                                                            
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom" id="PnlButton">
                                    <a id="BtnQuery"></a>
                                    <a id="BtnNew"></a>
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
        <div style="display:none">
          <div id="AddDealerContractID" class="FrameControl"></div>
            <div id="DeleteDealerContractID" class="FrameControl"></div>
    </div>
    <div id="divContractDetail" style="display: none;">
        <style>
            #divContractDetail .row {
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
                    <i class="fa fa-fw fa-require"></i>经销商:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddDealer" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    合同编号:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddContractNumber" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    合同有效期:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddContractYears" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    <i class="fa fa-fw fa-require"></i>开始日期:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddStartDate" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                <div class="col-xs-3 col-label">
                    <i class="fa fa-fw fa-require"></i>结束日期:
                </div>
                <div class="col-xs-8 col-field">
                    <div id="AddStopDate" class="FrameControl"></div>
                </div>
            </div>
        </div>
        <div class="windowsfoot-btn">
            <a id="saveDetail"></a>
            <a id="colseDetail"></a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom">
       
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/DealerContractList.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            DealerContractList.Init();
        });
    </script>
</asp:Content>