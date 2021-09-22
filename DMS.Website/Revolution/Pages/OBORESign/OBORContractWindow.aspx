<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="OBORContractWindow.aspx.cs" Inherits="DMS.Website.Revolution.Pages.OBORESign.OBORContractWindow" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="Src" class="FrameControl" />
    <input type="hidden" id="FileName" class="FrameControl" />
    <input type="hidden" id="ES_ID" class="FrameControl" />


    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">

            <div class="row">
                <div class="box box-primary">
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

    <div class="content-main" style="padding: 5px; display:none" >
        <div class="col-xs-12">
            <div class="row">



                <%--<div class="box box-primary">
                    <div class="box-body" style="padding: 0px;">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-6 col-md-4 col-group">
                                    <div class="col-xs-3 col-label">
                                        <i class="fa fa-fw fa-blank"></i>短信验证码
                                    </div>
                                    <div class="col-xs-8 col-field">
                                        <div id="QryAgreementNo" class="FrameControl"></div>
                                    </div>
                                    <div class="col-xs-3 col-label">
                                        <i class="fa fa-fw fa-blank"></i>发送验证码
                                    </div>
                                </div>

                            </div>


                        </div>
                    </div>
                </div>--%>

            </div>

        </div>
    </div>

</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom">
        <a id="BtnDealerSign"></a>
        <a id="BtnLPSign"></a>
        <a id="BtnDownload"></a>
        <a id="BtnClose"></a>
    </div>
</asp:Content>

<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/OBORContractWindow.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            OBORContractWindow.Init();
        });
    </script>
</asp:Content>
