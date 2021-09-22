<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PromotionQuotaQuery.aspx.cs"
    Inherits="DMS.Website.Pages.Promotion.PromotionQuotaQuery" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        .txtRed {
            color: Red;
            font-weight: bold;
        }
    </style>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Date.js" type="text/javascript"></script>

    <ext:ScriptContainer ID="ScriptContainer1" runat="server" />

    <script type="text/javascript">

        //        Ext.onReady(function() {
        //            LoadStore('_grapecity_cache_ilname', this.IlNameStore);
        //            LoadStore('_grapecity_cache_ilstatus', this.IlStatusStore);
        //            LoadStore('_grapecity_cache_ilclient', this.DealerStore);
        //        });

        //        function SetIlNameStorage() {
        //            SetStore('_grapecity_cache_ilname', this.IlNameStore);
        //        }

        //        function SetIlStatusStorage() {
        //            SetStore('_grapecity_cache_ilstatus', this.IlStatusStore);
        //        }

        //        function SetIlClientStorage() {
        //            SetStore('_grapecity_cache_ilclient', this.DealerStore);
        //        }
        function ComboxSelValue(e) {
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var input = e.query;
                if (input != null && input != '') {
                    // 检索的正则
                    var regExp = new RegExp(".*" + input + ".*");
                    // 执行检索
                    combo.store.filterBy(function (record, id) {
                        // 得到每个record的项目名称值
                        var text = record.get(combo.displayField);
                        return regExp.test(text);
                    });
                } else {
                    combo.store.clearFilter();
                }
                combo.expand();
                return false;
            }
        }
        function cbPromotionTypeChang() {

            var cbPromotionType = Ext.getCmp('cbPromotionType');
            var grid = Ext.getCmp('GridPanel1');

            if (cbPromotionType.getValue() == 'zp') {

                grid.getColumnModel().setHidden(4, true);
                //grid.getColumnModel().setHidden(5, true);
            } else {

                grid.getColumnModel().setHidden(4, false);
                //grid.getColumnModel().setHidden(5, false);
            }
            //grid.reload();
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        <script type="text/javascript">
            function prepareCommandEdit(grid, toolbar, rowIndex, record) {
                var firstButton = toolbar.items.get(0);
                var isModified = (Ext.getCmp('<%=this.hidDealerId.ClientID%>').getValue() != record.data.DealerId && Ext.getCmp('<%=this.hidDealerType.ClientID%>').getValue() == 'LP') ? true : false;
                firstButton.setVisible(isModified);
            }

            function CheckUpdateValue() {
                var surplusamount = Ext.getCmp('<%=this.labSurplusAmount.ClientID%>').getText() == "" ? 0 : Ext.getCmp('<%=this.labSurplusAmount.ClientID%>').getText();
                var getvalue = Ext.getCmp('<%=this.nubUpdateAmount.ClientID%>').getValue();
                if (getvalue <= 0 || surplusamount < getvalue) {
                    Ext.Msg.alert('Error', '调整值必须 >0 并且 <= 剩余额度');
                    Ext.getCmp('<%=this.nubUpdateAmount.ClientID%>').setValue("0")
                }

            }
            function ValidateForm() {
                var getvalue = Ext.getCmp('<%=this.nubUpdateAmount.ClientID%>').getValue();
                if (getvalue == 0)
                {
                    Ext.Msg.alert('Error', '调整值必须 >0 并且 <= 剩余额度');
                    return;
                }
                Ext.Msg.confirm('Message', '确认提交？',
                                  function (e) {
                                      if (e == 'yes') {
                                          Coolite.AjaxMethods.Submit(
                                                  {
                                                      success: function () {
                                                          Ext.Msg.alert('Message', '修改成功！');
                                                          Ext.getCmp('<%=this.WindowPoints.ClientID%>').hide();
                                                            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
                                                        },
                                                        failure: function (err) {
                                                            Ext.Msg.alert('Error', err);
                                                        }
                                                    }
                                                );
                                                }
                                    })
                                        }
        </script>
        <ext:Store ID="PromotionTypeSotre" runat="server" UseIdConfirmation="true" OnRefreshData="Store_PromotionTypeSotre"
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
        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseShortName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <%--  <Listeners>
            <Load Handler="#{cbDealer}.setValue(#{hiddenInitDealerId}.getValue());" />
        </Listeners>--%>
        </ext:Store>
        <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DmaName" />
                        <ext:RecordField Name="BuName" />
                        <ext:RecordField Name="PointType" />
                        <ext:RecordField Name="ValidDate" />
                        <ext:RecordField Name="LargessAmount" />
                        <ext:RecordField Name="OrderAmount" />
                        <ext:RecordField Name="OtherAmount" />
                        <ext:RecordField Name="Yue" />
                        <ext:RecordField Name="CfnName" />
                        <ext:RecordField Name="Remar" />
                        <ext:RecordField Name="PoinType" />
                        <ext:RecordField Name="Code" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="DLid" />
                        <ext:RecordField Name="Period" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden ID="hidDealerType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDealerId" runat="server">
        </ext:Hidden>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel1" runat="server" Title="查询条件" AutoHeight="true" BodyStyle="padding: 5px;"
                            Frame="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor Horizontal="65%">
                                                        <ext:ComboBox ID="cbPromotionType" runat="server" EmptyText="选择类型..." Width="130"
                                                            Editable="false" TypeAhead="true" Mode="Local" FieldLabel="类型">
                                                            <SelectedItem Value="jf" Text="未上报" />
                                                            <Items>
                                                                <ext:ListItem Value="zp" Text="赠品" />
                                                                <ext:ListItem Value="jf" Text="积分" />
                                                            </Items>
                                                            <%--   <Listeners>
                                                            <Select Handler="cbPromotionTypeChang();" />
                                                        </Listeners>--%>
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
                                                    <ext:Anchor Horizontal="65%">
                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="选择产品线" Width="130" Editable="false"
                                                            TypeAhead="true" StoreID="ProductLineStore" ValueField="Id" Mode="Local" DisplayField="AttributeName"
                                                            FieldLabel="产品线">
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
                                                    <ext:Anchor Horizontal="65%">
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="选择经销商..." Width="130" Editable="true"
                                                            TypeAhead="true" StoreID="DealerStore" ValueField="Id" Mode="Local" DisplayField="ChineseShortName"
                                                            FieldLabel="经销商">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <BeforeQuery Fn="ComboxSelValue" />
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Panel ID="Panel9" runat="server">
                                                            <Buttons>
                                                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh">
                                                                    <Listeners>
                                                                        <Click Handler="cbPromotionTypeChang(); #{GridPanel1}.reload();" />
                                                                    </Listeners>
                                                                </ext:Button>
                                                                <ext:Button ID="btnExport" Text="导出" runat="server" Icon="PageExcel" IDMode="Legacy"
                                                                    AutoPostBack="true" OnClick="ExportExcel">
                                                                </ext:Button>
                                                            </Buttons>
                                                        </ext:Panel>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 0 5">
                        <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="ResultStore"
                                        Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="PoinType" DataIndex="PoinType" Header="额度类型"
                                                    Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="Code" DataIndex="Code" Header="经销商编号" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="DmaName" DataIndex="DmaName" Header="经销商" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="BuName" DataIndex="BuName" Header="产品线" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="PointType" DataIndex="PointType" Header="积分类型"
                                                    Width="120">
                                                    <Renderer Handler="return getNameFromStoreById(PromotionTypeSotre,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ValidDate" DataIndex="ValidDate" Header="有效期"
                                                    Width="150">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="LargessAmount" DataIndex="LargessAmount" Header="总额度" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="OrderAmount" DataIndex="OrderAmount" Header="已使用额度" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="OtherAmount" DataIndex="OtherAmount" Header="其它额度" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="Yue" DataIndex="Yue" Header="剩余额度" Width="120">
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnName" DataIndex="CfnName" Header="授权产品" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="Period" DataIndex="Period" Header="账期" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="Remar" DataIndex="Remar" Header="备注" Width="150">
                                                </ext:Column>
                                                <ext:CommandColumn Width="50" Header="编辑" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="编辑" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                    <PrepareToolbar Fn="prepareCommandEdit" />
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler="if (command == 'Edit'){
                                                             Coolite.AjaxMethods.DetailShow(record.data.DLid,record.data.PoinType,{success:function(){#{PagingToolBar1}.changePage(1);},failure:function(err){Ext.Msg.alert('Error', err);}});
                                                          } 
                                                         " />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                                DisplayInfo="true" />
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
        <ext:Window ID="WindowPoints" runat="server" Title="二级额度调整" Width="420" Modal="true" Collapsible="false" Maximizable="false" ShowOnLoad="false" BodyStyle="padding:10px;" AutoHeight="true" Icon="Group">
            <Body>
                <ext:FormLayout ID="FormLayout9" runat="server" LabelWidth="80">
                    <ext:Anchor>
                        <ext:Hidden ID="hidDlid" runat="server">
                        </ext:Hidden>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:Hidden ID="hidPolicyType" runat="server">
                        </ext:Hidden>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:Label ID="labDealerName" FieldLabel="经销商" runat="server"></ext:Label>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:Label ID="labProductLine" FieldLabel="产品线" runat="server"></ext:Label>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:Label ID="labPolicyType" FieldLabel="额度类型" runat="server" CtCls="txtRed"></ext:Label>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:Label ID="labPointAmount" FieldLabel="总额度" runat="server"></ext:Label>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:Label ID="labOrderAmount" FieldLabel="已使用额度" runat="server"></ext:Label>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:Label ID="labSurplusAmount" FieldLabel="剩余额度" runat="server" CtCls="txtRed"></ext:Label>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:NumberField ID="nubUpdateAmount" runat="server" FieldLabel="调减值" AllowBlank="false" Width="180">
                            <Listeners>
                                <Blur Fn="CheckUpdateValue" />
                            </Listeners>
                        </ext:NumberField>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:Label ID="Label1" LabelSeparator="" Text="*调减值必须 >0 并且 <= 剩余额度" runat="server" CtCls="txtRed"></ext:Label>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:Label ID="Label2" LabelSeparator="" Text="*提交后您输入的额度将从剩余额度中扣减" runat="server" CtCls="txtRed"></ext:Label>
                    </ext:Anchor>
                    <ext:Anchor>
                            <ext:TextArea ID="taRemark" runat="server" Width="200" FieldLabel="备注" ></ext:TextArea>
                    </ext:Anchor>
                </ext:FormLayout>

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
