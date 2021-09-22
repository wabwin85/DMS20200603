<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OrderDetailWindowLP.ascx.cs"
    Inherits="DMS.Website.Controls.OrderDetailWindowLP" %>
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
        msg2: "<%=GetLocalResourceObject("btnCopy.OrderDetailWindow.Copy.Message").ToString()%>",
        msg3: "<%=GetLocalResourceObject("btnRevoke.OrderDetailWindow.Revoke.Message").ToString()%>",
        msg4: "<%=GetLocalResourceObject("btnClose.OrderDetailWindow.Close.Message").ToString()%>"
    }
    var showHospitalSelectorDlg = function() {
              
        var product = <%= cbProductLine.ClientID %>.getValue();
                                  
        if(product == null || product == "")
        {
            Ext.Msg.alert('提醒', '请选择产品线!');}
        else 
            openHospitalSearchDlg(product);
            
    }

    //初次载入详细信息窗口时读取数据
    function RefreshDetailWindow() {
        Ext.getCmp('<%=this.PagingToolBar2.ClientID%>').changePage(1);
        Ext.getCmp('<%=this.gpLog.ClientID%>').reload();
        Ext.getCmp('<%=this.gpInvoice.ClientID%>').reload();
        Ext.getCmp('<%=this.cbProductLine.ClientID%>').store.reload();
        Ext.getCmp('<%=this.cbPointType.ClientID%>').store.reload();
        Ext.getCmp('<%=this.gpAttachment.ClientID%>').store.reload();


    }
    //重新读取明细行
    function ReloadDetail() {
        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
    }

    //表单验证
    function ValidateForm() {
        var errMsg = "";
        var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
         var rtnMsg = Ext.getCmp('<%=this.hidRtnMsg.ClientID%>');
         var rtnRegMsg = Ext.getCmp('<%=this.hidRtnRegMsg.ClientID%>');

         var isForm1Valid = Ext.getCmp('<%=this.FormPanel1.ClientID%>').getForm().isValid();
         var isForm2Valid = Ext.getCmp('<%=this.FormPanel2.ClientID%>').getForm().isValid();

         var tabPanel = Ext.getCmp('<%=this.TabPanel1.ClientID%>')
         var txtRemark = Ext.getCmp('<%=this.txtRemark.ClientID%>');
         var dtRDD = Ext.getCmp('<%=this.dtRDD.ClientID%>');
         var cbPointType = Ext.getCmp('<%=this.cbPointType.ClientID%>');
         var txtContactPerson = Ext.getCmp('<%=this.txtContactPerson.ClientID%>');
         var txtContact = Ext.getCmp('<%=this.txtContact.ClientID%>');
         var txtContactMobile = Ext.getCmp('<%=this.txtContactMobile.ClientID%>');
         var txtConsignee = Ext.getCmp('<%=this.txtConsignee.ClientID%>');
         var txtConsigneePhone = Ext.getCmp('<%=this.txtConsigneePhone.ClientID%>');

         var cbSpecialPrice = Ext.getCmp('<%=this.cbSpecialPrice.ClientID%>');
         var cbOrderType = Ext.getCmp('<%=this.cbOrderType.ClientID%>');
         var hidCreateType = Ext.getCmp('<%=this.hidCreateType.ClientID%>');
         var hidUpdateDate = Ext.getCmp('<%=this.hidUpdateDate.ClientID%>');
         var hidPointCheckErr = Ext.getCmp('<%=this.hidPointCheckErr.ClientID%>');
        
         if (!isForm1Valid || !isForm2Valid || (cbPointType.getValue() == "" && cbOrderType.getValue() == '<%=PurchaseOrderType.CRPO.ToString() %>')) {
             errMsg = "<%=GetLocalResourceObject("ValidateForm.errMsgForm").ToString()%>";
        }

         //Edit by Huakaichun on 20171214 由于平台KE订单合并事宜，备注信息会比较长，并且不能被修改
       <%-- if (txtRemark.getValue().length > 132) {
            errMsg += '<%=GetLocalResourceObject("ValidateForm.errMsgConst").ToString()%>';
        }--%>

         //Edit by Songweiming on 2013-11-4 特殊价格选择暂时先不使用
         //如果选择了特殊价格订单，则必须选择特殊价格规则
         if (cbOrderType.getValue() == '<%=PurchaseOrderType.SpecialPrice.ToString() %>' && (cbSpecialPrice.getValue() == null || cbSpecialPrice.getValue() == '')) {
             errMsg += '<%=GetLocalResourceObject("ValidateForm.errMsgSpecialPrice").ToString()%>';
        }
        if (txtContactPerson.getValue() == "" || txtContact.getValue() == "" || txtContactMobile.getValue() == "") {
            errMsg += '请填写完整的联系人信息';
        }
        if (txtContactMobile.getValue() != "" && (isNaN(txtContactMobile.getValue()) || txtContactMobile.getValue().length != 11)) {
            errMsg += '请填写正确的手机号码';
        }

        if (txtConsignee.getValue() == "" || txtConsigneePhone.getValue() == "") {
            errMsg += '请填写完整的收货人信息';
        }

        var hidProductLine = Ext.getCmp('<%=this.hidProductLine.ClientID%>');
        var hidDealerType = Ext.getCmp('<%=this.hidDealerType.ClientID%>');
         //Edit By SongWeiming on 2017-04-18 去除RSM的选择
         //var cbSales = Ext.getCmp('<%=this.cbSales.ClientID%>');        
         //if (hidProductLine.getValue() == '8f15d92a-47e4-462f-a603-f61983d61b7b' && cbSales.getValue() == '' && hidDealerType.getValue() == 'T1') {
         //    errMsg += '请选择RSM！';
         //}
         var reg = /^[a-z0-9]+([._\\-]*[a-z0-9])*@(([a-zA-Z0-9_-])+\.)+([a-zA-Z0-9_-]{2,5})$/;
         if (!reg.test(txtContact.getValue())) {
             errMsg += '请输入正确的邮箱地址';
         }

         //校验组套产品订购数量
         if (cbOrderType.getValue() == '<%=PurchaseOrderType.BOM.ToString() %>') {
            Coolite.AjaxMethods.OrderDetailWindowLP.ValidateBOMQty({
                success: function (result) { if (result == "0") { errMsg += '组套产品订购数量超额，不能提交！'; } },
                failure: function (err) {
                    errMsg += '校验组套产品订购数量错误';
                }
            })
        }
        if (errMsg != "") {
            tabPanel.setActiveTab(0);
            Ext.Msg.alert('Message', errMsg);
        } else {
            if (cbOrderType.getValue() == '<%=PurchaseOrderType.CRPO.ToString() %>') {
                hidPointCheckErr.setValue("0");
                Coolite.AjaxMethods.OrderDetailWindowLP.CaculateFormValuePoint({
                    success: function (result) {
                        if (hidPointCheckErr.getValue() == "1") {
                            Ext.Msg.alert('errMsg', result + "不能提交该订单。");
                        } else {
                            Ext.Msg.confirm('Message', result + odwMsgList.msg1,
                                                  function (e) {
                                                      if (e == 'yes') {
                                                          Coolite.AjaxMethods.OrderDetailWindowLP.CheckSubmit(hidCreateType.getValue(), hidUpdateDate.getValue(), cbSpecialPrice.getValue(),
                                                                      {
                                                                          success: function () {
                                                                              if (rtnVal.getValue() == "Success") {
                                                                                  Coolite.AjaxMethods.OrderDetailWindowLP.Submit(
                                                                                  {
                                                                                      success: function () {
                                                                                          Ext.Msg.alert('Message', '<%=GetLocalResourceObject("ValidateForm.Submit.alert.Body").ToString()%>');
                                                                                          Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                                                          RefreshMainPage();
                                                                                      },
                                                                                      failure: function (err) {
                                                                                          Ext.Msg.alert('Error', err);
                                                                                      }
                                                                                  }
                                                                );
                                                                              } else if (rtnVal.getValue() == "Error") {
                                                                                  tabPanel.setActiveTab(1);
                                                                                  Ext.Msg.alert('Error', rtnMsg.getValue());
                                                                              } else if (rtnVal.getValue() == "Warn") {
                                                                                  tabPanel.setActiveTab(1);
                                                                                  Ext.Msg.confirm('Warning', rtnMsg.getValue(),
                                                                                      function (e) {
                                                                                          if (e == 'yes') {
                                                                                              Coolite.AjaxMethods.OrderDetailWindowLP.Submit(
                                                                                              {
                                                                                                  success: function () {
                                                                                                      Ext.Msg.alert('Message', '<%=GetLocalResourceObject("ValidateForm.Submit.alert.Body").ToString()%>');
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
                                                                          },
                                                                          failure: function (err) {
                                                                              Ext.Msg.alert('Error', err);
                                                                          }
                                                                      }
                                                );
                                                              }
                                                  });
                                                      }


                    }, failure: function (err) { Ext.Msg.alert('Error', err); }

                });
                                          }
                                          else if (cbOrderType.getValue() == '<%=PurchaseOrderType.BOM.ToString() %>') {
                Coolite.AjaxMethods.OrderDetailWindowLP.ValidateBOMQty({
                    success: function (result) {
                        if (result == "0") {
                            Ext.Msg.alert('errMsg', "组套产品订购数量超额，不能提交！");
                        } else {
                            Ext.Msg.confirm('Message', odwMsgList.msg1,
                                                  function (e) {
                                                      if (e == 'yes') {
                                                          Coolite.AjaxMethods.OrderDetailWindowLP.CheckSubmit(hidCreateType.getValue(), hidUpdateDate.getValue(), cbSpecialPrice.getValue(),
                                                                      {
                                                                          success: function () {
                                                                              if (rtnVal.getValue() == "Success") {
                                                                                  Coolite.AjaxMethods.OrderDetailWindowLP.Submit(
                                                                                  {
                                                                                      success: function () {
                                                                                          Ext.Msg.alert('Message', '<%=GetLocalResourceObject("ValidateForm.Submit.alert.Body").ToString()%>');
                                                                                          Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                                                          RefreshMainPage();
                                                                                      },
                                                                                      failure: function (err) {
                                                                                          Ext.Msg.alert('Error', err);
                                                                                      }
                                                                                  }
                                                                );
                                                                              } else if (rtnVal.getValue() == "Error") {
                                                                                  tabPanel.setActiveTab(1);
                                                                                  Ext.Msg.alert('Error', rtnMsg.getValue());
                                                                              } else if (rtnVal.getValue() == "Warn") {
                                                                                  tabPanel.setActiveTab(1);
                                                                                  Ext.Msg.confirm('Warning', rtnMsg.getValue(),
                                                                                      function (e) {
                                                                                          if (e == 'yes') {
                                                                                              Coolite.AjaxMethods.OrderDetailWindowLP.Submit(
                                                                                              {
                                                                                                  success: function () {
                                                                                                      Ext.Msg.alert('Message', '<%=GetLocalResourceObject("ValidateForm.Submit.alert.Body").ToString()%>');
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
                                                                          },
                                                                          failure: function (err) {
                                                                              Ext.Msg.alert('Error', err);
                                                                          }
                                                                      }
                                                );
                                                              }
                                                  });
                                                      }


                    }, failure: function (err) { Ext.Msg.alert('Error', err); }

                });
                                          }
                                          else {
                                              Ext.Msg.confirm('Message', odwMsgList.msg1,
                                                                      function (e) {
                                                                          if (e == 'yes') {
                                                                              Coolite.AjaxMethods.OrderDetailWindowLP.CheckSubmit(hidCreateType.getValue(), hidUpdateDate.getValue(), cbSpecialPrice.getValue(),
                                                                                          {
                                                                                              success: function () {
                                                                                                  if (rtnVal.getValue() == "Success") {
                                                                                                      Coolite.AjaxMethods.OrderDetailWindowLP.Submit(
                                                                                                      {
                                                                                                          success: function () {
                                                                                                              Ext.Msg.alert('Message', '<%=GetLocalResourceObject("ValidateForm.Submit.alert.Body").ToString()%>');
                                                                                                              Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                                                                                                              RefreshMainPage();
                                                                                                          },
                                                                                                          failure: function (err) {
                                                                                                              Ext.Msg.alert('Error', err);
                                                                                                          }
                                                                                                      }
                                    );
                                                                                                  } else if (rtnVal.getValue() == "Error") {
                                                                                                      tabPanel.setActiveTab(1);
                                                                                                      Ext.Msg.alert('Error', rtnMsg.getValue());
                                                                                                  } else if (rtnVal.getValue() == "Warn") {
                                                                                                      tabPanel.setActiveTab(1);
                                                                                                      Ext.Msg.confirm('Warning', rtnMsg.getValue(),
                                                                                                          function (e) {
                                                                                                              if (e == 'yes') {
                                                                                                                  Coolite.AjaxMethods.OrderDetailWindowLP.Submit(
                                                                                                                  {
                                                                                                                      success: function () {
                                                                                                                          Ext.Msg.alert('Message', '<%=GetLocalResourceObject("ValidateForm.Submit.alert.Body").ToString()%>');
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
                                                                                              },
                                                                                              failure: function (err) {
                                                                                                  Ext.Msg.alert('Error', err);
                                                                                              }
                                                                                          }
                    );
                                                                                  }
                                                                      });

                                                                          }
                                                                  }
                                                              }

                                                              //window hide前提示是否需要保存数据
                                                              var NeedSave = function () {
                                                                  var isModified = Ext.getCmp('<%=this.hidIsModified.ClientID%>').getValue() == "True" ? true : false;
                                                                  var isPageNew = Ext.getCmp('<%=this.hidIsPageNew.ClientID%>').getValue() == "True" ? true : false;
                                                                  var isSaved = Ext.getCmp('<%=this.hidIsSaved.ClientID%>').getValue() == "True" ? true : false;
                                                                  if (!isSaved) {
                                                                      if (isModified) {
                                                                          Ext.Msg.confirm('Warning', '<%=GetLocalResourceObject("NeedSave.confirm.Body").ToString()%>',
                function (e) {
                    if (e == 'yes') {
                        Coolite.AjaxMethods.OrderDetailWindowLP.SaveDraft(
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
                    } else {
                        if (isPageNew) {
                            Coolite.AjaxMethods.OrderDetailWindowLP.DeleteDraft(
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
                        } else {
                            Ext.getCmp('<%=this.hidIsSaved.ClientID%>').setValue("True");
                            Ext.getCmp('<%=this.DetailWindow.ClientID%>').hide();
                        }
                    }
                });
                return false;
            } else if (isPageNew) {
                Coolite.AjaxMethods.OrderDetailWindowLP.DeleteDraft(
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
                return false;
            }
    }
                                                              }

//设置是否需要保存
var SetModified = function (isModified) {
    Ext.getCmp('<%=this.hidIsModified.ClientID%>').setValue(isModified ? "True" : "False");
}

//变更产品线
var ChangeProductLine = function () {
    var cbOrderType = Ext.getCmp('<%=this.cbOrderType.ClientID%>');
    var cbProductLine = Ext.getCmp('<%=this.cbProductLine.ClientID%>');
    var hidProductLine = Ext.getCmp('<%=this.hidProductLine.ClientID%>');
    var hidTerritoryCode = Ext.getCmp('<%=this.hidTerritoryCode.ClientID%>');
    var hidOrderType = Ext.getCmp('<%=this.hidOrderType.ClientID%>');
    if (hidProductLine.getValue() != cbProductLine.getValue()) {
        Ext.Msg.confirm('Warning', '<%=GetLocalResourceObject("ChangeProductLine.confirm.Body").ToString()%>',
                        function (e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.OrderDetailWindowLP.ChangeProductLine(
                                {
                                    success: function () {

                                        hidProductLine.setValue(cbProductLine.getValue());
                                        hidOrderType.setValue(cbOrderType.getValue());
                                        hidTerritoryCode.setValue('');
                                        SetModified(true);
                                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').enable();
                                        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();

                                        //SetSalesAccount();
                                        //Ext.getCmp('<%=this.cbSales.ClientID%>').store.reload();

                                        Coolite.AjaxMethods.OrderDetailWindowLP.SetSpecialPriceHidden();
                                        clearItems();
                                    },
                                    failure: function (err) {

                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                                );
                            }
                            else {
                                cbProductLine.setValue(hidProductLine.getValue());
                                Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);

                            }
                        }
                    );
                    } else {
                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);

    }
}

//变更订单类型
var ChangeOrderType = function () {

    var cbOrderType = Ext.getCmp('<%=this.cbOrderType.ClientID%>');
    var hidOrderType = Ext.getCmp('<%=this.hidOrderType.ClientID%>');
    var hidWarehouse = Ext.getCmp('<%=this.hidWarehouse.ClientID%>');
    var hidWareHouseType = Ext.getCmp('<%=this.hidWareHouseType.ClientID%>');
    var hidSpecialPrice = Ext.getCmp('<%=this.hidSpecialPrice.ClientID%>');
    var gpDetail = Ext.getCmp('<%=this.gpDetail.ClientID%>');
    var cbPointType = Ext.getCmp('<%=this.cbPointType.ClientID%>');
    var hidPointType = Ext.getCmp('<%=this.hidPointType.ClientID%>');
    var lbclearBorrowremark = Ext.getCmp('<%=this.ttClearBorrowRemark.ClientID%>');

    var Warehouse = Ext.getCmp('<%=this.cbWarehouse.ClientID%>');
    if (hidOrderType.getValue() != cbOrderType.getValue()) {

        Ext.Msg.confirm('Warning', '<%=GetLocalResourceObject("ChangeOrderType.confirm.Body").ToString()%>',
                        function (e) {
                            if (e == 'yes') {

                                Coolite.AjaxMethods.OrderDetailWindowLP.ChangeOrderType(
                                {
                                    success: function () {

                                        hidOrderType.setValue(cbOrderType.getValue());
                                        hidWarehouse.setValue('');
                                        hidSpecialPrice.setValue('');
                                        SetWarehosueType();
                                        SetModified(true);

                                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').enable();

                                        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
                                        Ext.getCmp('<%=this.cbWarehouse.ClientID%>').store.reload();

                                        if (cbOrderType.getValue() == '<%=PurchaseOrderType.Transfer.ToString() %>' ||  cbOrderType.getValue() == '<%=PurchaseOrderType.ConsignmentSales.ToString() %>'
                                            || cbOrderType.getValue() == '<%=PurchaseOrderType.Consignment.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.Return.ToString() %>') {
                                            gpDetail.getColumnModel().setHidden(10, false);
                                        } else {
                                            gpDetail.getColumnModel().setHidden(10, true);
                                        }

                                        if (cbOrderType.getValue() == '<%=PurchaseOrderType.CRPO.ToString() %>') {
                                            gpDetail.getColumnModel().setHidden(17, false);
                                            cbPointType.show();
                                        } else {
                                            gpDetail.getColumnModel().setHidden(17, true);
                                            cbPointType.hide();
                                        }
                                        if (cbOrderType.getValue() == '<%=PurchaseOrderType.ClearBorrowManual.ToString() %>') {
                                            gpDetail.getColumnModel().setHidden(18, false);
                                            //lbclearBorrowremark.show();
                                        } else {
                                            gpDetail.getColumnModel().setHidden(18, true);
                                            //lbclearBorrowremark.hide();
                                        }

                                        Coolite.AjaxMethods.OrderDetailWindowLP.SetSpecialPriceHidden();
                                        Coolite.AjaxMethods.OrderDetailWindowLP.SetSpecialPriceEdit();
                                        clearItems();
                                    },
                                    failure: function (err) {

                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                                );
                            }
                            else {
                                cbOrderType.setValue(hidOrderType.getValue());
                                Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);

                            }
                        }
                    );
                    } else {
                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);

    }
}

var ChangePointType = function () {
    var cbPointType = Ext.getCmp('<%=this.cbPointType.ClientID%>');
    var hidPointType = Ext.getCmp('<%=this.hidPointType.ClientID%>');

    if (hidPointType.getValue() != cbOrderType.getValue()) {
        Ext.Msg.confirm('Warning', '<%=GetLocalResourceObject("ChangePointType.confirm.Body").ToString()%>',
                        function (e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.OrderDetailWindowLP.ChangePointType(
                                {
                                    success: function () {

                                        hidPointType.setValue(cbPointType.getValue());

                                        SetModified(true);
                                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').enable();
                                        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
                                        clearItems();
                                    },
                                    failure: function (err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                                );
                            }
                            else {
                                cbPointType.setValue(hidPointType.getValue());
                                Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);
                            }
                        }
                    );
                    } else {
                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);
    }
}


var UpdateItem = function (upn) {

    var txtRequiredQty = Ext.getCmp('<%=this.txtRequiredQty.ClientID%>');
    var txtLotNumber = Ext.getCmp('<%=this.txtLotNumber.ClientID%>');
    var txtCfnPrice = Ext.getCmp('<%=this.txtCfnPrice.ClientID%>');
    var hidCustomerFaceNbr = Ext.getCmp('<%=this.hidCustomerFaceNbr.ClientID%>');


    var hidEditItemId = Ext.getCmp('<%=this.hidEditItemId.ClientID%>');
    var DetailWindow = Ext.getCmp('<%=this.DetailWindow.ClientID%>');
    var rtnVal = Ext.getCmp('<%=this.hidRtnVal.ClientID%>');
    Coolite.AjaxMethods.OrderDetailWindowLP.UpdateItem(txtRequiredQty.getValue(), txtLotNumber.getValue(), txtCfnPrice.getValue(), hidCustomerFaceNbr.getValue(),
    {
        success: function () {
            if (rtnVal.getValue() == "LotTooLong") {
                Ext.Msg.alert('Error', '<%=GetLocalResourceObject("UpdateItem.Error.LotTooLong").ToString()%>');
            } else if (rtnVal.getValue() == "LotNotExists") {
                Ext.Msg.alert('Error', '<%=GetLocalResourceObject("UpdateItem.Error.LotNotExists").ToString()%>');
            } else if (rtnVal.getValue() == "LotExisted") {
                Ext.Msg.alert('Error', '<%=GetLocalResourceObject("UpdateItem.Error.LotExisted").ToString()%>');
            }
            else if (rtnVal.getValue() == "LotPriceExisted") {
                Ext.Msg.alert('Error', '相同价格的产品已经存在!');
            }
            hidEditItemId.setValue('');
            ReloadDetail();
            SetWinBtnDisabled(DetailWindow, false);
        },
        failure: function (err) {
            Ext.Msg.alert('Error', err);
        }
    }
        );
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
    var gpDetail = Ext.getCmp('<%=this.gpDetail.ClientID%>');
    var btnAddCfnSet = Ext.getCmp('<%=this.btnAddCfnSet.ClientID%>');
    var btnAddCfn = Ext.getCmp('<%=this.btnAddCfn.ClientID%>');


    if (hidIsPageNew.getValue() == 'True') {
        cbOrderType.setValue(cbOrderType.store.getTotalCount() > 0 ? cbOrderType.store.getAt(0).get('Key') : '');
        hidOrderType.setValue(cbOrderType.getValue());
    } else {
        cbOrderType.setValue(hidOrderType.getValue());
    }

    SetWarehosueType();
    cbWarehouse.store.reload();
    if (cbOrderType.getValue() == '<%=PurchaseOrderType.Transfer.ToString() %>' || 
        cbOrderType.getValue() == '<%=PurchaseOrderType.ConsignmentSales.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.Consignment.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.Return.ToString() %>') {
        gpDetail.getColumnModel().setHidden(10, false);
    } else {
        gpDetail.getColumnModel().setHidden(10, true);
    }

}


//根据选择的订单类型，设定仓库类型、价格类型
function SetWarehosueType() {


    var cbOrderType = Ext.getCmp('<%=this.cbOrderType.ClientID%>');
    var hidWareHouseType = Ext.getCmp('<%=this.hidWareHouseType.ClientID%>');
    var hidPriceType = Ext.getCmp('<%=this.hidPriceType.ClientID%>');

    //特殊价格订单(普通仓库、特殊价格)、寄售订单（寄售仓库、寄售价格）、普通订单（普通仓库、普通价格）、借货订单（借货仓库、寄售价格）、交接订单（普通仓库、普通价格）、特殊清指定批号订单（借货仓库、普通价格）
    if (cbOrderType.getValue() == '<%=PurchaseOrderType.Normal.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.Transfer.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.PEGoodsReturn.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.EEGoodsReturn.ToString() %>' ||
    cbOrderType.getValue() == '<%=PurchaseOrderType.BOM.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.Return.ToString() %>') {
        hidWareHouseType.setValue('Normal');
        hidPriceType.setValue('Dealer');
    }
    else if (cbOrderType.getValue() == '<%=PurchaseOrderType.ConsignmentSales.ToString() %>') {
        hidWareHouseType.setValue('Consignment');
        hidPriceType.setValue('DealerConsignment');
    }
    else if (cbOrderType.getValue() == '<%=PurchaseOrderType.Consignment.ToString() %>') {
        hidWareHouseType.setValue('Consignment,Borrow');
        hidPriceType.setValue('DealerConsignment');
    }
    else if (cbOrderType.getValue() == '<%=PurchaseOrderType.Borrow.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.ClearBorrow.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.ClearBorrowManual.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.ZTKB.ToString() %>' || cbOrderType.getValue() == '<%=PurchaseOrderType.ZTKA.ToString() %>') {
        hidWareHouseType.setValue('Borrow');
        hidPriceType.setValue('DealerConsignment');
    }
    else if (cbOrderType.getValue() == '<%=PurchaseOrderType.SpecialPrice.ToString() %>') {
        //Edit by Songweiming on 2013-11-4 特殊价格选择暂时先不使用
        //hidWareHouseType.setValue('Normal');
        hidPriceType.setValue('DealerSpecial');
        hidWareHouseType.setValue('Normal');
        //hidPriceType.setValue('Dealer');             
    }
    else {
        hidWareHouseType.setValue('Normal');
        hidPriceType.setValue('Dealer');
    }
}
//Edit by Songweiming on 2013-11-4 特殊价格选择暂时先不使用(ChangeSpecialPrice注释不使用)
//设定特殊价格规则编号
function ChangeSpecialPrice() {
    var cbSpecialPrice = Ext.getCmp('<%=this.cbSpecialPrice.ClientID%>');
    var hidSpecialPrice = Ext.getCmp('<%=this.hidSpecialPrice.ClientID%>');
    var txtSpecialPrice = Ext.getCmp('<%=this.txtSpecialPrice.ClientID%>');
    var taPolicyContent = Ext.getCmp('<%=this.taPolicyContent.ClientID%>');
    if (hidSpecialPrice.getValue() != cbSpecialPrice.getValue()) {
        Ext.Msg.confirm('Warning', '<%=GetLocalResourceObject("ChangeSpecialPrice.confirm.Body").ToString()%>',
                        function (e) {
                            if (e == 'yes') {
                                Coolite.AjaxMethods.OrderDetailWindowLP.ChangeSpecialPrice(
                                {
                                    success: function () {
                                        hidSpecialPrice.setValue(cbSpecialPrice.getValue());

                                        SetModified(true);
                                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').enable();

                                        Ext.getCmp('<%=this.gpDetail.ClientID%>').reload();
                                        var index = cbSpecialPrice.store.find('PolicyId', cbSpecialPrice.getValue());
                                        txtSpecialPrice.setValue(cbSpecialPrice.store.getAt(index).get('PolicyNo'));
                                        taPolicyContent.setValue(cbSpecialPrice.store.getAt(index).get('PolicyName'));
                                        clearItems();
                                    },
                                    failure: function (err) {
                                        Ext.Msg.alert('Error', err);
                                    }
                                }
                                );
                            }
                            else {
                                cbSpecialPrice.setValue(hidSpecialPrice.getValue());
                                Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);

                            }
                        }
                    );
                    } else {
                        Ext.getCmp('<%=this.Toolbar1.ClientID%>').setDisabled(false);

    }
}

function SpecialPriceInit() {
    var cbSpecialPrice = Ext.getCmp('<%=this.cbSpecialPrice.ClientID%>');
    var txtSpecialPrice = Ext.getCmp('<%=this.txtSpecialPrice.ClientID%>');
    var taPolicyContent = Ext.getCmp('<%=this.taPolicyContent.ClientID%>');
    var index = cbSpecialPrice.store.find('PolicyId', cbSpecialPrice.getValue());
    if (index >= 0) {
        txtSpecialPrice.setValue(cbSpecialPrice.store.getAt(index).get('PolicyNo'));
        taPolicyContent.setValue(cbSpecialPrice.store.getAt(index).get('PolicyName'));
    }
}

var SetCellCssEditable = function (v, m) {
    m.css = "editable-column";
    return v;
}

var SetCellCssNonEditable = function (v, m) {
    m.css = "";
    return v;
}

function getCurrentInvRowClass(record, index) {
    var orderStatus = Ext.getCmp('<%=this.hidOrderStatus.ClientID%>');
    if (orderStatus.getValue() == '<%=PurchaseOrderStatus.Delivering.ToString() %>' || orderStatus.getValue() == '<%=PurchaseOrderStatus.Completed.ToString() %>' || orderStatus.getValue() == '<%=PurchaseOrderStatus.ApplyComplete.ToString() %>') {

        if (record.data.ReceiptQty < record.data.RequiredQty) {
            return 'yellow-row';
        }
    }
}

//Edit By SongWeiming on 2017-04-18 去除RSM的选择
<%--var SetSalesAccount = function () {
    var hidProductLine = Ext.getCmp('<%=this.hidProductLine.ClientID%>');
    var hidDealerType = Ext.getCmp('<%=this.hidDealerType.ClientID%>');
    if (hidDealerType.getValue() == '' && hidProductLine.getValue() == '8f15d92a-47e4-462f-a603-f61983d61b7b')
    { Ext.getCmp('<%=this.cbSales.ClientID%>').show(); }
        else if (hidProductLine.getValue() == '8f15d92a-47e4-462f-a603-f61983d61b7b' && hidDealerType.getValue() == 'T1') {
            Ext.getCmp('<%=this.cbSales.ClientID%>').show();
        }
        else {
            Ext.getCmp('<%=this.cbSales.ClientID%>').hide();
        }
}--%>
    // 发货方式修改
    var ChanageRadio =function (){
        Coolite.AjaxMethods.OrderDetailWindowLP.ChanageRadio({
            success: function () { },
    
            failure: function (err) {
                Ext.Msg.alert('Error', err);
            }
        })
    }
    




    //lijie add 20160810
    var cbWarehouseChanage = function () {
        var hidWarehouse = Ext.getCmp('<%=this.hidWarehouse.ClientID%>');
        var cbWarehouse = Ext.getCmp('<%=this.cbWarehouse.ClientID%>');
        var hidDealerTaxpayer = Ext.getCmp('<%=this.hidDealerTaxpayer.ClientID%>');
        var hidOrderType = Ext.getCmp('<%=this.hidOrderType.ClientID%>');
        //只有不是直销医院且或部位清指定订单变更仓库时才改变仓库（直销医院的清指定订单不可选择仓库）
        if (hidDealerTaxpayer.getValue() != '直销医院' || hidOrderType.getValue() != 'ClearBorrowManual') {
            if (cbWarehouse.getValue() != hidWarehouse.getValue()) {
                hidWarehouse.setValue(cbWarehouse.getValue());
            }
        }
    }
    var cbSAPWarehouseAddressChanage = function () {
        var hidSAPWarehouseAddress = Ext.getCmp('<%=this.hidSAPWarehouseAddress.ClientID%>');
        var cbSAPWarehouseAddress = Ext.getCmp('<%=this.cbSAPWarehouseAddress.ClientID%>');
        if (cbSAPWarehouseAddress.getValue() != hidSAPWarehouseAddress.getValue()) {
            hidSAPWarehouseAddress.setValue(cbSAPWarehouseAddress.getValue());
        }

    }
    var GetcbSAPWarehouseAddress = function () {

        Coolite.AjaxMethods.OrderDetailWindowLP.GetcbSAPWarehouseAddress({
            success: function () { }
         ,
            failure: function (err) {
                Ext.Msg.alert('Error', err);
            }
        })
    }

    function isEmail() {
        var contract = Ext.getCmp('<%=this.txtContact.ClientID%>');
        var reg = /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
        if (reg.test(contract.getValue()))
        { }
        else {
            contract.setValue('');
            Ext.Msg.alert('Error', '请输入正确的邮箱地址');
        }
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
                <ext:RecordField Name="Uom" />
                <ext:RecordField Name="RequiredQty" />
                <ext:RecordField Name="Amount" />
                <ext:RecordField Name="ReceiptQty" />
                <ext:RecordField Name="LotNumber" />
                <ext:RecordField Name="VirtualDCCode" />
                <ext:RecordField Name="IsSpecial" />
                <ext:RecordField Name="CanOrderNumber" />
                <ext:RecordField Name="ExpDate" />
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
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <BeforeLoad Handler="#{DetailWindow}.body.mask('Loading...', 'x-mask-loading');" />
        <Load Handler="#{DetailWindow}.body.unmask();" />
        <LoadException Handler="Ext.Msg.alert('Products - Load failed', e.message || response.statusText);#{DetailWindow}.body.unmask();" />
    </Listeners>
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
<ext:Store ID="InvoiceStore" runat="server" UseIdConfirmation="false" OnRefreshData="InvoiceStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader>
            <Fields>
                <ext:RecordField Name="OrderNo" />
                <ext:RecordField Name="InvoiceNo" />
                <ext:RecordField Name="InvoiceDate" Type="Date" />
                <ext:RecordField Name="InvoiceStatus" />
                <ext:RecordField Name="InvoiceAmount" />
                <ext:RecordField Name="ID733" />
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
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbProductLine}.setValue(#{cbProductLine}.store.getTotalCount()>0?#{cbProductLine}.store.getAt(0).get('Id'):'');#{hidProductLine}.setValue(#{cbProductLine}.getValue());Coolite.AjaxMethods.OrderDetailWindowLP.ProductLineInit();}else{#{cbProductLine}.setValue(#{hidProductLine}.getValue());Coolite.AjaxMethods.OrderDetailWindowLP.ProductLineInit();}" />

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
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){OrderTypeStoreLoad();}else{OrderTypeStoreLoad();}" />
    </Listeners>
</ext:Store>
<ext:Store ID="WarehouseStore" runat="server" UseIdConfirmation="true" OnRefreshData="Store_WarehouseByDealer"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="Address" />
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
        <Load Handler=" if(#{hidIsPageNew}.getValue()=='True'){#{cbWarehouse}.setValue(#{cbWarehouse}.store.getTotalCount()>0?#{cbWarehouse}.store.getAt(0).get('Id'):''); }else{ if(#{hidWarehouse}.getValue()==''){#{cbWarehouse}.setValue(#{cbWarehouse}.store.getTotalCount()>0?#{cbWarehouse}.store.getAt(0).get('Id'):''); }else{#{cbWarehouse}.setValue(#{hidWarehouse}.getValue());}} #{hidWarehouse}.setValue(#{cbWarehouse}.getValue()); " />
        <LoadException Handler="Ext.Msg.alert('Warehouse - Load failed', e.message || response.statusText);alert('b');" />
    </Listeners>
</ext:Store>
<ext:Store ID="SAPWarehouseAddressStore" runat="server" UseIdConfirmation="true">
    <Reader>
        <ext:JsonReader ReaderID="Id">
            <Fields>
                <ext:RecordField Name="Id" />
                <ext:RecordField Name="WhAddress" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbSAPWarehouseAddress}.setValue(#{cbSAPWarehouseAddress}.store.getTotalCount()>0?#{cbSAPWarehouseAddress}.store.getAt(0).get('WhAddress'):'');}else{ if(#{hidSAPWarehouseAddress}.getValue()==''){#{cbSAPWarehouseAddress}.setValue(#{cbSAPWarehouseAddress}.store.getTotalCount()>0?#{cbSAPWarehouseAddress}.store.getAt(0).get('WhAddress'):'');}else{#{cbSAPWarehouseAddress}.setValue(#{hidSAPWarehouseAddress}.getValue());}} #{hidSAPWarehouseAddress}.setValue(#{cbSAPWarehouseAddress}.getValue())" />
        <LoadException Handler="Ext.Msg.alert('Address - Load failed', e.message || response.statusText);" />
    </Listeners>
</ext:Store>
<ext:Store ID="SpecialPriceStore" runat="server" UseIdConfirmation="true">
    <Reader>
        <ext:JsonReader ReaderID="PolicyId">
            <Fields>
                <ext:RecordField Name="PolicyId" Type="String" />
                <ext:RecordField Name="PolicyNo" />
                <ext:RecordField Name="PolicyName" />
                <ext:RecordField Name="PolicySubStyle" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbSpecialPrice}.setValue(#{cbSpecialPrice}.store.getTotalCount()>0?#{cbSpecialPrice}.store.getAt(0).get('PolicyId'):'');#{hidSpecialPrice}.setValue(#{cbSpecialPrice}.getValue());SpecialPriceInit();}else{if(#{hidSpecialPrice}.getValue()==''){#{cbSpecialPrice}.setValue(#{cbSpecialPrice}.store.getTotalCount()>0?#{cbSpecialPrice}.store.getAt(0).get('PolicyId'):'');#{hidSpecialPrice}.setValue(#{cbSpecialPrice}.getValue());SpecialPriceInit();}else{#{cbSpecialPrice}.setValue(#{hidSpecialPrice}.getValue());SpecialPriceInit();}}" />
        <LoadException Handler="Ext.Msg.alert('Warehouse - Load failed', e.message || response.statusText);" />
    </Listeners>
    <%-- <SortInfo Field="Name" Direction="ASC" />--%>
</ext:Store>
<%--<ext:Store ID="SalesStore" runat="server" UseIdConfirmation="true" OnRefreshData="SalesStore_RefershData"
    AutoLoad="false">
    <reader>
        <ext:JsonReader ReaderID="UserAccount">
            <Fields>
                <ext:RecordField Name="UserAccount" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </reader>
    <listeners>
        <Load Handler="#{cbSales}.setValue(#{hidSalesAccount}.getValue());" />
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True'){#{cbSales}.setValue(#{cbSales}.store.getTotalCount()>0?#{cbSales}.store.getAt(0).get('UserAccount'):'');}else{#{cbSales}.setValue(#{hidSalesAccount}.getValue())};" />
        <LoadException Handler="Ext.Msg.alert('RSM - Load failed', e.message || response.statusText);" />
    </listeners>
</ext:Store>--%>
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
<%--<ext:Store ID="TerritoryStore" runat="server" UseIdConfirmation="true" OnRefreshData="TerritoryStore_RefershData"
    AutoLoad="false">
    <Proxy>
        <ext:DataSourceProxy />
    </Proxy>
    <Reader>
        <ext:JsonReader ReaderID="Code">
            <Fields>
                <ext:RecordField Name="Code" />
                <ext:RecordField Name="Name" />
            </Fields>
        </ext:JsonReader>
    </Reader>
    <Listeners>
        <Load Handler="if(#{hidIsPageNew}.getValue()=='True' || #{hidTerritoryCode}.getValue()==''){#{cbTerritory}.setValue(#{cbTerritory}.store.getTotalCount()>0?#{cbTerritory}.store.getAt(0).get('Code'):'');#{hidTerritoryCode}.setValue(#{cbTerritory}.getValue());}else{#{cbTerritory}.setValue(#{hidTerritoryCode}.getValue());}" />
    </Listeners>
    <SortInfo Field="Name" Direction="ASC" />
</ext:Store>--%>
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
<ext:Hidden ID="hidSAPWarehouseAddress" runat="server">
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
<ext:Hidden ID="hidVenderId" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidCustomerFaceNbr" runat="server">
</ext:Hidden>
<%--<ext:Hidden ID="hidSalesAccount" runat="server">
</ext:Hidden>--%>
<ext:Hidden ID="hidDealerType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPointType" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidDealerTaxpayer" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidPointCheckErr" runat="server">
</ext:Hidden>
<ext:Hidden ID="hidIsUsePro" runat="server">
</ext:Hidden>
<ext:Hidden ID="hiddenFileName" runat="server">
</ext:Hidden>
<ext:Window ID="DetailWindow" runat="server" Icon="Group" Title="<%$ Resources: DetailWindow.Title %>"
    Width="1024" Height="510" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;"
    Resizable="false" Header="false" CenterOnLoad="true" Y="5" Maximizable="true">
    <Body>
        <ext:BorderLayout ID="BorderLayout2" runat="server">
            <North MarginsSummary="5 5 5 5" Collapsible="true">
                <ext:FormPanel ID="FormPanel1" runat="server" Header="false" Frame="true" AutoHeight="true">
                    <Body>
                        <ext:ColumnLayout ID="ColumnLayout2" runat="server">
                            <ext:LayoutColumn ColumnWidth=".22">
                                <ext:Panel ID="Panel7" runat="server" Border="false" Header="false">
                                    <Body>
                                        <%--表头信息 --%>
                                        <ext:FormLayout ID="FormLayout4" runat="server" LabelAlign="Left" LabelWidth="60">
                                            <%--订单类型、订单编号、提交日期 ，UPN--%>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbOrderType" runat="server" EmptyText="<%$ Resources: cbOrderType.EmptyText %>"
                                                    Width="120" Editable="false" TypeAhead="true" StoreID="OrderTypeStore" ValueField="Key"
                                                    ListWidth="200" AllowBlank="false" Mode="Local" DisplayField="Value" FieldLabel="<%$ Resources: txtOrderType.FieldLabel %>">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>"
                                                            HideTrigger="true" />
                                                    </Triggers>
                                                    <Listeners>
                                                        <TriggerClick Handler="this.clearValue();" />
                                                        <%--<Select Handler="#{hidOrderType}.setValue(#{cbOrderType}.getValue());" />--%>
                                                        <Select Handler="#{Toolbar1}.setDisabled(true);ChangeOrderType();" />
                                                    </Listeners>
                                                </ext:ComboBox>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderNo" runat="server" FieldLabel="<%$ Resources: txtOrderNo.FieldLabel %>"
                                                    Width="120" />
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
                                                        <Select Handler="#{Toolbar1}.setDisabled(true);ChangePointType();" />
                                                    </Listeners>
                                                </ext:ComboBox>
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
                                                        <Select Handler="#{Toolbar1}.setDisabled(true);ChangeProductLine();" />
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
                                                <ext:TextField ID="txtDealer" runat="server" FieldLabel="<%$ Resources: cbDealer.FieldLabel %>"
                                                    Width="200" />
                                                <%-- <ext:TextField ID="cbDealer" runat="server" Width="200" Editable="true" TypeAhead="true"
                                                    StoreID="DealerStore" ValueField="Id" DisplayField="ChineseName" FieldLabel="<%$ Resources: cbDealer.FieldLabel %>"
                                                    Mode="Local" AllowBlank="false" BlankText="<%$ Resources: cbDealer.BlankText %>"
                                                    EmptyText="<%$ Resources: cbDealer.EmptyText %>" ListWidth="300" Resizable="true">
                                                </ext:ComboBox>--%>
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtOrderTo" runat="server" FieldLabel="<%$ Resources: txtOrderTo.FieldLabel %>"
                                                    Width="200" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:Panel>
                            </ext:LayoutColumn>
                            <ext:LayoutColumn ColumnWidth=".24">
                                <ext:Panel ID="Panel17" runat="server" Border="false" Header="false">
                                    <Body>
                                        <%--表头信息 --%>
                                        <ext:FormLayout ID="FormLayout3" runat="server" LabelAlign="Left" LabelWidth="90">
                                            <ext:Anchor>
                                                <ext:TextField ID="txtSubmitDate" runat="server" FieldLabel="<%$ Resources: txtSubmitDate.FieldLabel %>"
                                                    Width="130" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCrossDock" runat="server" FieldLabel="CrossDock编号" Width="130" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:ComboBox ID="cbSales" runat="server" LabelStyle="color:red;font-weight:bold" Width="130" TypeAhead="true" ValueField="UserAccount" DisplayField="Name" FieldLabel="RSM"
                                                    BlankText="请选择" EmptyText="请选择RSM" ListWidth="200" Resizable="true" Visible="false">
                                                    <Triggers>
                                                        <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>" />
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
                                                <ext:LayoutColumn ColumnWidth="0.3">
                                                    <ext:Panel ID="Panel4" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: Panel4.Title %>">
                                                        <%--汇总信息 --%>
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout1" runat="server" LabelAlign="Left">
                                                                <ext:Anchor>
                                                                    <ext:Label ID="txtCurrency" runat="server" FieldLabel="订单币种"></ext:Label>
                                                                </ext:Anchor>

                                                                <%--金额汇总、数量汇总、VirtualDC、备注 --%>
                                                                <ext:Anchor>
                                                                    <ext:NumberField ID="txtTotalAmount" runat="server" FieldLabel="<%$ Resources: txtTotalAmount.FieldLabel %>">
                                                                    </ext:NumberField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:NumberField ID="txtTotalQty" runat="server" FieldLabel="<%$ Resources: txtTotalQty.FieldLabel %>">
                                                                    </ext:NumberField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtVirtualDC" runat="server" FieldLabel="<%$ Resources: lbVirtualDC.FieldLabel %>"
                                                                        AllowBlank="true" MsgTarget="Side" ReadOnly="true" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Label ID="lbRemark" runat="server" FieldLabel="<%$ Resources: lbRemark.FieldLabel %>">
                                                                    </ext:Label>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextArea ID="txtRemark" runat="server" Width="240" Height="140" HideLabel="true" />
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                                <ext:LayoutColumn ColumnWidth="0.35">
                                                    <ext:Panel ID="Panel5" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: Panel5.Title %>">
                                                        <%--订单信息 --%>
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout8" runat="server" LabelAlign="Left" LabelWidth="80">
                                                                <ext:Anchor>
                                                                    <ext:ToolTip Html="<font color='red'><b>如订单有问题，请联系ChinaShareService@bsci.com</b></font>" HideBorders="true" BodyBorder="false" runat="server" ID="tt1"></ext:ToolTip>
                                                                </ext:Anchor>
                                                                <%--特殊价格规则名称、特殊价格规则编号、订单联系人、联系方式、手机号码 --%>
                                                                <ext:Anchor>
                                                                   <%-- <ext:ComboBox ID="cbSpecialPrice" runat="server" EmptyText="请选择促销政策" Width="205"
                                                                        Editable="false" Disabled="false" TypeAhead="true" StoreID="SpecialPriceStore"
                                                                        ListWidth="220" ValueField="PolicyId" Resizable="true" AllowBlank="true" Mode="Local"
                                                                        DisplayField="PolicySubStyle" FieldLabel="促销政策名称">--%>
                                                                     <ext:ComboBox ID="cbSpecialPrice" runat="server" EmptyText="请选择促销政策" Width="205"
                                                                        DisplayField="PolicySubStyle" FieldLabel="促销政策名称">
                                                                        <Triggers>
                                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>"
                                                                                HideTrigger="true" />
                                                                        </Triggers>
                                                                        <Listeners>
                                                                            <TriggerClick Handler="this.clearValue();" />
                                                                            <%--Edit by Songweiming on 2013-11-4 特殊价格选择暂时先不使用 --%>
                                                                            <Select Handler="ChangeSpecialPrice();" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtSpecialPrice" runat="server" Width="205" FieldLabel="促销政策编号"
                                                                        AllowBlank="true" MsgTarget="Side" MaxLength="120">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Panel ID="pPolicyContent" runat="server" Border="false">
                                                                        <Body>
                                                                            <ext:HtmlEditor ID="taPolicyContent" runat="server" Width="290" Height="115" HideLabel="true"
                                                                                ReadOnly="true" EnableAlignments="false" EnableColors="false" EnableFont="false"
                                                                                EnableFontSize="false" EnableFormat="false" EnableLinks="false" EnableLists="false"
                                                                                EnableSourceEdit="false" />
                                                                            <br />
                                                                        </Body>
                                                                    </ext:Panel>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtContactPerson" LabelStyle="color:red;" runat="server" Width="205" FieldLabel="<%$ Resources: txtContactPerson.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtContactPerson.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="100" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtContact" LabelStyle="color:red;" runat="server" Width="205" FieldLabel="<%$ Resources: txtContact.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtContact.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="100">
                                                                    </ext:TextField>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtContactMobile" LabelStyle="color:red;" runat="server" Width="205" FieldLabel="<%$ Resources: txtContactMobile.FieldLabel %>"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtContactMobile.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="100" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Label ID="lbRejectReason" runat="server" FieldLabel="<%$ Resources: lbRejectReason.FieldLabel %>"
                                                                        HideLabel="true">
                                                                    </ext:Label>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ToolTip Html="<font color='red'><b>系统自动计算价格折扣，不提供修改功能。如有问题请联系ShareService</b></font>" HideBorders="true" BodyBorder="false" runat="server" ID="ttClearBorrowRemark" Hidden="true"></ext:ToolTip>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextArea ID="txtRejectReason" runat="server" Width="290" Height="100" HideLabel="true" />
                                                                </ext:Anchor>
                                                            </ext:FormLayout>
                                                        </Body>
                                                    </ext:Panel>
                                                </ext:LayoutColumn>
                                                <ext:LayoutColumn ColumnWidth="0.35">
                                                    <ext:Panel ID="Panel10" runat="server" Border="true" FormGroup="true" Title="<%$ Resources: Panel10.Title %>">
                                                        <%-- 收货信息 --%>
                                                        <Body>
                                                            <ext:FormLayout ID="FormLayout7" runat="server" LabelAlign="Left">
                                                                <%--收货仓库选择、收货地址、收货人、收货人电话、期望到货时间、承运商 --%>
                                                                <ext:Anchor>
                                                                    <ext:RadioGroup ID="ReceivingWay" runat="server" Width="220" FieldLabel="" LabelSeparator="">
                                                                        <Items>
                                                                            <ext:Radio ID="PickUp" runat="server" BoxLabel="自提" Width="60" >
                                                                                <Listeners>
                                                                                    <Check Handler="ChanageRadio()" />
                                                                                </Listeners>
                                                                            </ext:Radio>
                                                                            <ext:Radio ID="Deliver" runat="server" BoxLabel="送货/承运商承运" />
                                                                        </Items>
                                                                    </ext:RadioGroup>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="cbWarehouse" runat="server" EmptyText="<%$ Resources: cbWarehouse.EmptyText %>"
                                                                        Width="220" Editable="false" Disabled="false" TypeAhead="true" StoreID="WarehouseStore"
                                                                        ListWidth="300" ValueField="Id" AllowBlank="false" Mode="Local" DisplayField="Name"
                                                                        FieldLabel="<%$ Resources: cbWarehouse.FieldLabel %>">
                                                                        <Triggers>
                                                                            <ext:FieldTrigger Icon="Clear" Qtip="<%$ Resources: cbTerritory.FieldTrigger.Qtip %>"
                                                                                HideTrigger="true" />
                                                                        </Triggers>
                                                                        <Listeners>
                                                                            <Select Handler="cbWarehouseChanage();" />
                                                                            <TriggerClick Handler="this.clearValue();" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:ComboBox ID="cbSAPWarehouseAddress" runat="server" Width="220" Editable="false"
                                                                        Disabled="false" TypeAhead="true" StoreID="SAPWarehouseAddressStore" ListWidth="300"
                                                                        ValueField="WhAddress" AllowBlank="true" Mode="Local" DisplayField="WhAddress"
                                                                        FieldLabel="<%$ Resources: txtShipToAddress.FieldLabel %>">
                                                                        <Listeners>
                                                                            <Select Handler="cbSAPWarehouseAddressChanage();" />
                                                                        </Listeners>
                                                                    </ext:ComboBox>
                                                                    <%--<ext:TextField ID="txtShipToAddress" runat="server" Width="150" FieldLabel="<%$ Resources: txtShipToAddress.FieldLabel %>"
                                                                    AllowBlank="true" BlankText="<%$ Resources: txtShipToAddress.BlankText %>" MsgTarget="Side"
                                                                    MaxLength="200">
                                                                </ext:TextField>--%>
                                                                </ext:Anchor>

                                                                <ext:Anchor>
                                                                    <ext:Panel ID="pan" runat="server" Border="false" Width="420">
                                                                        <Body>
                                                                            <ext:ColumnLayout ID="ColumnLayout4" runat="server" Split="false">
                                                                                <ext:LayoutColumn ColumnWidth="0.62">
                                                                                    <ext:Panel ID="Panel13" runat="server" Border="true" FormGroup="true">
                                                                                        <Body>
                                                                                            <ext:FormLayout ID="FormLayout12" runat="server" LabelAlign="Left">
                                                                                                <ext:Anchor>
                                                                                                    <ext:TextField ID="Texthospitalname" runat="server" FieldLabel="医院名称"
                                                                                                        AllowBlank="true" />
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
                                                                                                    <ext:Button ID="btnhospital" runat="server" Text="选择" Icon="Zoom">
                                                                                                        <Listeners>
                                                                                                            <Click Fn="showHospitalSelectorDlg" />
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
                                                                    <ext:TextField ID="HospitalAddress" runat="server" Width="150" FieldLabel="医院地址" MaxLength="500" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtConsignee" runat="server" Width="150" FieldLabel="<%$ Resources: txtConsignee.FieldLabel %>" LabelStyle="color:red;"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtConsignee.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="250" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:TextField ID="txtConsigneePhone" runat="server" Width="150" FieldLabel="<%$ Resources: txtConsigneePhone.FieldLabel %>" LabelStyle="color:red;"
                                                                        AllowBlank="true" BlankText="<%$ Resources: txtConsigneePhone.BlankText %>" MsgTarget="Side"
                                                                        MaxLength="200" />
                                                                </ext:Anchor>
                                                                <ext:Anchor>
                                                                    <ext:Label ID="ShipToRemark" runat="server" HideLabel="true" Html="<font color='#FF0000'> 此为随货同行单的联系信息，请务必维护准确</font>" LabelSeparator=""></ext:Label>
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
                                        EnableHdMenu="false" Header="false" AutoExpandColumn="CfnChineseName">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar1" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                    <ext:Button ID="btnUserPoint" runat="server" Text="使用积分" Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{hidDealerId}.getValue() == '' || #{hidProductLine}.getValue() == ''|| #{hidPriceType}.getValue()=='' || #{hidOrderType}.getValue() =='') {alert('请等待数据加载完毕！');} else {if (#{hidOrderType}.getValue() =='CRPO') {Coolite.AjaxMethods.OrderDetailWindowLP.CaculateFormValuePoint({success:function(result){ReloadDetail();}, failure: function(err) {Ext.Msg.alert('Error', err);}})} else {alert('非积分订单不能使用积分！');}}" />
                                                        </Listeners>
                                                    </ext:Button>
                                                    <ext:Button ID="btnAddCfnSet" runat="server" Text="<%$ Resources: btnAddCfnSet.Text %>"
                                                        Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{hidDealerId}.getValue() == '' || #{hidProductLine}.getValue() == ''|| #{hidPriceType}.getValue()=='' || #{hidOrderType}.getValue() =='') {alert('请等待数据加载完毕！');} else {Coolite.AjaxMethods.OrderCfnSetDialog.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue(),#{hidDealerId}.getValue(),#{hidPriceType}.getValue(),#{hidOrderType}.getValue());}" />
                                                        </Listeners>
                                                    </ext:Button>
                                                    <ext:Button ID="btnAddCfn" runat="server" Text="<%$ Resources: btnAddCfn.Text %>"
                                                        Icon="Add">
                                                        <Listeners>
                                                            <Click Handler="if(#{hidInstanceId}.getValue() == '' ||  #{hidDealerId}.getValue() == '' || #{hidProductLine}.getValue() == ''|| #{hidPriceType}.getValue()=='' || #{hidOrderType}.getValue() =='') {alert('请等待数据加载完毕！');} else {if (#{hidOrderType}.getValue() =='PRO') {Coolite.AjaxMethods.OrderCfnDialogLPPRO.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue(),#{hidDealerId}.getValue(),#{hidPriceType}.getValue(),#{hidSpecialPrice}.getValue(),#{hidOrderType}.getValue(),{success:function(){RefreshDetailCFNPROWindow();},failure:function(err){Ext.Msg.alert('Error', err);}});} else {Coolite.AjaxMethods.OrderCfnDialogLP.Show(#{hidInstanceId}.getValue(),#{hidProductLine}.getValue(),#{hidDealerId}.getValue(),#{hidPriceType}.getValue(),#{hidSpecialPrice}.getValue(),#{hidOrderType}.getValue());}}" />
                                                        </Listeners>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="CustomerFaceNbr" DataIndex="CustomerFaceNbr" Header="<%$ Resources: resource,Lable_Article_Number  %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnEnglishName" DataIndex="CfnEnglishName" Width="200" Header="<%$ Resources: gpDetail.CfnEnglishName %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnChineseName" DataIndex="CfnChineseName" Header="<%$ Resources: gpDetail.CfnChineseName %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="RequiredQty" DataIndex="RequiredQty" Header="<%$ Resources: gpDetail.RequiredQty %>"
                                                    Width="70" Align="Center">
                                                    <Editor>
                                                        <ext:NumberField ID="txtRequiredQty" runat="server" AllowBlank="false" AllowDecimals="false"
                                                            DataIndex="RequiredQty" SelectOnFocus="true" AllowNegative="false">
                                                        </ext:NumberField>
                                                    </Editor>
                                                    <%--<Renderer Fn="SetCellCss" />--%>
                                                </ext:Column>
                                                <ext:Column ColumnID="CfnPrice" DataIndex="CfnPrice" Header="<%$ Resources: gpDetail.CfnPrice %>"
                                                    Width="70" Align="Right">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                    <Editor>
                                                        <ext:NumberField ID="txtCfnPrice" runat="server" AllowBlank="false" AllowDecimals="true"
                                                            DataIndex="CfnPrice" SelectOnFocus="true" AllowNegative="false" DecimalPrecision="6">
                                                        </ext:NumberField>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="Uom" DataIndex="Uom" Header="<%$ Resources: gpDetail.Uom %>"
                                                    Width="50" Align="Center" Hidden="<%$ AppSettings: HiddenUOM  %>">
                                                </ext:Column>
                                                <ext:Column ColumnID="Amount" DataIndex="Amount" Header="<%$ Resources: gpDetail.Amount %>"
                                                    Width="80" Align="Right">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                    <Editor>
                                                        <ext:NumberField ID="txtAmount" runat="server" AllowBlank="false" DataIndex="Amount"
                                                            SelectOnFocus="true" AllowNegative="false" DecimalPrecision="6">
                                                        </ext:NumberField>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="CanOrderNumber" DataIndex="CanOrderNumber" Header="<%$ Resources: gpDetail.CanOrderNumber %>"
                                                    Width="50">
                                                </ext:Column>
                                                <ext:Column ColumnID="ExpDate" DataIndex="ExpDate" Header="<%$ Resources: gpDetail.ExpDate %>"
                                                    Width="60">
                                                </ext:Column>
                                                <ext:Column ColumnID="IsSpecial" DataIndex="IsSpecial" Header="<%$ Resources: gpDetail.IsSpecialPrice %>"
                                                    Width="60" Align="Center">
                                                </ext:Column>
                                                <ext:Column ColumnID="LotNumber" Css="editable-column" DataIndex="LotNumber" Header="<%$ Resources: gpDetail.LotNumber %>"
                                                    Width="80" Align="Right">
                                                    <Editor>
                                                        <ext:TextField ID="txtLotNumber" runat="server" AllowBlank="true" DataIndex="LotNumber"
                                                            SelectOnFocus="true" AllowNegative="false">
                                                        </ext:TextField>
                                                    </Editor>
                                                </ext:Column>
                                                <ext:Column ColumnID="ReceiptQty" DataIndex="ReceiptQty" Header="<%$ Resources: gpDetail.ReceiptQty %>"
                                                    Width="60" Align="Right">
                                                </ext:Column>
                                                <ext:CommandColumn Width="50" Header="<%$ Resources: gpDetail.CommandColumn.Header %>"
                                                    Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="<%$ Resources: gpDetail.CommandColumn.Header %>" />
                                                    </Commands>
                                                </ext:CommandColumn>
                                                <ext:Column ColumnID="CurRegNo" DataIndex="CurRegNo" Header="注册证编号-1" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="CurManuName" DataIndex="CurManuName" Header="生产企业(注册证-1)" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="LastRegNo" DataIndex="LastRegNo" Header="注册证编号-2" Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="LastManuName" DataIndex="LastManuName" Header="生产企业(注册证-2)"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="PointAmount" DataIndex="PointAmount" Header="使用积分" Width="100"
                                                    Hidden="true">
                                                </ext:Column>
                                                <ext:Column ColumnID="DiscountRate" DataIndex="DiscountRate" Header="折扣率" Width="100"
                                                    Hidden="true">
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
                                            <Command Handler="ShowEditingMask();Coolite.AjaxMethods.OrderDetailWindowLP.DeleteItem(record.data.Id,{success:function(){ReloadDetail();SetWinBtnDisabled(#{DetailWindow},false);},failure:function(err){Ext.Msg.alert('Error', err);}});" />
                                            <BeforeEdit Handler="#{hidEditItemId}.setValue(this.getSelectionModel().getSelected().id);#{hidCustomerFaceNbr}.setValue(this.getSelectionModel().getSelected().data.CustomerFaceNbr);#{txtRequiredQty}.setValue(this.getSelectionModel().getSelected().data.RequiredQty);#{txtCfnPrice}.setValue(this.getSelectionModel().getSelected().data.CfnPrice);#{txtAmount}.setValue(this.getSelectionModel().getSelected().data.Amount);#{txtLotNumber}.setValue(this.getSelectionModel().getSelected().data.LotNumber);" />
                                            <AfterEdit Handler="ShowEditingMask();StoreCommitAll(this.store);UpdateItem();" />
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
                            <Listeners>
                                <Activate Handler="Coolite.AjaxMethods.OrderDetailWindowLP.InitBtnCfnAdd();" />
                            </Listeners>
                        </ext:Tab>
                        <ext:Tab ID="TabInvoice" runat="server" Title="<%$ Resources: TabInvoice.Title %>"
                            AutoScroll="false">
                            <Body>
                                <ext:FitLayout ID="FT2" runat="server">
                                    <ext:GridPanel ID="gpInvoice" runat="server" Title="<%$ Resources: gpInvoice.Title %>"
                                        StoreID="InvoiceStore" AutoScroll="true" StripeRows="true" Collapsible="false"
                                        Border="false" Header="false" Icon="Lorry" AutoExpandColumn="ID733">
                                        <ColumnModel ID="ColumnModelInvoice" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="InvoiceNo" DataIndex="InvoiceNo" Header="<%$ Resources: gpInvoice.InvoiceNo %>"
                                                    Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="InvoiceDate" DataIndex="InvoiceDate" Header="<%$ Resources: gpInvoice.InvoiceDate %>"
                                                    Width="150">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="InvoiceAmount" DataIndex="InvoiceAmount" Header="<%$ Resources: gpInvoice.InvoiceAmount %>"
                                                    Width="100" Align="Right">
                                                    <Renderer Fn="Ext.util.Format.numberRenderer('0.00')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="InvoiceStatus" DataIndex="InvoiceStatus" Header="<%$ Resources: gpInvoice.InvoiceStatus %>"
                                                    Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="ID733" DataIndex="ID733" Header="<%$ Resources: gpInvoice.ID733 %>">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="true">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar3" runat="server" PageSize="50" StoreID="InvoiceStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>
                        <ext:Tab ID="TabLog" runat="server" Title="<%$ Resources: TabLog.Title %>" AutoScroll="false">
                            <Body>
                                <ext:FitLayout ID="FitLayout1" runat="server">
                                    <ext:GridPanel ID="gpLog" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="OrderLogStore"
                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                        Icon="Lorry" AutoExpandColumn="OperNote">
                                        <ColumnModel ID="ColumnModel1" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="<%$ Resources: gpLog.OperUserId %>"
                                                    Width="100">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="<%$ Resources: gpLog.OperUserName %>"
                                                    Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="<%$ Resources: gpLog.OperTypeName %>"
                                                    Width="150">
                                                </ext:Column>
                                                <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="<%$ Resources: gpLog.OperDate %>"
                                                    Width="150">
                                                    <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                </ext:Column>
                                                <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="<%$ Resources: gpLog.OperNote %>">
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
                        <ext:Tab ID="TabAttachment" runat="server" Title="附件" Icon="BrickLink" AutoScroll="false">
                            <Body>
                                <ext:FitLayout ID="FTAttachement" runat="server">
                                    <ext:GridPanel ID="gpAttachment" runat="server" Title="附件列表" StoreID="AttachmentStore" AutoWidth="true" StripeRows="true" Collapsible="false" Border="false" Icon="Lorry" Header="false" AutoExpandColumn="Name">
                                        <TopBar>
                                            <ext:Toolbar ID="Toolbar3" runat="server">
                                                <Items>
                                                    <ext:ToolbarFill ID="ToolbarFill3" runat="server" />
                                                    <ext:Button ID="btnAddAttach" runat="server" Text="添加附件" Icon="Add" StyleSpec="margin-right:15px">
                                                        <AjaxEvents>
                                                            <Click OnEvent="ShowAttachmentWindow">
                                                                <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="={#{DetailWindow}.body}" />
                                                            </Click>
                                                        </AjaxEvents>
                                                    </ext:Button>
                                                </Items>
                                            </ext:Toolbar>
                                        </TopBar>
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
                                                <ext:CommandColumn Width="50" Header="删除" Align="Center">
                                                    <Commands>
                                                        <ext:GridCommand Icon="BulletCross" CommandName="Delete" ToolTip-Text="删除" />
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
                                            <Command Handler="if (command == 'Delete'){
                                                                        Ext.Msg.confirm('警告', '是否要删除该附件文件?',
                                                                            function(e) {
                                                                                if (e == 'yes') {
                                                                                    Coolite.AjaxMethods.OrderDetailWindowLP.DeleteAttachment(record.data.Id,record.data.Url,{
                                                                                        success: function() {
                                                                                            Ext.Msg.alert('Message', '删除附件成功！');
                                                                                            #{gpAttachment}.reload();
                                                                                        },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                }
                                                                            });                                                                                   
                                                                           
                                                                    }
                                                                    else if (command == 'DownLoad')
                                                                    {
                                                                        var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=AdjustAttachment';
                                                                        downloadfile(url);                                                                                
                                                                    }
                                                                            
                                                                    " />
                                        </Listeners>
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                            <Listeners>
                                <Activate Handler="Coolite.AjaxMethods.OrderDetailWindowLP.InitBtnAddAttach();" />
                            </Listeners>
                        </ext:Tab>
                        <%-- <ext:Tab ID="TabFinance" runat="server" Title="<%$ Resources: TabFinance.Title %>" BodyStyle="padding: 6px;" AutoScroll="true">
                            
                            <Body>
                                <ext:FormPanel ID="FormPanel33" runat="server" Header="false" Border="false">
                                    <Body>
                                        <ext:FormLayout ID="FormLayout2" runat="server" LabelAlign="Left">
                                            
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCreditLimit" runat="server" Width="200" FieldLabel="<%$ Resources: lbCreditLimit.FieldLabel %>" AllowBlank="true" MsgTarget="Side" ReadOnly="true" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtDeposit" runat="server" Width="200" FieldLabel="<%$ Resources: lbDeposit.FieldLabel %>" AllowBlank="true" MsgTarget="Side" ReadOnly="true" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtPaymentDays" runat="server" Width="200" FieldLabel="<%$ Resources: lbPaymentDays.FieldLabel %>" AllowBlank="true" MsgTarget="Side" ReadOnly="true" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextField ID="txtCreditTerm" runat="server" Width="200" FieldLabel="<%$ Resources: lbtxtCreditTerm.FieldLabel %>" AllowBlank="true" MsgTarget="Side" ReadOnly="true" />
                                            </ext:Anchor>
                                            <ext:Anchor>
                                                <ext:TextArea ID="txtOthers" runat="server" Width="200" Height="100" FieldLabel="<%$ Resources: lbFinanceOthers.FieldLabel %>" AllowBlank="true" MsgTarget="Side" ReadOnly="true" />
                                            </ext:Anchor>
                                        </ext:FormLayout>
                                    </Body>
                                </ext:FormPanel>
                            </Body>
                        </ext:Tab>--%>
                        <%--<ext:Tab ID="TabUpnSearch" runat="server" Header="false" Border="false" Title="产品是否可订购">
                            <Body>
                                <ext:FitLayout ID="FitLayout2" runat="server">
                                    <ext:GridPanel ID="GridUpnInfo" runat="server" Title="<%$ Resources: gpLog.Title %>" StoreID="CfnInfoStore"
                                        AutoScroll="true" StripeRows="true" Collapsible="false" Border="false" Header="false"
                                        Icon="Lorry" >
                                        <ColumnModel ID="ColumnModel3" runat="server">
                                            <Columns>
                                                <ext:Column ColumnID="Title" DataIndex="Title" Header="标题"
                                                    Width="200">
                                                </ext:Column>
                                                <ext:Column ColumnID="Messing" DataIndex="Messing" Header="描述"
                                                    Width="400">
                                                </ext:Column>
                                            </Columns>
                                        </ColumnModel>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel4" SingleSelect="true" runat="server"
                                                MoveEditorOnEnter="true">
                                            </ext:RowSelectionModel>
                                        </SelectionModel>
                                        <BottomBar>
                                            <ext:PagingToolbar ID="PagingToolBar4" runat="server" PageSize="50" StoreID="CfnInfoStore"
                                                DisplayInfo="true" />
                                        </BottomBar>
                                        <SaveMask ShowMask="false" />
                                        <LoadMask ShowMask="true" />
                                    </ext:GridPanel>
                                </ext:FitLayout>
                            </Body>
                        </ext:Tab>--%>
                    </Tabs>
                </ext:TabPanel>
            </Center>
        </ext:BorderLayout>
    </Body>
    <Buttons>
        <ext:Button ID="btnUsePro" runat="server" Text="使用促销" Icon="LorryAdd">
            <Listeners>
                <Click Handler="Coolite.AjaxMethods.OrderDetailWindowLP.UsePro({success:function(){ReloadDetail();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnSaveDraft" runat="server" Text="<%$ Resources: btnSaveDraft.Text %>"
            Icon="Add">
            <Listeners>
                <Click Handler="Coolite.AjaxMethods.OrderDetailWindowLP.SaveDraft({success:function(){#{DetailWindow}.hide();RefreshMainPage();},failure:function(err){Ext.Msg.alert('Error', err);}});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnDeleteDraft" runat="server" Text="<%$ Resources: btnDeleteDraft.Text %>"
            Icon="Delete">
            <Listeners>
                <Click Handler="
                    Ext.Msg.confirm('Message', odwMsgList.msg1,
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.OrderDetailWindowLP.DeleteDraft({success:function(){#{DetailWindow}.hide();RefreshMainPage();},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnDiscardModify" runat="server" Text="<%$ Resources: btnDiscardModify.Text %>"
            Icon="Delete">
            <Listeners>
                <Click Handler="
                    Ext.Msg.confirm('Message', odwMsgList.msg1,
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.OrderDetailWindowLP.DiscardModify({success:function(){#{DetailWindow}.hide();RefreshMainPage();},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnSubmit" runat="server" Text="<%$ Resources: btnSubmit.Text %>"
            Icon="LorryAdd">
            <Listeners>
                <Click Handler="ValidateForm();" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnCopy" runat="server" Text="<%$ Resources: btnCopy.Text %>" Icon="PageCopy">
            <Listeners>
                <Click Handler="Ext.Msg.confirm('Message', odwMsgList.msg1,
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.OrderDetailWindowLP.Copy({success:function(){#{DetailWindow}.hide();RefreshMainPage();Ext.Msg.alert('Message',odwMsgList.msg2);},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnRevoke" runat="server" Text="<%$ Resources: btnRevoke.Text %>"
            Icon="Decline">
            <Listeners>
                <Click Handler="Ext.Msg.confirm('Message', odwMsgList.msg1,
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.OrderDetailWindowLP.Revoke({success:function(){#{DetailWindow}.hide();RefreshMainPage();Ext.Msg.alert('Message',odwMsgList.msg3);},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
        <ext:Button ID="btnClose" runat="server" Text="<%$ Resources: btnClose.Text %>" Icon="LorryAdd">
            <Listeners>
                <Click Handler="Ext.Msg.confirm('Message', odwMsgList.msg1,
                                function(e) {
                                    if (e == 'yes') {
                                        Coolite.AjaxMethods.OrderDetailWindowLP.Close({success:function(){#{DetailWindow}.hide();RefreshMainPage();Ext.Msg.alert('Message',odwMsgList.msg4);},failure:function(err){Ext.Msg.alert('Error', err);}});
                                        }});" />
            </Listeners>
        </ext:Button>
    </Buttons>
    <Listeners>
        <BeforeHide Handler="return NeedSave();" />
    </Listeners>
</ext:Window>
<ext:Window ID="AttachmentWindow" runat="server" Icon="Group" Title="上传附件" Resizable="false" Header="false" Width="500" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Header="false" AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout2" runat="server" LabelWidth="50">
                            <ext:Anchor>
                                <ext:FileUploadField ID="FileUploadField1" runat="server" EmptyText="选择上传附件" FieldLabel="文件" ButtonText="" Icon="ImageAdd">
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
                                    Success="#{gpAttachment}.reload();#{FileUploadField1}.setValue('')">
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
                <Hide Handler="#{gpAttachment}.reload();" />
                <BeforeShow Handler="#{FileUploadField1}.setValue('');" />
            </Listeners>
        </ext:Window>
