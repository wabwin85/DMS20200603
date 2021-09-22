var InventoryInit = {};

InventoryInit = function () {
    var that = {};

    var business = 'MasterDatas.InventoryInit';

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
                window.open('/Upload/ExcelTemplate/Template_Inventory.xls');
            }
        });
        //$('#BtnSearchData').FrameButton({
        //    text: '查询待处理数据',
        //    icon: 'search',
        //    onClick: function () {
        //        that.QueryErrorData();
        //    }
        //});
        $('#BtnImportData').FrameButton({
            text: '导入数据库',
            icon: 'upload',
            onClick: function () {
                that.ImportCorrectData();
            }
        });
        //$('#InvInitUpload').data("kendoUpload").destroy();
        $('#InvInitUpload').kendoUpload({
            async: {
                saveUrl: "../Handler/UploadFile.ashx?Type=InventoryInit&SheetName=Sheet1",
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
                var upload = $("#InvInitUpload").data("kendoUpload");
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
                var upload = $("#InvInitUpload").data("kendoUpload");
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
                        var upload = $("#InvInitUpload").data("kendoUpload");
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
        LtmExpiredDate: { type: "date", validation: { format: "{0: yyyy-MM-dd}" } },
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
                    field: "SapCode", title: "ERP账号", width: 120,
                    template: "<a style='text-decoration:none;color:black;' title='#=SapCodeErrMsg==null?'':SapCodeErrMsg#'>#=SapCode==null?'':SapCode#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "ERP账号" }
                },
                {
                    field: "WhmName", title: "仓库名称", width: 150,
                    template: "<a style='text-decoration:none;color:black;' title='#=WhmNameErrMsg==null?'':WhmNameErrMsg#'>#=WhmName==null?'':WhmName#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库名称" }
                },
                {
                    field: "Cfn", title: "产品型号", width: 120,
                    template: "<a style='text-decoration:none;color:black;' title='#=CfnErrMsg==null?'':CfnErrMsg#'>#=Cfn==null?'':Cfn#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
                },
                {
                    field: "LtmLotNumber", title: "批号/序列号", width: 120,
                    template: "<a style='text-decoration:none;color:black;' title='#=LtmLotNumberErrMsg==null?'':LtmLotNumberErrMsg#'>#=LtmLotNumber==null?'':LtmLotNumber#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "批号/序列号" }
                },
                {
                    field: "LtmExpiredDate", title: "有效期", format: "{0: yyyy-MM-dd}", width: 120,
                    template: "<a style='text-decoration:none;color:black;' title='#=LtmExpiredDateErrMsg==null?'':LtmExpiredDateErrMsg#'>#=LtmExpiredDate==null?'':kendo.toString(LtmExpiredDate, 'yyyy-MM-dd')#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" }
                },
                {
                    field: "Qty", title: "数量", width: 120, format: "{0:N1}",
                    template: "<a style='text-decoration:none;color:black;' title='#=QtyErrMsg==null?'':QtyErrMsg#'>#=Qty==null?'':kendo.format('{0:N1}',Qty)#</a>",
                    headerAttributes: { "class": "text-center text-bold", "title": "数量" }
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

            if (record.SapCode == null || record.SapCode == '' || record.WhmName == null || record.WhmName == '' ||
                record.Cfn == null || record.Cfn == '' || record.LtmLotNumber == null || record.LtmLotNumber == '' ||
                record.LtmExpiredDate == null || record.LtmExpiredDate == '' || record.Qty == null || record.Qty == '') {
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