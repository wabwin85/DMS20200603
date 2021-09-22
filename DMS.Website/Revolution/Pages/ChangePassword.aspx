<%@ Page Language="C#" MasterPageFile="~/Revolution/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="DMS.Website.Revolution.Pages.ChangePassword" %>

<asp:Content ID="ContentStyle" ContentPlaceHolderID="StyleContent" runat="server">
</asp:Content>
<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main" style="padding: 5px;">
        <div class="col-xs-12">
            <div class="row" id="plPerson">
                <div class="box box-primary" style="width: 500px;margin-top: 200px;margin-left: auto;margin-right: auto;">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class='fa fa-fw fa-list-alt'></i>&nbsp;请按照提示修改您的密码</h3>
                    </div>
                    <div class="box-body">
                        <div class="col-xs-12">
                            <div class="row">

                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        老密码
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="OldPassword" class="FrameControl"></div>
                                    </div>
                                </div>

                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        新密码
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="NewPassword" class="FrameControl"></div>
                                    </div>
                                </div>

                                
                                <div class="col-xs-12 col-sm-12 col-md-12 col-group">
                                    <div class="col-xs-2 col-label">
                                        确认密码
                                    </div>
                                    <div class="col-xs-10 col-field">
                                        <div id="ComNewPassword" class="FrameControl"></div>
                                    </div>
                                </div>
                               

                            </div> 
                            <div class="row">
                                <div class="col-xs-12 col-buttom" id="PnlButton">
                                    <a id="BtnChange"></a>
                                </div>
                            </div>                          
                        </div>
                        
                    </div>
                </div>
            </div>           
            
        </div>
    </div>
    <div style="display:none;">
        <input id="Title"/>
        <input id="SuccessUrl" name="SuccessUrl" runat="server"/>
    </div>
</asp:Content>
<asp:Content ID="ContentFoot" ContentPlaceHolderID="FootContent" runat="server">
</asp:Content>
<asp:Content ID="ContentScript" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript" src="Script/ChangePassword.js?v=<%=DMS.Common.SR.CONST_JAVA_SCRIPT_VERSION %>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ChangePassword.Init();
        });
    </script>
</asp:Content>
