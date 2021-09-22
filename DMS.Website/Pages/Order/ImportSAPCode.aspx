<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ImportSAPCode.aspx.cs"
    Inherits="DMS.Website.Pages.Order.ImportSAPCode" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Import ERP Code</title>
   
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
                    <ext:RecordField Name="InvoiceDateErrMsg" />
                    <ext:RecordField Name="HospitalNameErrMsg" />
                    <ext:RecordField Name="LotShipmentDate" />
                    <ext:RecordField Name="Remark" />
                    <ext:RecordField Name="LotShipmentDateErrMsg" />
                    <ext:RecordField Name="RemarkErrMsg" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Title="经销商编码导入"
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
                                    <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="请选择导入文件（Excel格式)"
                                        FieldLabel="文件" ButtonText="" Icon="ImageAdd">
                                    </ext:FileUploadField>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                        <Listeners>
                            <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                        </Listeners>
                        <Buttons>
                            <ext:Button ID="SaveButton" runat="server" Text="导入">
                               
                            </ext:Button>
                            <ext:Button ID="ImportButton" runat="server" Text="导入" Hidden="true">
                                <AjaxEvents>
                                    <Click OnEvent="UploadConfirm" Success="Confirm();">
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                            <ext:Button ID="DownloadButton" runat="server" Text="下载模板">
                                <Listeners>
                                    <Click Handler="window.open('../../Upload/ExcelTemplate/Template_ShipmentImport.xls')" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="ExportButton" runat="server" Text="导出上传的数据"></ext:Button>
                        </Buttons>
                    </ext:FormPanel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="导入信息" StoreID="ResultStore"
                                    Border="false" Icon="Error" AutoWidth="true" StripeRows="true" EnableHdMenu="false">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="LineNbr" DataIndex="LineNbr" Header="行号" Sortable="false" Width="50">
                                            </ext:Column>
                                            <ext:Column ColumnID="HospitalCode" DataIndex="HospitalCode" Header="经销商编码(ERP Code)"
                                                Sortable="false" Width="220">
                                               
                                            </ext:Column>
                                            <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="经销商名称" Sortable="false"
                                                Width="280">
                                              
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
                                           
                                            </ext:ImageCommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server"
                                            MoveEditorOnEnter="false">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                       
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="100" StoreID="ResultStore"
                                            DisplayInfo="false">
                                            <Listeners>
                                                <BeforeChange Handler="editId=''" />
                                            </Listeners>
                                        </ext:PagingToolbar>
                                    </BottomBar>
                                    <LoadMask ShowMask="true" Msg="load" />
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
