var FrameWindow = {};

FrameWindow = function () {
    var that = {};

    that.ShowLoading = function () {
        $('#loadingToast').show();
    }

    that.HideLoading = function () {
        $('#loadingToast').hide();
    }

    that.ShowMessage = function (option) {
        var setting = $.extend({}, {
            target: 'this',
            title: '',
            message: ''
        }, option);

        var b;
        if (setting.target == 'top') {
            b = top.bootbox;
        } else if (setting.target == 'parent') {
            b = parent.bootbox;
        } else {
            b = bootbox;
        }

        return b.dialog({
            title: setting.title,
            message: setting.message,
            closeButton: false
        });
    }

    that.ShowAlert = function (option) {
        var setting = $.extend({}, {
            target: 'this',
            alertType: 'info',
            title: '',
            message: '',
            okLabel: '确定',
            callback: function () { }
        }, option);

        var msg = '';
        if (Object.prototype.toString.call(setting.message) === '[object Array]') {
            for (i = 0; i < setting.message.length; i++) {
                msg += setting.message[i] + '<br />';
            }
        } else {
            msg = setting.message;
        }

        if (typeof (msg) == 'undefined' || msg == '') {
            msg = '出错了，请联系管理员';
        }

        var b;
        if (setting.target == 'top') {
            b = top.bootbox;
        } else if (setting.target == 'parent') {
            b = parent.bootbox;
        } else {
            b = bootbox;
        }

        if (setting.title == '') {
            if (setting.alertType == 'error') {
                setting.title = '<span style="color: #d15b47;"><i class="fa fa-times-circle" />&nbsp;出错啦</span>';
            } else if (setting.alertType == 'warning') {
                setting.title = '<span style="color: #ffb752;"><i class="fa fa-warning" />&nbsp;警告</span>';
            } else {
                setting.title = '<span style="color: #428bca;"><i class="fa fa-info-circle" />&nbsp;提示信息</span>';
            }
        }

        b.alert({
            title: setting.title,
            message: msg,
            //animate: false,
            callback: setting.callback,
            buttons: {
                ok: {
                    label: setting.okLabel
                }
            }
        });
    }

    that.ShowConfirm = function (option) {
        var setting = $.extend({}, {
            target: 'this',
            message: '',
            confirmLabel: '确定',
            cancelLabel: '取消',
            confirmCallback: function () { },
            cancelCallback: function () { }
        }, option);

        var msg = '';
        if (Object.prototype.toString.call(setting.message) === '[object Array]') {
            for (i = 0; i < setting.message.length; i++) {
                msg += setting.message[i] + '<br />';
            }
        } else {
            msg = setting.message;
        }

        var b;
        if (setting.target == 'top') {
            b = top.bootbox;
        } else if (setting.target == 'parent') {
            b = parent.bootbox;
        } else {
            b = bootbox;
        }

        var title = '<span style="color: #d15b47;"><i class="fa fa-question-circle" />&nbsp;确认</span>';

        b.confirm({
            title: title,
            message: msg,
            //animate: false,
            callback: function (result) {
                if (result == true) {
                    setting.confirmCallback.call(this);
                } else {
                    setting.cancelCallback.call(this);
                }
            },
            buttons: {
                confirm: {
                    label: setting.confirmLabel
                },
                cancel: {
                    label: setting.cancelLabel
                }
            }
        });
    }

    that.ShowPrompt = function (option) {
        var setting = $.extend({}, {
            target: 'this',
            title: '',
            message: '',
            confirmLabel: '确定',
            cancelLabel: '取消',
            confirmCallback: function () { return true; },
            cancelCallback: function () { }
        }, option);

        var b;
        if (setting.target == 'top') {
            b = top.bootbox;
        } else if (setting.target == 'parent') {
            b = parent.bootbox;
        } else {
            b = bootbox;
        }

        var dialog = b.prompt({
            title: setting.title,
            inputType: 'textarea',
            callback: function (result) {
                if (result == null) {
                    setting.cancelCallback.call(this);
                } else {
                    return setting.confirmCallback.call(this, $.trim(result));
                }
            },
            buttons: {
                confirm: {
                    label: setting.confirmLabel
                },
                cancel: {
                    label: setting.cancelLabel
                }
            }
        });

        dialog.find('textarea').css('resize', 'none');
        if (setting.message != '') {
            $('<span>' + setting.message + '</span>').insertBefore(dialog.find('.bootbox-body'));
        }
    }

    that.OpenWindow = function (option) {
        var setting = $.extend({}, {
            target: 'this',
            title: '',
            url: '',
            width: 800,
            height: 600,
            maxed: false,
            actions: ["Maximize", "Close"],
            callback: function () { }
        }, option);

        var timestamp = Common.GetTimestamp();

        var myWindow;
        var maxHeight;
        if (setting.target == 'top') {
            $(top.document.body).append('<div id="ModelWinow_' + timestamp + '"></div>');
            myWindow = top.$('#ModelWinow_' + timestamp);
            maxHeight = $(top.window).height() - 30;
        } else if (setting.target == 'parent') {
            $(parent.document.body).append('<div id="ModelWinow_' + timestamp + '"></div>');
            myWindow = parent.$('#ModelWinow_' + timestamp);
            maxHeight = $(parent.window).height() - 30;
        } else {
            $(document.body).append('<div id="ModelWinow_' + timestamp + '"></div>');
            myWindow = $('#ModelWinow_' + timestamp);
            maxHeight = $(window).height() - 30;
        }

        var onClose = function () {
            var returnValue = myWindow.data('returnValue');

            if (returnValue) {
                setting.callback.call(this, returnValue);
            } else {
                setting.callback.call(this);
            }

            myWindow.data("kendoWindow").destroy();
        }

        setting.url = Common.UpdateUrlParams(setting.url, "timestamp", timestamp);

        myWindow.kendoWindow({
            width: setting.width,
            height: setting.height,
            maxHeight: maxHeight,
            modal: true,
            resizable: false,
            title: setting.title,
            content: setting.url,
            iframe: true,
            actions: setting.actions,
            close: onClose
        });

        if (setting.maxed) {
            myWindow.data("kendoWindow").center().open().maximize();
        } else {
            myWindow.data("kendoWindow").center().open();
        }
    }

    that.CloseWindow = function (option) {
        var setting = $.extend({}, {
            target: 'this'
        }, option);

        var myWindow;
        var timestamp = Common.GetUrlParam('timestamp');
        if (setting.target == 'top') {
            myWindow = top.$('#ModelWinow_' + timestamp);
        } else if (setting.target == 'parent') {
            myWindow = parent.$('#ModelWinow_' + timestamp);
        } else {
            myWindow = $('#ModelWinow_' + timestamp);
        }

        myWindow.data("kendoWindow").close();
    }

    that.SetWindowReturnValue = function (option) {
        var setting = $.extend({}, {
            target: 'this',
            value: {}
        }, option);

        var myWindow;
        var timestamp = Common.GetUrlParam('timestamp');
        if (setting.target == 'top') {
            myWindow = top.$('#ModelWinow_' + timestamp);
        } else if (setting.target == 'parent') {
            myWindow = parent.$('#ModelWinow_' + timestamp);
        } else {
            myWindow = $('#ModelWinow_' + timestamp);
        }

        myWindow.data('returnValue', setting.value);
    }

    that.ReloadWindow = function (option) {
        var setting = $.extend({}, {
            target: 'this',
            title: '',
            url: ''
        }, option);

        var myWindow;
        var timestamp = Common.GetUrlParam('timestamp');
        if (setting.target == 'top') {
            myWindow = top.$('#ModelWinow_' + timestamp);
        } else if (setting.target == 'parent') {
            myWindow = parent.$('#ModelWinow_' + timestamp);
        } else {
            myWindow = $('#ModelWinow_' + timestamp);
        }

        if (setting.title != '') {
            myWindow.data("kendoWindow").title(setting.title);
        }

        if (setting.url != '') {
            var url = Common.UpdateUrlParams(setting.url, "timestamp", Common.GetUrlParam('timestamp'));

            myWindow.find('.k-content-frame').attr('src', url);
        }
    }

    return that;
}();