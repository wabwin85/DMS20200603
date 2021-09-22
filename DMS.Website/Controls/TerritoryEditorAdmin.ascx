<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TerritoryEditorAdmin.ascx.cs" Inherits="DMS.Website.Controls.TerritoryEditorAdmin" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<script type="text/javascript">
    var MsgList = {
        AuthorizationStore: {
            LoadExceptionTitle: "提示 - 数据加载失败",
            CommitFailedTitle: "提示 - 提交失败",
            SaveExceptionTitle: "提示 - 保存失败",
            CommitDoneTitle: "提示",
            CommitDoneMsg: "保存成功!"
        },
        Store2: {
            LoadExceptionTitle: "提示 - 数据加载失败"
        },
        btnDelete: {
            confirm: "确认删除授权产品？",
            alert: "删除失败，请先删除授权医院!"
        },
        btnDeleteHospital: {
            confirm: "你确信删除吗?"
        }
    }
    var addItems = function (grid) {
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
            var param = '';

            for (var i = 0; i < selList.length; i++) {
                param += selList[i].data.Id + ',';
            }

            Coolite.AjaxMethods.TerritoryEditorAdmin.addProduct(param, {
                success: function () {
                    Ext.getCmp('<%=this.gplAuthorization.ClientID%>').reload();
                },
                failure: function (err) {
                    Ext.Msg.alert('Error', err);
                }
            });
        } else {
            Ext.MessageBox.alert('错误', '请选择要添加的产品');
        }
    }
    var selectedAuthorization = function (grid, row, record) {
        Ext.getCmp('<%=this.hiddenId.ClientID%>').setValue(record.data["Id"]);
        var btndel = Ext.getCmp('<%=this.btnDelete.ClientID%>');
        if (btndel != null) {
            btndel.enable();
        }
        Ext.getCmp('<%=this.gplAuthHospital.ClientID%>').reload();
    }

    var CheckNull = function () {
        if (Ext.getCmp('<%=this.txtHidDatId.ClientID%>').getValue() == "") {
            Ext.Msg.alert('Error', '请选择医院！');
            return false;
        }
        if (Ext.getCmp('<%=this.txtHospitalDepartment.ClientID%>').getValue() == "") {
            Ext.Msg.alert('Error', '医院科室不能为空！');
            return false;
        }
        return true;
    }
    var showHospitalCopyDlg = function () {
        var dclId = Ext.getCmp('<%=this.hiddenId.ClientID%>').getValue();

        if (dclId == null || dclId == "")
            Ext.Msg.alert('提醒', '请选择授权分类!');
        else
            openAuthSelectorDlg();
    }
    var openAuthSelectorDlg = function () {
        var window = Ext.getCmp('<%=this.AuthSelectorDlg.ClientID%>');
        Ext.getCmp('<%=this.GridPanel1.ClientID%>').clear();
        Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
        window.show(null);
    }
    var showHospitalSelectorDlg = function () {
        var dclId = Ext.getCmp('<%=this.hiddenId.ClientID%>').getValue();
        if (dclId == null || dclId == "") {
            Ext.Msg.alert('提醒', '请选择授权产品分类!');
        }
        else {
            var window = Ext.getCmp('<%=this.HospitalSearchWindow.ClientID%>');
            window.show(null);
        }

    }
    var addHospitalItems = function (grid) {
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
            var param = '';

            for (var i = 0; i < selList.length; i++) {
                param += selList[i].data.HosId + ',';
            }
            Coolite.AjaxMethods.TerritoryEditorAdmin.SubmintHospitalAdd(param, {
                success: function () {
                    Ext.Msg.alert('Success', '保存成功!');
                    Ext.getCmp('<%=this.gplAuthHospital.ClientID%>').reload();

                },
                failure: function (err) {
                    Ext.Msg.alert('Error', err);
                }
            });
        } else {
            Ext.MessageBox.alert('错误', '请选择医院!');
        }
    }
    //维护医院科室信息
    var showHospitalDepartDlg = function() {
    }
</script>
<ext:Store ID="AuthorizationStore" runat="server" UseIdConfirmation="false" OnRefreshData="AuthorizationStore_RefershData" AutoLoad="false">
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
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <LoadException Handler="Ext.Msg.alert(MsgList.Store2.LoadExceptionTitle, e.message || e )" />
    </Listeners>
</ext:Store>
<ext:Hidden ID="hiddenContractId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenTempId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidContractType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidSubBU" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidBeginDate" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenDealer" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenProductLine" runat="server">
</ext:Hidden>

<ext:Hidden ID="hiddenId" runat="server">
</ext:Hidden>


<ext:Window ID="PartsDetailsWindow" runat="server" Icon="Group" Title="调整授权"
    AutoShow="false" ShowOnLoad="false" Resizable="false" Draggable="false" Height="550" Width="900" AutoScroll="true"
    Modal="true" BodyStyle="padding:5px;">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:Panel runat="server" Title="授权产品" Icon="Lorry" ID="plAuthorization" Border="false" Height="220"
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
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                    <Buttons>

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
                                    OnEvent="DeleteAuthorization_Click" Success="#{gplAuthorization}.reload();#{hiddenId}.setValue('');#{btnDelete}.disable();"
                                    Failure="Ext.Msg.alert('Message',MsgList.btnDelete.alert)">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="pnlSouth" runat="server" Title="包含医院" Icon="Basket" IDMode="Legacy" Collapsible="true" Border="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout2" runat="server">
                            <ext:GridPanel ID="gplAuthHospital" runat="server" Title="包含医院" Header="false" StoreID="HospitalStore"
                                Border="false" Icon="Lorry" StripeRows="true">
                                <Buttons>
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
                                    <ext:Button ID="btnUpdateHospitalDepart" runat="server" Text="医院科室维护" Icon="Add" Hidden="true"
                                        CommandArgument="" CommandName="" IDMode="Legacy">
                                        <%--  <Listeners>
                                            <Click Fn="showHospitalDepartDlg" />
                                        </Listeners>--%>
                                    </ext:Button>
                                    <ext:Button ID="Button2" runat="server" Text="关闭" Icon="Cancel" CommandArgument=""
                                        CommandName="" IDMode="Legacy">
                                        <Listeners>
                                            <Click Handler="#{PartsDetailsWindow}.hide(null);" />
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="医院名称"
                                            Width="200">
                                        </ext:Column>
                                        <ext:Column DataIndex="HosKeyAccount" ColumnID="HosKeyAccount" Header="医院编号">
                                        </ext:Column>
                                        <ext:Column DataIndex="HosGrade" Header="等级">
                                        </ext:Column>
                                        <ext:Column DataIndex="HosProvince" Header="省份">
                                        </ext:Column>
                                        <ext:Column DataIndex="HosCity" Header="地区">
                                        </ext:Column>
                                        <ext:Column DataIndex="HosDistrict" Header="区/县">
                                        </ext:Column>
                                        <ext:Column DataIndex="HosDepartTypeName" Width="100" Header="科室类型">
                                        </ext:Column>
                                        <ext:Column DataIndex="HosDepart" Width="100" Header="科室名称">
                                        </ext:Column>
                                        <ext:Column Width="150" DataIndex="HosDepartRemark" Header="备注">
                                        </ext:Column>
                                        <ext:Column ColumnID="RepeatDealer" Width="200" DataIndex="RepeatDealer" Header="重复授权">
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
            </Center>
        </ext:BorderLayout>
    </Body>
</ext:Window>
<%--添加授权产品--%>
<ext:Store ID="AllProductStore" runat="server" UseIdConfirmation="false" OnRefreshData="AllProductStore_RefershData" AutoLoad="false">
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

<ext:Window ID="EditHospitalDepWindow" runat="server" Icon="Group" Title="医院科室备注"
    Width="800" Height="490" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false" Maximizable="true">
    <Body>
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
                        <Click OnEvent="SaveTerritoryDepart_Click" Success=" Ext.Msg.alert('Success','保存成功！');#{gplAuthHospital}.reload();" Before="return CheckNull();">
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="ClearButton" runat="server" Text="清除" Icon="PageCancel">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.TerritoryEditorAdmin.HospitalDepartClear({success:function(){#{gplAuthHospital}.reload();},failure:function(err){Ext.Msg.alert('Error', err);}}) " />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="CancelButton" runat="server" Text="关闭窗口" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{gplAuthHospital}.reload();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Panel>
    </Body>

</ext:Window>

<%--新增授权医院--%>
<ext:Store ID="HospitalSearchDlgStore" runat="server" UseIdConfirmation="false" OnRefreshData="HospitalSearchDlgStore_RefershData"
    AutoLoad="false">
    <AutoLoadParams>
        <ext:Parameter Name="start" Value="={0}" />
        <ext:Parameter Name="limit" Value="={15}" />
    </AutoLoadParams>
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="HosId">
            <Fields>
                <ext:RecordField Name="HosId" />
                <ext:RecordField Name="HosHospitalShortName" />
                <ext:RecordField Name="HosHospitalName" />
                <ext:RecordField Name="HosGrade" />
                <ext:RecordField Name="HosKeyAccount" />
                <ext:RecordField Name="HosProvince" />
                <ext:RecordField Name="HosCity" />
                <ext:RecordField Name="HosDistrict" />
                <ext:RecordField Name="HosPhone" />
                <ext:RecordField Name="HosPostalCode" />
                <ext:RecordField Name="HosAddress" />
                <ext:RecordField Name="HosPublicEmail" />
                <ext:RecordField Name="HosWebsite" />
                <ext:RecordField Name="HosChiefEquipment" />
                <ext:RecordField Name="HosChiefEquipmentContact" />
                <ext:RecordField Name="HosDirector" />
                <ext:RecordField Name="HosDirectorContact" />
                <ext:RecordField Name="HosDirectorContact" />
                <ext:RecordField Name="HosLastModifiedDate" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <LoadException Handler="Ext.Msg.alert('Massage', e.message || e )" />
    </Listeners>
</ext:Store>
<ext:Window ID="HospitalSearchWindow" runat="server" Icon="Group" Title="新增授权医院" Closable="true"
    Draggable="false" Resizable="true" Width="900" Height="480" AutoShow="false"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:ContainerLayout ID="ContainerLayout2" runat="server">
            <ext:Panel ID="plSearch" runat="server" Border="false" Frame="true" Header="false"
                ButtonAlign="Right">
                <Body>
                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                        <ext:LayoutColumn ColumnWidth=".5">
                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                <Body>
                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="80">
                                        <ext:Anchor>
                                            <ext:TextField ID="txtSearchHospitalName" runat="server" FieldLabel="医院名称" Width="150" />
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>
                        </ext:LayoutColumn>
                        <ext:LayoutColumn ColumnWidth=".5">
                            <ext:Panel ID="Panel2" runat="server" Border="false">
                                <Body>
                                    <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="80">
                                        <ext:Anchor>
                                            <ext:TextField ID="txtHospitalCode" runat="server" FieldLabel="医院编号" Width="150" />
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
                            <Click Handler="#{GridPanel2}.clear();#{GridPanel2}.reload();" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="btnOk" runat="server" Text="添加" Icon="Disk" CommandArgument="" CommandName=""
                        IDMode="Legacy" Enabled="false">
                        <Listeners>
                            <Click Handler="addHospitalItems(#{GridPanel2});" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="Button1" runat="server" Text="关闭" Icon="Cancel" CommandArgument=""
                        CommandName="" IDMode="Legacy" OnClientClick="">
                        <Listeners>
                            <Click Handler="#{HospitalSearchWindow}.hide(null);" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Panel>
            <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Height="300" Header="false">
                <Body>
                    <ext:FitLayout ID="FitLayout4" runat="server">
                        <ext:GridPanel ID="GridPanel2" runat="server" Title="" AutoExpandColumn="HosHospitalName"
                            Header="false" StoreID="HospitalSearchDlgStore" Border="false" Icon="Lorry" StripeRows="true">
                            <ColumnModel ID="ColumnModel5" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="医院名称">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosKeyAccount" Header="医院编号">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosGrade" Header="医院等级">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosProvince" Header="省份">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosCity" Header="城市">
                                    </ext:Column>
                                    <ext:Column DataIndex="HosDistrict" Header="区县">
                                    </ext:Column>
                                </Columns>
                            </ColumnModel>
                            <Plugins>
                                <ext:GridFilters runat="server" ID="GridFilters2" Local="true">
                                    <Filters>
                                        <ext:StringFilter DataIndex="HosHospitalName" />
                                        <ext:StringFilter DataIndex="HosKeyAccount" />
                                        <ext:StringFilter DataIndex="HosGrade" />
                                        <ext:StringFilter DataIndex="HosProvince" />
                                        <ext:StringFilter DataIndex="HosCity" />
                                        <ext:StringFilter DataIndex="HosDistrict" />
                                    </Filters>
                                </ext:GridFilters>
                            </Plugins>
                            <SelectionModel>
                                <ext:CheckboxSelectionModel ID="CheckboxSelectionModel3" runat="server">
                                    <Listeners>
                                        <RowSelect Handler="#{btnOk}.enable();" />
                                    </Listeners>
                                </ext:CheckboxSelectionModel>
                            </SelectionModel>
                            <BottomBar>
                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="HospitalSearchDlgStore" />
                            </BottomBar>
                            <LoadMask ShowMask="true" Msg="正在加载……" />
                        </ext:GridPanel>
                    </ext:FitLayout>
                </Body>
            </ext:Panel>
        </ext:ContainerLayout>
    </Body>
</ext:Window>
