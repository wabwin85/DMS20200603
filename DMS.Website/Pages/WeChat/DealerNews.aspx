<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerNews.aspx.cs" Inherits="DMS.Website.Pages.WeChat.DealerNews" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

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
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_ProductLine">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="AttributeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Id" Direction="ASC" />
        <Listeners>
            <Load Handler="" />
        </Listeners>
    </ext:Store>
    <ext:Store ID="ComplaintTypeStore" runat="server" UseIdConfirmation="false" OnRefreshData="ComplaintTypeStore_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="ID">
                <Fields>
                    <ext:RecordField Name="ID" />
                    <ext:RecordField Name="NameEN" />
                    <ext:RecordField Name="NameCN" />
                    <ext:RecordField Name="DeleteFlag" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="DealerTypeStore" runat="server" UseIdConfirmation="false" OnRefreshData="DealerTypeStore_RefreshData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Key" Direction="ASC" />
        <Listeners>
        </Listeners>
    </ext:Store>
    <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ProductLineId" />
                    <ext:RecordField Name="Tital" />
                    <ext:RecordField Name="Body" />
                    <ext:RecordField Name="CreateUserId" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="Url   " />
                    <ext:RecordField Name="DealerName" />
                    <ext:RecordField Name="UserName" />
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
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbComplaintType" runat="server" EmptyText="请消息类型" Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="ComplaintTypeStore" ValueField="ID" DisplayField="NameCN"
                                                            Mode="Local" FieldLabel="消息类型" ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="请选择产品线" Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" Mode="Local" DisplayField="AttributeName"
                                                            FieldLabel="产品线" ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".4">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealerType" runat="server" FieldLabel="所属经销商类型" StoreID="DealerTypeStore"
                                                            Editable="false" TypeAhead="true" Mode="Local" DisplayField="Value" ValueField="Key"
                                                            Width="150" ForceSelection="true" TriggerAction="All" EmptyText="请选择所属经销商类型"
                                                            ItemSelector="div.list-item" SelectOnFocus="true" AllowBlank="false">
                                                            <Template ID="Template2" runat="server">
                                                                            <tpl for=".">
                                                                                <div class="list-item">
                                                                                     {Value}
                                                                                </div>
                                                                            </tpl>
                                                            </Template>
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
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
                                                <ext:Column ColumnID="Tital" DataIndex="Tital" Header="消息类型" Width="300">
                                                    <Renderer Handler="return getNameFromStoreById(ComplaintTypeStore,{Key:'ID',Value:'NameCN'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineId" DataIndex="ProductLineId" Header="产品线" Width="200">
                                                    <Renderer Handler="return getNameFromStoreById(ProductLineStore,{Key:'Id',Value:'AttributeName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="提交人" >
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="提交时间" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="所属经销商" Width="200">
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
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                        </BottomBar>
                                        <Listeners>
                                            <Command Handler="if (command == 'Edit')
                                                                   {
                                                                    var contid = record.data.ContractID;
                                                                    Coolite.AjaxMethods.DetailItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                   
                                                                   }
                                              " />
                                        </Listeners>
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
    <ext:Window ID="InputWindow" runat="server" Icon="Group" Title="经销商投诉建议回复" Resizable="false"
        Header="false" Width="390" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
        BodyStyle="padding:5px;">
        <Body>
            <ext:FormLayout ID="FormLayout9" runat="server">
                <ext:Anchor>
                    <ext:Hidden ID="texthdId" runat="server">
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
                                                    <ext:Label runat="server" ID="textUserName" FieldLabel="提交人">
                                                    </ext:Label>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Label ID="textDealerName" runat="server" FieldLabel="所属经销商">
                                                    </ext:Label>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="taTextComplaintType" runat="server" EmptyText="" Width="150" Editable="false"
                                                        TypeAhead="true" StoreID="ComplaintTypeStore" ValueField="ID" DisplayField="NameCN"
                                                        Mode="Local" FieldLabel="消息类型" ListWidth="300" Resizable="true" ReadOnly="true"
                                                        Enabled="false">
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="taProductLine" runat="server" EmptyText="请选择产品线" Width="150" Editable="false"
                                                        TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" Mode="Local" DisplayField="AttributeName"
                                                        FieldLabel="产品线" ListWidth="300" Resizable="true" ReadOnly="true" Enabled="false">
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextArea ID="taTextBody" runat="server" FieldLabel="描述" Width="220" ReadOnly="true">
                                                    </ext:TextArea>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Image runat="server" ID="textImage" Width="180" Height="130" LabelSeparator="">
                                                    </ext:Image>
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
