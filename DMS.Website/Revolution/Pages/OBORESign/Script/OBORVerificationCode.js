var OBORVerificationCode = {};

OBORVerificationCode = function () {
    var that = {};

    var business = 'OBORESign.OBORVerificationCode';
    var pickedList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {


        var data = {};
        data.ES_ID = Common.GetUrlParam('ES_ID');
        data.SignType = Common.GetUrlParam('SignType');
        $('#ES_ID').val(Common.GetUrlParam('ES_ID'));
        $('#SignType').val(Common.GetUrlParam('SignType'));
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

               
                $('#IptVerificationCode').FrameTextBox({

                    value: model.IptVerificationCode
                });



                $('#BtnSend').FrameButton({
                    text: '发送验证码',
                    icon: 'send',
                    onClick: function () {
                        that.Send();
                    }
                });
                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'search',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });

                $('#BtnConfirm').FrameButton({
                    text: '确定',
                    icon: 'save',
                    onClick: function () {
                        that.Confirm();
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



    function disableSeconds(buttonId, changingValue, changedValue, seconds) {
        $("#" + buttonId).attr("disabled", "disabled");
        for (i = 0; i <= seconds; i++) {
            window.setTimeout(updateSeconds(buttonId, changingValue, changedValue, seconds, i), i * 1000);

            
        }
    }

    function updateSeconds(buttonId, changingValue, changedValue, seconds, num) {
        var printnr;
        if (num == seconds) {
            $("#" + buttonId).html(changedValue);
            $("#" + buttonId).attr("disabled", false);
        }
        else {
            printnr = seconds - num;
            $("#" + buttonId).html(changingValue + " (" + printnr + ")");
        }
    }
    that.Send = function () {

        
        var data = FrameUtil.GetModel();

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Send',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                
                if (model.IsSuccess) {

                    $('#Phone').html('已向手机号：' + model.Phone + '发送验证码，请查收')

                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '发送成功',
                        callback: function () {
                           
                            //disableSeconds("BtnSend", "请稍后", '<i class="fa fa-send-o"></i>发送验证码', 30);

                        }
                    });
                }

                FrameWindow.HideLoading();
            }
        });


    }


    that.Confirm = function () {


        var data = FrameUtil.GetModel();


        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Confirm',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '签章成功',
                        callback: function () {
                            FrameWindow.CloseWindow({
                                target: 'top'
                            });
                        }
                    });
                }

                FrameWindow.HideLoading();
            }
        });
    }




    var setLayout = function () {
    }

    return that;
}();
