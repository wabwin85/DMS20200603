<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RedeemGift.aspx.cs" Inherits="DMS.Website.Pages.WeChat.RedeemGift" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
        //添加选中的产品
        var addItems = function(grid) {

            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();
                var param = '';

                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].data.Documentnumber + ',';
                }

                Coolite.AjaxMethods.Approve(param);


            } else {
                Ext.MessageBox.alert('错误', '请选择要审批的礼品单');
            }
        }

        var reject = function(grid) {

            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();
                var param = '';

                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].data.Documentnumber + ',';
                }

                Coolite.AjaxMethods.Reject(param);


            } else {
                Ext.MessageBox.alert('错误', '请选择要审批的礼品单');
            }
        }


    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Store ID="ResultStore" runat="server" AutoLoad="false" OnRefreshData="ResultStore_RefreshData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Documentnumber" />
                        <ext:RecordField Name="Status" />
                        <ext:RecordField Name="UserName" />
                        <ext:RecordField Name="DealerName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="BulletinStatusStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Key" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="DetailStore" runat="server" UseIdConfirmation="false" AutoLoad="false"
            OnRefreshData="DetailStore_Refresh">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="GiftName" />
                        <ext:RecordField Name="Exchangenumber" />
                        <ext:RecordField Name="Data" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtDealerName" runat="server" Width="180" FieldLabel="经销商">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtUserName" runat="server" Width="180" FieldLabel="用户名">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                               <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cmbStatus" runat="server" Width="180" FieldLabel="状态" AllowBlank="true">
                                                        <Items>
                                                        <ext:ListItem Text="待批" Value="待批" />
                                                        <ext:ListItem Text="通过"  Value="通过"/>
                                                        <ext:ListItem Text="拒绝"  Value="拒绝"/>
                                                        </Items>
                                                        </ext:ComboBox>
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
                                        <Click Handler="#{PageToolBar2}.changePage(1);" />
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
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="230">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="用户名" Width="180">
                                                </ext:Column>
                                                <ext:Column ColumnID="Documentnumber" DataIndex="Documentnumber" Header="礼品单号">
                                                </ext:Column>
                                                <ext:Column ColumnID="Status" DataIndex="Status" Header="状态">
                                                </ext:Column>
                                                <ext:CommandColumn Width="60" Header="明细" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="编辑" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                                <Listeners>
                                                </Listeners>
                                            </ext:CheckboxSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler="Coolite.AjaxMethods.Show(record.data.Documentnumber,{success:function(){#{DetailWindow}.show();#{PagingToolBar3}.changePage(1);}});" />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PageToolBar2" runat="server" PageSize="15" StoreID="ResultStore"
                                                DisplayInfo="true" EmptyMsg="没有数据" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="Load" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="ApproveButton" runat="server" Text="通过" Icon="Add">
                                    <Listeners>
                                        <Click Handler="addItems(#{GridPanel1});" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                            <Buttons>
                                <ext:Button ID="Button1" runat="server" Text="拒绝" Icon="Add">
                                    <Listeners>
                                        <Click Handler="reject(#{GridPanel1});" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="礼品明细" Resizable="false"
            Header="false" Width="600" Height="365" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:FitLayout ID="FitLayout3" runat="server">
                    <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Border="false" AutoScroll="true">
                        <Tabs>
                            <ext:Tab ID="Tab2" runat="server" Title="明细" Icon="BrickLink">
                                <Body>
                                    <ext:FormLayout ID="FormLayout7" runat="server">
                                        <ext:Anchor>
                                            <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:GridPanel ID="DetailPanel" runat="server" Title="明细" StoreID="DetailStore" Border="false"
                                                        Icon="Lorry" Height="260" Width="755" AutoScroll="true" EnableHdMenu="false"
                                                        StripeRows="true">
                                                        <ColumnModel ID="ColumnModel3" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="GiftName" DataIndex="GiftName" Header="礼品名称" Width="250">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Exchangenumber" DataIndex="Exchangenumber" Header="数量" Width="200">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Data" DataIndex="Data" Header="申请时间">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server">
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <BottomBar>
                                                            <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="100" StoreID="DetailStore"
                                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                        </BottomBar>
                                                        <SaveMask ShowMask="true" />
                                                    </ext:GridPanel>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </ext:FitLayout>
            </Body>
            <Buttons>
                <ext:Button ID="btnCancel" runat="server" Text="关闭" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{DetailWindow}.hide(null);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Hidden ID="hdnDocumentnumber" runat="server">
        </ext:Hidden>
    </div>
    </form>
</body>
</html>
