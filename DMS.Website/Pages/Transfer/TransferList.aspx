<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TransferList.aspx.cs" Inherits="DMS.Website.Pages.Transfer.Transfer" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/TransferDialog.ascx" TagName="TransferDialog" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .editable-column
        {
            background: #FFFF99;
        }
        .nonEditable-column
        {
            background: #FFFFFF;
        }
    </style>

    <script language="javascript">       
        var MsgList = {
			btnInsert:{
				FailureTitle:"<%=GetLocalResourceObject("Panel1.btnInsert.AjaxEvents.Alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("Panel1.btnInsert.AjaxEvents.Alert.Body").ToString()%>"
			},
			ShowDetails:{
				FailureTitle:"<%=GetLocalResourceObject("GridPanel1.AjaxEvents.Alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("GridPanel1.AjaxEvents.Alert.Body").ToString()%>"
			},
			AddItemsButton:{
				FailureTitle:"<%=GetLocalResourceObject("GridPanel2.AddItemsButton.AjaxEvents.Alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("GridPanel2.AddItemsButton.AjaxEvents.Alert.Body").ToString()%>"
			}
        }

        var CheckAddItemsParam = function() {
            //此函数用来控制“添加产品”按钮的状态
            if (Ext.getCmp('cbDealerFromWin').getValue() == '' || Ext.getCmp('cbProductLineWin').getValue() == '' || Ext.getCmp('hiddenDealerToId').getValue() == '') {
                Ext.getCmp('AddItemsButton').disable();
            } else {
                Ext.getCmp('AddItemsButton').enable();
            }
        }

        var SetMod = function(changed) {
            var hiddenIsModified = Ext.getCmp('hiddenIsModified');
            if (changed) {
                if (hiddenIsModified.getValue() == 'new') {
                    hiddenIsModified.setValue('newchanged');
                } else if (hiddenIsModified.getValue() == 'old') {
                    hiddenIsModified.setValue('oldchanged');
                }
            }
        }

        //校验用户输入数量
        var CheckQty = function() {
            var txtQty = Ext.getCmp('txtQty');
            var grid = Ext.getCmp('GridPanel2');
            var hiddenCurrentEdit = Ext.getCmp('hiddenCurrentEdit');
            var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');
            var record = grid.store.getById(hiddenCurrentEdit.getValue());
            //记录当前编辑的行ID
            hiddenIsEditting.setValue(hiddenCurrentEdit.getValue());
            if ((parseInt(record.data.TotalQty) < parseInt(txtQty.getValue()))) {
                //数量错误时，编辑行置为空
                hiddenIsEditting.setValue('');
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body").ToString()%>');
                return false;
                
            }
            else if ((parseInt(txtQty.getValue()) > 1)) {
                //转移库存不能大于1
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.EWM").ToString()%>');
                return false;
            }
           
             
             

            return true;
        }
        
        //当关闭明细窗口时，判断是否需要保存数据
        var CheckMod = function() {
            var currenStatus = Ext.getCmp('hiddenIsModified').getValue();
            if (currenStatus == 'new') {
                Coolite.AjaxMethods.DeleteDraft(
                {
                    success: function() {
                        Ext.getCmp('hiddenIsModified').setValue('');
                        Ext.getCmp('GridPanel1').store.reload();
                        Ext.getCmp('DetailWindow').hide();
                    },
                    failure: function(err) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', err);
                    }
                }
                );
                return false;
            }
            if (currenStatus == 'newchanged') {
                //第一次新增的窗口
                Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Body").ToString()%>',
                function(e) {
                    if (e == 'yes') {
                        //alert("用户需保存草稿或提交数据");
                    } else {
                        //alert("执行删除草稿的操作");
                        Coolite.AjaxMethods.DeleteDraft(
                        {
                            success: function() {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                            },
                            failure: function(err) {
                            Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', err);
                            }
                        }
                        );
                    }
                });
                return false;
            }
            if (currenStatus == 'oldchanged') {
                //修改窗口
                Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.oldchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("CheckMod.oldchanged.Confirm.Body").ToString()%>',
                function(e) {
                    if (e == 'yes') {
                        //alert("用户需保存草稿或提交数据");
                    } else {
                        Ext.getCmp('hiddenIsModified').setValue('');
                        Ext.getCmp('DetailWindow').hide();
                    }
                });
                return false;
            }
            //因为已经改成了修改一条记录就更新数据库，所以下面的判断也就用不到了
            /*
            if (IsStoreDirty(Ext.getCmp('GridPanel2').store)) {
            Ext.Msg.confirm('Warning', '数据已被修改过，是否保存？',
            function(e) {
            if (e == 'yes') {
            alert("执行数据保存");
            } else {
            //alert("将dirty数据commit");
            StoreCommitAll(Ext.getCmp('GridPanel2').store);
            Ext.getCmp('DetailWindow').hide();
            }
            });
            return false;
            }
            */
        }

        //判断store是否修改过
        var IsStoreDirty = function(store) {
            for (var i = 0; i < store.getCount(); i++) {
                var record = store.getAt(i);
                if (record.dirty) {
                    //alert('Record is dirty');
                    return true;
                }
            }
            return false;
        }

        //改变store状态
        var StoreCommitAll = function(store) {
            for (var i = 0; i < store.getCount(); i++) {
                var record = store.getAt(i);
                if (record.dirty) {
                    record.commit();
                }
            }
        }

        var ChangeProductLine = function() {
            var hiddenProductLineId = Ext.getCmp('hiddenProductLineId');
            var cbProductLineWin = Ext.getCmp('cbProductLineWin');
            var grid = Ext.getCmp('GridPanel2');
            var hiddenIsModified = Ext.getCmp('hiddenIsModified');

            if (hiddenProductLineId.getValue() != cbProductLineWin.getValue()) {
                if (hiddenProductLineId.getValue() == '') {
                    hiddenProductLineId.setValue(cbProductLineWin.getValue());
                    grid.store.reload();
                    CheckAddItemsParam();
                    ClearItems();
                    SetMod(true);
                } else {
                Ext.Msg.confirm('<%=GetLocalResourceObject("ChangeProductLine.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("ChangeProductLine.Confirm.Body").ToString()%>',
                        function(e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.DeleteDetail(
                                    {
                                        success: function() {
                                            hiddenProductLineId.setValue(cbProductLineWin.getValue());
                                            grid.store.reload();
                                            CheckAddItemsParam();
                                            ClearItems();
                                            SetMod(true);
                                        },
                                        failure: function(err) {
                                        Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', err);
                                        }
                                    }
                                );
                            }
                            else {
                                cbProductLineWin.setValue(hiddenProductLineId.getValue());
                            }
                        }
                    );
                }
            }

        }

        var ChangeDealerTo = function() {            
            Coolite.AjaxMethods.CheckDealer({
                success: function() {
                    CheckAddItemsParam();
                    SetMod(true);
                },
                failure: function(err) {
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', err);
                }
            });
        }

        var CheckSubmit = function() {
            var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');
            if (hiddenIsEditting.getValue() != '') {
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckSubmit.Alert.Body").ToString()%>');
                return;
            }
            var cbDealerFromWin = Ext.getCmp('cbDealerFromWin');
            var cbProductLineWin = Ext.getCmp('cbProductLineWin');
            var cbDealerToWin = Ext.getCmp('cbDealerToWin');
            var grid = Ext.getCmp('GridPanel2');
            if (cbDealerFromWin.getValue() != '' && cbProductLineWin.getValue() != '' && cbDealerToWin.getValue() != '' && grid.store.getCount() > 0) {
                if (CheckLotQty()) {
                    Coolite.AjaxMethods.DoSubmit({
                        success: function(result) {
                            //alert(result);
                            if (result == "True") {
                                if (result) {
                                    Ext.getCmp('hiddenIsModified').setValue('');
                                    Ext.getCmp('GridPanel1').store.reload();
                                    Ext.getCmp('DetailWindow').hide();
                                }
                            }
                            else if (result == "DealerTypeNotEqual") {
                                Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title").ToString()%>', ' <%=GetLocalResourceObject("CheckSubmit.MarketType.Alert.Body").ToString()%>');
                            }
                            
                        },
                        failure: function(err) {
                        Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', err);
                        }
                    });
                }
            } else {
            Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', ' <%=GetLocalResourceObject("CheckSubmit.Alert.Body1").ToString()%>');
            }
        }

        var CheckLotQty = function() {
            var store = Ext.getCmp('GridPanel2').store;
            for (var i = 0; i < store.getCount(); i++) {
                var record = store.getAt(i);
                if (record.data.TransferQty <= 0) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body").ToString()%>');
                    return false;
                }
                  if((record.data.QRCodeEdit == "" || record.data.QRCodeEdit == null) && record.data.QRCode == "NoQR")
                {
                      Ext.Msg.alert('<%=GetLocalResourceObject("CheckLotQty.Alert.Title").ToString()%>', '借货出库二维码为NoQR，请联系系统管理员补充二维码！');
                    return false;
                }
                 if(record.data.QRCodeEdit!=null &&  record.data.QRCodeEdit != '' && record.data.TransferQty>1)
                   {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '带二维码的产品数量不得大于一');
                    return false;
                   }
                   if(store.query("QRCodeEdit",record.data.QRCodeEdit).length>1 &&record.data.QRCode=="NoQR" &&record.data.QRCodeEdit!='')
                   {
                     Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>','二维码'+record.data.QRCodeEdit+"出现多次");
                    return false;
                   }
                   if(store.query("QRCode",record.data.QRCodeEdit).length>0 &&record.data.QRCode=="NoQR"&&record.data.QRCodeEdit!='')
                   {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>','二维码'+record.data.QRCode+"已使用");
                    return false;
                   }
            }
            return true;
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
        
        var SetCellCssEditable  = function(v,m){
        m.css = "editable-column";
        return v;
        }
        
         var SetCellCssNonEditable  = function(v,m){
            m.css = "nonEditable-column";
            return v;
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="#{DealerToStore}.load();" />
        </Listeners>
    </ext:ScriptManager>
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
        <Listeners>
            <Load Handler="#{cbDealerFrom}.setValue(#{hidInitDealerId}.getValue());" />
        </Listeners>
        <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="DealerToStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_DealerToList"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ChineseShortName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <BaseParams>
            <ext:Parameter Name="DealerFromId" Value="#{hidInitDealerId}.getValue()" Mode="Raw" />
        </BaseParams>
        <Listeners>
            <Load Handler="#{cbDealerTo}.clearValue();" />
        </Listeners>
        <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="DealerToStoreWin" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ChineseShortName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <Load Handler="#{cbDealerToWin}.setValue(#{hiddenDealerToId}.getValue());" />
        </Listeners>
        <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="TransferStatusStore" runat="server" UseIdConfirmation="true">
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
    <ext:Store ID="TransferTypeStore" runat="server" UseIdConfirmation="true">
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
    <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="TransferNumber" />
                    <ext:RecordField Name="FromDealerDmaId" />
                    <ext:RecordField Name="Status" />
                    <ext:RecordField Name="ToDealerDmaId" />
                    <ext:RecordField Name="ToDealerDmaName" />
                    <ext:RecordField Name="Type" />
                    <ext:RecordField Name="Description" />
                    <ext:RecordField Name="ReverseTrnId" />
                    <ext:RecordField Name="TransferDate" />
                    <ext:RecordField Name="TotalQyt" />
                    <ext:RecordField Name="TransferUserName" />
                    <ext:RecordField Name="LPUploadNo" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--            <SortInfo Field="ToDealerDmaId" Direction="ASC" />--%>
    </ext:Store>
    <ext:Hidden ID="hidInitDealerId" runat="server">
    </ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true"
                        BodyStyle="padding: 5px;" Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout1.cbProductLine.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                        DisplayField="AttributeName" FieldLabel="<%$ Resources: Panel1.FormLayout1.cbProductLine.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout1.cbProductLine.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtStartDate" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout1.txtStartDate.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtTransferNumber" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout1.txtTransferNumber.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbTransferType" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout2.cbTransferType.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" FieldLabel="<%$ Resources: Panel1.FormLayout2.cbTransferType.FieldLabel %>"
                                                        StoreID="TransferTypeStore" ValueField="Key" DisplayField="Value">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout3.cbTransferStatus.FieldTrigger.Qtip %>" />
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
                                                    <ext:ComboBox ID="cbDealerFrom" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout2.cbDealerFrom.EmptyText %>"
                                                        Width="220" Editable="true" Mode="Local" TypeAhead="true" StoreID="DealerStore"
                                                        ValueField="Id" DisplayField="ChineseShortName" FieldLabel="<%$ Resources: Panel1.FormLayout2.cbDealerFrom.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout2.cbDealerFrom.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <BeforeQuery Fn="ComboxSelValue" />
                                                            <TriggerClick Handler="this.clearValue();this.store.clearFilter();#{DealerToStore}.reload();" />
                                                            <Select Handler="#{DealerToStore}.reload();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtEndDate" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout2.txtEndDate.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtCFN" runat="server" Width="150" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtUPN" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout2.txtUPN.FieldLabel %>"
                                                        Hidden="<%$ AppSettings: HiddenUPN  %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtLPNo" runat="server" Width="150" FieldLabel="平台上传单号" />
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
                                                    <ext:ComboBox ID="cbDealerTo" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout3.cbDealerTo.EmptyText %>"
                                                        Width="220" Editable="true" Mode="Local" TypeAhead="true" StoreID="DealerToStore"
                                                        ValueField="Id" DisplayField="ChineseShortName" FieldLabel="<%$ Resources: GridPanel1.ColumnModel1.ToDealerDmaName.Header %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout3.cbDealerTo.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbTransferStatus" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout3.cbTransferStatus.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="TransferStatusStore" ValueField="Key"
                                                        DisplayField="Value" FieldLabel="<%$ Resources: Panel1.FormLayout3.cbTransferStatus.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout3.cbTransferStatus.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtLotNumber" runat="server" Width="150" FieldLabel="批号/二维码" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnSearch" Text="<%$ Resources: Panel1.btnSearch.Text %>" runat="server"
                                Icon="ArrowRefresh" IDMode="Legacy">
                                <Listeners>
                                    <%--<Click Handler="#{GridPanel1}.reload();" />--%>
                                    <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: Panel1.btnInsert.Text %>"
                                Icon="Add" IDMode="Legacy">
                                <AjaxEvents>
                                    <Click Before="#{GridPanel1}.getSelectionModel().clearSelections();" OnEvent="ShowDetails"
                                        Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);"
                                        Success="#{cbDealerFromWin}.clearValue();#{cbDealerFromWin}.setValue(#{hiddenDealerFromId}.getValue());#{cbProductLineWin}.setValue(#{cbProductLineWin}.store.getTotalCount()>0?#{cbProductLineWin}.store.getAt(0).get('Id'):'');#{hiddenProductLineId}.setValue(#{cbProductLineWin}.getValue());ClearItems();#{GridPanel2}.clear();#{hiddenIsModified}.setValue('new');#{gpLog}.store.reload();">
                                        <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                        <ExtraParams>
                                            <ext:Parameter Name="TransferId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                            </ext:Parameter>
                                        </ExtraParams>
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                    StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="FromDealerDmaId" DataIndex="FromDealerDmaId" Header="<%$ Resources: GridPanel1.ColumnModel1.FromDealerDmaId.Header %>"
                                                Width="200">
                                                <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseShortName'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="TransferNumber" DataIndex="TransferNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.TransferNumber.Header %>"
                                                Width="200">
                                            </ext:Column>
                                            <ext:Column ColumnID="ToDealerDmaName" DataIndex="ToDealerDmaName" Header="<%$ Resources: DetailWindow.FormLayout5.txtDealerToWin.FieldLabel %>"
                                                Width="200">
                                            </ext:Column>
                                            <ext:Column ColumnID="TotalQyt" DataIndex="TotalQyt" Header="<%$ Resources: GridPanel1.ColumnModel1.TotalQyt.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="TransferDate" DataIndex="TransferDate" Header="<%$ Resources: GridPanel1.ColumnModel1.TransferDate.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="TransferUserName" DataIndex="TransferUserName" Header="<%$ Resources: GridPanel1.ColumnModel1.TransferUserName.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="LPUploadNo" DataIndex="LPUploadNo" Header="平台上传单号">
                                            </ext:Column>
                                            <ext:Column ColumnID="Status" DataIndex="Status" Header="<%$ Resources: GridPanel1.ColumnModel1.Status.Header %>">
                                                <Renderer Handler="return getNameFromStoreById(TransferStatusStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.ToolTip.Text %>" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <AjaxEvents>
                                        <Command OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.ShowDetails.FailureTitle, MsgList.ShowDetails.FailureMsg);"
                                            Success="#{cbDealerFromWin}.clearValue(); #{cbDealerFromWin}.setValue(#{hiddenDealerFromId}.getValue());#{cbProductLineWin}.clearValue(); #{cbProductLineWin}.setValue(#{hiddenProductLineId}.getValue());ClearItems();#{GridPanel2}.reload();#{hiddenIsModified}.setValue('old');#{gpLog}.store.reload();">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                            <ExtraParams>
                                                <ext:Parameter Name="TransferId" Value="#{GridPanel1}.getSelectionModel().getSelected().id"
                                                    Mode="Raw">
                                                </ext:Parameter>
                                            </ExtraParams>
                                        </Command>
                                    </AjaxEvents>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                            DisplayInfo="false" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="CFN" />
                    <ext:RecordField Name="UPN" />
                    <ext:RecordField Name="LotNumber" />
                    <ext:RecordField Name="ExpiredDate" />
                    <ext:RecordField Name="UnitOfMeasure" />
                    <ext:RecordField Name="TransferQty" />
                    <ext:RecordField Name="TotalQty" />
                    <ext:RecordField Name="WarehouseName" />
                    <ext:RecordField Name="WarehouseId" />
                    <ext:RecordField Name="CFNEnglishName" />
                    <ext:RecordField Name="CFNChineseName" />
                    <ext:RecordField Name="QRCode" />
                    <ext:RecordField Name="QRCodeEdit" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert('Load Exception', e.message || response.statusText);" />
        </Listeners>
        <%--        <SortInfo Field="CFN" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" OnRefreshData="OrderLogStore_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="PohId" />
                    <ext:RecordField Name="OperUser" />
                    <ext:RecordField Name="OperUserId" />
                    <ext:RecordField Name="OperUserName" />
                    <ext:RecordField Name="OperType" />
                    <ext:RecordField Name="OperTypeName" />
                    <ext:RecordField Name="OperDate" Type="Date" />
                    <ext:RecordField Name="OperNote" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hiddenTransferId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenDealerFromId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenDealerToId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenProductLineId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenDealerToDefaultWarehouseId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenCurrentEdit" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenIsEditting" runat="server" />
    <ext:Hidden ID="hiddenIsModified" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenlotNumber" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenQrCode" runat="server">
    </ext:Hidden>
    <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>"
        Width="950" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
        <Body>
            <ext:BorderLayout ID="BorderLayout2" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="50">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbDealerFromWin" runat="server" Width="200" Editable="true" Mode="Local"
                                                        TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName"
                                                        FieldLabel="<%$ Resources: Panel1.FormLayout3.cbDealerTo.FieldLabel %>" AllowBlank="false"
                                                        BlankText="<%$ Resources: DetailWindow.FormLayout4.cbDealerFromWin.BlankText %>"
                                                        EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbDealerFromWin.EmptyText %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout4.cbDealerFromWin.FieldTrigger.qtip %>"
                                                                HideTrigger="true" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <BeforeQuery Fn="ComboxSelValue" />
                                                            <TriggerClick Handler="this.clearValue();" />
                                                            <Select Handler="if (#{hiddenDealerFromId}.getValue() != #{cbDealerFromWin}.getValue()){Coolite.AjaxMethods.DeleteDetail( {
                                                            success: function() {
                                                                #{hiddenDealerFromId}.setValue(#{cbDealerFromWin}.getValue());
                                                                #{DetailStore}.reload();
                                                                CheckAddItemsParam();
                                                                ClearItems(); 
                                                            },
                                                            failure: function(err) {
                                                                Ext.Msg.alert('Failure', err);
                                                            }
                                                        });}" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbProductLineWin" runat="server" Width="150" Editable="false" TypeAhead="true"
                                                        StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.FieldLabel %>"
                                                        AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.BlankText %>"
                                                        EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.EmptyText %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.FieldTrigger.qtip %>"
                                                                HideTrigger="true" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                            <Select Handler="ChangeProductLine();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtNumber" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout5.txtNumber.FieldLabel %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbDealerToWin" runat="server" Width="200" Editable="true" Mode="Local"
                                                        TypeAhead="true" StoreID="DealerToStoreWin" ValueField="Id" DisplayField="ChineseShortName"
                                                        FieldLabel="<%$ Resources: GridPanel1.ColumnModel1.ToDealerDmaName.Header %>"
                                                        AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbDealerFromWin.BlankText %>"
                                                        EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbDealerFromWin.EmptyText %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: DetailWindow.FormLayout4.cbDealerFromWin.FieldTrigger.qtip %>"
                                                                HideTrigger="true" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <BeforeQuery Fn="ComboxSelValue" />
                                                            <Select Handler="ChangeDealerTo();if (#{hiddenDealerToId}.getValue() != #{cbDealerToWin}.getValue()){Coolite.AjaxMethods.DeleteDetail( {
                                                            success: function() {
                                                                #{hiddenDealerToId}.setValue(#{cbDealerToWin}.getValue());
                                                                #{DetailStore}.reload();
                                                                CheckAddItemsParam();
                                                                ClearItems(); 
                                                            },
                                                            failure: function(err) {
                                                                Ext.Msg.alert('Failure', err);
                                                            }
                                                        });}" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtDate" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtDate.FieldLabel %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtStatus" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtStatus.FieldLabel %>"
                                                        ReadOnly="true" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 5 5">
                    <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                        <Tabs>
                            <ext:Tab ID="TabHeader" runat="server" Title="<%$ Resources: TabDetail.Title %>"
                                BodyStyle="padding: 0px;" AutoScroll="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout2" runat="server">
                                        <ext:GridPanel ID="GridPanel2" runat="server" Title="<%$ Resources: GridPanel2.Title %>"
                                            StoreID="DetailStore" StripeRows="true" Border="false" Icon="Lorry" ClicksToEdit="1"
                                            EnableHdMenu="false" Header="false" AutoExpandColumn="CFNChineseName">
                                            <TopBar>
                                                <ext:Toolbar ID="Toolbar1" runat="server">
                                                    <Items>
                                                        <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                        <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources: GridPanel2.AddItemsButton.Text %>"
                                                            Icon="Add">
                                                            <AjaxEvents>
                                                                <Click OnEvent="ShowDialog" Failure="Ext.MessageBox.alert(MsgList.AddItemsButton.FailureTitle, MsgList.AddItemsButton.FailureMsg);">
                                                                    <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{DetailWindow}.body}" />
                                                                    <ExtraParams>
                                                                        <ext:Parameter Name="TransferId" Value="#{hiddenTransferId}.getValue()" Mode="Raw">
                                                                        </ext:Parameter>
                                                                    </ExtraParams>
                                                                </Click>
                                                            </AjaxEvents>
                                                        </ext:Button>
                                                    </Items>
                                                </ext:Toolbar>
                                            </TopBar>
                                            <ColumnModel ID="ColumnModel2" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="<%$ Resources: GridPanel2.ColumnModel2.WarehouseName.Header %>"
                                                        Width="170">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CFNEnglishName" Width="200" DataIndex="CFNEnglishName" Header="<%$ Resources: CFNEnglishName %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CFNChineseName" DataIndex="CFNChineseName" Header="<%$ Resources:CFNChineseName %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CFN" Width="100" DataIndex="CFN" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UPN" Width="100" DataIndex="UPN" Header="<%$ Resources: GridPanel2.ColumnModel2.UPN.Header %>"
                                                        Hidden="<%$ AppSettings: HiddenUPN  %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="LotNumber" Width="80" DataIndex="LotNumber" Header="<%$ Resources: GridPanel2.ColumnModel2.LotNumber.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码" Align="Right" Width="120">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources: GridPanel2.ColumnModel2.ExpiredDate.Header %>"
                                                        Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="<%$ Resources: GridPanel2.ColumnModel2.UnitOfMeasure.Header %>"
                                                        Width="50" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="<%$ Resources: GridPanel2.ColumnModel2.TotalQty.Header %>"
                                                        Width="90" Align="Right">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="TransferQty" DataIndex="TransferQty" Header="<%$ Resources: GridPanel2.ColumnModel2.TransferQtyEdit.Header %>"
                                                        Width="70" Align="Right">
                                                        <Editor>
                                                            <ext:NumberField ID="txtQty" runat="server" AllowBlank="false" AllowDecimals="false"
                                                                AllowNegative="false">
                                                            </ext:NumberField>
                                                        </Editor>
                                                    </ext:Column>
                                                    <ext:Column ColumnID="TransferQty" DataIndex="TransferQty" Header="<%$ Resources: GridPanel2.ColumnModel2.TransferQty.Header %>"
                                                        Align="Right" Width="50">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="QRCodeEdit" DataIndex="QRCodeEdit" Header="二维码" Align="Center"
                                                        Width="150">
                                                        <Editor>
                                                            <ext:TextField ID="txtQrCode" runat="server" AllowBlank="false" SelectOnFocus="true">
                                                            </ext:TextField>
                                                        </Editor>
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="60" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                                <ToolTip Text="<%$ Resources: GridPanel2.ColumnModel2.ToolTip.Text %>" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="DetailStore"
                                                    DisplayInfo="true" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel2.LoadMask.Msg %>" />
                                            <Listeners>
                                                <ValidateEdit Fn="CheckQty" />
                                                <Command Handler="Coolite.AjaxMethods.DeleteItem(this.getSelectionModel().getSelected().id,{failure: function(err) {Ext.Msg.alert('Failure', err);}});" />
                                                <BeforeEdit Handler="#{hiddenCurrentEdit}.setValue(this.getSelectionModel().getSelected().id);
                                                #{hiddenlotNumber}.setValue(this.getSelectionModel().getSelected().data.LotNumber);
                                                #{hiddenQrCode}.setValue(this.getSelectionModel().getSelected().data.QRCode);
                                                #{txtQrCode}.setValue(this.getSelectionModel().getSelected().data.QRCodeEdit);
                                                   #{txtQty}.setValue(this.getSelectionModel().getSelected().data.TransferQty);
                                                   
                                              " />
                                                <AfterEdit Handler="Coolite.AjaxMethods.SaveItem(#{hiddenCurrentEdit}.getValue(),#{txtQty}.getValue(),#{hiddenQrCode}.getValue(),#{txtQrCode}.getValue(),#{hiddenlotNumber}.getValue(),{success:function(){#{hiddenIsEditting}.setValue('');},failure: function(err) {Ext.Msg.alert('Failure', err);}});" />
                                            </Listeners>
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources: TabLog.Title %>" AutoScroll="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout3" runat="server">
                                        <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="OrderLogStore"
                                            StripeRows="true" Border="false" Icon="Lorry" ClicksToEdit="1" EnableHdMenu="false"
                                            Header="false" AutoExpandColumn="OperNote">
                                            <ColumnModel ID="ColumnModel3" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="<%$ Resources: gpLog.OperUserId %>"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="<%$ Resources: gpLog.OperUserName %>"
                                                        Width="150">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="<%$ Resources: gpLog.OperTypeName %>"
                                                        Width="150">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="<%$ Resources: gpLog.OperDate %>"
                                                        Width="150">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="<%$ Resources: gpLog.OperNote %>">
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server"
                                                    MoveEditorOnEnter="true">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="15" StoreID="OrderLogStore"
                                                    DisplayInfo="true" />
                                            </BottomBar>
                                            <SaveMask ShowMask="false" />
                                            <LoadMask ShowMask="true" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </Center>
            </ext:BorderLayout>
        </Body>
        <Buttons>
            <ext:Button ID="DraftButton" runat="server" Text="<%$ Resources: DetailWindow.DraftButton.Text %>"
                Icon="Add">
                <Listeners>
                    <Click Handler="
                    if(#{hiddenIsEditting}.getValue()!=''){
                        //Ext.Msg.alert('Error','请稍后');
                    }else{
                    Coolite.AjaxMethods.SaveDraft({
                            success: function() {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Failure', err);
                            }
                        });
                        }" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="DeleteButton" runat="server" Text="<%$ Resources: DetailWindow.DeleteButton.Text %>"
                Icon="Delete">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.DeleteDraft({
                            success: function() {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Failure', err);
                            }
                        });" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="SubmitButton" runat="server" Text="<%$ Resources: DetailWindow.SubmitButton.Text %>"
                Icon="LorryAdd">
                <Listeners>
                    <Click Handler="CheckSubmit();" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="RevokeButton" runat="server" Text="撤销" Icon="Cancel">
                <Listeners>
                    <Click Handler="Coolite.AjaxMethods.DoRevoke({
                            success: function() {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
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
            <BeforeHide Fn="CheckMod" />
        </Listeners>
    </ext:Window>
    <uc1:TransferDialog ID="TransferDialog1" runat="server" />
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
