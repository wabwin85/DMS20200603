var POReceiPtImport = {};

POReceiPtImport = function () {
    var that = {};

    var business = 'POReceipt.POReceiPtImport';
    var IMPORT_TYPE = 'POReceiPtImport';
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
            $("#batchNumber").val(obj.data);

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
                    message: '导入成功',
                    callback: function () {
                        //top.deleteTabsCurrent();
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
                    field: "LineNbr", title: "行号", width: '50px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "行号" }
                },
                {
                    field: "ProblemDescription", title: "错误信息", width: '150px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "错误信息" },
                    attributes: { "class": "table-td-cell #if(data.ProblemDescription !=null){#ipt-grid-cell-error#} #", "title": "#if(data.ProblemDescription !=null) {# #=data.ProblemDescription # #}#" }
                },
                {
                    field: "SapCode", title: "二级经销商编号", width: '150px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "二级经销商编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SapDeliveryNo", title: "二级经销商采购单编号", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "二级经销商采购单编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SapDeliveryNo", title: "物流平台或RLD发货单编号", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "物流平台或RLD发货单编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SapDeliveryDate", title: "发货日期", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "发货日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ShipmentType", title: "销售类型", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ArticleNumber", title: "产品UPN", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品UPN" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotNumber", title: "产品批号", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品批号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QRCode", title: "二维码", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DeliveryQty", title: "发货数量", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "发货数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UnitPrice", title: "发货产品价格(含税单价)", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "发货产品价格(含税单价)" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "WHMName", title: "二级商寄售仓库", width: '100px', editable: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "二级商寄售仓库" },
                    attributes: { "class": "table-td-cell" }
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

    var setLayout = function () {
    }
    return that;

}();
