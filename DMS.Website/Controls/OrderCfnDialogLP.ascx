<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrderCfnDialogLP.ascx.cs" Inherits="DMS.Website.Controls.OrderCfnDialogLP" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
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

    //添加选中的产品
    var addItems = function(grid) {
        if (grid.hasSelection()) {
            var selList = grid.selModel.getSelections();
           
            //var param = '';
            //for (var i = 0; i < selList.length; i++) {
            //    param += selList[i].id + '@' + selList[i].data.Price + '@' + selList[i].data.UOM + ',';
            //}
            var chklist = document.getElementsByName("chkItem");
            var txtlist = document.getElementsByName("txtItem");
            var paramWithQty = '';
            for (var i = 0; i < chklist.length; i++) {
                if (chklist[i].checked) {
                   
                        paramWithQty += chklist[i].value + '@' + txtlist[i].value + ',';
                    }                       
                    
                    //alert(grid.getStore().getById(chklist[i].value).data.LotInvQty);
                    //alert(txtlist[i].value);
                }
            
            if (paramWithQty == '') {
                Ext.MessageBox.alert('Error', '请选择要添加的产品');
                return;
            }
            Coolite.AjaxMethods.OrderCfnDialogLP.DoAddItems(paramWithQty,
                        {
                            success: function() {
                                ReloadDetail();
                                //clearItems();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                        );
            
        } else {
            Ext.MessageBox.alert('Message', '<%=GetLocalResourceObject("addItems.alert.Body").ToString()%>');
        }
    }

    //关闭页面
    var closeWindow = function() {
        Ext.getCmp('<%=this.CfnWindow.ClientID%>').hide();
        clearItems();
        //ReloadDetail();
    }

    //清除页面查询结果
    var clearItems = function() {
        Ext.getCmp('<%=this.GridPanel2.ClientID%>').clear();
    }

    function beforeRowSelect(s, n, k, r) {
        if (r.get("IsCanOrder") == '否' || r.get("IsCanOrder") == '否（经销商资质无此分类代码）') return false;
    }

    function setCheckboxStatus(v, p, record) {
        if (record.get("IsCanOrder") == '否' || record.get("IsCanOrder") == '否（经销商资质无此分类代码）') return "";
        return '<div class="x-grid3-row-checker">&#160;</div>';
    }

    Ext.onReady(function() {
        var sm = Ext.getCmp('<%=this.GridPanel2.ClientID %>').getSelectionModel();
        sm.renderer = setCheckboxStatus;
    });
    function btnCfnInfoClick(Upn) {
    var Upn=Upn.split(',')[0];
    //window.parent.loadExample('/Pages/Order/CfnnotorderInfo.aspx?UPN='+Upn+'','subMenu230',"产品不可订购信息查询");
    top.createTab({id: 'subMenu230',title: '产品不可订购信息查询',url: 'Pages/Order/CfnnotorderInfo.aspx?UPN=' + Upn});
    }

    var RenderCheckBox = function (value) {
        
        var name = getNameFromStoreById(<%= CurrentCfnStore.ClientID %>, { Key: 'Id', Value: 'IsCanOrder' }, value);
        //alert(name);
        if (name == '否' || name == '否（经销商资质无此分类代码或已过期）') return "";
        return "<input type='checkbox' name='chkItem' value='" + value + "'>";
    }

    var RenderTextBox = function (value) {
        return "<input type='text' name='txtItem' id='tb" + value.toString() + "' value='1' style='width:40px;color:blue;border:1px solid #D0D0D0;background-color: #FFFFBF;' align='Right' >";
    }
</script>

<ext:Store ID="CurrentCfnStore" runat="server" OnRefreshData="CurrentCfnStore_RefershData" AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="CustomerFaceNbr" />
                <ext:RecordField Name="ChineseName" />
                <ext:RecordField Name="EnglishName" />
                <ext:RecordField Name="Price" />
                <ext:RecordField Name="UOM" />
                <ext:RecordField Name="IsCanOrder" />
                <ext:RecordField Name="Avaiable" />
                <ext:RecordField Name="Sheet" />
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
<ext:Window ID="CfnWindow" runat="server" Icon="Group" Title="<%$ Resources: CfnWindow.Title %>" Width="900" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" Resizable="false" Header="false">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:Panel ID="Panel4" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".6">
                                <ext:Panel ID="Panel6" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="120">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCFN" runat="server" Width="300" FieldLabel="<%$ Resources: Lable_Product_Number  %>" SelectOnFocus="true" EmptyText="<%$ Resources: txtCFN.EmptyText %>" EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCFNName" runat="server" Width="300" FieldLabel="<%$ Resources: Lable_Product_Name  %>" SelectOnFocus="true" EmptyText="<%$ Resources: txtCFN.EmptyText %>" EmptyClass="x-form-empty-field" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".4">
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false" LabelWidth="80">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left">
                                            <ext:Anchor>
                                                <ext:Checkbox ID="chkShare" runat="server" FieldLabel="<%$ Resources: chkShare.FieldLabel %>" Hidden="true">
                                                </ext:Checkbox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:Checkbox ID="chkDisplayCanOrder" runat="server" Checked="true" FieldLabel="<%$ Resources: chkDisplayCanOrder.FieldLabel %>" Hidden="false">
                                                </ext:Checkbox>
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnSearch" Text="<%$ Resources: btnSearch.Text %>" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                            <Listeners>
                                <%--<Click Handler="#{GridPanel2}.reload();" />--%>
                                <Click Handler="#{PagingToolBar2}.changePage(1);" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="btnCfnInfo" Text="查询产品是否可订购" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                            <Listeners>
                                <%--<Click Handler="#{GridPanel2}.reload();" />--%>
                                <Click Handler="btnCfnInfoClick(#{txtCFN}.getValue());" /> 
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </North>
            <Center MarginsSummary="0 5 5 5">
                <ext:Panel ID="Panel8" runat="server" Height="300" Header="false">
                    <Body>
                        <ext:FitLayout ID="FitLayout2" runat="server">
                            <ext:GridPanel ID="GridPanel2" runat="server" StoreID="CurrentCfnStore" Title="<%$ Resources: GridPanel2.Title %>" Border="false" Icon="Lorry" StripeRows="true" AutoExpandColumn="ChineseName" Header="false">
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="chkId" DataIndex="Id" Header="选择" Width="30" Sortable="false">
                                            <Renderer Fn="RenderCheckBox"  />
                                        </ext:Column>
                                        <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="EnglishName" Width="200" DataIndex="EnglishName" Header="<%$ Resources: GridPanel2.EnglishName %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel2.ChineseName %>">
                                        </ext:Column>
                                        <ext:Column ColumnID="Price" DataIndex="Price" Header="<%$ Resources: GridPanel2.Price %>" Width="80" Align="Right">
                                            <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                        </ext:Column>
                                        <ext:Column ColumnID="UOM" DataIndex="UOM" Header="<%$ Resources: GridPanel2.UOM %>" Width="50" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Sheet" DataIndex="Sheet" Header="<%$ Resources: GridPanel2.Sheets %>" Width="50" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="Avaiable" DataIndex="Avaiable" Header="<%$ Resources: GridPanel2.Avaiable %>" Width="60" Align="Right">
                                        </ext:Column>
                                        <ext:Column ColumnID="IsCanOrder" DataIndex="IsCanOrder" Header="<%$ Resources: GridPanel2.IsCanOrder %>"
                                            Width="50" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="ProductMsg" DataIndex="ProductMsg" Header="<%$ Resources: GridPanel2.ProductMsg %>"
                                            Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="ShipmentQtyDialog" DataIndex="Id" Header="订购数量(个)" Width="75" Align="Center">
                                            <Renderer Fn="RenderTextBox" />
                                        </ext:Column>
                                        <ext:Column ColumnID="CurGMKind" DataIndex="CurGMKind" Header="产品类别" Width="60" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="CurGMCatalog" DataIndex="CurGMCatalog" Header="产品分类代码" Width="100" Align="Center">
                                        </ext:Column>
                                        <ext:Column ColumnID="CurRegNo" DataIndex="CurRegNo" Header="注册证编号-1" Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="CurManuName" DataIndex="CurManuName" Header="生产企业(注册证-1)" Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="LastRegNo" DataIndex="LastRegNo" Header="注册证编号-2" Width="100">
                                        </ext:Column>
                                        <ext:Column ColumnID="LastManuName" DataIndex="LastManuName" Header="生产企业(注册证-2)" Width="100">
                                        </ext:Column>
                                       
                                    </Columns>
                                </ColumnModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="10" StoreID="CurrentCfnStore" DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
                                </BottomBar>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true">
                                        
                                    </ext:RowSelectionModel>
                                    <%--<ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server">
                                        <Listeners>
                                            <BeforeRowSelect Fn="beforeRowSelect" />
                                        </Listeners>
                                    </ext:CheckboxSelectionModel>--%>
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
                    <Event Handler="addItems(#{GridPanel2});" />
                </Listeners>
            </ext:KeyBinding>
        </ext:KeyMap>
    </Body>
    <Buttons>
        <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources: AddItemsButton.Text %>" Icon="Add">
            <Listeners>
                <Click Handler="addItems(#{GridPanel2});" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <Buttons>
        <ext:Button ID="CloseWindow" runat="server" Text="<%$ Resources: CloseWindowButton.Text %>" Icon="Delete">
            <Listeners>
                <Click Handler="closeWindow();" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
