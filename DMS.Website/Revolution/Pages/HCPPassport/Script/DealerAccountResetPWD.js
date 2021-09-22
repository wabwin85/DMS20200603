var DealerAccountResetPWD = {};

DealerAccountResetPWD = function () {
    var that = {};

    var business = 'HCPPassport.DealerAccountResetPWD';


    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        data.ID = Common.GetUrlParam('ID');

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (Common.GetUrlParam('ID') == '') {

                }
                else {
                    $('#IptName').FrameLabel({
                        value: model.IptName,
                        readonly: true,
                    });
                    $("#IptUserName").val(model.IptUserName);
                    $('#UserName').FrameLabel({
                        value: model.IptUserName,
                        readonly: true,
                    });
                    $('#IptNewPassword').FrameTextBox({
                        value: model.NewPassword
                    });
                    $('#IptNewPassword_Control').attr("type", "password");
                    $('#IptComNewPassword').FrameTextBox({
                        value: model.ComNewPassword
                    });
                    $('#IptComNewPassword_Control').attr("type", "password");
                }
                $('#BtnChange').FrameButton({
                    text: '密码重置',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
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

    that.Save = function () {
        var data = that.GetModel();
        data.ID = Common.GetUrlParam('ID');

        var message = that.CheckForm(data);
        if (message != "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Save',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '修改成功',
                        callback: function () {
                            //that.Init();
                            //var url = Common.AppVirtualPath + 'Revolution/Pages/OBORESign/OBORESignInfo.aspx';
                            //url += '?ES_ID=' + model.ES_ID;
                            //window.location = url;
                            FrameWindow.CloseWindow({
                                target: 'top'
                            });
                        }
                    });

                    FrameWindow.HideLoading();
                }
            });
        }


    }

    that.CheckForm = function (data) {
        var success = true;
        var msg = '';
        if (success && data.IptNewPassword == '') {
            success = false;
            msg = '新密码不能为空！';
        }
        if (success && data.IptNewPassword != data.IptComNewPassword) {
            success = false;
            msg = '新密码和确认密码必须相同！';
        }
        return msg;
    }

    var setLayout = function () {
    }

    return that;
}();
