<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractTerritoryEditorV2.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractTerritoryEditorV2" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/HospitalSearchDialogDCMS.ascx" TagName="HospitalSearchDCMSDialog"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>经销商授权维护</title>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .yellow-row
        {
            background: #FFD700;
        }
    </style>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript">
    Ext.apply(Ext.util.Format, {            number: function(v, format) {                if(!format){                    return v;                }                                                v *= 1;                if(typeof v != 'number' || isNaN(v)){                    return '';                }                var comma = ',';                var dec = '.';                var i18n = false;                                if(format.substr(format.length - 2) == '/i'){                    format = format.substr(0, format.length-2);                    i18n = true;                    comma = '.';                    dec = ',';                }                var hasComma = format.indexOf(comma) != -1,                    psplit = (i18n ? format.replace(/[^\d\,]/g,'') : format.replace(/[^\d\.]/g,'')).split(dec);                if (1 < psplit.length) {                    v = v.toFixed(psplit[1].length);                }                else if (2 < psplit.length) {                    throw('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format);                }                else {                    v = v.toFixed(0);                }                var fnum = v.toString();                if (hasComma) {                    psplit = fnum.split('.');                    var cnum = psplit[0],                        parr = [],                        j = cnum.length,                        m = Math.floor(j / 3),                        n = cnum.length % 3 || 3;                    for (var i = 0; i < j; i += n) {                        if (i != 0) {n = 3;}                        parr[parr.length] = cnum.substr(i, n);                        m -= 1;                    }                    fnum = parr.join(comma);                    if (psplit[1]) {                        fnum += dec + psplit[1];                    }                }                return format.replace(/[\d,?\.?]+/, fnum);            },            numberRenderer : function(format){                return function(v){                    return Ext.util.Format.number(v, format);                };            }        });
  
          //Dialog:医院
        var showHospitalSelectorDlg = function() {
           
            var lineId = <%= hidProductLineId.ClientID %>.getValue();
            
            if(lineId == null || lineId == "")
              Ext.Msg.alert('提醒', '请选择授权分类!');
            else 
                openHospitalSearchDlg(lineId);
        }
       
        function getCurrentInvRowClass(record, index) {
        if (record.data.TCount >0) {
                return 'yellow-row';
            }
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
        
          
        var afterTerritoryDetails = function() {
            Ext.Msg.alert('Success','保存成功！');
            <%=gplAuthHospital.ClientID%>.reload();
        }
        
         var CheckNull = function(){
                if ( <%= txtHospitalDepartment.ClientID %>.getValue()=="" )
                {
                    alert('医院科室不能为空！');
                    return false;
                }
                return true;
        }
        
          var cancelWindow =function()
        {
             <%= EditHospitalDepWindow.ClientID %>.hide(null);
        }
        
        
         var SubmitClassAuthorization = function(tree) {

            var checkedNodes = tree.getChecked();
            var Nodesid = [];
            
            for(var i=0;i<checkedNodes.length;i++){
                Nodesid.push(checkedNodes[i].id);
            }
            
            if(checkedNodes.length>0){
                var TabPanel = <%= TabPanelDeatil.ClientID %>;
                var TabAuthor = <%= TabAuthorization.ClientID %>;
                TabAuthor.disabled=false;
                
                Coolite.AjaxMethods.SubmitClassAuthorization(Nodesid.toString(),{success:function(result){ if(result=='Success') { TabPanel.setActiveTab(TabAuthor); Ext.getCmp('<%=this.gplAuthHospital.ClientID%>').reload();} else { Ext.Msg.alert('Error', result);} },failure:function(err){Ext.Msg.alert('Error', err);}});

            } else {
                Ext.MessageBox.alert('错误', '请选择授权产品分类');
            }
        }
        
         function refreshLines(tree) {
            Coolite.AjaxMethods.RefreshLines({
                success: function(result) {
                    var nodes = eval(result);
                    if (tree.root != null)
                        tree.root.ui.remove();
                    tree.initChildren(nodes);

                    if (tree.root != null)
                        tree.root.render();
                }
            });
        }
        
         function checkChange2(nodeid, node, value) {
            var checked = value.checkbox.checked; //获取节点上的checkbox控件
            node.expand(); //展开下面的节点
            node.attributes.checked = checked;
            node.eachChild(function (child) {
                child.ui.toggleCheck(checked);
                child.attributes.checked = checked;
                child.fireEvent('checkchange', child, checked);
            });
        }
        
    </script>

    <ext:Store ID="Store1" runat="server" UseIdConfirmation="false" OnRefreshData="Store1_RefershData"
        OnBeforeStoreChanged="Store1_BeforeStoreChanged" AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="HosId" />
                    <ext:RecordField Name="HosHospitalShortName" />
                    <ext:RecordField Name="HosHospitalName" />
                    <ext:RecordField Name="HosGrade" />
                    <ext:RecordField Name="HosKeyAccount" />
                    <ext:RecordField Name="HosProvince" />
                    <ext:RecordField Name="HosCity" />
                    <ext:RecordField Name="HosDistrict" />
                    <ext:RecordField Name="TCount" />
                    <ext:RecordField Name="RepeatDealer" />
                    <ext:RecordField Name="OperType" />
                    <ext:RecordField Name="HosDepart" />
                    <ext:RecordField Name="HosDepartType" />
                    <ext:RecordField Name="HosDepartTypeName" />
                    <ext:RecordField Name="HosDepartRemark" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
        </Listeners>
    </ext:Store>
    <ext:Store ID="StoreUpdate" runat="server" UseIdConfirmation="false" OnRefreshData="StoreUpdate_RefershData"
        AutoLoad="false">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="HosId">
                <Fields>
                    <ext:RecordField Name="OperType" />
                    <ext:RecordField Name="HosId" />
                    <ext:RecordField Name="HosHospitalShortName" />
                    <ext:RecordField Name="HosHospitalName" />
                    <ext:RecordField Name="HosGrade" />
                    <ext:RecordField Name="HosKeyAccount" />
                    <ext:RecordField Name="HosDepartType" />
                    <ext:RecordField Name="HosDepartTypeName" />
                    <ext:RecordField Name="HosDepartRemark" />
                    <ext:RecordField Name="HosDepart" />
                </Fields>
            </ext:JsonReader>
        </Reader>
        <Listeners>
            <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
        </Listeners>
    </ext:Store>
    <%-- <ext:Store ID="AuthorizationStore" runat="server" OnRefreshData="AuthorizationStore_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Namecn" />
                    <ext:RecordField Name="IsSelected" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>--%>
    <ext:Store ID="HospitalDepartStore" runat="server" OnRefreshData="HospitalDepartStore_RefershData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="Id">
                <Fields>
                    <ext:RecordField Name="Id" />
                    <ext:RecordField Name="Value" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:FitLayout ID="FitLayout1" runat="server">
                <ext:TabPanel ID="TabPanelDeatil" runat="server" ActiveTabIndex="0" Border="false">
                    <Tabs>
                        <ext:Tab ID="TabPartsClassification" runat="server" Title="授权产品分类" Icon="ChartOrganisation"
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
                                        <ext:Panel runat="server" ID="Panel11" Border="false" Frame="true" Title="第一步：选择授权产品分类"
                                            Icon="HouseKey" Height="200" ButtonAlign="Left">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout6" runat="server">
                                                    <%--   <ext:GridPanel ID="gplAuthorization" runat="server" StoreID="AuthorizationStore"
                                                        Border="false" Icon="Lorry" Header="false" AutoExpandColumn="Namecn" AutoExpandMax="250"
                                                        AutoExpandMin="150" StripeRows="true">
                                                        <ColumnModel ID="ColumnModel1" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Namecn" DataIndex="Namecn" Header="授权产品分类">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Id" DataIndex="Id" Header="授权产品分类" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="IsSelected" DataIndex="IsSelected" Header="授权产品分类" Hidden="true">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                                            </ext:CheckboxSelectionModel>
                                                        </SelectionModel>
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                    </ext:GridPanel>--%>
                                                    <ext:TreePanel ID="menuTree" runat="server" Title="授权产品分类" Header="true" RootVisible="true">
                                                        <Tools>
                                                            <ext:Tool Type="Refresh" Handler="refreshLines(#{menuTree});" />
                                                        </Tools>
                                                        <Listeners>
                                                            <CheckChange Handler="checkChange2(node.id,node,node.getUI());" />
                                                        </Listeners>
                                                    </ext:TreePanel>
                                                </ext:FitLayout>
                                            </Body>
                                            <Buttons>
                                                <ext:Button ID="Button8" runat="server" Text="提交,进入下一步" Icon="Disk" CommandArgument=""
                                                    CommandName="" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="SubmitClassAuthorization(#{menuTree});" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Buttons>
                                        </ext:Panel>
                                    </Center>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="TabAuthorization" runat="server" Title="授权医院" Icon="ChartOrganisation"
                            AutoShow="true" Enabled="false">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout1" runat="server">
                                    <Center MarginsSummary="0 5 0 5">
                                        <ext:Panel ID="pnlSouth" runat="server" Title="第二步：选择授权医院：  <img src='/resources/images/icons/flag_ch.png' > </img> 代表本次新授权医院"
                                            Icon="Basket" Height="280" IDMode="Legacy">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout2" runat="server">
                                                    <ext:GridPanel ID="gplAuthHospital" runat="server" Title="包含医院" Header="false" AutoExpandColumn="HosHospitalName"
                                                        StoreID="Store1" Border="false" ButtonAlign="Left" Icon="Lorry" StripeRows="true">
                                                        <Buttons>
                                                            <ext:Button ID="btnAddHospital" runat="server" Text="添加医院" Icon="Add" CommandArgument=""
                                                                CommandName="" IDMode="Legacy">
                                                                <Listeners>
                                                                    <Click Fn="showHospitalSelectorDlg" />
                                                                </Listeners>
                                                            </ext:Button>
                                                            <ext:Button ID="btnDeleteHospital" runat="server" Text="删除" Icon="Delete" CommandArgument=""
                                                                CommandName="" IDMode="Legacy">
                                                                <Listeners>
                                                                    <Click Handler="var result = confirm('你确信删除吗?'); var grid = #{gplAuthHospital};if ( (result) && grid.hasSelection()) { grid.deleteSelected(); grid.save();}" />
                                                                </Listeners>
                                                            </ext:Button>
                                                            <ext:Button ID="Button2" runat="server" Text="导出" Icon="PageExcel" IDMode="Legacy"
                                                                AutoPostBack="true" OnClick="ExportExcel">
                                                            </ext:Button>
                                                            <ext:Button ID="BtnSubmit" runat="server" Text="提交" Icon="Disk" IDMode="Legacy">
                                                                <Listeners>
                                                                    <Click Fn="ClosePage" />
                                                                </Listeners>
                                                            </ext:Button>
                                                        </Buttons>
                                                        <ColumnModel ID="ColumnModel2" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Id" Width="100" DataIndex="Id" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="OperType" DataIndex="OperType" Align="Center" Width="30" MenuDisabled="true">
                                                                    <Renderer Fn="change" />
                                                                </ext:Column>
                                                                <ext:CommandColumn ColumnID="Details" Header="编辑" Width="60" Hidden="false">
                                                                    <Commands>
                                                                        <ext:GridCommand Icon="VcardEdit" CommandName="Modify" ToolTip-Text="编辑">
                                                                        </ext:GridCommand>
                                                                    </Commands>
                                                                </ext:CommandColumn>
                                                                <ext:Column ColumnID="HosHospitalName" Width="180" DataIndex="HosHospitalName" Header="医院名称">
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosKeyAccount" Width="90" Header="医院编号">
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosProvince" Width="90" Header="省份">
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosCity" Width="70" Header="城市">
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosDepartTypeName" Width="100" Header="科室类型">
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosDepart" Width="100" Header="科室名称">
                                                                </ext:Column>
                                                                <ext:Column Width="200" DataIndex="HosDepartRemark" Header="备注">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="RepeatDealer" Width="400" DataIndex="RepeatDealer" Header="重复授权">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <View>
                                                            <ext:GridView ID="GridView1" runat="server">
                                                                <GetRowClass Fn="getCurrentInvRowClass" />
                                                            </ext:GridView>
                                                        </View>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server">
                                                                <Listeners>
                                                                    <RowSelect Handler="var btndel = #{btnDelete}; if(btndel != null ) btndel.enable();" />
                                                                </Listeners>
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <BottomBar>
                                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="Store1"
                                                                DisplayInfo="true" EmptyMsg="无数据显示…" />
                                                        </BottomBar>
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                        <AjaxEvents>
                                                            <Command OnEvent="EditTerritory_Click">
                                                                <ExtraParams>
                                                                    <ext:Parameter Name="editData" Value="Ext.encode(#{gplAuthHospital}.getRowsValues())"
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
                                    <South Collapsible="false" Split="True" MarginsSummary="0 5 5 5">
                                        <ext:Hidden runat="server" ID="hidSouth">
                                        </ext:Hidden>
                                    </South>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Tab>
                    </Tabs>
                </ext:TabPanel>
            </ext:FitLayout>
        </Body>
    </ext:ViewPort>
    <ext:Window ID="EditHospitalDepWindow" runat="server" Icon="Group" Title="医院科室备注"
        Width="800" Height="490" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
        Resizable="false" Header="false" Maximizable="true">
        <Body>
            <ext:ColumnLayout ID="ColumnLayout2" runat="server" FitHeight="true">
                <ext:LayoutColumn ColumnWidth="0.5">
                    <ext:Panel runat="server" ID="TXT" BodyBorder="false">
                        <Body>
                            <ext:BorderLayout ID="BorderLayout2" runat="server">
                                <Center Collapsible="True" MarginsSummary="0 5 0 0">
                                    <ext:Panel runat="server" ID="Panel4" Border="false" Frame="true" Icon="HouseKey"
                                        Title="授权医院">
                                        <Body>
                                            <ext:FitLayout ID="FitLayout3" runat="server">
                                                <ext:GridPanel ID="txtGPHospitalUpdate" runat="server" Header="false" StoreID="StoreUpdate"
                                                    Border="false" Icon="Lorry" AutoExpandColumn="HosHospitalName" AutoExpandMax="250"
                                                    AutoExpandMin="150" StripeRows="true">
                                                    <ColumnModel ID="ColumnModel4" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="OperType" DataIndex="OperType" Align="Center" Width="30" MenuDisabled="true">
                                                                <Renderer Fn="change" />
                                                            </ext:Column>
                                                            <ext:Column ColumnID="HosHospitalName" Width="180" DataIndex="HosHospitalName" Header="医院名称">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="HosDepart" Width="50" DataIndex="HosDepart" Hidden="true">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="HosDepartType" Width="50" DataIndex="HosDepartType" Hidden="true">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="HosDepartRemark" Width="50" DataIndex="HosDepartRemark" Hidden="true">
                                                            </ext:Column>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <View>
                                                        <ext:GridView ID="GridView2" runat="server">
                                                            <GetRowClass Fn="getCurrentInvRowClass" />
                                                        </ext:GridView>
                                                    </View>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel4" runat="server" SingleSelect="true">
                                                            <AjaxEvents>
                                                                <RowSelect OnEvent="RowSelect" Buffer="250">
                                                                    <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="#{Details}" />
                                                                    <ExtraParams>
                                                                        <ext:Parameter Name="HospitalDepartEdite" Value="Ext.encode(#{txtGPHospitalUpdate}.getRowsValues())"
                                                                            Mode="Raw" />
                                                                    </ExtraParams>
                                                                </RowSelect>
                                                            </AjaxEvents>
                                                        </ext:RowSelectionModel>
                                                    </SelectionModel>
                                                    <LoadMask ShowMask="true" Msg="处理中..." />
                                                    <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="30" StoreID="StoreUpdate"
                                                            DisplayInfo="true" EmptyMsg="无数据显示…" />
                                                    </BottomBar>
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
                    <ext:Panel ID="Details" runat="server" Frame="true" Header="false">
                        <Body>
                            <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="100">
                                <ext:Anchor Horizontal="100%">
                                    <%--<ext:Hidden ID="hidHosListId" runat="server">
                                    </ext:Hidden>--%>
                                    <ext:Hidden ID="txtHidHosId" runat="server">
                                    </ext:Hidden>
                                </ext:Anchor>
                                <ext:Anchor Horizontal="100%">
                                    <ext:Label runat="server" ID="txtHospitalName" FieldLabel="医院名称">
                                    </ext:Label>
                                </ext:Anchor>
                                <ext:Anchor Horizontal="100%">
                                    <ext:ComboBox ID="txtHospitalDepartType" runat="server" EmptyText="请选择科室类型" Editable="true"
                                        TypeAhead="true" StoreID="HospitalDepartStore" ValueField="Id" DisplayField="Value"
                                        Mode="Local" FieldLabel="科室类型" Resizable="true">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="Clear" Qtip="清空" />
                                        </Triggers>
                                        <Listeners>
                                            <Select Handler="#{txtHospitalDepartment}.setValue(''); #{txtHospitalDepartment}.setValue(this.getText());" />
                                            <TriggerClick Handler="this.clearValue(); #{txtHospitalDepartment}.setValue('');" />
                                        </Listeners>
                                    </ext:ComboBox>
                                </ext:Anchor>
                                <ext:Anchor Horizontal="100%">
                                    <ext:TextField ID="txtHospitalDepartment" runat="server" FieldLabel="所属科室">
                                    </ext:TextField>
                                </ext:Anchor>
                                <ext:Anchor Horizontal="100%">
                                    <ext:TextArea ID="txtHospitalRemark" runat="server" FieldLabel="备注">
                                    </ext:TextArea>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                    </ext:Panel>
                </ext:LayoutColumn>
            </ext:ColumnLayout>
        </Body>
        <Buttons>
            <ext:Button ID="SaveButton" runat="server" Text="提交" Icon="Disk">
                <AjaxEvents>
                    <Click OnEvent="SaveTerritoryDepart_Click" Success="afterTerritoryDetails();" Before="return CheckNull();">
                    </Click>
                </AjaxEvents>
            </ext:Button>
            <ext:Button ID="CancelButton" runat="server" Text="返回" Icon="Cancel">
                <Listeners>
                    <Click Handler="cancelWindow();" />
                </Listeners>
            </ext:Button>
        </Buttons>
    </ext:Window>
    <uc1:HospitalSearchDCMSDialog ID="HospitalSearchDCMSDialog1" runat="server" />
    <ext:Hidden ID="hidInstanceID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidDivisionID" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidPartsContractCode" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidBeginDate" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidDealerId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidIsEmerging" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidProductLineId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidContractType" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidProductAmend" runat="server">
    </ext:Hidden>
    </form>
</body>
</html>
