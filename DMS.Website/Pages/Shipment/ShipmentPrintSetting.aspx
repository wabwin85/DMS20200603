<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShipmentPrintSetting.aspx.cs"
    Inherits="DMS.Website.Pages.Shipment.ShipmentPrintSetting" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server" />

    <script language="javascript">


        var MsgList = {
            btnSave: {
                SuccessTitle: "Message",
                SuccessMsg: "<%=GetLocalResourceObject("Function.MsgList.alert.Message").ToString()%>"
            }
        }
        
     

     
    </script>

    <ext:Hidden ID="hidIsNew" runat="server">
    </ext:Hidden>
    <ext:Hidden ID="hidInstanceId" runat="server">
    </ext:Hidden>
    <ext:Panel ID="Panel3" runat="server" Border="false" Frame="true" Title="<%$ Resources:ShipmentPrintSetting%>"
        Width="300">
        <Body>
            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="60">
                <%--         <ext:Anchor>
                    <ext:Checkbox ID="cbWarehouse" runat="server" BoxLabel="<%$ Resources:cbWarehouse%>" HideLabel="true">
                    </ext:Checkbox>
                </ext:Anchor>--%>
                <ext:Anchor>
                    <ext:Checkbox ID="cbCertificateName" runat="server" BoxLabel="<%$ Resources:cbCertificateName%>"
                        HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbEnglishName" runat="server" BoxLabel="产品规格"
                        HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbProductType" runat="server" BoxLabel="<%$ Resources:cbProductType%>"
                        HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbLot" runat="server" BoxLabel="<%$ Resources:cbLot%>" HideLabel="true"
                        Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbExpiryDate" runat="server" BoxLabel="<%$ Resources:cbExpiryDate%>"
                        HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <%--          <ext:Anchor>
                    <ext:Checkbox ID="cbInventoryQty" runat="server" BoxLabel="库存量" HideLabel="true"
                        Width="200">
                    </ext:Checkbox>
                </ext:Anchor>--%>
                <ext:Anchor>
                    <ext:Checkbox ID="cbShipmentQty" runat="server" BoxLabel="<%$ Resources:cbShipmentQty%>"
                        HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbUnit" runat="server" BoxLabel="单位" HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbUnitPrice" runat="server" BoxLabel="<%$ Resources:cbUnitPrice%>"
                        HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbCertificateNo" runat="server" BoxLabel="<%$ Resources:cbCertificateNo%>"
                        HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbcbCertificateENNo" runat="server" BoxLabel="<%$ Resources:cbcbCertificateENNo%>"
                        HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbStartDate" runat="server" BoxLabel="<%$ Resources:cbStartDate%>"
                        HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <ext:Anchor>
                    <ext:Checkbox ID="cbExpireDate" runat="server" BoxLabel="<%$ Resources:cbExpireDate%>"
                        HideLabel="true" Width="200">
                    </ext:Checkbox>
                </ext:Anchor>
                <%--                <ext:Anchor>
                    <ext:Checkbox ID="cbCertificateType" runat="server" BoxLabel="注册证型号" HideLabel="true"
                        Width="200">
                    </ext:Checkbox>
                </ext:Anchor>--%>
                <%--<ext:Anchor>
                    <ext:Checkbox ID="cbChooseAll" runat="server" BoxLabel="全选" HideLabel="true" Width="200"
                        OnCheckedChanged="cbChooseAll_OnClick">
                    </ext:Checkbox>
                </ext:Anchor>--%>
            </ext:FormLayout>
        </Body>
        <%--  <Buttons>
            <ext:Button ID="Button1" Text="全选" runat="server" Icon="Disk">
                <AjaxEvents>
                    <Click OnEvent="btnChoseAll_OnClick" />
                </AjaxEvents>
            </ext:Button>
        </Buttons>--%>
        <Buttons>
            <ext:Button ID="btnSave" Text="<%$ Resources: btnSave.Text %>" runat="server" Icon="Disk">
                <AjaxEvents>
                    <Click OnEvent="btnSave_OnClick" Success="Ext.Msg.alert(MsgList.btnSave.SuccessTitle,MsgList.btnSave.SuccessMsg);" />
                </AjaxEvents>
            </ext:Button>
        </Buttons>
    </ext:Panel>
    </form>
</body>
</html>
