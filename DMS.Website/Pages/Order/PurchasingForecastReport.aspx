<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PurchasingForecastReport.aspx.cs" Inherits="DMS.Website.Pages.Order.PurchasingForecastReport" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

        <script type="text/javascript" language="javascript">

            function oppp() {                
                window.location.href = '/Pages/DPForecast/DPForecastImport.aspx';
            }
        </script>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Hidden ID="hidcbProductLine" runat="server">
            </ext:Hidden>
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
        <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="PFA_ID">
                    <Fields>
                        <ext:RecordField Name="PFA_ID" />
                        <ext:RecordField Name="PFA_ForecastVersion" />
                        <ext:RecordField Name="DMA_SAP_Code" />
                        <ext:RecordField Name="DMA_ChineseName" />
                        <ext:RecordField Name="PFA_BU" />
                        <ext:RecordField Name="DivisionName" />
                        <ext:RecordField Name="PFA_DMA_ID" />
                        <ext:RecordField Name="PFA_UPN" />
                        <ext:RecordField Name="PFA_UPNDescription" />
                        <ext:RecordField Name="PFA_ProductGroup" />
                        <ext:RecordField Name="PFA_ProductSubGroup" />
                        <ext:RecordField Name="PFA_PurchaseUnitPrice" />
                        <ext:RecordField Name="PFA_HisPurchase_M1" />
                        <ext:RecordField Name="PFA_HisPurchase_M2" />
                        <ext:RecordField Name="PFA_HisPurchase_M3" />
                        <ext:RecordField Name="PFA_HisPurchase_M4" />
                        <ext:RecordField Name="PFA_HisPurchase_M5" />
                        <ext:RecordField Name="PFA_HisPurchase_M6" />
                        <ext:RecordField Name="PFA_HisPurchase_M7" />
                        <ext:RecordField Name="PFA_HisPurchase_M8" />
                        <ext:RecordField Name="PFA_HisPurchase_M9" />
                        <ext:RecordField Name="PFA_HisPurchase_M10" />
                        <ext:RecordField Name="PFA_HisPurchase_M11" />
                        <ext:RecordField Name="PFA_HisPurchase_M12" />
                        <ext:RecordField Name="PFA_YearlyPurchase" />
                        <ext:RecordField Name="PFA_InventoryQty" />
                        <ext:RecordField Name="PFA_HisForecastMM3" />
                        <ext:RecordField Name="PFA_HisForecastMM2" />
                        <ext:RecordField Name="PFA_HisForecastMM1" />
                        <ext:RecordField Name="PFA_HisForecastAccuMM3" />
                        <ext:RecordField Name="PFA_HisForecastAccuMM2" />
                        <ext:RecordField Name="PFA_HisForecastAccuMM1" />
                        <ext:RecordField Name="PFA_HisForecastAdjAccuMM3" />
                        <ext:RecordField Name="PFA_HisForecastAdjAccuMM2" />
                        <ext:RecordField Name="PFA_HisForecastAdjAccuMM1" />
                        <ext:RecordField Name="PFA_Forecast_M1" />
                        <ext:RecordField Name="PFA_Forecast_M2" />
                        <ext:RecordField Name="PFA_Forecast_M3" />
                        <ext:RecordField Name="PFA_ForecastAdj_M1" />
                        <ext:RecordField Name="PFA_ForecastAdj_M2" />
                        <ext:RecordField Name="PFA_ForecastAdj_M3" />
                        <ext:RecordField Name="PFA_ForecastAdj_Remark" />
                        <ext:RecordField Name="PFA_IndexForecastRate_M1" />
                        <ext:RecordField Name="PFA_IndexForecastRate_M2" />
                        <ext:RecordField Name="PFA_IndexForecastRate_M3" />
                        <ext:RecordField Name="PFA_IndexAdjustRate_M1" />
                        <ext:RecordField Name="PFA_IndexAdjustRate_M2" />
                        <ext:RecordField Name="PFA_IndexAdjustRate_M3" />
                        <ext:RecordField Name="PFA_CreateDate" />
                        <ext:RecordField Name="PFA_UpdateDate" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <div>
            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North Collapsible="True" Split="True">
                            <ext:Panel ID="Panel8" runat="server" Title="采购预测" AutoHeight="true" BodyStyle="padding: 5px;"
                                Frame="true" Icon="Find">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server">
                                                        <ext:Anchor>
                                                            <ext:TextField runat="server" ID="ForecastVersion" FieldLabel="数据版本"></ext:TextField>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="选择产品线..." Width="200" ListWidth="200"
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
                                                    <ext:FormLayout ID="FormLayout2" runat="server">
                                                        <ext:Anchor>
                                                            <ext:TextField runat="server" ID="UPNID" FieldLabel="UPN编号"></ext:TextField>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                                <Buttons>
                                    <ext:Button ID="btnSubmit" Text="导入" runat="server" Icon="PageExcel" IDMode="Legacy">
                                        <Listeners>
                                            <Click Fn="oppp" />
                                        </Listeners>
                                    </ext:Button>
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
                                        <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果"
                                            StoreID="ResultStore" Border="false" Icon="Lorry" StripeRows="true">
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="PFA_ForecastVersion" DataIndex="PFA_ForecastVersion" Header="版本"
                                                        Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DivisionName" DataIndex="DivisionName" Header="部门"
                                                        Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DMA_SAP_Code" DataIndex="DMA_SAP_Code" Header="经销商编号" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="DMA_ChineseName" DataIndex="DMA_ChineseName" Header="经销商名称" Width="150">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PFA_UPN" DataIndex="PFA_UPN" Header="产品UPN"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PFA_UPNDescription" DataIndex="PFA_UPNDescription" Header="产品描述"
                                                        Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PFA_ProductGroup" DataIndex="PFA_ProductGroup" Header="产品大类"
                                                        Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PFA_ProductSubGroup" DataIndex="PFA_ProductSubGroup" Header="产品组"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PFA_PurchaseUnitPrice" DataIndex="PFA_PurchaseUnitPrice" Header="产品价格"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PFA_HisPurchase_M1" DataIndex="PFA_HisPurchase_M1" Header="M1历史采购"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PFA_HisPurchase_M2" DataIndex="PFA_HisPurchase_M2" Header="M2历史采购"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PFA_HisPurchase_M3" DataIndex="PFA_HisPurchase_M3" Header="M3历史采购"
                                                        Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PFA_HisPurchase_M4" DataIndex="PFA_HisPurchase_M4" Header="M4历史采购"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PFA_HisPurchase_M5" DataIndex="PFA_HisPurchase_M5" Header="M5历史采购"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PFA_HisPurchase_M6" DataIndex="PFA_HisPurchase_M6" Header="M6历史采购"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PFA_HisPurchase_M7" DataIndex="PFA_HisPurchase_M7" Header="M7历史采购" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisPurchase_M8" DataIndex="PFA_HisPurchase_M8" Header="M8历史采购" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisPurchase_M9" DataIndex="PFA_HisPurchase_M9" Header="M9历史采购" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisPurchase_M10" DataIndex="PFA_HisPurchase_M10" Header="M10历史采购" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisPurchase_M11" DataIndex="PFA_HisPurchase_M11" Header="M11历史采购" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisPurchase_M12" DataIndex="PFA_HisPurchase_M12" Header="M12历史采购" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_YearlyPurchase" DataIndex="PFA_YearlyPurchase" Header="年度采购" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_InventoryQty" DataIndex="PFA_InventoryQty" Header="库存数据" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisForecastMM3" DataIndex="PFA_HisForecastMM3" Header="M-3历史预测" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisForecastMM2" DataIndex="PFA_HisForecastMM2" Header="M-2历史预测" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisForecastMM1" DataIndex="PFA_HisForecastMM1" Header="M-1历史预测" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisForecastAccuMM3" DataIndex="PFA_HisForecastAccuMM3" Header="M-3历史预测准确率" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisForecastAccuMM2" DataIndex="PFA_HisForecastAccuMM2" Header="M-2历史预测准确率" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisForecastAccuMM1" DataIndex="PFA_HisForecastAccuMM1" Header="M-1历史预测准确率" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisForecastAdjAccuMM3" DataIndex="PFA_HisForecastAdjAccuMM3" Header="M-3历史调整准确率" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisForecastAdjAccuMM2" DataIndex="PFA_HisForecastAdjAccuMM2" Header="M-2历史调整准确" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_HisForecastAdjAccuMM1" DataIndex="PFA_HisForecastAdjAccuMM1" Header="M-1历史调整准确率" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_Forecast_M1" DataIndex="PFA_Forecast_M1" Header="M+1统计预测" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_Forecast_M2" DataIndex="PFA_Forecast_M2" Header="M+2统计预测" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_Forecast_M3" DataIndex="PFA_Forecast_M3" Header="M+3统计预测" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_ForecastAdj_M1" DataIndex="PFA_ForecastAdj_M1" Header="M+1统计调整（经销商填写" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_ForecastAdj_M2" DataIndex="PFA_ForecastAdj_M2" Header="M+2统计调整（经销商填写" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_ForecastAdj_M3" DataIndex="PFA_ForecastAdj_M3" Header="M+3统计调整（经销商填写" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_ForecastAdj_Remark" DataIndex="PFA_ForecastAdj_Remark" Header="统计调整备注原因（经销商填写" Width="70"></ext:Column>
                                                    <ext:Column ColumnID="PFA_UpdateDate" DataIndex="PFA_UpdateDate" Header="记录修改日期" Width="70">
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Handler="if (command == 'Edit')
                                                                   {
                                                                    var contid = record.data.ContractID;
                                                                    var parmetType = record.data.ParmetType;
                                                                    var dealerType = record.data.DealerType;
                                                                    window.location.href = '/Pages/Contract/ContractDeatil.aspx?ContractID=' + contid + '&ParmetType=' + parmetType + '&DealerType=' + dealerType;
                                                                   
                                                                   }
                                              " />
                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="ResultStore"
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


    </form>
</body>
</html>
