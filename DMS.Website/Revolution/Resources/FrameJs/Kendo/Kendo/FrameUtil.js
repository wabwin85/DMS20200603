var FrameUtil = {};

FrameUtil = function () {
    var that = {};

    that.AjaxTimeout = 60000;

    that.GetModel = function (panel) {
        var model = {};

        if (typeof (panel) == 'undefined') {
            $('.FrameControl').each(function () {
                var controlId = $(this).attr("id");
                if ($(this).attr("type") == 'hidden') {
                    eval("model." + controlId + " = '" + $(this).val() + "'");
                } else {
                    var type = $(this).data('type');
                    if (typeof (type) == 'undefined') {
                        eval("model." + controlId + " = null");
                    } else {
                        eval("model." + controlId + " = $(this)." + type + "('getValue')");
                    }
                }
            });
        } else {
            $('#' + panel).find('.FrameControl').each(function () {
                var controlId = $(this).attr("id");
                if ($(this).attr("type") == 'hidden') {
                    eval("model." + controlId + " = '" + $(this).val() + "'");
                } else {
                    var type = $(this).data('type');
                    if (typeof (type) == 'undefined') {
                        eval("model." + controlId + " = null");
                    } else {
                        eval("model." + controlId + " = $(this)." + type + "('getValue')");
                    }
                }
            });
        }

        return model;
    }

    that.SubmitAjax = function (option) {
        var setting = $.extend({}, {
            business: '',
            method: '',
            url: '',
            async: true,
            data: {},
            callback: function () { },
            failCallback: function () { }
        }, option);

        setting.url = Common.UpdateUrlParams(setting.url, 'Business', setting.business);
        setting.url = Common.UpdateUrlParams(setting.url, 'Method', setting.method);

        $.ajax({
            type: "Post",
            url: setting.url,
            timeout: that.AjaxTimeout,
            data: JSON.stringify(setting.data),
            contentType: "application/json; charset=utf-8",
            async: setting.async,
            dataType: "json",
            success: function (model) {
                try {
                    if (model.IsSuccess == true) {
                        setting.callback.call(this, model);
                    } else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'error',
                            message: model.ExecuteMessage,
                            callback: function () {
                                setting.failCallback.call(this, model);
                            }
                        });
                        FrameWindow.HideLoading();
                    }
                } catch (e) {
                    console.log(e.stack);
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'error',
                        message: e.name + "：" + e.message
                    });
                    FrameWindow.HideLoading();
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log(XMLHttpRequest);
                if (textStatus == 'timeout') {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'error',
                        message: '系统超时，请稍后再试'
                    });
                    FrameWindow.HideLoading();
                } else if (textStatus == 'parsererror' && XMLHttpRequest.responseText.indexOf('Login.aspx') != -1) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'error',
                        message: '登陆超时，请重新登陆！',
                        callback: function () {
                            window.location.reload();
                        }
                    });
                    FrameWindow.HideLoading();
                } else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'error',
                        message: errorThrown
                    });
                    FrameWindow.HideLoading();
                }
            }
        });
    }

    that.LoadAjaxHtml = function (option) {
        var setting = $.extend({}, {
            url: '',
            callback: function () { }
        }, option);

        $.ajax({
            url: setting.url,
            type: 'get',
            async: false,
            success: function (res) {
                setting.callback.call(this, res);
            }
        });
    }

    that.StartDownload = function (option) {
        var setting = $.extend({}, {
            url: '',
            cookie: '',
            business: '',
            method: 'GET',
            data: null
        }, option);

        setting.cookie += '_' + Common.GetTimestamp();

        setting.url = Common.UpdateUrlParams(setting.url, 'DownloadCookie', setting.cookie);
        setting.url = Common.UpdateUrlParams(setting.url, 'Business', setting.business);
        setting.url = Common.UpdateUrlParams(setting.url, 'Method', setting.method);

        var timestamp = Common.GetTimestamp();
        setting.url = Common.UpdateUrlParams(setting.url, "timestamp", timestamp);

        $.fileDownload(setting.url, {
            preparingMessageTitle: '<span style="color: #428bca;"><i class="fa fa-info-circle" />&nbsp;提示信息</span>',
            preparingMessageHtml: '<p><i class="fa fa-spin fa-spinner"></i>&nbsp;下载中，请等待...</p>',
            failMessageHtml: '下载出错',
            cookieName: "fileDownload_" + setting.cookie,
            httpMethod: setting.method,
            data: setting.data
        });
    }

    return that;
}();