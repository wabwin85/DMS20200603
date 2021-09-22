<%@ Page Language="C#" AutoEventWireup="true"  CodeBehind="FinanceApprove.aspx.cs" Inherits="DMS.Website.Pages.FinanceApprove" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
    <title></title>
    <link href="../resources/css/main.css" rel="stylesheet" type="text/css" />
    <script src="../resources/cooliteHelper.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />
    <ext:Panel runat="server">
        <Body>
            <ext:ContainerLayout ID="ContainerLayout1" runat="server">
                <ext:Panel ID="Panel1" runat="server" Title="一级经销商提交寄售销售，财务批注（批注后系统自动生成清指定批号订单）" AutoHeight="true" Frame="true"
                     ButtonAlign="Center" BodyStyle="padding: 10px;">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth="1">
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout runat="server">
                                             <ext:Anchor>
                                                <ext:Label ID="lbWarn" runat="server" FieldLabel="提示" Width="260" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextArea ID="txtRemark" runat="server" FieldLabel="批注"
                                                    Width="400" Height="200" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                        </ext:ColumnLayout>
                    </Body>
                    <Buttons>
                        <ext:Button ID="btnApprove" runat="server" Text="确认" OnClick="btnApprove_Click"
                            Icon="Disk" AutoPostBack="true">
                        </ext:Button>
                    </Buttons>
                </ext:Panel>
            </ext:ContainerLayout>
        </Body>
    </ext:Panel>
    </form>
        </body>
</html>