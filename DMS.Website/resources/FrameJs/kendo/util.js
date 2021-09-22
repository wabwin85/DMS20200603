var submitAjax = function (url, data, callback, callbackError) {
    $.ajax({
        type: "Post",
        url: url,
        timeout: 60000,
        data: JSON.stringify(data),
        contentType: "application/json; charset=utf-8",
        async: true,
        dataType: "json",
        success: function (model) {
            try {
                //var model = JSON.parse(data);
                //console.log(model);
                if (model.IsSuccess == true) {
                    callback.call(this, model);
                } else {
                    showAlert({
                        target: 'this',
                        alertType: 'error',
                        message: model.ExecuteMessage,
                        callback: callbackError
                    });
                    hideLoading();
                }
            } catch (e) {
                console.log(e.stack);
                showAlert({
                    target: 'this',
                    alertType: 'error',
                    message: e.name + "：" + e.message
                });
                hideLoading();
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            console.log(XMLHttpRequest);
            if (textStatus == 'timeout') {
                showAlert({
                    target: 'this',
                    alertType: 'error',
                    message: '系统超时，请稍后再试'
                });
                hideLoading();
            } else if (textStatus == 'Unauthorized' || (textStatus == 'parsererror' && XMLHttpRequest.responseText.indexOf('Login.aspx') != -1)) {
                showAlert({
                    target: 'this',
                    alertType: 'error',
                    message: '登陆超时，请重新登陆！',
                    callback: function () {
                        window.location = window.location.href;
                    }
                });
                hideLoading();
            } else {
                showAlert({
                    target: 'this',
                    alertType: 'error',
                    message: errorThrown
                });
                hideLoading();
            }
        }
    });
}

var startDownload = function (url, downloadType) {
    $.fileDownload(url, {
        preparingMessageTitle: '<span style="color: #428bca;"><i class="fa fa-info-circle" />&nbsp;提示信息</span>',
        preparingMessageHtml: '<p><i class="fa fa-spin fa-spinner"></i>&nbsp;下载中，请等待...</p>',
        failMessageHtml: '下载出错',
        cookieName: "fileDownload_" + downloadType
    });
}