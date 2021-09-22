<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PolicyApply.aspx.cs" Inherits="DMS.Website.Pages.Promotion.PolicyApply" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/PromotionPolicyDialog.ascx" TagName="PromotionPolicyDialog"
    TagPrefix="uc" %>
<%@ Register Src="../../Controls/PromotionPolicyRuleSet.ascx" TagName="PromotionPolicyRuleSet"
    TagPrefix="uc" %>
<%@ Register Src="../../Controls/PromotionPolicyRuleCondition.ascx" TagName="PromotionPolicyRuleCondition"
    TagPrefix="uc" %>
<%@ Register Src="../../Controls/PromotionPolicyDealers.ascx" TagName="PromotionPolicyDealers"
    TagPrefix="uc" %>
<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />

    <script type="text/javascript" language="javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });
        
         var PrintRender = function () {
            return '<img class="imgPrint" ext:qtip="预览" style="cursor:pointer;" src="../../resources/images/icons/page.png" />';
            
        }
        
        //刷新父窗口查询结果
        function RefreshMainPage() {
            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
        }
        
        function prepareCommandEdit(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            var isModified = (Ext.getCmp('<%=this.hidUserId.ClientID%>').getValue() == record.data.UserId||Ext.getCmp('<%=this.hidUserId.ClientID%>').getValue()=='c763e69b-616f-4246-8480-9df40126057c') ? true : false;
            firstButton.setVisible(isModified);
        }
        function prepareCommandDelete(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            var isModified = Ext.getCmp('<%=this.hidUserId.ClientID%>').getValue() == record.data.UserId ? true : false;
            if (record.data.canDelete && isModified)
            {
                firstButton.setVisible(true);
            }
            else
            {
                firstButton.setVisible(false);
            }
            
        }
        function prepareCommandView(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            firstButton.setVisible(record.data.canView);
        }
        
       var cellViewClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var test = "1";

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
            var id = record.data['PolicyId'];
            if (t.className == 'imgPrint' && columnId == 'Print') {
                window.open("PromotionView.aspx?PolicyId=" + id);
            }          
        }
    </script>

    <style type="text/css">
        .yellow-row
        {
            background: #FFD700;
        }
    </style>
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
    <ext:Store ID="StatusStore" runat="server" OnRefreshData="StatusStore_RefreshData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="TimeStatusStore" runat="server" OnRefreshData="TimeStatusStore_RefreshData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
        UseIdConfirmation="false" AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="PolicyId">
                <Fields>
                    <ext:RecordField Name="PolicyId" />
                    <ext:RecordField Name="PolicyNo" />
                    <ext:RecordField Name="PolicyName" />
                    <ext:RecordField Name="BU" />
                    <ext:RecordField Name="StartDate" />
                    <ext:RecordField Name="EndDate" />
                    <ext:RecordField Name="Status" />
                    <ext:RecordField Name="TimeStatus" />
                    <ext:RecordField Name="CalPeriod" />
                    <ext:RecordField Name="UserId" />
                    <ext:RecordField Name="canModify" />
                    <ext:RecordField Name="canDelete" />
                    <ext:RecordField Name="canView" />
                    <ext:RecordField Name="PolicyStyle" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hidUserId" runat="server">
    </ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="促销政策查询" AutoHeight="true" BodyStyle="padding: 5px;"
                        Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtPolicyName" runat="server" Width="180" FieldLabel="政策名称" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtPolicyNo" runat="server" Width="180" FieldLabel="政策编号" />
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbProType" runat="server" EmptyText="请选择促销类型..." Width="180" Editable="false"
                                                        TypeAhead="true" Mode="Local" FieldLabel="促销类型" Resizable="true">
                                                        <Items>
                                                            <ext:ListItem Text="赠品" Value="赠品" />
                                                            <ext:ListItem Text="积分" Value="积分" />
                                                            <ext:ListItem Text="即买即赠" Value="即时买赠" />
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
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbTimeStatus" runat="server" EmptyText="选择时效状态..." Width="150"
                                                        Editable="false" TypeAhead="true" StoreID="TimeStatusStore" ValueField="Key"
                                                        Mode="Local" DisplayField="Value" FieldLabel="时效状态" Resizable="true">
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
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <ext:ComboBox ID="cbPolicyStatus" runat="server" EmptyText="选择状态..." Width="150"
                                                        Editable="false" TypeAhead="true" StoreID="StatusStore" ValueField="Key" Mode="Local"
                                                        DisplayField="Value" FieldLabel="状态" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:NumberField ID="txtYear" runat="server" Width="150" FieldLabel="年份" />
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
                                    <Click Handler="#{WindowPromotionType}.show();#{lbWindowRemark}.setText('');#{hidWindowPromotionType}.setValue('');#{cbWindowProType}.clearValue();#{cbWindowProTypeSub}.clearValue(); #{WindowProTypeSubStore}.reload();" />
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
                                            <ext:Column ColumnID="PolicyNo" DataIndex="PolicyNo" Header="政策编号" Width="100">
                                            </ext:Column>
                                            <ext:Column ColumnID="PolicyName" DataIndex="PolicyName" Align="Left" Header="政策名称"
                                                Width="250">
                                            </ext:Column>
                                            <ext:Column ColumnID="BU" Width="80" Align="Left" DataIndex="BU" Header="产品线">
                                            </ext:Column>
                                            <ext:Column ColumnID="PolicyStyle" Width="80" Align="Left" DataIndex="PolicyStyle"
                                                Header="政策类型">
                                            </ext:Column>
                                            <ext:Column ColumnID="StartDate" Width="150" Align="Right" DataIndex="StartDate"
                                                Header="开始时间">
                                               <%-- <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />--%>
                                            </ext:Column>
                                            <ext:Column ColumnID="EndDate" Width="100" Align="Right" DataIndex="EndDate" Header="结束时间">
                                               <%-- <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />--%>
                                            </ext:Column>
                                            <ext:Column ColumnID="Status" Width="100" Align="Right" DataIndex="Status" Header="状态">
                                            </ext:Column>
                                            <ext:Column ColumnID="TimeStatus" Width="100" Align="Right" DataIndex="TimeStatus"
                                                Header="时效状态">
                                            </ext:Column>
                                            <ext:Column ColumnID="CalPeriod" Width="100" Align="Right" DataIndex="CalPeriod"
                                                Header="已结算">
                                            </ext:Column>
                                            <ext:CommandColumn Width="50" Header="编辑" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="编辑" />
                                                    </ext:GridCommand>
                                                </Commands>
                                                <PrepareToolbar Fn="prepareCommandEdit" />
                                            </ext:CommandColumn>
                                            <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                        <ToolTip Text="删除" />
                                                    </ext:GridCommand>
                                                </Commands>
                                                <PrepareToolbar Fn="prepareCommandDelete" />
                                            </ext:CommandColumn>
                                            <ext:CommandColumn Width="50" Header="查看" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="View">
                                                        <ToolTip Text="查看" />
                                                    </ext:GridCommand>
                                                </Commands>
                                                <PrepareToolbar Fn="prepareCommandView" />
                                            </ext:CommandColumn>
                                            <ext:Column ColumnID="Print" DataIndex="PolicyId" Header="预览" Align="Center" Width="60">
                                                <Renderer Fn="PrintRender" />
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                        <Command Handler="if (command == 'Edit'){
                                                             Coolite.AjaxMethods.PromotionPolicyDialog.Show(record.data.PolicyId,'Modify','','',{success:function(){RefreshDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});
                                                          } 
                                                          if (command == 'Delete'){
                                                              Ext.Msg.confirm('警告', '是否要删除该促销政策?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.PolicyApply.DeleteProPolicy(record.data.PolicyId,{
                                                                                        success: function() {
                                                                                            #{GridPanel1}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });
                                                          } 
                                                          if (command == 'View'){
                                                             Coolite.AjaxMethods.PromotionPolicyDialog.Show(record.data.PolicyId,'View','','',{success:function(){RefreshDetailWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});
                                                          }
                                                         " />
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
    <uc:PromotionPolicyDialog ID="PolicyDialog1" runat="server"></uc:PromotionPolicyDialog>
    <uc:PromotionPolicyRuleSet ID="PromotionPolicyRuleSet1" runat="server"></uc:PromotionPolicyRuleSet>
    <uc:PromotionPolicyRuleCondition ID="PromotionPolicyRuleCondition1" runat="server">
    </uc:PromotionPolicyRuleCondition>
    <uc:PromotionPolicyDealers ID="PromotionPolicyDealers1" runat="server"></uc:PromotionPolicyDealers>
    <ext:Store ID="WindowProTypeSubStore" runat="server" OnRefreshData="WindowProTypeSubStore_RefreshData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hidWindowPromotionType" runat="server">
    </ext:Hidden>
    <ext:Window ID="WindowPromotionType" runat="server" Title="选择政策类型" Width="400" AutoHeight="true"
        Modal="true" Collapsible="false" Maximizable="false" ShowOnLoad="false" BodyStyle="padding:5px;">
        <Body>
            <ext:FormPanel ID="FormPanelPromotionType" runat="server" Border="true" ButtonAlign="Right"
                BodyStyle="padding:5px;" AutoHeight="true">
                <Body>
                    <ext:FormLayout ID="FormLayout20" runat="server">
                        <ext:Anchor>
                            <ext:ComboBox ID="cbWindowProType" runat="server" EmptyText="选择政策分类..." Editable="false"
                                Width="200" AllowBlank="false" TypeAhead="true" Mode="Local" FieldLabel="政策分类"
                                Resizable="true">
                                <Items>
                                    <ext:ListItem Text="赠品类" Value="赠品" />
                                    <ext:ListItem Text="积分类" Value="积分" />
                                    <ext:ListItem Text="即买即赠" Value="即时买赠" />
                                </Items>
                                <Triggers>
                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                </Triggers>
                                <Listeners>
                                    <TriggerClick Handler="this.clearValue();#{cbWindowProTypeSub}.clearValue();#{WindowProTypeSubStore}.reload(); " />
                                    <Select Handler=" #{hidWindowPromotionType}.setValue(#{cbWindowProType}.getValue());#{cbWindowProTypeSub}.clearValue();#{lbWindowRemark}.setText(''); #{WindowProTypeSubStore}.reload(); " />
                                </Listeners>
                            </ext:ComboBox>
                        </ext:Anchor>
                        <ext:Anchor>
                            <ext:ComboBox ID="cbWindowProTypeSub" runat="server" EmptyText="选择分类类型..." Editable="false"
                                Width="200" AllowBlank="false" StoreID="WindowProTypeSubStore" ValueField="Key"
                                DisplayField="Value" TypeAhead="true" Mode="Local" FieldLabel="类型" Resizable="true">
                                <Listeners>
                                    <Select Handler=" if(#{cbWindowProTypeSub}.getValue()=='满额送固定积分') { #{lbWindowRemark}.setText('');} 
                            else if(#{cbWindowProTypeSub}.getValue()=='金额百分比积分') { #{lbWindowRemark}.setText('');}
                            else if(#{cbWindowProTypeSub}.getValue()=='促销赠品转积分') { #{lbWindowRemark}.setText('适用于： 通过数量算出买赠 然后根据采购价转换积分，或者通过固定积分转换，又或者通过采购与标准之间的价差换算');}
                            " />
                                </Listeners>
                            </ext:ComboBox>
                        </ext:Anchor>
                        <ext:Anchor>
                            <ext:Label ID="lbWindowRemark" runat="server" FieldLabel="说明" HideLabel="true">
                            </ext:Label>
                        </ext:Anchor>
                    </ext:FormLayout>
                </Body>
                <Buttons>
                    <ext:Button ID="Button1" runat="server" Text="确认新增" Icon="Add" IDMode="Legacy">
                        <Listeners>
                            <Click Handler=" if(#{FormPanelPromotionType}.getForm().isValid()) {Coolite.AjaxMethods.PromotionPolicyDialog.Show('','Modify',#{cbWindowProType}.getValue(),#{cbWindowProTypeSub}.getValue(),{success:function(){RefreshDetailWindow();#{WindowPromotionType}.hide()},failure:function(err){Ext.Msg.alert('Error', err);}})} else{Ext.Msg.alert('Error', '信息填写不完整！'); };" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:FormPanel>
        </Body>
    </ext:Window>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
