<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShipmentPrint.aspx.cs"
    Inherits="DMS.Website.Pages.Shipment.ShipmentPrint" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%--    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />--%>
    <%--    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>--%>
    <style type="text/css">
        body
        {
            font-size: 10px;
            font-family: 'Helvetica Neue' , Helvetica, Arial, sans-serif;
            line-height: 22px;
            color: black;
            background-color: White;
        }
        td
        {
            padding-left: 5px;
            padding-top: 0px;
            vertical-align: top;
            border: solid 1px;
        }
        tr
        {
            text-align: left;
        }
        .headercss
        {
            padding-left: 3px;
            font-size: 11px;
            font-weight: bold;
            width: 55px;
        }
        .td1
        {
            width: 60px;
        }
        .td2
        {
            width: 65px;
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
    <div style="margin-left: 20px; margin-top: 20px;">
        <table style="margin-bottom: 20px; width: 650px; border-collapse: collapse; border: none;
            vertical-align: top;" cellspacing="0px">
            <tr>
                <td class="td1">
                    <%=GetLocalResourceObject("form1.table.tr.td").ToString()%>
                </td>
                <td>
                    <asp:Label ID="tbDealer" runat="server"></asp:Label>
                </td>
                <td style="width: 65px">
                    <%=GetLocalResourceObject("form1.table.tr.td1").ToString()%>
                </td>
                <td>
                    <asp:Label ID="tbOrderNumber" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <%=GetLocalResourceObject("form1.table.tr.td4").ToString()%>
                </td>
                <td>
                    <asp:Label ID="tbHospital" runat="server"></asp:Label>
                </td>
                <td style="width: 65px">
                    <%=GetLocalResourceObject("form1.table.tr.td3").ToString()%>
                </td>
                <td>
                    <asp:Label ID="tbDate" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <%=GetLocalResourceObject("form1.table.tr.tdDept").ToString()%>
                </td>
                <td>
                    <asp:Label ID="txtOffice" runat="server"></asp:Label>
                </td>
                <td>
                    <%=GetLocalResourceObject("form1.table.tr.tdInvoiceNo").ToString()%>
                </td>
                <td>
                    <asp:Label ID="txtInoviceNo" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                   <%=GetLocalResourceObject("form1.table.tr.manufacturer").ToString()%>
                </td>
                <td>
                   <%=GetLocalResourceObject("form1.table.tr.BSC").ToString()%>
                </td>
                <td>
                    <%=GetLocalResourceObject("form1.table.tr.tdInvoiceDate").ToString()%>
                </td>
                <td>
                    <asp:Label ID="txtInoviceDate" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td rowspan="2">
                    <%=GetLocalResourceObject("form1.table.tr.td6").ToString()%>
                </td>
                <td rowspan="2">
                    <asp:Label ID="tbMemo" runat="server"></asp:Label>
                </td>
                <td>
                    <%=GetLocalResourceObject("form1.table.tr.td7").ToString()%>
                </td>
                <td>
                    <asp:Label ID="tbTotalAmount" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <%=GetLocalResourceObject("form1.table.tr.td8").ToString()%>
                </td>
                <td>
                    <asp:Label ID="txtTotalQty" runat="server"></asp:Label>
                </td>
            </tr>
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
                Width="650" AutoGenerateColumns="False" OnRowCreated="result_RowCreated" BorderWidth="1px"
                HeaderStyle-Font-Bold="true" CellPadding="50" BorderColor="Black">
                <Columns>
                    <asp:TemplateField HeaderText="<%$ Resources:GridView1.Columns.RegName%>" HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="lblRPName" runat="server" Text='<% #Eval("RegistrationProductName")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText='<%$ Resources: resource,Lable_Article_Number  %>'
                        HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label2" runat="server" Text='<% #Eval("CFN")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="产品规格" HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label3" runat="server" Text='<% #Eval("CFNEnglishName")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText2 %>" HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label4" runat="server" Text='<% #Eval("LotNumber")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText3 %>" HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label5" runat="server" Text='<% #Eval("ExpiredDate")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText6 %>" HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label8" runat="server" Text='<% #Eval("ShipmentQty","{0:N2}")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText4 %>" HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label6" runat="server" Text='<% #Eval("UnitOfMeasure")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.HeaderText5 %>" HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label7" runat="server" Text='<% #Eval("UnitPrice","{0:N2}")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.RegsiterNo%>" HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label9" runat="server" Text='<% #Eval("RegistrationNbrCN")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources: GridView1.Columns.RegsiterNoEnglish%>"
                        HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label10" runat="server" Text='<% #Eval("RegistrationNbrEN")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources:GridView1.Columns.StartTime%>" HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label11" runat="server" Text='<% #Eval("OpeningDate","{0:yyyy-MM-dd}")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources:GridView1.Columns.ExpireTime%>" HeaderStyle-CssClass="headercss">
                        <ItemTemplate>
                            <asp:Label ID="label12" runat="server" Text='<% #Eval("ExpirationDate","{0:yyyy-MM-dd}")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </table>
        <div style="margin-left: 20px; margin-top: 20px;">
            <div>
             销售人员签字：<u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>
             &nbsp;&nbsp;&nbsp;&nbsp;客户收件人签字：<u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>
               </div>
            <div style="float: left;">
                <%--<ext:Button ID="butPrint" Icon="PagePortrait" Text="<%$ Resources: form1.butPrint.Text %>"
                    runat="server">
                    <Listeners>
                        <Click Handler="window.print();" />
                    </Listeners>
                </ext:Button>--%>
                <asp:Button ID="btnPrint" Text="<%$ Resources:form1.butPrint.Text%>" Width="80px"
                    runat="server" OnClientClick="window.print()" />
                <%--                
                    <input type=button name=button_print value="打印" 

onclick="window.print() "> --%>
            </div>
            <%--      <div>
                <asp:HiddenField ID="hfUOM" runat="server" Value="<%$ AppSettings: HiddenUOM  %>" />
                <asp:HiddenField ID="hfUPN" runat="server" Value="<%$ AppSettings: HiddenUPN  %>" />
            </div>--%>
        </div>
    </div>
    </form>
</body>
</html>
