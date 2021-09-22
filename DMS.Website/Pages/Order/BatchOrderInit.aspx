<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BatchOrderInit.aspx.cs" Inherits="DMS.Website.Pages.Order.BatchOrderInit" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Excel订单导入</title>
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
				FailureMsg:"上传发生错误",
			},
			ImportButton:{
				BeforeTitle:"正在处理数据",
				BeforeMsg:"处理订单数据",
			}
        }

    </script>

    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <ext:Store ID="ResultStore" runat="server" UseIdConfirmation="false" OnRefreshData="ResultStore_RefershData" WarningOnDirty="false"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy/>
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="ID"/>
                        <ext:RecordField Name="USER"/>
                        <ext:RecordField Name="UploadDate"/>
                        <ext:RecordField Name="LineNbr"/>
                        <ext:RecordField Name="FileName"/>
                        <ext:RecordField Name="ErrorFlag"/>
                        <ext:RecordField Name="ErrorDescription"/>
                        <ext:RecordField Name="POH_ID"/>
                        <ext:RecordField Name="POD_ID"/>
                        <ext:RecordField Name="OrderType"/>
                        <ext:RecordField Name="ArticleNumber"/>
                        <ext:RecordField Name="RequiredQty"/>
                        <ext:RecordField Name="LotNumber"/>
                        <ext:RecordField Name="SapCode"/>                       
                        <ext:RecordField Name="DMA_ID"/>
                        <ext:RecordField Name="CFN_ID"/>
                        <ext:RecordField Name="BUM_ID"/>
                        <ext:RecordField Name="TerritoryCode"/>
                        <ext:RecordField Name="Warehouse"/>
                        <ext:RecordField Name="WHM_ID"/>
                        <ext:RecordField Name="OrderTypeName"/>
                        <ext:RecordField Name="SAP_Code_ErrMsg"/>
                        <ext:RecordField Name="OrderType_ErrMsg"/>
                        <ext:RecordField Name="ArticleNumber_ErrMsg"/>
                        <ext:RecordField Name="RequiredQty_ErrMsg"/>
                        <ext:RecordField Name="LotNumber_ErrMsg"/>
                        <ext:RecordField Name="Amount"/>
                        <ext:RecordField Name="Amount_ErrMsg"/>
                        <ext:RecordField Name="ProductLine"/>
                        <ext:RecordField Name="ProductLine_ErrMsg"/>
                        <ext:RecordField Name="ErrMsg"/>
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Title="订单导入"
                            AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;" ButtonAlign="Left">
                            <Defaults>
                                <ext:Parameter Name="anchor" Value="50%" Mode="Value" />
                                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                            </Defaults>
                            <Body>
                                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="50">
                                    <ext:Anchor>
                                        <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择订单数据导入文件（Excle格式）"
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
                                                });" Success="#{ImportButton}.setDisabled(false);#{SaveButton}.setDisabled(true);#{PagingToolBar1}.changePage(1);">
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
                                        <Click OnEvent="ImportClick" Before="Ext.Msg.wait('正在处理数据', '处理订单数据');" Success="#{PagingToolBar1}.changePage(1)">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="DownloadButton" runat="server" Text="下载模板">
                                    <Listeners>
                                        <Click Handler="window.open('../../Upload/ExcelTemplate/Template_DiscountRule.xls')" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel9" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="GridPanel3" runat="server" Title="出错信息" StoreID="ResultStore" Border="false"
                                        Icon="Error" AutoWidth="true" StripeRows="true" EnableHdMenu="false">
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                               
                                                <ext:Column ColumnID="SapCode" DataIndex="SapCode" Header="经销商ERP编号" Sortable="false" Width="90px">                                            
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLine" DataIndex="ProductLine" Header="产品线" Sortable="false" Width="150px">                                                
                                                </ext:Column>
                                                <ext:Column ColumnID="ArticleNumber" DataIndex="ArticleNumber" Header="产品编号"  Sortable="false" Width="100px">                                                    
                                                </ext:Column>
                                                <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="批号" Sortable="false" Width="90px">                                                    
                                                </ext:Column>
                                                <ext:Column ColumnID="RequiredQty" DataIndex="RequiredQty" Header="订购数量" Sortable="false" Width="70px">                                               
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
                                                DisplayInfo="false" >
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
        <ext:Hidden ID="hidFileName" runat="server">
        </ext:Hidden>
    </div>
    </form>
</body>
</html>

