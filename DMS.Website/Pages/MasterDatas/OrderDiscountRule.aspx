<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderDiscountRule.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.OrderDiscountRule" %>


<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Inventory Update</title>
    <link href="../../../../resources/css/examples.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
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
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData" AutoLoad="false" WarningOnDirty="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="ProductLineName" />
                        <ext:RecordField Name="DivisionName" />
                        <ext:RecordField Name="SAPCode" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="PctLevel" />
                        <ext:RecordField Name="PctLevelCode" />
                        <ext:RecordField Name="Upn" />
                        <ext:RecordField Name="Lot" />
                        <ext:RecordField Name="QrCode" />
                        <ext:RecordField Name="PctNameGroup" />
                        <ext:RecordField Name="LeftValue" />
                        <ext:RecordField Name="RightValue" />
                        <ext:RecordField Name="DiscountValue" />
                        <ext:RecordField Name="BeginDate" />
                        <ext:RecordField Name="EndDate" />
                        <ext:RecordField Name="CreatUser" />
                        <ext:RecordField Name="CreateDate" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>

        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件"
                            Frame="true" AutoHeight="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
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
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtUPN" runat="server" FieldLabel="产品编号"
                                                            Width="150" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtLot" runat="server" FieldLabel="产品批号"
                                                            Width="150" />
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
                                <ext:Button ID="btnInsert" runat="server" Text="导入新规则" Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.OrderDiscountRule.RuleUploadShow();#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);#{ImportButton}.setDisabled(true);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Title="查询结果"
                            Icon="HouseKey">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Header="false" StoreID="ResultStore" Border="false"
                                        Icon="Lorry" AutoExpandColumn="DealerName" AutoExpandMax="250" AutoExpandMin="150"
                                        StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="产品线">
                                                </ext:Column>
                                                <ext:Column ColumnID="SAPCode" DataIndex="SAPCode" Header="经销商编号">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商名称">
                                                </ext:Column>
                                                <ext:Column ColumnID="PctLevelCode" DataIndex="PctLevelCode" Header="产品层级代码" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="PctLevel" DataIndex="PctLevel" Header="产品层级名称" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="Upn" DataIndex="Upn" Header="产品编号">
                                                </ext:Column>
                                                <ext:Column ColumnID="Lot" DataIndex="Lot" Header="批号">
                                                </ext:Column>
                                                <ext:Column ColumnID="QrCode" DataIndex="QrCode" Header="二维码" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="LeftValue" DataIndex="LeftValue" Header="时间区间（>=天）">
                                                </ext:Column>
                                                <ext:Column ColumnID="RightValue" DataIndex="RightValue" Header="时间区间（<天）">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiscountValue" DataIndex="DiscountValue" Header="折扣率">
                                                </ext:Column>
                                                <ext:Column ColumnID="BeginDate" DataIndex="BeginDate" Header="开始时间">
                                                </ext:Column>
                                                <ext:Column ColumnID="EndDate" DataIndex="EndDate" Header="终止时间">
                                                </ext:Column>
                                                <ext:Column ColumnID="CreatUser" DataIndex="CreatUser" Header="提交请人">
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="提交时间" Width="150">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                DisplayInfo="true" EmptyMsg="无数据显示" />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="数据正在加载…" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>

        <ext:Store ID="WindowUploadStore" runat="server" OnRefreshData="WindowUploadStore_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="UPNName" />
                        <ext:RecordField Name="UPN" />
                        <ext:RecordField Name="DealerSAP" />
                        <ext:RecordField Name="LOT" />
                        <ext:RecordField Name="QRCode" />
                        <ext:RecordField Name="LeftValue" />
                        <ext:RecordField Name="RightValue" />
                        <ext:RecordField Name="DiscountValue" />
                        <ext:RecordField Name="ErrMassage" />
                        <ext:RecordField Name="ErrType" />
                        <ext:RecordField Name="BeginDate" />
                        <ext:RecordField Name="EndDate" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Window ID="WindowRuleInput" runat="server" Title="规则导入" Width="900" AutoHeight="true"
            Modal="true" Collapsible="false" Maximizable="false" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="FormPanelRuleInput" runat="server" Border="true" ButtonAlign="Right"
                    BodyStyle="padding:5px;" Height="500">
                    <Body>
                        <ext:BorderLayout ID="BorderLayout2" runat="server">
                            <North MarginsSummary="5 5 5 5" Collapsible="true">
                                <ext:FormPanel ID="BasicForm" runat="server" Width="900" Frame="true" Title="规则上传"
                                    AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;" ButtonAlign="Left">
                                    <Defaults>
                                        <ext:Parameter Name="anchor" Value="50%" Mode="Value" />
                                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                                    </Defaults>
                                    <Body>
                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="100">
                                            <ext:Anchor>
                                                <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="请选择上传文件"
                                                    FieldLabel="上传文件" ButtonText="" Icon="ImageAdd">
                                                </ext:FileUploadField>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                    <Listeners>
                                        <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                                    </Listeners>
                                    <Buttons>
                                        <ext:Button ID="SaveButton" runat="server" Text="上传">
                                            <AjaxEvents>
                                                <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                                    Ext.Msg.wait('上传中', '请稍等！');"
                                                    Failure="Ext.Msg.show({ 
                                                    title   : '错误', 
                                                    msg     : '包含错误数据，请确认后重新上传！', 
                                                    minWidth: 200, 
                                                    modal   : true, 
                                                    icon    : Ext.Msg.ERROR, 
                                                    buttons : Ext.Msg.OK 
                                                });"
                                                    Success="#{ImportButton}.setDisabled(false);#{SaveButton}.setDisabled(true);#{PagingToolBar2}.changePage(1);">
                                                </Click>
                                            </AjaxEvents>
                                        </ext:Button>
                                        <ext:Button ID="ResetButton" runat="server" Text="清空">
                                            <Listeners>
                                                <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);#{ImportButton}.setDisabled(true);" />
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="ImportButton" runat="server" Text="确认导入系统" Disabled="true">
                                            <AjaxEvents>
                                                <Click OnEvent="ImportClick" Before="Ext.Msg.wait('正在上传文件...', '文件上传');" Success="#{PagingToolBar2}.changePage(1);#{PagingToolBar1}.changePage(1);">
                                                </Click>
                                            </AjaxEvents>
                                        </ext:Button>
                                        <ext:Button ID="DownloadButton" runat="server" Text="模板下载">
                                            <Listeners>
                                                <Click Handler="window.open('../../Upload/ExcelTemplate/Template_DiscountRule.xls')" />
                                            </Listeners>
                                        </ext:Button>
                                    </Buttons>
                                </ext:FormPanel>
                            </North>
                            <Center MarginsSummary="0 5 0 5">
                                <ext:Panel ID="Panel9" runat="server" Height="300" Header="false">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout3" runat="server">
                                            <ext:GridPanel ID="GridPanel3" runat="server" Title="数据列表" StoreID="WindowUploadStore" Border="false"
                                                Icon="Error" AutoWidth="true" StripeRows="true" EnableHdMenu="false">
                                                <ColumnModel ID="ColumnModel3" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="DealerSAP" DataIndex="DealerSAP" Header="DealerSAP" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UPN" DataIndex="UPN" Header="UPN" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UPNName" DataIndex="UPNName" Header="产品名称" Sortable="false" Width="150px">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="LOT" DataIndex="LOT" Header="批号" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="LeftValue" DataIndex="LeftValue" Header="时间区间（>=天）" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="RightValue" DataIndex="RightValue" Header="时间区间（<天）" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="DiscountValue" DataIndex="DiscountValue" Header="折扣" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="BeginDate" DataIndex="BeginDate" Header="开始时间" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="EndDate" DataIndex="EndDate" Header="终止时间" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ErrMassage" DataIndex="ErrMassage" Header="错误信息" Sortable="false">
                                                        </ext:Column>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server" MoveEditorOnEnter="false">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="100" StoreID="WindowUploadStore"
                                                        DisplayInfo="false">
                                                    </ext:PagingToolbar>
                                                </BottomBar>
                                                <LoadMask ShowMask="true" Msg="加载中…" />
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Panel>
                            </Center>
                        </ext:BorderLayout>
                    </Body>
                </ext:FormPanel>
            </Body>
        </ext:Window>
    </form>
    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>
