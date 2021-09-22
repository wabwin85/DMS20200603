var MasterDatasInfo = {};
MasterDatasInfo = function () {
    var that = {};

    var business = 'MasterDatas.MasterDatasInfo'

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }
    that.Init = function () {
        var data = {};
        data.Year = Common.GetUrlParam('Year');

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#Year').val(model.Year);
                if (model.Year == "undefined") {
                 
                    //年月
                    $('#QryApplyDate').FrameDatePicker({
                        value: model.QryApplyDate
                    });
                    $('#IptIsFlag').FrameSwitch({
                        onLabel: "是",
                        offLabel: "否",
                        value: model.IptIsFlag,
                        readonly: model.IsAdmin
                    });

                } else {
                    $('#IptIsFlag').FrameSwitch({
                        onLabel: "是",
                        offLabel: "否",
                        value: model.IptIsFlag,

                    });
                    $('#QryApplyDate').FrameDatePicker({
                        value: model.QryApplyDate
                    });
                }

                $('#BtnSave').FrameButton({
                    text: '保存',
                    icon: 'save',
                    onClick: function () {
                        that.Submit();
                    }
                });


                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'save',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
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

    that.Submit = function () {
        var data = that.GetModel();
        var message = checkForm(data, 'Submit');
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        } else {
            FrameWindow.ShowConfirm({
                target: 'top',
                message: '确定提交吗？',
                confirmCallback: function () {
                    FrameWindow.ShowLoading();
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'Submit',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            if (model.messages == false) {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'info',
                                    message: '请选择当月日期',
                                    callback: function () {
                                        FrameWindow.CloseWindow({
                                            target: 'top'
                                        });
                                    }
                                });
                                FrameWindow.HideLoading();

                            } else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '提交成功',
                                callback: function () {
                                    FrameWindow.CloseWindow({
                                        target: 'top'
                                    });
                                }
                            });
                            FrameWindow.HideLoading();
                            }
                        }
                    });

                }
            });
        }

    }
    var checkForm = function (data, status) {
        var message = [];
        if (status == 'Submit') {
            if (data.QryApplyDate == null) {
                message.push('请选择上报日期');
            }
        }
        return message;
    }
    var setLayout = function () {
    }
    return that;
}();
