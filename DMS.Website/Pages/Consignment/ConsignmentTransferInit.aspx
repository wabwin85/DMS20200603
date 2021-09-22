<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConsignmentTransferInit.aspx.cs" Inherits="DMS.Website.Pages.Consignment.ConsignmentTransferInit" %>


<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Consignment Apply Init</title>
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

        .red-row {
            background: #FFD700 !important;
        }
    </style>

    <script type="text/javascript">
        var MsgList = {
            SaveButton: {
                BeforeTitle: "正在上传文件...",
                BeforeMsg: "文件上传",
                FailureTitle: "错误",
                FailureMsg: "上传中发生错误"
            },
            ImportButton: {
                BeforeTitle: "正在处理数据...",
                BeforeMsg: "初始化销售单"
            }
        }


        var rowCommand = function (command, record, row) {
            if (command == "Delete") {
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

            function getCurrentRowClass(record, index) {

                if (record.data.ErrFlg == '1') {
                    return 'red-row';
                }
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
                        <ext:RecordField Name="DealerCodeTo" />
                        <ext:RecordField Name="DealerNameTo" />
                        <ext:RecordField Name="DealerIdTo" />
                        <ext:RecordField Name="DealerCodeFrom" />
                        <ext:RecordField Name="DealerIdFrom" />
                        <ext:RecordField Name="DealerNameFrom" />
                        <ext:RecordField Name="ProductLineId" />
                        <ext:RecordField Name="ProductLineName" />
                        <ext:RecordField Name="Upn" />
                        <ext:RecordField Name="Qty" />
                        <ext:RecordField Name="ContractNo" />
                        <ext:RecordField Name="ContractId" />
                        <ext:RecordField Name="HospitalCode" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="HospitalId" />
                        <ext:RecordField Name="Remark" />
                        <ext:RecordField Name="InputUser" />
                        <ext:RecordField Name="InputDate" />
                        <ext:RecordField Name="ErrFlg" />
                        <ext:RecordField Name="ErrMassages" />
                        <ext:RecordField Name="LineNbr" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Title="寄售转移申请批量导入"
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
                                        <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择导入文件(Excel格式)"
                                            FieldLabel="文件" ButtonText=""
                                            Icon="ImageAdd">
                                        </ext:FileUploadField>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                            <Listeners>
                                <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                            </Listeners>
                            <Buttons>
                                <ext:Button ID="SaveButton" runat="server" Text="上传文件">
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
                                <ext:Button ID="ResetButton" runat="server" Text="清除">
                                    <Listeners>
                                        <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="ImportButton" runat="server" Text="提交申请">
                                    <AjaxEvents>
                                        <Click OnEvent="ImportClick">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="DownloadButton" runat="server" Text="下载模板">
                                    <Listeners>
                                        <Click Handler="window.open('../../Upload/ExcelTemplate/Template_ConsignmentTransferImport.xls')" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="导入信息"
                                        StoreID="ResultStore" Border="false" Icon="Error" AutoWidth="true" StripeRows="true"
                                        EnableHdMenu="false">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:CommandColumn ColumnID="Id" Align="Center" Width="50" Header="删除">
                                                    <Commands>
                                                        <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                            <ToolTip Text="删除" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:Column ColumnID="LineNbr" DataIndex="LineNbr" Header="行号"
                                                    Sortable="false" Width="50">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerCodeTo" DataIndex="DealerCodeTo" Header="移入经销商编号"
                                                    Sortable="false" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerNameTo" DataIndex="DealerNameTo" Header="移入经销商名称"
                                                    Sortable="false" Width="220">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerCodeFrom" DataIndex="DealerCodeFrom" Header="移出经销商编号"
                                                    Sortable="false" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="DealerNameFrom" DataIndex="DealerNameFrom" Header="移出经销商名称"
                                                    Sortable="false" Width="220">
                                                </ext:Column>
                                                <ext:Column ColumnID="HospitalCode" DataIndex="HospitalCode" Header="医院编号"
                                                    Sortable="false" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="医院名称"
                                                    Sortable="false" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineName" DataIndex="ProductLineName" Header="产品线名称"
                                                    Sortable="false" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="Upn" DataIndex="Upn" Header="产品"
                                                    Sortable="false" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="Qty" DataIndex="Qty" Header="申请数量"
                                                    Sortable="false" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="ContractNo" DataIndex="ContractNo" Header="寄售合同"
                                                    Sortable="false" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ErrMassages" DataIndex="ErrMassages" Header="错误信息" Width="300"
                                                    Sortable="false">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <View>
                                            <ext:GridView ID="GridView2" runat="server">
                                                <GetRowClass Fn="getCurrentRowClass" />
                                            </ext:GridView>
                                        </View>
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
                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>
