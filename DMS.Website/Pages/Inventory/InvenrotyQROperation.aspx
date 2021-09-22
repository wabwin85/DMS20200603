<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvenrotyQROperation.aspx.cs"
    Inherits="DMS.Website.Pages.Inventory.InvenrotyQROperation" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<%@ Register Src="../../Controls/InvenrotyQROperationCfnDailog.ascx" TagName="InvenrotyQROperationCfnDailog"
    TagPrefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"></script>

    <title>二维码收集</title>
    <style type="text/css">
        .RequiredClass {
            font-weight: bold;
            color: Red;
        }

        .list-item {
            font: normal 9px tahoma, arial, helvetica, sans-serif;
            padding: 1px 1px 1px 1px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #bbbbbb;
        }

            .list-item h3 {
                display: block;
                font: inherit;
                font-weight: normal;
                font-size: 12px;
                color: #222;
            }

            .list-item h2 {
                display: block;
                font: inherit;
                font-weight: normal;
                font-size: 12px;
                color: #bbbbbb;
            }

        .editable-column {
            background: #FFFF99;
        }

        .nonEditable-column {
            background: #FFFFFF;
        }

        .fontsize {
            font-size: 5px !important;
        }

        .txtRed {
            color: Red;
            font-size: 13px !important;
        }
    </style>
</head>
<body>

    <script type="text/javascript" language="javascript">
        var RefreshShipmentDetailWindow = function () {
            Ext.getCmp('<%=this.ShipmentGridPanel.ClientID%>').getStore().removeAll();

            Ext.getCmp('<%=this.hidInvType.ClientID%>').setValue('Shipment');
            Ext.getCmp('<%=this.ShipmentGridPanel.ClientID%>').reload();
        }

        var RefreshTransferDetailWindow = function () {
            Ext.getCmp('<%=this.TransferGridPanel.ClientID%>').getStore().removeAll();

            Ext.getCmp('<%=this.hidInvType.ClientID%>').setValue('Transfer');
            Ext.getCmp('<%=this.TransferGridPanel.ClientID%>').reload();
        }
        var RefreshShipmentQRCodeWindows = function () {
            Ext.getCmp('<%=this.QrCodeConvertGridPanel.ClientID%>').getStore().removeAll();
            Ext.getCmp('<%=this.QrCodeConvertGridPanel.ClientID%>').reload();
        }
        var cellClick = function (grid, rowIndex, columnIndex, e) {
            var mainWindow = Ext.getCmp('<%=this.ViewPort1.ClientID%>');

            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

            var id = record.data['Id'];

            if (t.className == 'imgAdd' && columnId == 'Id') {

                var list = "";
                var chklist = document.getElementsByName("chkItem");
                var txtlist = document.getElementsByName("txtItemSet");

                for (var i = 0; i < chklist.length; i++) {

                    if (chklist[i].value.split("@")[1].toLocaleUpperCase() == id.toLocaleUpperCase()) {
                        list = chklist[i].value + '@' + txtlist[i].value + ',';
                    }
                }

                if (list.length > 0) {
                    Coolite.AjaxMethods.AddItem(list,
                                            {
                                                success: function () {

                                                },
                                                failure: function (err) {
                                                    Ext.Msg.alert('Error', err);
                                                }
                                            });
                }
            } else if (t.className == 'imgDelete' && columnId == 'Id') {

                Ext.Msg.confirm('Message', '确定删除?',
                function (e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.DeleteItem(id,
                                            {
                                                success: function () {
                                                    grid.reload();
                                                },
                                                failure: function (err) {
                                                    Ext.Msg.alert('Error', err);
                                                }
                                            });
                    }
                });
            }
        }

        var addShipmentCfn = function (grid) {


            var mainWindow = Ext.getCmp('<%=this.ViewPort1.ClientID%>');
            var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');

            var list = GetSelectedItemSet();

            if (list == "false") {
                Ext.Msg.alert('Error', '上报数量小于等于0的不允许添加');
                return false;
            }

            if (list.indexOf('null') >= 0) {
                Ext.Msg.alert('Error', '无库存的二维码不允许添加');
                return false;
            }

            if (list.length > 0) {
                Ext.Msg.confirm('Message', '确定添加?',
                function (e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.AddItem(list, 'Shipment',
                        {
                            success: function () {
                                if (rtnVal.getValue() == "Success") {
                                    Ext.getCmp('<%=this.ShipmentWindows.ClientID%>').show();
                                    RefreshShipmentDetailWindow();
                                    ShowShipmentWindow();
                                    Ext.getCmp('<%=this.gpAttachment.ClientID%>').store.reload();

                                } else {
                                    Ext.Msg.alert('Error', rtnMsg.getValue());
                                }

                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);

                            }
                        }
                        );
                    } else {

                    }
                });
            } else {
                Ext.getCmp('<%=this.ShipmentWindows.ClientID%>').show();
                RefreshShipmentDetailWindow();
                ShowShipmentWindow();
            }

        }

        var ShowShipmentWindow = function () {
            Coolite.AjaxMethods.ShowShipmentWindow(
                        {
                            success: function () {
                                Ext.getCmp('ShipmentWindows').show();
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                        );
        }

        var CheckShipmentQty = function () {

            var txtShipmentQty = Ext.getCmp('nfShipmentQty');
            var grid = Ext.getCmp('ShipmentGridPanel');
            var hidEditItemId = Ext.getCmp('hidEditItemId');
            var hidIsEditting = Ext.getCmp('hidIsEditting');
            var record = grid.store.getById(hidEditItemId.getValue());
            //记录当前编辑的行ID
            hidIsEditting.setValue(hidEditItemId.getValue());

            if (accMin(record.data.LotQty, txtShipmentQty.getValue()) < 0) {
                //数量错误时，编辑行置为空
                hidIsEditting.setValue('');
                Ext.Msg.alert('Error', '销售数量不能大于库存数量');
                return false;
            }
            if (txtShipmentQty.getValue() == 0) {
                //数量错误时，编辑行置为空
                hidIsEditting.setValue('');
                Ext.Msg.alert('Error', '销售数量不能为0');
                return false;
            }

            //寄售判断小数位
            if (accMul(txtShipmentQty.getValue(), 1000000) % accDiv(1, record.data.ConvertFactor).mul(1000000) != 0) {
                //数量错误时，编辑行置为空
                hidIsEditting.setValue('');
                Ext.Msg.alert('Error', '最小单位是' + accDiv(1, record.data.ConvertFactor).toString());
                return false;
            }

            return true;
        }
        //触发函数
        function downloadfile(url) {
            var iframe = document.createElement("iframe");
            iframe.src = url;
            iframe.style.display = "none";
            document.body.appendChild(iframe);
        }
        //选择用量日期的时候，需要重置销售医院
        var ChangeShipmentDate = function () {

            Ext.getCmp('cbWinShipmentHospital').clearValue();

            Coolite.AjaxMethods.ChangeShipmentDate({
                success: function () {
                },
                failure: function (err) {
                    Ext.Msg.alert('Error', err);
                }
            });
        }

        var ChangeShipmentProductLine = function () {
            Coolite.AjaxMethods.ShipmentProductLineChange(
                {
                    success: function () {
                        Ext.getCmp('dfWinShipmentDate').setValue('');
                        Ext.getCmp('cbWinShipmentHospital').setValue('');
                    },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                    }
                }
            );
        }

        var ShipmentClear = function () {
            var errMsg = "";
            var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
            var store = Ext.getCmp('ShipmentGridPanel').store;
            var shipmentWindow = Ext.getCmp('<%=this.ShipmentWindows.ClientID%>');

            var cbProductLineWin = Ext.getCmp('cbWinShipmentProductLine');
            var cbHospitalWin = Ext.getCmp('cbWinShipmentHospital');
            var txtShipmentDateWin = Ext.getCmp('dfWinShipmentDate');

            Ext.Msg.confirm('Message', '清空确认?',
                    function (e) {
                        if (e == 'yes') {
                            Coolite.AjaxMethods.DeleteOperationByType('Shipment',
                                {
                                    success: function () {
                                        Ext.Msg.alert('信息', '清空成功！');
                                        store.reload();
                                    },
                                    failure: function (err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                            );
                        }
                    }
                );
        }

        var ShipmentSubmit = function () {
            var errMsg = "";
            var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
            var isForm1Valid = Ext.getCmp('<%=this.FormPanel1.ClientID%>').getForm().isValid();
            var store = Ext.getCmp('ShipmentGridPanel').store;
            var shipmentWindow = Ext.getCmp('<%=this.ShipmentWindows.ClientID%>');

            var cbProductLineWin = Ext.getCmp('cbWinShipmentProductLine');
            var cbHospitalWin = Ext.getCmp('cbWinShipmentHospital');
            var txtShipmentDateWin = Ext.getCmp('dfWinShipmentDate');
            var attstore = Ext.getCmp('gpAttachment').store;
            if (cbProductLineWin.getValue() == '' || cbHospitalWin.getValue() == '' || txtShipmentDateWin.getValue() == '') {

                Ext.Msg.alert('错误', '销售单信息不完整！');
                return false;
            }

            if (store.getCount() == 0) {
                Ext.Msg.alert('错误', '销售产品没有数据');
                return false;
            }            

            var fristWarehouseType = "";
            for (var i = 0; i < store.getCount() ; i++) {
                var record = store.getAt(i);
                if (record.data.Qty == 0) {
                    Ext.Msg.alert('错误', '销售数量不能为0');
                    return false;
                }
                if (record.data.Qty > record.data.LotQty) {
                    Ext.Msg.alert('错误', '销售数量不能大于库存数量');
                    return false;
                }
                if (accMul(record.data.Qty, 1000000) % accDiv(1, record.data.ConvertFactor).mul(1000000) != 0) {
                    Ext.Msg.alert('Error', '最小单位是' + accDiv(1, factor).toString());
                }
                //                if (record.data.ShipmentPrice == 0 || record.data.ShipmentPrice == '' || record.data.ShipmentPrice == null) {
                //                    Ext.Msg.alert('错误', '销售单价不能为0');
                //                    return false;
                //                }

                if (i == 0) { fristWarehouseType = record.data.WarehouseType; }
                if ((fristWarehouseType == "Consignment" || fristWarehouseType == "LP_Consignment" || fristWarehouseType == "Borrow") && i != 0) {
                    if (record.data.WarehouseType != "Consignment" && record.data.WarehouseType != "LP_Consignment" && record.data.WarehouseType != "Borrow") {
                        Ext.Msg.alert('错误', '寄售库存不能和普通库存同时上报销量！');
                        return false;
                    }
                }
                if ((fristWarehouseType != "Consignment" && fristWarehouseType != "LP_Consignment" && fristWarehouseType != "Borrow") && i != 0) {
                    if (record.data.WarehouseType == "Consignment" || record.data.WarehouseType == "LP_Consignment" || record.data.WarehouseType == "Borrow") {
                        Ext.Msg.alert('错误', '寄售库存不能和普通库存同时上报销量！');
                        return false;
                    }
                }

                if (record.data.ExpiredDate < txtShipmentDateWin.getValue()) {
                    Ext.Msg.alert('错误', '不能上报过期销量');
                    return false;
                }
            }

            Ext.Msg.confirm('Message', '提交确认?',
                    function (e) {
                        if (e == 'yes') {
                            Coolite.AjaxMethods.SubmitShipment(
                                {
                                    success: function () {
                                        if (rtnVal.getValue() == 'Success') {
                                            Ext.Msg.alert('信息', '已将数据生成为已完成状态的销售单');
                                            shipmentWindow.hide(null);
                                            Ext.getCmp('<%=this.PagingToolBar1.ClientID%>').changePage(1);

                                        } else {
                                            Ext.Msg.alert('错误', rtnMsg.getValue());
                                        }
                                    },
                                    failure: function (err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                            );
                            }
                    }
                );
        }
                    function beforeRowSelect(s, n, k, r) {
                        if (r.get("ShippedQty") < 0)
                            return false;
                    }
                    var ShowTransferWindow = function () {
                        Coolite.AjaxMethods.ShowTransferWindow(
                                    {
                                        success: function () {
                                            Ext.getCmp('TransferWindows').show();
                                        },
                                        failure: function (err) {
                                            Ext.Msg.alert('Error', err);
                                        }
                                    }
                                    );
                    }

                    var ChangeTransferProductLine = function () {

                        Coolite.AjaxMethods.TransferProductLineChange(
                                        {
                                            success: function () {

                                            },
                                            failure: function (err) {
                                                Ext.Msg.alert('Error', err);
                                            }
                                        }
                                    );
                    }

                    var ChangeTransferType = function () {
                        var cbWinTransferWarehouse = Ext.getCmp('cbWinTransferWarehouse');



                        cbWinTransferWarehouse.setValue('');
                        cbWinTransferWarehouse.store.removeAll();
                        cbWinTransferWarehouse.store.reload();

                        RefreshTransferDetailWindow();
                    }


                    var addTransferCfn = function (grid) {

                        var mainWindow = Ext.getCmp('<%=this.ViewPort1.ClientID%>');
                        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
                        var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');

                        var list = GetSelectedItemSet();
                        if (list == "false") {
                            Ext.Msg.alert('Error', '上报数量小于等于0的不允许添加');
                            return false;
                        }
                        if (list.indexOf('null') >= 0) {
                            Ext.Msg.alert('Error', '无库存的二维码不允许添加');
                            return false;
                        }
                        if (list.length > 0) {
                            Ext.Msg.confirm('Message', '确定添加?',
                                            function (e) {
                                                if (e == 'yes') {
                                                    Coolite.AjaxMethods.AddItem(list, 'Transfer',
                                                    {
                                                        success: function () {
                                                            if (rtnVal.getValue() == "Success") {
                                                                Ext.getCmp('<%=this.TransferWindows.ClientID%>').show();
                                                                RefreshTransferDetailWindow();
                                                                ShowTransferWindow();
                                                            } else {
                                                                Ext.Msg.alert('Error', rtnMsg.getValue());
                                                            }

                                                        },
                                                        failure: function (err) {
                                                            Ext.Msg.alert('Error', err);

                                                        }
                                                    }
                                        );
                                                } else {

                                                }
                                            });
                                        } else {
                                            Ext.getCmp('<%=this.TransferWindows.ClientID%>').show();
                            RefreshTransferDetailWindow();
                            ShowTransferWindow();
                        }

                    }

                    var CheckTransferQty = function () {

                        var txtTransferQty = Ext.getCmp('nfTransferQty');
                        var grid = Ext.getCmp('TransferGridPanel');
                        var hidEditItemId = Ext.getCmp('hidEditItemId');
                        var hidIsEditting = Ext.getCmp('hidIsEditting');
                        var record = grid.store.getById(hidEditItemId.getValue());
                        //记录当前编辑的行ID
                        hidIsEditting.setValue(hidEditItemId.getValue());

                        if (accMin(record.data.LotQty, txtTransferQty.getValue()) < 0) {
                            //数量错误时，编辑行置为空
                            hidIsEditting.setValue('');
                            Ext.Msg.alert('Error', '移库数量不能大于库存数量');
                            return false;
                        }
                        if (txtTransferQty.getValue() == 0) {
                            //数量错误时，编辑行置为空
                            hidIsEditting.setValue('');
                            Ext.Msg.alert('Error', '移库数量不能为0');
                            return false;
                        }

                        //寄售判断小数位
                        if (accMul(txtTransferQty.getValue(), 1000000) % accDiv(1, record.data.ConvertFactor).mul(1000000) != 0) {
                            //数量错误时，编辑行置为空
                            hidIsEditting.setValue('');
                            Ext.Msg.alert('Error', '最小单位是' + accDiv(1, record.data.ConvertFactor).toString());
                            return false;
                        }

                        return true;
                    }

                    var UpdateToWarehouse = function (value) {
                        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
                        var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
                        var grid = Ext.getCmp('<%=this.TransferGridPanel.ClientID%>');
                        var list = grid.store;

                        if (value == null || value == '') {
                            return;
                        }
                        if (list.getTotalCount() > 0) {
                            Ext.Msg.confirm('Message', '确定更新默认仓库?',
                                            function (e) {
                                                if (e == 'yes') {
                                                    Coolite.AjaxMethods.UpdateToWarehouse(value,
                                                    {
                                                        success: function () {
                                                            if (rtnVal.getValue() == "Success") {
                                                                RefreshTransferDetailWindow();
                                                            } else {
                                                                Ext.Msg.alert('Error', rtnMsg.getValue());
                                                            }

                                                        },
                                                        failure: function (err) {
                                                            Ext.Msg.alert('Error', err);

                                                        }
                                                    });
                                                } else {

                                                }
                                            }
                                        );
                        } else {

                        }
                    }

                    var TransferClear = function () {
                        var errMsg = "";
                        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
                        var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
                        var isForm1Valid = Ext.getCmp('<%=this.FormPanel2.ClientID%>').getForm().isValid();
                        var store = Ext.getCmp('TransferGridPanel').store;
                        var window = Ext.getCmp('<%=this.TransferWindows.ClientID%>');

                        var cbProductLineWin = Ext.getCmp('cbWinTransferProductLine');
                        var cbTransferType = Ext.getCmp('cbWinTransferType');

                        Ext.Msg.confirm('Message', '清空确认?',
                                function (e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.DeleteOperationByType('Transfer',
                                            {
                                                success: function () {
                                                    Ext.Msg.alert('信息', '清空成功！');
                                                    store.reload();
                                                },
                                                failure: function (err) {
                                                    Ext.Msg.alert('Error', err);
                                                }
                                            }
                                        );
                                    }
                                }
                            );
                    }

                    var TransferSubmit = function () {
                        var errMsg = "";
                        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
                        var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
                        var isForm1Valid = Ext.getCmp('<%=this.FormPanel2.ClientID%>').getForm().isValid();
                        var store = Ext.getCmp('TransferGridPanel').store;
                        var window = Ext.getCmp('<%=this.TransferWindows.ClientID%>');

                        var cbProductLineWin = Ext.getCmp('cbWinTransferProductLine');
                        var cbTransferType = Ext.getCmp('cbWinTransferType');

                        if (cbProductLineWin.getValue() == '' || cbTransferType.getValue() == '') {

                            Ext.Msg.alert('错误', '移库单信息不完整！');
                            return false;
                        }

                        if (store.getCount() == 0) {
                            Ext.Msg.alert('错误', '移库产品没有数据');
                            return false;
                        }

                        for (var i = 0; i < store.getCount() ; i++) {
                            var record = store.getAt(i);
                            if (record.data.Qty == 0) {
                                Ext.Msg.alert('错误', '移库数量不能为0');
                                return false;
                            }
                            if (record.data.Qty > record.data.LotQty) {
                                Ext.Msg.alert('错误', '移库数量不能大于库存数量');
                                return false;
                            }
                            if (accMul(record.data.Qty, 1000000) % accDiv(1, record.data.ConvertFactor).mul(1000000) != 0) {
                                Ext.Msg.alert('Error', '最小单位是' + accDiv(1, factor).toString());
                            }
                            if (record.data.ToWarehouseId == '' || record.data.ToWarehouseId == null) {
                                Ext.Msg.alert('错误', '必须选择移入仓库');
                                return false;
                            }
                            if (record.data.WarehouseId.toUpperCase() == record.data.ToWarehouseId.toUpperCase()) {
                                Ext.Msg.alert('错误', '移出仓库与移入仓库必须不同！');
                                return false;
                            }
                            if (record.data.WarehouseType == 'Borrow' || record.data.WarehouseType == 'Consignment' || record.data.WarehouseType == 'LP_Consignment'
                                || record.data.ToWarehouseType == 'Borrow' || record.data.ToWarehouseType == 'Consignment' || record.data.ToWarehouseType == 'LP_Consignment'
                                ) {
                                Ext.Msg.alert('错误', '寄售/借货仓位不能做移库操作！');
                                return false;
                            }
                        }

                        Ext.Msg.confirm('Message', '提交确认?',
                                function (e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.SubmitTransfer(
                                            {
                                                success: function () {
                                                    if (rtnVal.getValue() == 'Success') {
                                                        Ext.Msg.alert('信息', '已将数据生成为完成状态的移库单');
                                                        window.hide(null);
                                                        Ext.getCmp('<%=this.PagingToolBar1.ClientID%>').changePage(1);

                                        } else {
                                            Ext.Msg.alert('错误', rtnMsg.getValue());
                                        }
                                    },
                                    failure: function (err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                            );
                            }
                    }
                );
                    }



                    var delScanDate = function () {
                        var mainWindow = Ext.getCmp('<%=this.ViewPort1.ClientID%>');
                        var gridToolBar = Ext.getCmp('<%=this.PagingToolBar1.ClientID%>');
                        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
                        var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');

                        var list = GetSelectedItemSet();

                        if (list.length > 0) {
                            Ext.Msg.confirm('Message', '确定是否删除?',
                                function (e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.DeleteItems(list,
                                        {
                                            success: function () {
                                                if (rtnVal.getValue() == "Success") {
                                                    gridToolBar.changePage(1);
                                                } else {
                                                    Ext.Msg.alert('Error', rtnMsg.getValue());
                                                }

                                            },
                                            failure: function (err) {
                                                Ext.Msg.alert('Error', err);

                                            }
                                        }
                                        );
                                    } else {

                                    }
                                });
                        } else {
                            Ext.Msg.alert('Error', '请选择需要删除的记录');
                        }
                    }
                    ///lijie add
                    var addInvnrotyQRCode = function (grid) {
                        var mainWindow = Ext.getCmp('<%=this.ViewPort1.ClientID%>');
                        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
                        var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
                        var store = grid.store;
                        var list = "";
                        var chklist = document.getElementsByName("chkItem");
                        var count = 0;
                        var whmtype = '';
                        for (var i = 0; i < chklist.length; i++) {
                            if (chklist[i].checked) {
                                var record = store.getAt(i);
                                whmtype = record.data.WarehouseType;
                                list += chklist[i].value;
                                count = count + 1;
                            }
                        }

                        if (count != 1) {
                            Ext.Msg.alert('Error', '必须且只能选择一条进行替换');
                            return false;
                        }

                        if (list.length > 0) {
                            Ext.Msg.confirm('Message', '确定替换?',
                            function (e) {
                                if (e == 'yes') {
                                    Coolite.AjaxMethods.ShowInventoryAdjustQRCodeWindows(list, whmtype,
                                    {
                                        success: function () {
                                            if (rtnVal.getValue() == "Success") {
                                                Ext.getCmp('<%=this.GridPanel2.ClientID%>').getStore().removeAll();
                                                Ext.getCmp('<%=this.InvenrotyWindow.ClientID%>').show();


                                            } else {
                                                Ext.Msg.alert('Error', rtnMsg.getValue());
                                            }

                                        },
                                        failure: function (err) {
                                            Ext.Msg.alert('Error', err);

                                        }
                                    }
                        );
                                } else {

                                }
                            });
                        }
                    }

                    var addShipmentQRCode = function (grid) {
                        var mainWindow = Ext.getCmp('<%=this.ViewPort1.ClientID%>');
                        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
                        var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
                        var list = "";
                        var chklist = document.getElementsByName("chkItem");
                        var count = 0;
                        for (var i = 0; i < chklist.length; i++) {
                            if (chklist[i].checked) {

                                list += chklist[i].value;
                                count = count + 1;
                            }
                        }

                        if (count != 1) {
                            Ext.Msg.alert('Error', '必须且只能选择一条进行替换');
                            return false;
                        }
                        if (list.length > 0) {
                            Ext.Msg.confirm('Message', '确定替换?',
                            function (e) {
                                if (e == 'yes') {
                                    Coolite.AjaxMethods.ShowShipmentQRCodeWindows(list,
                                    {
                                        success: function () {
                                            if (rtnVal.getValue() == "Success") {
                                                Ext.getCmp('<%=this.ShipmentQRCodeWindows.ClientID%>').show();
                                                RefreshShipmentQRCodeWindows();

                                            } else {
                                                Ext.Msg.alert('Error', rtnMsg.getValue());
                                            }

                                        },
                                        failure: function (err) {
                                            Ext.Msg.alert('Error', err);

                                        }
                                    }
                        );
                                } else {

                                }
                            });
                        }
                    }


    </script>

    <script type="text/javascript" language="javascript">
        Ext.apply(Ext.util.Format, { number: function (v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function (format) { return function (v) { return Ext.util.Format.number(v, format); }; } });

        var RenderCheckBoxSet = function (value, cellmeta, record) {
            //            if (record.get("LotQty") == '' || record.get("LotQty") == null) {
            //                return "";
            //            }
            //            else {
            return "<input type='checkbox' name='chkItem' value='" + value + '@' + record.data.Id + "'>";
            //                return "<input type='checkbox' name='chkItem' value='" + value + '@' + record.data.Id + '@' + record.data.WarehouseType + "'>";
            //            }
        }
        var QrCodeRenderCheckBoxSet = function (value, cellmeta, record) {
            if (record.get("ShippedQty") == '' || record.get("ShippedQty") <= 0 || record.get("ShippedQty") == null) {
                return "";
            }
            else {
                return "<input type='checkbox' name='QrCodechkItem' value='" + record.data.Id + "'>";
            }
        }
        function CheckAll() {
            var chklist = document.getElementsByName("chkItem");
            var isChecked = document.getElementById("chkAllItem").checked;

            for (var i = 0; i < chklist.length; i++) {
                chklist[i].checked = isChecked;
            }
        }
        function QrCodeCheckAll() {

            var QrCodechklist = document.getElementsByName("QrCodechkItem");

            var QrCodeisChecked = document.getElementById("QrCodekAllItem").checked;

            for (var i = 0; i < QrCodechklist.length; i++) {

                QrCodechklist[i].checked = QrCodeisChecked;
            }
        }
        var prepareColumn = function (grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);

            if (record.data.LotQty == 0 || record.data.LotQty == '0' || record.data.LotQty == '' || record.data.LotQty == null) {
                firstButton.setDisabled(true);
                firstButton.setTooltip('Disabled');
            }
        }

        var orderModify = function (value, cellmeta, record, rowIndex, columnIndex, store) {

            if (record.data.LotQty == 0 || record.data.LotQty == '0' || record.data.LotQty == '' || record.data.LotQty == null) {
                return '';
            } else {
                return '<img class="imgAdd" ext:qtip="添加" style="cursor:pointer;" src="../../resources/images/icons/note_add.png" />';
            }
        }

        var orderDelete = function (value, cellmeta, record, rowIndex, columnIndex, store) {

            return '<img class="imgDelete" ext:qtip="删除" style="cursor:pointer;" src="../../resources/images/delitem.gif" />';
        }

        var RenderTextBoxSet = function (value, cellmeta, record) {
            //            if (record.get("LotQty") == '' || record.get("LotQty") == null) {

            //                return "";
            //            }
            //            if (record.get("LotQty") == 0 || record.get("LotQty") == '0' || record.get("LotQty") == '' || record.get("LotQty") == null) {
            //                return "<input type='text' name='txtItemSet' value='0' style='width:50px;background-color:yellow;border:#000000 1px solid;text-align:center;' onkeyup='clearNoNum(this);' onblur='checkQty(" + value + ",this.value," + record.data.ConvertFactor + ");' />";
            //            }
            //            else {

            return "<input type='text' name='txtItemSet' value='" + value + "' style='width:50px;background-color:yellow;border:#000000 1px solid;text-align:center;' onkeyup='clearNoNum(this);' onblur='checkQty(" + value + ",this.value," + record.data.ConvertFactor + ");' />";
            //            }
        }

        var checkQty = function (totalQty, qty, factor) {

            if (totalQty < qty) {
                Ext.Msg.alert('Error', '上报数量不能大于库存数量');
            }
            if (accMul(qty, 1000000) % accDiv(1, factor).mul(1000000) != 0) {
                Ext.Msg.alert('Error', '最小单位是' + accDiv(1, factor).toString());
            }
        }

        function GetSelectedItemSet() {
            var list = "";
            var bl = "true";
            var chklist = document.getElementsByName("chkItem");
            var txtlist = document.getElementsByName("txtItemSet");

            for (var i = 0; i < chklist.length; i++) {
                if (chklist[i].checked) {
                    if (txtlist[i].value == '0' || txtlist[i].value < 0 || txtlist[i].value == null || txtlist[i].value == '') {
                        bl = "false";
                    }

                    list += chklist[i].value + '@' + txtlist[i].value + ',';
                }
            }

            if (bl == "true") {
                return list;
            }
            return bl;
        }

        function clearNoNum(obj) {
            //先把非数字的都替换掉，除了数字和.
            obj.value = obj.value.replace(/[^\d.]/g, "");
            //必须保证第一个为数字而不是.
            obj.value = obj.value.replace(/^\./g, "");
            //保证只有出现一个.而没有多个.
            obj.value = obj.value.replace(/\.{2,}/g, ".");
            //保证.只出现一次，而不能出现两次以上
            obj.value = obj.value.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");
        }

        var SetCellCssEditable = function (v, m) {
            m.css = "editable-column";
            return v;
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
                    combo.store.filterBy(function (record, id) {
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

        var UpdateShipmentItem = function (upn) {

            var shipmentQty = Ext.getCmp('<%=this.nfShipmentQty.ClientID%>');
            var shipmentPrice = Ext.getCmp('<%=this.nfShipmentPrice.ClientID%>');

            var hidEditItemId = Ext.getCmp('<%=this.hidEditItemId.ClientID%>');
            var DetailWindow = Ext.getCmp('<%=this.ShipmentWindows.ClientID%>');
            var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
            Coolite.AjaxMethods.UpdateShipmentItem(shipmentQty.getValue(), shipmentPrice.getValue(),
                {
                    success: function () {
                        hidEditItemId.setValue('');

                        RefreshShipmentDetailWindow();
                        SetWinBtnDisabled(DetailWindow, false);
                    },
                    failure: function (err) {
                        hidEditItemId.setValue('');
                        Ext.Msg.alert('Error', err);
                        SetWinBtnDisabled(DetailWindow, false);
                    }
                }
            );
        }

        var UpdateTransferItem = function (upn) {

            var transferQty = Ext.getCmp('<%=this.nfTransferQty.ClientID%>');
            var cbToWarehouseId = Ext.getCmp('<%=this.cbToWarehouseId.ClientID%>');
            var hidEditItemId = Ext.getCmp('<%=this.hidEditItemId.ClientID%>');
            var DetailWindow = Ext.getCmp('<%=this.TransferWindows.ClientID%>');

            var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
            Coolite.AjaxMethods.UpdateTransferItem(transferQty.getValue(), cbToWarehouseId.getValue(),
                {
                    success: function () {
                        hidEditItemId.setValue('');

                        RefreshTransferDetailWindow();
                        SetWinBtnDisabled(DetailWindow, false);
                    },
                    failure: function (err) {
                        hidEditItemId.setValue('');
                        Ext.Msg.alert('Error', err);
                        SetWinBtnDisabled(DetailWindow, false);
                    }
                }
            );
        }
        var BtnNewCfn = function (type) {
            var DealerId = Ext.getCmp('<%=this.hidDealerId.ClientID%>');
            var Upn = Ext.getCmp('<%=this.hidUPN.ClientID%>');
            var LotNumber = Ext.getCmp('<%=this.hidLotNumber.ClientID%>');
            var LotId = Ext.getCmp('<%=this.hidLotId.ClientID%>');
            var QrCode = Ext.getCmp('<%=this.hidQrCode.ClientID%>');
            var NewQrCode = Ext.getCmp('<%=this.tfWinQrCodeConvertNewQrCode.ClientID%>');

            Coolite.AjaxMethods.InvenrotyQROperationCfnDailog.Show(DealerId.getValue(), LotNumber.getValue(), Upn.getValue(), QrCode.getValue(), type, {

                success: function () {
                    LotId.setValue('');
                    NewQrCode.setValue('');
                },
                failure: function (err) {

                    Ext.Msg.alert('Error', err);

                }
            })
        }
        var AddQrCode = function (LotId, QrCode, WhmId) {
            Ext.getCmp('<%=this.hidLotId.ClientID%>').setValue(LotId);
            Ext.getCmp('<%=this.tfWinQrCodeConvertNewQrCode.ClientID%>').setValue(QrCode);
            Ext.getCmp('<%=this.hidWhmId.ClientID%>').setValue(WhmId);

        }
        var Addstock = function (LotId, QrCode, WhmId) {
            Ext.getCmp('<%=this.hidLotId.ClientID%>').setValue(LotId);
            Ext.getCmp('<%=this.tfWinStockOutQrCode.ClientID%>').setValue(QrCode);
            Ext.getCmp('<%=this.hidWhmId.ClientID%>').setValue(WhmId);
            Ext.getCmp('<%=this.GridPanel2.ClientID%>').reload();

        }
        //aa
        var StockQrCodeConvertCheckedSumbit = function () {
            var store = Ext.getCmp('GridPanel2').store;
            var stockOutQrCdoe = Ext.getCmp('tfWinStockOutQrCode');
            if (stockOutQrCdoe.getValue() == '') {
                Ext.Msg.alert('Error', '错误，请选择要出库的二维码');
                return false;
            }
            var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
            var isForm1Valid = Ext.getCmp('<%=this.FormPanel4.ClientID%>').getForm().isValid();
            rtnVal.setValue('');
            rtnMsg.setValue('');

            if (!isForm1Valid) {
                Ext.Msg.alert('Error', '错误，请填写表头信息');
                return false;
            }
            if (store.getCount() == 0) {
                Ext.Msg.alert('Error', '错误，没有数据');
                return false;
            }
            Ext.Msg.confirm('Message', '确定替换?',
            function (e) {
                if (e == 'yes') {
                    Coolite.AjaxMethods.StockQrCodeConvertCheckedSumbit({
                        success: function () {
                            if (rtnVal.getValue() == 'Success') {
                                Coolite.AjaxMethods.StockSumbit({
                                    success: function () {
                                        if (rtnVal.getValue() == 'Success') {
                                            Ext.Msg.alert('Error', '二维码替换成功');
                                            Ext.getCmp('<%=this.InvenrotyWindow.ClientID%>').hide(null);

                                        }
                                        else {
                                            Ext.Msg.alert('Error', rtnMsg.getValue());
                                        }
                                    },
                                    failure: function (err) {

                                        Ext.Msg.alert('Error', err);

                                    }

                                })
                            }
                            else {
                                Ext.Msg.alert('Error', rtnMsg.getValue());

                            }
                        },
                        failure: function (err) {

                            Ext.Msg.alert('Error', err);

                        }
                    });
                }
            })

        }
        var QrCodeConvertCheckedSumbit = function (grid) {
            var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
            var store = Ext.getCmp('QrCodeConvertGridPanel').store;

            rtnVal.setValue('');
            rtnMsg.setValue('');
            var list = '';
            //            if (store.getCount() == 0) {
            //                Ext.MessageBox.alert('Message', ' ');
            //            }
            var chklist = document.getElementsByName("QrCodechkItem");
            var txtlist = document.getElementsByName("QrCodekAllItem");

            for (var i = 0; i < chklist.length; i++) {
                if (chklist[i].checked) {
                    list = list + chklist[i].value + ',';
                }
            }

            if (list != '') {
                Ext.Msg.confirm('Message', '确定替换?',
                function (e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.QrCodeConvertChecked(list,
                                            {
                                                success: function () {
                                                    if (rtnVal.getValue() == 'Success') {
                                                        Ext.Msg.alert('Success', '二维码替换成功!');
                                                        Ext.getCmp('<%=this.tfWinQrCodeConvertNewQrCode.ClientID%>').setValue('');
                                                        Ext.getCmp('<%=this.ShipmentQRCodeWindows.ClientID%>').hide(null);

                                                    }
                                                    else {
                                                        Ext.Msg.alert('Error', rtnMsg.getValue());

                                                    }
                                                },
                                                failure: function (err) {

                                                    Ext.Msg.alert('Error', err);

                                                }

                                            });

                                        }
                });

                                } else {
                                    Ext.MessageBox.alert('Message', '请选择需要替换的销售数据');
                                }
        }
                            //屏蔽刷新Store时的提示
                            var StoreCommitAll = function (store) {
                                for (var i = 0; i < store.getCount() ; i++) {
                                    var record = store.getAt(i);
                                    if (record.dirty) {
                                        record.commit();
                                    }
                                }
                            }

                            var ShowEditingMask = function (type) {
                                var win;
                                if (type == 'Shipment') {
                                    win = Ext.getCmp('<%=this.ShipmentWindows.ClientID%>');
                                }
                                else if (type == 'Transfer') {
                                    win = Ext.getCmp('<%=this.TransferWindows.ClientID%>');
                                }

                                win.body.mask('执行中...', 'x-mask-loading');
                                SetWinBtnDisabled(win, true);
                            }

                        var SetWinBtnDisabled = function (win, disabled) {
                            for (var i = 0; i < win.buttons.length; i++) {
                                win.buttons[i].setDisabled(disabled);
                            }
                        }

                        var GetCfnPrice = function () {
                            var cbHospit = Ext.getCmp('<%=this.cbWinShipmentHospital.ClientID%>');
                            if (cbHospit.getValue() == '') {
                                Ext.Msg.alert('Messinge', '请选择医院!');
                                return false;
                            }
                            Coolite.AjaxMethods.GetCfnPrice(
                                {
                                    success: function () {
                                        RefreshShipmentDetailWindow();
                                    },
                                    failure: function (err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                            );
                        }
    </script>

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
                <ext:Parameter Name="DealerId" Value="#{cbDealer}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{cbDealer}.getValue()"
                    Mode="Raw" />
            </BaseParams>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert('Error', e.message || response.statusText);" />
            </Listeners>
            <%--<SortInfo Field="Name" Direction="ASC" />--%>
        </ext:Store>
        <ext:Store ID="ScanType" runat="server" AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="BarCode1" />
                        <ext:RecordField Name="BarCode2" />
                        <ext:RecordField Name="QrCode" />
                        <ext:RecordField Name="Upn" />
                        <ext:RecordField Name="Lot" />
                        <ext:RecordField Name="Remark" />
                        <ext:RecordField Name="RemarkDate" Type="Date" />
                        <ext:RecordField Name="CreateDate" Type="Date" />
                        <ext:RecordField Name="CreateUserName" />
                        <ext:RecordField Name="Status" />
                        <ext:RecordField Name="DataHandleRemark" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="DealerCode" />
                        <ext:RecordField Name="DealerType" />
                        <ext:RecordField Name="WarehouseName" />
                        <ext:RecordField Name="WarehouseType" />
                        <ext:RecordField Name="WarehouseTypeName" />
                        <ext:RecordField Name="CustomerFaceNbr" />
                        <ext:RecordField Name="Sku2" />
                        <ext:RecordField Name="CfnCnName" />
                        <ext:RecordField Name="CfnEnName" />
                        <ext:RecordField Name="ExpiredDate" Type="Date" />
                        <ext:RecordField Name="UOM" />
                        <ext:RecordField Name="LotQty" Type="String" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="ProductLineId" />
                        <ext:RecordField Name="LotId" />
                        <ext:RecordField Name="ShipmentState" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="查询条件" AutoHeight="true" BodyStyle="padding: 5px;"
                            Frame="true" Icon="Find">
                            <Body>
                                <ext:Panel runat="server" ID="vefwe">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".35">
                                                <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择经销商" Width="250" Editable="true"
                                                                    TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName"
                                                                    Mode="Local" FieldLabel="经销商" ListWidth="300" Resizable="true">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清空" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                        <TriggerClick Handler="this.clearValue();#{WarehouseStore}.reload();#{cbWarehouse}.clearValue();" />
                                                                        <Select Handler="#{WarehouseStore}.reload();#{cbWarehouse}.clearValue();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbWarehouse" runat="server" EmptyText="请选择仓库" Mode="Local" Width="250"
                                                                    Editable="false" TypeAhead="true" StoreID="WarehouseStore" ValueField="Id" DisplayField="Name"
                                                                    FieldLabel="仓库">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清空" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbScanType" runat="server" EmptyText="请选择类型" Width="250" Editable="false"
                                                                    TypeAhead="true" FieldLabel="类型" ListWidth="300" Resizable="true">
                                                                    <Items>
                                                                        <ext:ListItem Text="上报销量" Value="上报销量" />
                                                                        <ext:ListItem Text="移库" Value="移库" />
                                                                    </Items>
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清空" />
                                                                    </Triggers>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtRemark" runat="server" Width="250" FieldLabel="备注" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbShipmentState" runat="server" EmptyText="上报状态" Width="250" Editable="false"
                                                                    TypeAhead="true" FieldLabel="上报状态" ListWidth="300" Resizable="true">
                                                                    <SelectedItem Value="0" Text="未上报" />
                                                                    <Items>
                                                                        <ext:ListItem Text="已上报" Value="1" />
                                                                        <ext:ListItem Text="未上报" Value="0" />
                                                                    </Items>
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清空" />
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
                                            <ext:LayoutColumn ColumnWidth=".25">
                                                <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="请选择产品线" Width="150" Editable="false"
                                                                    TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName"
                                                                    FieldLabel="产品线" ListWidth="300" Resizable="true">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清空" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtCFN" runat="server" Width="150" FieldLabel="产品型号" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtLotNumber" runat="server" Width="150" FieldLabel="批次号" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbQtyIsZero" runat="server" EmptyText="请选择" Width="150" Editable="true"
                                                                    TypeAhead="true" ListWidth="150" Resizable="true" FieldLabel="库存状态" Mode="Local">
                                                                    <SelectedItem Value="1" Text="库存不为零" />
                                                                    <Items>
                                                                        <ext:ListItem Value="1" Text="库存不为零" />
                                                                        <ext:ListItem Value="0" Text="库存为零" />
                                                                        <ext:ListItem Value="-1" Text="库存不存在" />
                                                                    </Items>
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清空" />
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
                                            <ext:LayoutColumn ColumnWidth=".20">
                                                <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="100">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtQrCode" runat="server" Width="120" FieldLabel="二维码" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtExpiredDateStart" runat="server" Width="120" FieldLabel="有效期开始日期" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtRemarkDateStart" runat="server" Width="120" FieldLabel="数据开始日期" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtCreateDateStart" runat="server" Width="120" FieldLabel="扫描开始日期" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".20">
                                                <ext:Panel ID="Panel10" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="txtCfnChineseName" runat="server" Width="120" FieldLabel="产品名称" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtExpiredDateEnd" runat="server" Width="120" FieldLabel="至" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtRemarkDateEnd" runat="server" Width="120" FieldLabel="至" />
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="txtCreateDateEnd" runat="server" Width="120" FieldLabel="至" />
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>

                                <ext:Panel ID="Panel32" runat="server">
                                    <Body>
                                        <ext:Label ID="Remark" runat="server" LabelSeparator="" Width="200"
                                            EmptyText="您有超期未上传发票的销量单据，具体未上传信息请到销售出库单页面查询" CtCls="txtRed" />
                                    </Body>
                                </ext:Panel>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnExport" Text="导出" runat="server" Icon="PageExcel" IDMode="Legacy"
                                    AutoPostBack="true" OnClick="ExportDetail">
                                </ext:Button>
                                <ext:Button ID="btnDelete" Text="删除" runat="server" Icon="Delete" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="delScanDate();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnCreateShipment" runat="server" Icon="CartRemove" Text="生成销售单">
                                    <Listeners>
                                        <Click Handler="addShipmentCfn(#{GridPanel1});" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnCreateTransfer" runat="server" Icon="CartEdit" Text="生成移库单">
                                    <Listeners>
                                        <Click Handler="addTransferCfn(#{GridPanel1});" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnCreateQrCodeConvent" runat="server" Icon="ArrowRefresh" Text="替换二维码(销售)">
                                    <Listeners>
                                        <Click Handler="addShipmentQRCode(#{GridPanel1});" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnCreateInvenrotyQrcodeConvent" runat="server" Icon="ArrowSwitch" Hidden="true"
                                    Text="替换二维码(库存)">
                                    <Listeners>
                                        <Click Handler="addInvnrotyQRCode(#{GridPanel1});" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="5 5 5 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" AutoExpandColumn="WarehouseName">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="LotId" DataIndex="LotId" Header="<input type='checkbox' id='chkAllItem' onclick='CheckAll()'>"
                                                    Width="50" Align="Center" Sortable="false" Fixed="true">
                                                    <Renderer Fn="RenderCheckBoxSet" />
                                                </ext:Column>
                                                <ext:Column ColumnID="BarCode1" DataIndex="BarCode1" Header="上报类型" Width="70" Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="30"
                                                    Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="仓库" Width="150"
                                                    Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="WarehouseTypeName" DataIndex="WarehouseTypeName" Header="仓库类型"
                                                    Width="60" Hidden="true" Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="QrCode" DataIndex="QrCode" Header="二维码" Width="120" Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="Remark" DataIndex="Remark" Header="备注" Width="70" Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineId" DataIndex="ProductLineId" Header="产品线" Width="90"
                                                    Sortable="true">
                                                    <Renderer Handler="return getNameFromStoreById(ProductLineStore,{Key:'Id',Value:'AttributeName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Upn" DataIndex="Upn" Header="产品型号" Width="90" Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="Sku2" DataIndex="Sku2" Header="短编号" Width="60" Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnCnName" DataIndex="CfnCnName" Header="产品中文名称" Width="60"
                                                    Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="Lot" DataIndex="Lot" Header="批次号" Width="65" Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="有效期" Width="80"
                                                    Sortable="true">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RemarkDate" DataIndex="RemarkDate" Header="数据日期" Width="80"
                                                    Sortable="true">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="扫描日期" Width="110"
                                                    Sortable="true">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="UOM" DataIndex="UOM" Header="单位" Width="50" Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="LotQty" DataIndex="LotQty" Header="库存数量" Width="40" Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="LotQty" DataIndex="LotQty" Header="上报数量" Width="60" Sortable="true">
                                                    <Renderer Fn="RenderTextBoxSet" />
                                                </ext:Column>
                                                <ext:Column ColumnID="CreateUserName" DataIndex="CreateUserName" Header="上报人" Align="Center"
                                                    Width="60" Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="ShipmentState" DataIndex="ShipmentState" Header="上报状态" Align="Center"
                                                    Width="60" Sortable="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="Id" DataIndex="Id" Width="35" Header="添加" Align="Center" Sortable="false"
                                                    Hidden="true">
                                                    <Renderer Fn="orderModify" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Id" DataIndex="Id" Width="35" Header="删除" Align="Center" Sortable="false">
                                                    <Renderer Fn="orderDelete" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="50" StoreID="ResultStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" />
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
        <ext:Hidden ID="hidRtnVal" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidRtnMsg" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidEditItemId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsEditting" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidInvType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidUPN" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidQrCode" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDealerId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidLotNumber" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidLotId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidHeadId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidWhmId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidiShipHeadid" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidPmaId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenFileName" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddencbWinStockProductLine" runat="server">
        </ext:Hidden>
        <ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="QrcId" />
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="DealerCode" />
                        <ext:RecordField Name="DealerType" />
                        <ext:RecordField Name="CfnId" />
                        <ext:RecordField Name="PmaId" />
                        <ext:RecordField Name="Upn" />
                        <ext:RecordField Name="LotId" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="BarCode" />
                        <ext:RecordField Name="Qty" />
                        <ext:RecordField Name="ToWarehouseId" />
                        <ext:RecordField Name="ToWarehouseType" />
                        <ext:RecordField Name="ToWarehouseName" />
                        <ext:RecordField Name="ShipmentPrice" />
                        <ext:RecordField Name="CreateUser" />
                        <ext:RecordField Name="CreateDate" />
                        <ext:RecordField Name="OperationType" />
                        <ext:RecordField Name="CustomerFaceNbr" />
                        <ext:RecordField Name="SKU2" />
                        <ext:RecordField Name="CfnCnName" />
                        <ext:RecordField Name="CfnEnName" />
                        <ext:RecordField Name="ExpiredDate" Type="Date" />
                        <ext:RecordField Name="WarehouseId" />
                        <ext:RecordField Name="WarehouseType" />
                        <ext:RecordField Name="WarehouseName" />
                        <ext:RecordField Name="ProductLineId" />
                        <ext:RecordField Name="LotQty" />
                        <ext:RecordField Name="ConvertFactor" />
                        <ext:RecordField Name="UOM" />
                        <ext:RecordField Name="QrcRemark" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <BaseParams>
                <ext:Parameter Name="InventoryType" Value="#{hidInvType}.getValue()" Mode="Raw" />
            </BaseParams>
            <Listeners>
                <Load Handler="#{ShipmentWindows}.body.unmask();#{TransferWindows}.body.unmask();" />
                <LoadException Handler="Ext.Msg.alert('Error', e.message || response.statusText);#{ShipmentWindows}.body.unmask();" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="HospitalStore" runat="server" UseIdConfirmation="true" AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Name" />
                        <ext:RecordField Name="ShortName" />
                        <ext:RecordField Name="Address" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
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
        </ext:Store>
        <ext:Store ID="TransferWarehouseStore" runat="server" OnRefreshData="TransferWarehouseSrote_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Name" />
                        <ext:RecordField Name="Type" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <BaseParams>
                <ext:Parameter Name="DealerId" Value="#{cbDealer}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{cbDealer}.getValue()"
                    Mode="Raw" />
                <ext:Parameter Name="DealerWarehouseType" Value="#{cbWinTransferType}.getValue()"
                    Mode="Raw" />
            </BaseParams>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert('Error', e.message || response.statusText);" />
            </Listeners>
            <%--<SortInfo Field="Name" Direction="ASC" />--%>
        </ext:Store>
        <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" AutoLoad="false"
            OnRefreshData="AttachmentStore_Refresh">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Attachment" />
                        <ext:RecordField Name="Name" />
                        <ext:RecordField Name="Url" />
                        <ext:RecordField Name="Type" />
                        <ext:RecordField Name="UploadUser" />
                        <ext:RecordField Name="Identity_Name" />
                        <ext:RecordField Name="UploadDate" />
                        <ext:RecordField Name="IsCurrent" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Window ID="ShipmentWindows" runat="server" Icon="Group" Title="销售单信息" Maximizable="true"
            Resizable="false" Header="false" Width="900" Height="500" AutoShow="true" Modal="true"
            ShowOnLoad="false" BodyStyle="padding:5px;" CenterOnLoad="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="FormPanel1" runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:Panel ID="Panel14" runat="server" Header="false" Frame="true" AutoHeight="true">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel6" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinShipmentDealerName" runat="server" FieldLabel="经销商" ReadOnly="true"
                                                                    Width="150" LabelCls="RequiredClass" AllowBlank="false">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextArea ID="tfWinShipmentRemark" runat="server" FieldLabel="备注" Height="90"
                                                                    Width="150">
                                                                </ext:TextArea>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbWinShipmentProductLine" runat="server" EmptyText="请选择产品线" Width="150"
                                                                    Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                                    DisplayField="AttributeName" FieldLabel="产品线" AllowBlank="false" LabelCls="RequiredClass"
                                                                    ListWidth="300" Resizable="true">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清空" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();ChangeShipmentProductLine();#{dfWinShipmentDate}.setValue('');#{cbWinShipmentHospital}.setValue('');#{cbWinShipmentHospital}.store.removeAll();" />
                                                                        <Select Handler="ChangeShipmentProductLine();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinShipmentInvoiceNo" runat="server" FieldLabel="发票号码" Width="150">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinShipmentInvoiceTitle" runat="server" FieldLabel="发票抬头" Width="150">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:DateField ID="dfWinShipmentInvoiceDate" runat="server" FieldLabel="发票日期" Width="150">
                                                                </ext:DateField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel8" runat="server" Border="false" Header="true">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:DateField ID="dfWinShipmentDate" runat="server" FieldLabel="用量日期" AllowBlank="false"
                                                                    Width="150" ReadOnly="true" LabelCls="RequiredClass">
                                                                    <Listeners>
                                                                        <Select Handler="ChangeShipmentDate();" />
                                                                    </Listeners>
                                                                </ext:DateField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Panel ID="Panel9" runat="server">
                                                                    <Body>
                                                                        <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                                                            <ext:LayoutColumn ColumnWidth=".75">
                                                                                <ext:Panel ID="Panel30" runat="server">
                                                                                    <Body>
                                                                                        <ext:FormLayout ID="FormLayout20" runat="server" LabelWidth="80">
                                                                                            <ext:Anchor>
                                                                                                <ext:ComboBox ID="cbWinShipmentHospital" runat="server" EmptyText="请选择销售医院" Width="130"
                                                                                                    Editable="true" TypeAhead="true" StoreID="HospitalStore" ValueField="Id" DisplayField="Name"
                                                                                                    FieldLabel="销售医院" AllowBlank="false" LabelCls="RequiredClass" ListWidth="300"
                                                                                                    Resizable="true" SelectOnFocus="true" ItemSelector="div.list-item">
                                                                                                    <Triggers>
                                                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清空" />
                                                                                                    </Triggers>
                                                                                                    <Listeners>
                                                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                                                    </Listeners>
                                                                                                    <Template ID="Template1" runat="server">
                                                                                                    <tpl for=".">
                                                                                                        <div class="list-item">
                                                                                                             <h3>{Name}</h3>
                                                                                                             <h2>　{ShortName}</h2>
                                                                                                        </div>
                                                                                                    </tpl>
                                                                                                    </Template>
                                                                                                </ext:ComboBox>
                                                                                            </ext:Anchor>
                                                                                        </ext:FormLayout>
                                                                                    </Body>
                                                                                </ext:Panel>
                                                                            </ext:LayoutColumn>
                                                                            <ext:LayoutColumn ColumnWidth=".25">
                                                                                <ext:Panel ID="Panel31" runat="server">
                                                                                    <Body>

                                                                                        <ext:FormLayout ID="FormLayout21" runat="server">
                                                                                            <ext:Anchor>
                                                                                                <ext:Button runat="server" Text="更新价格" ID="btnPrice">
                                                                                                    <Listeners>
                                                                                                        <Click Handler="GetCfnPrice();" />
                                                                                                    </Listeners>
                                                                                                </ext:Button>
                                                                                            </ext:Anchor>
                                                                                        </ext:FormLayout>
                                                                                    </Body>
                                                                                </ext:Panel>
                                                                            </ext:LayoutColumn>
                                                                        </ext:ColumnLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinShipmentDepartment" runat="server" FieldLabel="科室" Width="150">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <%--<ext:LayoutColumn ColumnWidth=".1">
                                            <ext:Panel ID="Panel9" runat="server" Border="false" Header="true">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout20" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:Panel>
                                                            </ext:Panel>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:Panel>
                                                            </ext:Panel>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:Button runat="server" Text="获取价格"  ID="btnPrice">
                                                                <Listeners>
                                                                    <Click Handler="GetCfnPrice();" />
                                                                </Listeners>
                                                            </ext:Button>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>--%>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                            </Body>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="5 5 5 5">
                        <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                            <Tabs>
                                <ext:Tab ID="TabSearch" runat="server" Title="上报销量" AutoShow="true">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout2" runat="server">
                                            <ext:GridPanel ID="ShipmentGridPanel" runat="server" Title="查询结果" StoreID="DetailStore"
                                                Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" ClicksToEdit="1"
                                                EnableHdMenu="false">
                                                <TopBar>
                                                    <ext:Toolbar ID="Toolbar1" runat="server" Height="25">
                                                        <Items>
                                                            <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                            <ext:Label ID="lbShipmentRecord" runat="server" Text="记录数:" Icon="Sum" />
                                                            <ext:Label ID="lbShipmentRecordSum" runat="server" Text="" />
                                                            <ext:ToolbarSeparator>
                                                            </ext:ToolbarSeparator>
                                                            <ext:Label ID="lbShipmentQty" runat="server" Text="数量合计:" Icon="Sum" />
                                                            <ext:Label ID="lbShipmentQtySum" runat="server" Text="" />
                                                        </Items>
                                                    </ext:Toolbar>
                                                </TopBar>
                                                <ColumnModel ID="ColumnModel2" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="90"
                                                            Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="仓库" Width="200"
                                                            Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="BarCode" DataIndex="BarCode" Header="二维码" Width="120" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="QrcRemark" DataIndex="QrcRemark" Header="备注" Width="90" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ProductLineId" DataIndex="ProductLineId" Header="产品线" Width="90"
                                                            Sortable="false">
                                                            <Renderer Handler="return getNameFromStoreById(ProductLineStore,{Key:'Id',Value:'AttributeName'},value);" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="产品型号"
                                                            Width="90" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="SKU2" DataIndex="SKU2" Header="短编号" Width="60" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="CfnCnName" DataIndex="CfnCnName" Header="产品中文名称" Width="90"
                                                            Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="批次号" Width="70" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="有效期" Width="80"
                                                            Sortable="false">
                                                            <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UOM" DataIndex="UOM" Header="单位" Width="50" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="LotQty" DataIndex="LotQty" Header="库存数量" Width="70" Sortable="false">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Qty" DataIndex="Qty" Header="销售数量" Width="70">
                                                            <Renderer Fn="SetCellCssEditable" />
                                                            <Editor>
                                                                <ext:NumberField ID="nfShipmentQty" runat="server" Width="60" AllowBlank="false"
                                                                    AllowDecimals="true" SelectOnFocus="true" AllowNegative="false" DecimalPrecision="6">
                                                                </ext:NumberField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:Column ColumnID="ShipmentPrice" DataIndex="ShipmentPrice" Header="销售金额" Width="70">
                                                            <Renderer Fn="SetCellCssEditable" />
                                                            <Editor>
                                                                <ext:NumberField ID="nfShipmentPrice" runat="server" Width="60" AllowBlank="false"
                                                                    AllowDecimals="true" SelectOnFocus="true" AllowNegative="false" DecimalPrecision="6">
                                                                </ext:NumberField>
                                                            </Editor>
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="60" Header="删除" Align="Center" Sortable="false">
                                                            <Commands>
                                                                <ext:GridCommand Icon="Cancel" CommandName="Delete">
                                                                    <ToolTip Text="删除" />
                                                                </ext:GridCommand>
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <SaveMask ShowMask="false" />
                                                <LoadMask ShowMask="false" />
                                                <Listeners>
                                                    <ValidateEdit Fn="CheckShipmentQty" />
                                                    <Command Handler="Coolite.AjaxMethods.DeleteOperationItem(record.data.Id,{success:function(){RefreshShipmentDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                    <BeforeEdit Handler="#{hidEditItemId}.setValue(this.getSelectionModel().getSelected().data.Id);#{nfShipmentQty}.setValue(this.getSelectionModel().getSelected().data.Qty);#{nfShipmentPrice}.setValue(this.getSelectionModel().getSelected().data.ShipmentPrice);" />
                                                    <AfterEdit Handler="ShowEditingMask('Shipment');StoreCommitAll(this.store);UpdateShipmentItem();" />
                                                </Listeners>
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>
                                <ext:Tab ID="TabAttachment" runat="server" Title="附件" Icon="BrickLink" AutoScroll="false">
                                    <Body>
                                        <ext:FitLayout ID="FTAttachement" runat="server">
                                            <ext:GridPanel ID="gpAttachment" runat="server" Title="附件列表" StoreID="AttachmentStore"
                                                AutoWidth="true" StripeRows="true" Collapsible="false" Border="false" Icon="Lorry"
                                                Header="false" AutoExpandColumn="Name">
                                                <TopBar>
                                                    <ext:Toolbar ID="Toolbar3" runat="server">
                                                        <Items>
                                                            <ext:ToolbarFill ID="ToolbarFill3" runat="server" />
                                                            <ext:Button ID="btnAddAttach" runat="server" Text="添加附件" Icon="Add" StyleSpec="margin-right:15px">
                                                                <%--<Listeners>
                                                                <Click Handler="AttachmentWindow.show();" />
                                                            </Listeners>--%>
                                                                <AjaxEvents>
                                                                    <Click OnEvent="ShowAttachmentWindow">
                                                                        <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{ShipmentWindows}.body}" />
                                                                    </Click>
                                                                </AjaxEvents>
                                                            </ext:Button>
                                                        </Items>
                                                    </ext:Toolbar>
                                                </TopBar>
                                                <ColumnModel ID="ColumnModel6" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="MainId" DataIndex="MainId" Hidden="true">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Name" DataIndex="Name" Header="附件名称">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Url" DataIndex="Url" Header="路径" Hidden="true" Width="200">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="上传人" Width="200">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="上传时间" Width="100">
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad" ToolTip-Text="下载" />
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                        <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel5" SingleSelect="true" runat="server">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBarAttachement" runat="server" PageSize="100" StoreID="AttachmentStore"
                                                        DisplayInfo="false" />
                                                </BottomBar>
                                                <SaveMask ShowMask="true" />
                                                <LoadMask ShowMask="true" Msg="处理中……" />
                                                <Listeners>
                                                    <Command Handler="if (command == 'Delete'){
                                                                            if( record.data.IsCurrent == '1'){
                                                                                Ext.Msg.confirm('警告', '是否要删除该附件文件?',
                                                                                    function(e) {
                                                                                        if (e == 'yes') {
                                                                                            Coolite.AjaxMethods.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                                success: function() {
                                                                                                    Ext.Msg.alert('Message', '删除附件成功！');
                                                                                                    #{gpAttachment}.reload();
                                                                                                },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                        }
                                                                                    });
                                                                                    
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        Ext.Msg.alert('警告', '非当天上传文件，不允许删除');
                                                                                    }
                                                                            }
                                                                            else if (command == 'DownLoad')
                                                                            {
                                                                                var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=ShipmentToHospital';
                                                                                downloadfile(url);                                                                                
                                                                            }
                                                                            
                                                                            " />
                                                </Listeners>
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
                <ext:Button ID="btnWinClearShipment" runat="server" Text="清空" Icon="BasketDelete">
                    <Listeners>
                        <Click Handler="ShipmentClear();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnWinAddShipment" runat="server" Text="提交" Icon="Add">
                    <Listeners>
                        <Click Handler="ShipmentSubmit();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Window ID="TransferWindows" runat="server" Icon="Group" Title="移库信息" Maximizable="true"
            Resizable="false" Header="false" Width="900" Height="500" AutoShow="false" Modal="true"
            ShowOnLoad="false" BodyStyle="padding:5px;" CenterOnLoad="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout3" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:Panel ID="Panel11" runat="server" Header="false" Frame="true" AutoHeight="true">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel12" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinTransferDealerName" runat="server" FieldLabel="经销商" ReadOnly="true"
                                                                    Width="150" LabelCls="RequiredClass" AllowBlank="false">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbWinTransferProductLine" runat="server" EmptyText="请选择产品线" Width="150"
                                                                    Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                                    DisplayField="AttributeName" FieldLabel="产品线" AllowBlank="false" LabelCls="RequiredClass"
                                                                    ListWidth="300" Resizable="true">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清空" />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();ChangeTransferProductLine();" />
                                                                        <Select Handler="ChangeTransferProductLine();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel13" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbWinTransferType" runat="server" EmptyText="请选择移库类型" Width="150"
                                                                    Editable="false" TypeAhead="true" StoreID="TransferTypeStore" ValueField="Key"
                                                                    DisplayField="Value" FieldLabel="移库类型" AllowBlank="false" LabelCls="RequiredClass"
                                                                    ListWidth="300" Resizable="true">
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <Select Handler="ChangeTransferType();#{cbWinTransferWarehouse}.store.reload();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel15" runat="server" Border="false" Header="true">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbWinTransferWarehouse" runat="server" EmptyText="请选择默认移入仓库..."
                                                                    Width="200" Editable="true" TypeAhead="true" StoreID="TransferWarehouseStore"
                                                                    ValueField="Id" Mode="Local" DisplayField="Name" FieldLabel="默认移入仓库" ListWidth="300"
                                                                    Resizable="true">
                                                                    <Triggers>
                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清除..." />
                                                                    </Triggers>
                                                                    <Listeners>
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <Select Handler="UpdateToWarehouse(this.value);" />
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
                            </Body>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="5 5 5 5">
                        <ext:Panel ID="Panel16" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="TransferGridPanel" runat="server" Title="查询结果" StoreID="DetailStore"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" ClicksToEdit="1"
                                        EnableHdMenu="false">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar2" runat="server" Height="25">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill4" runat="server" />
                                                    <ext:Label ID="lbTransferRecord" runat="server" Text="记录数:" Icon="Sum" />
                                                    <ext:Label ID="lbTransferRecordSum" runat="server" Text="" />
                                                    <ext:ToolbarSeparator>
                                                    </ext:ToolbarSeparator>
                                                    <ext:Label ID="lbTransferQty" runat="server" Text="数量合计:" Icon="Sum" />
                                                    <ext:Label ID="lbTransferQtySum" runat="server" Text="" />
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="90"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="仓库" Width="200"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="BarCode" DataIndex="BarCode" Header="二维码" Width="120" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="QrcRemark" DataIndex="QrcRemark" Header="备注" Width="90" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineId" DataIndex="ProductLineId" Header="产品线" Width="90"
                                                    Sortable="false">
                                                    <Renderer Handler="return getNameFromStoreById(ProductLineStore,{Key:'Id',Value:'AttributeName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="产品型号"
                                                    Width="90" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="SKU2" DataIndex="SKU2" Header="短编号" Width="60" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnCnName" DataIndex="CfnCnName" Header="产品中文名称" Width="90"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="批次号" Width="70" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="有效期" Width="80"
                                                    Sortable="false">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="UOM" DataIndex="UOM" Header="单位" Width="50" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="LotQty" DataIndex="LotQty" Header="库存数量" Width="70" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="Qty" DataIndex="Qty" Header="移库数量" Width="70">
                                                    <Renderer Fn="SetCellCssEditable" />
                                                    <Editor>
                                                        <ext:NumberField ID="nfTransferQty" runat="server" Width="60" AllowBlank="false"
                                                            AllowDecimals="true" SelectOnFocus="true" AllowNegative="false" DecimalPrecision="6">
                                                        </ext:NumberField>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="ToWarehouseName" DataIndex="ToWarehouseName" Header="移入仓库"
                                                    Align="Left" Width="170">
                                                    <Renderer Handler="return getNameFromStoreById(TransferWarehouseStore,{Key:'Id',Value:'Name'},value);" />
                                                    <Renderer Fn="SetCellCssEditable" />
                                                    <Editor>
                                                        <ext:ComboBox ID="cbToWarehouseId" runat="server" EmptyText="请选择移入仓库..." TriggerAction="All"
                                                            ForceSelection="true" StoreID="TransferWarehouseStore" ValueField="Id" Mode="Local"
                                                            Shadow="Drop" ListWidth="300" Resizable="true" DisplayField="Name">
                                                            <Listeners>
                                                                <BeforeQuery Fn="ComboxSelValue" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:CommandColumn Width="60" Header="删除" Align="Center" Sortable="false">
                                                    <Commands>
                                                        <ext:GridCommand Icon="Cancel" CommandName="Delete">
                                                            <ToolTip Text="删除" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="false" />
                                        <Listeners>
                                            <ValidateEdit Fn="CheckTransferQty" />
                                            <Command Handler="Coolite.AjaxMethods.DeleteOperationItem(record.data.Id,{success:function(){RefreshTransferDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                            <BeforeEdit Handler="#{hidEditItemId}.setValue(this.getSelectionModel().getSelected().data.Id);#{nfTransferQty}.setValue(this.getSelectionModel().getSelected().data.Qty);#{cbToWarehouseId}.setValue(this.getSelectionModel().getSelected().data.ToWarehouseId);" />
                                            <AfterEdit Handler="ShowEditingMask('Transfer');StoreCommitAll(this.store);UpdateTransferItem();" />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="btnTransferClear" runat="server" Text="清空" Icon="BasketDelete">
                    <Listeners>
                        <Click Handler="TransferClear();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnTransferSubmit" runat="server" Text="提交" Icon="Add">
                    <Listeners>
                        <Click Handler="TransferSubmit();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Store ID="ShipmentQRCodeDetailStore" runat="server" AutoLoad="false" OnRefreshData="ShipmentQRCodeDetailStore_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="WarehouseId" />
                        <ext:RecordField Name="WarehouseName" />
                        <ext:RecordField Name="ShipmentNbr" />
                        <ext:RecordField Name="HospitalId" />
                        <ext:RecordField Name="SubmitDate" />
                        <ext:RecordField Name="CustomerFaceNbr" />
                        <ext:RecordField Name="Property1" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="QRCode" />
                        <ext:RecordField Name="ExpiredDate" />
                        <ext:RecordField Name="Uom" />
                        <ext:RecordField Name="ShippedQty" />
                        <ext:RecordField Name="UnitPrice" />
                        <ext:RecordField Name="HospitalName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <BaseParams>
                <ext:Parameter Name="InventoryType" Value="#{hidInvType}.getValue()" Mode="Raw" />
            </BaseParams>
            <Listeners>
                <Load Handler="#{ShipmentWindows}.body.unmask();#{TransferWindows}.body.unmask();" />
                <LoadException Handler="Ext.Msg.alert('Error', e.message || response.statusText);#{ShipmentWindows}.body.unmask();" />
            </Listeners>
        </ext:Store>
        <ext:Window ID="ShipmentQRCodeWindows" runat="server" Icon="Group" Title="二维码转换"
            Maximizable="true" Resizable="false" Header="false" Width="900" Height="500"
            AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" CenterOnLoad="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout4" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="FormPanel3" runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:Panel ID="Panel17" runat="server" Header="false" Frame="true" AutoHeight="true">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".25">
                                                <ext:Panel ID="Panel18" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout11" runat="server" LabelAlign="Left" LabelWidth="60">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinQrCodeConvertDealerName" runat="server" FieldLabel="经销商"
                                                                    ReadOnly="true" Width="140" LabelCls="RequiredClass" AllowBlank="false">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinQrCodeConvertLotNumber" runat="server" FieldLabel="批次号" ReadOnly="true"
                                                                    Width="140" LabelCls="RequiredClass" AllowBlank="false">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbWinQrCodeCOnert" runat="server" EmptyText="请选择原因" Width="140"
                                                                    Editable="false" TypeAhead="true" FieldLabel="调整原因" AllowBlank="false" LabelCls="RequiredClass"
                                                                    ListWidth="200" Resizable="true">
                                                                    <Items>
                                                                        <ext:ListItem Value="二维码替换" Text="二维码替换" />
                                                                    </Items>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <%--  <Select Handler="ChangeTransferType();#{cbWinTransferWarehouse}.store.reload();"/>--%>
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel19" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout12" runat="server" LabelAlign="Left" LabelWidth="90">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbfWinQrCodeConvertProductLine" runat="server" EmptyText="请选择产品线"
                                                                    Width="150" Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                                    DisplayField="AttributeName" FieldLabel="产品线" AllowBlank="false" LabelCls="RequiredClass"
                                                                    ListWidth="300" Resizable="true" Disabled="true">
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <%--  <Select Handler="ChangeTransferType();#{cbWinTransferWarehouse}.store.reload();"/>--%>
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinQrCodeConvertUsedQrCode" runat="server" FieldLabel="被替换的二维码"
                                                                    ReadOnly="true" Width="150" LabelCls="RequiredClass" AllowBlank="false">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".26">
                                                <ext:Panel ID="Panel20" runat="server" Border="false" Header="true">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout13" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinQrCodeConvertUpn" runat="server" FieldLabel="产品型号" ReadOnly="true"
                                                                    Width="130" LabelCls="RequiredClass" AllowBlank="false">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinQrCodeConvertNewQrCode" runat="server" ReadOnly="true" FieldLabel="新二维码"
                                                                    Width="130" LabelCls="RequiredClass" AllowBlank="false">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".13">
                                                <ext:Panel ID="Panel22" runat="server" Border="false" Header="true">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout14" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:Panel ID="p1" runat="server" Height="25">
                                                                </ext:Panel>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Button ID="btnNewCfn" runat="server" Icon="add">
                                                                    <Listeners>
                                                                        <Click Handler="BtnNewCfn('Shipment');" />
                                                                    </Listeners>
                                                                </ext:Button>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                            </Body>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="5 5 5 5">
                        <ext:Panel ID="Panel21" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout4" runat="server">
                                    <ext:GridPanel ID="QrCodeConvertGridPanel" runat="server" Title="查询结果" StoreID="ShipmentQRCodeDetailStore"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" ClicksToEdit="1"
                                        EnableHdMenu="false">
                                        <ColumnModel ID="ColumnModel4" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="Id" DataIndex="Id" Header="<input type='checkbox' id='QrCodekAllItem' onclick='QrCodeCheckAll()'>"
                                                    Width="50" Align="Center" Sortable="false" Fixed="true">
                                                    <Renderer Fn="QrCodeRenderCheckBoxSet" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerId" DataIndex="DealerId" Header="经销商" Width="90" Sortable="false">
                                                    <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="仓库" Width="200"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="ShipmentNbr" DataIndex="ShipmentNbr" Header="销售单号" Width="120"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="销售医院" Width="90"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="SubmitDate" DataIndex="SubmitDate" Header="提交日期" Width="90"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="产品型号"
                                                    Width="90" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="Property1" DataIndex="Property1" Header="短编号" Width="60" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="产品中文名称" Width="90"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="批次号" Width="70" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码" Width="80" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="有效期" Width="70"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="Uom" DataIndex="Uom" Header="单位" Width="50" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="ShippedQty" DataIndex="ShippedQty" Header="销售数量" Width="70"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="UnitPrice" DataIndex="UnitPrice" Header="销售单价" Width="70">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <%--  <SelectionModel>
                                        <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server">
                                            <Listeners>
                                                <BeforeRowSelect Fn="beforeRowSelect" />
                                            </Listeners>
                                        </ext:CheckboxSelectionModel>
                                    </SelectionModel>--%>
                                        <%-- <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel4" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>--%>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="false" />
                                        <Listeners>
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="btnShipmentQRCodeSubmit" runat="server" Text="提交" Icon="Add">
                    <Listeners>
                        <Click Handler="QrCodeConvertCheckedSumbit(#{QrCodeConvertGridPanel});" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Window ID="AttachmentWindow" runat="server" Icon="Group" Title="上传附件" Resizable="false"
            Header="false" Width="500" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Header="false"
                    AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout19" runat="server" LabelWidth="50">
                            <ext:Anchor>
                                <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择上传附件" FieldLabel="文件"
                                    ButtonText="" Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="SaveButton" runat="server" Text="上传附件">
                            <AjaxEvents>
                                <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');"
                                    Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });"
                                    Success="#{gpAttachment}.reload();#{FileUploadField1}.setValue('')">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="ResetButton" runat="server" Text="清除">
                            <Listeners>
                                <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </Body>
            <Listeners>
                <Hide Handler="#{gpAttachment}.reload();" />
                <BeforeShow Handler="#{FileUploadField1}.setValue('');" />
            </Listeners>
        </ext:Window>
        <ext:Store ID="StockQRCodeDetailStore" runat="server" AutoLoad="false" OnRefreshData="StockQRCodeDetailStore_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="CustomerFaceNbr" />
                        <ext:RecordField Name="Qty" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="QrCode" />
                        <ext:RecordField Name="LotId" />
                        <ext:RecordField Name="WHMId" />
                        <ext:RecordField Name="WarehouseName" />
                        <ext:RecordField Name="Property1" />
                        <ext:RecordField Name="ExpiredDate" />
                        <ext:RecordField Name="UOM" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="Qty" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <BaseParams>
                <ext:Parameter Name="InventoryType" Value="#{hidInvType}.getValue()" Mode="Raw" />
            </BaseParams>
            <Listeners>
                <Load Handler="#{ShipmentWindows}.body.unmask();#{InvenrotyWindow}.body.unmask();" />
                <LoadException Handler="Ext.Msg.alert('Error', e.message || response.statusText);#{InvenrotyWindow}.body.unmask();" />
            </Listeners>
        </ext:Store>
        <ext:Window ID="InvenrotyWindow" runat="server" Icon="Group" Title="二维码转换" Maximizable="true"
            Resizable="false" Header="false" Width="900" Height="500" AutoShow="false" Modal="true"
            ShowOnLoad="false" BodyStyle="padding:5px;" CenterOnLoad="true">
            <Body>
                <ext:BorderLayout ID="BorderLayout5" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="FormPanel4" runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:Panel ID="Panel23" runat="server" Header="false" Frame="true" AutoHeight="true">
                                    <Body>
                                        <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                            <ext:LayoutColumn ColumnWidth=".25">
                                                <ext:Panel ID="Panel24" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout15" runat="server" LabelAlign="Left" LabelWidth="60">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinStockDealerName" runat="server" FieldLabel="经销商" ReadOnly="true"
                                                                    Width="140" LabelCls="RequiredClass" AllowBlank="false">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinStockLotNumber" runat="server" FieldLabel="批次号" ReadOnly="true"
                                                                    Width="140" LabelCls="RequiredClass" AllowBlank="false">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbWinStockreason" runat="server" EmptyText="请选择原因" Width="140"
                                                                    Editable="false" TypeAhead="true" FieldLabel="调整原因" AllowBlank="false" LabelCls="RequiredClass"
                                                                    ListWidth="200" Resizable="true">
                                                                    <Items>
                                                                        <ext:ListItem Value="二维码替换" Text="二维码替换" />
                                                                    </Items>
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <%--  <Select Handler="ChangeTransferType();#{cbWinTransferWarehouse}.store.reload();"/>--%>
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".33">
                                                <ext:Panel ID="Panel25" runat="server" Border="false" Header="false">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout16" runat="server" LabelAlign="Left" LabelWidth="90">
                                                            <ext:Anchor>
                                                                <ext:ComboBox ID="cbWinStockProductLine" runat="server" EmptyText="请选择产品线" Width="150"
                                                                    Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                                    DisplayField="AttributeName" FieldLabel="产品线" AllowBlank="false" LabelCls="RequiredClass"
                                                                    ListWidth="300" Resizable="true" ReadOnly="true" Disabled="true">
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <%--  <Select Handler="ChangeTransferType();#{cbWinTransferWarehouse}.store.reload();"/>--%>
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinStockinQrCode" runat="server" FieldLabel="入库二维码" ReadOnly="true"
                                                                    Width="150" LabelCls="RequiredClass" AllowBlank="false">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".26">
                                                <ext:Panel ID="Panel26" runat="server" Border="false" Header="true">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout17" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinStockUpn" runat="server" FieldLabel="产品型号" ReadOnly="true"
                                                                    Width="130" LabelCls="RequiredClass" AllowBlank="false">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:TextField ID="tfWinStockOutQrCode" runat="server" ReadOnly="true" FieldLabel="出库二维码"
                                                                    Width="130" LabelCls="RequiredClass" AllowBlank="false">
                                                                </ext:TextField>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                            <ext:LayoutColumn ColumnWidth=".13">
                                                <ext:Panel ID="Panel27" runat="server" Border="false" Header="true">
                                                    <Body>
                                                        <ext:FormLayout ID="FormLayout18" runat="server" LabelAlign="Left" LabelWidth="80">
                                                            <ext:Anchor>
                                                                <ext:Panel ID="Panel28" runat="server" Height="25">
                                                                </ext:Panel>
                                                            </ext:Anchor>
                                                            <ext:Anchor>
                                                                <ext:Button ID="Button1" runat="server" Icon="add">
                                                                    <Listeners>
                                                                        <Click Handler="BtnNewCfn('stock');" />
                                                                    </Listeners>
                                                                </ext:Button>
                                                            </ext:Anchor>
                                                        </ext:FormLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </ext:LayoutColumn>
                                        </ext:ColumnLayout>
                                    </Body>
                                </ext:Panel>
                            </Body>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="5 5 5 5">
                        <ext:Panel ID="Panel29" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout5" runat="server">
                                    <ext:GridPanel ID="GridPanel2" runat="server" Title="查询结果" StoreID="StockQRCodeDetailStore"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" ClicksToEdit="1"
                                        EnableHdMenu="false">
                                        <ColumnModel ID="ColumnModel5" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerId" DataIndex="DealerId" Header="经销商" Width="90" Sortable="false">
                                                    <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="WarehouseName" DataIndex="WarehouseName" Header="仓库" Width="200"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="产品型号"
                                                    Width="90" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="Property1" DataIndex="Property1" Header="短编号" Width="60" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="产品中文名称" Width="90"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="批次号" Width="70" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="Qty" DataIndex="Qty" Header="数量" Width="70" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="QrCode" DataIndex="QrCode" Header="二维码" Width="80" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="有效期" Width="70"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="UOM" DataIndex="UOM" Header="单位" Width="50" Sortable="false">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <%--  <SelectionModel>
                                        <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server">
                                            <Listeners>
                                                <BeforeRowSelect Fn="beforeRowSelect" />
                                            </Listeners>
                                        </ext:CheckboxSelectionModel>
                                    </SelectionModel>--%>
                                        <%-- <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel4" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>--%>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="false" />
                                        <Listeners>
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="Button2" runat="server" Text="提交" Icon="Add">
                    <Listeners>
                        <Click Handler="StockQrCodeConvertCheckedSumbit();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <uc1:InvenrotyQROperationCfnDailog ID="InvenrotyQROperationCfnDailog" runat="server" />
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
