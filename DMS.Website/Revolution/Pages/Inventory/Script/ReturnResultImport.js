var POReceiptDeliveryImport = {};

POReceiptDeliveryImport = function () {
    var that = {};
    var business = 'Inventory.ReturnResultImport';
    var IMPORT_TYPE = 'ReturnResultImport';
    var IMPORT_NAME = 'sheet1'
    that.Init = function () {

        var data = FrameUtil.GetModel();
        createResultList();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#OldAutoNbr').val(model.AutoNbr);
                $('#AutoNbr').val(model.AutoNbr);
                $("#files").kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadFile.ashx?Type=" + IMPORT_TYPE + "&SheetName=" + IMPORT_NAME,
                        autoUpload: true
                    },
                    localization: {
                        headerStatusUploading: "上传处理中,请稍等..."
                    },
                    multiple: false,
                    upload: onUpload,
                    success: onSuccess,
                    error: onError
                });

                var dataSource = $("#ImportErrorGrid").data("kendoGrid").dataSource;
                dataSource.data([]);

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });

        
    }

    function onUpload(e) {
        var files = e.files;
        e.data = { AutoNbr: $('#AutoNbr').val() };
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
            if (obj.result == "Error") {
                that.Query();
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: obj.msg,
                    callback: function () {
                        
                    }
                });
                //dms.common.alert(obj.msg);
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
                //dms.common.alert("导入数据有问题，详见错误信息列表。");
            }
            else if (obj.result == "Success") {
                var dataSource = $("#ImportErrorGrid").data("kendoGrid").dataSource;
                dataSource.data([]);
                
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
        that.InitAutoNumber();
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
    that.InitAutoNumber = function () {
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#OldAutoNbr').val($('#AutoNbr').val());
                $('#AutoNbr').val(model.AutoNbr);

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }
    var fields = { BeginDate: { type: "date" }, EndDate: { type: "date" } };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields);
    var createResultList = function () {
        $("#ImportErrorGrid").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
            
            {
                field: "SapCode", title: "经销商编号", width: '80px',
                headerAttributes: { "class": "text-center text-bold", "title": "经销商编号" }
            },
            {
                field: "PoNbr", title: "订单号", width: '150px',
                headerAttributes: { "class": "text-center text-bold", "title": "订单号" }
            },
            {
                field: "DeliveryNoteNbr", title: "发货单号", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "发货单号" }
            },
            {
                field: "Cfn", title: "产品型号", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
            },
            {
                field: "LotNumber", title: "批号", width: '80px',
                headerAttributes: { "class": "text-center text-bold", "title": "批号" }
            },
            {
                field: "ProblemDescription", title: "错误信息", width: 'auto',
                headerAttributes: { "class": "text-center text-bold", "title": "错误信息" }
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
