<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MedtronicHomePage.aspx.cs" Inherits="DMS.Website.Pages.Home.MedtronicHomePage" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function refreshTree(tree) {
            Coolite.AjaxMethods.RefreshTree({
                success: function(result) {
                    var nodes = eval(result);
                    tree.root.ui.remove();
                    tree.initChildren(nodes);
                    tree.root.render();
                }
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        <ext:Store ID="DeliveryNoteStore" runat="server" OnRefreshData="DeliveryNoteStore_RefershData" AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                     <ext:RecordField Name="Id" />
                     <ext:RecordField Name="LineNbrInFile" />
                     <ext:RecordField Name="SapCode" />
                     <ext:RecordField Name="PoNbr" />
                     <ext:RecordField Name="DeliveryNoteNbr" />
                     <ext:RecordField Name="Cfn" />
                     <ext:RecordField Name="Upn" />
                     <ext:RecordField Name="LotNumber" />
                     <ext:RecordField Name="ExpiredDate" />
                     <ext:RecordField Name="ReceiveUnitOfMeasure" />
                     <ext:RecordField Name="ReceiveQty" />
                     <ext:RecordField Name="ShipmentDate" />
                     <ext:RecordField Name="ImportFileName" />
                     <ext:RecordField Name="OrderType" />
                     <ext:RecordField Name="UnitPrice" />
                     <ext:RecordField Name="SubTotal" />
                     <ext:RecordField Name="CreateDate" />
                     <ext:RecordField Name="ProblemDescription" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server" >
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <Center MarginsSummary="0 0 0 0">
                    <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:Panel ID="Panel2" runat="server" Height="300" Title="收货产品定义问题列表 - 更多信息点击右侧【查询图标】" Icon="Bell">
                                <Tools>                                    
                                    <ext:Tool Type="Refresh" Handler="#{GridPanel1}.reload();" />
                                    <%--<ext:Tool Type="Search" Qtip="更多..." Handler="window.parent.loadExample('/Pages/POReceipt/DeliveryNoteList.aspx','subMenu122','Shipment数据问题');" />--%>
                                    <ext:Tool Type="Search" Qtip="更多..." Handler="top.createTab({id: 'subMenu122',title: '批量导入',url: 'Pages/POReceipt/DeliveryNoteList.aspx'});" />

                                </Tools>                            
                                <Body>
                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                        <ext:GridPanel ID="GridPanel1" runat="server" StoreID="DeliveryNoteStore" Border="false" AutoWidth="true" StripeRows="true" Header="false">
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="LineNbrInFile" DataIndex="LineNbrInFile" Header="行号">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="ERP Code">                                                    
                                                        </ext:Column>
                                                        <ext:Column ColumnID="PoNbr" DataIndex="PoNbr" Header="采购单号">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="DeliveryNoteNbr" DataIndex="DeliveryNoteNbr" Header="发货单号">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Cfn" DataIndex="Cfn" Header="CFN(型号)">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Upn" DataIndex="Upn" Header="条形码">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="序列号/批次">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="过期日期">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ReceiveUnitOfMeasure" DataIndex="ReceiveUnitOfMeasure" Header="单位">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ReceiveQty" DataIndex="ReceiveQty" Header="数量">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ShipmentDate" DataIndex="ShipmentDate" Header="发货日期">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ImportFileName" DataIndex="ImportFileName" Header="导入文件名">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="OrderType" DataIndex="OrderType" Header="发货单类型">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UnitPrice" DataIndex="UnitPrice" Header="单价">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="SubTotal" DataIndex="SubTotal" Header="小计">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="生成日期">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ProblemDescription" DataIndex="ProblemDescription" Header="问题描述">
                                                        </ext:Column>
                                                    </Columns>
                                            </ColumnModel>                                    
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <LoadMask ShowMask="true" Msg="处理中..." />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Panel>
                        </Body>
                    </ext:Panel>
                </Center>  
                <East MarginsSummary="0 0 0 0" MinWidth="225">
                    <ext:Panel ID="Panel7" runat="server" Header="false" Frame="true" Width="225">
                        <Body>
                            <ext:Accordion ID="AccordionLayout1" runat="server">
                                 <ext:TreePanel ID="TreePanel1" runat="server" Title="任务" Icon="Bell" RootVisible="false">
                                    <Tools>
                                        <ext:Tool Type="Refresh" Handler="refreshTree(#{TreePanel1});" />
                                    </Tools>
                                </ext:TreePanel>
                            </ext:Accordion>
                        </Body>
                    </ext:Panel>
                </East>           
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    </form>
</body>
</html>
