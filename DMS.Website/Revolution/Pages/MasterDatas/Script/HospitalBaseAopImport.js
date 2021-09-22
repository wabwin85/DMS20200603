var HospitalBaseAopImport = {};

HospitalBaseAopImport = function () {
    var that = {};
    var business = 'MasterDatas.HospitalBaseAop';
    var IMPORT_TYPE = 'HospitalBaseAopImport';
    var IMPORT_NAME = 'result';
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

    var kendoDataSource = GetKendoDataSource(business, 'QueryImport', null);
    var createResultList = function () {
        $("#ImportErrorGrid").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    field: "AOPHRI_ErrMassage", title: "错误信息", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "错误信息" }
                },
                {
                    field: "AOPHRI_SubCompanyName", title: "分子公司", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                },
                {
                    field: "AOPHRI_BrandName", title: "品牌", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                },
                {
                    field: "AOPHRI_ProductLineName", title: "产品线", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                },
                {
                    field: "AOPHRI_PCTName", title: "产品分类", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类" }
                },
                {
                    field: "AOPHRI_Year", title: "年份", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "年份" }
                },
                {
                    field: "AOPHRI_HospitalName", title: "医院名称", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" }
                },
                {
                    field: "AOPHRI_HospitalNbr", title: "医院编号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院编号" }
                },
                {
                    field: "AOPHRI_January", title: "一月", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "一月" }
                },
                {
                    field: "AOPHRI_February", title: "二月", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二月" }
                },
                {
                    field: "AOPHRI_March", title: "三月", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "三月" }
                },
                {
                    field: "AOPHRI_April", title: "四月", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "四月" }
                },
                {
                    field: "AOPHRI_May", title: "五月", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "五月" }
                },
                {
                    field: "AOPHRI_June", title: "六月", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "六月" }
                },
                {
                    field: "AOPHRI_July", title: "七月", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "七月" }
                },
                {
                    field: "AOPHRI_August", title: "八月", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "八月" }
                },
                {
                    field: "AOPHRI_September", title: "九月", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "九月" }
                },
                {
                    field: "AOPHRI_October", title: "十月", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "十月" }
                },
                {
                    field: "AOPHRI_November", title: "十一月", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "十一月" }
                },
                {
                    field: "AOPHRI_December", title: "十二月", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "十二月" }
                },
                {
                    field: "AOPHRI_IsDelete", title: "是否删除", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "是否删除" }
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
