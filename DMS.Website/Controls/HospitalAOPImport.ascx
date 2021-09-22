<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HospitalAOPImport.ascx.cs"
    Inherits="DMS.Website.Controls.HospitalAOPImport" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
<ext:Hidden ID="hidContractId" runat="server">
</ext:Hidden>

<script type="text/javascript" language="javascript">
  
    function closeUploadWindow() {
        Ext.getCmp('<%=this.HospitalAopUploadWindow.ClientID%>').hide(null)
    }
    
    function closeAndReloadUploadWindow() {
        RefreshAOPWindow();
        Ext.getCmp('<%=this.HospitalAopUploadWindow.ClientID%>').hide(null)
    }
   
</script>

<ext:Window ID="HospitalAopUploadWindow" runat="server" Icon="Group" Title="医院指标导入"
    Hidden="true" Resizable="false" Header="false" Width="600" Height="500" AutoShow="false"
    BodyBorder="false" Modal="true" ShowOnLoad="false">
    <Body>
        <ext:FitLayout ID="FitLayout1" runat="server">
            <ext:TabPanel ID="TabPanelDeatil" runat="server" ActiveTabIndex="0" Plain="true">
                <Tabs>
                    <ext:Tab ID="tabForm1" runat="server" Title="上传医院指标" AutoShow="true" BodyBorder="false">
                        <AutoLoad Mode="IFrame" MaskMsg="正在加载中..." ShowMask="true" Scripts="true" />
                    </ext:Tab>
                </Tabs>
            </ext:TabPanel>
        </ext:FitLayout>
    </Body>
</ext:Window>
