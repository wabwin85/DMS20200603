<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DPPermissionsInfo.aspx.cs"
    Inherits="DMS.Website.Pages.DP.DPPermissionsInfo" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>设置权限</title>

    <script type="text/javascript">
        function refreshTree(tree) {
            Coolite.AjaxMethods.RefreshMenu({
                success: function(result) {
                    var nodes = eval(result);
                    tree.root.ui.remove();
                    tree.initChildren(nodes);
                    tree.root.render();
                }
            });
        }
        
           var SubmitClick = function(tree) {
           var checkedNodes = tree.getChecked();
           var Nodesid = [];
             for(var i=0;i<checkedNodes.length;i++){
                Nodesid.push(checkedNodes[i].id);
             }
             Coolite.AjaxMethods.btnSubmitDate(Nodesid.toString(),{success: function(){Ext.Msg.alert("消息","权限设置成功！")} })
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="设置权限" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfRoleName" runat="server" FieldLabel="角色名称" Width="180" ReadOnly="true" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfLastUpdateUser" runat="server" Hidden="true" ReadOnly="true" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfRoleID" runat="server" Hidden="true" ReadOnly="true" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:TreePanel ID="TreePanel1" runat="server" Icon="Anchor" Title="经销商信息模块" AutoScroll="true"
                                        Width="500" Collapsed="False" CollapseFirst="True" HideParent="False" RootVisible="False"
                                        BodyStyle="padding-left:5px">
                                        <Tools>
                                            <ext:Tool Type="Refresh" Qtip="Refresh" Handler="refreshTree(#{TreePanel1});" />
                                        </Tools>
                                    </ext:TreePanel>
                                </ext:FitLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSubmit" Text="提交" runat="server" Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="SubmitClick(#{TreePanel1})" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </div>
    </form>
</body>
</html>
