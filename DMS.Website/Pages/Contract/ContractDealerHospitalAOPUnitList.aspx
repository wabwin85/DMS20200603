<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractDealerHospitalAOPUnitList.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractDealerHospitalAOPUnitList" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Assembly="DMS.Common" Namespace="DMS.Common.WebControls" TagPrefix="ext" %>
<%@ Register Src="../../Controls/HospitalAOPImport.ascx" TagName="HospitalAOPImport"
    TagPrefix="uc" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>经销商指标设定</title>
    <style type="text/css">
        .txtRed {
            color: Red;
            font-weight: bold;
        }

        .txtBlue {
            font-weight: bold;
        }

        .x-grid3-col-RefQ2, .x-grid3-col-Q2, .x-grid3-col-RefQ4, .x-grid3-col-Q4, .x-grid3-col-AOPD_Amount_Y, .x-grid3-col-ReQ2, .x-grid3-col-ReQ4 {
            background-color: #EDEEF0;
        }

        .x-grid3-col-RefYear, .x-grid3-col-AmountY, .x-grid3-col-AOPD_Amount_Y, .x-grid3-col-ReAmountY {
            background-color: #BBFFBB;
        }

        .txtReadOnly {
            background-color: Gray;
        }

        .labeCss {
            text-align: right;
            font-weight: bold;
        }

        .td-left {
            border-style: solid;
            border-color: #D0D0D0;
            border-width: 1px 0px 0px 1px;
        }

        .td-right {
            border-style: solid;
            border-color: #D0D0D0;
            border-width: 1px 1px 0px 1px;
        }

        .td-bottom {
            border-bottom-width: 1px;
        }

        .td-label div {
            background-color: #99bbe8;
            font-weight: bold;
        }

        * {
            font-family: 微软雅黑 !important;
            font-size: 12px;
        }

        .aopTotal div {
            background-color: #BBFFBB;
        }

        .yellow-row {
            background: #FFD700;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

        <script type="text/javascript">
            Ext.apply(Ext.util.Format, {            number: function(v, format) {                if(!format){                    return v;                }                                                v *= 1;                if(typeof v != 'number' || isNaN(v)){                    return '';                }                var comma = ',';                var dec = '.';                var i18n = false;                                if(format.substr(format.length - 2) == '/i'){                    format = format.substr(0, format.length-2);                    i18n = true;                    comma = '.';                    dec = ',';                }                var hasComma = format.indexOf(comma) != -1,                    psplit = (i18n ? format.replace(/[^\d\,]/g,'') : format.replace(/[^\d\.]/g,'')).split(dec);                if (1 < psplit.length) {                    v = v.toFixed(psplit[1].length);                }                else if (2 < psplit.length) {                    throw('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format);                }                else {                    v = v.toFixed(0);                }                var fnum = v.toString();                if (hasComma) {                    psplit = fnum.split('.');                    var cnum = psplit[0],                        parr = [],                        j = cnum.length,                        m = Math.floor(j / 3),                        n = cnum.length % 3 || 3;                    for (var i = 0; i < j; i += n) {                        if (i != 0) {n = 3;}                        parr[parr.length] = cnum.substr(i, n);                        m -= 1;                    }                    fnum = parr.join(comma);                    if (psplit[1]) {                        fnum += dec + psplit[1];                    }                }                return format.replace(/[\d,?\.?]+/, fnum);            },            numberRenderer : function(format){                return function(v){                    return Ext.util.Format.number(v, format);                };            }        });
    
      
        
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
        
            var ImgDiff = '<img src="{0}" alt="经销商指标小于医院指标或者大于医院指标的10%"></img>';       
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
                    alert('请完整填写医院指标信息且医院指标不能为 0 ');
                    return false;
                }
           return true;
       }
        
            var afterSaveAOPDetails = function() {
                Ext.Msg.alert('提示', '保存成功');
                reloadHospitalFlag=true;
                reloadDealerFlag=true;
                reloadProductFlag=true;
            }
        
            var afterSaveDealerAOPDetails = function() {
                Ext.Msg.alert('提示', '保存成功');
            }
       
            var newHosPageLoad=true;
            var newDealerPageLoad=true;
            var newProductPageLoad=true;
         
            var reloadHospitalFlag = false;
            function SetHospitalActivate() {
                if (reloadHospitalFlag||newHosPageLoad){
                    Ext.getCmp('<%=this.GridHospitalAop.ClientID%>').store.reload();
           
                reloadHospitalFlag =false;
                newHosPageLoad=false;
            }
        }
        
        var reloadDealerFlag = false;
        function SetDelearActivate() {
            if (reloadDealerFlag|| newDealerPageLoad){

                if(newDealerPageLoad){
                    Ext.getCmp('<%=this.cbDelaerAopYear.ClientID%>').store.reload();
                 }
                 reloadDealerFlag =false;
                 newDealerPageLoad=false;
             }
         }
        
         var reloadProductFlag = false;
         function SetProductActivate() {
             if (reloadProductFlag|| newProductPageLoad){

                 Ext.getCmp('<%=this.GridPanelProduct.ClientID%>').store.reload();
                reloadProductFlag =false;
                newProductPageLoad=false;
            }
        }
        
        function getIsErrRowClass(record, index) {
            if (record.data.ISErr==1)
            {
                return 'yellow-row';
            }
        }
        
        function RefreshAOPWindow() {
            Ext.getCmp('<%=this.GridDealerAop.ClientID%>').reload();
               Ext.getCmp('<%=this.GridPanelAOPStore.ClientID%>').reload(); 
            
           }
        </script>

        <ext:ScriptManager ID="ScriptManager1" runat="server">
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
                        <ext:RecordField Name="Amount1" />
                        <ext:RecordField Name="Amount2" />
                        <ext:RecordField Name="Amount3" />
                        <ext:RecordField Name="Amount4" />
                        <ext:RecordField Name="Amount5" />
                        <ext:RecordField Name="Amount6" />
                        <ext:RecordField Name="Amount7" />
                        <ext:RecordField Name="Amount8" />
                        <ext:RecordField Name="Amount9" />
                        <ext:RecordField Name="Amount10" />
                        <ext:RecordField Name="Amount11" />
                        <ext:RecordField Name="Amount12" />
                        <ext:RecordField Name="Q1" />
                        <ext:RecordField Name="Q2" />
                        <ext:RecordField Name="Q3" />
                        <ext:RecordField Name="Q4" />
                        <ext:RecordField Name="AmountY" />
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
                        <ext:RecordField Name="RefQ1" />
                        <ext:RecordField Name="RefQ2" />
                        <ext:RecordField Name="RefQ3" />
                        <ext:RecordField Name="RefQ4" />
                        <ext:RecordField Name="RefYear" />
                        <ext:RecordField Name="FromalAmount1" />
                        <ext:RecordField Name="FromalAmount2" />
                        <ext:RecordField Name="FromalAmount3" />
                        <ext:RecordField Name="FromalAmount4" />
                        <ext:RecordField Name="FromalAmount5" />
                        <ext:RecordField Name="FromalAmount6" />
                        <ext:RecordField Name="FromalAmount7" />
                        <ext:RecordField Name="FromalAmount8" />
                        <ext:RecordField Name="FromalAmount9" />
                        <ext:RecordField Name="FromalAmount10" />
                        <ext:RecordField Name="FromalAmount11" />
                        <ext:RecordField Name="FromalAmount12" />
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
            AutoLoad="true">
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
        <ext:Store ID="AOPHospitalStore" runat="server" UseIdConfirmation="false" OnRefreshData="AOPHospitalStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="HospitalId" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="Year" />
                        <ext:RecordField Name="Amount1" />
                        <ext:RecordField Name="Amount2" />
                        <ext:RecordField Name="Amount3" />
                        <ext:RecordField Name="Amount4" />
                        <ext:RecordField Name="Amount5" />
                        <ext:RecordField Name="Amount6" />
                        <ext:RecordField Name="Amount7" />
                        <ext:RecordField Name="Amount8" />
                        <ext:RecordField Name="Amount9" />
                        <ext:RecordField Name="Amount10" />
                        <ext:RecordField Name="Amount11" />
                        <ext:RecordField Name="Amount12" />
                        <ext:RecordField Name="Q1" />
                        <ext:RecordField Name="Q2" />
                        <ext:RecordField Name="Q3" />
                        <ext:RecordField Name="Q4" />
                        <ext:RecordField Name="AmountY" />
                        <ext:RecordField Name="ReAmount1" />
                        <ext:RecordField Name="ReAmount2" />
                        <ext:RecordField Name="ReAmount3" />
                        <ext:RecordField Name="ReAmount4" />
                        <ext:RecordField Name="ReAmount5" />
                        <ext:RecordField Name="ReAmount6" />
                        <ext:RecordField Name="ReAmount7" />
                        <ext:RecordField Name="ReAmount8" />
                        <ext:RecordField Name="ReAmount9" />
                        <ext:RecordField Name="ReAmount10" />
                        <ext:RecordField Name="ReAmount11" />
                        <ext:RecordField Name="ReAmount12" />
                        <ext:RecordField Name="ReQ1" />
                        <ext:RecordField Name="ReQ2" />
                        <ext:RecordField Name="ReQ3" />
                        <ext:RecordField Name="ReQ4" />
                        <ext:RecordField Name="ReAmountY" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="AOPProductStore" runat="server" UseIdConfirmation="false" OnRefreshData="AOPProductStore_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="ProductName" />
                        <ext:RecordField Name="ProductCode" />
                        <ext:RecordField Name="Year" />
                        <ext:RecordField Name="Amount1" />
                        <ext:RecordField Name="Amount2" />
                        <ext:RecordField Name="Amount3" />
                        <ext:RecordField Name="Amount4" />
                        <ext:RecordField Name="Amount5" />
                        <ext:RecordField Name="Amount6" />
                        <ext:RecordField Name="Amount7" />
                        <ext:RecordField Name="Amount8" />
                        <ext:RecordField Name="Amount9" />
                        <ext:RecordField Name="Amount10" />
                        <ext:RecordField Name="Amount11" />
                        <ext:RecordField Name="Amount12" />
                        <ext:RecordField Name="Q1" />
                        <ext:RecordField Name="Q2" />
                        <ext:RecordField Name="Q3" />
                        <ext:RecordField Name="Q4" />
                        <ext:RecordField Name="AmountY" />
                        <ext:RecordField Name="ReAmount1" />
                        <ext:RecordField Name="ReAmount2" />
                        <ext:RecordField Name="ReAmount3" />
                        <ext:RecordField Name="ReAmount4" />
                        <ext:RecordField Name="ReAmount5" />
                        <ext:RecordField Name="ReAmount6" />
                        <ext:RecordField Name="ReAmount7" />
                        <ext:RecordField Name="ReAmount8" />
                        <ext:RecordField Name="ReAmount9" />
                        <ext:RecordField Name="ReAmount10" />
                        <ext:RecordField Name="ReAmount11" />
                        <ext:RecordField Name="ReAmount12" />
                        <ext:RecordField Name="ReQ1" />
                        <ext:RecordField Name="ReQ2" />
                        <ext:RecordField Name="ReQ3" />
                        <ext:RecordField Name="ReQ4" />
                        <ext:RecordField Name="ReAmountY" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="DealerAopYearStore" runat="server" UseIdConfirmation="true" OnRefreshData="DealerAopYearStore_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Year">
                    <Fields>
                        <ext:RecordField Name="Year" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler=" if(#{hidUpdateDealerYear}.getValue()!=''){#{cbDelaerAopYear}.setValue(#{hidUpdateDealerYear}.getValue());} else{ #{cbDelaerAopYear}.setValue(#{cbDelaerAopYear}.store.getTotalCount()>0?#{cbDelaerAopYear}.store.getAt(0).get('Year'):'');}" />
            </Listeners>
        </ext:Store>
        <ext:Hidden ID="hidUpdateDealerYear" runat="server">
        </ext:Hidden>
        <div>
            <ext:ViewPort ID="ViewPortDeatil" runat="server">
                <Body>
                    <ext:FitLayout ID="FitLayout1" runat="server">
                        <ext:FormPanel ID="FormPanel3" runat="server" Border="true" FormGroup="true" ButtonAlign="Right">
                            <Body>
                                <ext:FitLayout ID="FitLayout4" runat="server">
                                    <ext:TabPanel ID="TabPanelDeatil" runat="server" ActiveTabIndex="0">
                                        <Tabs>
                                            <ext:Tab ID="TabHospitalProductAOP" runat="server" Title="医院产品指标" BodyStyle="padding: 0px;"
                                                AutoScroll="true">
                                                <Body>
                                                    <ext:BorderLayout ID="BorderLayout2" runat="server">
                                                        <North MarginsSummary="5 5 5 5" Collapsible="true">
                                                            <ext:Panel ID="Panel2" runat="server" Title="查询条件" Height="120" BodyStyle="padding: 5px;"
                                                                Frame="true" Icon="Find">
                                                                <Body>
                                                                    <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                                                        <ext:LayoutColumn ColumnWidth=".5">
                                                                            <ext:Panel ID="Panel" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField ID="txtQueryHospitalName" runat="server" Width="180" FieldLabel="医院名称" />
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth=".5">
                                                                            <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField ID="txtQueryProductName" runat="server" Width="180" FieldLabel="产品名称" />
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
                                                                            <Click Handler="#{PagingToolBarAOP}.changePage(1);" />
                                                                        </Listeners>
                                                                    </ext:Button>
                                                                    <ext:Button ID="btnInputRule" runat="server" Text="医院指标导入" Icon="PageExcel">
                                                                        <Listeners>
                                                                            <Click Handler="Coolite.AjaxMethods.HospitalAOPImport.Show(#{hidContractId}.getValue())" />
                                                                        </Listeners>
                                                                    </ext:Button>
                                                                    <%--   <ext:Button ID="btnExcel" runat="server" Text="导出医院指标" Icon="PageExcel" IDMode="Legacy"
                                                                    AutoPostBack="true" OnClick="ExportHospitalExcel">
                                                                </ext:Button>--%>
                                                                    <ext:Button ID="btnExcel" runat="server" Text="导出医院指标" Icon="PageExcel">
                                                                        <Listeners>
                                                                            <Click Handler="window.open('PrintPage.aspx?ContractId='+#{hidContractId}.getValue()+'&ExportType=HospitalAOP');" />
                                                                        </Listeners>
                                                                    </ext:Button>
                                                                </Buttons>
                                                            </ext:Panel>
                                                        </North>
                                                        <Center MarginsSummary="0 5 5 5">
                                                            <ext:Panel runat="server" ID="Panel100" Border="false" Frame="true">
                                                                <Body>
                                                                    <ext:FitLayout ID="FitLayout6" runat="server">
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
                                                                                    <ext:Column ColumnID="RefYear" DataIndex="RefYear" Header="合计<br/>标准" Width="80"
                                                                                        Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="AmountY" DataIndex="AmountY" Header="合计<br/>实际" Width="80"
                                                                                        Align="Center" Css="styColumn_Green">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefQ1" DataIndex="RefQ1" Header="Q1<br/>标准" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Q1" DataIndex="Q1" Header="Q1<br/>实际" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefQ2" DataIndex="RefQ2" Header="Q2<br/>标准" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Q2" DataIndex="Q2" Header="Q2<br/>实际" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefQ3" DataIndex="RefQ3" Header="Q3<br/>标准" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Q3" DataIndex="Q3" Header="Q3<br/>实际" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefQ4" DataIndex="RefQ4" Header="Q4<br/>标准" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Q4" DataIndex="Q4" Header="Q4<br/>实际" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefAmount1" DataIndex="RefAmount1" Header="一月<br/>标准" Width="45"
                                                                                        Hidden="true" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount1" DataIndex="Amount1" Header="一月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefAmount2" DataIndex="RefAmount2" Header="二月<br/>标准" Width="45"
                                                                                        Hidden="true" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount2" DataIndex="Amount2" Header="二月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefAmount3" DataIndex="RefAmount3" Header="三月<br/>标准" Width="45"
                                                                                        Hidden="true" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount3" DataIndex="Amount3" Header="三月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefAmount4" DataIndex="RefAmount4" Header="四月<br/>标准" Width="45"
                                                                                        Hidden="true" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount4" DataIndex="Amount4" Header="四月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefAmount5" DataIndex="RefAmount5" Header="五月<br/>标准" Width="45"
                                                                                        Hidden="true" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount5" DataIndex="Amount5" Header="五月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefAmount6" DataIndex="RefAmount6" Header="六月<br/>标准" Width="45"
                                                                                        Hidden="true" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount6" DataIndex="Amount6" Header="六月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefAmount7" DataIndex="RefAmount7" Header="七月<br/>标准" Width="45"
                                                                                        Hidden="true" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount7" DataIndex="Amount7" Header="七月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefAmount8" DataIndex="RefAmount8" Header="八月<br/>标准" Width="45"
                                                                                        Hidden="true" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount8" DataIndex="Amount8" Header="八月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefAmount9" DataIndex="RefAmount9" Header="九月<br/>标准" Width="45"
                                                                                        Hidden="true" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount9" DataIndex="Amount9" Header="九月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefAmount10" DataIndex="RefAmount10" Header="十月<br/>标准" Width="45"
                                                                                        Hidden="true" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount10" DataIndex="Amount10" Header="十月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefAmount11" DataIndex="RefAmount11" Header="十一月<br/>标准" Width="45"
                                                                                        Hidden="true" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount11" DataIndex="Amount11" Header="十一月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="RefAmount12" DataIndex="RefAmount12" Header="十二月<br/>标准" Width="45"
                                                                                        Hidden="true" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount12" DataIndex="Amount12" Header="十二月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="row_number" DataIndex="row_number" Width="60" Hidden="true">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
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
                                                            <ext:Panel runat="server" ID="PanelDealerAop" Border="false" Frame="true" Title="维护经销商商业采购指标: <img src='/resources/images/icons/exclamation.png' > </img> 经销商指标小于医院指标或者大于医院指标的10%(不含税指标)"
                                                                Icon="HouseKey" Height="180" ButtonAlign="Left">
                                                                <Body>
                                                                    <ext:FitLayout ID="FitLayout7" runat="server">
                                                                        <ext:GridPanel ID="GridDealerAop" runat="server" Header="false" StoreID="AOPDealerStore"
                                                                            Border="false" Icon="Lorry" AutoExpandColumn="AOPD_Dealer_DMA_ID" AutoExpandMax="250"
                                                                            AutoExpandMin="150" StripeRows="true">
                                                                            <ColumnModel ID="ColumnModel5" runat="server">
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
                                                                                    <ext:Column ColumnID="AOPD_Amount_Y" DataIndex="AOPD_Amount_Y" Header="合计" Width="90"
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
                                                                                <ext:RowSelectionModel ID="RowSelectionModel5" runat="server" SingleSelect="true" />
                                                                            </SelectionModel>
                                                                            <LoadMask ShowMask="true" Msg="处理中..." />
                                                                            <AjaxEvents>
                                                                                <Command OnEvent="EditDealerAop_Click" Success="SetDelearActivate()">
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
                                                            </ext:Panel>
                                                        </South>
                                                    </ext:BorderLayout>
                                                </Body>
                                            </ext:Tab>
                                            <ext:Tab ID="Tab1" runat="server" Title="医院指标" BodyStyle="padding: 5px;" AutoScroll="true">
                                                <Body>
                                                    <ext:BorderLayout ID="BorderLayout3" runat="server">
                                                        <North MarginsSummary="5 5 5 5" Collapsible="true">
                                                            <ext:Panel ID="Panel8" runat="server" Title="查询条件" BodyStyle="padding: 5px;" Height="80"
                                                                Frame="true" Icon="Find">
                                                                <Body>
                                                                    <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                                                        <ext:LayoutColumn ColumnWidth=".5">
                                                                            <ext:Panel ID="Panel12" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout14" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField ID="txtHospital" runat="server" Width="180" FieldLabel="医院名称" />
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth=".5">
                                                                            <ext:Panel ID="Panel15" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout15" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                                        <ext:Anchor>
                                                                                            <ext:Button ID="Button4" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                                                                <Listeners>
                                                                                                    <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                                                                                </Listeners>
                                                                                            </ext:Button>
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                    </ext:ColumnLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </North>
                                                        <Center MarginsSummary="0 5 5 5">
                                                            <ext:Panel runat="server" ID="Panel13" Border="false" Frame="true">
                                                                <Body>
                                                                    <ext:FitLayout ID="FitLayout2" runat="server">
                                                                        <ext:GridPanel ID="GridHospitalAop" runat="server" Header="false" StoreID="AOPHospitalStore"
                                                                            Border="false" Icon="Lorry" AutoExpandColumn="HospitalName" AutoExpandMax="250"
                                                                            AutoExpandMin="150" StripeRows="true">
                                                                            <ColumnModel ID="ColumnModel2" runat="server">
                                                                                <Columns>
                                                                                    <ext:Column ColumnID="Year" DataIndex="Year" Header="年度" Width="45">
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="医院名称" Width="150">
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="ReAmountY" DataIndex="ReAmountY" Header="合计<br/>标准" Width="80"
                                                                                        Align="Center" Css="styColumn_Green">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="AmountY" DataIndex="AmountY" Header="合计<br/>实际" Width="80"
                                                                                        Align="Center" Css="styColumn_Green">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="ReQ1" DataIndex="ReQ1" Header="Q1<br/>标准" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Q1" DataIndex="Q1" Header="Q1<br/>实际" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="ReQ2" DataIndex="ReQ2" Header="Q2<br/>标准" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Q2" DataIndex="Q2" Header="Q2<br/>实际" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="ReQ3" DataIndex="ReQ3" Header="Q3<br/>标准" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Q3" DataIndex="Q3" Header="Q3<br/>实际" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="ReQ4" DataIndex="ReQ4" Header="Q4<br/>标准" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Q4" DataIndex="Q4" Header="Q4<br/>实际" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount1" DataIndex="Amount1" Header="一月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount2" DataIndex="Amount2" Header="二月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount3" DataIndex="Amount3" Header="三月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount4" DataIndex="Amount4" Header="四月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount5" DataIndex="Amount5" Header="五月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount6" DataIndex="Amount6" Header="六月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount7" DataIndex="Amount7" Header="七月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount8" DataIndex="Amount8" Header="八月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount9" DataIndex="Amount9" Header="九月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount10" DataIndex="Amount10" Header="十月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount11" DataIndex="Amount11" Header="十一月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount12" DataIndex="Amount12" Header="十二月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                </Columns>
                                                                            </ColumnModel>
                                                                            <SelectionModel>
                                                                                <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" SingleSelect="true" />
                                                                            </SelectionModel>
                                                                            <BottomBar>
                                                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="AOPHospitalStore"
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
                                                <Listeners>
                                                    <Activate Handler="SetHospitalActivate();" />
                                                </Listeners>
                                            </ext:Tab>
                                            <ext:Tab ID="TabProductAOP" runat="server" Title="产品指标" BodyStyle="padding: 0px;"
                                                AutoScroll="true">
                                                <Body>
                                                    <ext:BorderLayout ID="BorderLayout5" runat="server">
                                                        <North MarginsSummary="5 5 5 5" Collapsible="true">
                                                            <ext:Panel ID="Panel88" runat="server" Title="查询条件" BodyStyle="padding: 5px;" Height="80"
                                                                Frame="true" Icon="Find">
                                                                <Body>
                                                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                                        <ext:LayoutColumn ColumnWidth=".5">
                                                                            <ext:Panel ID="Panel89" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                                        <ext:Anchor>
                                                                                            <ext:TextField ID="tfProdutName" runat="server" Width="180" FieldLabel="产品名称" />
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                        <ext:LayoutColumn ColumnWidth=".5">
                                                                            <ext:Panel ID="Panel90" runat="server" Border="false" Header="false">
                                                                                <Body>
                                                                                    <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                                        <ext:Anchor>
                                                                                            <ext:Button ID="Button1" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                                                                <Listeners>
                                                                                                    <Click Handler="#{PagingToolBarProduct}.changePage(1);" />
                                                                                                </Listeners>
                                                                                            </ext:Button>
                                                                                        </ext:Anchor>
                                                                                    </ext:FormLayout>
                                                                                </Body>
                                                                            </ext:Panel>
                                                                        </ext:LayoutColumn>
                                                                    </ext:ColumnLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </North>
                                                        <Center MarginsSummary="0 5 5 5">
                                                            <ext:Panel runat="server" ID="Panel91" Border="false" Frame="true">
                                                                <Body>
                                                                    <ext:FitLayout ID="FitLayout8" runat="server">
                                                                        <ext:GridPanel ID="GridPanelProduct" runat="server" Header="false" StoreID="AOPProductStore"
                                                                            Border="false" Icon="Lorry" AutoExpandColumn="ProductName" AutoExpandMax="250"
                                                                            AutoExpandMin="150" StripeRows="true">
                                                                            <ColumnModel ID="ColumnModel6" runat="server">
                                                                                <Columns>
                                                                                    <ext:Column ColumnID="Year" DataIndex="Year" Header="年度" Width="45">
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="ProductName" DataIndex="ProductName" Header="产品名称" Width="150">
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="ReAmountY" DataIndex="ReAmountY" Header="合计<br/>标准" Width="80"
                                                                                        Align="Center" Css="styColumn_Green">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="AmountY" DataIndex="AmountY" Header="合计<br/>实际" Width="80"
                                                                                        Align="Center" Css="styColumn_Green">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="ReQ1" DataIndex="ReQ1" Header="Q1<br/>标准" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Q1" DataIndex="Q1" Header="Q1<br/>实际" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="ReQ2" DataIndex="ReQ2" Header="Q2<br/>标准" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Q2" DataIndex="Q2" Header="Q2<br/>实际" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="ReQ3" DataIndex="ReQ3" Header="Q3<br/>标准" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Q3" DataIndex="Q3" Header="Q3<br/>实际" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="ReQ4" DataIndex="ReQ4" Header="Q4<br/>标准" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Q4" DataIndex="Q4" Header="Q4<br/>实际" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount1" DataIndex="Amount1" Header="一月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount2" DataIndex="Amount2" Header="二月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount3" DataIndex="Amount3" Header="三月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount4" DataIndex="Amount4" Header="四月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount5" DataIndex="Amount5" Header="五月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount6" DataIndex="Amount6" Header="六月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount7" DataIndex="Amount7" Header="七月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount8" DataIndex="Amount8" Header="八月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount9" DataIndex="Amount9" Header="九月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount10" DataIndex="Amount10" Header="十月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount11" DataIndex="Amount11" Header="十一月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                    <ext:Column ColumnID="Amount12" DataIndex="Amount12" Header="十二月" Width="50" Align="Center">
                                                                                        <Renderer Fn="Ext.util.Format.numberRenderer('0')" />
                                                                                    </ext:Column>
                                                                                </Columns>
                                                                            </ColumnModel>
                                                                            <SelectionModel>
                                                                                <ext:RowSelectionModel ID="RowSelectionModel6" runat="server" SingleSelect="true" />
                                                                            </SelectionModel>
                                                                            <BottomBar>
                                                                                <ext:PagingToolbar ID="PagingToolBarProduct" runat="server" PageSize="30" StoreID="AOPProductStore"
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
                                                <Listeners>
                                                    <Activate Handler="SetProductActivate();" />
                                                </Listeners>
                                            </ext:Tab>
                                        </Tabs>
                                    </ext:TabPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:FormPanel>
                    </ext:FitLayout>
                </Body>
            </ext:ViewPort>
            <ext:Window ID="AOPHospitalWindow" runat="server" Icon="Group" Title="经销商医院实际指标设置"
                Closable="false" AutoShow="false" ShowOnLoad="false" Resizable="false" Height="580"
                Draggable="false" Width="800" Modal="true" BodyStyle="padding:5px;">
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
                                                                                SelectOnFocus="false" AllowBlank="false">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor Horizontal="100%">
                                                                            <ext:TextField ID="txtUnit_3" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                                SelectOnFocus="false" AllowBlank="false">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor Horizontal="100%">
                                                                            <ext:TextField ID="txtUnit_4" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                                SelectOnFocus="false" AllowBlank="false">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor Horizontal="100%">
                                                                            <ext:TextField ID="txtUnit_5" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                                SelectOnFocus="false" AllowBlank="false">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor Horizontal="100%">
                                                                            <ext:TextField ID="txtUnit_6" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                                SelectOnFocus="false" AllowBlank="false">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor Horizontal="100%">
                                                                            <ext:TextField ID="txtUnit_7" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                                SelectOnFocus="false" AllowBlank="false">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor Horizontal="100%">
                                                                            <ext:TextField ID="txtUnit_8" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                                SelectOnFocus="false" AllowBlank="false">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor Horizontal="100%">
                                                                            <ext:TextField ID="txtUnit_9" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                                SelectOnFocus="false" AllowBlank="false">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor Horizontal="100%">
                                                                            <ext:TextField ID="txtUnit_10" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                                SelectOnFocus="false" AllowBlank="false">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor Horizontal="100%">
                                                                            <ext:TextField ID="txtUnit_11" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                                SelectOnFocus="false" AllowBlank="false">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor Horizontal="100%">
                                                                            <ext:TextField ID="txtUnit_12" runat="server" HideLabel="true" MaskRe="/[0-9\.]/"
                                                                                SelectOnFocus="false" AllowBlank="false">
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
                                                            <ext:TextArea ID="hospitaleRemark" runat="server" HideLabel="true" Height="50" Width="360">
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
                            <Click Handler="#{AOPHospitalWindow}.hide(null); #{GridPanelAOPStore}.reload();#{GridDealerAop}.reload();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Window>
            <ext:Window ID="AOPDealerWindow" runat="server" Icon="Group" Title="经销商商业采购指标设置"
                Closable="false" AutoShow="false" ShowOnLoad="false" Resizable="false" Height="630"
                Maximizable="true" AutoScroll="true" Draggable="false" Width="780" Modal="true"
                BodyStyle="padding:5px;">
                <Body>
                    <ext:FormPanel ID="FormPanel2" runat="server" Border="true" FormGroup="true" ButtonAlign="Right"
                        BodyStyle="padding: 0px;">
                        <TopBar>
                            <ext:Toolbar ID="Toolbar1" runat="server">
                                <Items>
                                    <ext:ToolbarTextItem ID="ttiVersion" runat="server" Text="<b>指标年份：</b>" />
                                    <ext:ComboBox ID="cbDelaerAopYear" runat="server" Editable="false" ReadOnly="true"
                                        TypeAhead="true" ForceSelection="true" StoreID="DealerAopYearStore" ValueField="Year"
                                        Resizable="true" AllowBlank="false" Mode="Local" DisplayField="Year" TriggerAction="All">
                                        <Listeners>
                                            <Select Handler=" Coolite.AjaxMethods.ChangePageDealerAOP()" />
                                        </Listeners>
                                    </ext:ComboBox>
                                </Items>
                            </ext:Toolbar>
                        </TopBar>
                        <Body>
                            <ext:TableLayout ID="TableLayout1" runat="server" Columns="1">
                                <%--TABLE 1--%>
                                <ext:Cell>
                                    <ext:Panel ID="Panel181" runat="server" Header="false" Border="false" Width="980">
                                        <Body>
                                            <ext:TableLayout ID="TableLayout8" runat="server" Columns="6">
                                                <%--表头--%>
                                                <ext:Cell ColSpan="2" CellCls="td-left td-label">
                                                    <ext:Panel ID="PanelCell1" runat="server" Header="false" Border="false" BodyStyle="padding:5px;  text-align:center;"
                                                        Width="220" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label19" runat="server" Html="<b>经销商医院实际指标</b>">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell ColSpan="2" CellCls="td-left td-label">
                                                    <ext:Panel ID="Panel1" runat="server" Header="false" Border="false" BodyStyle="padding:5px; text-align:center;"
                                                        Width="220" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label1" runat="server" Html="<b>经销商商业采购指标</b>">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell ColSpan="2" CellCls="td-right td-label">
                                                    <ext:Panel ID="Panel7" runat="server" Header="false" Border="false" BodyStyle="padding:5px; text-align:center;"
                                                        Width="320" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label2" runat="server" Html="<b>指标差异汇总</b>">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%--第一行--%>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel10" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label4" runat="server" Html="一月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel11" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmount1" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel14" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label6" runat="server" Html="一月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel16" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:NumberField ID="nfAmount1" runat="server" HideLabel="true" LabelSeparator="">
                                                            </ext:NumberField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell ColSpan="2" CellCls="td-right">
                                                    <ext:Panel ID="Panel17" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="320" Height="30">
                                                        <Body>
                                                            <ext:Label ID="labDiffQ1" runat="server" LabelSeparator="" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%--第二行--%>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel18" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label5" runat="server" Html="二月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel19" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmount2" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel20" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label8" runat="server" Html="二月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel21" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:NumberField ID="nfAmount2" runat="server" HideLabel="true" LabelSeparator="">
                                                            </ext:NumberField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell ColSpan="2" CellCls="td-right">
                                                    <ext:Panel ID="Panel22" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="320" Height="30">
                                                        <Body>
                                                            <ext:Label ID="labDiffQ2" runat="server" LabelSeparator="" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%--第三行--%>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel23" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label7" runat="server" Html="三月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel24" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmount3" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel25" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label10" runat="server" Html="三月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel26" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:NumberField ID="nfAmount3" runat="server" HideLabel="true" LabelSeparator="">
                                                            </ext:NumberField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell ColSpan="2" CellCls="td-right">
                                                    <ext:Panel ID="Panel27" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="320" Height="30">
                                                        <Body>
                                                            <ext:Label ID="labDiffQ3" runat="server" LabelSeparator="" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%--第四行--%>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel68" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label28" runat="server" Html="Q1合计" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel69" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmountQ1" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel70" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label31" runat="server" Html="Q1合计" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel71" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="nfAmountQ1" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell ColSpan="2" CellCls="td-right">
                                                    <ext:Panel ID="Panel32" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="320" Height="30">
                                                        <Body>
                                                            <ext:Label ID="labDiffQ4" runat="server" LabelSeparator="" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%--第五行--%>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel28" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label12" runat="server" Html="四月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel29" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmount4" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel30" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label14" runat="server" Html="四月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel31" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:NumberField ID="nfAmount4" runat="server" HideLabel="true" LabelSeparator="">
                                                            </ext:NumberField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell ColSpan="2" CellCls="td-right">
                                                    <ext:Panel ID="Panel37" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="320" Height="30">
                                                        <Body>
                                                            <ext:Label ID="labDiffY" runat="server" LabelSeparator="" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%--第六行--%>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel33" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label9" runat="server" Html="五月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel34" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmount5" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel35" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label13" runat="server" Html="五月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel36" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:NumberField ID="nfAmount5" runat="server" HideLabel="true" LabelSeparator="">
                                                            </ext:NumberField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell ColSpan="2" CellCls="td-right td-bottom" RowSpan="12">
                                                    <ext:Panel ID="Panel42" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="320" Height="360">
                                                        <Body>
                                                            <ext:TableLayout ID="TableLayout2" runat="server" Columns="1">
                                                                <ext:Cell>
                                                                    <ext:Panel ID="Panel182" runat="server" Header="false" Border="false" Width="310">
                                                                        <Body>
                                                                            <span class="txtRed">经销商商业采购指标小于医院实际指标或大于医院实际指标10%原因</span>
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:Cell>
                                                                <ext:Cell>
                                                                    <ext:Panel ID="Panel43" runat="server" Header="false" Border="false" BodyStyle="padding:5px;">
                                                                        <Body>
                                                                            <ext:TextArea ID="txtDealerAopRemark" runat="server" LabelSeparator="" Width="300">
                                                                            </ext:TextArea>
                                                                        </Body>
                                                                        <Buttons>
                                                                            <ext:Button ID="SaveDealerButton" runat="server" Text="保存经销商指标" Icon="Disk">
                                                                                <AjaxEvents>
                                                                                    <Click OnEvent="SaveAOPDealer_Click" Success="afterSaveDealerAOPDetails();">
                                                                                    </Click>
                                                                                </AjaxEvents>
                                                                            </ext:Button>
                                                                            <ext:Button ID="CancelDealerButton" runat="server" Text="关闭" Icon="Cancel">
                                                                                <Listeners>
                                                                                    <Click Handler="#{AOPDealerWindow}.hide(null);#{AOPDealerStore}.reload();" />
                                                                                </Listeners>
                                                                            </ext:Button>
                                                                        </Buttons>
                                                                    </ext:Panel>
                                                                </ext:Cell>
                                                            </ext:TableLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%-- 第七行--%>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel38" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label11" runat="server" Html="六月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel39" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmount6" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel40" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label16" runat="server" Html="六月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel41" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:NumberField ID="nfAmount6" runat="server" HideLabel="true" LabelSeparator="">
                                                            </ext:NumberField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%-- 第八行--%>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel72" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label30" runat="server" Html="Q2合计" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel73" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmountQ2" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel74" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label33" runat="server" Html="Q2合计" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel75" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="nfAmountQ2" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%-- 第九行--%>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel44" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label15" runat="server" Html="七月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel45" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmount7" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel46" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label17" runat="server" Html="七月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel47" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:NumberField ID="nfAmount7" runat="server" HideLabel="true" LabelSeparator="">
                                                            </ext:NumberField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%-- 第十行--%>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel48" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label18" runat="server" Html="八月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel49" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmount8" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel50" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label21" runat="server" Html="八月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel51" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:NumberField ID="nfAmount8" runat="server" HideLabel="true" LabelSeparator="">
                                                            </ext:NumberField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%-- 第十一行--%>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel52" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label20" runat="server" Html="九月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel53" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmount9" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel54" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label23" runat="server" Html="九月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel55" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:NumberField ID="nfAmount9" runat="server" HideLabel="true" LabelSeparator="">
                                                            </ext:NumberField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%-- 第十二行--%>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel76" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label32" runat="server" Html="Q3合计" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel77" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmountQ3" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel78" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label35" runat="server" Html="Q3合计" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel79" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="nfAmountQ3" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%-- 第十三行--%>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel56" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label22" runat="server" Html="十月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel57" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmount10" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel58" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label25" runat="server" Html="十月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel59" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:NumberField ID="nfAmount10" runat="server" HideLabel="true" LabelSeparator="">
                                                            </ext:NumberField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%-- 第十四行--%>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel60" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label24" runat="server" Html="十一月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel61" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmount11" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel62" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label27" runat="server" Html="十一月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel63" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:NumberField ID="nfAmount11" runat="server" HideLabel="true" LabelSeparator="">
                                                            </ext:NumberField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%-- 第十五行--%>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel64" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label26" runat="server" Html="十二月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel65" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmount12" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel66" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label29" runat="server" Html="十二月">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left">
                                                    <ext:Panel ID="Panel67" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:NumberField ID="nfAmount12" runat="server" HideLabel="true" LabelSeparator="">
                                                            </ext:NumberField>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%-- 第十六行--%>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel80" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label34" runat="server" Html="Q4合计" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel81" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmountQ4" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel82" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label37" runat="server" Html="Q4合计" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left aopTotal">
                                                    <ext:Panel ID="Panel83" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="nfAmountQ4" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <%-- 第十七行--%>
                                                <ext:Cell CellCls="td-left td-bottom aopTotal">
                                                    <ext:Panel ID="Panel84" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label36" runat="server" Html="全年合计" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom aopTotal">
                                                    <ext:Panel ID="Panel85" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="txtReAmountTL" runat="server">
                                                            </ext:Label>
                                                            <ext:Hidden ID="hidReReAmountTL" runat="server">
                                                            </ext:Hidden>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom aopTotal">
                                                    <ext:Panel ID="Panel86" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="60" Height="30">
                                                        <Body>
                                                            <ext:Label ID="Label39" runat="server" Html="全年合计" CtCls="txtRed">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                                <ext:Cell CellCls="td-left td-bottom aopTotal">
                                                    <ext:Panel ID="Panel87" runat="server" Header="false" Border="false" BodyStyle="padding:5px;"
                                                        Width="160" Height="30">
                                                        <Body>
                                                            <ext:Label ID="nfAmountTL" runat="server">
                                                            </ext:Label>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Cell>
                                            </ext:TableLayout>
                                        </Body>
                                    </ext:Panel>
                                </ext:Cell>
                            </ext:TableLayout>
                        </Body>
                    </ext:FormPanel>
                </Body>
            </ext:Window>
            <ext:Hidden ID="hidContractId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidDealerId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidDivisionID" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidProductLineId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidEffectiveDate" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidExpirationDate" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidIsEmerging" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidYearString" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidSubBuCode" runat="server">
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
            <%-- add in 20160701--%>
            <ext:Hidden ID="hidLastContractId" runat="server">
            </ext:Hidden>
            <%--页面类型--%>
            <ext:Hidden ID="hidPageType" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidPageOperation" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidSubBuType" runat="server">
            </ext:Hidden>
            <uc:HospitalAOPImport ID="HospitalAOPImport1" runat="server"></uc:HospitalAOPImport>
        </div>
    </form>
</body>
</html>
