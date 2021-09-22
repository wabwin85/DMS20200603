var DataImportErrorList = {};

DataImportErrorList = function () {
    var that = {};

    var business = 'DataImport.DataImportErrorList';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.Parameters = Common.GetUrlParamList();

        return model;
    }

    that.Init = function () {
        var data = {};
        data.Parameters = Common.GetUrlParamList();
        data.DelegateBusiness = Common.GetUrlParam('DelegateBusiness');

        console.log(data);
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#DelegateBusiness').val(model.DelegateBusiness);

                //$('#BtnExport').FrameButton({
                //    text: '导出',
                //    icon: 'file-excel-o',
                //    onClick: function () {
                //        $("#RstResultList").data("kendoGrid").saveAsExcel();
                //    }
                //});
                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'window-close',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });

                createResultList(model.RstResultList);

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    var createResultList = function (dataSource) {
        $("#RstResultList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    field: "RowNum", title: "行号", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "行号" }
                },
                {
                    field: "ErrorMessage", title: "错误内容",
                    headerAttributes: { "class": "text-center text-bold", "title": "错误内容" }
                }
            ],
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
            },
            excel: {
                allPages: true//是否导出所有页中的数据
            },
            excelExport: function (e) {
                e.workbook.fileName = "ErrorList.xlsx";
            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();
