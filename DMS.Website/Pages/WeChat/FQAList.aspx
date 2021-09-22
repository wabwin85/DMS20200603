<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FQAList.aspx.cs" Inherits="DMS.Website.Pages.WeChat.FQAList" %>

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
    <ext:Store ID="StateStore" runat="server" UseIdConfirmation="false" OnRefreshData="StateStore_RefershData"
        AutoLoad="true">
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
    <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Title" />
                    <ext:RecordField Name="Body" />
                    <ext:RecordField Name="State" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="CreateUser" />
                    <ext:RecordField Name="UpdateDate" />
                    <ext:RecordField Name="UpdateUser" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshAttachment"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Attachment" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Url" />
                    <ext:RecordField Name="Type" />
                    <ext:RecordField Name="UploadUser" />
                    <ext:RecordField Name="Identity_Name" />
                    <ext:RecordField Name="UploadDate" />
                    <ext:RecordField Name="TypeName" />
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
                                                        <ext:TextField ID="tfTital" runat="server" Width="200" FieldLabel="标题">
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
                                                        <ext:ComboBox ID="cbState" runat="server" EmptyText="请选择发布状态" Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="StateStore" ValueField="Id" Mode="Local" DisplayField="Value"
                                                            FieldLabel="发布状态" ListWidth="300" Resizable="true">
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
                                <ext:Button ID="btnAdd" runat="server" Text="新增" Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.ShowFQAWindow();" />
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
                                                <ext:Column ColumnID="Title" DataIndex="Title" Header="标题" Width="250">
                                                </ext:Column>
                                                <ext:CheckColumn ColumnID="State" DataIndex="State" Header="发布状态" Align="Center">
                                                </ext:CheckColumn>
                                                <ext:CommandColumn Width="50" Header="修改" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="修改" />
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
                                                                    Coolite.AjaxMethods.EditFQAItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                   
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
    <ext:Window ID="FaqInputWindow" runat="server" Icon="Group" Title="常见问题维护" Resizable="false"
        Header="false" Width="500" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
        BodyStyle="padding:5px;">
        <Body>
            <ext:FormLayout ID="FormLayout9" runat="server">
                <ext:Anchor>
                    <ext:Hidden ID="fqaId" runat="server">
                    </ext:Hidden>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Hidden ID="fqaOperationType" runat="server">
                    </ext:Hidden>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Panel ID="Panel27" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                <ext:LayoutColumn ColumnWidth="1">
                                    <ext:Panel ID="Panel28" runat="server" Border="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="100">
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfTextTital" runat="server" FieldLabel="标题">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextArea ID="taTextBody" runat="server" FieldLabel="内容" Width="220">
                                                    </ext:TextArea>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Checkbox ID="cbTextState" runat="server" FieldLabel="发布状态">
                                                    </ext:Checkbox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel3" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:0px;">
                                                        <Body>
                                                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                                <ext:LayoutColumn ColumnWidth=".8">
                                                                    <ext:Panel ID="Panel4" runat="server" Border="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="100">
                                                                                <ext:Anchor>
                                                                                    <ext:FileUploadField ID="ufTextUpload" runat="server" FieldLabel="上传图片" Width="220"
                                                                                        ButtonText="" Icon="ImageAdd">
                                                                                    </ext:FileUploadField>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth=".2">
                                                                    <ext:Panel ID="Panel5" runat="server" Border="false">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="100">
                                                                                <ext:Anchor>
                                                                                    <ext:Button ID="Button1" runat="server" Text="保存图片" Icon="Tick">
                                                                                        <Listeners>
                                                                                            <Click Handler=" Coolite.AjaxMethods.SavePicture(
                                                                                                                            {success:function(result)
                                                                                                                            { 
                                                                                                                                if(result=='') 
                                                                                                                                { #{gpAttachment}.reload();} 
                                                                                                                                else { Ext.Msg.alert('Error', result);}
                                                                                                                             },
                                                                                                                             failure:function(err)
                                                                                                                             {Ext.Msg.alert('Error', err);}
                                                                                                                             });" />
                                                                                        </Listeners>
                                                                                    </ext:Button>
                                                                                </ext:Anchor>
                                                                            </ext:FormLayout>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:LayoutColumn>
                                                            </ext:ColumnLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Panel ID="plAttachment" runat="server" Title="图片" Frame="True" Icon="Application"
                                                        AutoHeight="True" AutoScroll="True" IDMode="Legacy">
                                                        <Body>
                                                            <ext:GridPanel ID="gpAttachment" runat="server" StoreID="AttachmentStore" Header="false"
                                                                Border="true" Icon="Lorry" StripeRows="true" Height="200" >
                                                                <ColumnModel ID="ColumnModel8" runat="server">
                                                                    <Columns>
                                                                        <ext:Column ColumnID="Name" DataIndex="Name" Width="150" Header="附件名称">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Width="90" Header="上传时间">
                                                                        </ext:Column>
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
                                                                    <ext:RowSelectionModel ID="RowSelectionModel2" runat="server">
                                                                    </ext:RowSelectionModel>
                                                                </SelectionModel>
                                                                <BottomBar>
                                                                    <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="30" StoreID="AttachmentStore"
                                                                        DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                                </BottomBar>
                                                                <Listeners>
                                                                    <Command Handler="if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该文件?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                        success: function() {
                                                                                            #{gpAttachment}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });
                                                                    }" />
                                                                </Listeners>
                                                                <LoadMask ShowMask="true" Msg="处理中..." />
                                                            </ext:GridPanel>
                                                        </Body>
                                                        <LoadMask ShowMask="True" Msg="处理中..." />
                                                    </ext:Panel>
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
            <ext:Button ID="btnFqaSubmit" runat="server" Text="提交" Icon="Tick">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.SubmintFqa();" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="btnReturnFaqCancel" runat="server" Text="返回" Icon="Delete">
                <Listeners>
                    <Click Handler="#{FaqInputWindow}.hide();" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>
    </form>
</body>
</html>
