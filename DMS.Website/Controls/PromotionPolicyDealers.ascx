<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PromotionPolicyDealers.ascx.cs"
    Inherits="DMS.Website.Controls.PromotionPolicyDealers" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>

<script type="text/javascript" language="javascript">
   function RefreshDetailWindow7() {
        Ext.getCmp('<%=this.GridWd7PolicyDealer.ClientID%>').store.reload();
        Ext.getCmp('<%=this.GridWd3PolicyDealerSeleted.ClientID%>').store.reload(); 
    }
    function RefreshDealerWindow7() {
        Ext.getCmp('<%=this.GridWd7DealerList.ClientID%>').store.reload();
    }
    
    function getIsErrRowClassDealer(record, index) {
        if (record.data.ISErr==1)
        {
           return 'yellow-row';
        }
    }
</script>

<ext:Hidden ID="hidWd7PageType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd7PromotionState" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd7PolicyId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd7ProductLineId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWd7SubBuCode" runat="server">
</ext:Hidden>
<ext:Store ID="PolicyDealerCanStore" runat="server" OnRefreshData="PolicyDealerCanStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="DmaId">
            <Fields>
                <ext:RecordField Name="DmaId" />
                <ext:RecordField Name="DealerName" />
                <ext:RecordField Name="DealerFullName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="PolicyDealerSeletedStore" runat="server" OnRefreshData="PolicyDealerSeletedStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="DEALERID">
            <Fields>
                <ext:RecordField Name="DEALERID" />
                <ext:RecordField Name="DealerName" />
                <ext:RecordField Name="OperType" />
                <ext:RecordField Name="WithType" />
                <ext:RecordField Name="PolicyId" />
                <ext:RecordField Name="Remark1" />
                <ext:RecordField Name="DealerFullName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="UpLoadDealerListStore" runat="server" OnRefreshData="UpLoadDealerListStore_RefreshData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="SAPCode" />
                <ext:RecordField Name="DealerName" />
                <ext:RecordField Name="ErrMsg" />
                <ext:RecordField Name="ISErr" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Window ID="wd7PolicyDealer" runat="server" Icon="Group" Title="政策适用对象" Resizable="false"
    Header="false" Width="600" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
    BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout20" runat="server">
            <ext:Anchor>
                <ext:Panel ID="PanelWd3PolicyFactor" runat="server" Border="true" Title="查询条件" BodyStyle="padding:5px;">
                    <Body>
                        <ext:FormLayout ID="FormLayout21" runat="server" LabelWidth="100">
                            <ext:Anchor>
                                <ext:TextField ID="txtWd7DealerName" runat="server" FieldLabel="经销商名称" Width="200">
                                </ext:TextField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnWd7PolicyDealerQuery" runat="server" Text="查询" Icon="ArrowRefresh">
                            <Listeners>
                                <Click Handler="#{PagingToolBarPolicyDealersCan}.changePage(1);" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="btnWd7PolicyDealerUpload" runat="server" Text="上传指定经销商" Icon="PackageAdd">
                            <Listeners>
                                <Click Handler="Coolite.AjaxMethods.PromotionPolicyDealers.DealerUploadShow({success:function(){RefreshDealerWindow7();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="PanelWd3AddFactorCondition" runat="server" BodyBorder="false" Header="false"
                    FormGroup="true">
                    <Body>
                        <ext:FitLayout ID="FitLayout3" runat="server">
                            <ext:GridPanel ID="GridWd7PolicyDealer" runat="server" StoreID="PolicyDealerCanStore"
                                Border="false" Title="<font color='red'>可选经销商</font>" Icon="Lorry" StripeRows="true"
                                Height="180" AutoScroll="true">
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="DmaId" DataIndex="DmaId" Align="Left" Header="经销商ID" Hidden="true">
                                        </ext:Column>
                                        <ext:Column ColumnID="DealerFullName" DataIndex="DealerFullName" Align="Left" Header="经销商名称"
                                            Width="300">
                                        </ext:Column>
                                        <ext:CommandColumn Width="80" Header="选择" Align="Center">
                                            <Commands>
                                                <ext:GridCommand Icon="Add" CommandName="Add" Text="包含">
                                                    <ToolTip Text="添加" />
                                                </ext:GridCommand>
                                            </Commands>
                                        </ext:CommandColumn>
                                        <ext:CommandColumn Width="80" Header="排除" Align="Center">
                                            <Commands>
                                                <ext:GridCommand Icon="Delete" CommandName="Delete" Text="不包含">
                                                    <ToolTip Text="不包含" />
                                                </ext:GridCommand>
                                            </Commands>
                                        </ext:CommandColumn>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <Listeners>
                                    <Command Handler="if (command == 'Add'){
                                        Coolite.AjaxMethods.PromotionPolicyDealers.DelaerAdd(record.data.DmaId,{ success: function() { #{GridWd3PolicyDealerSeleted}.reload();#{GridWd7PolicyDealer}.reload();},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                    } 
                                    if (command == 'Delete'){
                                        Coolite.AjaxMethods.PromotionPolicyDealers.DelaerExclusive(record.data.DmaId,{ success: function() { #{GridWd3PolicyDealerSeleted}.reload();#{GridWd7PolicyDealer}.reload();},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                    } 
                                    " />
                                </Listeners>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBarPolicyDealersCan" runat="server" PageSize="10"
                                        StoreID="PolicyDealerCanStore" DisplayInfo="true" />
                                </BottomBar>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="PanelWd3PolicyDealerSelected" runat="server" BodyBorder="false" Header="false"
                    FormGroup="true">
                    <Body>
                        <ext:FitLayout ID="FitLayout1" runat="server">
                            <ext:GridPanel ID="GridWd3PolicyDealerSeleted" runat="server" StoreID="PolicyDealerSeletedStore"
                                Border="false" Title="<font color='red'>已选经销商</font>" Icon="Lorry" StripeRows="true"
                                Height="200" AutoScroll="true">
                                <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="DEALERID" DataIndex="DEALERID" Align="Left" Header="经销商ID"
                                            Hidden="true">
                                        </ext:Column>
                                        <ext:Column ColumnID="DealerFullName" DataIndex="DealerFullName" Align="Left" Header="经销商名称"
                                            Width="300">
                                        </ext:Column>
                                        <ext:Column ColumnID="OperType" DataIndex="OperType" Align="Left" Header="类型" Width="120">
                                        </ext:Column>
                                        <ext:CommandColumn Width="80" Header="删除" Align="Center">
                                            <Commands>
                                                <ext:GridCommand Icon="Decline" CommandName="Delete" Text="删除">
                                                    <ToolTip Text="删除" />
                                                </ext:GridCommand>
                                            </Commands>
                                        </ext:CommandColumn>
                                    </Columns>
                                </ColumnModel>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <Listeners>
                                    <Command Handler="if (command == 'Delete'){
                                    Coolite.AjaxMethods.PromotionPolicyDealers.DeleteSelectedDealer(record.data.DEALERID,{ success: function() { #{GridWd3PolicyDealerSeleted}.reload();#{GridWd7PolicyDealer}.reload();},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                    } " />
                                </Listeners>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBarPolicyDealersSelected" runat="server" PageSize="10"
                                        StoreID="PolicyDealerSeletedStore" DisplayInfo="true" />
                                </BottomBar>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnPolicyDealerCancel" runat="server" Text="关闭" Icon="LorryAdd">
                            <Listeners>
                                <Click Handler="#{wd7PolicyDealer}.hide(null);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </ext:Anchor>
        </ext:FormLayout>
    </Body>
</ext:Window>
<ext:Window ID="wd7DealerUpload" runat="server" Icon="Group" Title="指定经销商导入" Hidden="true"
    Resizable="false" Header="false" Width="700" AutoHeight="true" AutoShow="false"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:FormLayout ID="FormLayout2" runat="server">
            <ext:Anchor>
                <ext:FormPanel ID="BasicFormDealer" runat="server" Frame="true" Header="false" AutoHeight="true"
                    MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="50">
                            <ext:Anchor>
                                <ext:FileUploadField ID="FileUploadFieldDealer" runat="server" EmptyText="选择封顶值"
                                    FieldLabel="文件" Width="500" ButtonText="" Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{SaveButtonDealer}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="SaveButtonDealer" runat="server" Text="上传指定经销商">
                            <AjaxEvents>
                                <Click OnEvent="UploadDealerClick" Before="if(!#{BasicFormDealer}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传指定经销商...', '指定经销商上传');" Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="#{PagingToolBarDealer}.changePage(1);#{FileUploadFieldDealer}.setValue(''); Ext.Msg.show({ 
                                        title   : '成功', 
                                        msg     : '上传成功', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        buttons : Ext.Msg.OK 
                                    })">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="ResetButton" runat="server" Text="清除">
                            <Listeners>
                                <Click Handler="#{BasicFormDealer}.getForm().reset();#{SaveButtonDealer}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                        <ext:Button ID="ButtonTopValueDownLoad" runat="server" Text="下载模板">
                            <Listeners>
                                <Click Handler="window.open('../../Upload/ExcelTemplate/Template_PromotionDealerInit.xls')" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </ext:Anchor>
            <ext:Anchor>
                <ext:Panel ID="PanelWd7DealerList" runat="server" BodyBorder="false" Header="false"
                    FormGroup="true">
                    <Body>
                        <ext:FitLayout ID="FitLayout4" runat="server">
                            <ext:GridPanel ID="GridWd7DealerList" runat="server" StoreID="UpLoadDealerListStore"
                                Border="false" Title="指定经销商" Icon="Lorry" StripeRows="true" Height="300" AutoScroll="true">
                                <ColumnModel ID="ColumnModel3" runat="server">
                                    <Columns>
                                        <ext:Column ColumnID="SAPCode" DataIndex="SAPCode" Align="Left" Header="经销商Code"
                                            Width="80">
                                        </ext:Column>
                                        <ext:Column ColumnID="DealerName" DataIndex="DealerName" Align="Left" Header="经销商名称"
                                            Width="150">
                                        </ext:Column>
                                        <ext:Column ColumnID="ErrMsg" DataIndex="ErrMsg" Align="Left" Header="错误信息" Width="200">
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                                <View>
                                    <ext:GridView ID="GridView1" runat="server">
                                        <GetRowClass Fn="getIsErrRowClassDealer" />
                                    </ext:GridView>
                                </View>
                                <SelectionModel>
                                    <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server">
                                    </ext:RowSelectionModel>
                                </SelectionModel>
                                <BottomBar>
                                    <ext:PagingToolbar ID="PagingToolBarDealer" runat="server" PageSize="20" StoreID="UpLoadDealerListStore"
                                        DisplayInfo="true" />
                                </BottomBar>
                                <SaveMask ShowMask="true" />
                                <LoadMask ShowMask="true" />
                            </ext:GridPanel>
                        </ext:FitLayout>
                    </Body>
                </ext:Panel>
            </ext:Anchor>
        </ext:FormLayout>
    </Body>
    <Buttons>
        <ext:Button ID="ButtonWd7Submint" runat="server" Text="提交" Icon="LorryAdd" Hidden="true">
            <Listeners>
                <Click Handler="Coolite.AjaxMethods.PromotionPolicyDealers.DealerSubmint({ success: function() { #{GridWd3PolicyDealerSeleted}.reload();#{GridWd7PolicyDealer}.reload();#{wd7DealerUpload}.hide(null);},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="Button1" runat="server" Text="关闭" Icon="LorryStop">
            <Listeners>
                <Click Handler="#{wd7DealerUpload}.hide(null);" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
