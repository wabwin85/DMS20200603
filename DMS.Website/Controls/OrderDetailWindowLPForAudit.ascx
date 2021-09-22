<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrderDetailWindowLPForAudit.ascx.cs"
    Inherits="DMS.Website.Controls.OrderDetailWindowLPForAudit" %>
<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>
<%@ Import Namespace="DMS.Model.Data" %>
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
</style>

<script type="text/javascript" language="javascript">
    var odwMsgList = {
        msg1: "<%=GetLocalResourceObject("ValidateForm.confirm.Body").ToString()%>",
        msg2: "<%=GetLocalResourceObject("btnCopy.OrderDetailWindow.Copy.Message").ToString()%>"
    }
    //初次载入详细信息窗口时读取数据
    function RefreshDetailWindow() {
        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
        Ext.getCmp('<%=this.gpLog.ClientID%>').reload();
        Ext.getCmp('<%=this.cbDealer.ClientID%>').store.reload();
        Ext.getCmp('<%=this.cbProductLine.ClientID%>').store.reload();
        Ext.getCmp('<%=this.cbPointType.ClientID%>').store.reload();
        Ext.getCmp('<%=this.gpConsignment.ClientID%>').store.reload();
        Ext.getCmp('<%=this.gpAttachment.ClientID%>').store.reload();

    }
    //重新读取明细行
    function ReloadDetail() {
        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
    }




    //设置是否需要保存
    var SetModified = function (isModified) {
        Ext.getCmp('<%=this.hidIsModified.ClientID%>').setValue(isModified ? "True" : "False");
    }




    //屏蔽刷新Store时的提示
    var StoreCommitAll = function (store) {
        for (var i = 0; i < store.getCount() ; i++) {
            var record = store.getAt(i);
            if (record.dirty) {
                record.commit();
            }
        }
    }

    var ShowEditingMask = function () {
        var win = Ext.getCmp('<%=this.DetailWindow.ClientID%>');
        win.body.mask('<%=GetLocalResourceObject("ShowEditingMask.mask").ToString()%>', 'x-mask-loading');
        SetWinBtnDisabled(win, true);
    }

    var SetWinBtnDisabled = function (win, disabled) {
        for (var i = 0; i < win.buttons.length; i++) {
            win.buttons[i].setDisabled(disabled);
        }
    }

    //订单类型加载时刷新
    function OrderTypeStoreLoad() {
        var hidIsPageNew = Ext.getCmp('<%=this.hidIsPageNew.ClientID%>');
        var cbOrderType = Ext.getCmp('<%=this.cbOrderType.ClientID%>');
        var hidOrderType = Ext.getCmp('<%=this.hidOrderType.ClientID%>');
        var cbWarehouse = Ext.getCmp('<%=this.cbWarehouse.ClientID%>');
        var hidWareHouseType = Ext.getCmp('<%=this.hidWareHouseType.ClientID%>');

        if (hidIsPageNew.getValue() == 'True') {
            cbOrderType.setValue(cbOrderType.store.getTotalCount() > 0 ? cbOrderType.store.getAt(0).get('Key') : '');
            hidOrderType.setValue(cbOrderType.getValue());
        } else {
            cbOrderType.setValue(hidOrderType.getValue());
        }


        if (cbOrderType.getValue() == '<%=PurchaseOrderType.Normal.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.Transfer.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.PEGoodsReturn.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.EEGoodsReturn.ToString() %>') {
            hidWareHouseType.setValue('Normal');
        }
        else if (cbOrderType.getValue() == '<%=PurchaseOrderType.ConsignmentSales.ToString() %>') {
            hidWareHouseType.setValue('Consignment');
        }
        else if (cbOrderType.getValue() == '<%=PurchaseOrderType.Consignment.ToString() %>') {
            hidWareHouseType.setValue('Consignment,Borrow');
        }
        else if (cbOrderType.getValue() == '<%=PurchaseOrderType.Borrow.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.ClearBorrow.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.ClearBorrowManual.ToString() %>') {
            hidWareHouseType.setValue('Borrow');
        }
        else if (cbOrderType.getValue() == '<%=PurchaseOrderType.SpecialPrice.ToString() %>') {
            hidWareHouseType.setValue('Normal');

        }
        else {
            hidWareHouseType.setValue('Normal');
        }

    cbWarehouse.store.reload();
    Coolite.AjaxMethods.OrderDetailWindowLP.SetLotNumberHidden();
    Coolite.AjaxMethods.OrderDetailWindowLP.SetSpecialPriceHidden();

}

function SpecialPriceInit() {
    var cbSpecialPrice = Ext.getCmp('<%=this.cbSpecialPrice.ClientID%>');
    var txtSpecialPrice = Ext.getCmp('<%=this.txtSpecialPrice.ClientID%>');
    var taPolicyContent = Ext.getCmp('<%=this.taPolicyContent.ClientID%>');
    var index = cbSpecialPrice.store.find('Id', cbSpecialPrice.getValue());
    if (index >= 0) {
        txtSpecialPrice.setValue(cbSpecialPrice.store.getAt(index).get('Code'));
        taPolicyContent.setValue(cbSpecialPrice.store.getAt(index).get('Content'));
    }
}



var DoAgree = function () {
    Ext.Msg.confirm('Message', '<%=GetLocalResourceObject("DoAgree.confirm.Body").ToString()%>',
                  function (e) {
                      if (e == 'yes') {
                          Coolite.AjaxMethods.OrderDetailWindowLP.Agree(
                              {
                                  success: function () {
                                      Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                      RefreshMainPage();
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

                  var DoReject = function () {
                      var txtRejectReason = Ext.getCmp('<%=this.txtRejectReason.ClientID%>');
                      var tabPanel = Ext.getCmp('<%=this.TabPanel1.ClientID%>');
                      if (txtRejectReason.getValue() == '' || txtRejectReason.getValue().length > 200) {
                          tabPanel.setActiveTab(0);
                          Ext.Msg.alert('Message', '<%=GetLocalResourceObject("DoReject.alert.Body").ToString()%>');
                          return;
                      }
                      Ext.Msg.confirm('Message', '<%=GetLocalResourceObject("DoReject.confirm.Body").ToString()%>',
                              function (e) {
                                  if (e == 'yes') {
                                      Coolite.AjaxMethods.OrderDetailWindowLP.Reject(
                                          {
                                              success: function () {
                                                  Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                  RefreshMainPage();
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

                              var DoRevokeConfirm = function () {
                                  var txtRejectReason = Ext.getCmp('<%=this.txtRejectReason.ClientID%>');
                                  var tabPanel = Ext.getCmp('<%=this.TabPanel1.ClientID%>');
                                  //        if (txtRejectReason.getValue() == '' || txtRejectReason.getValue().length > 200) {
                                  //            tabPanel.setActiveTab(0);
                                  //            Ext.Msg.alert('Message', '<%=GetLocalResourceObject("DoRevokeConfirm.alert.Body").ToString()%>');
                                  //            return;
                                  //        }
                                  Ext.Msg.confirm('Message', '<%=GetLocalResourceObject("DoRevokeConfirm.confirm.Body").ToString()%>',
                                          function (e) {
                                              if (e == 'yes') {
                                                  Coolite.AjaxMethods.OrderDetailWindowLP.RevokeConfirm(
                                                      {
                                                          success: function () {
                                                              Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                              RefreshMainPage();
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

                                          var DoOrderComplete = function () {
                                              var txtRejectReason = Ext.getCmp('<%=this.txtRejectReason.ClientID%>');
                                              var tabPanel = Ext.getCmp('<%=this.TabPanel1.ClientID%>');
                                              var ConfirmMsg = '<%=GetLocalResourceObject("DoOrderComplete.confirm.Body").ToString()%>'
                                              var cbOrderType = Ext.getCmp('<%=this.cbOrderType.ClientID%>');
                                              if (cbOrderType.getValue() == '<%=PurchaseOrderType.SpecialPrice.ToString() %>') {
                                                  ConfirmMsg = '此订单为特殊价格订单，是否要同意关闭？';
                                              }

                                              Ext.Msg.confirm('Message', ConfirmMsg,
                                                      function (e) {
                                                          if (e == 'yes') {
                                                              Coolite.AjaxMethods.OrderDetailWindowLP.CompleteOrder(
                                                                  {
                                                                      success: function () {
                                                                          Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                                          RefreshMainPage();
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

                                                      var DoRejectRevoke = function () {
                                                          var txtRejectReason = Ext.getCmp('<%=this.txtRejectReason.ClientID%>');
                                                          var tabPanel = Ext.getCmp('<%=this.TabPanel1.ClientID%>');
                                                          Ext.Msg.confirm('Message', '<%=GetLocalResourceObject("DoOrderComplete.confirm.Body").ToString()%>',
                                                                  function (e) {
                                                                      if (e == 'yes') {
                                                                          Coolite.AjaxMethods.OrderDetailWindowLP.RejectRevoke(
                                                                              {
                                                                                  success: function () {
                                                                                      Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                                                    RefreshMainPage();
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

                                                                var DoRejectComplete = function () {
                                                                    var txtRejectReason = Ext.getCmp('<%=this.txtRejectReason.ClientID%>');
                                                        var tabPanel = Ext.getCmp('<%=this.TabPanel1.ClientID%>');
                                                        Ext.Msg.confirm('Message', '<%=GetLocalResourceObject("DoOrderComplete.confirm.Body").ToString()%>',
                                                                function (e) {
                                                                    if (e == 'yes') {
                                                                        Coolite.AjaxMethods.OrderDetailWindowLP.RejectComplete(
                                                                            {
                                                                                success: function () {
                                                                                    Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                                                    RefreshMainPage();
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

                                                                function getCurrentInvRowClass(record, index) {
                                                                    var orderStatus = Ext.getCmp('<%=this.hidOrderStatus.ClientID%>');
                                                        if (orderStatus.getValue() == '<%=PurchaseOrderStatus.Delivering.ToString() %>' || orderStatus.getValue() == '<%=PurchaseOrderStatus.Completed.ToString() %>' || orderStatus.getValue() == '<%=PurchaseOrderStatus.ApplyComplete.ToString() %>') {

                                                            if (record.data.ReceiptQty < record.data.RequiredQty) {
                                                                return 'yellow-row';
                                                            }
                                                        }
                                                    }

                                                    var addItems = function (grid) {
                                                        if (grid.hasSelection()) {
                                                            var chklist = document.getElementsByName("chkItem");
                                                            var txtlist = document.getElementsByName("txtItem");
                                                            var paramWithQty = '';
                                                            for (var i = 0; i < chklist.length; i++) {
                                                                if (chklist[i].checked) {
                                                                    paramWithQty += chklist[i].value + '@' + txtlist[i].value + ',';
                                                                }
                                                            }
                                                            if (paramWithQty == '') {
                                                                Ext.MessageBox.alert('Error', '请选择要通知的产品');
                                                                return;
                                                            }
                                                            Coolite.AjaxMethods.OrderDetailWindowLP.DoAddItems(paramWithQty,
                                                                        {
                                                                            success: function () {
                                                                                //clearItems();
                                                                                //ReloadDetail();
                                                                            },
                                                                            failure: function (err) {
                                                                                Ext.Msg.alert('Error', err);
                                                                            }
                                                                        }
                                                                        );

                                                        } else {
                                                            Ext.MessageBox.alert('Message', '请选择要通知的产品');
                                                        }
                                                    }

                                                    var RenderCheckBox = function (value) {
                                                        return "<input type='checkbox' name='chkItem' value='" + value + "'>";

                                                    }

                                                    var RenderTextBox = function (value) {
                                                        return "<input type='text' name='txtItem' id='tb" + value.toString() + "' value='1' style='width:40px;color:blue;border:1px solid #D0D0D0;background-color: #FFFFBF;' align='Right' >";
                                                    }

                                                    function downloadfile(url) {
                                                        var iframe = document.createElement("iframe");
                                                        iframe.src = url;
                                                        iframe.style.display = "none";
                                                        document.body.appendChild(iframe);
                                                    }
</script>

<ext:Store ID="DetailStore" runat="server" OnRefreshData="DetailStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="PohId" />
                <ext:RecordField Name="CfnId" />
                <ext:RecordField Name="CustomerFaceNbr" />
                <ext:RecordField Name="CfnChineseName" />
                <ext:RecordField Name="CfnEnglishName" />
                <ext:RecordField Name="CfnPrice" />
                <ext:RecordField Name="CfnPriceNoTax" />
                <ext:RecordField Name="Uom" />
                <ext:RecordField Name="RequiredQty" />
                <ext:RecordField Name="Amount" />
                <ext:RecordField Name="ReceiptQty" />
                <ext:RecordField Name="LotNumber" />
                <ext:RecordField Name="VirtualDCCode" />
                <ext:RecordField Name="IsSpecial" />
                <ext:RecordField Name="CanOrderNumber" />
                <ext:RecordField Name="CurRegNo" />
                <ext:RecordField Name="CurValidDateFrom" />
                <ext:RecordField Name="CurValidDataTo" />
                <ext:RecordField Name="CurManuName" />
                <ext:RecordField Name="LastRegNo" />
                <ext:RecordField Name="LastValidDateFrom" />
                <ext:RecordField Name="LastValidDataTo" />
                <ext:RecordField Name="LastManuName" />
                <ext:RecordField Name="CurGMKind" />
                <ext:RecordField Name="CurGMCatalog" />
                <ext:RecordField Name="PointAmount" />
                <ext:RecordField Name="DiscountRate" />
                <ext:RecordField Name="ExpDate" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <BeforeLoad Handler="#{DetailWindow}.body.mask('Loading...', 'x-mask-loading');" />
        <Load Handler="#{DetailWindow}.body.unmask();" />
        <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
    </Listeners>
</ext:Store>
<ext:Store ID="ConsignmentStore" runat="server" UseIdConfirmation="false" OnRefreshData="ConsignmentStore_RefershData" AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="CAH_RDD" />
                <ext:RecordField Name="CAH_SalesName" />
                <ext:RecordField Name="CAH_SalesPhone" />
                <ext:RecordField Name="CAH_SalesEmail" />
                <ext:RecordField Name="CAH_OrderNo" />
                <ext:RecordField Name="CAH_CM_Type" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" OnRefreshData="OrderLogStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="PohId" />
                <ext:RecordField Name="OperUser" />
                <ext:RecordField Name="OperUserId" />
                <ext:RecordField Name="OperUserName" />
                <ext:RecordField Name="OperType" />
                <ext:RecordField Name="OperTypeName" />
                <ext:RecordField Name="OperDate" Type="Date" />
                <ext:RecordField Name="OperNote" />
            </Fields>
        </ext:JsonReader>
    </Reader>
</ext:Store>
<ext:Store ID="ProductLineStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_RefreshProductLine"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="AttributeName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbProductLine}.setValue(#{hidProductLine}.getValue());" />
        <%--<Load Handler="#{cbProductLine}.setValue(#{hidProductLine}.getValue());Coolite.AjaxMethods.OrderDetailWindowLP.ProductLineInit();" />--%>
    </Listeners>
    <SortInfo Field="Id" Direction="ASC" />
</ext:Store>
<ext:Store ID="OrderTypeStore" runat="server" UseIdConfirmation="true">
    <Reader>
        <ext:JsonReader ReaderID="Key">
            <Fields>
                <ext:RecordField Name="Key" />
                <ext:RecordField Name="Value" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <BaseParams>
    </BaseParams>
    <Listeners>
        <Load Handler="OrderTypeStoreLoad()" />
    </Listeners>
</ext:Store>
<ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_DealerList"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="ChineseName" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="#{cbDealer}.setValue(#{hidDealerId}.getValue());" />
    </Listeners>
    <%--<SortInfo Field="ChineseName" Direction="ASC" />--%>
</ext:Store>
<ext:Store ID="WarehouseStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_WarehouseByDealerAndType"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <BaseParams>
        <ext:Parameter Name="DealerId" Value="#{hidDealerId}.getValue()==''?'00000000-0000-0000-0000-000000000000':#{hidDealerId}.getValue()"
            Mode="Raw" />
        <ext:Parameter Name="DealerWarehouseType" Value="#{hidWareHouseType}.getValue()"
            Mode="Raw" />
    </BaseParams>
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbWarehouse}.setValue(#{cbWarehouse}.store.getTotalCount()>0?#{cbWarehouse}.store.getAt(0).get('Id'):'');}else{ if(#{hidWarehouse}.getValue()==''){#{cbWarehouse}.setValue(#{cbWarehouse}.store.getTotalCount()>0?#{cbWarehouse}.store.getAt(0).get('Id'):'');}else{#{cbWarehouse}.setValue(#{hidWarehouse}.getValue());}}" />
        <LoadException Handler="Ext.Msg.alert('Warehouse - Load failed', e.message || response.statusText);" />
    </Listeners>
    <SortInfo Field="Name" Direction="ASC" />
</ext:Store>
<ext:Store ID="SpecialPriceStore" runat="server" UseIdConfirmation="true">
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Code" />
                <ext:RecordField Name="Name" />
                <ext:RecordField Name="Content" />
                <ext:RecordField Name="Type" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="if(#{hidSpecialPrice}.getValue()==''){#{cbSpecialPrice}.setValue(#{cbSpecialPrice}.store.getTotalCount()>0?#{cbSpecialPrice}.store.getAt(0).get('Id'):'');#{hidSpecialPrice}.setValue(#{cbSpecialPrice}.getValue());SpecialPriceInit();}else{#{cbSpecialPrice}.setValue(#{hidSpecialPrice}.getValue());SpecialPriceInit();}" />
        <LoadException Handler="Ext.Msg.alert('Warehouse - Load failed', e.message || response.statusText);" />
    </Listeners>
    <%-- <SortInfo Field="Name" Direction="ASC" />--%>
</ext:Store>
<ext:Store ID="PointTypeStore" runat="server" UseIdConfirmation="true" OnRefreshData="PointTypeStore_RefershData"
    AutoLoad="false">
    <Reader>
        <ext:JsonReader ReaderID="Key">
            <Fields>
                <ext:RecordField Name="Key" />
                <ext:RecordField Name="Value" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbPointType}.setValue(#{cbPointType}.store.getTotalCount()>0?#{cbPointType}.store.getAt(0).get('Key'):'');#{hidPointType}.setValue(#{cbPointType}.getValue());}else{#{cbPointType}.setValue(#{hidPointType}.getValue());}" />
    </Listeners>
</ext:Store>

<ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" AutoLoad="false" OnRefreshData="AttachmentStore_Refresh">
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
                        <ext:RecordField Name="IsCurrent" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
        </ext:Store>
<ext:Hidden ID="hidIsPageNew" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIsModified" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIsSaved" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidInstanceId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidDealerId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidProductLine" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidOrderStatus" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidEditItemId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidTerritoryCode" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnVal" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnMsg" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidRtnRegMsg" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidLatestAuditDate" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidOrderType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWareHouseType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidWarehouse" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPriceType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidSpecialPrice" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPohId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidCreateType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidUpdateDate" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPointType" runat="server">
</ext:Hidden>
<ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>"
    Width="1024" Height="490" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false" CenterOnLoad="true" Y="10" Maximizable="true">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:FormPanel ID="FormPanel1" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".24">
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                    <Body>
                                        <%--表头信息 --%>
                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="60">
                                            <%--订单类型、订单编号、提交日期 --%>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbOrderType" runat="server" EmptyText="<%$ Resources: cbOrderType.EmptyText %>"
                                                    Width="120" Editable="false" TypeAhead="true" StoreID="OrderTypeStore" ValueField="Key"
                                                    AllowBlank="false" Mode="Local" DisplayField="Value" FieldLabel="<%$ Resources: txtOrderType.FieldLabel %>">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>"
                                                            HideTrigger="true" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                        <%--<Select Handler="#{hidOrderType}.setValue(#{cbOrderType}.getValue());" />--%>
                                                        <Select Handler="#{btnAddCfn}.setDisabled(true);#{btnAddCfnSet}.setDisabled(true);" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderNo" runat="server" FieldLabel="<%$ Resources: txtOrderNo.FieldLabel %>"
                                                    Width="120" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".24">
                                <ext:Panel ID="Panel8" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout5" runat="server" LabelAlign="Left" LabelWidth="60">
                                            <%--产品线、订单状态、财务信息 --%>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbProductLine" runat="server" Width="120" Editable="false" TypeAhead="true"
                                                    Disabled="true" StoreID="ProductLineStore" ValueField="Id" DisplayField="AttributeName"
                                                    FieldLabel="<%$ Resources: cbProductLine.FieldLabel %>" AllowBlank="false" BlankText="<%$ Resources: cbProductLine.BlankText %>"
                                                    EmptyText="<%$ Resources: cbProductLine.EmptyText %>" ListWidth="200" Resizable="true">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>"
                                                            HideTrigger="true" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderStatus" runat="server" FieldLabel="<%$ Resources: txtOrderStatus.FieldLabel %>"
                                                    Width="120" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".3">
                                <ext:Panel ID="Panel9" runat="server" Border="false" Header="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout6" runat="server" LabelAlign="Left" LabelWidth="60">
                                            <%--经销商、订单对象 --%>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbDealer" runat="server" Width="200" Editable="true" TypeAhead="true"
                                                    StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName" FieldLabel="<%$ Resources: cbDealer.FieldLabel %>"
                                                    Mode="Local" AllowBlank="false" BlankText="<%$ Resources: cbDealer.BlankText %>"
                                                    EmptyText="<%$ Resources: cbDealer.EmptyText %>" ListWidth="300" Resizable="true">
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderTo" runat="server" FieldLabel="<%$ Resources: txtOrderTo.FieldLabel %>"
                                                    Width="200" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".22">
                                <ext:Panel ID="PanelSubmitDate" runat="server" Border="false" Header="false">
                                    <Body>
                                        <%--表头信息 --%>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left" LabelWidth="60">
                                            <%--订单类型、订单编号、提交日期 --%>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtSubmitDate" runat="server" FieldLabel="<%$ Resources: txtSubmitDate.FieldLabel %>"
                                                    Width="130" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbPointType" runat="server" EmptyText="<%$ Resources: cbPointType.EmptyText %>"
                                                    Width="120" Editable="false" TypeAhead="true" StoreID="PointTypeStore" ValueField="Key"
                                                    ListWidth="200" Mode="Local" DisplayField="Value" FieldLabel="<%$ Resources: cbPointType.FieldLabel %>">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbPointType.FieldTrigger.Qtip %>"
                                                            HideTrigger="true" />
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
                <ext:TabPanel ID="TabPanel1" runat="server" ActiveTabIndex="0" Plain="true">
                    <Tabs>
                        <ext:Tab ID="TabHeader" runat="server" Title="<%$ Resources: TabHeader.Title %>"
                            BodyStyle="padding: 6px;" AutoScroll="true">
                            <%--表头信息 --%>
                            <Body>
                                <ext:FitLayout ID="FTHeader" runat="server">
                                    <ext:FormPanel ID="FormPanel2" runat="server" Header="false" Border="false">
                                        <Body>
                                            <ext:ColumnLayout ID="ColumnLayout3" runat="server" Split="false">
                                                <ext:LayoutColumn ColumnWidth=".3">
                                                    <ext:Panel ID="Panel4" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: Panel4.Title %>">
                                                        <%--汇总信息 --%>
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left" LabelWidth="125">
                                                                <ext:Anchor>
                                                                    <ext:Label ID="txtCurrency" runat="server" FieldLabel="订单币种"></ext:Label>
                                                                </ext:Anchor>
                                                                <%--金额汇总、数量汇总、VirtualDC、备注 --%>
                                                                <ext:Anchor>
                                                                    <ext:NumberField ID="txtTotalAmount" runat="server" FieldLabel="<%$ Resources: txtTotalAmount.FieldLabel %>"
                                                                        Width="125">
                                                                    </ext:NumberField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:NumberField ID="txtTotalAmountNoTax" runat="server" FieldLabel="不含税总金额" Width="125">
                                                                    </ext:NumberField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:NumberField ID="txtTotalQty" runat="server" FieldLabel="<%$ Resources: txtTotalQty.FieldLabel %>"
                                                                        Width="125">
                                                                    </ext:NumberField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtVirtualDC" runat="server" Width="125" FieldLabel="<%$ Resources: lbVirtualDC.FieldLabel %>"
                                                                        AllowBlank="true" MsgTarget="Side" ReadOnly="true" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtMHD" runat="server" Width="125" FieldLabel="ManHeaderDisc%"
                                                                        AllowBlank="true" ReadOnly="true" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Label ID="lbRemark" runat="server" FieldLabel="<%$ Resources: lbRemark.FieldLabel %>">
                                                                    </ext:Label>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextArea ID="txtRemark" runat="server" Width="255" Height="80" HideLabel="true" />
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                                <ext:LayoutColumn ColumnWidth=".3">
                                                    <ext:Panel ID="Panel5" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: Panel5.Title %>">
                                                        <%--订单信息 --%>
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="80">

                                                                <ext:Anchor>
                                                                    <ext:ToolTip Html="<font color='red'><b>如订单有问题，请联系ChinaShareservice</b></font>" HideBorders="true" BodyBorder="false" runat="server" ID="tt1"></ext:ToolTip>
                                                                </ext:Anchor>
                                                                <%--特殊价格规则名称、特殊价格规则编号、订单联系人、联系方式、手机号码 --%>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="cbSpecialPrice" runat="server" EmptyText="<%$ Resources: cbSpecialPriceName.EmptyText %>"
                                                                        Width="195" Editable="false" Disabled="false" TypeAhead="true" StoreID="SpecialPriceStore"
                                                                        ListWidth="225" ValueField="Id" AllowBlank="true" Mode="Local" DisplayField="Name"
                                                                        FieldLabel="<%$ Resources: cbSpecialPriceName.FieldLabel %>">
                                                                        <Triggers>
                                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>"
                                                                                HideTrigger="true" />
                                                                        </Triggers>
                                                                        <Listeners>
                                                                            <TriggerClick Handler="this.clearValue();" />
                                                                            <%--<Select Handler="ChangeSpecialPrice();" />--%>
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtSpecialPrice" runat="server" Width="195" FieldLabel="<%$ Resources: txtSpecialPriceCode.FieldLabel %>"
                                                                        AllowBlank="true" MsgTarget="Side" MaxLength="120">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Panel ID="pPolicyContent" runat="server" Border="false">
                                                                        <Body>
                                                                            <ext:HtmlEditor ID="taPolicyContent" runat="server" Width="280" Height="120" HideLabel="true"
                                                                                ReadOnly="true" EnableAlignments="false" EnableColors="false" EnableFont="false"
                                                                                EnableFontSize="false" EnableFormat="false" EnableLinks="false" EnableLists="false"
                                                                                EnableSourceEdit="false" />
                                                                            <br />
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtContactPerson" runat="server" Width="195" FieldLabel="<%$ Resources: txtContactPerson.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtContactPerson.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="100" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtContact" runat="server" Width="195" FieldLabel="<%$ Resources: txtContact.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtContact.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="100" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtContactMobile" runat="server" Width="195" FieldLabel="<%$ Resources: txtContactMobile.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtContactMobile.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="100" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txt6MonthsExpProduct" runat="server" Width="195" FieldLabel="是否接受<6个月效期的产品"
                                                                        AllowBlank="true" BlankText="" MsgTarget="Side" MaxLength="100" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Label ID="lbRejectReason" runat="server" FieldLabel="<%$ Resources: lbRejectReason.FieldLabel %>"
                                                                        HideLabel="true">
                                                                    </ext:Label>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextArea ID="txtRejectReason" runat="server" Width="280" Height="100" HideLabel="true" />
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                                <ext:LayoutColumn ColumnWidth=".4">
                                                    <ext:Panel ID="Panel10" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: Panel10.Title %>">
                                                        <%-- 收货信息 --%>
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left">
                                                                <%--收货仓库选择、收货地址、收货人、收货人电话、期望到货时间、承运商 --%>
                                                                <ext:Anchor>
                                                                    <ext:RadioGroup ID="ReceivingWay" runat="server" Width="220" FieldLabel="" LabelSeparator="">
                                                                        <Items>
                                                                            <ext:Radio ID="PickUp" runat="server" BoxLabel="自提" Width="60" />
                                                                            <ext:Radio ID="Deliver" runat="server" BoxLabel="送货/承运商承运" />
                                                                        </Items>
                                                                    </ext:RadioGroup>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="cbWarehouse" runat="server" EmptyText="<%$ Resources: cbWarehouse.EmptyText %>"
                                                                        Width="250" Editable="false" Disabled="false" TypeAhead="true" StoreID="WarehouseStore"
                                                                        ListWidth="220" ValueField="Id" AllowBlank="false" Mode="Local" DisplayField="Name"
                                                                        FieldLabel="<%$ Resources: cbWarehouse.FieldLabel %>">
                                                                        <Triggers>
                                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>"
                                                                                HideTrigger="true" />
                                                                        </Triggers>
                                                                        <Listeners>
                                                                            <TriggerClick Handler="this.clearValue();" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtShipToAddress" runat="server" Width="250" FieldLabel="<%$ Resources: txtShipToAddress.FieldLabel %>"
                                                                        AllowBlank="false" BlankText="<%$ Resources: txtShipToAddress.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="200">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="Texthospitalname" runat="server" FieldLabel="医院名称"
                                                                        AllowBlank="true" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="HospitalAddress" runat="server" Width="150" FieldLabel="医院地址"
                                                                        AllowBlank="true" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtConsignee" runat="server" Width="150" FieldLabel="<%$ Resources: txtConsignee.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtConsignee.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="200" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtConsigneePhone" runat="server" Width="150" FieldLabel="<%$ Resources: txtConsigneePhone.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtConsigneePhone.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="200" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:DateField ID="dtRDD" runat="server" Width="150" FieldLabel="<%$ Resources: dtRDD.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: dtRDD.BlankText %>" MsgTarget="Side" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtCarrier" runat="server" Width="150" FieldLabel="<%$ Resources: txtCarrier.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtCarrier.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="200">
                                                                    </ext:TextField>
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
                        <ext:Tab ID="TabDetail" runat="server" Title="<%$ Resources: TabDetail.Title %>"
                            AutoScroll="false">
                            <Body>
                                <ext:FitLayout ID="FT1" runat="server">
                                    <ext:GridPanel ID="gpDetail" runat="server" Title="<%$ Resources: gpDetail.Title %>"
                                        StoreID="DetailStore" StripeRows="true" Border="false" Icon="Lorry" ClicksToEdit="1"
                                        EnableHdMenu="false" Header="false" AutoExpandColumn="CfnEnglishName">
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CustomerFaceNbr" Width="110" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnChineseName" Width="210" DataIndex="CfnChineseName" Header="<%$ Resources: gpDetail.CfnChineseName %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnEnglishName" DataIndex="CfnEnglishName" Header="<%$ Resources: gpDetail.CfnEnglishName %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="RequiredQty" DataIndex="RequiredQty" Header="<%$ Resources: gpDetail.RequiredQty %>"
                                                    Width="80" Align="Right">
                                                    <Editor>
                                                        <ext:NumberField ID="txtRequiredQty" runat="server" AllowBlank="false" AllowDecimals="false"
                                                            Disabled="true" DataIndex="RequiredQty" SelectOnFocus="true" AllowNegative="false">
                                                        </ext:NumberField>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnPrice" DataIndex="CfnPrice" Width="80" Align="Right" Header="<%$ Resources: gpDetail.CfnPrice %>">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnPriceNoTax" DataIndex="CfnPriceNoTax" Width="80" Align="Right"
                                                    Header="不含税单价">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="Uom" DataIndex="Uom" Width="45" Align="Center" Header="<%$ Resources: gpDetail.Uom %>"
                                                    Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount" DataIndex="Amount" Width="90" Align="Right" Header="<%$ Resources: gpDetail.Amount %>">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                    <Editor>
                                                        <ext:NumberField ID="txtAmount" runat="server" AllowBlank="false" DataIndex="Amount"
                                                            Disabled="true" SelectOnFocus="true" AllowNegative="false" DecimalPrecision="6">
                                                        </ext:NumberField>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="VirtualDCCode" DataIndex="VirtualDCCode" Align="Center" Header="<%$ Resources: gpDetail.VirtualDC %>"
                                                    Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="IsSpecial" DataIndex="IsSpecial" Align="Center" Header="<%$ Resources: gpDetail.IsSpecialPrice %>"
                                                    Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="LotNumber" DataIndex="LotNumber" Header="<%$ Resources: gpDetail.LotNumber %>"
                                                    Width="80">
                                                    <Editor>
                                                        <ext:TextField ID="txtLotNumber" runat="server" AllowBlank="true" DataIndex="LotNumber"
                                                            Disabled="true" SelectOnFocus="true" AllowNegative="false">
                                                        </ext:TextField>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="ReceiptQty" Width="80" Align="Right" DataIndex="ReceiptQty"
                                                    Header="<%$ Resources: gpDetail.ReceiptQty %>">
                                                </ext:Column>
                                                <%--<ext:CommandColumn Width="50" Header="<%$ Resources: gpDetail.CommandColumn.Header %>"
                                                Align="Center">
                                                <Commands>
                                                    <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources: gpDetail.CommandColumn.Header %>" />
                                                </Commands>
                                            </ext:CommandColumn>--%>
                                                <ext:Column ColumnID="CurRegNo" DataIndex="CurRegNo" Header="注册证号" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="CurManuName" DataIndex="CurManuName" Header="生产企业" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="LastRegNo" DataIndex="LastRegNo" Header="历史注册证号" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="LastManuName" DataIndex="LastManuName" Header="历史生产企业" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="PointAmount" DataIndex="PointAmount" Header="使用积分" Width="100"
                                                    Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiscountRate" DataIndex="DiscountRate" Header="折扣率" Width="100"
                                                    Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="ExpDate" DataIndex="ExpDate" Header="产品有效期"
                                                    Width="80">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <View>
                                            <ext:GridView ID="GridView1" runat="server">
                                                <GetRowClass Fn="getCurrentInvRowClass" />
                                            </ext:GridView>
                                        </View>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="true">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <Listeners>
                                        </Listeners>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="50" StoreID="DetailStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="false" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="tabConsDetail" runat="server" Title="<%$ Resources: ConsDetail.Title %>" AutoScroll="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout12" runat="server">
                                    <ext:GridPanel ID="gpConsignment" runat="server" Title="<%$ Resources: ConsDetail.Title %>" StoreID="ConsignmentStore"
                                        StripeRows="true" Collapsible="false" Border="false" Icon="Lorry">
                                        <ColumnModel ID="ColumnModel13" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CAH_RDD" DataIndex="CAH_RDD" Header="送货时间要求" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="CAH_SalesName" DataIndex="CAH_SalesName" Header="申请销售" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="CAH_SalesPhone" DataIndex="CAH_SalesPhone" Header="申请销售电话" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="CAH_SalesEmail" DataIndex="CAH_SalesEmail" Header="申请销售邮箱" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="CAH_OrderNo" DataIndex="CAH_OrderNo" Header="EWF申请单号" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="CAH_CM_Type" DataIndex="CAH_CM_Type" Header="近效期类型" Width="150">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server" MoveEditorOnEnter="true">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="15" StoreID="ConsignmentStore"
                                                DisplayInfo="false" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources: TabLog.Title %>" AutoScroll="false">
                            <Body>
                                <ext:FitLayout ID="FT2" runat="server">
                                    <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="OrderLogStore"
                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                        Icon="Lorry" AutoExpandColumn="OperNote">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="<%$ Resources: gpLog.OperUserId %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="<%$ Resources: gpLog.OperUserName %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="<%$ Resources: gpLog.OperTypeName %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="<%$ Resources: gpLog.OperDate %>"
                                                    Width="150">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="<%$ Resources: gpLog.OperNote %>"
                                                    Width="250">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel1" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="true">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar1" runat="server" PageSize="50" StoreID="OrderLogStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="TabLocal" runat="server" Title="本地化通知" AutoScroll="false" Hidden="true">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="GridPanel1" runat="server" Title="本地化通知" StoreID="DetailStore"
                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                        Icon="Lorry" AutoExpandColumn="CustomerFaceNbr">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar1" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                    <ext:Button ID="btnNotice" runat="server" Text="确定通知" Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="addItems(#{GridPanel1});" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="chkId" DataIndex="Id" Header="选择" Width="30" Sortable="false">
                                                    <Renderer Fn="RenderCheckBox" />
                                                </ext:Column>
                                                <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="EnglishName" DataIndex="EnglishName" Header="产品英文名称" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ChineseName" DataIndex="ChineseName" Header="产品中文名称" Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="UOM" DataIndex="UOM" Header="包装单位" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="ConvertFactor" DataIndex="ConvertFactor" Header="单位数量" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="ApplyQty" DataIndex="ReceiptQty" Header="申请数量" Width="80">
                                                </ext:Column>
                                                <ext:Column ColumnID="ApplyQtyDialog" DataIndex="Id" Header="订购数量(个)" Width="75" Align="Center">
                                                    <Renderer Fn="RenderTextBox" />
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="10" StoreID="DetailStore" DisplayInfo="true" DisplayMsg="记录数： {0} - {1} of {2}" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="TabAttachment" runat="server" Title="附件" Icon="BrickLink" AutoScroll="true">
                            <Body>
                                <ext:FitLayout ID="FTAttachement" runat="server">
                                    <ext:GridPanel ID="gpAttachment" runat="server" Title="附件列表" StoreID="AttachmentStore" AutoWidth="true" StripeRows="true" Collapsible="false" Border="false" Icon="Lorry" Header="false" AutoExpandColumn="Name">
                                        <ColumnModel ID="ColumnModel5" runat="server">
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
                                                        <ext:GridCommand Icon="DiskDownload" CommandName="DownLoad" ToolTip-Text="下载" />
                                                    </Commands>
                                                </ext:CommandColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel5" SingleSelect="true" runat="server">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBarAttachement" runat="server" PageSize="50" StoreID="AttachmentStore" DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="true" />
                                        <LoadMask ShowMask="true" Msg="处理中……" />
                                        <Listeners>
                                            <Command Handler=" if (command == 'DownLoad')
                                                                    {
                                                                        var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=AdjustAttachment';
                                                                        downloadfile(url);                                                                                
                                                                    }
                                                                            
                                                                    " />
                                        </Listeners>
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
        <ext:Button ID="btnAgree" runat="server" Text="<%$ Resources: btnAgree.Text %>" Icon="LorryAdd">
            <Listeners>
                <Click Handler="DoAgree();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnRevokeConfirm" runat="server" Text="<%$ Resources: btnRevokeConfirm.Text %>"
            Icon="Accept">
            <Listeners>
                <Click Handler="DoRevokeConfirm();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnOrderComplete" runat="server" Text="<%$ Resources: btnOrderComplete.Text %>"
            Icon="ApplicationStop">
            <Listeners>
                <Click Handler="DoOrderComplete();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnRejectRevoke" runat="server" Text="<%$ Resources: btnRejectRevoke.Text %>"
            Icon="ApplicationStop">
            <Listeners>
                <Click Handler="DoRejectRevoke();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnRejectComplete" runat="server" Text="<%$ Resources: btnRejectComplete.Text %>"
            Icon="ApplicationStop">
            <Listeners>
                <Click Handler="DoRejectComplete();" />
            </Listeners>
        </ext:Button>
    </Buttons>
</ext:Window>
