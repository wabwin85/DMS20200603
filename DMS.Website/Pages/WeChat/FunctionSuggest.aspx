<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FunctionSuggest.aspx.cs"
    Inherits="DMS.Website.Pages.WeChat.FunctionSuggest" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

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
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Body" />
                    <ext:RecordField Name="UserId" />
                    <ext:RecordField Name="UserName" />
                    <ext:RecordField Name="DealerName" />
                    <ext:RecordField Name="DealerType" />
                    <ext:RecordField Name="CreateDate" />
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
                                                        <ext:DateField ID="dfBeginDate" runat="server" Width="150" FieldLabel="提交开始时间" />
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
                                                        <ext:DateField ID="dfEndDate" runat="server" Width="150" FieldLabel="提交终止时间" />
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
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="提交人" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="所属公司" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerType" DataIndex="DealerType" Header="经销商类型" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="提交时间" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="Body" DataIndex="Body" Header="内容" Width="150">
                                                </ext:Column>
                                                <ext:CommandColumn Width="50" Header="明细" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="明细" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler="if (command == 'Edit')
                                                                   {
                                                                        Coolite.AjaxMethods.EditSuggestItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});
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
    <ext:Window ID="InputWindow" runat="server" Icon="Group" Title="新功能建议详细信息" Resizable="false"
        Header="false" Width="380" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
        BodyStyle="padding:5px;">
        <Body>
            <ext:FormLayout ID="FormLayout9" runat="server">
                <ext:Anchor>
                    <ext:Panel ID="Panel27" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                <ext:LayoutColumn ColumnWidth="1">
                                    <ext:Panel ID="Panel28" runat="server" Border="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="90">
                                                <ext:Anchor>
                                                    <ext:Label ID="txtUserName" runat="server" FieldLabel="用户名称">
                                                    </ext:Label>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Label ID="txtDealerName" runat="server" FieldLabel="所属经销商">
                                                    </ext:Label>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Label ID="txtDealerType" runat="server" FieldLabel="经销商等级">
                                                    </ext:Label>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Label ID="txtDate" runat="server" FieldLabel="提交时间">
                                                    </ext:Label>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextArea ID="txtBody" runat="server" FieldLabel="内容" Width="220" Enabled="true">
                                                    </ext:TextArea>
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
            <ext:Button ID="btnReturnFaqCancel" runat="server" Text="返回" Icon="Delete">
                <Listeners>
                    <Click Handler="#{InputWindow}.hide();" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>
    </form>
</body>
</html>
