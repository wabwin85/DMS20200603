<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AuthorizationSelectorDialog.ascx.cs" Inherits="DMS.Website.Controls.AuthorizationSelectorDialog" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<script type="text/javascript">
    //var employeeRecord;
   
    var openAuthSelectorDlg = function (contractid, animTrg) {
        var window = <%= AuthSelectorDlg.ClientID %>;
       
        <%=hiddenSelectedId.ClientID %>.setValue(animTrg);
        <%=hiddenContractId.ClientID %>.setValue(contractid);
        <%= GridPanel1.ClientID %>.clear();
        <%= GridPanel1.ClientID %>.reload();
        window.show(null);
    }

   
</script>
<ext:Store ID="AuthorizationSelectorStore" runat="server" UseIdConfirmation="false" OnRefreshData="AuthorizationSelectorStore_RefershData">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="PmaId" />
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="DclId" />
                <ext:RecordField Name="DmaId" />
                <ext:RecordField Name="ProductLineBumId" />
                <ext:RecordField Name="AuthorizationType" />
                <ext:RecordField Name="HospitalListDesc" />
                <ext:RecordField Name="ProductDescription" />
                <ext:RecordField Name="PmaDesc" />
                <ext:RecordField Name="ProductLineDesc" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <LoadException Handler="Ext.Msg.alert('<%$ Resources: MSG.LoadException %>', e.message || e )" />
    </Listeners>
</ext:Store>
<ext:Window ID="AuthSelectorDlg" runat="server" Icon="Group" Title="<%$ Resources: AuthSelectorDlg.Title %>" Closable="true"
    Draggable="false" Resizable="true" Width="900" Height="480" AutoShow="false"
    Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
    <Body>
        <ext:ContainerLayout ID="ContainerLayout1" runat="server">
            <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true" Height="450" Header="false" IDMode="Legacy">
                <Body>
                    <ext:FitLayout ID="FitLayout1" runat="server">
                        <ext:GridPanel ID="GridPanel1" runat="server" Title="" AutoExpandColumn="ProductDescription"
                            Header="false" StoreID="AuthorizationSelectorStore" Border="false" Icon="Lorry" StripeRows="true">
                            <ColumnModel ID="ColumnModel1" runat="server">
                                <Columns>
                                    <ext:Column ColumnID="ProductLineDesc" DataIndex="ProductLineDesc" Header="<%$ Resources: GridPanel1.ProductLineBumId.Header %>"
                                        Width="150">
                                        <%--<Renderer Fn="renderLines" />--%>
                                    </ext:Column>
                                    <ext:Column ColumnID="PmaDesc" DataIndex="PmaDesc" Header="<%$ Resources: GridPanel1.PmaId.Header %>" Width="150">
                                        <%--<Renderer Fn="renderParts" />--%>
                                    </ext:Column>
                                    <ext:Column ColumnID="ProductDescription" DataIndex="ProductDescription" Header="<%$ Resources: GridPanel1.ProductDescription.Header %>">
                                    </ext:Column>
                                    <ext:Column ColumnID="HospitalListDesc" DataIndex="HospitalListDesc" Header="<%$ Resources: GridPanel1.HospitalListDesc.Header %>"
                                        Width="250">
                                    </ext:Column>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:CheckboxSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true">
                                    <Listeners>
                                        <RowSelect Handler="#{btnCopy}.enable();" />
                                    </Listeners>
                                </ext:CheckboxSelectionModel>
                            </SelectionModel>
                            <BottomBar>
                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="AuthorizationSelectorStore" 
                                    DisplayInfo="true" EmptyMsg="No data to display" />
                            </BottomBar>
                            <LoadMask ShowMask="true" Msg="<%$ Resources: MSG.LoadMask %>" />
                        </ext:GridPanel>
                    </ext:FitLayout>
                </Body>
                <Buttons>
                    <ext:Button ID="btnCopy" runat="server" Text="<%$ Resources: btnCopy.Text %>" Icon="Add" CommandArgument=""
                        CommandName="" IDMode="Legacy" OnClientClick="" Enabled="false">
                        <AjaxEvents>
                            <Click OnEvent="SubmitSelection" Success="#{AuthSelectorDlg}.hide(null);" >
                                <ExtraParams>
                                    <ext:Parameter Name="SelectValues" Value="Ext.encode(#{GridPanel1}.getRowsValues())" Mode="Raw" />
                                </ExtraParams>
                            </Click>
                        </AjaxEvents>
                    </ext:Button>
                    <ext:Button ID="btnCancel" runat="server" Text="<%$ Resources: btnCancel.Text %>" Icon="Cancel" CommandArgument=""
                        CommandName="" IDMode="Legacy" OnClientClick="" Disabled="True">
                        <Listeners>
                            <Click Handler="#{AuthSelectorDlg}.hide(null);" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Panel>
        </ext:ContainerLayout>
    </Body>
    
</ext:Window>
<ext:Hidden ID="hiddenSelectedId" runat="server" />
<ext:Hidden ID="hiddenContractId" runat="server" />