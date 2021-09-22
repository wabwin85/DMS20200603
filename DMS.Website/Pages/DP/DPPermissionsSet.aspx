<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DPPermissionsSet.aspx.cs"
    Inherits="DMS.Website.Pages.DP.DPPermissionsSet" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        .list-item
        {
            font: normal 11px tahoma, arial, helvetica, sans-serif;
            padding: 3px 10px 3px 10px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #555;
        }
        .list-item h3
        {
            display: block;
            font: inherit;
            font-weight: bold;
            color: #222;
        }
    </style>
</head>
<body>

    <script type="text/javascript">
      
        var RoleDetailsRender = function () {
            return '<img class="imgEdit" ext:qtip="Permissions Set" style="cursor:pointer;" src="../../resources/images/icons/vcard_edit.png" />';
            
        }


        var cellClick = function(grid, rowIndex, columnIndex, e) {  //gradpanel events
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

            
            if (t.className == 'imgEdit' && columnId == 'Details2') {
                Coolite.AjaxMethods.BindIFrameUrl(record.id,record.data['RoleName']);
            }
        }
    </script>

    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Store ID="RoleStore" runat="server" AutoLoad="true" UseIdConfirmation="true"
            OnRefreshData="RoleStore_RefreshData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="RoleName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Id" Direction="ASC" />
            <Listeners>
                <LoadException Handler="Ext.Msg.alert(MsgList.RoleStore.LoadExceptionTitle, e.message || e )" />
                <CommitFailed Handler="Ext.Msg.alert(MsgList.RoleStore.CommitFailedTitle, MsgList.RoleStore.CommitFailedMsg + msg)" />
                <SaveException Handler="Ext.Msg.alert(MsgList.RoleStore.SaveExceptionTitle, e.message || e)" />
                <CommitDone Handler="Ext.Msg.alert(MsgList.RoleStore.CommitDoneTitle, MsgList.RoleStore.CommitDoneMsg);" />
            </Listeners>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="经销商信息查询权限设定" Frame="true"
                            AutoHeight="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfRoleName" runat="server" FieldLabel="角色名称" Width="180" />
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
                                        <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="RoleStore" Border="false"
                                        Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="RoleName" DataIndex="RoleName" Header="角色名" Width="200">
                                                </ext:Column>
                                               
                                                 <ext:Column ColumnID="Details2" Header="编辑" Width="50" Align="Center" Fixed="true"
                                                    MenuDisabled="true" Resizable="false">
                                                    <Renderer Fn="RoleDetailsRender" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="13" StoreID="RoleStore"
                                                DisplayInfo="true" DisplayMsg="{2}个附件中第{0}-{1}个" EmptyMsg="没有角色数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                        <Listeners>
                                            <CellClick Fn="cellClick" />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
       
        <ext:Window ID="WindowPermissionsSet" runat="server" Title="设置权限" Width="680"
            Height="450" Modal="true" Collapsible="true" Maximizable="true" ShowOnLoad="false">
            <AutoLoad Mode="IFrame">
            </AutoLoad>
        </ext:Window>
    </div>
    </form>
</body>
</html>
