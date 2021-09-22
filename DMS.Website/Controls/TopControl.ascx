<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TopControl.ascx.cs"
    Inherits="DMS.Website.Controls.TopControl" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">
    function LogoutClick() {
        Coolite.AjaxMethods.Logout();
    }
</script>

<div id="settingsWrapper">
    <table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-collapse: collapse;" >
        <tbody>
            <tr>
                
                <td align="right" style="width:100%;">
                    <div id="settings">
                        <ul>
                            <li><ext:Label ID="lbWelcome" runat="server"></ext:Label></li>
                            <li id="itemAddContent"><a href="/"><%=GetLocalResourceObject("DMS.Homepage").ToString()%></li>
                            <!--<li id="itemComments"><a href="#">FAQ</a></li> -->
                            
                            <%
                                Lafite.RoleModel.Security.IRoleModelContext context = Lafite.RoleModel.Security.RoleModelContext.Current;

                                if (context!= null && context.IsInRole("Administrators"))
                                {
                                 %>
                            <li id="itemContacts"><a href="/admin/">Administration</a></li>
                            <%
                                } %>
                                
                            <li id="itemLogout">
                                <ext:LinkButton runat="server" Text="<%$ Resources:LogoutButton.Text%>">
                                    <Listeners>
                                        <Click Handler="#{AjaxMethods}.Logout();" />
                                    </Listeners>
                                </ext:LinkButton>
                                <ext:LinkButton runat="server" Text="Theme" Hidden="true">
                                    <Listeners>
                                        <Click Handler="changeTheme();" />
                                    </Listeners>
                                </ext:LinkButton>
                            </li>
                        </ul>
                    </div>
                </td>
                <td>
                    <img src="../resources/images/banner0910.png" alt="bg"  style="margin:0;padding:0px;display:block;" />
                </td>
            </tr>
        </tbody>
    </table>
</div>
