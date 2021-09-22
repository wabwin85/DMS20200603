<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerAOPList.aspx.cs"
    Inherits="DMS.Website.Pages.AOP.DealerAOPList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>DealerAOPList</title>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">
        Ext.apply(Ext.util.Format, {            number: function(v, format) {                if(!format){                    return v;                }                                                v *= 1;                if(typeof v != 'number' || isNaN(v)){                    return '';                }                var comma = ',';                var dec = '.';                var i18n = false;                                if(format.substr(format.length - 2) == '/i'){                    format = format.substr(0, format.length-2);                    i18n = true;                    comma = '.';                    dec = ',';                }                var hasComma = format.indexOf(comma) != -1,                    psplit = (i18n ? format.replace(/[^\d\,]/g,'') : format.replace(/[^\d\.]/g,'')).split(dec);                if (1 < psplit.length) {                    v = v.toFixed(psplit[1].length);                }                else if (2 < psplit.length) {                    throw('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format);                }                else {                    v = v.toFixed(0);                }                var fnum = v.toString();                if (hasComma) {                    psplit = fnum.split('.');                    var cnum = psplit[0],                        parr = [],                        j = cnum.length,                        m = Math.floor(j / 3),                        n = cnum.length % 3 || 3;                    for (var i = 0; i < j; i += n) {                        if (i != 0) {n = 3;}                        parr[parr.length] = cnum.substr(i, n);                        m -= 1;                    }                    fnum = parr.join(comma);                    if (psplit[1]) {                        fnum += dec + psplit[1];                    }                }                return format.replace(/[\d,?\.?]+/, fnum);            },            numberRenderer : function(format){                return function(v){                    return Ext.util.Format.number(v, format);                };            }        });
        
        var MsgList = {
			btnDelete:{
				confirm:"<%=GetLocalResourceObject("btnDelete.confirm").ToString()%>",
				FailureTitle:"<%=GetLocalResourceObject("btnDelete.alert.title").ToString()%>",
				FailureMsg:"<%=GetLocalResourceObject("btnDelete.alert.body").ToString()%>"
			}
        }

        var renderDealer = function(value) {
           var dealerName = "";
           var json_data =<%= dealerData.ClientID %>.getValue() ;
           
           dealerName= getValueFromArray(json_data,value);
           return dealerName;
        }
        
        var renderLines = function(value)
       {
          var sName = "";
          var json_data =<%= prodLineData.ClientID %>.getValue() ; 
           sName= getValueFromArray(json_data,value);
           return sName;
       }
        
        var afterSaveAOPDetails = function() {
            <%= AOPEditorWindow.ClientID %>.hide(null);
            Ext.Msg.alert('<%=GetLocalResourceObject("afterSaveAOPDetails.alert.title").ToString()%>', '<%=GetLocalResourceObject("afterSaveAOPDetails.alert.body").ToString()%>');
            <%=GridPanel1.ClientID%>.reload();
        }
       
        var CheckNull = function(){
                if (<%= txtDealer.ClientID %>.getValue() =="" || <%= txtProdLine.ClientID %>.getValue()=="" || <%= txtYear.ClientID %>.getValue()==""
                    ||<%= txtAmount_1.ClientID %>.getValue()==""
                    ||<%= txtAmount_2.ClientID %>.getValue()==""
                    ||<%= txtAmount_3.ClientID %>.getValue()==""
                    ||<%= txtAmount_4.ClientID %>.getValue()==""
                    ||<%= txtAmount_5.ClientID %>.getValue()==""
                    ||<%= txtAmount_6.ClientID %>.getValue()==""
                    ||<%= txtAmount_7.ClientID %>.getValue()==""
                    ||<%= txtAmount_8.ClientID %>.getValue()==""
                    ||<%= txtAmount_9.ClientID %>.getValue()==""
                    ||<%= txtAmount_10.ClientID %>.getValue()==""
                    ||<%= txtAmount_11.ClientID %>.getValue()==""
                    ||<%= txtAmount_12.ClientID %>.getValue()=="")
                {
                    alert('<%=GetLocalResourceObject("CheckNull.alert").ToString()%>');
                    return false;
                }
                return true;
        }
       
        var cancelWindow =function()
        {
             <%= AOPEditorWindow.ClientID %>.hide(null);
        }

    </script>

    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Debug">
        </ext:ScriptManager>
        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_DealerList"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
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
        <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="AttributeName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="AttributeName" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="WinProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_ProductLine">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="AttributeName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="AttributeName" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="YearStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshFY"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="COP_Period" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="COP_Period" Direction="ASC" />
        </ext:Store>
        <ext:JsonStore ID="AOPStore" runat="server" UseIdConfirmation="false" OnRefreshData="AOPStore_RefershData"
            AutoLoad="false">
            <AutoLoadParams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={15}" />
            </AutoLoadParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Dealer_DMA_ID" />
                        <ext:RecordField Name="ProductLine_BUM_ID" />
                        <ext:RecordField Name="Year" />
                        <ext:RecordField Name="Amount_1" />
                        <ext:RecordField Name="Amount_2" />
                        <ext:RecordField Name="Amount_3" />
                        <ext:RecordField Name="Amount_4" />
                        <ext:RecordField Name="Amount_5" />
                        <ext:RecordField Name="Amount_6" />
                        <ext:RecordField Name="Amount_7" />
                        <ext:RecordField Name="Amount_8" />
                        <ext:RecordField Name="Amount_9" />
                        <ext:RecordField Name="Amount_10" />
                        <ext:RecordField Name="Amount_11" />
                        <ext:RecordField Name="Amount_12" />
                        <ext:RecordField Name="Amount_Y" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Dealer_DMA_ID" Direction="ASC" />
        </ext:JsonStore>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="<%$ Resources: plSearch.Title %>"
                            Frame="true" AutoHeight="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".35">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDealer" runat="server" EmptyText="<%$ Resources: plSearch.cbDealer.EmptyText %>"
                                                            Width="220" Editable="true" TypeAhead="true" StoreID="DealerStore" ValueField="Id"
                                                            DisplayField="ChineseName" ListWidth="300" Resizable="true" FieldLabel="<%$ Resources: plSearch.cbDealer.FieldLabel %>"
                                                            Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.cbDealer.TriggerClick.Handler %>" />
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
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbProLine" runat="server" EmptyText="<%$ Resources: plSearch.cbProLine.EmptyText %>"
                                                            Width="220" Editable="true" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                            DisplayField="AttributeName" ListWidth="300" Resizable="true" FieldLabel="<%$ Resources: plSearch.cbProLine.FieldLabel %>"
                                                            Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.cbProLine.TriggerClick.Handler %>" />
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
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbYear" runat="server" EmptyText="<%$ Resources: plSearch.cbYear.EmptyText%>"
                                                            Width="200" Editable="true" TypeAhead="true" StoreID="YearStore" ValueField="COP_Period"
                                                            DisplayField="COP_Period" ListWidth="200" Resizable="true" FieldLabel="<%$ Resources: plSearch.cbYear.FieldLabel%>"
                                                            Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.cbYear.TriggerClick.Handler %>" />
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
                                <ext:Button ID="btnSearch" Text="<%$ Resources: btnSearch.Text %>" runat="server"
                                    Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagingToolBar1}.doLoad(0);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="btnInsert" runat="server" Text="<%$ Resources: btnInsert.Text %>"
                                    Icon="Add" CommandArgument="" CommandName="" IDMode="Legacy">
                                    <AjaxEvents>
                                        <Click OnEvent="NewAop_Click">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="btnDelete" runat="server" Text="<%$ Resources: btnDelete.Text %>"
                                    Icon="Delete" CommandArgument="" CommandName="" IDMode="Legacy" OnClientClick="">
                                    <AjaxEvents>
                                        <Click Before="var result = confirm(MsgList.btnDelete.confirm)&& #{GridPanel1}.hasSelection(); if (!result) return false;"
                                            OnEvent="DeleteAOP_Click" Success="#{GridPanel1}.reload();" Failure="Ext.Msg.alert(MsgList.btnDelete.FailureTitle,MsgList.btnDelete.FailureMsg)">
                                            <ExtraParams>
                                                <ext:Parameter Name="delData" Value="Ext.encode(#{GridPanel1}.getRowsValues())" Mode="Raw">
                                                </ext:Parameter>
                                            </ExtraParams>
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Title="<%$ Resources: ctl46.Title %>"
                            Icon="HouseKey">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Header="false" StoreID="AOPStore" Border="false"
                                        Icon="Lorry" AutoExpandColumn="Dealer_DMA_ID" AutoExpandMax="250" AutoExpandMin="150"
                                        StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="Dealer_DMA_ID" DataIndex="Dealer_DMA_ID" Header="<%$ Resources: ctl46.Dealer_DMA_ID.Header %>">
                                                    <Renderer Fn="renderDealer" />
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLine_BUM_ID" DataIndex="ProductLine_BUM_ID" Header="<%$ Resources: ctl46.ProductLine_BUM_ID.Header %>"
                                                    Width="150">
                                                    <Renderer Fn="renderLines" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Year" DataIndex="Year" Header="<%$ Resources: ctl46.Year.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_1" DataIndex="Amount_1" Header="<%$ Resources: ctl46.Amount_1.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_2" DataIndex="Amount_2" Header="<%$ Resources: ctl46.Amount_2.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_3" DataIndex="Amount_3" Header="<%$ Resources: ctl46.Amount_3.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_4" DataIndex="Amount_4" Header="<%$ Resources: ctl46.Amount_4.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_5" DataIndex="Amount_5" Header="<%$ Resources: ctl46.Amount_5.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_6" DataIndex="Amount_6" Header="<%$ Resources: ctl46.Amount_6.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_7" DataIndex="Amount_7" Header="<%$ Resources: ctl46.Amount_7.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_8" DataIndex="Amount_8" Header="<%$ Resources: ctl46.Amount_8.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_9" DataIndex="Amount_9" Header="<%$ Resources: ctl46.Amount_9.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_10" DataIndex="Amount_10" Header="<%$ Resources: ctl46.Amount_10.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_11" DataIndex="Amount_11" Header="<%$ Resources: ctl46.Amount_11.Header %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_12" DataIndex="Amount_12" Header="<%$ Resources: ctl46.Amount_12.Header %>">
                                                </ext:Column>
                                                <ext:CommandColumn ColumnID="Details" Header="<%$ Resources: ctl46.Details.Header %>"
                                                    Width="60">
                                                    <Commands>
                                                        <ext:GridCommand Icon="VcardEdit" CommandName="Modify" ToolTip-Text="<%$ Resources: ctl46.Details.GridCommand.ToolTip-Text %>">
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="AOPStore"
                                                DisplayInfo="true" EmptyMsg="<%$ Resources: ctl46.PagingToolBar1.EmptyMsg %>" />
                                        </BottomBar>
                                        <LoadMask ShowMask="true" Msg="<%$ Resources: ctl46.LoadMask.Msg %>" />
                                        <AjaxEvents>
                                            <Command OnEvent="EditAop_Click">
                                                <ExtraParams>
                                                    <ext:Parameter Name="editData" Value="Ext.encode(#{GridPanel1}.getRowsValues())"
                                                        Mode="Raw">
                                                    </ext:Parameter>
                                                </ExtraParams>
                                            </Command>
                                        </AjaxEvents>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Window ID="AOPEditorWindow" runat="server" Icon="Group" Title="<%$ Resources: AOPEditorWindow.Title %>"
            Closable="false" AutoShow="false" ShowOnLoad="false" Resizable="false" Height="450"
            Draggable="false" Width="600" Modal="true" BodyStyle="padding:5px;">
            <Body>
                <ext:ColumnLayout ID="ColumnLayout2" runat="server" FitHeight="true">
                    <ext:LayoutColumn ColumnWidth="0.5">
                        <ext:Panel ID="pmaintainleft" runat="server" Frame="true" AutoHeight="true" Header="true"
                            Title="<%$ Resources: AOPEditorWindow.pmaintainleft.Title %>">
                            <Body>
                                <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="80">
                                    <ext:Anchor Horizontal="100%">
                                        <ext:ComboBox ID="txtDealer" runat="server" EmptyText="<%$ Resources: AOPEditorWindow.txtDealer.EmptyText %>"
                                            Editable="true" AllowBlank="false" TypeAhead="true" StoreID="DealerStore" ValueField="Id"
                                            DisplayField="ChineseName" ListWidth="300" Resizable="true" FieldLabel="<%$ Resources: AOPEditorWindow.txtDealer.FieldLabel %>"
                                            Mode="Local">
                                            <Triggers>
                                                <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: plSearch.cbDealer.TriggerClick.Handler %>" />
                                            </Triggers>
                                            <Listeners>
                                                <Select Handler="#{txtProdLine}.clearValue(); #{WinProductLineStore}.reload(); " />
                                                <TriggerClick Handler="this.clearValue();#{txtProdLine}.clearValue();#{WinProductLineStore}.reload();" />
                                            </Listeners>
                                        </ext:ComboBox>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:ComboBox ID="txtProdLine" runat="server" EmptyText="<%$ Resources: AOPEditorWindow.txtProdLine.EmptyText %>"
                                            Editable="true" AllowBlank="false" TypeAhead="true" StoreID="WinProductLineStore"
                                            ValueField="Id" DisplayField="AttributeName" ListWidth="300" Resizable="true"
                                            FieldLabel="<%$ Resources: AOPEditorWindow.txtProdLine.FieldLabel %>" Mode="Local">
                                        </ext:ComboBox>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:ComboBox ID="txtYear" runat="server" EmptyText="<%$ Resources: AOPEditorWindow.txtYear.EmptyText %>"
                                            Editable="true" AllowBlank="false" TypeAhead="true" StoreID="YearStore" ValueField="COP_Period"
                                            DisplayField="COP_Period" ListWidth="300" Resizable="true" FieldLabel="<%$ Resources: AOPEditorWindow.txtYear.FieldLabel %>"
                                            Mode="Local">
                                        </ext:ComboBox>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                        </ext:Panel>
                    </ext:LayoutColumn>
                    <ext:LayoutColumn ColumnWidth="0.5">
                        <ext:Panel ID="pmaintainright" runat="server" Frame="true" AutoHeight="true" Header="true"
                            Title="<%$ Resources: AOPEditorWindow.pmaintainright.Title %>">
                            <Body>
                                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="100">
                                    <ext:Anchor Horizontal="100%">
                                        <ext:Label runat="server" ID="lb_desc" Text="<%$ Resources: AOPEditorWindow.lb_desc.Text %>"
                                            FieldLabel="<%$ Resources: AOPEditorWindow.lb_desc.FieldLabel %>">
                                        </ext:Label>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_1" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_1.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_2" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_2.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_3" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_3.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_4" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_4.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_5" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_5.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_6" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_6.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_7" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_7.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_8" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_8.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_9" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_9.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_10" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_10.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_11" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_11.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_12" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_12.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                        </ext:Panel>
                    </ext:LayoutColumn>
                </ext:ColumnLayout>
            </Body>
            <Buttons>
                <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: AOPEditorWindow.SaveButton.Text %>"
                    Icon="Disk">
                    <AjaxEvents>
                        <Click OnEvent="SaveAOP_Click" Success="afterSaveAOPDetails();" Before="return CheckNull();">
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources: AOPEditorWindow.CancelButton.Text %>"
                    Icon="Cancel">
                    <Listeners>
                        <Click Handler="cancelWindow();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Hidden ID="dealerData" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="prodLineData" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidAddMod" runat="server">
        </ext:Hidden>
    </div>
    </form>
</body>
</html>
