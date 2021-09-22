<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ComplaintReply.aspx.cs"
    Inherits="DMS.Website.Pages.WeChat.ComplaintReply" %>

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
        <proxy>
            <ext:DataSourceProxy />
        </proxy>
        <reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="AttributeName" />
                </Fields>
            </ext:JsonReader>
        </reader>
        <sortinfo field="Id" direction="ASC" />
        <listeners>
            <Load Handler="" />
        </listeners>
    </ext:Store>
    <ext:Store ID="AnswerStateStore" runat="server" UseIdConfirmation="false" AutoLoad="true"
        OnRefreshData="AnswerStateStore_RefershData">
        <proxy>
            <ext:DataSourceProxy />
        </proxy>
        <reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </reader>
    </ext:Store>
    <ext:Store ID="ComplaintTypeStore" runat="server" UseIdConfirmation="false" OnRefreshData="ComplaintTypeStore_RefershData"
        AutoLoad="true">
        <proxy>
            <ext:DataSourceProxy />
        </proxy>
        <reader>
            <ext:JsonReader ReaderID="ID">
                <Fields>
                    <ext:RecordField Name="ID" />
                    <ext:RecordField Name="NameEN" />
                    <ext:RecordField Name="NameCN" />
                    <ext:RecordField Name="DeleteFlag" />
                </Fields>
            </ext:JsonReader>
        </reader>
    </ext:Store>
    <ext:Store ID="DealerTypeStore" runat="server" UseIdConfirmation="false" OnRefreshData="DealerTypeStore_RefreshData">
        <proxy>
            <ext:DataSourceProxy />
        </proxy>
        <reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </reader>
        <sortinfo field="Key" direction="ASC" />
        <listeners>
        </listeners>
    </ext:Store>
    <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
        AutoLoad="true">
        <proxy>
            <ext:DataSourceProxy />
        </proxy>
        <reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="WdtId" />
                    <ext:RecordField Name="WupId" />
                    <ext:RecordField Name="QuestionTitle" />
                    <ext:RecordField Name="QuestionBody" />
                    <ext:RecordField Name="Answer" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="UserID" />
                    <ext:RecordField Name="UserName" />
                    <ext:RecordField Name="DealerName" />
                    <ext:RecordField Name="AnswerDate" />
                    <ext:RecordField Name="AnswerUserId" />
                    <ext:RecordField Name="AnswerUserName" />
                    <ext:RecordField Name="Status" />
                </Fields>
            </ext:JsonReader>
        </reader>
    </ext:Store>
    <div>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <north collapsible="True" split="True">
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
                    </north>
                    <center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <columnmodel id="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="QuestionTitle" DataIndex="QuestionTitle" Header="投诉类型" Width="300">
                                                </ext:Column>
                                                <ext:Column ColumnID="WupId" DataIndex="WupId" Header="产品线" Width="200">
                                                    <Renderer Handler="return getNameFromStoreById(ProductLineStore,{Key:'Id',Value:'AttributeName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="提问人">
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="提问时间">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="所属经销商" Width="200">
                                                </ext:Column>
                                                <ext:CheckColumn ColumnID="Status" DataIndex="Status" Header="答复状态" Align="Center">
                                                </ext:CheckColumn>
                                                <ext:Column ColumnID="AnswerUserName" DataIndex="AnswerUserName" Header="应答复人">
                                                </ext:Column>
                                                <ext:Column ColumnID="AnswerDate" DataIndex="AnswerDate" Header="答复时间">
                                                </ext:Column>
                                                <ext:CommandColumn Width="50" Header="查看" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="查看" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </columnmodel>
                                        <selectionmodel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </selectionmodel>
                                        <listeners>
                                            <Command Handler="if (command == 'Edit')
                                                                   {
                                                                    Coolite.AjaxMethods.EditQuestionItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                   }
                                              " />
                                        </listeners>
                                        <bottombar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                        </bottombar>
                                        <savemask showmask="true" />
                                        <loadmask showmask="true" msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </body>
                        </ext:Panel>
                    </center>
                </ext:BorderLayout>
            </body>
        </ext:ViewPort>
    </div>
    <ext:Window ID="QuestionWindow" runat="server" Icon="Group" Title="问题查看" Resizable="false"
        Header="false" Width="450" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
        BodyStyle="padding:5px;">
        <body>
            <ext:FormLayout ID="FormLayout9" runat="server">
                <ext:Anchor>
                    <ext:Hidden ID="questionIdDetail" runat="server">
                    </ext:Hidden>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Panel ID="Panel27" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                        <body>
                            <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                <ext:LayoutColumn ColumnWidth="1">
                                    <ext:Panel ID="Panel28" runat="server" Border="false">
                                        <body>
                                            <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="120">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="taTextComplaintType" runat="server" EmptyText="请选择投诉内容"  Width="220"
                                                        Editable="false" TypeAhead="true" StoreID="ComplaintTypeStore" ValueField="ID"
                                                        DisplayField="NameCN" Mode="Local" FieldLabel="提问类型" ListWidth="300" Resizable="true"
                                                        ReadOnly="true" Enabled="false">
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="taProductLine" runat="server" EmptyText="请选择产品线"  Editable="false" Width="220"
                                                        TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" Mode="Local" DisplayField="AttributeName"
                                                        FieldLabel="产品线" ListWidth="300" Resizable="true" ReadOnly="true" Enabled="false">
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfSubUserDetail" runat="server" FieldLabel="提问人" Width="220">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfSubTimeDetail" runat="server" FieldLabel="提问时间" Width="220">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfDealerNameDetail" runat="server" FieldLabel="所属经销商" Width="220">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextArea ID="taQtDetail" runat="server" FieldLabel="提问内容" Width="220">
                                                    </ext:TextArea>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfStatusDetail" runat="server" FieldLabel="答复状态" Width="220">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextArea ID="taTextAnswer" runat="server" FieldLabel="答复内容" Width="220">
                                                    </ext:TextArea>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfAnswerUserNameDetail" runat="server" FieldLabel="应答复人" Width="220">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfAnswerDateDetail" runat="server" FieldLabel="答复时间" Width="220">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </body>
                    </ext:Panel>
                </ext:Anchor>
            </ext:FormLayout>
        </body>
        <buttons>
            <ext:Button ID="btnReturnCancel" runat="server" Text="关闭" Icon="Delete">
                <Listeners>
                    <Click Handler="#{QuestionWindow}.hide();" />
                </Listeners>
            </ext:Button>
        </buttons>
    </ext:Window>
    </form>
</body>
</html>
