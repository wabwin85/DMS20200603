<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WarehouseMaint.aspx.cs"
    Inherits="DMS.Website.Pages.Inventory.WarehouseMaint" ValidateRequest="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/WarehouseEditor.ascx" TagName="WarehouseEditor"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <style type="text/css">
        .list-item
        {
            font: normal 11px tahoma, arial, helvetica, sans-serif;
            padding: 3px 10px 3px 10px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #555;
        }
        .list-item h3
        {
            display: block;
            font: inherit;
            font-weight: bold;
            color: #222;
        }
    </style>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">
        var MsgList = {
			Store1:{
				LoadExceptionTitle:"<%=GetLocalResourceObject("Store1.LoadException.Alert.Title").ToString()%>",
				LoadExceptionMsg:"<%=GetLocalResourceObject("Store1.LoadException.Alert.Body").ToString()%>",
				CommitFailedTitle:"<%=GetLocalResourceObject("Store1.CommitFailed.Alert.Title").ToString()%>",
				CommitFailedMsg:"<%=GetLocalResourceObject("Store1.CommitFailed.Alert.Body").ToString()%>",
				SaveExceptionTitle:"<%=GetLocalResourceObject("Store1.SaveException.Alert.Title").ToString()%>",
				SaveExceptionMsg:"<%=GetLocalResourceObject("Store1.SaveException.Alert.Body").ToString()%>",
				CommitDoneTitle:"<%=GetLocalResourceObject("Store1.CommitDone.Alert.Title").ToString()%>",
				CommitDoneMsg:"<%=GetLocalResourceObject("Store1.CommitDone.Alert.Body").ToString()%>"
			}
        }

        var currentDealerRecID;  //当前DealerRecordID

        var DetailsRender = function(para) {
        return '<img class="imgEdit" ext:qtip="<%=GetLocalResourceObject("DetailsRender.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/vcard_edit.png" />';
        }

        var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var test = "1";

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

            if (t.className == 'imgEdit' && columnId == 'Details') {
                openDetails(record, t, test);
                //openDetails2(record, t, test);
                Coolite.AjaxMethods.sethospitalname();
            }
        }

        var createNewObject = function() {

            var record = Ext.getCmp("GridPanel1").insertRecord(0, {});

            record.set('LastModifiedDate', Ext.util.Format.date(Date(), "Y-m-d\\TH:i:s"));

            Ext.getCmp("GridPanel1").getView().focusRow(0);
            Coolite.AjaxMethods.createNewObjects();

            createNewObjectDetails(record, "GridPanel1", null);
        }

    /* 保存时检查是否只有一个缺省仓库 */
        var IsDefaultWarehouse = function(store) {
            var defaultWHCount;
            defaultWHCount = 0;
            for (var i = 0; i < store.getCount(); i++) {
                var record = store.getAt(i);
                if (record.data.Type != null) {
                    if (record.data.Type.toLowerCase() == 'defaultwh') {
                        defaultWHCount++;
                    }
                };
            };
            if ((Ext.getCmp('hiddenHasDefaultWarehouse').getValue() == 'True') && ((Ext.getCmp('hiddenShowDefaultWarehouse').getValue() == 'False') || (Ext.getCmp('hiddenShowDefaultWarehouse').getValue() == ''))) { /* 如果查询结果没有显示缺省仓库 */
                defaultWHCount++;
            };
            if (defaultWHCount <= 1) {
                if (defaultWHCount == 1) {
                    Ext.getCmp('hiddenHasDefaultWarehouse').setValue("True");
                    if (Ext.getCmp('hiddenShowDefaultWarehouse').getValue() == 'False') { Ext.getCmp('hiddenShowDefaultWarehouse').setValue("True"); };
                };
                if (defaultWHCount == 0) {
                    Ext.getCmp('hiddenHasDefaultWarehouse').setValue("False");
                    Ext.getCmp('hiddenShowDefaultWarehouse').setValue("False");
                };
                return true;
            }
            else {
                return false;
            };
        }

        var checkWhenSubmit = function() {
            if (IsDefaultWarehouse(Ext.getCmp('GridPanel1').store)) {
                Ext.getCmp("GridPanel1").save();
            }
            else {
                Ext.Msg.alert('<%=GetLocalResourceObject("checkWhenSubmit.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("checkWhenSubmit.Alert.Body").ToString()%>', '<%=GetLocalResourceObject("checkWhenSubmit.Alert.Body1").ToString()%>');
            }
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
    </script>

</head>
<body>
    <form id="frmWarehouse" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
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
                        <ext:RecordField Name="ChineseShortName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
        </ext:Store>
        <ext:Store ID="WarehouseTypeStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshDictionary"
            AutoLoad="true">
            <BaseParams>
                <ext:Parameter Name="Type" Value="MS_WarehouseType" Mode="Value">
                </ext:Parameter>
            </BaseParams>
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
            <SortInfo Field="Key" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="Store1" runat="server" UseIdConfirmation="false" OnRefreshData="Store1_RefreshData"
            AutoLoad="false" OnBeforeStoreChanged="Store1_BeforeStoreChanged">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="Name" />
                        <ext:RecordField Name="Type" />
                        <ext:RecordField Name="Province" />
                        <ext:RecordField Name="City" />
                        <ext:RecordField Name="Town" />
                        <ext:RecordField Name="District" />
                        <ext:RecordField Name="Phone" />
                        <ext:RecordField Name="Fax" />
                        <ext:RecordField Name="ConId" />
                        <ext:RecordField Name="PostalCode" />
                        <ext:RecordField Name="Address" />
                        <ext:RecordField Name="HoldWarehouse" />
                        <ext:RecordField Name="ActiveFlag" />
                        <ext:RecordField Name="HospitalHosId" />
                        <ext:RecordField Name="Code" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--      <SortInfo Field="Name" Direction="DESC" />--%>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert(MsgList.Store1.LoadExceptionTitle, MsgList.Store1.LoadExceptionMsg +  e.message || e )" />
                <CommitFailed Handler="Ext.Msg.alert(MsgList.Store1.CommitFailedTitle, MsgList.Store1.CommitFailedMsg + msg)" />
                <SaveException Handler="Ext.Msg.alert(MsgList.Store1.SaveExceptionTitle, MsgList.Store1.SaveExceptionMsg + e.message || e)" />
                <CommitDone Handler="Ext.Msg.alert(MsgList.Store1.CommitDoneTitle, MsgList.Store1.CommitDoneMsg);" />
            </Listeners>
        </ext:Store>
        <ext:Hidden ID="hiddenHasDefaultWarehouse" runat="server" />
        <ext:Hidden ID="hiddenShowDefaultWarehouse" runat="server" />
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Border="false" Frame="true" AutoHeight="true"
                            Title="<%$ Resources: plSearch.Title %>" Icon="Find" ButtonAlign="Right">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".4">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: plSearch.FormLayout2.cbDealer.EmptyText %>"
                                                            Width="220" Editable="true" TypeAhead="False" StoreID="DealerStore" ValueField="Id"
                                                            DisplayField="ChineseShortName" ListWidth="300" Resizable="true" Mode="Local" FieldLabel="<%$ Resources: plSearch.FormLayout2.cbDealer.FieldLabel %>">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.FormLayout2.FieldTrigger.Qtip %>" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();this.store.clearFilter();" />
                                                                <BeforeQuery Fn="SelectValue" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtFilterWarehouseName" runat="server" FieldLabel="<%$ Resources: plSearch.FormLayout1.txtFilterWarehouseName.FieldLabel %>"
                                                            Width="150" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel9" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtFilterAddress" runat="server" FieldLabel="<%$ Resources: plSearch.FormLayout4.txtFilterAddress.FieldLabel %>"
                                                            Width="150" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="<%$ Resources: plSearch.btnSearch.Text %>" runat="server"
                                    Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: plSearch.btnInsert.Text %>"
                                    Icon="Add" CommandArgument="" CommandName="" IDMode="Legacy" OnClientClick="">
                                    <Listeners>
                                        <Click Handler="createNewObject();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnSave" runat="server" Text="<%$ Resources: plSearch.btnSave.Text %>"
                                    Icon="Disk" CommandArgument="" CommandName="" IDMode="Legacy" OnClientClick="">
                                    <Listeners>
                                        <Click Handler="checkWhenSubmit();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: plSearch.btnDelete.Text %>"
                                    Icon="Delete" CommandArgument="" Hidden="true" CommandName="" IDMode="Legacy"
                                    OnClientClick="">
                                    <Listeners>
                                        <Click Handler="#{GridPanel1}.deleteSelected();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnExport" Text="导出" runat="server" Icon="PageExcel" IDMode="Legacy"
                                    AutoPostBack="true" OnClick="ExportExcel">
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel ID="Panel7" runat="server">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                        StoreID="Store1" Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DmaId" DataIndex="DmaId" Header="<%$ Resources: GridPanel1.ColumnModel1.DmaId.Header %>">
                                                    <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseShortName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Code" DataIndex="Code" Header="仓库代码">
                                                    <Editor>
                                                        <ext:TextField ID="txtCode" runat="server" Disabled="true"  />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="Name" DataIndex="Name" Header="<%$ Resources: GridPanel1.ColumnModel1.Name.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtName" runat="server" Disabled="true" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="Province" DataIndex="Province" Header="<%$ Resources: GridPanel1.ColumnModel1.Province.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtProvince" runat="server"  Disabled="true" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="Id" DataIndex="Id" Header="<%$ Resources: GridPanel1.ColumnModel1.Id.Header %>"
                                                    Hidden="true">
                                                    <Editor>
                                                        <ext:TextField ID="txtId" runat="server" Disabled="true"  />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="City" DataIndex="City" Header="<%$ Resources: GridPanel1.ColumnModel1.City.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtCity" runat="server"  Disabled="true" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="Type" DataIndex="Type" Header="<%$ Resources: GridPanel1.ColumnModel1.Type.Header %>"
                                                    Hidden="false">
                                                    <Renderer Handler="return getNameFromStoreById(WarehouseTypeStore,{Key:'Key',Value:'Value'},value);" />
                                                    <Editor>
                                                        <ext:ComboBox ID="ComboBox2" runat="server" FieldLabel="<%$ Resources: GridPanel1.ColumnModel1.ComboBox2.FieldLabel %>"
                                                            StoreID="WarehouseTypeStore" Editable="false" TypeAhead="true" Mode="Local" DisplayField="Value"
                                                            ValueField="Key" ForceSelection="true" TriggerAction="All" EmptyText="<%$ Resources: GridPanel1.ColumnModel1.ComboBox2.EmptyText %>"
                                                            ItemSelector="div.list-item" SelectOnFocus="true">
                                                            <Template ID="Template3" runat="server">
                                                            <tpl for=".">
                                                                <div class="list-item">
                                                                     {Value}
                                                                </div>
                                                            </tpl>
                                                            </Template>
                                                        </ext:ComboBox>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="PostalCode" DataIndex="PostalCode" Header="<%$ Resources: GridPanel1.ColumnModel1.PostalCode.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtPostalCode" runat="server" Disabled="true"  />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="Address" DataIndex="Address" Header="<%$ Resources: GridPanel1.ColumnModel1.Address.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtAddress" runat="server" Disabled="true"  />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:CheckColumn ColumnID="HoldWarehouse" DataIndex="HoldWarehouse" Header="<%$ Resources: GridPanel1.ColumnModel1.HoldWarehouse.Header %>"
                                                    Hidden="true">
                                                    <Editor>
                                                        <ext:Checkbox ID="chkHoldWarehouse" runat="server"  Disabled="true" />
                                                    </Editor>
                                                </ext:CheckColumn>
                                                <ext:Column ColumnID="Town" DataIndex="Town" Header="<%$ Resources: GridPanel1.ColumnModel1.Town.Header %>"
                                                    Hidden="true">
                                                    <Editor>
                                                        <ext:TextField ID="txtTown" runat="server" Disabled="true" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="District" DataIndex="District" Header="<%$ Resources: GridPanel1.ColumnModel1.District.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtDistrict" runat="server" Disabled="true" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="Phone" DataIndex="Phone" Header="<%$ Resources: GridPanel1.ColumnModel1.Phone.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtPhone" runat="server" Disabled="true" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="Fax" DataIndex="Fax" Header="<%$ Resources: GridPanel1.ColumnModel1.Fax.Header %>">
                                                    <Editor>
                                                        <ext:TextField ID="txtFax" runat="server" Disabled="true" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:CheckColumn ColumnID="ActiveFlag" DataIndex="ActiveFlag" Header="<%$ Resources: GridPanel1.ColumnModel1.ActiveFlag.Header %>">
                                                </ext:CheckColumn>
                                                <ext:Column ColumnID="HospitalHosId" DataIndex="HospitalHosId" Header="<%$ Resources: GridPanel1.ColumnModel1.HospitalHosId.Header %>"
                                                    Hidden="true">
                                                    <Editor>
                                                        <ext:TextField ID="txtHospitalHosId" runat="server" Disabled="true" />
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="Details" Header="<%$ Resources: GridPanel1.ColumnModel1.Details.Header %>"
                                                    Width="50" Align="Center" Fixed="true" DataIndex="ABc" MenuDisabled="true" Resizable="false">
                                                    <Renderer Fn="DetailsRender" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                                DisplayInfo="true" DisplayMsg="<%$ Resources: GridPanel1.BottomBar.PagingToolBar1.DisplayMsg %>"
                                                EmptyMsg="<%$ Resources: GridPanel1.BottomBar.PagingToolBar1.EmptyMsg %>" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                        <Listeners>
                                            <CellClick Fn="cellClick" />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <uc1:WarehouseEditor ID="WarehouseEditor1" runat="server" />
    </div>
    </form>
</body>
</html>
