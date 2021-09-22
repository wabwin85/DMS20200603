<%@ Page Title="" Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="BulletinRead.aspx.cs" Inherits="DMS.Website.Revolution.Pages.Platform.BulletinRead" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="InstanceId" class="FrameControl" />
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="col-xs-12" style="font-size:20px; text-align:center; font-weight:bold;">
                    <div id="IptTitle"></div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12" style="text-align:right;">
                    <div id="IptPublishedDate"></div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <div id="IptBody"></div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <ul id="RstAttachment" style="padding:10px 0;"></ul>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
    <div class="foot-bar col-buttom">
        <a id="BtnConfirm"></a>
        <a id="BtnClose"></a>
    </div>
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/BulletinRead.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            BulletinRead.Init();
        });
    </script>
</asp:Content>
