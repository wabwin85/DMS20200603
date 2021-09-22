<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TransferEditor.aspx.cs"
    Inherits="DMS.Website.Pages.Transfer.TransferEditor" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/TransferDialog.ascx" TagName="TransferDialog" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
        .editable-column
        {
            background: #FFFF99;
        }
        .nonEditable-column
        {
            background: #FFFFFF;
        }
    </style>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
    <script src="../../resources/Calculate.js" type="text/javascript"></script>
    <script language="javascript">
        var MsgList = {
			btnInsert:{
				FailureTitle:"<%=GetLocalResourceObject("Panel1.btnInsert.Alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("Panel1.btnInsert.Alert.Body").ToString()%>"
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
        
        var TransferMsgList = {
            msg1:"<%=GetLocalResourceObject("loadExample.subMenu301").ToString()%>"
        }

        var CheckAddItemsParam = function() {
            if (Ext.getCmp('cbProductLineWin').getValue() == '') {
                Ext.getCmp('AddItemsButton').disable();
            } else {
                Ext.getCmp('AddItemsButton').enable();
            }
            //            alert(String.format('hiddenDealerFromId = {0}\ncbProductLineWin = {1}\nhiddenProductLineId = {2}\nhiddenDealerToId = {3}',
            //            Ext.getCmp('hiddenDealerFromId').getValue(),
            //            Ext.getCmp('cbProductLineWin').getValue(),
            //            Ext.getCmp('hiddenProductLineId').getValue(),
            //            Ext.getCmp('hiddenDealerToId').getValue()));
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
            var txtTransferQty = Ext.getCmp('txtTransferQty');
            var cboToWarehouseId = Ext.getCmp('cboToWarehouseId');
            
            var grid = Ext.getCmp('GridPanel2');
            var hiddenCurrentEdit = Ext.getCmp('hiddenCurrentEdit');
            var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');
            var record = grid.store.getById(hiddenCurrentEdit.getValue());
            //记录当前编辑的行ID
            hiddenIsEditting.setValue(hiddenCurrentEdit.getValue());
            
            if (accMin(record.data.TotalQty,txtTransferQty.getValue()) < 0) {
                //数量错误时，编辑行置为空
                hiddenIsEditting.setValue('');
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckQty.Alert.Body").ToString()%>');
                return false;
            }
            
            if(accMul(txtTransferQty.getValue(),1000000) % accDiv(1,record.data.ConvertFactor).mul(1000000) !=0)
            {
                hiddenIsEditting.setValue('');
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>',  '<%=GetLocalResourceObject("CheckQty.Alert.Body1").ToString()%>'+accDiv(1,record.data.ConvertFactor).toString());
                return false;
            }
            
            if(cboToWarehouseId.getValue() == '')
            {
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
                Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("CheckMod.oldchanged.Confirm.Body").ToString()%>',
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
            var hiddentype = Ext.getCmp('hiddenTransType');

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
                        Ext.Msg.confirm('<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title").ToString()%>', '<%=GetLocalResourceObject("ChangeProductLine.Confirm.Body").ToString()%>',
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

        var CheckSubmit = function() {
            var hiddenIsEditting = Ext.getCmp('hiddenIsEditting');
            if (hiddenIsEditting.getValue() != '') {
                Ext.Msg.alert('<%=GetLocalResourceObject("CheckSubmit.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckSubmit.Alert.Body").ToString()%>');
                return;
            }
            var cbDealerFromWin = Ext.getCmp('cbDealerFromWin');
            var cbProductLineWin = Ext.getCmp('cbProductLineWin');
            var grid = Ext.getCmp('GridPanel2');
            if (cbDealerFromWin.getValue() != '' && cbProductLineWin.getValue() != '' && grid.store.getCount() > 0) {
                if (CheckLotQty()) {
                    Coolite.AjaxMethods.DoSubmit({
                        success: function(rtn) {
                            if (rtn == 'WarehouseNotEqual') {
                                Ext.getCmp('hiddenIsModified').setValue('');
                                Ext.getCmp('GridPanel1').store.reload();
                                Ext.getCmp('DetailWindow').hide();
                            } else if(rtn == "False"){}                            
                            else {
                                Ext.Msg.alert('<%=GetLocalResourceObject("CheckMod.newchanged.Confirm.Title").ToString()%>', ' <%=GetLocalResourceObject("CheckSubmit.success.Alert.Body").ToString()%>');
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
                if (record.data.ToWarehouseId == null) {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("CheckLotQty.Alert.Body1").ToString()%>');
                    return false;

                }
                   if((record.data.QRCodeEdit == "" || record.data.QRCodeEdit == null) && record.data.QRCode == "NoQR")
                   {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '移库必须填写二维码');
                    return false;

                   }
                    if(record.data.QRCodeEdit!=null &&  record.data.QRCodeEdit != '' && record.data.TransferQty>1)
                   {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>', '带二维码的产品数量不得大于一');
                    return false;
                   }
                   if(store.query("QRCodeEdit",record.data.QRCodeEdit).length>1 && record.data.QRCodeEdit != '')
                   {
                     Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>','二维码'+record.data.QRCodeEdit+"出现多次");
                    return false;
                   }
                   if(record.data.QRCodeEdit != null && record.data.QRCodeEdit != '' && store.query("QRCode",record.data.QRCodeEdit).length > 0 
                    && record.data.QRCode=="NoQR" && record.data.QRCodeEdit!='')
                   {
                    Ext.Msg.alert('<%=GetLocalResourceObject("CheckQty.Alert.Title").ToString()%>','二维码'+record.data.QRCodeEdit+"已使用");
                    return false;
                   }
               
            }
           
            return true;
        }


        var TransferPrint = function() {
            return '<img class="imgPrint" ext:qtip="<%=GetLocalResourceObject("TransferPrint.img.ext:qtip").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/printer.png" />';
        }

        var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var test = "1";

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
            var id = record.data['Id'];
            if (t.className == 'imgPrint' && columnId == 'Id') {
                window.open("TransferPrint.aspx?id=" + id, window, "status:false;dialogWidth:800px;dialogHeight:500px");
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
        
           function SelectValue(e) {
            var filterField = 'Name';  //需进行模糊查询的字段
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
        
        function SelectDealerValue(e) {
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
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" AutoLoad="false">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="AttributeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <Load Handler="#{cbProductLineWin}.setValue(#{hiddenProductLineId}.getValue());" />
        </Listeners>
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
        <Listeners>
            <Load Handler="#{cbDealerFrom}.setValue(#{hidInitDealerId}.getValue());" />
        </Listeners>
        <%-- <SortInfo Field="ChineseName" Direction="ASC" />--%>
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
                    <ext:RecordField Name="Type" />
                    <ext:RecordField Name="Description" />
                    <ext:RecordField Name="ReverseTrnId" />
                    <ext:RecordField Name="TransferDate"/>
                    <ext:RecordField Name="TotalQyt" />
                    <ext:RecordField Name="TransferUserName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--        <SortInfo Field="ToDealerDmaId" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="WarehouseStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Name" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--  <BaseParams>
            <ext:Parameter Name="DealerId" Value="#{hiddenTransType}.getValue()=='Transfer'?(#{hiddenDealerFromId}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{hiddenDealerFromId}.getValue()):(#{hiddenDealerToId}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{hiddenDealerToId}.getValue())"
                Mode="Raw" />
                <ext:Parameter Name="DealerWarehouseType" Value="#{hiddenTransType}.getValue()== 'Transfer'?'Normal':'Consignment'"
                Mode="Raw" />
        </BaseParams>--%>
        <Listeners>
            <Load Handler="#{cbWarehouseWin}.setValue(#{cbWarehouseWin}.store.getTotalCount()>0?#{cbWarehouseWin}.store.getAt(0).get('Id'):'');" />
            <LoadException Handler="Ext.Msg.alert('Load Exception', e.message || response.statusText);" />
        </Listeners>
        <%--<SortInfo Field="Name" Direction="ASC" />--%>
    </ext:Store>
    <ext:Hidden ID="hidInitDealerId" runat="server" />
    <ext:Hidden ID="hidInitWarehouseId" runat="server" />
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
                                                        ListWidth="300" Resizable="true" DisplayField="AttributeName" FieldLabel="<%$ Resources: Panel1.FormLayout1.cbProductLine.FieldLabel %>"
                                                        LoadingText="<%$ Resources: Panel1.FormLayout1.cbProductLine.LoadingText %>">
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
                                                    <ext:TextField ID="txtCFN" runat="server" Width="150" FieldLabel="<%$ Resources: resource,Lable_Article_Number  %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtUPN" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout1.txtUPN.FieldLabel %>"
                                                        Hidden="<%$ AppSettings: HiddenUPN  %>" />
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
                                                        Width="220" Editable="true" ListWidth="300" Resizable="true" TypeAhead="False"
                                                        StoreID="DealerStore" ValueField="Id" Mode="Local" DisplayField="ChineseShortName"
                                                        LoadingText="<%$ Resources: Panel1.FormLayout2.cbDealerFrom.LoadingText %>" FieldLabel="<%$ Resources: Panel1.FormLayout2.cbDealerFrom.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout2.cbDealerFrom.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();this.store.clearFilter();" />
                                                            <BeforeQuery Fn="SelectDealerValue" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:DateField ID="txtEndDate" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout2.txtEndDate.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtLotNumber" runat="server" Width="150" FieldLabel="批号/二维码" />
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
                                                    <ext:TextField ID="txtTransferNumber" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout3.txtTransferNumber.FieldLabel %>" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbTransferStatus" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout3.cbTransferStatus.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="TransferStatusStore" ValueField="Key"
                                                        DisplayField="Value" FieldLabel="<%$ Resources: Panel1.FormLayout3.cbTransferStatus.FieldLabel %>"
                                                        LoadingText="<%$ Resources: Panel1.FormLayout3.cbTransferStatus.LoadingText %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout3.cbTransferStatus.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbTransferType" runat="server" EmptyText="选择移库单类型" Width="150"
                                                        Editable="false" TypeAhead="true" FieldLabel="移库单类型" LoadingText="装载中..." StoreID="TransferTypeStore"
                                                        ValueField="Key" DisplayField="Value">
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
                            <ext:Button ID="btnSubmit" Text="历史移库单导出" runat="server" Icon="PageExcel" IDMode="Legacy"
                                        AutoPostBack="true" OnClick="ExportExcel">
                                    </ext:Button>
                            <ext:Button ID="btnImport" runat="server" Text="<%$ Resources: btnImport.Text %>"
                                Icon="Disk" IDMode="Legacy">
                                <Listeners>
                                    <%--<Click Handler="window.parent.loadExample('/Pages/Transfer/TransferEditorImport.aspx','subMenu301',TransferMsgList.msg1);" />--%>
                                    <Click Handler="top.createTab({id: 'subMenu301',title: '导入',url: 'Pages/Transfer/TransferEditorImport.aspx'});" />

                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnInsert" runat="server" Text="普通库移库" Icon="Add" IDMode="Legacy">
                                <AjaxEvents>
                                    <Click Before="#{GridPanel1}.getSelectionModel().clearSelections();" OnEvent="ShowDetails"
                                        Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);"
                                        Success="#{cbDealerFromWin}.clearValue();#{cbDealerFromWin}.setValue(#{hiddenDealerFromId}.getValue());#{cbProductLineWin}.setValue(#{cbProductLineWin}.store.getTotalCount()>0?#{cbProductLineWin}.store.getAt(0).get('Id'):'');#{hiddenProductLineId}.setValue(#{cbProductLineWin}.getValue());CheckAddItemsParam();ClearItems();#{GridPanel2}.clear();#{hiddenIsModified}.setValue('new');#{gpLog}.store.reload();#{PagingToolBar2}.changePage(1);">
                                        <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                        <ExtraParams>
                                            <ext:Parameter Name="TransferId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                            </ext:Parameter>
                                            <ext:Parameter Name="TransType" Value="Transfer" Mode="Value">
                                            </ext:Parameter>
                                        </ExtraParams>
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                            <ext:Button ID="btnTrans" runat="server" Text="寄售库移库" Icon="Add" IDMode="Legacy">
                                <AjaxEvents>
                                    <Click Before="#{GridPanel1}.getSelectionModel().clearSelections();" OnEvent="ShowDetails"
                                        Failure="Ext.MessageBox.alert(MsgList.btnInsert.FailureTitle, MsgList.btnInsert.FailureMsg);"
                                        Success="#{cbDealerFromWin}.clearValue();#{cbDealerFromWin}.setValue(#{hiddenDealerFromId}.getValue());#{cbProductLineWin}.setValue(#{cbProductLineWin}.store.getTotalCount()>0?#{cbProductLineWin}.store.getAt(0).get('Id'):'');#{hiddenProductLineId}.setValue(#{cbProductLineWin}.getValue());CheckAddItemsParam();ClearItems();#{GridPanel2}.clear();#{hiddenIsModified}.setValue('new');#{gpLog}.store.reload();#{PagingToolBar2}.changePage(1);">
                                        <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                        <ExtraParams>
                                            <ext:Parameter Name="TransferId" Value="00000000-0000-0000-0000-000000000000" Mode="Value">
                                            </ext:Parameter>
                                            <ext:Parameter Name="TransType" Value="TransferConsignment" Mode="Value">
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
                                            <ext:Column ColumnID="DealerDmaID" DataIndex="FromDealerDmaId" Header="<%$ Resources: GridPanel1.ColumnModel1.DealerDmaID.Header %>"
                                                Width="220">
                                                <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseShortName'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="TransferNumber" DataIndex="TransferNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.TransferNumber.Header %>"
                                                Width="200">
                                            </ext:Column>
                                            <ext:Column ColumnID="ToDealerDmaId" DataIndex="ToDealerDmaId" Header="<%$ Resources: GridPanel1.ColumnModel1.ToDealerDmaId.Header %>"
                                                Hidden="true">
                                                <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="TotalQyt" DataIndex="TotalQyt" Header="<%$ Resources: GridPanel1.ColumnModel1.TotalQyt.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="TransferDate" DataIndex="TransferDate"  Width="130" Header="<%$ Resources:GridPanel1.ColumnModel1.TransferDate.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="TransferUserName" DataIndex="TransferUserName" Header="<%$ Resources:GridPanel1.ColumnModel1.TransferUserName.Header %>">
                                            </ext:Column>
                                            <ext:Column ColumnID="Type" DataIndex="Type" Header="移库单类型">
                                                <Renderer Handler="return getNameFromStoreById(TransferTypeStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="Status" DataIndex="Status" Header="<%$ Resources:GridPanel1.ColumnModel1.Status.Header %>">
                                                <Renderer Handler="return getNameFromStoreById(TransferStatusStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:CommandColumn Width="60" Header="<%$ Resources:GridPanel1.ColumnModel1.CommandColumn.Header %>">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="<%$ Resources:GridPanel1.ColumnModel1.CommandColumn.ToolTip.Text %>" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                            <ext:Column ColumnID="Id" DataIndex="Id" Header="<%$ Resources:GridPanel1.ColumnModel1.Id.Header %>"
                                                Align="Center">
                                                <Renderer Fn="TransferPrint" />
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <AjaxEvents>
                                        <Command OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.ShowDetails.FailureTitle, MsgList.ShowDetails.FailureMsg);"
                                            Success="#{cbDealerFromWin}.clearValue(); #{cbDealerFromWin}.setValue(#{hiddenDealerFromId}.getValue());#{cbProductLineWin}.clearValue(); #{cbProductLineWin}.setValue(#{hiddenProductLineId}.getValue());ClearItems();#{PagingToolBar2}.changePage(1);#{hiddenIsModified}.setValue('old');#{gpLog}.store.reload();">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}" />
                                            <ExtraParams>
                                                <ext:Parameter Name="TransferId" Value="#{GridPanel1}.getSelectionModel().getSelected().id"
                                                    Mode="Raw">
                                                </ext:Parameter>
                                                <ext:Parameter Name="TransType" Value="#{GridPanel1}.getSelectionModel().getSelected().data.Type"
                                                    Mode="Raw">
                                                </ext:Parameter>
                                            </ExtraParams>
                                        </Command>
                                    </AjaxEvents>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel1.LoadMask.Msg %>" />
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
    <%-- *********************************移库明细窗口*********************************************  --%>
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
                    <ext:RecordField Name="ToWarehouseName" />
                    <ext:RecordField Name="ToWarehouseId" />
                    <ext:RecordField Name="CFNEnglishName" />
                    <ext:RecordField Name="CFNChineseName" />
                    <ext:RecordField Name="ConvertFactor" />
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
    <ext:Store ID="ProductLineWinStore" runat="server" UseIdConfirmation="true" AutoLoad="false">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="AttributeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <Load Handler="#{cbProductLineWin}.setValue(#{hiddenProductLineId}.getValue());" />
        </Listeners>
        <SortInfo Field="Id" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="ReasonStore" runat="server" UseIdConfirmation="false" OnRefreshData="ReasonStore_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="LimitId" />
                    <ext:RecordField Name="ProductLineName" />
                    <ext:RecordField Name="Reason" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hiddenTransferId" runat="server" />
    <ext:Hidden ID="hiddenDealerFromId" runat="server" />
    <ext:Hidden ID="hiddenDealerToId" runat="server" />
    <ext:Hidden ID="hiddenProductLineId" runat="server" />
    <ext:Hidden ID="hiddenDealerToDefaultWarehouseId" runat="server" />
    <ext:Hidden ID="hiddenCurrentEdit" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenIsEditting" runat="server" />
    <ext:Hidden ID="hiddenIsModified" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenTransType" runat="server">
    </ext:Hidden>
     <ext:Hidden ID="hiddenlotNumber" runat="server">
    </ext:Hidden>
     <ext:Hidden ID="hiddenQrCode" runat="server">
    </ext:Hidden>
    <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources:DetailWindow.Title %>"
        Width="1000" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
        <Body>
            <ext:BorderLayout ID="BorderLayout2" runat="server">
                <%-- 表头 --%>
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="50">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbDealerFromWin" runat="server" Width="200" Editable="true" TypeAhead="true"
                                                        Mode="Local" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName"
                                                        FieldLabel="<%$ Resources:DetailWindow.FormLayout4.cbDealerFromWin.FieldLabel %>"
                                                        AllowBlank="false" BlankText="<%$ Resources:DetailWindow.FormLayout4.cbDealerFromWin.BlankText %>"
                                                        EmptyText="<%$ Resources:DetailWindow.FormLayout4.cbDealerFromWin.EmptyText %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:DetailWindow.FormLayout4.cbDealerFromWin.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
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
                                                        StoreID="ProductLineWinStore" ValueField="Id" DisplayField="AttributeName" FieldLabel="<%$ Resources:DetailWindow.FormLayout4.cbProductLineWin.FieldLabel %>"
                                                        AllowBlank="false" BlankText="<%$ Resources:DetailWindow.FormLayout4.cbProductLineWin.BlankText %>"
                                                        EmptyText="<%$ Resources:DetailWindow.FormLayout4.cbProductLineWin.EmptyText %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:DetailWindow.FormLayout4.cbProductLineWin.FieldTrigger.Qtip %>"
                                                                HideTrigger="true" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                            <Select Handler="ChangeProductLine();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Button ID="BtnReason" runat="server" Text="授权产品线无法选择的原因" IDMode="Legacy">
                                                        <AjaxEvents>
                                                            <Click OnEvent="ShowReason">                                                                                                                               
                                                            </Click>
                                                        </AjaxEvents>
                                                    </ext:Button>
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
                                                    <ext:TextField ID="txtNumber" runat="server" FieldLabel="<%$ Resources:DetailWindow.FormLayout5.txtNumber.FieldLabel %>"
                                                        ReadOnly="true" Enabled="false" Width="200" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtDate" runat="server" FieldLabel="<%$ Resources:DetailWindow.FormLayout5.txtDate.FieldLabel %>"
                                                        ReadOnly="true" Enabled="false" Width="200"/>
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
                                                    <ext:TextField ID="txtStatus" runat="server" FieldLabel="<%$ Resources:DetailWindow.FormLayout6.txtStatus.FieldLabel %>"
                                                        ReadOnly="true" Enabled="false" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbWarehouseWin" runat="server" EmptyText="<%$ Resources:DetailWindow.FormLayout6.cbWarehouseWin.EmptyText %>"
                                                        Width="200" Editable="true" TypeAhead="true" StoreID="WarehouseStore" ValueField="Id"
                                                        DisplayField="Name" FieldLabel="<%$ Resources:DetailWindow.FormLayout6.cbWarehouseWin.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:DetailWindow.FormLayout6.cbWarehouseWin.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                            <BeforeQuery Fn="SelectValue" />
                                                        </Listeners>
                                                    </ext:ComboBox>
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
                                BodyStyle="padding: 0px;" AutoScroll="false">
                                <Body>
                                    <ext:FitLayout ID="FitLayout2" runat="server">
                                        <ext:GridPanel ID="GridPanel2" runat="server" Title="<%$ Resources:GridPanel2.Title %>"
                                            StoreID="DetailStore" StripeRows="true" Border="false" Icon="Lorry" ClicksToEdit="1"
                                            EnableHdMenu="false" Header="false" AutoExpandColumn="CFN">
                                            <TopBar>
                                                <ext:Toolbar ID="Toolbar1" runat="server">
                                                    <Items>                                                    
                                                        <ext:Label ID="lblProductSum" runat="server" Text=""  Icon="Sum"/>
                                                        <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                        <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources:GridPanel2.AddItemsButton.Text %>"
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
                                                    <ext:Column ColumnID="FromWarehouseName" DataIndex="WarehouseName" Header="<%$ Resources:GridPanel2.ColumnModel2.FromWarehouseName.Header %>"
                                                        Width="170">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CFNEnglishName" DataIndex="CFNEnglishName" Header="<%$ Resources: CFNEnglishName %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CFNChineseName" DataIndex="CFNChineseName" Header="<%$ Resources:CFNChineseName %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CFN" DataIndex="CFN" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UPN" DataIndex="UPN" Header="<%$ Resources:GridPanel2.ColumnModel2.UPN.Header %>"
                                                        Hidden="<%$ AppSettings: HiddenUPN  %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources:GridPanel2.ColumnModel2.LotNumber.Header %>">
                                                    </ext:Column>
                                                     <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码"
                                                        Width="50">
                                                    </ext:Column>
                                                    
                                                    <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources:GridPanel2.ColumnModel2.ExpiredDate.Header %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UnitOfMeasure" DataIndex="UnitOfMeasure" Header="<%$ Resources:GridPanel2.ColumnModel2.UnitOfMeasure.Header %>"
                                                        Width="50" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="TotalQty" DataIndex="TotalQty" Header="<%$ Resources:GridPanel2.ColumnModel2.TotalQty.Header %>"
                                                        Width="50">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="TransferQty" DataIndex="TransferQty" Header="<%$ Resources:GridPanel2.ColumnModel2.TransferQty.Header %>"
                                                        Align="Right" Width="50">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ToWarehouseId" DataIndex="ToWarehouseId" Header="<%$ Resources:GridPanel2.ColumnModel2.ToWarehouseId.Header %>"
                                                        Align="Left">
                                                        <Renderer Handler="return getNameFromStoreById(WarehouseStore,{Key:'Id',Value:'Name'},value);" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="TransferQtyEdit" DataIndex="TransferQty" Header="<%$ Resources:GridPanel2.ColumnModel2.TransferQtyEdit.Header %>"
                                                        Align="Right" Width="50">
                                                        <Editor>
                                                            <ext:NumberField ID="txtTransferQty" runat="server" AllowBlank="false" AllowDecimals="true"
                                                                SelectOnFocus="true" AllowNegative="false">
                                                            </ext:NumberField>
                                                        </Editor>
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ToWarehouseIdEdit" DataIndex="ToWarehouseId" Header="<%$ Resources:GridPanel2.ColumnModel2.ToWarehouseIdEdit.Header %>"
                                                        Align="Left" Width="170">
                                                        <Renderer Handler="return getNameFromStoreById(WarehouseStore,{Key:'Id',Value:'Name'},value);" />
                                                        <Editor>
                                                            <ext:ComboBox ID="cboToWarehouseId" runat="server" EmptyText="<%$ Resources:GridPanel2.ColumnModel2.ToWarehouseIdEdit.cboToWarehouseId.EmptyText %>"
                                                                TriggerAction="All" ForceSelection="true" StoreID="WarehouseStore" ValueField="Id"
                                                                Mode="Local" Shadow="Drop" ListWidth="300" Resizable="true" DisplayField="Name">
                                                                    <Listeners>
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                    </Listeners>
                                                            </ext:ComboBox>
                                                        </Editor>
                                                    </ext:Column>
                                                    <ext:Column ColumnID="QRCodeEdit" DataIndex="QRCodeEdit" Header="二维码"
                                                        Align="Center" Width="150">
                                                         <Editor>
                                                            <ext:TextField ID="txtQrCode" runat="server" AllowBlank="false" SelectOnFocus="true">
                                                            </ext:TextField>
                                                        </Editor>
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="50" Header="<%$ Resources:GridPanel2.ColumnModel2.CommandColumn.Header %>">
                                                        <Commands>
                                                            <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                                <ToolTip Text="<%$ Resources:GridPanel2.ColumnModel2.CommandColumn.ToolTip.Text %>" />
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
                                            <SaveMask ShowMask="true" Msg="<%$ Resources:GridPanel2.SaveMask.Msg %>" />
                                            <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel2.LoadMask.Msg %>" />
                                            <View>
                                                <ext:GridView ID="GridView1" runat="server">
                                                    <GetRowClass Handler="" />
                                                </ext:GridView>
                                            </View>
                                            <Listeners>
                                                <ValidateEdit Fn="CheckQty" />
                                                <BeforeEdit Handler="#{hiddenCurrentEdit}.setValue(this.getSelectionModel().getSelected().id);
                                                #{cboToWarehouseId}.setValue(this.getSelectionModel().getSelected().data.ToWarehouseId);
                                                #{txtTransferQty}.setValue(this.getSelectionModel().getSelected().data.TransferQty);
                                                #{txtQrCode}.setValue(this.getSelectionModel().getSelected().data.QRCodeEdit);
                                                #{hiddenlotNumber}.setValue(this.getSelectionModel().getSelected().data.LotNumber);
                                                #{hiddenQrCode}.setValue(this.getSelectionModel().getSelected().data.QRCode);
                                                #{txtQrCode}.setValue(this.getSelectionModel().getSelected().data.QRCodeEdit);
                                                if(this.getSelectionModel().getSelected().data.QRCode!='NoQR')
                                                {
                                                 #{txtQrCode}.setDisabled(true);
                                                }
                                                else{
                                                #{txtQrCode}.setDisabled(false);
                                                }
                                                 " />
                                                <AfterEdit Handler="Coolite.AjaxMethods.SaveTransferItem(#{hiddenCurrentEdit}.getValue(),#{cboToWarehouseId}.getValue(),#{txtTransferQty}.getValue(), #{hiddenQrCode}.getValue(),#{txtQrCode}.getValue(),#{hiddenlotNumber}.getValue(),{success:function(){#{hiddenIsEditting}.setValue('');},failure: function(err) {Ext.Msg.alert('Failure', err);}});" />
                                                <Command Handler="Coolite.AjaxMethods.DeleteItem(this.getSelectionModel().getSelected().id,{failure: function(err) {Ext.Msg.alert('Failure', err);}});" />
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
                                                    DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
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
            <ext:Button ID="DraftButton" runat="server" Text="<%$ Resources:DetailWindow.DraftButton.Text %>"
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
            <ext:Button ID="DeleteButton" runat="server" Text="<%$ Resources:DetailWindow.DeleteButton.Text %>"
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
            <ext:Button ID="SubmitButton" runat="server" Text="<%$ Resources:DetailWindow.SubmitButton.Text %>"
                Icon="LorryAdd">
                <Listeners>
                    <Click Handler="CheckSubmit();" />
                </Listeners>
            </ext:Button>
        </Buttons>
        <Listeners>
            <BeforeHide Fn="CheckMod" />
        </Listeners>
    </ext:Window>
    <ext:Window ID="ReasonWindow" runat="server" Icon="Group" Title="<%$ Resources:DetailWindow.Title %>"
        Width="500" Height="300" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
        <Body>
            <ext:BorderLayout ID="BorderLayout3" runat="server">
                
                <Center MarginsSummary="0 5 5 5">
                    <ext:TabPanel ID="TabPanel2" runat="server" ActiveTabIndex="0" Plain="true">
                        <Tabs>
                            <ext:Tab ID="TabReason" runat="server" Title="原因"
                                BodyStyle="padding: 0px;" AutoScroll="false">
                                <Body>
                                    <ext:FitLayout ID="FitLayout4" runat="server">
                                        <ext:GridPanel ID="GridPanel3" runat="server" Title="<%$ Resources:GridPanel2.Title %>"
                                            StoreID="ReasonStore" StripeRows="true" Border="false" Icon="Lorry"
                                            EnableHdMenu="false" Header="false" AutoExpandColumn="ProductLineName">
                                            <ColumnModel ID="ColumnModel4" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="<%$ Resources:DetailWindow.FormLayout4.cbProductLineWin.FieldLabel %>"
                                                        Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Reason" DataIndex="Reason" Header="原因">
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel4" SingleSelect="true" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="15" StoreID="ReasonStore"
                                                    DisplayInfo="true" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" Msg="<%$ Resources:GridPanel2.SaveMask.Msg %>" />
                                            <LoadMask ShowMask="true" Msg="<%$ Resources:GridPanel2.LoadMask.Msg %>" />
                                            <View>
                                                <ext:GridView ID="GridView2" runat="server">
                                                    <GetRowClass Handler="" />
                                                </ext:GridView>
                                            </View>
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </Center>
            </ext:BorderLayout>
        </Body>
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
