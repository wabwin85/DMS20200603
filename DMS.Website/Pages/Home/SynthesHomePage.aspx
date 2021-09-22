<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SynthesHomePage.aspx.cs"
    Inherits="DMS.Website.Pages.Home.SynthesHomePage" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script type="text/javascript">
        var MsgList = {
            BulletinSearchTabName: "<%=GetLocalResourceObject("Panel4.Tool.Search.Handler").ToString()%>",
            IssuesListTabName: "<%=GetLocalResourceObject("Panel5.Tool.Search.Handler").ToString()%>",
            btnBulletinConfirm: {
                alertTitle: "<%=GetLocalResourceObject("BulletinDetailWindow.btnBulletinConfirm.Alert.Title").ToString()%>",
                alertMsg: "<%=GetLocalResourceObject("BulletinDetailWindow.btnBulletinConfirm.Alert.Body").ToString()%>"
            },
            DealerQAListTabName: "经销商问答"
        }

        function refreshTree(tree) {
            Coolite.AjaxMethods.RefreshTree({
                success: function (result) {
                    var nodes = eval(result);
                    tree.root.ui.remove();
                    tree.initChildren(nodes);
                    tree.root.render();
                }
            });
        }


    </script>

</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        <ext:Store ID="BulletinStore" runat="server" AutoLoad="true" OnRefreshData="BulletinStore_RefreshData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Title" />
                        <ext:RecordField Name="Body" />
                        <ext:RecordField Name="UrgentDegree" />
                        <ext:RecordField Name="ReadFlag" />
                        <ext:RecordField Name="Status" />
                        <ext:RecordField Name="ExpirationDate" />
                        <ext:RecordField Name="PublishedUser" />
                        <ext:RecordField Name="IdentityName" />
                        <ext:RecordField Name="PublishedDate" />
                        <ext:RecordField Name="CreateUser" />
                        <ext:RecordField Name="CreateDate" />
                        <ext:RecordField Name="UpdateUser" />
                        <ext:RecordField Name="UpdateDate" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="BulletinImportantStore" runat="server" UseIdConfirmation="true" AutoLoad="true"
            OnRefreshData="Store_RefreshDictionary">
            <BaseParams>
                <ext:Parameter Name="Type" Value="CONST_Bulletin_Important" Mode="Value">
                </ext:Parameter>
            </BaseParams>
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Key">
                    <Fields>
                        <ext:RecordField Name="Key" />
                        <ext:RecordField Name="Value" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Key" Direction="DESC" />
        </ext:Store>
        <ext:Store ID="IssueListStore" runat="server" AutoLoad="true" OnRefreshData="IssueListStore_RefreshData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Question" />
                        <ext:RecordField Name="Answer" />
                        <ext:RecordField Name="SortNo" />
                        <ext:RecordField Name="DeleteFlag" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" AutoLoad="false"
            OnRefreshData="AttachmentStore_Refresh">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Attachment" />
                        <ext:RecordField Name="Name" />
                        <ext:RecordField Name="Url" />
                        <ext:RecordField Name="Type" />
                        <ext:RecordField Name="UploadUser" />
                        <ext:RecordField Name="Identity_Name" />
                        <ext:RecordField Name="UploadDate" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="IssueAttachmentStore" runat="server" UseIdConfirmation="false" AutoLoad="false"
            OnRefreshData="IssueAttachmentStore_Refresh">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="Attachment" />
                        <ext:RecordField Name="Name" />
                        <ext:RecordField Name="Url" />
                        <ext:RecordField Name="Type" />
                        <ext:RecordField Name="UploadUser" />
                        <ext:RecordField Name="Identity_Name" />
                        <ext:RecordField Name="UploadDate" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <West MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel3" runat="server" Title="<%$ Resources:Panel3.Title %>" Frame="true"
                            Icon="Bell" Width="225">
                            <Body>
                                <ext:Accordion ID="AccordionLayout1" runat="server">
                                    <ext:TreePanel ID="TreePanel1" runat="server" Title="<%$ Resources:Panel3.TreePanel1.Title %>"
                                        RootVisible="false" Header="true">
                                        <Tools>
                                            <ext:Tool Type="Refresh" Handler="refreshTree(#{TreePanel1});" />
                                        </Tools>
                                    </ext:TreePanel>
                                </ext:Accordion>
                            </Body>
                        </ext:Panel>
                    </West>
                    <Center MarginsSummary="5 5 5 5">
                        <ext:Panel ID="Panel2" runat="server" Title="" Frame="true" Header="false" Icon="Information">
                            <Body>
                                <ext:BorderLayout ID="BorderLayout2" runat="server">
                                    <North MarginsSummary="0 0 0 0">
                                        <ext:Panel ID="Panel4" runat="server" Title="<%$ Resources: Panel4.Title %>" Icon="Information"
                                            Collapsible="true" Height="260">
                                            <Tools>
                                                <ext:Tool Type="Refresh" Handler="#{GridPanelBulletin}.reload();" />
                                                <%--<ext:Tool Type="Search" Qtip="<%$ Resources: Panel4.Tool.Search.Qtip %>" Handler="window.parent.loadExample('/Pages/DCM/BulletinManage.aspx','subMenu178',MsgList.BulletinSearchTabName);" />--%>

                                                <ext:Tool Type="Search" Qtip="<%$ Resources: Panel4.Tool.Search.Qtip %>" Handler="top.createTab({id: 'subMenu178',title: '导入',url: 'Pages/DCM/BulletinManage.aspx'});" />

                                            </Tools>
                                            <Body>
                                                <ext:FitLayout ID="FitLayout1" runat="server">
                                                    <ext:GridPanel ID="GridPanelBulletin" runat="server" StoreID="BulletinStore" Border="false"
                                                        AutoWidth="true" StripeRows="true" Header="false">
                                                        <ColumnModel ID="ColumnModel1" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Title" DataIndex="Title" Header="<%$ Resources: Panel4.GridPanelBulletin.Title.Header %>"
                                                                    Width="300">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="IdentityName" DataIndex="IdentityName" Header="<%$ Resources: Panel4.GridPanelBulletin.IdentityName.Header %>"
                                                                    Width="100">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="PublishedDate" DataIndex="PublishedDate" Header="<%$ Resources: Panel4.GridPanelBulletin.PublishedDate.Header %>"
                                                                    Width="100">
                                                                </ext:Column>
                                                                <%-- <ext:Column ColumnID="ExpirationDate" DataIndex="ExpirationDate" Header="信息有效期">
                                                            </ext:Column>--%>
                                                                <%--<ext:Column ColumnID="UrgentDegree" DataIndex="UrgentDegree" Header="紧急程度">
                                                                <Renderer Handler="return getNameFromStoreById(BulletinImportantStore,{Key:'Key',Value:'Value'},value);" />
                                                            </ext:Column>--%>
                                                                <ext:CheckColumn ColumnID="ReadFlag" DataIndex="ReadFlag" Header="<%$ Resources: Panel4.GridPanelBulletin.ReadFlag.Header %>">
                                                                </ext:CheckColumn>
                                                                <ext:CommandColumn Width="60" Header="<%$ Resources: Panel4.GridPanelBulletin.CommandColumn.Header %>"
                                                                    Align="Center">
                                                                    <Commands>
                                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                                            <ToolTip Text="<%$ Resources: Panel4.GridPanelBulletin.ToolTip.Text %>" />
                                                                        </ext:GridCommand>
                                                                    </Commands>
                                                                </ext:CommandColumn>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server">
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <Listeners>
                                                            <Command Handler="Coolite.AjaxMethods.BulletinDetailShow(record.data.Id,{success:function(){#{BulletinDetailWindow}.show();#{PagingToolBar3}.changePage(1);}});" />
                                                        </Listeners>
                                                        <LoadMask ShowMask="true" Msg="<%$ Resources: Panel4.GridPanelBulletin.LoadMask.Msg %>" />
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                        </ext:Panel>
                                    </North>
                                    <Center MarginsSummary="0 0 0 0">
                                        <ext:Panel ID="Panel5" runat="server" Title="<%$ Resources: Panel5.Title %>" Icon="Information"
                                            Collapsible="true" Height="260">
                                            <Tools>
                                                <ext:Tool Type="Refresh" Handler="#{GridPanelIssueList}.reload();" />
                                                <%--<ext:Tool Type="Search" Qtip="<%$ Resources: Panel5.Tool.Search.Qtip %>" Handler="window.parent.loadExample('/Pages/DCM/IssuesList.aspx','subMenu181',MsgList.IssuesListTabName);" />--%>
                                                <ext:Tool Type="Search" Qtip="<%$ Resources: Panel5.Tool.Search.Qtip %>" Handler="top.createTab({id: 'subMenu181',title: '导入',url: 'Pages/DCM/IssuesList.aspx'});" />
                                            </Tools>
                                            <Body>
                                                <ext:FitLayout ID="FitLayout2" runat="server">
                                                    <ext:GridPanel ID="GridPanelIssueList" runat="server" StoreID="IssueListStore" Border="false"
                                                        StripeRows="true" Header="false">
                                                        <ColumnModel ID="ColumnModel2" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="SortNo" DataIndex="SortNo" Header="<%$ Resources: Panel5.GridPanelIssueList.SortNo.Header %>"
                                                                    Width="40" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Question" DataIndex="Question" Header="<%$ Resources: Panel5.GridPanelIssueList.Question.Header %>"
                                                                    Width="200">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Answer" DataIndex="Answer" Header="<%$ Resources: Panel5.GridPanelIssueList.Answer.Header %>"
                                                                    Width="300">
                                                                </ext:Column>
                                                                <ext:CommandColumn Width="60" Header="<%$ Resources: Panel5.GridPanelIssueList.CommandColumn.Header %>"
                                                                    Align="Center">
                                                                    <Commands>
                                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                                            <ToolTip Text="<%$ Resources: Panel5.GridPanelIssueList.ToolTip.Text %>" />
                                                                        </ext:GridCommand>
                                                                    </Commands>
                                                                </ext:CommandColumn>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server">
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <Listeners>
                                                            <Command Handler="Coolite.AjaxMethods.IssueListShow(record.data.Id,{success:function(){#{IssueListDetailWindow}.show();#{ptbIssueAttachment}.changePage(1);}});" />
                                                        </Listeners>
                                                        <LoadMask ShowMask="true" Msg="<%$ Resources:Panel5.GridPanelIssueList.LoadMask.Msg %>" />
                                                    </ext:GridPanel>
                                                </ext:FitLayout>
                                            </Body>
                                        </ext:Panel>
                                    </Center>
                                </ext:BorderLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                    <East MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel7" runat="server" Title="DMS教程下载" Frame="true" Icon="Bell" Width="260" AutoScroll="true">
                            <Body>
                                <ext:TreePanel ID="TreePanel2" runat="server" AutoHeight="true" Border="false"
                                    Collapsed="False" CollapseFirst="True" HideParent="False" RootVisible="False">
                                    <Root>
                                        <ext:TreeNode NodeID="0">
                                            <Nodes>
                                                <ext:TreeNode Text="T1/LP电子签章操作手册" Icon="PackageIn">
                                                   <Listeners>
                                                      <Click Handler="window.open('https://bscdealer.cn/Upload/UploadFile/T1LP电子合同签章操作手册.docx');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="T2电子签章操作手册" Icon="PackageIn">
                                                   <Listeners>
                                                      <Click Handler="window.open('https://bscdealer.cn/Upload/UploadFile/T2电子合同签章操作手册.docx');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="BSA 操作手册" Icon="PackageIn">
                                                   <Listeners>
                                                      <Click Handler="window.open('https://bscdealer.cn/Upload/UploadFile/BSA-操作手册.docx');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="寄售管理 操作手册" Icon="PackageIn">
                                                   <Listeners>
                                                      <Click Handler="window.open('https://bscdealer.cn/Upload/UploadFile/寄售管理-操作手册.docx');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                               <ext:TreeNode Text="2018预警反馈流程" Icon="PackageIn">
                                                   <Listeners>
                                                      <Click Handler="window.open('https://bscdealer.cn/Upload/UploadFile/2018EarlyWarning.pptx');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="DMS操作流程图" Icon="PackageIn">
                                                   <Listeners>
                                                      <Click Handler="window.open('https://bscdealer.cn/resources/images/DMSProcess.jpg');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="T1订单详情" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360848/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="T2订单申请" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360852/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="仓库维护" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360853/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <%--  <ext:TreeNode Text="二维码产品数据收集" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('https://bostonscientific.boxenterprise.net/v/DMS-23');" />
                                                    </Listeners>
                                                </ext:TreeNode>--%>
                                                <ext:TreeNode Text="借货出库" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360854/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="经销商产品查询" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360864/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <%-- <ext:TreeNode Text="经销商订单明细报表" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('https://bostonscientific.boxenterprise.net/v/DMS-20');" />
                                                    </Listeners>
                                                </ext:TreeNode>--%>
                                                <ext:TreeNode Text="经销商合同" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360866/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="经销商合同（CO）" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360865/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="经销商库存调整报表" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360849/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <%--    <ext:TreeNode Text="经销商评分" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('https://bostonscientific.boxenterprise.net/v/DMS-17');" />
                                                    </Listeners>
                                                </ext:TreeNode>--%>
                                                <ext:TreeNode Text="经销商收货数据报表" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360850/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="经销商销售报表" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360851/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="经销商信息汇总维护" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360870/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="经销商信息披露" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360871/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <%--   <ext:TreeNode Text="经销商移库" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('https://bostonscientific.boxenterprise.net/v/DMS1-7');" />
                                                    </Listeners>
                                                </ext:TreeNode>--%>
                                                <ext:TreeNode Text="经销商指标查询" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360867/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="库存查询" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360858/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <%-- <ext:TreeNode Text="库存数据上传" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('https://bostonscientific.boxenterprise.net/v/DMS-9');" />
                                                    </Listeners>
                                                </ext:TreeNode>--%>
                                                <ext:TreeNode Text="批量上传销量" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360863/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="其他出库" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360856/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="收货" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360860/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="投诉退换货" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360859/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="退换货申请" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360861/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="微信用户查询" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360868/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="销售出库单" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360862/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="医院指标查询" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/360869/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>

                                                <%--   <ext:TreeNode Text="特殊销量上报" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('https://bostonscientific.boxenterprise.net/v/DMS-NEW1');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="扫描有奖积分兑换" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('https://bostonscientific.boxenterprise.net/v/DMS-NEW2');" />
                                                    </Listeners>
                                                </ext:TreeNode>--%>
                                                <%--   <ext:TreeNode Text="如何进行二维码收集" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('https://bostonscientific.boxenterprise.net/v/DMS-NEW3');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="如何关注敬言物联" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('https://bostonscientific.boxenterprise.net/v/DMS-NEW4');" />
                                                    </Listeners>
                                                </ext:TreeNode>--%>

                                                <ext:TreeNode Text="如何扫码移库" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/361336/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                                <ext:TreeNode Text="如何上传二维码照片作为支持件" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/361335/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>


                                                <ext:TreeNode Text="二级经销商采购预测" Icon="PackageIn">
                                                    <Listeners>
                                                        <Click Handler="window.open('http://mudu.tv/show/videolink2/220260/origin');" />
                                                    </Listeners>
                                                </ext:TreeNode>
                                            </Nodes>
                                        </ext:TreeNode>
                                    </Root>
                                </ext:TreePanel>
                            </Body>
                        </ext:Panel>
                    </East>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Hidden ID="hfBulletinMainId" runat="server">
        </ext:Hidden>
        <ext:Window ID="BulletinDetailWindow" runat="server" Icon="Group" Title="<%$ Resources:BulletinDetailWindow.Title %>"
            Resizable="false" Header="false" Width="600" Height="370" AutoShow="false" Modal="true"
            ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FitLayout ID="FitLayout3" runat="server">
                    <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Border="false" AutoScroll="true">
                        <Tabs>
                            <ext:Tab ID="Tab1" runat="server" Title="明细" Icon="ChartOrganisation" BodyStyle="padding:5px;">
                                <Body>
                                    <ext:FormLayout ID="FormLayout11" runat="server">
                                        <ext:Anchor>
                                            <ext:Panel ID="Panel8" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                                                <Body>
                                                    <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                        <ext:LayoutColumn ColumnWidth=".5">
                                                            <ext:Panel ID="Panel9" runat="server" Border="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout4" runat="server">
                                                                        <ext:Anchor>
                                                                            <ext:ComboBox ID="BulletinUrgentDegree" runat="server" EmptyText="<%$ Resources:BulletinDetailWindow.Panel9.BulletinUrgentDegree.EmptyText %>"
                                                                                Width="150" Editable="true" TypeAhead="true" Resizable="true" StoreID="BulletinImportantStore"
                                                                                ValueField="Key" DisplayField="Value" FieldLabel="<%$ Resources:BulletinDetailWindow.Panel9.BulletinUrgentDegree.FieldLabel %>"
                                                                                Disabled="true">
                                                                                <Triggers>
                                                                                    <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources:BulletinDetailWindow.Panel9.FieldTrigger.Qtip %>" />
                                                                                </Triggers>
                                                                                <Listeners>
                                                                                    <TriggerClick Handler="this.clearValue();" />
                                                                                </Listeners>
                                                                            </ext:ComboBox>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:Checkbox ID="BulletinReadFlag" runat="server" FieldLabel="<%$ Resources:BulletinDetailWindow.Panel9.BulletinReadFlag.FieldLabel %>"
                                                                                Disabled="true">
                                                                            </ext:Checkbox>
                                                                        </ext:Anchor>
                                                                        <%-- <ext:Anchor>
                                                                        <ext:Checkbox ID="BulletinIsRead" runat="server" FieldLabel="是否已阅读" Disabled="true">
                                                                        </ext:Checkbox>
                                                                    </ext:Anchor>--%>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth=".5">
                                                            <ext:Panel ID="Panel10" runat="server" Border="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout5" runat="server">
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="BulletinPublishedUser" runat="server" Width="150" FieldLabel="<%$ Resources:BulletinDetailWindow.Panel10.BulletinPublishedUser.FieldLabel %>"
                                                                                Disabled="true">
                                                                            </ext:TextField>
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:DateField ID="BulletinPublishedDate" runat="server" Width="150" FieldLabel="<%$ Resources:BulletinDetailWindow.Panel10.BulletinPublishedDate.FieldLabel %>"
                                                                                Disabled="true">
                                                                            </ext:DateField>
                                                                        </ext:Anchor>
                                                                        <%--<ext:Anchor>
                                                                        <ext:Checkbox ID="BulletinIsConfirm" runat="server" FieldLabel="是否已确认" Disabled="true">
                                                                        </ext:Checkbox>
                                                                    </ext:Anchor>--%>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                    </ext:ColumnLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Anchor>
                                        <ext:Anchor>
                                            <ext:Panel ID="Panel11" runat="server" BodyBorder="false" Header="false" BodyStyle="padding:5px;">
                                                <Body>
                                                    <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                                        <ext:LayoutColumn>
                                                            <ext:Panel ID="Panel12" runat="server" Border="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout6" runat="server">
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="BulletinTitle" runat="server" FieldLabel="<%$ Resources:BulletinDetailWindow.Panel12.BulletinTitle.FieldLabel %>"
                                                                                Width="390" ReadOnly="true" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:TextArea ID="BulletinBody" runat="server" FieldLabel="<%$ Resources:BulletinDetailWindow.Panel12.BulletinBody.FieldLabel %>"
                                                                                Width="390" Height="120" ReadOnly="true">
                                                                            </ext:TextArea>
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                    </ext:ColumnLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="Tab2" runat="server" Title="附件" Icon="BrickLink">
                                <Body>
                                    <ext:FormLayout ID="FormLayout7" runat="server">
                                        <ext:Anchor>
                                            <ext:Panel ID="Panel1" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:GridPanel ID="AttachmentPanel" runat="server" Title="附件列表" StoreID="AttachmentStore"
                                                        Border="false" Icon="Lorry" Height="260" Width="755" AutoScroll="true" EnableHdMenu="false"
                                                        StripeRows="true">
                                                        <ColumnModel ID="ColumnModel3" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="MainId" DataIndex="MainId" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Name" DataIndex="Name" Header="附件名称" Width="200">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Url" DataIndex="Url" Header="路径" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="上传人">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="上传时间">
                                                                </ext:Column>
                                                                <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                                    <Commands>
                                                                        <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad" ToolTip-Text="下载" />
                                                                    </Commands>
                                                                </ext:CommandColumn>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server">
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <BottomBar>
                                                            <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="100" StoreID="AttachmentStore"
                                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                        </BottomBar>
                                                        <SaveMask ShowMask="true" />
                                                        <LoadMask ShowMask="true" Msg="处理中" />
                                                        <Listeners>
                                                            <Command Handler="if (command == 'DownLoad')
                                                                        {
                                                                            var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url);
                                                                            open(url, 'Download');
                                                                        }" />
                                                        </Listeners>
                                                    </ext:GridPanel>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </ext:FitLayout>
            </Body>
            <Buttons>
                <ext:Button ID="btnBulletinConfirm" runat="server" Text="<%$ Resources:BulletinDetailWindow.btnBulletinConfirm.Text %>"
                    Icon="Disk">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.BulletinUpdateConfirm(#{hfBulletinMainId}.getValue(),{success:function(){#{GridPanelBulletin}.reload();#{BulletinDetailWindow}.hide(null);Ext.Msg.alert(MsgList.btnBulletinConfirm.alertTitle,MsgList.btnBulletinConfirm.alertMsg);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnBulletinCancel" runat="server" Text="<%$ Resources: BulletinDetailWindow.btnBulletinCancel.Text %>"
                    Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{BulletinDetailWindow}.hide(null);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Hidden ID="hfIssueListSortNo" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hfIssueListId" runat="server">
        </ext:Hidden>
        <ext:Window ID="IssueListDetailWindow" runat="server" Icon="Group" Title="<%$ Resources: IssueListDetailWindow.Title %>"
            Resizable="false" Header="false" Width="600" Height="380" AutoShow="false" Modal="true"
            ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FitLayout ID="FitLayout4" runat="server">
                    <ext:TabPanel ID="TabPanel2" runat="server" ActiveTabIndex="0" Border="false" AutoScroll="true">
                        <Tabs>
                            <ext:Tab ID="Tab3" runat="server" Title="政策内容" Icon="ChartOrganisation" Border="false"
                                BodyStyle="padding:5px;">
                                <Body>
                                    <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="100">
                                                <ext:Anchor>
                                                    <ext:TextArea ID="taIssueListQuestion" runat="server" FieldLabel="<%$ Resources: IssueListDetailWindow.Panel14.taIssueListQuestion.FieldLabel %>"
                                                        AllowBlank="false" Height="60" Width="300" ReadOnly="true">
                                                    </ext:TextArea>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:TextArea ID="taIssueListAnswer" runat="server" FieldLabel="<%$ Resources: IssueListDetailWindow.Panel14.taIssueListAnswer.FieldLabel %>"
                                                        AllowBlank="false" Height="165" Width="390" ReadOnly="true">
                                                    </ext:TextArea>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:NumberField ID="nfIssueListSortNo" runat="server" FieldLabel="<%$ Resources: IssueListDetailWindow.Panel14.nfIssueListSortNo.FieldLabel %>"
                                                        Width="70" ReadOnly="true">
                                                    </ext:NumberField>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Panel>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="Tab4" runat="server" Title="附件" Icon="BrickLink">
                                <Body>
                                    <ext:FormLayout ID="FormLayout2" runat="server">
                                        <ext:Anchor>
                                            <ext:Panel ID="Panel6" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:GridPanel ID="IssueAttachPanel" runat="server" Title="附件列表" StoreID="IssueAttachmentStore"
                                                        Border="false" Icon="Lorry" Height="270" Width="576" AutoScroll="true" EnableHdMenu="false"
                                                        StripeRows="true">
                                                        <ColumnModel ID="ColumnModel4" runat="server">
                                                            <Columns>
                                                                <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="MainId" DataIndex="MainId" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Name" DataIndex="Name" Header="附件名称" Width="200">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Url" DataIndex="Url" Header="路径" Hidden="true">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="上传人">
                                                                </ext:Column>
                                                                <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="上传时间">
                                                                </ext:Column>
                                                                <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                                    <Commands>
                                                                        <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad" ToolTip-Text="下载" />
                                                                    </Commands>
                                                                </ext:CommandColumn>
                                                            </Columns>
                                                        </ColumnModel>
                                                        <SelectionModel>
                                                            <ext:RowSelectionModel ID="RowSelectionModel4" SingleSelect="true" runat="server">
                                                            </ext:RowSelectionModel>
                                                        </SelectionModel>
                                                        <BottomBar>
                                                            <ext:PagingToolbar ID="ptbIssueAttachment" runat="server" PageSize="100" StoreID="IssueAttachmentStore"
                                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                        </BottomBar>
                                                        <SaveMask ShowMask="true" />
                                                        <LoadMask ShowMask="true" Msg="处理中" />
                                                        <Listeners>
                                                            <Command Handler="if (command == 'DownLoad')
                                                                        {
                                                                            var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url);
                                                                            open(url, 'Download');
                                                                        }" />
                                                        </Listeners>
                                                    </ext:GridPanel>
                                                </Body>
                                            </ext:Panel>
                                        </ext:Anchor>
                                    </ext:FormLayout>
                                </Body>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </ext:FitLayout>
            </Body>
            <Buttons>
                <ext:Button ID="btnIssueListCancel" runat="server" Text="<%$ Resources: IssueListDetailWindow.btnIssueListCancel.Text %>"
                    Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{IssueListDetailWindow}.hide(null);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Hidden ID="hfDealerQAId" runat="server">
        </ext:Hidden>
    </form>
</body>
</html>
