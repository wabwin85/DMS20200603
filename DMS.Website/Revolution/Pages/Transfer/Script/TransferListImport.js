var TransferListImport = {};

TransferListImport = function () {
    var that = {};

    var business = 'Transfer.TransferListImport';
    var IMPORT_TYPE = 'TransferListImport';
    var IMPORT_NAME = 'sheet1'

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        createResultList();
        $("#files").kendoUpload({
            async: {
                saveUrl: "../Handler/UploadFile.ashx?Type=" + IMPORT_TYPE + "&SheetName=" + IMPORT_NAME,
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

        $('#BtnImportDB').FrameButton({
            text: '导入',
            icon: 'file',
            onClick: function () {
                that.ImportDB();
            }
        });
        $("#BtnImportDB").FrameButton("disable");//禁用

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

            if (!obj.ImportButtonDisable) {
                $("#BtnImportDB").FrameButton("enable");
            } else {
                $("#BtnImportDB").FrameButton("disable");
            }

            if (obj.result == "Error") {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: obj.msg,
                    callback: function () {

                    }
                });
            }
            if (obj.result == "DataError") {//如果是导入的数据问题，则刷新列表显示错误内容；
                that.Query();
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: "导入数据有问题，详见错误信息列表。",
                    callback: function () {
                    }
                });
            }
            else if (obj.result == "Success") {
                var dataSource = $("#ImportErrorGrid").data("kendoGrid").dataSource;
                that.Query();

                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: obj.msg
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
    that.Query = function () {
        var grid = $("#ImportErrorGrid").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    var fields = {
        BeginDate: { type: "date" }, EndDate: { type: "date" }, CreateDate: { type: "date" },
        RequiredQty: { type: "number", validation: { required: false, min: 1 } }
    };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields);

    that.RemoveOperation = function () {
        var data = FrameUtil.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'RemoveData',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });

                FrameWindow.HideLoading();
            }
        });
    }


    var createResultList = function () {
        $("#ImportErrorGrid").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,//调整大小
            editable: true,//编辑行
            sortable: true,//排序
            scrollable: true,//滚动
            height: 500,
            columns: [
                {
                    field: "LineNbr", title: "行号", width: '80px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "行号" }
                },
               {
                   field: "DealerFrom", title: "经销商名称", width: 'auto', editable: true,
                   headerAttributes: { "class": "text-center text-bold", "title": "仓库名称" },
                   attributes: { "class": "table-td-cell #if(data.DealerFromErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.DealerFromErrMsg !=null) {# #=data.DealerFromErrMsg # #}#" }
                },
                {
                    field: "WarehouseFrom", title: "仓库名称", width: 'auto', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库名称" },
                    attributes: { "class": "table-td-cell #if(data.WarehouseFromErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.WarehouseFromErrMsg !=null) {# #=data.WarehouseFromErrMsg # #}#" }
                },
                {
                    field: "DealerTo", title: "移入经销商名称(简称)", width: 'auto', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "移入经销商名称(简称)" },
                    attributes: { "class": "table-td-cell #if(data.DealerToErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.DealerToErrMsg !=null) {# #=data.DealerToErrMsg # #}#" }
                },
                {
                    field: "WarehouseTo", title: "移入仓库名称", width: 'auto', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "移入仓库名称" },
                    attributes: { "class": "table-td-cell #if(data.WarehouseToErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.WarehouseToErrMsg !=null) {# #=data.WarehouseToErrMsg # #}#" }
                },
                {
                    field: "ArticleNumber", title: "产品型号", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell #if(data.ArticleNumberErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.ArticleNumberErrMsg !=null) {# #=data.ArticleNumberErrMsg # #}#" }
                },
                {
                    field: "LotNumber", title: "批次号", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "批次号" },
                    attributes: { "class": "table-td-cell #if(data.LotNumberErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.LotNumberErrMsg !=null) {# #=data.LotNumberErrMsg # #}#" }
                },
                {
                    field: "QRCode", title: "二维码", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell #if(data.QRCodeErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.QRCodeErrMsg !=null) {# #=data.QRCodeErrMsg # #}#" }
                },
                {
                    field: "TransferQty", title: "移库数量", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "移库数量" },
                    attributes: { "class": "table-td-cell #if(data.TransferQtyErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.TransferQtyErrMsg !=null) {# #=data.TransferQtyErrMsg # #}#" }
                },
                {
                    title: "操作", width: "150px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: " <i class='fa fa-edit' id='lnksaveStandardPrice' style='font-size: 14px; cursor: pointer;' name='edit'>" +
                    "</i>&nbsp;&nbsp;&nbsp;&nbsp;<i class='fa fa-save'  style='font-size: 14px; cursor: pointer;' name='save'></i> " +
                    "</i>&nbsp;&nbsp;&nbsp;&nbsp;<i class='fa fa-remove'  style='font-size: 14px; cursor: pointer;' name='remove'></i> ",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }

            ],
            dataBound: function (e) {
                $("#IsFirstLoad").val(false);
                var grid = e.sender;
                $("#ImportErrorGrid").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    for (var i = 1; i < tr[0].cells.length - 1; i++) {
                        $("#ImportErrorGrid").data("kendoGrid").columns[i].editable = false
                    }
                });

                $("#ImportErrorGrid").find("i[name='save']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    that.Save(data);
                });

                $("#ImportErrorGrid").find("i[name='remove']").on('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    that.Delete(data);
                })
            },
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 20,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
        });
    }
    //更改
    that.Save = function (r) {
        var data = {};
        data = r;
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Save',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                that.Query();
                if (!model.ImportButtonDisable) {
                    $("#BtnImportDB").FrameButton("enable");
                }
                FrameWindow.HideLoading();
            }
        });
    }
    //删除
    that.Delete = function (r) {
        var data = {};
        data.Id = r.Id;
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Delete',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                that.Query();
                FrameWindow.HideLoading();
            }
        });
    };
    //导入数据库
    that.ImportDB = function () {
        var data = {};
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ImportDB',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: model.ExecuteMessage,
                });
                that.Query();
                FrameWindow.HideLoading();
            },
            failCallback: function (err) {
                that.Query();
                FrameWindow.HideLoading();
            }
        });
    };

    var setLayout = function () {
    }
    return that;
}();
