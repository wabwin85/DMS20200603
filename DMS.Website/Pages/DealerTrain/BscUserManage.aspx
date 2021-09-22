<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BscUserManage.aspx.cs"
    Inherits="DMS.Website.Pages.DealerTrain.BscUserManage" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>波科用户维护</title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });

        function RefreshMainPage() {
            Ext.getCmp('<%=this.PagBscUserList.ClientID%>').changePage(1);
        }

        function SaveBscUserInfo() {
            var rtnVal = Ext.getCmp('<%=this.IptRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.IptRtnMsg.ClientID%>');

            var errMsg = "";
            var isFormValid = Ext.getCmp('<%=this.FrmBscUserInfo.ClientID%>').getForm().isValid();

            if (!isFormValid) {
                errMsg = "请填写完整用户信息";
            }

            if (errMsg != "") {
                Ext.Msg.alert('Message', errMsg);
            } else {
                Ext.Msg.confirm('Message', "是否确认提交此用户信息？",
                    function(e) {
                        if (e == 'yes') {
                            Coolite.AjaxMethods.SaveBscUserInfo(
                                {
                                    success: function() {
                                        if (rtnVal.getValue() == 'True') {
                                            Ext.Msg.alert('Message', '保存成功！');
                                            Ext.getCmp('<%=this.WdwBscUserInfo.ClientID%>').hide();
                                            RefreshMainPage();
                                        } else {
                                            Ext.Msg.alert('Message', rtnMsg.getValue());
                                        }
                                    },
                                    failure: function(err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                            );
                        }
                    }
                );
            }
        }

        function DeleteBscUserInfoById(bscUserId) {
            var rtnVal = Ext.getCmp('<%=this.IptRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.IptRtnMsg.ClientID%>');

            Ext.Msg.confirm('Message', '确定删除用户信息吗？',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.DeleteBscUserInfo(
                            bscUserId,
                            {
                                success: function() {
                                    Ext.Msg.alert('Message', '删除成功！');
                                    Ext.getCmp('<%=this.WdwBscUserInfo.ClientID%>').hide();
                                    RefreshMainPage();
                                },
                                failure: function(err) {
                                    Ext.Msg.alert('Error', err);
                                }
                            }
                        );
                    }
                }
            );
        }

        function DeleteBscUserInfo() {
            var bscUserId = Ext.getCmp('<%=this.IptBscUserId.ClientID%>').getValue();

            DeleteBscUserInfoById(bscUserId);
        }

        function SaveDealer(grid) {
            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();
                var param = '';

                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].data.DealerId + ',';
                }

                Coolite.AjaxMethods.SaveDealer(param);
            } else {
                Ext.MessageBox.alert('错误', '请选择要添加的经销商');
            }
        }

        function DeleteTeacherDealer(bscUserId, dealerId) {
            var rtnVal = Ext.getCmp('<%=this.IptRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.IptRtnMsg.ClientID%>');

            Ext.Msg.confirm('Message', '确定删除经销商吗？',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.DeleteDealer(
                            bscUserId,
                            dealerId,
                            {
                                success: function() { Ext.getCmp('<%=this.PagTeacherDealerList.ClientID%>').changePage(1); },
                                failure: function(err) { Ext.Msg.alert('Error', err); }
                            }
                        );
                    }
                }
            );
        }
    </script>

    <div id="DivStore">
        <ext:Store ID="StoUserType" runat="server" OnRefreshData="StoUserType_RefreshData"
            AutoLoad="true">
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
        </ext:Store>
        <ext:Store ID="StoBscUserList" runat="server" UseIdConfirmation="false" OnRefreshData="StoBscUserList_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="BscUserId">
                    <Fields>
                        <ext:RecordField Name="BscUserId" />
                        <ext:RecordField Name="UserName" />
                        <ext:RecordField Name="UserSex" />
                        <ext:RecordField Name="UserPhone" />
                        <ext:RecordField Name="UserEmail" />
                        <ext:RecordField Name="UserType" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoTeacherDealerList" runat="server" UseIdConfirmation="false" OnRefreshData="StoTeacherDealerList_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="BscUserId" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="DealerName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <BaseParams>
                <ext:Parameter Name="BscUserId" Value="#{IptBscUserId}.getValue()" Mode="Raw" />
            </BaseParams>
        </ext:Store>
        <ext:Store ID="StoDealerList" runat="server" UseIdConfirmation="false" OnRefreshData="StoDealerList_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="DealerId">
                    <Fields>
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="DealerName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <BaseParams>
                <ext:Parameter Name="BscUserId" Value="#{IptBscUserId}.getValue()" Mode="Raw" />
            </BaseParams>
        </ext:Store>
    </div>
    <div id="DivHidden">
        <ext:Hidden ID="IptRtnVal" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptRtnMsg" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptIsNew" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptBscUserId" runat="server">
        </ext:Hidden>
    </div>
    <div id="DivView">
        <ext:ViewPort ID="WdwMain" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="PnlSearch" runat="server" Header="true" Title="查询条件" Frame="true"
                            AutoHeight="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="QryUserName" runat="server" Width="200" FieldLabel="姓名">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="QryUserType" runat="server" EmptyText="请选择用户类型…" Width="220" Editable="false"
                                                            AllowBlank="false" TypeAhead="true" StoreID="StoUserType" ValueField="Key" DisplayField="Value"
                                                            FieldLabel="用户类型" ListWidth="220" Resizable="true">
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
                                <ext:Button ID="BtnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagBscUserList}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="BtnAdd" runat="server" Text="新增" Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="
                                            #{IptIsNew}.setValue('True');
                                            #{IptBscUserId}.setValue('00000000-0000-0000-0000-000000000000');
                                            Coolite.AjaxMethods.ShowBscUserInfo(
                                                '00000000-0000-0000-0000-000000000000',
                                                {
                                                    success:function() {
                                                        #{PagTeacherDealerList}.changePage(1);
                                                        #{FrmBscUserInfo}.reload(); 
                                                    },
                                                    failure:function(err) {
                                                        Ext.Msg.alert('Error', err);
                                                    }
                                                }
                                            );
                                            
                                        " />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="Panel23" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="RstBscUserList" runat="server" Title="查询结果" StoreID="StoBscUserList"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="用户" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserPhone" DataIndex="UserPhone" Header="手机" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserEmail" DataIndex="UserEmail" Header="邮箱" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserType" DataIndex="UserType" Header="用户类型" Width="200">
                                                </ext:Column>
                                                <ext:CommandColumn Width="50" Header="操作" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="查看" />
                                                        </ext:GridCommand>
                                                        <ext:CommandSeparator />
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
                                            <Command Handler="
                                                if (command == 'Edit') {
                                                    #{IptIsNew}.setValue('False');
                                                    #{IptBscUserId}.setValue(record.data.BscUserId);
                                                    Coolite.AjaxMethods.ShowBscUserInfo(
                                                        record.data.BscUserId,
                                                        {
                                                            success: function() {#{FrmBscUserInfo}.reload();},
                                                            failure: function(err) {Ext.Msg.alert('Error', err);}
                                                        }
                                                    );
                                                    #{PagTeacherDealerList}.changePage(1);
                                                } if (command == 'Delete') {
                                                    DeleteBscUserInfoById(record.data.BscUserId);
                                                }
                                              " />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagBscUserList" runat="server" PageSize="15" StoreID="StoBscUserList"
                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中…" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Window ID="WdwBscUserInfo" runat="server" Icon="Group" Title="签约明细" Resizable="false"
            Header="false" Width="800" Height="500" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <North MarginsSummary="5 5 5 5">
                        <ext:FormPanel ID="FrmBscUserInfo" runat="server" Header="false" Frame="true" Border="false"
                            BodyBorder="false" AutoHeight="true">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel11" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptUserName" runat="server" FieldLabel="姓名" AllowBlank="false"
                                                            Width="300">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="IptUserSex" runat="server" FieldLabel="性别" Width="300">
                                                            <Items>
                                                                <ext:Radio ID="IptUserSexM" runat="server" BoxLabel="男" Checked="true" />
                                                                <ext:Radio ID="IptUserSexF" runat="server" BoxLabel="女" Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptUserPhone" runat="server" FieldLabel="手机号码" AllowBlank="false"
                                                            Width="300">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptUserEmail" runat="server" FieldLabel="邮箱" AllowBlank="false"
                                                            Width="300">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:CheckboxGroup ID="IptUserType" runat="server" FieldLabel="用户类型" Width="300"
                                                            AllowBlank="false">
                                                            <Items>
                                                                <ext:Checkbox ID="IptUserTypeLecturer" runat="server" BoxLabel="培训讲师" Checked="false">
                                                                </ext:Checkbox>
                                                                <ext:Checkbox ID="IptUserTypeTeacher" runat="server" BoxLabel="跟台带教" Checked="false">
                                                                    <Listeners>
                                                                        <Check Handler="#{BtnAddDealer}.setDisabled(!this.checked);" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                                <ext:Checkbox ID="IptUserTypeManager" runat="server" BoxLabel="培训经理" Checked="false">
                                                                </ext:Checkbox>
                                                            </Items>
                                                        </ext:CheckboxGroup>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:Panel ID="FrmTeacherDealerList" runat="server" Header="false" Border="false">
                            <Body>
                                <ext:FitLayout ID="FTHeader" runat="server">
                                    <ext:GridPanel ID="RstTeacherDealerList" runat="server" Title="经销商" StoreID="StoTeacherDealerList"
                                        StripeRows="true" Border="false" Icon="Lorry" Header="false">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar1" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                    <ext:Button ID="BtnAddDealer" runat="server" Text="添加" Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="if(#{IptBscUserId}.getValue() == '') {alert('请等待数据加载完毕！');} else { #{QryDealerName}.setValue(''); #{RstDealerList}.clear(); #{WdwDealer}.show(); }" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="200">
                                                </ext:Column>
                                                <ext:CommandColumn Width="50" Header="操作" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                            <ToolTip Text="删除" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagTeacherDealerList" runat="server" PageSize="10" StoreID="StoTeacherDealerList"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <Listeners>
                                            <Command Handler="
                                                if (command == 'Delete') {
                                                    DeleteTeacherDealer(record.data.BscUserId, record.data.DealerId);
                                                }
                                            " />
                                        </Listeners>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="false" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="BtnSaveBscUserInfo" runat="server" Text="提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="SaveBscUserInfo();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnDeleteBscUserInfo" runat="server" Text="删除" Icon="Delete">
                    <Listeners>
                        <Click Handler="DeleteBscUserInfo();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnCancelBscUserInfo" runat="server" Text="关闭" Icon="LorryAdd">
                    <Listeners>
                        <Click Handler="#{WdwBscUserInfo}.hide(); #{RstTeacherDealerList}.clear();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Window ID="WdwDealer" runat="server" Icon="Group" Title="选择经销商" Resizable="false"
            Header="false" Width="750" Height="400" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:BorderLayout ID="BorderLayout3" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel6" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel2" runat="server" Border="false" AutoHeight="true">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="QryDealerName" runat="server" FieldLabel="经销商" Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="BtnQueryDealer" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagDealerList}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="RstDealerList" runat="server" Title="经销商" StoreID="StoDealerList"
                                        StripeRows="true" Border="false" Icon="Lorry" Header="false">
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="200">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                                <Listeners>
                                                </Listeners>
                                            </ext:CheckboxSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagDealerList" runat="server" PageSize="10" StoreID="StoDealerList"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="false" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:FormPanel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="BtnSaveDealer" runat="server" Text="提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="SaveDealer(#{RstDealerList});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnCancelDealer" runat="server" Text="返回" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{WdwDealer}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Handler="#{PagTeacherDealerList}.changePage(1);" />
            </Listeners>
        </ext:Window>
    </div>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
