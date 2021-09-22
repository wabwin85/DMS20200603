<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EndoScoreCard.aspx.cs"
    Inherits="DMS.Website.Pages.ScoreCard.EndoScoreCard" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .editable-column
        {
            background: #FFFF99;
        }
        .nonEditable-column
        {
            background: #FFFFFF;
        }
        .label-color
        {
            color: Red;
            font-weight: bold;
            font-size: larger;
        } 
    </style>

    <script language="javascript">
        var MsgList = {
			ShowDetails:{
				FailureTitle:"<%=GetLocalResourceObject("GridPanel1.AjaxEvents.Alert.Title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("GridPanel1.AjaxEvents.Alert.Body").ToString()%>"
			}
        }
        
        var OrderApplyMsgList = {
            msg1:"<%=GetLocalResourceObject("loadExample.subMenu300").ToString()%>"
        }
        
        var DealerConfirm = function(){
        var escid = Ext.getCmp('<%=this.hiddenESCId.ClientID%>').getValue()
        Coolite.AjaxMethods.DealerConfirm(
        escid,{success: function() {
                                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide(null);
                                            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
                                            Ext.Msg.alert('<%=GetLocalResourceObject("DealerConfirm.SaveItem.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("DealerConfirm.SaveItem.Alert.Body").ToString()%>');
                                        },failure: function(err) {
                                        Ext.Msg.alert('<%=GetLocalResourceObject("DealerConfirm.SaveItem.Failed.Alert.Title").ToString()%>', err);
                                        }
                                        });
        }
        
        var LPConfirm = function(){
        var escid = Ext.getCmp('<%=this.hiddenESCId.ClientID%>').getValue()
        Coolite.AjaxMethods.LPConfirm(
        escid,{success: function() {
                                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide(null);
                                            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
                                            Ext.Msg.alert('<%=GetLocalResourceObject("LPConfirm.SaveItem.Alert.Title").ToString()%>', '<%=GetLocalResourceObject("LPConfirm.SaveItem.Alert.Body").ToString()%>');
                                        },failure: function(err) {
                                        Ext.Msg.alert('<%=GetLocalResourceObject("LPConfirm.SaveItem.Failed.Alert.Title").ToString()%>', err);
                                        }
                                        });
        }
        
        function prepareCommand(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);

            var attachname = record.data.Name;

            if (attachname==null||attachname == '') {
                firstButton.setVisible(false);
            } else {
                firstButton.setVisible(true);
            }
        }
        
        var prepareCommand2 = function(grid, command, record, row) {
            command.hidden = false;
          
        }        
        
        var rowCommand = function(command, record, row){
            if  (command == "Delete"){
           
                    Coolite.AjaxMethods.Delete(
                        record.data.Id,
                        record.data.TypeName,
                        {
                            success: function(){
                                Ext.getCmp('<%=this.gpFile.ClientID%>').reload();
                            },
                            failure: function(err){
                                Ext.Msg.alert('Error', err);
                            }
                        }
                    );
               
            }
            else if (command == "DownLoad"){
                var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url);
                open(url, 'Download');
            }
            
        }   
        
        var DownloadRender = function () {
            return '<img class="imgPrint" ext:qtip="<%=GetLocalResourceObject("gpFile.DownLoad.Header").ToString()%>" style="cursor:pointer;" src="../../resources/images/icons/page_go.png" />';
            
        }

       var cellClick = function(grid, rowIndex, columnIndex, e) {
            var t = e.getTarget();
            var record = grid.getStore().getAt(rowIndex);  // Get the Record
            var test = "1";

            var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id
            var id = record.data['Id'];
            if (t.className == 'imgPrint' && columnId == 'Download') {
                Coolite.AjaxMethods.Download(
                        id,
                        {
                            success: function(){
                                Ext.getCmp('<%=this.gpFile.ClientID%>').reload();
                            },
                            failure: function(err){
                                Ext.Msg.alert('Error', err);
                            }
                        }
                    );
            }          
        }
         
        
        var SetCellCssEditable  = function(v,m){
        m.css = "editable-column";
        return v;
        }
        
         var SetCellCssNonEditable  = function(v,m){
            m.css = "nonEditable-column";
            return v;
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" >
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
                    <ext:RecordField Name="ChineseName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
    </ext:Store>
    <ext:Store ID="StatusStore" runat="server" UseIdConfirmation="true">
        <Reader>
            <ext:JsonReader ReaderID="Key">
                <Fields>
                    <ext:RecordField Name="Key" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <SortInfo Field="Key" Direction="ASC" />
    </ext:Store>
    <ext:Store ID="ResultStore" runat="server" OnRefreshData="ResultStore_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="DmaId" />
                    <ext:RecordField Name="BumId" />
                    <ext:RecordField Name="Year" />
                    <ext:RecordField Name="Quarter" />
                    <ext:RecordField Name="No" />
                    <ext:RecordField Name="Status" />
                    <ext:RecordField Name="StatusName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <%--        <SortInfo Field="AdjustNumber" Direction="ASC" />--%>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel1" runat="server" Title="<%$ Resources: Panel1.Title %>" AutoHeight="true"
                        BodyStyle="padding: 5px;" Frame="true" Icon="Find">
                        <Body>
                            <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                <ext:LayoutColumn ColumnWidth=".3">
                                    <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                <ext:Anchor>
                                                    <%--<ext:ComboBox ID="cbProductLine" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout1.cbProductLine.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                        DisplayField="AttributeName" FieldLabel="<%$ Resources: Panel1.FormLayout1.cbProductLine.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout1.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>--%>
                                                    <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout2.cbDealer.EmptyText %>"
                                                        Width="220" Editable="true" TypeAhead="true" StoreID="DealerStore" ValueField="Id"
                                                        DisplayField="ChineseName" Mode="Local" FieldLabel="<%$ Resources: Panel1.FormLayout2.cbDealer.FieldLabel %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout2.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtYear" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout2.txtYear.FieldLabel %>" />
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
                                                    <ext:ComboBox ID="cbBU" runat="server" Width="200" Editable="false" TypeAhead="true"
                                                        StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.FieldLabel %>"
                                                        AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.BlankText %>"
                                                        EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.EmptyText %>"
                                                        ListWidth="300" Resizable="true">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout2.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtQuarter" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout3.txtQuarter.FieldLabel %>" />
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
                                                    <ext:ComboBox ID="cbStatus" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout3.cbAdjustStatus.EmptyText %>"
                                                        Width="150" Editable="false" TypeAhead="true" StoreID="StatusStore" ValueField="Key"
                                                        DisplayField="Value" FieldLabel="<%$ Resources: Panel1.FormLayout3.cbAdjustStatus.FieldLabel %>">
                                                        <Triggers>
                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: Panel1.FormLayout2.FieldTrigger.Qtip %>" />
                                                        </Triggers>
                                                        <Listeners>
                                                            <TriggerClick Handler="this.clearValue();" />
                                                        </Listeners>
                                                    </ext:ComboBox>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextField ID="txtScoreCardNumber" runat="server" Width="150" FieldLabel="<%$ Resources: Panel1.FormLayout1.txtScoreCardNumber.FieldLabel %>" />
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:LayoutColumn>
                            </ext:ColumnLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnSearch" Text="<%$ Resources: Panel1.btnSearch.Text %>" runat="server"
                                Icon="ArrowRefresh" IDMode="Legacy">
                                <Listeners>
                                    <%-- <Click Handler="#{GridPanel1}.reload();" />--%>
                                    <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button ID="btnImport" runat="server" Text="<%$ Resources: btnImport.Text %>" Hidden="true"
                                Icon="Disk" IDMode="Legacy">
                                <Listeners>
                                    <%--<Click Handler="window.parent.loadExample('/Pages/ScoreCard/EndoScoreCardImport.aspx','subMenu300',OrderApplyMsgList.msg1);" />--%>
                                    <Click Handler="top.createTab({id: 'subMenu300',title: '导入',url: 'Pages/ScoreCard/EndoScoreCardImport.aspx'});" />

                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 0 5">
                    <ext:Panel ID="Panel2" runat="server" Height="300" Header="false">
                        <Body>
                            <ext:FitLayout ID="FitLayout1" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="<%$ Resources: GridPanel1.Title %>"
                                    StoreID="ResultStore" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true">
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="DmaId" DataIndex="DmaId" Header="<%$ Resources: GridPanel1.ColumnModel1.DealerId.Header %>"
                                                Width="250">
                                                <Renderer Handler="return getNameFromStoreById(DealerStore,{Key:'Id',Value:'ChineseName'},value);" />
                                            </ext:Column>
                                            <ext:Column ColumnID="No" DataIndex="No" Header="<%$ Resources: GridPanel1.ColumnModel1.ScoreCardNumber.Header %>"
                                                Width="180">
                                            </ext:Column>
                                            <ext:Column ColumnID="Year" DataIndex="Year" Header="<%$ Resources: GridPanel1.ColumnModel1.YearCode.Header %>"
                                                Align="Right">
                                            </ext:Column>
                                            <ext:Column ColumnID="Quarter" DataIndex="Quarter" Header="<%$ Resources: GridPanel1.ColumnModel1.Quarter.Header %>"
                                                Align="Right">
                                            </ext:Column>
                                            <ext:Column ColumnID="Status" DataIndex="Status" Header="<%$ Resources: GridPanel1.ColumnModel1.Status.Header %>"
                                                Align="Center" Width="100">
                                                <Renderer Handler="return getNameFromStoreById(StatusStore,{Key:'Key',Value:'Value'},value);" />
                                            </ext:Column>
                                            <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.ColumnModel1.CommandColumn.Header %>"
                                                Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="<%$ Resources: GridPanel1.ColumnModel1.ToolTip.Text %>" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                            <ext:Column ColumnID="Download" DataIndex="Id" Width="50" Header="<%$ Resources: gpFile.DownLoad.Header %>" Align="Center">
                                                <Renderer Fn="DownloadRender" />
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <AjaxEvents>
                                        <Command OnEvent="ShowDetails" Failure="Ext.MessageBox.alert(MsgList.ShowDetails.FailureTitle, MsgList.ShowDetails.FailureMsg);"
                                            Success="#{cbDealerWin}.clearValue(); #{cbDealerWin}.setValue(#{hiddenDealerId}.getValue());#{cbProductLineWin}.clearValue(); #{cbProductLineWin}.setValue(#{hiddenProductLineId}.getValue());#{cbStatusWin}.clearValue(); #{cbStatusWin}.setValue(#{hiddenStatus}.getValue());#{GridPanel2}.reload();#{gpFile}.store.reload();#{gpLog}.store.reload();">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{GridPanel1}.body}"
                                                Msg="<%$ Resources: GridPanel1.LoadMask.Msg %>" />
                                            <ExtraParams>
                                                <ext:Parameter Name="ESCHId" Value="#{GridPanel1}.getSelectionModel().getSelected().id"
                                                    Mode="Raw">
                                                </ext:Parameter>
                                            </ExtraParams>
                                        </Command>
                                    </AjaxEvents>
                                    <Listeners>
                                        <CellClick Fn="cellClick" />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ResultStore"
                                            DisplayInfo="false" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <%--<LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel2.AddItemsButton.AjaxEvents.EventMask.Msg %>" />--%>
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Manage" />
                    <ext:RecordField Name="Item" />
                    <ext:RecordField Name="Source" />
                    <ext:RecordField Name="ScoreDetail" />
                    <ext:RecordField Name="TotalScore" />
                    <ext:RecordField Name="Content" />
                    <ext:RecordField Name="Score" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />
        </Listeners>
    </ext:Store>
    <ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" OnRefreshData="OrderLogStore_RefershData"
        AutoLoad="false">
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="PohId" />
                    <ext:RecordField Name="OperUser" />
                    <ext:RecordField Name="OperUserName" />
                    <ext:RecordField Name="OperType" />
                    <ext:RecordField Name="OperDate" Type="Date" />
                    <ext:RecordField Name="OperNote" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Store ID="FileUploadStore" runat="server" UseIdConfirmation="false" OnRefreshData="FileUploadStore_RefershData"
        AutoLoad="false">
        <Reader>
            <ext:JsonReader>
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Attachment" />
                    <ext:RecordField Name="Name" />
                    <ext:RecordField Name="Url" />
                    <ext:RecordField Name="Type" />
                    <ext:RecordField Name="TypeName" />
                    <ext:RecordField Name="Remark" />
                    <ext:RecordField Name="UploadUser" />
                    <ext:RecordField Name="Identity_Name" />
                    <ext:RecordField Name="UploadDate" Type="Date" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:Hidden ID="hiddenESCId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenDealerId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenProductLineId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenStatus" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hiddenCurrentEdit" runat="server" />
    <ext:Hidden ID="hiddenIsEditting" runat="server" />
    <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>"
        Width="950" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
        <Body>
            <ext:BorderLayout ID="BorderLayout2" runat="server">
                <North MarginsSummary="5 5 5 5" Collapsible="true">
                    <ext:Panel ID="Panel6" runat="server" Header="false" Frame="true" AutoHeight="true">
                        <Body>
                            <ext:Panel ID="Panel11" runat="server">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".35">
                                            <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbDealerWin" runat="server" Width="200" Editable="true" TypeAhead="true"
                                                                Mode="Local" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName"
                                                                FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.FieldLabel %>"
                                                                AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.BlankText %>"
                                                                EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbDealerWin.EmptyText %>"
                                                                ListWidth="300" Resizable="true">
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtScoreCardNumberWin" Width="150" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout5.txtScoreCardNumberWin.FieldLabel %>"
                                                                ReadOnly="true" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:NumberField ID="txtEditScore" Width="150" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout5.txtScoreEdit.FieldLabel %>"
                                                             MaxLength="3"></ext:NumberField>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".35">
                                            <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbProductLineWin" runat="server" Width="200" Editable="false" TypeAhead="true"
                                                                StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName" FieldLabel="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.FieldLabel %>"
                                                                AllowBlank="false" BlankText="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.BlankText %>"
                                                                EmptyText="<%$ Resources: DetailWindow.FormLayout4.cbProductLineWin.EmptyText %>"
                                                                ListWidth="300" Resizable="true">
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbStatusWin" runat="server" EmptyText="<%$ Resources: Panel1.FormLayout3.cbAdjustStatus.EmptyText %>"
                                                                Width="200" Editable="false" TypeAhead="true" StoreID="StatusStore" ValueField="Key"
                                                                DisplayField="Value" FieldLabel="<%$ Resources: Panel1.FormLayout3.cbAdjustStatus.FieldLabel %>">
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtYearWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtYearWin.FieldLabel %>"
                                                                ReadOnly="true" />
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtQuarterWin" runat="server" FieldLabel="<%$ Resources: DetailWindow.FormLayout6.txtQuarterWin.FieldLabel %>"
                                                                ReadOnly="true" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                            </ext:Panel>
                        </Body>
                    </ext:Panel>
                </North>
                <Center MarginsSummary="0 5 5 5">
                    <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                        <Tabs>
                            <ext:Tab ID="TabHeader" runat="server" Title="<%$ Resources: TabDetail.Title %>"
                                BodyStyle="padding: 0px;" AutoScroll="false">
                                <Body>
                                    <ext:FitLayout ID="FitLayout2" runat="server">
                                        <ext:GridPanel ID="GridPanel2" runat="server" Title="<%$ Resources: GridPanel2.Title %>" AutoExpandColumn="Content"
                                            StoreID="DetailStore" StripeRows="true" Collapsible="false" Border="false" Icon="Lorry" Header="false">
                                           <TopBar>
                                                <ext:Toolbar ID="Toolbar2" runat="server">
                                                    <Items>
                                                         <ext:Label ID="txtContent1" runat="server" Text="<%$ Resources: gpFile.lbContent1.Text %>" Cls="label-color"></ext:Label>
                                                        <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                       <ext:Button ID="btnScoreEdit" runat="server" Text="调整" Icon="Add"  >
                                                       <AjaxEvents>
                                                            <Click  OnEvent="SaveScore" Success="#{GridPanel2}.reload();">
                                                           
                                                            </Click>
                                                        </AjaxEvents>
                                                        
                                                        </ext:Button>
                                                    </Items>
                                                </ext:Toolbar>
                                            </TopBar>
                                            <ColumnModel ID="ColumnModel2" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="Manage" DataIndex="Manage" Header="<%$ Resources: GridPanel2.ColumnModel2.ManageName.Header %>"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Item" DataIndex="Item" Header="<%$ Resources: GridPanel2.ColumnModel2.ItemName.Header %>"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Source" DataIndex="Source" Header="<%$ Resources:GridPanel2.ColumnModel2.Source.Header %>"
                                                        Width="110">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Content" DataIndex="Content" Header="<%$ Resources: GridPanel2.ColumnModel2.Content.Header %>"
                                                        >
                                                    </ext:Column>
                                                    <ext:Column ColumnID="TotalScore" DataIndex="TotalScore" Header="<%$ Resources: GridPanel2.ColumnModel2.TotalScore.Header  %>"
                                                        Width="70">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="ScoreDetail" DataIndex="ScoreDetail" Header="<%$ Resources: GridPanel2.ColumnModel2.Detail.Header %>"
                                                        Width="220">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Score" DataIndex="Score" Header="<%$ Resources: GridPanel2.ColumnModel2.ActualScore.Header %>"
                                                        Width="80" Align="Right">
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="DetailStore"
                                                    DisplayInfo="true" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="<%$ Resources: GridPanel2.LoadMask.Msg %>" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="TabFile" runat="server" Title="<%$ Resources: TabFile.Title %>" AutoScroll="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout4" runat="server">
                                        <ext:GridPanel ID="gpFile" runat="server" Title="<%$ Resources: gpFile.Title %>"
                                            StoreID="FileUploadStore" StripeRows="true" Collapsible="false" Border="false"
                                            Icon="Lorry" AutoExpandColumn="UploadDate" Header="false">
                                             <TopBar>
                                                <ext:Toolbar ID="Toolbar1" runat="server">
                                                    <Items>
                                                        <ext:Label ID="txtContent2" runat="server"  Text="<%$ Resources: gpFile.lbContent1.Text %>" Cls="label-color"></ext:Label>
                                                        <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                       <ext:Button ID="btnAddAttach" runat="server" Text="添加附件" Icon="Add" >
                                                       <AjaxEvents>
                                                            <Click  OnEvent="ShowWindow">
                                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{DetailWindow}.body}"
                                                                        Msg="<%$ Resources: GridPanel2.LoadMask.Msg %>" />
                                                            </Click>
                                                        </AjaxEvents>
                                                        </ext:Button>
                                                    </Items>
                                                </ext:Toolbar>
                                            </TopBar>
                                            <ColumnModel ID="ColumnModel4" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="Id" DataIndex="Id" Header="<%$ Resources: gpFile.FileType %>"
                                                        Width="100" Hidden="true">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="TypeName" DataIndex="TypeName" Header="<%$ Resources: gpFile.FileType %>"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Name" DataIndex="Name" Header="<%$ Resources: gpFile.FileName %>"
                                                        Width="200">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Remark" DataIndex="Remark" Header="<%$ Resources: gpFile.FileRemark %>"
                                                        Width="300">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="<%$ Resources: gpFile.FileUploadUser %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="<%$ Resources: gpFile.FileUploadDate %>"
                                                        Width="150">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="50" Header="<%$ Resources: gpFile.DownLoad.Header %>" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                                <ToolTip Text="<%$ Resources: gpFile.DownLoad.Header %>" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                        <PrepareToolbar Fn="prepareCommand" />
                                                    </ext:CommandColumn>
                                                    <ext:ImageCommandColumn Width="80">
                                                        <Commands>
                                                            <ext:ImageCommand CommandName="Delete" Icon="Cross">
                                                                <ToolTip Text="Delete" />
                                                            </ext:ImageCommand>
                                                        </Commands>
                                                        <PrepareCommand Fn="prepareCommand2" />
                                                    </ext:ImageCommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel4" SingleSelect="true" runat="server"
                                                    MoveEditorOnEnter="true">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Fn="rowCommand" />
                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="15" StoreID="FileUploadStore"
                                                    DisplayInfo="true" />
                                            </BottomBar>
                                            <LoadMask ShowMask="true" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources: TabLog.Title %>" AutoScroll="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout3" runat="server">
                                        <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="OrderLogStore"
                                            StripeRows="true" Collapsible="false" Border="false" Icon="Lorry" AutoExpandColumn="OperNote"
                                            Header="false">
                                            <ColumnModel ID="ColumnModel3" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="<%$ Resources: gpLog.OperUserName %>"
                                                        Width="150">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperType" DataIndex="OperType" Header="<%$ Resources: gpLog.OperTypeName %>"
                                                        Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="<%$ Resources: gpLog.OperNote %>">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="<%$ Resources: gpLog.OperDate %>"
                                                        Width="150">
                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server"
                                                    MoveEditorOnEnter="true">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="15" StoreID="OrderLogStore"
                                                    DisplayInfo="true" />
                                            </BottomBar>
                                            <SaveMask ShowMask="false" />
                                            <LoadMask ShowMask="true" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </Center>
            </ext:BorderLayout>
        </Body>
        <Buttons>
            <ext:Button ID="DealerConfirmButton" runat="server" Text="<%$ Resources: DetailWindow.DealerConfirmButton.Text %>"
                Icon="Add">
                <Listeners>
                    <Click Handler="DealerConfirm();" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="LPConfirmButton" runat="server" Text="<%$ Resources: DetailWindow.LPConfirmButton.Text %>"
                Icon="Add">
                <Listeners>
                    <Click Handler="LPConfirm();" />
                </Listeners>
            </ext:Button>
            <ext:Button ID="ReturnButton" runat="server" Text="<%$ Resources: DetailWindow.ReturnButton.Text %>"
                Icon="Cancel" CommandArgument="" CommandName="" IDMode="Legacy">
                <Listeners>
                        <Click Handler="#{DetailWindow}.hide(null);" />
                    </Listeners>
            </ext:Button>
        </Buttons>
        <Listeners>
            <Hide Handler="#{GridPanel2}.clear();" />
        </Listeners>
    </ext:Window>
    
    <ext:Hidden ID="hiddenFileName" runat="server"></ext:Hidden>
        <ext:Window ID="AttachmentWindow" runat="server" Icon="Group" Title="上传附件" Resizable="false" Header="false" 
            Width="500" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" >
            <Body>
                <ext:FormPanel 
                    ID="BasicForm" 
                    runat="server"
                    Width="500"
                    Frame="true"
                    Header="false"
                    AutoHeight="true"
                    MonitorValid="true"
                    BodyStyle="padding: 10px 10px 0 10px;">                
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="50">

                            <ext:Anchor>
                                <ext:FileUploadField 
                                    ID="FileUploadField1" 
                                    runat="server" 
                                    EmptyText="选择上传附件"
                                    FieldLabel="文件"
                                    ButtonText=""
                                    Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="SaveButton" runat="server" Text="上传附件">
                            <AjaxEvents>
                                <Click 
                                    OnEvent="UploadClick"
                                    Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');"
                                        
                                    Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });"
                                    Success="#{gpFile}.reload();#{FileUploadField1}.setValue('')"
                                    >
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="ResetButton" runat="server" Text="清除">
                            <Listeners>
                                <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </body>
            <Listeners>
                <Hide Handler="#{AttachmentPanel}.reload();" />
                <BeforeShow Handler="#{FileUploadField1}.setValue('');" />
            </Listeners>
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
