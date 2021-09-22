<%@ Page Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="DealerAccountResetPWD.aspx.cs"
    Inherits="DMS.Website.Revolution.Pages.HCPPassport.DealerAccountResetPWD" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
     <input type="hidden" id="IptUserName" class="FrameControl" />
     <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-navicon'></i>&nbsp;密码重置</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        登录ID
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="UserName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        用户姓名
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="IptName" class="FrameControl"></div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        <i class="fa fa-fw fa-require"></i>新密码
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="IptNewPassword" class="FrameControl"></div>
                                    </div>
                                </div>


                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        <i class="fa fa-fw fa-require"></i>确认密码
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="IptComNewPassword" class="FrameControl"></div>
                                    </div>
                                </div>


                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-buttom" id="PnlButton">
                                    <a id="BtnChange"></a>
                                    <a id="BtnClose"></a>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

        </div>
    </div>
    <div style="display: none;">
        <input id="Title" />
        <input id="SuccessUrl" name="SuccessUrl" runat="server" />
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/DealerAccountResetPWD.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            DealerAccountResetPWD.Init();
        });
    </script>
</asp:Content>
