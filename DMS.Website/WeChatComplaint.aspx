<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WeChatComplaint.aspx.cs"
    Inherits="DMS.Website.WeChatComplaint" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script src="resources/cooliteHelper.js" type="text/javascript"></script>

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
    <ext:Store ID="AnswerStateStore" runat="server" UseIdConfirmation="false" AutoLoad="true"
        OnRefreshData="AnswerStateStore_RefershData">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
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
    <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="WdtId" />
                    <ext:RecordField Name="WupId" />
                    <ext:RecordField Name="QuestionTitle" />
                    <ext:RecordField Name="QuestionBody" />
                    <ext:RecordField Name="Answer" />
                    <ext:RecordField Name="CreateDate   " />
                    <ext:RecordField Name="UserID" />
                    <ext:RecordField Name="UserName" />
                    <ext:RecordField Name="DealerName" />
                    <ext:RecordField Name="AnswerDate" />
                    <ext:RecordField Name="AnswerUserId" />
                    <ext:RecordField Name="AnswerUserName" />
                    <ext:RecordField Name="Status" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hfUserId" runat="server">
    </ext:Hidden>
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
                                                        <ext:ComboBox ID="cbComplaintType" runat="server" EmptyText="请选择投诉内容" Width="150"
                                                            Editable="false" TypeAhead="true" StoreID="ComplaintTypeStore" ValueField="ID"
                                                            DisplayField="NameCN" Mode="Local" FieldLabel="投诉内容" ListWidth="300" Resizable="true">
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
                                                        <ext:ComboBox ID="cbAnswerStatus" runat="server" EmptyText="请选择回复状态" Width="150"
                                                            Editable="false" TypeAhead="true" StoreID="AnswerStateStore" ValueField="Id"
                                                            Mode="Local" DisplayField="Value" FieldLabel="回复状态" ListWidth="300" Resizable="true">
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
                                                <ext:Column ColumnID="QuestionTitle" DataIndex="QuestionTitle" Header="投诉类型" Width="300">
                                                </ext:Column>
                                                <ext:Column ColumnID="WupId" DataIndex="WupId" Header="产品线" Width="200">
                                                    <Renderer Handler="return getNameFromStoreById(ProductLineStore,{Key:'Id',Value:'AttributeName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="提问人" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="所属经销商" Width="200">
                                                </ext:Column>
                                                <ext:CheckColumn ColumnID="Status" DataIndex="Status" Header="答复状态" Align="Center">
                                                </ext:CheckColumn>
                                                <ext:CommandColumn Width="50" Header="回答" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="回答" />
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
                                                                    var contid = record.data.ContractID;
                                                                    Coolite.AjaxMethods.AnswerItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                   
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
                                                    <ext:Label runat="server" ID="textUserName" FieldLabel="提问人">
                                                    </ext:Label>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Label ID="textDealerName" runat="server" FieldLabel="所属经销商">
                                                    </ext:Label>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="taTextComplaintType" runat="server" EmptyText="请选择投诉内容" Width="150"
                                                        Editable="false" TypeAhead="true" StoreID="ComplaintTypeStore" ValueField="ID"
                                                        DisplayField="NameCN" Mode="Local" FieldLabel="投诉内容" ListWidth="300" Resizable="true"
                                                        ReadOnly="true" Enabled="false">
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
                                                    <ext:TextArea ID="taTextAnswer" runat="server" FieldLabel="回复" Width="220">
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
            <ext:Button ID="btnSubmit" runat="server" Text="提交" Icon="Tick">
                <Listeners>
                    <Click Handler="  Coolite.AjaxMethods.Submint();" />
                </Listeners>
            </ext:Button>
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
