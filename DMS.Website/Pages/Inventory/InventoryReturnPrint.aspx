<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InventoryReturnPrint.aspx.cs" Inherits="DMS.Website.Pages.Inventory.InventoryReturnPrint" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .list-item
        {
            font: normal 16px tahoma, arial, helvetica, sans-serif;
            padding: 1px 1px 1px 1px;
            border: 1px solid #fff;
            border-bottom: 1px solid #000000;
            white-space: normal;
            color: #000000;
        }
        .list-item h3
        {
            display: block;
            font: inherit;
            font-weight: normal;
            font-size: 16px;
            color: #000000;
        }
        .style1
        {
            width: 250px;
        }
        .style2
        {
            width: 250px;
        }
        .style3
        {
            width: 250px;
        }
        .gvRow
        {
            line-height: 20px;
            padding: 2px;
            height: 20px;
        }
        @media print
        {
            input
            {
                display: none;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <div>
        <p>
            &nbsp;</p>
        <p>
            &nbsp;</p>
        <p>
            &nbsp;</p>
        <table border="0" cellpadding="0" cellspacing="0" style="width: 750px">
            <tr>
                <td style="width: 50px;">
                    &nbsp;
                </td>
                <td>
                    <table border="1" cellpadding="0" cellspacing="0" style="height: 88px; width: 700px;
                        border-color: Black;">
                        <tr align="left" style="border-color: Black; border-style: inherit;">
                            <td class="style2">
                                <%=GetLocalResourceObject("form1.table.tr.td").ToString()%><asp:Label ID="tbDealer"
                                    runat="server"></asp:Label>
                            </td>
                            <td class="style3">
                                <%=GetLocalResourceObject("form1.table.tr.td1").ToString()%><asp:Label ID="tbReturnNumber"
                                    runat="server"></asp:Label>
                            </td>
                            <td class="style1">
                                <%=GetLocalResourceObject("form1.table.tr.td2").ToString()%><asp:Label ID="tbStatus"
                                    runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr align="left">
                            <td class="style2">
                                <%=GetLocalResourceObject("form1.table.tr.td3").ToString()%><asp:Label ID="tbProductLine"
                                    runat="server"></asp:Label>
                            </td>
                            <td class="style3">
                                <%=GetLocalResourceObject("form1.table.tr.td4").ToString()%><asp:Label ID="tbDate"
                                    runat="server"></asp:Label>
                            </td>
                            <td class="style1">
                                 退换货类型:<asp:Label ID="tbApplyType"
                                    runat="server"></asp:Label>
                            </td>
                        </tr>
                           <tr align="left">
                            <td class="style2">
                              退换货要求:<asp:Label ID="tbReosson"
                                    runat="server"></asp:Label>
                            </td>
                            <td class="style3">
                              退换货原因:<asp:Label ID="tbRetrunReason"
                                    runat="server"></asp:Label>
                            </td>
                            <td class="style1">
                                
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td style="width: 50px;">
                    &nbsp;
                </td>
                <td>
                    <table>
                        <asp:GridView ID="GridView1" runat="server" EmptyDataText="<%$ Resources: GridView1.EmptyDataText %>"
                            Width="700px" AutoGenerateColumns="false" OnRowCreated="result_RowCreated" BorderColor="Black"
                            BorderWidth="1px" CellPadding="1" CellSpacing="0">
                            <RowStyle BackColor="White" />
                            <Columns>
                                <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText %>">
                                    <ItemTemplate>
                                        <asp:Label ID="label1" runat="server" Text='<% #Eval("WarehouseName")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText='<%$ Resources: resource,Lable_Article_Number  %>'>
                                    <ItemTemplate>
                                        <asp:Label ID="label2" runat="server" Text='<% #Eval("CFN")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="产品规格">
                                    <ItemTemplate>
                                        <asp:Label ID="label7" runat="server" Text='<% #Eval("CFNEnglishName")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText1 %>">
                                    <ItemTemplate>
                                        <asp:Label ID="label3" runat="server" Text='<% #Eval("UPN")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText2 %>">
                                    <ItemTemplate>
                                        <asp:Label ID="label4" runat="server" Text='<% #Eval("LotNumber")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>                                
                                <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText3 %>">
                                    <ItemTemplate>
                                        <asp:Label ID="label5" runat="server" Text='<% #Eval("ExpiredDate")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText4 %>">
                                    <ItemTemplate>
                                        <asp:Label ID="label6" runat="server" Text='<% #Eval("UnitOfMeasure")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField> 
                                 <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText5 %>">
                                    <ItemTemplate>
                                        <asp:Label ID="label8" runat="server" Text='<% #Eval("AdjustQty")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>                                                         
                            </Columns>
                            <RowStyle CssClass="gvRow" />
                        </asp:GridView>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <table>
                        <tr>
                            <td style="width: 650px;" align="right">
                                <%--   <ext:Button ID="butPrint" Icon="PagePortrait" Text="<%$ Resources: form1.butPrint.Text %>"
                                    runat="server">
                                    <Listeners>
                                        <Click Handler="window.print();" />
                                    </Listeners>
                                </ext:Button>--%>
                                <asp:Button ID="btnPrint" Text="<%$ Resources:form1.butPrint.Text%>" Width="80px"
                                    runat="server" OnClientClick="window.print()" />
                            </td>
                            <td align="center">
                                <%-- <ext:Button ID="butCancle" Icon="Cancel" Text="<%$ Resources: form1.butCancle.Text %>"
                                    runat="server">
                                    <Listeners>
                                        <Click Handler="window.close();" />
                                    </Listeners>
                                </ext:Button>--%>
                                <asp:Button ID="btnCancle" Text="<%$ Resources: form1.butCancle.Text%>" Width="80px"
                                    runat="server" OnClientClick="window.close();" />
                                <asp:HiddenField ID="hfUOM" runat="server" Value="<%$ AppSettings: HiddenUOM  %>" />
                                <asp:HiddenField ID="hfUPN" runat="server" Value="<%$ AppSettings: HiddenUPN  %>" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>