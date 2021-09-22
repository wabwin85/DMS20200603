<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ELearningMain.aspx.cs"
    Inherits="DMS.Website.Pages.ELearning.ELearningMain" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
table.gridtable {
font-family: verdana,arial,sans-serif;
font-size:11px;
color:#333333;
border-width: 1px;
border-color: #666666;
border-collapse: collapse;
}
table.gridtable th {
border-width: 1px;
padding: 8px;
border-style: solid;
border-color: #666666;
background-color: #dedede;
text-align:center;
}
table.gridtable td {
border-width: 1px;
padding: 8px;
border-style: solid;
border-color: #666666;
background-color: #ffffff;
}
</style>
</head>
<body style="background-color: #DFE8F6;">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>
    <form id="form1" runat="server">
        <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshAttachment">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Name">
                    <Fields>
                        <ext:RecordField Name="Name" />
                        <ext:RecordField Name="Url" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <div style="height: 100%; width: 100%; background-color: #DFE8F6;">
            <div style="width: 100%; text-align: center; height: 100%; vertical-align: middle; min-height: 500px; line-height: 500px; }">
                <asp:Button runat="server" ID="btnTrainCompliance" Text="合规培训" Width="250" Height="60" Style="font-weight: bold;" OnClick="btnTrainCompliance_OnClick" />
                <asp:Button runat="server" ID="btnTrainQuality" Text="质量培训" Visible="False" Width="250" Height="60" Style="font-weight: bold;" OnClick="btnTrainQuality_OnClick" />
                <asp:Button runat="server" ID="btnSurvey" Text="问卷调查" Width="250" Height="60" Style="font-weight: bold;" OnClick="btnSurvey_OnClick" />
                
            </div>
             <div style="width: 100%; text-align: center;  vertical-align: middle;}">
                <table style="margin-left:auto;margin-right:auto;margin-top:-200px;text-align: center;" class="gridtable">
                    <tr>
                        <th>序号</th>
                        <th>名称</th>                        
                        <th>操作</th>
                    </tr>
                    <tr>
                        <td>01</td>
                        <td>波士顿科学渠道合作方行为守则</td>                        
                        <td><a target="_blank" class="iframeLink" href="../../Upload/ContractElectronicAttachmentTemplate/Read/AppointmentRenewal/92010492波士顿科学渠道合作方行为守则_RevC_(S) Chinese-已更新.pdf">阅读</a></td>
                    </tr>
                    <tr>
                        <td>02</td>
                        <td>波士顿科学全球反贿赂反腐败政策</td>                        
                        <td><a target="_blank" class="iframeLink" href="../../Upload/ContractElectronicAttachmentTemplate/Read/AppointmentRenewal/波士顿科学全球反贿赂反腐败政策_AF_CN-已更新.pdf">阅读</a></td>
                    </tr>
                    <tr>
                        <td>03</td>
                        <td>美国先进医疗技术协会《与中国医疗卫生专业人士互动交流的道德规范》</td>                        
                        <td><a target="_blank" class="iframeLink" href="../../Upload/ContractElectronicAttachmentTemplate/Read/AppointmentRenewal/美国先进医疗技术协会《与中国医疗卫生专业人士互动交流的道德规范》-已确认.pdf">阅读</a></td>
                    </tr>
                    <tr>
                        <td>04</td>
                        <td>蓝威经销商合规政策</td>                        
                        <td><a target="_blank" class="iframeLink" href="../../Upload/ContractElectronicAttachmentTemplate/Read/AppointmentRenewal/蓝威经销商合规政策.pdf">阅读</a></td>
                    </tr>
                    <tr>
                        <td>05</td>
                        <td>销商合规培训材料</td>                        
                        <td><a target="_blank" class="iframeLink" href="../../Upload/ContractElectronicAttachmentTemplate/Read/AppointmentRenewal/附件4-销商合规培训材料-更新.pdf">阅读</a></td>
                    </tr>
                </table>
            </div>
            <div style="height: 70%;">
                <ext:ViewPort ID="ViewPort1" runat="server" Visible="False">
                    <Body>
                        <ext:BorderLayout ID="BorderLayout1" runat="server">
                            <North Collapsible="True" Split="True">
                                <ext:Panel ID="plSearch" runat="server" Header="true" Frame="true" Icon="Find" Height="200">
                                    <Body>
                                        <div style="width: 100%; height: 6%;">
                                        </div>
                                        <div style="width: 100%; height: 40%; text-align: center;">
                                            <asp:ImageButton ID="IbtExam" runat="server" ImageUrl="~/resources/images/ElearningButton.png"
                                                OnClick="btnExam_OnClick" Visible="False" />
                                        </div>
                                        <div style="width: 100%; height: 12%; text-align: center; display: none;">
                                            <ext:Checkbox ID="cbCheck" runat="server" LabelSeparator="" LabelCls="" AutoPostBack="true"
                                                BoxLabel="- 我们保证所有与BSC业务有关的员工均参加了《蓝威经营准则之诚信致胜》合规培训课程，且承诺遵守并履行最高道德准则">
                                                <%-- <AjaxEvents>
                                            <Check OnEvent="cbCheck_OnEvent"></Check>
                                            </AjaxEvents>--%>
                                            </ext:Checkbox>
                                        </div>
                                        <div style="width: 100%; height: 42%; text-align: center;" visible="false">
                                            <asp:ImageButton ID="ImageUplodeFile" Enabled="false" runat="server" ImageUrl="~/resources/images/ElearningDownload.png"
                                                OnClick="btnUplodeFile_OnClick" Visible="false" />
                                        </div>
                                    </Body>
                                </ext:Panel>
                            </North>
                            <Center>
                                <ext:Panel runat="server" ID="ctl46" Visible="False" Border="false" Frame="true" Title="附件下载" Icon="HouseKey">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout1" runat="server">
                                            <ext:GridPanel ID="gpAttachment" runat="server" StoreID="AttachmentStore" Header="false"
                                                Border="true" Icon="Lorry" StripeRows="true" Height="400">
                                                <ColumnModel ID="ColumnModel8" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="Name" DataIndex="Name" Width="200" Header="附件名称">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="Url" DataIndex="Url" Width="200" Header="附件地址" Hidden="true">
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                                    <ToolTip Text="下载" />
                                                                </ext:GridCommand>
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel1" runat="server">
                                                    </ext:RowSelectionModel>
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="30" StoreID="AttachmentStore"
                                                        DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                </BottomBar>
                                                <Listeners>
                                                    <Command Handler=" if (command == 'DownLoad')
                                                                    {
                                                                        var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=ELearning';
                                                                        open(url, 'Download');
                                                                    }
                                                                    " />
                                                </Listeners>
                                                <LoadMask ShowMask="true" Msg="处理中..." />
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Panel>
                            </Center>
                        </ext:BorderLayout>
                    </Body>
                </ext:ViewPort>
            </div>
        </div>
    </form>
</body>
</html>
