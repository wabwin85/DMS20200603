var InventoryReturnBsc = {};

InventoryReturnBsc = function () {
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

        $('#AdjId').val($.getUrlParam('formInstanceId'));

        $('#InvoiceNo').FrameTextBox({
            value: ''
        });

        $('#RgaNo').FrameTextBox({
            value: ''
        });

        $('#DeliveryNo').FrameTextBox({
            value: ''
        });

        $('#ReasonCode').FrameTextBox({
            value: ''
        });

        $('#RevokeRemark').FrameTextBox({
            value: ''
        });

        $('#divReturnHtml').html('');

        showLoading();

        var data = that.GetModel('InitPage');
        submitAjax(Common.AppVirtualPath + "PagesKendo/InventoryReturn/Handler/InventoryReturnBscHandler.ashx", data, function (model) {
           
            $("#BtnSave").css("display", "block");

            $('#InvoiceNo').FrameTextBox({
                value: model.InvoiceNo
            });

            $('#RgaNo').FrameTextBox({
                value: model.RGANo
            });

            $('#DeliveryNo').FrameTextBox({
                value: model.DeliveryNo
            });

            $('#RevokeRemark').FrameTextBox({
                value: model.RevokeRemark
            });

            $('#ReasonCode').FrameDropdownList({
                dataSource: model.LstReason,
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'select'
            });

            $('#ReasonCode').FrameDropdownList('setValue', model.ReasonCode);

            $('#LastUpdateTime').val(model.LastUpdateTime);

            $("#divReturnHtml").append(model.HtmlString);
            
            checkAuth();

            setLayout();

            hideLoading();
        });
    }

    that.DoSave = function () {
        showLoading();

        var data = that.GetModel('DoSave');
        submitAjax(Common.AppVirtualPath + "PagesKendo/InventoryReturn/Handler/InventoryReturnBscHandler.ashx", data, function (model) {

            showAlert({
                target: 'top',
                alertType: 'info',
                message: '保存成功！',
                callback: function () {
                    window.location.href = $('#ForwardUrl').val();
                }
            });

            $("#BtnSave").css("display", "block");

            $('#LastUpdateTime').val(model.LastUpdateTime);
            $("#divReturnHtml").html('');
            $("#divReturnHtml").append(model.HtmlString);

            checkAuth();

            setLayout();

            hideLoading();
        });
    }

    var initColumnLayout = function () {
    }

    var setLayout = function () {
        var h = $('.content-main').height();
    }

    var checkAuth = function (nodeIds) {
        //CurrentNodeIds

        clearControlStatus();

        var isCs = false;
        var isLogistic = false;
        if (nodeIds != null && nodeIds != '') {
            if ($.inArray('N14', nodeIds.split(',')) >= 0) {
                isCs = true;
            }
            else if ($.inArray('N15', nodeIds.split(',')) >= 0) {
                isLogistic = true;
            }
        }

        if (isCs)
        {
            $('#InvoiceNo').FrameTextBox('enable');
            $('#RgaNo').FrameTextBox('enable');
            $('#DeliveryNo').FrameTextBox('enable');
            $('#RevokeRemark').FrameTextBox('enable');
            $('#ReasonCode').FrameDropdownList('enable');
        }
        else if (isLogistic) {
            $('#RgaNo').FrameTextBox('enable');
            $('#ReasonCode').FrameDropdownList('enable');
        }
    }

    var clearControlStatus = function () {
        $('#InvoiceNo').FrameTextBox('disable');
        $('#RgaNo').FrameTextBox('disable');
        $('#DeliveryNo').FrameTextBox('disable');
        $('#RevokeRemark').FrameTextBox('disable');
        $('#ReasonCode').FrameDropdownList('disable');
    }

    return that;
}();
