(function ($) {
    //DmsDataImport Start
    $.fn.DmsDataImport = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.DmsDataImport.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.DmsDataImport.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.DmsDataImport.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();

            //HTML
            var html = '';
            if (!setting.readOnly) {
                html += '<div style="display: none;"><input type="file" id="' + controlId + '_BtnUpload" /></div>';
                html += '<a id="' + controlId + '_BtnFile" />\n';
                html += '<a id="' + controlId + '_BtnShowError" />\n';
                if (setting.template) {
                    html += '<a id="' + controlId + '_BtnDownload" />\n';
                }
            } else {
                html += '<a id="' + controlId + '_BtnShowDetail" />\n';
            }
            $('#' + controlId).append(html);

            if (!setting.readOnly) {
                var urlUpload = Common.AppVirtualPath + 'Revolution/Pages/Handler/DataImportUploadHanler.ashx';
                urlUpload = Common.UpdateUrlParams(urlUpload, 'KeepFile', setting.keepFile);
                urlUpload = Common.UpdateUrlParams(urlUpload, 'DelegateBusiness', setting.delegateBusiness);

                var urlError = Common.AppVirtualPath + 'Revolution/Pages/Util/DataImport/DataImportErrorList.aspx';
                urlError = Common.UpdateUrlParams(urlError, 'DelegateBusiness', setting.delegateBusiness);

                var urlTemplate = Common.AppVirtualPath + 'Revolution/Pages/Util/DataImport/DataImportTemplate.aspx';

                $('#' + controlId + '_BtnUpload').kendoUpload({
                    async: {
                        saveUrl: urlUpload,
                        autoUpload: true
                    },
                    select: function (e) {
                        $('#' + controlId + '_BtnUpload').data("kendoUpload").setOptions({
                            async: {
                                saveUrl: setting.appendUploadParam.call(this, urlUpload),
                                autoUpload: true
                            }
                        });
                        FrameWindow.ShowLoading();
                    },
                    multiple: false,
                    success: function (e) {
                        //成功上传过文件
                        $('#' + controlId).data('uploaded', true);

                        if (e.response.IsSuccess) {
                            if (!e.response.CheckResult) {
                                $('#' + controlId).data('success', false);

                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'warning',
                                    message: 'Excel文件中数据有误，请查看错误信息',
                                    callback: function () {
                                        $('#' + controlId + '_BtnShowError').show();
                                    }
                                });
                            } else {
                                $('#' + controlId).data('success', true);

                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'info',
                                    message: '数据导入成功',
                                    callback: function () {
                                        $('#' + controlId + '_BtnShowError').hide();
                                    }
                                });
                            }
                            FrameWindow.HideLoading();

                            setting.onSuccess.call(this, e.response);
                        } else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'error',
                                message: e.response.ExecuteMessage
                            });
                            FrameWindow.HideLoading();
                        }
                    },
                    error: function (e) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'error',
                            message: '上传文件出错！'
                        });
                        FrameWindow.HideLoading();
                    }
                });
                $('#' + controlId + '_BtnFile').FrameButton({
                    text: setting.fileText,
                    icon: 'folder-open',
                    onClick: function () {
                        var message = setting.checkUpload.call(this);
                        if (message.length > 0) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'warning',
                                message: message,
                            });
                        } else {
                            $('#' + controlId + '_BtnUpload').click();
                        }
                    }
                });
                $('#' + controlId + '_BtnShowError').FrameButton({
                    text: '错误信息',
                    icon: 'exclamation-triangle',
                    style: { 'display': 'none', 'margin-left': '5px' },
                    className: 'btn-danger',
                    onClick: function () {
                        urlError = setting.appendErrorParam.call(this, urlError);
                        FrameWindow.OpenWindow({
                            target: 'top',
                            title: '错误信息',
                            url: urlError,
                            width: $(window).width() * 0.7,
                            height: $(window).height() * 0.9,
                            actions: ["Close"]
                        });
                    }
                });
                if (setting.template) {
                    $('#' + controlId + '_BtnDownload').FrameButton({
                        text: '导入模板下载',
                        icon: 'download',
                        style: { 'margin-left': '5px' },
                        onClick: function () {
                            urlTemplate = setting.appendTemplateParam.call(this, urlTemplate);
                            FrameUtil.StartDownload({
                                url: urlTemplate,
                                cookie: setting.cookie,
                                business: setting.delegateBusiness
                            });
                        }
                    });
                }
            } else {
                var urlDetail = Common.AppVirtualPath + 'Revolution/Pages/Util/DataImport/FileCheckDetailList.aspx';
                urlDetail = $.updateUrlParams(urlDetail, 'DelegateBusiness', setting.delegateBusiness);
                urlDetail = $.updateUrlParams(urlDetail, 'InstanceId', setting.instanceId);

                $('#' + controlId + '_BtnShowDetail').FrameButton({
                    text: '导入信息',
                    icon: 'server',
                    onClick: function () {
                        openWindow({
                            target: 'top',
                            title: '导入信息',
                            url: urlDetail,
                            width: $(window).width() * 0.7,
                            height: $(window).height() * 0.9,
                            actions: ["Close"]
                        });
                    }
                });
            }
        }
    };

    $.fn.DmsDataImport.defaults = $.extend({}, {
        type: 'DmsDataImport',
        delegateBusiness: '',
        instanceId: '',
        keepFile: false,
        cookie: '',
        readOnly: false,
        template: false,
        success: true,
        uploaded: false,
        fileText: '上传',
        appendUploadParam: function (url) { return url; },
        appendTemplateParam: function (url) { return url; },
        appendErrorParam: function (url) { return url; },
        onSuccess: function (e) { },
        checkUpload: function () { return []; }
    });

    $.fn.DmsDataImport.methods = {
        IsSuccess: function (my, value) {
            var controlId = $(my).attr("id");

            return $('#' + controlId).data('success');
        },
        IsUploaded: function (my, value) {
            var controlId = $(my).attr("id");

            return $('#' + controlId).data('uploaded');
        },
        ShowErrorInfo: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId).data('success', false);
            $('#' + controlId + '_BtnShowError').show();
        },
        HideErrorInfo: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId).data('success', true);
            $('#' + controlId + '_BtnShowError').hide();
        }
    };
    //DmsDataImport End
})(jQuery);