<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrderT2CfnSetDialog.ascx.cs" Inherits="DMS.Website.Controls.OrderT2CfnSetDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<style type="text/css">
    .x-form-empty-field {
        color: #bbbbbb;
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }

    .x-small-editor .x-form-field {
        font: normal 11px arial, tahoma, helvetica, sans-serif;
    }

    .x-small-editor .x-form-text {
        height: 20px;
        line-height: 16px;
        vertical-align: middle;
    }
</style>

<script language="javascript" type="text/javascript">

    //添加选中的产品
    var addCfnSet = function (grid) {
        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
        var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
        var list = GetSelectedItemSet();
        //alert(list);
        //return;
        if (list.length > 0) {
            Ext.Msg.confirm('Message', '<%=GetLocalResourceObject("addCfnSet.confirm.Body").ToString()%>',
                function (e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.OrderT2CfnSetDialog.DoAddCfnSet(list,
                            {
                                success: function () {
                                    if (rtnVal.getValue() == "Success") {
                                        Ext.getCmp('<%=this.CfnSetWindow.ClientID%>').hide();
                                        ReloadDetail();
                                    } else if (rtnVal.getValue() == "Warn") {
                                        Ext.Msg.alert('Warning', rtnMsg.getValue());
                                    } else {
                                        Ext.Msg.alert('Error', rtnMsg.getValue());
                                    }
                                },
                                failure: function (err) {
                                    Ext.Msg.alert('Error', err);
                                }
                            }
                        );
                    } else {

                    }
                });
        } else {
            Ext.MessageBox.alert('Message', '<%=GetLocalResourceObject("addCfnSet.alert.Body").ToString()%>');
        }
    }

    var RenderCheckBoxSet = function (value) {
        return "<input type='checkbox' name='chkItemSet' value='" + value + "'>";
    }

    var RenderTextBoxSet = function (value) {
        return "<input type='text' name='txtItemSet' value='" + value + "' style='width:50px'>";
    }

    function CheckAllSet() {
        var chklist = document.getElementsByName("chkItemSet");
        var isChecked = document.getElementById("chkAllItemSet").checked;
        //alert(chklist.length);
        for (var i = 0; i < chklist.length; i++) {
            chklist[i].checked = isChecked;
            //alert(chklist[i].value);
        }
    }

    function GetSelectedItemSet() {
        var list = "";
        var chklist = document.getElementsByName("chkItemSet");
        var txtlist = document.getElementsByName("txtItemSet");
        for (var i = 0; i < chklist.length; i++) {
            if (chklist[i].checked) {
                list += chklist[i].value + '|' + txtlist[i].value + ',';
            }
        }
        return list;
    }

    var template = '<span style="color:{0};">{1}</span>';

    var pctChange = function (value) {
        return String.format(template, (value < 1) ? 'green' : 'red', value + '%');
    }
</script>

<ext:Store ID="CfnSetStore" runat="server" OnRefreshData="CfnSetStore_RefershData" AutoLoad="false" AutoDataBind="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="UPN" />
                <ext:RecordField Name="ChineseName" />
                <ext:RecordField Name="EnglishName" />
                <ext:RecordField Name="ProductLineBumId" />
                <ext:RecordField Name="DiscountRate" />
                <ext:RecordField Name="IsCanOrder" />
                <ext:RecordField Name="ProductMsg" />
                <ext:RecordField Name="RequiredQty" DefaultValue="1" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="CfnSetDetailStore" runat="server" OnRefreshData="CfnSetDetailStore_RefershData" AutoLoad="false" AutoDataBind="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="UPN" />
                <ext:RecordField Name="DiscountRate" />
                <ext:RecordField Name="DiscountPrice" />
                <ext:RecordField Name="ChineseName" />
                <ext:RecordField Name="EnglishName" />
                <ext:RecordField Name="Price" />
                <ext:RecordField Name="DefaultQuantity" />
                <ext:RecordField Name="PackagePrice" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <BaseParams>
        <ext:Parameter Name="CfnSetId" Value="#{hidCfnSetId}.getValue()" Mode="Raw" />
    </BaseParams>
    <Listeners>
        <%--<LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />--%>
    </Listeners>
    <SortInfo Field="UPN" Direction="ASC" />
</ext:Store>
<ext:Hidden ID="hidHeaderId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidProductLine" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidDealerId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidCfnSetId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidOrderTypeId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPriceTypeId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnVal" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnMsg" runat="server">
</ext:Hidden>
<ext:Window ID="CfnSetWindow" runat="server" Icon="Group" Title="<%$ Resources: CfnSetWindow.Title %>" Width="800" Height="500" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" Resizable="false" Header="false">
    <Body>
        <ext:Panel ID="Panel8" runat="server" Header="false" Frame="true" AutoHeight="true">
            <Body>
                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left">
                    <ext:Anchor>
                        <ext:Panel runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:ColumnLayout runat="server" ID="ColumnLayout1">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout runat="server" ID="FormLayout4" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField runat="server" ID="txtProtectName" FieldLabel="成套产品名称" Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel runat="server" Border="false" Header="false">
                                            <Body>
                                                <ext:FormLayout runat="server" ID="FormLayout1" LabelAlign="Left" LabelWidth="80">
                                                    <ext:Anchor>
                                                        <ext:TextField runat="server" ID="txtUpn" FieldLabel="UPN" Width="150">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="Button1" runat="server" Text="查询"  Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:GridPanel ID="GridPanel1" runat="server" StoreID="CfnSetStore" Title="<%$ Resources: GridPanel1.Title %>" Height="200" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" AutoExpandColumn="EnglishName">
                            <ColumnModel ID="ColumnModel1" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="chkId" DataIndex="Id" Header="选择" Width="30" Sortable="false">
                                        <Renderer Fn="RenderCheckBoxSet" />
                                    </ext:Column>
                                    <ext:Column ColumnID="UPN" DataIndex="UPN" Header="UPN" Width="120px">
                                    </ext:Column>
                                    <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel1.ChineseName %>" Width="160px">
                                    </ext:Column>
                                    <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="<%$ Resources: GridPanel1.EnglishName %>" Width="160px">
                                    </ext:Column>
                                    <ext:Column ColumnID="RequiredQty" DataIndex="RequiredQty" Header="<%$ Resources: GridPanel1.RequiredQty %>" Width="80">
                                        <Renderer Fn="RenderTextBoxSet" />
                                    </ext:Column>
                                    <ext:Column ColumnID="DiscountRate" DataIndex="DiscountRate" Header="组套折扣" Width="100" Align="Center">
                                        <Renderer Fn="pctChange" />
                                    </ext:Column>
                                    <ext:CommandColumn Width="60" Header="<%$ Resources: GridPanel1.CommandColumn.Header %>" Align="Center">
                                        <Commands>
                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                <ToolTip Text="<%$ Resources: GridPanel1.CommandColumn.Header %>" />
                                            </ext:GridCommand>
                                        </Commands>
                                    </ext:CommandColumn>
                                </Columns>
                            </ColumnModel>
                            <BottomBar>
                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="CfnSetStore" DisplayInfo="false" />
                            </BottomBar>
                            <SelectionModel>
                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true">
                                </ext:RowSelectionModel>
                            </SelectionModel>
                            <Listeners>
                                <Command Handler="#{hidCfnSetId}.setValue(record.data.Id);#{PagingToolBar2}.changePage(1);" />
                            </Listeners>
                            <SaveMask ShowMask="true" />
                            <LoadMask ShowMask="true" />
                        </ext:GridPanel>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:Panel ID="BtnPanel" runat="server" Height="25">
                            <Body>
                            </Body>
                            <Buttons>
                                <ext:Button ID="AddItemsButton" runat="server" Text="<%$ Resources: AddItemsButton.Text %>" Icon="Add">
                                    <Listeners>
                                        <Click Handler="addCfnSet(#{GridPanel1});" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:GridPanel ID="GridPanel2" runat="server" StoreID="CfnSetDetailStore" Title="<%$ Resources: GridPanel2.Title %>" Height="200" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" AutoExpandColumn="EnglishName">
                            <ColumnModel ID="ColumnModel3" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="UPN" DataIndex="UPN" Header="<%$ Resources: resource,Lable_Article_Number  %>" Width="110px">
                                    </ext:Column>
                                    <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="<%$ Resources: GridPanel2.ChineseName %>" Width="150px">
                                    </ext:Column>
                                    <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="<%$ Resources: GridPanel2.EnglishName %>">
                                    </ext:Column>
                                    <ext:Column ColumnID="Price" DataIndex="Price" Header="<%$ Resources: GridPanel2.Price %>" Width="80px" Align="Right">
                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                    </ext:Column>
                                    <ext:Column ColumnID="DiscountRate" DataIndex="DiscountRate" Header="组套折扣" Width="90px" Align="Center">
                                        <Renderer Fn="pctChange" />
                                    </ext:Column>
                                    <ext:Column ColumnID="DiscountPrice" DataIndex="DiscountPrice" Header="折后单价" Width="80px" Align="Right">
                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                    </ext:Column>
                                    <ext:Column ColumnID="DefaultQuantity" DataIndex="DefaultQuantity" Header="<%$ Resources: GridPanel2.DefaultQuantity %>" Width="70px" Align="Center">
                                    </ext:Column>
                                    <ext:Column ColumnID="PackagePrice" DataIndex="PackagePrice" Header="组套后总价" Width="90px" Align="Right">
                                        <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                    </ext:Column>
                                </Columns>
                            </ColumnModel>
                            <BottomBar>
                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="50" StoreID="CfnSetDetailStore" DisplayInfo="true" />
                            </BottomBar>
                            <SaveMask ShowMask="true" />
                            <LoadMask ShowMask="true" />
                        </ext:GridPanel>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
        </ext:Panel>
    </Body>
    <Listeners>
        <Show Handler="#{GridPanel1}.reload();#{GridPanel2}.clear();" />
    </Listeners>
</ext:Window>
