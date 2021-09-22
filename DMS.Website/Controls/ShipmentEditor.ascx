<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ShipmentEditor.ascx.cs" Inherits="DMS.Website.Controls.ShipmentEditor" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<ext:Hidden ID="hiddenEditId" runat="server"></ext:Hidden>
<ext:Window ID="EditorWindow" runat="server" Icon="Group" Title="<%$ Resources: EditorWindow.Title %>" Width="350" Height="350" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" Resizable="false" Header="false">
    <Body>
        <ext:BorderLayout ID="BorderLayout1" runat="server">
            <Center MarginsSummary="0 0 0 0">
                <ext:Panel 
                    ID="Details" 
                    runat="server" 
                    Frame="true"
                    Header="false">
                    <Body>
                        <ext:FormLayout ID="FormLayout1" runat="server">
                            <ext:Anchor>
                                <ext:TextField 
                                    ID="txtWarehouseName" 
                                    runat="server" 
                                    FieldLabel="<%$ Resources: EditorWindow.txtWarehouseName.FieldLabel %>" 
                                    Width="150"
                                    ReadOnly="true" 
                                    Disabled="true"
                                    />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField 
                                    ID="txtCFN" 
                                    runat="server" 
                                    FieldLabel="<%$ Resources: EditorWindow.txtCFN.FieldLabel %>" 
                                    Width="150"
                                    ReadOnly="true" 
                                    Disabled="true"
                                    />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField 
                                    ID="txtUPN" 
                                    runat="server" 
                                    FieldLabel="<%$ Resources: EditorWindow.txtUPN.FieldLabel %>" 
                                    Width="150" 
                                    ReadOnly="true" 
                                    Disabled="true"
                                    />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField 
                                    ID="txtLotNumber" 
                                    runat="server" 
                                    FieldLabel="<%$ Resources: EditorWindow.txtLotNumber.FieldLabel %>" 
                                    Width="150" 
                                    ReadOnly="true" 
                                    Disabled="true"
                                    />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:DateField 
                                    ID="txtExpiredDate" 
                                    runat="server" 
                                    Width="150" 
                                    FieldLabel="<%$ Resources: EditorWindow.txtExpiredDate.FieldLabel %>" 
                                    Format="yyyy-M-d"
                                    ReadOnly="true" 
                                    Disabled="true" 
                                    />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField 
                                    ID="txtUnitOfMeasure" 
                                    runat="server" 
                                    FieldLabel="<%$ Resources: EditorWindow.txtUnitOfMeasure.FieldLabel %>" 
                                    Width="150" 
                                    ReadOnly="true" 
                                    Disabled="true"
                                    />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:TextField 
                                    ID="txtTotalQty" 
                                    runat="server" 
                                    FieldLabel="<%$ Resources: EditorWindow.txtTotalQty.FieldLabel %>" 
                                    Width="150" 
                                    ReadOnly="true" 
                                    Disabled="true"
                                    />
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:NumberField ID="txtShipmentQty" Width="150" runat="server" AllowBlank="false" AllowDecimals="false" AllowNegative="false" FieldLabel="<%$ Resources: EditorWindow.txtShipmentQty.FieldLabel %>">
                                </ext:NumberField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>                    
                </ext:Panel>                
            </Center>             
        </ext:BorderLayout>
    </Body>
    <Buttons>                 
        <ext:Button ID="SaveButton" runat="server" Text="<%$ Resources: SaveButton.Text %>" Icon="Disk">
            <Listeners>
                <Click Handler="Coolite.AjaxMethods.UCE.SaveItem();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="CancelButton" runat="server" Text="<%$ Resources: CancelButton.Text %>" Icon="Cancel">
            <Listeners>
                <Click Handler="#{EditorWindow}.hide(null);" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>