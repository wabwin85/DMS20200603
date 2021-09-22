var BatchOrderInit = {};

BatchOrderInit = function () {
    var that = {};

    var business = 'Order.BatchOrderInit';
    var IMPORT_TYPE = 'BatchOrderInit';
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
            //showFileList: false,
            multiple: false,
            upload: onUpload,
            success: onSuccess,
            error: onError
        });

        $('#BtnImportDB').FrameButton({
            text: '导入数据库',
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
            }
            else {
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
                    message: obj.msg,
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
                    field: "SapCode", title: "订单类型", width: '120px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "订单类型" },
                    attributes: { "class": "table-td-cell #if(data.OrderTypeErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.OrderTypeErrMsg !=null) {# #=data.OrderTypeErrMsg # #}#" }
                },
                {
                    field: "ProductLine", title: "产品线", width: '150px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell #if(data.ProductLineErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.ProductLineErrMsg !=null) {# #=data.ProductLineErrMsg # #}#" }
                },
                {
                    field: "ArticleNumber", title: "产品型号", width: '150px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell #if(data.ArticleNumberErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.ArticleNumberErrMsg !=null) {# #=data.ArticleNumberErrMsg # #}#" }
                },
                {
                    field: "LotNumber", title: "批次", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "批次" },
                    attributes: { "class": "table-td-cell #if(data.LotNumberErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.LotNumberErrMsg !=null) {# #=data.LotNumberErrMsg # #}#" }
                },
                {
                    field: "RequiredQty", title: "订购数量", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "订购数量" },
                    attributes: { "class": "table-td-cell #if(data.RequiredQtyErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.RequiredQtyErrMsg !=null) {# #=data.RequiredQtyErrMsg # #}#" }
                },
                {
                    field: "ErrMsg", title: "出错信息", width: 'auto', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "出错信息" },
                    attributes: { "class": "table-td-cell #if(data.AmountErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.AmountErrMsg !=null) {# #=data.AmountErrMsg # #}#" }
                }

            ],
            dataBound: function (e) {
                $("#IsFirstLoad").val(false);
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
            }
        });
    };

    var setLayout = function () {
    }
    return that;
}();
