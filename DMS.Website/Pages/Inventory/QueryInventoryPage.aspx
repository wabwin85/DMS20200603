<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QueryInventoryPage.aspx.cs"
    Inherits="DMS.Website.Pages.Inventory.QueryInventoryPage" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <iframe id="ifile" style="display: none"></iframe>

    <script type="text/javascript">
        var MsgList = {
			WarehouseStore:{
				LoadExceptionTitle:"<%=GetLocalResourceObject("WarehouseStore.Listeners.Alert").ToString()%>"
			},
			DetailStore:{
				LoadExceptionTitle:"<%=GetLocalResourceObject("DetailStore.Listeners.Alert").ToString()%>"
			}
        }

        var submitValue = function(grid, hiddenFormat, format) {
            hiddenFormat.setValue(format);
            grid.submitData(false);
        }

        var ClearItems = function() {
            Ext.getCmp('<%=cboWarehouse.ClientID%>').clearValue();
            Ext.getCmp('<%=GridPanel1.ClientID%>').clear();
        }
        
        function SelectValue(e) {
            var filterField = 'ChineseShortName';  //需进行模糊查询的字段
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
               var value = e.query;
                if (value != null && value != '') {
                    combo.store.filterBy(function (record, id) {
                        var text = record.get(filterField);
                        if (text != null && text != "") {
                            // 用自己的过滤规则,如写正则式
                            return (text.indexOf(value) != -1);
                        }
                        else {
                           return false;
                        }
                    });
                } else {
                    combo.store.clearFilter();
                }
                combo.onLoad(); //不加第一次会显示不出来  
                combo.expand();
                return false;
            }
        }
       
     function ComboxSelValue(e) {
        var combo = e.combo;
        combo.collapse();
        if (!e.forceAll) {
            var input = e.query;
            if (input != null && input != '') {
                // 检索的正则
                var regExp = new RegExp(".*" + input + ".*");
                // 执行检索
                combo.store.filterBy(function(record, id) {
                    // 得到每个record的项目名称值
                    var text = record.get(combo.displayField);
                    return regExp.test(text);
                });
            } else {
                    combo.store.clearFilter();
            }
            combo.expand();
            return false;
        }
    } 
     //触发函数
        function downloadfile(url) {    
       
            var iframe = document.createElement("iframe");
            iframe.src = url;
            iframe.style.display = "none";  
            document.body.appendChild(iframe);
        } 
    </script>

    <form id="form1" runat="server" defaultbutton="btnSearch">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <ext:Hidden ID="FormatType" runat="server" />
    <ext:Hidden ID="HiddFileName" runat="server" />
    <ext:Hidden ID="HiddDowleName" runat="server" />
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
                    <ext:RecordField Name="ChineseShortName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="WarehouseStore" runat="server" OnRefreshData="Store_AllWarehouseByDealer"
        AutoLoad="true">
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
            <ext:Parameter Name="DealerId" Value="#{cboDealer}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{cboDealer}.getValue()"
                Mode="Raw" />
        </BaseParams>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert(MsgList.WarehouseStore.LoadExceptionTitle, e.message || response.statusText);" />
        </Listeners>
        <%--<SortInfo Field="Name" Direction="ASC" />--%>
    </ext:Store>

    <ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
        UseIdConfirmation="false" AutoLoad="false">
        <AjaxEventConfig IsUpload="true" />
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="DealerName" />
                    <ext:RecordField Name="WarehouseName" />
                    <ext:RecordField Name="CustomerFaceNbr" />
                    <ext:RecordField Name="CFNChineseName" />
                    <ext:RecordField Name="Upn" />
                    <ext:RecordField Name="LotNumber" />
                    <ext:RecordField Name="ExpiredDate" Type="Date" />
                    <ext:RecordField Name="UnitOfMeasure" />
                    <ext:RecordField Name="OnHandQty" />
                    <ext:RecordField Name="ExpiredDateString" />
                    <ext:RecordField Name="OnHandQtyDecimal" />
                    <ext:RecordField Name="CFNEnglishName" />
                    <ext:RecordField Name="WhmType" />
                    <ext:RecordField Name="LotDOM" />
                    <ext:RecordField Name="QRCode" />
                    <ext:RecordField Name="Property1" />
                    <ext:RecordField Name="FrozenDate" />
                    <ext:RecordField Name="WarehouseFrom" />
                    
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert(MsgList.DetailStore.LoadExceptionTitle, e.message || response.statusText);" />
        </Listeners>
        <%--        <SortInfo Field="CustomerFaceNbr" Direction="ASC" />   Type="Date" DateFormat="n/j h:ia" --%>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North Collapsible="True" Split="True" MarginsSummary="5 5 5 5">
                    <ext:Panel ID="Panel5" runat="server" Header="true" Title="<%$ Resources: Panel5.Title %>"
                        Frame="true" AutoHeight="true" Icon="Find">
                        <Body>
                            <ext:Panel ID="Panel1" runat="server" Header="false" Title="<%$ Resources: Panel5.Panel1.Title %>"
                                Frame="false" AutoHeight="true">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".4">
                                            <ext:Panel ID="Panel2" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="100">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cboDealer" runat="server" EmptyText="<%$ Resources: Panel5.Panel2.FormLayout1.cboDealer.EmptyText %>"
                                                                Width="200" Editable="true" TypeAhead="false" StoreID="DealerStore" ValueField="Id"
                                                                DisplayField="ChineseShortName" Mode="Local" ListWidth="300" Resizable="true"
                                                                FieldLabel="<%$ Resources: Panel5.Panel2.FormLayout1.cboDealer.FieldLabel %>">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel5.Panel2.FormLayout1.FieldTrigger.Qtip %>" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <BeforeQuery Fn="ComboxSelValue" />
                                                                    <TriggerClick Handler="this.clearValue();#{WarehouseStore}.reload();#{cboWarehouse}.clearValue();" />
                                                                    <Select Handler="#{WarehouseStore}.reload();
                                                                ClearItems(); " />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                       
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtCFN" runat="server" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>"
                                                                Enabled="true" Width="200" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:DateField ID="dateFrom" runat="server" Width="150" Vtype="daterange" FieldLabel="<%$ Resources: Panel5.Panel2.FormLayout1.dateFrom.FieldLabel %>">
                                                                <Listeners>
                                                                    <Render Handler="this.endDateField='#{dateTo}'" />
                                                                </Listeners>
                                                            </ext:DateField>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="100">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cboWarehouse" runat="server" EmptyText="<%$ Resources: Panel5.Panel3.FormLayout2.cboWarehouse.EmptyText %>"
                                                                Width="200" Editable="true" TypeAhead="false" StoreID="WarehouseStore" ValueField="Id"
                                                                DisplayField="Name" ListWidth="300" Resizable="true" FieldLabel="<%$ Resources: Panel5.Panel3.FormLayout2.cboWarehouse.FieldLabel %>">
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel5.Panel3.FormLayout2.FieldTrigger.Qtip %>" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                    <BeforeQuery Fn="ComboxSelValue" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtLot" runat="server" FieldLabel="批号/二维码" Width="200" Enabled="true" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:DateField ID="dateTo" runat="server" Width="150" Vtype="daterange" FieldLabel="<%$ Resources: Panel5.Panel3.FormLayout2.dateTo.FieldLabel %>">
                                                                <Listeners>
                                                                    <Render Handler="this.startDateField='#{dateFrom}'" />
                                                                </Listeners>
                                                            </ext:DateField>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="100">
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
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtUPN" runat="server" FieldLabel="<%$ Resources: Panel5.Panel4.FormLayout3.txtUPN.FieldLabel %>"
                                                                ReadOnly="false" Enabled="true" Hidden="<%$ AppSettings: HiddenUPN  %>" Width="200" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtCfnName" runat="server" FieldLabel="<%$ Resources: resource,Label_Article_Name  %>"
                                                                Enabled="true" Width="200" />
                                                        </ext:Anchor>
                                                      <ext:Anchor>                   
                                                           <ext:NumberField runat="server" ID="Stockdays" FieldLabel="库存天数" Width="200"  allowNegative="false" allowDecimals="false"  MaxLength="5" EmptyText=">=库存天数"></ext:NumberField>
                                                      </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                                <Buttons>
                                    <ext:Button ID="btnClear" runat="server" Text="<%$ Resources: Panel5.Panel1.btnClear.Text %>"
                                        Icon="Reload" IDMode="Legacy" OnClientClick="">
                                        <Listeners>
                                            <Click Handler="Coolite.AjaxMethods.ClearCriteria();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnSearch" Text="<%$ Resources: Panel5.Panel1.btnSearch.Text %>"
                                        runat="server" Icon="Zoom" IDMode="Legacy">
                                        <Listeners>
                                            <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                            <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnSubmit" Text="导出" runat="server" Icon="PageExcel" IDMode="Legacy"
                                        AutoPostBack="true" OnClick="ExportExcel">
                                    </ext:Button>
                                    <ext:Button ID="btnExportLPABC" Text="ABC产品分类导出" runat="server" Icon="PageExcel"
                                        IDMode="Legacy" AutoPostBack="true" OnClick="ExportLPABC">
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </Body>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 5 5">
                    <ext:Panel ID="Panel12" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                    StoreID="DetailStore" Border="false" Icon="Lorry" StripeRows="true" Header="false"
                                    AutoExpandColumn="CFNEnglishName">
                                    <TopBar>
                                        <ext:Toolbar ID="Toolbar1" runat="server" Height="25">
                                            <Items>
                                                <ext:Label ID="lblResult" runat="server" Text="<%$ Resources: GridPanel1.Title %>"
                                                    Icon="Lorry" />
                                                <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                <ext:Label ID="lblInvSum" runat="server" Text="" Icon="Sum" />
                                            </Items>
                                        </ext:Toolbar>
                                    </TopBar>
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="Dealer" DataIndex="DealerName" Header="<%$ Resources: GridPanel1.ColumnModel1.Dealer.Header %>"
                                                Width="180">
                                            </ext:Column>
                                            <ext:Column ColumnID="Warehouse" DataIndex="WarehouseName" Header="<%$ Resources: GridPanel1.ColumnModel1.Warehouse.Header %>"
                                                Width="170">
                                            </ext:Column>
                                            <ext:Column ColumnID="WhmType" DataIndex="WhmType" Header="<%$ Resources: GridPanel1.ColumnModel1.WarehouseType.Header %>"
                                                Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="CFN" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                                Width="130">
                                            </ext:Column>
                                            <ext:Column ColumnID="CFNChineseName" DataIndex="CFNChineseName" Width="160" Header="<%$ Resources: GridPanel1.ColumnModel1.ProductChineseName.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="CFNEnglishName" DataIndex="CFNEnglishName" Header="<%$ Resources: GridPanel1.ColumnModel1.ProductEnglishNameName.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="UPN" DataIndex="Upn" Header="<%$ Resources: GridPanel1.ColumnModel1.UPN.Header %>"
                                                Hidden="<%$ AppSettings: HiddenUPN  %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.LotNumber.Header %>"
                                                Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码" Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="ExpiredDateString" DataIndex="ExpiredDateString" Header="<%$ Resources: GridPanel1.ColumnModel1.ExpiredDate.Header %>"
                                                Width="100" Align="Center">
                                            </ext:Column>
                                            <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="<%$ Resources: GridPanel1.ColumnModel1.UnitOfMeasure.Header %>"
                                                Hidden="<%$ AppSettings: HiddenUOM  %>" Width="40" Align="Center">
                                            </ext:Column>
                                            <ext:Column ColumnID="OnHandQty" DataIndex="OnHandQty" Header="<%$ Resources: GridPanel1.ColumnModel1.OnHandQty.Header %>"
                                                Width="70" Align="Right">
                                            </ext:Column>
                                            <ext:Column ColumnID="LotDOM" DataIndex="LotDOM" Header="产品生产日期" Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="FrozenDate" DataIndex="FrozenDate" Header="在库时间"
                                                Width="70" Align="Right">
                                            </ext:Column>
                                            <ext:Column ColumnID="WarehouseFrom" DataIndex="WarehouseFrom" Header="产品来源"
                                                Width="100" >
                                            </ext:Column>
                                            <ext:CommandColumn Header="批次质检报告(CoA)下载" Align="Center" Width="50">
                                                <Commands>
                                                    <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                        <ToolTip Text="批次质检报告(CoA)下载" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="DetailStore"
                                            DisplayInfo="true">
                                        </ext:PagingToolbar>
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                    <Listeners>
                                        <Command Handler="if (command == 'DownLoad')     
                                    {
                                          Coolite.AjaxMethods.DownloadPdf(record.data.LotNumber,record.data.Property1,record.data.Upn,
                                        {success:function(){
                                           var Downame=#{HiddDowleName}.getValue();
                                         
                                           if(Downame!='')
                                             {
                                             var fileName=#{HiddFileName}.getValue();
                                            var url = '../Download.aspx?downloadname=' + escape(Downame) + '&fileName=' + escape(fileName) + '&downtype=COA';
                                     
                                            downloadfile(url);
                                            }
                                             },failure:function(err){Ext.Msg.alert('Error', err);}});
                                    }" />
                                    </Listeners>
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>
