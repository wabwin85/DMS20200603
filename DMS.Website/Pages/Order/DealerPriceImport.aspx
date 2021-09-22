<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerPriceImport.aspx.cs"
    Inherits="DMS.Website.Pages.Order.DealerPriceImport" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>
        <%=GetLocalResourceObject("Head1.Title").ToString()%></title>
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
            SaveButton: {
                BeforeTitle: '<%=GetLocalResourceObject("SaveButton.Before.Ext.Msg.wait.Body").ToString()%>',
                BeforeMsg: '<%=GetLocalResourceObject("SaveButton.Before.Ext.Msg.wait.Title").ToString()%>',
                FailureTitle: '<%=GetLocalResourceObject("SaveButton.Failure.Ext.Msg.show.Title").ToString()%>',
                FailureMsg: '<%=GetLocalResourceObject("SaveButton.Failure.Ext.Msg.show.msg").ToString()%>'
            },
            ImportButton: {
                BeforeTitle: '<%=GetLocalResourceObject("ImportButton.Before.Ext.Msg.wait.Body").ToString()%>',
                BeforeMsg: '<%=GetLocalResourceObject("ImportButton.Before.Ext.Msg.wait.Title").ToString()%>'
            }
        }

        //最初的版本请参考InventoryInit.aspx
        var editId = '';
        var editControls = [
                          { name: 'DPI_ArticleNumber', field: { xtype: "textfield", width: 90, maxLength: 50, allowBlank: false} },
                          { name: 'DPI_Dealer', field: { xtype: "textfield", width: 140, maxLength: 50, allowBlank: true} },
                          { name: 'DPI_Price', field: { xtype: "numberfield", width: 90, allowBlank: false, minValue: 0, maxValue: 99999999.0, allowNegative: false, allowDecimals: true, inputType: "text"} },
                          { name: 'DPI_PriceTypeName', field: { xtype: "textfield", width: 140, maxLength: 50, allowBlank: false} }
                        ];

        var renderData = function(value, meta, record, row, col, store) {
            if (record.get(meta.id + '_ErrMsg') != null && record.get(meta.id + '_ErrMsg') != '') {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.get(meta.id + '_ErrMsg') + '"';
            }
            if (editId == record.id) {
                return "<div id='div" + meta.id + "'><\/div>";
            }
            return value;
        }

        var renderControl = function(item) {
            var config = Ext.apply({}, item.field, { id: 'tb' + item.name, renderTo: 'div' + item.name });
            switch (config.xtype) {
                case 'textfield': return new Ext.form.TextField(config);
                case 'datefield': return new Ext.form.DateField(config);
                case 'numberfield': return new Ext.form.NumberField(config);
                default:
            }
        }

        var renderEditControls = function(record) {
            Ext.each(editControls, function(item) {
                renderControl(item);
                Ext.getCmp('tb' + item.name).setValue(record.get(item.name));
            });
        }

        var checkValid = function() {

            for (var i = 0; i < editControls.length; i++) {
                if (!Ext.getCmp('tb' + editControls[i].name).isValid())
                    return false;
            }

            return true;
        }

        var rowCommand = function(command, record, row) {
            if (command == "Edit") {
                editId = record.id;
                Ext.getCmp('<%=this.GridPanel3.ClientID %>').getView().refresh(true);
                renderEditControls(record);
            }
            else if (command == "Cancel") {
                editId = '';
                Ext.getCmp('<%=this.GridPanel3.ClientID %>').getView().refresh(true);
            }
            else if (command == "Save") {
                var tbDPI_ArticleNumber = Ext.getCmp('tbDPI_ArticleNumber');
                var tbDPI_Dealer = Ext.getCmp('tbDPI_Dealer');
                var tbDPI_Price = Ext.getCmp('tbDPI_Price');
                var tbDPI_PriceTypeName = Ext.getCmp('tbDPI_PriceTypeName');

                if (checkValid()) {
                    Coolite.AjaxMethods.Save(
                        record.id,
                        tbDPI_ArticleNumber.getValue(),
                        tbDPI_Dealer.getValue(),
                        tbDPI_Price.getValue(),
                        tbDPI_PriceTypeName.getValue(),
                        {
                            success: function() {
                                Ext.each(editControls, function(item) {
                                    record.set(item.name, Ext.getCmp('tb' + item.name).getRawValue());
                                    record.set(item.name + '_ErrMsg', null);
                                });
                                record.commit();

                                editId = '';
                                Ext.getCmp('<%=this.GridPanel3.ClientID %>').getView().refresh(true);
                                //renderEditControls(record);    
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                    );
                }
            } else if (command == "Delete") {
                Coolite.AjaxMethods.Delete(
                    record.id,
                    {
                        success: function() {
                            editId = '';
                            Ext.getCmp('<%=this.GridPanel3.ClientID %>').deleteSelected();
                        },
                        failure: function(err) {
                            Ext.Msg.alert('Error', err);
                        }
                    }
                );
            }

        }

        var prepareCommand = function(grid, command, record, row) {
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
                <ext:JsonReader ReaderID="DPI_ID">
                    <Fields>
                        <ext:RecordField Name="DPI_ID" />
                        <ext:RecordField Name="DPI_USER" />
                        <ext:RecordField Name="DPI_UploadDate" />
                        <ext:RecordField Name="DPI_LineNbr" />
                        <ext:RecordField Name="DPI_FileName" />
                        <ext:RecordField Name="DPI_ErrorFlag" />
                        <ext:RecordField Name="DPI_ErrorDescription" />
                        <ext:RecordField Name="DPI_ArticleNumber" />
                        <ext:RecordField Name="DPI_ArticleNumber_ErrMsg" />
                        <ext:RecordField Name="DPI_Dealer" />
                        <ext:RecordField Name="DPI_Dealer_ErrMsg" />
                        <ext:RecordField Name="DPI_Price" />
                        <ext:RecordField Name="DPI_Price_ErrMsg" />
                        <ext:RecordField Name="DPI_PriceTypeName" />
                        <ext:RecordField Name="DPI_PriceTypeName_ErrMsg" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Title="<%$ Resources: BasicForm.Title %>"
                            AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;"
                            ButtonAlign="Left">
                            <Defaults>
                                <ext:Parameter Name="anchor" Value="50%" Mode="Value" />
                                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                            </Defaults>
                            <Body>
                                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="50">
                                    <ext:Anchor>
                                        <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="<%$ Resources: FileUploadField1.EmptyText %>"
                                            FieldLabel="<%$ Resources: FileUploadField1.FieldLabel %>" ButtonText="" Icon="ImageAdd" AllowBlank="false">
                                        </ext:FileUploadField>
                                    </ext:Anchor>
                                    <ext:Anchor>
                                        <ext:TextField ID="txtRemark" runat="server" Width="150" FieldLabel="<%$ Resources: txtRemark.FieldLabel  %>" AllowBlank="false" />
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                            <Listeners>
                                <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                            </Listeners>
                            <Buttons>
                                <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: SaveButton.Text %>">
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
                                <ext:Button ID="ResetButton" runat="server" Text="<%$ Resources: ResetButton.Text %>">
                                    <Listeners>
                                        <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);#{ImportButton}.setDisabled(true);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="ImportButton" runat="server" Text="<%$ Resources: ImportButton.Text %>"
                                    Disabled="true">
                                    <AjaxEvents>
                                        <Click OnEvent="ImportClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } Ext.Msg.wait(MsgList.ImportButton.BeforeTitle, MsgList.ImportButton.BeforeMsg);"  Success="#{PagingToolBar1}.changePage(1);">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="DownloadButton" runat="server" Text="<%$ Resources: DownloadButton.Text %>">
                                    <Listeners>
                                        <Click Handler="window.open('../../Upload/ExcelTemplate/Template_DealerPrice.xls')" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel9" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="GridPanel3" runat="server" Title="<%$ Resources: GridPanel3.Title %>"
                                        StoreID="ResultStore" Border="false" Icon="Error" AutoWidth="true" StripeRows="true"
                                        EnableHdMenu="false">
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DPI_LineNbr" DataIndex="DPI_LineNbr" Header="<%$ Resources: GridPanel3.ColumnModel3.LineNbr.Header %>"
                                                    Sortable="false">
                                                </ext:Column>
                                                <ext:Column ColumnID="DPI_ArticleNumber" DataIndex="DPI_ArticleNumber" Header="<%$ Resources: resource,Lable_Article_Number %>"
                                                    Sortable="false">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DPI_Dealer" DataIndex="DPI_Dealer" Header="<%$ Resources: GridPanel3.ColumnModel3.Dealer.Header  %>"
                                                    Sortable="false" Width="150px">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DPI_Price" DataIndex="DPI_Price" Header="<%$ Resources: GridPanel3.ColumnModel3.Price.Header %>"
                                                    Sortable="false">
                                                    <Renderer Fn="renderData" />
                                                </ext:Column>
                                                <ext:Column ColumnID="DPI_PriceTypeName" DataIndex="DPI_PriceTypeName" Header="<%$ Resources: GridPanel3.ColumnModel3.PriceTypeName.Header %>"
                                                    Sortable="false">
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
                                                DisplayInfo="true">
                                                <Listeners>
                                                    <BeforeChange Handler="editId=''" />
                                                </Listeners>
                                            </ext:PagingToolbar>
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel3.LoadMask.Msg %>" />
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
