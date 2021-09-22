<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PolicyFactorInfo.aspx.cs"
    Inherits="DMS.Website.Pages.Promotion.PolicyFactorInfo" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/PromotionPolicyFactorSearch.ascx" TagName="PromotionPolicyFactorSearch"
    TagPrefix="uc" %>
<%@ Register Src="../../Controls/PromotionPolicyFactorRuleSearch.ascx" TagName="PromotionPolicyFactorRuleSearch"
    TagPrefix="uc" %>
<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript" language="javascript">
        function RefreshFolicyFactorWindow() {
            Ext.getCmp('<%=this.GridFolicyFactor.ClientID%>').reload();
        }
        function SetPageActivate() {
            var btnAddFolicyFactor = Ext.getCmp('<%=this.btnAddFolicyFactor.ClientID%>');
            var GridFolicyFactor = Ext.getCmp('<%=this.GridFolicyFactor.ClientID%>');
            alert(parent.pagetype());
              alert(parent.promotionstate());
            if (parent.pagetype()=='View')
            {
                GridFolicyFactor.getColumnModel().setHidden(4, true);
                btnAddFolicyFactor.disable();
            }
            else if (parent.pagetype()=='Modify' && (parent.promotionstate()=='审批中' || parent.promotionstate()=='有效'|| parent.promotionstate()=='无效'|| parent.promotionstate()=='审批拒绝'))
            {
               GridFolicyFactor.getColumnModel().setHidden(4, true);
                btnAddFolicyFactor.disable();
            }else{
                GridFolicyFactor.getColumnModel().setHidden(4, false);
                btnAddFolicyFactor.enable();
            }
        }
    </script>

    <%--政策因素--%>
    <ext:Store ID="FolicyFactorStore" runat="server" OnRefreshData="FolicyFactorStore_RefreshData"
        AutoLoad="true">
        <Proxy>
            <ext:DataSourceProxy />
        </Proxy>
        <Reader>
            <ext:JsonReader ReaderID="PolicyFactorId">
                <Fields>
                    <ext:RecordField Name="PolicyFactorId" />
                    <ext:RecordField Name="PolicyId" />
                    <ext:RecordField Name="FactId" />
                    <ext:RecordField Name="FactName" />
                    <ext:RecordField Name="FactDesc" />
                    <ext:RecordField Name="IsGift" />
                    <ext:RecordField Name="IsPoint" />
                    <ext:RecordField Name="IsGiftName" />
                </Fields>
            </ext:JsonReader>
        </Reader>
    </ext:Store>
    <form id="form1" runat="server">
    <ext:Hidden ID="hidInstanceId" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidPageType" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidPromotionState" runat="server">
    </ext:Hidden>
    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <ext:BorderLayout ID="BorderLayout1" runat="server">
                <North MarginsSummary="0 0 0 0" Collapsible="true">
                    <ext:Hidden ID="hidPageHidden" runat="server">
                    </ext:Hidden>
                </North>
                <Center MarginsSummary="0 0 0 0">
                    <ext:Panel ID="Panel46" runat="server" BodyBorder="false" BodyStyle="padding:0px;">
                        <Body>
                            <ext:FitLayout ID="FitLayout2" runat="server">
                                <ext:GridPanel ID="GridFolicyFactor" runat="server" StoreID="FolicyFactorStore" Border="false"
                                    Icon="Lorry" StripeRows="true">
                                    <TopBar>
                                        <ext:Toolbar ID="Toolbar1" runat="server">
                                            <Items>
                                                <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                <ext:Button ID="btnAddFolicyFactor" runat="server" Text="新增因素" Icon="Add">
                                                    <Listeners>
                                                        <Click Handler="Coolite.AjaxMethods.PromotionPolicyFactorSearch.Show(parent.instanceid(),'',parent.policystyle(),parent.policystylesub(),parent.productlineid(),parent.subbu(),parent.pagetype(),parent.promotionstate(),{success:function(){RefreshDetailWindow2();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                                        <%--    <Click Handler="alert(parent.instanceid());" />--%>
                                                    </Listeners>
                                                </ext:Button>
                                            </Items>
                                        </ext:Toolbar>
                                    </TopBar>
                                    <ColumnModel ID="ColumnModel1" runat="server">
                                        <Columns>
                                            <ext:Column ColumnID="FactName" DataIndex="FactName" Header="因素名称" Width="150">
                                            </ext:Column>
                                            <ext:Column ColumnID="IsGiftName" DataIndex="IsGiftName" Align="Left" Header="描述"
                                                Width="350">
                                            </ext:Column>
                                            <ext:CommandColumn Width="50" Header="编辑" Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                        <ToolTip Text="编辑" />
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
                                        <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" SingleSelect="true">
                                            <%--<Listeners>
                                                                <RowSelect Fn="selectedFactorRule" />
                                                            </Listeners>--%>
                                        </ext:RowSelectionModel>
                                    </SelectionModel>
                                    <Listeners>
                                        <Command Handler="if (command == 'Edit'){
                                                                                    Coolite.AjaxMethods.PromotionPolicyFactorSearch.Show(parent.instanceid(),record.data.PolicyFactorId,parent.policystyle(),parent.policystylesub(),parent.productlineid(),parent.subbu(),parent.pagetype(),parent.promotionstate(),{success:function(){RefreshDetailWindow2();},failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                                  } 
                                                                          if (command == 'Delete'){
                                                                                    Ext.Msg.confirm('警告', '是否要删除该因素?',function(e) { 
                                                                                    if (e == 'yes') {
                                                                                         Coolite.AjaxMethods.DeletePolicyFactor(record.data.PolicyFactorId,record.data.IsGift,record.data.IsPoint,{success: function(result) { 
                                                                                         if(result=='') {   #{GridFolicyFactor}.reload(); } else { Ext.Msg.alert('Error', result);} },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                        }
                                                                                     });
                                                                                  } " />
                                    </Listeners>
                                    <BottomBar>
                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="FolicyFactorStore"
                                            DisplayInfo="true" />
                                    </BottomBar>
                                    <SaveMask ShowMask="true" />
                                    <LoadMask ShowMask="true" />
                                </ext:GridPanel>
                            </ext:FitLayout>
                        </Body>
                    </ext:Panel>
                </Center>
            </ext:BorderLayout>
        </Body>
    </ext:ViewPort>
    <uc:PromotionPolicyFactorSearch ID="PromotionPolicyFactorSearch1" runat="server">
    </uc:PromotionPolicyFactorSearch>
    <uc:PromotionPolicyFactorRuleSearch ID="PromotionPolicyFactorRuleSearch1" runat="server">
    </uc:PromotionPolicyFactorRuleSearch>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
