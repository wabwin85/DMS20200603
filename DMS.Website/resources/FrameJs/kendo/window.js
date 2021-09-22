var showLoading = function () {
    $('#loadingToast').show();
}

var hideLoading = function () {
    $('#loadingToast').hide();
}

var showMessage = function (option) {
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

var showAlert = function (option) {
    var setting = $.extend({}, {
        target: 'this',
        alertType: 'info',
        message: '',
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

    var b;
    if (setting.target == 'top') {
        b = top.bootbox;
    } else if (setting.target == 'parent') {
        b = parent.bootbox;
    } else {
        b = bootbox;
    }

    var title;
    if (setting.alertType == 'error') {
        title = '<span style="color: #d15b47;"><i class="fa fa-times-circle" />&nbsp;出错啦</span>';
    } else if (setting.alertType == 'warning') {
        title = '<span style="color: #ffb752;"><i class="fa fa-warning" />&nbsp;警告</span>';
    } else {
        title = '<span style="color: #428bca;"><i class="fa fa-info-circle" />&nbsp;提示信息</span>';
    }

    b.alert({
        title: title,
        message: msg,
        //animate: false,
        callback: setting.callback,
        buttons: {
            ok: {
                label: '确定'
            }
        }
    });
}

var showConfirm = function (option) {
    var setting = $.extend({}, {
        target: 'this',
        message: '',
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
                label: setting.confirmLabel == undefined || setting.confirmLabel == "" ? '确定' : setting.confirmLabel
            },
            cancel: {
                label: setting.cancelLabel == undefined || setting.cancelLabel == "" ? '取消' : setting.cancelLabel
            }
        }
    });
}

var openWindow = function (option) {
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

    var timestamp = $.getTimestamp();

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
        setting.callback.call(this);
        myWindow.data("kendoWindow").destroy();
    }

    setting.url = $.updateUrlParams(setting.url, "timestamp", timestamp);

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

var closeWindow = function (option) {
    var setting = $.extend({}, {
        target: 'this'
    }, option);

    var myWindow;
    var timestamp = $.getUrlParam('timestamp');
    if (setting.target == 'top') {
        myWindow = top.$('#ModelWinow_' + timestamp);
    } else if (setting.target == 'parent') {
        myWindow = parent.$('#ModelWinow_' + timestamp);
    } else {
        myWindow = $('#ModelWinow_' + timestamp);
    }

    myWindow.data("kendoWindow").close();
}

var setWindowTitle = function (option) {
    var setting = $.extend({}, {
        target: 'this',
        title: ''
    }, option);

    var myWindow;
    var timestamp = $.getUrlParam('timestamp');
    if (setting.target == 'top') {
        myWindow = top.$('#ModelWinow_' + timestamp);
    } else if (setting.target == 'parent') {
        myWindow = parent.$('#ModelWinow_' + timestamp);
    } else {
        myWindow = $('#ModelWinow_' + timestamp);
    }

    myWindow.data("kendoWindow").title(setting.title);
}

var reloadWindow = function (option) {
    var setting = $.extend({}, {
        target: 'this',
        title: '',
        url: ''
    }, option);

    var myWindow;
    var timestamp = $.getUrlParam('timestamp');
    if (setting.target == 'top') {
        myWindow = top.$('#ModelWinow_' + timestamp);
    } else if (setting.target == 'parent') {
        myWindow = parent.$('#ModelWinow_' + timestamp);
    } else {
        myWindow = $('#ModelWinow_' + timestamp);
    }

    myWindow.data("kendoWindow").title(setting.title);

    if (setting.url != '') {
        var url = $.updateUrlParams(setting.url, "timestamp", $.getUrlParam('timestamp'));

        myWindow.find('.k-content-frame').attr('src', url);
    }
}