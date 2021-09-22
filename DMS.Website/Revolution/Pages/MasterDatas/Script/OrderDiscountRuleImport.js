var OrderDiscountRuleImport = {};

OrderDiscountRuleImport = function () {
    var that = {};
    var business = 'MasterDatas.OrderDiscountRuleImport';
    var IMPORT_TYPE = 'OrderDiscountRuleImport';
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

    var fields = { BeginDate: { type: "date" }, EndDate: { type: "date" }, CreateDate: { type: "date" } };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields);
    var createResultList = function () {
        $("#ImportErrorGrid").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                //{
                //    field: "ProductLineName", title: "产品线", width: '100px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                //},
                {
                    field: "DealerSAP", title: "DealerSAP", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商编号" }
                },                
                {
                    field: "Upn", title: "产品编号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品编号" }
                },                
                {
                    field: "UPNName", title: "产品名称", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "LOT", title: "批号", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "批号" }
                },
                {
                    field: "LeftValue", title: "时间区间(>=天)", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "时间区间(>=天)" }
                },
                {
                    field: "RightValue", title: "时间区间(<天)", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "时间区间(<天)" }
                },
                {
                    field: "DiscountValue", title: "折扣率", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "折扣率" }
                },
                {
                    field: "BeginDate", title: "开始时间", width: '100px', format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "开始时间" }
                },
                {
                    field: "EndDate", title: "终止时间", width: '100px', format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "终止时间" }
                },
                //{
                //    field: "CreatUser", title: "提交人", width: '100px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "提交人" }
                //},
                //{
                //    field: "CreateDate", title: "提交时间", width: '100px', format: "{0:yyyy-MM-dd}",
                //    headerAttributes: { "class": "text-center text-bold", "title": "提交时间" }
                //},
                {
                    field: "ErrMassage", title: "错误信息", width: '100px', 
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
