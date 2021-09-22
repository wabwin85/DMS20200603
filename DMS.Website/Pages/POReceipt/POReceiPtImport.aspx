<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="POReceiPtImport.aspx.cs"
    Inherits="DMS.Website.Pages.POReceipt.POReceiPtImport" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>平台收货数据批量上传</title>
    <link href="../../../../resources/css/examples.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #fi-button-msg
        {
            border: 2px solid #ccc;
            padding: 5px 10px;
            background: #eee;
            margin: 5px;
            float: left;
        }
        .x-grid-cell-error
        {
            background: #FFFF99;
        }
    </style>
</head>
<body>

    <script type="text/javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });

    var MsgList = {
			SaveButton:{
				BeforeTitle:"正在上传文件",
				BeforeMsg:"文件上传",
				FailureTitle:"错误",
				FailureMsg:"上传中发生错误"
			},
			ImportButton:{
				BeforeTitle:"正在处理数据",
				BeforeMsg:"处理订单数据"
			}
        }


        //最初的版本请参考InventoryInit.aspx
        
        var editId = '';
        var editControls = [
                          { name: 'SapCode', field: { xtype: "textfield", width: 160, maxLength: 50, allowBlank: false} },
                          { name: 'WarehouseTo', field: {xtype:"textfield",width:160,maxLength:50,allowBlank:false} },
                          { name: 'ArticleNumber', field: {xtype:"textfield",width:100,maxLength:50,allowBlank:false} },
                          { name: 'LotNumber', field: {xtype:"textfield",width:100,maxLength:50,allowBlank:false} },
                          { name: 'QRCode', field: {xtype:"textfield",width:100,maxLength:50,allowBlank:false} },
                          { name: 'TransferQty', field: {xtype:"numberfield",width:90,allowBlank:false,minValue:1.0,maxValue:99999999.0,allowNegative:false,allowDecimals:false,inputType:"text"} }
                        ];

                          var renderData = function(value, meta, record, row, col, store) {

                          if (record.get(meta.id) != null && record.get(meta.id) != '') {
                                  meta.css = "x-grid-cell-error";
                                  meta.attr = 'ext:qtip="' + record.get(meta.id) + '"';
                              }
                              if (editId == record.id) {
                                  return "<div id='div" + meta.id + "'><\/div>";
                              }
                            
                              return value;
                          } 
        
        var renderControl = function(item){
            var config = Ext.apply({},item.field,{id: 'tb' + item.name, renderTo: 'div' + item.name });
            switch(config.xtype){
                case 'textfield':return new Ext.form.TextField(config);                
                case 'datefield':return new Ext.form.DateField(config);
                case 'numberfield':return new Ext.form.NumberField(config);
                default:
            }
        }
        
        var renderEditControls=function(record){
                Ext.each(editControls, function(item){
                    renderControl(item);
                    Ext.getCmp('tb'+item.name).setValue(record.get(item.name));
                });
        }
        
        var checkValid = function(){

            for (var i = 0; i < editControls.length; i++ ){
                if (!Ext.getCmp('tb'+editControls[i].name).isValid())
                    return false;
            }
            
            return true;
        }
        
        var rowCommand = function(command, record, row){
            if (command == "Edit"){
                editId = record.id;
                Ext.getCmp('<%=this.GridPanel3.ClientID %>').getView().refresh(true);
                renderEditControls(record);                
            }
            else if (command == "Cancel"){
                editId = '';
                Ext.getCmp('<%=this.GridPanel3.ClientID %>').getView().refresh(true);
            }   
            else if (command == "Save"){
                var tbWarehouseFrom = Ext.getCmp('tbWarehouseFrom');
                var tbWarehouseTo = Ext.getCmp('tbWarehouseTo');
                var tbArticleNumber = Ext.getCmp('tbArticleNumber');
                var tbTransferQty = Ext.getCmp('tbTransferQty');
                var tbLotNumber = Ext.getCmp('tbLotNumber');
               
                var tbQrCode=Ext.getCmp('tbQRCode');
               
                if (checkValid())
                {
                    Coolite.AjaxMethods.Save(
                        record.id,
                        tbWarehouseFrom.getValue(),
                        tbWarehouseTo.getValue(),
                        tbArticleNumber.getValue(),
                        tbTransferQty.getValue(),
                        tbLotNumber.getValue(),
                        tbQrCode.getValue(),
                        {
                            success: function(){
                                Ext.each(editControls, function(item){
                                    record.set(item.name,Ext.getCmp('tb'+item.name).getRawValue());
                                    record.set(item.name+'ErrMsg',null);
                                });
                                record.commit();
                                
                                editId = '';
                                Ext.getCmp('<%=this.GridPanel3.ClientID %>').getView().refresh(true);
                                //renderEditControls(record);    
                            },
                            failure: function(err){
                                Ext.Msg.alert('Error', err);
                            }                            
                        }
                    );
                }
            }else if (command == "Delete"){
                Coolite.AjaxMethods.Delete(
                    record.id,
                    {
                        success: function(){
                            editId = '';
                            Ext.getCmp('<%=this.GridPanel3.ClientID %>').deleteSelected();
                        },
                        failure: function(err){
                            Ext.Msg.alert('Error', err);
                        }
                    }
                );
            }
            
        }   
        
        var prepareCommand = function(grid, command, record, row) {
            command.hidden = true;
          
            if (editId == record.id){
                if (command.command == "Save" || command.command == "Cancel"){
                    command.hidden = false;
                }
            }else{
                if (command.command == "Delete" || command.command == "Edit"){
                    command.hidden = false;
                }
            }
        }        
    </script>

    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData"
            WarningOnDirty="false" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="SapCode" />
                        <ext:RecordField Name="OrderNo" />
                        <ext:RecordField Name="SapDeliveryNo" />
                        <ext:RecordField Name="SapDeliveryDate" />
                        <ext:RecordField Name="ShippingDate" />
                        <ext:RecordField Name="ToWhmCode" />
                        <ext:RecordField Name="ArticleNumber" />
                        <ext:RecordField Name="SapDeliveryLineNbr" />
                        <ext:RecordField Name="LotNumber" />
                        <ext:RecordField Name="ImportDate" />
                        <ext:RecordField Name="ClientID" />
                        <ext:RecordField Name="BatchNbr" />
                        <ext:RecordField Name="ShipmentType" />
                        <ext:RecordField Name="UnitPrice" />
                        <ext:RecordField Name="WHMName" />
                        <ext:RecordField Name="QRCode" />
                        <ext:RecordField Name="ProblemDescription" />
                        <ext:RecordField Name="DeliveryQty" />
                        <ext:RecordField Name="LineNbr" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden runat="server" ID="HiddbatchNumber">
        </ext:Hidden>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Title="平台收货数据批量上传"
                            AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;"
                            ButtonAlign="Left">
                            <Defaults>
                                <ext:Parameter Name="anchor" Value="50%" Mode="Value" />
                                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                            </Defaults>
                            <Body>
                                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="50">
                                    <ext:Anchor>
                                        <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择导入文件" FieldLabel="文件"
                                            ButtonText="" Icon="ImageAdd">
                                        </ext:FileUploadField>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                            <Listeners>
                                <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                            </Listeners>
                            <Buttons>
                                <ext:Button ID="SaveButton" runat="server" Text="上传">
                                    <AjaxEvents>
                                        <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                                    Ext.Msg.wait(MsgList.SaveButton.BeforeTitle, MsgList.SaveButton.BeforeMsg);"
                                            Failure="Ext.Msg.show({ 
                                                    title   : MsgList.SaveButton.FailureTitle, 
                                                    msg     : MsgList.SaveButton.FailureMsg, 
                                                    minWidth: 200, 
                                                    modal   : true, 
                                                    icon    : Ext.Msg.ERROR, 
                                                    buttons : Ext.Msg.OK 
                                                });" Success="#{ImportButton}.setDisabled(false);#{SaveButton}.setDisabled(true);#{PagingToolBar1}.changePage(1);">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="ResetButton" runat="server" Text="清除">
                                    <Listeners>
                                        <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);#{ImportButton}.setDisabled(true);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="DownloadButton" runat="server" Text="下载模板">
                                    <Listeners>
                                        <Click Handler="window.open('../../Upload/ExcelTemplate/Template_LPRLD_Delivery.xls')" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel9" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="GridPanel3" runat="server" Title="列表" StoreID="ResultStore" Border="false"
                                        Icon="Error" AutoWidth="true" StripeRows="true" EnableHdMenu="false">
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="LineNbr" DataIndex="LineNbr" Header="行号" Sortable="false" Width="20px">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProblemDescription" DataIndex="ProblemDescription" Width="250px"
                                                    Header="错误信息" Sortable="false">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="二级经销商编号" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="SapDeliveryNo" DataIndex="SapDeliveryNo" Header="二级经销商采购单编号"
                                                    Sortable="false" Width="100px">
                                                </ext:Column>
                                                <ext:Column ColumnID="SapDeliveryNo" DataIndex="SapDeliveryNo" Header="物流平台或RLD发货单编号"
                                                    Sortable="false" Width="150px">
                                                </ext:Column>
                                                <ext:Column ColumnID="SapDeliveryDate" DataIndex="SapDeliveryDate" Header="发货日期"
                                                    Sortable="false" Width="150px">
                                                </ext:Column>
                                                <ext:Column ColumnID="ShipmentType" DataIndex="ShipmentType" Header="销售类型" Sortable="false"
                                                    Width="150px">
                                                </ext:Column>
                                                <ext:Column ColumnID="ArticleNumber" DataIndex="ArticleNumber" Header="产品UPN" Sortable="false"
                                                    Width="150px">
                                                </ext:Column>
                                                <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="产品批号" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="QRCode" DataIndex="QRCode" Header="二维码" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="DeliveryQty" DataIndex="DeliveryQty" Header="发货数量" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="UnitPrice" DataIndex="UnitPrice" Header="发货产品价格(含税单价)" Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="WHMName" DataIndex="WHMName" Header="二级商寄售仓库" Sortable="false">
                                                </ext:Column>
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
                                        <LoadMask ShowMask="true" Msg="正在获取数据" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Hidden ID="hidFileName" runat="server">
        </ext:Hidden>
    </div>
    </form>
</body>
</html>
