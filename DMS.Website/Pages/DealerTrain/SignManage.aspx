<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignManage.aspx.cs" Inherits="DMS.Website.Pages.DealerTrain.SignManage" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>签约维护</title>
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
            Ext.getCmp('<%=this.RstSignList.ClientID%>').reload();
        }

        function CloseSignInfo() {
            var signId = Ext.getCmp('<%=this.IptSignId.ClientID%>');
            Coolite.AjaxMethods.DeleteSignDraft(signId.getValue(),
            {
                success: function() {
                    Ext.getCmp('<%=this.WdwSignInfo.ClientID%>').hide();
                },
                failure: function(err) {
                    Ext.Msg.alert('Error', err);
                }
            });
        }

        function SaveSignInfo() {
            var errMsg = "";
            var isFormValid = Ext.getCmp('<%=this.FrmSignInfo.ClientID%>').getForm().isValid();

            if (!isFormValid) {
                errMsg = "请填写完整签约主信息";
            }

            if (errMsg != "") {
                Ext.Msg.alert('Message', errMsg);
            } else {
                Ext.getCmp('<%=this.IptSignTrainValue.ClientID%>').setValue(Ext.getCmp('<%=this.IptSignTrain.ClientID%>').getValue());
                Ext.Msg.confirm('Message', "是否确认提交此签约？",
                    function(e) {
                        if (e == 'yes') {
                            Coolite.AjaxMethods.SaveSignInfo(
                                {
                                    success: function() {
                                        Ext.Msg.alert('Message', '保存成功！');
                                        Ext.getCmp('<%=this.WdwSignInfo.ClientID%>').hide();
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
        }

        function SaveDealerSales(grid) {
            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();
                var param = '';

                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].data.DealerSalesId + ',';
                }

                Coolite.AjaxMethods.SaveDealerSales(
                    param,
                    {
                        success: function() {
                            Ext.getCmp('<%=this.RstDealerSalesList.ClientID%>').reload();
                        },
                        failure: function(err) {
                            Ext.Msg.alert('Error', err);
                        }
                    }
                );
            } else {
                Ext.MessageBox.alert('错误', '请选择要添加的销售员');
            }
        }

        function DeleteSignInfoById(signId) {
            var rtnVal = Ext.getCmp('<%=this.IptRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.IptRtnMsg.ClientID%>');

            Coolite.AjaxMethods.CheckSignInfo(
                signId,
                {
                    success: function() {
                        Ext.Msg.confirm('Message', rtnMsg.getValue(),
                            function(e) {
                                if (e == 'yes') {
                                    Coolite.AjaxMethods.DeleteSignInfo(
                                        signId,
                                        {
                                            success: function() { Ext.getCmp('<%=this.WdwSignInfo.ClientID%>').hide(); RefreshMainPage(); },
                                            failure: function(err) { Ext.Msg.alert('Error', err); }
                                        }
                                    );
                                }
                            }
                        );
                    },
                    failure: function(err) {
                        Ext.Msg.alert('Error', err);
                    }
                }
            );
        }

        function DeleteSignInfo() {
            var signId = Ext.getCmp('<%=this.IptSignId.ClientID%>').getValue();

            DeleteSignInfoById(signId);
        }

        function DeleteDealerSales(signRelationId, salesId) {
            var rtnVal = Ext.getCmp('<%=this.IptRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.IptRtnMsg.ClientID%>');

            Coolite.AjaxMethods.CheckDealerSales(
                signRelationId,
                {
                    success: function() {
                        Ext.Msg.confirm('Message', rtnMsg.getValue(),
                            function(e) {
                                if (e == 'yes') {
                                    Coolite.AjaxMethods.DeleteDealerSales(
                                        signRelationId,
                                        Ext.getCmp('<%=this.IptSignId.ClientID%>').getValue(),
                                        salesId,
                                        {
                                            success: function() { Ext.getCmp('<%=this.RstSignSalesList.ClientID%>').reload(); },
                                            failure: function(err) { Ext.Msg.alert('Error', err); }
                                        }
                                    );
                                }
                            }
                        );
                    },
                    failure: function(err) {
                        Ext.Msg.alert('Error', err);
                    }
                }
            );
        }
    </script>

    <div id="DivStore">
        <ext:Store ID="StoSignList" runat="server" UseIdConfirmation="false" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="SignId">
                    <Fields>
                        <ext:RecordField Name="SignId" />
                        <ext:RecordField Name="SignName" />
                        <ext:RecordField Name="SignDesc" />
                        <ext:RecordField Name="CreateUser" />
                        <ext:RecordField Name="CreateTime" />
                        <ext:RecordField Name="UpdateUser" />
                        <ext:RecordField Name="UpdateTime" />
                        <ext:RecordField Name="TrainName" />
                        <ext:RecordField Name="TrainBu" />
                        <ext:RecordField Name="TrainArea" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoSignSalesList" runat="server" UseIdConfirmation="false"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="SignRelationId">
                    <Fields>
                        <ext:RecordField Name="SignRelationId" />
                        <ext:RecordField Name="DealerSalesId" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="SalesName" />
                        <ext:RecordField Name="SalesPhone" />
                        <ext:RecordField Name="SalesEmail" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <BaseParams>
                <ext:Parameter Name="SignId" Value="#{IptSignId}.getValue()" Mode="Raw" />
            </BaseParams>
        </ext:Store>
        <ext:Store ID="StoDealerSalesList" runat="server" UseIdConfirmation="false"
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
                        <ext:RecordField Name="SalesPhone" />
                        <ext:RecordField Name="SalesEmail" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <BaseParams>
                <ext:Parameter Name="SignId" Value="#{IptSignId}.getValue()" Mode="Raw" />
            </BaseParams>
        </ext:Store>
        <ext:Store ID="StoTrainList" runat="server"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="TrainId">
                    <Fields>
                        <ext:RecordField Name="TrainId" />
                        <ext:RecordField Name="TrainName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <BaseParams>
                <ext:Parameter Name="SignId" Value="#{IptSignId}.getValue()" Mode="Raw" />
            </BaseParams>
        </ext:Store>
        <ext:Store ID="StoTrainArea" runat="server"
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
        <ext:Store ID="StoTrainBu" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="AttributeName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Id" Direction="ASC" />
        </ext:Store>
    </div>
    <div id="DivHidden">
        <ext:Hidden ID="IptRtnVal" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptRtnMsg" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptIsNew" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptSignId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptSignTrainValue" runat="server">
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
                                                        <ext:TextField ID="QrySignName" runat="server" Width="200" FieldLabel="签约名称">
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
                                                        <ext:TextField ID="QryTrainName" runat="server" Width="200" FieldLabel="课程名称">
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
                                        <Click Handler="#{PagSignList}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="BtnAdd" runat="server" Text="新增" Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="
                                            #{IptIsNew}.setValue('True');
                                            #{IptSignId}.setValue('00000000-0000-0000-0000-000000000000');
                                            #{IptSignTrain}.store.reload();
                                            Coolite.AjaxMethods.ShowSignInfo(
                                                '00000000-0000-0000-0000-000000000000',
                                                {
                                                    success:function(){ #{FrmSignInfo}.reload(); },
                                                    failure:function(err){Ext.Msg.alert('Error', err);}
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
                                    <ext:GridPanel ID="RstSignList" runat="server" Title="查询结果" StoreID="StoSignList"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="SignName" DataIndex="SignName" Header="签名名称" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="TrainBu" DataIndex="TrainBu" Header="产品线" Width="150">
                                                    <Renderer Handler="return getNameFromStoreById(StoTrainBu,{Key:'Id',Value:'AttributeName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="TrainName" DataIndex="TrainName" Header="课程名称" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="TrainArea" DataIndex="TrainArea" Header="区域">
                                                    <Renderer Handler="return getNameFromStoreById(StoTrainArea,{Key:'Key',Value:'Value'},value);" />
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
                                                    #{IptSignId}.setValue(record.data.SignId);
                                                    #{IptSignTrain}.store.reload();
                                                    Coolite.AjaxMethods.ShowSignInfo(
                                                        record.data.SignId,
                                                        {
                                                            success: function() {#{PagSignSalesList}.changePage(1);},
                                                            failure: function(err) {Ext.Msg.alert('Error', err);}
                                                        }
                                                    );
                                                } if (command == 'Delete') {
                                                    DeleteSignInfoById(record.data.SignId);
                                                }
                                            " />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagSignList" runat="server" PageSize="15" StoreID="StoSignList"
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
        <ext:Window ID="WdwSignInfo" runat="server" Icon="Group" Title="签约信息" Resizable="false"
            Header="false" Width="800" Height="500" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="FrmSignInfo" runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel11" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptSignName" runat="server" FieldLabel="签约名称" AllowBlank="false"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextArea ID="IptSignDesc" runat="server" FieldLabel="签约描述" Width="200">
                                                        </ext:TextArea>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel4" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="IptSignTrain" runat="server" EmptyText="请选择课程…" Width="200" Editable="false"
                                                            AllowBlank="false" TypeAhead="true" StoreID="StoTrainList" ValueField="TrainId"
                                                            DisplayField="TrainName" FieldLabel="课程" ListWidth="200" Resizable="true">
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
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:Panel ID="FrmSignSalesList" runat="server" Header="false" Border="false">
                            <Body>
                                <ext:FitLayout ID="FTHeader" runat="server">
                                    <ext:GridPanel ID="RstSignSalesList" runat="server" Title="签约销售" StoreID="StoSignSalesList"
                                        StripeRows="true" Border="false" Icon="Lorry" Header="false">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar1" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                    <ext:Button ID="btnAddOnLine" runat="server" Text="添加" Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="if(#{IptSignId}.getValue() == '') {alert('请等待数据加载完毕！');} else { Coolite.AjaxMethods.ShowDealerSales(); #{RstDealerSalesList}.clear(); }" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesName" DataIndex="SalesName" Header="姓名" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesPhone" DataIndex="SalesPhone" Header="联系电话" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesEmail" DataIndex="SalesEmail" Header="邮箱" Width="200">
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
                                            <ext:PagingToolbar ID="PagSignSalesList" runat="server" PageSize="10" StoreID="StoSignSalesList"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <Listeners>
                                            <Command Handler="
                                                if (command == 'Delete') {
                                                    DeleteDealerSales(record.data.SignRelationId, record.data.DealerSalesId);
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
                <ext:Button ID="BtnSaveSignInfo" runat="server" Text="提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="SaveSignInfo();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnDeleteDetail" runat="server" Text="删除" Icon="Delete">
                    <Listeners>
                        <Click Handler="DeleteSignInfo()" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnCancelDetail" runat="server" Text="关闭" Icon="LorryAdd">
                    <Listeners>
                        <Click Handler="#{WdwSignInfo}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Handler="CloseSignInfo()" />
            </Listeners>
        </ext:Window>
        <ext:Window ID="WdwDealerSales" runat="server" Icon="Group" Title="选择销售人员" Resizable="false"
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
                                                        <ext:TextField ID="QryDealerName" runat="server" FieldLabel="经销商" AllowBlank="false"
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
                                                        <ext:TextField ID="QrySalesName" runat="server" FieldLabel="销售" AllowBlank="false"
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
                                <ext:Button ID="BtnQuerySales" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagDealerSalesList}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="RstDealerSalesList" runat="server" Title="签约销售" StoreID="StoDealerSalesList"
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
                                            <ext:PagingToolbar ID="PagDealerSalesList" runat="server" PageSize="10" StoreID="StoDealerSalesList"
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
                <ext:Button ID="BtnSaveDealerSales" runat="server" Text="提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="SaveDealerSales(#{RstDealerSalesList});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnCancelDealerSales" runat="server" Text="返回" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{WdwDealerSales}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Handler="#{PagSignSalesList}.changePage(1);" />
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
