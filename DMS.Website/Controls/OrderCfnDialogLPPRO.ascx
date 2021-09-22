<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrderCfnDialogLPPRO.ascx.cs"
    Inherits="DMS.Website.Controls.OrderCfnDialogLPPRO" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
<style type="text/css">
    .x-form-empty-field
    {
        color: #bbbbbb;
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }
    .x-small-editor .x-form-field
    {
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }
    .x-small-editor .x-form-text
    {
        height: 20px;
        line-height: 16px;
        vertical-align: middle;
    }
</style>

<script language="javascript" type="text/javascript">
    function RefreshDetailCFNPROWindow() { 
        Ext.getCmp('<%=this.cbProProductType.ClientID%>').store.reload(); 
       }
  
    //添加选中的产品
    var addItems2 = function(grid) {
        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
        var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
            var param = '';
            var checkparam = '';
            for (var i = 0; i < selList.length; i++) {
                param += selList[i].id + '@' + selList[i].data.Price + '@' + selList[i].data.UOM + ',';
                checkparam += selList[i].id + ',' + selList[i].data.DLid+ '|';
            }
            Coolite.AjaxMethods.OrderCfnDialogLPPRO.DoAddItems(param,checkparam,
                        {
                            success: function() {
                            
                              if (rtnVal.getValue() == "Success") {
                                    ReloadDetail();
                                }  else {
                                    Ext.Msg.alert('Error', rtnMsg.getValue());
                                }
                                //clearItems();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                        );
            //            Ext.Msg.confirm('Message', '<%=GetLocalResourceObject("addItems.confirm.Body").ToString()%>',
            //                function(e) {
            //                    if (e == 'yes') {
            //                        Coolite.AjaxMethods.OrderCfnDialogLP.DoAddItems(param,
            //                        {
            //                            success: function() {
            //                                ReloadDetail();
            //                                //clearItems();
            //                            },
            //                            failure: function(err) {
            //                                Ext.Msg.alert('Error', err);
            //                            }
            //                        }
            //                        );
            //                    } else {

            //                    }
            //                });
        } else {
            Ext.MessageBox.alert('Message', '<%=GetLocalResourceObject("addItems.alert.Body").ToString()%>');
        }
    }

    //关闭页面
    var closeWindow2 = function() {
        Ext.getCmp('<%=this.CfnWindow.ClientID%>').hide();
        clearItems2();
        //ReloadDetail();
    }

    //清除页面查询结果
    var clearItems2 = function() {
        Ext.getCmp('<%=this.GridPanel2.ClientID%>').clear();
    }

    function beforeRowSelect2(s, n, k, r) {
        if (r.get("IsCanOrder") == '否' || r.get("IsCanOrder") == '否（经销商资质无此分类代码）') return false;
    }

    function setCheckboxStatus2(v, p, record) {
        if (record.get("IsCanOrder") == '否' || record.get("IsCanOrder") == '否（经销商资质无此分类代码）') return "";
        return '<div class="x-grid3-row-checker">&#160;</div>';
    }

    Ext.onReady(function() {
        var sm = Ext.getCmp('<%=this.GridPanel2.ClientID %>').getSelectionModel();
        sm.renderer = setCheckboxStatus2;
    });
    
    var resetDescription2=function() {
        
        var cbProProductType=Ext.getCmp('<%=this.cbProProductType.ClientID%>');
        var tfDescription=Ext.getCmp('<%=this.tfDescription.ClientID%>');
        var txtLeftNum=Ext.getCmp('<%=this.txtLeftNum.ClientID%>');
        
        for (var i=0 ;i< cbProProductType.store.getTotalCount(); i++){
          if( cbProProductType.store.getAt(i).get('DLID')==cbProProductType.getValue()){
            tfDescription.setValue(cbProProductType.store.getAt(i).get('Description'));
            txtLeftNum.setValue(cbProProductType.store.getAt(i).get('LeftNum'));
          }
        }
        
    }
</script>

<ext:Store ID="CurrentCfnStore" runat="server" OnRefreshData="CurrentCfnStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="DLid" />
                <ext:RecordField Name="CustomerFaceNbr" />
                <ext:RecordField Name="ChineseName" />
                <ext:RecordField Name="EnglishName" />
                <ext:RecordField Name="Price" />
                <ext:RecordField Name="UOM" />
                <ext:RecordField Name="IsCanOrder" />
                <ext:RecordField Name="Avaiable" />
                <ext:RecordField Name="ProductMsg" />
                <ext:RecordField Name="CurRegNo" />
                <ext:RecordField Name="CurValidDateFrom" />
                <ext:RecordField Name="CurValidDataTo" />
                <ext:RecordField Name="CurManuName" />
                <ext:RecordField Name="LastRegNo" />
                <ext:RecordField Name="LastValidDateFrom" />
                <ext:RecordField Name="LastValidDataTo" />
                <ext:RecordField Name="LastManuName" />
                <ext:RecordField Name="CurGMKind" />
                <ext:RecordField Name="CurGMCatalog" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="ProProductTypeStore" runat="server" OnRefreshData="ProProductTypeStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="DLID">
            <Fields>
                <ext:RecordField Name="DLID" />
                <ext:RecordField Name="ListValue" />
                <ext:RecordField Name="Description" />
                <ext:RecordField Name="LeftNum" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="if(#{cbProProductType}.getValue()==''){#{cbProProductType}.setValue(#{cbProProductType}.store.getTotalCount()>0?#{cbProProductType}.store.getAt(0).get('DLID'):'');#{tfDescription}.setValue(#{cbProProductType}.store.getTotalCount()>0?#{cbProProductType}.store.getAt(0).get('Description'):'');#{txtLeftNum}.setValue(#{cbProProductType}.store.getTotalCount()>0?#{cbProProductType}.store.getAt(0).get('LeftNum'):'');}" />
    </Listeners>
</ext:Store>
<ext:Hidden ID="hidHeaderId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidProductLine" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidDealerId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidOrderTypeId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPriceTypeId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidSpecialPriceId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnVal" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnMsg" runat="server">
</ext:Hidden>
<ext:Window ID="CfnWindow" runat="server" Icon="Group" Title="<%$ Resources: CfnWindow.Title %>"
    Width="900" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:Panel ID="Panel4" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".4">
                                <ext:Panel ID="Panel6" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="110">
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbProProductType" runat="server" Width="200" Editable="true" TypeAhead="true"
                                                    StoreID="ProProductTypeStore" ValueField="DLID" DisplayField="ListValue" Mode="Local"
                                                    EmptyClass="x-form-empty-field" FieldLabel="赠品产品分类" Resizable="true">
                                                    <Listeners>
                                                        <Select Fn="resetDescription2" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtLeftNum" runat="server" Width="200" FieldLabel="剩余数量或积分" ReadOnly="true"
                                                    SelectOnFocus="true" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="tfDescription" runat="server" Width="200" FieldLabel="产品描述" ReadOnly="true"
                                                    SelectOnFocus="true" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Checkbox ID="chkDisplayCanOrder" runat="server" Checked="true" FieldLabel="<%$ Resources: chkDisplayCanOrder.FieldLabel %>"
                                                    Hidden="false">
                                                </ext:Checkbox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".6">
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false" LabelWidth="180">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCFN" runat="server" Width="250" FieldLabel="<%$ Resources: Lable_Product_Number  %>"
                                                    SelectOnFocus="true" EmptyText="<%$ Resources: txtCFN.EmptyText %>" EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCFNName" runat="server" Width="250" FieldLabel="<%$ Resources: Lable_Product_Name  %>"
                                                    SelectOnFocus="true" EmptyText="<%$ Resources: txtCFN.EmptyText %>" EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Checkbox ID="chkShare" runat="server" FieldLabel="<%$ Resources: chkShare.FieldLabel %>"
                                                    Hidden="true">
                                                </ext:Checkbox>
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
                                <%--<Click Handler="#{GridPanel2}.reload();" />--%>
                                <Click Handler="#{PagingToolBar2}.changePage(1);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="Panel8" runat="server" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout2" runat="server">
                            <ext:GridPanel ID="GridPanel2" runat="server" StoreID="CurrentCfnStore" Title="<%$ Resources: GridPanel2.Title %>"
                                Border="false" Icon="Lorry" StripeRows="true" AutoExpandColumn="ChineseName"
                                Header="false">
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                         <ext:Column ColumnID="DLid" DataIndex="DLid" Header="促销赠品编号" Hidden="true">
                                        </ext:Column>
                                        <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="EnglishName" Width="200" DataIndex="EnglishName" Header="<%$ Resources: GridPanel2.EnglishName %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel2.ChineseName %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="Price" DataIndex="Price" Header="<%$ Resources: GridPanel2.Price %>"
                                            Width="80" Align="Right">
                                            <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                        </ext:Column>
                                        <ext:Column ColumnID="UOM" DataIndex="UOM" Header="<%$ Resources: GridPanel2.UOM %>"
                                            Width="50" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Sheet" DataIndex="Sheet" Header="<%$ Resources: GridPanel2.Sheets %>"
                                            Width="50" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Avaiable" DataIndex="Avaiable" Header="<%$ Resources: GridPanel2.Avaiable %>"
                                            Width="60" Align="Right">
                                        </ext:Column>
                                        <ext:Column ColumnID="IsCanOrder" DataIndex="IsCanOrder" Header="<%$ Resources: GridPanel2.IsCanOrder %>"
                                            Width="50" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="ProductMsg" DataIndex="ProductMsg" Header="<%$ Resources: GridPanel2.ProductMsg %>"
                                            Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="CurGMKind" DataIndex="CurGMKind" Header="产品类别" Width="60" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="CurGMCatalog" DataIndex="CurGMCatalog" Header="产品分类代码" Width="100"
                                            Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="CurRegNo" DataIndex="CurRegNo" Header="注册证编号-1" Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="CurManuName" DataIndex="CurManuName" Header="生产企业(注册证-1)" Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="LastRegNo" DataIndex="LastRegNo" Header="注册证编号-2" Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="LastManuName" DataIndex="LastManuName" Header="生产企业(注册证-2)"
                                            Width="100">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="CurrentCfnStore"
                                        DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
                                </BottomBar>
                                <SelectionModel>
                                    <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server">
                                        <Listeners>
                                            <BeforeRowSelect Fn="beforeRowSelect2" />
                                        </Listeners>
                                    </ext:CheckboxSelectionModel>
                                </SelectionModel>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </Center>
        </ext:BorderLayout>
        <ext:KeyMap ID="KeyMap1" runat="server" Target="={Ext.isGecko ? Ext.getDoc() : Ext.getBody()}">
            <ext:KeyBinding>
                <Keys>
                    <ext:Key Code="ENTER" />
                </Keys>
                <Listeners>
                    <Event Handler="#{PagingToolBar2}.changePage(1);" />
                </Listeners>
            </ext:KeyBinding>
            <ext:KeyBinding Shift="true">
                <Keys>
                    <ext:Key Code="ENTER" />
                </Keys>
                <Listeners>
                    <Event Handler="addItems2(#{GridPanel2});" />
                </Listeners>
            </ext:KeyBinding>
        </ext:KeyMap>
    </Body>
    <Buttons>
        <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources: AddItemsButton.Text %>"
            Icon="Add">
            <Listeners>
                <Click Handler="addItems2(#{GridPanel2});" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <Buttons>
        <ext:Button ID="CloseWindow" runat="server" Text="<%$ Resources: CloseWindowButton.Text %>"
            Icon="Delete">
            <Listeners>
                <Click Handler="closeWindow2();" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
