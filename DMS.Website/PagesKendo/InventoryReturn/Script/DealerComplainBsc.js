var DealerComplainBsc = {};

DealerComplainBsc = function () {
    var that = {};

    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;

        return model;
    }

    that.InitPage = function () {
        $('#ForwardUrl').val($.getUrlParam('ReturnUrl'));

        $('#BtnSave').FrameButton({
            onClick: that.DoSave
        });
        $('#BtnClose').FrameButton({
            onClick: function () {
                window.location.href = $('#ForwardUrl').val();
            }
        });

        $('#ComplainId').val($.getUrlParam('formInstanceId'));

        $('#ComplainType').val('');

        $('#COMPLAINTID').FrameTextBox({
            value: ''
        });
        $('#TW').FrameTextBox({
            value: ''
        });
        $('#PI').FrameTextBox({
            value: ''
        });
        $('#IAN').FrameTextBox({
            value: ''
        });
        $('#RN').FrameTextBox({
            value: ''
        });
        $('#ReturnFactoryTrackingNo').FrameTextBox({
            value: ''
        });
        $('#ReceiveReturnedGoods').FrameDropdownList({
            dataSource: [{ Key: '1', Value: '是' }, { Key: '2', Value: '否' }],
            dataKey: 'Key',
            dataValue: 'Value',
            selectType: 'select'
        });
        $('#ReceiveReturnedGoodsDate').FrameDatePicker({
            depth: "year",
            start: "year",
            format: "yyyy-MM-dd",
            value: ''
        });
        $('#ConfirmReturnOrRefundCNF').FrameDropdownList({
            dataSource: [{ Key: '10', Value: '换货' }, { Key: '11', Value: '退款' }, { Key: '12', Value: '仅上报投诉，只退不换' }],
            dataKey: 'Key',
            dataValue: 'Value',
            selectType: 'select'
        });
        $('#ConfirmReturnOrRefundCRM').FrameDropdownList({
            dataSource: [{ Key: '1', Value: '换货' }, { Key: '2', Value: '退款' }, { Key: '5', Value: '仅上报投诉，只退不换' }],
            dataKey: 'Key',
            dataValue: 'Value',
            selectType: 'select'
        });
        $('#RGA').FrameTextBox({
            value: ''
        });
        $('#Invoice').FrameTextBox({
            value: ''
        });
        $('#DN').FrameTextBox({
            value: ''
        });

        $('#divReturnHtml').html('');

        showLoading();

        var data = that.GetModel('InitPage');
        submitAjax(Common.AppVirtualPath + "PagesKendo/InventoryReturn/Handler/DealerComplainBscHandler.ashx", data, function (model) {
            $("#BtnSave").css("display", "");

            $('#ComplainType').val(model.ComplainType);

            if (model.ComplainType == "CRM") {
                $(".CNF").css("display", "none");

                $('#PI').FrameTextBox({
                    value: model.PI
                });
                $('#IAN').FrameTextBox({
                    value: model.IAN
                });

                $('#ConfirmReturnOrRefundCRM').FrameDropdownList('setValue',model.ConfirmReturnOrRefundCRM);
            } else if (model.ComplainType == "CNF") {
                $(".CRM").css("display", "none");

                $('#COMPLAINTID').FrameTextBox({
                    value: model.COMPLAINTID
                });

                $('#TW').FrameTextBox({
                    value: model.TW
                });

                $('#ReturnFactoryTrackingNo').FrameTextBox({
                    value: model.ReturnFactoryTrackingNo
                });

                $('#ReceiveReturnedGoods').FrameDropdownList('setValue', model.ReceiveReturnedGoods);

                $('#ReceiveReturnedGoodsDate').FrameDatePicker({
                    depth: "date",
                    start: "date",
                    format: "yyyy-MM-dd",
                    value: model.ReceiveReturnedGoodsDate
                });

                $('#ConfirmReturnOrRefundCNF').FrameDropdownList('setValue',model.ConfirmReturnOrRefundCNF);
            }

            $('#RN').FrameTextBox({
                value: model.RN
            });
            $('#RGA').FrameTextBox({
                value: model.RGA
            });
            $('#Invoice').FrameTextBox({
                value: model.Invoice
            });
            $('#DN').FrameTextBox({
                value: model.DN
            });
           
            $('#LastUpdateTime').val(model.LastUpdateTime);
            $("#divReturnHtml").append(model.HtmlString);

            checkAuth(model);

            setLayout();

            hideLoading();
        });
    }

    that.DoSave = function () {
        showLoading();

        var data = that.GetModel('DoSave');
        submitAjax(Common.AppVirtualPath + "PagesKendo/InventoryReturn/Handler/DealerComplainBscHandler.ashx", data, function (model) {

            showAlert({
                target: 'top',
                alertType: 'info',
                message: '保存成功！',
                callback: function () {
                    window.location.href = $('#ForwardUrl').val();
                }
            });

            $("#BtnSave").css("display", "");

            $('#LastUpdateTime').val(model.LastUpdateTime);
            $("#divReturnHtml").html('');
            $("#divReturnHtml").append(model.HtmlString);

            checkAuth(model.CurrentNodeIds);

            setLayout();

            hideLoading();
        });
    }

    var initColumnLayout = function () {
    }

    var setLayout = function () {
        var h = $('.content-main').height();
    }

    var checkAuth = function (model) {

        clearControlStatus();

        var isStep1 = false;
        var isStep2 = false;
        var isStep3 = false;
        var isStep4 = false;

        if (model.CurrentNodeIds != null && model.CurrentNodeIds != '') {
            if ($.inArray('N17', model.CurrentNodeIds.split(',')) >= 0) {
                isStep1 = true;
            }
            else if ($.inArray('N24', model.CurrentNodeIds.split(',')) >= 0) {
                isStep2 = true;
            }
            else if ($.inArray('N15', model.CurrentNodeIds.split(',')) >= 0) {
                isStep3 = true;
            }
            else if ($.inArray('N16', model.CurrentNodeIds.split(',')) >= 0) {
                isStep4 = true;
            }
        }
        
        if (isStep1) {
            $('#COMPLAINTID').FrameTextBox('enable');
            $('#TW').FrameTextBox('enable');
            $('#PI').FrameTextBox('enable');
            $('#IAN').FrameTextBox('enable');
        }
        else if (isStep2) {
            $('#RN').FrameTextBox('enable');
            $('#ReturnFactoryTrackingNo').FrameTextBox('enable');
            $('#ReceiveReturnedGoods').FrameDropdownList('enable');
            $('#ReceiveReturnedGoodsDate').FrameDatePicker('enable');
        }
        else if (isStep3) {
            $('#ConfirmReturnOrRefundCNF').FrameDropdownList('enable');
            $('#ConfirmReturnOrRefundCRM').FrameDropdownList('enable');
        }
        else if (isStep4) {
            if (model.ComplainType == "CRM") {
                if (model.ConfirmReturnOrRefundCRM == "1") { //换货
                    $('#RGA').FrameTextBox('enable');
                    $('#DN').FrameTextBox('enable');
                } else if (model.ConfirmReturnOrRefundCRM == "2") { //退款
                    $('#RGA').FrameTextBox('enable');
                    $('#Invoice').FrameTextBox('enable');
                } else if (model.ConfirmReturnOrRefundCRM == "5") { //只退不换
                    $('#RGA').FrameTextBox('enable');
                }
            } else {
                if (model.ConfirmReturnOrRefundCNF == "10") { //换货
                    $('#RGA').FrameTextBox('enable');
                    $('#DN').FrameTextBox('enable');
                } else if (model.ConfirmReturnOrRefundCNF == "11") { //退款
                    $('#RGA').FrameTextBox('enable');
                    $('#Invoice').FrameTextBox('enable');
                } else if (model.ConfirmReturnOrRefundCNF == "12") { //只退不换
                    $('#RGA').FrameTextBox('enable');
                }
            }
        }
    }

    var clearControlStatus = function () {
        $('#COMPLAINTID').FrameTextBox('disable');
        $('#TW').FrameTextBox('disable');
        $('#PI').FrameTextBox('disable');
        $('#IAN').FrameTextBox('disable');
        $('#RN').FrameTextBox('disable');
        $('#ReturnFactoryTrackingNo').FrameTextBox('disable');
        $('#ReceiveReturnedGoods').FrameDropdownList('disable');
        $('#ReceiveReturnedGoodsDate').FrameDatePicker('disable');
        $('#ConfirmReturnOrRefundCNF').FrameDropdownList('disable');
        $('#ConfirmReturnOrRefundCRM').FrameDropdownList('disable');
        $('#RGA').FrameTextBox('disable');
        $('#Invoice').FrameTextBox('disable');
        $('#DN').FrameTextBox('disable');
    }

    return that;
}();
