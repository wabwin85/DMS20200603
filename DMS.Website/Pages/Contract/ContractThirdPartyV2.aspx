<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractThirdPartyV2.aspx.cs" Inherits="DMS.Website.Pages.Contract.ContractThirdPartyV2" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <style type="text/css">
        .x-form-group .x-form-group-header-text {
            background-color: #dfe8f6 !important;
            color: Black !important;
            font-family: "微软雅黑" !important;
            font-size: 11px !important;
        }

        .x-form-group .x-form-group-header {
            padding: 10px !important;
            border-bottom: 2px solid #99bbe8 !important;
        }

        .x-panel-mc {
            font: normal 12px "微软雅黑",tahoma,arial,helvetica,sans-serif !important;
            font-weight: bold !important;
        }

        .labelBold {
            font-weight: bold !important;
        }

        .txtRed {
            color: Red;
            font-weight: bold;
        }

        .yellow-row {
            background: #FFD700;
        }
    </style>

    <script language="javascript" type="text/javascript">

       
        

        //设定无披露
    

        //添加选中的产品线
        var addPL = function (grid) {
            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();

                var param = '';
                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].data.DivisionName + ',';
                }
                Coolite.AjaxMethods.SaveProductLine(param,
                            {
                                success: function () {

                                },
                                failure: function (err) {
                                    Ext.Msg.alert('Error', err);
                                }
                            }
                            );

            } else {
                Ext.MessageBox.alert('Message', '产品线为空，请选择产品线');
            }
        }

        

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server">
        </ext:ScriptManager>

        <script language="javascript" type="text/javascript">
            var DownloadFile = function () {
                var url = '../Download.aspx?downloadname=第三方公司披露操作方法.docx&filename=FromHelp.pdf';
                window.open(url, 'Download');
            }

            var DownloadTemplate = function () {
                var url = '../Download.aspx?downloadname=ThirdPartyTemplate.zip&filename=ThirdPartyTemplate.zip';
                window.open(url, 'Download');
            }
            Date.prototype.Format = function (fmt) { //author: meizz 
                var o = {
                    "M+": this.getMonth() + 1, //月份 
                    "d+": this.getDate(), //日 
                    "h+": this.getHours(), //小时 
                    "m+": this.getMinutes(), //分 
                    "s+": this.getSeconds(), //秒 
                    "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
                    "S": this.getMilliseconds() //毫秒 
                };
                if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
                for (var k in o)
                    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
                return fmt;
            }

            //var prepare = function (grid, toolbar, rowIndex, record) {
            //    var firstButton = toolbar.items.get(0);
            //    var begindate = new Date(record.data.BeginDate).Format('yyyy-MM-dd hh:mm:ss');
            //    var enddate = new Date(record.data.EndDate).Format('yyyy-MM-dd hh:mm:ss');
            //    var time2 = new Date().Format('yyyy-MM-dd hh:mm:ss')
            //    if (time2 > enddate) {
            //        firstButton.setVisible(false);
            //    }
            //    else {
            //        firstButton.setVisible(true);
            //    }
            //}

            function SetRulePageActivate() {
                var ApprovalStatu = Ext.getCmp('<%=this.hiddTabcontrol.ClientID%>').getValue();
               
                var hdtype = Ext.getCmp('<%=this.hdtype.ClientID%>').getValue();
                if ( ApprovalStatu == "申请审批拒绝" ||
                    ApprovalStatu == "终止申请审批拒绝"||
                    ApprovalStatu == "终止申请审批通过"||
                    ApprovalStatu == "终止申请审批中"  ||  ApprovalStatu=="申请审批通过") 
                {     
                  
                    GpWdAttachment.getColumnModel().setHidden(4, true);
                    Ext.getCmp('<%=this.btnPolicyAttachmentAdd.ClientID%>').hide();
                 
                
                }

                if(ApprovalStatu=="申请审批通过"&&  hdtype=="new"||ApprovalStatu=="申请审批中"||ApprovalStatu=="new")
                {
                    GpWdAttachment.getColumnModel().setHidden(4, false);
                    Ext.getCmp('<%=this.btnPolicyAttachmentAdd.ClientID%>').show();
                }


            
            
           
            }

            function setEndDate () {
              
                var txtStates = Ext.getCmp('<%=this.hdtype.ClientID%>').getValue();
              
               
                if(txtStates=="old"){

                    if(Ext.getCmp('<%=this.ApplicationNote.ClientID%>').getValue()=='')
                    { 
                        Ext.Msg.alert('警告', '终止披露必须填写披露备注');
                        return; 
                    } 
                    if(Ext.getCmp('<%=this.ApplicationNote.ClientID%>').getValue()==Ext.getCmp('<%=this.hidApplicationNote.ClientID%>').getValue() && Ext.getCmp('<%=this.Approver.ClientID%>').getText()=='终止披露')
                    {
                        Ext.Msg.alert('警告', '终止披露请重新填写披露备注');
                        return;
                    }

                    if(Ext.getCmp('<%=this.TerminationendDate.ClientID %>').getValue()=='')
                    {  
                        Ext.Msg.alert('警告', '请选择终止披露时间');
                        return; 
                    }
                    else{
                        var bdate = new Date(<%= this.begindate.ClientID %>.getValue()).Format('yyyy-MM-dd');
                        var edate = new Date(<%=this.enddate.ClientID %>.getValue()).Format('yyyy-MM-dd');
                        var date = Ext.getCmp('<%=this.TerminationendDate.ClientID%>').getValue();                               
                        var TerminationendDate=new Date(date).Format('yyyy-MM-dd');
                        if(TerminationendDate>edate || TerminationendDate<bdate)
                        {
                            Ext.Msg.alert('警告', '请选择披露范内的时间终止披露');
                            return;
                        } 
                     
                        else{
                            Coolite.AjaxMethods.EndThirdPartylistApprover({success: function() {Ext.getCmp('<%=this.windowThirdParty.ClientID%>').hide(); Ext.getCmp('<%=this.gpThirdPartyDisclosure.ClientID%>').reload();
                                                                                               
                            },failure: function(err) {Ext.Msg.alert('Error', err);}});
                        }
                    }
                }
                
              

            }

          
            function EndAppLP () {
               
                var txtStates = Ext.getCmp('<%=this.hdtype.ClientID%>').getValue();
                if(Ext.getCmp('<%=this.ApplicationNote.ClientID%>').getValue()=='')
                {    
                    Ext.Msg.alert('警告', '终止披露必须填写披露备注');
                    return; 
                }  
              
                if(Ext.getCmp('<%=this.ApplicationNote.ClientID%>').getValue()==Ext.getCmp('<%=this.hidApplicationNote.ClientID%>').getValue()  && Ext.getCmp('<%=this.Approver.ClientID%>').getText()=='终止披露审批通过')
                {
                    Ext.Msg.alert('警告', '终止披露请重新填写披露备注');
                    return;
                }
                       
                if(Ext.getCmp('<%= TerminationendDate.ClientID %>').getValue()=='')
                {  Ext.Msg.alert('警告', '请选择终止披露时间');
                    return; 
                }
                else{
                    var bdate = new Date(<%= begindate.ClientID %>.getValue()).Format('yyyy-MM-dd');
                    var edate = new Date(<%= enddate.ClientID %>.getValue()).Format('yyyy-MM-dd');
                    var TerminationendDate=new Date(Ext.getCmp('<%=this.TerminationendDate.ClientID%>').getValue()).Format('yyyy-MM-dd');
                    if(TerminationendDate>edate || TerminationendDate<bdate)
                    {
                        Ext.Msg.alert('警告', '请选择披露范内的时间终止披露');
                        return;
                    } 
                     
                    else{
                          
                        Coolite.AjaxMethods.EndThirdPartylist({success: function() {Ext.getCmp('<%=this.windowThirdParty.ClientID%>').hide(); Ext.getCmp('<%=this.gpThirdPartyDisclosure.ClientID%>').reload();                                                          
                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                    }
                }
                        

            }
              
                

            function Refusaltoapprove() {
                var txtStates = Ext.getCmp('<%=this.hdtype.ClientID%>').getValue();
                var taWinApprovalRemark=Ext.getCmp('<%=this.taWinApprovalRemark.ClientID%>').getValue();               
                if(taWinApprovalRemark=='')
                {
                    Ext.Msg.alert('警告', '审批拒绝必须填写审批备注');
                    return;
                }
                else{
     
                    Coolite.AjaxMethods.Reject({success: function() {Ext.getCmp('<%=this.windowThirdParty.ClientID%>').hide(); Ext.getCmp('<%=this.gpThirdPartyDisclosure.ClientID%>').reload();                                                          
                    },failure: function(err) {Ext.Msg.alert('Error', err);}});
                }
            }
            function datedifference(sDate1, sDate2) {    //sDate1和sDate2是2006-12-18格式  
                var dateSpan,
                    tempDate,
                    iDays;
                sDate1 = Date.parse(sDate1);
                sDate2 = Date.parse(sDate2);
                dateSpan = sDate2 - sDate1;
                dateSpan = Math.abs(dateSpan);
                iDays = Math.floor(dateSpan / (24 * 3600 * 1000));
                return iDays
            };


        
            var  getCurrentInvRowClass = function (record, index) {
             
                var time2 = new Date().Format('yyyy-MM-dd')
                var bdate = new Date(record.data.EndDate).Format('yyyy-MM-dd');
                if(bdate!=null){
                    if (datedifference(time2,bdate)<=30 && bdate>=time2)
                    {                       
                        return 'yellow-row';
                                                                         
                    }   
                                      
                }
            }
                                
                               
                               
                            
                        
            function Refusaltoapproveend() {
                var txtStates = Ext.getCmp('<%=this.hdtype.ClientID%>').getValue();
                var taWinApprovalRemark=Ext.getCmp('<%=this.taWinApprovalRemark.ClientID%>').getValue();               
                if(taWinApprovalRemark=='')
                {
                    Ext.Msg.alert('警告', '审批拒绝必须填写审批备注');
                    return;
                }
                else{
     
                    Coolite.AjaxMethods.refuseEndThirdPartylist({success: function() {Ext.getCmp('<%=this.windowThirdParty.ClientID%>').hide(); Ext.getCmp('<%=this.gpThirdPartyDisclosure.ClientID%>').reload();                                                          
                                },failure: function(err) {Ext.Msg.alert('Error', err);}});
                            }
            }

           
        </script>
        <ext:Hidden ID="hidname" runat="server" ></ext:Hidden>
        <ext:Hidden ID="hidpost" runat="server" ></ext:Hidden>
        <ext:Hidden ID="pagedealername" runat="server" />
        <ext:Hidden ID="DealerName" runat="server" />
        <ext:Hidden ID="hidall" runat="server" />
        <ext:Hidden ID="hidApplicationNote" runat="server" />
       
        <ext:Hidden ID="hidresful" runat="server" />
        <ext:Hidden ID="hdtype" runat="server" />
        <ext:Hidden ID="hdDmaId" runat="server" />
        <ext:Hidden ID="hidTerminationDate" runat="server" />
        <ext:Hidden ID="hidalert" runat="server" />
        
        <ext:Hidden ID="hidCompanyName" runat="server"></ext:Hidden>
        <ext:Hidden ID="hidrelationship" runat="server"></ext:Hidden>
        <ext:Hidden ID="hdProductLineId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hidhospitalname" runat="server" />
        <ext:Hidden ID="hdDealerType" runat="server">
        </ext:Hidden>

        <ext:Store ID="ThirdPartyDisclosureStore" runat="server"
            OnRefreshData="Store_RefreshThirdPartyDisclosure">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="DmaId" />
                        <ext:RecordField Name="HospitalId" />
                        <ext:RecordField Name="HospitalName" />
                        <ext:RecordField Name="CompanyName" />
                        <ext:RecordField Name="Rsm" />
                        <ext:RecordField Name="BeginDate" />
                        <ext:RecordField Name="EndDate" />
                        <ext:RecordField Name="ProductNameString" />
                        <ext:RecordField Name="ThirdType" />
                        <ext:RecordField Name="ApprovalStatus" />
                        <ext:RecordField Name="ApprovalDate" />
                        <ext:RecordField Name="ApprovalName" />
                        <ext:RecordField Name="TerminationDate" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>

        <ext:Store ID="AttachmentStore" runat="server" OnRefreshData="AttachmentStore_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="Id">
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
        <ext:Store ID="HospitalStore" runat="server" OnRefreshData="HospitalStore_RefreshData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="HospitalId" />
                        <ext:RecordField Name="HospitalCode" />
                        <ext:RecordField Name="HospitalName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="CurrentProductLineStore" runat="server" OnRefreshData="ProductLineStore_RefreshData"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="ProductLineId">
                    <Fields>
                        <ext:RecordField Name="ProductLineId" />
                        <ext:RecordField Name="ProductLineName" />
                        <ext:RecordField Name="DivisionName" />
                        <ext:RecordField Name="StartDate" />
                        <ext:RecordField Name="EndDate" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>

        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <Center>
                        <ext:Panel ID="Panel2" runat="server" Header="false" AutoScroll="true">
                            <Body>
                                <ext:Panel ID="btnPanel" runat="server" Header="false" Height="17">
                                    <TopBar>
                                        <ext:Toolbar ID="Toolbar1" runat="server">
                                            <Items>
                                                <ext:ToolbarFill />
                                                <ext:Button ID="btnCreatePdf" runat="server" Text="生成第三方披露表 PDF" Icon="PageWhiteAcrobat">

                                                    <Listeners>
                                                        <Click Handler="Coolite.AjaxMethods.CreatePdf();" />

                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="btnCancel" runat="server" Text="返回" Icon="Delete">
                                                    <Listeners>
                                                        <Click Handler="window.location.href='/Pages/Contract/ContractMain.aspx';" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="Button1" runat="server" Text="使用帮助" Icon="Help" Hidden="true">
                                                    <Listeners>
                                                        <Click Fn="DownloadFile" />
                                                    </Listeners>
                                                </ext:Button>
                                                <ext:Button ID="Button3" runat="server" Text="使用帮助及模板" Icon="Help">
                                                    <Listeners>
                                                        <Click Fn="DownloadTemplate" />
                                                    </Listeners>
                                                </ext:Button>
                                            </Items>
                                        </ext:Toolbar>
                                    </TopBar>
                                </ext:Panel>
                                <ext:Panel ID="Panel3" runat="server" Header="true" Title="第三方披露表" Frame="true" Icon="Application"
                                    AutoScroll="true" Collapsible="false">
                                    <Body>
                                        <ext:Panel ID="Panel10" runat="server" Header="false" BodyBorder="false" AutoHeight="true">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:Label ID="Label3" runat="server" FieldLabel="" HideLabel="true" LabelSeparator=""
                                                            CtCls="txtRed" Text="提示：第三方公司披露的详细要求以及需签署的文件模板请从右上角“使用帮助及模板”中获得">
                                                        </ext:Label>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                        <ext:Panel ID="plSearch" runat="server" Header="true" BodyBorder="false" FormGroup="true"
                                            AutoHeight="true" Title="公司信息">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelWidth="190">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="tfDealerNameCn" runat="server" FieldLabel="公司名称（本表简称“公司”)" ReadOnly="true"
                                                            Width="300">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                        <ext:Panel ID="plForm3" runat="server" Header="true" Title="第三方医院信息" FormGroup="true"
                                            BodyBorder="true" AutoHeight="true">
                                            <Body>
                                                <ext:Panel ID="Panel1" runat="server" Header="false" BodyBorder="true" AutoHeight="true">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                            <ext:LayoutColumn ColumnWidth=".3">
                                                                <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout10" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                            <ext:Anchor>
                                                                                <ext:TextField ID="txtHospitalName" runat="server" Width="180" FieldLabel="医院名称" />
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                            <ext:LayoutColumn ColumnWidth=".3">
                                                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout11" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                            <ext:Anchor>
                                                                                <ext:ComboBox ID="Type" runat="server" Width="220" Editable="true"
                                                                                    FieldLabel="状态" EmptyText="选择披露状态">
                                                                                    <Items>
                                                                                        <ext:ListItem Text="已生效" Value="已生效" />
                                                                                        <ext:ListItem Text="未生效" Value="未生效" />
                                                                                    </Items>
                                                                                    <Listeners>
                                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                                    </Listeners>
                                                                                    <Triggers>
                                                                                        <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                                                    </Triggers>
                                                                                </ext:ComboBox>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                    <Buttons>
                                                        <ext:Button ID="btnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                            <Listeners>
                                                                <Click Handler="#{PagingToolBar3}.changePage(1); #{PagingToolBar1}.changePage(1);" />
                                                            </Listeners>
                                                        </ext:Button>
                                                        <ext:Button ID="export" Text="导出" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                                            <Listeners>
                                                                <Click Handler=" Coolite.AjaxMethods.ExportDetail();" />
                                                            </Listeners>
                                                        </ext:Button>
                                                    </Buttons>
                                                </ext:Panel>
                                                <ext:Panel ID="Panel12" runat="server" Header="true" BodyBorder="true" AutoHeight="true" Title="授权医院信息" AutoWidth="true" Frame="true">
                                                    <Body>
                                                        <ext:FitLayout ID="FitLayout4" runat="server">
                                                            <ext:GridPanel ID="DealerAuthorizationHospital" runat="server" StoreID="HospitalStore"
                                                                Border="false" StripeRows="true" Header="false" AutoHeight="true" AutoWidth="true">
                                                                <ColumnModel ID="ColumnModel3" runat="server">
                                                                    <Columns>
                                                                        <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Width="150" Header="医院名称">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="HospitalCode" DataIndex="HospitalCode" Width="150" Header="医院代码">
                                                                        </ext:Column>
                                                                        <ext:CommandColumn Header="操作" Align="Center">
                                                                            <Commands>
                                                                                <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                                                    <ToolTip Text="明细" />
                                                                                </ext:GridCommand>
                                                                            </Commands>
                                                                        </ext:CommandColumn>
                                                                    </Columns>
                                                                </ColumnModel>
                                                                <SelectionModel>
                                                                    <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" SingleSelect="true" />
                                                                </SelectionModel>
                                                                <BottomBar>
                                                                    <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="5" StoreID="HospitalStore"
                                                                        DisplayInfo="true" EmptyMsg="没有数据显示&nbsp;&nbsp;&nbsp;&nbsp;" DisplayMsg="显示：{0} - {1} 共 {2}条&nbsp;&nbsp;&nbsp;" />
                                                                </BottomBar>
                                                                <Listeners>
                                                                    <Command Handler="if (command == 'Edit'){
                                                                           #{hiddTabcontrol}.setValue('new');
                                                        Coolite.AjaxMethods.EditThirdPartyDisclosureItem('',record.data.HospitalName,record.data.HospitalId,{success:function(){#{GpWdAttachment}.reload();}},{failure:function(err){Ext.Msg.alert('Error', err);}});};" />
                                                                </Listeners>
                                                                <SaveMask ShowMask="true" />
                                                                <LoadMask ShowMask="true" Msg="处理中……" />
                                                            </ext:GridPanel>
                                                        </ext:FitLayout>
                                                    </Body>
                                                </ext:Panel>
                                                <ext:Panel ID="Panel18" runat="server" Header="true" BodyBorder="false" AutoHeight="true" Title="披露医院信息" AutoWidth="true" Frame="true" AutoScroll="false">

                                                    <Body>
                                                        <ext:FitLayout ID="FitLayout6" runat="server">
                                                            <ext:GridPanel ID="gpThirdPartyDisclosure" runat="server" StoreID="ThirdPartyDisclosureStore"
                                                                Border="false" StripeRows="true" Header="false" AutoHeight="true" AutoScroll="false">
                                                                <ColumnModel ID="ColumnModel4" runat="server">
                                                                    <Columns>
                                                                        <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Width="150" Header="医院名称">
                                                                        </ext:Column>

                                                                        <ext:Column ColumnID="ProductNameString" DataIndex="ProductNameString" Width="100"
                                                                            Header="合作产品线">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="CompanyName" DataIndex="CompanyName" Width="130" Header="公司名称">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="Rsm" DataIndex="Rsm" Width="120" Header="与贵司或医院关系">
                                                                        </ext:Column>

                                                                        <ext:Column ColumnID="ThirdType" DataIndex="ThirdType" Width="80" Header="当前状态">
                                                                        </ext:Column>

                                                                        <ext:Column ColumnID="ApprovalStatus" DataIndex="ApprovalStatus" Header="审批状态" Width="120">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="ApprovalName" DataIndex="ApprovalName" Header="审批人" Width="80">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="TerminationDate" DataIndex="TerminationDate" Header="终止披露时间" Width="80" Hidden="true">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="ApprovalDate" DataIndex="ApprovalDate" Header="审批时间" Width="150" Align="Center">
                                                                        </ext:Column>
                                                                        <ext:CommandColumn Header="查看明细" Align="Center">
                                                                            <Commands>
                                                                                <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                                                    <ToolTip Text="披露详情" />
                                                                                </ext:GridCommand>
                                                                            </Commands>
                                                                        </ext:CommandColumn>
                                                                    </Columns>
                                                                </ColumnModel>
                                                                <View>
                                                                    <ext:GridView ID="GridView1" runat="server">
                                                                        <GetRowClass Fn="getCurrentInvRowClass" />

                                                                    </ext:GridView>
                                                                </View>
                                                                <SelectionModel>
                                                                    <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" />
                                                                </SelectionModel>
                                                                <BottomBar>
                                                                    <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="ThirdPartyDisclosureStore"
                                                                        DisplayInfo="true" EmptyMsg="没有数据显示&nbsp;&nbsp;&nbsp;&nbsp;" DisplayMsg="显示：{0} - {1} 共 {2}条&nbsp;&nbsp;&nbsp;" />
                                                                </BottomBar>
                                                                <Listeners>
                                                                    <Command Handler="
                                                            if (command == 'Edit'){ #{hiddTabcontrol}.setValue(record.data.ApprovalStatus);
                                                        Coolite.AjaxMethods.EditThirdPartyDisclosureItem(record.data.Id,'','',{success:function(){#{GpWdAttachment}.reload();#{windowThirdParty}.show();}},{failure:function(err){Ext.Msg.alert('Error', err);}});}" />
                                                                </Listeners>
                                                                <SaveMask ShowMask="true" />
                                                                <LoadMask ShowMask="true" Msg="处理中……" />

                                                            </ext:GridPanel>


                                                        </ext:FitLayout>


                                                    </Body>

                                                </ext:Panel>

                                                <ext:Panel ID="Panel9" runat="server" Header="false" Frame="true" Icon="Application"
                                                    AutoHeight="true" BodyStyle="padding:1px;">
                                                    <Body>
                                                        <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                                            <ext:LayoutColumn ColumnWidth="1">
                                                                <ext:Panel ID="Panel8" runat="server" Border="false">
                                                                    <Body>
                                                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="120">
                                                                            <ext:Anchor>
                                                                                <ext:Label ID="label1" runat="server" HideLabel="true" Text="兹通知，在贵司披露第三方公司时，蓝威或其代理公司可能会购买尽职调查验证报告及/或调查性的尽职调查报告，以获取有关各种事项的信息，包括但不限于公司结构、所有权、商务实践、银行记录、资信状况、破产程序、犯罪记录、民事记录、一般声誉及个人品质（包括前述任何项目，以及个人的教育程度、从业历史等），并有权根据报告结果拒绝与该第三方公司合作。若贵司未主动披露第三方公司，蓝威或其代理公司发现后，蓝威或其代理公司保留扣减贵司返利，直至解除合同取消授权等措施的权利。">
                                                                                </ext:Label>
                                                                            </ext:Anchor>
                                                                        </ext:FormLayout>
                                                                    </Body>
                                                                </ext:Panel>
                                                            </ext:LayoutColumn>
                                                        </ext:ColumnLayout>
                                                    </Body>
                                                </ext:Panel>
                                            </Body>
                                        </ext:Panel>



                                    </Body>
                                </ext:Panel>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <%-- 2.第三方披露表 --%>
       
        <ext:Hidden ID="hiddenWinThirdPartyDetailId" runat="server">
        </ext:Hidden>
       
        <ext:Hidden ID="hidEndDate" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddTabcontrol" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="ApprovalStatus" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenMainId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenHospitalId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenCountAttachment" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="hiddenProductLineName" runat="server">
        </ext:Hidden>
        <ext:Window ID="windowThirdParty" runat="server" Icon="Group" Title="第三方披露表" Resizable="false"
            Header="false" Width="550" Height="500" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:FitLayout ID="FitLayout2" runat="server">
                    <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                        <Tabs>
                            <ext:Tab ID="TabHeader" runat="server" Title="政策概要" BodyStyle="padding: 6px;" AutoScroll="true">
                                <%--表头信息 --%>
                                <Body>
                                    <ext:FitLayout ID="FTHeader" runat="server">
                                        <ext:FormPanel ID="FormPanelHard" runat="server" Header="false" Border="false" AutoHeight="true">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout1" runat="server" Split="false">
                                                    <ext:LayoutColumn ColumnWidth=".5">
                                                        <ext:Panel ID="Panel26" runat="server" Border="false">
                                                            <Body>
                                                                <ext:FormLayout ID="FormLayout8" runat="server" LabelWidth="120">
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfWinHospitalName" runat="server" FieldLabel="医院名称" Width="220"
                                                                            ReadOnly="true">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>

                                                                    <ext:Anchor>
                                                                        <ext:DateField ID="begindate" runat="server" FieldLabel="披露开始日期" Width="220" Hidden="true">
                                                                        </ext:DateField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:DateField ID="enddate" runat="server" FieldLabel="披露结束日期" Width="220" Hidden="true">
                                                                        </ext:DateField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:DateField ID="TerminationendDate" runat="server" FieldLabel="终止披露日期" Width="220" Hidden="true">
                                                                        </ext:DateField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Panel ID="pan" runat="server" Border="false">
                                                                            <Body>
                                                                                <ext:ColumnLayout ID="ColumnLayout4" runat="server" Split="false">
                                                                                    <ext:LayoutColumn ColumnWidth="0.62">
                                                                                        <ext:Panel ID="Panel13" runat="server" Border="true" FormGroup="true">
                                                                                            <Body>
                                                                                                <ext:FormLayout ID="FormLayout12" runat="server" LabelAlign="Left">
                                                                                                    <ext:Anchor>
                                                                                                        <ext:TextField ID="Productline" runat="server" FieldLabel="合作产品线"
                                                                                                            Width="190">
                                                                                                        </ext:TextField>
                                                                                                    </ext:Anchor>
                                                                                                </ext:FormLayout>
                                                                                            </Body>
                                                                                        </ext:Panel>
                                                                                    </ext:LayoutColumn>
                                                                                    <ext:LayoutColumn ColumnWidth="0.13">
                                                                                        <ext:Panel ID="Panel11" runat="server" Border="true" FormGroup="true">
                                                                                            <Body>
                                                                                                <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left">
                                                                                                    <ext:Anchor>
                                                                                                        <ext:Button ID="btnWdProductLine" runat="server" Text="添加" Icon="PackageAdd" FieldLabel="产品线">
                                                                                                            <Listeners>
                                                                                                                <Click Handler="Coolite.AjaxMethods.ProductLineShow();" />
                                                                                                            </Listeners>
                                                                                                        </ext:Button>
                                                                                                    </ext:Anchor>
                                                                                                </ext:FormLayout>
                                                                                            </Body>
                                                                                        </ext:Panel>
                                                                                    </ext:LayoutColumn>

                                                                                </ext:ColumnLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Label ID="Label4" runat="server" FieldLabel="" CtCls="txtRed" HideLabel="true" Text="     提示：请选择该第三方公司在该医院销售的所有产品线"></ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="tfWinCompanyName" runat="server" FieldLabel="第三方公司" Width="220">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:ComboBox ID="cbWinRs" runat="server" Width="220" Editable="true"
                                                                            FieldLabel="与贵司或医院关系" EmptyText="选择与贵司或医院关系">
                                                                            <Items>
                                                                                <ext:ListItem Text="经销商指定公司" Value="经销商指定公司" />
                                                                                <ext:ListItem Text="医院指定公司" Value="医院指定公司" />
                                                                            </Items>
                                                                            <Listeners>
                                                                                <Select Handler="if(this.getValue()=='经销商指定公司') {#{lbWinRsmRemark}.setText('请上传文件：贵司与第三方公司的合同、合规附件、合规/质量培训签到表和质量自检表，请在右上角的使用帮助及模板中下载相关模板'); } else if(this.getValue()=='医院指定公司') {#{lbWinRsmRemark}.setText('请上传医院指定的证明文件：包括第三方与医院的合同，或医院公函，或医院公告，或医院官方网站说明，或经BSC销售团队确认的经销商声明');} else{#{lbWinRsmRemark}.setText('');}" />
                                                                            </Listeners>
                                                                        </ext:ComboBox>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:Label ID="lbWinRsmRemark" runat="server" LabelSeparator="">
                                                                        </ext:Label>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="submintname" runat="server" FieldLabel="提交人姓名/职务" Width="220">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextField ID="job" runat="server" FieldLabel="提交人手机" Width="220">
                                                                        </ext:TextField>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextArea ID="ApplicationNote" runat="server" FieldLabel="披露备注" Width="220">
                                                                        </ext:TextArea>
                                                                    </ext:Anchor>
                                                                    <ext:Anchor>
                                                                        <ext:TextArea ID="taWinApprovalRemark" runat="server" FieldLabel="审批备注" Width="220">
                                                                        </ext:TextArea>
                                                                    </ext:Anchor>

                                                                </ext:FormLayout>
                                                            </Body>
                                                        </ext:Panel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:FormPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Tab>
                            <ext:Tab ID="Tab3" runat="server" Title="附件" AutoScroll="true">
                                <%-- 附件管理--%>
                                <Body>
                                    <ext:FitLayout ID="FitLayout5" runat="server">
                                        <ext:GridPanel ID="GpWdAttachment" runat="server" StoreID="AttachmentStore" Border="false"
                                            Icon="Lorry">
                                            <TopBar>
                                                <ext:Toolbar ID="Toolbar4" runat="server">
                                                    <Items>
                                                        <ext:ToolbarFill ID="ToolbarFill4" runat="server" />
                                                        <ext:Button ID="btnPolicyAttachmentAdd" runat="server" Text="新增附件" Icon="Add">
                                                            <Listeners>
                                                                <Click Handler="Coolite.AjaxMethods.AttachmentShow();" />
                                                            </Listeners>
                                                        </ext:Button>
                                                        <ext:Button ID="Button4" runat="server" Text="">
                                                        </ext:Button>
                                                    </Items>
                                                </ext:Toolbar>
                                            </TopBar>
                                            <ColumnModel ID="ColumnModel5" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="Name" DataIndex="Name" Width="200" Header="附件名称">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Width="90" Header="上传人">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Width="90" Header="上传时间">
                                                    </ext:Column>
                                                    <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad">
                                                                <ToolTip Text="下载" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                    <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                                <ToolTip Text="删除" />
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel5" SingleSelect="true" runat="server">
                                                </ext:RowSelectionModel>
                                            </SelectionModel>
                                            <Listeners>
                                                <Command Handler="if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该文件?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                        success: function() {
                                                                                            #{GpWdAttachment}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });
                                                                         }if (command == 'DownLoad'){
                                                                                    var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=dcms';
                                                                                    open(url, 'Download');
                                                                                  }  " />

                                            </Listeners>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBarAttachment" runat="server" PageSize="15" StoreID="AttachmentStore"
                                                    DisplayInfo="true" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" />
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                                <Listeners>
                                    <Activate Handler="SetRulePageActivate();" />
                                </Listeners>
                            </ext:Tab>
                        </Tabs>
                    </ext:TabPanel>
                </ext:FitLayout>
            </Body>
            <Buttons>

                <ext:Button ID="EndThirdParty" runat="server" Text="终止披露申请" Icon="Delete" Hidden="true">
                    <Listeners>
                        <Click Handler="EndAppLP();" />
                    </Listeners>
                </ext:Button>

                <ext:Button ID="Submit" runat="server" Text="提交续约" Icon="Tick">
                    <Listeners>
                        <Click Handler="#{hidCompanyName}.setValue(#{tfWinCompanyName}.getValue());#{hidrelationship}.setValue(#{cbWinRs}.getValue());if(#{hiddenProductLineName}.getValue() == '' ) { Ext.Msg.alert('Error','产品线为空请重新提交披露申请！');} else if(#{hiddenCountAttachment}.getValue() == '0' ) { Ext.Msg.alert('Error','请先上传证明文件后再提交！');}else{Coolite.AjaxMethods.RenewSubmit({success: function() {
                                                                                          #{windowThirdParty}.hide(); #{gpThirdPartyDisclosure}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}})};" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="Renewbtn" runat="server" Text="续约" Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.Renew({success: function() {         Ext.Msg.alert('提示', '请上传证明文件后点击“提交续约”按钮，完成续约操作。如果需要更新第三方公司名称，请提交新申请'); 
                                                                                              #{GpWdAttachment}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="Approver" runat="server" Text="终止披露审批通过" Icon="Tick">
                    <Listeners>
                        <Click Handler="setEndDate(); " />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="refuseEndThirdParty" runat="server" Text="终止披露审批拒绝" Icon="Tick">
                    <Listeners>
                        <Click Handler="Refusaltoapproveend();" />

                    </Listeners>
                </ext:Button>

                <ext:Button ID="btnThirdPartyApproval" runat="server" Text="披露申请审批通过" Icon="Tick">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.Approval({success: function() {
                                                                                            #{windowThirdParty}.hide(); #{gpThirdPartyDisclosure}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnThirdPartyReject" runat="server" Text="披露申请审批拒绝" Icon="Decline">
                    <Listeners>
                        <Click Handler="Refusaltoapprove();" />
                    </Listeners>
                </ext:Button>

                <ext:Button ID="btnThirdPartySubmit" runat="server" Text="披露申请提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="if(#{hiddenCountAttachment}.getValue() == '0' ) { Ext.Msg.alert('Error','请先上传证明文件后再提交！');}else{Coolite.AjaxMethods.SaveThirdParty({success: function() { },failure: function(err) {Ext.Msg.alert('Error', err);}});}" />
                    </Listeners>
                </ext:Button>

                <ext:Button ID="btnThirdPartyCancel" runat="server" Text="返回" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{windowThirdParty}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Window ID="wdAttachment" runat="server" Icon="Group" Title="上传附件" Resizable="false"
            Header="false" Width="500" Height="150" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="AttachmentForm" runat="server" Width="500" Frame="true" Header="false"
                    AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="80">
                            <ext:Anchor>
                                <ext:FileUploadField ID="ufUploadAttachment" runat="server" EmptyText="选择上传附件" FieldLabel="文件"
                                    ButtonText="" Icon="ImageAdd">
                                </ext:FileUploadField>
                            </ext:Anchor>
                        </ext:FormLayout>
                    </Body>
                    <Listeners>
                        <ClientValidation Handler="#{btnWinAttachmentSubmit}.setDisabled(!valid);" />
                    </Listeners>
                    <Buttons>
                        <ext:Button ID="btnWinAttachmentSubmit" runat="server" Text="上传附件">
                            <AjaxEvents>
                                <Click OnEvent="UploadAttachmentClick" Before="if(!#{AttachmentForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');"
                                    Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });"
                                    Success="#{GpWdAttachment}.reload();#{ufUploadAttachment}.setValue('')">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="Button2" runat="server" Text="清除">
                            <Listeners>
                                <Click Handler="#{AttachmentForm}.getForm().reset();#{btnWinAttachmentSubmit}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </Body>
            <Listeners>
                <BeforeShow Handler="#{ufUploadAttachment}.setValue('');" />
            </Listeners>
        </ext:Window>
        <ext:Window ID="wdProductLine" runat="server" Icon="Group" Title="添加产品线" Width="500" Height="400" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;" Resizable="false" Header="false">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <Center MarginsSummary="0 5 5 5">
                        <ext:Panel ID="Panel14" runat="server" Height="300" Header="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout3" runat="server">
                                    <ext:GridPanel ID="GridPanel2" runat="server" StoreID="CurrentProductLineStore" Title="产品线列表" Border="false" Icon="Lorry" StripeRows="true" AutoExpandColumn="ProductLineName" Header="false">
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DivisionName" DataIndex="DivisionName" Header="BU">
                                                </ext:Column>
                                                <ext:Column ColumnID="ProductLineName" Width="200" DataIndex="ProductLineName" Header="产品线名称">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="CurrentProductLineStore" />
                                        </BottomBar>
                                        <SelectionModel>
                                            <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server">
                                            </ext:CheckboxSelectionModel>
                                        </SelectionModel>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
                <ext:KeyMap ID="KeyMap1" runat="server" Target="={Ext.isGecko ? Ext.getDoc() : Ext.getBody()}">
                    <ext:KeyBinding>
                        <Keys>
                            <ext:Key Code="ENTER" />
                        </Keys>
                        <Listeners>
                            <Event Handler="#{PagingToolBar2}.changePage(1);" />
                        </Listeners>
                    </ext:KeyBinding>
                    <ext:KeyBinding Shift="true">
                        <Keys>
                            <ext:Key Code="ENTER" />
                        </Keys>
                        <Listeners>
                            <Event Handler="addPL(#{GridPanel2});" />
                        </Listeners>
                    </ext:KeyBinding>
                </ext:KeyMap>
            </Body>
            <Buttons>
                <ext:Button ID="AddItemsButton" runat="server" Text="添加" Icon="Add">
                    <Listeners>
                        <Click Handler="addPL(#{GridPanel2});#{wdProductLine}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Buttons>
                <ext:Button ID="CloseWindow" runat="server" Text="关闭" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{wdProductLine}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
    </form>
    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>
</body>
</html>
