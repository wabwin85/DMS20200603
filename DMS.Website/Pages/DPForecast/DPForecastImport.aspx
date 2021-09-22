<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DPForecastImport.aspx.cs" Inherits="DMS.Website.Pages.DPForecast.DPForecastImport" %>


<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Inventory Init</title>
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

        var editId = '';

        var renderPFA_ForecastVersion = function (value, meta, record, row, col, store) {
            if (record.data.PFA_ForecastVersion_ErrMsg != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.data.PFA_ForecastVersion_ErrMsg + '"';
            }
            if (editId == record.id) {
                return "<div id='divPFA_ForecastVersion'><\/div>";
            }
            return value;
        }

        var renderPFA_DMA = function (value, meta, record, row, col, store) {
            if (record.data.PFA_DMA_ErrMsg != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.data.PFA_DMA_ErrMsg + '"';
            }
            if (editId == record.id) {
                return "<div id='divPFA_DMA'><\/div>";
            }
            return value;
        }

        var renderPFA_UPN = function (value, meta, record, row, col, store) {
            if (record.data.PFA_UPN_ErrMsg != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.data.PFA_UPN_ErrMsg + '"';
            }
            if (editId == record.id) {
                return "<div id='divPFA_UPN'><\/div>";
            }
            return value;
        }

        var renderPFA_Forecast_M1 = function (value, meta, record, row, col, store) {
            if (record.data.PFA_Forecast_M1_ErrMsg != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.data.PFA_Forecast_M1_ErrMsg + '"';
            }
            if (editId == record.id) {
                return "<div id='divPFA_Forecast_M1'><\/div>";
            }
            return value;
        }

        var renderPFA_Forecast_M2 = function (value, meta, record, row, col, store) {
            if (record.data.PFA_Forecast_M2_ErrMsg != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.data.PFA_Forecast_M2_ErrMsg + '"';
            }
            if (editId == record.id) {
                return "<div id='divPFA_Forecast_M2'><\/div>";
            }
            return value;
        }

        var renderPFA_Forecast_M3 = function (value, meta, record, row, col, store) {
            if (record.data.PFA_Forecast_M3_ErrMsg != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.data.PFA_Forecast_M3_ErrMsg + '"';
            }
            if (editId == record.id) {
                return "<div id='divPFA_Forecast_M3'><\/div>";
            }
            return value;
        }

        var renderPFA_ForecastAdj_M1 = function (value, meta, record, row, col, store) {
            if (record.data.PFA_ForecastAdj_M1_ErrMsg != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.data.PFA_ForecastAdj_M1_ErrMsg + '"';
            }
            if (editId == record.id) {
                return "<div id='divPFA_ForecastAdj_M1'><\/div>";
            }
            return value;
        }

        var renderPFA_ForecastAdj_M2 = function (value, meta, record, row, col, store) {
            if (record.data.PFA_ForecastAdj_M2_ErrMsg != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.data.PFA_ForecastAdj_M2_ErrMsg + '"';
            }
            if (editId == record.id) {
                return "<div id='divPFA_ForecastAdj_M2'><\/div>";
            }
            return value;
        }

        var renderPFA_ForecastAdj_M3 = function (value, meta, record, row, col, store) {
            if (record.data.PFA_ForecastAdj_M3_ErrMsg != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.data.PFA_ForecastAdj_M3_ErrMsg + '"';
            }
            if (editId == record.id) {
                return "<div id='divPFA_ForecastAdj_M3'><\/div>";
            }
            return value;
        }


        function close() {

            window.location.href = "/pages/order/purchasingforecastreport.aspx";



        }

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />

        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData" AutoLoad="false" WarningOnDirty="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="II_ID">
                    <Fields>
                        <ext:RecordField Name="II_ID" />
                        <ext:RecordField Name="II_LineNbr" />
                        <ext:RecordField Name="PFA_ForecastVersion" />
                        <ext:RecordField Name="DivisionName" />
                        <ext:RecordField Name="PFA_BU" />
                        <ext:RecordField Name="PFA_DMA_PARENT" />
                        <ext:RecordField Name="PFA_DMA" />
                        <ext:RecordField Name="PFA_UPN" />
                        <ext:RecordField Name="PFA_UPNDescription" />
                        <ext:RecordField Name="PFA_ProductGroup" />
                        <ext:RecordField Name="PFA_ProductSubGroup" />
                        <ext:RecordField Name="PFA_Forecast_M1" />
                        <ext:RecordField Name="PFA_Forecast_M2" />
                        <ext:RecordField Name="PFA_Forecast_M3" />
                        <ext:RecordField Name="PFA_ForecastAdj_M1" />
                        <ext:RecordField Name="PFA_ForecastAdj_M2" />
                        <ext:RecordField Name="PFA_ForecastAdj_M3" />
                        <ext:RecordField Name="PFA_ForecastAdj_Remark" />
                        <ext:RecordField Name="II_ErrorMsg" />
                        <ext:RecordField Name="PFA_ForecastVersion_ErrMsg" />
                        <ext:RecordField Name="PFA_BU_ErrMsg" />
                        <ext:RecordField Name="PFA_DMA_ErrMsg" />
                        <ext:RecordField Name="PFA_UPN_ErrMsg" />
                        <ext:RecordField Name="PFA_Forecast_M1_ErrMsg" />
                        <ext:RecordField Name="PFA_Forecast_M2_ErrMsg" />
                        <ext:RecordField Name="PFA_Forecast_M3_ErrMsg" />
                        <ext:RecordField Name="PFA_ForecastAdj_M1_ErrMsg" />
                        <ext:RecordField Name="PFA_ForecastAdj_M2_ErrMsg" />
                        <ext:RecordField Name="PFA_ForecastAdj_M3_ErrMsg" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
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
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: form1.BasicForm.Title %>" AutoHeight="true"
                              AutoWidth="true" Frame="true" Border="false">
                            <Body>
                                <ext:Panel ID="Panel3" runat="server" Border="false" BodyStyle="padding: 0 0 10px 0;">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="选择产品线..." Width="200"
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
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                                <ext:FormPanel ID="BasicForm" runat="server" Width="1500" Frame="false"
                                    AutoHeight="true" MonitorValid="true" ButtonAlign="Left" Border="true" LabelWidth="80">
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
                                        <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                                    </Listeners>
                                    <Buttons>
                                        <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: form1.SaveButton.Text %>">
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
                            });"
                                                    Success="#{PagingToolBar1}.changePage(1);">
                                                </Click>
                                            </AjaxEvents>
                                        </ext:Button>
                                        <ext:Button ID="ResetButton" runat="server" Text="<%$ Resources: form1.ResetButton.Text %>">
                                            <Listeners>
                                                <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);"/>
                                            </Listeners>
                                        </ext:Button>
                                        <ext:Button ID="DownloadButton" runat="server" Text="<%$ Resources: form1.DownloadButton.Text %>">
                                            <AjaxEvents>
                                                <Click OnEvent="DownloadClick"></Click>
                                            </AjaxEvents>
                                        </ext:Button>
                                        <ext:Button ID="returnbutton" runat="server" Text="返回">
                                            <Listeners>
                                                <Click Fn="close" />
                                            </Listeners>
                                        </ext:Button>
                                    </Buttons>
                                </ext:FormPanel>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server"
                                        StoreID="ResultStore" Border="false" Icon="Error" AutoWidth="true" StripeRows="true" EnableHdMenu="false">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="II_LineNbr" DataIndex="II_LineNbr" Header="<%$ Resources: GridPanel1.ColumnModel1.LineNumber.Header %>" Sortable="false" Width="40">
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_ForecastVersion" DataIndex="PFA_ForecastVersion" Header="<%$ Resources: GridPanel1.ColumnModel1.ForecastVersion.Header %>" Sortable="false" Width="100">
                                                    <Renderer Fn="renderPFA_ForecastVersion" />
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_BU" DataIndex="PFA_BU" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_BU.Header %>" Sortable="false" Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_DMA_PARENT" DataIndex="PFA_DMA_PARENT" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_DMA_PARENT.Header %>" Sortable="false" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_DMA" DataIndex="PFA_DMA" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_DMA.Header %>" Sortable="false" Width="100">
                                                    <Renderer Fn="renderPFA_DMA" />
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_UPN" DataIndex="PFA_UPN" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_UPN.Header %>" Sortable="false" Width="100">
                                                    <Renderer Fn="renderPFA_UPN" />
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_UPNDescription" DataIndex="PFA_UPNDescription" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_UPNDescription.Header %>" Sortable="false" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_ProductGroup" DataIndex="PFA_ProductGroup" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_ProductGroup.Header %>" Sortable="false" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_ProductSubGroup" DataIndex="PFA_ProductSubGroup" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_ProductSubGroup.Header %>" Sortable="false" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_Forecast_M1" DataIndex="PFA_Forecast_M1" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_Forecast_M1.Header %>" Sortable="false" Width="70">
                                                    <Renderer Fn="renderPFA_Forecast_M1" />
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_Forecast_M2" DataIndex="PFA_Forecast_M2" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_Forecast_M2.Header %>" Sortable="false" Width="70">
                                                    <Renderer Fn="renderPFA_Forecast_M2" />
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_Forecast_M3" DataIndex="PFA_Forecast_M3" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_Forecast_M3.Header %>" Sortable="false" Width="70">
                                                    <Renderer Fn="renderPFA_Forecast_M3" />
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_ForecastAdj_M1" DataIndex="PFA_ForecastAdj_M1" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_ForecastAdj_M1.Header %>" Sortable="false" Width="70">
                                                    <Renderer Fn="renderPFA_ForecastAdj_M1" />
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_ForecastAdj_M2" DataIndex="PFA_ForecastAdj_M2" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_ForecastAdj_M2.Header %>" Sortable="false" Width="70">
                                                    <Renderer Fn="renderPFA_ForecastAdj_M2" />
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_ForecastAdj_M3" DataIndex="PFA_ForecastAdj_M3" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_ForecastAdj_M3.Header %>" Sortable="false" Width="70">
                                                    <Renderer Fn="renderPFA_ForecastAdj_M3" />
                                                </ext:Column>
                                                <ext:Column ColumnID="PFA_ForecastAdj_Remark" DataIndex="PFA_ForecastAdj_Remark" Header="<%$ Resources: GridPanel1.ColumnModel1.PFA_ForecastAdj_Remark.Header %>" Sortable="false" Width="100">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server" MoveEditorOnEnter="false">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="100" StoreID="ResultStore" DisplayInfo="false">
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
        <ext:Hidden ID="hiddenFileName" runat="server"></ext:Hidden>
    </form>
    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>
</body>
</html>

