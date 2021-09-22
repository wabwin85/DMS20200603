var Test = {};

Test = function () {
    var that = {};

    var business = 'Platform.Test';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        $('#IptImport').DmsDataImport({
            delegateBusiness: business,
            template: true,
            cookie: 'ImportCookie',
            fileText: '上传',
            //appendUploadParam: function (url) {
            //    url = Common.UpdateUrlParams(url, 'MidId', $('#IptMidId').val());
            //    url = Common.UpdateUrlParams(url, 'InstanceId', $('#InstanceId').val());
            //    return url;
            //},
            //appendErrorParam: function (url) {
            //    url = Common.UpdateUrlParams(url, 'MidId', $('#IptMidId').val());
            //    url = Common.UpdateUrlParams(url, 'InstanceId', $('#InstanceId').val());
            //    return url;
            //},
            //appendTemplateParam: function (url) {
            //    url = Common.UpdateUrlParams(url, 'MidId', $('#IptMidId').val());
            //    url = Common.UpdateUrlParams(url, 'InstanceId', $('#InstanceId').val());
            //    return url;
            //},
            //onSuccess: ReloadAchieve,
            readOnly: false
        });

        FrameWindow.HideLoading();
    }

    var setLayout = function () {
    }

    return that;
}();
