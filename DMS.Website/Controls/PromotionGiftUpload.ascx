<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PromotionGiftUpload.ascx.cs"
    Inherits="DMS.Website.Controls.PromotionGiftUpload" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>

<script type="text/javascript" language="javascript">
    function PageClear() {
        var cbType = Ext.getCmp('<%=this.cbType.ClientID%>');
        var cbMarketType = Ext.getCmp('<%=this.cbMarketType.ClientID%>');
        var cbPriceTypeReason = Ext.getCmp('<%=this.cbPriceTypeReason.ClientID%>');
  <%--      var cbApprove = Ext.getCmp('<%=this.cbApprove.ClientID%>');--%>
        var dfBeginDate = Ext.getCmp('<%=this.dfBeginDate.ClientID%>');
        var dfEndDate = Ext.getCmp('<%=this.dfEndDate.ClientID%>');
        var wdTaRemark = Ext.getCmp('<%=this.wdTaRemark.ClientID%>');
        var FileUploadField1 = Ext.getCmp('<%=this.FileUploadField1.ClientID%>');
        var GridAttachmentl = Ext.getCmp('<%=this.GridAttachmentl.ClientID%>');

        cbType.setValue("");
        cbMarketType.setValue("");
        cbPriceTypeReason.setValue("");
        cbMarketType.setValue("");
        //cbApprove.setValue("");
        dfBeginDate.reset();
        dfEndDate.reset();
        wdTaRemark.reset();
        FileUploadField1.reset();
        GridAttachmentl.reload();
    }
</script>

<style type="text/css">
    .txtBlue
    {
        color: Red;
        font-weight: bold;
    }
</style>
<ext:Hidden runat="server" ID="hidAttachmentId">
</ext:Hidden>
<ext:Hidden runat="server" ID="hidMassage"></ext:Hidden>
<ext:Hidden runat="server" ID="hidQtyCheck"></ext:Hidden>
<ext:Hidden runat="server" ID="hidFlowId"></ext:Hidden>
<ext:Store ID="AttachmentStore" runat="server" OnRefreshData="AttachmentStore_RefreshData"
    AutoLoad="true">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Attachment" />
                <ext:RecordField Name="Name" />
                <ext:RecordField Name="Url" />
                <ext:RecordField Name="Type" />
                <ext:RecordField Name="UploadUser" />
                <ext:RecordField Name="Identity_Name" />
                <ext:RecordField Name="UploadDate" />
                <ext:RecordField Name="TypeName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>

<ext:Window ID="wdGiftUpload" runat="server" Icon="Group" Title="确认赠品导入（促销执行）" Hidden="true"
    Resizable="false" Header="false" Width="700" Height="350" AutoShow="false" Modal="true"
    ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:FitLayout ID="FitLayout1" runat="server">
            <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                <Tabs>
                    <ext:Tab ID="TabHeader" runat="server" Title="赠送信息" BodyBorder="false" AutoScroll="true"
                        BodyStyle="padding: 6px;">
                        <%--表头信息 --%>
                        <Body>
                            <ext:FormLayout ID="FormLayout20" runat="server">
                                <ext:Anchor>
                                    <ext:FormPanel ID="BasicForm" runat="server" Header="false" BodyBorder="false" Border="false"
                                        MonitorValid="true">
                                        <Defaults>
                                            <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                                            <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                                            <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                                        </Defaults>
                                        <Body>
                                            <ext:FormPanel ID="FormPanelHard2" runat="server" BodyBorder="false" Border="false"
                                                FormGroup="true">
                                                <Body>
                                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                        <ext:LayoutColumn ColumnWidth="0.5">
                                                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="90">
                                                                        <ext:Anchor>
                                                                            <ext:ComboBox ID="cbType" runat="server" EmptyText="选择类型..." Editable="false" AllowBlank="false"
                                                                                Width="200" TypeAhead="true" Mode="Local" FieldLabel="类型" Resizable="true">
                                                                                <Items>
                                                                                    <ext:ListItem Text="赠品" Value="赠品" />
                                                                                    <ext:ListItem Text="积分" Value="积分" />
                                                                                </Items>
                                                                                <Triggers>
                                                                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                                </Triggers>
                                                                                <Listeners>
                                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                                </Listeners>
                                                                            </ext:ComboBox>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:Label ID="lbPriceType" runat="server" FieldLabel="价格类型" Text="促销执行申请" Width="200">
                                                                            </ext:Label>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:DateField ID="dfBeginDate" runat="server" FieldLabel="起始有效时间" Width="200" AllowBlank="false" />
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth="0.5">
                                                            <ext:Panel ID="Panel2" runat="server" Border="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="90">
                                                                        <ext:Anchor>
                                                                            <ext:ComboBox ID="cbMarketType" runat="server" EmptyText="选择市场类型..." Editable="false"
                                                                                Width="200" AllowBlank="false" TypeAhead="true" Mode="Local" FieldLabel="市场类型"
                                                                                Resizable="true">
                                                                                <Items>
                                                                                    <ext:ListItem Text="红海" Value="0" />
                                                                                    <ext:ListItem Text="蓝海" Value="1" />
                                                                                    <ext:ListItem Text="不分红蓝海" Value="2" />
                                                                                </Items>
                                                                                <Triggers>
                                                                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                                </Triggers>
                                                                                <Listeners>
                                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                                </Listeners>
                                                                            </ext:ComboBox>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:ComboBox ID="cbPriceTypeReason" runat="server" EmptyText="请选择类型原因..." Editable="false"
                                                                                Width="200" AllowBlank="false" TypeAhead="true" Mode="Local" FieldLabel="类型原因"
                                                                                Resizable="true">
                                                                                <Items>
                                                                                  <%--  <ext:ListItem Text="已获取亚太审批的促销政策" Value="已获取亚太审批的促销政策" />
                                                                                    <ext:ListItem Text="不需获取亚太审批的促销政策(非红票冲抵)" Value="不需获取亚太审批的促销政策(非红票冲抵)" />
                                                                                    <ext:ListItem Text="不需获取亚太审批的促销政策(红票冲抵)" Value="不需获取亚太审批的促销政策(红票冲抵)" />--%>
                                                                                </Items>
                                                                                <Triggers>
                                                                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                                </Triggers>
                                                                                <Listeners>
                                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                                </Listeners>
                                                                            </ext:ComboBox>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:DateField ID="dfEndDate" runat="server" FieldLabel="终止有效时间" Width="200" AllowBlank="false" />
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                    </ext:ColumnLayout>
                                                </Body>
                                            </ext:FormPanel>
<%--                                            <ext:FormPanel ID="FormPanel1" runat="server" BodyBorder="false" Border="false" FormGroup="true">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="90">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbApprove" runat="server" EmptyText="选择审批层面..." Editable="false"
                                                                Width="200" AllowBlank="false" TypeAhead="true" Mode="Local" FieldLabel="审批层面选择"
                                                                Resizable="true">
                                                                <Items>
                                                                    <ext:ListItem Text="BU审批" Value="Bu" />
                                                                    <ext:ListItem Text="RSM审批" Value="Rsm" />
                                                                </Items>
                                                                <Triggers>
                                                                    <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                </Triggers>
                                                                <Listeners>
                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                </Listeners>
                                                            </ext:ComboBox>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:FormPanel>--%>
                                            <ext:FormPanel ID="FormPanel2" runat="server" BodyBorder="false" Border="false" FormGroup="true">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="90">
                                                        <ext:Anchor>
                                                            <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="请选择文件" FieldLabel="执行结果上传"
                                                                Width="500" ButtonText="" Icon="ImageAdd">
                                                            </ext:FileUploadField>
                                                        </ext:Anchor>
                                                        <ext:Anchor>
                                                            <ext:TextArea ID="wdTaRemark" runat="server" FieldLabel=" 目的" Width="500">
                                                            </ext:TextArea>
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:FormPanel>
                                        </Body>
                                    </ext:FormPanel>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                    </ext:Tab>
                    <ext:Tab ID="Tab3" runat="server" Title="附件信息" AutoScroll="true">
                        <%-- 附件管理--%>
                        <Body>
                            <ext:FitLayout ID="FitLayout5" runat="server">
                                <ext:GridPanel ID="GridAttachmentl" runat="server" StoreID="AttachmentStore" StripeRows="true"
                                    BodyBorder="false">
                                    <TopBar>
                                        <ext:Toolbar ID="Toolbar1" runat="server">
                                            <Items>
                                                <ext:ToolbarFill />
                                                <ext:Button ID="btnAddAttachmentl" runat="server" Text="添加附件" Icon="Add">
                                                    <Listeners>
                                                        <Click Handler="#{ufUploadAttachment}.reset();#{btnWinAttachmentSubmit}.setDisabled(true);#{wdAttachment}.show();" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Items>
                                        </ext:Toolbar>
                                    </TopBar>
                                    <ColumnModel ID="ColumnModel3" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="Name" DataIndex="Name" Width="250" Header="附件名称">
                                            </ext:Column>
                                            <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Width="150" Header="上传人">
                                            </ext:Column>
                                            <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Width="90" Header="上传时间">
                                            </ext:Column>
                                            <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                        <ToolTip Text="下载" />
                                                    </ext:GridCommand>
                                                </Commands>
                                            </ext:CommandColumn>
                                            <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                        <ToolTip Text="删除" />
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
                                        <Command Handler="if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该文件?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.PromotionGiftUpload.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                        success: function() {
                                                                                            #{GridAttachmentl}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });
                                                                         }if (command == 'DownLoad'){
                                                                                    var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=Promotion';
                                                                                    open(url, 'Download');
                                                                                  }  " />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="5" StoreID="AttachmentStore"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Tab>
                </Tabs>
            </ext:TabPanel>
        </ext:FitLayout>
    </Body>
    <Buttons>
       <%-- <ext:Button ID="SaveButton" runat="server" Text="提交审批" Icon="PageSave">
            <AjaxEvents>
                <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; }
                                        " Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="RefreshPages();">
                </Click>
            </AjaxEvents>
        </ext:Button>--%>
         <ext:Button ID="btnDeleteDraft" runat="server" Text="提交审批"
            Icon="PageSave">
            <Listeners>
                <Click Handler="Coolite.AjaxMethods.PromotionGiftUpload.inputSubmint(
                        {
                            success:function(result)
                                        {
                                            if(result=='true')
                                             {
                                                  Ext.Msg.confirm('Message','本次导入总数为：'+#{hidQtyCheck}.getValue() +'，确认提交？',
                                                    function(e) {
                                                        if (e == 'yes') {
                                                                            Coolite.AjaxMethods.PromotionGiftUpload.InputSubmintToEwf({success:function(result)
                                                                                    { if(result=='true'){Ext.Msg.alert('成功', '导入成功，已提交审批！');RefreshPages();} 
                                                                                        else {Ext.Msg.alert('Error', result);}},failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                        }
                                                                        else{
                                                                            Coolite.AjaxMethods.PromotionGiftUpload.DeleteGift({success:function(){RefreshPages();},failure:function(err){Ext.Msg.alert('Error', err);}})
                                                                        }   
                                                            });
                                             }
                                             else { Ext.Msg.alert('Error', result);}
                                        },failure:function(err){Ext.Msg.alert('Error', err);}});
          " />
            </Listeners>
        </ext:Button>
        <ext:Button ID="ResetButton" runat="server" Text="清除" Icon="PageCancel">
            <Listeners>
                <Click Handler="PageClear();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnPolicyGiftCancel" runat="server" Text="关闭" Icon="Decline">
            <Listeners>
                <Click Handler="#{wdGiftUpload}.hide(null);" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <LoadMask ShowMask="true" />
</ext:Window>
<ext:Window ID="wdAttachment" runat="server" Icon="Group" Title="上传附件" Resizable="false"
    Header="false" Width="500" Height="150" AutoShow="false" Modal="true" ShowOnLoad="false"
    BodyStyle="padding:5px;">
    <Body>
        <ext:FormPanel ID="AttachmentForm" runat="server" Width="500" Frame="true" Header="false"
            AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
            <Defaults>
                <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
            </Defaults>
            <Body>
                <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="100">
                    <ext:Anchor>
                        <ext:FileUploadField ID="ufUploadAttachment" runat="server" EmptyText="选择上传附件" FieldLabel="文件"
                            ButtonText="" Icon="ImageAdd">
                        </ext:FileUploadField>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Listeners>
                <ClientValidation Handler="#{btnWinAttachmentSubmit}.setDisabled(!valid);" />
            </Listeners>
            <Buttons>
                <ext:Button ID="btnWinAttachmentSubmit" runat="server" Text="上传附件">
                    <AjaxEvents>
                        <Click OnEvent="UploadAttachmentClick" Before="if(!#{AttachmentForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');" Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });" Success="#{GridAttachmentl}.reload();#{ufUploadAttachment}.setValue('')">
                        </Click>
                    </AjaxEvents>
                </ext:Button>
                <ext:Button ID="Button1" runat="server" Text="清除">
                    <Listeners>
                        <Click Handler="#{AttachmentForm}.getForm().reset();#{btnWinAttachmentSubmit}.setDisabled(true);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:FormPanel>
    </Body>
    <Listeners>
        <BeforeShow Handler="#{ufUploadAttachment}.setValue('');" />
    </Listeners>
</ext:Window>
