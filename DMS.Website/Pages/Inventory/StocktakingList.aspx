<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StocktakingList.aspx.cs"
    Inherits="DMS.Website.Pages.Inventory.StocktakingList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/StocktakingDialog.ascx" TagName="StocktakingDialog"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script language="javascript">
        var ListSearch = function(pagingtoolbar) {
            if (Ext.getCmp('cbStocktakingNo').getValue() == '') {
                Ext.Msg.alert('<%=GetLocalResourceObject("ListSearch.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("ListSearch.Alert.Body").ToString()%>');
            } else {
                pagingtoolbar.changePage(1);
            }
        }

        var AddStocktaking = function(grid, store) {
            Ext.Msg.confirm('<%=GetLocalResourceObject("AddStocktaking.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("AddStocktaking.Confirm.Body").ToString()%>', function(e) {
                if (e == 'yes') {
                    if (Ext.getCmp('cbWarehouse').getValue() == '') {
                        Ext.Msg.alert('<%=GetLocalResourceObject("ListSearch.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("AddStocktaking.Alert.Body").ToString()%>');
                    } else {
                        Coolite.AjaxMethods.AddStocktaking({
                            success: function() {
                                store.reload();
                                Ext.Msg.alert('<%=GetLocalResourceObject("ListSearch.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("AddStocktaking.success.Alert.Body").ToString()%>');
                            },
                            failure: function(err) {
                                Ext.Msg.alert('<%=GetLocalResourceObject("AddStocktaking.failure.Alert.Title").ToString()%>', err);
                            }
                        });

                    }
                }
            });
        }

        var StoreLoadAfterAdd = function(store, grid) {
            if (Ext.getCmp('cbStocktakingNo').getValue() != '' || store.getCount() > 0) {
                Ext.getCmp('cbStocktakingNo').setValue(store.getAt(0).get('Id'));
                grid.store.reload();

            }
        }

        var showCfnSearchDlg = function() {

            openCfnSearchDlg(null);

        }

        var SaveGridPanel2Data = function(store) {
            //遍历整个Store，校验输入项是否不为空
            var rowNum = store.getCount();
            if (rowNum > 0) {
                var jsonData;
                for (var i = 0; i < rowNum; i++) {
                    var rec = store.getAt(i)
                    jsonData = jsonData + rec.data.toString();
                    if (rec.data['LotNumber'] == null || rec.data['ExpiredDate'] == null || rec.data['CheckQuantity'] == null) {
                        Ext.Msg.alert('<%=GetLocalResourceObject("SaveGridPanel2Data.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("SaveGridPanel2Data.Alert.Body").ToString()%>');
                        return;
                    }
                }
                GridPanel2.save();
            } else {
                Ext.Msg.alert('<%=GetLocalResourceObject("SaveGridPanel2Data.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("SaveGridPanel2Data.Alert.Body1").ToString()%>');
                return;
            }
        }

        var DelIconPrepare = function(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            firstButton.setVisible(record.data.isNewAdd);
        }

        var AdjustDif = function(grid) {
            Ext.MessageBox.confirm('<%=GetLocalResourceObject("ListSearch.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("AdjustDif.Confirm.Body").ToString()%>', function DoAdjust(btn) {
                if (btn == 'yes') {
                    if (Ext.getCmp('hiddenStocktakingSthID').getValue() == '') {
                        Ext.Msg.alert('<%=GetLocalResourceObject("ListSearch.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("AdjustDif.Alert.Body").ToString()%>');
                    } else {
                        Coolite.AjaxMethods.DoDifAdjust(Ext.getCmp('hiddenStocktakingSthID').getValue(), {
                            success: function() {
                                Ext.Msg.alert('<%=GetLocalResourceObject("ListSearch.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("AdjustDif.success.Alert.Body").ToString()%>');
                                grid.store.reload();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('<%=GetLocalResourceObject("AddStocktaking.failure.Alert.Title").ToString()%>', err);
                            }
                        });
                    }
                }
                else {
                    return;
                }
            });
        }
        var PrintDifReport = function() {
            if (Ext.getCmp('cbStocktakingNo').getValue() == '') {
                Ext.Msg.alert('<%=GetLocalResourceObject("ListSearch.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("PrintDifReport.Alert.Body").ToString()%>');
            } else {
                showModalDialog("StocktakingPrint.aspx?status=Dif&id="+Ext.getCmp('hiddenStocktakingSthID').getValue(),window,"status:false;dialogWidth:800px;dialogHeight:500px");
            }
        }

        var PrintInvReport = function() {
            if (Ext.getCmp('cbStocktakingNo').getValue() == '') {
                Ext.Msg.alert('<%=GetLocalResourceObject("ListSearch.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("PrintInvReport.Alert.Body").ToString()%>');
            } else {
                showModalDialog("StocktakingPrint.aspx?status=Inv&id="+Ext.getCmp('hiddenStocktakingSthID').getValue(),window,"status:false;dialogWidth:800px;dialogHeight:500px");
            }
        }
       
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <%--经销商Store--%>
    <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_DealerList"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ChineseName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
    </ext:Store>
    <%--仓库Store--%>
    <ext:Store ID="WarehouseStore" runat="server" OnRefreshData="Store_WarehouseByDealer"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Name" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <BaseParams>
            <ext:Parameter Name="DealerId" Value="#{cbDealer}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{cbDealer}.getValue()"
                Mode="Raw" />
        </BaseParams>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert('Load Exception', e.message || response.statusText);" />
        </Listeners>
        <SortInfo Field="Name" Direction="ASC" />
    </ext:Store>
    <%--盘点单号Store--%>
    <ext:Store ID="StocktakingNoStore" runat="server" OnRefreshData="StocktakingNoStore_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Number" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <BaseParams>
            <ext:Parameter Name="DealerId" Value="#{cbDealer}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{cbDealer}.getValue()"
                Mode="Raw" />
            <ext:Parameter Name="WarehouseId" Value="#{cbWarehouse}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{cbWarehouse}.getValue()"
                Mode="Raw" />
        </BaseParams>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert('Load Exception', e.message || response.statusText);" />
            <Load Handler="StoreLoadAfterAdd(#{StocktakingNoStore},#{GridPanelList})" />
        </Listeners>
        <SortInfo Field="Number" Direction="DESC" />
    </ext:Store>
    <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="DMA_ID" />
                    <ext:RecordField Name="DMA_ChineseName" />
                    <ext:RecordField Name="WHM_ID" />
                    <ext:RecordField Name="WHM_Name" />
                    <ext:RecordField Name="CFN_ID" />
                    <ext:RecordField Name="ArticleNumber" />
                    <ext:RecordField Name="LOT_ID" />
                    <ext:RecordField Name="LotNumber" />
                    <ext:RecordField Name="ExpiredDate" />
                    <ext:RecordField Name="PMA_ID" />
                    <ext:RecordField Name="PMA_Name" />
                    <ext:RecordField Name="STH_Status" />
                    <ext:RecordField Name="SLT_LotQty" />
                    <ext:RecordField Name="SLT_CheckQty" />
                    <ext:RecordField Name="DifQty" />
                    <ext:RecordField Name="isNewAdd" />
                    <ext:RecordField Name="STH_StocktakingNo" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="ArticleNumber" Direction="ASC" />
        <Listeners>
            <BeforeLoad Handler="Coolite.AjaxMethods.GetStocktakingDate(#{cbStocktakingNo}.getValue());" />
        </Listeners>
    </ext:Store>
    <ext:Hidden ID="hiddenStocktakingSthID" runat="server" />
    <ext:Hidden ID="hiddenCurrentEditID" runat="server" />
    <ext:Hidden ID="hiddenCurrentEditActualQty" runat="server" />
    <ext:Hidden ID="hiddenNewSelected" runat="server" />
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true" BodyStyle="padding: 5px;"
                        Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout1.cbDealer.EmptyText %>" Width="200" Editable="true"
                                                        TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName" Mode="Local"
                                                        ListWidth="300" Resizable="true" FieldLabel="<%$ Resources: Panel1.FormLayout1.cbDealer.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout1.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="
                                                                                   this.clearValue();
                                                                                   #{cbWarehouse}.clearValue(); 
                                                                                   #{cbStocktakingNo}.clearValue();
                                                                                   #{hiddenStocktakingSthID}.setValue('');
                                                                                   #{txtStatus}.setValue('');
                                                                                   #{txtArticleNumber}.setValue('');
                                                                                   #{GridPanelList}.clear();
                                                                                   #{BtnAddProduct}.setDisabled(true);
                                                                                   #{BtnAdjustDif}.setDisabled(true);
                                                                                   #{BtnPrintDif}.setDisabled(true);
                                                                                   #{BtnPrintInv}.setDisabled(true);
                                                                                   #{WarehouseStore}.reload();
                                                                                   #{StocktakingNoStore}.reload();
                                                                                   " />
                                                            <Select Handler="
                                                                                   #{cbWarehouse}.clearValue(); 
                                                                                   #{cbStocktakingNo}.clearValue();
                                                                                   #{hiddenStocktakingSthID}.setValue('');
                                                                                   #{txtStatus}.setValue('');
                                                                                   #{txtArticleNumber}.setValue('');
                                                                                   #{GridPanelList}.clear();
                                                                                   #{BtnAddProduct}.setDisabled(true);
                                                                                   #{BtnAdjustDif}.setDisabled(true);
                                                                                   #{BtnPrintDif}.setDisabled(true);
                                                                                   #{BtnPrintInv}.setDisabled(true);
                                                                                   #{WarehouseStore}.reload();
                                                                                   #{StocktakingNoStore}.reload();
                                                                             " />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtArticleNumber" runat="server" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" Enabled="true"
                                                        Width="200" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbWarehouse" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout2.cbWarehouse.EmptyText %>" Width="200" Editable="false"
                                                        TypeAhead="true" StoreID="WarehouseStore" ValueField="Id" DisplayField="Name"
                                                        ListWidth="300" Resizable="true" FieldLabel="<%$ Resources: Panel1.FormLayout2.cbWarehouse.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout2.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="
                                                                                   this.clearValue();                                                                                   
                                                                                   #{cbStocktakingNo}.clearValue();
                                                                                   #{hiddenStocktakingSthID}.setValue('');
                                                                                   #{txtStatus}.setValue('');
                                                                                   #{txtArticleNumber}.setValue('');
                                                                                   #{GridPanelList}.clear();
                                                                                   #{BtnAddProduct}.setDisabled(true);
                                                                                   #{BtnAdjustDif}.setDisabled(true);
                                                                                   #{BtnPrintDif}.setDisabled(true);
                                                                                   #{BtnPrintInv}.setDisabled(true);
                                                                                   #{StocktakingNoStore}.reload();
                                                                                   " />
                                                            <Select Handler="
                                                                                   #{hiddenStocktakingSthID}.setValue('');
                                                                                   #{txtStatus}.setValue('');
                                                                                   #{txtArticleNumber}.setValue('');
                                                                                   #{GridPanelList}.clear();
                                                                                   #{BtnAddProduct}.setDisabled(true);
                                                                                   #{BtnAdjustDif}.setDisabled(true);
                                                                                   #{BtnPrintDif}.setDisabled(true);
                                                                                   #{BtnPrintInv}.setDisabled(true);
                                                                                   #{StocktakingNoStore}.reload();
                                                                             " />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtStatus" runat="server" FieldLabel="<%$ Resources: Panel1.FormLayout2.txtStatus.FieldLabel %>" Enabled="true" Width="200" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbStocktakingNo" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout3.cbStocktakingNo.EmptyText %>" Width="220"
                                                        Editable="false" TypeAhead="true" StoreID="StocktakingNoStore" ValueField="Id"
                                                        DisplayField="Number" ListWidth="300" Resizable="true" FieldLabel="<%$ Resources: Panel1.FormLayout3.cbStocktakingNo.FieldLabel %>">
                                                        <Listeners>
                                                            <Select Handler="
                                                                            #{hiddenStocktakingSthID}.setValue('');
                                                                            #{txtArticleNumber}.setValue('');
                                                                            #{GridPanelList}.reload();
                                                                            " />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtStocktakingDate" runat="server" FieldLabel="<%$ Resources:Panel1.FormLayout3.txtStocktakingDate.FieldLabel %>" ReadOnly="true"
                                                        Width="220" Disabled="true" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnSearch" Text="<%$ Resources:Panel1.btnSearch.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="ListSearch(#{PagingToolBar1});" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnAdd" Text="<%$ Resources:Panel1.btnAdd.Text %>" runat="server" Icon="Add" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="AddStocktaking(#{GridPanelList},#{StocktakingNoStore});" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanelList" runat="server" Title="<%$ Resources:Panel2.GridPanelList.Title %>" StoreID="ResultStore"
                                    Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" EnableHdMenu="false">
                                    <TopBar>
                                        <ext:Toolbar ID="Toolbar2" runat="server">
                                            <Items>
                                                <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                <ext:Button ID="BtnPrintDif" runat="server" Text="<%$ Resources:Panel2.GridPanelList.BtnPrintDif.Text %>" Icon="Printer" CommandName=""
                                                    IDMode="Legacy" OnClientClick="PrintDifReport()">
                                                </ext:Button>
                                                <ext:Button ID="BtnPrintInv" runat="server" Text="<%$ Resources:Panel2.GridPanelList.BtnPrintInv.Text %>" Icon="Printer" CommandName=""
                                                    IDMode="Legacy" OnClientClick="PrintInvReport()">
                                                </ext:Button>
                                                <ext:Button ID="BtnAdjustDif" runat="server" Text="<%$ Resources:Panel2.GridPanelList.BtnAdjustDif.Text %>" Icon="Contrast" CommandName=""
                                                    IDMode="Legacy" OnClientClick="AdjustDif(#{GridPanelList});">
                                                </ext:Button>
                                                <ext:Button ID="BtnAddProduct" runat="server" Text="<%$ Resources:Panel2.GridPanelList.BtnAddProduct.Text %>" Icon="Add" CommandName=""
                                                    IDMode="Legacy" OnClientClick="">
                                                    <Listeners>
                                                        <Click Handler="Coolite.AjaxMethods.ShowDetails();" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Items>
                                        </ext:Toolbar>
                                    </TopBar>
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="DealerName" DataIndex="DMA_ChineseName" Header="<%$ Resources:Panel2.GridPanelList.ColumnModel1.DealerName.Header %>" Width="180" />
                                            <ext:Column ColumnID="WarehouseName" DataIndex="WHM_Name" Header="<%$ Resources:Panel2.GridPanelList.ColumnModel1.WarehouseName.Header %>" Width="100" />
                                            <ext:Column ColumnID="StocktakingNo" DataIndex="STH_StocktakingNo" Header="<%$ Resources:Panel2.GridPanelList.ColumnModel1.StocktakingNo.Header %>"
                                                Width="100" />
                                            <ext:Column ColumnID="ArticleNumber" DataIndex="ArticleNumber" Header="<%$ Resources: resource,Lable_Article_Number  %>" />
                                            <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources:Panel2.GridPanelList.ColumnModel1.LotNumber.Header %>" Align="Right" />
                                            <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources:Panel2.GridPanelList.ColumnModel1.ExpiredDate.Header %>" Align="Right" />
                                            <ext:Column ColumnID="InvActualQty" DataIndex="SLT_LotQty" Header="<%$ Resources:Panel2.GridPanelList.ColumnModel1.InvActualQty.Header %>" Width="70"
                                                Align="Right" />
                                            <ext:Column ColumnID="InvStockTakingQtyEdit" DataIndex="SLT_CheckQty" Header="<%$ Resources:Panel2.GridPanelList.ColumnModel1.InvStockTakingQtyEdit.Header %>"
                                                Width="70" Align="Right">
                                                <Editor>
                                                    <ext:NumberField ID="txtStockTakingQty" runat="server" AllowBlank="false" AllowDecimals="false"
                                                        DataIndex="SLT_CheckQty" SelectOnFocus="true" AllowNegative="false">
                                                    </ext:NumberField>
                                                </Editor>
                                            </ext:Column>
                                            <ext:Column ColumnID="InvDifQty" DataIndex="DifQty" Header="<%$ Resources:Panel2.GridPanelList.ColumnModel1.InvDifQty.Header %>" Width="60" Align="Right" />
                                            <ext:CommandColumn Width="40" Header="<%$ Resources:Panel2.GridPanelList.ColumnModel1.CommandColumn.Header %>" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources:Panel2.GridPanelList.ColumnModel1.GridCommand.ToolTip-Text %>" />
                                                </Commands>
                                                <PrepareToolbar Fn="DelIconPrepare" />
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                        <Command Handler="if (command == 'Delete'){
                                                             Coolite.AjaxMethods.DeleteListItem(this.getSelectionModel().getSelected().id,{failure: function(err) {Ext.Msg.alert('Failure', err);}});
                                                          } 
                                                         " />
                                        <BeforeEdit Handler="#{hiddenCurrentEditID}.setValue(this.getSelectionModel().getSelected().id); #{hiddenCurrentEditActualQty}.setValue(this.getSelectionModel().getSelected().data.SLT_LotQty);" />
                                        <AfterEdit Handler="Coolite.AjaxMethods.SaveItem(#{txtStockTakingQty}.getValue(),{failure: function(err) {Ext.Msg.alert('Failure', err);}});" />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                            DisplayInfo="false">
                                        </ext:PagingToolbar>
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" />
                                    <Listeners />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
        OnBeforeStoreChanged="DetailStore_BeforeStoreChanged" AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="LotID">
                <Fields>
                    <ext:RecordField Name="PmaId" />
                    <ext:RecordField Name="CustomerFaceNbr" />
                    <ext:RecordField Name="ChineseName" />
                    <ext:RecordField Name="LotID" />
                    <ext:RecordField Name="LotNumber" />
                    <ext:RecordField Name="ExpiredDate" />
                    <ext:RecordField Name="CheckQuantity" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert('Load Exception', e.message || response.statusText);" />
        </Listeners>
        <SortInfo Field="CustomerFaceNbr" Direction="ASC" />
    </ext:Store>
    <ext:Hidden ID="hiddenDealerIDWin" runat="server" />
    <ext:Hidden ID="hiddenWarehouseIDWin" runat="server" />
    <ext:Hidden ID="hiddenSTHIDWin" runat="server" />
    <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources:DetailWindow.Title %>" Width="900"
        Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false">
        <Body>
            <ext:BorderLayout ID="BorderLayout2" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:Panel ID="Panel11" runat="server">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".35">
                                            <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="120">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtDealerWin" runat="server" FieldLabel="<%$ Resources:DetailWindow.FormLayout4.txtDealerWin.FieldLabel %>" ReadOnly="true"
                                                                Disabled="true" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".35">
                                            <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="100">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtWarehouseWin" runat="server" FieldLabel="<%$ Resources:DetailWindow.FormLayout6.txtWarehouseWin.FieldLabel %>" ReadOnly="true"
                                                                Disabled="true" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="100">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtStocktakingNoWin" runat="server" FieldLabel="<%$ Resources:DetailWindow.FormLayout5.txtStocktakingNoWin.FieldLabel %>" ReadOnly="true"
                                                                Disabled="true" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                            </ext:Panel>
                        </Body>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel10" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout2" runat="server">
                                <ext:GridPanel ID="GridPanel2" runat="server" Title="<%$ Resources:DetailWindow.GridPanel2.Title %>" StoreID="DetailStore"
                                    StripeRows="true" Collapsible="true" Border="false" Icon="Lorry" AutoWidth="true"
                                    ClicksToEdit="1">
                                    <TopBar>
                                        <ext:Toolbar ID="Toolbar1" runat="server">
                                            <Items>
                                                <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources:DetailWindow.GridPanel2.AddItemsButton.Text %>" Icon="Add">
                                                    <Listeners>
                                                        <Click Fn="showCfnSearchDlg" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Items>
                                        </ext:Toolbar>
                                    </TopBar>
                                    <ColumnModel ID="ColumnModel2" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                                Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources:DetailWindow.GridPanel2.ColumnModel2.ChineseName.Header %>" Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources:DetailWindow.GridPanel2.ColumnModel2.LotNumber.Header %>" Width="100">
                                                <Editor>
                                                    <ext:TextField ID="txtLotNumber" runat="server" AllowBlank="false" SelectOnFocus="true">
                                                    </ext:TextField>
                                                </Editor>
                                            </ext:Column>
                                            <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources:DetailWindow.GridPanel2.ColumnModel2.ExpiredDate.Header %>" Width="80">
                                                <Renderer Fn="Ext.util.Format.dateRenderer('Ymd')" />
                                                <Editor>
                                                    <ext:DateField ID="dtExpiredDate" runat="server" AllowBlank="true" AltFormats="true"
                                                        DataIndex="ExpiredDate">
                                                    </ext:DateField>
                                                </Editor>
                                            </ext:Column>
                                            <ext:Column ColumnID="CheckQuantity" DataIndex="CheckQuantity" Header="<%$ Resources:DetailWindow.GridPanel2.ColumnModel2.CheckQuantity.Header %>" Width="80"
                                                Align="Right">
                                                <Editor>
                                                    <ext:NumberField ID="txtCheckQuantity" runat="server" AllowBlank="false" AllowDecimals="false"
                                                        DataIndex="CheckQuantity" SelectOnFocus="true" AllowNegative="false">
                                                    </ext:NumberField>
                                                </Editor>
                                            </ext:Column>
                                            <ext:CommandColumn Width="50" Header="<%$ Resources:DetailWindow.GridPanel2.ColumnModel2.CommandColumn.Header %>" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources:DetailWindow.GridPanel2.ColumnModel2.GridCommand.ToolTip-Text %>" />
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server"
                                            MoveEditorOnEnter="true">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" Msg="<%$ Resources:DetailWindow.GridPanel2.LoadMask.Msg %>" />
                                    <Listeners>
                                        <Command Handler="if (command == 'Delete'){Coolite.AjaxMethods.DeleteDetailItem();}" />
                                        <BeforeEdit Handler="" />
                                        <AfterEdit Handler="" />
                                    </Listeners>
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
        <Buttons>
            <ext:Button ID="DraftButton" runat="server" Text="<%$ Resources:DetailWindow.DraftButton.Text %>" Icon="Add">
                <Listeners>
                    <Click Handler="SaveGridPanel2Data(#{DetailStore});" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="RevokeButton" runat="server" Text="<%$ Resources:DetailWindow.RevokeButton.Text %>" Icon="Cancel">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.Cancel({
                            success: function() {
                                Ext.getCmp('DetailWindow').hide();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Failure', err);
                            }
                        });" />
                </Listeners>
            </ext:Button>
        </Buttons>
        <Listeners>
            <Hide Handler="#{GridPanel2}.clear();" />
        </Listeners>
    </ext:Window>
    <uc2:StocktakingDialog ID="StocktakingDialog1" runat="server" />
    </form>
     <script type="text/javascript">
         if (Ext.isChrome === true) {
             var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
             Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
         }

    </script>

</body>
</html>
