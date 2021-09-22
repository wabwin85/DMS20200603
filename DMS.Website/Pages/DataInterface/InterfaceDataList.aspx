<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InterfaceDataList.aspx.cs"
    Inherits="DMS.Website.Pages.DataInterface.InterfaceDataList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <ext:ScriptContainer ID="ScriptContainer1" runat="server" />
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Date.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
        //设置Store的数据至缓存

//        Ext.onReady(function() {
//            LoadStore('_grapecity_cache_interfacetype', this.InterfaceTypeStore);
//            LoadStore('_grapecity_cache_interfacestatus', this.InterfaceStatusStore);
//            LoadStore('_grapecity_cache_interfaceclient', this.DealerStore);
//        });

//        function SetInterfaceTypeStorage() {
//            SetStore('_grapecity_cache_interfacetype', this.InterfaceTypeStore);
//        }

//        function SetInterfaceStatusStorage() {
//            SetStore('_grapecity_cache_interfacestatus', this.InterfaceStatusStore);
//        }

//        function SetClientStorage() {
//            SetStore('_grapecity_cache_interfaceclient', this.DealerStore);
//        }

        function beforeRowSelect(s, n, k, r) {
            if (r.get("Status") != 'Pending' && r.get("Status") != 'Success' && r.get("Status") != 'Failure') return false;
        }

        function setCheckboxStatus(v, p, record) {

            if (record.get("Status") != 'Pending' && record.get("Status") != 'Success' && record.get("Status") != 'Failure') return "";
            return '<div class="x-grid3-row-checker">&#160;</div>';
        }

        Ext.onReady(function() {
            var sm = Ext.getCmp('GridPanel1').getSelectionModel();
            sm.renderer = setCheckboxStatus;
        });

        function SetRecordStatus(status) {
            var cbInterfaceType = Ext.getCmp("cbInterfaceType");
            var grid = Ext.getCmp("GridPanel1");
            var hiddenRtnVal = Ext.getCmp("hiddenRtnVal");
            var hiddenRtnMessing = Ext.getCmp("hiddenRtnMessing");
            if (cbInterfaceType.getValue() == '') {
                Ext.Msg.alert('提示', '请先选择接口类型!');
                return false;
            }
            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();
                var param = '';
                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].id + ';';
                }

                Ext.Msg.confirm('警告', '你确定执行该操作吗？<br>',
                            function(e) {
                                if (e == 'yes') {
                                    if (grid.hasSelection())
                                        Ext.getBody().mask('执行中...请稍等');
                                    Coolite.AjaxMethods.SetRecordStatus(param, status,
                                        {
                                            success: function(bOK) {
                                            Ext.getBody().unmask();
                                                if (bOK) {
                                                    if (hiddenRtnVal.getValue() == 'Success') {
                                                       
                                                        Ext.Msg.alert("提示", "执行成功!");
                                                    }
                                                    else {
                                                        
                                                        Ext.Msg.alert("提示", hiddenRtnMessing.getValue());
                                                    }
                                                } else {
                                                    Ext.getBody().unmask();
                                                }
                                            },
                                            failure: function(err) {
                                                Ext.getBody().unmask();
                                                Ext.Msg.alert('Error', err);
                                            }
                                        }
                                        );
                                    grid.reload();
                                }
                            });

            } else {
                Ext.Msg.alert('Message', '请选择');
            }
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <ext:Store ID="InterfaceTypeStore" runat="server" UseIdConfirmation="true" OnRefreshData="Bind_InterfaceDataType"
        AutoLoad="true">
        <BaseParams>
            <ext:Parameter Name="Type" Value="CONST_InterfaceDataDataType" Mode="Value">
            </ext:Parameter>
        </BaseParams>
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
       <%-- <Listeners>
            <Load Handler="SetInterfaceTypeStorage();" />
        </Listeners>--%>
        <%--<SortInfo Field="Key" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="InterfaceStatusStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshDictionary"
        AutoLoad="true">
        <BaseParams>
            <ext:Parameter Name="Type" Value="CONST_MakeOrder_Status" Mode="Value">
            </ext:Parameter>
        </BaseParams>
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
        <%--<Listeners>
            <Load Handler="SetInterfaceStatusStorage();" />
        </Listeners>--%>
        <SortInfo Field="Key" Direction="ASC" />
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
                    <ext:RecordField Name="BatchNbr" />
                    <ext:RecordField Name="RecordNbr" />
                    <ext:RecordField Name="HeaderId" />
                    <ext:RecordField Name="HeaderNo" />
                    <ext:RecordField Name="Status" />
                    <ext:RecordField Name="DataType" />
                    <ext:RecordField Name="ProcessType" />
                    <ext:RecordField Name="FileName" />
                    <ext:RecordField Name="CreateUser" />
                    <ext:RecordField Name="CreateDate" />
                    <ext:RecordField Name="UpdateUser" />
                    <ext:RecordField Name="UpdateDate" />
                    <ext:RecordField Name="ClientId" />
                    <ext:RecordField Name="DealerName" />
                    <ext:RecordField Name="DealerCode" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hiddenRtnVal" runat="server">
    </ext:Hidden>
     <ext:Hidden ID="hiddenRtnMessing" runat="server">
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
                                                <ext:Anchor Horizontal="85%">
                                                    <ext:ComboBox ID="cbInterfaceType" runat="server" EmptyText="选择接口类型..." Width="150"
                                                        Editable="false" TypeAhead="true" StoreID="InterfaceTypeStore" ValueField="Key"
                                                        Mode="Local" DisplayField="Value" FieldLabel="接口类型" >
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="85%">
                                                    <ext:DateField ID="txtStartDate" runat="server" Width="150" FieldLabel="开始日期" />
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="85%">
                                                    <ext:TextField ID="txtHeaderNo" runat="server" Width="150" FieldLabel="单据号" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".35">
                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor Horizontal="85%">
                                                    <ext:ComboBox ID="cbInterfaceStatus" runat="server" EmptyText="选择接口状态..." Width="150"
                                                        Editable="false" TypeAhead="true" StoreID="InterfaceStatusStore" ValueField="Key"
                                                        Mode="Local" DisplayField="Value" FieldLabel="接口状态">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="85%">
                                                    <ext:DateField ID="txtEndDate" runat="server" Width="150" FieldLabel="结束日期" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor Horizontal="100%">
                                                    <ext:ComboBox ID="cbClient" runat="server" EmptyText="选择平台商..." Width="150" Editable="false"
                                                        TypeAhead="true" StoreID="DealerStore" ValueField="Id" Mode="Local" DisplayField="ChineseShortName"
                                                        FieldLabel="平台商">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="100%">
                                                    <ext:TextField ID="txtBatchNbr" runat="server" Width="150" FieldLabel="批处理号" />
                                                </ext:Anchor>
                                                <ext:Anchor Horizontal="100%">
                                                    <ext:Panel ID="Panel9" runat="server">
                                                        <Buttons> 
                                                            <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh">
                                                                <Listeners>
                                                                    <Click Handler="if(#{cbInterfaceType}.getValue()==''){
                                                                  
                                                                      Ext.MessageBox.alert('提示', '请先选择接口类型');return false;
                                                                    } #{PagingToolBar1}.doLoad(0);" />
                                                                </Listeners>
                                                            </ext:Button>
                                                            <ext:Button ID="btnPending" Text="重置" runat="server" Icon="ArrowRefresh">
                                                                <Listeners>
                                                                    <Click Handler="SetRecordStatus('Pending');" />
                                                                </Listeners>
                                                            </ext:Button>
                                                            <ext:Button ID="btnSuccess" Text="还原" runat="server" Icon="ArrowRefresh" Hidden="true">
                                                                <Listeners>
                                                                    <Click Handler="SetRecordStatus('Success');" />
                                                                </Listeners>
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
                                            <ext:Column ColumnID="HeaderNo" DataIndex="HeaderNo" Header="单据号" Width="200">
                                            </ext:Column>
                                            <ext:Column ColumnID="DataType" DataIndex="DataType" Header="接口类型" Width="100">
                                                <Renderer Handler="return getNameFromStoreById(InterfaceTypeStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="Status" DataIndex="Status" Header="接口状态" Width="100">
                                                <Renderer Handler="return getNameFromStoreById(InterfaceStatusStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="平台商" Width="300">
                                            </ext:Column>
                                            <ext:Column ColumnID="CreateDate" DataIndex="CreateDate" Header="生成时间" Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="BatchNbr" DataIndex="BatchNbr" Header="批处理号" Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="RecordNbr" DataIndex="RecordNbr" Header="行号" Width="60">
                                            </ext:Column>
                                            <ext:CommandColumn Width="60" Header="明细" Align="Center" Hidden="true">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="进入明细" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server" SingleSelect="false"
                                            HideCheckAll="false">
                                            <Listeners>
                                                <BeforeRowSelect Fn="beforeRowSelect" />
                                            </Listeners>
                                        </ext:CheckboxSelectionModel>
                                    </SelectionModel>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                            DisplayInfo="false" />
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
      <script language="javascript" type="text/javascript">
          if (Ext.isChrome === true) {
              var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
              Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
          }
    </script>
</body>
</html>
