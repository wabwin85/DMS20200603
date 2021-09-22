<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShipmentQRPrint.aspx.cs" Inherits="DMS.Website.Pages.Shipment.ShipmentQRPrint" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
    <style type="text/css">
        body
        {
            font-size: 12px;
            font-family: 'Helvetica Neue' , Helvetica, Arial, sans-serif;
            line-height: 20px;
            color: black;
            background-color: White;
        }
        td
        {
            padding-left: 5px;
            padding-top: 0px;
            vertical-align: top;
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
         .label{word-wrap:break-word;word-break:keep-all;overflow:hidden;}
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
    <div style="margin-left: 20px; margin-top: 20px;">
        <table style="margin-bottom: 10px; width: 350px; height: 170px; border-collapse: collapse; border: none;
            vertical-align: top;" cellspacing="0px">
            <tr>
                <td>
                    名称：<asp:Label ID="lbChineseName" runat="server" CssClass="label" ></asp:Label>
                    <br/>
                    <br/>
                    <br/>
                    <br/>
                    <br/>
                </td>
                <td rowspan="4">
                    <asp:Image ID="imageQr" runat="server" Width="150" Height="150" ImageAlign="Middle" />
                </td>
            </tr>
            <tr>
                <td>
                    规格：<asp:Label ID="lbEnglishName" runat="server" CssClass="label" ></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    批号：<asp:Label ID="lbLotNumber" runat="server" CssClass="label" ></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    序号：<asp:Label ID="lbSerialNumbe" runat="server" CssClass="label" ></asp:Label>
                </td>
            </tr>
        </table>
        <div style="margin-left: 20px; margin-top: 20px;">
            <div style="float: left;">
                    <asp:Button ID="btnPrint" Text="打印" Width="80px"
                        runat="server" OnClientClick="window.print()" />
            </div>
        </div>
    </div>
    </form>
</body>
</html>
