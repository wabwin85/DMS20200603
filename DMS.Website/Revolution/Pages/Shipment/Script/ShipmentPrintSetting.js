var ShipmentPrintSetting = {};

ShipmentPrintSetting = function () {
    var that = {};

    var business = 'Shipment.ShipmentPrintSetting';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#HidIsNew').val(model.HidIsNew);
                $('#HidInstanceId').val(model.HidInstanceId);
                $('#SwCertificateName').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.SwCertificateName
                });
                $('#SwEnglishName').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.SwEnglishName
                });
                $('#SwProductType').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.SwProductType
                });
                $('#SwLot').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.SwLot
                });
                $('#SwExpiryDate').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.SwExpiryDate
                });
                $('#SwShipmentQty').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.SwShipmentQty
                });
                $('#SwUnit').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.SwUnit
                });
                $('#SwUnitPrice').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.SwUnitPrice
                });
                $('#SwCertificateNo').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.SwCertificateNo
                });
                $('#SwCertificateENNo').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.SwCertificateENNo
                });
                $('#SwStartDate').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.SwStartDate
                });
                $('#SwExpireDate').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.SwExpireDate
                });

                //按钮事件
                $('#BtnSave').FrameButton({
                    text: '保存',
                    icon: 'save',
                    onClick: function () {
                        that.SaveSetting();
                    }
                });
                
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });

    }

    that.SaveSetting = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveSetting',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess)
                {
                    $('#HidIsNew').val(model.HidIsNew);
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: "保存成功！",
                        callback: function () {
                        }
                    });
                }

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();