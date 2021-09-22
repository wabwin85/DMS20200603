<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WeChatUserList.aspx.cs"
    Inherits="DMS.Website.Pages.WeChat.WeChatUserList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
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
    <ext:Store ID="PositionStore" runat="server" UseIdConfirmation="false" OnRefreshData="PositionStore_RefershData"
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
    <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="UserName" />
                    <ext:RecordField Name="Phone" />
                    <ext:RecordField Name="Post" />
                    <ext:RecordField Name="DealerName" />
                    <ext:RecordField Name="NickName" />
                    <ext:RecordField Name="Sex" />
                    <ext:RecordField Name="Email" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hiddenRetrun" runat="server">
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
                            
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfName" runat="server" Width="200" FieldLabel="姓名">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                    <ext:Panel runat="server">
                                                    <Body>
                                                    <div style=" color:Red;">提交后请通知微信用户在手机上查收四位邀请码，扫描DMS首页二维码后在对话框输入：手机号 邀请码，注意手机号与邀请码中含空格。如果在绑定过程中遇到问题请联系：2976286693@qq.com。</div>
                                                    </Body>
                                                    </ext:Panel>
                                                   
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
                                                        <ext:ComboBox ID="cbPosition" runat="server" EmptyText="请选择职位" Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="PositionStore" ValueField="PositKey" Mode="Local" DisplayField="PositName"
                                                            FieldLabel="职位" Resizable="true">
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
                                        <Click Handler="Coolite.AjaxMethods.ShowUserWindow();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnReturn" Hidden="true" runat="server" Text="返回" Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.Retrun();" />
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
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="用户名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="NickName" DataIndex="NickName" Header="昵称">
                                                </ext:Column>
                                                <ext:Column ColumnID="Post" DataIndex="Post" Header="职位">
                                                    <Renderer Handler="return getNameFromStoreById(PositionStore,{Key:'PositKey',Value:'PositName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Phone" DataIndex="Phone" Header="手机">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商名称" Width="250">
                                                </ext:Column>
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
                                            <Command Handler="if (command == 'Edit')
                                                                   {
                                                                    var contid = record.data.ContractID;
                                                                    Coolite.AjaxMethods.EditUserItem(record.data.Id,{failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                   
                                                                   }
                                                                   else if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该用户?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.DeleteUserItem(record.data.Id,{
                                                                                        success: function() {
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
    <ext:Window ID="UserInputWindow" runat="server" Icon="Group" Title="微信登录人员维护" Resizable="false"
        Header="false" Width="390" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
        BodyStyle="padding:5px;">
        <Body>
            <ext:FormLayout ID="FormLayout9" runat="server">
                <ext:Anchor>
                    <ext:Hidden ID="userId" runat="server">
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
                                                    <ext:TextField ID="tfTextName" runat="server" FieldLabel="姓名">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfTextNickName" runat="server" FieldLabel="昵称" Hidden="true">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:NumberField ID="nfTextPhone" runat="server" FieldLabel="手机号码">
                                                    </ext:NumberField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbTextPosition" runat="server" EmptyText="请选择职位" Editable="false"
                                                        TypeAhead="true" StoreID="PositionStore" ValueField="PositKey" Mode="Local" DisplayField="PositName"
                                                        FieldLabel="职位" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:RadioGroup ID="rgTextSex" runat="server" FieldLabel="性别">
                                                        <Items>
                                                            <ext:Radio ID="radioSexB" runat="server" BoxLabel="男" Checked="true" />
                                                            <ext:Radio ID="radioSexG" runat="server" BoxLabel="女" Checked="false" />
                                                        </Items>
                                                    </ext:RadioGroup>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="tfTextMail" runat="server" FieldLabel="邮箱">
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
            <ext:Button ID="btnUserSubmit" runat="server" Text="提交" Icon="Tick">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.SubmintUser({success:function(result){ if(result=='') {Ext.Msg.alert('注册成功', '请查收短信或邮箱获取4位邀请码，在微信平台输入手机号（空格）邀请码，完成绑定。 <br> 若无法成功绑定，可三分钟后重新输入手机号（空格）邀请码，若仍有问题，请邮件至bscdealer@bsci.com或询问商务部负责同事。'); #{UserInputWindow}.hide(); #{GridPanel1}.reload();} else {Ext.Msg.alert('Error', result);}}});" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="btnReturnUserCancel" runat="server" Text="返回" Icon="Delete">
                <Listeners>
                    <Click Handler="#{UserInputWindow}.hide();" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>
    </form>
</body>
</html>
