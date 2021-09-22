<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DealerComplainForCNFEdit.aspx.cs" Inherits="DMS.Website.Pages.Inventory.DealerComplainForCNFEdit" %>

<%@ Register Assembly="Coolite.Ext.Web" Namespace="Coolite.Ext.Web" TagPrefix="ext" %>

<%@ Register Src="../../Controls/CFNSearchForComplainDialog.ascx" TagName="CFNSearchForComplainDialog" TagPrefix="uc" %>
<%@ Register Src="../../Controls/HospitalSearchForComplainDialog.ascx" TagName="HospitalSearchForComplainDialog" TagPrefix="uc" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../../resources/css/main.css" rel="stylesheet" type="text/css" />
    <script src="../../resources/kendo-2017.2.504/js/jquery.min.js"></script>
    <script src="../../resources/cooliteHelper.js" type="text/javascript"></script>
    <style>
        #divComplainCNF > .ext-el-mask {
            position: fixed;
        }

        .red {
            color: red;
        }

        table td {
            padding-top: 3px;
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
    <script>
        function downloadfile(url) {
            var iframe = document.createElement("iframe");
            iframe.src = url;
            iframe.style.display = "none";
            document.body.appendChild(iframe);
        }
        function itemValid(controlId) {
            var item = Ext.getCmp(controlId);
            if (isCheck) {
                if (item.getValue() == "" || item.getValue == 'undefined') {
                    alert(item.blankText);
                    item.focus();
                    isCheck = false;
                }
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

                    Ext.getCmp('<%=this.cbLOT.ClientID%>').setValue('');
                    Ext.getCmp('<%=this.cbUPN.ClientID%>').setValue('');
                    Ext.getCmp('<%=this.DESCRIPTION.ClientID%>').setValue('');
                    //<%--Ext.getCmp('<%=this.Model.ClientID%>').setValue('');--%>
                    Ext.getCmp('<%=this.txtRegistration.ClientID%>').setValue('');
                    Ext.getCmp('<%=this.DISTRIBUTORCUSTOMER.ClientID%>').setValue('');
                    Ext.getCmp('<%=this.DISTRIBUTORCITY.ClientID%>').setValue('');
                    Ext.getCmp('<%=this.DISTRIBUTORCUSTOMER.ClientID%>').setValue('');

                    HideEditingMask();
                }, failure: function (e) {
                    HideEditingMask(); Ext.Msg.alert('Error', err);
                }
            });
        }
        function checkItemValid(controlId) {
            var i = Ext.getCmp(controlId);
            if (isCheck) {
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
                    isCheck = false;
                }
            }
        }

        function radioItemValid(controlId) {
            var i = Ext.getCmp(controlId);
            if (isCheck) {
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
                    isCheck = false;
                }
            }
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
            function dateValid(controlId) {
                var i = Ext.getCmp(controlId);
                console.log(isCheck);
                if (isCheck) {
                    if (i.getValue() == null || i.getValue() == '') {
                        alert(i.blankText);
                        i.focus();
                        isCheck = false;
                    }
                }
            }
            var SetWinBtnDisabled = function (control, disabled) {
                for (var i = 0; i < control.buttons.length; i++) {
                    control.buttons[i].setDisabled(disabled);
                }
            }
            function CheckCRMReturnField() {
                this.itemValid('<%=this.txtQrCode.ClientID%>');
            this.itemValid('<%=this.cbWarehouse.ClientID%>');
            this.itemValid('<%=this.SalesDate.ClientID%>');
            this.checkItemValid('<%=PRODUCTTYPE.ClientID%>');
            this.itemValid('<%=this.RETURNTYPE.ClientID%>');
          <%--  this.itemValid('<%=this.CarrierNumber.ClientID%>');

            this.itemValid('<%=this.CourierCompany.ClientID%>');--%>
            <%--this.radioItemValid('<%=ReceiveReturnedGoods.ClientID%>');--%>
        }

<%--        function CheckReturnFieldSpecial() {
            if (Ext.getCmp('<%=this.ReceiveReturnedGoods_1.ClientID%>').checked) {
                if (Ext.getCmp('<%=this.ReceiveReturnedGoodsDate.ClientID%>').getValue() == null || Ext.getCmp('<%=this.ReceiveReturnedGoodsDate.ClientID%>').getValue() == '') {
                    Ext.getCmp('<%=this.ReceiveReturnedGoodsDate.ClientID%>').focus();
                    alert("收到实物日期必须填写");
                    isCheck = false;
                    return false;
                }
            }
        }--%>

        function CheckCNFFieldSpecial() {
            if (Ext.getCmp('<%=this.UPNEXPECTED_1.ClientID%>').checked) {
                Ext.getCmp('<%=this.UPNQUANTITY.ClientID%>').setValue('1');
                Ext.getCmp('<%=this.NORETURN_10.ClientID%>').disable('True');
                Ext.getCmp('<%=this.NORETURN_20.ClientID%>').disable('True');
                Ext.getCmp('<%=this.NORETURN_30.ClientID%>').disable('True');
                Ext.getCmp('<%=this.NORETURN_40.ClientID%>').disable('True');
                Ext.getCmp('<%=this.NORETURN_99.ClientID%>').disable('True');
                Ext.getCmp('<%=this.NORETURN_50.ClientID%>').disable('True');
                Ext.getCmp('<%=this.etfOtherDec.ClientID%>').disable('True');
                Ext.getCmp('<%=this.NORETURN_50.ClientID%>').setValue(true);
                Ext.getCmp('<%=this.etfOtherDec.ClientID%>').setValue('');
            }
            else {
                Ext.getCmp('<%=this.UPNQUANTITY.ClientID%>').setValue('0');
                Ext.getCmp('<%=this.NORETURN_10.ClientID%>').enable('True');
                Ext.getCmp('<%=this.NORETURN_20.ClientID%>').enable('True');
                Ext.getCmp('<%=this.NORETURN_30.ClientID%>').enable('True');
                Ext.getCmp('<%=this.NORETURN_40.ClientID%>').enable('True');
                Ext.getCmp('<%=this.NORETURN_99.ClientID%>').enable('True');
                Ext.getCmp('<%=this.etfOtherDec.ClientID%>').enable('True');
                Ext.getCmp('<%=this.NORETURN_50.ClientID%>').setValue(false);
                Ext.getCmp('<%=this.etfOtherDec.ClientID%>').setValue('');
            }

        }
        function chenkOtherDesc() {
            //是否有跟台填了是，则跟台日期，跟台人员必填
            if (isCheck) {
                if (Ext.getCmp('<%=this.HasFollowOperation_1.ClientID%>').checked) {
                    if (Ext.getCmp('<%=this.FollowOperationDate.ClientID%>').getValue() == null || Ext.getCmp('<%=this.FollowOperationDate.ClientID%>').getValue() == '') {
                        Ext.getCmp('<%=this.FollowOperationDate.ClientID%>').focus();
                        alert("跟台日期必须填写");
                        isCheck = false;
                        return false;
                    }
                    if ((Ext.getCmp('<%=this.FollowOperationStaff_1.ClientID%>').getValue() == null || Ext.getCmp('<%=this.FollowOperationStaff_1.ClientID%>').getValue() == '')
                        && (Ext.getCmp('<%=this.FollowOperationStaff_2.ClientID%>').getValue() == null || Ext.getCmp('<%=this.FollowOperationStaff_2.ClientID%>').getValue() == '')) {
                        Ext.getCmp('<%=this.FollowOperationStaff.ClientID%>').focus();
                        alert("跟台人员必须填写");
                        isCheck = false;
                        return false;
                    }
                }
            }

            if (Ext.getCmp('<%=this.Pulse_7.ClientID%>').checked) {
                this.itemValid('<%=this.etfOtherTreatDesc.ClientID%>');
            }
            if (Ext.getCmp('<%=this.Pulse_6.ClientID%>').checked) {
                this.itemValid('<%=this.etfBloodDesc.ClientID%>');
            }
            if (Ext.getCmp('<%=this.Pulse_4.ClientID%>').checked) {
                this.itemValid('<%=this.etfMedicationDesc.ClientID%>');
            }
            if (Ext.getCmp('<%=this.Pulse_3.ClientID%>').checked) {
                this.itemValid('<%=this.etfInPatientDesc.ClientID%>');
            }
            if (Ext.getCmp('<%=this.Pulse_2.ClientID%>').checked) {
                this.itemValid('<%=this.etfSurgeryDesc.ClientID%>');
            }

            if (Ext.getCmp('<%=this.Dead_1.ClientID%>').checked) {

                this.itemValid('<%=this.edtDeadDate.ClientID%>');
                <%--//this.radioItemValid('<%=this.RadioGroupPostmortem.ClientID%>');--%>
            }
            if (Ext.getCmp('<%=this.Dead_2.ClientID%>').checked) {
                this.itemValid('<%=this.NotSeriousRemark.ClientID%>');
            }
            if (Ext.getCmp('<%=this.Dead_3.ClientID%>').checked) {
                this.itemValid('<%=this.SeriousRemark.ClientID%>');
            }
            if (Ext.getCmp('<%=this.Dead_4.ClientID%>').checked) {
                this.itemValid('<%=this.PermanentDamageRemark.ClientID%>');
            }

            if (isCheck) {
                if (Ext.getCmp('<%=this.WITHLABELEDUSE_2.ClientID%>').checked) {
                    if (Ext.getCmp('<%=this.NOLABELEDUSE.ClientID%>').getValue() == null || Ext.getCmp('<%=this.NOLABELEDUSE.ClientID%>').getValue() == '') {
                        Ext.getCmp('<%=this.NOLABELEDUSE.ClientID%>').focus();
                        alert("如果不是，请解释，必须填写");
                        isCheck = false;
                        return false;
                    }
                }
            }
        }

        var isCheck = true;
        var CheckCNFSubmit = function () {
            //alert('hello world!');
            isCheck = true;
            checkField();
            CheckEDate();
            chenkOtherDesc();
            CheckCRMReturnField();
            if (isCheck) {
                //Ext.Msg.confirm('信息', '是否要执行【提交】操作吗？', function (e) {
                Ext.Msg.confirm('信息', '物权类型为' + Ext.getCmp('PropertyRights').getValue() + ',只能进行' + Ext.getCmp('RETURNTYPE').getText() + ',是否要执行【提交退货单】操作吗？', function (e) {
                    if (e == "yes") {
                        this.DoSubmit();
                    }
                });
            }
        }

        var showTextBoxWhenChecked = function (checkType) {
            if (checkType == 'Pulse_7') {
                if (Ext.getCmp('<%=this.Pulse_7.ClientID%>').checked) {
                    Ext.getCmp('<%=this.etfOtherTreatDesc.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.etfOtherTreatDesc.ClientID%>').hide();
                }
            }
            else if (checkType == 'Pulse_6') {
                if (Ext.getCmp('<%=this.Pulse_6.ClientID%>').checked) {
                    Ext.getCmp('<%=this.etfBloodDesc.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.etfBloodDesc.ClientID%>').hide();
                }
            }
            else if (checkType == 'Pulse_4') {
                if (Ext.getCmp('<%=this.Pulse_4.ClientID%>').checked) {
                    Ext.getCmp('<%=this.etfMedicationDesc.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.etfMedicationDesc.ClientID%>').hide();
                }
            }
            else if (checkType == 'Pulse_3') {
                if (Ext.getCmp('<%=this.Pulse_3.ClientID%>').checked) {
                    Ext.getCmp('<%=this.etfInPatientDesc.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.etfInPatientDesc.ClientID%>').hide();
                }
            }
            else if (checkType == 'Pulse_2') {
                if (Ext.getCmp('<%=this.Pulse_2.ClientID%>').checked) {
                    Ext.getCmp('<%=this.etfSurgeryDesc.ClientID%>').show();
                } else {
                    Ext.getCmp('<%=this.etfSurgeryDesc.ClientID%>').hide();
                }
            }

        }

var isDeathCheck = function (checkType) {
    if (checkType == "Dead_1") {
        if (Ext.getCmp('<%=this.Dead_1.ClientID%>').checked) {
            document.getElementById('<%=this.tr1.ClientID%>').style.display = "";
        } else {
            document.getElementById('<%=this.tr1.ClientID%>').style.display = "none";
        }
    }
    else if (checkType == "Dead_2") {
        if (Ext.getCmp('<%=this.Dead_2.ClientID%>').checked) {
                    document.getElementById('<%=this.tr2.ClientID%>').style.display = "";
                } else {
                    document.getElementById('<%=this.tr2.ClientID%>').style.display = "none";
                }
            }
            else if (checkType == "Dead_3") {
                if (Ext.getCmp('<%=this.Dead_3.ClientID%>').checked) {
                    document.getElementById('<%=this.tr3.ClientID%>').style.display = "";
                } else {
                    document.getElementById('<%=this.tr3.ClientID%>').style.display = "none";
                }
            }
            else if (checkType == "Dead_4") {
                if (Ext.getCmp('<%=this.Dead_4.ClientID%>').checked) {
                    document.getElementById('<%=this.tr4.ClientID%>').style.display = "";
                } else {
                    document.getElementById('<%=this.tr4.ClientID%>').style.display = "none";
                }
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

var withLabelUserCheck = function () {
    if (Ext.getCmp('<%=this.WITHLABELEDUSE_2.ClientID%>').checked) {
                document.getElementById('<%=this.tdlblNOLABELEDUSE.ClientID%>').style.display = "";
                document.getElementById('<%=this.tdNOLABELEDUSE.ClientID%>').style.display = "";
            } else {
                Ext.getCmp('<%=this.NOLABELEDUSE.ClientID%>').setValue('');
                document.getElementById('<%=this.tdlblNOLABELEDUSE.ClientID%>').style.display = "none";
                document.getElementById('<%=this.tdNOLABELEDUSE.ClientID%>').style.display = "none";
            }
        }

        var checkField = function () {          
            
           
            //alert('hello world!');
            this.itemValid('<%=this.cbLOT.ClientID%>');
            this.itemValid('<%=this.cbUPN.ClientID%>');
            this.itemValid('<%=this.INITIALPDATE.ClientID%>');
            this.itemValid('<%=this.EDATE.ClientID%>');

            <%--this.itemValid('<%=this.CompletedName.ClientID%>');
            this.itemValid('<%=this.BSCSalesPhone.ClientID%>');--%>
            this.itemValid('<%=this.INITIALJOB.ClientID%>');
            this.itemValid('<%=this.INITIALNAME.ClientID%>');
            this.itemValid('<%=this.INITIALPHONE.ClientID%>');
            this.itemValid('<%=this.PHYSICIANPHONE.ClientID%>');
            this.itemValid('<%=this.INITIALEMAIL.ClientID%>');
            this.itemValid('<%=this.PHYSICIAN.ClientID%>');
            <%--this.radioItemValid('<%=HasFollowOperation.ClientID%>');--%>
            this.radioItemValid('<%=NeedOfferAnalyzeReport.ClientID%>');
            this.checkItemValid('<%=this.COMPLAINTSOURCE.ClientID%>');
            this.checkItemValid('<%=this.CONTACTMETHOD.ClientID%>');

            this.radioItemValid('<%=this.ISPLATFORM.ClientID%>');
            this.itemValid('<%=this.BSCSOLDTONAME.ClientID%>');
            this.itemValid('<%=this.BSCSOLDTOCITY.ClientID%>');
            this.itemValid('<%=this.DISTRIBUTORCUSTOMER.ClientID%>');
            this.itemValid('<%=this.DISTRIBUTORCITY.ClientID%>');

            this.radioItemValid('<%=this.SINGLEUSE.ClientID%>');
            this.radioItemValid('<%=this.RESTERILIZED.ClientID%>');
            this.radioItemValid('<%=this.USEDEXPIRY.ClientID%>');
            this.radioItemValid('<%=this.UPNEXPECTED.ClientID%>');
            this.checkItemValid('<%=this.NORETURN.ClientID%>');

            //校验患者信息
            this.itemValid('<%=this.etfOCCurPatientAge.ClientID%>');
            this.itemValid('<%=this.etfAgeUint.ClientID%>');
            this.radioItemValid('<%=this.RadioGroupAdult.ClientID%>');
            //this.dateValid('<%=this.edfPatientBrithDate.ClientID%>');
            this.radioItemValid('<%=this.RadioGroupGender.ClientID%>');
            this.itemValid('<%=this.etfPatientWeight.ClientID%>');
            this.radioItemValid('<%=this.RadioGroupWeightUint.ClientID%>');
            this.itemValid('<%=this.etfAnatomy.ClientID%>');

            //手术信息
            this.itemValid('<%=this.PNAME.ClientID%>');
            this.itemValid('<%=this.INDICATION.ClientID%>');
            this.checkItemValid('<%=this.POUTCOME.ClientID%>');
            this.radioItemValid('<%=this.PCONDITION.ClientID%>');

            //事件信息
            this.checkItemValid('<%=this.WHEREOCCUR.ClientID%>');
            this.checkItemValid('<%=this.WHENNOTICED.ClientID%>');
            this.itemValid('<%=this.EDESCRIPTION.ClientID%>');
            if (Ext.getCmp('<%=this.hiddenUPNLevel2Code.ClientID%>').getValue() == '040') {
                this.radioItemValid('<%=this.NoProblemButLesionNotPass.ClientID%>');
            }
            this.radioItemValid('<%=this.EVENTRESOLVED.ClientID%>');
            this.radioItemValid('<%=this.WITHLABELEDUSE.ClientID%>');
        }

        function CheckEDate() {
            if (isCheck) {
                var InitialDate = Ext.getCmp('<%=this.INITIALPDATE.ClientID%>');
                var isDead = Ext.getCmp('<%=this.Dead_1.ClientID%>');
                var EDate = Ext.getCmp('<%=this.EDATE.ClientID%>');
                var deathDate = Ext.getCmp('<%=this.edtDeadDate.ClientID%>');
                var nowDate = new Date();
                //如果选择了死亡，则必须填写死亡日期
                if (isDead.checked) {
                    if (deathDate == null || deathDate.getValue() == '') {
                        alert("请选择死亡日期！");
                        deathDate.focus();
                        deathDate.setValue("");
                        isCheck = false;
                    }
                }

                if (InitialDate == null || InitialDate.getValue() == '') {
                    alert("请选择首次手术日期！");
                    InitialDate.focus();
                    InitialDate.setValue("");
                    isCheck = false;

                } else if (EDate == null || EDate.getValue() == '') {
                    alert("请选择事件发生日期！");
                    EDate.focus();
                    EDate.setValue("");
                    isCheck = false;
                } else if (InitialDate.getValue() > EDate.getValue()) {
                    alert("事件日期不能小于手术日期！");
                    EDate.setValue("");
                    isCheck = false;
                } else if (nowDate < EDate.getValue()) {
                    alert("事件日期不能大于当前日期！");
                    EDate.setValue("");
                    isCheck = false;
                }

                
            }
        }

        var DoSaveDraft = function () {
            //Ext.getCmp('<%=this.hidInstanceId.ClientID%>').focus();
            ShowEditingMask();
            Coolite.AjaxMethods.DoSave('doSaveDraft', {
                success: function () {
                    alert('保存草稿成功');
                    HideEditingMask();
                    window.location.href = window.location.href;
                },
                failure: function (err) {
                    Ext.Msg.alert('Error', err);
                    HideEditingMask();
                }
            });
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

        var DoSubmit = function () {
            Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
            ShowEditingMask();
            Coolite.AjaxMethods.DoSave('doSubmit', {
                success: function () {
                    alert('提交成功！');
                    HideEditingMask();
                    window.location.href = window.location.href;
                },
                failure: function (err) {
                    Ext.Msg.alert('Error', err);
                    HideEditingMask();
                }
            });
        }

            var DoSaveReturnDraft = function () {
            <%-- Ext.getCmp('<%=this.txtLotNumber.ClientID%>').focus();--%>
                ShowEditingMask();
                Coolite.AjaxMethods.DoSaveReturn('doSaveDraft', {
                    success: function () {
                        alert('保存草稿成功');
                        HideEditingMask();
                        window.location.href = window.location.href;
                    },
                    failure: function (err) {
                        Ext.Msg.alert('Error', err);
                        HideEditingMask();
                    }
                });
            }

            var CheckSubmitReturn = function () {
                isCheck = true;
                CheckCRMReturnField();
                //CheckReturnFieldSpecial();

                if (isCheck) {
                    Ext.Msg.confirm('信息', '物权类型为' + Ext.getCmp('PropertyRights').getValue() + ',只能进行' + Ext.getCmp('RETURNTYPE').getText() + ',是否要执行【提交退货单】操作吗？', function (e) {
                        if (e == "yes") {
                        <%-- Ext.getCmp('<%=this.txtLotNumber.ClientID%>').focus();--%>
                        ShowEditingMask();
                        Coolite.AjaxMethods.DoSaveReturn('doSubmit', {
                            success: function () {
                                alert('提交成功!');
                                HideEditingMask();
                                window.location.href = window.location.href;
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                                HideEditingMask();
                            }
                        });
                    }
                });
            }
        }
        var DoDealerConfirm = function () {
            Ext.Msg.confirm("信息", "你确定要执行【经销商确认投诉单】操作吗？", function (e) {
                if (e == "yes") {
                    Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
                    ShowEditingMask();
                    Coolite.AjaxMethods.DoDealerConfirm({
                        success: function () {
                            alert('操作成功！');
                            HideEditingMask();
                            window.location.href = window.location.href;
                        },
                        failure: function (err) {
                            Ext.Msg.alert('Error', err);
                            HideEditingMask();
                        }
                    });
                }
            });
        }
        function chenkQA() {
            this.itemValid('<%=this.COMPLAINTID.ClientID%>');
            this.itemValid('<%=this.REFERBOX.ClientID%>');
            this.itemValid('<%=this.TW.ClientID%>');
        }
        var DoQASubmit = function () {
            isCheck = true;
            chenkQA();
            CheckEDate();
            if (isCheck) {
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
            Ext.Msg.confirm("信息", "你确定要执行【退回】操作吗？", function (e) {
                if (e == "yes") {
                    Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
                    ShowEditingMask();
                    Coolite.AjaxMethods.DoQAReject({
                        success: function () {
                            alert('操作成功！');
                            HideEditingMask();
                            window.location.href = window.location.href;
                        },
                        failure: function (err) {
                            Ext.Msg.alert('Error', err);
                            HideEditingMask();
                        }
                    });
                }
            });
        }
        var DoQASaveDraft = function () {
            Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
            ShowEditingMask();
            Coolite.AjaxMethods.DoQASaveDraft({
                success: function () {
                    alert('操作成功！');
                    HideEditingMask();
                    window.location.href = window.location.href;
                },
                failure: function (err) {
                    Ext.Msg.alert('Error', err);
                    HideEditingMask();
                }
            });
        }

        var DoQAReceipt = function () {
            Ext.Msg.confirm("信息", "你确定要执行【QA确认收到投诉单】操作吗？", function (e) {
                if (e == "yes") {
                    Ext.getCmp('<%=this.cbDealer.ClientID%>').focus();
                        ShowEditingMask();
                        Coolite.AjaxMethods.DoQAReceipt({
                            success: function () {
                                alert('操作成功！');
                                HideEditingMask();
                                window.location.href = window.location.href;
                            },
                            failure: function (err) {
                                Ext.Msg.alert('Error', err);
                                HideEditingMask();
                            }
                        });
                    }
            });
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

            //var isNoProblemButLesionNotPass = function () {
            //    if (Ext.getCmp('NoProblemButLesionNotPass_1').checked == true) {
            //        Ext.getCmp('UPNEXPECTED_1').setValue(false);
            //        Ext.getCmp('UPNEXPECTED_2').setValue(true);
            //        Ext.getCmp('UPNQUANTITY').setValue('0');
            //        Ext.getCmp('NORETURN_10').setValue(true);
            //    }
            //}
    </script>
    <form id="form1" runat="server">
        <ext:ScriptManager ID="ScriptManager1" runat="server" />
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
        <%-- //<ext:Hidden ID="hiddenCompalinStatus" runat="server"></ext:Hidden>--%>
        <ext:Hidden ID="hidInstanceId" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenInitUserId" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenBscUserId" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenLastUpdateDate" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenInitDealerId" runat="server"></ext:Hidden>
        <ext:Hidden ID="DealerID" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenConfirmUpdateDate" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenAttachmentUpload" runat="server"></ext:Hidden>
        <ext:Hidden ID="hiddenUPNLevel2Code" runat="server"></ext:Hidden>
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
        <div id="divComplainCNF">
            <ext:ViewPort ID="ViewPort1" runat="server">
                <Body>
                    <ext:BorderLayout ID="BorderLayout1" runat="server">
                        <Center MarginsSummary="0 5 0 5">
                            <ext:Panel ID="complainCrmPanel" runat="server" Header="false" Frame="false" BodyBorder="false"
                                AutoScroll="true">
                                <Body>
                                    
                                    <ext:Panel ID="mainPanel" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px 5px 10px 5px;" BodyBorder="true"
                                        Title="投诉申请单" Header="true" Collapsible="true">
                                        <Body>
                                            <ext:Panel ID="Panel1" Title="填写投诉相关信息" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%;">
                                                        <tr style="">
                                                            <td style="width: 140px;">产品二维码:</td>
                                                            <td>
                                                                <ext:TextField ID="txtQRCodeView" runat="server" Width="200" Disabled="true"></ext:TextField>
                                                                <ext:ImageButton ID="imbtnSearchQrCode" runat="server" ImageUrl="~/resources/images/Search.gif" OnClientClick="openQrCodeSearchDlg(#{cbUPN}.getValue(),#{cbLot}.getValue(),#{hiddenInitDealerId}.getValue(),null);"></ext:ImageButton>
                                                            </td>
                                                            
                                                            <td style="width: 140px;"><span class="red">*</span>产品批号（Lot）：</td>
                                                            <td>
                                                                <ext:TextField ID="cbLOT" runat="server" Width="200" FieldLabel="产品批号" Disabled="true" BlankText="请填写产品批号" />
                                                                <ext:Hidden ID="cbLOT_hid" runat="server"></ext:Hidden>
                                                                <%--<ext:ImageButton ID="cbLOT_search" runat="server" ImageUrl="~/resources/images/Search.gif" OnClientClick="openCfnSearchDlg('0',#{hiddenInitDealerId}.getValue(),null);"></ext:ImageButton>--%>
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>产品型号（UPN）：</td>
                                                            <td>
                                                                <ext:TextField ID="cbUPN" runat="server" Width="200" FieldLabel="产品型号" Disabled="true" />
                                                                <ext:Hidden ID="cbUPN_hid" runat="server"></ext:Hidden>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>首次手术日期：</td>
                                                            <td>
                                                                <ext:DateField ID="INITIALPDATE" runat="server" Width="200" AllowBlank="false" BlankText="请填写首次手术日期" MsgTarget="Side">
                                                                    <%--<Listeners>
                                                                        <Change Handler="BeginDateSYN();" />
                                                                    </Listeners>--%>
                                                                </ext:DateField>
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>事件发生日期：</td>
                                                            <td>
                                                                <ext:DateField ID="EDATE" runat="server" Width="200" AllowBlank="false" BlankText="请填写事件发生日期" MsgTarget="Side">
                                                                    <%-- <Listeners>
                                                                        <Change Handler="EventDateSYN();" />
                                                                    </Listeners>--%>
                                                                </ext:DateField>
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>蓝威人员接报日期：</td>
                                                            <td>
                                                                <ext:DateField ID="DateReceipt" runat="server" Width="200" AllowBlank="false" BlankText="蓝威人员接报日期" MsgTarget="Side" Disabled ="true">
                                                                </ext:DateField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>投诉号码：</td>
                                                            <td>
                                                                <ext:TextField ID="COMPLAINTID" runat="server" Width="200" Enabled="false" BlankText="填写投诉号码" FieldLabel="投诉号码" />

                                                            </td>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>收到返回产品登记号：</td>
                                                            <td>
                                                                <ext:TextField ID="REFERBOX" runat="server" Width="200" Enabled="false" BlankText="填写收到返回产品登记号" FieldLabel="收到返回产品登记号" />
                                                            </td>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>TW#编号：</td>
                                                            <td>
                                                                <ext:TextField ID="TW" runat="server" Width="200" FieldLabel="TW#编号" BlankText="填写TW#编号" Enabled="false" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>产品有效期:</td>
                                                            <td>
                                                                <ext:TextField ID="txtProductExpiredDate" runat="server" Width="200" Disabled="true"></ext:TextField>
                                                            </td>
                                                            <td style="width: 140px;">投诉单状态:</td>
                                                            <td>
                                                                <ext:TextField ID="txtComplainStatus" runat="server" Width="200" Disabled="true"></ext:TextField>
                                                                <ext:Hidden ID="hiddenCompalinStatus" runat="server"></ext:Hidden>
                                                            </td>
                                                            <td style="width: 140px;">单据号:</td>
                                                            <td>
                                                                <ext:TextField ID="txtComplainNo" Width="200" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>经销商:</td>
                                                            <td>
                                                                <ext:ComboBox ID="cbDealer" runat="server" Width="200" Editable="true" TypeAhead="false" Mode="Local"
                                                                    StoreID="DealerStore" ValueField="Id" DisplayField="ChineseShortName" ListWidth="300" Resizable="true" AllowBlank="false"
                                                                    BlankText="请选择经销商" EmptyText="请选择经销商">
                                                                    <Listeners>
                                                                        <TriggerClick Handler="this.clearValue();" />
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                        <Select Handler="ChangeDealer();" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </td>
                                                            
                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>
											                                            <ext:Panel ID="Panel3" Title="销售信息" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>是否是平台：</td>
                                                            <td style="">
                                                                <ext:RadioGroup ID="ISPLATFORM" runat="server" FieldLabel="是否是平台" BlankText="请选择是否是平台"
                                                                    AllowBlank="false" ReadOnly="True" FieldClass="x-item-disabled" noedit="TRUE" Width="250" MsgTarget="Side">
                                                                    <Items>
                                                                        <ext:Radio ID="ISPLATFORM_1" runat="server" BoxLabel="是" ReadOnly="True" cvalue="1"
                                                                            noedit="TRUE" />
                                                                        <ext:Radio ID="ISPLATFORM_2" runat="server" BoxLabel="否" Checked="true" ReadOnly="True" cvalue="2"
                                                                            noedit="TRUE" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>一级经销商账号：</td>
                                                            <td>
                                                                <ext:TextField ID="BSCSOLDTOACCOUNT" runat="server" Width="250" FieldLabel="一级经销商账号"
                                                                    Enabled="false" noedit="TRUE" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>一级经销商名称：</td>
                                                            <td>
                                                                <ext:TextField ID="BSCSOLDTONAME" runat="server" Width="250" FieldLabel="<font color='red'>*</font>一级经销商名称"
                                                                    AllowBlank="false" BlankText="一级经销商名称" Enabled="false" noedit="TRUE" MsgTarget="Side" />
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>一级经销商所在城市：</td>
                                                            <td>
                                                                <ext:TextField ID="BSCSOLDTOCITY" runat="server" Width="250" FieldLabel="<font color='red'>*</font>一级经销商所在城市"
                                                                    AllowBlank="false" BlankText="一级经销商所在城市" Enabled="true" noedit="TRUE" MsgTarget="Side" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>二级经销商名称：</td>
                                                            <td>
                                                                <ext:TextField ID="SUBSOLDTONAME" runat="server" Width="250" FieldLabel="二级经销商名称"
                                                                    Enabled="false" noedit="TRUE" />
                                                            </td>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>二级经销商所在城市：</td>
                                                            <td>
                                                                <ext:TextField ID="SUBSOLDTOCITY" runat="server" Width="250" FieldLabel="二级经销商所在城市"
                                                                    Enabled="false" noedit="TRUE" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>医院名称：</td>
                                                            <td>
                                                                <ext:TextField ID="DISTRIBUTORCUSTOMER" runat="server" Width="250" Cls="lightyellow-row" AllowBlank="false" ReadOnly="True" FieldClass="x-item-disabled"
                                                                    BlankText="请选择医院" MsgTarget="Side" FieldLabel="<font color='red'>*</font>请选择医院" />
                                                                <ext:ImageButton ID="imbtnSearchHospital" runat="server" ImageUrl="~/resources/images/Search.gif" OnClientClick="openHospitalSearchDlg('0',#{hiddenInitDealerId}.getValue(),null);"></ext:ImageButton>
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>医院所在城市：</td>
                                                            <td>
                                                                <ext:TextField ID="DISTRIBUTORCITY" runat="server" Width="250" FieldLabel="<font color='red'>*</font>医院所在城市" ReadOnly="True" FieldClass="x-item-disabled"
                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写医院所在城市" MsgTarget="Side" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>医院中文名称：</td>
                                                            <td>
                                                                <ext:TextField ID="etfHospitalName_China" runat="server" Width="250" EmptyText="" FieldLabel="医院中文名称" ReadOnly="True" FieldClass="x-item-disabled" />
                                                            </td>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>医院英文名称：</td>
                                                            <td>
                                                                <ext:TextField ID="etfHospitalName_USA" runat="server" Width="250" EmptyText="" FieldLabel="医院英文名称" ReadOnly="True" FieldClass="x-item-disabled" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>
                                            <ext:Panel ID="Panel2" Title="申请人详细信息" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="width: 140px;"><%--<span class="red">*</span--%>申请人：</td>
                                                            <td>
                                                                <ext:TextField ID="EID" runat="server" Width="200" Disabled="true" FieldLabel="请填写申请人" />
                                                            </td>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>申请日期：</td>
                                                            <td>
                                                                <ext:DateField ID="REQUESTDATE" runat="server" Width="200" Disabled="true" AllowBlank="false" BlankText="请填写申请日期"></ext:DateField>
                                                            </td>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>申请单编号：</td>
                                                            <td>
                                                                <ext:TextField ID="APPLYNO" runat="server" Width="200" Disabled="true" BlankText="申请单编号" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;">销售人员姓名：</td>
                                                            <td>
                                                                <%-- <ext:TextField ID="BSCSalesName" runat="server" Width="200" FieldLabel="<font color='red'>*</font>蓝威销售人员姓名"
                                                                    Enabled="true" noedit="false" Cls="lightyellow-row" AllowBlank="false" BlankText="请填写蓝威销售人员姓名"
                                                                    MsgTarget="Side" />--%>

                                                                <ext:ComboBox ID="CompletedName" runat="server" Width="200" Editable="true" TypeAhead="false" Mode="Local"
                                                                    StoreID="BscUserStore" ValueField="UserAccount" DisplayField="UserName" ListWidth="300" Resizable="true"
                                                                     EmptyText="BP销售,请先选择产品及医院">
                                                                    <Listeners>
                                                                        <BeforeQuery Fn="ComboxSelValue" />
                                                                        <Select Handler="#{hiddenBscUserId}.setValue(#{CompletedName}.getValue());" />
                                                                    </Listeners>
                                                                </ext:ComboBox>
                                                            </td>
                                                            <td style="width: 140px;">销售人员电话：</td>
                                                            <td>
                                                                <ext:TextField ID="BSCSalesPhone" runat="server" Width="200" 
                                                                    Enabled="true" Cls="lightyellow-row"
                                                                    MsgTarget="Side" />
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>原报告人职业：</td>
                                                            <td>
                                                                <ext:TextField ID="INITIALJOB" runat="server" Width="200" FieldLabel="<font color='red'>*</font>原报告人职业"
                                                                    AllowBlank="false" Enabled="true" BlankText="请填写原报告人职业" MsgTarget="Side" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>原报告人姓名：</td>
                                                            <td>
                                                                <ext:TextField ID="INITIALNAME" runat="server" Width="200" FieldLabel="<font color='red'>*</font>原报告人姓名"
                                                                    AllowBlank="false" Cls="lightyellow-row" MsgTarget="Side" BlankText="请填写原报告人姓名" />
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>原报告人电话：</td>
                                                            <td>
                                                                <ext:TextField ID="INITIALPHONE" runat="server" Width="200" FieldLabel="<font color='red'>*</font>原报告人电话"
                                                                    AllowBlank="false" Cls="lightyellow-row" MsgTarget="Side" BlankText="请填写原报告人电话" />
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>医生电话：</td>
                                                            <td>
                                                                <ext:TextField ID="PHYSICIANPHONE" runat="server" Width="200" FieldLabel="<font color='red'>*</font>医生电话"
                                                                    AllowBlank="false" MsgTarget="Side" Cls="lightyellow-row" BlankText="请填写医生电话" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>原报告人Email：</td>
                                                            <td>
                                                                <ext:TextField ID="INITIALEMAIL" runat="server" Width="200"
                                                                    MsgTarget="Side" AllowBlank="false" Cls="lightyellow-row" BlankText="请填写原报告人Email" FieldLabel="请填写原报告人Email" />
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>医生姓名：</td>
                                                            <td>
                                                                <ext:TextField ID="PHYSICIAN" runat="server" Width="200" FieldLabel="<font color='red'>*</font>医生姓名"
                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写医生姓名" MsgTarget="Side" />
                                                            </td>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>投诉通知日期：</td>
                                                            <td>
                                                                <ext:TextField ID="NOTIFYDATE" runat="server" Width="200" FieldLabel="投诉通知日期" Enabled="true" />
                                                            </td>
                                                        </tr>
                                                        <tr runat="server" style="display:none;">
                                                            <td style="width: 140px;" runat="server"><span class="red">*</span>是否有跟台：</td>
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
                                                            <td id="tdlblFollowOperationDate" runat="server" style="width: 140px;"><span class="red">*</span>跟台日期：</td>
                                                            <td id="tdFollowOperationDate" runat="server">
                                                                <ext:DateField ID="FollowOperationDate" runat="server" Width="183" AllowBlank="False" BlankText="请选择跟台日期"></ext:DateField>
                                                            </td>
                                                            <td id="tdlblFollowOperationStaff" runat="server" style="width: 140px;"><span class="red">*</span>跟台人员：</td>
                                                            <td id="tdFollowOperationStaff" runat="server">
                                                                <ext:RadioGroup ID="FollowOperationStaff" runat="server" AllowBlank="False">
                                                                    <Items>
                                                                        <ext:Radio ID="FollowOperationStaff_1" runat="server" BoxLabel="蓝威人员" cvalue="1" />
                                                                        <ext:Radio ID="FollowOperationStaff_2" runat="server" BoxLabel="代理商" cvalue="2" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>联系方式：</td>
                                                            <td colspan="3">
                                                                <ext:CheckboxGroup ID="CONTACTMETHOD" runat="server" FieldLabel="<font color='red'>*</font>请选择联系方式"
                                                                    AllowBlank="false" BlankText="请选择联系方式" ReadOnly="True" FieldClass="x-item-disabled" noedit="TRUE">
                                                                    <Items>
                                                                        <ext:Checkbox ID="CONTACTMETHOD_1" runat="server" BoxLabel="CNF" Checked="true" ReadOnly="True"
                                                                            cvalue="1" noedit="TRUE" />
                                                                        <ext:Checkbox ID="CONTACTMETHOD_2" runat="server" BoxLabel="电子 CNF" ReadOnly="True"
                                                                            cvalue="2" noedit="TRUE" />
                                                                        <ext:Checkbox ID="CONTACTMETHOD_3" runat="server" BoxLabel="电子邮件" ReadOnly="True"
                                                                            cvalue="3" noedit="TRUE" />
                                                                        <ext:Checkbox ID="CONTACTMETHOD_4" runat="server" BoxLabel="传真" ReadOnly="True"
                                                                            cvalue="4" noedit="TRUE" />
                                                                        <ext:Checkbox ID="CONTACTMETHOD_5" runat="server" BoxLabel="现场服务代表" ReadOnly="True"
                                                                            cvalue="5" noedit="TRUE" />
                                                                        <ext:Checkbox ID="CONTACTMETHOD_6" runat="server" BoxLabel="邮件" ReadOnly="True"
                                                                            cvalue="6" noedit="TRUE" />
                                                                        <ext:Checkbox ID="CONTACTMETHOD_7" runat="server" BoxLabel="电话" ReadOnly="True"
                                                                            cvalue="7" noedit="TRUE" />
                                                                        <ext:Checkbox ID="CONTACTMETHOD_8" runat="server" BoxLabel="语音邮件" ReadOnly="True"
                                                                            cvalue="8" noedit="TRUE" />
                                                                    </Items>
                                                                </ext:CheckboxGroup>
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>是否要求提供分析报告：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="NeedOfferAnalyzeReport" runat="server" AllowBlank="False" BlankText="请选择是否要求提供分析报告">
                                                                    <Items>
                                                                        <ext:Radio ID="NeedOfferAnalyzeReport_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                        <ext:Radio ID="NeedOfferAnalyzeReport_2" runat="server" BoxLabel="否" cvalue="2" Checked="true" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>投诉来源：</td>
                                                            <td colspan="4">
                                                                <ext:CheckboxGroup ID="COMPLAINTSOURCE" runat="server" FieldLabel="<font color='red'>*</font>请选择投诉来源"
                                                                    AllowBlank="false" BlankText="请选择投诉来源" ReadOnly="True" FieldClass="x-item-disabled" noedit="TRUE">
                                                                    <Items>
                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_1" runat="server" BoxLabel="公司代表" ReadOnly="True"
                                                                            cvalue="1" noedit="TRUE" />
                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_2" runat="server" BoxLabel="消费者" ReadOnly="True"
                                                                            cvalue="2" noedit="TRUE" />
                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_3" runat="server" BoxLabel="经销商" Checked="true" ReadOnly="True"
                                                                            cvalue="3" noedit="TRUE" />
                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_4" runat="server" BoxLabel="外部" ReadOnly="True"
                                                                            cvalue="4" noedit="TRUE" />
                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_5" runat="server" BoxLabel="医疗专家" ReadOnly="True"
                                                                            cvalue="5" noedit="TRUE" />
                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_6" runat="server" BoxLabel="文献资料" ReadOnly="True"
                                                                            cvalue="6" noedit="TRUE" />
                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_7" runat="server" BoxLabel="研究" ReadOnly="True"
                                                                            cvalue="7" noedit="TRUE" />
                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_8" runat="server" BoxLabel="用户设备" ReadOnly="True"
                                                                            cvalue="8" noedit="TRUE" />
                                                                        <ext:Checkbox ID="COMPLAINTSOURCE_9" runat="server" BoxLabel="其他 － 请说明" ReadOnly="True"
                                                                            cvalue="9" noedit="TRUE" />
                                                                    </Items>
                                                                </ext:CheckboxGroup>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>

                                            <ext:Panel ID="Panel4" Title="产品/批次信息" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;" Header="true" Collapsible="true">
                                                <Body>
                                                    <ext:Label runat="server"><span style="color: red; width: 100%;">如投诉产品为多包装产品，请确认产品处理方式是否为退货或退款。</span></ext:Label>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>UPN描述：</td>
                                                            <td>
                                                                <ext:TextField ID="DESCRIPTION" runat="server" Width="200" FieldLabel="UPN描述" Enabled="false" />
                                                                <ext:Hidden ID="hiddenDESCRIPTION" runat="server"></ext:Hidden>
                                                            </td>
                                                            <td style="width: 80px;"><%--<span class="red">*</span>--%>包装数：</td>
                                                            <td>
                                                                <ext:TextField ID="ConvertFactor" runat="server" Width="200" FieldLabel="UPN描述" Enabled="false" />
                                                                <ext:Hidden ID="hiddenConvertFactor" runat="server"></ext:Hidden>
                                                                <ext:Hidden ID="hiddenCFN_Property4" runat="server"></ext:Hidden>
                                                            </td>
                                                            <td style="width: 120px;"><span class="red">*</span>是否为一次性器械：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="SINGLEUSE" runat="server" FieldLabel="<font color='red'>*</font>是否为一次性器械"
                                                                    AllowBlank="true" Width="200" BlankText="请选择产品/批次信息中的是否为一次性器械" MsgTarget="Side">
                                                                    <Items>
                                                                        <ext:Radio ID="SINGLEUSE_1" runat="server" BoxLabel="是" Enabled="true" cvalue="1" Checked="true" />
                                                                        <ext:Radio ID="SINGLEUSE_2" runat="server" BoxLabel="否" Enabled="true" cvalue="2" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>UPN所属业务部门：</td>
                                                            <td>
                                                                <ext:TextField ID="BU" runat="server" Width="200" FieldLabel="UPN所属业务部门" Enabled="false" />
                                                                <ext:Hidden ID="hiddenBu" runat="server"></ext:Hidden>
                                                                <ext:Hidden ID="hiddenProductLineId" runat="server"></ext:Hidden>
                                                                <ext:Hidden ID="hiddenBuCode" runat="server"></ext:Hidden>
                                                            </td>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>产品数量：</td>
                                                            <td>
                                                                <ext:TextField ID="TBNUM" runat="server" Width="200" FieldLabel="产品数量（单位盒）" AllowBlank="true"
                                                                    Enabled="false" />
                                                                <ext:Hidden ID="hiddenTBNUM" runat="server"></ext:Hidden>
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>能否重复消毒：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="RESTERILIZED" runat="server" FieldLabel=""
                                                                    AllowBlank="true" BlankText="请选择产品/批次信息中的能否重复消毒" MsgTarget="Side" AutoWidth="true">
                                                                    <Items>
                                                                        <ext:Radio ID="RESTERILIZED_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                        <ext:Radio ID="RESTERILIZED_2" runat="server" Checked="true" BoxLabel="否" cvalue="2" />
                                                                        <ext:Radio ID="RESTERILIZED_3" runat="server" BoxLabel="不知道" cvalue="3" />
                                                                        <ext:Radio ID="RESTERILIZED_4" runat="server" BoxLabel="不适用" cvalue="4" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2"><%--<span class="red">*</span>--%>如果该器械经过再次处理后用户患者<br />
                                                                请填写进行再处理的单位的名称和地址：</td>
                                                            <td colspan="3">
                                                                <ext:TextField ID="PREPROCESSOR" runat="server" Width="400" FieldLabel="" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>是否在有效期后使用：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="USEDEXPIRY" runat="server" FieldLabel="<font color='red'>*</font>是否在有效期后使用"
                                                                    AllowBlank="true" BlankText="请选择产品/批次信息中的是否在有效期后使用" MsgTarget="Side" Width="220">
                                                                    <Items>
                                                                        <ext:Radio ID="USEDEXPIRY_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                        <ext:Radio ID="USEDEXPIRY_2" runat="server" Checked="true" BoxLabel="否" cvalue="2" />
                                                                        <ext:Radio ID="USEDEXPIRY_4" runat="server" BoxLabel="不适用" cvalue="4" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>产品能否退回：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="UPNEXPECTED" runat="server" FieldLabel="<font color='red'>*</font>产品能否退回"
                                                                    AllowBlank="true" BlankText="请选择产品/批次信息中的产品能否被退回" MsgTarget="Side" AutoWidth="true"
                                                                    Width="180">
                                                                    <Items>
                                                                        <ext:Radio ID="UPNEXPECTED_1" runat="server" BoxLabel="是" cvalue="1" AutoWidth="true">
                                                                            <Listeners>
                                                                                <Check Handler="CheckCNFFieldSpecial();" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="UPNEXPECTED_2" runat="server" BoxLabel="否" cvalue="2" AutoWidth="true">
                                                                            <Listeners>
                                                                                <Check Handler="CheckCNFFieldSpecial();" />
                                                                            </Listeners>
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>退回的数量：</td>
                                                            <td>
                                                                <ext:TextField ID="UPNQUANTITY" runat="server" Width="200"
                                                                    BlankText="请填写退回的数量"
                                                                    ReadOnly="True" FieldClass="x-item-disabled" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <table>
                                                                <tr>
                                                                    <td style="width: 140px;"><span class="red">*</span>不能寄回厂家的原因：</td>
                                                                    <td colspan="3">
                                                                        <ext:CheckboxGroup ID="NORETURN" runat="server" FieldLabel="<font color='red'>*</font>不能寄回厂家的原因"
                                                                            ColumnsNumber="6" AllowBlank="true" BlankText="请选择产品/批次信息中的不能寄回厂家的原因" MsgTarget="Side"
                                                                            AutoWidth="true">
                                                                            <Items>
                                                                                <ext:Checkbox ID="NORETURN_10" runat="server" BoxLabel="已污染" cvalue="10" />
                                                                                <ext:Checkbox ID="NORETURN_20" runat="server" BoxLabel="已丢弃" cvalue="20" />
                                                                                <ext:Checkbox ID="NORETURN_30" runat="server" BoxLabel="已植入" cvalue="30" />
                                                                                <ext:Checkbox ID="NORETURN_40" runat="server" BoxLabel="保留在医院" cvalue="40" />
                                                                                <ext:Checkbox ID="NORETURN_50" runat="server" BoxLabel="不适用" cvalue="50" ReadOnly="True" Cls="x-item-disabled"
                                                                                    noedit="TRUE" />
                                                                                <ext:Checkbox ID="NORETURN_99" runat="server" BoxLabel="其他 - 请说明" cvalue="99" />

                                                                            </Items>
                                                                        </ext:CheckboxGroup>

                                                                    </td>
                                                                    <td>
                                                                        <ext:TextField ID="etfOtherDec" runat="server" Width="200" EmptyText="" FieldLabel="其他 - 请说明" />
                                                                    </td>
                                                                </tr>
                                                            </table>

                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>
                                            <ext:Panel ID="Panel5" Title="患者信息" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;" Header="true" Collapsible="true">
                                                <Body>
                                                    <ext:Label runat="server"><span style="color: red; width: 100%;">患者标识码（ID）填写首字母缩写或其他标识信息，不要使用患者的姓名或SSN</span></ext:Label>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>患者标识（ID）：</td>
                                                            <td>
                                                                <ext:TextField ID="etfPatientID" runat="server" Width="200" FieldLabel="患者标识（ID）" />
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>事件发生时患者的年龄：</td>
                                                            <td>
                                                                <ext:TextField ID="etfOCCurPatientAge" runat="server" Width="200" AllowBlank="false" BlankText="请填写事件发生时患者的年龄" FieldLabel="事件发生时患者的年龄" />
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>年龄单位：</td>
                                                            <td>
                                                                <ext:TextField ID="etfAgeUint" runat="server" Width="200" AllowBlank="false" BlankText="请填写年龄单位" FieldLabel="年龄单位" Text="岁" ReadOnly="True" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>患者未满18岁：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="RadioGroupAdult" runat="server" FieldLabel="患者未满18岁"
                                                                    AllowBlank="true" BlankText="患者未满18岁" MsgTarget="Side" AutoWidth="true"
                                                                    Width="180">
                                                                    <Items>
                                                                        <ext:Radio ID="RadioGroupAdult_1" runat="server" BoxLabel="是" cvalue="1" AutoWidth="true">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="RadioGroupAdult_2" runat="server" BoxLabel="否" cvalue="2" AutoWidth="true">
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                            <td style="width: 140px;">患者出生日期：</td>
                                                            <td>
                                                                <ext:DateField ID="edfPatientBrithDate" runat="server" Width="200" AllowBlank="false" BlankText="请填写患者出生日期"></ext:DateField>
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>患者性别：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="RadioGroupGender" runat="server" FieldLabel="请选择患者性别"
                                                                    AllowBlank="false" BlankText="请选择患者性别" MsgTarget="Side" AutoWidth="true"
                                                                    Width="200">
                                                                    <Items>
                                                                        <ext:Radio ID="RadioGroupGender_1" runat="server" BoxLabel="男" cvalue="1" AutoWidth="true">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="RadioGroupGender_2" runat="server" BoxLabel="女" cvalue="2" AutoWidth="true">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="RadioGroupGender_3" runat="server" BoxLabel="未知" cvalue="3" AutoWidth="true">
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>患者体重：</td>
                                                            <td>
                                                                <ext:TextField ID="etfPatientWeight" runat="server" Width="200" AllowBlank="false" BlankText="请填写患者体重"></ext:TextField>
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>体重单位：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="RadioGroupWeightUint" runat="server" FieldLabel="请选择体重单位"
                                                                    AllowBlank="false" BlankText="请选择体重单位" MsgTarget="Side" AutoWidth="true"
                                                                    Width="200">
                                                                    <Items>
                                                                        <ext:Radio ID="RadioGroupWeightUint_1" runat="server" BoxLabel="磅" cvalue="1" AutoWidth="true">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="RadioGroupWeightUint_2" runat="server" BoxLabel="G" cvalue="2" AutoWidth="true">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="RadioGroupWeightUint_3" runat="server" BoxLabel="KG" cvalue="3" AutoWidth="true" Checked="true">
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioGroup>

                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>解剖部位/病变部位：</td>
                                                            <td colspan="3">
                                                                <ext:TextField ID="etfAnatomy" runat="server" Width="200" AllowBlank="False" BlankText="请填写解剖部位/病变部位" MsgTarget="Side"></ext:TextField>
                                                            </td>

                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>
                                            <ext:Panel ID="Panel6" Title="手术信息" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>手术名称：</td>
                                                            <td>
                                                                <ext:TextField ID="PNAME" runat="server" Width="200" FieldLabel="<font color='red'>*</font>请填写手术名称"
                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写手术名称" MsgTarget="Side" />
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>手术指征：</td>
                                                            <td>
                                                                <ext:TextField ID="INDICATION" runat="server" Width="200" FieldLabel="<font color='red'>*</font>请填写手术指征"
                                                                    AllowBlank="false" Cls="lightyellow-row" BlankText="请填写手术指征" MsgTarget="Side" />

                                                            </td>
                                                            <td></td>
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>植入日期（若有）：</td>
                                                            <td>
                                                                <ext:DateField ID="IMPLANTEDDATE" runat="server" Width="200" FieldLabel="植入日期（若有）" />
                                                            </td>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>移出日期（若有）：</td>
                                                            <td>
                                                                <ext:DateField ID="EXPLANTEDDATE" runat="server" Width="200" FieldLabel="移出日期（若有）" />
                                                            </td>
                                                            <td></td>
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>手术结果：</td>
                                                            <td colspan="5">
                                                                <ext:RadioGroup ID="POUTCOME" runat="server" FieldLabel="<font color='red'>*</font>手术结果"
                                                                    ColumnsNumber="7" AllowBlank="true" BlankText="请选择手术信息中的手术结果" MsgTarget="Side"
                                                                    AutoWidth="true">
                                                                    <Items>
                                                                        <ext:Radio ID="POUTCOME_1" runat="server" BoxLabel="使用此器械完成" cvalue="1" />
                                                                        <ext:Radio ID="POUTCOME_2" runat="server" BoxLabel="使用另一件相同器械完成" cvalue="2" />
                                                                        <ext:Radio ID="POUTCOME_3" runat="server" BoxLabel="使用其他器械完成" cvalue="3" />
                                                                        <ext:Radio ID="POUTCOME_4" runat="server" BoxLabel="由于此事件而未能完成" cvalue="4" />
                                                                        <ext:Radio ID="POUTCOME_5" runat="server" BoxLabel="由于缺乏相同器械而未能完成" cvalue="5" />
                                                                        <ext:Radio ID="POUTCOME_6" runat="server" BoxLabel="由于其他原因而未能完成" cvalue="6" />
                                                                        <ext:Radio ID="POUTCOME_99" runat="server" BoxLabel="不清楚" cvalue="99" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>是否使用了IVUS：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="IVUS" runat="server" FieldLabel="是否使用了IVUS" Width="200">
                                                                    <Items>
                                                                        <ext:Radio ID="IVUS_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                        <ext:Radio ID="IVUS_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                            <td></td>
                                                            <td></td>
                                                            <td></td>
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>是否使用了电刀：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="GENERATOR" runat="server" FieldLabel="是否使用了电刀" Width="200">
                                                                    <Items>
                                                                        <ext:Radio ID="GENERATOR_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                        <ext:Radio ID="GENERATOR_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>电刀类型说明：</td>
                                                            <td>
                                                                <ext:TextField ID="GENERATORTYPE" runat="server" Width="200" FieldLabel="电刀类型说明" />
                                                            </td>
                                                            <td style="width: 140px;"><%--<span class="red">*</span>--%>电刀设置：</td>
                                                            <td>
                                                                <ext:TextField ID="GENERATORSET" runat="server" Width="200" FieldLabel="电刀设置" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>患者术后状况如何：</td>
                                                            <td colspan="5">
                                                                <ext:RadioGroup ID="PCONDITION" runat="server" FieldLabel="<font color='red'>*</font>患者术后状况如何"
                                                                    AllowBlank="true" BlankText="请选择手术信息中的患者手术后状况" MsgTarget="Side" AutoWidth="true">
                                                                    <Items>
                                                                        <ext:Radio ID="PCONDITION_1" runat="server" BoxLabel="稳定" cvalue="1" />
                                                                        <ext:Radio ID="PCONDITION_2" runat="server" BoxLabel="接受手术治疗" cvalue="2" />
                                                                        <ext:Radio ID="PCONDITION_3" runat="server" BoxLabel="死亡" cvalue="3" />
                                                                        <ext:Radio ID="PCONDITION_99" runat="server" BoxLabel="其他" cvalue="99" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>
                                            <ext:Panel ID="Panel7" Title="事件信息" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>问题发生在什么位置：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="WHEREOCCUR" runat="server" FieldLabel="<font color='red'>*</font>问题发生在什么位置"
                                                                    AllowBlank="false" BlankText="请选择事件信息中的问题发生在什么位置" MsgTarget="Side" AutoWidth="true">
                                                                    <Items>
                                                                        <ext:Radio ID="WHEREOCCUR_1" runat="server" BoxLabel="患者体内" cvalue="1" />
                                                                        <ext:Radio ID="WHEREOCCUR_2" runat="server" BoxLabel="患者体外" cvalue="2" />
                                                                        <ext:Radio ID="WHEREOCCUR_80" runat="server" BoxLabel="不适用" cvalue="80" />
                                                                        <ext:Radio ID="WHEREOCCUR_99" runat="server" BoxLabel="不清楚" cvalue="99" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>发现问题的时间：</td>
                                                            <td>
                                                                <ext:CheckboxGroup ID="WHENNOTICED" runat="server" FieldLabel="<font color='red'>*</font>发现问题的时间"
                                                                    AllowBlank="false" BlankText="请选择事件信息中的发现问题的时间" MsgTarget="Side" AutoWidth="true">
                                                                    <Items>
                                                                        <ext:Checkbox ID="WHENNOTICED_1" runat="server" BoxLabel="打开包装时" cvalue="1" />
                                                                        <ext:Checkbox ID="WHENNOTICED_2" runat="server" BoxLabel="准备手术时" cvalue="2" />
                                                                        <ext:Checkbox ID="WHENNOTICED_3" runat="server" BoxLabel="插入时" cvalue="3" />
                                                                        <ext:Checkbox ID="WHENNOTICED_4" runat="server" BoxLabel="手术过程中" cvalue="4" />
                                                                        <ext:Checkbox ID="WHENNOTICED_5" runat="server" BoxLabel="退出时" cvalue="5" />
                                                                        <ext:Checkbox ID="WHENNOTICED_6" runat="server" BoxLabel="手术结束时" cvalue="6" />
                                                                        <ext:Checkbox ID="WHENNOTICED_7" runat="server" BoxLabel="术后" cvalue="7" />
                                                                        <ext:Checkbox ID="WHENNOTICED_99" runat="server" BoxLabel="不清楚" cvalue="99" />
                                                                    </Items>
                                                                </ext:CheckboxGroup>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>事件描述：</td>
                                                            <td>
                                                                <ext:TextField ID="EDESCRIPTION" runat="server" Width="800" FieldLabel="<font color='red'>*</font>事件描述"
                                                                    AllowBlank="true" Cls="lightyellow-row" BlankText="请填写时间描述" MsgTarget="Side" />
                                                            </td>
                                                        </tr>

                                                        
                                                        <tr>
                                                           <td style="width: 140px;">
                                                               <ext:Label ID="lblStents" Width="140" runat="server" Text="*请判断支架是否仅无法通过病变,不存在其他问题：" Hidden="true">  </ext:Label>
                                                            </td>
                                                            <td>
                                                                <ext:RadioGroup ID="NoProblemButLesionNotPass" runat="server" Hidden="true"
                                                                    AllowBlank="false" BlankText="请选择请判断支架是否仅无法通过病变,不存在其他问题" MsgTarget="Side" Width="180">
                                                                    <Items>
                                                                        <ext:Radio ID="NoProblemButLesionNotPass_1" runat="server" BoxLabel="是" cvalue="1">
                                                                            <%--                                                                            <Listeners>
                                                                                <Check Handler="isNoProblemButLesionNotPass();" />
                                                                            </Listeners>--%>
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="NoProblemButLesionNotPass_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                               
                                                        </tr>

                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>是在按标示使用器械的<br />
                                                                情况下发生该问题的吗：</td>
                                                            <td>
                                                                <table>
                                                                    <tr>
                                                                        <td style="width: 200px;">
                                                                            <ext:RadioGroup ID="WITHLABELEDUSE" runat="server" FieldLabel="<font color='red'>*</font>是在按标示使用器械的<br />情况下发生该问题的吗"
                                                                                AllowBlank="false" BlankText="请选择事件信息中的是在按标示使用器械的情况下发生该问题的吗" MsgTarget="Side"
                                                                                AutoWidth="true">
                                                                                <Items>
                                                                                    <ext:Radio ID="WITHLABELEDUSE_1" runat="server" BoxLabel="是" cvalue="1" Checked="true">
                                                                                        <Listeners>
                                                                                            <Check Handler="withLabelUserCheck();"></Check>
                                                                                        </Listeners>
                                                                                    </ext:Radio>
                                                                                    <ext:Radio ID="WITHLABELEDUSE_2" runat="server" BoxLabel="否" cvalue="2">
                                                                                        <Listeners>
                                                                                            <Check Handler="withLabelUserCheck();"></Check>
                                                                                        </Listeners>
                                                                                    </ext:Radio>
                                                                                </Items>
                                                                            </ext:RadioGroup>
                                                                        </td>
                                                                        <td id="tdlblNOLABELEDUSE" runat="server" style="width: 140px;">如果不是，请解释：</td>
                                                                        <td id="tdNOLABELEDUSE" runat="server">
                                                                            <ext:TextField ID="NOLABELEDUSE" runat="server" Width="200" FieldLabel="如果不是，请解释" />
                                                                        </td>

                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>事情是否已解决：</td>
                                                            <td>
                                                                <ext:RadioGroup ID="EVENTRESOLVED" runat="server" FieldLabel="<font color='red'>*</font>事情是否已解决"
                                                                    AllowBlank="false" BlankText="请选择事件信息中的事情是否已解决" MsgTarget="Side" Width="180">
                                                                    <Items>
                                                                        <ext:Radio ID="EVENTRESOLVED_1" runat="server" BoxLabel="是" cvalue="1" />
                                                                        <ext:Radio ID="EVENTRESOLVED_2" runat="server" BoxLabel="否" cvalue="2" />
                                                                        <ext:Radio ID="EVENTRESOLVED_5" runat="server" BoxLabel="不清楚" cvalue="5" />
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </Body>
                                            </ext:Panel>
                                            <ext:Panel ID="Panel8" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="医生尝试处理事件的行动" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%; border: solid 1px #99bbe8; padding: 5px;">
                                                        <tr>
                                                            <td>
                                                                <ext:Checkbox ID="Pulse_1" runat="server" BoxLabel="观察"
                                                                    cvalue="1" />
                                                            </td>
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="1">
                                                                <ext:Checkbox ID="Pulse_2" runat="server" BoxLabel="手术治疗（请说明）"
                                                                    cvalue="2">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Pulse_2');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="etfSurgeryDesc" Hidden="true" runat="server" Width="250" BlankText="请说明手术治疗" EmptyText="请说明手术治疗" FieldLabel="请说明手术治疗" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="1">
                                                                <ext:Checkbox ID="Pulse_3" runat="server" BoxLabel="住院或延长住院时间（请说明住院时间/原因）"
                                                                    cvalue="3">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Pulse_3');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="etfInPatientDesc" Hidden="true" runat="server" Width="250" BlankText="请说明住院时间和原因" EmptyText="请说明住院时间和原因" FieldLabel="请说明住院时间和原因" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="1">
                                                                <ext:Checkbox ID="Pulse_4" runat="server" BoxLabel="药物治疗 （请说明）"
                                                                    cvalue="4">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Pulse_4');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="etfMedicationDesc" Hidden="true" runat="server" Width="250" BlankText="请说明药物治疗" EmptyText="请说明药物治疗" FieldLabel="请说明药物治疗" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="1">
                                                                <ext:Checkbox ID="Pulse_5" runat="server" BoxLabel="取出器材"
                                                                    cvalue="5" />
                                                            </td>
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="1">
                                                                <ext:Checkbox ID="Pulse_6" runat="server" BoxLabel="输血/血液制品（请说明）"
                                                                    cvalue="6">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Pulse_6');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="etfBloodDesc" Hidden="true" runat="server" Width="250" EmptyText="请说明输血/血液制品" BlankText="请说明输血/血液制品" FieldLabel="请说明输血/血液制品" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="1">
                                                                <ext:Checkbox ID="Pulse_7" runat="server" BoxLabel="其他介入治疗（请说明）"
                                                                    cvalue="7">
                                                                    <Listeners>
                                                                        <Check Handler="showTextBoxWhenChecked('Pulse_7');" />
                                                                    </Listeners>
                                                                </ext:Checkbox>
                                                            </td>
                                                            <td>
                                                                <ext:TextField ID="etfOtherTreatDesc" Hidden="true" runat="server" Width="250" EmptyText="请说明其他介入治疗" BlankText="请说明其他介入治疗" FieldLabel="请说明其他介入治疗" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="1">
                                                                <ext:Checkbox ID="Pulse_8" runat="server" BoxLabel="无" cvalue="8" />
                                                            </td>
                                                            <td></td>
                                                        </tr>
                                                    </table>
                                                    <br />
                                                    <br />

                                                </Body>
                                            </ext:Panel>
                                            <ext:Panel ID="Panel9" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="该事件对患者造成的后果" Header="true" Collapsible="true">
                                                <Body>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <ext:RadioGroup ID="Consequence" runat="server">
                                                                <Items>
                                                                    <ext:Radio ID="Dead_1" runat="server" BoxLabel="死亡" cvalue="1">
                                                                        <Listeners>
                                                                            <Check Handler="isDeathCheck('Dead_1');" />
                                                                        </Listeners>
                                                                    </ext:Radio>
                                                                    <ext:Radio ID="Dead_2" runat="server" BoxLabel="未严重受伤" cvalue="2">
                                                                        <Listeners>
                                                                            <Check Handler="isDeathCheck('Dead_2');" />
                                                                        </Listeners>
                                                                    </ext:Radio>
                                                                    <ext:Radio ID="Dead_3" runat="server" BoxLabel="严重受伤" cvalue="3">
                                                                        <Listeners>
                                                                            <Check Handler="isDeathCheck('Dead_3');" />
                                                                        </Listeners>
                                                                    </ext:Radio>
                                                                    <ext:Radio ID="Dead_4" runat="server" BoxLabel="某项身体机能永久受损" cvalue="4">
                                                                        <Listeners>
                                                                            <Check Handler="isDeathCheck('Dead_4');" />
                                                                        </Listeners>
                                                                    </ext:Radio>
                                                                    <ext:Radio ID="Dead_5" runat="server" BoxLabel="不清楚" cvalue="5">
                                                                    </ext:Radio>
                                                                    <ext:Radio ID="Dead_6" runat="server" BoxLabel="无" cvalue="6"></ext:Radio>
                                                                </Items>
                                                            </ext:RadioGroup>
                                                        </tr>
                                                    </table>
                                                    <table id="conseDI" style="width: 100%;">
                                                        <tr id="tr1" runat="server">
                                                            <td style="width: 140px;"><font color='red'>*</font>死亡日期</td>
                                                            <td style="width: 250px;">
                                                                <ext:DateField ID="edtDeadDate" Width="150" runat="server" AllowBlank="true" BlankText="死亡日期"></ext:DateField>
                                                            </td>
                                                            <td style="width: 140px;">如果是死亡请提供尸检报告/尸检证明</td>
                                                            <td style="width: 250px;">
                                                                <ext:RadioGroup ID="RadioGroupPostmortem" runat="server" FieldLabel="<font color='red'>*</font>如果是死亡请提供尸检报告/尸检证明"
                                                                    AllowBlank="true" BlankText="如果是死亡请提供尸检报告/尸检证明" MsgTarget="Side" AutoWidth="true">
                                                                    <Items>
                                                                        <ext:Radio ID="Postmortem_1" runat="server" BoxLabel="是" cvalue="1" AutoWidth="true">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="Postmortem_2" runat="server" BoxLabel="否" cvalue="2" AutoWidth="true">
                                                                        </ext:Radio>
                                                                    </Items>

                                                                </ext:RadioGroup>
                                                            </td>
                                                        </tr>
                                                        <tr id="tr2" runat="server">
                                                            <td colspan="4">
                                                                <ext:TextField ID="NotSeriousRemark" runat="server" Width="400" EmptyText="请说明未严重受伤" FieldLabel="请说明未严重受伤" />
                                                            </td>
                                                        </tr>
                                                        <tr id="tr3" runat="server">
                                                            <td colspan="4">
                                                                <ext:TextField ID="SeriousRemark" runat="server" Width="400" EmptyText="请说明严重受伤" FieldLabel="请说明严重受伤" />
                                                            </td>
                                                        </tr>
                                                        <tr id="tr4" runat="server">
                                                            <td colspan="4">
                                                                <ext:TextField ID="PermanentDamageRemark" runat="server" Width="400" EmptyText="请说明某项身体机能永久受损" FieldLabel="请说明某项身体机能永久受损" />
                                                            </td>
                                                        </tr>
                                                        <%-- <tr id="tr5" runat="server" style="display:none;">
                                                            <td colspan="4">
                                                                <ext:TextField ID="TextField1" runat="server" Width="400" EmptyText="请说明不清楚" FieldLabel="请说明不清楚" />
                                                            </td>
                                                        </tr>--%>
                                                    </table>

                                                    <br />
                                                    <br />

                                                </Body>
                                            </ext:Panel>
                                            <ext:Panel ID="Panel13" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px;"
                                                Title="投诉单附件" Header="true" Collapsible="true">
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
                                                                                <Click Handler="#{hiddenAttachmentUpload}.setValue('DealerComplainCNF');#{AttachmentWindow}.show();#{FileUploadField1}.setValue('');" />
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
                                                                                            Coolite.AjaxMethods.DeleteAttachment('DealerComplainCNF',record.data.Id,record.data.Url,{
                                                                                                success: function() {
                                                                                                    Ext.Msg.alert('Message', '删除附件成功！');
                                                                                                    #{gpAttachment}.reload();
                                                                                                },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                        }
                                                                                    });
                                                                            }
                                                                            else if (command == 'DownLoad')
                                                                            {
                                                                                var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=DealerComplainCNF';
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
                                    <ext:Panel ID="returnPanel" runat="server" BodyStyle="background-color: #D9E7F8;padding:10px 5px;" BodyBorder="true"
                                        Title="填写投诉退货关键信息" Header="true" Collapsible="true" AutoHeight="true">
                                        <Body>
                                            <ext:Panel ID="Panel14" runat="server" Title="产品信息" Header="true"
                                                BodyBorder="true" Collapsible="true" BodyStyle="background-color: #D9E7F8;padding:10px 0;">
                                                <Body>
                                                    <table style="width: 100%;">
                                                        <tr>

                                                            <td style="width: 140px;"><span class="red">*</span>产品批号(SN):</td>
                                                            <td style="">
                                                                <ext:TextField ID="txtLotNumber" Width="250" runat="server" Disabled="true"></ext:TextField>
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>产品有效期:</td>
                                                            <td>
                                                                <ext:TextField ID="UPNExpDate" Width="250" runat="server" Disabled="true"></ext:TextField>
                                                                <ext:Hidden ID="hiddenExpiredDate" runat="server"></ext:Hidden>
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>二维码:</td>
                                                            <td style="">
                                                                <ext:TextField ID="txtQrCode" Width="250" runat="server" Disabled="true" BlankText="请选择二维码"></ext:TextField>
                                                                <ext:Hidden ID="hiddenQrCode" runat="server"></ext:Hidden>
                                                                <%--<ext:ImageButton ID="imbtnSearchQrCode" runat="server" ImageUrl="~/resources/images/Search.gif" OnClientClick="openQrCodeSearchDlg(#{cbUPN}.getValue(),#{cbLot}.getValue(),#{hiddenInitDealerId}.getValue(),null);"></ext:ImageButton>--%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;"><span class="red">*</span>注册证:</td>
                                                            <td>
                                                                <ext:TextField ID="txtRegistration" Width="250" runat="server" Disabled="true"></ext:TextField>
                                                            </td>

                                                            <td style="width: 140px;"><span class="red">*</span>仓库:</td>
                                                            <td>
                                                                <ext:TextField ID="cbWarehouse" runat="server" Width="250" Disabled="true" BlankText="请选择仓库"></ext:TextField>
                                                                <ext:Hidden ID="hiddenWarehouseId" runat="server"></ext:Hidden>
                                                            </td>
                                                            <td style="width: 140px;"><span class="red">*</span>销售日期:</td>
                                                            <td>
                                                                <ext:DateField ID="SalesDate" runat="server" FieldLabel="销售日期" Width="250" AllowBlank="false" BlankText="请选择销售日期"></ext:DateField>
                                                                <ext:Hidden ID="hiddenHasSalesDate" runat="server"></ext:Hidden>
                                                                <ext:Hidden ID="hiddenSalesDate" runat="server"></ext:Hidden>
                                                            </td>
                                                        </tr>
                                                        <tr>

                                                            <td>蓝威DN号码:</td>
                                                            <td>
                                                                <ext:TextField ID="DNNo" runat="server" Width="250" FieldLabel="蓝威DN号码" AllowBlank="true" Disabled="true" noedit="TRUE" />
                                                            </td>
                                                            <td>快递单号:</td>
                                                            <td>
                                                                <ext:TextField ID="CarrierNumber" runat="server" Width="250" FieldLabel="快递单号" Disabled="true"  />
                                                            </td>
                                                            <td>退货单状态:</td>
                                                            <td>
                                                                <ext:Hidden ID="hiddenReturnStatus" runat="server"></ext:Hidden>
                                                                <ext:TextField ID="txtReturnStatus" runat="server" Disabled="true" Width="250"></ext:TextField>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>快递公司:</td>
                                                            <td>
                                                                <ext:TextField ID="CourierCompany" runat="server" Width="250" Disabled="true" ></ext:TextField>
                                                            </td>
                                                            <td>备注:</td>
                                                            <td>
                                                                <ext:TextField ID="Remark" runat="server" Width="250" FieldLabel="备注" AllowBlank="true" />
                                                            </td>
                                                            <td></td>
                                                            <td></td>
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
                                                            <td colspan="3" style="">
                                                                <ext:RadioGroup ID="PRODUCTTYPE" runat="server" FieldLabel="<font color='red'>*</font>产品类型"
                                                                    AllowBlank="true" AutoWidth="true" BlankText="请选择【销售情况】中的【产品类型】" ColumnsNumber="3" ReadOnly="True" FieldClass="x-item-disabled">
                                                                    <Items>
                                                                        <ext:Radio ID="PRODUCTTYPE_8" runat="server" BoxLabel="市场部/销售部样品" cvalue="8" ReadOnly="True">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="PRODUCTTYPE_9" runat="server" BoxLabel="临床试验用的样品" cvalue="9" ReadOnly="True">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="PRODUCTTYPE_10" runat="server" BoxLabel="新技术应用的样品" cvalue="10" ReadOnly="True">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="PRODUCTTYPE_11" runat="server" BoxLabel="销售员(SRAI)/工程师(FSEAI)" cvalue="11" ReadOnly="True">
                                                                        </ext:Radio>
                                                                        <%--                                                                        <ext:Radio ID="PRODUCTTYPE_12" runat="server" BoxLabel="机器/机器配件" cvalue="12" ReadOnly="True">
                                                                        </ext:Radio>--%>
                                                                        <ext:Radio ID="PRODUCTTYPE_13" runat="server" BoxLabel="综合: 平台物权、T1物权、T2物权、医院物权、蓝威物权" cvalue="13" ReadOnly="True">
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                            <td>物权类型:</td>
                                                            <td>
                                                                <ext:TextField ID="PropertyRights" runat="server" Width="250" ReadOnly="True" FieldClass="x-item-disabled" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;">收到返回产品登记号:</td>
                                                            <td>
                                                                <ext:TextField ID="ReturnProductRegisterNo" runat="server" Disabled="true" Width="250"></ext:TextField>
                                                            </td>
                                                            <td style="width: 140px;">返回原厂运单号:</td>
                                                            <td>
                                                                <ext:TextField ID="ReturnFactoryTrackingNo" runat="server" Width="250" ReadOnly="True" FieldClass="x-item-disabled" />
                                                            </td>
                                                            <td>产品退货或换货:</td>
                                                            <td>
                                                                <ext:ComboBox ID="RETURNTYPE" runat="server" Editable="false" Enabled="False" Width="250"
                                                                    TypeAhead="true" BlankText="请选择产品换货或退款" AllowBlank="false">
                                                                    <Items>
                                                                        <ext:ListItem Text="换货" Value="10" />
                                                                        <ext:ListItem Text="退款" Value="11" />
                                                                        <ext:ListItem Text="仅上报投诉，只退不换" Value="12" />
                                                                    </Items>
                                                                </ext:ComboBox>
                                                                <ext:Hidden ID="hiddenRETURNTYPE" runat="server"></ext:Hidden>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 140px;">是否收到实物退货:</td>
                                                            <td>
                                                                <ext:RadioGroup ID="ReceiveReturnedGoods" runat="server" BlankText="请选择是否收到实物退货" ReadOnly="True" FieldClass="x-item-disabled">
                                                                    <Items>
                                                                        <ext:Radio ID="ReceiveReturnedGoods_1" runat="server" BoxLabel="是" cvalue="1" ReadOnly="True">
                                                                        </ext:Radio>
                                                                        <ext:Radio ID="ReceiveReturnedGoods_2" runat="server" BoxLabel="否" cvalue="2" ReadOnly="True">
                                                                        </ext:Radio>
                                                                    </Items>
                                                                </ext:RadioGroup>
                                                            </td>
                                                            <td style="width: 140px;">收到日期:</td>
                                                            <td>
                                                                <ext:DateField ID="ReceiveReturnedGoodsDate" runat="server" FieldLabel="收到日期" Width="250" BlankText="请选择收到日期" Enabled="False"></ext:DateField>
                                                            </td>
                                                            <td>蓝威确认产品换货或退款:</td>
                                                            <td>
                                                                <ext:ComboBox ID="ConfirmReturnOrRefund" runat="server" Editable="false" Enabled="False" Width="250"
                                                                    TypeAhead="true" BlankText="" AllowBlank="false">
                                                                    <Items>
                                                                        <ext:ListItem Text="换货" Value="10" />
                                                                        <ext:ListItem Text="退款" Value="11" />
                                                                        <ext:ListItem Text="仅上报投诉，只退不换" Value="12" />
                                                                    </Items>
                                                                </ext:ComboBox>
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
                                                                                <Click Handler="#{hiddenAttachmentUpload}.setValue('DealerComplainCNFRtn');#{AttachmentWindow}.show();#{FileUploadField1}.setValue('');" />
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
                                                                                            Coolite.AjaxMethods.DeleteAttachment('DealerComplainCNFRtn',record.data.Id,record.data.Url,{
                                                                                                success: function() {
                                                                                                    Ext.Msg.alert('Message', '删除附件成功！');
                                                                                                    #{gpAttachment_Return}.reload();
                                                                                                },failure: function(err) {Ext.Msg.alert('Error', err);}});
                                                                                        }
                                                                                    });
                                                                            }
                                                                            else if (command == 'DownLoad')
                                                                            {
                                                                                var url = '../Download.aspx?downloadname=' + escape(record.data.Name) + '&filename=' + escape(record.data.Url) + '&downtype=DealerComplainCNFRtn';
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
                                </Body>
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
                                            <Click Handler="CheckCNFSubmit();" />
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
                                    <ext:Button ID="btnCarrierCancel" runat="server" Text="取消" Icon="Delete">
                                        <Listeners>
                                            <Click Handler="window.parent.closeTab('subMenu' + Ext.getCmp('hidInstanceId').getValue());" />
                                        </Listeners>
                                    </ext:Button>
                                </Buttons>
                                <LoadMask ShowMask="true" />
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
                                    Success="Ext.Msg.alert('信息','上传成功！');if (#{hiddenAttachmentUpload}.getValue()=='DealerComplainCNFRtn') #{gpAttachment_Return}.reload(); else #{gpAttachment}.reload(); #{FileUploadField1}.setValue('');">
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
                <Hide Handler="if (#{hiddenAttachmentUpload}.getValue()=='DealerComplainCNFRtn') #{gpAttachment_Return}.reload(); else #{gpAttachment}.reload();" />
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
