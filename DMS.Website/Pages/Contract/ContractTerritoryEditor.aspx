<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractTerritoryEditor.aspx.cs"
    Inherits="DMS.Website.Pages.Contract.ContractTerritoryEditor" %>

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


    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>
        <style type="text/css">
            .yellow-row {
                background: #FFD700;
            }
            .itemColor
            {
                background-color: #FF3300; 
            }
        </style>

        <script type="text/javascript">
            var changeRowBackColor = function (value, cellmeta, r) {
                if (r.data.HospitalCount == '是') {        //&& (r.data.HosDepart == ''||r.data.HosDepart==null)
                    cellmeta.css = 'itemColor';
                }
                return value;
            }
            var changeDeptRowBackColor = function (value, cellmeta, r) {
                if (r.data.IsMustFill == '是'&& (r.data.Depart == ''||r.data.Depart==null)) {
                    cellmeta.css = 'itemColor';
                }
                return value;
            }

            var MsgList = {
                AuthorizationStore:{
                    LoadExceptionTitle:"提示 - 数据加载失败",
                    CommitFailedTitle:"提示 - 提交失败",
                    SaveExceptionTitle:"提示 - 保存失败",
                    CommitDoneTitle:"提示",
                    CommitDoneMsg:"保存成功!"
                },
                Store2:{
                    LoadExceptionTitle:"提示 - 数据加载失败"
                },
                btnDelete:{
                    confirm:"确认删除授权产品？",
                    alert:"删除失败，请先删除授权医院!"
                },
                btnDeleteHospital:{
                    confirm:"你确信删除吗?"
                }
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
        
            var addItems = function(grid) {
                if (grid.hasSelection()) {
                    var selList = grid.selModel.getSelections();
                    var param = '';

                    for (var i = 0; i < selList.length; i++) {
                        param += selList[i].data.Id + ',';
                    }

                    Coolite.AjaxMethods.addProduct(param,{
                        success: function() {
                            Ext.getCmp('<%=this.gplAuthorization.ClientID%>').reload();
                        },
                        failure: function(err) {
                            Ext.Msg.alert('Error', err);
                        }
                    });


                } else {
                    Ext.MessageBox.alert('错误', '请选择要添加的产品');
                }
            }
        
            var authDetailsRender = function() {
                return '<img class="imgEdit" ext:qtip="批量导入医院" style="cursor:pointer;" src="../../resources/images/icons/note_edit.png" />';

            }
        
            var cellClick = function(grid, rowIndex, columnIndex, e) {
                var t = e.getTarget();
                var record = grid.getStore().getAt(rowIndex);  // Get the Record

                var columnId = grid.getColumnModel().getColumnId(columnIndex); // Get column id

                if(t.className == 'imgEdit' && columnId == 'Details')
                {
                    openAuthorizationDialog(record, t);
                }
            }
        
            //分产品线批量导入授权医院
            var openAuthorizationDialog =function(record,animTrg)
            {
                var datId=record.data["Id"];
                var contractId=Ext.getCmp('<%=this.hiddenContractId.ClientID%>');
                var wdurl=Ext.getCmp('<%=this.windowHospitalInsert.ClientID%>');
                var mktype=Ext.getCmp('<%=this.hidIsEmerging.ClientID%>');
            
                wdurl.autoLoad.url = '/Pages/Contract/ContractHospitalInfo.aspx?datId=' + datId+'&ContractId='+contractId.getValue()+'&MarktingType='+mktype.getValue();
                wdurl.reload();
                Ext.getCmp('<%=this.windowHospitalInsert.ClientID%>').show();
            }
       
            //全产品批量导入授权医院
            var openAuthorizationAllDialog =function()
            {
                var contractId=Ext.getCmp('<%=this.hiddenContractId.ClientID%>');
                var wdurl=Ext.getCmp('<%=this.windowHospitalInsert.ClientID%>');
                var mktype=Ext.getCmp('<%=this.hidIsEmerging.ClientID%>');
            
                wdurl.autoLoad.url = '/Pages/Contract/ContractHospitalInfo.aspx?datId=00000000-0000-0000-0000-000000000000&ContractId='+contractId.getValue()+'&MarktingType='+mktype.getValue();
                wdurl.reload();
                Ext.getCmp('<%=this.windowHospitalInsert.ClientID%>').show();
            }
       
            function getIsErrRowClass(record, index) {
                if (record.data.ISErr==1)
                {
                    return 'yellow-row';
                }
            }
        
            var selectedAuthorization = function(grid,row, record)
            {
                <%= hiddenId.ClientID %>.setValue(record.data["Id"]);    
                var btndel = Ext.getCmp("btnDelete");
                if(btndel != null)
                    btndel.enable();

                Ext.getCmp("gplAuthHospital").reload();
                Ext.getCmp("gpDeleteHospital").reload();
            }
        
            var showHospitalSelectorDlg = function() {
           
                var initType = <%= hidHospitalInitType.ClientID %>
                var lineId = <%= hiddenProductLine.ClientID %>.getValue();
                var dclId = <%= hiddenId.ClientID %>.getValue();
                var beginYear =<%= hidBeginDate.ClientID %>.getValue();
                initType.setValue("alone");
                if(dclId == null || dclId =="" || lineId == null || lineId == "")
                    Ext.Msg.alert('提醒', '请选择授权产品分类!');
                else 
                    openHospitalSearchDlg(lineId,beginYear);
            }

            var showHospitalSelectAllProductDlg = function() {
                var initType = <%= hidHospitalInitType.ClientID %>
                var lineId = <%= hiddenProductLine.ClientID %>.getValue();
                var beginYear =<%= hidBeginDate.ClientID %>.getValue();
                initType.setValue("all");

                if(lineId == null || lineId == "")
                    Ext.Msg.alert('提醒', '产品线为空，不能维护授权!');
                else 
                    openHospitalSearchDlg(lineId,beginYear);
            }
        
            //Dialog:复制医院
            var showHospitalCopyDlg = function() {
           
                var contractId = <%= hiddenContractId.ClientID %>.getValue();
                var dclId = <%= hiddenId.ClientID %>.getValue();
            
                if(dclId == null || dclId =="")
                    Ext.Msg.alert('提醒', '请选择授权分类!');
                else 
                    openAuthSelectorDlg();
            }
        
            var openAuthSelectorDlg = function () {
                var window = <%= AuthSelectorDlg.ClientID %>;
                <%= GridPanel1.ClientID %>.clear();
                <%= GridPanel1.ClientID %>.reload();
                window.show(null);
            }
        
            var showHospitalDepartDlg = function() {
           
                var contractId = <%= hiddenContractId.ClientID %>.getValue();
            
                Ext.getCmp('<%=this.cbDepartProduct.ClientID%>').store.reload();
                Ext.getCmp('<%=this.txtHospitalDepartType.ClientID%>').store.reload();
                Ext.getCmp('<%=this.txtGPHospitalUpdate.ClientID%>').reload();
            
                if(contractId == null || contractId ==""){
                    Ext.Msg.alert('提醒', '没有相关合同信息!');
                }
                else {
                    Coolite.AjaxMethods.UpdateHospitalDepart({
                        success: function() {
                            Ext.getCmp('<%=this.EditHospitalDepWindow.ClientID%>').show();
                        },
                        failure: function(err) {
                            Ext.Msg.alert('Error', err);
                        }
                    });
                }
            }
        
            var CheckNull = function(){
                if ( <%= txtHidDatId.ClientID %>.getValue()=="" )
                {
                    Ext.Msg.alert('Error', '请选择医院！');
                    return false;
                }
                if ( <%= txtHospitalDepartment.ClientID %>.getValue()=="" )
                {
                    Ext.Msg.alert('Error', '医院科室不能为空！');
                    return false;
                }
                return true;
            }
        
            var afterTerritoryDetails = function() {
                Ext.Msg.alert('Success','保存成功！');
                <%=gplAuthHospital.ClientID%>.reload();
                <%=txtGPHospitalUpdate.ClientID%>.reload();
            }
        
            var closeUploadHospitalWindow = function() {
                <%=windowHospitalInsert.ClientID%>.hide(null);
                <%=gplAuthHospital.ClientID%>.reload();
                Ext.Msg.alert('Success', '提交成功！');
            }

        </script>

        <ext:Hidden ID="hiddenId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenContractId" runat="server">
        </ext:Hidden>
        <ext:Store ID="AuthorizationStore" runat="server" UseIdConfirmation="false" OnRefreshData="AuthorizationStore_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="ProductLineSubDesc" />
                        <ext:RecordField Name="ProductLineSub" />
                        <ext:RecordField Name="PmaId" />
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DclId" />
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="ProductLineBumId" />
                        <ext:RecordField Name="AuthorizationType" />
                        <ext:RecordField Name="HospitalListDesc" />
                        <ext:RecordField Name="ProductDescription" />
                        <ext:RecordField Name="PmaDesc" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert(MsgList.AuthorizationStore.LoadExceptionTitle, e.message || e )" />
                <CommitFailed Handler="Ext.Msg.alert(MsgList.AuthorizationStore.CommitFailedTitle, 'Reason: ' + msg)" />
                <SaveException Handler="Ext.Msg.alert(MsgList.AuthorizationStore.SaveExceptionTitle, e.message || e)" />
                <CommitDone Handler="Ext.Msg.alert(MsgList.AuthorizationStore.CommitDoneTitle, MsgList.AuthorizationStore.CommitDoneMsg);" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="HospitalStore" runat="server" UseIdConfirmation="false" OnRefreshData="HospitalStore_RefershData"
            OnBeforeStoreChanged="HospitalStore_BeforeStoreChanged" AutoLoad="false">
            <AutoLoadParams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={10}" />
            </AutoLoadParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
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
                        <ext:RecordField Name="HospitalCount" />  
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert(MsgList.Store2.LoadExceptionTitle, e.message || e )" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="DeleteProductStore" runat="server" UseIdConfirmation="false" OnRefreshData="DeleteProductStore_RefershData" AutoLoad="true">
            <AutoLoadParams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={10}" />
            </AutoLoadParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="PmaId">
                    <Fields>
                        <ext:RecordField Name="PmaDesc" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="DeleteHospitalStore" runat="server" UseIdConfirmation="false" OnRefreshData="DeleteHospitalStore_RefershData" AutoLoad="false">
            <AutoLoadParams>
                <ext:Parameter Name="start" Value="={0}" />
                <ext:Parameter Name="limit" Value="={10}" />
            </AutoLoadParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="HosKeyAccount">
                    <Fields>
                        <ext:RecordField Name="HosKeyAccount" />
                        <ext:RecordField Name="HosHospitalName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <West MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel Icon="Cross" runat="server" Width="350" Title="本次合同删除的授权" Collapsed="false">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout4" runat="server">
                                    <Center MarginsSummary="0 0 0 0">
                                        <ext:Panel runat="server" Title="<font color='red'	>被删除的授权产品</font>" ID="Panel1" Border="false" Collapsible="true">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout5" runat="server">
                                                    <ext:GridPanel ID="GPDeleteProduct" runat="server" StoreID="DeleteProductStore"
                                                        Border="false" Icon="Lorry" Header="false">
                                                        <ColumnModel ID="ColumnModel6" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="PmaDesc" DataIndex="PmaDesc" Header="授权产品分类" Width="200">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                        <BottomBar>
                                                            <ext:PagingToolbar ID="DeleteProductPagingToolBar" runat="server" PageSize="10" StoreID="DeleteProductStore"
                                                                DisplayInfo="true" />
                                                        </BottomBar>
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                        </ext:Panel>
                                    </Center>
                                    <South Collapsible="false" MarginsSummary="0 0 0 0">
                                        <ext:Panel ID="Panel3" runat="server" Title="<font color='red'	>被删除医院</font>" Height="280" IDMode="Legacy" Collapsible="true" Border="false">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout6" runat="server">
                                                    <ext:GridPanel ID="gpDeleteHospital" runat="server" Header="false" Border="false" Icon="Lorry" StripeRows="true" StoreID="DeleteHospitalStore" Height="280">
                                                        <ColumnModel ID="ColumnModel7" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="医院名称" Width="150">
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosKeyAccount" ColumnID="HosKeyAccount" Header="医院编号">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                        <BottomBar>
                                                            <ext:PagingToolbar ID="DeleteHospitalPagingToolbar" runat="server" PageSize="10" StoreID="DeleteHospitalStore"
                                                                DisplayInfo="true" />
                                                        </BottomBar>
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                        </ext:Panel>
                                    </South>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Panel>
                    </West>
                    <Center MarginsSummary="5 5 5 5">
                        <ext:Panel ID="Panel2" runat="server" Title="" Header="false" Icon="Information">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout3" runat="server">
                                    <Center MarginsSummary="0 0 0 0">
                                        <ext:Panel runat="server" Title="授权产品" Icon="Lorry" ID="plAuthorization" Border="false"
                                            IDMode="Legacy">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout1" runat="server">
                                                    <ext:GridPanel ID="gplAuthorization" runat="server" StoreID="AuthorizationStore"
                                                        Border="false" Icon="Lorry" Header="false" AutoExpandColumn="ProductDescription"
                                                        StripeRows="true">
                                                        <ColumnModel ID="ColumnModel1" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="ProductLineSubDesc" DataIndex="ProductLineSubDesc" Header="合同产品分类"
                                                                    Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="PmaDesc" DataIndex="PmaDesc" Header="授权产品分类" Width="150">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductDescription" DataIndex="ProductDescription" Header="产品描述">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="HospitalListDesc" DataIndex="HospitalListDesc" Header="授权区域描述"
                                                                    Width="250">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Details" Header="批量导入医院" Width="150">
                                                                    <Renderer Fn="authDetailsRender" />
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true">
                                                                <Listeners>
                                                                    <RowSelect Fn="selectedAuthorization" />
                                                                </Listeners>
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                        <Listeners>
                                                            <CellClick Fn="cellClick" />
                                                        </Listeners>
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                            <Buttons>
                                                <ext:Button ID="BtnExecl" runat="server" Text="全产品批量导入医院" Icon="PageWhiteExcel" CommandArgument=""
                                                    CommandName="" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="openAuthorizationAllDialog()" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="btnAdd" runat="server" Text="新增授权产品" Icon="Add" CommandArgument=""
                                                    CommandName="" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="#{authorizationEditorWindow}.show();#{GridAllProduct}.reload();" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="btnDelete" runat="server" Text="删除授权产品" Icon="Delete" CommandArgument=""
                                                    CommandName="" IDMode="Legacy" OnClientClick="" Disabled="True">
                                                    <AjaxEvents>
                                                        <Click Before="var result = confirm(MsgList.btnDelete.confirm)&& #{gplAuthorization}.hasSelection(); if (!result) return false;"
                                                            OnEvent="DeleteAuthorization_Click" Success="#{gplAuthorization}.reload();#{GPDeleteProduct}.reload();#{hiddenId}.setValue('');#{btnDelete}.disable();"
                                                            Failure="Ext.Msg.alert('Message',MsgList.btnDelete.alert)">
                                                        </Click>
                                                    </AjaxEvents>
                                                </ext:Button>
                                            </Buttons>
                                        </ext:Panel>
                                    </Center>
                                    <South Collapsible="True" MarginsSummary="0 0 0 0">
                                        <ext:Panel ID="pnlSouth" runat="server" Title="包含医院" Icon="Basket" Height="280" IDMode="Legacy" Collapsible="true" Border="false">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout2" runat="server">
                                                    <ext:GridPanel ID="gplAuthHospital" runat="server" Title="包含医院" Header="false" StoreID="HospitalStore"
                                                        Border="false" Icon="Lorry" StripeRows="true">
                                                        <Buttons>
                                                            <ext:Button ID="btnAllProduct" runat="server" Text="全产品批量添加医院" Icon="ArrowUp" CommandArgument=""
                                                                CommandName="" IDMode="Legacy">
                                                                <Listeners>
                                                                    <Click Fn="showHospitalSelectAllProductDlg" />
                                                                </Listeners>
                                                            </ext:Button>
                                                            <ext:Button ID="btnAddHospital" runat="server" Text="添加医院" Icon="Add" CommandArgument=""
                                                                CommandName="" IDMode="Legacy">
                                                                <Listeners>
                                                                    <Click Fn="showHospitalSelectorDlg" />
                                                                </Listeners>
                                                            </ext:Button>
                                                            <ext:Button ID="btnCopyHospital" runat="server" Text="复制医院" Icon="DatabaseCopy" CommandArgument=""
                                                                CommandName="" IDMode="Legacy">
                                                                <Listeners>
                                                                    <Click Fn="showHospitalCopyDlg" />
                                                                </Listeners>
                                                            </ext:Button>
                                                            <ext:Button ID="btnDeleteHospital" runat="server" Text="删除" Icon="Delete" CommandArgument=""
                                                                CommandName="" IDMode="Legacy">
                                                                <Listeners>
                                                                    <Click Handler="var result = confirm(MsgList.btnDeleteHospital.confirm); var grid = #{gplAuthHospital};if ( (result) && grid.hasSelection()) { grid.deleteSelected(); grid.save();}" />
                                                                </Listeners>
                                                            </ext:Button>
                                                            <ext:Button ID="btnUpdateHospitalDepart" runat="server" Text="医院科室维护" Icon="Add"
                                                                CommandArgument="" CommandName="" IDMode="Legacy">
                                                                <Listeners>
                                                                    <Click Fn="showHospitalDepartDlg" />
                                                                </Listeners>
                                                            </ext:Button>
                                                            <ext:Button ID="Button2" runat="server" Text="导出授权" Icon="PageExcel" IDMode="Legacy"
                                                                AutoPostBack="true" OnClick="ExportExcel">
                                                            </ext:Button>
                                                        </Buttons>
                                                        <ColumnModel ID="ColumnModel2" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="OperType" DataIndex="OperType" Align="Center" Width="30" MenuDisabled="true">
                                                                    <Renderer Fn="change" />
                                                                </ext:Column>
                                                                <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="医院名称"
                                                                    Width="200">  
                                                                    <Renderer Fn="changeRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosKeyAccount" ColumnID="HosKeyAccount" Header="医院编号">
                                                                    <Renderer Fn="changeRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosGrade" Header="等级">
                                                                    <Renderer Fn="changeRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosProvince" Header="省份">
                                                                    <Renderer Fn="changeRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosCity" Header="地区">
                                                                    <Renderer Fn="changeRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosDistrict" Header="区/县">
                                                                    <Renderer Fn="changeRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosDepartTypeName" Width="100" Header="科室类型">
                                                                    <Renderer Fn="changeRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column DataIndex="HosDepart" Width="100" Header="科室名称">
                                                                    <Renderer Fn="changeRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column Width="150" DataIndex="HosDepartRemark" Header="备注">
                                                                    <Renderer Fn="changeRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column ColumnID="RepeatDealer" Width="200" DataIndex="RepeatDealer" Header="重复授权">
                                                                    <Renderer Fn="changeRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column ColumnID="HospitalCount" Width="200" DataIndex="HospitalCount" Header="必须维护科室" >
                                                                    <Renderer Fn="changeRowBackColor" />
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server">
                                                                <Listeners>
                                                                    <RowSelect Handler="var btndel = #{btnDelete}; if(btndel != null ) btndel.enable();" />
                                                                </Listeners>
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <BottomBar>
                                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="HospitalStore"
                                                                DisplayInfo="true" />
                                                        </BottomBar>
                                                        <LoadMask ShowMask="true" Msg="处理中..." />
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                        </ext:Panel>
                                    </South>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <%--添加授权产品--%>
        <ext:Store ID="AllProductStore" runat="server" UseIdConfirmation="false" OnRefreshData="AllProductStore_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="SubBuCode" />
                        <ext:RecordField Name="SubBuName" />
                        <ext:RecordField Name="CaCode" />
                        <ext:RecordField Name="CaName" />
                        <ext:RecordField Name="CaNameEn" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Window ID="authorizationEditorWindow" runat="server" Icon="Group" Title="授权产品"
            Closable="false" AutoShow="false" ShowOnLoad="false" Resizable="false" Height="400"
            Draggable="false" Width="450" Modal="true" BodyStyle="padding:5px;">
            <Body>
                <ext:FitLayout ID="FitLayout" runat="server">
                    <ext:GridPanel ID="GridAllProduct" runat="server" Title="" AutoExpandColumn="CaName"
                        Header="false" StoreID="AllProductStore" Border="false" Icon="Lorry" StripeRows="true">
                        <ColumnModel ID="ColumnModel3" runat="server">
                            <Columns>
                                <ext:Column ColumnID="SubBuName" DataIndex="SubBuName" Header="合同产品分类">
                                </ext:Column>
                                <ext:Column ColumnID="CaName" DataIndex="CaName" Header="授权产品分类">
                                </ext:Column>
                            </Columns>
                        </ColumnModel>
                        <Plugins>
                            <ext:GridFilters runat="server" ID="GridFilters1" Local="true">
                                <Filters>
                                    <ext:StringFilter DataIndex="SubBuName" />
                                    <ext:StringFilter DataIndex="CaName" />
                                </Filters>
                            </ext:GridFilters>
                        </Plugins>
                        <SelectionModel>
                            <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                <Listeners>
                                    <RowSelect Handler="#{btnSaveButton}.enable();" />
                                </Listeners>
                            </ext:CheckboxSelectionModel>
                        </SelectionModel>
                        <LoadMask ShowMask="true" Msg="处理中..." />
                    </ext:GridPanel>
                </ext:FitLayout>
            </Body>
            <Buttons>
                <ext:Button ID="btnSaveButton" runat="server" Text="确定" Icon="Disk">
                    <Listeners>
                        <Click Handler="addItems(#{GridAllProduct});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnCancelButton" runat="server" Text="取消" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{authorizationEditorWindow}.hide(null);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <%--复制授权医院--%>
        <ext:Store ID="AuthorizationSelectorStore" runat="server" UseIdConfirmation="false"
            OnRefreshData="AuthorizationSelectorStore_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="PmaId" />
                        <ext:RecordField Name="PmaDesc" />
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="ProductLineBumId" />
                        <ext:RecordField Name="AuthorizationType" />
                        <ext:RecordField Name="HospitalListDesc" />
                        <ext:RecordField Name="ProductDescription" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <LoadException Handler="Ext.Msg.alert('<%$ Resources: MSG.LoadException %>', e.message || e )" />
            </Listeners>
        </ext:Store>
        <ext:Window ID="AuthSelectorDlg" runat="server" Icon="Group" Title="复制医院" Closable="true"
            Draggable="false" Resizable="true" Width="900" Height="480" AutoShow="false"
            Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:ContainerLayout ID="ContainerLayout1" runat="server">
                    <ext:Panel runat="server" ID="Panelctl46" Border="false" Frame="true" Height="450" Header="false"
                        IDMode="Legacy">
                        <Body>
                            <ext:FitLayout ID="FitLayout3" runat="server">
                                <ext:GridPanel ID="GridPanel1" runat="server" Title="" AutoExpandColumn="ProductDescription"
                                    Header="false" StoreID="AuthorizationSelectorStore" Border="false" Icon="Lorry"
                                    StripeRows="true">
                                    <ColumnModel ID="ColumnModel4" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="PmaDesc" DataIndex="PmaDesc" Header="产品分类" Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="ProductDescription" DataIndex="ProductDescription" Header="产品描述">
                                            </ext:Column>
                                            <ext:Column ColumnID="HospitalListDesc" DataIndex="HospitalListDesc" Header="授权区域描述"
                                                Width="250">
                                            </ext:Column>
                                        </Columns>
                                    </ColumnModel>
                                    <SelectionModel>
                                        <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server" SingleSelect="true">
                                            <Listeners>
                                                <RowSelect Handler="#{btnCopy}.enable();" />
                                            </Listeners>
                                        </ext:CheckboxSelectionModel>
                                    </SelectionModel>
                                    <LoadMask ShowMask="true" Msg="处理中..." />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                        <Buttons>
                            <ext:Button ID="btnCopy" runat="server" Text="复制医院" Icon="Add" CommandArgument=""
                                CommandName="" IDMode="Legacy" OnClientClick="" Enabled="false">
                                <AjaxEvents>
                                    <Click OnEvent="SubmitSelection" Success="#{AuthSelectorDlg}.hide(null);">
                                        <ExtraParams>
                                            <ext:Parameter Name="SelectValues" Value="Ext.encode(#{GridPanel1}.getRowsValues())"
                                                Mode="Raw" />
                                        </ExtraParams>
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                            <ext:Button ID="btnCancel" runat="server" Text="取消" Icon="Cancel" CommandArgument=""
                                CommandName="" IDMode="Legacy" OnClientClick="">
                                <Listeners>
                                    <Click Handler="#{AuthSelectorDlg}.hide(null);" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:Panel>
                </ext:ContainerLayout>
            </Body>
        </ext:Window>
        <%--维护授权医院科室信息--%>
        <ext:Store ID="ProductTempStore" runat="server" UseIdConfirmation="false" AutoLoad="false"
            OnRefreshData="ProductTempStore_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="PmaId">
                    <Fields>
                        <ext:RecordField Name="PmaId" />
                        <ext:RecordField Name="ProductName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="HospitalProductStore" runat="server" UseIdConfirmation="false" AutoLoad="false"
            OnRefreshData="HospitalProductStore_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="HospitalCode" />
                        <ext:RecordField Name="HospitalId" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="Depart" />
                        <ext:RecordField Name="HosDepartTypeName" />
                        <ext:RecordField Name="DepartRemark" />
                        <ext:RecordField Name="PmaId" />
                        <ext:RecordField Name="ProductName" /> 
                        <ext:RecordField Name="IsMustFill" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="HospitalDepartStore" runat="server" OnRefreshData="HospitalDepartStore_RefershData"
            AutoLoad="false">
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
        <ext:Window ID="EditHospitalDepWindow" runat="server" Icon="Group" Title="医院科室备注"
            Width="800" Height="490" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" Maximizable="true">
            <Body>
                <ext:ColumnLayout ID="ColumnLayout2" runat="server" FitHeight="true">
                    <ext:LayoutColumn ColumnWidth="0.5">
                        <ext:Panel runat="server" ID="TXT" BodyBorder="false">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout2" runat="server">
                                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                                        <ext:Panel ID="PanelHospitalDepartSearh" runat="server" Title="查询" AutoHeight="true"
                                            BodyStyle="padding: 2px;" Frame="true" Icon="Find">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="cbDepartProduct" runat="server" Editable="false" TypeAhead="true"
                                                            Width="180" StoreID="ProductTempStore" ValueField="PmaId" Mode="Local" DisplayField="ProductName"
                                                            FieldLabel="授权产品分类" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="txtDepartHospitalName" runat="server" FieldLabel="医院名称" Width="180">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                            <Buttons>
                                                <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                    <Listeners>
                                                        <Click Handler="#{PagingToolBar2}.changePage(1);" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Buttons>
                                        </ext:Panel>
                                    </North>
                                    <Center Collapsible="True" MarginsSummary="0 5 0 0">
                                        <ext:Panel runat="server" ID="Panel4" Border="false" Frame="true" Icon="HouseKey"
                                            Title="授权医院">
                                            <Body>
                                                <ext:FitLayout ID="FitLayout4" runat="server">
                                                    <ext:GridPanel ID="txtGPHospitalUpdate" runat="server" Header="false" StoreID="HospitalProductStore"
                                                        Border="false" Icon="Lorry" AutoExpandColumn="HospitalName" AutoExpandMax="250"
                                                        AutoExpandMin="150" StripeRows="true">
                                                        <ColumnModel ID="ColumnModel5" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="ProductName" DataIndex="ProductName" Header="产品分类">
                                                                    <Renderer Fn="changeDeptRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column ColumnID="HospitalCode" DataIndex="HospitalCode" Header="医院编码" Hidden="true">
                                                                    <Renderer Fn="changeDeptRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="医院">
                                                                    <Renderer Fn="changeDeptRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Depart" DataIndex="Depart" Header="科室">
                                                                    <Renderer Fn="changeDeptRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column ColumnID="HosDepartTypeName" DataIndex="HosDepartTypeName" Header="科室分类">
                                                                    <Renderer Fn="changeDeptRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column ColumnID="IsMustFill" DataIndex="IsMustFill" Header="是否必须维护">
                                                                    <Renderer Fn="changeDeptRowBackColor" />
                                                                </ext:Column>
                                                                <ext:Column ColumnID="DepartRemark" Width="50" DataIndex="DepartRemark" Hidden="true">
                                                                </ext:Column>
                                                            </Columns>
                                                        </ColumnModel>
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
                                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="30" StoreID="HospitalProductStore"
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
                                        <ext:Hidden ID="txtHidDatId" runat="server">
                                        </ext:Hidden>
                                    </ext:Anchor>
                                    <ext:Anchor Horizontal="100%">
                                        <ext:Label runat="server" ID="tetProductName" FieldLabel="产品分类">
                                        </ext:Label>
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
                            <Buttons>
                                <ext:Button ID="SaveButton" runat="server" Text="提交" Icon="Disk">
                                    <AjaxEvents>
                                        <Click OnEvent="SaveTerritoryDepart_Click" Success="afterTerritoryDetails();" Before="return CheckNull();">
                                        </Click>
                                    </AjaxEvents>
                                </ext:Button>
                                <ext:Button ID="ClearButton" runat="server" Text="清除" Icon="PageCancel">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.HospitalDepartClear({success:function(){#{txtGPHospitalUpdate}.reload();#{gplAuthHospital}.reload();},failure:function(err){Ext.Msg.alert('Error', err);}}) " />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </ext:LayoutColumn>
                </ext:ColumnLayout>
            </Body>
            <Buttons>
                <ext:Button ID="CancelButton" runat="server" Text="关闭窗口" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{gplAuthHospital}.reload(); #{EditHospitalDepWindow}.hide(null);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <%-- 维护导入授权医院--%>
        <ext:Window ID="windowHospitalInsert" runat="server" Icon="Group" Title="授权医院导入"
            Hidden="true" Resizable="false" Header="false" Width="700" Height="500" AutoShow="false"
            Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <AutoLoad Mode="IFrame" MaskMsg="加载中……" ShowMask="true" Scripts="true" />
        </ext:Window>
        <uc1:HospitalSearchDCMSDialog ID="HospitalSearchDCMSDialog1" runat="server" />
        <ext:Hidden ID="hiddenProductLine" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenDealer" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidDivisionID" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsEmerging" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidIsChange" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidPartsContractCode" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidContractType" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidBeginDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidEndDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidLastContractId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidPageOperation" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidHospitalInitType" runat="server">
        </ext:Hidden>
    </form>
</body>
</html>
