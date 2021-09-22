<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TrainManage.aspx.cs" Inherits="DMS.Website.Pages.DealerTrain.TrainManage" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>培训课程维护</title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <ext:ScriptManager ID="ScriptManager1" runat="server">
    </ext:ScriptManager>

    <script type="text/javascript">
        Ext.apply(Ext.util.Format, { number: function(v, format) { if (!format) { return v; } v *= 1; if (typeof v != 'number' || isNaN(v)) { return ''; } var comma = ','; var dec = '.'; var i18n = false; if (format.substr(format.length - 2) == '/i') { format = format.substr(0, format.length - 2); i18n = true; comma = '.'; dec = ','; } var hasComma = format.indexOf(comma) != -1, psplit = (i18n ? format.replace(/[^\d\,]/g, '') : format.replace(/[^\d\.]/g, '')).split(dec); if (1 < psplit.length) { v = v.toFixed(psplit[1].length); } else if (2 < psplit.length) { throw ('NumberFormatException: invalid format, formats should have no more than 1 period: ' + format); } else { v = v.toFixed(0); } var fnum = v.toString(); if (hasComma) { psplit = fnum.split('.'); var cnum = psplit[0], parr = [], j = cnum.length, m = Math.floor(j / 3), n = cnum.length % 3 || 3; for (var i = 0; i < j; i += n) { if (i != 0) { n = 3; } parr[parr.length] = cnum.substr(i, n); m -= 1; } fnum = parr.join(comma); if (psplit[1]) { fnum += dec + psplit[1]; } } return format.replace(/[\d,?\.?]+/, fnum); }, numberRenderer: function(format) { return function(v) { return Ext.util.Format.number(v, format); }; } });

        function RefreshMainPage() {
            Ext.getCmp('<%=this.RstTrainList.ClientID%>').reload();
        }

        function GetFormatDay(mydate) {
            var y = mydate.getFullYear();
            var m = (mydate.getMonth() + 1);
            if (m.toString().length == 1) {
                m = "0" + m;
            }
            var d = mydate.getDate();
            if (d.toString().length == 1) {
                d = "0" + d;
            }

            return y + '-' + m + '-' + d;
        }

        function SaveTrainInfo() {
            var errMsg = "";
            var rtnVal = Ext.getCmp('<%=this.IptRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.IptRtnMsg.ClientID%>');

            var isFormValid = Ext.getCmp('<%=this.FrmTrainInfo.ClientID%>').getForm().isValid();

            if (!isFormValid) {
                errMsg = "请填写完整课程主信息";
            } else {
                var startTime = GetFormatDay(Ext.getCmp('<%=this.IptTrainStartTime.ClientID%>').getValue());
                var endTime = GetFormatDay(Ext.getCmp('<%=this.IptTrainEndTime.ClientID%>').getValue());
                if (startTime > endTime) {
                    errMsg = "起始时间不能大于终止时间";
                } else if (endTime < GetFormatDay(new Date())) {
                    errMsg = "终止时间不能小于今天";
                }
            }

            if (errMsg != "") {
                Ext.Msg.alert('Message', errMsg);
            } else {
                var isSendRemind = 'False';
                Ext.Msg.confirm('Message', "是否确认提交此课程申请？",
                    function(e) {
                        if (e == 'yes') {
                            if (Ext.getCmp('<%=this.IptIsNew.ClientID%>').getValue() == 'False') {
                                Ext.Msg.confirm('Message', "跟台次数已更新，是否发送提醒？",
                                    function(e) {
                                        if (e == 'yes') {
                                            isSendRemind = 'True';
                                        }
                                        Coolite.AjaxMethods.SaveTrainInfo(
                                            isSendRemind,
                                            {
                                                success: function() {
                                                    Ext.Msg.alert('Message', '保存成功！');
                                                    Ext.getCmp('<%=this.WdwTrainInfo.ClientID%>').hide();
                                                    RefreshMainPage();
                                                },
                                                failure: function(err) {
                                                    Ext.Msg.alert('Error', err);
                                                }
                                            }
                                        );
                                    }
                                );
                            } else {
                                Coolite.AjaxMethods.SaveTrainInfo(
                                    isSendRemind,
                                    {
                                        success: function() {
                                            Ext.Msg.alert('Message', '保存成功！');
                                            Ext.getCmp('<%=this.WdwTrainInfo.ClientID%>').hide();
                                            RefreshMainPage();
                                        },
                                        failure: function(err) {
                                            Ext.Msg.alert('Error', err);
                                        }
                                    }
                                );
                            }
                        }
                    }
                );
            }
        }

        function DeleteTrainInfoById(trainId) {
            var rtnVal = Ext.getCmp('<%=this.IptRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.IptRtnMsg.ClientID%>');

            Coolite.AjaxMethods.CheckTrainInfo(
                trainId,
                {
                    success: function() {
                        Ext.Msg.confirm('Message', rtnMsg.getValue(),
                            function(e) {
                                if (e == 'yes') {
                                    Coolite.AjaxMethods.DeleteTrainInfo(
                                        trainId,
                                        {
                                            success: function() {
                                                Ext.Msg.alert('Message', '删除成功！');
                                                Ext.getCmp('<%=this.WdwTrainInfo.ClientID%>').hide();
                                                RefreshMainPage();
                                            },
                                            failure: function(err) {
                                                Ext.Msg.alert('Error', err);
                                            }
                                        }
                                    );
                                }
                            }
                        );
                    },
                    failure: function(err) {
                        Ext.Msg.alert('Error', err);
                    }
                }
            );
        }

        function DeleteTrainInfo() {
            var TrainId = Ext.getCmp('<%=this.IptTrainId.ClientID%>');
            DeleteTrainInfoById(TrainId.getValue());
        }

        function CloseTrainInfo() {
            var trainId = Ext.getCmp('<%=this.IptTrainId.ClientID%>');
            Coolite.AjaxMethods.DeleteTrainDraft(trainId.getValue(),
            {
                failure: function(err) {
                    Ext.Msg.alert('Error', err);
                }
            });
        }

        function SaveTrainOnlineSelfInfo() {
            var errMsg = "";

            var isFormValid = Ext.getCmp('<%=this.FrmTrainOnlineSelfInfo.ClientID%>').getForm().isValid();

            if (!isFormValid) {
                errMsg = "请填写完整在线学习信息";
            }

            if (errMsg != "") {
                Ext.Msg.alert('Message', errMsg);
            } else {
                var isSendRemind = 'False';
                if (Ext.getCmp('<%=this.IptIsNew.ClientID%>').getValue() == 'False') {
                    Ext.Msg.confirm('Message', "在线学习已更新，是否发送提醒？",
                        function(e) {
                            if (e == 'yes') {
                                isSendRemind = 'True';
                            }
                            Coolite.AjaxMethods.SaveTrainOnlineSelf(
                                isSendRemind,
                                {
                                    success: function() {
                                        Ext.Msg.alert('Message', '保存成功！');
                                        Ext.getCmp('<%=this.WdwTrainOnlineSelfInfo.ClientID%>').hide();
                                        Ext.getCmp('<%=this.RstTrainOnlineList.ClientID%>').reload();
                                    },
                                    failure: function(err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                            );
                        }
                    );
                } else {
                    Coolite.AjaxMethods.SaveTrainOnlineSelf(
                        isSendRemind,
                        {
                            success: function() {
                                Ext.Msg.alert('Message', '保存成功！');
                                Ext.getCmp('<%=this.WdwTrainOnlineSelfInfo.ClientID%>').hide();
                                Ext.getCmp('<%=this.RstTrainOnlineList.ClientID%>').reload();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                    );
                }
            }
        }

        function SaveTrainOnlineExamInfo() {
            var errMsg = "";

            var isFormValid = Ext.getCmp('<%=this.FrmTrainOnlineExamInfo.ClientID%>').getForm().isValid();

            if (!isFormValid) {
                errMsg = "请填写完整在线学习信息";
            } else {
                var examTime = GetFormatDay(Ext.getCmp('<%=this.IptTrainOnlineExamEndTime.ClientID%>').getValue());
                if (examTime < GetFormatDay(new Date())) {
                    errMsg = "截止时间不能小于今天";
                }
            }

            if (errMsg != "") {
                Ext.Msg.alert('Message', errMsg);
            } else {
                var isSendRemind = 'False';
                if (Ext.getCmp('<%=this.IptIsNew.ClientID%>').getValue() == 'False') {
                    Ext.Msg.confirm('Message', "在线学习已更新，是否发送提醒？",
                        function(e) {
                            if (e == 'yes') {
                                isSendRemind = 'True';
                            }
                            Coolite.AjaxMethods.SaveTrainOnlineExam(
                                isSendRemind,
                                {
                                    success: function() {
                                        Ext.Msg.alert('Message', '保存成功！');
                                        Ext.getCmp('<%=this.WdwTrainOnlineExamInfo.ClientID%>').hide();
                                        Ext.getCmp('<%=this.RstTrainOnlineList.ClientID%>').reload();
                                    },
                                    failure: function(err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                            );
                        }
                    );
                } else {
                    Coolite.AjaxMethods.SaveTrainOnlineExam(
                        isSendRemind,
                        {
                            success: function() {
                                Ext.Msg.alert('Message', '保存成功！');
                                Ext.getCmp('<%=this.WdwTrainOnlineExamInfo.ClientID%>').hide();
                                Ext.getCmp('<%=this.RstTrainOnlineList.ClientID%>').reload();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                    );
                }
            }
        }

        function SaveTrainClassInfo() {
            var errMsg = "";

            var isFormValid = Ext.getCmp('<%=this.FrmTrainClassInfo.ClientID%>').getForm().isValid();

            if (!isFormValid) {
                errMsg = "请填写完整面授培训信息";
            }

            if (errMsg != "") {
                Ext.Msg.alert('Message', errMsg);
            } else {
                var isSendRemind = 'False';
//                if (Ext.getCmp('<%=this.IptIsNew.ClientID%>').getValue() == 'False') {
//                    Ext.Msg.confirm('Message', "面授培训已更新，是否发送提醒？",
//                        function(e) {
//                            if (e == 'yes') {
//                                isSendRemind = 'True';
//                            }
//                            Coolite.AjaxMethods.SaveTrainClass(
//                                isSendRemind,
//                                {
//                                    success: function() {
//                                        Ext.Msg.alert('Message', '保存成功！');
//                                        Ext.getCmp('<%=this.WdwTrainClassInfo.ClientID%>').hide();
//                                        Ext.getCmp('<%=this.RstTrainClassList.ClientID%>').reload();
//                                    },
//                                    failure: function(err) {
//                                        Ext.Msg.alert('Error', err);
//                                    }
//                                }
//                            );
//                        }
//                    );
//                } else {
                    Coolite.AjaxMethods.SaveTrainClass(
                        isSendRemind,
                        {
                            success: function() {
                                Ext.Msg.alert('Message', '保存成功！');
                                Ext.getCmp('<%=this.WdwTrainClassInfo.ClientID%>').hide();
                                Ext.getCmp('<%=this.RstTrainClassList.ClientID%>').reload();
                            },
                            failure: function(err) {
                                Ext.Msg.alert('Error', err);
                            }
                        }
                    );
                //}
            }
        }

        function SaveManager(grid) {
            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();
                var param = '';

                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].data.ManagerId + ',';
                }

                Coolite.AjaxMethods.SaveManager(param);
            } else {
                Ext.MessageBox.alert('错误', '请选择要添加的培训经理');
            }
        }

        function SaveDealerSales(grid) {
            if (grid.hasSelection()) {
                var selList = grid.selModel.getSelections();
                var param = '';

                for (var i = 0; i < selList.length; i++) {
                    param += selList[i].data.DealerSalesId + ',';
                }

                Coolite.AjaxMethods.SaveDealerSales(
                    param,
                    {
                        success: function() {
                            Ext.getCmp('<%=this.RstDealerSalesList.ClientID%>').reload();
                        },
                        failure: function(err) {
                            Ext.Msg.alert('Error', err);
                        }
                    }
                );
            } else {
                Ext.MessageBox.alert('错误', '请选择要添加的销售员');
            }
        }

        function DeleteDealerSales(salesTrainId) {
            var rtnVal = Ext.getCmp('<%=this.IptRtnVal.ClientID%>');
            var rtnMsg = Ext.getCmp('<%=this.IptRtnMsg.ClientID%>');

            Coolite.AjaxMethods.CheckDealerSales(
                salesTrainId,
                {
                    success: function() {
                        Ext.Msg.confirm('Message', rtnMsg.getValue(),
                            function(e) {
                                if (e == 'yes') {
                                    Coolite.AjaxMethods.DeleteDealerSales(
                                        salesTrainId,
                                        {
                                            success: function() { Ext.getCmp('<%=this.RstSalesList.ClientID%>').reload(); },
                                            failure: function(err) { Ext.Msg.alert('Error', err); }
                                        }
                                    );
                                }
                            }
                        );
                    },
                    failure: function(err) {
                        Ext.Msg.alert('Error', err);
                    }
                }
            );
        }
    </script>

    <div id="DivStore">
        <ext:Store ID="StoTrainList" runat="server" UseIdConfirmation="false" OnRefreshData="StoTrainList_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="TrainId">
                    <Fields>
                        <ext:RecordField Name="TrainId" />
                        <ext:RecordField Name="TrainName" />
                        <ext:RecordField Name="TrainBu" />
                        <ext:RecordField Name="TrainStartTime" />
                        <ext:RecordField Name="TrainEndTime" />
                        <ext:RecordField Name="TrainArea" />
                        <ext:RecordField Name="IsSign" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoTrainBu" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="AttributeName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <SortInfo Field="Id" Direction="ASC" />
        </ext:Store>
        <ext:Store ID="StoTrainArea" runat="server" OnRefreshData="StoTrainArea_RefreshData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="AreaId">
                    <Fields>
                        <ext:RecordField Name="AreaId" />
                        <ext:RecordField Name="AreaName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler="#{IptTrainArea}.setValue(#{IptAreaValue}.getValue());" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="StoTrainAreaAll" runat="server" OnRefreshData="StoTrainAreaAll_RefreshData"
            AutoLoad="true">
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
        </ext:Store>
        <ext:Store ID="StoTrainOnlineType" runat="server" OnRefreshData="StoTrainOnlineType_RefreshData"
            AutoLoad="true">
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
        </ext:Store>
        <ext:Store ID="StoLecturerList" runat="server" OnRefreshData="StoLecturerList_RefreshData"
            AutoLoad="true">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="BscUserId">
                    <Fields>
                        <ext:RecordField Name="BscUserId" />
                        <ext:RecordField Name="UserName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoTrainOnlineList" runat="server" OnRefreshData="StoTrainOnlineList_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="TrainDetailId">
                    <Fields>
                        <ext:RecordField Name="TrainDetailId" />
                        <ext:RecordField Name="TrainType" />
                        <ext:RecordField Name="TrainContent1" />
                        <ext:RecordField Name="TrainContent2" />
                        <ext:RecordField Name="TrainContent3" />
                        <ext:RecordField Name="TrainContent4" />
                        <ext:RecordField Name="TrainContent5" />
                        <ext:RecordField Name="TrainContent6" />
                        <ext:RecordField Name="TrainContent7" />
                        <ext:RecordField Name="TrainContent8" />
                        <ext:RecordField Name="TrainContent9" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoTrainClassList" runat="server" OnRefreshData="StoTrainClassList_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="TrainDetailId">
                    <Fields>
                        <ext:RecordField Name="TrainDetailId" />
                        <ext:RecordField Name="TrainType" />
                        <ext:RecordField Name="TrainContent1" />
                        <ext:RecordField Name="TrainContent2" />
                        <ext:RecordField Name="TrainContent3" />
                        <ext:RecordField Name="TrainContent4" />
                        <ext:RecordField Name="TrainContent5" />
                        <ext:RecordField Name="TrainContent6" />
                        <ext:RecordField Name="TrainContent7" />
                        <ext:RecordField Name="TrainContent8" />
                        <ext:RecordField Name="TrainContent9" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoTrainManagerList" runat="server" OnRefreshData="StoTrainManagerList_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader>
                    <Fields>
                        <ext:RecordField Name="TrainId" />
                        <ext:RecordField Name="ManagerId" />
                        <ext:RecordField Name="UserName" />
                        <ext:RecordField Name="UserPhone" />
                        <ext:RecordField Name="UserEmail" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoManagerList" runat="server" OnRefreshData="StoManagerList_RefreshData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="ManagerId">
                    <Fields>
                        <ext:RecordField Name="ManagerId" />
                        <ext:RecordField Name="UserName" />
                        <ext:RecordField Name="UserPhone" />
                        <ext:RecordField Name="UserEmail" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoSalesList" runat="server" UseIdConfirmation="false" OnRefreshData="StoSalesList_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="SalesTrainId">
                    <Fields>
                        <ext:RecordField Name="SalesTrainId" />
                        <ext:RecordField Name="SalesId" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="SalesName" />
                        <ext:RecordField Name="SalesPhone" />
                        <ext:RecordField Name="SalesEmail" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Store ID="StoDealerSalesList" runat="server" UseIdConfirmation="false" OnRefreshData="StoDealerSalesList_RefershData"
            AutoLoad="false">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="DealerSalesId">
                    <Fields>
                        <ext:RecordField Name="DealerSalesId" />
                        <ext:RecordField Name="DealerId" />
                        <ext:RecordField Name="DealerName" />
                        <ext:RecordField Name="SalesName" />
                        <ext:RecordField Name="SalesPhone" />
                        <ext:RecordField Name="SalesEmail" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
    </div>
    <div id="DivHidden">
        <ext:Hidden ID="IptRtnVal" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptRtnMsg" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptIsNew" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptTrainId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptTrainOnlineId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptTrainClassId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptTrainPracticeId" runat="server">
        </ext:Hidden>
        <ext:Hidden ID="IptAreaValue" runat="server">
        </ext:Hidden>
    </div>
    <div id="DivView">
        <ext:ViewPort ID="WdwMain" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <North Collapsible="True" Split="True">
                        <ext:Panel ID="PnlSearch" runat="server" Header="true" Title="查询条件" Frame="true"
                            AutoHeight="true" Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel1" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout1" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="QryTrainBu" runat="server" EmptyText="请选择产品线…" Width="150" Editable="false"
                                                            TypeAhead="true" StoreID="StoTrainBu" ValueField="Id" DisplayField="AttributeName"
                                                            FieldLabel="产品线" ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="QryTrainName" runat="server" Width="150" FieldLabel="课程名称">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel2" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout2" runat="server">
                                                    <ext:Anchor>
                                                        <ext:DateField ID="QryTrainStartBeginTime" runat="server" Width="150" FieldLabel="课程起始开始时间" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="QryTrainStartEndTime" runat="server" Width="150" FieldLabel="课程终止开始时间" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".3">
                                        <ext:Panel ID="Panel3" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout3" runat="server">
                                                    <ext:Anchor>
                                                        <ext:DateField ID="QryTrainEndBeginTime" runat="server" Width="150" FieldLabel="课程起始结束时间" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="QryTrainEndEndTime" runat="server" Width="150" FieldLabel="课程终止结束时间" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="BtnSearch" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagTrainList}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="BtnAdd" runat="server" Text="新增" Icon="Add" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="
                                            Coolite.AjaxMethods.ShowTrainInfo(
                                                '00000000-0000-0000-0000-000000000000',
                                                {
                                                    success:function() {
                                                        #{RstTrainOnlineList}.clear();
                                                        #{RstTrainClassList}.clear();
                                                        #{RstTrainManagerList}.clear();
                                                        #{RstSalesList}.clear();
                                                        #{RstTrainOnlineList}.reload();
                                                        #{RstTrainClassList}.reload();
                                                        #{RstTrainManagerList}.reload();
                                                        #{RstSalesList}.reload();
                                                        #{WdwTrainInfo}.show();
                                                    },
                                                    failure:function(err) {
                                                        Ext.Msg.alert('Error', err);
                                                    }
                                                }
                                            );
                                        " />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center>
                        <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="RstTrainList" runat="server" Title="查询结果" StoreID="StoTrainList"
                                        Border="false" Icon="Lorry" StripeRows="true">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="TrainName" DataIndex="TrainName" Header="课程名称" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="TrainBu" DataIndex="TrainBu" Header="产品线" Width="150">
                                                    <Renderer Handler="return getNameFromStoreById(StoTrainBu,{Key:'Id',Value:'AttributeName'},value);" />
                                                </ext:Column>
                                                <ext:Column ColumnID="TrainStartTime" DataIndex="TrainStartTime" Header="开始时间">
                                                </ext:Column>
                                                <ext:Column ColumnID="TrainEndTime" DataIndex="TrainEndTime" Header="终止时间">
                                                </ext:Column>
                                                <ext:Column ColumnID="TrainArea" DataIndex="TrainArea" Header="区域" Width="150">
                                                    <Renderer Handler="return getNameFromStoreById(StoTrainAreaAll,{Key:'Key',Value:'Value'},value);" />
                                                </ext:Column>
                                                <ext:CheckColumn ColumnID="IsSign" DataIndex="IsSign" Header="是否被签约" Align="Center">
                                                </ext:CheckColumn>
                                                <ext:CommandColumn Width="50" Header="操作" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                            <ToolTip Text="查看" />
                                                        </ext:GridCommand>
                                                        <ext:CommandSeparator />
                                                        <ext:GridCommand Icon="BulletCross" CommandName="Delete">
                                                            <ToolTip Text="删除" />
                                                        </ext:GridCommand>
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                        </SelectionModel>
                                        <Listeners>
                                            <Command Handler="
                                                if (command == 'Edit') {
                                                    Coolite.AjaxMethods.ShowTrainInfo(
                                                        record.data.TrainId,
                                                        {
                                                            success: function() {
                                                                #{RstTrainOnlineList}.clear();
                                                                #{RstTrainClassList}.clear();
                                                                #{RstTrainManagerList}.clear();
                                                                #{RstSalesList}.clear();
                                                                #{RstTrainOnlineList}.reload();
                                                                #{RstTrainClassList}.reload();
                                                                #{RstTrainManagerList}.reload();
                                                                #{RstSalesList}.reload();
                                                                #{IptTrainArea}.store.reload();
                                                                #{WdwTrainInfo}.show();
                                                            },
                                                            failure: function(err) {
                                                                Ext.Msg.alert('Error', err);
                                                            }
                                                        }
                                                    );
                                                } if (command == 'Delete') {
                                                    DeleteTrainInfoById(record.data.TrainId);
                                                }
                                            " />
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagTrainList" runat="server" PageSize="15" StoreID="StoTrainList"
                                                DisplayInfo="true" EmptyMsg="没有数据显示" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中…" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>
        <ext:Window ID="WdwTrainInfo" runat="server" Icon="Group" Title="培训课程" Resizable="false"
            Header="false" Width="800" Height="500" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:BorderLayout ID="BorderLayout2" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:FormPanel ID="FrmTrainInfo" runat="server" Header="false" Frame="true" AutoHeight="true">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel11" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout8" runat="server">
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="IptTrainBu" runat="server" EmptyText="请选择产品线…" Width="200" Editable="false"
                                                            TypeAhead="true" StoreID="StoTrainBu" ValueField="Id" AllowBlank="false" DisplayField="AttributeName"
                                                            FieldLabel="产品线" ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <Select Handler="#{IptTrainArea}.clearValue(); #{StoTrainArea}.reload(); " />
                                                                <TriggerClick Handler="this.clearValue(); #{IptTrainArea}.clearValue(); #{StoTrainArea}.reload();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="IptTrainStartTime" runat="server" FieldLabel="课程起始时间" Width="200"
                                                            AllowBlank="false" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextArea ID="IptTrainDesc" runat="server" FieldLabel="课程介绍" Width="200">
                                                        </ext:TextArea>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel4" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout4" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptTrainName" runat="server" FieldLabel="课程名称" AllowBlank="false"
                                                            Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="IptTrainEndTime" runat="server" FieldLabel="课程终止时间" AllowBlank="false"
                                                            Width="200" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="IptTrainArea" runat="server" EmptyText="请选择区域…" Width="200" Editable="false"
                                                            AllowBlank="false" TypeAhead="true" StoreID="StoTrainArea" ValueField="AreaId"
                                                            DisplayField="AreaName" FieldLabel="区域" ListWidth="300" Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:FormPanel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:TabPanel ID="TabPanel1" runat="server" Plain="true">
                            <Tabs>
                                <ext:Tab ID="TabOnline" runat="server" TabIndex="0" Title="在线学习">
                                    <Body>
                                        <ext:FitLayout ID="FTHeader" runat="server">
                                            <ext:GridPanel ID="RstTrainOnlineList" runat="server" Title="在线学习" StoreID="StoTrainOnlineList"
                                                StripeRows="true" Border="false" Icon="Lorry" Header="false">
                                                <TopBar>
                                                    <ext:Toolbar ID="Toolbar1" runat="server">
                                                        <Items>
                                                            <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                            <ext:Button ID="BtnAddTrainOnlineSelf" runat="server" Text="添加自学" Icon="Add">
                                                                <Listeners>
                                                                    <Click Handler="
                                                                        if (#{IptTrainId}.getValue() == '') {
                                                                            alert('请等待数据加载完毕！');
                                                                        } else {
                                                                            Coolite.AjaxMethods.ShowTrainOnlineSelfInfo(''); 
                                                                        }" />
                                                                </Listeners>
                                                            </ext:Button>
                                                            <ext:Button ID="BtnAddTrainOnlineExam" runat="server" Text="添加考试" Icon="Add">
                                                                <Listeners>
                                                                    <Click Handler="
                                                                        if (#{IptTrainId}.getValue() == '') {
                                                                            alert('请等待数据加载完毕！');
                                                                        } else {
                                                                            Coolite.AjaxMethods.ShowTrainOnlineExamInfo(''); 
                                                                        }" />
                                                                </Listeners>
                                                            </ext:Button>
                                                        </Items>
                                                    </ext:Toolbar>
                                                </TopBar>
                                                <ColumnModel ID="ColumnModel2" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="TrainContent1" DataIndex="TrainContent1" Header="在线学习类型">
                                                            <Renderer Handler="return getNameFromStoreById(StoTrainOnlineType,{Key:'Key',Value:'Value'},value);" />
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TrainContent2" DataIndex="TrainContent2" Header="学习内容">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TrainContent3" DataIndex="TrainContent3" Header="学习方法">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TrainContent4" DataIndex="TrainContent4" Header="截止时间" Align="Right">
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="80" Header="操作" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                                    <ToolTip Text="修改" />
                                                                </ext:GridCommand>
                                                                <ext:CommandSeparator />
                                                                <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                                    <ToolTip Text="删除" />
                                                                </ext:GridCommand>
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" />
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagTrainOnlineList" runat="server" PageSize="10" StoreID="StoTrainOnlineList"
                                                        DisplayInfo="true" />
                                                </BottomBar>
                                                <Listeners>
                                                    <Command Handler="
                                                        if (command == 'Delete') {
                                                            Ext.Msg.confirm('Message', '确认删除当前信息？',
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.RemoveTrainOnline(
                                                                            record.data.TrainDetailId,
                                                                            {
                                                                                success:function() {
                                                                                    #{RstTrainOnlineList}.reload();
                                                                                },
                                                                                failure:function(err) {
                                                                                    Ext.Msg.alert('Error', err);
                                                                                }
                                                                            }
                                                                        );
                                                                    }
                                                                }
                                                            );
                                                        } else if (command == 'Edit') {
                                                            if (record.data.TrainContent1 == 'Self') {
                                                                Coolite.AjaxMethods.ShowTrainOnlineSelfInfo(record.data.TrainDetailId);
                                                            } else {
                                                                Coolite.AjaxMethods.ShowTrainOnlineExamInfo(record.data.TrainDetailId);
                                                            }
                                                        }
                                                    " />
                                                </Listeners>
                                                <SaveMask ShowMask="false" />
                                                <LoadMask ShowMask="false" />
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>
                                <ext:Tab ID="TabClass" runat="server" Title="面授培训">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout2" runat="server">
                                            <ext:GridPanel ID="RstTrainClassList" runat="server" Title="面授培训" StoreID="StoTrainClassList"
                                                StripeRows="true" Border="false" Icon="Lorry" Header="false">
                                                <TopBar>
                                                    <ext:Toolbar ID="Toolbar2" runat="server">
                                                        <Items>
                                                            <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                            <ext:Button ID="BtnAddTrainClass" runat="server" Text="添加" Icon="Add">
                                                                <Listeners>
                                                                    <Click Handler="
                                                                        if (#{IptTrainId}.getValue() == '') {
                                                                            alert('请等待数据加载完毕！');
                                                                        } else { 
                                                                            Coolite.AjaxMethods.ShowTrainClassInfo(''); 
                                                                        }
                                                                    " />
                                                                </Listeners>
                                                            </ext:Button>
                                                        </Items>
                                                    </ext:Toolbar>
                                                </TopBar>
                                                <ColumnModel ID="ColumnModel3" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="TrainContent1" DataIndex="TrainContent1" Header="课程名称">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TrainContent2" DataIndex="TrainContent2" Header="培训介绍">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="TrainContent3" DataIndex="TrainContent3" Header="培训讲师">
                                                            <Renderer Handler="return getNameFromStoreById(StoLecturerList,{Key:'BscUserId',Value:'UserName'},value);" />
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="80" Header="操作" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                                    <ToolTip Text="修改" />
                                                                </ext:GridCommand>
                                                                <ext:CommandSeparator />
                                                                <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                                    <ToolTip Text="删除" />
                                                                </ext:GridCommand>
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel3" runat="server" />
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagTrainClassList" runat="server" PageSize="10" StoreID="StoTrainClassList"
                                                        DisplayInfo="true" />
                                                </BottomBar>
                                                <Listeners>
                                                    <Command Handler="
                                                        if (command == 'Delete') {
                                                            Ext.Msg.confirm('Message', '确认删除当前信息？',
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.RemoveTrainClass(
                                                                            record.data.TrainDetailId,
                                                                            {
                                                                                success:function() {
                                                                                    #{RstTrainClassList}.reload();
                                                                                },
                                                                                failure:function(err) {
                                                                                    Ext.Msg.alert('Error', err);
                                                                                }
                                                                            }
                                                                        );
                                                                    }
                                                                }
                                                            );
                                                        } else if (command == 'Edit') {
                                                            Coolite.AjaxMethods.ShowTrainClassInfo(record.data.TrainDetailId);
                                                        }
                                                    " />
                                                </Listeners>
                                                <SaveMask ShowMask="false" />
                                                <LoadMask ShowMask="false" />
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>
                                <ext:Tab ID="TabPractice" runat="server" Title="跟台实践" BodyStyle="padding: 6px;">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout3" runat="server">
                                            <ext:FormPanel ID="FrmPractice" runat="server" Header="false" Border="false">
                                                <Body>
                                                    <ext:ColumnLayout ID="ColumnLayout5" runat="server" Split="false">
                                                        <ext:LayoutColumn ColumnWidth="0.4">
                                                            <ext:Panel ID="Panel6" runat="server" Border="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout6" runat="server">
                                                                        <ext:Anchor>
                                                                            <ext:NumberField ID="IptTrainPracticeCount" runat="server" FieldLabel="共需填写">
                                                                            </ext:NumberField>
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:Panel>
                                                        </ext:LayoutColumn>
                                                        <ext:LayoutColumn ColumnWidth="0.3">
                                                            <ext:Panel ID="Panel7" runat="server" Border="false">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout7" runat="server">
                                                                        <ext:Anchor>
                                                                            <ext:Label ID="Label1" runat="server" HideLabel="true" Text="次跟台任务">
                                                                            </ext:Label>
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
                                <ext:Tab ID="TabManager" runat="server" Title="培训经理">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout4" runat="server">
                                            <ext:GridPanel ID="RstTrainManagerList" runat="server" Title="培训经理" StoreID="StoTrainManagerList"
                                                StripeRows="true" Border="false" Icon="Lorry" Header="false">
                                                <TopBar>
                                                    <ext:Toolbar ID="Toolbar3" runat="server">
                                                        <Items>
                                                            <ext:ToolbarFill ID="ToolbarFill3" runat="server" />
                                                            <ext:Button ID="BtnAddTrainManager" runat="server" Text="添加" Icon="Add">
                                                                <Listeners>
                                                                    <Click Handler="
                                                                        if (#{IptTrainId}.getValue() == '') {
                                                                            alert('请等待数据加载完毕！');
                                                                        } else { 
                                                                            #{QryManagerName}.setValue('');
                                                                            #{WdwManagerList}.show();
                                                                            #{RstManagerList}.clear();
                                                                        }
                                                                    " />
                                                                </Listeners>
                                                            </ext:Button>
                                                        </Items>
                                                    </ext:Toolbar>
                                                </TopBar>
                                                <ColumnModel ID="ColumnModel4" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="UserName" DataIndex="UserName" Header="姓名">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UserPhone" DataIndex="UserPhone" Header="联系电话">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="UserEmail" DataIndex="UserEmail" Header="邮箱">
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="40" Header="操作" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                                    <ToolTip Text="删除" />
                                                                </ext:GridCommand>
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel4" runat="server" />
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagTrainManagerList" runat="server" PageSize="10" StoreID="StoTrainManagerList"
                                                        DisplayInfo="true" />
                                                </BottomBar>
                                                <Listeners>
                                                    <Command Handler="
                                                        if (command == 'Delete') {
                                                            Ext.Msg.confirm('Message', '确认删除当前信息？',
                                                                function(e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.RemoveManager(
                                                                            record.data.TrainId,
                                                                            record.data.ManagerId,
                                                                            {
                                                                                success:function() {
                                                                                    #{RstTrainManagerList}.reload();
                                                                                },
                                                                                failure:function(err) {
                                                                                    Ext.Msg.alert('Error', err);
                                                                                }
                                                                            }
                                                                        );
                                                                    }
                                                                }
                                                            );
                                                        }
                                                    " />
                                                </Listeners>
                                                <SaveMask ShowMask="false" />
                                                <LoadMask ShowMask="false" />
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>
                                <ext:Tab ID="TabSales" runat="server" Title="签约销售">
                                    <Body>
                                        <ext:FitLayout ID="FitLayout6" runat="server">
                                            <ext:GridPanel ID="RstSalesList" runat="server" Title="签约销售" StoreID="StoSalesList"
                                                StripeRows="true" Border="false" Icon="Lorry" Header="false">
                                                <TopBar>
                                                    <ext:Toolbar ID="Toolbar4" runat="server">
                                                        <Items>
                                                            <ext:ToolbarFill ID="ToolbarFill4" runat="server" />
                                                            <ext:Button ID="BtnAddSales" runat="server" Text="添加" Icon="Add">
                                                                <Listeners>
                                                                    <Click Handler="
                                                                        if (#{IptTrainId}.getValue() == '') {
                                                                            alert('请等待数据加载完毕！');
                                                                        } else { 
                                                                            #{QryDealerName}.setValue('');
                                                                            #{QrySalesName}.setValue('');
                                                                            #{WdwDealerSales}.show();
                                                                            #{RstDealerSalesList}.clear();
                                                                        }
                                                                    " />
                                                                </Listeners>
                                                            </ext:Button>
                                                        </Items>
                                                    </ext:Toolbar>
                                                </TopBar>
                                                <ColumnModel ID="ColumnModel6" runat="server">
                                                    <Columns>
                                                        <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="SalesName" DataIndex="SalesName" Header="销售姓名">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="SalesPhone" DataIndex="SalesPhone" Header="联系电话">
                                                        </ext:Column>
                                                        <ext:Column ColumnID="SalesEmail" DataIndex="SalesEmail" Header="邮箱" Width="200">
                                                        </ext:Column>
                                                        <ext:CommandColumn Width="40" Header="操作" Align="Center">
                                                            <Commands>
                                                                <ext:GridCommand Icon="Delete" CommandName="Delete">
                                                                    <ToolTip Text="删除" />
                                                                </ext:GridCommand>
                                                            </Commands>
                                                        </ext:CommandColumn>
                                                    </Columns>
                                                </ColumnModel>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel5" runat="server" />
                                                </SelectionModel>
                                                <BottomBar>
                                                    <ext:PagingToolbar ID="PagSalesList" runat="server" PageSize="10" StoreID="StoSalesList"
                                                        DisplayInfo="true" />
                                                </BottomBar>
                                                <Listeners>
                                                    <Command Handler="
                                                        if (command == 'Delete') {
                                                            DeleteDealerSales(record.data.SalesTrainId);
                                                        }
                                                    " />
                                                </Listeners>
                                                <SaveMask ShowMask="false" />
                                                <LoadMask ShowMask="false" />
                                            </ext:GridPanel>
                                        </ext:FitLayout>
                                    </Body>
                                </ext:Tab>
                            </Tabs>
                        </ext:TabPanel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="BtnSaveTrain" runat="server" Text="提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="SaveTrainInfo();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnRemoveTrain" runat="server" Text="删除" Icon="Delete">
                    <Listeners>
                        <Click Handler="DeleteTrainInfo();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnCloseTrain" runat="server" Text="关闭" Icon="LorryAdd">
                    <Listeners>
                        <Click Handler="#{WdwTrainInfo}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Handler="CloseTrainInfo()" />
            </Listeners>
        </ext:Window>
        <ext:Window ID="WdwTrainOnlineSelfInfo" runat="server" Icon="Group" Title="在线学习维护"
            Resizable="false" Header="false" Width="390" AutoHeight="true" AutoShow="false"
            Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout22" runat="server">
                    <ext:Anchor>
                        <ext:FormPanel ID="FrmTrainOnlineSelfInfo" runat="server" BodyBorder="false" Header="false"
                            BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout13" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel41" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout23" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:Label ID="IptTrainOnlineSelfType" runat="server" Width="220" FieldLabel="在线学习类型"
                                                            Text="自学" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptTrainOnlineSelfName" runat="server" FieldLabel="学习内容" AllowBlank="false"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptTrainOnlineSelfContent" runat="server" FieldLabel="学习方法" AllowBlank="false"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:FormPanel>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Buttons>
                <ext:Button ID="BtnSaveTrainOnlineSelf" runat="server" Text="提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="SaveTrainOnlineSelfInfo();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnCancelTrainOnlineSelf" runat="server" Text="返回" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{WdwTrainOnlineSelfInfo}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Window ID="WdwTrainOnlineExamInfo" runat="server" Icon="Group" Title="在线学习维护"
            Resizable="false" Header="false" Width="390" AutoHeight="true" AutoShow="false"
            Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout13" runat="server">
                    <ext:Anchor>
                        <ext:FormPanel ID="FrmTrainOnlineExamInfo" runat="server" BodyBorder="false" Header="false"
                            BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel14" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout14" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:Label ID="Label2" runat="server" Width="220" FieldLabel="在线学习类型" Text="考试" />
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptTrainOnlineExamName" runat="server" FieldLabel="考试内容" AllowBlank="false"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptTrainOnlineExamContent" runat="server" FieldLabel="考试方法" AllowBlank="false"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:DateField ID="IptTrainOnlineExamEndTime" runat="server" Width="220" FieldLabel="截止时间"
                                                            AllowBlank="false" />
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:FormPanel>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Buttons>
                <ext:Button ID="BtnSaveTrainOnlineExam" runat="server" Text="提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="SaveTrainOnlineExamInfo();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnCancelTrainOnlineExam" runat="server" Text="返回" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{WdwTrainOnlineExamInfo}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Window ID="WdwTrainClassInfo" runat="server" Icon="Group" Title="面授培训维护" Resizable="false"
            Header="false" Width="390" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:FormLayout ID="FormLayout9" runat="server">
                    <ext:Anchor>
                        <ext:FormPanel ID="FrmTrainClassInfo" runat="server" BodyBorder="false" Header="false"
                            BodyStyle="padding:5px;">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout3" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel9" runat="server" Border="false">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="100">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptTrainClassName" runat="server" FieldLabel="课程名称" AllowBlank="false"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:TextField ID="IptTrainClassDesc" runat="server" FieldLabel="培训介绍" AllowBlank="false"
                                                            Width="220">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                    <ext:Anchor>
                                                        <ext:ComboBox ID="IptTrainClassLecturer" runat="server" EmptyText="请选择培训讲师…" Width="220"
                                                            Editable="false" AllowBlank="false" TypeAhead="true" StoreID="StoLecturerList"
                                                            ValueField="BscUserId" DisplayField="UserName" FieldLabel="培训讲师" ListWidth="220"
                                                            Resizable="true">
                                                            <Triggers>
                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                            </Triggers>
                                                            <Listeners>
                                                                <TriggerClick Handler="this.clearValue();" />
                                                            </Listeners>
                                                        </ext:ComboBox>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                        </ext:FormPanel>
                    </ext:Anchor>
                </ext:FormLayout>
            </Body>
            <Buttons>
                <ext:Button ID="BtnSaveTrainClass" runat="server" Text="提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="SaveTrainClassInfo();" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnCancelTrainClass" runat="server" Text="返回" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{WdwTrainClassInfo}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
        <ext:Window ID="WdwManagerList" runat="server" Icon="Group" Title="选择培训经理" Resizable="false"
            Header="false" Width="750" Height="400" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:BorderLayout ID="BorderLayout3" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel5" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout4" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel8" runat="server" Border="false" AutoHeight="true">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout5" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="QryManagerName" runat="server" FieldLabel="姓名" Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="BtnQueryManager" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagManagerList}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout5" runat="server">
                                    <ext:GridPanel ID="RstManagerList" runat="server" Title="签约销售" StoreID="StoManagerList"
                                        StripeRows="true" Border="false" Icon="Lorry" Header="false">
                                        <ColumnModel ID="ColumnModel5" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="UserName" DataIndex="UserName" Header="姓名" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserPhone" DataIndex="UserPhone" Header="联系电话" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="UserEmail" DataIndex="UserEmail" Header="邮箱" Width="200">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                                <Listeners>
                                                </Listeners>
                                            </ext:CheckboxSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagManagerList" runat="server" PageSize="10" StoreID="StoManagerList"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="false" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:FormPanel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="BtnSaveManager" runat="server" Text="提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="SaveManager(#{RstManagerList});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnCancelManager" runat="server" Text="返回" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{WdwManagerList}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Handler="#{PagTrainManagerList}.changePage(1);" />
            </Listeners>
        </ext:Window>
        <ext:Window ID="WdwDealerSales" runat="server" Icon="Group" Title="选择销售人员" Resizable="false"
            Header="false" Width="750" Height="400" AutoShow="false" Modal="true" ShowOnLoad="false"
            BodyStyle="padding:5px;">
            <Body>
                <ext:BorderLayout ID="BorderLayout4" runat="server">
                    <North MarginsSummary="5 5 5 5" Collapsible="true">
                        <ext:Panel ID="Panel10" runat="server" Header="true" Title="查询条件" Frame="true" AutoHeight="true"
                            Icon="Find">
                            <Body>
                                <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel12" runat="server" Border="false" AutoHeight="true">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout11" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="QryDealerName" runat="server" FieldLabel="经销商" Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                    <ext:LayoutColumn ColumnWidth=".5">
                                        <ext:Panel ID="Panel13" runat="server" Border="false" AutoHeight="true">
                                            <Body>
                                                <ext:FormLayout ID="FormLayout12" runat="server">
                                                    <ext:Anchor>
                                                        <ext:TextField ID="QrySalesName" runat="server" FieldLabel="销售" Width="200">
                                                        </ext:TextField>
                                                    </ext:Anchor>
                                                </ext:FormLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutColumn>
                                </ext:ColumnLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="BtnQueryDealerSales" Text="查询" runat="server" Icon="ArrowRefresh"
                                    IDMode="Legacy">
                                    <Listeners>
                                        <Click Handler="#{PagDealerSalesList}.changePage(1);" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </North>
                    <Center MarginsSummary="0 5 5 5">
                        <ext:FormPanel ID="FormPanel1" runat="server" Header="false" Border="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout7" runat="server">
                                    <ext:GridPanel ID="RstDealerSalesList" runat="server" Title="签约销售" StoreID="StoDealerSalesList"
                                        StripeRows="true" Border="false" Icon="Lorry" Header="false">
                                        <ColumnModel ID="ColumnModel7" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="DealerName" DataIndex="DealerName" Header="经销商" Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesName" DataIndex="SalesName" Header="姓名" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesPhone" DataIndex="SalesPhone" Header="联系电话" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="SalesEmail" DataIndex="SalesEmail" Header="邮箱" Width="200">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server">
                                                <Listeners>
                                                </Listeners>
                                            </ext:CheckboxSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagDealerSalesList" runat="server" PageSize="10" StoreID="StoDealerSalesList"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="false" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:FormPanel>
                    </Center>
                </ext:BorderLayout>
            </Body>
            <Buttons>
                <ext:Button ID="BtnSaveDealerSales" runat="server" Text="提交" Icon="Tick">
                    <Listeners>
                        <Click Handler="SaveDealerSales(#{RstDealerSalesList});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="BtnCancelDealerSales" runat="server" Text="返回" Icon="Delete">
                    <Listeners>
                        <Click Handler="#{WdwDealerSales}.hide();" />
                    </Listeners>
                </ext:Button>
            </Buttons>
            <Listeners>
                <BeforeHide Handler="#{PagSalesList}.changePage(1);" />
            </Listeners>
        </ext:Window>
    </div>
    </form>

    <script language="javascript" type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
