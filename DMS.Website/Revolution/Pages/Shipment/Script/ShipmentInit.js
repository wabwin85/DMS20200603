var ShipmentInit = {};

ShipmentInit = function () {
    var that = {};

    var business = 'Shipment.ShipmentInitList';

    //下拉框数据源
    var LstDealer;
    var LstStatus;

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        createInitResultList();

        $('#BtnDownTemplate').FrameButton({
            text: '下载模板',
            icon: 'file',
            onClick: function () {
                window.open('/Upload/ExcelTemplate/Template_ShipmentImport.xls');
            }
        });
        $('#BtnSearchData').FrameButton({
            text: '查询待处理数据',
            icon: 'search',
            onClick: function () {
                that.QueryErrorData();
            }
        });
        $('#BtnImportData').FrameButton({
            text: '上传数据',
            icon: 'upload',
            onClick: function () {
                that.ImportCorrectData();
            }
        });
        //$('#ShipInitUpload').data("kendoUpload").destroy();
        $('#ShipInitUpload').kendoUpload({
            async: {
                saveUrl: "../Handler/UploadFile.ashx?Type=ShipmentInit&SheetName=Sheet1",
                autoUpload: true
            },
            localization: {
                headerStatusUploading: "上传处理中,请稍等..."
            },
            multiple: false,
            error: function onError(e) {
                if (e.XMLHttpRequest.responseText != "") {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: e.XMLHttpRequest.responseText,
                        callback: function () {
                        }
                    });
                }
                FrameWindow.HideLoading();
                var upload = $("#ShipInitUpload").data("kendoUpload");
                upload.enable();
            },
            success: function onSuccess(e) {
                if (e.XMLHttpRequest.responseText != "") {
                    var obj = $.parseJSON(e.XMLHttpRequest.responseText);
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: obj.msg,
                        callback: function () {
                        }
                    });
                    that.QueryErrorData();
                }
                FrameWindow.HideLoading();
                var upload = $("#ShipInitUpload").data("kendoUpload");
                upload.enable();
            },
            upload: function onUpload(e) {
                var files = e.files;
                // Check the extension of the file and abort the upload if it is not .xls or .xlsx
                $.each(files, function () {
                    if (this.extension.toLowerCase() != ".xls" && this.extension.toLowerCase() != ".xlsx") {
                        FrameWindow.ShowAlert({
                            target: 'center',
                            alertType: 'info',
                            message: '只能导入Excel文件！',
                            callback: function () {
                                e.preventDefault();
                                var dataSource = $("#RstInitImportResult").data("kendoGrid").dataSource;
                                dataSource.data([]);
                                FrameWindow.HideLoading();
                            }
                        });
                    }
                    else {
                        FrameWindow.ShowLoading();
                        var upload = $("#ShipInitUpload").data("kendoUpload");
                        upload.disable();
                    }
                });
            }
        });
        
        FrameWindow.HideLoading();
    }

    that.QueryErrorData = function () {
        var grid = $("#RstInitImportResult").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    var fields = {
        //ShipmentDate: { type: "date", validation: { format: "{0: yyyy-MM-dd}" } },
        //InvoiceDate: { type: "date",  validation: { format: "{0: yyyy-MM-dd}" } },
        //LotShipmentDate: { type: "date",  validation: { format: "{0: yyyy-MM-dd}" } },
        Price: { type: "number", validation: { min: 0.0, max: 999999999.0 } },
        Qty: { type: "number", validation: { min: 0.1, max: 999999999.0 } }
    }
    var kendoDataSource = GetKendoDataSource(business, 'QueryErrorData', fields, 20);
    var createInitResultList = function () {
        $("#RstInitImportResult").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 400,
            columns: [
                {
                    field: "LineNbr", title: "行号", width: 50, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "行号" }
                },
                {
                    field: "HospitalCode", title: "医院编号", width: 120,
                    template: "<a style='text-decoration:none;color:black;' title='#=HospitalCodeErrMsg==null?'':HospitalCodeErrMsg#'>#=HospitalCode==null?'':HospitalCode#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "医院编号" },
                    attributes: { "class": "table-td-cell #if(data.HospitalCodeErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.HospitalCodeErrMsg !=null) {# #=data.HospitalCodeErrMsg # #}#" }
                },
                {
                    field: "HospitalName", title: "医院名称", width: 150,
                    template: "<a style='text-decoration:none;color:black;' title='#=HospitalNameErrMsg==null?'':HospitalNameErrMsg#'>#=HospitalName==null?'':HospitalName#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" },
                    attributes: { "class": "table-td-cell #if(data.HospitalNameErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.HospitalNameErrMsg !=null) {# #=data.HospitalNameErrMsg # #}#" }
                },
                {
                    field: "HospitalOffice", title: "医院科室", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院科室" },
                    attributes: { "class": "table-td-cell #if(data.HospitalOfficeErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.HospitalOfficeErrMsg !=null) {# #=data.HospitalOfficeErrMsg # #}#" }
                },
                {
                    field: "InvoiceNumber", title: "发票号码", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "发票号码" },
                    attributes: { "class": "table-td-cell #if(data.InvoiceNumberErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.InvoiceNumberErrMsg !=null) {# #=data.InvoiceNumberErrMsg # #}#" }
                },
                {
                    field: "InvoiceDate", title: "发票日期", format: "{0: yyyy-MM-dd}",
                    width: 125, template: "<a style='text-decoration:none;color:black;' title='#=InvoiceDateErrMsg==null?'':InvoiceDateErrMsg#'>#=InvoiceDate==null?'':kendo.toString(InvoiceDate, 'yyyy-MM-dd')#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "发票日期" },
                    attributes: { "class": "table-td-cell #if(data.InvoiceDateErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.InvoiceDateErrMsg !=null) {# #=data.InvoiceDateErrMsg # #}#" }
                },
                {
                    field: "InvoiceTitle", title: "发票抬头", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "发票抬头" },
                    attributes: { "class": "table-td-cell #if(data.InvoiceTitleErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.InvoiceTitleErrMsg !=null) {# #=data.InvoiceTitleErrMsg # #}#" }
                },
                {
                    field: "ShipmentDate", title: "销售日期", format: "{0: yyyy-MM-dd}",
                    width: 125, template: "<a style='text-decoration:none;color:black;' title='#=ShipmentDateErrMsg==null?'':ShipmentDateErrMsg#'>#=ShipmentDate==null?'':kendo.toString(ShipmentDate, 'yyyy-MM-dd')#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售日期" },
                    attributes: { "class": "table-td-cell #if(data.ShipmentDateErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.ShipmentDateErrMsg !=null) {# #=data.ShipmentDateErrMsg # #}#" }
                },
                {
                    field: "ArticleNumber", title: "产品型号", width: 120,
                    template: "<a style='text-decoration:none;color:black;' title='#=ArticleNumberErrMsg==null?'':ArticleNumberErrMsg#'>#=ArticleNumber==null?'':ArticleNumber#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell #if(data.ArticleNumberErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.ArticleNumberErrMsg !=null) {# #=data.ArticleNumberErrMsg # #}#" }
                },
                {
                    field: "ChineseName", title: "产品名称", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品名称" },
                    attributes: { "class": "table-td-cell #if(data.ChineseNameErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.ChineseNameErrMsg !=null) {# #=data.ChineseNameErrMsg # #}#" }
                },
                {
                    field: "LotNumber", title: "产品批号", width: 120,
                    template: "<a style='text-decoration:none;color:black;' title='#=LotNumberErrMsg==null?'':LotNumberErrMsg#'>#=LotNumber==null?'':LotNumber#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品批号" },
                    attributes: { "class": "table-td-cell #if(data.LotNumberErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.LotNumberErrMsg !=null) {# #=data.LotNumberErrMsg # #}#" }
                },
                {
                    field: "QrCode", title: "二维码", width: 120,
                    template: "<a style='text-decoration:none;color:black;' title='#=QrCodeErrMsg==null?'':QrCodeErrMsg#'>#=QrCode==null?'':QrCode#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell #if(data.QrCodeErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.QrCodeErrMsg !=null) {# #=data.QrCodeErrMsg # #}#" }
                },
                {
                    field: "Price", title: "销售单价", width: 120, format: "{0:N1}",
                    template: "<a style='text-decoration:none;color:black;' title='#=PriceErrMsg==null?'':PriceErrMsg#'>#=Price==null?'':kendo.format('{0:N1}',Price)#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单价" },
                    attributes: { "class": "table-td-cell #if(data.PriceErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.PriceErrMsg !=null) {# #=data.PriceErrMsg # #}#" }
                },
                {
                    field: "Qty", title: "销售数量", width: 120, format: "{0:N1}",
                    template: "<a style='text-decoration:none;color:black;' title='#=QtyErrMsg==null?'':QtyErrMsg#'>#=Qty==null?'':kendo.format('{0:N1}',Qty)#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售数量" },
                    attributes: { "class": "table-td-cell #if(data.QtyErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.QtyErrMsg !=null) {# #=data.QtyErrMsg # #}#" }
                },
                {
                    field: "Uom", title: "产品单位", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品单位" },
                    attributes: { "class": "table-td-cell #if(data.UomErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.UomErrMsg !=null) {# #=data.UomErrMsg # #}#" }
                },
                {
                    field: "ExpiredDate", title: "产品有效期", format: "{0: yyyy-MM-dd}", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" },
                    attributes: { "class": "table-td-cell #if(data.ExpiredDateErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.ExpiredDateErrMsg !=null) {# #=data.ExpiredDateErrMsg # #}#" }
                },
                {
                    field: "Warehouse", title: "仓库名称", width: 230,
                    template: "<a style='text-decoration:none;color:black;' title='#=WarehouseErrMsg==null?'':WarehouseErrMsg#'>#=Warehouse==null?'':Warehouse#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库名称" },
                    attributes: { "class": "table-td-cell #if(data.WarehouseErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.WarehouseErrMsg !=null) {# #=data.WarehouseErrMsg # #}#" }
                },
                {
                    field: "LotShipmentDate", title: "过期产品销售日期", format: "{0: yyyy-MM-dd}",
                    width: 230, template: "<a style='text-decoration:none;color:black;' title='#=LotShipmentDateErrMsg==null?'':LotShipmentDateErrMsg#'>#=LotShipmentDate==null?'':kendo.toString(LotShipmentDate, 'yyyy-MM-dd')#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "过期产品销售日期" },
                    attributes: { "class": "table-td-cell #if(data.LotShipmentDateErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.LotShipmentDateErrMsg !=null) {# #=data.LotShipmentDateErrMsg # #}#" }
                },
                {
                    field: "Remark", title: "备注", width: 230,
                    template: "<a style='text-decoration:none;color:black;' title='#=RemarkErrMsg==null?'':RemarkErrMsg#'>#=Remark==null?'':Remark#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "备注" },
                    attributes: { "class": "table-td-cell #if(data.RemarkErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.RemarkErrMsg !=null) {# #=data.RemarkErrMsg # #}#" }
                },
                {
                    field: "ConsignmentNbr", title: "寄售申请单号", width: 230,
                    template: "<a style='text-decoration:none;color:black;' title='#=ConsignmentNbrErrMsg==null?'':ConsignmentNbrErrMsg#'>#=ConsignmentNbr==null?'':ConsignmentNbr#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "寄售申请单号" },
                    attributes: { "class": "table-td-cell #if(data.ConsignmentNbrErrMsg !=null){#ipt-grid-cell-error#} #", "title": "#if(data.ConsignmentNbrErrMsg !=null) {# #=data.ConsignmentNbrErrMsg # #}#" }
                },
                {
                    title: "删除", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-times' style='font-size: 14px; cursor: pointer;' name='delete'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
            editable: "incell",
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstInitImportResult").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    that.DeleteErrorData(data.Id);
                });

            },
            page: function (e) {
            }
        });
    }

    that.DeleteErrorData = function (initId) {
        var data = {};
        data.DelErrorId = initId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteErrorData',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess != true) {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: model.ExecuteMessage,
                        callback: function () {
                        }
                    });
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '删除成功！',
                        callback: function () {
                        }
                    });
                    that.QueryErrorData();
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.ImportCorrectData = function () {
        var initData = $("#RstInitImportResult").data("kendoGrid").dataSource.data();
        var data = {};
        var record;
        for (var i = 0; i < initData.length ; i++) {
            record = initData[i];

            if (record.HospitalName == '' || record.ShipmentDate == '' ||
                record.ArticleNumber == '' || record.LotNumber == '' ||
                record.QrCode == '' || record.Price == '' ||
                record.Qty == '' || record.Warehouse == '') {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '必填项为空！',
                    callback: function () {
                    }
                });
                return;
            }
        }
        data.RstInitImportResult = initData;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ImportCorrectData',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: model.ExecuteMessage,
                    callback: function () {
                    }
                });
                that.QueryErrorData();
                FrameWindow.HideLoading();
            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();