<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerComplainForCRMEdit.aspx.cs" Inherits="DMS.Website.Pages.Inventory.DealerComplainForCRMEdit" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<%@ Register Src="../../Controls/CFNSearchForComplainDialog.ascx" TagName="CFNSearchForComplainDialog" TagPrefix="uc" %>
<%@ Register Src="../../Controls/HospitalSearchForComplainDialog.ascx" TagName="HospitalSearchForComplainDialog" TagPrefix="uc" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
    <style>
        #divComplainCrm > .ext-el-mask {
            position: fixed;
        }

        .red {
            color: red;
        }

        .panelTital {
            font-weight: 600;
        }

        .x-column-inner {
            width: auto !important;
        }

        .x-panel .x-panel-noborder .x-column {
            width: auto !important;
        }

        .x-panel-body .x-panel-body-noheader .x-panel-body-noborder {
            width: auto !important;
        }

        .x-form-element {
            padding-left: 50px !important;
            width: auto !important;
        }

        .x-hide-label .x-form-element {
            padding-left: 10px !important;
        }
    </style>

</head>
<body>
    <script type="text/javascript">
        var CloseCRMWindow = function () {
            Ext.getCmp('<%=this.ViewPort1.ClientID%>').hide();
        }

        function downloadfile(url) {
            var iframe = document.createElement("iframe");
            iframe.src = url;
            iframe.style.display = "none";
            document.body.appendChild(iframe);
        }

        var DoSaveReturnDraft = function () {
            Ext.getCmp('<%=this.txtLotNumber.ClientID%>').focus();
            ShowEditingMask();
            Coolite.AjaxMethods.DoSaveReturn('doSaveDraft',
                {
                    success: function (result) {
                        if (result == 'Success') {
                            alert('保存草稿成功');
                            HideEditingMask();
                            window.location.href = window.location.href;
                        } else {
                            Ext.Msg.alert('Error', result);
                            HideEditingMask();
                        }


                    },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                        HideEditingMask();
                    }
                }
            );
        }

            var CheckSubmitReturn = function () {
                iCRMCheck = true;
                CheckCRMReturnField();

                if (iCRMCheck) {
                    Ext.Msg.confirm('信息', '物权类型为' + Ext.getCmp('PropertyRights').getValue() + ',只能进行' + Ext.getCmp('RETURNTYPE').getText() + ',是否要执行【提交退货单】操作吗？', function (e) {
                        if (e == "yes") {
                            Ext.getCmp('<%=this.txtLotNumber.ClientID%>').focus();
                        ShowEditingMask();
                        Coolite.AjaxMethods.DoSaveReturn('doSubmit',
                            {
                                success: function (result) {
                                    if (result == 'Success') {
                                        alert('提交成功!');
                                        HideEditingMask();
                                        window.location.href = window.location.href;
                                    } else {
                                        Ext.Msg.alert('Error', result);
                                        HideEditingMask();
                                    }
                                },
                                failure: function (err) {
                                    Ext.Msg.alert('Error', err);
                                    HideEditingMask();
                                }
                            }
                        );
                    }
                });
            }
        }

        var DoSaveDraft = function () {
            Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
            ShowEditingMask();
            Coolite.AjaxMethods.DoSave('doSaveDraft',
                {
                    success: function (result) {
                        if (result == 'Success') {
                            alert('保存草稿成功');
                            HideEditingMask();
                            window.location.href = window.location.href;
                        } else {
                            HideEditingMask();
                            Ext.Msg.alert('Error', result);
                        }
                    },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                        HideEditingMask();
                    }
                }
            );
        }

        var CheckCRMSubmit = function () {
            iCRMCheck = true;
            CheckCRMField();
            if (iCRMCheck) {
                CheckCRMFieldSpecial();
            }
            if (iCRMCheck) {
                Ext.Msg.confirm('信息', '是否要执行【提交】操作吗？', function (e) {
                    if (e == "yes") {
                        this.DoSubmit();
                    }
                });
            }
        }

        var DoSubmit = function () {
            Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
            ShowEditingMask();
            Coolite.AjaxMethods.DoSave('doSubmit',
            {
                success: function (result) {
                    if (result == 'Success') {
                        alert('提交成功！');
                        HideEditingMask();
                        window.location.href = window.location.href;
                    } else {
                        Ext.Msg.alert('Error', result);
                        HideEditingMask();
                    }
                },
                failure: function (err) {
                    Ext.Msg.alert('Error', err);
                    HideEditingMask();
                }
            }
            );
        }

        var DoDealerConfirm = function () {
            Ext.Msg.confirm("信息", "你确定要执行【经销商确认投诉单】操作吗？", function (e) {
                if (e == "yes") {
                    Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
                    ShowEditingMask();
                    Coolite.AjaxMethods.DoDealerConfirm(
                        {
                            success: function () {
                                alert('操作成功！');
                                HideEditingMask();
                                window.location.href = window.location.href;
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                                HideEditingMask();
                            }
                        }
                    );
                }
            });
        }

        var DoQAReceipt = function () {
            Ext.Msg.confirm("信息", "你确定要执行【QA确认收到投诉单】操作吗？", function (e) {
                if (e == "yes") {
                    Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
                    ShowEditingMask();
                    Coolite.AjaxMethods.DoQAReceipt(
                        {
                            success: function () {
                                alert('操作成功！');
                                HideEditingMask();
                                window.location.href = window.location.href;
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                                HideEditingMask();
                            }
                        }
                    );
                }
            });
        }

        var DoQASaveDraft = function () {
            Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
            ShowEditingMask();
            Coolite.AjaxMethods.DoQASaveDraft(
                {
                    success: function () {
                        alert('操作成功！');
                        HideEditingMask();
                        window.location.href = window.location.href;
                    },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                        HideEditingMask();
                    }
                }
            );
        }

        var DoQASubmit = function () {
            iCRMCheck = true;
            this.itemValid('<%=this.PI.ClientID%>');
            this.itemValid('<%=this.IAN.ClientID%>');
            this.itemValid('<%=this.RN.ClientID%>');
            CheckCRMField();
            if (iCRMCheck) {
                CheckCRMFieldSpecial();
            }
            if (iCRMCheck) {
                Ext.Msg.confirm("信息", "你确定要执行【提交】操作吗？", function (e) {
                    if (e == "yes") {
                        Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
                        ShowEditingMask();
                        Coolite.AjaxMethods.DoQASubmit(
                            {
                                success: function () {
                                    alert('操作成功！');
                                    HideEditingMask();
                                    window.location.href = window.location.href;
                                },
                                failure: function (err) {
                                    Ext.Msg.alert('Error', err);
                                    HideEditingMask();
                                }
                            }
                        );
                    }
                });
            }
        }

        var DoReject = function () {
            iCRMCheck = true;
            this.itemValid('<%=this.ComplainApprovelRemark.ClientID%>');
            if (iCRMCheck) {
                Ext.Msg.confirm("信息", "你确定要执行【退回】操作吗？", function (e) {
                    if (e == "yes") {
                        Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
                        ShowEditingMask();
                        Coolite.AjaxMethods.DoQAReject(
                            {
                                success: function () {
                                    alert('操作成功！');
                                    HideEditingMask();
                                    window.location.href = window.location.href;
                                },
                                failure: function (err) {
                                    Ext.Msg.alert('Error', err);
                                    HideEditingMask();
                                }
                            }
                        );
                    }
                });
            }
        }

        var ChangeDealer = function () {
            var hiddenInitDealerId = Ext.getCmp('<%=this.hiddenInitDealerId.ClientID%>');
            var cbDealer = Ext.getCmp('<%=this.cbDealer.ClientID%>');

            if (hiddenInitDealerId.getValue() != "") {
                Ext.Msg.confirm('Message', '改变经销商会清除产品和医院数据，是否继续？',
                function (e) {
                    if (e == 'yes') {
                        hiddenInitDealerId.setValue(cbDealer.getValue());
                        LoadDealerInfo();
                    } else {
                        cbDealer.setValue(hiddenInitDealerId.getValue());
                    }
                });
            } else {
                hiddenInitDealerId.setValue(cbDealer.getValue());
                LoadDealerInfo();
            }
        }

        var LoadDealerInfo = function () {
            cbDealer.focus();
            ShowEditingMask();
            Coolite.AjaxMethods.LoadDealerInfo({
                success: function () {
                    //清空产品信息和医院信息

                    Ext.getCmp('<%=this.txtLot.ClientID%>').setValue('');
                    Ext.getCmp('<%=this.txtUPN.ClientID%>').setValue('');
                    Ext.getCmp('<%=this.DESCRIPTION.ClientID%>').setValue('');
                    Ext.getCmp('<%=this.Model.ClientID%>').setValue('');
                    Ext.getCmp('<%=this.Registration.ClientID%>').setValue('');
                    Ext.getCmp('<%=this.DISTRIBUTORCUSTOMER.ClientID%>').setValue('');
                    Ext.getCmp('<%=this.DISTRIBUTORCITY.ClientID%>').setValue('');
                    Ext.getCmp('<%=this.PhysicianHospital.ClientID%>').setValue('');

                    HideEditingMask();
                }, failure: function (e) {
                    HideEditingMask(); Ext.Msg.alert('Error', err);
                }
            });
        }

        var ShowEditingMask = function () {
            var panel = Ext.getCmp('<%=this.complainCrmPanel.ClientID%>');
            panel.body.mask('Loading...', 'x-mask-loading');
            SetWinBtnDisabled(panel, true);
        }

        var HideEditingMask = function () {
            var panel = Ext.getCmp('<%=this.complainCrmPanel.ClientID%>');
            panel.body.unmask();
            SetWinBtnDisabled(panel, false);
        }

        var SetWinBtnDisabled = function (control, disabled) {
            for (var i = 0; i < control.buttons.length; i++) {
                control.buttons[i].setDisabled(disabled);
            }
        }

        var isRemainsServiceChheck = function (isRemainsService) {
            if (isRemainsService) {
                Ext.getCmp('<%=this.RemovedService_1.ClientID%>').setValue(false);
                Ext.getCmp('<%=this.RemovedService_2.ClientID%>').setValue(false);
                Ext.getCmp('<%=this.RemovedService_3.ClientID%>').setValue(false);
                Ext.getCmp('<%=this.RemovedService_4.ClientID%>').setValue(false);
            } else {
                Ext.getCmp('<%=this.RemainsService_1.ClientID%>').setValue(false);
                Ext.getCmp('<%=this.RemainsService_2.ClientID%>').setValue(false);
                Ext.getCmp('<%=this.RemainsService_3.ClientID%>').setValue(false);
                Ext.getCmp('<%=this.RemainsService_4.ClientID%>').setValue(false);
                Ext.getCmp('<%=this.RemainsService_5.ClientID%>').setValue(false);
            }
        }

        var showTextBoxWhenChecked = function (checkType) {

            if (checkType == 'Pulse_9') {
                if (Ext.getCmp('<%=this.Pulse_9.ClientID%>').checked) {
                    Ext.getCmp('<%=this.Pulsebeats.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.Pulsebeats.ClientID%>').hide();
                }
            }
            else if (checkType == 'Leads_1') {
                if (Ext.getCmp('<%=this.Leads_1.ClientID%>').checked) {
                    Ext.getCmp('<%=this.LeadsFracture.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.LeadsFracture.ClientID%>').hide();
                }
            }
            else if (checkType == 'Leads_2') {
                if (Ext.getCmp('<%=this.Leads_2.ClientID%>').checked) {
                    Ext.getCmp('<%=this.LeadsIssue.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.LeadsIssue.ClientID%>').hide();
                }
            }
            else if (checkType == 'Leads_3') {
                if (Ext.getCmp('<%=this.Leads_3.ClientID%>').checked) {
                    Ext.getCmp('<%=this.LeadsDislodgement.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.LeadsDislodgement.ClientID%>').hide();
                }
            }
            else if (checkType == 'Leads_4') {
                if (Ext.getCmp('<%=this.Leads_4.ClientID%>').checked) {
                    Ext.getCmp('<%=this.LeadsMeasurements.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.LeadsMeasurements.ClientID%>').hide();
                }
            }
            else if (checkType == 'Leads_6') {
                if (Ext.getCmp('<%=this.Leads_6.ClientID%>').checked) {
                    Ext.getCmp('<%=this.LeadsThresholds.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.LeadsThresholds.ClientID%>').hide();
                }
            }
            else if (checkType == 'Leads_7') {
                if (Ext.getCmp('<%=this.Leads_7.ClientID%>').checked) {
                    Ext.getCmp('<%=this.LeadsBeats.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.LeadsBeats.ClientID%>').hide();
                }
            }
            else if (checkType == 'Leads_8') {
                if (Ext.getCmp('<%=this.Leads_8.ClientID%>').checked) {
                    Ext.getCmp('<%=this.LeadsNoise.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.LeadsNoise.ClientID%>').hide();
                }
            }
            else if (checkType == 'Leads_9') {
                if (Ext.getCmp('<%=this.Leads_9.ClientID%>').checked) {
                    Ext.getCmp('<%=this.LeadsLoss.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.LeadsLoss.ClientID%>').hide();
                }
            }
            else if (checkType == 'Clinical_1') {
                if (Ext.getCmp('<%=this.Clinical_1.ClientID%>').checked) {
                    Ext.getCmp('<%=this.ClinicalPerforation.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.ClinicalPerforation.ClientID%>').hide();
                }
            }
            else if (checkType == 'Clinical_3') {
                if (Ext.getCmp('<%=this.Clinical_3.ClientID%>').checked) {
                    Ext.getCmp('<%=this.ClinicalBeats.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.ClinicalBeats.ClientID%>').hide();
                }
            }
        }

var isDeathCheck = function () {
    if (Ext.getCmp('<%=this.PatientStatus_6.ClientID%>').checked) {
                document.getElementById('<%=this.deathTable1.ClientID%>').style.display = "";
                document.getElementById('<%=this.deathTable2.ClientID%>').style.display = "";
            } else {
                document.getElementById('<%=this.deathTable1.ClientID%>').style.display = "none";
                document.getElementById('<%=this.deathTable2.ClientID%>').style.display = "none";
            }
        }

        var hasFollowOperationCheck = function () {
            if (Ext.getCmp('<%=this.HasFollowOperation_1.ClientID%>').checked) {
                document.getElementById('<%=this.tdlblFollowOperationDate.ClientID%>').style.display = "";
                document.getElementById('<%=this.tdFollowOperationDate.ClientID%>').style.display = "";
                document.getElementById('<%=this.tdlblFollowOperationStaff.ClientID%>').style.display = "";
                document.getElementById('<%=this.tdFollowOperationStaff.ClientID%>').style.display = "";
            } else {
                document.getElementById('<%=this.tdlblFollowOperationDate.ClientID%>').style.display = "none";
                document.getElementById('<%=this.tdFollowOperationDate.ClientID%>').style.display = "none";
                document.getElementById('<%=this.tdlblFollowOperationStaff.ClientID%>').style.display = "none";
                document.getElementById('<%=this.tdFollowOperationStaff.ClientID%>').style.display = "none";
            }
        }

        function ComboxSelValue(e) {
            var combo = e.combo;
            combo.collapse();
            if (!e.forceAll) {
                var input = e.query;
                if (input != null && input != '') {
                    // 检索的正则
                    var regExp = new RegExp(".*" + input + ".*");
                    // 执行检索
                    combo.store.filterBy(function (record, id) {
                        // 得到每个record的项目名称值
                        var text = record.get(combo.displayField);
                        return regExp.test(text);
                    });
                } else {
                    combo.store.clearFilter();
                }
                combo.expand();
                return false;
            }
        }

        var iCRMCheck = true;
        function CheckCRMField() {
            this.itemValid('<%=this.cbDealer.ClientID%>');
            this.itemValid('<%=this.txtLot.ClientID%>');
            this.itemValid('<%=this.txtUPN.ClientID%>');
            this.itemValid('<%=this.DESCRIPTION.ClientID%>');
            this.itemValid('<%=this.CompletedName.ClientID%>');
            this.itemValid('<%=this.CompletedTitle.ClientID%>');
            this.itemValid('<%=this.DateEvent.ClientID%>');
            //this.itemValid('<%=this.DateReceipt.ClientID%>');
            this.itemValid('<%=this.NonBostonName.ClientID%>');
            //this.itemValid('<%=this.DateDealer.ClientID%>');
            this.itemValid('<%=this.CompletedPhone.ClientID%>');
            this.itemValid('<%=this.EventCountry.ClientID%>');
            this.itemValid('<%=this.CompletedEmail.ClientID%>');
            this.groupItemValid('<%=NeedSupport.ClientID%>');
            //this.groupItemValid('<%=HasFollowOperation.ClientID%>');
            this.groupItemValid('<%=this.ISPLATFORM.ClientID%>');
            this.itemValid('<%=this.BSCSOLDTOACCOUNT.ClientID%>');
            this.itemValid('<%=this.BSCSOLDTONAME.ClientID%>');
            this.itemValid('<%=this.BSCSOLDTOCITY.ClientID%>');
            this.itemValid('<%=this.DISTRIBUTORCUSTOMER.ClientID%>');
            this.itemValid('<%=this.DISTRIBUTORCITY.ClientID%>');
            this.itemValid('<%=this.PatientName.ClientID%>');
            this.itemValid('<%=this.PatientNum.ClientID%>');
            this.itemValid('<%=this.PhysicianName.ClientID%>');
            this.itemValid('<%=this.PhysicianTitle.ClientID%>');
            this.itemValid('<%=this.PhysicianAddress.ClientID%>');
            this.itemValid('<%=this.PhysicianCity.ClientID%>');
            this.itemValid('<%=this.PhysicianZipcode.ClientID%>');
            this.itemValid('<%=this.PhysicianCountry.ClientID%>');
            this.groupItemValid('<%=this.PatientStatus.ClientID%>');
            this.groupItemValid('<%=this.IsForBSCProduct.ClientID%>');
            this.groupItemValid('<%=this.ReasonsForProduct.ClientID%>');
            this.groupItemValid('<%=this.Returned.ClientID%>');
            this.groupItemValid('<%=this.AnalysisReport.ClientID%>');
            //this.itemValid('<%=this.RequestPhysicianName.ClientID%>');
            this.groupItemValid('<%=this.Warranty.ClientID%>');
        }

        var iCRMCheck = true;
        function CheckCRMReturnField() {
            this.itemValid('<%=this.txtQrCode.ClientID%>');
            this.itemValid('<%=this.txtWarehouse.ClientID%>');
            this.itemValid('<%=this.SalesDate.ClientID%>');
            this.groupItemValid('<%=PRODUCTTYPE.ClientID%>');
            this.itemValid('<%=this.RETURNTYPE.ClientID%>');
 <%--           this.itemValid('<%=this.CarrierNumber.ClientID%>');
            this.itemValid('<%=this.CourierCompany.ClientID%>');--%>
        }

        function groupItemValid(controlId) {
            var i = Ext.getCmp(controlId);
            if (iCRMCheck) {
                var checkboxgroupChk = false;
                i.items.each(
                function (item, index, length) {

                    if (item.checked) {
                        checkboxgroupChk = true;
                    }
                });

                if (!checkboxgroupChk) {
                    alert(i.blankText);
                    i.focus();
                    iCRMCheck = false;
                }
            }
        }

        function itemValid(controlId) {
            var item = Ext.getCmp(controlId);
            if (iCRMCheck) {
                if (item.getValue() == "") {
                    alert(item.blankText);
                    item.focus();
                    iCRMCheck = false;
                }
            }
        }

        function CheckCRMFieldSpecial() {

            //是否有跟台填了是，则跟台日期，跟台人员必填
            if (Ext.getCmp('<%=this.HasFollowOperation_1.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.FollowOperationDate.ClientID%>').getValue() == null || Ext.getCmp('<%=this.FollowOperationDate.ClientID%>').getValue() == '') {
                    Ext.getCmp('<%=this.FollowOperationDate.ClientID%>').focus();
                    alert("跟台日期必须填写");
                    iCRMCheck = false;
                    return false;
                }
                if ((Ext.getCmp('<%=this.FollowOperationStaff_1.ClientID%>').getValue() == null || Ext.getCmp('<%=this.FollowOperationStaff_1.ClientID%>').getValue() == '')
                    && (Ext.getCmp('<%=this.FollowOperationStaff_2.ClientID%>').getValue() == null || Ext.getCmp('<%=this.FollowOperationStaff_2.ClientID%>').getValue() == '')) {
                    Ext.getCmp('<%=this.FollowOperationStaff.ClientID%>').focus();
                    alert("跟台人员必须填写");
                    iCRMCheck = false;
                    return false;
                }
            }

            if ((Ext.getCmp('<%=this.DateReceipt.ClientID%>').getValue() == null || Ext.getCmp('<%=this.DateReceipt.ClientID%>').getValue() == '')
                && (Ext.getCmp('<%=this.DateDealer.ClientID%>').getValue() == null || Ext.getCmp('<%=this.DateDealer.ClientID%>').getValue() == '')) {
                Ext.getCmp('<%=this.DateReceipt.ClientID%>').focus();
                alert("波科人员接报日期与代理商接报日期，两者必填一个");
                iCRMCheck = false;
                return false;
            }

            //病人信息要么填写，要么选择不能获取
            if ((Ext.getCmp('<%=this.PatientSex.ClientID%>').getValue() == null || Ext.getCmp('<%=this.PatientSex.ClientID%>').getValue() == '') && !Ext.getCmp('<%=this.PatientSexInvalid.ClientID%>').checked) {
                alert("请填写患者性别或选择不能获取");
                Ext.getCmp('<%=this.PatientSex.ClientID%>').focus();
                iCRMCheck = false;
                return false;
            }

            if ((Ext.getCmp('<%=this.PatientBirth.ClientID%>').getValue() == null || Ext.getCmp('<%=this.PatientBirth.ClientID%>').getValue() == '') && !Ext.getCmp('<%=this.PatientBirthInvalid.ClientID%>').checked) {
                alert("请填写患者出生年月日或选择不能获取");
                Ext.getCmp('<%=this.PatientBirth.ClientID%>').focus();
                iCRMCheck = false;
                return false;
            }

            if ((Ext.getCmp('<%=this.PatientWeight.ClientID%>').getValue() == null || Ext.getCmp('<%=this.PatientWeight.ClientID%>').getValue() == '') && !Ext.getCmp('<%=this.PatientWeightInvalid.ClientID%>').checked) {
                alert("请填写患者体重或选择不能获取");
                Ext.getCmp('<%=this.PatientWeight.ClientID%>').focus();
                iCRMCheck = false;
                return false;
            }

            //如果选择了死亡，则下面的内容是必填的
            if (Ext.getCmp('<%=this.PatientStatus_6.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.DeathDate.ClientID%>').getValue() == null || Ext.getCmp('<%=this.DeathDate.ClientID%>').getValue() == '') {
                    alert("请选择死亡日期");
                    Ext.getCmp('<%=this.DeathDate.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }

                if (Ext.getCmp('<%=this.DeathTime.ClientID%>').getValue() == null || Ext.getCmp('<%=this.DeathTime.ClientID%>').getValue() == '') {
                    alert("请填写死亡时间");
                    Ext.getCmp('<%=this.DeathTime.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }

                if (Ext.getCmp('<%=this.DeathCause.ClientID%>').getValue() == null || Ext.getCmp('<%=this.DeathCause.ClientID%>').getValue() == '') {
                    alert("请填写死亡原因");
                    Ext.getCmp('<%=this.DeathCause.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }

                if (!Ext.getCmp('<%=this.Witnessed_1.ClientID%>').checked && !Ext.getCmp('<%=this.Witnessed_2.ClientID%>').checked) {
                    alert("请选择上报人是否在场");
                    Ext.getCmp('<%=this.Witnessed_1.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }

                if (!Ext.getCmp('<%=this.RelatedBSC_1.ClientID%>').checked && !Ext.getCmp('<%=this.RelatedBSC_2.ClientID%>').checked && !Ext.getCmp('<%=this.RelatedBSC_3.ClientID%>').checked) {
                    alert("请选择是否怀疑该死亡与波科产品故障有关");
                    Ext.getCmp('<%=this.RelatedBSC_1.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            if (Ext.getCmp('<%=this.Returned_1.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.ReturnedDay.ClientID%>').getValue() == null || Ext.getCmp('<%=this.ReturnedDay.ClientID%>').getValue() == '') {
                    alert("请填写需要多少天返回");
                    Ext.getCmp('<%=this.ReturnedDay.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            if (Ext.getCmp('<%=this.AnalysisReport_1.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.RequestPhysicianName.ClientID%>').getValue() == null || Ext.getCmp('<%=this.RequestPhysicianName.ClientID%>').getValue() == '') {
                    alert("请填写要求提供报告的医生姓名");
                    Ext.getCmp('<%=this.RequestPhysicianName.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            //校验
            if (Ext.getCmp('<%=this.Pulse_9.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.Pulsebeats.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Pulsebeats.ClientID%>').getValue() == '') {
                    alert("请填写抑制起搏的跳数");
                    Ext.getCmp('<%=this.Pulsebeats.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            if (Ext.getCmp('<%=this.Leads_1.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.LeadsFracture.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsFracture.ClientID%>').getValue() == '') {
                    alert("请填写电极导体断裂");
                    Ext.getCmp('<%=this.LeadsFracture.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            if (Ext.getCmp('<%=this.Leads_2.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.LeadsIssue.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsIssue.ClientID%>').getValue() == '') {
                    alert("请填写绝缘层问题");
                    Ext.getCmp('<%=this.LeadsIssue.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            if (Ext.getCmp('<%=this.Leads_3.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.LeadsDislodgement.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsDislodgement.ClientID%>').getValue() == '') {
                    alert("请填写电极脱位");
                    Ext.getCmp('<%=this.LeadsDislodgement.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            if (Ext.getCmp('<%=this.Leads_4.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.LeadsMeasurements.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsMeasurements.ClientID%>').getValue() == '') {
                    alert("请填写阻抗测量值异常");
                    Ext.getCmp('<%=this.LeadsMeasurements.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            if (Ext.getCmp('<%=this.Leads_6.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.LeadsThresholds.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsThresholds.ClientID%>').getValue() == '') {
                    alert("请填写起搏阈值过高");
                    Ext.getCmp('<%=this.LeadsThresholds.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            if (Ext.getCmp('<%=this.Leads_7.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.LeadsBeats.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsBeats.ClientID%>').getValue() == '') {
                    alert("请填写抑制起搏的跳数");
                    Ext.getCmp('<%=this.LeadsBeats.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }
            if (Ext.getCmp('<%=this.Leads_8.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.LeadsNoise.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsNoise.ClientID%>').getValue() == '') {
                    alert("请填写噪声");
                    Ext.getCmp('<%=this.LeadsNoise.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            if (Ext.getCmp('<%=this.Leads_9.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.LeadsLoss.ClientID%>').getValue() == null || Ext.getCmp('<%=this.LeadsLoss.ClientID%>').getValue() == '') {
                    alert("请填写失夺获");
                    Ext.getCmp('<%=this.LeadsLoss.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            if (Ext.getCmp('<%=this.Clinical_1.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.ClinicalPerforation.ClientID%>').getValue() == null || Ext.getCmp('<%=this.ClinicalPerforation.ClientID%>').getValue() == '') {
                    alert("请填写穿孔");
                    Ext.getCmp('<%=this.ClinicalPerforation.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            if (Ext.getCmp('<%=this.Clinical_3.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.ClinicalBeats.ClientID%>').getValue() == null || Ext.getCmp('<%=this.ClinicalBeats.ClientID%>').getValue() == '') {
                    alert("请填写阻抗测量值异常");
                    Ext.getCmp('<%=this.ClinicalBeats.ClientID%>').focus();
                    iCRMCheck = false;
                    return false;
                }
            }

            //校验临床观察中的3组多选框必须要选择一个       
            var clinicCheckboxgroupChk = false;
            if (Ext.getCmp('<%=this.Pulse_1.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_2.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_3.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_4.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_5.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_6.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_7.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_8.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_9.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_10.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_11.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_12.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_13.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_14.ClientID%>').checked
                     || Ext.getCmp('<%=this.Pulse_15.ClientID%>').checked
                     ) {
                clinicCheckboxgroupChk = true;
            }
            if (Ext.getCmp('<%=this.Leads_1.ClientID%>').checked
                    || Ext.getCmp('<%=this.Leads_2.ClientID%>').checked
                    || Ext.getCmp('<%=this.Leads_3.ClientID%>').checked
                    || Ext.getCmp('<%=this.Leads_4.ClientID%>').checked
                    || Ext.getCmp('<%=this.Leads_5.ClientID%>').checked
                    || Ext.getCmp('<%=this.Leads_6.ClientID%>').checked
                    || Ext.getCmp('<%=this.Leads_7.ClientID%>').checked
                    || Ext.getCmp('<%=this.Leads_8.ClientID%>').checked
                    || Ext.getCmp('<%=this.Leads_9.ClientID%>').checked
                    || Ext.getCmp('<%=this.Leads_10.ClientID%>').checked
                    || Ext.getCmp('<%=this.Leads_11.ClientID%>').checked
                    ) {
                clinicCheckboxgroupChk = true;
            }
            if (Ext.getCmp('<%=this.Clinical_1.ClientID%>').checked
                     || Ext.getCmp('<%=this.Clinical_2.ClientID%>').checked
                     || Ext.getCmp('<%=this.Clinical_3.ClientID%>').checked
                     || Ext.getCmp('<%=this.Clinical_4.ClientID%>').checked
                     || Ext.getCmp('<%=this.Clinical_5.ClientID%>').checked
                     || Ext.getCmp('<%=this.Clinical_6.ClientID%>').checked
                     || Ext.getCmp('<%=this.Clinical_7.ClientID%>').checked
                     || Ext.getCmp('<%=this.Clinical_8.ClientID%>').checked
                     || Ext.getCmp('<%=this.Clinical_9.ClientID%>').checked
                     || Ext.getCmp('<%=this.Clinical_10.ClientID%>').checked
                     || Ext.getCmp('<%=this.Clinical_11.ClientID%>').checked
                     || Ext.getCmp('<%=this.Clinical_12.ClientID%>').checked
                     ) {
                clinicCheckboxgroupChk = true;
            }
            if (!clinicCheckboxgroupChk) {
                Ext.getCmp('<%=this.Pulse_1.ClientID%>').focus();
                alert("【7. 临床观察】中的脉冲发生器/程控仪、电极/传送系统、临床3个选择项必须选择至少一项！");
                iCRMCheck = false;
                return false;
            }


            //校验脉冲发生器、电极1、电极2、电极3、配件必须至少选择一个       
            if ((Ext.getCmp('<%=this.PulseModel.ClientID%>').getValue() == null || Ext.getCmp('<%=this.PulseModel.ClientID%>').getValue() == '')
             && (Ext.getCmp('<%=this.Leads1Model.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads1Model.ClientID%>').getValue() == '')
             && (Ext.getCmp('<%=this.Leads2Model.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads2Model.ClientID%>').getValue() == '')
             && (Ext.getCmp('<%=this.Leads3Model.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads3Model.ClientID%>').getValue() == '')
             && (Ext.getCmp('<%=this.AccessoryModel.ClientID%>').getValue() == null || Ext.getCmp('<%=this.AccessoryModel.ClientID%>').getValue() == '')) {
                Ext.getCmp('<%=this.PulseModel.ClientID%>').focus();
                alert("校验脉冲发生器、电极1、电极2、电极3、配件必须至少填写一项");
                iCRMCheck = false;
                return false;
            }

            if (Ext.getCmp('<%=this.PulseModel.ClientID%>').getValue() != null && Ext.getCmp('<%=this.PulseModel.ClientID%>').getValue() != '') {
                if ((Ext.getCmp('<%=this.PulseSerial.ClientID%>').getValue() == null || Ext.getCmp('<%=this.PulseSerial.ClientID%>').getValue() == '')
                 || (Ext.getCmp('<%=this.PulseImplant.ClientID%>').getValue() == null || Ext.getCmp('<%=this.PulseImplant.ClientID%>').getValue() == '')) {
                    Ext.getCmp('<%=this.PulseModel.ClientID%>').focus();
                    alert("脉冲发生器的Serial、植入时间也必须填写");
                    iCRMCheck = false;
                    return false;
                }
            }
            if (Ext.getCmp('<%=this.Leads1Model.ClientID%>').getValue() != null && Ext.getCmp('<%=this.Leads1Model.ClientID%>').getValue() != '') {
                if ((Ext.getCmp('<%=this.Leads1Serial.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads1Serial.ClientID%>').getValue() == '')
                 || (Ext.getCmp('<%=this.Leads1Implant.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads1Implant.ClientID%>').getValue() == '')) {
                    Ext.getCmp('<%=this.Leads1Model.ClientID%>').focus();
                    alert("电极1的Serial、植入时间也必须填写");
                    iCRMCheck = false;
                    return false;

                } else if (!Ext.getCmp('<%=this.Leads1Position_1.ClientID%>').checked && !Ext.getCmp('<%=this.Leads1Position_2.ClientID%>').checked && !Ext.getCmp('<%=this.Leads1Position_3.ClientID%>').checked && !Ext.getCmp('<%=this.Leads1Position_4.ClientID%>').checked) {

                    Ext.getCmp('<%=this.Leads1Position_1.ClientID%>').focus();
                    alert("电极1的电极位置必须选择");
                    iCRMCheck = false;
                    return false;
                }
        }
        if (Ext.getCmp('<%=this.Leads2Model.ClientID%>').getValue() != null && Ext.getCmp('<%=this.Leads2Model.ClientID%>').getValue() != '') {
                if ((Ext.getCmp('<%=this.Leads2Serial.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads2Serial.ClientID%>').getValue() == '')
                 || (Ext.getCmp('<%=this.Leads2Implant.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads2Implant.ClientID%>').getValue() == '')) {
                    Ext.getCmp('<%=this.Leads2Model.ClientID%>').focus();
                    alert("电极2的Serial、植入时间也必须填写");
                    iCRMCheck = false;
                    return false;
                } else if (!Ext.getCmp('<%=this.Leads2Position_1.ClientID%>').checked && !Ext.getCmp('<%=this.Leads2Position_2.ClientID%>').checked && !Ext.getCmp('<%=this.Leads2Position_3.ClientID%>').checked && !Ext.getCmp('<%=this.Leads2Position_4.ClientID%>').checked) {

                    Ext.getCmp('<%=this.Leads2Position_1.ClientID%>').focus();
                    alert("电极2的电极位置必须选择");
                    iCRMCheck = false;
                    return false;
                }
        }
        if (Ext.getCmp('<%=this.Leads3Model.ClientID%>').getValue() != null && Ext.getCmp('<%=this.Leads3Model.ClientID%>').getValue() != '') {
                if ((Ext.getCmp('<%=this.Leads3Serial.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads3Serial.ClientID%>').getValue() == '')
                 || (Ext.getCmp('<%=this.Leads3Implant.ClientID%>').getValue() == null || Ext.getCmp('<%=this.Leads3Implant.ClientID%>').getValue() == '')) {
                    Ext.getCmp('<%=this.Leads3Model.ClientID%>').focus();
                    alert("电极3的Serial、植入时间也必须填写");
                    iCRMCheck = false;
                    return false;

                } else if (!Ext.getCmp('<%=this.Leads3Position_1.ClientID%>').checked && !Ext.getCmp('<%=this.Leads3Position_2.ClientID%>').checked && !Ext.getCmp('<%=this.Leads3Position_3.ClientID%>').checked && !Ext.getCmp('<%=this.Leads3Position_4.ClientID%>').checked) {

                    Ext.getCmp('<%=this.Leads3Position_1.ClientID%>').focus();
                    alert("电极3的电极位置必须选择");
                    iCRMCheck = false;
                    return false;
                }
        }
        if (Ext.getCmp('<%=this.AccessoryModel.ClientID%>').getValue() != null && Ext.getCmp('<%=this.AccessoryModel.ClientID%>').getValue() != '') {
                if ((Ext.getCmp('<%=this.AccessorySerial.ClientID%>').getValue() == null || Ext.getCmp('<%=this.AccessorySerial.ClientID%>').getValue() == '')
                 || (Ext.getCmp('<%=this.AccessoryImplant.ClientID%>').getValue() == null || Ext.getCmp('<%=this.AccessoryImplant.ClientID%>').getValue() == '')) {
                    Ext.getCmp('<%=this.AccessoryModel.ClientID%>').focus();
                    alert("配件的Serial、植入时间也必须填写");
                    iCRMCheck = false;
                    return false;
                }
            }

            //仍在服务中的选择项和产品已移除体内
            if (Ext.getCmp('<%=this.RemainsService_1.ClientID%>').checked
             || Ext.getCmp('<%=this.RemainsService_2.ClientID%>').checked
             || Ext.getCmp('<%=this.RemainsService_3.ClientID%>').checked
             || Ext.getCmp('<%=this.RemainsService_4.ClientID%>').checked
             || Ext.getCmp('<%=this.RemainsService_5.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.RemovedService_1.ClientID%>').checked ||
                    Ext.getCmp('<%=this.RemovedService_2.ClientID%>').checked ||
                    Ext.getCmp('<%=this.RemovedService_3.ClientID%>').checked ||
                    Ext.getCmp('<%=this.RemovedService_4.ClientID%>').checked) {

                    Ext.getCmp('<%=this.RemainsService_1.ClientID%>').focus();
                    alert("仍在服务中的选择项和产品已移除体内的选择项不能同时选择");
                    iCRMCheck = false;
                    return false;
                }
            }

            //仍在服务中的选择项和产品已移除体内
            if (Ext.getCmp('<%=this.RemovedService_1.ClientID%>').checked ||
                Ext.getCmp('<%=this.RemovedService_2.ClientID%>').checked ||
                Ext.getCmp('<%=this.RemovedService_3.ClientID%>').checked ||
                Ext.getCmp('<%=this.RemovedService_4.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.RemainsService_1.ClientID%>').checked
                  || Ext.getCmp('<%=this.RemainsService_2.ClientID%>').checked
                  || Ext.getCmp('<%=this.RemainsService_3.ClientID%>').checked
                  || Ext.getCmp('<%=this.RemainsService_4.ClientID%>').checked
                  || Ext.getCmp('<%=this.RemainsService_5.ClientID%>').checked) {

                    Ext.getCmp('<%=this.RemainsService_1.ClientID%>').focus();
                    alert("仍在服务中的选择项和产品已移除体内的选择项不能同时选择");
                    iCRMCheck = false;
                    return false;
                }
            }

            if (!Ext.getCmp('<%=this.RemovedService_1.ClientID%>').checked &&
                !Ext.getCmp('<%=this.RemovedService_2.ClientID%>').checked &&
                !Ext.getCmp('<%=this.RemovedService_3.ClientID%>').checked &&
                !Ext.getCmp('<%=this.RemovedService_4.ClientID%>').checked &&
                !Ext.getCmp('<%=this.RemainsService_1.ClientID%>').checked &&
                !Ext.getCmp('<%=this.RemainsService_2.ClientID%>').checked &&
                !Ext.getCmp('<%=this.RemainsService_3.ClientID%>').checked &&
                !Ext.getCmp('<%=this.RemainsService_4.ClientID%>').checked &&
                !Ext.getCmp('<%=this.RemainsService_5.ClientID%>').checked) {

                Ext.getCmp('<%=this.RemainsService_1.ClientID%>').focus();
                alert("仍在服务中的选择项和产品已移除体内的选择项至少要选择一项");
                iCRMCheck = false;
                return false;
            }

            //表格第9部分需要填写
            if (Ext.getCmp('<%=this.ProductExpDetail.ClientID%>').getValue() == null || Ext.getCmp('<%=this.ProductExpDetail.ClientID%>').getValue() == '') {
                alert("请填写产品体验详细的时间描述或临床观察");
                Ext.getCmp('<%=this.ProductExpDetail.ClientID%>').focus();
                iCRMCheck = false;
                return false;
            }
        }

        var DoExportForm = function () {
            Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
            ShowEditingMask();
            Coolite.AjaxMethods.DoExportForm({
                success: function (rtn) {
                    HideEditingMask();
                    if (rtn != '') {
                        var value = Ext.util.JSON.decode(rtn);
                        var url = '../Download.aspx?downloadname=' + value.ComplainNbr + '.docx&filename=' + escape(value.FilePath) + '&downtype=DealerComplain';
                        downloadfile(url);
                    }
                },
                failure: function (err) {
                    Ext.Msg.alert('Error', err);
                    HideEditingMask();
                }
            });
        }

        var isAnalysisReportCheck = function () {
            if (Ext.getCmp('<%=this.AnalysisReport_1.ClientID%>').checked) {
                document.getElementById('<%=this.tdlblRequestPhysicianName.ClientID%>').style.visibility = "";
                document.getElementById('<%=this.tdRequestPhysicianName.ClientID%>').style.visibility = "";
            } else {
                Ext.getCmp('RequestPhysicianName').setValue('');
                document.getElementById('<%=this.tdlblRequestPhysicianName.ClientID%>').style.visibility = "hidden";
                document.getElementById('<%=this.tdRequestPhysicianName.ClientID%>').style.visibility = "hidden";
            }
        }

        var isReturnedCheck = function () {
            if (Ext.getCmp('<%=this.Returned_1.ClientID%>').checked) {
                document.getElementById('<%=this.tdlblReturnedDay.ClientID%>').style.visibility = "";
                document.getElementById('<%=this.tdReturnedDay.ClientID%>').style.visibility = "";
            } else {
                Ext.getCmp('ReturnedDay').setValue('');
                document.getElementById('<%=this.tdlblReturnedDay.ClientID%>').style.visibility = "hidden";
                document.getElementById('<%=this.tdReturnedDay.ClientID%>').style.visibility = "hidden";
            }
        }
    </script>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
        <ext:Store ID="DealerStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="Id">
                    <Fields>
                        <ext:RecordField Name="Id" />
                        <ext:RecordField Name="ChineseShortName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler="#{cbDealer}.setValue(#{hiddenInitDealerId}.getValue());" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="BscUserStore" runat="server" UseIdConfirmation="true">
            <Reader>
                <ext:JsonReader ReaderID="UserAccount">
                    <Fields>
                        <ext:RecordField Name="UserAccount" />
                        <ext:RecordField Name="UserName" />
                    </Fields>
                </ext:JsonReader>
            </Reader>
            <Listeners>
                <Load Handler="#{CompletedName}.setValue(#{hiddenBscUserId}.getValue());" />
            </Listeners>
        </ext:Store>
        <ext:Store ID="OrderLogStore" runat="server" UseIdConfirmation="false" AutoLoad="true" OnRefreshData="OrderLogStore_RefershData">
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
        <ext:Store ID="AttachmentStore" runat="server" UseIdConfirmation="false" AutoLoad="true" OnRefreshData="AttachmentStore_Refresh">
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
        <ext:Store ID="AttachmentRtnStore" runat="server" UseIdConfirmation="false" AutoLoad="true" OnRefreshData="AttachmentRtnStore_Refresh">
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
        <ext:Hidden ID="hidInstanceId" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenInitDealerId" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenInitUserId" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenBscUserId" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenLastUpdateDate" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenConfirmUpdateDate" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenAttachmentUpload" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenBu" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenBuCode" runat="server"></ext:Hidden>
        <div id="divComplainCrm">
            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout2" runat="server">
                        <Center MarginsSummary="0 5 0 5">
                            <ext:Panel ID="complainCrmPanel" runat="server" BodyBorder="true"
                                Header="false" AutoHeight="false" AutoScroll="true">
                                <Body>
                                    <ext:Panel ID="returnPanel" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px 5px;" BodyBorder="true"
                                        Title="退货申请单" Header="true" Collapsible="true" AutoHeight="true">
                                        <Body>
                                            <ext:Panel ID="Panel14" runat="server" Title="产品信息" Header="true"
                                                BodyBorder="true" Collapsible="true" BodyStyle="background-color: #D9E7F8;padding:10px 0;">
                                                <Body>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="width: 120px;"><span class="red">*</span>产品批号(SN):</td>
                                                            <td style="">
                                                                <ext:TextField ID="txtLotNumber" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                            <td style="width: 120px;"><span class="red">*</span>型号(Model#):</td>
                                                            <td style="">
                                                                <ext:TextField ID="txtModel" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                            <td style="width: 120px;"><span class="red">*</span>二维码:</td>
                                                            <td style="">
                                                                <ext:TextField ID="txtQrCode" runat="server" Disabled="true" BlankText="请选择二维码"></ext:TextField>
                                                                <ext:Hidden ID="hiddenQrCode" runat="server"></ext:Hidden>
                                                                <ext:ImageButton ID="imbtnSearchQrCode" runat="server" ImageUrl="~/resources/images/Search.gif" OnClientClick="openQrCodeSearchDlg(#{txtUPN}.getValue(),#{txtLot}.getValue(),#{hiddenInitDealerId}.getValue(),null);"></ext:ImageButton>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><span class="red">*</span>注册证:</td>
                                                            <td>
                                                                <ext:TextField ID="txtRegistration" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                            <td><span class="red">*</span>产品有效期:</td>
                                                            <td>
                                                                <ext:TextField ID="txtExpiredDate" runat="server" Disabled="true"></ext:TextField>
                                                                <ext:Hidden ID="hiddenExpiredDate" runat="server"></ext:Hidden>
                                                            </td>
                                                            <td><span class="red">*</span>仓库:</td>
                                                            <td>
                                                                <ext:TextField ID="txtWarehouse" runat="server" Disabled="true" BlankText="请选择仓库"></ext:TextField>
                                                                <ext:Hidden ID="hiddenWarehouseId" runat="server"></ext:Hidden>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><span class="red">*</span>销售日期:</td>
                                                            <td>
                                                                <ext:DateField ID="SalesDate" runat="server" FieldLabel="销售日期" AllowBlank="false" BlankText="请选择销售日期" Width="150"></ext:DateField>
                                                                <ext:Hidden ID="hiddenHasSalesDate" runat="server"></ext:Hidden>
                                                                <ext:Hidden ID="hiddenSalesDate" runat="server"></ext:Hidden>
                                                            </td>
                                                            <td>波科DN号码:</td>
                                                            <td>
                                                                <ext:TextField ID="DNNo" runat="server" FieldLabel="波科DN号码" AllowBlank="true" Disabled="true" noedit="TRUE" />
                                                            </td>
                                                            <td>退货单状态:</td>
                                                            <td>
                                                                <ext:Hidden ID="hiddenReturnStatus" runat="server"></ext:Hidden>
                                                                <ext:TextField ID="txtReturnStatus" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>快递单号:</td>
                                                            <td>
                                                                <ext:TextField ID="CarrierNumber" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                            <td>快递公司:</td>
                                                            <td>
                                                                <ext:TextField ID="CourierCompany" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                            <td>产品描述:</td>
                                                            <td>
                                                                <ext:TextField ID="ProductDescription" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>备注:</td>
                                                            <td colspan="5">
                                                                <ext:TextArea ID="REMARK" runat="server" Width="500"></ext:TextArea>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>
                                            <ext:Panel ID="Panel15" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px 0;"
                                                BodyBorder="true" Title="销售情况" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="width: 120px;"><span class="red">*</span>产品类型:</td>
                                                            <td style="">
                                                                <ext:RadioGroup ID="PRODUCTTYPE" runat="server" FieldLabel="<font color='red'>*</font>产品类型"
                                                                    AllowBlank="true" AutoWidth="true" BlankText="请选择【销售情况】中的【产品类型】" ColumnsNumber="3" ReadOnly="True" FieldClass="x-item-disabled">
                                                                    <Items>
                                                                        <ext:Radio ID="PRODUCTTYPE_8" runat="server" BoxLabel="市场部/销售部样品" cvalue="8" ReadOnly="True" />
                                                                        <ext:Radio ID="PRODUCTTYPE_9" runat="server" BoxLabel="临床试验用的样品" cvalue="9" ReadOnly="True" />
                                                                        <ext:Radio ID="PRODUCTTYPE_10" runat="server" BoxLabel="新技术应用的样品" cvalue="10" ReadOnly="True" />
                                                                        <ext:Radio ID="PRODUCTTYPE_11" runat="server" BoxLabel="销售员(SRAI)/工程师(FSEAI)" cvalue="11" ReadOnly="True" />
                                                                        <ext:Radio ID="PRODUCTTYPE_12" runat="server" BoxLabel="程控仪" cvalue="12" ReadOnly="True" />
                                                                        <ext:Radio ID="PRODUCTTYPE_13" runat="server" BoxLabel="综合: 平台物权、T1物权、T2物权、医院物权、波科物权" cvalue="13" ReadOnly="True" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                            <td>物权类型:</td>
                                                            <td>
                                                                <ext:TextField ID="PropertyRights" runat="server" Width="250" ReadOnly="True" FieldClass="x-item-disabled" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>收到返回产品登记号:</td>
                                                            <td>
                                                                <ext:TextField ID="ReturnProductRegisterNo" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                            <td><span class="red">*</span>产品退货或换货:</td>
                                                            <td>
                                                                <ext:ComboBox ID="RETURNTYPE" runat="server" Editable="false" Enabled="False"
                                                                    TypeAhead="true" BlankText="请选择产品换货或退款" AllowBlank="false">
                                                                    <Items>
                                                                        <ext:ListItem Text="换货" Value="1" />
                                                                        <ext:ListItem Text="退款" Value="2" />
                                                                        <ext:ListItem Text="仅上报投诉，只退不换" Value="5" />
                                                                    </Items>
                                                                </ext:ComboBox>
                                                                <ext:Hidden ID="hiddenRETURNTYPE" runat="server"></ext:Hidden>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td></td>
                                                            <td></td>
                                                            <td>波科确认产品换货或退款:</td>
                                                            <td>
                                                                <ext:TextField ID="ConfirmReturnOrRefund" runat="server" Disabled="true" Width="250"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>
                                            <ext:Panel ID="Panel16" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="退货单附件" Header="true" Collapsible="true">
                                                <Body>
                                                    <ext:FitLayout ID="FitLayout2" runat="server">
                                                        <ext:GridPanel ID="gpAttachment_Return" runat="server" Title="附件信息" StoreID="AttachmentRtnStore" AutoScroll="true"
                                                            StripeRows="true" Collapsible="false" Border="true" Header="false" Icon="Lorry"
                                                            AutoExpandColumn="Name" Height="200" AutoWidth="true">
                                                            <TopBar>
                                                                <ext:Toolbar ID="Toolbar1" runat="server">
                                                                    <Items>
                                                                        <ext:ToolbarFill ID="ToolbarFill1" runat="server" />
                                                                        <ext:Button ID="btnUploadAttachment_Return" runat="server" Text="上传附件" Icon="FolderUp">
                                                                            <Listeners>
                                                                                <Click Handler="#{hiddenAttachmentUpload}.setValue('DealerComplainCRMRtn');#{AttachmentWindow}.show();#{FileUploadField1}.setValue('');" />
                                                                            </Listeners>
                                                                        </ext:Button>
                                                                    </Items>
                                                                </ext:Toolbar>
                                                            </TopBar>
                                                            <ColumnModel ID="ColumnModel3" runat="server">
                                                                <Columns>
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
                                                                            <ext:GridCommand Icon="Cross" CommandName="Delete" ToolTip-Text="删除" />
                                                                        </Commands>
                                                                    </ext:CommandColumn>
                                                                </Columns>
                                                            </ColumnModel>
                                                            <SelectionModel>
                                                                <ext:RowSelectionModel ID="RowSelectionModel3" SingleSelect="true" runat="server"
                                                                    MoveEditorOnEnter="true">
                                                                </ext:RowSelectionModel>
                                                            </SelectionModel>
                                                            <BottomBar>
                                                                <ext:PagingToolbar ID="PagingToolBar2" runat="server" PageSize="50" StoreID="AttachmentRtnStore"
                                                                    DisplayInfo="true" />
                                                            </BottomBar>
                                                            <SaveMask ShowMask="false" />
                                                            <LoadMask ShowMask="true" />
                                                            <Listeners>
                                                                <Command Handler="if (command == 'Delete'){
                                                                                Ext.Msg.confirm('警告', '是否要删除该附件文件?',
                                                                                    function(e) {
                                                                                        if (e == 'yes') {
                                                                                            Coolite.AjaxMethods.DeleteAttachment('DealerComplainCRMRtn',record.data.Id,record.data.Url,{
                                                                                                success: function() {
                                                                                                    Ext.Msg.alert('Message', '删除附件成功！');
                                                                                                    #{gpAttachment_Return}.reload();
                                                                                                },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                        }
                                                                                    });
                                                                            }
                                                                            else if (command == 'DownLoad')
                                                                            {
                                                                                var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=DealerComplainCRMRtn';
                                                                                downloadfile(url);
                                                                            }
                                                                            
                                                                            " />
                                                            </Listeners>
                                                        </ext:GridPanel>
                                                    </ext:FitLayout>
                                                </Body>
                                            </ext:Panel>
                                        </Body>
                                    </ext:Panel>
                                    <ext:Panel ID="mainPanel" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px 5px;" BodyBorder="true"
                                        Title="投诉申请单" Header="true" Collapsible="true">
                                        <Body>
                                            <ext:Panel ID="Panel12" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="产品信息" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%;">
                                                        <tr style="">
                                                            <td style="width: 100px;"><span class="red">*</span>经销商:</td>
                                                            <td>
                                                                <ext:ComboBox ID="cbDealer" runat="server" Width="250" Editable="true" TypeAhead="false" Mode="Local"
                                                                    StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName" ListWidth="300" Resizable="true" AllowBlank="false"
                                                                    BlankText="请选择经销商" EmptyText="请选择经销商">
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                        <Select Handler="ChangeDealer();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </td>
                                                            <td style="width: 100px;"><span class="red">*</span>产品批号:</td>
                                                            <td>
                                                                <ext:TextField ID="txtLot" runat="server" Disabled="true" BlankText="请选择产品批号"></ext:TextField>
                                                                <ext:Hidden ID="hiddenLot" runat="server"></ext:Hidden>
                                                                <ext:ImageButton ID="imbtnSearchProduct" runat="server" ImageUrl="~/resources/images/Search.gif" OnClientClick="openCfnSearchDlg('1',#{hiddenInitDealerId}.getValue(),null);"></ext:ImageButton>
                                                            </td>
                                                            <td style="width: 120px;">投诉单状态:</td>
                                                            <td>
                                                                <ext:Hidden ID="hiddenCompalinStatus" runat="server"></ext:Hidden>
                                                                <ext:TextField ID="txtComplainStatus" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><span class="red">*</span>产品型号(UPN):</td>
                                                            <td>
                                                                <ext:TextField ID="txtUPN" runat="server" Disabled="true" BlankText="请选择产品型号"></ext:TextField>
                                                                <ext:Hidden ID="hiddenUPN" runat="server"></ext:Hidden>
                                                                <ext:Hidden ID="hiddenConvertFactor" runat="server"></ext:Hidden>
                                                                <ext:Hidden ID="hiddenCFN_Property4" runat="server"></ext:Hidden>
                                                            </td>
                                                            <td><span class="red">*</span>产品描述:</td>
                                                            <td>
                                                                <ext:TextField ID="DESCRIPTION" runat="server" Disabled="true"></ext:TextField>
                                                                <ext:Hidden ID="Model" runat="server"></ext:Hidden>
                                                                <ext:Hidden ID="Registration" runat="server"></ext:Hidden>
                                                                <ext:Hidden ID="hiddenDescription" runat="server"></ext:Hidden>
                                                            </td>
                                                            <td>单据号:
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="txtComplainNo" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>投诉号码(PI):</td>
                                                            <td>
                                                                <ext:TextField ID="PI" runat="server" Disabled="true" BlankText="请输入投诉号码(PI)"></ext:TextField>
                                                            </td>
                                                            <td>退换货码（IAN）:</td>
                                                            <td>
                                                                <ext:TextField ID="IAN" runat="server" Disabled="true" BlankText="请输入退换货码（IAN）"></ext:TextField>
                                                            </td>
                                                            <td>收到返回产品登记号:<br/>仅在产品可退回时提供</td>
                                                            <td>
                                                                <ext:TextField ID="RN" runat="server" Disabled="true" BlankText="请输入收到返回产品登记号"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="vertical-align: top;">产品有效期:</td>
                                                            <td style="vertical-align: top;">
                                                                <ext:TextField ID="txtProductExpiredDate" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                            <td>投诉单审批备注:</td>
                                                            <td>
                                                                <ext:TextArea ID="ComplainApprovelRemark" runat="server" Width="250" BlankText="请输入投诉单审批备注"></ext:TextArea>
                                                            </td>
                                                           
                                                            <td>产品二维码:</td>
                                                            <td>
                                                                <ext:TextField ID="txtQRCodeView" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                            <%--<td colspan="2" style="vertical-align: top;">（仅在产品可退回时提供）
                                                            </td>--%>
                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>

                                            <ext:Panel ID="Panel1" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="1、报告信息" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%;">

                                                        <tr>
                                                            <td colspan="4" style="padding-top: 10px;"><span class="panelTital">销售情况</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td><span class="red">*</span>是否是平台:</td>
                                                            <td>
                                                                <ext:RadioGroup ID="ISPLATFORM" runat="server" AllowBlank="false" BlankText="请选择是否是平台"
                                                                    Enabled="false" noedit="TRUE" Width="100">
                                                                    <Items>
                                                                        <ext:Radio ID="ISPLATFORM_1" runat="server" BoxLabel="是" Enabled="false" cvalue="1"
                                                                            noedit="TRUE" />
                                                                        <ext:Radio ID="ISPLATFORM_2" runat="server" BoxLabel="否" Enabled="false" cvalue="2"
                                                                            noedit="TRUE" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                            <td><span class="red">*</span>一级经销商账号:</td>
                                                            <td>
                                                                <ext:TextField ID="BSCSOLDTOACCOUNT" runat="server" AllowBlank="false" BlankText="请填写一级经销商账号" Disabled="true"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><span class="red">*</span>一级经销商名称:</td>
                                                            <td>
                                                                <ext:TextField ID="BSCSOLDTONAME" runat="server" AllowBlank="false" BlankText="请填写一级经销商名称" Disabled="true" Width="250"></ext:TextField>
                                                            </td>
                                                            <td><span class="red">*</span>一级经销商所在城市:</td>
                                                            <td>
                                                                <ext:TextField ID="BSCSOLDTOCITY" runat="server" AllowBlank="false" BlankText="请填写一级经销商所在城市" Disabled="true"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>二级经销商名称:</td>
                                                            <td>
                                                                <ext:TextField ID="SUBSOLDTONAME" runat="server" Width="250" Disabled="true"></ext:TextField>
                                                            </td>
                                                            <td>二级经销商所在城市:</td>
                                                            <td>
                                                                <ext:TextField ID="SUBSOLDTOCITY" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><span class="red">*</span>医院名称:</td>
                                                            <td>
                                                                <ext:TextField ID="DISTRIBUTORCUSTOMER" runat="server" Width="250" Disabled="true"
                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请选择医院" MsgTarget="Side">
                                                                </ext:TextField>
                                                                <ext:ImageButton ID="imbtnSearchHospital" runat="server" ImageUrl="~/resources/images/Search.gif" OnClientClick="openHospitalSearchDlg('1',#{hiddenInitDealerId}.getValue(),null);"></ext:ImageButton>
                                                                <ext:Hidden ID="hiddenDistributorCustomer" runat="server"></ext:Hidden>
                                                                <ext:Hidden ID="hiddenDistributorCustomerName" runat="server"></ext:Hidden>
                                                                <ext:Hidden ID="hiddenDistributorCity" runat="server"></ext:Hidden>
                                                            </td>
                                                            <td><span class="red">*</span>医院所在城市:</td>
                                                            <td>
                                                                <ext:TextField ID="DISTRIBUTORCITY" runat="server"
                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写医院所在城市" MsgTarget="Side" Disabled="true">
                                                                </ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 1px; width: 120px;"></td>
                                                            <td style="height: 1px;"></td>
                                                            <td style="height: 1px; width: 120px;"></td>
                                                            <td style="height: 1px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2"><span class="panelTital">BSC销售联系人</span></td>
                                                            <td colspan="2"><span class="panelTital">事件信息</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td><span class="red">*</span>姓名:</td>
                                                            <td>
                                                                <ext:ComboBox ID="CompletedName" runat="server" Width="200" Editable="true" TypeAhead="false" Mode="Local"
                                                                    StoreID="BscUserStore" ValueField="UserAccount" DisplayField="UserName" ListWidth="300" Resizable="true" AllowBlank="false"
                                                                    BlankText="请选择BSC销售" EmptyText="BSC销售,请先选择产品及医院">
                                                                    <Listeners>
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                        <Select Handler="#{hiddenBscUserId}.setValue(#{CompletedName}.getValue());" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </td>
                                                            <td><span class="red">*</span>事件发生日期:</td>
                                                            <td>
                                                                <ext:DateField ID="DateEvent" runat="server" Width="151" AllowBlank="false" BlankText="请填写事件发生日期"></ext:DateField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><span class="red">*</span>职位:</td>
                                                            <td>
                                                                <ext:TextField ID="CompletedTitle" runat="server" AllowBlank="false" BlankText="请填写职位"></ext:TextField>
                                                            </td>
                                                            <td><span class="red">*</span>表单提交日期:</td>
                                                            <td>
                                                                <ext:TextField ID="DateBSC" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2"><span class="panelTital">如果非波科人员上报</span></td>
                                                            <td>波科人员接报日期:</td>
                                                            <td>
                                                                <ext:DateField ID="DateReceipt" runat="server" Width="151" AllowBlank="false" BlankText="请选择波科人员接报日期" Disabled="true"></ext:DateField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><span class="red">*</span>姓名:</td>
                                                            <td>
                                                                <ext:TextField ID="NonBostonName" runat="server" AllowBlank="false" BlankText="请填写姓名"></ext:TextField>
                                                            </td>
                                                            <td>代理商接报日期:</td>
                                                            <td>
                                                                <ext:DateField ID="DateDealer" runat="server" Width="151" AllowBlank="false" BlankText="请选择代理商接报日期"></ext:DateField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><span class="red">*</span>联系电话:</td>
                                                            <td>
                                                                <ext:TextField ID="CompletedPhone" runat="server" AllowBlank="false" BlankText="请填写联系电话"></ext:TextField>
                                                            </td>
                                                            <td><span class="red">*</span>事件发生的国家:</td>
                                                            <td>
                                                                <ext:TextField ID="EventCountry" runat="server" Disabled="true" AllowBlank="false" BlankText="请填写事件发生的国家"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><span class="red">*</span>联系邮箱:</td>
                                                            <td>
                                                                <ext:TextField ID="CompletedEmail" runat="server" AllowBlank="false" BlankText="请填写联系邮箱话"></ext:TextField>
                                                            </td>
                                                            <td>其他国家:</td>
                                                            <td>
                                                                <ext:TextField ID="OtherCountry" runat="server"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>公司:</td>
                                                            <td>
                                                                <ext:TextField ID="NonBostonCompany" runat="server"></ext:TextField>
                                                            </td>
                                                            <td><span class="red">*</span>是否需要技术支持:</td>
                                                            <td>
                                                                <ext:RadioGroup ID="NeedSupport" runat="server" AllowBlank="false"
                                                                    BlankText="请选择【1.报告信息】中的【是否需要技术支持】">
                                                                    <Items>
                                                                        <ext:Radio ID="NeedSupport_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                        <ext:Radio ID="NeedSupport_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr runat="server" style="display: none;">
                                                            <td>地址:</td>
                                                            <td>
                                                                <ext:TextField ID="NonBostonAddress" runat="server"></ext:TextField>
                                                            </td>
                                                            <td><span class="red">*</span>是否有跟台:</td>
                                                            <td>
                                                                <ext:RadioGroup ID="HasFollowOperation" runat="server" AllowBlank="False" BlankText="请选择是否有跟台">
                                                                    <Items>
                                                                        <ext:Radio ID="HasFollowOperation_1" runat="server" BoxLabel="是" cvalue="1">
                                                                            <Listeners>
                                                                                <Check Handler="hasFollowOperationCheck();" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="HasFollowOperation_2" runat="server" BoxLabel="否" cvalue="2">
                                                                            <Listeners>
                                                                                <Check Handler="hasFollowOperationCheck();" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="HasFollowOperation_3" runat="server" BoxLabel="不清楚" cvalue="3">
                                                                            <Listeners>
                                                                                <Check Handler="hasFollowOperationCheck();" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>城市:</td>
                                                            <td>
                                                                <ext:TextField ID="NonBostonCity" runat="server"></ext:TextField>
                                                            </td>
                                                            <td id="tdlblFollowOperationDate" runat="server"><span class="red">*</span>跟台日期:</td>
                                                            <td id="tdFollowOperationDate" runat="server">
                                                                <ext:DateField ID="FollowOperationDate" runat="server" Width="151" AllowBlank="False" BlankText="请选择跟台日期"></ext:DateField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>国家:</td>
                                                            <td>
                                                                <ext:TextField ID="NonBostonCountry" runat="server"></ext:TextField>
                                                            </td>
                                                            <td id="tdlblFollowOperationStaff" runat="server"><span class="red">*</span>跟台人员:</td>
                                                            <td id="tdFollowOperationStaff" runat="server">
                                                                <ext:RadioGroup ID="FollowOperationStaff" runat="server" AllowBlank="False">
                                                                    <Items>
                                                                        <ext:Radio ID="FollowOperationStaff_1" runat="server" BoxLabel="波科人员" cvalue="1" />
                                                                        <ext:Radio ID="FollowOperationStaff_2" runat="server" BoxLabel="代理商" cvalue="2" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="4">备注：该表格要求的所有信息都要求填写。对于无法获取的信息，请提供书面说明</td>
                                                        </tr>

                                                    </table>
                                                </Body>
                                            </ext:Panel>

                                            <table style="width: 100%;">
                                                <tr>
                                                    <td style="width: 50%; vertical-align: top;">
                                                        <ext:Panel ID="Panel3" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                            Title="2、病人信息" Header="true" Collapsible="true">
                                                            <Body>
                                                                <table style="width: 100%;">
                                                                    <tr>
                                                                        <td style="width: 150px;"><span class="red">*</span>患者姓名或者字母:</td>
                                                                        <td>
                                                                            <ext:TextField ID="PatientName" runat="server" AllowBlank="false" BlankText="请填写患者姓名或者字母"></ext:TextField>
                                                                        </td>
                                                                        <td style="width: 50px;"></td>
                                                                        <td style="width: 100px;"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><span class="red">*</span>患者编号:</td>
                                                                        <td>
                                                                            <ext:TextField ID="PatientNum" runat="server" AllowBlank="false" BlankText="请填写患者编号"></ext:TextField>
                                                                        </td>
                                                                        <td></td>
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><span class="red">*</span>性别:</td>
                                                                        <td>
                                                                            <ext:TextField ID="PatientSex" runat="server"></ext:TextField>
                                                                        </td>
                                                                        <td>或者</td>
                                                                        <td>
                                                                            <ext:Checkbox ID="PatientSexInvalid" runat="server" BoxLabel="不能获取"></ext:Checkbox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><span class="red">*</span>患者出身年月日:</td>
                                                                        <td>
                                                                            <ext:DateField ID="PatientBirth" runat="server" Width="147" />
                                                                        </td>
                                                                        <td>或者</td>
                                                                        <td>
                                                                            <ext:Checkbox ID="PatientBirthInvalid" runat="server" BoxLabel="不能获取"></ext:Checkbox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><span class="red">*</span>患者体重:</td>
                                                                        <td>
                                                                            <ext:TextField ID="PatientWeight" runat="server"></ext:TextField>
                                                                            （事件当时，单位KG）</td>
                                                                        <td>或者</td>
                                                                        <td>
                                                                            <ext:Checkbox ID="PatientWeightInvalid" runat="server" BoxLabel="不能获取"></ext:Checkbox>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </Body>
                                                        </ext:Panel>
                                                    </td>
                                                    <td style="width: 50%; vertical-align: top;">
                                                        <ext:Panel ID="Panel4" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                            Title="3、医生信息及信息来源" Header="true" Collapsible="true">
                                                            <Body>
                                                                <table style="width: 100%;">
                                                                    <tr>
                                                                        <td style="width: 150px;"><span class="red">*</span>医生姓名/信息来源者姓名:</td>
                                                                        <td>
                                                                            <ext:TextField ID="PhysicianName" runat="server"
                                                                                BlankText="请填写医生姓名/信息来源者姓名" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row">
                                                                            </ext:TextField>
                                                                        </td>
                                                                        <td style="width: 100px;"><span class="red">*</span>事件发生医院:</td>
                                                                        <td>
                                                                            <ext:TextField ID="PhysicianHospital" runat="server" Disabled="true"
                                                                                BlankText="请填写医院" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row">
                                                                            </ext:TextField>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><span class="red">*</span>职位:</td>
                                                                        <td colspan="3">
                                                                            <ext:TextField ID="PhysicianTitle" runat="server"
                                                                                BlankText="请填写职位" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row">
                                                                            </ext:TextField>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><span class="red">*</span>地址:</td>
                                                                        <td colspan="3">
                                                                            <ext:TextField ID="PhysicianAddress" runat="server"
                                                                                BlankText="请填写地址" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row">
                                                                            </ext:TextField>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><span class="red">*</span>城市:</td>
                                                                        <td>
                                                                            <ext:TextField ID="PhysicianCity" runat="server"
                                                                                BlankText="请填写城市" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row">
                                                                            </ext:TextField>
                                                                        </td>
                                                                        <td><span class="red">*</span>邮编:</td>
                                                                        <td>
                                                                            <ext:TextField ID="PhysicianZipcode" runat="server"
                                                                                BlankText="请填写邮编" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row">
                                                                            </ext:TextField>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><span class="red">*</span>国家:</td>
                                                                        <td colspan="3">
                                                                            <ext:TextField ID="PhysicianCountry" runat="server"
                                                                                BlankText="请填写国家" MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row">
                                                                            </ext:TextField>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </Body>
                                                        </ext:Panel>
                                                    </td>
                                                </tr>
                                            </table>

                                            <ext:Panel ID="Panel2" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="4、患者信息" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="height: 1px; width: 150px;"></td>
                                                            <td style="height: 1px;"></td>
                                                            <td style="height: 1px; width: 150px;"></td>
                                                            <td style="height: 1px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td><span class="red">*</span>患者状态:</td>
                                                            <td colspan="3">
                                                                <ext:CheckboxGroup ID="PatientStatus" runat="server"
                                                                    BlankText="请选择【4.患者状态】中的【患者状态】" ColumnsNumber="4">
                                                                    <Items>
                                                                        <ext:Checkbox ID="PatientStatus_1" runat="server" BoxLabel="患者无任何不良反应" cvalue="1" />
                                                                        <ext:Checkbox ID="PatientStatus_2" runat="server" BoxLabel="患者出院在家，正常随访" cvalue="2" />
                                                                        <ext:Checkbox ID="PatientStatus_7" runat="server" BoxLabel="起搏器依赖者" cvalue="7" />
                                                                        <ext:Checkbox ID="PatientStatus_3" runat="server" BoxLabel="患者有不良反应(请在第九项解释)" cvalue="3" />
                                                                        <ext:Checkbox ID="PatientStatus_4" runat="server" BoxLabel="患者入院" cvalue="4" />
                                                                        <ext:Checkbox ID="PatientStatus_5" runat="server" BoxLabel="医学原因（病人自身情况有关/与产品无关）" cvalue="5" />
                                                                        <ext:Checkbox ID="PatientStatus_6" runat="server" BoxLabel="死亡" cvalue="6">
                                                                            <Listeners>
                                                                                <Check Handler="isDeathCheck();" />
                                                                            </Listeners>
                                                                        </ext:Checkbox>
                                                                    </Items>
                                                                </ext:CheckboxGroup>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table style="width: 100%;" id="deathTable1" runat="server">
                                                        <tr>
                                                            <td style="height: 1px; width: 150px;">死亡日期:</td>
                                                            <td style="height: 1px; width: 35%;">
                                                                <ext:DateField ID="DeathDate" runat="server" Width="151"></ext:DateField>
                                                            </td>
                                                            <td style="height: 1px; width: 150px;">死亡时间:</td>
                                                            <td style="height: 1px; width: 35%;">
                                                                <ext:TextField ID="DeathTime" runat="server"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>原因:</td>
                                                            <td colspan="3">
                                                                <ext:TextField ID="DeathCause" runat="server" Width="300"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>上报人是否在场</td>
                                                            <td colspan="3">
                                                                <ext:RadioGroup ID="Witnessed" runat="server" Width="200">
                                                                    <Items>
                                                                        <ext:Radio ID="Witnessed_1" runat="server" BoxLabel="上报人在场" cvalue="1" />
                                                                        <ext:Radio ID="Witnessed_2" runat="server" BoxLabel="上报人未在场" cvalue="2" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table style="width: 100%;" id="deathTable2" runat="server">
                                                        <tr>
                                                            <td style="width: 200px;">是否怀疑该死亡与波科产品故障有关</td>
                                                            <td>
                                                                <ext:RadioGroup ID="RelatedBSC" runat="server" Width="300">
                                                                    <Items>
                                                                        <ext:Radio ID="RelatedBSC_1" runat="server" BoxLabel="不知道" cvalue="1" />
                                                                        <ext:Radio ID="RelatedBSC_2" runat="server" BoxLabel="是" cvalue="2" />
                                                                        <ext:Radio ID="RelatedBSC_3" runat="server" BoxLabel="否" cvalue="3" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>

                                            <table style="width: 100%;">
                                                <tr>
                                                    <td style="width: 50%;">
                                                        <ext:Panel ID="Panel5" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                            Title="5、上报产品体验报告的原因" Header="true" Collapsible="true">
                                                            <Body>
                                                                <table style="width: 100%;">
                                                                    <tr>
                                                                        <td style="width: 150px;"><span class="red">*</span>是否与波科产品有关:</td>
                                                                        <td>
                                                                            <ext:RadioGroup ID="IsForBSCProduct" runat="server"
                                                                                AllowBlank="true" BlankText="请选择【5.上报产品体验报告的原因】中的【是否与波科产品有关】" Width="140">
                                                                                <Items>
                                                                                    <ext:Radio ID="ISFORBSCPRODUCT_01" runat="server" BoxLabel="是" cvalue="1" />
                                                                                    <ext:Radio ID="ISFORBSCPRODUCT_02" runat="server" BoxLabel="否" cvalue="2" />
                                                                                </Items>
                                                                            </ext:RadioGroup>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><span class="red">*</span>上报原因:</td>
                                                                        <td>
                                                                            <ext:CheckboxGroup ID="ReasonsForProduct" runat="server"
                                                                                BlankText="请选择【5.上报产品体验报告的原因】中的【上报原因】" ColumnsNumber="2">
                                                                                <Items>
                                                                                    <ext:Checkbox ID="ReasonsForProduct_1" runat="server" BoxLabel="发生在植入前测试中" cvalue="1" />
                                                                                    <ext:Checkbox ID="ReasonsForProduct_2" runat="server" BoxLabel="发生在植入中创口缝合前" cvalue="2" />
                                                                                    <ext:Checkbox ID="ReasonsForProduct_3" runat="server" BoxLabel="发生在囊袋闭合后" cvalue="3" />
                                                                                    <ext:Checkbox ID="ReasonsForProduct_4" runat="server" BoxLabel="发生在取出时/取出后" cvalue="4" />
                                                                                    <ext:Checkbox ID="ReasonsForProduct_5" runat="server" BoxLabel="发生在随访中" cvalue="5" />
                                                                                    <ext:Checkbox ID="ReasonsForProduct_6" runat="server" BoxLabel="发布声明/召回（只是为了预防而建议取出产品）" cvalue="6" Height="30" />
                                                                                    <ext:Checkbox ID="ReasonsForProduct_7" runat="server" BoxLabel="其他（请在第九部分解释）" cvalue="7" />
                                                                                </Items>
                                                                            </ext:CheckboxGroup>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </Body>
                                                        </ext:Panel>
                                                    </td>
                                                    <td style="width: 50%;">
                                                        <ext:Panel ID="Panel6" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                            Title="6、返回信息" Header="true" Collapsible="true">
                                                            <Body>
                                                                <table style="width: 100%;">
                                                                    <tr>
                                                                        <td style="width: 150px;"><span class="red">*</span>产品是否可返回:</td>
                                                                        <td>
                                                                            <ext:RadioGroup ID="Returned" runat="server"
                                                                                BlankText="请选择【6.返回信息】中的【产品是否可返回】">
                                                                                <Items>
                                                                                    <ext:Radio ID="Returned_1" runat="server" BoxLabel="是" cvalue="1">
                                                                                        <Listeners>
                                                                                            <Check Handler="isReturnedCheck();" />
                                                                                        </Listeners>
                                                                                    </ext:Radio>
                                                                                    <ext:Radio ID="Returned_2" runat="server" BoxLabel="无法返回" cvalue="2">
                                                                                        <Listeners>
                                                                                            <Check Handler="isReturnedCheck();" />
                                                                                        </Listeners>
                                                                                    </ext:Radio>
                                                                                </Items>
                                                                            </ext:RadioGroup>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="tdlblReturnedDay" runat="server">如果是，需要多少天返回:</td>
                                                                        <td id="tdReturnedDay" runat="server">
                                                                            <ext:TextField ID="ReturnedDay" runat="server"></ext:TextField>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><span class="red">*</span>是否要求提供分析报告:</td>
                                                                        <td>
                                                                            <ext:RadioGroup ID="AnalysisReport" runat="server"
                                                                                BlankText="请选择【6.返回信息】中的【是否要求提供分析报告】">
                                                                                <Items>
                                                                                    <ext:Radio ID="AnalysisReport_1" runat="server" BoxLabel="是" cvalue="1">
                                                                                        <Listeners>
                                                                                            <Check Handler="isAnalysisReportCheck();" />
                                                                                        </Listeners>
                                                                                    </ext:Radio>
                                                                                    <ext:Radio ID="AnalysisReport_2" runat="server" BoxLabel="否" cvalue="2">
                                                                                        <Listeners>
                                                                                            <Check Handler="isAnalysisReportCheck();" />
                                                                                        </Listeners>
                                                                                    </ext:Radio>
                                                                                </Items>
                                                                            </ext:RadioGroup>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="tdlblRequestPhysicianName" runat="server">要求提供报告的医生姓名:</td>
                                                                        <td id="tdRequestPhysicianName" runat="server">
                                                                            <ext:TextField ID="RequestPhysicianName" runat="server" BlankText="请填写要求提供报告的医生姓名"></ext:TextField>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><span class="red">*</span>是否有保修单:</td>
                                                                        <td>
                                                                            <ext:RadioGroup ID="Warranty" runat="server" FieldLabel="是否有保修单" BlankText="请选择【6.返回信息】中的【是否有保修单】">
                                                                                <Items>
                                                                                    <ext:Radio ID="Warranty_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                                    <ext:Radio ID="Warranty_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                                </Items>
                                                                            </ext:RadioGroup>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </Body>
                                                        </ext:Panel>
                                                    </td>
                                                </tr>
                                            </table>

                                            <ext:Panel ID="Panel7" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="7. 临床观察<span class='red'>*（脉冲发生器/程控仪、电极/传送系统、临床至少选一项）</span>" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%; border: solid 1px #99bbe8; padding: 5px;">
                                                        <tr>
                                                            <td><span class="panelTital">脉冲发生器/控制仪</span></td>
                                                            <td style="width: 700px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_1" runat="server" BoxLabel="Fault codes/error messages 故障码/错误信息（将故障码/错误信息写在第九部分）"
                                                                    cvalue="1" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_2" runat="server" BoxLabel="Beeping tones 蜂鸣声"
                                                                    cvalue="2" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_3" runat="server" BoxLabel="Telemetry Problem 遥测技术问题"
                                                                    cvalue="3" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_4" runat="server" BoxLabel="Unable to establish telemetry 不能建立遥测技术"
                                                                    cvalue="4" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_5" runat="server" BoxLabel="Normal ERI, no allegation ERI ERI正常，未宣称"
                                                                    cvalue="5" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_6" runat="server" BoxLabel="Allegation of premature battery depletion 宣称电池提前耗竭"
                                                                    cvalue="6" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_7" runat="server" BoxLabel="Undersensing 感知不良"
                                                                    cvalue="7" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_8" runat="server" BoxLabel="Oversensing 过度感知"
                                                                    cvalue="8" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Pulse_9" runat="server" BoxLabel="Pacing inhibition(Number of beats inhibited) 起搏抑制（抑制起搏的跳数）"
                                                                    cvalue="9">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Pulse_9');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="Pulsebeats" runat="server" Width="200" Hidden="true" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_10" runat="server" BoxLabel="Unable to interrogate无法询问"
                                                                    cvalue="10" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_11" runat="server" BoxLabel="Safety Mode 安全模式"
                                                                    cvalue="11" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_12" runat="server" BoxLabel="High defibrillation thresholds 高除颤阈值"
                                                                    cvalue="12" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_13" runat="server" BoxLabel="Brady pacing not delivered 未发起心动过缓起搏"
                                                                    cvalue="13" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Pulse_14" runat="server" BoxLabel="Tachy pacing not delivered 未发起心动过速起搏"
                                                                    cvalue="14" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Pulse_15" runat="server" BoxLabel="Other (Please explain in section 9) 其他（请在第九部分解释）"
                                                                    cvalue="15" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <br />
                                                    <br />
                                                    <table style="width: 100%; border: solid 1px #99bbe8; padding: 5px;">
                                                        <tr>
                                                            <td><span class="panelTital">电极/传送系统</span><br />
                                                                请指明电极位置，例如右心房，右心室，左心室等</td>
                                                            <td style="width: 700px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Leads_1" runat="server" BoxLabel="Lead conductor fracture 电极导体断裂"
                                                                    cvalue="1">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Leads_1');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="LeadsFracture" runat="server" Width="200" Hidden="true" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Leads_2" runat="server" BoxLabel="Insulation issue 绝缘层问题" cvalue="2">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Leads_2');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="LeadsIssue" runat="server" Width="200" Hidden="true" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Leads_3" runat="server" BoxLabel="Lead dislodgement 电极脱位" cvalue="3">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Leads_3');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="LeadsDislodgement" runat="server" Width="200" Hidden="true" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Leads_4" runat="server" BoxLabel="Abnormal impedance measurements 阻抗测量值异常(Ohms)"
                                                                    cvalue="4">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Leads_4');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="LeadsMeasurements" runat="server" Width="200" Hidden="true" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Leads_5" runat="server" BoxLabel="Inappropriate shock 不恰当电击" cvalue="5" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Leads_6" runat="server" BoxLabel="High pacing thresholds 起搏阈值过高"
                                                                    cvalue="6">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Leads_6');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="LeadsThresholds" runat="server" Width="200" Hidden="true" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Leads_7" runat="server" BoxLabel="Pacing inhibition seconds of asystole 起搏抑制心搏停止数秒"
                                                                    cvalue="7">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Leads_7');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="LeadsBeats" runat="server" Width="200" Hidden="true" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Leads_8" runat="server" BoxLabel="Noise 噪声" cvalue="8">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Leads_8');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="LeadsNoise" runat="server" Width="200" Hidden="true" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Leads_9" runat="server" BoxLabel="Loss of capture 失夺获" cvalue="9">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Leads_9');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="LeadsLoss" runat="server" Width="200" Hidden="true" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Leads_10" runat="server" BoxLabel="Non-conversion of ventricular tachycardia or ventricular fibrillation 未转复为室速或室颤" cvalue="10" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Leads_11" runat="server" BoxLabel="Other (Please explain in section 9) 其他（请在第九部分解释）"
                                                                    cvalue="11" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <br />
                                                    <br />
                                                    <table style="width: 100%; border: solid 1px #99bbe8; padding: 5px;">
                                                        <tr>
                                                            <td><span class="panelTital">临床</span><br />
                                                                请指明电极位置，例如右心房，右心室，左心室等</td>
                                                            <td style="width: 700px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Clinical_1" runat="server" BoxLabel="Perforation 穿孔" cvalue="1">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Clinical_1');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="ClinicalPerforation" runat="server" Width="200" Hidden="true" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Clinical_2" runat="server" BoxLabel="Dissection 夹层" cvalue="2" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Clinical_3" runat="server" BoxLabel="Abnormal impedance measurements 阻抗测量值异常（Ohms）"
                                                                    cvalue="3">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Clinical_3');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="ClinicalBeats" runat="server" Width="200" Hidden="true" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Clinical_4" runat="server" BoxLabel="Diaphragmatic stimulation 隔肌刺激"
                                                                    cvalue="4" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Clinical_5" runat="server" BoxLabel="Resolved with reprogramming 再程控"
                                                                    cvalue="5" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Clinical_6" runat="server" BoxLabel="Muscle/pocket stimulation 肌肉/囊袋刺激"
                                                                    cvalue="6" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Clinical_7" runat="server" BoxLabel="Infection 感染"
                                                                    cvalue="7" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Clinical_8" runat="server" BoxLabel="Syncope, loss of consciousness 晕厥，意识丧失（请在第九部分解释）"
                                                                    cvalue="8" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Clinical_9" runat="server" BoxLabel="Migration 设备移位"
                                                                    cvalue="9" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Clinical_10" runat="server" BoxLabel="Erosion 糜烂"
                                                                    cvalue="10" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Clinical_11" runat="server" BoxLabel="Rhythm acceleration 心律加速"
                                                                    cvalue="11" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <ext:Checkbox ID="Clinical_12" runat="server" BoxLabel="Other (Please explain in section 9) 其他（请在第九部分解释）"
                                                                    cvalue="12" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>

                                            <ext:Panel ID="Panel8" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="8. 设备/电极状态<span class='red'>*（脉冲、电极、配件请至少填一项）</span>" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="width: 150px;"></td>
                                                            <td style="width: 200px;"><span class='red'>*</span>Model</td>
                                                            <td style="width: 200px;"><span class='red'>*</span>Serial #</td>
                                                            <td style="width: 200px;"><span class='red'>*</span>植入时间</td>
                                                            <td style="width: 300px;"></td>
                                                            <td style="width: 40%;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>脉冲发生器</td>
                                                            <td>
                                                                <ext:TextField ID="PulseModel" runat="server" Width="100" />
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="PulseSerial" runat="server" Width="100" />
                                                            </td>
                                                            <td>
                                                                <ext:DateField ID="PulseImplant" runat="server" Width="100" />
                                                            </td>
                                                            <td></td>
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td>电极1</td>
                                                            <td>
                                                                <ext:TextField ID="Leads1Model" runat="server" Width="100" />
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="Leads1Serial" runat="server" Width="100" />
                                                            </td>
                                                            <td>
                                                                <ext:DateField ID="Leads1Implant" runat="server" Width="100" />
                                                            </td>
                                                            <td style="text-align: center;">电极位置</td>
                                                            <td>
                                                                <ext:RadioGroup ID="Leads1Position" runat="server" ColumnsNumber="4"
                                                                    Width="350">
                                                                    <Items>
                                                                        <ext:Radio ID="Leads1Position_1" runat="server" BoxLabel="右心房" cvalue="1" />
                                                                        <ext:Radio ID="Leads1Position_2" runat="server" BoxLabel="右心室" cvalue="2" />
                                                                        <ext:Radio ID="Leads1Position_3" runat="server" BoxLabel="左心室" cvalue="3" />
                                                                        <ext:Radio ID="Leads1Position_4" runat="server" BoxLabel="不知道" cvalue="4" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>电极2</td>
                                                            <td>
                                                                <ext:TextField ID="Leads2Model" runat="server" Width="100" />
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="Leads2Serial" runat="server" Width="100" />
                                                            </td>
                                                            <td>
                                                                <ext:DateField ID="Leads2Implant" runat="server" Width="100" />
                                                            </td>
                                                            <td style="text-align: center;">电极位置</td>
                                                            <td>
                                                                <ext:RadioGroup ID="Leads2Position" runat="server" ColumnsNumber="4"
                                                                    Width="350">
                                                                    <Items>
                                                                        <ext:Radio ID="Leads2Position_1" runat="server" BoxLabel="右心房" cvalue="1" />
                                                                        <ext:Radio ID="Leads2Position_2" runat="server" BoxLabel="右心室" cvalue="2" />
                                                                        <ext:Radio ID="Leads2Position_3" runat="server" BoxLabel="左心室" cvalue="3" />
                                                                        <ext:Radio ID="Leads2Position_4" runat="server" BoxLabel="不知道" cvalue="4" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>电极3</td>
                                                            <td>
                                                                <ext:TextField ID="Leads3Model" runat="server" Width="100" />
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="Leads3Serial" runat="server" Width="100" />
                                                            </td>
                                                            <td>
                                                                <ext:DateField ID="Leads3Implant" runat="server" Width="100" />
                                                            </td>
                                                            <td style="text-align: center;">电极位置</td>
                                                            <td>
                                                                <ext:RadioGroup ID="Leads3Position" runat="server" ColumnsNumber="4"
                                                                    Width="350">
                                                                    <Items>
                                                                        <ext:Radio ID="Leads3Position_1" runat="server" BoxLabel="右心房" cvalue="1" />
                                                                        <ext:Radio ID="Leads3Position_2" runat="server" BoxLabel="右心室" cvalue="2" />
                                                                        <ext:Radio ID="Leads3Position_3" runat="server" BoxLabel="左心室" cvalue="3" />
                                                                        <ext:Radio ID="Leads3Position_4" runat="server" BoxLabel="不知道" cvalue="4" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>配件</td>
                                                            <td>
                                                                <ext:TextField ID="AccessoryModel" runat="server" Width="100" />
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="AccessorySerial" runat="server" Width="100" />
                                                            </td>
                                                            <td>
                                                                <ext:DateField ID="AccessoryImplant" runat="server" Width="100" />
                                                            </td>
                                                            <td style="text-align: center;">批号（如有）</td>
                                                            <td>
                                                                <ext:TextField ID="AccessoryLot" runat="server" Width="100" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <div class="panelTital red" style="width: 100%">
                                                        *移除信息（请在“仍在服务中”和“产品已移除体内”选一项）
                                                    </div>
                                                    <table style="width: 100%">
                                                        <tr>
                                                            <td style="width: 200px;">移除时间：</td>
                                                            <td>
                                                                <ext:DateField ID="ExplantDate" runat="server" Width="200" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>仍在服务中：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="RemainsService" runat="server" FieldLabel="仍在服务中" ColumnsNumber="5" Width="600">
                                                                    <Items>
                                                                        <ext:Radio ID="RemainsService_1" runat="server" BoxLabel="未改变" cvalue="1">
                                                                            <Listeners>
                                                                                <Check Handler="isRemainsServiceChheck(true);" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="RemainsService_2" runat="server" BoxLabel="重新程控" cvalue="2">
                                                                            <Listeners>
                                                                                <Check Handler="isRemainsServiceChheck(true);" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="RemainsService_3" runat="server" BoxLabel="重新定位" cvalue="3">
                                                                            <Listeners>
                                                                                <Check Handler="isRemainsServiceChheck(true);" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="RemainsService_4" runat="server" BoxLabel="修理" cvalue="4">
                                                                            <Listeners>
                                                                                <Check Handler="isRemainsServiceChheck(true);" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="RemainsService_5" runat="server" BoxLabel="失效" cvalue="5">
                                                                            <Listeners>
                                                                                <Check Handler="isRemainsServiceChheck(true);" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>产品已移除体内</td>
                                                            <td>
                                                                <ext:RadioGroup ID="RemovedService" runat="server" FieldLabel="产品已移除体内" ColumnsNumber="4" Width="700">
                                                                    <Items>
                                                                        <ext:Radio ID="RemovedService_1" runat="server" BoxLabel="丢弃" cvalue="1">
                                                                            <Listeners>
                                                                                <Check Handler="isRemainsServiceChheck(false);" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="RemovedService_2" runat="server" BoxLabel="返回波科" cvalue="2">
                                                                            <Listeners>
                                                                                <Check Handler="isRemainsServiceChheck(false);" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="RemovedService_3" runat="server" BoxLabel="STAT analysis requested" cvalue="3">
                                                                            <Listeners>
                                                                                <Check Handler="isRemainsServiceChheck(false);" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="RemovedService_4" runat="server" BoxLabel="设备或电极不能退回" cvalue="4">
                                                                            <Listeners>
                                                                                <Check Handler="isRemainsServiceChheck(false);" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <div style="width: 100%" class="panelTital red">
                                                        更换的产品信息
                                                    </div>
                                                    <table style="width: 100%">
                                                        <tr>
                                                            <td style="width: 300px;">型号</td>
                                                            <td style="width: 300px;">序列号</td>
                                                            <td>植入时间</td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:TextField ID="Replace1Model" runat="server" Width="200" />
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="Replace1Serial" runat="server" Width="200" />
                                                            </td>
                                                            <td>
                                                                <ext:DateField ID="Replace1Implant" runat="server" Width="200" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:TextField ID="Replace2Model" runat="server" Width="200" />
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="Replace2Serial" runat="server" Width="200" />
                                                            </td>
                                                            <td>
                                                                <ext:DateField ID="Replace2Implant" runat="server" Width="200" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:TextField ID="Replace3Model" runat="server" Width="200" />
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="Replace3Serial" runat="server" Width="200" />
                                                            </td>
                                                            <td>
                                                                <ext:DateField ID="Replace3Implant" runat="server" Width="200" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:TextField ID="Replace4Model" runat="server" Width="200" />
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="Replace4Serial" runat="server" Width="200" />
                                                            </td>
                                                            <td>
                                                                <ext:DateField ID="Replace4Implant" runat="server" Width="200" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <ext:TextField ID="Replace5Model" runat="server" Width="200" />
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="Replace5Serial" runat="server" Width="200" />
                                                            </td>
                                                            <td>
                                                                <ext:DateField ID="Replace5Implant" runat="server" Width="200" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>

                                            <ext:Panel ID="Panel9" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="9. 产品体验详细的事件描述或临床观察（事件描述尽量详细，包括上报的临床观察，发生事件的时间和地点，故障排除的结果，设备或者电极的参数，病人的影响以及最后的手术结果）" Header="true" Collapsible="true">
                                                <Body>
                                                    <ext:TextArea ID="ProductExpDetail" runat="server" Width="1000"
                                                        AllowBlank="false" BlankText="请填写【9.产品体验详细的事件描述或临床观察】" Cls="lightyellow-row" />
                                                </Body>
                                            </ext:Panel>

                                            <ext:Panel ID="Panel10" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="10. 客户意见/扩展需求" Header="true" Collapsible="true">
                                                <Body>
                                                    <ext:TextArea ID="CustomerComment" runat="server" Width="1000" />
                                                </Body>
                                            </ext:Panel>

                                            <ext:Panel ID="Panel13" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="11、附件" Header="true" Collapsible="true">
                                                <Body>
                                                    <ext:FitLayout ID="FitLayout1" runat="server">
                                                        <ext:GridPanel ID="gpAttachment" runat="server" Title="附件信息" StoreID="AttachmentStore" AutoScroll="true"
                                                            StripeRows="true" Collapsible="false" Border="true" Header="false" Icon="Lorry"
                                                            AutoExpandColumn="Name" Height="200" AutoWidth="true">
                                                            <TopBar>
                                                                <ext:Toolbar ID="Toolbar5" runat="server">
                                                                    <Items>
                                                                        <ext:ToolbarFill ID="ToolbarFill5" runat="server" />
                                                                        <ext:Button ID="btnUploadAttachment" runat="server" Text="上传附件" Icon="FolderUp">
                                                                            <Listeners>
                                                                                <Click Handler="#{hiddenAttachmentUpload}.setValue('DealerComplainCRM');#{AttachmentWindow}.show();#{FileUploadField1}.setValue('');" />
                                                                            </Listeners>
                                                                        </ext:Button>
                                                                    </Items>
                                                                </ext:Toolbar>
                                                            </TopBar>
                                                            <ColumnModel ID="ColumnModel2" runat="server">
                                                                <Columns>
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
                                                                            <ext:GridCommand Icon="Cross" CommandName="Delete" ToolTip-Text="删除" />
                                                                        </Commands>
                                                                    </ext:CommandColumn>
                                                                </Columns>
                                                            </ColumnModel>
                                                            <SelectionModel>
                                                                <ext:RowSelectionModel ID="RowSelectionModel2" SingleSelect="true" runat="server"
                                                                    MoveEditorOnEnter="true">
                                                                </ext:RowSelectionModel>
                                                            </SelectionModel>
                                                            <BottomBar>
                                                                <ext:PagingToolbar ID="PagingToolBarAttachement" runat="server" PageSize="50" StoreID="AttachmentStore"
                                                                    DisplayInfo="true" />
                                                            </BottomBar>
                                                            <SaveMask ShowMask="false" />
                                                            <LoadMask ShowMask="true" />
                                                            <Listeners>
                                                                <Command Handler="if (command == 'Delete'){
                                                                                Ext.Msg.confirm('警告', '是否要删除该附件文件?',
                                                                                    function(e) {
                                                                                        if (e == 'yes') {
                                                                                            Coolite.AjaxMethods.DeleteAttachment('DealerComplainCRM',record.data.Id,record.data.Url,{
                                                                                                success: function() {
                                                                                                    Ext.Msg.alert('Message', '删除附件成功！');
                                                                                                    #{gpAttachment}.reload();
                                                                                                },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                        }
                                                                                    });
                                                                            }
                                                                            else if (command == 'DownLoad')
                                                                            {
                                                                                var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=DealerComplainCRM';
                                                                                downloadfile(url);
                                                                            }
                                                                            
                                                                            " />
                                                            </Listeners>
                                                        </ext:GridPanel>
                                                    </ext:FitLayout>
                                                </Body>
                                            </ext:Panel>

                                            <ext:Panel ID="Panel11" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="操作日志" Header="true" Collapsible="true">
                                                <Body>
                                                    <ext:FitLayout ID="FT2" runat="server">
                                                        <ext:GridPanel ID="gpLog" runat="server" Title="审批记录" StoreID="OrderLogStore" AutoScroll="true"
                                                            StripeRows="true" Collapsible="false" Border="true" Header="false" Icon="Lorry"
                                                            AutoExpandColumn="OperNote" Height="200" AutoWidth="true">
                                                            <ColumnModel ID="ColumnModel1" runat="server">
                                                                <Columns>
                                                                    <ext:Column ColumnID="OperUserId" DataIndex="OperUserId" Header="操作人账号" Width="100">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="OperUserName" DataIndex="OperUserName" Header="操作人姓名" Width="200">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="OperTypeName" DataIndex="OperTypeName" Header="操作类型" Width="100">
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="OperDate" DataIndex="OperDate" Header="操作日期" Width="150">
                                                                        <Renderer Fn="Ext.util.Format.dateRenderer('Y-m-d H:i:s')" />
                                                                    </ext:Column>
                                                                    <ext:Column ColumnID="OperNote" DataIndex="OperNote" Header="备注">
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
                                            </ext:Panel>
                                        </Body>
                                    </ext:Panel>
                                </Body>
                                <LoadMask ShowMask="true" />
                                <Buttons>
                                    <ext:Button ID="btnExportForm" runat="server" Text="导出Word" Icon="PageWord">
                                        <Listeners>
                                            <Click Handler="DoExportForm();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnQaReceipt" runat="server" Text="QA确认收到投诉单" Icon="Accept">
                                        <Listeners>
                                            <Click Handler="DoQAReceipt();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnQaSaveDraft" runat="server" Text="QA保存草稿" Icon="PageSave">
                                        <Listeners>
                                            <Click Handler="DoQASaveDraft();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnQASubmit" runat="server" Text="QA提交" Icon="UserTick">
                                        <Listeners>
                                            <Click Handler="DoQASubmit();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnQAReject" runat="server" Text="退回" Icon="UserCross">
                                        <Listeners>
                                            <Click Handler="DoReject();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnSaveDraft" runat="server" Text="保存草稿" Icon="PageSave">
                                        <Listeners>
                                            <Click Handler="DoSaveDraft();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnCarrieSubmit" runat="server" Text="提交" Icon="Tick">
                                        <Listeners>
                                            <Click Handler="CheckCRMSubmit();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnDealerConfirm" runat="server" Text="经销商确认投诉" Icon="Tick">
                                        <Listeners>
                                            <Click Handler="DoDealerConfirm();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnSaveReturnDraft" runat="server" Text="保存退货单草稿" Icon="PageSave">
                                        <Listeners>
                                            <Click Handler="DoSaveReturnDraft();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnSubmitReturn" runat="server" Text="提交退货单" Icon="Tick">
                                        <Listeners>
                                            <Click Handler="CheckSubmitReturn();" />
                                        </Listeners>
                                    </ext:Button>
                                    <ext:Button ID="btnCRMCarrierCancel" runat="server" Text="返回" Icon="Delete">
                                        <Listeners>
                                            <Click Handler="window.parent.closeTab('subMenu' + Ext.getCmp('hidInstanceId').getValue());" />
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                            </ext:Panel>
                        </Center>
                    </ext:BorderLayout>

                </Body>
            </ext:ViewPort>
        </div>

        <ext:Window ID="AttachmentWindow" runat="server" Icon="Group" Title="上传附件" Resizable="false" Header="false" Width="500" Height="200" AutoShow="false" Modal="true" ShowOnLoad="false" BodyStyle="padding:5px;">
            <Body>
                <ext:FormPanel ID="BasicForm" runat="server" Width="500" Frame="true" Header="false" AutoHeight="true" MonitorValid="true" BodyStyle="padding: 10px 10px 0 10px;">
                    <Defaults>
                        <ext:Parameter Name="anchor" Value="95%" Mode="Value" />
                        <ext:Parameter Name="allowBlank" Value="false" Mode="Raw" />
                        <ext:Parameter Name="msgTarget" Value="side" Mode="Value" />
                    </Defaults>
                    <Body>
                        <ext:FormLayout ID="FormLayout7" runat="server" LabelWidth="50">
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
                                            msg     : result, 
                                            minWidth: 200, 
                                            modal   : true, 
                                            icon    : Ext.Msg.ERROR, 
                                            buttons : Ext.Msg.OK 
                                        });"
                                    Success="Ext.Msg.alert('信息','上传成功！');if (#{hiddenAttachmentUpload}.getValue()=='DealerComplainCRMRtn') #{gpAttachment_Return}.reload(); else #{gpAttachment}.reload(); #{FileUploadField1}.setValue('');">
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
                <Hide Handler="if (#{hiddenAttachmentUpload}.getValue()=='DealerComplainCRMRtn') #{gpAttachment_Return}.reload(); else #{gpAttachment}.reload();" />
                <BeforeShow Handler="#{FileUploadField1}.setValue('');" />
            </Listeners>
        </ext:Window>

        <uc:CFNSearchForComplainDialog ID="CFNSearchForComplainDialog1" runat="server" />
        <uc:HospitalSearchForComplainDialog ID="HospitalSearchForComplainDialog1" runat="server" />
    </form>

    <script type="text/javascript">
        if (Ext.isChrome === true) {
            var chromeDatePickerCSS = ".x-date-picker {border-color: #1b376c;background-color:#fff;position: relative;width: 185px;}";
            Ext.util.CSS.createStyleSheet(chromeDatePickerCSS, 'chromeDatePickerStyle');
        }
    </script>

</body>
</html>
