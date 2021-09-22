<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InitialPointApply.aspx.cs"
    Inherits="DMS.Website.Pages.Promotion.InitialPointApply" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
<%@ Register Src="../../Controls/PromotionInitPointRuleSearch.ascx" TagName="PromotionInitPointRuleSearch"
    TagPrefix="uc" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>初始积分查询</title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"></script>
    <style type="text/css">
        .txtRed {
            color: Red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />

        <script type="text/javascript" language="javascript">
            Ext.apply(Ext.util.Format, { number: function (v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function (format) { return function (v) { return Ext.util.Format.number(v, format); }; } });
            function prepareCommandEdit(grid, toolbar, rowIndex, record) {
                var firstButton = toolbar.items.get(0);
                var isModified = (Ext.getCmp('<%=this.hidUserId.ClientID%>').getValue() == record.data.CreateBy || Ext.getCmp('<%=this.hidUserId.ClientID%>').getValue() == 'c763e69b-616f-4246-8480-9df40126057c') ? true : false;
                firstButton.setVisible(isModified);
            }

            var odwMsgList = {
                msg1: "确定要执行此操作？"
            }

            function ValidateForm() {
                var errMsg = "";

                var cbWdProductLine = Ext.getCmp('<%=this.cbWdProductLine.ClientID%>');
                var cbWdPointUseRangeType = Ext.getCmp('<%=this.cbWdPointUseRangeType.ClientID%>');
                var cbWdPointType = Ext.getCmp('<%=this.cbWdPointType.ClientID%>');
                var cbMarketType = Ext.getCmp('<%=this.cbMarketType.ClientID%>');
<%--                var cbPriceTypeReason = Ext.getCmp('<%=this.cbPriceTypeReason.ClientID%>');--%>
                var lbWdCheckProduct = Ext.getCmp('<%=this.lbWdCheckProduct.ClientID%>');
                

                if (cbWdProductLine.getValue() == '' || cbWdPointUseRangeType.getValue() == '' || cbWdPointType.getValue() == '' || cbMarketType.getValue() == '' 
                    || lbWdCheckProduct.getText() != '')
                {
                    errMsg = "信息填写不完整";
                }

                if (errMsg != "") {
                    Ext.Msg.alert('Message', errMsg);
                } else {
                        Coolite.AjaxMethods.InitialPointApply.SubmitCheck({
                            success: function (result) {
                                if (result == '') {
                    	
                                    Ext.Msg.confirm('Message', odwMsgList.msg1,
                                          function (e) {
                                              if (e == 'yes') {
                                                  Coolite.AjaxMethods.InitialPointApply.Submit(
                                                      {
                                                          success: function (result) {
                                                              if (result == '') {
                                                                  Ext.Msg.alert('Message', '提交成功');
                                                                  Ext.getCmp('<%=this.WindowPoints.ClientID%>').hide();
                                                                  Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
                                                              }
                                                              else {
                                                                  Ext.Msg.alert('Error', result);
                                                              }
                                                          },
                                                          failure: function (err) {
                                                              Ext.Msg.alert('Error', err);
                                                          }
                                                      }
                                                  );
                        
                                              }
                                          })
                                    }
                                    else {
                                        Ext.Msg.alert('Error', '请先上传积分附件');
                                    }
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                            }
                        })
                    }
                }

                //window hide前提示是否需要保存数据
                var NeedSave = function () {
                    var isPageNew = Ext.getCmp('<%=this.hidIsPageNew.ClientID%>').getValue() == "True" ? true : false;
                    if (isPageNew) {
                        Coolite.AjaxMethods.InitialPointApply.DeleteDraft(
                                    {
                                        success: function () {
                                            Ext.getCmp('<%=this.WindowPoints.ClientID%>').hide();

                                        },
                                        failure: function (err) {
                                            Ext.Msg.alert('Error', err);
                                        }
                                    });
                                }
                }

                            var checkProductSet = function () {
                                var lbWdCheckProduct = Ext.getCmp('<%=this.lbWdCheckProduct.ClientID%>');

                                Coolite.AjaxMethods.InitialPointApply.CheckProductSet({
                                    success: function (result) {
                                        if (result == 'true') { lbWdCheckProduct.setText('') }
                                        else { lbWdCheckProduct.setText('请维护指定产品') }
                                    }, failure: function (err) { Ext.Msg.alert('Error', err); }
                                });
                            }

                            var cellViewClick = function (grid, rowIndex, columnIndex, e) {
                                var t = e.getTarget();
                                var record = grid.getStore().getAt(rowIndex);  // Get the Record
                                var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
                                var id = record.data['FlowId'];
                                if (t.className == 'imgPrint' && columnId == 'Print') {
                                    window.open("GiftMaintainView.aspx?FlowType=InsertGift&FlowId=" + id);
                                }
                            }
                            var PrintRender = function () {
                                return '<img class="imgPrint" ext:qtip="查看" style="cursor:pointer;" src="../../resources/images/icons/page.png" />';
                            }

                            function RefreshAct() {
                                Ext.getCmp('<%=this.GridAttachmentl.ClientID%>').store.reload();
                                Ext.getCmp('<%=this.GridPanel2.ClientID%>').store.reload();
                            }
        </script>

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
            <Listeners>
                <Load Handler="" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            UseIdConfirmation="false" AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="FlowId">
                    <Fields>
                        <ext:RecordField Name="FlowId" />
                        <ext:RecordField Name="Description" />
                        <ext:RecordField Name="BU" />
                        <ext:RecordField Name="PointType" />
                        <ext:RecordField Name="PointUseRangeType" />
                        <ext:RecordField Name="PointUseRange" />
                        <ext:RecordField Name="Status" />
                        <ext:RecordField Name="CreateBy" />
                        <ext:RecordField Name="CreateTime" />
                        <ext:RecordField Name="FlowNo" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>

        <ext:Store ID="AttachmentStore" runat="server" OnRefreshData="AttachmentStore_RefreshData"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Attachment" />
                        <ext:RecordField Name="Name" />
                        <ext:RecordField Name="Url" />
                        <ext:RecordField Name="Type" />
                        <ext:RecordField Name="UploadUser" />
                        <ext:RecordField Name="Identity_Name" />
                        <ext:RecordField Name="UploadDate" />
                        <ext:RecordField Name="TypeName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="InitPointStore" runat="server" OnRefreshData="InitPointStore_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="FlowId">
                    <Fields>
                        <ext:RecordField Name="FlowId" />
                        <ext:RecordField Name="Description" />
                        <ext:RecordField Name="BU" />
                        <ext:RecordField Name="PointType" />
                        <ext:RecordField Name="PointUseRangeType" />
                        <ext:RecordField Name="PointUseRange" />
                        <ext:RecordField Name="Status" />
                        <ext:RecordField Name="CreateBy" />
                        <ext:RecordField Name="CreateTime" />
                        <ext:RecordField Name="FlowNo" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="InitImportPointStore" runat="server" OnRefreshData="InitImportPointStore_RefreshData" AutoLoad="false">
            <Reader>
                <ext:JsonReader ReaderID="DealerName">
                    <Fields>
                        <ext:RecordField Name="PolicyNo" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="Point" />
                        <ext:RecordField Name="Ratio" />
                        <ext:RecordField Name="PointExpiredDate" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden ID="hidUserId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidFLowId" runat="server">
        </ext:Hidden>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="导入赠送查询" AutoHeight="true" BodyStyle="padding: 5px;"
                            Frame="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="选择产品线..." Width="150"
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
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbApplyStatus" runat="server" EmptyText="选择状态..." Width="150" Editable="false"
                                                            TypeAhead="true" FieldLabel="状态" Resizable="true">
                                                            <Items>
                                                                <ext:ListItem Text="草稿" Value="草稿" />
                                                                <ext:ListItem Text="审批中" Value="审批中" />
                                                                <ext:ListItem Text="审批完成" Value="审批完成" />
                                                                <ext:ListItem Text="审批拒绝" Value="审批拒绝" />
                                                            </Items>
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
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel6" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbPointsType" runat="server" EmptyText="选择积分分类..." Width="150"
                                                            Editable="false" TypeAhead="true" FieldLabel="积分分类" Resizable="true">
                                                            <Items>
                                                                <ext:ListItem Text="不算返利不算达成" Value="入门积分" />
                                                            </Items>
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
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="新增" Icon="Add">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.InitialPointApply.Show({success:function(){RefreshAct();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="FlowNo" DataIndex="FlowNo" Header="审批流程编号" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="Description" DataIndex="Description" Align="Left" Header="审批流程描述"
                                                    Width="250">
                                                </ext:Column>
                                                <ext:Column ColumnID="BU" Width="80" Align="Left" DataIndex="BU" Header="产品线">
                                                </ext:Column>
                                                <ext:Column ColumnID="PointType" Width="80" Align="Left" DataIndex="PointType"
                                                    Header="积分类型">
                                                </ext:Column>
                                                <ext:Column ColumnID="Status" Width="100" Align="Right" DataIndex="Status" Header="状态">
                                                </ext:Column>
                                                <ext:Column ColumnID="Print" DataIndex="FlowId" Header="查看" Align="Center" Width="60">
                                                    <Renderer Fn="PrintRender" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <CellClick Fn="cellViewClick" />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="ResultStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Hidden ID="hidIsPageNew" runat="server">
        </ext:Hidden>
        <ext:Window ID="WindowPoints" runat="server" Title="维护积分" Width="700"
            Modal="true" Collapsible="false" Maximizable="false" ShowOnLoad="false" BodyStyle="padding:5px;" Height="450">
            <Body>
                <ext:FitLayout ID="FitLayout2" runat="server">
                    <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                        <Tabs>
                            <ext:Tab ID="TabHeader" runat="server" Title="赠送信息" BodyBorder="false" AutoScroll="true"
                                BodyStyle="padding: 6px;">
                                <%--表头信息 --%>
                                <Body>
                                    <ext:FormLayout ID="FormLayout8" runat="server">
                                        <ext:Anchor>
                                            <ext:FormPanel ID="FormPoints" runat="server" Border="false" ButtonAlign="Right" BodyStyle="padding:5px;"
                                                AutoHeight="true">
                                                <Body>
                                                    <ext:Panel ID="Panel20" runat="server" BodyBorder="false">
                                                        <Body>
                                                            <ext:ColumnLayout ID="ColumnLayout5" runat="server" Split="false">
                                                                <ext:LayoutColumn ColumnWidth="0.5">
                                                                    <ext:Panel ID="Panel13" runat="server" Border="true" FormGroup="true">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout20" runat="server">
                                                                                <ext:Anchor>
                                                                                    <ext:TextField ID="txtWdApplyNo" runat="server" FieldLabel="流程编号" ReadOnly="true"
                                                                                        AllowBlank="true" Enabled="false" Width="180">
                                                                                    </ext:TextField>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:ComboBox ID="cbMarketType" runat="server" EmptyText="选择市场类型..." Editable="false"
                                                                                        Width="180" AllowBlank="false" TypeAhead="true" Mode="Local" FieldLabel="市场类型"
                                                                                        Resizable="true">
                                                                                        <Items>
                                                                                            <ext:ListItem Text="蓝海" Value="0" />
                                                                                        </Items>
                                                                                        <Triggers>
                                                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                                        </Triggers>
                                                                                  <%--      <Listeners>
                                                                                            <TriggerClick Handler="this.clearValue();" />
                                                                                        </Listeners>--%>
                                                                                    </ext:ComboBox>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:ComboBox ID="cbWdProductLine" runat="server" EmptyText="选择产品线..." Width="180"
                                                                                        Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                                                        Mode="Local" DisplayField="AttributeName" AllowBlank="false" FieldLabel="产品线"
                                                                                        Resizable="true">
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
                                                                </ext:LayoutColumn>
                                                                <ext:LayoutColumn ColumnWidth="0.5">
                                                                    <ext:Panel ID="Panel14" runat="server" Border="true" FormGroup="true">
                                                                        <Body>
                                                                            <ext:FormLayout ID="FormLayout10" runat="server">
                                                                           <%--     <ext:Anchor>
                                                                                    <ext:ComboBox ID="cbPriceTypeReason" runat="server" EmptyText="请选择类型原因..." Editable="false"
                                                                                        Width="180" AllowBlank="false" TypeAhead="true" Mode="Local" FieldLabel="类型原因" ListWidth="200"
                                                                                        Resizable="true">
                                                                                        <Items>
                                                                                            <ext:ListItem Text="已获取亚太审批的促销政策" Value="1" />
                                                                                            <ext:ListItem Text="不需获取亚太审批的促销政策(非红票冲抵)" Value="2" />
                                                                                            <ext:ListItem Text="不需获取亚太审批的促销政策(红票冲抵)" Value="3" />
                                                                                        </Items>
                                                                                        <Triggers>
                                                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                                        </Triggers>
                                                                                        <Listeners>
                                                                                            <TriggerClick Handler="this.clearValue();" />
                                                                                        </Listeners>
                                                                                    </ext:ComboBox>
                                                                                </ext:Anchor>--%>
                                                                                <ext:Anchor>
                                                                                    <ext:ComboBox ID="cbWdProType" runat="server" EmptyText="选择赠送类型..." Editable="false"
                                                                                        Width="180" AllowBlank="false" TypeAhead="true" Mode="Local" FieldLabel="赠送类型"
                                                                                        Resizable="true">
                                                                                        <SelectedItem Value="积分" Text="积分" />
                                                                                        <Items>
                                                                                            <ext:ListItem Text="积分" Value="积分" />
                                                                                             <ext:ListItem Text="赠品" Value="赠品" />
                                                                                        </Items>
                                                                                        <Listeners>
                                                                                        </Listeners>
                                                                                    </ext:ComboBox>
                                                                                </ext:Anchor>
                                                                                <ext:Anchor>
                                                                                    <ext:ComboBox ID="cbWdPointType" runat="server" EmptyText="选择积分类型..." Editable="false"
                                                                                        Width="180" AllowBlank="false" TypeAhead="true" Mode="Local" FieldLabel="积分类型"
                                                                                        Resizable="true">
                                                                                        <Items>
                                                                                            <ext:ListItem Text="不算返利不算达成" Value="不算返利不算达成" />
                                                                                        </Items>
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
                                                                </ext:LayoutColumn>
                                                            </ext:ColumnLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                    <ext:Panel ID="Panel15" runat="server" BodyBorder="false">
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout11" runat="server">
                                                                <ext:Anchor>
                                                                    <ext:Panel ID="Panel3" runat="server" Border="false" ButtonAlign="Center">
                                                                        <Body>
                                                                            <ext:ColumnLayout ID="ColumnLayout3" runat="server" Split="false">
                                                                                <ext:LayoutColumn ColumnWidth="0.7">
                                                                                    <ext:Panel ID="Panel8" runat="server" Border="true" FormGroup="true">
                                                                                        <Body>
                                                                                            <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left">
                                                                                                <ext:Anchor>
                                                                                                    <ext:Panel ID="pan" runat="server" Border="false">
                                                                                                        <Body>
                                                                                                            <ext:ColumnLayout ID="ColumnLayout2" runat="server" Split="false">
                                                                                                                <ext:LayoutColumn ColumnWidth="0.5">
                                                                                                                    <ext:Panel ID="Panel" runat="server" Border="false" FormGroup="true">
                                                                                                                        <Body>
                                                                                                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left">
                                                                                                                                <ext:Anchor>
                                                                                                                                    <ext:ComboBox ID="cbWdPointUseRangeType" runat="server" EmptyText="选择使用产品范围类型..."
                                                                                                                                        Width="180" Editable="false" TypeAhead="true" BlankText="选择使用范围类型" AllowBlank="false"
                                                                                                                                        Mode="Local" FieldLabel="使用范围" Resizable="true">
                                                                                                                                        <Items>
                                                                                                                                            <ext:ListItem Value="BU" Text="全产品线" />
                                                                                                                                            <ext:ListItem Value="UPN" Text="指定产品" />
                                                                                                                                        </Items>
                                                                                                                                        <Triggers>
                                                                                                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                                                                                        </Triggers>
                                                                                                                                        <Listeners>
                                                                                                                                            <TriggerClick Handler="this.clearValue();#{btnWdPointUseRange}.setVisible(false); #{lbWdCheckProduct}.setText('');" />
                                                                                                                                            <Select Handler="if(#{cbWdPointUseRangeType}.getValue()=='BU') {
                                                                                                #{btnWdPointUseRange}.setVisible(false); #{lbWdCheckProduct}.setText('')} else { 
                                                                                                        #{btnWdPointUseRange}.setVisible(true); 
                                                                                                        Coolite.AjaxMethods.InitialPointApply.CheckProductSet({success:function(result){ if(result=='true'){ #{lbWdCheckProduct}.setText('')}else{#{lbWdCheckProduct}.setText('请维护指定产品')}},failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                                                    }" />
                                                                                                                                        </Listeners>
                                                                                                                                    </ext:ComboBox>
                                                                                                                                </ext:Anchor>
                                                                                                                            </ext:FormLayout>
                                                                                                                        </Body>
                                                                                                                    </ext:Panel>
                                                                                                                </ext:LayoutColumn>
                                                                                                                <ext:LayoutColumn ColumnWidth="0.2">
                                                                                                                    <ext:Panel ID="Panel7" runat="server" Border="true" FormGroup="true">
                                                                                                                        <Body>
                                                                                                                            <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left">
                                                                                                                                <ext:Anchor>
                                                                                                                                    <ext:Button ID="btnWdPointUseRange" runat="server" Text="维护" Hidden="true">
                                                                                                                                        <Listeners>
                                                                                                                                            <Click Handler="if(#{cbWdProductLine}.getValue()==''){Ext.Msg.alert('Error', '请选择产品线！');}else{ Coolite.AjaxMethods.PromotionInitPointRuleSearch.Show(#{hidFLowId}.getValue(),#{cbWdProductLine}.getValue(),'','','',{success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}})};" />
                                                                                                                                        </Listeners>
                                                                                                                                    </ext:Button>
                                                                                                                                </ext:Anchor>
                                                                                                                            </ext:FormLayout>
                                                                                                                        </Body>
                                                                                                                    </ext:Panel>
                                                                                                                </ext:LayoutColumn>
                                                                                                                <ext:LayoutColumn ColumnWidth="0.3">
                                                                                                                    <ext:Panel ID="Panel9" runat="server" Border="true" FormGroup="true">
                                                                                                                        <Body>
                                                                                                                            <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left">
                                                                                                                                <ext:Anchor>
                                                                                                                                    <ext:Label runat="server" ID="lbWdCheckProduct" LabelSeparator="" HideLabel="true" Text="" CtCls="txtRed"></ext:Label>
                                                                                                                                </ext:Anchor>
                                                                                                                            </ext:FormLayout>
                                                                                                                        </Body>
                                                                                                                    </ext:Panel>
                                                                                                                </ext:LayoutColumn>
                                                                                                            </ext:ColumnLayout>
                                                                                                        </Body>
                                                                                                    </ext:Panel>
                                                                                                </ext:Anchor>

                                                                                                <%--<ext:Anchor>
                                                                                                    <ext:FileUploadField ID="FileUploadField" runat="server" EmptyText="请选择额度文件"
                                                                                                        FieldLabel="额度文件" Width="400" ButtonText="" Icon="ImageAdd">
                                                                                                    </ext:FileUploadField>
                                                                                                </ext:Anchor>--%>
                                                                                            </ext:FormLayout>
                                                                                        </Body>
                                                                                    </ext:Panel>
                                                                                </ext:LayoutColumn>
                                                                            </ext:ColumnLayout>
                                                                        </Body>
                                                                        <%--<Buttons>
                                                                            <ext:Button ID="DownloadButton" runat="server" Text="下载模板">
                                                                                <Listeners>
                                                                                    <Click Handler="window.open('../../Upload/PROOther/Template_InitPoint.xls')" />
                                                                                </Listeners>
                                                                            </ext:Button>
                                                                            <ext:Button ID="ResetButton" runat="server" Text="清除">
                                                                                <Listeners>
                                                                                    <Click Handler="#{FileUploadField}.setValue('');" />
                                                                                </Listeners>
                                                                            </ext:Button>
                                                                            <ext:Button ID="SaveFileButton" runat="server" Text="上传积分">
                                                                                <AjaxEvents>
                                                                                    <Click OnEvent="UploadClick" Before=" 
                                                                            Ext.Msg.wait('正在上传积分...', '积分上传');"
                                                                                        Failure="#{FileUploadField}.setValue('');Ext.Msg.show({ 
                                                                            title   : '错误', 
                                                                            msg     : '上传中发生错误', 
                                                                            minWidth: 200, 
                                                                            modal   : true, 
                                                                            icon    : Ext.Msg.ERROR, 
                                                                            buttons : Ext.Msg.OK 
                                                                        });"
                                                                                        Success="#{FileUploadField}.setValue(''); Ext.Msg.show({ 
                                                                            title   : '成功', 
                                                                            msg     : '上传成功', 
                                                                            minWidth: 200, 
                                                                            modal   : true, 
                                                                            buttons : Ext.Msg.OK 
                                                                        })">
                                                                                    </Click>
                                                                                </AjaxEvents>
                                                                            </ext:Button>
                                                                        </Buttons>--%>
                                                                    </ext:Panel>
                                                                </ext:Anchor>

                                                                <ext:Anchor>
                                                                    <ext:Label runat="server" ID="lbWdPointUseRemark" HideLabel="true" Text=""></ext:Label>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextArea ID="areWdDescription" runat="server" FieldLabel="描述" Width="400">
                                                                    </ext:TextArea>
                                                                </ext:Anchor>

                                                            </ext:FormLayout>

                                                        </Body>
                                                    </ext:Panel>
                                                </Body>

                                            </ext:FormPanel>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="Tab2" runat="server" Title="文件上传" AutoScroll="true">
                                <Body>
                                    <ext:FormLayout ID="FormLayout9" runat="server">
                                        <ext:Anchor>
                                            <ext:FormPanel ID="FormPanel1" runat="server" Border="false" ButtonAlign="Right" BodyStyle="padding:5px;"
                                                AutoHeight="true">
                                                <Body>
                                                    <ext:Panel ID="Panel16" runat="server" BodyBorder="false">
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout14" runat="server">
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtImportTotal" runat="server" FieldLabel="本次上传合计" ReadOnly="true"
                                                                        AllowBlank="true" Enabled="false" Width="180">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Panel ID="Panel17" runat="server" Border="false" ButtonAlign="Left">
                                                                        <Buttons>
                                                                            <ext:Button ID="btnImport" Text="导入额度" runat="server" Icon="add" IDMode="Legacy">
                                                                                <Listeners>
                                                                                    <Click Handler="Coolite.AjaxMethods.InitialPointApply.ImportShow({success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                                                </Listeners>
                                                                            </ext:Button>
                                                                        </Buttons>
                                                                    </ext:Panel>
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                    <ext:Panel ID="Panel19" runat="server" BodyBorder="true" Height="265">
                                                        <Body>
                                                            <ext:FitLayout ID="FitLayout3" runat="server">
                                                                <ext:GridPanel ID="GridPanel2" runat="server" StoreID="InitImportPointStore" StripeRows="true" Width="700"
                                                                    BodyBorder="false">
                                                                    <ColumnModel ID="ColumnModel2" runat="server">
                                                                        <Columns>
                                                                            <ext:Column ColumnID="PolicyNo" DataIndex="PolicyNo" Header="政策编号" Width="100">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商名称" Width="200">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Point" DataIndex="Point" Align="Left" Header="积分" Width="120">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="Ratio" Width="120" Align="Left" DataIndex="Ratio" Header="加价率">
                                                                            </ext:Column>
                                                                            <ext:Column ColumnID="PointExpiredDate" Align="Left" DataIndex="PointExpiredDate"
                                                                                Header="积分失效时间">
                                                                            </ext:Column>
                                                                        </Columns>
                                                                    </ColumnModel>
                                                                    <SelectionModel>
                                                                        <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server">
                                                                        </ext:RowSelectionModel>
                                                                    </SelectionModel>
                                                                    <BottomBar>
                                                                        <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="20" StoreID="InitImportPointStore"
                                                                            DisplayInfo="true" />
                                                                    </BottomBar>
                                                                    <SaveMask ShowMask="true" />
                                                                    <LoadMask ShowMask="true" />
                                                                </ext:GridPanel>
                                                            </ext:FitLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </Body>
                                            </ext:FormPanel>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="Tab3" runat="server" Title="附件信息" AutoScroll="true">
                                <%-- 附件管理--%>
                                <Body>
                                    <ext:FitLayout ID="FitLayout5" runat="server">
                                        <ext:GridPanel ID="GridAttachmentl" runat="server" StoreID="AttachmentStore" StripeRows="true"
                                            BodyBorder="false">
                                            <TopBar>
                                                <ext:Toolbar ID="Toolbar1" runat="server">
                                                    <Items>
                                                        <ext:ToolbarFill />
                                                        <ext:Button ID="btnAddAttachmentl" runat="server" Text="添加附件" Icon="Add">
                                                            <Listeners>
                                                                <Click Handler="#{ufUploadAttachment}.reset();#{btnWinAttachmentSubmit}.setDisabled(true);#{wdAttachment}.show();" />
                                                            </Listeners>
                                                        </ext:Button>
                                                    </Items>
                                                </ext:Toolbar>
                                            </TopBar>
                                            <ColumnModel ID="ColumnModel3" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="Name" DataIndex="Name" Width="250" Header="附件名称">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Width="150" Header="上传人">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Width="90" Header="上传时间">
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                                <ToolTip Text="下载" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                    <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                                <ToolTip Text="删除" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Handler="if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该文件?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.InitialPointApply.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                        success: function() {
                                                                                            #{GridAttachmentl}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });
                                                                         }if (command == 'DownLoad'){
                                                                                    var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=Promotion';
                                                                                    open(url, 'Download');
                                                                                  }  " />
                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="5" StoreID="AttachmentStore"
                                                    DisplayInfo="true" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </ext:FitLayout>
            </Body>
            <Buttons>
                <ext:Button ID="Button1" runat="server" Text="提交" Icon="PageSave" IDMode="Legacy">
                    <Listeners>
                        <Click Handler=" ValidateForm();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="Button2" runat="server" Text="关闭" Icon="PageCancel" IDMode="Legacy">
                    <Listeners>
                        <Click Handler="#{WindowPoints}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Handler="return NeedSave();" />
            </Listeners>
        </ext:Window>

        <ext:Window ID="wdAttachment" runat="server" Icon="Group" Title="上传附件" Resizable="false"
            Header="false" Width="500" Height="150" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="AttachmentForm" runat="server" Width="500" Frame="true" Header="false"
                    AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="100">
                            <ext:Anchor>
                                <ext:FileUploadField ID="ufUploadAttachment" runat="server" EmptyText="选择上传附件" FieldLabel="文件"
                                    ButtonText="" Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{btnWinAttachmentSubmit}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="btnWinAttachmentSubmit" runat="server" Text="上传附件">
                            <AjaxEvents>
                                <Click OnEvent="UploadAttachmentClick" Before="if(!#{AttachmentForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');"
                                    Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });"
                                    Success="#{GridAttachmentl}.reload();#{ufUploadAttachment}.setValue('')">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="Button3" runat="server" Text="清除">
                            <Listeners>
                                <Click Handler="#{AttachmentForm}.getForm().reset();#{btnWinAttachmentSubmit}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </Body>
            <Listeners>
                <BeforeShow Handler="#{ufUploadAttachment}.setValue('');" />
            </Listeners>
        </ext:Window>
        <ext:Window ID="ImportWindow" runat="server" Icon="Group" Title="经销商额度导入" Closable="true"
            AutoShow="false" ShowOnLoad="false" Resizable="false" Height="200" Draggable="false"
            Width="500" Modal="true" BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="BasicForm" runat="server" Header="false" Border="false" BodyStyle="padding: 10px 10px 0 10px;background-color:#dfe8f6">
                    <Body>
                        <ext:FormLayout ID="FormLayout12" runat="server" LabelPad="20">
                            <ext:Anchor Horizontal="100%">
                                <ext:FileUploadField ID="FileUploadField" runat="server" EmptyText="上传文件" FieldLabel="文件"
                                    ButtonText="" Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="SaveButton" runat="server" Text="上传">
                            <AjaxEvents>
                                <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } " Success="">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="Button4" runat="server" Text="清除">
                            <Listeners>
                                <%--  <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);#{ImportButton}.setDisabled(true);" />--%>
                                <Click Handler="#{BasicForm}.getForm().reset();" />
                            </Listeners>
                        </ext:Button>

                        <ext:Button ID="Button8" runat="server" Text="下载模板">
                            <Listeners>
                                <Click Handler="window.open('../../Upload/PROOther/Template_InitPoint.xls')" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </Body>
        </ext:Window>
        <uc:PromotionInitPointRuleSearch ID="PromotionInitPointRuleSearch" runat="server"></uc:PromotionInitPointRuleSearch>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
