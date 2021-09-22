<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractDealerAOPList.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractDealerAOPList" %>

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
        
     
        
        var afterSaveAOPDetails = function() {
            <%= AOPEditorWindow.ClientID %>.hide(null);
            Ext.Msg.alert('<%=GetLocalResourceObject("afterSaveAOPDetails.alert.title").ToString()%>', '<%=GetLocalResourceObject("afterSaveAOPDetails.alert.body").ToString()%>');
            <%=GridPanel1.ClientID%>.reload();
        }
       
        var CheckNull = function(){
                if ( <%= txtAmount_1.ClientID %>.getValue()==""
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
        
        var ClosePage=function()
        {
            window.open('','_self');
            window.close();
        }

    </script>

    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Debug">
        </ext:ScriptManager>
        <ext:Store ID="YearStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshFYCO"
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
            AutoLoad="true">
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
                        <ext:RecordField Name="CCName" />
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
                        <ext:RecordField Name="FmAmount_1" />
                        <ext:RecordField Name="FmAmount_2" />
                        <ext:RecordField Name="FmAmount_3" />
                        <ext:RecordField Name="FmAmount_4" />
                        <ext:RecordField Name="FmAmount_5" />
                        <ext:RecordField Name="FmAmount_6" />
                        <ext:RecordField Name="FmAmount_7" />
                        <ext:RecordField Name="FmAmount_8" />
                        <ext:RecordField Name="FmAmount_9" />
                        <ext:RecordField Name="FmAmount_10" />
                        <ext:RecordField Name="FmAmount_11" />
                        <ext:RecordField Name="FmAmount_12" />
                        <ext:RecordField Name="FmAmount_Y" />
                        <ext:RecordField Name="DiffAmount_1" />
                        <ext:RecordField Name="DiffAmount_2" />
                        <ext:RecordField Name="DiffAmount_3" />
                        <ext:RecordField Name="DiffAmount_4" />
                        <ext:RecordField Name="DiffAmount_5" />
                        <ext:RecordField Name="DiffAmount_6" />
                        <ext:RecordField Name="DiffAmount_7" />
                        <ext:RecordField Name="DiffAmount_8" />
                        <ext:RecordField Name="DiffAmount_9" />
                        <ext:RecordField Name="DiffAmount_10" />
                        <ext:RecordField Name="DiffAmount_11" />
                        <ext:RecordField Name="DiffAmount_12" />
                        <ext:RecordField Name="DiffAmount_Y" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Dealer_DMA_ID" Direction="ASC" />
        </ext:JsonStore>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="plSearch" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbYear" runat="server" EmptyText="请选择年份..." Width="200" Editable="true"
                                                            TypeAhead="true" StoreID="YearStore" ValueField="COP_Period" DisplayField="COP_Period"
                                                            ListWidth="200" Resizable="true" FieldLabel="年份" Mode="Local">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
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
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                    <ext:Anchor>
                                                        <ext:Hidden runat="server" ID="hd">
                                                        </ext:Hidden>
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
                                        <Click Handler="#{PagingToolBar1}.doLoad(0);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="Button1" runat="server" Text="提交" Icon="Disk" CommandArgument=""
                                    CommandName="" IDMode="Legacy">
                                    <Listeners>
                                        <Click Fn="ClosePage" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Title="查询结果" Icon="HouseKey">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Header="false" StoreID="AOPStore" Border="false"
                                        Icon="Lorry" AutoExpandColumn="Dealer_DMA_ID" AutoExpandMax="250" AutoExpandMin="150"
                                        StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:CommandColumn ColumnID="Details" Header="修改" Align="Center" Width="60">
                                                    <Commands>
                                                        <ext:GridCommand Icon="VcardEdit" CommandName="Modify" ToolTip-Text="修改">
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:Column ColumnID="Dealer_DMA_ID" DataIndex="Dealer_DMA_ID" Header="<%$ Resources: ctl46.Dealer_DMA_ID.Header %>"
                                                    Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLine_BUM_ID" DataIndex="ProductLine_BUM_ID" Header="<%$ Resources: ctl46.ProductLine_BUM_ID.Header %>"
                                                    Width="150" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="CCName" DataIndex="CCName" Header="产品分类" Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="Year" DataIndex="Year" Header="<%$ Resources: ctl46.Year.Header %>"
                                                    Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_Y" DataIndex="Amount_Y" Header="<%$ Resources: ctl46.Amount_Total.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_1" DataIndex="Amount_1" Header="<%$ Resources: ctl46.Amount_1.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_2" DataIndex="Amount_2" Header="<%$ Resources: ctl46.Amount_2.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_3" DataIndex="Amount_3" Header="<%$ Resources: ctl46.Amount_3.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_4" DataIndex="Amount_4" Header="<%$ Resources: ctl46.Amount_4.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_5" DataIndex="Amount_5" Header="<%$ Resources: ctl46.Amount_5.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_6" DataIndex="Amount_6" Header="<%$ Resources: ctl46.Amount_6.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_7" DataIndex="Amount_7" Header="<%$ Resources: ctl46.Amount_7.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_8" DataIndex="Amount_8" Header="<%$ Resources: ctl46.Amount_8.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_9" DataIndex="Amount_9" Header="<%$ Resources: ctl46.Amount_9.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_10" DataIndex="Amount_10" Header="<%$ Resources: ctl46.Amount_10.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_11" DataIndex="Amount_11" Header="<%$ Resources: ctl46.Amount_11.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_12" DataIndex="Amount_12" Header="<%$ Resources: ctl46.Amount_12.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
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
            Closable="false" AutoShow="false" ShowOnLoad="false" Resizable="false" Height="500"
            Draggable="false" Width="600" Modal="true" BodyStyle="padding:5px;">
            <Body>
                <ext:ColumnLayout ID="ColumnLayout2" runat="server" FitHeight="true">
                    <ext:LayoutColumn ColumnWidth="0.5">
                        <ext:Panel ID="pmaintainleft" runat="server" Frame="true" AutoHeight="true" Header="true"
                            Title="<%$ Resources: AOPEditorWindow.pmaintainleft.Title %>">
                            <Body>
                                <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="80">
                                    <ext:Anchor Horizontal="100%">
                                        <ext:Label ID="txtClassification" runat="server" FieldLabel="产品分类">
                                        </ext:Label>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:Label ID="txtYear" runat="server" FieldLabel="年份">
                                        </ext:Label>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:Hidden ID="hidtxtYear" runat="server">
                                        </ext:Hidden>
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
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false" Enabled="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_2" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_2.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false" Enabled="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_3" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_3.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false" Enabled="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_4" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_4.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false" Enabled="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_5" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_5.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false" Enabled="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_6" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_6.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false" Enabled="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_7" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_7.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false" Enabled="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_8" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_8.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false" Enabled="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_9" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_9.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false" Enabled="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_10" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_10.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false" Enabled="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_11" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_11.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false" Enabled="false">
                                        </ext:TextField>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:TextField ID="txtAmount_12" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtAmount_12.FieldLabel %>"
                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false" Enabled="false">
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
        <ext:Hidden ID="hidContractID" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDealerID" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDivisionID" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="HidEffectiveDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="HidExpirationDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidProductLineId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidPartsContractCode" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidPartsContractId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsEmerging" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidContractType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidMinYear" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidYearString" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidBeginYearMinMonth" runat="server">
        </ext:Hidden>
          <ext:Hidden ID="hidSheBei" runat="server">
        </ext:Hidden>
        
    </div>
    </form>
</body>
</html>
