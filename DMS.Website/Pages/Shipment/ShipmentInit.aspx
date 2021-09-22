<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShipmentInit.aspx.cs" Inherits="DMS.Website.Pages.Shipment.ShipmentInit" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Shipment order import</title>
    <link href="../../../../resources/css/examples.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #fi-button-msg {
            border: 2px solid #ccc;
            padding: 5px 10px;
            background: #eee;
            margin: 5px;
            float: left;
        }

        .x-grid-cell-error {
            background: #FFFF99;
        }
    </style>

    <script type="text/javascript">
        var MsgList = {
            SaveButton: {
                BeforeTitle: "<%=GetLocalResourceObject("form1.SaveButton.wait.Title").ToString()%>",
                BeforeMsg: "<%=GetLocalResourceObject("form1.SaveButton.wait.Body").ToString()%>",
                FailureTitle: "<%=GetLocalResourceObject("form1.SaveButton.Msg.Show.Title").ToString()%>",
                FailureMsg: "<%=GetLocalResourceObject("form1.SaveButton.Msg.Show.body").ToString()%>"
            },
            ImportButton: {
                BeforeTitle: "<%=GetLocalResourceObject("form1.ImportButton.wait.Title").ToString()%>",
                BeforeMsg: "<%=GetLocalResourceObject("form1.ImportButton.wait.Body").ToString()%>"
            }
        }

        var showFile = function (fb, v) {
            var el = Ext.fly('fi-button-msg');
            el.update('<b>Selected:</b> ' + v);
            if (!el.isVisible()) {
                el.slideIn('t', {
                    duration: .2,
                    easing: 'easeIn',
                    callback: function () {
                        el.highlight();
                    }
                });
            } else {
                el.highlight();
            }
        }

        //最初的版本请参考InventoryInit.aspx
        var editId = '';
        var editControls = [
                          { name: 'HospitalCode', field: { xtype: "textfield", width: 120, maxLength: 50, allowBlank: true } },
                          { name: 'HospitalName', field: { xtype: "textfield", width: 150, maxLength: 200, allowBlank: false } },
                          { name: 'HospitalOffice', field: { xtype: "textfield", width: 120, maxLength: 200, allowBlank: true } },
                          { name: 'InvoiceNumber', field: { xtype: "textfield", width: 120, maxLength: 200, allowBlank: true } },
                          { name: 'InvoiceDate', field: { xtype: "datefield", format: "Y-m-d", allowBlank: true } },
                          { name: 'InvoiceTitle', field: { xtype: "textfield", width: 120, maxLength: 200, allowBlank: true } },
                          { name: 'ShipmentDate', field: { xtype: "datefield", width: 120, format: "Y-m-d", allowBlank: false } },
                          { name: 'ArticleNumber', field: { xtype: "textfield", width: 120, maxLength: 200, allowBlank: false } },
                          { name: 'ChineseName', field: { xtype: "textfield", width: 120, maxLength: 200, allowBlank: true } },
                          { name: 'LotNumber', field: { xtype: "textfield", width: 120, maxLength: 20, allowBlank: false } },
                          { name: 'QrCode', field: { xtype: "textfield", width: 120, maxLength: 20, allowBlank: false } },
                          { name: 'Price', field: { xtype: "numberfield", width: 120, allowBlank: false, minValue: 0.0, maxValue: 999999999.0, allowNegative: false, allowDecimals: true, inputType: "text" } },
                      //{ name: 'Uom', field: {xtype:"textfield",width:90,maxLength:20,allowBlank:true} },
                           //{ name: 'ExpiredDate', field: {xtype:"datefield",width:90,format:"Y-m-d",allowBlank:false} },
                          { name: 'Qty', field: { xtype: "numberfield", width: 120, allowBlank: false, minValue: 0.1, maxValue: 99999999.0, allowNegative: false, allowDecimals: true, inputType: "text" } },
                          { name: 'Warehouse', field: { xtype: "textfield", width: 230, maxLength: 50, allowBlank: false } },
                          { name: 'LotShipmentDate', field: { xtype: "datefield", format: "Y-m-d", allowBlank: true } },
                          { name: 'Remark', field: { xtype: "textfield", width: 200, maxLength: 100, allowBlank: true } },
                          { name: 'ConsignmentNbr', field: { xtype: "textfield", width: 120, maxLength: 100, allowBlank: true } }
        ];

        var renderData = function (value, meta, record, row, col, store) {
            if (record.get(meta.id + 'ErrMsg') != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.get(meta.id + 'ErrMsg') + '"';
            }
            if (editId == record.id) {
                return "<div id='div" + meta.id + "'><\/div>";
            }
            return value;
        }

        var renderControl = function (item) {
            var config = Ext.apply({}, item.field, { id: 'tb' + item.name, renderTo: 'div' + item.name });
            switch (config.xtype) {
                case 'textfield': return new Ext.form.TextField(config);
                case 'datefield': return new Ext.form.DateField(config);
                case 'numberfield': return new Ext.form.NumberField(config);
                default:
            }
        }

        var renderEditControls = function (record) {
            Ext.each(editControls, function (item) {
                renderControl(item);
                Ext.getCmp('tb' + item.name).setValue(record.get(item.name));
            });
        }

        var checkValid = function () {

            for (var i = 0; i < editControls.length; i++) {
                if (!Ext.getCmp('tb' + editControls[i].name).isValid())
                    return false;
            }

            return true;
        }

        var rowCommand = function (command, record, row) {
            if (command == "Edit") {
                editId = record.id;
                Ext.getCmp('<%=this.GridPanel1.ClientID %>').getView().refresh(true);
                renderEditControls(record);
            }
            else if (command == "Cancel") {
                editId = '';
                Ext.getCmp('<%=this.GridPanel1.ClientID %>').getView().refresh(true);
            }
            else if (command == "Save") {
                var tbHospitalCode = Ext.getCmp('tbHospitalCode');
                var tbHospitalName = Ext.getCmp('tbHospitalName');
                var tbHospitalOffice = Ext.getCmp('tbHospitalOffice');
                var tbInvoiceNumber = Ext.getCmp('tbInvoiceNumber');
                var tbInvoiceDate = Ext.getCmp('tbInvoiceDate');
                var tbInvoiceTitle = Ext.getCmp('tbInvoiceTitle');
                var tbShipmentDate = Ext.getCmp('tbShipmentDate');
                var tbArticleNumber = Ext.getCmp('tbArticleNumber');
                var tbChineseName = Ext.getCmp('tbChineseName');
                var tbLotNumber = Ext.getCmp('tbLotNumber');
                var tbPrice = Ext.getCmp('tbPrice');
                //                var tbUom = Ext.getCmp('tbUom');
                //var tbExpiredDate=Ext.getCmp('tbExpiredDate');
                var tbQty = Ext.getCmp('tbQty');
                var tbWarehouse = Ext.getCmp('tbWarehouse');
                var tbLotShipmentDate = Ext.getCmp('tbLotShipmentDate');
                var tbRemark = Ext.getCmp('tbRemark');
                var tbConsignmentNbr = Ext.getCmp('tbConsignmentNbr');
                var tbQrCode = Ext.getCmp('tbQrCode');

                if (checkValid()) {
                    Coolite.AjaxMethods.Save(
                        record.id,
                        tbHospitalCode.getValue(),
                        tbHospitalName.getValue(),
                        tbHospitalOffice.getValue(),
                        tbInvoiceNumber.getValue(),
                        tbInvoiceDate.getValue(),
                        tbInvoiceTitle.getValue(),
                        tbShipmentDate.getRawValue(),
                        tbArticleNumber.getValue(),
                        tbChineseName.getValue(),
                        tbLotNumber.getValue(),
                        tbPrice.getValue(),
//                        tbUom.getValue(),
                        //tbExpiredDate.getValue(),
                        tbQty.getValue(),
                        tbWarehouse.getValue(),
                        tbLotShipmentDate.getValue(),
                        tbRemark.getValue(),


                        tbConsignmentNbr.getValue(),
                         tbQrCode.getValue(),
                        {
                            success: function () {
                                Ext.each(editControls, function (item) {
                                    record.set(item.name, Ext.getCmp('tb' + item.name).getRawValue());
                                    record.set(item.name + 'ErrMsg', null);
                                });
                                record.commit();

                                editId = '';
                                Ext.getCmp('<%=this.GridPanel1.ClientID %>').getView().refresh(true);
                                //renderEditControls(record);    
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                    );
                    }
                } else if (command == "Delete") {
                    Coolite.AjaxMethods.Delete(
                        record.id,
                        {
                            success: function () {
                                editId = '';
                                Ext.getCmp('<%=this.GridPanel1.ClientID %>').deleteSelected();
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                );
                    }

        }

    var prepareCommand = function (grid, command, record, row) {
        command.hidden = true;

        if (editId == record.id) {
            if (command.command == "Save" || command.command == "Cancel") {
                command.hidden = false;
            }
        } else {
            if (command.command == "Delete" || command.command == "Edit") {
                command.hidden = false;
            }
        }
    }


    var Confirm = function () {
        Ext.Msg.confirm('', '<%=GetLocalResourceObject("PrepareToUpload").ToString()%>' + hiddenLineNbr.getValue() + '<%=GetLocalResourceObject("DataCount").ToString()%>' + hiddenQty.getValue() + '<%=GetLocalResourceObject("ProductAndAmount").ToString()%>' + hiddenPrice.getValue() + '<%=GetLocalResourceObject("RMBYuan").ToString()%>',
               function (e) {
                   if (e == 'yes' && hiddenQty.getValue() > 0) {

                       Ext.Msg.wait(MsgList.ImportButton.BeforeTitle, MsgList.ImportButton.BeforeMsg);
                       Coolite.AjaxMethods.ImportClick();

                   }
                   else {

                   }
               });
    }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false" WarningOnDirty="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="LineNbr" />
                        <ext:RecordField Name="HospitalCode" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="HospitalOffice" />
                        <ext:RecordField Name="InvoiceNumber" />
                        <ext:RecordField Name="InvoiceTitle" />
                        <ext:RecordField Name="ShipmentDate" />
                        <ext:RecordField Name="ArticleNumber" />
                        <ext:RecordField Name="ChineseName" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="Price" />
                        <ext:RecordField Name="Uom" />
                        <ext:RecordField Name="ExpiredDate" />
                        <ext:RecordField Name="Qty" />
                        <ext:RecordField Name="HospitalCodeErrMsg" />
                        <ext:RecordField Name="ShipmentDateErrMsg" />
                        <ext:RecordField Name="ArticleNumberErrMsg" />
                        <ext:RecordField Name="LotNumberErrMsg" />
                        <ext:RecordField Name="QtyErrMsg" />
                        <ext:RecordField Name="PriceErrMsg" />
                        <ext:RecordField Name="Warehouse" />
                        <ext:RecordField Name="WarehouseErrMsg" />
                        <ext:RecordField Name="InvoiceDate" />
                        <ext:RecordField Name="InvoiceDateErrMsg" />
                        <ext:RecordField Name="HospitalNameErrMsg" />
                        <ext:RecordField Name="LotShipmentDate" />
                        <ext:RecordField Name="Remark" />
                        <ext:RecordField Name="LotShipmentDateErrMsg" />
                        <ext:RecordField Name="RemarkErrMsg" />
                        <ext:RecordField Name="ConsignmentNbr" />
                        <ext:RecordField Name="ConsignmentNbrErrMsg" />
                        <ext:RecordField Name="QrCode" />
                        <ext:RecordField Name="QrCodeErrMsg" />

                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Title="<%$ Resources: form1.BasicForm.Title %>"
                            AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;"
                            ButtonAlign="Left">
                            <Defaults>
                                <ext:Parameter Name="anchor" Value="50%" Mode="Value" />
                                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                            </Defaults>
                            <Body>
                                <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="50">
                                    <ext:Anchor>
                                        <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="<%$ Resources: form1.FileUploadField1.EmptyText %>"
                                            FieldLabel="<%$ Resources: form1.FileUploadField1.FieldLabel %>" ButtonText=""
                                            Icon="ImageAdd">
                                        </ext:FileUploadField>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                            <Listeners>
                                <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);#{VerificationButton}.setDisabled(!valid);" />
                            </Listeners>
                            <Buttons>
                                <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: form1.SaveButton.Text %>">
                                    <AjaxEvents>
                                        <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                "
                                            Failure="Ext.Msg.show({ 
                                title   : MsgList.SaveButton.FailureTitle, 
                                msg     : MsgList.SaveButton.FailureMsg, 
                                minWidth: 200, 
                                modal   : true, 
                                icon    : Ext.Msg.ERROR, 
                                buttons : Ext.Msg.OK 
                            });"
                                            Success="#{PagingToolBar1}.changePage(1);">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="VerificationButton" runat="server" Text="<%$ Resources: form1.VerificationButton.Text %>">
                                    <AjaxEvents>
                                        <Click OnEvent="VerificationClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                "
                                            Failure="Ext.Msg.show({ 
                                title   : MsgList.SaveButton.FailureTitle, 
                                msg     : MsgList.SaveButton.FailureMsg, 
                                minWidth: 200, 
                                modal   : true, 
                                icon    : Ext.Msg.ERROR, 
                                buttons : Ext.Msg.OK 
                            });"
                                            Success="#{PagingToolBar1}.changePage(1);">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="ResetButton" runat="server" Text="<%$ Resources: form1.ResetButton.Text %>">
                                    <Listeners>
                                        <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);;#{VerificationButton}.setDisabled(true);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="ImportButton" runat="server" Text="<%$ Resources: form1.ImportButton.Text %>" Hidden="true">
                                    <AjaxEvents>
                                        <Click OnEvent="UploadConfirm" Success="Confirm();">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="DownloadButton" runat="server" Text="<%$ Resources: form1.DownloadButton.Text %>">
                                    <Listeners>
                                        <Click Handler="window.open('../../Upload/ExcelTemplate/Template_ShipmentImport.xls')" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="SearchButton" runat="server" Text="查询待处理数据">
                                    <Listeners>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                        StoreID="ResultStore" Border="false" Icon="Error" AutoWidth="true" StripeRows="true"
                                        EnableHdMenu="false">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="LineNbr" DataIndex="LineNbr" Header="<%$ Resources: GridPanel1.ColumnModel1.LineNbr.Header %>"
                                                    Sortable="false" Width="50">
                                                </ext:Column>
                                                <ext:Column ColumnID="HospitalCode" DataIndex="HospitalCode" Header="<%$ Resources: GridPanel1.ColumnModel1.HospitalCode.Header %>"
                                                    Sortable="false" Width="120">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="<%$ Resources: GridPanel1.ColumnModel1.HospitalName.Header%>"
                                                    Sortable="false" Width="150">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="HospitalOffice" DataIndex="HospitalOffice" Header="<%$ Resources: GridPanel1.ColumnModel1.HospitalOffice.Header %>"
                                                    Sortable="false" Width="120">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="InvoiceNumber" DataIndex="InvoiceNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.InvoiceNo.Header %>"
                                                    Sortable="false" Width="120">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="InvoiceDate" DataIndex="InvoiceDate" Header="<%$ Resources: GridPanel1.ColumnModel1.InvoiceDate.Header %>"
                                                    Sortable="false" Width="125">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="InvoiceTitle" DataIndex="InvoiceTitle" Header="<%$ Resources: GridPanel1.ColumnModel1.InvoiceTitle.Header %>"
                                                    Sortable="false" Width="120">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ShipmentDate" DataIndex="ShipmentDate" Header="<%$ Resources: GridPanel1.ColumnModel1.ShipmentDate.Header %>"
                                                    Sortable="false" Width="125">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ArticleNumber" DataIndex="ArticleNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.ArticleNumber.Header%>"
                                                    Sortable="false" Width="120">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel1.ColumnModel1.ProductName.Header %>"
                                                    Sortable="false" Width="120">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.LotNumber.Header%>"
                                                    Sortable="false" Width="120">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="QrCode" DataIndex="QrCode" Header="二维码"
                                                    Sortable="false" Width="120">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Price" DataIndex="Price" Header="<%$ Resources: GridPanel1.ColumnModel1.Price.Header%>"
                                                    Sortable="false" Width="120">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Qty" DataIndex="Qty" Header="<%$ Resources: GridPanel1.ColumnModel1.Qty.Header%>"
                                                    Sortable="false" Width="120">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Uom" DataIndex="Uom" Header="<%$ Resources: GridPanel1.ColumnModel1.ProductUnit.Header %>"
                                                    Sortable="false" Width="120">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ExpiredDate" DataIndex="ExpiredDate" Header="<%$ Resources: GridPanel1.ColumnModel1.ExpiredDate.Header %>"
                                                    Sortable="false" Width="120">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Warehouse" DataIndex="Warehouse" Header="<%$ Resources: GridPanel1.ColumnModel1.Warehouse.Header%>"
                                                    Sortable="false" Width="230">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="LotShipmentDate" DataIndex="LotShipmentDate" Header="<%$ Resources: GridPanel1.ColumnModel1.LotShipmentDate.Header%>"
                                                    Sortable="false" Width="230">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Remark" DataIndex="Remark" Header="<%$ Resources: GridPanel1.ColumnModel1.Remark.Header%>"
                                                    Sortable="false" Width="230">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ConsignmentNbr" DataIndex="ConsignmentNbr" Header="寄售申请单号"
                                                    Sortable="false" Width="230">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:ImageCommandColumn Width="80">
                                                    <Commands>
                                                        <ext:ImageCommand CommandName="Edit" Icon="TableEdit">
                                                            <ToolTip Text="Edit" />
                                                        </ext:ImageCommand>
                                                        <ext:ImageCommand CommandName="Save" Icon="Disk">
                                                            <ToolTip Text="Save" />
                                                        </ext:ImageCommand>
                                                        <ext:ImageCommand CommandName="Cancel" Icon="ArrowUndo">
                                                            <ToolTip Text="Cancel" />
                                                        </ext:ImageCommand>
                                                        <ext:ImageCommand CommandName="Delete" Icon="Cross">
                                                            <ToolTip Text="Delete" />
                                                        </ext:ImageCommand>
                                                    </Commands>
                                                    <PrepareCommand Fn="prepareCommand" />
                                                </ext:ImageCommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="false">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Fn="rowCommand" />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="100" StoreID="ResultStore"
                                                DisplayInfo="false">
                                                <Listeners>
                                                    <BeforeChange Handler="editId=''" />
                                                </Listeners>
                                            </ext:PagingToolbar>
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Hidden ID="hiddenFileName" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenLineNbr" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenPrice" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenQty" runat="server">
        </ext:Hidden>
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>
