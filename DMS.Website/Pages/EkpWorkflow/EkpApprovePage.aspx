<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EkpApprovePage.aspx.cs" Inherits="DMS.Website.Pages.EKPWorkflow.EkpApprovePage" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
    <title>DMS</title>
    <style type="text/css" >
        .FormBtn {
            height: 30px;
            width: 80px;
            text-align: center;
            color: white;
            background-color: #1f4e81;
            float: left;
            line-height: 30px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            margin: 0 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style=" text-align:center;font-size:15px;font-family:Tahoma;height:70px;width:100%;padding-top:30px;">
        <asp:Label ID="lbRemark" runat="server"></asp:Label>
    </div>
    <div style="width: 100%; text-align: center;">
        <div style="overflow: hidden; display: inline-block">
            <div class="FormBtn" id="btnSubmit0" style="display: block;" onclick="window.open('','_self');window.close();window.history.back();return false;">关闭当前窗口</div>
        </div>
    </div>
    </form>
</body>
</html>
