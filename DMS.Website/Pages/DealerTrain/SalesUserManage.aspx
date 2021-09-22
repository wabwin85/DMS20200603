<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SalesUserManage.aspx.cs"
    Inherits="DMS.Website.Pages.DealerTrain.SalesUserManage" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>经销商销售员维护</title>
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
            Ext.getCmp('<%=this.PagDealerSalesList.ClientID%>').changePage(1);
        }

        function SaveDealerSalesInfo() {
            var rtnVal = Ext.getCmp('<%=this.IptRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.IptRtnMsg.ClientID%>');

            var errMsg = "";
            var isFormValid = Ext.getCmp('<%=this.FrmDealerSalesInfo.ClientID%>').getForm().isValid();

            if (!isFormValid) {
                errMsg = "请填写完整销售信息";
            }

            if (errMsg != "") {
                Ext.Msg.alert('Message', errMsg);
            } else {
                Ext.Msg.confirm('Message', "是否确认提交此销售信息？",
                    function(e) {
                        if (e == 'yes') {
                            Coolite.AjaxMethods.SaveDealerSalesInfo(
                                {
                                    success: function() {
                                        if (rtnVal.getValue() == 'True') {
                                            Ext.Msg.alert('Message', '保存成功！');
                                            Ext.getCmp('<%=this.WdwDealerSalesInfo.ClientID%>').hide();
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

        function DeleteDealerSalesInfoById(dealerSalesId) {
            var rtnVal = Ext.getCmp('<%=this.IptRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.IptRtnMsg.ClientID%>');

            Ext.Msg.confirm('Message', '确定删除销售信息吗？',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.DeleteDealerSalesInfo(
                            dealerSalesId,
                            {
                                success: function() {
                                    Ext.Msg.alert('Message', '删除成功！');
                                    Ext.getCmp('<%=this.WdwDealerSalesInfo.ClientID%>').hide();
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

        function DeleteDealerSalesInfo() {
            var dealerSalesId = Ext.getCmp('<%=this.IptDealerSalesId.ClientID%>').getValue();

            DeleteDealerSalesInfoById(dealerSalesId);
        }

        function SaveWechatUser(grid) {
            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();
                var param = '';

                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].data.WeChatUserId + ',';
                }

                Coolite.AjaxMethods.SaveWechatUser(
                    param,
                    {
                        success: function() {
                            Ext.getCmp('<%=this.PagWechatUserList.ClientID%>').changePage(1);
                            RefreshMainPage();
                        },
                        failure: function(err) {
                            Ext.Msg.alert('Error', err);
                        }
                    }
                );
            } else {
                Ext.MessageBox.alert('错误', '请选择要添加的微信用户');
            }
        }
    </script>

    <div id="DivStore">
        <ext:Store ID="StoDealerSalesList" runat="server" UseIdConfirmation="false" OnRefreshData="StoDealerSalesList_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="DealerSalesId">
                    <Fields>
                        <ext:RecordField Name="DealerSalesId" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="SalesName" />
                        <ext:RecordField Name="SalesSex" />
                        <ext:RecordField Name="SalesPhone" />
                        <ext:RecordField Name="SalesEmail" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoWechatUserList" runat="server" UseIdConfirmation="false" OnRefreshData="StoWechatUserList_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="WeChatUserId">
                    <Fields>
                        <ext:RecordField Name="WeChatUserId" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="SalesName" />
                        <ext:RecordField Name="SalesSex" />
                        <ext:RecordField Name="SalesPhone" />
                        <ext:RecordField Name="SalesEmail" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoDealerList" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
    </div>
    <div id="DivHidden">
        <ext:Hidden ID="IptRtnVal" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptRtnMsg" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptIsNew" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptDealerSalesId" runat="server">
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
                                                        <ext:TextField ID="QryDealerName" runat="server" Width="200" FieldLabel="经销商">
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
                                                        <ext:TextField ID="QrySalesName" runat="server" Width="200" FieldLabel="销售">
                                                        </ext:TextField>
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
                                        <Click Handler="#{PagDealerSalesList}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="BtnAdd" runat="server" Text="新增" Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="
                                            #{IptIsNew}.setValue('True');
                                            #{IptDealerSalesId}.setValue('00000000-0000-0000-0000-000000000000');
                                            Coolite.AjaxMethods.ShowDealerSalesInfo(
                                                '00000000-0000-0000-0000-000000000000',
                                                {
                                                    success:function(){ #{FrmDealerSalesInfo}.reload(); },
                                                    failure:function(err){Ext.Msg.alert('Error', err);}
                                                });
                                        " />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="BtnImport" runat="server" Text="从微信用户导入" Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{WdwWechatUser}.show(); #{RstWechatUserList}.clear();" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="Panel23" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="RstDealerSalesList" runat="server" Title="查询结果" StoreID="StoDealerSalesList"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesName" DataIndex="SalesName" Header="销售" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesPhone" DataIndex="SalesPhone" Header="手机" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesEmail" DataIndex="SalesEmail" Header="邮箱" Width="200">
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
                                                    #{IptDealerSalesId}.setValue(record.data.DealerSalesId);
                                                    Coolite.AjaxMethods.ShowDealerSalesInfo(
                                                        record.data.DealerSalesId,
                                                        {
                                                            success: function() {#{FrmDealerSalesInfo}.reload();},
                                                            failure: function(err) {Ext.Msg.alert('Error', err);}
                                                        }
                                                    );
                                                } if (command == 'Delete') {
                                                    DeleteDealerSalesInfoById(record.data.DealerSalesId);
                                                }
                                              " />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagDealerSalesList" runat="server" PageSize="15" StoreID="StoDealerSalesList"
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
        <ext:Window ID="WdwDealerSalesInfo" runat="server" Icon="Group" Title="销售信息" Resizable="false"
            Header="false" Width="500" Height="250" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <Center MarginsSummary="5 5 5 5">
                        <ext:FormPanel ID="FrmDealerSalesInfo" runat="server" Header="false" Frame="true"
                            Border="false" BodyBorder="false" AutoHeight="true">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                    <ext:LayoutColumn ColumnWidth="1">
                                        <ext:Panel ID="Panel11" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="IptDealer" runat="server" EmptyText="请选择经销商…" Width="300" Editable="true"
                                                            AllowBlank="false" TypeAhead="true" StoreID="StoDealerList" ValueField="Id" DisplayField="ChineseName"
                                                            FieldLabel="经销商" ListWidth="300" Resizable="true" Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptSalesName" runat="server" FieldLabel="姓名" AllowBlank="false"
                                                            Width="300">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:RadioGroup ID="IptSalesSex" runat="server" FieldLabel="性别" Width="300">
                                                            <Items>
                                                                <ext:Radio ID="IptSalesSexM" runat="server" BoxLabel="男" Checked="true" />
                                                                <ext:Radio ID="IptSalesSexF" runat="server" BoxLabel="女" Checked="false" />
                                                            </Items>
                                                        </ext:RadioGroup>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptSalesPhone" runat="server" FieldLabel="手机号码" AllowBlank="false"
                                                            Width="300">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptSalesEmail" runat="server" FieldLabel="邮箱" AllowBlank="false"
                                                            Width="300">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:FormPanel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="BtnSaveDealerSalesInfo" runat="server" Text="提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="SaveDealerSalesInfo();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnDeleteDealerSalesInfo" runat="server" Text="删除" Icon="Delete">
                    <Listeners>
                        <Click Handler="DeleteDealerSalesInfo();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnCancelDealerSalesInfo" runat="server" Text="关闭" Icon="LorryAdd">
                    <Listeners>
                        <Click Handler="#{WdwDealerSalesInfo}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Window ID="WdwWechatUser" runat="server" Icon="Group" Title="选择微信用户" Resizable="false"
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
                                                        <ext:TextField ID="QryWechatDealerName" runat="server" FieldLabel="经销商" AllowBlank="false"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel5" runat="server" Border="false" AutoHeight="true">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout5" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="QryWechatSalesName" runat="server" FieldLabel="销售" AllowBlank="false"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="BtnQueryWechatUser" Text="查询" runat="server" Icon="ArrowRefresh"
                                    IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagWechatUserList}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="RstWechatUserList" runat="server" Title="签约销售" StoreID="StoWechatUserList"
                                        StripeRows="true" Border="false" Icon="Lorry" Header="false">
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesName" DataIndex="SalesName" Header="姓名" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesPhone" DataIndex="SalesPhone" Header="联系电话" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesEmail" DataIndex="SalesEmail" Header="邮箱" Width="200">
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
                                            <ext:PagingToolbar ID="PagWechatUserList" runat="server" PageSize="10" StoreID="StoWechatUserList"
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
                <ext:Button ID="BtnSaveWechatUser" runat="server" Text="提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="SaveWechatUser(#{RstWechatUserList});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnCancelWechatUser" runat="server" Text="返回" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{WdwWechatUser}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Handler="RefreshMainPage();" />
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
