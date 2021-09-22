<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractIAFOperation.aspx.cs" Inherits="DMS.Website.Pages.Contract.ContractIAFOperation" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .x-form-group .x-form-group-header-text
        {
            background-color: #dfe8f6;
            color: Black;
        }
        .x-form-group .x-form-group-header
        {
            padding: 10px;
            border-bottom: 2px solid #99bbe8;
        }
    </style>
</head>
<body>
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <form id="form1" runat="server">
    <ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" OnRefreshData="OrderLogStore_RefershData"
    AutoLoad="true">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="PohId" />
                <ext:RecordField Name="OperUser" />
                <ext:RecordField Name="OperUserId" />
                <ext:RecordField Name="OperUserName" />
                <ext:RecordField Name="OperType" />
                <ext:RecordField Name="OperTypeName" />
                <ext:RecordField Name="OperDate" Type="Date" />
                <ext:RecordField Name="OperNote" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
    <ext:Hidden ID="hdContractID" runat="server">
    </ext:Hidden>
    <div>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="false" BodyBorder="false" Height="0">
                            <Body>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel ID="plForm3" runat="server" Header="true" Title="IAF操作记录"
                            BodyBorder="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="OrderLogStore"
                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                        Icon="Lorry" AutoExpandColumn="OperNote">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="<%$ Resources: gpLog.OperUserId %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="<%$ Resources: gpLog.OperUserName %>"
                                                    Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="<%$ Resources: gpLog.OperTypeName %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="<%$ Resources: gpLog.OperDate %>"
                                                    Width="150">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="<%$ Resources: gpLog.OperNote %>">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="true">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="50" StoreID="OrderLogStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </div>
    </form>
</body>
</html>
