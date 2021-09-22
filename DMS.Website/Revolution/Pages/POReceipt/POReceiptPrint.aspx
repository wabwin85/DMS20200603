<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="POReceiptPrint.aspx.cs"
    Inherits="DMS.Website.Revolution.Pages.POReceipt.POReceiptPrint" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%--    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />--%>
    <%--    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>--%>
    <style type="text/css">
        body {
            font-size: 10px;
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
            line-height: 22px;
            background-color: White;
        }

        td {
            padding-left: 5px;
            padding-top: 0px;
            vertical-align: top;
            border: solid 1px;
        }

        tr {
            text-align: left;
        }

        .headercss {
            padding-left: 5px;
            font-size: 11px;
            font-weight: bold;
        }

        .td1 {
            width: 80px;
        }

        .td2 {
            width: 55px;
        }

        @media print {
            input {
                display: none;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        <div style="margin-top: 50px; margin-right: 50px; margin-left: 50px;">
            <table style="margin-bottom: 20px; border-collapse: collapse; border: none; vertical-align: top; border-color: White;"
                width="700px" cellspacing="0px" cellpadding="0px">
                <tr>
                    <td align="center" style="font-size: large">入库单
                    </td>
                </tr>
            </table>
            <table style="margin-bottom: 20px; border-collapse: collapse; border: none; vertical-align: top; border-color: Black;"
                width="700px" cellspacing="0px">
                <tr>
                    <td class="td1">
                        <%=GetLocalResourceObject("form1.table.tr.tbDealer").ToString()%>
                    </td>
                    <td>
                        <asp:Label ID="lbDealer" runat="server"></asp:Label>
                    </td>
                    <td>
                        <%=GetLocalResourceObject("form1.table.tr.tbDate").ToString()%>
                    </td>
                    <td>
                        <asp:Label ID="lbDate" runat="server"></asp:Label>
                    </td>
                    <td style="width: 65px">
                        <%=GetLocalResourceObject("form1.table.tr.tbPONumber").ToString()%>
                    </td>
                    <td>
                        <asp:Label ID="lbPONumber" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=GetLocalResourceObject("form1.table.tr.tbVendor").ToString()%>
                    </td>
                    <td>
                        <asp:Label ID="lbVendor" runat="server"></asp:Label>
                    </td>
                    <td>
                        <%=GetLocalResourceObject("form1.table.tr.tbCarrier").ToString()%>
                    </td>
                    <td>
                        <asp:Label ID="lbCarrier" runat="server"></asp:Label>
                    </td>
                    <td>
                        <%=GetLocalResourceObject("form1.table.tr.tbSapNumber").ToString()%>
                    </td>
                    <td>
                        <asp:Label ID="lbSapNumber" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=GetLocalResourceObject("form1.table.tr.tbTrackingNo").ToString()%>
                    </td>
                    <td>
                        <asp:Label ID="lbTrackingNo" runat="server"></asp:Label>
                    </td>
                    <td>
                        <%=GetLocalResourceObject("form1.table.tr.tbShipType").ToString()%>
                    </td>
                    <td>
                        <asp:Label ID="lbShipType" runat="server"></asp:Label>
                    </td>
                    <td>
                        <%=GetLocalResourceObject("form1.table.tr.txtTotalQty").ToString()%>
                    </td>
                    <td>
                        <asp:Label ID="lbTotalQty" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%=GetLocalResourceObject("form1.table.tr.tbWarehouse").ToString()%>
                    </td>
                    <td colspan="3">
                        <asp:Label ID="lbWarehouse" runat="server"></asp:Label>
                    </td>
                    <td>生产厂商：
                    </td>
                    <td>
                        <asp:Label ID="Label1" runat="server">蓝威公司</asp:Label>
                    </td>

                </tr>
                <%-- <tr>
                <td>
                    <%=GetLocalResourceObject("form1.table.tr.tbTotalAmount").ToString()%>
                </td>
                <td>
                    <asp:Label ID="lbTotalAmount" runat="server"></asp:Label>
                </td>
            </tr>--%>
                <%--       <tr>
                <td>
                    <%=GetLocalResourceObject("form1.table.tr.td5").ToString()%>
                </td>
                <td>
                    <asp:Label ID="tbStatus" runat="server"></asp:Label>
                </td>
            </tr>--%>
            </table>
            <table>
                <asp:GridView ID="GridView1" runat="server" EmptyDataText="<%$ Resources: GridView1.EmptyDataText %>"
                    Width="700px" AutoGenerateColumns="False" OnRowCreated="result_RowCreated" BorderWidth="1px"
                    HeaderStyle-Font-Bold="true" CellPadding="50" BorderColor="Black">
                    <Columns>
                        <asp:TemplateField HeaderText="<%$ Resources:GridView1.Columns.CFNName%>" HeaderStyle-CssClass="headercss">
                            <ItemTemplate>
                                <asp:Label ID="lblRPName" runat="server" Text='<% #Eval("CFN")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="<%$ Resources:GridView1.Columns.CFNChineseName%>"
                            HeaderStyle-CssClass="headercss">
                            <ItemTemplate>
                                <asp:Label ID="lblCFNChineseName" runat="server" Text='<% #Eval("CFNChineseName")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="产品规格"
                            HeaderStyle-CssClass="headercss">
                            <ItemTemplate>
                                <asp:Label ID="lblCFNEnglishName" runat="server" Width="100" Text='<% #Eval("CFNEnglishName")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="产品注册证号"
                            HeaderStyle-CssClass="headercss">
                            <ItemTemplate>
                                <asp:Label ID="lblCFNRegName" runat="server" Text='<% #Eval("RegName")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%--  <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText %>" HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label1" runat="server" Text='<% #Eval("WarehouseName")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="产品批号" HeaderStyle-CssClass="headercss">
                            <ItemTemplate>
                                <asp:Label ID="label4" runat="server" Width="70" Text='<% #Eval("LotNumber")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText3 %>" HeaderStyle-CssClass="headercss">
                            <ItemTemplate>
                                <asp:Label ID="label5" runat="server" Width="50" Text='<% #Eval("ExpiredDate")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText6 %>" HeaderStyle-CssClass="headercss">
                            <ItemTemplate>
                                <asp:Label ID="label8" runat="server" Width="30" Text='<% #Eval("ReceiptQty", "{0:N0}")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText4 %>" HeaderStyle-CssClass="headercss">
                            <ItemTemplate>
                                <asp:Label ID="label6" runat="server" Width="30" Text='<% #Eval("UnitOfMeasure")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%--<asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText5 %>" HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label7" runat="server" Text='<% #Eval("UnitPrice","{0:N2}")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>--%>
                    </Columns>
                </asp:GridView>
            </table>
        </div>
        <div style="width: 700px; margin-top: 10px; margin-left: 50px;">
            制单人：<u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>
            &nbsp;&nbsp;&nbsp;&nbsp;验收：<u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>
            &nbsp;&nbsp;&nbsp;&nbsp;负责人：<u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>
        </div>
        <div style="width: 700px; margin-top: 10px; margin-left: 50px;">
            <asp:Button ID="btnPrint" Text="<%$ Resources:form1.butPrint.Text%>" Width="80px"
                runat="server" OnClientClick="window.print()" />
            <asp:HiddenField ID="hfUOM" runat="server" Value="<%$ AppSettings: HiddenUOM  %>" />
            <asp:HiddenField ID="hfUPN" runat="server" Value="<%$ AppSettings: HiddenUPN  %>" />
        </div>
    </form>
</body>
</html>
