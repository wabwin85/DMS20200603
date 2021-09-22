var ConsignmentTransferInit = {};

ConsignmentTransferInit = function () {
    var that = {};

    var business = 'Consign.ConsignmentTransferInit';

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
                window.open('/Upload/ExcelTemplate/Template_ConsignmentTransferImport.xls');
            }
        });
        $('#BtnImportData').FrameButton({
            text: '提交申请',
            icon: 'upload',
            onClick: function () {
                that.ImportCorrectData();
            }
        });
        $('#BtnImportData').FrameButton('disable');

        $('#TransferInitUpload').kendoUpload({
            async: {
                saveUrl: "../Handler/UploadFile.ashx?Type=Consignment&SheetName=Sheet1",
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
                var upload = $("#TransferInitUpload").data("kendoUpload");
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
                    if (obj.result == "Success")
                    {
                        $('#BtnImportData').FrameButton('enable');
                    }
                }
                FrameWindow.HideLoading();
                var upload = $("#TransferInitUpload").data("kendoUpload");
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
                        var upload = $("#TransferInitUpload").data("kendoUpload");
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

    var kendoDataSource = GetKendoDataSource(business, 'QueryErrorData', null, 20);
    var createInitResultList = function () {
        $("#RstInitImportResult").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 400,
            columns: [
                {
                    title: "删除", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-times' style='font-size: 14px; cursor: pointer;' name='delete'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "LineNbr", title: "行号", width: 50, 
                    headerAttributes: { "class": "text-center text-bold", "title": "行号" }
                },
                {
                    field: "DealerCodeTo", title: "移入经销商编号", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "移入经销商编号" }
                },
                {
                    field: "DealerNameTo", title: "移入经销商名称", width: 220,
                    headerAttributes: { "class": "text-center text-bold", "title": "移入经销商名称" }
                },
                {
                    field: "DealerCodeFrom", title: "移出经销商编号", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "移出经销商编号" }
                },
                {
                    field: "DealerNameFrom", title: "移出经销商名称", width: 220,
                    headerAttributes: { "class": "text-center text-bold", "title": "移出经销商名称" }
                },
                {
                    field: "HospitalCode", title: "医院编号", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院编号" }
                },
                {
                    field: "HospitalName", title: "医院名称", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" }
                },
                {
                    field: "ProductLineName", title: "产品线名称", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线名称" }
                },
                {
                    field: "Upn", title: "产品", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品" }
                },
                {
                    field: "Qty", title: "申请数量", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "申请数量" }
                },
                {
                    field: "ContractNo", title: "寄售合同", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "寄售合同" }
                },
                {
                    field: "ErrMassages", title: "错误信息", width: 300,
                    headerAttributes: { "class": "text-center text-bold", "title": "错误信息" }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
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
               
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '删除成功！',
                    callback: function () {
                    }
                });
                that.QueryErrorData();
                
                FrameWindow.HideLoading();
            }
        });
    }

    that.ImportCorrectData = function () {
        
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ImportCorrectData',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: (model.ExecuteMessage == "Success" ? "数据导入成功！" : model.ExecuteMessage),
                    callback: function () {
                    }
                });
                that.QueryErrorData();
                if (model.ExecuteMessage == "Success") {
                    $('#BtnImportData').FrameButton('disable');
                }
                FrameWindow.HideLoading();
            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();