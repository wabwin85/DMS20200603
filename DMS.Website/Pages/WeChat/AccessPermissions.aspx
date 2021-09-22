<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccessPermissions.aspx.cs"
    Inherits="DMS.Website.Pages.WeChat.AccessPermissions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

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
            for (var i = 0; i < checkedNodes.length; i++) {
                Nodesid.push(checkedNodes[i].id);
            }
            Coolite.AjaxMethods.btnSubmitPermitsDate(Nodesid.toString(), { success: function() { Ext.Msg.alert("消息", "权限设置成功！") } })
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="PositKey">
                <Fields>
                    <ext:RecordField Name="PositKey" />
                    <ext:RecordField Name="PositName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <div>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfPositName" runat="server" Width="200" FieldLabel="职位名称">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                    <ext:Anchor>
                                                        <ext:Hidden ID="hd1" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnAdd" runat="server" Text="新增" Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.ShowPositWindow();" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="PositKey" DataIndex="PositKey" Header="职位ID" Width="250">
                                                </ext:Column>
                                                <ext:Column ColumnID="PositName" DataIndex="PositName" Header="职位名称" Width="250">
                                                </ext:Column>
                                                <ext:CommandColumn Width="70" Header="权限设定" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Permits">
                                                            <ToolTip Text="权限" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:CommandColumn Width="50" Header="修改" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="修改" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                            <ToolTip Text="删除" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler=" if (command == 'Permits')
                                                               {
                                                                    Coolite.AjaxMethods.PermitsPositItem(record.data.PositKey,record.data.PositName,{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                               }
                                                               else if (command == 'Edit')
                                                               {
                                                                    Coolite.AjaxMethods.EditPositItem(record.data.PositKey,{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                               }
                                                               else if(command == 'Delete')
                                                               {
                                                                   Ext.Msg.confirm('警告', '是否要删除该职位?',
                                                                   function(e) {
                                                                        if (e == 'yes') {
                                                                            Coolite.AjaxMethods.DeletePositItem(record.data.PositKey,{
                                                                                success: function() {
                                                                                    Ext.Msg.alert('success', '删除成功！');
                                                                                    #{GridPanel1}.reload();
                                                                                },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                        }
                                                                    });
                                                               }
                                              " />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </div>
    <ext:Window ID="PositInputWindow" runat="server" Icon="Group" Title="职位维护" Resizable="false"
        Header="false" Width="390" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
        BodyStyle="padding:5px;">
        <Body>
            <ext:FormLayout ID="FormLayout9" runat="server">
                <ext:Anchor>
                    <ext:Hidden ID="PositId" runat="server">
                    </ext:Hidden>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Panel ID="Panel27" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                <ext:LayoutColumn ColumnWidth=".5">
                                    <ext:Panel ID="Panel28" runat="server" Border="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="100">
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfTextPositKey" runat="server" FieldLabel="职位ID">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfTextPositName" runat="server" FieldLabel="职位名称" >
                                                    </ext:TextField>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                    </ext:Panel>
                </ext:Anchor>
            </ext:FormLayout>
        </Body>
        <Buttons>
            <ext:Button ID="btnPositSubmit" runat="server" Text="提交" Icon="Tick">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.SubmintPosit();" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="btnReturnPositCancel" runat="server" Text="返回" Icon="Delete">
                <Listeners>
                    <Click Handler="#{PositInputWindow}.hide();" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>
    <ext:Window ID="PermitsWindow" runat="server" Icon="Group" Title="权限"   Resizable="false"
        Header="false" Width="390" AutoShow="false" Modal="true" ShowOnLoad="false"  Height="450"
        BodyStyle="padding:5px;">
        <Body>
            <ext:BorderLayout ID="BorderLayout2" runat="server">
                <North Collapsible="True" Split="True">
                    <ext:Panel ID="Panel3" runat="server" Header="true" Title="设置权限" Frame="true" AutoHeight="true"
                        Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                <ext:LayoutColumn ColumnWidth=".5">
                                    <ext:Panel ID="Panel4" runat="server" Border="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="textPermitsPositionName" runat="server" FieldLabel="职位名称" Width="180"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Hidden ID="textPermitsPositionId" runat="server">
                                                    </ext:Hidden>
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
                    <ext:Panel runat="server" ID="Panel5" Border="false" Frame="true">
                        <Body>
                            <ext:FitLayout ID="FitLayout2" runat="server">
                                <ext:TreePanel ID="TreePanel1" runat="server" Icon="Anchor" Title="职位权限" AutoScroll="false"
                                    Width="500" Collapsed="False" CollapseFirst="True" HideParent="False" RootVisible="False" AutoHeight="true"
                                    BodyStyle="padding-left:5px">
                                    <Tools>
                                        <ext:Tool Type="Refresh" Qtip="Refresh" Handler="refreshTree(#{TreePanel1});" />
                                    </Tools>
                                </ext:TreePanel>
                            </ext:FitLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnPermitsPositionSubmit" Text="提交" runat="server" Icon="Add" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="SubmitClick(#{TreePanel1})" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="Button1" runat="server" Text="返回" Icon="Delete">
                                <Listeners>
                                    <Click Handler="#{PermitsWindow}.hide();" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:Window>
    </form>
</body>
</html>
