<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ConsignmentCfnSetDialog.ascx.cs" Inherits="DMS.Website.Controls.ConsignmentCfnSetDialog" %>
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
    var addCfnSet = function(grid) {
        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
        var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
       
        var list = GetSelectedItemSet();
        // alert(list);
        //return;
        if (list.length > 0) {
            Ext.Msg.confirm('Message', '确定添加?',
                function(e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.ConsignmentCfnSetDialog.DoAddCfnSet(list,
                        {
                            success: function() {
                                if (rtnVal.getValue() == "Success") {
                                    Ext.getCmp('<%=this.CfnSetWindow.ClientID%>').hide();
                                    SetModified(true);
                                  
                                    DetailStoreLoad();
                                } else if (rtnVal.getValue() == "Warn") {
                                    Ext.Msg.alert('Warning', rtnMsg.getValue());
                                    SetModified(true);
                                } else {
                                    Ext.Msg.alert('Error', rtnMsg.getValue());
                                }
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                        );
                    } else {

                    }
                });
        } else {
            Ext.MessageBox.alert('Message', '请选择要添加的成套产品');
        }
    }

   var RenderCheckBoxSet = function(value) {
        return "<input type='checkbox' name='chkItemSet' value='" + value + "'>";
    }

//    var RenderTextBoxSet = function(value) {
//        return "<input type='text' name='txtItemSet' value='" + value + "' style='width:50px'>";
//    }

//    function CheckAllSet() {
//        var chklist = document.getElementsByName("chkItemSet");
//        var isChecked = document.getElementById("chkAllItemSet").checked;
//        //alert(chklist.length);
//        for (var i = 0; i < chklist.length; i++) {
//            chklist[i].checked = isChecked;
//            //alert(chklist[i].value);
//        }
//    }
    var RenderTextBoxSet = function(value) {
        return "<input type='text' name='txtItemSet' value='" + value + "' style='width:50px'>";
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

//    var template = '<span style="color:{0};">{1}</span>';
//    
//    var pctChange = function(value) {
//        return String.format(template, (value < 1) ? 'green' : 'red', value + '%');
//    }
</script>

<ext:Store ID="CfnSetStore" runat="server" OnRefreshData="CfnSetStore_RefershData"   AutoLoad="false" AutoDataBind="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="ChineseName" />
                <ext:RecordField Name="EnglishName" />
                <ext:RecordField Name="ProductLineBUMID" />
                <ext:RecordField Name="RequiredQty" DefaultValue="1" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="CfnSetDetailStore" runat="server"  AutoLoad="false" AutoDataBind="false" OnRefreshData="CfnSetDetailStore_RefershData">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="CfnId" />
                <ext:RecordField Name="Quantity" />
                <ext:RecordField Name="ChineseName" />
                <ext:RecordField Name="EnglishName" />
                <ext:RecordField Name="CustomerFaceNbr" />
                <ext:RecordField Name="Property1" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <BaseParams>
        <ext:Parameter Name="CfnSetId" Value="#{hidCfnSetId}.getValue()" Mode="Raw" />
    </BaseParams>
    <Listeners>
        <%--<LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);" />--%>
    </Listeners>
   
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

<ext:Hidden ID="hidRtnVal" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnMsg" runat="server">
</ext:Hidden>
<ext:Window ID="CfnSetWindow" runat="server" Icon="Group" Title="组套产品" Width="800" Height="500" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" Resizable="false" Header="false">
    <Body>
        <ext:Panel ID="Panel8" runat="server" Header="false" Frame="true" AutoHeight="true">
            <Body>
                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left">
                    <ext:Anchor>
                        <ext:GridPanel ID="GridPanel1" runat="server" StoreID="CfnSetStore" Title="组套产品列表" Height="200" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" AutoExpandColumn="EnglishName">
                            <ColumnModel ID="ColumnModel1" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="chkId" DataIndex="Id" Header="选择" Width="30" Sortable="false">
                                         <Renderer Fn="RenderCheckBoxSet" />
                                    </ext:Column>
                                  
                                    <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="产品中文名" Width="160px">
                                    </ext:Column>
                                    <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="产品英文名" Width="160px">
                                    </ext:Column>
                                    <ext:Column ColumnID="RequiredQty" DataIndex="RequiredQty" Header="订购数量" Width="80">
                                        <Renderer Fn="RenderTextBoxSet" />
                                    </ext:Column>
                                   
                                    <ext:CommandColumn Width="60" Header="明细" Align="Center">
                                        <Commands>
                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                <ToolTip Text="明细" />
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
                                <ext:Button ID="AddItemsButton" runat="server" Text="添加" Icon="Add">
                                    <Listeners>
                                        <Click Handler="addCfnSet(#{GridPanel1});" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </ext:Anchor>
                    <ext:Anchor>
                        <ext:GridPanel ID="GridPanel2" runat="server" StoreID="CfnSetDetailStore" Title="产品明细" Height="200" Border="false" Icon="Lorry" AutoWidth="true" StripeRows="true" AutoExpandColumn="EnglishName">
                            <ColumnModel ID="ColumnModel3" runat="server">
                                <Columns>
                                <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="产品型号" Width="150px">
                                    </ext:Column>
                                    <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="中文名" Width="150px">
                                    </ext:Column>
                                    <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="英文名">
                                    </ext:Column>
                                    <ext:Column ColumnID="Property1" DataIndex="Property1" Header="短编码" Width="80px" Align="Right">
                                      
                                    </ext:Column> 
                                    <ext:Column ColumnID="Quantity" DataIndex="Quantity" Header="默认数量" Width="80px" Align="Right">
                                      
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

