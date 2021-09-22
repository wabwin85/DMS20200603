<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeliveryInit.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.DeliveryInit" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>发货数据上传</title>
    <link href="../../../../resources/css/examples.css" rel="stylesheet" type="text/css" />
    
 
    <style type="text/css">
        #fi-button-msg {
            border: 2px solid #ccc;
            padding: 5px 10px;
            background: #eee;
            margin: 5px;
            float: left;
        }
    </style>
    
    <script type="text/javascript">
        var MsgList = {
			SaveButton:{
				BeforeTitle:"<%=GetLocalResourceObject("form1.SaveButton.Wait.Title").ToString()%>",
				BeforeMsg:"<%=GetLocalResourceObject("form1.SaveButton.Wait.Body").ToString()%>",
				FailureTitle:"<%=GetLocalResourceObject("form1.SaveButton.Alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("form1.SaveButton.Alert.Body").ToString()%>"
			},
			ImportButton:{
				BeforeTitle:"<%=GetLocalResourceObject("form1.ImportButton.Wait.Title").ToString()%>",
				BeforeMsg:"<%=GetLocalResourceObject("form1.ImportButton.Wait.Body").ToString()%>"
			}
        }

        var showFile = function (fb, v) {
            var el = Ext.fly('fi-button-msg');
            el.update('<b>Selected:</b> ' + v);
            if (!el.isVisible()) {
                el.slideIn('t', {
                    duration: .2,
                    easing: 'easeIn',
                    callback: function() {
                        el.highlight();
                    }
                });
            } else {
                el.highlight();
            }
        }            
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        <ext:Store ID="ResultStore" runat="server" 
            OnRefreshData="ResultStore_RefershData" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                     <ext:RecordField Name="Id" />
                     <ext:RecordField Name="User" />
                     <ext:RecordField Name="UploadDate" />
                     <ext:RecordField Name="LineNbr" />
                     <ext:RecordField Name="ErrorFlag" />
                     <ext:RecordField Name="ErrorDescription" />
                     <ext:RecordField Name="SapCode" />
                     <ext:RecordField Name="OrderNo" />
                     <ext:RecordField Name="ArticleNo" />
                     <ext:RecordField Name="LotNumber" />
                     <ext:RecordField Name="ExpiredDate"/>
                     <ext:RecordField Name="SapDeliveryNo" />
                     <ext:RecordField Name="ShippingDate" Type="Date"/>
                     <ext:RecordField Name="Carrier" />
                     <ext:RecordField Name="TrackingNo" />
                     <ext:RecordField Name="DeliveryQty" />
                     <ext:RecordField Name="ShipType" />
                     <ext:RecordField Name="Note" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="LineNbr" Direction="ASC" />
        </ext:Store>
        <ext:Hidden ID="hiddenFileName" runat="server"></ext:Hidden>
        <ext:FormPanel 
            ID="BasicForm" 
            runat="server"
            Width="500"
            Frame="true"
            Title="<%$ Resources: form1.BasicForm.Title %>"
            AutoHeight="true"
            MonitorValid="true"
            BodyStyle="padding: 10px 10px 0 10px;">                
            <Defaults>
                <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
            </Defaults>
            <Body>
                <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="50">

                    <ext:Anchor>
                        <ext:FileUploadField 
                            ID="FileUploadField1" 
                            runat="server" 
                            EmptyText="<%$ Resources: form1.FileUploadField1.EmptyText %>"
                            FieldLabel="<%$ Resources: form1.FileUploadField1.FieldLabel %>"
                            ButtonText=""
                            Icon="ImageAdd">
                        </ext:FileUploadField>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Listeners>
                <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
            </Listeners>
            <Buttons>
                <ext:Button ID="ResetButton" runat="server" Text="<%$ Resources: form1.ResetButton.Text %>">
                    <Listeners>
                        <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);#{ImportButton}.setDisabled(true);" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: form1.SaveButton.Text %>">
                    <AjaxEvents>
                        <Click 
                            OnEvent="UploadClick"
                            Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                Ext.Msg.wait(MsgList.SaveButton.BeforeTitle, MsgList.SaveButton.BeforeMsg);"
                                
                            Failure="Ext.Msg.show({ 
                                title   : MsgList.SaveButton.FailureTitle, 
                                msg     : MsgList.SaveButton.FailureMsg, 
                                minWidth: 200, 
                                modal   : true, 
                                icon    : Ext.Msg.ERROR, 
                                buttons : Ext.Msg.OK 
                            });"
                            Success="#{ImportButton}.setDisabled(false);"
                            >
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="ImportButton" runat="server" Text="<%$ Resources: form1.ImportButton.Text %>">
                    <AjaxEvents>
                        <Click 
                            OnEvent="ImportClick" 
                            Before="Ext.Msg.wait(MsgList.ImportButton.BeforeTitle, MsgList.ImportButton.BeforeTitle.BeforeMsg);"
                        >
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="DownloadButton" runat="server" Text="<%$ Resources: form1.DownloadButton.Text %>" >
                    <Listeners>
                        <Click Handler="window.open('../../Upload/ExcelTemplate/Template_Delivery.xls')" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            
            
            
        </ext:FormPanel>
        <ext:Panel ID="Panel2" runat="server" Height="365" Header="false">
            <Body>
                <ext:FitLayout ID="FitLayout1" runat="server">
                    <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>" StoreID="ResultStore" Border="false" Icon="Error" AutoWidth="true" StripeRows="true">
                        <ColumnModel ID="ColumnModel1" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="LineNbr" DataIndex="LineNbr" Header="<%$ Resources: GridPanel1.ColumnModel1.LineNbr.Header %>" Width="50">                                                    
                                    </ext:Column>
                                    <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="<%$ Resources: GridPanel1.ColumnModel1.SapCode.Header %>">                                                    
                                    </ext:Column>
                                    <ext:Column ColumnID="OrderNo" DataIndex="OrderNo" Header="<%$ Resources: GridPanel1.ColumnModel1.OrderNo.Header %>">                                                    
                                    </ext:Column>
                                    <ext:Column ColumnID="ArticleNo" DataIndex="ArticleNo" Header="<%$ Resources: resource,Lable_Article_Number  %>">                                                    
                                    </ext:Column>
                                    <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: GridPanel1.ColumnModel1.LotNumber.Header %>">                                                    
                                    </ext:Column>
                                    <ext:Column ColumnID="SapDeliveryNo" DataIndex="SapDeliveryNo" Header="<%$ Resources: GridPanel1.ColumnModel1.SapDeliveryNo.Header %>">                                                    
                                    </ext:Column>
                                    <ext:Column ColumnID="ShippingDate" DataIndex="ShippingDate" Header="<%$ Resources: GridPanel1.ColumnModel1.ShippingDate.Header %>">   
                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />                                                 
                                    </ext:Column>
                                    <ext:Column ColumnID="Carrier" DataIndex="Carrier" Header="<%$ Resources: GridPanel1.ColumnModel1.Carrier.Header %>">                                                    
                                    </ext:Column>
                                    <ext:Column ColumnID="TrackingNo" DataIndex="TrackingNo" Header="<%$ Resources: GridPanel1.ColumnModel1.TrackingNo.Header %>">                                                    
                                    </ext:Column>
                                    <ext:Column ColumnID="DeliveryQty" DataIndex="DeliveryQty" Header="<%$ Resources: GridPanel1.ColumnModel1.DeliveryQty.Header %>">                                                    
                                    </ext:Column>
                                    <ext:Column ColumnID="ShipType" DataIndex="ShipType" Header="<%$ Resources: GridPanel1.ColumnModel1.ShipType.Header %>">                                                    
                                    </ext:Column>
                                    <ext:Column ColumnID="Note" DataIndex="Note" Header="<%$ Resources: GridPanel1.ColumnModel1.Note.Header %>">                                                    
                                    </ext:Column>
                                    <ext:Column ColumnID="ErrorDescription" DataIndex="ErrorDescription" Header="<%$ Resources: GridPanel1.ColumnModel1.ErrorDescription.Header %>" Hidden="true">                                                    
                                    </ext:Column>
                                </Columns>
                        </ColumnModel>     
                        <View>
                            <ext:GridView runat="server" EnableRowBody="true">
                                <GetRowClass Handler="rowParams.body = '<p><font color=\'red\'>' + record.data.ErrorDescription + '</font></p>';" />
                            </ext:GridView>
                        </View>                               
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                            </ext:RowSelectionModel>
                        </SelectionModel>
                        <BottomBar>
                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                DisplayInfo="false" />
                        </BottomBar>
                        <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                    </ext:GridPanel>
                </ext:FitLayout>
            </Body>
        </ext:Panel>
    </form>
</body>
</html>