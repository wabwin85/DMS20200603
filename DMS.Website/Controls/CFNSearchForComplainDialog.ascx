<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CFNSearchForComplainDialog.ascx.cs" Inherits="DMS.Website.Controls.CFNSearchForComplainDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">
    //var employeeRecord;
   
    var openCfnSearchDlg = function (isCrm, dealerId, animTrg) {
        var window = <%= cfnSearchDlg.ClientID %>;
        
        if (dealerId == "" || dealerId == null) {
            alert("请选择经销商");
        } else {
            <%= this.hiddenSearchType.ClientID %>.setValue("SearchUpn");
            <%= this.hiddenIsCrm.ClientID %>.setValue(isCrm);
            <%= this.hiddenDealerId.ClientID %>.setValue(dealerId);
            <%= this.GridPanel1.ClientID %>.clear();
            <%= this.GridPanel2.ClientID %>.clear();
            
            <%= this.dialogUpnPanel.ClientID %>.show();
            <%= this.dialogQrCodePanel.ClientID %>.hide();

            <%= this.cbCatories.ClientID %>.store.reload();
        
            window.show(animTrg);
        }
    }

    var openQrCodeSearchDlg = function (upn, lotNumber, dealerId, animTrg) {
        var window = <%= cfnSearchDlg.ClientID %>;
        
        if (dealerId == "" || dealerId == null) {
            alert("请选择经销商");
        } else {
            <%= this.hiddenSearchType.ClientID %>.setValue("SearchQrCode");
            <%= this.hiddenDealerId.ClientID %>.setValue(dealerId);
            <%= this.txtUpnForSearch.ClientID %>.setValue(upn);
            <%= this.txtLotForSearch.ClientID %>.setValue(lotNumber);

            <%= this.hiddenUpn.ClientID %>.setValue(upn);
            <%= this.hiddenLotNumber.ClientID %>.setValue(lotNumber);
            
            <%= this.GridPanel1.ClientID %>.clear();
            <%= this.GridPanel2.ClientID %>.clear();

            <%= this.dialogUpnPanel.ClientID %>.hide();
            <%= this.dialogQrCodePanel.ClientID %>.show();

            <%= this.cbCatories.ClientID %>.store.reload();
        
            window.show(animTrg);
        }
    }

    var cancelCfnDialog = function(grid) {         
        //遍历store，获取level2code，然后确定是否要隐藏支架相关信息
        var model = grid.getSelectionModel(); 
        var count = model.getCount();  
        //var store = grid.getStore();       
        //var count = store.getCount();
       
        if (count > 0){
            var record=model.getSelections();           
           
            var level2Code = record[0].data.Level2Code;
          
            if (level2Code == "040"){
                //将“请判断支架是否仅无法通过……”显示   
                if (Ext.getCmp('NoProblemButLesionNotPass') != null){
                    Ext.getCmp('NoProblemButLesionNotPass').show();    
                    Ext.getCmp('lblStents').show();    
                    Ext.getCmp('hiddenUPNLevel2Code').setValue('040');
                }
            } else {
                //隐藏
                if (Ext.getCmp('NoProblemButLesionNotPass') != null){
                    Ext.getCmp('NoProblemButLesionNotPass').hide();    
                    Ext.getCmp('lblStents').hide(); 
                    Ext.getCmp('hiddenUPNLevel2Code').setValue('NULL');
                }
            }
            
        } else {        
            if (Ext.getCmp('NoProblemButLesionNotPass') != null){
                Ext.getCmp('NoProblemButLesionNotPass').hide();    
                Ext.getCmp('lblStents').hide();
                Ext.getCmp('hiddenUPNLevel2Code').setValue('NULL');
            }
          
        }
        <%= this.cfnSearchDlg.ClientID %>.hide(null);
        
    }
    
</script>

<ext:Store ID="Store1" runat="server" OnRefreshData="Store1_RefershData" AutoLoad="false"  >
    <AutoLoadParams>
        <ext:Parameter Name="start" Value="={0}" />
        <ext:Parameter Name="limit" Value="={15}" />
    </AutoLoadParams>
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="UpnId" />
                <ext:RecordField Name="UpnName" />
                <ext:RecordField Name="LotName" />
                <ext:RecordField Name="SkuCnName" />
                <ext:RecordField Name="SkuEnName" />
                <ext:RecordField Name="SkuDesc" />
                <ext:RecordField Name="Property1" />
                <ext:RecordField Name="Property2" />
                <ext:RecordField Name="Property3" />
                <ext:RecordField Name="Property4" />
                <ext:RecordField Name="Property5" />
                <ext:RecordField Name="Property6" />
                <ext:RecordField Name="Property7" />
                <ext:RecordField Name="Property8" />
                <ext:RecordField Name="BU" />
                <ext:RecordField Name="BUCode" />
                <ext:RecordField Name="ConvertFactor" />
                <ext:RecordField Name="FactorNumber" />
                <ext:RecordField Name="Level2Code" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="UpnName" Direction="ASC" />
    <Listeners>
        <LoadException Handler="Ext.Msg.alert('Error', e )" />
    </Listeners>
</ext:Store>
<ext:Store ID="Store2" runat="server" OnRefreshData="Store2_RefershData" AutoLoad="false"  >
    <AutoLoadParams>
        <ext:Parameter Name="start" Value="={0}" />
        <ext:Parameter Name="limit" Value="={15}" />
    </AutoLoadParams>
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="WarehouseId" />
                <ext:RecordField Name="WarehouseName" />
                <ext:RecordField Name="UpnId" />
                <ext:RecordField Name="UpnName" />
                <ext:RecordField Name="LotName" />
                <ext:RecordField Name="QrCode" />
                <ext:RecordField Name="SkuCnName" />
                <ext:RecordField Name="SkuEnName" />
                <ext:RecordField Name="SkuDesc" />
                <ext:RecordField Name="ExpiredDate" />
                <ext:RecordField Name="Property1" />
                <ext:RecordField Name="Property2" />
                <ext:RecordField Name="Property3" />
                <ext:RecordField Name="Property4" />
                <ext:RecordField Name="Property5" />
                <ext:RecordField Name="Property6" />
                <ext:RecordField Name="Property7" />
                <ext:RecordField Name="Property8" />
                <ext:RecordField Name="ConvertFactor" />
                <ext:RecordField Name="FactorNumber" />
                <ext:RecordField Name="ProductLineId" />
                <ext:RecordField Name="BU" />
                <ext:RecordField Name="BUCode" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="UpnName" Direction="ASC" />
    <Listeners>
        <LoadException Handler="Ext.Msg.alert('Error', e )" />
    </Listeners>
</ext:Store>
<ext:Store ID="ProductCatoriesStore" runat="server" UseIdConfirmation="true" 
    OnRefreshData="Store_RefreshProductLineByDealer" AutoLoad="false"  >
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="AttributeName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <SortInfo Field="AttributeName" Direction="ASC" />
    <Listeners>
        <Load Handler="#{cbCatories}.setValue(#{cbCatories}.store.getTotalCount()>0?#{cbCatories}.store.getAt(0).get('Id'):'');" />
    </Listeners>
</ext:Store>

<ext:Hidden ID="hiddenSearchType" runat="server" ></ext:Hidden>
<ext:Hidden ID="hiddenIsCrm" runat="server" ></ext:Hidden>
<ext:Hidden ID="hiddenDealerId" runat="server" ></ext:Hidden>
<ext:Hidden ID="hiddenUpn" runat="server" ></ext:Hidden>
<ext:Hidden ID="hiddenLotNumber" runat="server" ></ext:Hidden>

<ext:Window ID="cfnSearchDlg" runat="server" Icon="Group" Title="产品选择" Closable="false"
    Draggable="false" Resizable="true" Width="800" Height="480" AutoShow="false" AutoScroll="true"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:ContainerLayout ID="ContainerLayout1" runat="server">
            <ext:Panel ID="dialogUpnPanel" runat="server" AutoHeight="true">
                <Body>
                    <ext:Panel ID="plSearch" runat="server" Border="false" Frame="true" AutoHeight="true"
                        ButtonAlign="Right">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth="1">
                                    <ext:Panel ID="Panel1" runat="server" Border="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbCatories" runat="server" EmptyText="产品线" Width="150" ListWidth="300" Editable="true"
                                                        TypeAhead="false" Mode="Local" Resizable="true" StoreID="ProductCatoriesStore" 
                                                        ValueField="Id" DisplayField="AttributeName" FieldLabel="产品线" >
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtCFN" runat="server" FieldLabel="产品型号" Width="150">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtLot" runat="server" FieldLabel="批号" Width="150">
                                                    </ext:TextField>
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
                                    <Click Handler="#{GridPanel1}.clear();#{PagingToolBar1}.changePage(1);" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnOk" runat="server" Text="确认" Icon="Disk" IDMode="Legacy" >
                                <AjaxEvents>
                                    <Click OnEvent="SubmitSelectionForCfn" Success="cancelCfnDialog(#{GridPanel1});">
                                        <ExtraParams>
                                            <ext:Parameter Name="Values" Value="Ext.encode(#{GridPanel1}.getRowsValues())" Mode="Raw" />
                                        </ExtraParams>
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                            <ext:Button ID="btnCancel" runat="server" Text="返回" Icon="Cancel" IDMode="Legacy" >
                                <Listeners>
                                    <Click Handler="cancelCfnDialog(#{GridPanel1});" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                    <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Height="300">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="产品列表" StoreID="Store1" 
                                    EnableColumnMove="false"  AutoExpandColumn="SkuDesc" AutoExpandMax="300" AutoExpandMin="100"
                                    Border="false" Icon="Lorry" Header="false" StripeRows="true">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="UpnName" DataIndex="UpnName" Header="产品型号" >
                                            </ext:Column>
                                            <ext:Column ColumnID="LotName" DataIndex="LotName" Header="批号" Width="200" >
                                            </ext:Column>
                                            <ext:Column ColumnID="Property1" DataIndex="Property1" Header="Model" >
                                            </ext:Column>
                                            <ext:Column ColumnID="SkuDesc" DataIndex="SkuDesc" Header="描述" >
                                            </ext:Column>
                                            <ext:Column ColumnID="Level2Code" DataIndex="Level2Code" Header="Level2Code"  >
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                   <SelectionModel>
                                        <ext:CheckboxSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" ></ext:CheckboxSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                            DisplayInfo="true" EmptyMsg="No data to display" />
                                    </BottomBar>
                                    <LoadMask ShowMask="true" Msg="Loading..." />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Body>
            </ext:Panel>
            <ext:Panel ID="dialogQrCodePanel" runat="server" AutoHeight="true">
                <Body>
                    <ext:Panel ID="Panel2" runat="server" Border="false" Frame="true" AutoHeight="true"
                        ButtonAlign="Right">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                <ext:LayoutColumn ColumnWidth="1">
                                    <ext:Panel ID="Panel3" runat="server" Border="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtUpnForSearch" runat="server" FieldLabel="产品型号" Width="150">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtLotForSearch" runat="server" FieldLabel="批号" Width="150">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtQrCodeForSearch" runat="server" FieldLabel="二维码" Width="150">
                                                    </ext:TextField>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="Button1" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="#{GridPanel2}.clear();#{PagingToolBar2}.changePage(1);" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="Button2" runat="server" Text="确认" Icon="Disk" IDMode="Legacy" >
                                <AjaxEvents>
                                    <Click OnEvent="SubmitSelectionForQrCode" Success="cancelCfnDialog(#{GridPanel2});">
                                        <ExtraParams>
                                            <ext:Parameter Name="Values" Value="Ext.encode(#{GridPanel2}.getRowsValues())" Mode="Raw" />
                                        </ExtraParams>
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                            <ext:Button ID="Button3" runat="server" Text="返回" Icon="Cancel" IDMode="Legacy" >
                                <Listeners>
                                    <Click Handler="cancelCfnDialog(#{GridPanel2});" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                    <ext:Panel runat="server" ID="Panel4" Border="false" Frame="true" Height="300">
                        <Body>
                            <ext:FitLayout ID="FitLayout2" runat="server">
                                <ext:GridPanel ID="GridPanel2" runat="server" Title="产品列表" StoreID="Store2" 
                                    EnableColumnMove="false"  AutoExpandColumn="WarehouseName" AutoExpandMax="300" AutoExpandMin="100"
                                    Border="false" Icon="Lorry" Header="false" StripeRows="true">
                                    <ColumnModel ID="ColumnModel2" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="仓库" >
                                            </ext:Column>
                                            <ext:Column ColumnID="UpnName" DataIndex="UpnName" Header="产品型号" Width="100" >
                                            </ext:Column>
                                            <ext:Column ColumnID="LotName" DataIndex="LotName" Header="批号" Width="100" >
                                            </ext:Column>
                                            <ext:Column ColumnID="QrCode" DataIndex="QrCode" Header="二维码" Width="120" >
                                            </ext:Column>
                                            <ext:Column ColumnID="Property1" DataIndex="Property1" Header="Model" >
                                            </ext:Column>
                                            <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="有效期" >
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server" SingleSelect="true" ></ext:CheckboxSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="Store2"
                                            DisplayInfo="true" EmptyMsg="No data to display" />
                                    </BottomBar>
                                    <LoadMask ShowMask="true" Msg="Loading..." />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Body>
            </ext:Panel>
        </ext:ContainerLayout>
    </Body>
</ext:Window>
