var EmbedDataImport = {};

EmbedDataImport = function () {
    var that = {};
    var business = 'Shipment.Extense.EmbedDataInit';
    var IMPORT_TYPE = 'EmbedDataImport';
    var IMPORT_NAME = 'sheet1'

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        that.GetModel(); 
        createResultList();
        $('#BtnExport').click(function () {
            var grid = $("#ImportErrorGrid").data("kendoGrid");
            var rowcount = grid._data.length;
            if (rowcount == 0) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: "请导入数据，目前导入数据为空",
                    callback: function () {

                    }
                });
            }
            else {
                that.ExportData();
            }
             
        });
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

        FrameWindow.HideLoading();
    };

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
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: obj.msg,
                    callback: function () {

                    }
                });
                //FrameWindow.ShowConfirm({
                //    target: 'top',
                //    message: obj.msg,
                //    confirmCallback: function () {
                //        FrameUtil.SubmitAjax({
                //            business: business,
                //            method: 'EmbedDataImportToDB',
                //            url: Common.AppHandler,
                //            data: data,
                //            callback: function (data) {
                //                if (data.IsSuccess == true) {
                //                    FrameWindow.ShowAlert({
                //                        target: 'top',
                //                        alertType: 'info',
                //                        message: data.Msg,
                //                        callback: function () {

                //                        }
                //                    });
                //                }
                //            }
                //        });
                //    }
                //});
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

    var kendoDataSource = GetKendoDataSource(business, 'Query');

    that.Query = function () {
        var grid = $("#ImportErrorGrid").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    that.ExportData = function () { 
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'EmbedTempDataExport');
        startDownload(urlExport, 'EmbedTempDataExport');
    }

    function createResultList() {
        $('#ImportErrorGrid').kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            noRecords: true,
            editable: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 20,
                input: true,
                numeric: false
            },
            columns: [ 
                {
                    field: 'ErrorMsg',
                    title: '错误信息',
                    width: '120px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '错误信息' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SubCompany',
                    title: '分子公司',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '分子公司' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Brand',
                    title: '品牌',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '品牌' },
                    attributes: { "class": "table-td-cell" }
                }, {
                    field: 'AccountingYear',
                    title: '核算年份',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '核算年份' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'AccountingMonth',
                    title: '核算月度',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '核算月度' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'DealerCode',
                    title: 'DMS经销商编号',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '经销商编号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'DealerName',
                    title: '经销商名称',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '经销商名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'LegalEntity',
                    title: '实控方',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '实控方' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SalesEntity',
                    title: '销售方名称（发票卖方）',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '销售方名称（发票卖方）' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Hos_Level',
                    title: '医院等级',
                    width: '40px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '医院等级' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Hos_Type',
                    title: '医院类型',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '医院类型' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Hos_Code',
                    title: 'DMS医院编号',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': 'DMS医院编号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Hos_Name',
                    title: '医院名称（发票买方）',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '医院名称（发票买方）' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'NewOpenMonth',
                    title: '新开月份',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '新开月份' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'NewOpenProduct',
                    title: '新开产品',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '新开产品' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'PMA_UPN',
                    title: '规格型号',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '规格型号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'CFN_Name',
                    title: '商品名称',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '商品名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ProductLine',
                    title: '产品线',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品线' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ShipmentNbr',
                    title: '出库单号',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '出库单号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'UsedDate',
                    title: '出库/用量日期',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '用量日期' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceNumber',
                    title: '发票号码',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票号码' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceDate',
                    title: '发票日期',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票日期' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Quantity',
                    title: '数量',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '数量' },
                    editable: true,
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoicePrice',
                    title: '发票单价（不含税)',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票单价（不含税)' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceRate',
                    title: '税率',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '税率' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'AssessUnitPrice',
                    title: '考核单价（未税）',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '考核单价（未税）' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'AssessPrice',
                    title: '考核金额（未税）',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '考核金额（未税）' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Remark',
                    title: '备注',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '备注' },
                    attributes: { "class": "table-td-cell" }
                },
            ]

        });
    }

    return that;
}();