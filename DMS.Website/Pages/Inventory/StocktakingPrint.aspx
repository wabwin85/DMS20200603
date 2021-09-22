<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StocktakingPrint.aspx.cs" Inherits="DMS.Website.Pages.Inventory.StocktakingPrint" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <div>
        <p>&nbsp;</p>
        <p>&nbsp;</p>
        <p>&nbsp;</p>
        <table border="0" cellpadding="0" cellspacing="0" style="width: 750px" >
            <tr>
                <td style="width:50px;">&nbsp;</td>
                <td>
                    <table border="1" cellpadding="0" cellspacing="0" 
                        style=" height: 60px; width: 700px; border-color: Black;">
                        <tr align="left" style="border-color: Black; border-style:inherit;  ">
                            <td class="style2">
                                <%=GetLocalResourceObject("table.tr1.td1").ToString()%><asp:Label ID="tbDealer" runat="server"  ></asp:Label>
                            </td>
                            <td class="style3">
                                <%=GetLocalResourceObject("table.tr1.td2").ToString()%><asp:Label ID="tbWarehouse" runat="server" ></asp:Label>
                            </td>
                        </tr>
                        <tr align="left" style="border-color: Black; border-style:inherit;  ">
                            <td class="style2">
                                <%=GetLocalResourceObject("table.tr2.td1").ToString()%><asp:Label ID="tbStocktakingNo" runat="server" ></asp:Label>
                            </td>
                            <td class="style3">
                                <%=GetLocalResourceObject("table.tr2.td2").ToString()%><asp:Label ID="tbStocktakingDate" runat="server" ></asp:Label>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td style="width:50px;">&nbsp;</td>
                <td>
                    <table>
                        <asp:GridView ID="GridView1" runat="server" EmptyDataText="<%$ Resources: GridView1.EmptyDataText %>" Width="700px" 
                            AutoGenerateColumns="False" BorderColor="Black" BorderWidth="1px" CellPadding="1" 
                            CellSpacing="0" OnRowCreated="result_RowCreated"  >
                            <RowStyle BackColor="White" />
                            <Columns>
                                <asp:TemplateField HeaderText='<%$ Resources: resource,Lable_Article_Number  %>' >
                                    <ItemTemplate>
                                        <asp:Label ID="label1" runat="server" Text='<% #Eval("ArticleNumber")%>' ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources: GridView1.HeaderText %>" >
                                    <ItemTemplate>
                                        <asp:Label ID="label2" runat="server" Text='<% #Eval("LotNumber")%>' ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources: GridView1.HeaderText1 %>" >
                                    <ItemTemplate>
                                        <asp:Label ID="label3" runat="server" Text='<% #Eval("ExpiredDate")%>' ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources: GridView1.HeaderText2 %>" >
                                    <ItemTemplate>
                                        <asp:Label ID="label4" runat="server" Text='<% #Eval("SLT_LotQty")%>' ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources: GridView1.HeaderText3 %>" >
                                    <ItemTemplate>
                                        <asp:Label ID="label5" runat="server" Text='<% #Eval("SLT_CheckQty")%>' ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources: GridView1.HeaderText4 %>" >
                                    <ItemTemplate>
                                        <asp:Label ID="label6" runat="server" Text='<% #Eval("DifQty")%>' ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources: GridView1.HeaderText5 %>" >
                                    <ItemTemplate>
                                        <asp:Label ID="label7" runat="server" Text='' ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <RowStyle CssClass="gvRow" />
                        </asp:GridView>
                    </table>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td colspan="2">
                    <table>
                        <tr>
                            <td style="width:650px;" align="right">
                                <ext:Button ID="butPrint" Icon="PagePortrait" Text="<%$ Resources: butPrint.Text %>" runat="server">
                                    <Listeners>
                                        <Click Handler="window.print();" />
                                    </Listeners>
                                </ext:Button>
                            </td>
                            <td align="center">
                                <ext:Button ID="butCancle" Icon="Cancel" Text="<%$ Resources: butCancle.Text %>" runat="server">
                                    <Listeners>
                                        <Click Handler="window.close();" />
                                    </Listeners>
                                </ext:Button>
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
