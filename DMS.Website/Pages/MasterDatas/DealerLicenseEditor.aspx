<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerLicenseEditor.aspx.cs" Inherits="DMS.Website.Pages.MasterDatas.DealerLicenseEditor" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>DealerContractEditor</title>
</head>
<body>

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript">
              
    </script>

    <ext:ViewPort ID="ViewPort1" runat="server">
        <Body>
            <body>
                <ext:ColumnLayout ID="ColumnLayout1" runat="server" Split="true" FitHeight="true">
                    <Columns>
                        <ext:LayoutColumn ColumnWidth="0.5">
                            <ext:Panel ID="WestPanel" runat="server" Title="当前CFDA证照信息" BodyStyle="padding: 5px;" Frame="true" AutoWidth="true">
                                <Body>
                                    <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="300">
                                        <ext:Anchor>
                                            <ext:TextField ID="CurLicenseNo" runat="server" FieldLabel="医疗器械经营许可证编号" Width="200" />
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:DateField ID="CurLicenseNoValidFrom" runat="server" Width="200" FieldLabel="医疗器械经营许可证起始日期" />
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:DateField ID="CurLicenseNoValidTo" runat="server" Width="200" FieldLabel="医疗器械经营许可证结束日期" />
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:TextField ID="CurFilingNo" runat="server" FieldLabel="医疗器械备案凭证号" Width="200" />
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:DateField ID="CurFilingNoValidFrom" runat="server" FieldLabel="医疗器械备案凭证起始日期" Width="200" />
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:DateField ID="CurFilingNoValidTo" runat="server" FieldLabel="医疗器械备案凭证结束日期" Width="200" />
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>
                        </ext:LayoutColumn>
                        <ext:LayoutColumn ColumnWidth="0.5">
                            <ext:Panel ID="EastPanel" runat="server" Title="修改的CFDA证照信息" BodyStyle="padding: 5px;" Frame="true" AutoWidth="true">
                                <Body>
                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="300">
                                        <ext:Anchor>
                                            <ext:TextField ID="TextField1" runat="server" FieldLabel="医疗器械经营许可证编号" Width="200" />
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:DateField ID="DateField1" runat="server" Width="200" FieldLabel="医疗器械经营许可证起始日期" />
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:DateField ID="DateField2" runat="server" Width="200" FieldLabel="医疗器械经营许可证结束日期" />
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:TextField ID="TextField2" runat="server" FieldLabel="医疗器械备案凭证号" Width="200" />
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:DateField ID="DateField3" runat="server" FieldLabel="医疗器械备案凭证起始日期" Width="200" />
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:DateField ID="DateField4" runat="server" FieldLabel="医疗器械备案凭证结束日期" Width="200" />
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Panel>
                        </ext:LayoutColumn>
                    </Columns>
                </ext:ColumnLayout>
            </body>
            <buttons>
               <ext:Button ID="btnSubmit" Text="提交" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                
               </ext:Button>
            </buttons>
        </Body>
    </ext:ViewPort>
    </form>
</body>
</html>
