﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerLicenseChange.aspx.cs"
    Inherits="DMS.Website.Pages.MasterDatas.DealerLicenseChange" ValidateRequest="false" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE11" />
    <title></title>
    <style type="text/css">
        .list-item {
            font: normal 11px tahoma, arial, helvetica, sans-serif;
            padding: 3px 10px 3px 10px;
            border: 1px solid #fff;
            border-bottom: 1px solid #eeeeee;
            white-space: normal;
            color: #555;
        }

            .list-item h3 {
                display: block;
                font: inherit;
                font-weight: bold;
                color: #222;
            }

        .txtRed {
            color: Red;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <script type="text/javascript">
        function RefreshDetailWindow() {
            Ext.getCmp('<%=this.windwcbBscSales.ClientID%>').store.reload();
        }
        //校验必填项是否填写
        function isValid() {
            var errMsg = "";
            var gpDialogCatagory = Ext.getCmp('<%=this.gpDialogCatagory.ClientID%>');
            var NewLicenseNo = Ext.getCmp('<%=this.NewLicenseNo.ClientID%>');
            var NewLicenseNoValidFrom = Ext.getCmp('<%=this.NewLicenseNoValidFrom.ClientID%>');
            var NewLicenseNoValidTo = Ext.getCmp('<%=this.NewLicenseNoValidTo.ClientID%>');
            var NewFilingNo = Ext.getCmp('<%=this.NewFilingNo.ClientID%>');
            var NewFilingNoValidFrom = Ext.getCmp('<%=this.NewFilingNoValidFrom.ClientID%>');
            var NewCurRespPerson = Ext.getCmp('<%=this.NewCurRespPerson.ClientID%>');
            var NewCurLegalPerson = Ext.getCmp('<%=this.NewCurLegalPerson.ClientID%>');
            var GridPanel2store = Ext.getCmp('<%=this.GridPanel2.ClientID%>').store;
            var gpNewAttachmentstore = Ext.getCmp('<%=this.gpNewAttachment.ClientID%>').store;
            var CbBscSales = Ext.getCmp('<%=this.windwcbBscSales.ClientID%>');

            if (CbBscSales.getValue() == '') {
                errMsg += "请选择销售人员，如无销售人员请联系系统管理员<br/>"
            }
            if (NewLicenseNo.getValue() == '' || NewFilingNo.getValue() == '') {
                errMsg += "请填写证件编号<br/>"
            }
            if (NewLicenseNoValidFrom.getValue() == '' || NewFilingNoValidFrom.getValue() == '') {
                errMsg += "请填写起始日期<br/>"
            }
            if (NewLicenseNoValidTo.getValue() == '') {
                errMsg += "请填写结束日期<br/>"
            }
            if (NewCurRespPerson.getValue() == '') {
                errMsg += "请填写企业负责人<br/>"
            }
            if (NewCurLegalPerson.getValue() == '') {
                errMsg += "请填写法人代表<br/>"
            }
            if (GridPanel2store.getTotalCount() <= 0) {
                errMsg += "请维护地址信息<br/>"
            }
            if (gpNewAttachmentstore.getTotalCount() <= 0) {
                errMsg += "请上传附件<br/>"
            }

            return errMsg;
        }
        var SelectSecondLevelCatagory = function () {

            var hidDealerId = Ext.getCmp('<%=this.hidDealerId.ClientID%>');
            Coolite.AjaxMethods.ShowDialog(hidDealerId.getValue(), "二类", "2002版");
        }
            var SelectNewSecond = function () {

                var hidDealerId = Ext.getCmp('<%=this.hidDealerId.ClientID%>');
                Coolite.AjaxMethods.ShowDialog(hidDealerId.getValue(), "二类", "2017版");
            }
            var SelectThirdLevelCatagory = function () {
                var hidDealerId = Ext.getCmp('<%=this.hidDealerId.ClientID%>')
                Coolite.AjaxMethods.ShowDialog(hidDealerId.getValue(), "三类", "2002版");
            }
            var SelectNewThird = function () {
                var hidDealerId = Ext.getCmp('<%=this.hidDealerId.ClientID%>')
                Coolite.AjaxMethods.ShowDialog(hidDealerId.getValue(), "三类", "2017版");
            }

            var add = function () {
                var hidDealerId = Ext.getCmp('<%=this.cbaddresstype.ClientID%>').getValue();
            var txtRemark = Ext.getCmp('<%=this.txtRemark.ClientID%>').getValue();
            var hidisshitoaddress = Ext.getCmp('<%=this.hidisshitoaddress.ClientID%>').getValue();
            var cbaddresstype = Ext.getCmp('<%=this.cbaddresstype.ClientID%>').getValue();
            if (cbaddresstype == "" || txtRemark == '') {
                Ext.MessageBox.alert('警告', '请填写完整后再提交！');
            }
            else if (txtRemark.length > 60) {
                Ext.MessageBox.alert("警告", "地址信息超长，请调整后提交!")
            }
            else {
                if (hidisshitoaddress != "N" && Ext.getCmp('<%=this.Hidstate.ClientID%>').getValue() == "Checked") {
                    Ext.Msg.confirm('默认发货仓库将由：' + hidisshitoaddress + '修改为</br>' + txtRemark + '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp是否提交？',
                            function (e) {
                                if (e == 'yes') {
                                    Ext.getCmp('<%=this.hidOptType.ClientID%>').setValue('update');

                                    Coolite.AjaxMethods.AddAddress({
                                        success: function () {
                                            Ext.MessageBox.alert('提示', '添加成功');
                                            Ext.getCmp('<%=this.AddressWindow.ClientID%>').hide();
                                            Ext.getCmp('<%=this.GridPanel2.ClientID%>').reload();
                                        },
                                        failure: function (err) {
                                            Ext.Msg.alert('Error', err);
                                        }

                                    });

                                }
                                else {
                                }
                            }
                        );

                        }
                        if (hidisshitoaddress != 'N' && Ext.getCmp('<%=this.Hidstate.ClientID%>').getValue() == "NoChecked") {
                    Coolite.AjaxMethods.AddAddress({
                        success: function () {
                            Ext.MessageBox.alert('提示', '添加成功');
                            Ext.getCmp('<%=this.AddressWindow.ClientID%>').hide();
                            Ext.getCmp('<%=this.GridPanel2.ClientID%>').reload();
                        },
                        failure: function (err) {
                            Ext.Msg.alert('Error', err);
                        }

                    });

                }
                if (hidisshitoaddress == 'N') {
                    Coolite.AjaxMethods.AddAddress({
                        success: function () {
                            Ext.MessageBox.alert('提示', '添加成功');
                            Ext.getCmp('<%=this.AddressWindow.ClientID%>').hide();
                            Ext.getCmp('<%=this.GridPanel2.ClientID%>').reload();
                        },
                        failure: function (err) {
                            Ext.Msg.alert('Error', err);
                        }

                    });

                }
            }

        }
    var submit = function () {
        var massage = isValid();
        if (massage == null || massage == '') {
            Ext.getCmp('<%=this.hidsumit.ClientID%>').setValue('submit')

                Coolite.AjaxMethods.SaveDraft(
                {
                    success: function (result) {
                        if (result == "0") {
                            Ext.Msg.alert('提示', "提交成功!");
                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                            Ext.getCmp('<%=this.hiddenNewApplyId.ClientID%>').setValue('');
                            Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
                        }
                        if (result == "1") {
                            Ext.Msg.alert('提示', "该经销商拥有未完成审批的申请!");
                        }
                        if (result == "2") {
                            Ext.Msg.alert('提示', "请维护仓库地址和经营地址");
                        }
                    },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                    }
                }
                );
            }
            else {
                Ext.Msg.alert("提示", massage)
            }

        }
        var Close = function () {
            if (Ext.getCmp('<%=this.HidApplyStatus.ClientID%>').getValue() == 'new' || Ext.getCmp('<%=this.HidApplyStatus.ClientID%>').getValue() == '草稿') {
                Ext.Msg.confirm('提示', '是否保存草稿？',
                     function (e) {
                         if (e == 'yes') {
                             SaveDraft();
                         }
                         else {
                             Coolite.AjaxMethods.delete(
                                 {
                                     success: function () {
                                         Ext.Msg.alert('提示', "草稿已删除");
                                         Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                         Ext.getCmp('<%=this.hiddenNewApplyId.ClientID%>').setValue('');
                                         Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
                                     },
                                     failure: function (err) {
                                         Ext.Msg.alert('Error', err);
                                     }
                                 }
                                 );

                             }
                     })
                     }
                     else {

                         Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                Ext.getCmp('<%=this.hiddenNewApplyId.ClientID%>').setValue('');
            }
        }

        var SaveDraft = function () {
            Ext.getCmp('<%=this.hidsumit.ClientID%>').setValue('save')
            Coolite.AjaxMethods.SaveDraft(
           {
               success: function (result) {
                   if (result == "2") {
                       Ext.Msg.alert('提示', "仓库地址和经营地址必须维护");
                   }
                   else {
                       Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                       Ext.getCmp('<%=this.hiddenNewApplyId.ClientID%>').setValue('');
                       Ext.getCmp('<%=this.GridPanel1.ClientID%>').reload();
                   }
               },
               failure: function (err) {
                   Ext.Msg.alert('Error', err);
               }
           }
               );
        }
       //添加选中的产品
       var addItems = function (grid) {

           var catagoryType = Ext.getCmp('<%=this.hiddenDialogCatagoryType.ClientID%>');
           var versionNumber = Ext.getCmp('<%=this.hiddenVersionNumber.ClientID%>');
           if (grid.hasSelection()) {
               var selList = grid.selModel.getSelections();
               var param = '';
               for (var i = 0; i < selList.length; i++) {
                   param += selList[i].get('CatagoryID') + ',';
               }
               Coolite.AjaxMethods.RefreshNewCatagoryGrid(param, catagoryType.getValue(), versionNumber.getValue());
           } else {
               Ext.MessageBox.alert('警告', '请选择要添加的产品分类代码');
           }
       }

       //触发函数
       function downloadfile(url) {
           var iframe = document.createElement("iframe");
           iframe.src = url;
           iframe.style.display = "none";
           document.body.appendChild(iframe);
       }
       if (Ext.isChrome === true) {
           var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
           Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
       }
       var CheckAddressLength = function () {
           var address = Ext.getCmp('<%=this.txtRemark.ClientID%>').getValue();
           if (address != null || address != '') {
               if (address.length > 60) {
                   Ext.Msg.alert("警告", "地址超60个字符，请调整！")
               }
           }
       }
    </script>
    <form id="form1" runat="server">
        <div>
            <ext:ScriptManager ID="ScriptManager1" runat="server">
            </ext:ScriptManager>
            <ext:Hidden ID="hidDealerId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidOptType" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="HidApplyStatus" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidsumit" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidStatus" runat="server"></ext:Hidden>
            <ext:Store ID="Store1" runat="server" OnRefreshData="Store1_RefershData" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="DML_MID" />
                            <ext:RecordField Name="DMA_ChineseShortName" />
                            <ext:RecordField Name="DML_NewApplyNO" />
                            <ext:RecordField Name="DML_NewApplyStatus" />
                            <ext:RecordField Name="DML_NewApplyDate" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
                <Reader>
                    <ext:JsonReader ReaderID="Id">
                        <Fields>
                            <ext:RecordField Name="Id" />
                            <ext:RecordField Name="ChineseName" />
                            <ext:RecordField Name="ChineseShortName" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="NewAttachmentStore" runat="server" UseIdConfirmation="false" AutoLoad="false" OnRefreshData="NewAttachmentStore_Refresh">
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
            <ext:Store ID="ShipToAddress" runat="server" OnRefreshData="ShipToAddress_RefershData" AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader ReaderID="ST_ID">
                        <Fields>
                            <ext:RecordField Name="ST_ID" />
                            <ext:RecordField Name="ST_WH_Code" />
                            <ext:RecordField Name="DMA_ChineseShortName" />
                            <ext:RecordField Name="ST_Type" />
                            <ext:RecordField Name="ST_Address" />
                            <ext:RecordField Name="ST_IsSendAddress" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
            </ext:Store>
            <ext:Store ID="NewThirdClassCatagoryStore" runat="server">
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="CatagoryID" />
                            <ext:RecordField Name="CatagoryName" />
                            <ext:RecordField Name="CatagoryType" />
                            <ext:RecordField Name="CatagoryStatus" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <SortInfo Field="CatagoryID" Direction="ASC" />
            </ext:Store>
            <ext:Store ID="NewThirdStore" runat="server">
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="CatagoryID" />
                            <ext:RecordField Name="CatagoryName" />
                            <ext:RecordField Name="CatagoryType" />
                            <ext:RecordField Name="CatagoryStatus" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <SortInfo Field="CatagoryID" Direction="ASC" />
            </ext:Store>
            <ext:Store ID="NewSecondClassCatagoryStore" runat="server">
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="CatagoryID" />
                            <ext:RecordField Name="CatagoryName" />
                            <ext:RecordField Name="CatagoryType" />
                            <ext:RecordField Name="CatagoryStatus" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <SortInfo Field="CatagoryID" Direction="ASC" />
            </ext:Store>
            <ext:Store ID="NewSecondStore" runat="server">
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="CatagoryID" />
                            <ext:RecordField Name="CatagoryName" />
                            <ext:RecordField Name="CatagoryType" />
                            <ext:RecordField Name="CatagoryStatus" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <SortInfo Field="CatagoryID" Direction="ASC" />
            </ext:Store>


            <ext:Store ID="LicenseCatagoryStore" runat="server" OnRefreshData="LicenseCatagoryStore_RefershData"
                AutoLoad="false">
                <Proxy>
                    <ext:DataSourceProxy />
                </Proxy>
                <Reader>
                    <ext:JsonReader>
                        <Fields>
                            <ext:RecordField Name="CatagoryID" />
                            <ext:RecordField Name="CatagoryName" />
                            <ext:RecordField Name="CatagoryType" />
                            <ext:RecordField Name="CatagoryStatus" />
                        </Fields>
                    </ext:JsonReader>
                </Reader>
                <SortInfo Field="CatagoryID" Direction="ASC" />
            </ext:Store>
            <ext:Store ID="BscSalesStore" runat="server" OnRefreshData="BscSalesStore_RefreshData" AutoLoad="false">
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
                <Listeners>
                    <Load Handler="if(#{winHidSalesRep}.getValue()==''){#{windwcbBscSales}.setValue(#{windwcbBscSales}.store.getTotalCount()>0?#{windwcbBscSales}.store.getAt(0).get('Key'):'')}else{#{windwcbBscSales}.setValue(#{winHidSalesRep}.getValue())}; " />
                </Listeners>
            </ext:Store>

            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <North Collapsible="True" Split="True">
                            <ext:Panel ID="plSearch" runat="server" Header="true" Title="查找条件" Frame="true" AutoHeight="true" Icon="Find">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout1" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".35">
                                            <ext:Panel ID="Panel1" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="100">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbDealer" runat="server" EmptyText="请选择经销商..." Width="250" Editable="true"
                                                                TypeAhead="true" StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName"
                                                                Mode="Local" FieldLabel="经销商中文名称" ListWidth="250" Resizable="true">
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
                                        <ext:LayoutColumn ColumnWidth=".35">
                                            <ext:Panel ID="Panel2" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="100">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="CFDAProcessNo" runat="server" FieldLabel="CFDA流程编号" Width="220" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".3">
                                            <ext:Panel ID="Panel3" runat="server" Border="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="90">
                                                        <ext:Anchor>
                                                            <ext:ComboBox ID="cbStatus" runat="server" FieldLabel="申请审批状态" Editable="true" TypeAhead="true" EmptyText="" Mode="Local" Width="150">
                                                                <Items>
                                                                    <ext:ListItem Text="审批通过" Value="审批通过" />
                                                                    <ext:ListItem Text="审批拒绝" Value="审批拒绝" />
                                                                    <ext:ListItem Text="草稿" Value="草稿" />
                                                                    <ext:ListItem Text="审批中" Value="审批中" />
                                                                </Items>
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
                                <Buttons>
                                    <ext:Button ID="btnSearch" Text="查找" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                        <Listeners>
                                            <Click Handler="#{PagingToolBar1}.changePage(1);" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnInsert" runat="server" Text="新增" Icon="Add" CommandArgument="" CommandName="" IDMode="Legacy" OnClientClick="">
                                        <Listeners>
                                            <Click Handler=" Coolite.AjaxMethods.DetailWindowShow('','',{success: function(){RefreshDetailWindow();},failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </North>
                        <Center>
                            <ext:Panel runat="server" ID="ctl46" Border="false" Frame="true">
                                <Body>
                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                        <ext:GridPanel ID="GridPanel1" runat="server" Title="查询结果" StoreID="Store1" Border="false" Icon="Lorry" StripeRows="true">
                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="DMA_ChineseShortName" DataIndex="DMA_ChineseShortName" Header="经销商名称" Width="250">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DML_NewApplyNO" DataIndex="DML_NewApplyNO" Header="申请单编号" Width="200">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DML_NewApplyStatus" DataIndex="DML_NewApplyStatus" Header="审批状态">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="DML_NewApplyDate" DataIndex="DML_NewApplyDate" Header="申请时间">
                                                    </ext:Column>
                                                    <ext:CommandColumn Header="查看" Width="60" Align="Center">
                                                        <Commands>
                                                            <ext:GridCommand Icon="ApplicationViewDetail" CommandName="look" ToolTip-Text="查看">
                                                            </ext:GridCommand>
                                                        </Commands>
                                                    </ext:CommandColumn>

                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" />
                                            </SelectionModel>
                                            <BottomBar>
                                                <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="15" StoreID="Store1" DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
                                            </BottomBar>
                                            <SaveMask ShowMask="true" />
                                            <LoadMask ShowMask="true" Msg="加载中。。。" />
                                            <Listeners>
                                                <Command Handler=" if (command == 'look')
                                                                {  
                                                                    Coolite.AjaxMethods.DetailWindowShow(record.data.DML_MID,record.data.DML_NewApplyStatus,{success: function(){RefreshDetailWindow();},failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                }
                                                            
                                              " />
                                            </Listeners>
                                        </ext:GridPanel>
                                    </ext:FitLayout>
                                </Body>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>
                </Body>
            </ext:ViewPort>
            <ext:Hidden ID="HidAction" runat="server">
            </ext:Hidden>

            <ext:Hidden ID="hiddenDialogDealerId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hiddenDialogCatagoryType" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hiddenVersionNumber" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hiddenNewApplyId" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hiddenFileName" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hiddenDialogCatagoryID" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hiddenDialogCatagoryName" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hiddenLatestApptoveUpdate" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hidisshitoaddress" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="Hidstate" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="winHidSalesRep" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="winHidAppNo" runat="server">
            </ext:Hidden>

            <ext:Hidden ID="hiddenSecondClass2012" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hiddenSecondClass2017" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hiddenThirdClass2012" runat="server">
            </ext:Hidden>
            <ext:Hidden ID="hiddenThirdClass2017" runat="server">
            </ext:Hidden>
            <ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="CFDA证照信息修改"
                AutoShow="false" Modal="true" ShowOnLoad="false" Width="980" Height="640"
                Header="false" CenterOnLoad="true" Y="5" Closable="false" Maximizable="true">
                <Body>
                    <ext:BorderLayout ID="BorderLayout3" runat="server">
                        <North Collapsible="true">
                            <ext:Panel ID="Panel18" runat="server" Header="false" Frame="true" AutoHeight="true" Border="false">
                                <Body>
                                    <ext:Panel ID="Panel5" runat="server">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                                                <ext:LayoutColumn ColumnWidth="0.5">
                                                    <ext:Panel ID="Panel6" runat="server" Border="false" Header="false" BodyStyle="padding:5px 15px 5px">
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout15" runat="server" LabelWidth="100">
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="windwcbBscSales" runat="server" EmptyText="请选择销售人员" Width="180" Editable="true"
                                                                        TypeAhead="true" StoreID="BscSalesStore" ValueField="Key" DisplayField="Value"
                                                                        Mode="Local" FieldLabel="销售" ListWidth="250" Resizable="true">
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:Panel>
                                    <ext:Panel ID="Panel23" runat="server">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout7" runat="server">
                                                <ext:LayoutColumn ColumnWidth="0.5">
                                                    <ext:Panel ID="Panel20" runat="server" Border="false" Header="false" BodyStyle="padding:5px 15px 5px">
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout6" runat="server" LabelWidth="100">
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="NewCurRespPerson" runat="server" FieldLabel="企业负责人" Width="180">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                                <ext:LayoutColumn ColumnWidth="0.5">
                                                    <ext:Panel ID="Panel21" runat="server" Border="false" Header="false" BodyStyle="padding:5px 15px 5px">
                                                        <Body>

                                                            <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="100">
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="NewCurLegalPerson" runat="server" FieldLabel="法人代表" Width="180">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>

                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:Panel>
                                    <ext:Panel ID="Panel19" runat="server">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout6" runat="server">
                                                <ext:LayoutColumn ColumnWidth=".5">
                                                    <ext:Panel ID="Panel22" runat="server" Border="false" Header="false" Title="医疗器械经营许可证信息">
                                                        <Body>
                                                            <ext:FieldSet ID="FieldSetNewLicense" runat="server" Header="true" Frame="false"
                                                                BodyBorder="true" AutoHeight="true" AutoWidth="true" Title="医疗器械经营许可证信息">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout4" runat="server" LabelWidth="100">
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="NewLicenseNo" runat="server" FieldLabel="证件编号" Width="250" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:DateField ID="NewLicenseNoValidFrom" runat="server" Width="250" FieldLabel="起始日期" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:DateField ID="NewLicenseNoValidTo" runat="server" Width="250" FieldLabel="结束日期" />
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:FieldSet>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                                <ext:LayoutColumn ColumnWidth=".5">
                                                    <ext:Panel ID="Panel24" runat="server" Border="false" Header="false" Title="医疗器械备案凭证信息">
                                                        <Body>
                                                            <ext:FieldSet ID="FieldSetNewFiling" runat="server" Header="true" Frame="false" BodyBorder="true"
                                                                AutoHeight="true" AutoWidth="true" Title="医疗器械备案凭证信息">
                                                                <Body>
                                                                    <ext:FormLayout ID="FormLayout5" runat="server" LabelWidth="100">
                                                                        <ext:Anchor>
                                                                            <ext:TextField ID="NewFilingNo" runat="server" FieldLabel="证件编号" Width="250" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:DateField ID="NewFilingNoValidFrom" runat="server" FieldLabel="起始日期" Width="250" />
                                                                        </ext:Anchor>
                                                                        <ext:Anchor>
                                                                            <ext:DateField ID="NewFilingNoValidTo" Disabled="true" runat="server" FieldLabel="结束日期"
                                                                                Width="250" />
                                                                        </ext:Anchor>
                                                                    </ext:FormLayout>
                                                                </Body>
                                                            </ext:FieldSet>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                            </ext:ColumnLayout>
                                        </Body>
                                    </ext:Panel>
                                </Body>
                            </ext:Panel>
                        </North>
                        <Center>
                            <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Border="false">
                                <Tabs>
                                    <ext:Tab ID="Tab3" runat="server" Title="ShipTo地址" BodyBorder="false" ActiveIndex="1" AutoShow="true">
                                        <Body>
                                            <ext:FitLayout ID="FT2" runat="server">
                                                <ext:GridPanel ID="GridPanel2" runat="server" StoreID="ShipToAddress"
                                                    AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                                    Icon="Lorry" Width="885">
                                                    <TopBar>
                                                        <ext:Toolbar ID="Toolbar3" runat="server">
                                                            <Items>
                                                                <ext:Label ID="Label1" runat="server" Text="ShipTo地址" Icon="Lorry" />
                                                                <ext:ToolbarFill ID="ToolbarFill3" runat="server" />
                                                                <ext:Button ID="Addressbtn" runat="server" Text="选择地址" Icon="Add">
                                                                    <Listeners>
                                                                        <Click Handler="Coolite.AjaxMethods.AddressWindowshow();" />
                                                                    </Listeners>
                                                                </ext:Button>
                                                            </Items>
                                                        </ext:Toolbar>
                                                    </TopBar>
                                                    <ColumnModel ID="ColumnModel2" runat="server">
                                                        <Columns>
                                                            <ext:Column ColumnID="ST_WH_Code" DataIndex="ST_WH_Code" Header="地址代码" Width="130">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="ST_Type" DataIndex="ST_Type" Header="地址类型" Width="130">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="ST_Address" DataIndex="ST_Address" Header="地址名称" Width="250">
                                                            </ext:Column>
                                                            <ext:Column ColumnID="ST_IsSendAddress" DataIndex="ST_IsSendAddress" Header="是否默认发货地址" Width="130">
                                                            </ext:Column>

                                                            <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                                <Commands>
                                                                    <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
                                                                </Commands>
                                                            </ext:CommandColumn>
                                                            <ext:CommandColumn Width="150" Header="变更默认发货地址" Align="Center">
                                                                <Commands>
                                                                    <ext:GridCommand Icon="VcardEdit" CommandName="update" ToolTip-Text="变更发货地址" />
                                                                </Commands>
                                                            </ext:CommandColumn>
                                                        </Columns>
                                                    </ColumnModel>
                                                    <SelectionModel>
                                                        <ext:RowSelectionModel ID="RowSelectionModel4" runat="server" />
                                                    </SelectionModel>
                                                    <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="50" StoreID="ShipToAddress" DisplayInfo="true" />
                                                    </BottomBar>
                                                    <SaveMask ShowMask="true" />
                                                    <LoadMask ShowMask="true" />
                                                    <Listeners>
                                                        <Command Handler="if(command == 'Delete'){
                                                                                Ext.Msg.confirm('警告', '是否要删除该地址?',
                                                                                    function(e) {
                                                                                        if (e == 'yes') {
                                                                                            Coolite.AjaxMethods.DeleteAddress(record.data.ST_ID,record.data.ST_WH_Code,{
                                                                                                success: function() {
                                                                                                    Ext.Msg.alert('Message', '删除成功！');
                                                                                                    #{GridPanel2}.reload();
                                                                                                },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                        }
                                                                                    });
                                                                            } if(command == 'update'){
                                                                               Coolite.AjaxMethods.updateshiptoaddressbtn(record.data.ST_ID,record.data.ST_IsSendAddress,{ 
                                                                                                    success: function() {
                                                                                                    #{GridPanel2}.reload();
																			},failure: function(err) {Ext.Msg.alert('Error', err);}})}" />

                                                    </Listeners>
                                                </ext:GridPanel>
                                            </ext:FitLayout>
                                        </Body>
                                    </ext:Tab>
                                    <ext:Tab ID="tab4" runat="server" Title="二类医疗器械产品分类" BodyBorder="false" ActiveIndex="2" AutoShow="true">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout13" runat="server">
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel9" runat="server" Border="false" Header="false" AutoScroll="true">
                                                        <Body>
                                                            <ext:GridPanel ID="gpNewSecondClassCatagory" runat="server" Title="2002版二类医疗器械产品分类"
                                                                StoreID="NewSecondClassCatagoryStore" StripeRows="true" Border="false" Header="false" Icon="Lorry" AutoExpandColumn="NewCatagoryName" Height="175" AutoScroll="true">
                                                                <TopBar>
                                                                    <ext:Toolbar ID="Toolbar1" runat="server">
                                                                        <Items>
                                                                            <ext:Label ID="lblResultLevel2" runat="server" Text="2002版二类医疗器械产品分类" Icon="Lorry" />
                                                                            <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                                            <ext:Button ID="btnAddCatagory" runat="server" Text="重新选择分类" Icon="Add">
                                                                                <Listeners>
                                                                                    <Click Handler="SelectSecondLevelCatagory();" />
                                                                                </Listeners>
                                                                            </ext:Button>
                                                                        </Items>
                                                                    </ext:Toolbar>
                                                                </TopBar>
                                                                <ColumnModel ID="ColumnModel3" runat="server">
                                                                    <Columns>
                                                                        <ext:Column ColumnID="NewCatagoryID" DataIndex="CatagoryID" Header="产品分类代码" Width="200">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="NewCatagoryName" DataIndex="CatagoryName" Header="产品分类名称" Width="300">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="NewCatagoryType" DataIndex="CatagoryType" Header="分类级别" Width="140">
                                                                        </ext:Column>
                                                                    </Columns>
                                                                </ColumnModel>
                                                                <%-- <BottomBar>
                                                                        <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="50" StoreID="NewSecondClassCatagoryStore" DisplayInfo="true" />
                                                                     </BottomBar>--%>
                                                                <SaveMask ShowMask="false" />
                                                                <LoadMask ShowMask="true" />
                                                            </ext:GridPanel>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel7" runat="server" Border="false" Header="false" AutoScroll="true">
                                                        <Body>
                                                            <ext:GridPanel ID="NewSecondGridPanel" runat="server" Title="2017版二类医疗器械产品分类"
                                                                StoreID="NewSecondStore" StripeRows="true" Border="false" Header="false" Icon="Lorry" AutoExpandColumn="NewCatagoryName" Height="175" AutoScroll="true">
                                                                <TopBar>
                                                                    <ext:Toolbar ID="Toolbar4" runat="server">
                                                                        <Items>
                                                                            <ext:Label ID="Label2" runat="server" Text="2017版二类医疗器械产品分类" Icon="Lorry" />
                                                                            <ext:ToolbarFill ID="ToolbarFill4" runat="server" />
                                                                            <ext:Button ID="Button1" runat="server" Text="重新选择分类" Icon="Add">
                                                                                <Listeners>
                                                                                    <Click Handler="SelectNewSecond();" />
                                                                                </Listeners>
                                                                            </ext:Button>
                                                                        </Items>
                                                                    </ext:Toolbar>
                                                                </TopBar>
                                                                <ColumnModel ID="ColumnModel6" runat="server">
                                                                    <Columns>
                                                                        <ext:Column ColumnID="NewCatagoryID" DataIndex="CatagoryID" Header="产品分类代码" Width="200">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="NewCatagoryName" DataIndex="CatagoryName" Header="产品分类名称" Width="300">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="NewCatagoryType" DataIndex="CatagoryType" Header="分类级别" Width="140">
                                                                        </ext:Column>
                                                                    </Columns>
                                                                </ColumnModel>
                                                                <SaveMask ShowMask="false" />
                                                                <LoadMask ShowMask="true" />
                                                            </ext:GridPanel>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Tab>
                                    <ext:Tab ID="tab5" runat="server" Title="三类医疗器械产品分类" BodyBorder="false" ActiveIndex="3" AutoShow="true">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout14" runat="server">
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel12" runat="server" Border="false" Header="false" AutoScroll="true">
                                                        <Body>
                                                            <ext:GridPanel ID="gpNewThirdClassCatagory" runat="server" Title="2002版三类医疗器械产品分类" StoreID="NewThirdClassCatagoryStore"
                                                                StripeRows="true" Height="175" Border="false" Header="false" Icon="Lorry" AutoScroll="true">
                                                                <TopBar>
                                                                    <ext:Toolbar ID="Toolbar2" runat="server">
                                                                        <Items>
                                                                            <ext:Label ID="lblResultLevel3" runat="server" Text="2002版三类医疗器械产品分类" Icon="Lorry" />
                                                                            <ext:ToolbarFill ID="ToolbarFill2" runat="server" />
                                                                            <ext:Button ID="btnAddCatagoryThird" runat="server" Text="重新选择分类" Icon="Add">
                                                                                <Listeners>
                                                                                    <Click Handler="SelectThirdLevelCatagory();" />
                                                                                </Listeners>
                                                                            </ext:Button>
                                                                        </Items>
                                                                    </ext:Toolbar>
                                                                </TopBar>
                                                                <ColumnModel ID="ColumnModel4" runat="server">
                                                                    <Columns>
                                                                        <ext:Column ColumnID="NewCatagoryID" DataIndex="CatagoryID" Header="产品分类代码" Width="200">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="NewCatagoryName" DataIndex="CatagoryName" Header="产品分类名称" Width="300">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="NewCatagoryType" DataIndex="CatagoryType" Header="分类级别" Width="140">
                                                                        </ext:Column>
                                                                    </Columns>
                                                                </ColumnModel>
                                                                <%-- <BottomBar>
                                                        <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="50" StoreID="NewThirdClassCatagoryStore" DisplayInfo="true" />
                                                    </BottomBar>
                                                    <SaveMask ShowMask="false" />
                                                    <LoadMask ShowMask="true" />--%>
                                                            </ext:GridPanel>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Anchor>
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                                        <Body>
                                                            <ext:GridPanel ID="NewThirdGridPanel" runat="server" Title="2017版三类医疗器械产品分类" StoreID="NewThirdStore"
                                                                StripeRows="true" Height="175" Border="false" Header="false" Icon="Lorry" AutoScroll="true">
                                                                <TopBar>
                                                                    <ext:Toolbar ID="Toolbar5" runat="server">
                                                                        <Items>
                                                                            <ext:Label ID="Label5" runat="server" Text="2017版三类医疗器械产品分类" Icon="Lorry" />
                                                                            <ext:ToolbarFill ID="ToolbarFill5" runat="server" />
                                                                            <ext:Button ID="Button2" runat="server" Text="重新选择分类" Icon="Add">
                                                                                <Listeners>
                                                                                    <Click Handler="SelectNewThird();" />
                                                                                </Listeners>
                                                                            </ext:Button>
                                                                        </Items>
                                                                    </ext:Toolbar>
                                                                </TopBar>
                                                                <ColumnModel ID="ColumnModel8" runat="server">
                                                                    <Columns>
                                                                        <ext:Column ColumnID="NewCatagoryID" DataIndex="CatagoryID" Header="产品分类代码" Width="200">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="NewCatagoryName" DataIndex="CatagoryName" Header="产品分类名称" Width="300">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="NewCatagoryType" DataIndex="CatagoryType" Header="分类级别" Width="140">
                                                                        </ext:Column>
                                                                    </Columns>
                                                                </ColumnModel>
                                                                <SaveMask ShowMask="false" />
                                                                <LoadMask ShowMask="true" />
                                                            </ext:GridPanel>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:Anchor>
                                            </ext:FormLayout>
                                        </Body>
                                    </ext:Tab>
                                    <ext:Tab ID="tab6" runat="server" Title="附件" BodyBorder="false" ActiveIndex="4" AutoShow="true">
                                        <Body>
                                            <ext:FormLayout ID="FormLayout12" runat="server">
                                                <ext:Anchor>
                                                    <ext:Panel ID="Panel4" runat="server" Border="false" Header="false">
                                                        <Body>
                                                            <ext:GridPanel ID="gpNewAttachment" runat="server" Title="附件列表" StoreID="NewAttachmentStore"
                                                                AutoWidth="true" StripeRows="true" Collapsible="false" Border="false" Icon="Lorry"
                                                                Header="false" Height="255">
                                                                <TopBar>
                                                                    <ext:Toolbar ID="Toolbar6" runat="server">
                                                                        <Items>
                                                                            <ext:Label ID="Label4" runat="server" Text="附件列表" Icon="Lorry" />
                                                                            <ext:ToolbarFill ID="ToolbarFill6" runat="server" />
                                                                            <ext:Button ID="btnAddAttach" runat="server" Text="添加附件" Icon="Add" StyleSpec="margin-right:15px">
                                                                                <Listeners>
                                                                                    <Click Handler="#{AttachmentWindow}.show()" />
                                                                                </Listeners>
                                                                            </ext:Button>
                                                                        </Items>
                                                                    </ext:Toolbar>
                                                                </TopBar>
                                                                <ColumnModel ID="ColumnModel7" runat="server">
                                                                    <Columns>
                                                                        <ext:Column ColumnID="Id" DataIndex="Id" Hidden="true">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="MainId" DataIndex="MainId" Hidden="true">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="Name" DataIndex="Name" Header="附件名称">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="Url" DataIndex="Url" Header="路径" Hidden="true" Width="200">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="Identity_Name" DataIndex="Identity_Name" Header="上传人" Width="200">
                                                                        </ext:Column>
                                                                        <ext:Column ColumnID="UploadDate" DataIndex="UploadDate" Header="上传时间" Width="100">
                                                                        </ext:Column>
                                                                        <ext:CommandColumn Width="50" Header="下载" Align="Center">
                                                                            <Commands>
                                                                                <ext:GridCommand Icon="DiskDownload" CommandName="DownLoadNew" ToolTip-Text="下载" />
                                                                            </Commands>
                                                                        </ext:CommandColumn>
                                                                        <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                                            <Commands>
                                                                                <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
                                                                            </Commands>
                                                                        </ext:CommandColumn>
                                                                    </Columns>
                                                                </ColumnModel>
                                                                <SelectionModel>
                                                                    <ext:RowSelectionModel ID="RowSelectionModel6" SingleSelect="true" runat="server">
                                                                    </ext:RowSelectionModel>
                                                                </SelectionModel>
                                                                <BottomBar>
                                                                    <ext:PagingToolbar ID="PagingToolBarNewAttachement" runat="server" PageSize="100"
                                                                        StoreID="NewAttachmentStore" DisplayInfo="false" />
                                                                </BottomBar>
                                                                <SaveMask ShowMask="true" />
                                                                <LoadMask ShowMask="true" Msg="处理中……" />
                                                                <Listeners>
                                                                    <Command Handler="if (command == 'Delete'){
                                                                                Ext.Msg.confirm('警告', '是否要删除该附件文件?',
                                                                                    function(e) {
                                                                                        if (e == 'yes') {
                                                                                            Coolite.AjaxMethods.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                                success: function() {
                                                                                                    Ext.Msg.alert('Message', '删除附件成功！');
                                                                                                    #{gpNewAttachment}.reload();
                                                                                                },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                        }
                                                                                    });
                                                                            }
                                                                            else if (command == 'DownLoadNew')
                                                                            {
                                                                                var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=DealerLicense';
                                                                                downloadfile(url);                                                                                
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
                        </Center>
                    </ext:BorderLayout>
                </Body>
                <Buttons>
                    <ext:Button runat="server" ID="btnsubmit" Text="提交审批" Icon="Add">
                        <Listeners>
                            <Click Handler="submit()" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button runat="server" ID="btndelete" Text="删除草稿" Icon="Add">
                        <Listeners>
                            <Click Handler="Coolite.AjaxMethods.delete({
                                            success: function() {
                                                Ext.Msg.alert('Message', '删除成功！');
                                                       #{DetailWindow}.hide();
                                                       #{GridPanel1}.reload();
                                            },failure: function(err) {Ext.Msg.alert('Error', err);}});" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button runat="server" ID="btnsave" Text="保存草稿" Icon="Add">
                        <Listeners>
                            <Click Handler="SaveDraft()" />
                        </Listeners>
                    </ext:Button>
                    <ext:Button runat="server" ID="close" Text="关闭" Icon="Delete">
                        <Listeners>
                            <Click Handler="Close();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Window>
            <ext:Window ID="DialogCatagoryWindow" runat="server" Icon="Group" Title="产品分类选择"
                Width="800" Height="480" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
                Resizable="false" Header="false">
                <Body>
                    <ext:BorderLayout ID="BorderLayout2" runat="server">
                        <North MarginsSummary="5 5 5 5" Collapsible="true">
                            <ext:Panel ID="Panel13" runat="server" Header="false" Frame="true" AutoHeight="true">
                                <Body>
                                    <ext:ColumnLayout ID="ColumnLayout5" runat="server">
                                        <ext:LayoutColumn ColumnWidth=".5">
                                            <ext:Panel ID="Panel14" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtCFN" runat="server" Width="200" FieldLabel="产品分类代码" EmptyText=""
                                                                SelectOnFocus="true" EmptyClass="x-form-empty-field" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                        <ext:LayoutColumn ColumnWidth=".5">
                                            <ext:Panel ID="Panel16" runat="server" Border="false" Header="false">
                                                <Body>
                                                    <ext:FormLayout ID="FormLayout9" runat="server" LabelAlign="Left" LabelWidth="80">
                                                        <ext:Anchor>
                                                            <ext:TextField ID="txtLotNumber" runat="server" FieldLabel="产品分类名称" EmptyText=""
                                                                Width="200" SelectOnFocus="true" EmptyClass="x-form-empty-field" />
                                                        </ext:Anchor>
                                                    </ext:FormLayout>
                                                </Body>
                                            </ext:Panel>
                                        </ext:LayoutColumn>
                                    </ext:ColumnLayout>
                                </Body>
                                <Buttons>
                                    <ext:Button ID="Button3" Text="查询" runat="server" Icon="ArrowRefresh" IDMode="Legacy">
                                        <Listeners>
                                            <Click Handler="#{gpDialogCatagory}.reload();" />
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </North>
                        <Center MarginsSummary="0 5 5 5">
                            <ext:Panel ID="Panel17" runat="server" Height="300" Header="false">
                                <Body>
                                    <ext:FitLayout ID="FitLayout5" runat="server">
                                        <ext:GridPanel ID="gpDialogCatagory" runat="server" StoreID="LicenseCatagoryStore"
                                            Title="查询结果" Border="false" Icon="Lorry" StripeRows="true" AutoWidth="true">
                                            <ColumnModel ID="ColumnModel5" runat="server">
                                                <Columns>
                                                    <ext:Column ColumnID="NewCatagoryID" DataIndex="CatagoryID" Header="产品分类代码" Width="100">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="NewCatagoryName" DataIndex="CatagoryName" Header="产品分类名称" Width="300">
                                                    </ext:Column>
                                                    <ext:Column ColumnID="NewCatagoryType" DataIndex="CatagoryType" Header="分类级别" Width="100">
                                                    </ext:Column>
                                                </Columns>
                                            </ColumnModel>
                                            <SelectionModel>
                                                <ext:CheckboxSelectionModel ID="CheckboxSelectionModel2" runat="server" Visible="true" SelectedRecordID="NewCatagoryID">
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
                </Body>
                <Buttons>
                    <ext:Button ID="AddItemsButton" runat="server" Text="添加" Icon="Add">
                        <Listeners>
                            <Click Handler="addItems(#{gpDialogCatagory});" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
                <Buttons>
                    <ext:Button ID="btnClose" runat="server" Text="关闭" Icon="Cancel">
                        <Listeners>
                            <Click Handler="#{DialogCatagoryWindow}.hide()" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Window>
            <ext:Window ID="AttachmentWindow" runat="server" Icon="Group" Title="上传附件" Resizable="false"
                Header="false" Width="500" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false"
                BodyStyle="padding:5px;">
                <Body>
                    <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Header="false"
                        AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                        <Defaults>
                            <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                            <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                            <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                        </Defaults>
                        <Body>
                            <ext:FormLayout ID="FormLayout10" runat="server" LabelWidth="50">
                                <ext:Anchor>
                                    <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择上传附件" FieldLabel="文件"
                                        ButtonText="" Icon="ImageAdd">
                                    </ext:FileUploadField>
                                </ext:Anchor>
                            </ext:FormLayout>
                        </Body>
                        <Listeners>
                            <ClientValidation Handler="#{SaveButton}.setDisabled(!valid);" />
                        </Listeners>
                        <Buttons>
                            <ext:Button ID="SaveButton" runat="server" Text="上传附件">
                                <AjaxEvents>
                                    <Click OnEvent="UploadClick" Before="if(!#{BasicForm}.getForm().isValid()) { return false; } 
                                        Ext.Msg.wait('正在上传附件...', '附件上传');"
                                        Failure="Ext.Msg.show({ 
                                        title   : '错误', 
                                        msg     : '上传中发生错误', 
                                        minWidth: 200, 
                                        modal   : true, 
                                        icon    : Ext.Msg.ERROR, 
                                        buttons : Ext.Msg.OK 
                                    });"
                                        Success="#{gpNewAttachment}.reload();#{FileUploadField1}.setValue('')">
                                    </Click>
                                </AjaxEvents>
                            </ext:Button>
                            <ext:Button ID="ResetButton" runat="server" Text="清除">
                                <Listeners>
                                    <Click Handler="#{BasicForm}.getForm().reset();#{SaveButton}.setDisabled(true);" />
                                </Listeners>
                            </ext:Button>
                        </Buttons>
                    </ext:FormPanel>
                </Body>
                <Listeners>
                    <Hide Handler="#{gpNewAttachment}.reload();" />
                    <BeforeShow Handler="#{FileUploadField1}.setValue('');" />
                </Listeners>
            </ext:Window>
            <ext:Window ID="AddressWindow" runat="server" Icon="Group" Title="添加地址" Resizable="false"
                Header="false" Width="500" AutoHeight="true" AutoShow="false" Modal="true" ShowOnLoad="false"
                BodyStyle="padding:5px;">
                <Body>
                    <ext:FitLayout ID="FitLayout2" runat="server">
                        <ext:Panel ID="Panel" runat="server" AutoScroll="true" BodyStyle="padding:10px;" AutoHeight="true">
                            <Body>
                                <ext:FormLayout ID="FormLayout11" runat="server" LabelWidth="120">
                                    <ext:Anchor>
                                        <ext:Label ID="Label3" runat="server" FieldLabel="" HideLabel="true" LabelSeparator=""
                                            CtCls="txtRed" Text="提示：同一经销商有且只能包含一个默认发货地址">
                                        </ext:Label>
                                    </ext:Anchor>
                                    <ext:Anchor>
                                        <ext:Checkbox runat="server" ID="IssendAddress" FieldLabel="是否默认发货地址" Width="150">
                                            <Listeners>
                                                <Check Handler="Coolite.AjaxMethods.setstatue();" />
                                            </Listeners>
                                        </ext:Checkbox>

                                    </ext:Anchor>
                                    <ext:Anchor>
                                        <ext:ComboBox ID="cbaddresstype" runat="server" FieldLabel="地址类型" Editable="false" TypeAhead="true" EmptyText="选择地址类型" Mode="Local" Width="150">
                                            <Items>
                                                <ext:ListItem Text="经营地址" Value="经营地址" />
                                                <ext:ListItem Text="仓库地址" Value="仓库地址" />
                                                <ext:ListItem Text="住所地址" Value="住所地址" />
                                            </Items>
                                            <Triggers>
                                                <ext:FieldTrigger Icon="Clear" Qtip="清除" />
                                            </Triggers>
                                            <Listeners>
                                                <TriggerClick Handler="this.clearValue();" />
                                            </Listeners>
                                        </ext:ComboBox>
                                    </ext:Anchor>
                                    <ext:Anchor>
                                        <ext:TextArea ID="txtRemark" runat="server" Width="240" Height="70" FieldLabel="地址信息">
                                            <Listeners>
                                                <Blur Handler="CheckAddressLength();" />
                                            </Listeners>
                                        </ext:TextArea>
                                    </ext:Anchor>
                                </ext:FormLayout>
                            </Body>
                            <Buttons>
                                <ext:Button ID="BtnAdd" runat="server" Text="添加">
                                    <Listeners>
                                        <Click Handler="add();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:Button ID="Button5" runat="server" Text="取消">
                                    <Listeners>
                                        <Click Handler="#{AddressWindow}.hide()" />
                                    </Listeners>
                                </ext:Button>
                            </Buttons>
                        </ext:Panel>
                    </ext:FitLayout>
                </Body>
            </ext:Window>
        </div>
    </form>
</body>
</html>
