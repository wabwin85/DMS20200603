<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReturnPositionSearch.aspx.cs" Inherits="DMS.Website.Pages.Inventory.ReturnPositionSearch" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />


    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"> </script>


</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        <script type="text/javascript" language="javascript">
            function checkNumber(theObj) {
                var reg = /^(\-|\+)?\d+(\.\d+)?$/;
                if (reg.test(theObj)) {
                    return true;
                }
                return false;
            }

            var closeWindow = function () {
                Ext.getCmp('WindowPromotionType').hide();
                Ext.getCmp('GridPanel1').store.reload();
                Ext.getCmp('FormPanelPromotionType').getForm().reset();


                //ReloadDetail();
            }

            var changedealer = function () {
                var id = Ext.getCmp('Dealer').getValue()
                if (id != '') {
                    Coolite.AjaxMethods.changedealer(
                             id,
                        {
                            success: function (result) {
                                if (result == 'true') {
                                    Ext.getCmp('Dealer').clearValue();
                                    Ext.Msg.alert('提示', '不能设定二级退货额度');
                                }
                            }
                        }
                        );
                }
            }

        </script>
        <ext:Store ID="DetailStore" runat="server"  OnRefreshData="DetailStore_RefershData" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="ReturnNbr" />
                        <ext:RecordField Name="ProductLineName" />
                        <ext:RecordField Name="Years" />
                        <ext:RecordField Name="DRP_Quarter" />
                        <ext:RecordField Name="DetailAmount" />
                        <ext:RecordField Name="DRP_Type" />
                        <ext:RecordField Name="DRP_Desc" />
                        <ext:RecordField Name="CreateUserName" />
                        <ext:RecordField Name="SubmitBeginDate" />
                        <ext:RecordField Name="DRP_SubmitEndDate" />
                        <ext:RecordField Name="DRP_ExpBeginDate" />
                        <ext:RecordField Name="ExpEndDate" />
                        <ext:RecordField Name="CreateDate" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true">
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

        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="ChineseShortName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>

        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            UseIdConfirmation="false" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="SAPCode" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="ProductLineID" />
                        <ext:RecordField Name="ProductLineName" />
                        <ext:RecordField Name="Year" />
                        <ext:RecordField Name="Amount" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden ID="hiddenChineseName" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenProductLineName" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddendatayear" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidInitDealerId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidProductLine" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenChineseNamedatil" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenProductLineNamedatil" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddendatayeardatil" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenamount" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddentype" runat="server"></ext:Hidden>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="退货额度查询" AutoHeight="true" BodyStyle="padding: 5px;"
                            Frame="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择经销商……"
                                                            Width="200" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id"
                                                            DisplayField="ChineseShortName" Mode="Local" FieldLabel="经销商"
                                                            ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
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
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="选择产品线..." Width="200"
                                                            Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                            Mode="Local" DisplayField="AttributeName" FieldLabel="产品线" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
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
                                <ext:Button ID="btninsert" runat="server" Text="新增" Icon="Add">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.Inserttde('','','','insert')" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnSubmit" Text="导出" runat="server" Icon="PageExcel" IDMode="Legacy"
                                    AutoPostBack="true" OnClick="ExportExcel">
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="SAPCode" DataIndex="SAPCode" Header="经销商SAPCode" Width="70">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商名称" Width="170">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="产品线" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="Year" DataIndex="Year" Header="年份" Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount" DataIndex="Amount" Header="汇总金额" Width="90">
                                                </ext:Column>
                                                <ext:CommandColumn Width="60" Header="明细">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="编辑明细" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:CommandColumn Width="60" Header="修改">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Update">
                                                            <ToolTip Text="修改额度" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler="if (command == 'Edit'){
                                                             Coolite.AjaxMethods.ShowDetails(record.data.SAPCode,record.data.ProductLineID);}
                                                              else if (command == 'Update'){
                                             
                                                            Coolite.AjaxMethods.Inserttde(record.data.DealerId,record.data.ProductLineID,record.data.Amount,'update');}  
                                                               " />
                                        </Listeners>
                                        <%--/传出经销商名称、产品线、年份到后天--%>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="ResultStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="退货单明细"
            Width="1000" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <Center MarginsSummary="0 5 5 5">
                        <ext:GridPanel ID="GridPanel2" runat="server" Title="查询结果"
                            StoreID="DetailStore" StripeRows="true" Icon="Lorry" Header="false">
                            <ColumnModel ID="ColumnModel2" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="CreateUserName" DataIndex="CreateUserName" Header="操作人"
                                        Width="70">
                                    </ext:Column>
                                    <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="操作时间"
                                        Width="90">
                                    </ext:Column>
                                    <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="经销商名称"
                                        Width="170">
                                    </ext:Column>
                                    <ext:Column ColumnID="ReturnNbr" DataIndex="ReturnNbr" Header="退货单号" Width="150">
                                    </ext:Column>
                                    <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="产品线" Width="70">
                                    </ext:Column>
                                    <ext:Column ColumnID="Years" DataIndex="Years" Header="年份" Width="70">
                                    </ext:Column>
                                    <ext:Column ColumnID="DRP_Quarter" DataIndex="DRP_Quarter" Header="账期"
                                        Width="40">
                                    </ext:Column>
                                    <ext:Column ColumnID="DetailAmount" DataIndex="DetailAmount" Header="金额明细"
                                        Width="70">
                                    </ext:Column>
                                    <ext:Column ColumnID="DRP_Type" DataIndex="DRP_Type" Header="操作类型"
                                        Width="70">
                                    </ext:Column>
                                    <ext:Column ColumnID="DRP_Desc" DataIndex="DRP_Desc" Header="操作备注"
                                        Width="70">
                                    </ext:Column>
                                    <ext:Column ColumnID="SubmitBeginDate" DataIndex="SubmitBeginDate" Header="额度开始使用时间"
                                        Width="90">
                                    </ext:Column>
                                    <ext:Column ColumnID="DRP_SubmitEndDate" DataIndex="DRP_SubmitEndDate" Header="额度终止使用时间"
                                        Width="90">
                                    </ext:Column>
                                    <ext:Column ColumnID="DRP_ExpBeginDate" DataIndex="DRP_ExpBeginDate" Header="产品效期开始时间"
                                        Width="90">
                                    </ext:Column>
                                    <ext:Column ColumnID="ExpEndDate" DataIndex="ExpEndDate" Header="产品效期终止时间"
                                        Width="90">
                                    </ext:Column>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                </ext:RowSelectionModel>
                            </SelectionModel>
                            <BottomBar>
                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="30" StoreID="DetailStore"
                                    DisplayInfo="true" />
                            </BottomBar>
                            <SaveMask ShowMask="true" Msg="保存中..." />
                            <LoadMask ShowMask="true" Msg="处理中..." />
                        </ext:GridPanel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:Window>
        <ext:Window ID="WindowPromotionType" runat="server" Title="退货单明细修改" Width="400" AutoHeight="true"
            Modal="true" Collapsible="false" Maximizable="false" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="FormPanelPromotionType" runat="server" Border="true" ButtonAlign="Right"
                    BodyStyle="padding:5px;" AutoHeight="true">
                    <Body>
                        <ext:FormLayout ID="FormLayout20" runat="server">
                            <ext:Anchor>
                                <ext:ComboBox ID="Dealer" runat="server" EmptyText="请选择经销商……"
                                    Width="220" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id"
                                    DisplayField="ChineseShortName" Mode="Local" FieldLabel="经销商"
                                    ListWidth="300" Resizable="true">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                        <Select Handler="changedealer();" />
                                    </Listeners>

                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:ComboBox ID="ProductLine" runat="server" EmptyText="选择产品线..." Width="220"
                                    Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                    Mode="Local" DisplayField="AttributeName" FieldLabel="产品线" Resizable="true">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:NumberField runat="server" ID="Years" FieldLabel="年份" Width="220" EmptyText="请输入年份" MaxLength="4"></ext:NumberField>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:ComboBox ID="Quarter" runat="server" FieldLabel="季度" Width="220" EmptyText="选择季度...." Editable="false">
                                    <Items>
                                        <ext:ListItem Text="第一季度" Value="1" />
                                        <ext:ListItem Text="第二季度" Value="2" />
                                        <ext:ListItem Text="第三季度" Value="3" />
                                        <ext:ListItem Text="第四季度" Value="4" />
                                    </Items>
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:NumberField runat="server" ID="Amount" FieldLabel="额度" Width="220"  allowNegative="true" allowDecimals="true" nanText="请输入正确的额度" decimalPrecision="15"></ext:NumberField>
                               <%-- <ext:TextField runat="server" ID="Quota" FieldLabel="额度" Width="220"></ext:TextField>--%>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextArea ID="txtBody" runat="server" FieldLabel="备注" Width="220" Enabled="true">
                                </ext:TextArea>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="SubmitButton" runat="server" Text="提交"
                            Icon="LorryAdd">
                            <Listeners>
                                <Click Handler="
                                    if(!checkNumber(#{Amount}.getValue())){
                              Ext.MessageBox.alert('错误','请输入正确数据');                                       
                            } else {Coolite.AjaxMethods.sbmited();};" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="CloseWindow" runat="server" Text="关闭" Icon="Delete">
                            <Listeners>
                                <Click Handler="closeWindow();" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </Body>
        </ext:Window>
    </form>
</body>
</html>
