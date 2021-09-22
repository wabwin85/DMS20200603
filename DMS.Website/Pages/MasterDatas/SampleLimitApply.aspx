<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SampleLimitApply.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.SampleLimitApply" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"> </script>
      <style type="text/css">
            .txtRed {
            color: Red;
            font-size: 13px !important;
        }
         </style>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <script type="text/javascript" language="javascript">
            var ChangeProductLine = function () {
                Ext.getCmp('CFN_Level4Code').clearValue();
                Ext.getCmp('CFN_Level4Code').store.reload();
                var id = Ext.getCmp('ProductLine').getValue()
                if (id != '') {
                    Coolite.AjaxMethods.ChangeProductLine(id, {});
                }
            }
        </script>
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="SampleApplyLimitId" />
                        <ext:RecordField Name="ProductLineName" />
                        <ext:RecordField Name="CFN_ProductLine_BUM_ID" />                        
                        <ext:RecordField Name="Level4Code" />
                        <ext:RecordField Name="Limit" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="CFN_Level4Codestore" runat="server" UseIdConfirmation="true" AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="CFN_Level4Code" />
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
        <ext:Hidden ID="hid" runat="server">
        </ext:Hidden>
          <ext:Hidden ID="Hidproductline" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="HidCFN_Level4Code" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidLimit" runat="server"></ext:Hidden>


        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
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
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField runat="server" ID="Level4Code" EmptyText="输入产品组代码" FieldLabel="产品组"></ext:TextField>
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
                                                        <ext:Hidden ID="hd" runat="server">
                                                        </ext:Hidden>
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
                                <ext:Button ID="BtnInsert" runat="server" Text="新增" Icon="PageExcel" IDMode="Legacy"
                                    AutoPostBack="false">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.Inserttde('','','','','insert')" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="l46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridDealerInfor" runat="server" Title="查询结果" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="产品线" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="Level4Code" DataIndex="Level4Code" Header="产品组" Width="90">
                                                </ext:Column>
                                                <ext:Column ColumnID="Limit" DataIndex="Limit" Header="数量" Width="90">
                                                </ext:Column>
                                                <ext:CommandColumn Header="修改" Width="120" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="VcardEdit" CommandName="Update" ToolTip-Text="维护">
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler="if (command == 'Update')
                                                                   {
                                                                    var id = record.data.SampleApplyLimitId;
                                                                    var productline=record.data.CFN_ProductLine_BUM_ID;
                                                                    var Limit=record.data.Limit;
                                                                    var CFN_Level4Code=record.data.Level4Code;
                                                                  #{Hidproductline}.setValue(record.data.ProductLineName);
                                                                
                                                            Coolite.AjaxMethods.Inserttde(id,productline,Limit,CFN_Level4Code,'update');
                                                                   }" />


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

        <ext:Window ID="WindowPromotionType" runat="server" Title="商业样品申请upn数量更新" Width="400" AutoHeight="true"
            Modal="true" Collapsible="false" Maximizable="false" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="FormPanelPromotionType" runat="server" Border="true" ButtonAlign="Right"
                    BodyStyle="padding:5px;" AutoHeight="true">
                    <Body>
                        <ext:FormLayout ID="FormLayout20" runat="server">
                            <ext:Anchor>
                                <ext:ComboBox ID="ProductLine" runat="server" EmptyText="选择产品线..." Width="220"
                                    Editable="true" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                    Mode="Local" DisplayField="AttributeName" FieldLabel="产品线" Resizable="true">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                        <Select Handler="ChangeProductLine();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:ComboBox ID="CFN_Level4Code" runat="server" EmptyText="选择产品组Code..." Width="220"
                                    Editable="false" TypeAhead="true" StoreID="CFN_Level4Codestore" ValueField="CFN_Level4Code"
                                    Mode="Local" DisplayField="CFN_Level4Code" FieldLabel="产品组" Resizable="true">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:NumberField runat="server" ID="LimitAmount" FieldLabel="数量" Width="220" AllowDecimals="false" AllowNegative="false" MaxLength="4"></ext:NumberField>
                            </ext:Anchor>
                          <ext:Anchor>
                              <ext:Label ID="remake" runat="server" Width="220"  LabelSeparator=""
                                Text="此产品线中没有可选择的产品组code" CtCls="txtRed" Hidden = "true"/>                               
                          </ext:Anchor>
                          
                                 
                        </ext:FormLayout>
                          
                    </Body>
                    <Buttons>
                        <ext:Button ID="SubmitButton" runat="server" Text="新增"
                            Icon="LorryAdd">
                            <Listeners>
                                <Click Handler="Ext.Msg.confirm('提示','请确认新增信息',
                                        function(e){
                                       if(e == 'yes'){
                                    Coolite.AjaxMethods.Submit('','','','','insert');}})" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="UpdateButton" runat="server" Text="修改"
                            Icon="LorryAdd">
                            <Listeners>
                                <Click Handler="Ext.Msg.confirm('提示','请确认修改信息',
                                        function(e){
                                       if(e == 'yes'){
                                    Coolite.AjaxMethods.Submit('','','','','update');}})" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="CloseWindow" runat="server" Text="关闭" Icon="Delete">
                            <Listeners>
                                <Click Handler="Ext.getCmp('WindowPromotionType').hide(); Ext.getCmp('GridDealerInfor').store.reload();" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
                </Body>
        </ext:Window>
    </form>
</body>
</html>
