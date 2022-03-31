var SellInDataImport = {};

SellInDataImport = function () {
    var that = {};
    var business = 'Shipment.Extense.SellInDataInit';
    var IMPORT_TYPE = 'SellInDataImport';
    var IMPORT_NAME = 'sheet1'

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        that.GetModel();
        createResultList();

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
                    title: '状态',
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
                }
                , {
                    field: 'AccountingYear',
                    title: '核算年份',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '核算年份' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'AccountingQuarter',
                    title: '核算季度',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '核算季度' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'AccountingMonth',
                    title: '核算月份（记帐期间）',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '核算月度' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Channel',
                    title: '渠道',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '渠道' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SalesIdentity',
                    title: '销售凭证',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '销售凭证' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SalesIdentityRow',
                    title: '销售凭证行项目',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '销售凭证行项目' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'OrderType',
                    title: '订单类型',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '订单类型' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ActualDiscount',
                    title: '实际折扣',
                    width: '40px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '实际折扣' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'CompanyCode',
                    title: '公司代码',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '公司代码' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: '公司名称',
                    title: 'CompanyName',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '公司名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'IsRelated',
                    title: '关联方',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '关联方' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'RevenueType',
                    title: '收入类型',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '收入类型' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'BorderType',
                    title: '国内外',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '国内外' },
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
                    field: 'ProductProvince',
                    title: '产品线&省份',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品线&省份' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceDate',
                    title: '出具发票日期',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '出具发票日期' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SoldPartyDealerCode',
                    title: '售达方DMS Code',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '售达方DMS Code' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SoldPartySAPCode',
                    title: '售达方',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '售达方' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SoldPartyName',
                    title: '售达方名称',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '售达方名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'BillingType',
                    title: '开票类型',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '开票类型' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Province',
                    title: '省份',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '省份' },
                    editable: true,
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ExchangeRate',
                    title: '汇率',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '汇率' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'MaterialCode',
                    title: '物料',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '物料' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'MaterialName',
                    title: '物料名称',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '物料名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'UPN',
                    title: '规格型号',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '规格型号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'OutInvoiceNum',
                    title: '已出发票数量',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '已出发票数量' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceNetAmount',
                    title: '开票金额（净价）',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '开票金额（净价）' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceRate',
                    title: '开票税额',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '开票税额' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'RebateNetAmount',
                    title: '返利金额（净价）',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '返利金额（净价）' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'RebateRate',
                    title: '返利税额',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '返利税额' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceAmount',
                    title: '开票总额',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '开票总额' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'LocalCurrencyAmount',
                    title: '本币金额',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '本币金额' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'KLocalCurrencyAmount',
                    title: '本币金额(K)',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '本币金额(K)' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'DeliveryDate',
                    title: '发货日期',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发货日期' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'OrderCreateDate',
                    title: '订单创建日期',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '订单创建日期' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ProductLineAndSoldParty',
                    title: '产品线&售达方',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品线&售达方' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ActualLegalEntity',
                    title: '实控方',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '实控方' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'IsNeedRecovery',
                    title: '是否需要还原',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '是否需要还原' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'RecoveryComment',
                    title: '还原备注',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '还原备注' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'BusinessCaliber',
                    title: '商务口径收入',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '商务口径收入' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ClosedAccount',
                    title: '关账收入',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '关账收入' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Comment',
                    title: '备注',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '备注' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ProductGeneration',
                    title: '产品代次',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品代次' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'StandardPrice',
                    title: '标准价',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '标准价' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Region',
                    title: '区域',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '区域' },
                    attributes: { "class": "table-td-cell" }
                },
            ]

        });
    }

    return that;
}();