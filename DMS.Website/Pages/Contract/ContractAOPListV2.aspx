<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractAOPListV2.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractAOPListV2" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>经销商指标设定</title>
    <style type="text/css">
        .txtRed
        {
            color: Red;
            font-weight: bold;
        }
        .x-grid3-col-RefQ2, .x-grid3-col-Q2, .x-grid3-col-RefQ4, .x-grid3-col-Q4, .x-grid3-col-AOPD_Amount_Y
        {
            background-color: #EDEEF0;
        }
        .x-grid3-col-RefYear, .x-grid3-col-UnitY, .x-grid3-col-AOPD_Amount_Y
        {
            background-color: #BBFFBB;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">
        Ext.apply(Ext.util.Format, {            number: function(v, format) {                if(!format){                    return v;                }                                                v *= 1;                if(typeof v != 'number' || isNaN(v)){                    return '';                }                var comma = ',';                var dec = '.';                var i18n = false;                                if(format.substr(format.length - 2) == '/i'){                    format = format.substr(0, format.length-2);                    i18n = true;                    comma = '.';                    dec = ',';                }                var hasComma = format.indexOf(comma) != -1,                    psplit = (i18n ? format.replace(/[^\d\,]/g,'') : format.replace(/[^\d\.]/g,'')).split(dec);                if (1 < psplit.length) {                    v = v.toFixed(psplit[1].length);                }                else if (2 < psplit.length) {                    throw('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format);                }                else {                    v = v.toFixed(0);                }                var fnum = v.toString();                if (hasComma) {                    psplit = fnum.split('.');                    var cnum = psplit[0],                        parr = [],                        j = cnum.length,                        m = Math.floor(j / 3),                        n = cnum.length % 3 || 3;                    for (var i = 0; i < j; i += n) {                        if (i != 0) {n = 3;}                        parr[parr.length] = cnum.substr(i, n);                        m -= 1;                    }                    fnum = parr.join(comma);                    if (psplit[1]) {                        fnum += dec + psplit[1];                    }                }                return format.replace(/[\d,?\.?]+/, fnum);            },            numberRenderer : function(format){                return function(v){                    return Ext.util.Format.number(v, format);                };            }        });
    
        var SubmitPriceClick = function(tree) {
                var checkedNodes = tree.getChecked();
                var Nodesid = [];
                for (var i = 0; i < checkedNodes.length; i++) {
                    Nodesid.push(checkedNodes[i].id);
                }
                var TabPanel = <%= TabPanelDeatil.ClientID %>;
                var TabAop = <%= TabDealerAop.ClientID %>;
                TabAop.disabled=false;
                TabPanel.setActiveTab(TabAop);
                
                Coolite.AjaxMethods.SaveProductPrice(Nodesid.toString(), { success: function(result) {if(result==''){ Ext.getCmp('<%=this.GridDealerAop.ClientID%>').reload();
               
                }else{Ext.Msg.alert('Error', result); } }, failuer: function(err) { Ext.Msg.alert('Error', err); } });
            }
            
         var NextClick = function() {

                var TabPanel = <%= TabPanelDeatil.ClientID %>;
                var TabAop = <%= TabDealerAop.ClientID %>;
                TabAop.disabled=false;
                TabPanel.setActiveTab(TabAop);
                Ext.getCmp('<%=this.GridDealerAop.ClientID%>').reload();
        }    
         
        
        function prepareCommand(grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            var type = record.data.AOPType;

            if (type == '经销商医院实际指标') {
                firstButton.setVisible(false);
            } else   if (type == '经销商商业采购指标'){
                firstButton.setVisible(true);
            }
        }
        
        var template = '<span style="color:{0}; width:100%; margin:0 0 0 0; font-size:larger;">{1}</span>';
        var changeColumn1 = function(value) {
            return String.format(template, 'green' , value);
        }
        
        var Img = '<img src="{0}" alt="本次新增授权医院"></img>';       
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
        
        var ImgDiff = '<img src="{0}" alt="经销商指标小于医院指标或者大于医院指标的20%"></img>';       
        var changeDiff = function (value)
        {
            if(value=='1'){
                return String.format(ImgDiff,'/resources/images/icons/exclamation.png');
            }
            else
            {
                return "";
            }     
        }
        
        var ClosePage=function()
        {
            window.open('','_self');
            window.close();
        }
        
        var cancelWindow =function()
        {
             <%= AOPHospitalWindow.ClientID %>.hide(null);
        }
        
       var CheckHospitalNull = function(){
                if ( <%= txtHospitalID.ClientID %>.getValue()=="" || <%= txtHospitalName.ClientID %>.getText()=="" || <%= txtYear.ClientID %>.getText()==""
                    ||<%= txtUnit_1.ClientID %>.getValue()==""
                    ||<%= txtUnit_2.ClientID %>.getValue()==""
                    ||<%= txtUnit_3.ClientID %>.getValue()==""
                    ||<%= txtUnit_4.ClientID %>.getValue()==""
                    ||<%= txtUnit_5.ClientID %>.getValue()==""
                    ||<%= txtUnit_6.ClientID %>.getValue()==""
                    ||<%= txtUnit_7.ClientID %>.getValue()==""
                    ||<%= txtUnit_8.ClientID %>.getValue()==""
                    ||<%= txtUnit_9.ClientID %>.getValue()==""
                    ||<%= txtUnit_10.ClientID %>.getValue()==""
                    ||<%= txtUnit_11.ClientID %>.getValue()==""
                    ||<%= txtUnit_12.ClientID %>.getValue()==""
                    ||(<%= txtUnit_1.ClientID %>.getValue()=="0"&&<%= txtUnit_2.ClientID %>.getValue()=="0"&&<%= txtUnit_3.ClientID %>.getValue()=="0"&&<%= txtUnit_4.ClientID %>.getValue()=="0"&&<%= txtUnit_5.ClientID %>.getValue()=="0"
                        &&<%= txtUnit_6.ClientID %>.getValue()=="0"&&<%= txtUnit_7.ClientID %>.getValue()=="0"&&<%= txtUnit_8.ClientID %>.getValue()=="0"&&<%= txtUnit_9.ClientID %>.getValue()=="0"&&<%= txtUnit_10.ClientID %>.getValue()=="0" &&<%= txtUnit_11.ClientID %>.getValue()=="0" &&<%= txtUnit_12.ClientID %>.getValue()=="0")
                    
                    )
                {
                    alert('请完整填写经销商医院指标信息且医院指标不能为 0 ');
                    return false;
                }
                return true;
        }
        
       var CheckDealerNull = function(){
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
                    alert('请完整填写经销商指标信息');
                    return false;
                }
                return true;
        }
        
       var afterSaveAOPDetails = function() {
            Ext.Msg.alert('提示', '保存成功');
            <%=GridPanelAOPStore.ClientID%>.reload();
            <%=GridDealerAop.ClientID%>.reload();
        }
        
       var afterSaveDealerAOPDetails = function() {
            Ext.Msg.alert('提示', '保存成功');
            <%=GridDealerAop.ClientID%>.reload();
        }
        
       var cancelDealerWindow =function()
        {
             <%= WindowDealerAop.ClientID %>.hide(null);
        }
    </script>

    <div>
        <ext:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Debug">
        </ext:ScriptManager>
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
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="ProductLineId" />
                        <ext:RecordField Name="ProductId" />
                        <ext:RecordField Name="ProductName" />
                        <ext:RecordField Name="HospitalId" />
                        <ext:RecordField Name="OperType" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="Year" />
                        <ext:RecordField Name="Unit1" />
                        <ext:RecordField Name="Unit2" />
                        <ext:RecordField Name="Unit3" />
                        <ext:RecordField Name="Unit4" />
                        <ext:RecordField Name="Unit5" />
                        <ext:RecordField Name="Unit6" />
                        <ext:RecordField Name="Unit7" />
                        <ext:RecordField Name="Unit8" />
                        <ext:RecordField Name="Unit9" />
                        <ext:RecordField Name="Unit10" />
                        <ext:RecordField Name="Unit11" />
                        <ext:RecordField Name="Unit12" />
                        <ext:RecordField Name="Q1" />
                        <ext:RecordField Name="Q2" />
                        <ext:RecordField Name="Q3" />
                        <ext:RecordField Name="Q4" />
                        <ext:RecordField Name="UnitY" />
                        <ext:RecordField Name="RefUnit1" />
                        <ext:RecordField Name="RefUnit2" />
                        <ext:RecordField Name="RefUnit3" />
                        <ext:RecordField Name="RefUnit4" />
                        <ext:RecordField Name="RefUnit5" />
                        <ext:RecordField Name="RefUnit6" />
                        <ext:RecordField Name="RefUnit7" />
                        <ext:RecordField Name="RefUnit8" />
                        <ext:RecordField Name="RefUnit9" />
                        <ext:RecordField Name="RefUnit10" />
                        <ext:RecordField Name="RefUnit11" />
                        <ext:RecordField Name="RefUnit12" />
                        <ext:RecordField Name="RefQ1" />
                        <ext:RecordField Name="RefQ2" />
                        <ext:RecordField Name="RefQ3" />
                        <ext:RecordField Name="RefQ4" />
                        <ext:RecordField Name="RefYear" />
                        <ext:RecordField Name="FromalUnit1" />
                        <ext:RecordField Name="FromalUnit2" />
                        <ext:RecordField Name="FromalUnit3" />
                        <ext:RecordField Name="FromalUnit4" />
                        <ext:RecordField Name="FromalUnit5" />
                        <ext:RecordField Name="FromalUnit6" />
                        <ext:RecordField Name="FromalUnit7" />
                        <ext:RecordField Name="FromalUnit8" />
                        <ext:RecordField Name="FromalUnit9" />
                        <ext:RecordField Name="FromalUnit10" />
                        <ext:RecordField Name="FromalUnit11" />
                        <ext:RecordField Name="FromalUnit12" />
                        <ext:RecordField Name="FromalQ1" />
                        <ext:RecordField Name="FromalQ2" />
                        <ext:RecordField Name="FromalQ3" />
                        <ext:RecordField Name="FromalQ4" />
                        <ext:RecordField Name="FromalYear" />
                        <ext:RecordField Name="row_number" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="DmaId" Direction="ASC" />
        </ext:JsonStore>
        <ext:JsonStore ID="AOPHospitalEditer" runat="server" UseIdConfirmation="false" OnRefreshData="AOPHospitalEditer_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="ProductLineId" />
                        <ext:RecordField Name="ProductId" />
                        <ext:RecordField Name="ProductName" />
                        <ext:RecordField Name="HospitalId" />
                        <ext:RecordField Name="OperType" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="Year" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="DmaId" Direction="ASC" />
        </ext:JsonStore>
        <ext:Store ID="AOPDealerStore" runat="server" UseIdConfirmation="false" OnRefreshData="AOPDealerStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="AOPD_Contract_ID" />
                        <ext:RecordField Name="AOPD_Dealer_DMA_ID" />
                        <ext:RecordField Name="AOPD_ProductLine_BUM_ID" />
                        <ext:RecordField Name="AOPD_Year" />
                        <ext:RecordField Name="Q1" />
                        <ext:RecordField Name="Q2" />
                        <ext:RecordField Name="Q3" />
                        <ext:RecordField Name="Q4" />
                        <ext:RecordField Name="AOPD_Amount_1" />
                        <ext:RecordField Name="AOPD_Amount_2" />
                        <ext:RecordField Name="AOPD_Amount_3" />
                        <ext:RecordField Name="AOPD_Amount_4" />
                        <ext:RecordField Name="AOPD_Amount_5" />
                        <ext:RecordField Name="AOPD_Amount_6" />
                        <ext:RecordField Name="AOPD_Amount_7" />
                        <ext:RecordField Name="AOPD_Amount_8" />
                        <ext:RecordField Name="AOPD_Amount_9" />
                        <ext:RecordField Name="AOPD_Amount_10" />
                        <ext:RecordField Name="AOPD_Amount_11" />
                        <ext:RecordField Name="AOPD_Amount_12" />
                        <ext:RecordField Name="AOPD_Amount_Y" />
                        <ext:RecordField Name="RefAmount1" />
                        <ext:RecordField Name="RefAmount2" />
                        <ext:RecordField Name="RefAmount3" />
                        <ext:RecordField Name="RefAmount4" />
                        <ext:RecordField Name="RefAmount5" />
                        <ext:RecordField Name="RefAmount6" />
                        <ext:RecordField Name="RefAmount7" />
                        <ext:RecordField Name="RefAmount8" />
                        <ext:RecordField Name="RefAmount9" />
                        <ext:RecordField Name="RefAmount10" />
                        <ext:RecordField Name="RefAmount11" />
                        <ext:RecordField Name="RefAmount12" />
                        <ext:RecordField Name="RefAmountTotal" />
                        <ext:RecordField Name="RefD_H" />
                        <ext:RecordField Name="FormalAmount_1" />
                        <ext:RecordField Name="FormalAmount_2" />
                        <ext:RecordField Name="FormalAmount_3" />
                        <ext:RecordField Name="FormalAmount_4" />
                        <ext:RecordField Name="FormalAmount_5" />
                        <ext:RecordField Name="FormalAmount_6" />
                        <ext:RecordField Name="FormalAmount_7" />
                        <ext:RecordField Name="FormalAmount_8" />
                        <ext:RecordField Name="FormalAmount_9" />
                        <ext:RecordField Name="FormalAmount_10" />
                        <ext:RecordField Name="FormalAmount_11" />
                        <ext:RecordField Name="FormalAmount_12" />
                        <ext:RecordField Name="AOPType" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="AOPD_Dealer_DMA_ID" Direction="ASC" />
        </ext:Store>
        <ext:ViewPort ID="ViewPortDeatil" runat="server">
            <Body>
                <ext:FitLayout ID="FitLayout1" runat="server">
                    <ext:TabPanel ID="TabPanelDeatil" runat="server" ActiveTabIndex="0" Border="false">
                        <Tabs>
                            <ext:Tab ID="TabProductPrice" runat="server" Title="选择产品分类价格" Icon="ChartOrganisation"
                                AutoShow="true">
                                <Body>
                                    <ext:BorderLayout ID="BorderLayout3" runat="server">
                                        <North Collapsible="True" MarginsSummary="0 5 5 5">
                                            <ext:Panel ID="Panel10" runat="server" Header="false" BodyBorder="false" Height="0">
                                                <Body>
                                                </Body>
                                            </ext:Panel>
                                        </North>
                                        <Center MarginsSummary="0 5 5 5">
                                            <ext:Panel runat="server" ID="Panel11" Border="false" Frame="true" Title="第二步：选择产品价格"
                                                Icon="HouseKey" Height="200" ButtonAlign="Left">
                                                <Body>
                                                    <ext:FitLayout ID="FitLayout6" runat="server">
                                                        <ext:TreePanel ID="PriceTree" runat="server" Title="产品分类价格" Header="true" RootVisible="true">
                                                            <Tools>
                                                                <ext:Tool Type="Refresh" Handler="refreshLines(#{PriceTree});" />
                                                            </Tools>
                                                        </ext:TreePanel>
                                                    </ext:FitLayout>
                                                </Body>
                                                <Buttons>
                                                    <ext:Button ID="Button8" runat="server" Text="提交，进入下一步 （提交后经销商指标会根据医院指标及价格重新计算）"
                                                        Icon="Disk" CommandArgument="" CommandName="" IDMode="Legacy">
                                                        <Listeners>
                                                            <Click Handler="SubmitPriceClick(#{PriceTree});" />
                                                        </Listeners>
                                                    </ext:Button>
                                                    <ext:Button ID="Button1" runat="server" Text="查看指标" Icon="BulletGo" CommandArgument=""
                                                        CommandName="" IDMode="Legacy">
                                                        <Listeners>
                                                            <Click Handler="NextClick();" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Buttons>
                                            </ext:Panel>
                                        </Center>
                                    </ext:BorderLayout>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="TabDealerAop" runat="server" Title="指标维护" Icon="ChartOrganisation" AutoShow="true"
                                Enabled="false">
                                <Body>
                                    <ext:BorderLayout ID="BorderLayout2" runat="server">
                                        <North Collapsible="True" MarginsSummary="0 5 5 5">
                                            <ext:Panel ID="Panel111" runat="server" Header="false" BodyBorder="false" Height="0">
                                                <Body>
                                                </Body>
                                            </ext:Panel>
                                        </North>
                                        <Center Collapsible="True" MarginsSummary="0 5 5 5">
                                            <ext:Panel runat="server" ID="PanelHospitalProduct" Border="false" Frame="true" Title="第二步：维护经销商医院指标: <img src='/resources/images/icons/flag_ch.png' > </img> 代表本次新授权医院"
                                                Icon="HouseKey">
                                                <Body>
                                                    <ext:FitLayout ID="FitLayout4" runat="server">
                                                        <ext:GridPanel ID="GridPanelAOPStore" runat="server" Header="false" StoreID="AOPStore"
                                                            Border="false" Icon="Lorry" AutoExpandColumn="DmaId" AutoExpandMax="250" AutoExpandMin="150"
                                                            StripeRows="true">
                                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="OperType" DataIndex="OperType" Align="Center" Width="26" MenuDisabled="true">
                                                                        <Renderer Fn="change" />
                                                                    </ext:Column>
                                                                    <ext:CommandColumn ColumnID="Details" Header="编辑" Width="45" Align="Center">
                                                                        <Commands>
                                                                            <ext:GridCommand Icon="VcardEdit" CommandName="Modify" ToolTip-Text="编辑">
                                                                            </ext:GridCommand>
                                                                        </Commands>
                                                                    </ext:CommandColumn>
                                                                    <ext:Column ColumnID="DmaId" DataIndex="DmaId" Header="经销商" Hidden="true">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Year" DataIndex="Year" Header="年度" Width="45">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="医院名称" Width="150">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="ProductLineId" DataIndex="ProductLineId" Header="产品线" Width="150"
                                                                        Hidden="true">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="ProductName" DataIndex="ProductName" Header="产品分类" Width="120">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefYear" DataIndex="RefYear" Header="合计<br/>标准" Width="50"
                                                                        Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="UnitY" DataIndex="UnitY" Header="合计<br/>实际" Width="50" Align="Center"
                                                                        Css="styColumn_Green">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefQ1" DataIndex="RefQ1" Header="Q1<br/>标准" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Q1" DataIndex="Q1" Header="Q1<br/>实际" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefQ2" DataIndex="RefQ2" Header="Q2<br/>标准" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Q2" DataIndex="Q2" Header="Q2<br/>实际" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefQ3" DataIndex="RefQ3" Header="Q3<br/>标准" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Q3" DataIndex="Q3" Header="Q3<br/>实际" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefQ4" DataIndex="RefQ4" Header="Q4<br/>标准" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Q4" DataIndex="Q4" Header="Q4<br/>实际" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefUnit1" DataIndex="RefUnit1" Header="一月<br/>标准" Width="45"
                                                                        Hidden="true" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Unit1" DataIndex="Unit1" Header="一月" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefUnit2" DataIndex="RefUnit2" Header="二月<br/>标准" Width="45"
                                                                        Hidden="true" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Unit2" DataIndex="Unit2" Header="二月" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefUnit3" DataIndex="RefUnit3" Header="三月<br/>标准" Width="45"
                                                                        Hidden="true" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Unit3" DataIndex="Unit3" Header="三月" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefUnit4" DataIndex="RefUnit4" Header="四月<br/>标准" Width="45"
                                                                        Hidden="true" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Unit4" DataIndex="Unit4" Header="四月" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefUnit5" DataIndex="RefUnit5" Header="五月<br/>标准" Width="45"
                                                                        Hidden="true" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Unit5" DataIndex="Unit5" Header="五月" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefUnit6" DataIndex="RefUnit6" Header="六月<br/>标准" Width="45"
                                                                        Hidden="true" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Unit6" DataIndex="Unit6" Header="六月" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefUnit7" DataIndex="RefUnit7" Header="七月<br/>标准" Width="45"
                                                                        Hidden="true" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Unit7" DataIndex="Unit7" Header="七月" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefUnit8" DataIndex="RefUnit8" Header="八月<br/>标准" Width="45"
                                                                        Hidden="true" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Unit8" DataIndex="Unit8" Header="八月" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefUnit9" DataIndex="RefUnit9" Header="九月<br/>标准" Width="45"
                                                                        Hidden="true" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Unit9" DataIndex="Unit9" Header="九月" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefUnit10" DataIndex="RefUnit10" Header="十月<br/>标准" Width="45"
                                                                        Hidden="true" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Unit10" DataIndex="Unit10" Header="十月" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefUnit11" DataIndex="RefUnit11" Header="十一月<br/>标准" Width="45"
                                                                        Hidden="true" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Unit11" DataIndex="Unit11" Header="十一月" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RefUnit12" DataIndex="RefUnit12" Header="十二月<br/>标准" Width="45"
                                                                        Hidden="true" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Unit12" DataIndex="Unit12" Header="十二月" Width="50" Align="Center">
                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.0')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="row_number" DataIndex="row_number" Width="60" Hidden="true">
                                                                    </ext:Column>
                                                                </Columns>
                                                            </ColumnModel>
                                                            <SelectionModel>
                                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                                            </SelectionModel>
                                                            <BottomBar>
                                                                <ext:PagingToolbar ID="PagingToolBarAOP" runat="server" PageSize="15" StoreID="AOPStore"
                                                                    DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                            </BottomBar>
                                                            <LoadMask ShowMask="true" Msg="处理中..." />
                                                            <AjaxEvents>
                                                                <Command OnEvent="EditAop_Click">
                                                                    <ExtraParams>
                                                                        <ext:Parameter Name="editData" Value="Ext.encode(#{GridPanelAOPStore}.getRowsValues())"
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
                                        <South Collapsible="True" MarginsSummary="0 5 0 5">
                                            <ext:Panel runat="server" ID="PanelDealerAop" Border="false" Frame="true" Title="第三步：维护经销商商业采购指标: <img src='/resources/images/icons/exclamation.png' > </img> 经销商指标小于医院指标或者大于医院指标的20%(不含税指标)"
                                                Icon="HouseKey" Height="200" ButtonAlign="Left">
                                                <Body>
                                                    <ext:FitLayout ID="FitLayout5" runat="server">
                                                        <ext:GridPanel ID="GridDealerAop" runat="server" Header="false" StoreID="AOPDealerStore"
                                                            Border="false" Icon="Lorry" AutoExpandColumn="AOPD_Dealer_DMA_ID" AutoExpandMax="250"
                                                            AutoExpandMin="150" StripeRows="true">
                                                            <ColumnModel ID="ColumnModel2" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="RefD_H" DataIndex="RefD_H" Align="Center" Width="30" MenuDisabled="true">
                                                                        <Renderer Fn="changeDiff" />
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
                                                                    <ext:Column ColumnID="AOPD_ProductLine_BUM_ID" DataIndex="AOPD_ProductLine_BUM_ID"
                                                                        Header="产品线" Width="150" Hidden="true">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Year" DataIndex="AOPD_Year" Header="年度" Width="50" Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPType" DataIndex="AOPType" Header="指标类型" Width="120" Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_Y" DataIndex="AOPD_Amount_Y" Header="合计" Width="70"
                                                                        Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Q1" DataIndex="Q1" Header="Q1" Width="70" Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Q2" DataIndex="Q2" Header="Q2" Width="70" Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Q3" DataIndex="Q3" Header="Q3" Width="70" Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="Q4" DataIndex="Q4" Header="Q4" Width="70" Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_1" DataIndex="AOPD_Amount_1" Header="一月" Width="65"
                                                                        Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_2" DataIndex="AOPD_Amount_2" Header="二月" Width="65"
                                                                        Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_3" DataIndex="AOPD_Amount_3" Header="三月" Width="65"
                                                                        Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_4" DataIndex="AOPD_Amount_4" Header="四月" Width="65"
                                                                        Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_5" DataIndex="AOPD_Amount_5" Header="五月" Width="65"
                                                                        Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_6" DataIndex="AOPD_Amount_6" Header="六月" Width="65"
                                                                        Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_7" DataIndex="AOPD_Amount_7" Header="七月" Width="65"
                                                                        Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_8" DataIndex="AOPD_Amount_8" Header="八月" Width="65"
                                                                        Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_9" DataIndex="AOPD_Amount_9" Header="九月" Width="65"
                                                                        Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_10" DataIndex="AOPD_Amount_10" Header="十月" Width="65"
                                                                        Align="Center">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_11" DataIndex="AOPD_Amount_11" Header="十一月" Align="Center"
                                                                        Width="65">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="AOPD_Amount_12" DataIndex="AOPD_Amount_12" Header="十二月" Align="Center"
                                                                        Width="65">
                                                                    </ext:Column>
                                                                </Columns>
                                                            </ColumnModel>
                                                            <SelectionModel>
                                                                <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" SingleSelect="true" />
                                                            </SelectionModel>
                                                            <LoadMask ShowMask="true" Msg="处理中..." />
                                                            <AjaxEvents>
                                                                <Command OnEvent="EditDealerAop_Click">
                                                                    <ExtraParams>
                                                                        <ext:Parameter Name="editData" Value="Ext.encode(#{GridDealerAop}.getRowsValues())"
                                                                            Mode="Raw">
                                                                        </ext:Parameter>
                                                                    </ExtraParams>
                                                                </Command>
                                                            </AjaxEvents>
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
                                        </South>
                                    </ext:BorderLayout>
                                </Body>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </ext:FitLayout>
            </Body>
        </ext:ViewPort>
        <ext:Window ID="AOPHospitalWindow" runat="server" Icon="Group" Title="经销商医院指标设置"
            Closable="false" AutoShow="false" ShowOnLoad="false" Resizable="false" Height="580"
            Draggable="false" Width="900" Modal="true" BodyStyle="padding:5px;">
            <Body>
                <ext:ColumnLayout ID="ColumnLayout2" runat="server" FitHeight="true">
                    <ext:LayoutColumn ColumnWidth="0.5">
                        <ext:Panel runat="server" ID="TXT" BodyBorder="false">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout1" runat="server">
                                    <North Collapsible="True" MarginsSummary="0 0 0 5">
                                        <ext:Panel ID="pmaintainleft" runat="server" Frame="true" AutoHeight="true" Header="true">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="80">
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Hidden ID="hidClassification" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Hidden ID="hidProdLineID" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Label ID="txtYear" runat="server" FieldLabel="年度" CtCls="txtRed">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Label ID="txtHospitalName" runat="server" FieldLabel="医院名称" CtCls="txtRed">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Label ID="txtClassificationName" runat="server" FieldLabel="产品分类" CtCls="txtRed">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Hidden ID="txtHospitalID" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Hidden ID="hidentxtYear" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </North>
                                    <Center Collapsible="True" MarginsSummary="0 0 0 5">
                                        <ext:Panel runat="server" ID="Panel4" Border="false" Frame="true" Icon="HouseKey"
                                            Title="医院-产品分类">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout3" runat="server">
                                                    <ext:GridPanel ID="txtGPHospitalUpdate" runat="server" Header="false" StoreID="AOPHospitalEditer"
                                                        Border="false" Icon="Lorry" AutoExpandColumn="ProductName" AutoExpandMax="250"
                                                        AutoExpandMin="150" StripeRows="true">
                                                        <ColumnModel ID="ColumnModel4" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Year" DataIndex="Year" Header="年度" Width="50">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="医院名称" Width="110">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductName" DataIndex="ProductName" Header="产品分类">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductLineId" DataIndex="ProductLineId" Width="100" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductId" DataIndex="ProductId" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="HospitalId" DataIndex="HospitalId" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="row_number" DataIndex="row_number" Width="80" Hidden="true">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
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
                                                        </SelectionModel>
                                                         <BottomBar>
                                                            <ext:PagingToolbar ID="PagingToolBarEdit" runat="server" PageSize="15" StoreID="AOPHospitalEditer"
                                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                        </BottomBar>
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                        </ext:Panel>
                                    </Center>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Panel>
                    </ext:LayoutColumn>
                    <ext:LayoutColumn ColumnWidth="0.5">
                        <ext:Panel runat="server" ID="Panel09" BodyBorder="false">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout04" runat="server">
                                    <Center Collapsible="True" MarginsSummary="0 0 0 5">
                                        <ext:Panel ID="Details" runat="server" Frame="true" Header="true" Title="经销商医院指标">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout4" runat="server" FitHeight="true">
                                                    <ext:LayoutColumn ColumnWidth="0.6">
                                                        <ext:Panel ID="Panel5" runat="server" Frame="false" Header="true">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="70">
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:Label runat="server" ID="lb_desc" Text="标准值" FieldLabel="月份">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtFormalUnit_1" runat="server" FieldLabel="1月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtFormalUnit_2" runat="server" FieldLabel="2月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtFormalUnit_3" runat="server" FieldLabel="3月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtFormalUnit_4" runat="server" FieldLabel="4月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtFormalUnit_5" runat="server" FieldLabel="5月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtFormalUnit_6" runat="server" FieldLabel="6月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtFormalUnit_7" runat="server" FieldLabel="7月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtFormalUnit_8" runat="server" FieldLabel="8月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtFormalUnit_9" runat="server" FieldLabel="9月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtFormalUnit_10" runat="server" FieldLabel="10月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtFormalUnit_11" runat="server" FieldLabel="11月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:TextField ID="txtFormalUnit_12" runat="server" FieldLabel="12月" Enabled="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.4">
                                                        <ext:Panel ID="Panel6" runat="server" Frame="false" Header="true">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout6" runat="server" LabelWidth="100">
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:Label runat="server" ID="Label3" FieldLabel="数量">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtUnit_1" runat="server" MaskRe="/[0-9\.]/" SelectOnFocus="false"
                                                                            HideLabel="true" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtUnit_2" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtUnit_3" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtUnit_4" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtUnit_5" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtUnit_6" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtUnit_7" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtUnit_8" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtUnit_9" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtUnit_10" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtUnit_11" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtUnit_12" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:Panel>
                                    </Center>
                                    <South Collapsible="True" MarginsSummary="0 0 0 5">
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
                                    </South>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Panel>
                    </ext:LayoutColumn>
                </ext:ColumnLayout>
            </Body>
            <Buttons>
                <ext:Button ID="SaveUnitButton" runat="server" Text="确认" Icon="Disk">
                    <AjaxEvents>
                        <Click OnEvent="SaveAOP_Click" Success="afterSaveAOPDetails();" Before="return CheckHospitalNull();">
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="CancelButton" runat="server" Text="关闭" Icon="Cancel">
                    <Listeners>
                        <Click Handler="cancelWindow();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Window ID="WindowDealerAop" runat="server" Icon="Group" Title="经销商指标设置" Closable="false"
            AutoShow="false" ShowOnLoad="false" Resizable="false" Height="600" Draggable="false"
            Width="550" Modal="true" BodyStyle="padding:5px;">
            <Body>
                <ext:ColumnLayout ID="ColumnLayout3" runat="server" FitHeight="true">
                    <ext:LayoutColumn ColumnWidth="0.1">
                        <ext:Panel runat="server" ID="Panel12" BodyBorder="false">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout5" runat="server">
                                    <North MarginsSummary="0 0 0 5">
                                        <ext:Panel ID="Panel2" runat="server" Frame="true" Height="40" Header="false" Hidden="true">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="80">
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
                                                        <ext:Panel ID="panel" runat="server" Height="20" Header="false">
                                                            <Body>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:Anchor>
                                                    <ext:Anchor Horizontal="100%">
                                                        <ext:Hidden ID="hidDealerAopRemarkId" runat="server">
                                                        </ext:Hidden>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </North>
                                    <Center Collapsible="True" MarginsSummary="0 0 0 5">
                                        <ext:Panel ID="Panel3" runat="server" Frame="true" Header="true" Title="经销商指标">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout5" runat="server" FitHeight="true">
                                                    <ext:LayoutColumn ColumnWidth="0.6">
                                                        <ext:Panel ID="Panel7" runat="server" Frame="false" Header="true">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="70">
                                                                    <ext:Anchor Horizontal="80%">
                                                                        <ext:Label runat="server" ID="Label4" Text="医院实际指标" FieldLabel="月份">
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
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                    <ext:LayoutColumn ColumnWidth="0.4">
                                                        <ext:Panel ID="Panel8" runat="server" Frame="false" Header="true">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="100">
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:Label runat="server" ID="Label1" Text="经销商商业采购指标" HideLabel="true">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_1" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_2" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_3" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_4" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_5" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_6" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_7" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_8" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_9" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_10" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_11" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:TextField ID="txtAmount_12" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                            Enabled="false" SelectOnFocus="false" AllowBlank="false">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor Horizontal="100%">
                                                                        <ext:Label ID="txtAopErrorMag" runat="server" HideLabel="false" LabelSeparator="">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:Panel>
                                    </Center>
                                    <South Collapsible="True" MarginsSummary="0 0 0 5">
                                        <ext:Panel ID="panel13" runat="server" Frame="true" AutoHeight="true" Title="经销商指标小于医院指标或大于医院指标20%原因：">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout9" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextArea ID="txtDealerAopRemark" runat="server" HideLabel="true" Width="460">
                                                        </ext:TextArea>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </South>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Panel>
                    </ext:LayoutColumn>
                </ext:ColumnLayout>
            </Body>
            <Buttons>
                <ext:Button ID="SaveAmountButton" runat="server" Text="保存并关闭" Icon="Disk">
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
            </Buttons>
        </ext:Window>
        <ext:Hidden ID="hidContractID" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDealerID" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDivisionID" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidProductLineId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="HidEffectiveDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="HidExpirationDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsEmerging" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidYearString" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidPartsContractCode" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidPartsContractId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidMinYear" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidContractType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="prodLineData" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidBeginYearMinMonth" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidCheckHospitalProudct" runat="server">
        </ext:Hidden>
    </div>
    </form>
</body>
</html>
