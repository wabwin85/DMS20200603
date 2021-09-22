var ChangePassword = {};

ChangePassword = function () {
    var that = {};

    var business = 'ChangePassword';

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
                
                $('#OldPassword').FrameTextBox({
                    value: model.OldPassword
                });
                $('#OldPassword_Control').attr("type", "password");
                $('#NewPassword').FrameTextBox({
                    value: model.NewPassword
                });
                $('#NewPassword_Control').attr("type", "password");
                $('#ComNewPassword').FrameTextBox({
                    value: model.ComNewPassword
                });
                $('#ComNewPassword_Control').attr("type", "password");
                $('#BtnChange').FrameButton({
                    text: '修改密码',
                    icon: 'save',
                    onClick: function () {
                        that.Change();
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

    that.Change = function () {
        var data = FrameUtil.GetModel();
        var success = true;
        var msg = '';
        if (success && data.OldPassword == '') {
            success = false;
            msg = '老密码不能为空！';
        }
        if (success && data.NewPassword == '') {
            success = false;
            msg = '新密码不能为空！';
        }
        if (success && data.NewPassword != data.ComNewPassword) {
            success = false;
            msg = '新密码和确认密码必须相等！';
        }
        if (!success) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: msg,
                callback: function () {
                }
            });
            return;
        }
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Change',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.HideLoading();
                if (model.IsSuccess) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '修改成功',
                        callback: function () {
                            //top.deleteTabsCurrent();
                            if ($('#ctl00_MainContent_SuccessUrl').val() != '') {
                                window.location.href = $('#ctl00_MainContent_SuccessUrl').val();
                            }                         
                        }
                    });
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'error',
                        message: model.ExecuteMessage,
                        callback: function () {
                            //top.deleteTabsCurrent();
                        }
                    });
                }
            }
        });
    }

    

    var setLayout = function () {
    }

    return that;
}();
