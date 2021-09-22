var DataImportDetailList = {};

DataImportDetailList = function () {
    var that = {};

    var business = 'DataImport.DataImportDetailList';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        data.InstanceId = Common.GetUrlParam('InstanceId');
        data.DelegateBusiness = Common.GetUrlParam('DelegateBusiness');

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#InstanceId').val(model.InstanceId);
                $('#DelegateBusiness').val(model.DelegateBusiness);

                var urlDownload = Common.AppVirtualPath + 'Pages/Util/DataImport/DataImportDetailDownload.aspx';
                urlDownload = Common.UpdateUrlParams(urlDownload, 'InstanceId', $('#InstanceId').val());

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        FrameUtil.StartDownload({
                            url: urlDownload,
                            cookie: 'FileCheckDetailList_' + Common.GetTimestamp(),
                            business: $('#DelegateBusiness').val()
                        });
                    }
                });
                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'window-close',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });

                createResultList(model.RstResultColumn, model.RstResultList);

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    var createResultList = function (columns, dataSource) {
        $("#RstResultList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: columns,
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();
