<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractAOPEquipmentList.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractAOPEquipmentList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>EquipmentAOP</title>
    <style type="text/css">
        .txtRed
        {
            color: Red;
            font-weight: bold;
        }
        .txtAline
        {
            text-align: left;
        }
        .x-grid3-td-RE_Amount_Y, .x-grid3-td-Amount_Y, .x-grid3-td-RE_Q2, .x-grid3-td-Q2, .x-grid3-td-RE_Q4, .x-grid3-td-Q4
        {
            background-color: #EDEEF0;
        }
    </style>
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
        
        var afterSaveAOPDetails = function() {
            Ext.Msg.alert('<%=GetLocalResourceObject("afterSaveAOPDetails.alert.title").ToString()%>', '<%=GetLocalResourceObject("afterSaveAOPDetails.alert.body").ToString()%>');
            <%=GridPanel1.ClientID%>.reload();
            <%=GridDealerAop.ClientID%>.reload();
        }
         var afterSaveDealerAOPDetails = function() {
            <%= WindowDealerAop.ClientID %>.hide(null);
            Ext.Msg.alert('提示', '保存成功');
            <%=GridDealerAop.ClientID%>.reload();
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
        
         var CheckDealerNull = function(){
                if ( <%= txtDAmount_1.ClientID %>.getValue()==""
                    ||<%= txtDAmount_2.ClientID %>.getValue()==""
                    ||<%= txtDAmount_3.ClientID %>.getValue()==""
                    ||<%= txtDAmount_4.ClientID %>.getValue()==""
                    ||<%= txtDAmount_5.ClientID %>.getValue()==""
                    ||<%= txtDAmount_6.ClientID %>.getValue()==""
                    ||<%= txtDAmount_7.ClientID %>.getValue()==""
                    ||<%= txtDAmount_8.ClientID %>.getValue()==""
                    ||<%= txtDAmount_9.ClientID %>.getValue()==""
                    ||<%= txtDAmount_10.ClientID %>.getValue()==""
                    ||<%= txtDAmount_11.ClientID %>.getValue()==""
                    ||<%= txtDAmount_12.ClientID %>.getValue()=="")
                {
                    alert('请完整填写经销商指标信息');
                    return false;
                }
                return true;
        }
       
        var cancelWindow =function()
        {
             <%= AOPEditorWindow.ClientID %>.hide(null);
        }
        var cancelDealerWindow =function()
        {
             <%= WindowDealerAop.ClientID %>.hide(null);
        }
        
        var ClosePage=function()
        {
            window.open('','_self');
            window.close();
        }
        
        var Img = '<img src="{0}"></img>';       
        var change = function (value)
        {
            if(value=='New'){
                return String.format(Img,'/resources/images/icons/flag_ch.png');
            }
            else
            {
                return "";
            }     
        }
        var Img2 = '<img src="{0}" alt="经销商指标小于医院商业指标或者大于医院商业指标的20%"></img>';       
        var change2 = function (value)
        {
            if(value=='1'){
                return String.format(Img2,'/resources/images/icons/exclamation.png');
            }
            else
            {
                return "";
            }     
        }
        
         function prepareCommand(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            var type = record.data.AOPType;

            if (type == '医院商业指标') {
                firstButton.setVisible(false);
            } else   if (type == '经销商指标'){
                firstButton.setVisible(true);
            }
            else if(type == '经销商指标(修改后)')
            {
                firstButton.setVisible(true);
            }
            else if(type == '经销商指标（当前）')
            {
                firstButton.setVisible(false);
            }
        }

    </script>

    <form id="form1" runat="server">
    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Debug">
        </ext:ScriptManager>
        <ext:JsonStore ID="AOPStore" runat="server" UseIdConfirmation="false" OnRefreshData="AOPStore_RefershData"
            AutoLoad="true">
            <autoloadparams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={15}" />
            </autoloadparams>
            <proxy>
                <ext:DataSourceProxy />
            </proxy>
            <reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Dealer_DMA_ID" />
                        <ext:RecordField Name="ProductLine_BUM_ID" />
                        <ext:RecordField Name="Year" />
                        <ext:RecordField Name="Hospital_ID" />
                        <ext:RecordField Name="OperType" />
                        <ext:RecordField Name="Hospital_Name" />
                        <ext:RecordField Name="Q1" />
                        <ext:RecordField Name="Q2" />
                        <ext:RecordField Name="Q3" />
                        <ext:RecordField Name="Q4" />
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
                        <ext:RecordField Name="RE_Amount_1" />
                        <ext:RecordField Name="RE_Amount_2" />
                        <ext:RecordField Name="RE_Amount_3" />
                        <ext:RecordField Name="RE_Amount_4" />
                        <ext:RecordField Name="RE_Amount_5" />
                        <ext:RecordField Name="RE_Amount_6" />
                        <ext:RecordField Name="RE_Amount_7" />
                        <ext:RecordField Name="RE_Amount_8" />
                        <ext:RecordField Name="RE_Amount_9" />
                        <ext:RecordField Name="RE_Amount_10" />
                        <ext:RecordField Name="RE_Amount_11" />
                        <ext:RecordField Name="RE_Amount_12" />
                        <ext:RecordField Name="RE_Amount_Y" />
                        <ext:RecordField Name="RE_Q1" />
                        <ext:RecordField Name="RE_Q2" />
                        <ext:RecordField Name="RE_Q3" />
                        <ext:RecordField Name="RE_Q4" />
                        <ext:RecordField Name="Formal_Amount_1" />
                        <ext:RecordField Name="Formal_Amount_2" />
                        <ext:RecordField Name="Formal_Amount_3" />
                        <ext:RecordField Name="Formal_Amount_4" />
                        <ext:RecordField Name="Formal_Amount_5" />
                        <ext:RecordField Name="Formal_Amount_6" />
                        <ext:RecordField Name="Formal_Amount_7" />
                        <ext:RecordField Name="Formal_Amount_8" />
                        <ext:RecordField Name="Formal_Amount_9" />
                        <ext:RecordField Name="Formal_Amount_10" />
                        <ext:RecordField Name="Formal_Amount_11" />
                        <ext:RecordField Name="Formal_Amount_12" />
                        <ext:RecordField Name="Formal_Amount_Y" />
                        <ext:RecordField Name="Formal_Q1" />
                        <ext:RecordField Name="Formal_Q2" />
                        <ext:RecordField Name="Formal_Q3" />
                        <ext:RecordField Name="Formal_Q4" />
                        <ext:RecordField Name="row_number" />
                    </Fields>
                </ext:JsonReader>
            </reader>
            <sortinfo field="Dealer_DMA_ID" direction="ASC" />
        </ext:JsonStore>
        <ext:JsonStore ID="AOPHospitalEditer" runat="server" UseIdConfirmation="false" OnRefreshData="AOPHospitalEditer_RefershData"
            AutoLoad="true">
            <proxy>
                <ext:DataSourceProxy />
            </proxy>
            <reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Dealer_DMA_ID" />
                        <ext:RecordField Name="ProductLine_BUM_ID" />
                        <ext:RecordField Name="Hospital_ID" />
                        <ext:RecordField Name="OperType" />
                        <ext:RecordField Name="Hospital_Name" />
                        <ext:RecordField Name="Year" />
                        <ext:RecordField Name="row_number" />
                    </Fields>
                </ext:JsonReader>
            </reader>
            <sortinfo field="Dealer_DMA_ID" direction="ASC" />
        </ext:JsonStore>
        <ext:JsonStore ID="AOPDealerStore" runat="server" UseIdConfirmation="false" OnRefreshData="AOPDealerStore_RefershData"
            AutoLoad="true">
            <autoloadparams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={15}" />
            </autoloadparams>
            <proxy>
                <ext:DataSourceProxy />
            </proxy>
            <reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Dealer_DMA_ID" />
                        <ext:RecordField Name="ProductLine_BUM_ID" />
                        <ext:RecordField Name="AOPType" />
                        <ext:RecordField Name="RmkBody" />
                        <ext:RecordField Name="RefD_H" />
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
            </reader>
            <sortinfo field="Dealer_DMA_ID" direction="ASC" />
        </ext:JsonStore>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <north collapsible="True" marginssummary="0 5 5 5">
                        <ext:Panel ID="plSearch" runat="server" Header="false" BodyBorder="false" Height="0">
                            <Body>
                            </Body>
                        </ext:Panel>
                    </north>
                    <center collapsible="True" marginssummary="0 5 5 5">
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Title="<%$ Resources: ctl46.Title %>"
                            Icon="HouseKey">
                            <body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Header="false" StoreID="AOPStore" Border="false"
                                        Icon="Lorry" AutoExpandColumn="Dealer_DMA_ID" AutoExpandMax="250" AutoExpandMin="150"
                                        StripeRows="true">
                                        <columnmodel id="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="OperType" DataIndex="OperType" Align="Center" Width="30" MenuDisabled="true">
                                                    <Renderer Fn="change" />
                                                </ext:Column>
                                                <ext:CommandColumn ColumnID="Details" Header="<%$ Resources: ctl46.Details.Header %>"
                                                    Align="Center" Width="50">
                                                    <Commands>
                                                        <ext:GridCommand Icon="VcardEdit" CommandName="Modify" ToolTip-Text="<%$ Resources: ctl46.Details.GridCommand.ToolTip-Text %>">
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:Column ColumnID="Dealer_DMA_ID" DataIndex="Dealer_DMA_ID" Header="<%$ Resources: ctl46.Dealer_DMA_ID.Header %>"
                                                    Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLine_BUM_ID" DataIndex="ProductLine_BUM_ID" Header="<%$ Resources: ctl46.ProductLine_BUM_ID.Header %>"
                                                    Width="100" Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="Year" DataIndex="Year" Header="<%$ Resources: ctl46.Year.Header %>"
                                                    Width="50">
                                                </ext:Column>
                                                <ext:Column ColumnID="Hospital_Name" DataIndex="Hospital_Name" Header="<%$ Resources: ctl46.HospitalName.Header %>"
                                                    Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="RE_Amount_Y" DataIndex="RE_Amount_Y" Header="合计<br/>标准(￥)"
                                                    Width="65" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_Y" DataIndex="Amount_Y" Header="合计<br/>实际(￥)" Align="Center"
                                                    Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RE_Q1" DataIndex="RE_Q1" Header="Q1<br/>标准(￥)" Width="65" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Q1" DataIndex="Q1" Header="Q1<br/>实际(￥)" Width="65" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RE_Q2" DataIndex="RE_Q2" Header="Q2<br/>标准(￥)" Width="65" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Q2" DataIndex="Q2" Header="Q2<br/>实际(￥)" Width="65" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RE_Q3" DataIndex="RE_Q3" Header="Q3<br/>标准(￥)" Width="65" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Q3" DataIndex="Q3" Header="Q3<br/>实际(￥)" Width="65" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="RE_Q4" DataIndex="RE_Q4" Header="Q4<br/>标准(￥)" Width="65" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Q4" DataIndex="Q4" Header="Q4<br/>实际(￥)" Width="65" Align="Center">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_1" DataIndex="Amount_1" Header="<%$ Resources: ctl46.Amount_1.Header %>"
                                                    Align="Center" Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_2" DataIndex="Amount_2" Header="<%$ Resources: ctl46.Amount_2.Header %>"
                                                    Align="Center" Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_3" DataIndex="Amount_3" Header="<%$ Resources: ctl46.Amount_3.Header %>"
                                                    Align="Center" Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_4" DataIndex="Amount_4" Header="<%$ Resources: ctl46.Amount_4.Header %>"
                                                    Align="Center" Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_5" DataIndex="Amount_5" Header="<%$ Resources: ctl46.Amount_5.Header %>"
                                                    Align="Center" Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_6" DataIndex="Amount_6" Header="<%$ Resources: ctl46.Amount_6.Header %>"
                                                    Align="Center" Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_7" DataIndex="Amount_7" Header="<%$ Resources: ctl46.Amount_7.Header %>"
                                                    Align="Center" Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_8" DataIndex="Amount_8" Header="<%$ Resources: ctl46.Amount_8.Header %>"
                                                    Align="Center" Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_9" DataIndex="Amount_9" Header="<%$ Resources: ctl46.Amount_9.Header %>"
                                                    Align="Center" Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_10" DataIndex="Amount_10" Header="<%$ Resources: ctl46.Amount_10.Header %>"
                                                    Align="Center" Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_11" DataIndex="Amount_11" Header="<%$ Resources: ctl46.Amount_11.Header %>"
                                                    Align="Center" Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_12" DataIndex="Amount_12" Header="<%$ Resources: ctl46.Amount_12.Header %>"
                                                    Align="Center" Width="65">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="row_number" DataIndex="row_number" Width="60" Hidden="true">
                                                </ext:Column>
                                            </Columns>
                                        </columnmodel>
                                        <selectionmodel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                        </selectionmodel>
                                        <bottombar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="AOPStore"
                                                DisplayInfo="true" EmptyMsg="<%$ Resources: ctl46.PagingToolBar1.EmptyMsg %>" />
                                        </bottombar>
                                        <loadmask showmask="true" msg="<%$ Resources: ctl46.LoadMask.Msg %>" />
                                        <ajaxevents>
                                            <Command OnEvent="EditAop_Click">
                                                <ExtraParams>
                                                    <ext:Parameter Name="editData" Value="Ext.encode(#{GridPanel1}.getRowsValues())"
                                                        Mode="Raw">
                                                    </ext:Parameter>
                                                </ExtraParams>
                                            </Command>
                                        </ajaxevents>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </body>
                        </ext:Panel>
                    </center>
                    <south collapsible="True" marginssummary="0 5 0 5">
                        <ext:Panel runat="server" ID="PanelDealerAop" Border="false" Frame="true" Title="经销商指标列表:<img src='/resources/images/icons/exclamation.png' > </img> 经销商指标小于医院指标或者大于医院指标的20%  <span style=' color:Red;'>【医院商业指标 = 所有医院实际指标合计】</span>"
                            Icon="HouseKey" Height="200" ButtonAlign="Left">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="GridDealerAop" runat="server" Header="false" StoreID="AOPDealerStore"
                                        Border="false" Icon="Lorry" AutoExpandColumn="AOPD_Dealer_DMA_ID" Height="150"
                                        StripeRows="true">
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="RefD_H" DataIndex="RefD_H" Align="Center" Width="30" MenuDisabled="true">
                                                    <Renderer Fn="change2" />
                                                </ext:Column>
                                                <ext:CommandColumn ColumnID="Details" Header="编辑" Width="50" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="VcardEdit" CommandName="Modify" ToolTip-Text="编辑">
                                                        </ext:GridCommand>
                                                    </Commands>
                                                    <PrepareToolbar Fn="prepareCommand" />
                                                </ext:CommandColumn>
                                                <ext:Column ColumnID="AOPD_Dealer_DMA_ID" DataIndex="AOPD_Dealer_DMA_ID" Header="经销商"
                                                    Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="AOPType" DataIndex="AOPType" Header="指标类型" Width="110" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="Year" DataIndex="Year" Header="<%$ Resources: dealer.Year.Header %>"
                                                    Width="50">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_Y" DataIndex="Amount_Y" Header="<%$ Resources: dealer.Amount_Total.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_1" DataIndex="Amount_1" Header="<%$ Resources: dealer.Amount_1.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_2" DataIndex="Amount_2" Header="<%$ Resources: dealer.Amount_2.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_3" DataIndex="Amount_3" Header="<%$ Resources: dealer.Amount_3.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_4" DataIndex="Amount_4" Header="<%$ Resources: dealer.Amount_4.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_5" DataIndex="Amount_5" Header="<%$ Resources: dealer.Amount_5.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_6" DataIndex="Amount_6" Header="<%$ Resources: dealer.Amount_6.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_7" DataIndex="Amount_7" Header="<%$ Resources: dealer.Amount_7.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_8" DataIndex="Amount_8" Header="<%$ Resources: dealer.Amount_8.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_9" DataIndex="Amount_9" Header="<%$ Resources: dealer.Amount_9.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_10" DataIndex="Amount_10" Header="<%$ Resources: dealer.Amount_10.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_11" DataIndex="Amount_11" Header="<%$ Resources: dealer.Amount_11.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount_12" DataIndex="Amount_12" Header="<%$ Resources: dealer.Amount_12.Header %>"
                                                    Width="90">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" SingleSelect="true" />
                                        </SelectionModel>
                                        <AjaxEvents>
                                            <Command OnEvent="EditDealerAop_Click">
                                                <ExtraParams>
                                                    <ext:Parameter Name="editData" Value="Ext.encode(#{GridDealerAop}.getRowsValues())"
                                                        Mode="Raw">
                                                    </ext:Parameter>
                                                </ExtraParams>
                                            </Command>
                                        </AjaxEvents>
                                        <LoadMask ShowMask="true" Msg="<%$ Resources: dealer.LoadMask.Msg %>" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="Button6" runat="server" Text="提交" Icon="Disk" CommandArgument=""
                                    CommandName="" IDMode="Legacy">
                                    <Listeners>
                                        <Click Fn="ClosePage" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </south>
                </ext:BorderLayout>
            </body>
        </ext:ViewPort>
        <ext:Window ID="AOPEditorWindow" runat="server" Icon="Group" Title="<%$ Resources: AOPEditorWindow.Title %>"
            Closable="false" AutoShow="false" ShowOnLoad="false" Resizable="false" Height="580"
            Draggable="false" Width="700" Modal="true" BodyStyle="padding:5px;">
            <body>
                <ext:ColumnLayout ID="ColumnLayout2" runat="server" FitHeight="true">
                    <ext:LayoutColumn ColumnWidth="0.4">
                        <ext:Panel runat="server" ID="TXT" BodyBorder="false">
                            <body>
                                <ext:BorderLayout ID="BorderLayout2" runat="server">
                                    <north collapsible="True" marginssummary="0 0 0 5">
                                        <ext:Panel ID="pmaintainleft" runat="server" Frame="true" AutoHeight="true" Header="true"
                                            Title="<%$ Resources: AOPEditorWindow.pmaintainleft.Title %>">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="80">
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Label ID="txtHospitalName" runat="server" FieldLabel="<%$ Resources: AOPEditorWindow.txtHospitalName.FieldLabel %>"
                                                            CtCls="txtRed">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Label ID="txtYear" runat="server" FieldLabel="年度" CtCls="txtRed">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Hidden ID="txtHidYear" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Hidden ID="txtProdLine" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Hidden ID="txtHospitalID" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </north>
                                    <center collapsible="True" marginssummary="0 0 0 5">
                                        <ext:Panel runat="server" ID="Panel2" Border="false" Frame="true" Icon="HouseKey"
                                            Title="医院">
                                            <body>
                                                <ext:FitLayout ID="FitLayout2" runat="server">
                                                    <ext:GridPanel ID="txtGPHospitalUpdate" runat="server" Header="false" StoreID="AOPHospitalEditer"
                                                        Border="false" Icon="Lorry" AutoExpandColumn="Hospital_Name" AutoExpandMax="250"
                                                        AutoExpandMin="150" StripeRows="true">
                                                        <columnmodel id="ColumnModel4" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Year" DataIndex="Year" Header="年度" Width="50">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Hospital_Name" DataIndex="Hospital_Name" Header="医院名称" Width="110">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductLine_BUM_ID" DataIndex="ProductLine_BUM_ID" Width="100"
                                                                    Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Hospital_ID" DataIndex="Hospital_ID" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="row_number" DataIndex="row_number" Width="80" Hidden="true">
                                                                </ext:Column>
                                                            </Columns>
                                                        </columnmodel>
                                                        <selectionmodel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel4" runat="server" SingleSelect="true">
                                                                <AjaxEvents>
                                                                    <RowSelect OnEvent="RowSelect" Buffer="250">
                                                                        <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="#{Details}" />
                                                                        <ExtraParams>
                                                                            <ext:Parameter Name="HospitalAOPEditer" Value="Ext.encode(#{txtGPHospitalUpdate}.getRowsValues())"
                                                                                Mode="Raw" />
                                                                        </ExtraParams>
                                                                    </RowSelect>
                                                                </AjaxEvents>
                                                            </ext:RowSelectionModel>
                                                        </selectionmodel>
                                                        <loadmask showmask="true" msg="处理中..." />
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </body>
                                        </ext:Panel>
                                    </center>
                                </ext:BorderLayout>
                            </body>
                        </ext:Panel>
                    </ext:LayoutColumn>
                    <ext:LayoutColumn ColumnWidth="0.6">
                        <ext:Panel runat="server" ID="Panel09" BodyBorder="false">
                            <body>
                                <ext:BorderLayout ID="BorderLayout04" runat="server">
                                    <center collapsible="True" marginssummary="0 0 0 5">
                                        <ext:Panel ID="Details" runat="server" Frame="true" Header="true" Title="经销商医院指标">
                                            <body>
                                                <ext:ColumnLayout ID="ColumnLayout4" runat="server" FitHeight="true">
                                                    <ext:LayoutColumn ColumnWidth="0.6">
                                                        <ext:Panel ID="Panel5" runat="server" Frame="false" Header="true">
                                                            <body>
                                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="70">
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:Label runat="server" ID="lb_desc" Text="标准值" FieldLabel="月份">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtRe_1" runat="server" FieldLabel="1月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtRe_2" runat="server" FieldLabel="2月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtRe_3" runat="server" FieldLabel="3月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtRe_4" runat="server" FieldLabel="4月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtRe_5" runat="server" FieldLabel="5月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtRe_6" runat="server" FieldLabel="6月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtRe_7" runat="server" FieldLabel="7月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtRe_8" runat="server" FieldLabel="8月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtRe_9" runat="server" FieldLabel="9月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtRe_10" runat="server" FieldLabel="10月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtRe_11" runat="server" FieldLabel="11月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtRe_12" runat="server" FieldLabel="12月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.4">
                                                        <ext:Panel ID="Panel6" runat="server" Frame="false" Header="true">
                                                            <body>
                                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="100">
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:Label runat="server" ID="Label3" FieldLabel="金额" LabelSeparator="">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_1" runat="server" HideLabel="true" LabelSeparator=""
                                                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_2" runat="server" HideLabel="true" LabelSeparator=""
                                                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_3" runat="server" HideLabel="true" LabelSeparator=""
                                                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_4" runat="server" HideLabel="true" LabelSeparator=""
                                                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_5" runat="server" HideLabel="true" LabelSeparator=""
                                                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_6" runat="server" HideLabel="true" LabelSeparator=""
                                                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_7" runat="server" HideLabel="true" LabelSeparator=""
                                                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_8" runat="server" HideLabel="true" LabelSeparator=""
                                                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_9" runat="server" HideLabel="true" LabelSeparator=""
                                                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_10" runat="server" HideLabel="true" LabelSeparator=""
                                                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_11" runat="server" HideLabel="true" LabelSeparator=""
                                                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_12" runat="server" HideLabel="true" LabelSeparator=""
                                                                            MaskRe="/[0-9\.]/" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </body>
                                        </ext:Panel>
                                    </center>
                                    <south collapsible="True" marginssummary="0 0 0 5">
                                        <ext:Panel ID="panelHospitalProductRemark" runat="server" Frame="true" AutoHeight="true"
                                            Title="实际值不等于标准值时，请填写原因：">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextArea ID="hospitaleRemark" runat="server" HideLabel="true" Height="50" Width="410">
                                                        </ext:TextArea>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </south>
                                </ext:BorderLayout>
                            </body>
                        </ext:Panel>
                    </ext:LayoutColumn>
                </ext:ColumnLayout>
            </body>
            <buttons>
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
            </buttons>
        </ext:Window>
        <ext:Window ID="WindowDealerAop" runat="server" Icon="Group" Title="经销商指标设置" Closable="false"
            AutoShow="false" ShowOnLoad="false" Resizable="false" Height="600" Draggable="false"
            Width="550" Modal="true" BodyStyle="padding:5px;">
            <body>
                <ext:ColumnLayout ID="ColumnLayout3" runat="server" FitHeight="true">
                    <ext:LayoutColumn ColumnWidth="0.1">
                        <ext:Panel runat="server" ID="Panel12" BodyBorder="false">
                            <body>
                                <ext:BorderLayout ID="BorderLayout5" runat="server">
                                    <north marginssummary="0 0 0 5">
                                        <ext:Panel ID="Panel1" runat="server" Frame="true" Height="40" Header="false" Hidden="true">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="80">
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Hidden ID="hidDealerProdLineId" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Hidden ID="hidDealerAopYear" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Label ID="txtDealerAopYear" runat="server" FieldLabel="年度" CtCls="txtRed">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Hidden ID="hidDealerAopRemarkId" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </north>
                                    <center collapsible="True" marginssummary="0 0 0 5">
                                        <ext:Panel ID="Panel4" runat="server" Frame="true" Header="true" Title="经销商指标">
                                            <body>
                                                <ext:ColumnLayout ID="ColumnLayout5" runat="server" FitHeight="true">
                                                    <ext:LayoutColumn ColumnWidth="0.6">
                                                        <ext:Panel ID="Panel7" runat="server" Frame="false" Header="true">
                                                            <body>
                                                                <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="70">
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:Label runat="server" ID="Label4" Text="医院商业指标" FieldLabel="月份">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtReHosAmount_1" runat="server" FieldLabel="1月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtReHosAmount_2" runat="server" FieldLabel="2月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtReHosAmount_3" runat="server" FieldLabel="3月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtReHosAmount_4" runat="server" FieldLabel="4月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtReHosAmount_5" runat="server" FieldLabel="5月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtReHosAmount_6" runat="server" FieldLabel="6月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtReHosAmount_7" runat="server" FieldLabel="7月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtReHosAmount_8" runat="server" FieldLabel="8月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtReHosAmount_9" runat="server" FieldLabel="9月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtReHosAmount_10" runat="server" FieldLabel="10月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtReHosAmount_11" runat="server" FieldLabel="11月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtReHosAmount_12" runat="server" FieldLabel="12月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.4">
                                                        <ext:Panel ID="Panel8" runat="server" Frame="false" Header="true">
                                                            <body>
                                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelWidth="100">
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:Label runat="server" ID="Label1" Text="经销商指标" HideLabel="true">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtDAmount_1" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtDAmount_2" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtDAmount_3" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtDAmount_4" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtDAmount_5" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtDAmount_6" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtDAmount_7" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtDAmount_8" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtDAmount_9" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtDAmount_10" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtDAmount_11" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtDAmount_12" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:Label ID="txtAopErrorMag" runat="server" HideLabel="false" LabelSeparator="">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </body>
                                        </ext:Panel>
                                    </center>
                                    <south collapsible="True" marginssummary="0 0 0 5">
                                        <ext:Panel ID="panel13" runat="server" Frame="true" AutoHeight="true" Title="经销商指标小于医院指标或大于医院指标20%原因：">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout9" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextArea ID="txtDealerAopRemark" runat="server" HideLabel="true" Width="480">
                                                        </ext:TextArea>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </south>
                                </ext:BorderLayout>
                            </body>
                        </ext:Panel>
                    </ext:LayoutColumn>
                </ext:ColumnLayout>
            </body>
            <buttons>
                <ext:Button ID="SaveAmountButton" runat="server" Text="提交" Icon="Disk">
                    <AjaxEvents>
                        <Click OnEvent="SaveAOPDealer_Click" Success="afterSaveDealerAOPDetails();" Before="return CheckDealerNull();">
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="Button4" runat="server" Text="关闭" Icon="Cancel">
                    <Listeners>
                        <Click Handler="cancelDealerWindow();" />
                    </Listeners>
                </ext:Button>
            </buttons>
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
        <ext:Hidden ID="prodLineData" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidAddMod" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidProductLineId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsChange" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsEmerging" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidContractType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidYearString" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidMinYear" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidMinMonth" runat="server">
        </ext:Hidden>
    </div>
    </form>
</body>
</html>
