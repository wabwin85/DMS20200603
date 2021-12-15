var InvHospitalCfgImport = {};

InvHospitalCfgImport = function () {
    var that = {};

    var business = 'MasterDatas.Extense.InvHospitalCfgInit';
    var IMPORT_TYPE = 'InvHospitalCfgImport';
    var IMPORT_NAME = 'sheet1'

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        createResultList();
        //$("#ImportErrorGrid").data('kendoGrid').setOptions({
        //    dataSource: kendoDataSource
        //});
        $("#files").kendoUpload({
            async: {
                saveUrl: "../../Handler/UploadFile.ashx?Type=" + IMPORT_TYPE + "&SheetName=" + IMPORT_NAME,
                autoUpload: true
            },
            localization: {
                headerStatusUploading: "上传处理中,请稍等..."
            },
            validation: {
                allowedExtensions: [".xls", ".xlsx"],
            },
            multiple: false,
            upload: onUpload,
            success: onSuccess,
            error: onError
        });


        $(window).resize(function () {
            setLayout();
        })
        setLayout();

        FrameWindow.HideLoading();
    }

    function onUpload(e) {
        var files = e.files;
        // Check the extension of the file and abort the upload if it is not .xls or .xlsx
        $.each(files, function () {
            if (this.extension.toLowerCase() != ".xls" && this.extension.toLowerCase() != ".xlsx") {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: "只能导入Excel文件！",
                    callback: function () {
                        e.preventDefault();
                        var dataSource = $("#ImportErrorGrid").data("kendoGrid").dataSource;
                        dataSource.data([]);
                        FrameWindow.HideLoading();
                    }
                });
            }
            else {
                FrameWindow.ShowLoading();
                var upload = $("#files").data("kendoUpload");
                upload.disable();
            }
        });
    }

    function onSuccess(e) {
        if (e.XMLHttpRequest.responseText != "") {
            var obj = $.parseJSON(e.XMLHttpRequest.responseText);
            var data = that.GetModel();
            if (obj.result == "Success") {
                $("#ImportErrorGrid").data('kendoGrid').setOptions({
                    dataSource: kendoDataSource
                });
                FrameWindow.ShowConfirm({
                    target: 'top',
                    message: obj.msg,
                    confirmCallback: function () {
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'InvHospitalCfgImportToDB',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (data) {
                                if (data.IsSuccess == true) {
                                    FrameWindow.ShowAlert({
                                        target: 'top',
                                        alertType: 'info',
                                        message: data.Msg,
                                        callback: function () {

                                        }
                                    });
                                }
                            }
                        });
                    }
                });
            }
            else if (obj.result == "DataDuplicate") {//如果是导入的数据问题，则刷新列表显示错误内容；
                //that.Query();
                $("#ImportErrorGrid").data('kendoGrid').setOptions({
                    dataSource: kendoDataSource
                });
                FrameWindow.ShowConfirm({
                    target: 'top',
                    message: '确定要覆盖重复数据吗？',
                    confirmCallback: function () {
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'InvHospitalCfgImportToDB',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (data) {
                                if (data.IsSuccess == true) {
                                    FrameWindow.ShowAlert({
                                        target: 'top',
                                        alertType: 'info',
                                        message: data.Msg,
                                        callback: function () {

                                        }
                                    });
                                }
                            }
                        });
                    }
                });
            }
            else {
                $("#ImportErrorGrid").data('kendoGrid').setOptions({
                    dataSource: kendoDataSource
                });
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: obj.msg,
                    callback: function () {

                    }
                });
            }
        }
        FrameWindow.HideLoading();
        var upload = $("#files").data("kendoUpload");
        upload.enable();
    }

    function onError(e) {
        if (e.XMLHttpRequest.responseText != "") {
            //dms.common.alert(e.XMLHttpRequest.responseText);
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: e.XMLHttpRequest.responseText,
                callback: function () {
                }
            });
        }
        FrameWindow.HideLoading();
        var upload = $("#files").data("kendoUpload");
        upload.enable();
    }
    var fields = { BeginDate: { type: "date" }, EndDate: { type: "date" } };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields);

    that.Query = function () {
        var grid = $("#ImportErrorGrid").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    var createResultList = function () {
        $("#ImportErrorGrid").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [ 
                {
                    field: "DMSHospitalName", title: "DMS医院名称", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "DMS医院名称" }
                },
                {
                    field: "InvHospitalName", title: "发票医院名称", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "发票医院名称" }
                },
                {
                    field: "Hos_Code", title: "医院编号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院编号" }
                },
                {
                    field: "Hos_SFECode", title: "SFE医院编号", width: 60,
                    headerAttributes: { "class": "text-center text-bold", "title": "SFE医院编号" }
                },
                {
                    field: "Hos_Province", title: "省份", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "省份" }
                },
                {
                    field: "Hos_City", title: "地区", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "地区" }
                },
                {
                    field: "Hos_District", title: "区/县", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "区/县" }
                },
                {
                    field: 'ErrorMsg', title: '错误信息', width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "错误信息" },
                    template: '#if(ErrorMsg != ""){# <div style="background-color:red; width:100%;height:100%;">#=ErrorMsg#</div>#}#'

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
            dataBound: function (e) {

            },
            page: function (e) {
            }
        });
    }
    var setLayout = function () {
    }

    return that;

}();