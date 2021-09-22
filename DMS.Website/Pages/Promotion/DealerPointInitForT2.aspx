<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerPointInitForT2.aspx.cs" Inherits="DMS.Website.Pages.Promotion.DealerPointInitForT2" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Excel促销额度导入</title>
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
                BeforeTitle: "正在上传文件",
                BeforeMsg: "文件上传",
                FailureTitle: "错误",
                FailureMsg: "上传发生错误",
            },
            ImportButton: {
                BeforeTitle: "正在处理数据",
                BeforeMsg: "处理订单数据",
            }
        }
        var renderData = function (value, meta, record, row, col, store) {
            if (record.get(meta.id + 'ErrMsg') != null) {
                meta.css = "x-grid-cell-error";
                meta.attr = 'ext:qtip="' + record.get(meta.id + 'ErrMsg') + '"';
            }
            return value;
        }

        var Img = '<img src="{0}"></img>';
        var change = function (value) {
            if (value == '1') {
                return String.format(Img, '/resources/images/icons/cross.png');
            }
            else if (value == '0') {
                return String.format(Img, '/resources/images/icons/tick.png');
            }
            else {
                //return "";
                return String.format(Img, '/resources/images/icons/bullet_go.png');
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <ext:ScriptManager ID="ScriptManager1" runat="server">
            </ext:ScriptManager>
            <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData" WarningOnDirty="false"
                AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="PolicyType" />
                            <ext:RecordField Name="PolicyTypeErrmsg" />
                            <ext:RecordField Name="PolicyNo" />
                            <ext:RecordField Name="PolicyNoErrMsg" />
                            <ext:RecordField Name="SapCode" />
                            <ext:RecordField Name="SapCodeErrMsg" />
                            <ext:RecordField Name="Bu" />
                            <ext:RecordField Name="BuErrMsg" />
                             <ext:RecordField Name="AuthProductType" />
                            <ext:RecordField Name="AuthProductTypeErrMsg" />
                             <ext:RecordField Name="PL5" />
                            <ext:RecordField Name="PL5ErrMsg" />
                            <ext:RecordField Name="ValidDate" />
                            <ext:RecordField Name="ValidDateErrMsg" />
                            <ext:RecordField Name="PointType" />
                            <ext:RecordField Name="PointTypeErrMsg" />
                            <ext:RecordField Name="FreeGoods" />
                            <ext:RecordField Name="FreeGoodsErrMsg" />
                            <ext:RecordField Name="CurrentPeriod" />
                            <ext:RecordField Name="CurrentPeriodErrMsg" />
                            <ext:RecordField Name="RemarMag" />
                            <ext:RecordField Name="UserId" />
                            <ext:RecordField Name="LineNbr" />
                            <ext:RecordField Name="ErrorFlag" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North MarginsSummary="5 5 5 5" Collapsible="true">
                            <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Title="二级促销额度导入"
                                AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;" ButtonAlign="Left">
                                <Defaults>
                                    <ext:Parameter Name="anchor" Value="50%" Mode="Value" />
                                    <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                                    <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                                </Defaults>
                                <Body>
                                    <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="50">
                                        <ext:Anchor>
                                            <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择积分数据导入文件（Excle格式）"
                                                FieldLabel="文件" ButtonText="" Icon="ImageAdd">
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
                                                    Ext.Msg.wait('正在上传文件','处理订单数据');"
                                                Failure="Ext.Msg.show({ 
                                                    title   : '错误', 
                                                    msg     : '上传发生错误', 
                                                    minWidth: 200, 
                                                    modal   : true, 
                                                    icon    : Ext.Msg.OK, 
                                                    buttons : Ext.Msg.OK 
                                                });"
                                                Success="if (#{hidIsValid}.getValue='Success') { #{ImportButton}.setDisabled(false);}#{SaveButton}.setDisabled(true);#{PagingToolBar1}.changePage(1);">
                                            </Click>
                                        </AjaxEvents>
                                    </ext:Button>
                                    <ext:Button ID="ResetButton" runat="server" Text="清除">
                                        <Listeners>
                                            <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);#{ImportButton}.setDisabled(true);" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="ImportButton" runat="server" Text="导入数据" Disabled="true">
                                        <AjaxEvents>
                                            <Click OnEvent="ImportClick" Before="Ext.Msg.wait('正在处理数据', '处理积分数据');" Success="#{PagingToolBar1}.changePage(1);#{ImportButton}.setDisabled(true);">
                                            </Click>
                                        </AjaxEvents>
                                    </ext:Button>
                                    <ext:Button ID="DownloadButton" runat="server" Text="下载模板">
                                        <Listeners>
                                            <Click Handler="window.open('../../Upload/ExcelTemplate/Template_PromotionForT2.xls')" />
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                            </ext:FormPanel>
                        </North>
                        <Center MarginsSummary="0 5 0 5">
                            <ext:Panel ID="Panel9" runat="server" Height="300" Header="false">
                                <Body>
                                    <ext:FitLayout ID="FitLayout3" runat="server">
                                        <ext:GridPanel ID="GridPanel3" runat="server" Title="导入明细信息" StoreID="ResultStore" Border="false"
                                            Icon="Error" AutoWidth="true" StripeRows="true" EnableHdMenu="false">
                                            <TopBar>
                                                <ext:Toolbar ID="Toolbar1" runat="server">
                                                    <Items>
                                                        <ext:Label ID="lbPoint" runat="server" Text="" Icon="Sum" />
                                                        <ext:Label ID="lbLargess" runat="server" Text="" Icon="Sum" />
                                                    </Items>
                                                </ext:Toolbar>
                                            </TopBar>
                                            <ColumnModel ID="ColumnModel3" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="LineNbr" DataIndex="LineNbr" Header="行号" Sortable="false" Width="50px">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ErrorFlag" DataIndex="ErrorFlag" Align="Center" Width="50" MenuDisabled="true" Header="结果">
                                                        <Renderer Fn="change" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PolicyType" DataIndex="PolicyType" Header="促销类型" Sortable="false" Width="90px">
                                                        <Renderer Fn="renderData" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PolicyNo" DataIndex="PolicyNo" Header="促销编号" Sortable="false" Width="120px">
                                                        <Renderer Fn="renderData" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="经销商ERP编号" Sortable="false" Width="90px">
                                                        <Renderer Fn="renderData" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Bu" DataIndex="Bu" Header="产品线" Sortable="false" Width="150px">
                                                        <Renderer Fn="renderData" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="AuthProductType" DataIndex="AuthProductType" Header="授权分类" Sortable="false" Width="150px">
                                                        <Renderer Fn="renderData" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PL5" DataIndex="PL5" Header="PL5" Sortable="false" Width="150px">
                                                        <Renderer Fn="renderData" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ValidDate" DataIndex="ValidDate" Header="有效期" Sortable="false" Width="100px">
                                                        <Renderer Fn="renderData" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="PointType" DataIndex="PointType" Header="积分类型" Sortable="false" Width="90px">
                                                        <Renderer Fn="renderData" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="CurrentPeriod" DataIndex="CurrentPeriod" Header="促销账期" Sortable="false" Width="90px">
                                                        <Renderer Fn="renderData" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="FreeGoods" DataIndex="FreeGoods" Header="额度" Sortable="false" Width="70px">
                                                        <Renderer Fn="renderData" />
                                                    </ext:Column>
                                                    <ext:Column ColumnID="RemarMag" DataIndex="RemarMag" Header="备注" Sortable="false" Width="200px">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ErrMsg" DataIndex="ErrMsg" Header="出错信息" Sortable="false" Width="700px">
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server" MoveEditorOnEnter="false">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="100" StoreID="ResultStore"
                                                    DisplayInfo="false">
                                                </ext:PagingToolbar>
                                            </BottomBar>
                                            <LoadMask ShowMask="true" Msg="处理中....." />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
            </ext:ViewPort>
            <ext:Hidden ID="hidFileName" runat="server"></ext:Hidden>
            <ext:Hidden ID="hidIsValid" runat="server">
            </ext:Hidden>
        </div>
    </form>
</body>
</html>

