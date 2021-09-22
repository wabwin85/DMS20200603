<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HospitalSearchForComplainDialog.ascx.cs" Inherits="DMS.Website.Controls.HospitalSearchForComplainDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">
    //var employeeRecord;
   
    var openHospitalSearchDlg = function (isCrm, dealerId, animTrg) {
        var window = <%= hospitalSearchDlg.ClientID %>;
        
        if(dealerId=="" || dealerId==null)
        {
            alert("请选择经销商");
        }else{
            <%= this.hiddenIsCrm.ClientID %>.setValue(isCrm);
            <%= this.hiddenDealerId.ClientID %>.setValue(dealerId);
            <%= this.GridPanel1.ClientID %>.clear();
        
            window.show(animTrg);
        }
    }

    var cancelHospitalDialog =function() { 
        <%= this.hospitalSearchDlg.ClientID %>.hide(null);
    }
    
</script>

<ext:Store ID="Store1" runat="server" OnRefreshData="HospitalStore_RefreshData" AutoLoad="false"  >
    <AutoLoadParams>
        <ext:Parameter Name="start" Value="={0}" />
        <ext:Parameter Name="limit" Value="={15}" />
    </AutoLoadParams>
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="HosHospitalName" />
                <ext:RecordField Name="HosKeyAccount" />
                <ext:RecordField Name="HosProvince" />
                <ext:RecordField Name="HosCity" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <LoadException Handler="Ext.Msg.alert('Error', e )" />
    </Listeners>
</ext:Store>

<ext:Hidden ID="hiddenIsCrm" runat="server" ></ext:Hidden>
<ext:Hidden ID="hiddenDealerId" runat="server" ></ext:Hidden>

<ext:Window ID="hospitalSearchDlg" runat="server" Icon="Group" Title="医院选择" Closable="false"
    Draggable="false" Resizable="true" Width="800" Height="480" AutoShow="false" AutoScroll="true"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:ContainerLayout ID="ContainerLayout1" runat="server">
            <ext:Panel ID="plSearch" runat="server" Border="false" Frame="true" AutoHeight="true"
                ButtonAlign="Right">
                <Body>
                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                        <ext:LayoutColumn ColumnWidth="1">
                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                <Body>
                                    <ext:FormLayout ID="FormLayout1" runat="server">
                                        <ext:Anchor>
                                            <ext:TextField ID="txtHospital" runat="server" FieldLabel="医院名称/编号" Width="150">
                                            </ext:TextField>
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
                            <Click Handler="#{GridPanel1}.clear();#{PagingToolBar1}.changePage(1);" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button ID="btnOk" runat="server" Text="确认" Icon="Disk" IDMode="Legacy" >
                        <AjaxEvents>
                            <Click OnEvent="SubmitSelection" Success="cancelHospitalDialog();">
                                <ExtraParams>
                                    <ext:Parameter Name="Values" Value="Ext.encode(#{GridPanel1}.getRowsValues())" Mode="Raw" />
                                </ExtraParams>
                            </Click>
                        </AjaxEvents>
                    </ext:Button>
                    <ext:Button ID="btnCancel" runat="server" Text="返回" Icon="Cancel" IDMode="Legacy" >
                        <Listeners>
                            <Click Handler="cancelHospitalDialog();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Panel>
            <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Height="300">
                <Body>
                    <ext:FitLayout ID="FitLayout1" runat="server">
                        <ext:GridPanel ID="GridPanel1" runat="server" Title="医院列表" StoreID="Store1" 
                            EnableColumnMove="false"  AutoExpandColumn="HosHospitalName" AutoExpandMax="300" AutoExpandMin="100"
                            Border="false" Icon="Lorry" Header="false" StripeRows="true">
                            <ColumnModel ID="ColumnModel1" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="HosKeyAccount" DataIndex="HosKeyAccount" Header="医院编号" Width="200" >
                                    </ext:Column>
                                    <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="医院名称" >
                                    </ext:Column>
                                </Columns>
                            </ColumnModel>
                           <SelectionModel>
                                <ext:CheckboxSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" ></ext:CheckboxSelectionModel>
                            </SelectionModel>
                            <BottomBar>
                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1"
                                    DisplayInfo="true" EmptyMsg="No data to display" />
                            </BottomBar>
                            <LoadMask ShowMask="true" Msg="Loading..." />
                        </ext:GridPanel>
                    </ext:FitLayout>
                </Body>
            </ext:Panel>
        </ext:ContainerLayout>
    </Body>
</ext:Window>
