<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TenderAuthorizationInfo.aspx.cs" Inherits="DMS.Website.Pages.Contract.TenderAuthorizationInfo" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Register Src="../../Controls/HospitalSearchDialog.ascx" TagName="HospitalSearchDialog" TagPrefix="uc1" %>
<%@ Import Namespace="DMS.Model.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />

    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>

    <script src="../../resources/Calculate.js" type="text/javascript"></script>

    <script src="../../resources/data-view-plugins.js" type="text/javascript"></script>

    <style type="text/css">
        .x-form-empty-field {
            color: #bbbbbb;
            font: normal 11px arial, tahoma, helvetica, sans-serif;
        }

        .x-small-editor .x-form-field {
            font: normal 11px arial, tahoma, helvetica, sans-serif;
        }

        .x-small-editor .x-form-text {
            height: 20px;
            line-height: 16px;
            vertical-align: middle;
        }

        .editable-column {
            background: #FFFF99;
        }

        .nonEditable-column {
            background: #FFFFFF;
        }

        .yellow-row {
            background: #FFD700;
        }

        .lightyellow-row {
            background: #FFFFD8;
        }

        .x-panel-body {
            background-color: #dfe8f6;
        }

        .x-column-inner {
            height: auto !important;
            width: auto !important;
        }

        .list-item {
            font: normal 11px tahoma, arial, helvetica, sans-serif;
            padding: 3px 10px 3px 10px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #555;
        }

        .images-view .x-panel-body {
            background: white;
            font: 11px Arial, Helvetica, sans-serif;
        }

        .images-view .thumb {
            background: #dddddd;
            padding: 3px;
            height: 80px;
            width: 150px;
        }

            .images-view .thumb img {
                height: 80px;
                width: 150px;
            }

        .images-view .thumb-wrap {
            float: left;
            margin: 4px;
            margin-right: 0;
            padding: 5px;
            text-align: center;
            height: 120px;
            width: 160px;
        }

            .images-view .thumb-wrap span {
                display: block;
                overflow: hidden;
                text-align: center;
            }

        .images-view .x-view-over {
            border: 1px solid #dddddd;
            background: #efefef repeat-x left top;
            padding: 4px;
        }

        .images-view .x-view-selected {
            background: #eff5fb;
            border: 1px solid #99bbe8 no-repeat right bottom;
            padding: 4px;
        }

            .images-view .x-view-selected .thumb {
                background: transparent;
            }

        .images-view .loading-indicator {
            font-size: 11px;
            background-image: url(../../resources/images/loading.gif);
            background-repeat: no-repeat;
            background-position: left;
            padding-left: 20px;
            margin: 10px;
        }

        .txtRed {
            color: Red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />

        <script type="text/javascript">
            function Sup_SuperiorDealer() {
                var SuperiorDealer = Ext.getCmp('<%=this.SuperiorDealer.ClientID%>');
                var cbDealerType = Ext.getCmp('<%=this.cbDealerType.ClientID%>');
                var isModified = Ext.getCmp('<%=this.hidStates.ClientID%>')
                if (cbDealerType.getValue() == 'T2') {
                    SuperiorDealer.show();
                } else {
                    SuperiorDealer.hide();

                }
            }
            var selectedHospital = function (grid, row, record) {
                var massage = validateForm();
                if (massage == null || massage == '') {
                    <%= hidDthId.ClientID %>.setValue(record.data["Id"]);
            var btndel = Ext.getCmp("btnDeleteHospital");
            var txtStates = Ext.getCmp('<%=this.hidStates.ClientID%>').getValue();
            if (btndel != null && (txtStates == "Draft" || txtStates == "Deny"))
                btndel.enable();

            Ext.getCmp("gpProduct").reload();
                }
                else
            {
                Ext.Msg.alert("Error", massage)
            }
            }

            var showHospitalSelectorDlg = function () {
                var massage = validateForm();

                if (massage == null || massage == '') {
                    var product = <%= cbProductLine.ClientID %>.getValue();
                    if (product == null || product == "")
                        Ext.Msg.alert('提醒', '请选择授权产品分类!');
                    else
                        openHospitalSearchDlg(product);

                } else {
                    Ext.Msg.alert("Error", massage)
                }
            }

            var addItems = function (grid) {
                if (grid.hasSelection()) {
                    var selList = grid.selModel.getSelections();
                    var param = '';

                    for (var i = 0; i < selList.length; i++) {
                        param += selList[i].data.CaId + ',';
                    }

                    Coolite.AjaxMethods.addProduct(param, {
                        success: function () {
                            Ext.getCmp('<%=this.gpProduct.ClientID%>').reload();
                            <%=authorizationProductWindow.ClientID%>.hide(null);
                    },
                        failure: function (err) {
                            Ext.Msg.alert('Error', err);
                        }
                    });


            } else {
                Ext.MessageBox.alert('错误', '请选择医院');
                }
            }



            function validateForm() {
                var errMsg = "";
                var cbProductLine = Ext.getCmp('<%=this.cbProductLine.ClientID%>');
                var cbWdSubBU = Ext.getCmp('<%=this.cbWdSubBU.ClientID%>');
                var cbDealerType = Ext.getCmp('<%=this.cbDealerType.ClientID%>');
                var AuthorizationInfo = Ext.getCmp('<%=this.AuthorizationInfo.ClientID%>');
                var superiorDealer = Ext.getCmp('<%=this.SuperiorDealer.ClientID%>');
                var atuBeginDate = Ext.getCmp('<%=this.AtuBeginDate.ClientID%>');
                var atuEndDate = Ext.getCmp('<%=this.AtuEndDate.ClientID%>');
                var atuDealerName = Ext.getCmp('<%=this.AtuDealerName.ClientID%>');
                var atuRemark = Ext.getCmp('<%=this.AtuRemark.ClientID%>');
                var atuMailAddress = Ext.getCmp('<%=this.AtuMailAddress.ClientID%>');
                var startTime = new Date(Date.parse(atuBeginDate.getValue())).getTime();
                var endTime = new Date(Date.parse(atuEndDate.getValue())).getTime();
                var beginyear = new Date(atuBeginDate.getValue())
                var endyear = new Date(atuEndDate.getValue())
                var dates = Math.abs((startTime - endTime)) / (1000 * 60 * 60 * 24);
                atuBeginDate.getValue();
                if (cbProductLine.getValue() == null || cbProductLine.getValue() == '') {
                    errMsg += "请选择产品线信息<br/>"
                }
                if (cbWdSubBU.getValue() == null || cbWdSubBU.getValue() == '') {
                    errMsg += "请选择SubBU<br/>"
                }
                if (cbDealerType.getValue() == null || cbDealerType.getValue() == '') {
                    errMsg += "请选择经销商类型<br/>"
                }
                if (AuthorizationInfo.getValue() == null || AuthorizationInfo.getValue() == '') {
                    errMsg += "请选择授权类型<br/>"
                }
                if (atuBeginDate.getValue() == null || atuBeginDate.getValue() == '') {
                    errMsg += "请填写授权开始时间<br/>"
                }
                if (atuEndDate.getValue() == null || atuEndDate.getValue() == '') {
                    errMsg += "请填写授权终止时间<br/>"
                }
                if (atuBeginDate.getValue() != null && atuBeginDate.getValue() != '' && atuEndDate.getValue() != null && atuEndDate.getValue() != '' && atuBeginDate.getValue() > atuEndDate.getValue()) {
                    errMsg += "授权终止时间必须大于授权开始时间<br/>"
                }
                if (atuDealerName.getValue() == null || atuDealerName.getValue() == '') {
                    errMsg += "请填写经销商名称<br/>"
                }
                if (startTime != null && endTime != null) {
                    if (dates > 90 && (atuRemark.getValue() == null || atuRemark.getValue() == '')) {
                        errMsg += "授权时间大于90天，需填写备注信息<br/>"
                    }
                }
                if ((atuRemark.getValue() == null || atuRemark.getValue() == '') && beginyear.getFullYear() != endyear.getFullYear() && atuBeginDate.getValue() != null && atuEndDate.getValue() != null && atuBeginDate.getValue()!=''&& atuEndDate.getValue() != '') {
                    errMsg += "授权时间跨年，请填写备注信息<br/>"
                }

                if (cbDealerType.getValue() == "T2" && superiorDealer.getValue() == '') {
                    errMsg += "请选择上级平台商<br/>"
                }
                return errMsg;
            }

            var NeedSave = function () {
                var isModified = Ext.getCmp('<%=this.hidStates.ClientID%>').getValue() == "Draft" ? true : false;
                var isNewPage = Ext.getCmp('<%=this.hidStates.ClientID%>').getValue() == "True" ? true : false;
                if (isModified) {
                    Ext.Msg.confirm('Warning', '是否保存当前草稿单',
                        function (e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.SaveDraft(
                                    {
                                        success: function () {
                                            window.location.href = '/Pages/Contract/TenderAuthorizationList.aspx';
                                        },
                                        failure: function (err) {
                                            Ext.Msg.alert('Error', err);
                                        }
                                    });
                            } else {
                                if (isNewPage) {
                                    Coolite.AjaxMethods.DeleteDraft(
                                        {
                                            success: function () {
                                                window.location.href = '/Pages/Contract/TenderAuthorizationList.aspx';
                                            },
                                            failure: function (err) {
                                                Ext.Msg.alert('Error', err);
                                            }
                                        });
                                }
                                else {
                                    window.location.href = '/Pages/Contract/TenderAuthorizationList.aspx';
                                }
                            }
                        });
                } else {
                    window.location.href = '/Pages/Contract/TenderAuthorizationList.aspx';
                }
                return false;
            }

            var DoSubmint = function () {
                var massage = validateForm();
                if (massage == null || massage == '') {
                    Coolite.AjaxMethods.checkAttachment({
                        success: function (result) {
                            if (result == 'success') {
                                Ext.Msg.confirm('Message', "是否确认提交审批？",
                                    function (e) {
                                        if (e == 'yes') {

                                            Coolite.AjaxMethods.SaveSubmint(
                                                {
                                                    success: function () {
                                                        Ext.Msg.confirm('Success', '保存成功，是否返回查询页面？', function (e) { if (e == 'yes') { window.location.href = '/Pages/Contract/TenderAuthorizationList.aspx'; } });
                                                    },
                                                    failure: function (err) {
                                                        Ext.Msg.alert('Error', err);
                                                    }
                                                }
                                            );

                                        }
                                    }
                                );
                            }
                            else {
                                Ext.Msg.alert('Error', '公司证照上传不完整，请上传完整后在提交该申请！');
                            }
                        },
                        failure: function (err) {
                            Ext.Msg.alert('Error', err);
                        }
                    });
                }
                else {
                    Ext.Msg.alert("Error", massage)
                }
            }

            var setEndDate = function () {
                var txtStates = Ext.getCmp('<%=this.hidStates.ClientID%>').getValue();
                if (txtStates == "Draft" || txtStates == "Deny") {
                    var begindate = <%= AtuBeginDate.ClientID %>.getValue();
                    if (begindate != null || begindate != '') {
                        var date = new Date(begindate);
                        date.setDate(date.getDate() + 90);
                        var begindates = Number(new Date(begindate).toLocaleDateString().substring(0, 4));
                        var enddates = Number(date.toLocaleDateString().substring(0, 4));
                        var enddate = date.getFullYear() + '-' + getFormatDate(date.getMonth() + 1) + '-' + getFormatDate(date.getDate());
                        if (enddates - begindates > 0) {
                            <%= AtuEndDate.ClientID %>.setValue(begindates + '/12/31');
                        } else {
                 <%= AtuEndDate.ClientID %>.setValue(enddate);
            }
                    }
                    else { Ext.Msg.alert("Error", "1111111") }
                }
            }

            function getFormatDate(arg) {
                if (arg == undefined || arg == '') {
                    return '';
                }

                var re = arg + '';
                if (re.length < 2) {
                    re = '0' + re;
                }

                return re;
            }
            var DeleteDraft = function () {
                Ext.Msg.confirm('Warning', '确认删除该草稿单？',
                    function (e) {
                        if (e == 'yes') {
                            Coolite.AjaxMethods.DeleteDraft(
                                {
                                    success: function () {
                                        window.location.href = '/Pages/Contract/TenderAuthorizationList.aspx';
                                    },
                                    failure: function (err) {
                                        Ext.Msg.alert('Error', err);
                                    }

                                });
                        }
                    });
            }

            var DealerNameCheck = function () {
                var AtuDealerName = Ext.getCmp('<%=this.AtuDealerName.ClientID%>');
                var cbDealerType = Ext.getCmp('<%=this.cbDealerType.ClientID%>');
                var cbProductLine = Ext.getCmp('<%=this.cbProductLine.ClientID%>');
                var cbWdSubBU = Ext.getCmp('<%=this.cbWdSubBU.ClientID%>');
                var SuperiorDealer = Ext.getCmp('<%=this.SuperiorDealer.ClientID%>');
                var atuDealerRemark = Ext.getCmp('<%=this.atuDealerRemark.ClientID%>');

                if (AtuDealerName.getValue() != ''
                    && cbDealerType.getValue() != ''
                    && cbProductLine.getValue() != ''
                    && cbWdSubBU.getValue() != '') {
                    if (cbDealerType.getValue() == 'T2' && SuperiorDealer.getValue() == '') {
                        atuDealerRemark.setText('');
                    }
                    else {
                        Coolite.AjaxMethods.CheckDealerName(
                            AtuDealerName.getValue(),
                            cbDealerType.getValue(),
                            cbProductLine.getValue(),
                            cbWdSubBU.getValue(),
                            SuperiorDealer.getValue(),
                            {
                                success: function (result) {
                                    if (result == '') { atuDealerRemark.setText('') }
                                    else { atuDealerRemark.setText(result) }
                                }, failure: function (err) { Ext.Msg.alert('Error', err); }
                            })
                    }
                }
            }
        </script>



        <div id="DivStore">
            <ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine">
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
            <ext:Store ID="SubBUStore" runat="server" UseIdConfirmation="true" OnRefreshData="SubBUStore_RefreshData">
                <Reader>
                    <ext:JsonReader ReaderID="SubBUCode">
                        <Fields>
                            <ext:RecordField Name="SubBUCode" />
                            <ext:RecordField Name="SubBUName" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <SortInfo Field="SubBUCode" Direction="ASC" />
            </ext:Store>

            <ext:Store ID="HospitalListStore" runat="server" UseIdConfirmation="false" OnRefreshData="HospitalStore_RefershData" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="Id">
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="DtmId" />
                            <ext:RecordField Name="HospitalId" />
                            <ext:RecordField Name="HospitalShortName" />
                            <ext:RecordField Name="HospitalName" />
                            <ext:RecordField Name="HospitalGrade" />
                            <ext:RecordField Name="HospitalCode" />
                            <ext:RecordField Name="HospitalProvince" />
                            <ext:RecordField Name="HospitalCity" />
                            <ext:RecordField Name="HospitalDistrict" />
                            <ext:RecordField Name="HospitalDept" />
                            <ext:RecordField Name="Remark1" />
                            <ext:RecordField Name="Remark2" />
                            <ext:RecordField Name="Remark3" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <Listeners>
                    <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
                </Listeners>
            </ext:Store>
            <ext:Store ID="ProductStore" runat="server" UseIdConfirmation="false" OnRefreshData="ProductStore_RefershData" AutoLoad="false"
                OnBeforeStoreChanged="ProductStore_BeforeStoreChanged">
                <AutoLoadParams>
                    <ext:Parameter Name="start" Value="={0}" />
                    <ext:Parameter Name="limit" Value="={15}" />
                </AutoLoadParams>
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="Id">
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="HosId" />
                            <ext:RecordField Name="HosHospitalShortName" />
                            <ext:RecordField Name="HosHospitalName" />
                            <ext:RecordField Name="HosKeyAccount" />
                            <ext:RecordField Name="SubProductName" />
                            <ext:RecordField Name="RepeatDealer" />
                            <ext:RecordField Name="TCount" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <Listeners>
                    <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
                </Listeners>
            </ext:Store>
            <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" OnRefreshData="Store_RefreshAttachment">
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
                            <ext:RecordField Name="TypeName" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <Listeners>
                    <LoadException Handler="Ext.Msg.alert('提示 - 数据加载失败', e.message || e )" />
                </Listeners>
            </ext:Store>
            <ext:Store ID="DealerTypeStore" runat="server" UseIdConfirmation="true" OnRefreshData="DealerTypeStore_RefreshData">
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
                <SortInfo Field="Key" Direction="ASC" />
                <Listeners>
                </Listeners>
            </ext:Store>
            <ext:Store ID="AuthorizationInfoStore" runat="server" UseIdConfirmation="true">
                <Reader>
                    <ext:JsonReader ReaderID="Key">
                        <Fields>
                            <ext:RecordField Name="Key" />
                            <ext:RecordField Name="Value" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="SuperiorDealerStore" runat="server" OnRefreshData="Bind_SuperiorDealer" AutoLoad="true" UseIdConfirmation="true">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="ID">
                        <Fields>
                            <ext:RecordField Name="DMA_ID" />
                            <ext:RecordField Name="DMA_ChineseName" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <SortInfo Field="DMA_ID" Direction="ASC" />
                <Listeners>
                    <Load Handler="" />
                </Listeners>
            </ext:Store>
        </div>
        <div id="DivHidden">
            <ext:Hidden ID="hidIsPageNew" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidStates" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidDtmId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidDthId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidProductLine" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidSubBU" runat="server">
            </ext:Hidden>
        </div>
        <ext:ViewPort ID="ViewPort1" runat="server">
            <Body>
                <ext:BorderLayout ID="BorderLayout1" runat="server">
                    <Center MarginsSummary="0 0 0 0">
                        <ext:Panel ID="Panel2" runat="server" Header="false" BodyStyle="padding: 5px;" AutoScroll="true">
                            <Body>
                                <ext:RowLayout ID="RowLayout1" runat="server">
                                    <ext:LayoutRow>
                                        <ext:Panel ID="Panel6" runat="server" Header="false" Frame="false" BodyBorder="false"
                                            AutoHeight="true">
                                            <Body>
                                                <div style="text-align: center; font-size: medium; font-family: 微软雅黑;">
                                                    <asp:Literal ID="Literal1" runat="server" Text="经销商非正式授权申请" />
                                                </div>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutRow>
                                    <%--主信息--%>
                                    <ext:LayoutRow>
                                        <ext:FieldSet ID="DivSampleBusiness" runat="server" Header="true" Frame="false" BodyBorder="true"
                                            AutoHeight="true" AutoWidth="true" Title="基本信息">
                                            <Body>
                                                <ext:FormLayout runat="server">
                                                    <ext:Anchor>
                                                        <ext:Panel ID="Panel1" runat="server" Header="false" Border="false">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth=".33">
                                                                        <ext:Panel ID="Panel3" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="AtuNo" ReadOnly="true" runat="server" FieldLabel="授权编号" Enabled="false"
                                                                                            Width="200">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:ComboBox ID="AuthorizationInfo" runat="server" EmptyText="请选择授权类型…"
                                                                                            Width="200" Editable="false" TypeAhead="true" StoreID="AuthorizationInfoStore" ValueField="Key"
                                                                                            Mode="Local" DisplayField="Value" FieldLabel="授权类型">
                                                                                            <Triggers>
                                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                                            </Triggers>
                                                                                            <Listeners>
                                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                                            </Listeners>
                                                                                        </ext:ComboBox>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:ComboBox ID="cbProductLine" runat="server" EmptyText="请选择产品线…"
                                                                                            Width="200" Editable="false" TypeAhead="true" StoreID="ProductLineStore" ValueField="Id"
                                                                                            Mode="Local" DisplayField="AttributeName" FieldLabel="产品线"
                                                                                            ListWidth="200" Resizable="true">
                                                                                            <Triggers>
                                                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                                                            </Triggers>
                                                                                            <Listeners>
                                                                                                <TriggerClick Handler="this.clearValue();#{cbWdSubBU}.clearValue();  #{SubBUStore}.reload();  
                                                                                                    Coolite.AjaxMethods.ClearHospital();
                                                                                                        #{gpProduct}.reload();
                                                                                                          #{gpHospitalList}.reload()" />
                                                                                                <Select Handler="#{hidProductLine}.setValue(#{cbProductLine}.getValue()); 
                                                                                                                #{hidSubBU}.setValue(''); 
																												#{cbWdSubBU}.clearValue();
                                                                                                                #{SubBUStore}.reload();
                                                                                                                #{atuDealerRemark}.setText(''); 
                                                                                                                Coolite.AjaxMethods.ClearHospital();
                                                                                                                #{gpProduct}.reload();
                                                                                                                #{gpHospitalList}.reload()
                                                                                                               " />
                                                                                            </Listeners>
                                                                                        </ext:ComboBox>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:ComboBox ID="cbWdSubBU" runat="server" EmptyText="请选择SubBU..." Width="200" Editable="false"
                                                                                            Disabled="false" TypeAhead="true" StoreID="SubBUStore" ValueField="SubBUCode"
                                                                                            Resizable="true" Mode="Local" DisplayField="SubBUName" FieldLabel="SubBU">
                                                                                            <Triggers>
                                                                                                <ext:FieldTrigger Icon="Clear" Qtip="删除所选条目" />
                                                                                            </Triggers>
                                                                                            <Listeners>
                                                                                                <TriggerClick Handler="this.clearValue(); #{hidSubBU}.setValue(''); Coolite.AjaxMethods.ClearHospitalProduct(#{gpProduct}.reload());" />
                                                                                                <Select Handler="DealerNameCheck();  Coolite.AjaxMethods.ClearHospitalProduct();#{gpProduct}.reload()" />
                                                                                            </Listeners>
                                                                                        </ext:ComboBox>
                                                                                    </ext:Anchor>

                                                                                    <ext:Anchor>
                                                                                        <ext:ComboBox ID="cbDealerType" runat="server" EmptyText="请选择经销商类型…"
                                                                                            Width="200" Editable="false" TypeAhead="true" StoreID="DealerTypeStore" ValueField="Key"
                                                                                            Mode="Local" DisplayField="Value" FieldLabel="经销商类型"
                                                                                            ListWidth="200" Resizable="true">
                                                                                            <Triggers>
                                                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                                                            </Triggers>
                                                                                            <Listeners>
                                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                                                <Select Handler="Sup_SuperiorDealer(); DealerNameCheck();" />
                                                                                            </Listeners>
                                                                                        </ext:ComboBox>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth=".33">
                                                                        <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="AtuApplyUser" ReadOnly="true" runat="server" FieldLabel="申请人" Enabled="false"
                                                                                            Width="200">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:DateField ID="AtuBeginDate" runat="server" Width="200" FieldLabel="授权开始时间">
                                                                                            <Listeners>
                                                                                                <Blur Handler="setEndDate();" />
                                                                                            </Listeners>
                                                                                        </ext:DateField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:RadioGroup ID="AtulicenseType" runat="server" FieldLabel="是否三证合一" Width="150">
                                                                                            <Items>
                                                                                                <ext:Radio ID="AtulicenseTypeYes" runat="server" BoxLabel="是"
                                                                                                    Checked="true">
                                                                                                </ext:Radio>
                                                                                                <ext:Radio ID="AtulicenseTypeNo" runat="server" BoxLabel="否"
                                                                                                    Checked="false" />
                                                                                            </Items>
                                                                                        </ext:RadioGroup>
                                                                                    </ext:Anchor>
                                                                                    <%-- 添加上级平台商下拉框 如果其他类型,上级平台项隐藏--%>
                                                                                    <ext:Anchor>
                                                                                        <ext:ComboBox ID="SuperiorDealer" runat="server" EmptyText="请选择上级平台商…" Hidden="true"
                                                                                            Width="200" Editable="false" TypeAhead="true" StoreID="SuperiorDealerStore" ValueField="DMA_ID"
                                                                                            Mode="Local" DisplayField="DMA_ChineseName" FieldLabel="上级平台商"
                                                                                            ListWidth="320" Resizable="true">
                                                                                            <Triggers>
                                                                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                                                                            </Triggers>
                                                                                            <Listeners>
                                                                                                <TriggerClick Handler="this.clearValue();" />
                                                                                                <Select Handler="DealerNameCheck();" />
                                                                                            </Listeners>
                                                                                        </ext:ComboBox>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth=".34">
                                                                        <ext:Panel ID="Panel5" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                    <ext:Anchor>
                                                                                        <ext:Label ID="AtuApplyDate" runat="server" FieldLabel="申请时间" Height="22" Width="200" />
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:DateField ID="AtuEndDate" runat="server" Width="200" FieldLabel="授权终止时间" />
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
                                                        <ext:Panel ID="Panel7" runat="server" Header="false" Border="false">
                                                            <Body>
                                                                <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                                    <ext:LayoutColumn ColumnWidth=".58">
                                                                        <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="90">
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="AtuDealerName" runat="server" FieldLabel="经销商名称"
                                                                                            Width="600">
                                                                                            <Listeners>
                                                                                                <Blur Handler="DealerNameCheck();" />
                                                                                            </Listeners>
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextField ID="AtuMailAddress" runat="server" FieldLabel="邮寄及联系方式" EmptyText="请填写邮寄地址及收件人信息"
                                                                                            Width="600">
                                                                                        </ext:TextField>
                                                                                    </ext:Anchor>
                                                                                    <ext:Anchor>
                                                                                        <ext:TextArea ID="AtuRemark" runat="server" FieldLabel="备注" EmptyText="授权超过90天或跨年授权或二级经销商需波科出具授权，请填写原因"
                                                                                            Width="600" Height="44">
                                                                                        </ext:TextArea>
                                                                                    </ext:Anchor>
                                                                                </ext:FormLayout>
                                                                            </Body>
                                                                        </ext:Panel>
                                                                    </ext:LayoutColumn>
                                                                    <ext:LayoutColumn ColumnWidth=".42">
                                                                        <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                                            <Body>
                                                                                <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="20">
                                                                                    <ext:Anchor>
                                                                                        <ext:Label ID="atuDealerRemark" runat="server" HideLabel="true" LabelSeparator="" Width="200" CtCls="txtRed" />
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
                                        </ext:FieldSet>
                                    </ext:LayoutRow>
                                    <%--授权医院--%>
                                    <ext:LayoutRow>
                                        <ext:Panel ID="Panel57" runat="server" Border="false" Header="false" BodyStyle="padding-top:5px;" Frame="false">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout18" runat="server">
                                                    <ext:LayoutColumn ColumnWidth="1">
                                                        <ext:GridPanel ID="gpHospitalList" runat="server" Title="授权医院列表" StoreID="HospitalListStore" AutoScroll="false"
                                                            StripeRows="true" Collapsible="false" Border="true" Header="true" Icon="Lorry" Frame="false"
                                                            Height="200" AutoWidth="true">
                                                            <TopBar>
                                                                <ext:Toolbar ID="Toolbar1" runat="server">
                                                                    <Items>
                                                                        <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                                        <ext:Button ID="btnAddHospital" runat="server" Text="添加医院" Icon="Add" IDMode="Legacy">
                                                                            <Listeners>
                                                                                <Click Fn="showHospitalSelectorDlg" />
                                                                            </Listeners>
                                                                        </ext:Button>
                                                                        <ext:Button ID="btnDeleteHospital" runat="server" Text="删除授权医院" Icon="Delete" CommandArgument=""
                                                                            CommandName="" IDMode="Legacy" OnClientClick="" Disabled="false">
                                                                            <AjaxEvents>
                                                                                <Click Before="var result = confirm('确认删除授权医院？')&& #{gpHospitalList}.hasSelection(); if (!result) return false;"
                                                                                    OnEvent="DeleteHospital_Click" Success="#{gpHospitalList}.reload();#{hidDthId}.setValue('');#{gpProduct}.reload();#{btnDeleteHospital}.disable();"
                                                                                    Failure="Ext.Msg.alert('Message','删除失败!')">
                                                                                </Click>
                                                                            </AjaxEvents>
                                                                        </ext:Button>
                                                                    </Items>
                                                                </ext:Toolbar>
                                                            </TopBar>
                                                            <ColumnModel ID="ColumnModel2" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="HospitalName" DataIndex="HospitalName" Header="医院名称"
                                                                        Width="200">
                                                                    </ext:Column>
                                                                    <ext:Column DataIndex="HospitalCode" ColumnID="HospitalCode" Header="医院编号">
                                                                    </ext:Column>
                                                                    <ext:Column DataIndex="HospitalGrade" Header="等级">
                                                                    </ext:Column>
                                                                    <ext:Column DataIndex="HospitalProvince" Header="省份">
                                                                    </ext:Column>
                                                                    <ext:Column DataIndex="HospitalCity" Header="地区">
                                                                    </ext:Column>
                                                                    <ext:Column DataIndex="HospitalDistrict" Header="区/县">
                                                                    </ext:Column>
                                                                    <ext:Column DataIndex="HospitalDept" Width="150" Header="科室">
                                                                    </ext:Column>
                                                                    <ext:CommandColumn Width="50" Header="编辑" Align="Center">
                                                                        <Commands>
                                                                            <ext:GridCommand Icon="NoteEdit" CommandName="Edit">
                                                                                <ToolTip Text="编辑" />
                                                                            </ext:GridCommand>
                                                                        </Commands>
                                                                    </ext:CommandColumn>
                                                                </Columns>
                                                            </ColumnModel>
                                                            <BottomBar>
                                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="10" StoreID="HospitalListStore"
                                                                    DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                            </BottomBar>
                                                            <SelectionModel>
                                                                <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" SingleSelect="true">
                                                                    <Listeners>
                                                                        <RowSelect Fn="selectedHospital" />
                                                                    </Listeners>
                                                                </ext:RowSelectionModel>
                                                            </SelectionModel>
                                                            <SaveMask ShowMask="false" />
                                                            <LoadMask ShowMask="true" />
                                                            <Listeners>
                                                                <Command Handler="if (command == 'Edit'){
                                                                    Coolite.AjaxMethods.HospitalDeptShow(record.data.Id,record.data.HospitalCode,record.data.HospitalName,record.data.HospitalDept,{success:function(){},failure:function(err){Ext.Msg.alert('Error', err);}});
                                                                }" />
                                                            </Listeners>
                                                        </ext:GridPanel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutRow>
                                    <%--授权产品信息--%>
                                    <ext:LayoutRow>
                                        <ext:Panel ID="Panel23" runat="server" Border="false" Header="false" BodyStyle="padding-bottom:5px">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                                    <ext:LayoutColumn ColumnWidth="1">
                                                        <ext:GridPanel ID="gpProduct" runat="server" Title="授权产品" StoreID="ProductStore"
                                                            AutoScroll="true" StripeRows="true" Collapsible="false" Border="true" Icon="Lorry" AutoExpandColumn="RepeatDealer"
                                                            Height="400" AutoWidth="true">
                                                            <TopBar>
                                                                <ext:Toolbar ID="Toolbar2" runat="server">
                                                                    <Items>
                                                                        <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                                        <ext:Button ID="BtnAddProduct" runat="server" Text="添加授权产品" Icon="Add">
                                                                            <Listeners>
                                                                                <Click Handler="if (#{hidDthId}.getValue()==null||#{hidDthId}.getValue()==''){ Ext.Msg.alert('Message','请选择医院!') } else{ #{authorizationProductWindow}.show();#{GridAllProduct}.reload();}" />
                                                                            </Listeners>
                                                                        </ext:Button>
                                                                        <ext:Button ID="BtnDelProduct" runat="server" Text="删除授权产品" Icon="Delete">
                                                                            <Listeners>
                                                                                <Click Handler="var result = confirm('请确认是否删除授权产品？'); var grid = #{gpProduct};if ( (result) && grid.hasSelection()) { grid.deleteSelected(); grid.save(); #{ProductStore}.commitChanges();}" />
                                                                            </Listeners>
                                                                        </ext:Button>
                                                                    </Items>
                                                                </ext:Toolbar>
                                                            </TopBar>
                                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="HosKeyAccount" DataIndex="HosKeyAccount" Header="医院编号" Width="150">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="HosHospitalName" DataIndex="HosHospitalName" Header="医院名称" Width="200">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="SubProductName" DataIndex="SubProductName" Header="授权产品" Width="200">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="RepeatDealer" DataIndex="RepeatDealer" Header="重复授权经销商">
                                                                    </ext:Column>
                                                                </Columns>
                                                            </ColumnModel>
                                                            <SelectionModel>
                                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server">
                                                                    <Listeners>
                                                                        <RowSelect Handler="var btndel = #{BtnDelProduct}; if(btndel != null && (#{hidStates}.getValue()=='Draft' || #{hidStates}.getValue()=='Deny') ) btndel.enable();" />
                                                                    </Listeners>
                                                                </ext:RowSelectionModel>
                                                            </SelectionModel>
                                                            <BottomBar>
                                                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="15" StoreID="ProductStore"
                                                                    DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                            </BottomBar>
                                                            <Listeners>
                                                            </Listeners>
                                                            <SaveMask ShowMask="false" />
                                                            <LoadMask ShowMask="true" />
                                                        </ext:GridPanel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutRow>
                                    <%--附件信息--%>
                                    <ext:LayoutRow>
                                        <ext:Panel ID="Panel60" runat="server" Border="false" Header="false" BodyStyle="padding-top:5px;padding-bottom:5px;">
                                            <Body>
                                                <ext:ColumnLayout ID="ColumnLayout19" runat="server">
                                                    <ext:LayoutColumn ColumnWidth="1">
                                                        <ext:GridPanel ID="gpAttachment" runat="server" StoreID="AttachmentStore" Title="附件信息"
                                                            Border="true" Icon="Lorry" StripeRows="true" Height="300">
                                                            <TopBar>
                                                                <ext:Toolbar ID="Toolbar7" runat="server">
                                                                    <Items>
                                                                        <ext:ToolbarFill />
                                                                        <ext:Button ID="btnAddAttachment" runat="server" Text="上传附件" Icon="Add">
                                                                            <Listeners>
                                                                                <Click Handler="#{FileTypeStore}.reload();#{cbFileType}.clearValue();#{windowAttachment}.show();" />
                                                                            </Listeners>
                                                                        </ext:Button>
                                                                    </Items>
                                                                </ext:Toolbar>
                                                            </TopBar>
                                                            <ColumnModel ID="ColumnModel8" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="Name" DataIndex="Name" Width="200" Header="附件名称">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="TypeName" DataIndex="TypeName" Header="附件类型" Width="125">
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
                                                                <ext:RowSelectionModel ID="RowSelectionModel3" runat="server">
                                                                </ext:RowSelectionModel>
                                                            </SelectionModel>
                                                            <BottomBar>
                                                                <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="30" StoreID="AttachmentStore"
                                                                    DisplayInfo="true" EmptyMsg="没有数据显示" />
                                                            </BottomBar>
                                                            <Listeners>
                                                                <Command Handler="if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该下载文件?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                        success: function() {
                                                                                            #{gpAttachment}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });
                                                                    }
                                                                    else if (command == 'DownLoad')
                                                                    {
                                                                        var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=TenderFile';
                                                                        open(url, 'Download');
                                                                    }
                                                                    " />
                                                            </Listeners>
                                                            <LoadMask ShowMask="true" Msg="处理中..." />
                                                        </ext:GridPanel>
                                                    </ext:LayoutColumn>
                                                </ext:ColumnLayout>
                                            </Body>
                                        </ext:Panel>
                                    </ext:LayoutRow>
                                </ext:RowLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="BtnClose" runat="server" Text="返回" Icon="Cancel">
                                    <Listeners>
                                        <Click Handler="return NeedSave(); " />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="BtnDeleteDraft" runat="server" Text="删除草稿" Icon="Delete">
                                    <Listeners>
                                        <Click Handler="return DeleteDraft(); " />
                                    </Listeners>
                                </ext:Button>

                                <ext:Button ID="BtnDraft" runat="server" Text="保存草稿" Icon="Add">
                                    <Listeners>
                                        <Click Handler="Coolite.AjaxMethods.SaveDraft({ success: function () {
                                                               Ext.Msg.confirm('Success', '保存草稿成功，是否返回查询页面？',  function(e) { if (e == 'yes') {window.location.href ='/Pages/Contract/TenderAuthorizationList.aspx';}});
                                                            },
                                                            failure: function (err) {
                                                                Ext.Msg.alert('Error', err);
                                                            } })" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="BtnApprove" runat="server" Text="提交" Icon="LorryAdd">
                                    <Listeners>
                                        <Click Handler="DoSubmint();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="BtnExcel" runat="server" Text="导出" Icon="PageExcel" IDMode="Legacy" OnClick="ExportExcel" AutoPostBack="true">
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </Center>
                </ext:BorderLayout>
            </Body>
        </ext:ViewPort>

        <%--维护授权产品--%>
        <ext:Store ID="AllProductStore" runat="server" UseIdConfirmation="false" OnRefreshData="AllProductStore_RefershData">
            <Proxy>
                <ext:DataSourceProxy />
            </Proxy>
            <Reader>
                <ext:JsonReader ReaderID="CaId">
                    <Fields>
                        <ext:RecordField Name="SubBuId" />
                        <ext:RecordField Name="SubBuCode" />
                        <ext:RecordField Name="SubBuName" />
                        <ext:RecordField Name="CaId" />
                        <ext:RecordField Name="CaCode" />
                        <ext:RecordField Name="CaName" />

                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
        <ext:Hidden ID="dtProductHospitalId" runat="server"></ext:Hidden>
        <ext:Window ID="authorizationProductWindow" runat="server" Icon="Group" Title="授权产品"
            Closable="false" AutoShow="false" ShowOnLoad="false" Resizable="false" Height="400"
            Draggable="false" Width="450" Modal="true" BodyStyle="padding:5px;">
            <Body>
                <ext:FitLayout ID="FitLayout" runat="server">
                    <ext:GridPanel ID="GridAllProduct" runat="server" Title="" AutoExpandColumn="CaName"
                        Header="false" StoreID="AllProductStore" Border="false" Icon="Lorry" StripeRows="true">
                        <ColumnModel ID="ColumnModel5" runat="server">
                            <Columns>
                                <ext:Column ColumnID="SubBuName" DataIndex="SubBuName" Header="合同产品分类">
                                </ext:Column>
                                <ext:Column ColumnID="CaName" DataIndex="CaName" Header="授权产品分类">
                                </ext:Column>
                            </Columns>
                        </ColumnModel>
                        <Plugins>
                            <ext:GridFilters runat="server" ID="GridFilters1" Local="true">
                                <Filters>
                                    <ext:StringFilter DataIndex="SubBuName" />
                                    <ext:StringFilter DataIndex="CaName" />
                                </Filters>
                            </ext:GridFilters>
                        </Plugins>
                        <SelectionModel>
                            <ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server">
                                <Listeners>
                                    <RowSelect Handler="#{btnSaveButton}.enable();" />
                                </Listeners>
                            </ext:CheckboxSelectionModel>
                        </SelectionModel>
                        <LoadMask ShowMask="true" Msg="处理中..." />
                    </ext:GridPanel>
                </ext:FitLayout>
            </Body>
            <Buttons>
                <ext:Button ID="btnSaveButton" runat="server" Text="确定" Icon="Disk">
                    <Listeners>
                        <Click Handler="addItems(#{GridAllProduct});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="btnCancelButton" runat="server" Text="取消" Icon="Cancel">
                    <Listeners>
                        <Click Handler="#{authorizationProductWindow}.hide(null);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>

        <%--维护附件信息--%>
        <ext:Store ID="FileTypeStore" runat="server" OnRefreshData="FileTypeStore_RefreshData"
            AutoLoad="false">
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
        <ext:Window ID="windowAttachment" runat="server" Icon="Group" Title="上传附件" Resizable="false"
            Header="false" Width="500" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false"
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
                        <ext:FormLayout ID="FormLayout24" runat="server" LabelWidth="120">
                            <ext:Anchor>
                                <ext:ComboBox ID="cbFileType" runat="server" EmptyText="请选择上传文件类型" Editable="false"
                                    TypeAhead="true" StoreID="FileTypeStore" ValueField="Key" Mode="Local" DisplayField="Value"
                                    FieldLabel="文件类型" Resizable="true">
                                    <Triggers>
                                        <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                    </Triggers>
                                    <Listeners>
                                        <TriggerClick Handler="this.clearValue();" />
                                    </Listeners>
                                </ext:ComboBox>
                            </ext:Anchor>
                            <ext:Anchor>
                                <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择上传附件" FieldLabel="文件"
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
                                <Click OnEvent="UploadClick" Before="if(!#{AttachmentForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');"
                                    Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });"
                                    Success="#{gpAttachment}.reload();#{AttachmentForm}.getForm().reset();#{btnWinAttachmentSubmit}.setDisabled(true);">
                                </Click>
                            </AjaxEvents>
                        </ext:Button>
                        <ext:Button ID="ResetButton" runat="server" Text="清除">
                            <Listeners>
                                <Click Handler="#{AttachmentForm}.getForm().reset();#{btnWinAttachmentSubmit}.setDisabled(true);" />
                            </Listeners>
                        </ext:Button>
                    </Buttons>
                </ext:FormPanel>
            </Body>
            <Listeners>
                <Hide Handler="#{gpAttachment}.reload();" />
                <BeforeShow Handler="#{FileUploadField1}.setValue('');" />
            </Listeners>
        </ext:Window>

        <%-- 医院科室维护--%>
        <ext:Hidden ID="hidWindowDthId" runat="server"></ext:Hidden>
        <ext:Window ID="HospitalDeptWindow" runat="server" Icon="Group" Title="下载计算结果"
            Width="450" Height="190" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
            Resizable="false" Header="false" CenterOnLoad="true" Maximizable="true">
            <Body>
                <ext:FitLayout ID="FitLayout2" runat="server">
                    <ext:FormPanel ID="FormPanelHard" runat="server" Header="false" Border="false" BodyStyle="padding:5px;" LabelWidth="80">
                        <Body>
                            <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left">
                                <ext:Anchor>
                                    <ext:Label ID="lbWindowHosCode" runat="server" FieldLabel="医院编号" Width="200"></ext:Label>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:Label ID="lbWindowHosName" runat="server" FieldLabel="医院名称" Width="200"></ext:Label>
                                </ext:Anchor>
                                <ext:Anchor>
                                    <ext:TextField ID="txtWidnowHosDept" runat="server" FieldLabel="医院科室" Width="200"></ext:TextField>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                    </ext:FormPanel>
                </ext:FitLayout>
            </Body>
            <Buttons>
                <ext:Button ID="HospitalSaveButton" runat="server" Text="保存" Icon="PageSave">
                    <Listeners>
                        <Click Handler="Coolite.AjaxMethods.SaveHospitalDept({success:function(){Ext.Msg.alert('Success', '保存成功!');#{gpHospitalList}.reload();#{HospitalDeptWindow}.hide(null);},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                    </Listeners>
                </ext:Button>
                <ext:Button ID="CancelButton" runat="server" Text="关闭" Icon="PageCancel">
                    <Listeners>
                        <Click Handler="#{HospitalDeptWindow}.hide(null);" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>

        <uc1:HospitalSearchDialog ID="HospitalSearchDialog1" runat="server" />
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }

    </script>

</body>
</html>

