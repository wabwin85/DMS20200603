<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShipmentQRCode.aspx.cs" Inherits="DMS.Website.Pages.Shipment.ShipmentQRCode" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .list-item
        {
            font: normal 9px tahoma, arial, helvetica, sans-serif;
            padding: 1px 1px 1px 1px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #bbbbbb;
        }
        .list-item h3
        {
            display: block;
            font: inherit;
            font-weight: normal;
            font-size: 12px;
            color: #222;
        }
        .fillFont
        {
            color: Red;
            font-weight: bold;
        }
        .normalFont
        {
            color: Black;
            font-weight: normal;
        }
    </style>
    <script type="text/javascript" language="javascript">
        function ChangeDealer() {
            var cbProductLine = Ext.getCmp('cbProductLine');
            var cbHospital = Ext.getCmp('cbHospital');

            cbProductLine.clearValue();
            cbHospital.clearValue();
            cbProductLine.store.reload();
            cbHospital.store.removeAll();
        }

        function ChangeProductLine() {
            var cbHospital = Ext.getCmp('cbHospital');

            cbHospital.clearValue();
            cbHospital.store.reload();
        }

        function ShowPrintDialog() {
            var hiddenCfnChineseName = Ext.getCmp('hiddenCfnChineseName');
            var hiddenCfnEnglishName = Ext.getCmp('hiddenCfnEnglishName');
            var hiddenQrPath = Ext.getCmp('hiddenQrPath');
            var txtLotNumber = Ext.getCmp('txtLotNumber');
            var txtSerialNumbe = Ext.getCmp('txtSerialNumbe');

            window.open("ShipmentQrPrint.aspx?ChineseName=" + hiddenCfnChineseName.getValue()
            + "&EnglishName=" + hiddenCfnEnglishName.getValue()
            + "&LotNumber=" + txtLotNumber.getValue() 
            + "&SerialNumbe=" + txtSerialNumbe.getValue()
            + "&QrPath=" + hiddenQrPath.getValue(), 'newwindow',
           'status=no,width=400px,height=250px,scrollbars=yes,resizable=yes,location=no,top=50,left=100');

        }
        
        function SelectDealerValue(e) {
            var filterField = 'ChineseName';  //需进行模糊查询的字段
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var value = e.query;
                if (value != null && value != '') {
                    combo.store.filterBy(function(record, id) {
                        var text = record.get(filterField);
                        value = value.replace(/\s/g, '');
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

        function SelectHospitalValue(e) {
            var filterField = 'Name';  //需进行模糊查询的字段
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var value = e.query;
                if (value != null && value != '') {
                    combo.store.filterBy(function(record, id) {
                        var text = record.get(filterField);
                        value = value.replace(/\s/g, '');
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
    <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="ChineseName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <Load Handler="" />
        </Listeners>
    </ext:Store>
    <ext:store ID="ProductLineStore" runat="server" UseIdConfirmation="true" AutoLoad="false" OnRefreshData="Store_RefreshProductLine">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="AttributeName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:store>
    <ext:Store ID="HospitalStore" runat="server" UseIdConfirmation="true" AutoLoad="false" OnRefreshData="Store_RefreshHospital">
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="ShortName" />
                    <ext:RecordField Name="Address" />
                    <ext:RecordField Name="Town" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hiddenDealerId" runat="server"></ext:Hidden>
    <ext:Hidden ID="hiddenHospitalId" runat="server"></ext:Hidden>
    <ext:Hidden ID="hiddenCrmFlag" runat="server"></ext:Hidden>
    <ext:Hidden ID="hiddenQrPath" runat="server"></ext:Hidden>
    
    <ext:Hidden ID="hiddenCfnChineseName" runat="server"></ext:Hidden>
    <ext:Hidden ID="hiddenCfnEnglishName" runat="server"></ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="mainPalen" runat="server" Header="false" AutoHeight="true" Border="false" >
                        <Body>
                            <ext:FormPanel ID="FormPanel1" runat="server" Title="二维码生成" AutoHeight="true" BodyStyle="padding: 5px;"
                                Frame="true" Icon="Find" >
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择经销商"
                                                                Width="220" Editable="true" TypeAhead="true" StoreID="DealerStore" ValueField="Id" AllowBlank="false" 
                                                                DisplayField="ChineseName" Mode="Local" ListWidth="300" Resizable="true" FieldLabel="经销商" LabelCls="fillFont">
                                                                <Listeners>
                                                                    <BeforeQuery Fn="SelectDealerValue" />
                                                                    <Select Handler="ChangeDealer();" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="请选择产品线" Width="150"
                                                                Editable="true" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" AllowBlank="false" 
                                                                ListWidth="300" Resizable="true" DisplayField="AttributeName" FieldLabel="产品线" LabelCls="fillFont">
                                                                <Listeners>
                                                                    <Select Handler="ChangeProductLine();" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbHospital" runat="server" EmptyText="请选择医院" Width="150"
                                                                Editable="true" TypeAhead="true" StoreID="HospitalStore" ValueField="Id" AllowBlank="false" 
                                                                ListWidth="300" Resizable="true" DisplayField="Name" FieldLabel="医院" LabelCls="fillFont">
                                                                <Listeners>
                                                                    <BeforeQuery Fn="SelectHospitalValue" />
                                                                </Listeners>   
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtBarcode" runat="server" FieldLabel="条形码" LabelCls="fillFont" EmptyText="请扫描条形码" AllowBlank="false" >
                                                                <Listeners>
                                                                    <Change Handler="Coolite.AjaxMethods.BarCode(this.getValue(),{success: function(msg) {if(msg!=''){Ext.Msg.alert('Message', msg);}},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                                                                </Listeners>
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtType" runat="server" FieldLabel="条形码类型" ReadOnly="true" AllowBlank="false" >
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtIdentifierFalg" runat="server" FieldLabel="唯一标识" ReadOnly="true" AllowBlank="false" >
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtLotNumber" runat="server" FieldLabel="产品批号" ReadOnly="true" AllowBlank="false" >
                                                                <Listeners>
                                                                    <Change Handler="Coolite.AjaxMethods.SynLotNumber({success: function() {},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                                                                </Listeners>
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:DateField ID="dfCreateDate" runat="server" FieldLabel="生产日期" LabelCls="fillFont" AllowBlank="false" >
                                                                <Listeners>
                                                                    <Change Handler="Coolite.AjaxMethods.SynCreateDate({success: function() {},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                                                                </Listeners>
                                                            </ext:DateField>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel2" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:DateField ID="dfEffectiveDate" runat="server" FieldLabel="有效期" Disabled="true" AllowBlank="false" >
                                                            </ext:DateField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtSerialNumbe" runat="server" FieldLabel="产品序号" ReadOnly="true" AllowBlank="false" >
                                                            </ext:TextField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextArea ID="trQrCode" runat="server" FieldLabel="二维码序号" ReadOnly="true" Width="129"  >
                                                            </ext:TextArea>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                            </ext:FormPanel>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnCreateQrCode" Text="生成二维码序号" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                <Listeners>
                                    <Click Handler="if(!#{FormPanel1}.getForm().isValid()){Ext.Msg.alert('Message', '请填写完整！');}else{ Coolite.AjaxMethods.CreateQrCode();}" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnCreateQr" Text="生成二维码" runat="server" Icon="ArrowRefresh" IDMode="Legacy" >
                                <Listeners>
                                    <Click Handler="if(#{trQrCode}.getValue()!=''){Coolite.AjaxMethods.CreateImageQrPath({success: function() { Coolite.AjaxMethods.CreateQr({success: function() {ShowPrintDialog();},failure: function(err) {ShowPrintDialog();}});}});}else{Ext.Msg.alert('Message', '请先生成二维码序号！');}" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </Center>
                <South MarginsSummary="0 5 0 5">
                    
                </South>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>
    </form>
</body>
</html>
