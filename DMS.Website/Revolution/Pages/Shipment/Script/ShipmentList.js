var ShipmentList = {};

ShipmentList = function () {
    var that = {};

    var business = 'Shipment.ShipmentList';
    var chooseProduct = [];

    //下拉框数据源
    var LstDealerName;
    var LstOrderStatus;
    var LstShipmentOrderType;

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        createShipmentList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#DealerListType").val(model.DealerListType);
                $('#HidDealerType').val(model.WinSLDealerType);
                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryProductLine
                });
                $('#QryDealerName').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    parameters: { "IsAll": $("#DealerListType").val() },//查询类型
                    business: 'Util.DealerScreenFilter',
                    method: 'DealerFilter',
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'none',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealerName,
                });
                LstDealerName = model.LstDealer;
                $('#QryOrderStatus').FrameDropdownList({
                    dataSource: model.LstOrderStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryOrderStatus
                });
                LstOrderStatus = model.LstOrderStatus;
                $('#QryStartDate').FrameDatePickerRange({
                    value: model.QryStartDate
                });
                $('#QryHospital').FrameTextBox({
                    value: model.QryHospital
                });
                $('#QryOrderNumber').FrameTextBox({
                    value: model.QryOrderNumber
                });
                $('#QryCFN').FrameTextBox({
                    value: model.QryCFN
                });
                $('#QryLotNumber').FrameTextBox({
                    value: model.QryLotNumber
                });
                $('#QrySubmitDate').FrameDatePickerRange({
                    value: model.QrySubmitDate
                });
                $('#QryShipmentOrderType').FrameDropdownList({
                    dataSource: model.LstShipmentOrderType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryShipmentOrderType
                });
                LstShipmentOrderType = model.LstShipmentOrderType;
                $('#QryInvoiceStatus').FrameDropdownList({
                    dataSource: [{ Key: '未填写', Value: '未填写' }, { Key: '不完整', Value: '不完整' }, { Key: '已填写', Value: '已填写' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryInvoiceStatus
                });
                $('#QryInvoiceNo').FrameTextBox({
                    value: model.QryInvoiceNo
                });
                $('#QryInvoiceState').FrameDropdownList({
                    dataSource: [{ Key: '已上传', Value: '已上传' }, { Key: '未上传', Value: '未上传' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryInvoiceState
                });
                $('#QryInvoiceDate').FrameDatePickerRange({
                    value: model.QryInvoiceDate
                });

                $('#BtnSearch').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnUpdate').bind('click', function () {
                    $("#WinIsModified").val("new");
                    $("#WinSLOrderId").val("00000000-0000-0000-0000-000000000000");
                    $("#WinIsShipmentUpdate").val("UpdateShipment");
                    $("#WinShipmentType").val("Hospital");
                    //that.ShowDetails();
                    that.OpenDetailWin("00000000-0000-0000-0000-000000000000", "UpdateShipment", "new", "Hospital", $('#QryDealerName_Control').data("kendoDropDownList").value(), $('#HidDealerType').val());
                });
                if (model.IsAdmin || model.IsDealer) {
                    $('#liUpdate').show();
                    $('#divInsert').show();
                }
                else {
                    $('#liUpdate').hide();
                    $('#divInsert').hide();
                }
                $('#BtnExport').bind('click', function () {
                    that.Export('Export');
                });
                $('#BtnExportShipment').bind('click', function () {
                    that.Export('ExportShipment');
                });
                if (model.IsAdmin) {
                    $('#liUpdateConsignment').show();
                    $('#BtnUpdateConsignment').bind('click', function () {
                        $("#WinIsModified").val("new");
                        $("#WinSLOrderId").val("00000000-0000-0000-0000-000000000000");
                        $("#WinIsShipmentUpdate").val("UpdateShipment");
                        $("#WinShipmentType").val("Consignment");
                        //that.ShowDetails();
                        that.OpenDetailWin("00000000-0000-0000-0000-000000000000", "UpdateShipment", "new", "Consignment", $('#QryDealerName_Control').data("kendoDropDownList").value(), $('#HidDealerType').val());
                    });
                }
                else {
                    $('#liUpdateConsignment').hide();
                }

                if (model.IsDealer) {
                    //$('#QryDealerName').FrameDropdownList({
                    //    dataSource: [{ Key: model.QryDealerName.Key, Value: model.QryDealerName.Value }],
                    //    dataKey: 'Key',
                    //    dataValue: 'Value',
                    //    value: model.QryDealerName.Key
                    //});
                    if (model.WinSLDealerType == 'LP' || model.WinSLDealerType == 'LS') {
                        $('#QryDealerName').DmsDealerFilter('enable');
                    }
                    else {
                        $('#QryDealerName').DmsDealerFilter('disable');
                    }
                    if (model.ShowRemark) {
                        $('#divRemark').show();
                    }
                    else {
                        $('#divRemark').hide();
                    }
                    $('#divUpload').show();
                    $('#liInsert').show();
                    $('#liInsertConsignment').show();
                    $('#liInsertBorrow').show();
                    $('#BtnUploadFile').bind('click', function () {
                        that.UploadInvoiceAttach();
                    });
                    $('#BtnUploadInvoice').bind('click', function () {
                        that.UploadInvoiceNo();
                    });
                    $('#BtnConfirm').FrameButton({
                        text: '无销量确认',
                        onClick: function () {
                            that.DoConfirm();
                        }
                    });
                    $('#BtnInsert').bind('click', function () {
                        $("#WinIsModified").val("new");
                        $("#WinSLOrderId").val("00000000-0000-0000-0000-000000000000");
                        $("#WinIsShipmentUpdate").val("");
                        $("#WinShipmentType").val("Hospital");
                        //that.ShowDetails();
                        that.OpenDetailWin("00000000-0000-0000-0000-000000000000", "", "new", "Hospital", $('#QryDealerName_Control').data("kendoDropDownList").value(), $('#HidDealerType').val());
                    });
                    $('#BtnInsertConsignment').bind('click', function () {
                        $("#WinIsModified").val("new");
                        $("#WinSLOrderId").val("00000000-0000-0000-0000-000000000000");
                        $("#WinIsShipmentUpdate").val("");
                        $("#WinShipmentType").val("Consignment")
                        //that.ShowDetails();
                        that.OpenDetailWin("00000000-0000-0000-0000-000000000000", "", "new", "Consignment", $('#QryDealerName_Control').data("kendoDropDownList").value(), $('#HidDealerType').val());
                    });
                    $('#BtnInsertBorrow').bind('click', function () {
                        $("#WinIsModified").val("new");
                        $("#WinSLOrderId").val("00000000-0000-0000-0000-000000000000");
                        $("#WinIsShipmentUpdate").val("");
                        $("#WinShipmentType").val("Borrow");
                        //that.ShowDetails();
                        that.OpenDetailWin("00000000-0000-0000-0000-000000000000", "", "new", "Borrow", $('#QryDealerName_Control').data("kendoDropDownList").value(), $('#HidDealerType').val());
                    });
                }
                else {
                    $('#divUpload').hide();
                    $('#liInsert').hide();
                    $('#liInsertConsignment').hide();
                    $('#liInsertBorrow').hide();
                    if (model.ShowQuery != null && model.ShowQuery == false)
                        $('#BtnSearch').remove();
                }

                $('#WinSAShipDate').FrameDatePicker({
                    value: ''
                });
                //按钮
                if (model.WinShowReasonBtn) {
                    $('#BtnSLReason').FrameButton({
                        text: '授权产品线无法选择的原因',
                        icon: 'info-circle',
                        onClick: function () {
                            that.ShowReason();
                        }
                    });
                }
                $('#BtnWinDraft').FrameButton({
                    text: '保存草稿',
                    icon: 'floppy-o',
                    onClick: function () {
                        that.SaveDraft();
                    }
                });
                $('#BtnWinDelete').FrameButton({
                    text: '删除草稿',
                    icon: 'trash',
                    onClick: function () {
                        that.DeleteDraft();
                    }
                });
                $('#BtnWinNextMove').FrameButton({
                    text: '下一步',
                    icon: 'arrow-right',
                    onClick: function () {
                        that.CheckSubmit();
                    }
                });
                $('#BtnWinRevoke').FrameButton({
                    text: '冲红',
                    icon: 'times-circle',
                    onClick: function () {
                        that.DoRevoke();
                    }
                });
                $('#BtnWinPrice').FrameButton({
                    text: '修改价格',
                    icon: 'edit',
                    onClick: function () {
                        that.ShowUpdatePriceWin();
                    }
                });

                //上传功能按钮
                //批量上传发票号
                //$("#BtnWinUploadInvoiceNo").FrameButton({
                //    text: '上传附件',
                //    onClick: function () {

                //    }
                //});
                //$("#BtnWinClearInvoiceNo").FrameButton({
                //    text: '清除',
                //    onClick: function () {

                //    }
                //});
                $("#BtnWinImportInvoiceNo").FrameButton({
                    text: '导入数据库',
                    onClick: function () {
                        that.ImportInvoiceNo();
                    }
                });
                $("#BtnWinDownInvoiceTemp").FrameButton({
                    text: '下载模板',
                    onClick: function () {
                        window.open('/Upload/ExcelTemplate/Template_ShipmentInvoiceImport.xls');
                    }
                });
                //二维码导入
                $("#BtnSLQrCodeTemplate").FrameButton({
                    text: '下载模板',
                    onClick: function () {
                        window.open('/Upload/ShipmentQrCOde/Template_QrCode.xls');
                    }
                });
                //销售调整窗体
                $('#BtnSAAddHistoryData').FrameButton({
                    text: '添加历史销售数据',
                    icon: 'plus',
                    onClick: function () {
                        that.ShowAdjustHistory();
                    }
                });
                $('#BtnSAAddInventoryData').FrameButton({
                    text: '添加库存',
                    icon: 'plus',
                    onClick: function () {
                        that.ShowAdjustInventory();
                    }
                });
                $('#BtnWinAddAdjust').FrameButton({
                    text: '添加',
                    icon: 'plus',
                    onClick: function () {
                        that.AddAdjustItemsToDetail();
                    }
                });
                $('#BtnWinCloseAdjust').FrameButton({
                    text: '返回',
                    icon: 'times-circle',
                    onClick: function () {
                        $("#winSLShipmentAdjustLayout").data("kendoWindow").close();
                    }
                });
                //添加产品
                $('#BtnSCImportQrCode').FrameButton({
                    text: '导入二维码',
                    icon: 'plus',
                    onClick: function () {
                        that.ShowImportQrCodeWin();
                    }
                });
                $('#BtnSCSearch').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        clearChooseProduct();
                        that.QueryShipmentItem();
                    }
                });
                $('#BtnWinSCAdd').FrameButton({
                    text: '添加',
                    icon: 'plus',
                    onClick: function () {
                        that.AddItemsToDetail();
                        $('#winSLShipmentChooseItemLayout').data("kendoWindow").close();
                    }
                });
                $('#BtnWinSCClose').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $('#winSLShipmentChooseItemLayout').data("kendoWindow").close();
                    }
                });
                //历史单据
                $('#BtnSHSearch').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        clearChooseProduct();
                        that.QueryShipmentHistory();
                    }
                });
                $('#BtnWinSHAdd').FrameButton({
                    text: '添加',
                    icon: 'plus',
                    onClick: function () {
                        that.AddAdjustItems("Shipment");
                        ('#winSLShipmentHistoryLayout').data("kendoWindow").close();
                    }
                });
                $('#BtnWinSHClose').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $('#winSLShipmentHistoryLayout').data("kendoWindow").close();
                    }
                });
                //库存数据
                $('#BtnSIImportQrCode').FrameButton({
                    text: '导入二维码',
                    icon: 'plus',
                    onClick: function () {
                        that.ShowImportQrCodeWin();
                    }
                });
                $('#BtnSISearch').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        clearChooseProduct();
                        that.QueryShipmentInventory();
                    }
                });
                $('#BtnWinSIAdd').FrameButton({
                    text: '添加',
                    icon: 'plus',
                    onClick: function () {
                        that.AddAdjustItems("Inventory");
                        ('#winSLShipmentInventoryLayout').data("kendoWindow").close();
                    }
                });
                $('#BtnWinSIClose').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $('#winSLShipmentInventoryLayout').data("kendoWindow").close();
                    }
                });
                //检查结果窗口
                $('#BtnSLSubmitCorrect').FrameButton({
                    text: '提交（仅正确记录）',
                    icon: 'check',
                    onClick: function () {
                        that.SubmitCheckCorrectRecord();
                    }
                });
                $('#BtnSLExportError').FrameButton({
                    text: '导出（所有记录）',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export("ExportErrorData");
                    }
                });
                $('#BtnSLLastStep').FrameButton({
                    text: '返回上一步',
                    icon: 'arrow-left',
                    onClick: function () {
                        $('#winCheckSubmitResultLayout').data("kendoWindow").close();
                        $('#BtnWinNextMove').FrameButton('enable');
                    }
                });
                //更改价格
                $('#BtnWinSaveUpdatePrice').FrameButton({
                    text: '保存',
                    icon: 'save',
                    onClick: function () {
                        that.SaveUpdatePrice();
                    }
                });

                $('#WinSLAttachUpload').kendoUpload({
                    async: {
                        saveUrl: "/pageskendo/ContractElectronic/handlers/UploadHandler.ashx?Type=Attach",
                        autoUpload: true
                    },
                    validation: {
                        //allowedExtensions: [".xls", "xlsx"],
                    },
                    multiple: false,
                    success: function (e) {
                        //$("#BtnUploadProxy").FrameSortAble("FileaddNewData", e.response)
                    }
                });
                $('#WinUploadInvoiceNo').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadFile.ashx?Type=ShipmentInvoiceInit&SheetName=Sheet1",
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
                        var upload = $("#WinUploadInvoiceNo").data("kendoUpload");
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
                            that.QueryInvoiceNo();
                        }
                        FrameWindow.HideLoading();
                        var upload = $("#WinUploadInvoiceNo").data("kendoUpload");
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
                                        var dataSource = $("#RstWinInvoiceNo").data("kendoGrid").dataSource;
                                        dataSource.data([]);
                                        FrameWindow.HideLoading();
                                    }
                                });
                            }
                            else {
                                FrameWindow.ShowLoading();
                                var upload = $("#WinUploadInvoiceNo").data("kendoUpload");
                                upload.disable();
                            }
                        });
                    }
                });
                $('#WinSLQrCodeImport').kendoUpload({
                    async: {
                        saveUrl: "/pageskendo/ContractElectronic/handlers/UploadHandler.ashx?Type=Excel",
                        autoUpload: true
                    },
                    select: function (e) {
                        var file = e.files;
                        if (file[0].extension != '.xls' && file[0].extension != '.xlsx') {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '仅支持Excel上传',
                            });
                        }

                    },
                    validation: {
                        allowedExtensions: [".xls", "xlsx"],
                    },
                    multiple: false,
                    success: function (e) {
                        //$("#BtnUploadProxy").FrameSortAble("FileaddNewData", e.response)
                    }
                });

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.Query = function () {
        clearChooseProduct();
        var grid = $("#RstShipmentList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    //导出
    that.Export = function (type) {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'ShipmentListExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'ShipmentListExportType', type);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerId', data.QryDealerName.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryHospitalName', data.QryHospital);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryStartDate_Start', data.QryStartDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryStartDate_End', data.QryStartDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryOrderNo', data.QryOrderNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryOrderStatus', data.QryOrderStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryCfn', data.QryCFN);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryLotNumber', data.QryLotNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryOrderType', data.QryShipmentOrderType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QrySubmitDate_Start', data.QrySubmitDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QrySubmitDate_End', data.QrySubmitDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryInvoiceStatus', data.QryInvoiceStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryInvoiceNo', data.QryInvoiceNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryInvoiceState', data.QryInvoiceState.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryInvoiceDate_Start', data.QryInvoiceDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryInvoiceDate_End', data.QryInvoiceDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'WinSLOrderId', data.WinSLOrderId);
        startDownload(urlExport, 'ShipmentListExport');

    }

    //无销量确认
    that.DoConfirm = function () {
        var data = that.GetModel();
        if (confirm('添加无销量纪录？')) {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DoConfirm',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess != true) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: "添加失败！",
                            callback: function () {
                            }
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: "添加成功！",
                            callback: function () {
                            }
                        });
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 20);
    var createShipmentList = function () {
        $("#RstShipmentList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 280,
            columns: [
                {
                    field: "DealerId", title: "经销商", template: function (gridRow) {
                        var dealerName = "";
                        if (LstDealerName.length > 0) {
                            if (gridRow.DealerId != "") {
                                $.each(LstDealerName, function () {
                                    if (this.Id == gridRow.DealerId) {
                                        dealerName = this.ChineseShortName;
                                        return false;
                                    }
                                })
                            }
                        }
                        else {
                            dealerName = gridRow.DealerId;
                        }
                        return dealerName;
                    },
                    width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductLineName", title: "产品线",
                    width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubCompanyName", title: "分子公司",
                    width: 190,
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "BrandName", title: "品牌",
                    width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "OrderNumber", title: "销售单号",
                    width: 190,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HospitalName", title: "销售医院",
                    width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售医院" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TotalQyt", title: "总数量",
                    width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "总数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TotalAmount", title: "总金额",
                    width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "总金额" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ShipmentDate", title: "销售时间",
                    width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ShipmentName", title: "销售人",
                    width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Status", title: "状态", template: function (gridRow) {
                        var status = "";
                        if (LstOrderStatus.length > 0) {
                            if (gridRow.Status != "") {
                                $.each(LstOrderStatus, function () {
                                    if (this.Key == gridRow.Status) {
                                        status = this.Value;
                                        return false;
                                    }
                                })
                            }
                        }
                        return status;
                    },
                    width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Type", title: "销售单类型", template: function (gridRow) {
                        var type = "";
                        if (LstShipmentOrderType.length > 0) {
                            if (gridRow.Type != "") {
                                $.each(LstShipmentOrderType, function () {
                                    if (this.Key == gridRow.Type) {
                                        type = this.Value;
                                        return false;
                                    }
                                })
                            }
                        }
                        return type;
                    },
                    width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "InvoiceStatus", title: "发票状态",
                    width: 60,
                    headerAttributes: { "class": "text-center text-bold", "title": "发票状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubmitDays", title: "已上报天数",
                    width: 60,
                    headerAttributes: { "class": "text-center text-bold", "title": "已上报天数" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Annexsource", title: "附件来源",
                    width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "附件来源" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "明细",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 50,
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='detail'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "打印",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 50,
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-print' style='font-size: 14px; cursor: pointer;' name='print'></i>#}#",
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
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstShipmentList").find("i[name='detail']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    $("#WinIsModified").val("old");
                    $("#WinIsShipmentUpdate").val(data.AdjType);
                    $("#WinSLOrderId").val(data.Id);
                    //that.ShowDetails();
                    that.OpenDetailWin(data.Id, data.AdjType, "old", "", data.DealerId, $('#HidDealerType').val());
                });

                $("#RstShipmentList").find("i[name='print']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    window.open("/Pages/Shipment/ShipmentPrint.aspx?id=" + data.Id, 'newwindow',
                       'status=no,width=850px,height=550px,scrollbars=yes,resizable=yes,location=no,top=50,left=100');
                });

            },
            page: function (e) {
                clearChooseProduct();
            }
        });
    }

    that.QueryAttachInfo = function () {
        var grid = $("#RstWinSLAttachList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }
    that.QueryOPLog = function () {
        var grid = $("#RstWinSLOPLog").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    var kendoSLOPLog = GetKendoDataSource(business, 'QueryOPLog', null, 10);
    var kendoSLAttach = GetKendoDataSource(business, 'QueryAttachInfo', null, 10);
    //明细窗体部分Grid
    var createSLWinResultList = function (EditFlag) {
        //产品明细
        $("#RstWinSLProductList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 260,
            columns: [
                {
                    field: "WarehouseName", title: "分仓库", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "分仓库" }
                },
                {
                    field: "CFN", title: "产品型号", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
                },
                {
                    field: "CFNEnName", title: "产品英文名", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" }
                },
                {
                    field: "UPN", title: "产品UPN", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品UPN" }
                },
                {
                    field: "LotNumber", title: "序号/批号", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "序号/批号" }
                },
                {
                    field: "QRCode", title: "二维码", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "ExpiredDate", title: "产品有效期", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" }
                },
                {
                    field: "UnitOfMeasure", title: "单位", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" }
                },
                {
                    field: "ConvertFactor", title: "系数", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "系数" }
                },
                {
                    field: "TotalQty", title: "库存量", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "库存量" }
                },
                {
                    field: "UnitPrice", title: "单价", editable: function () {
                        return EditFlag;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "单价" }
                },
                {
                    field: "AdjAction", title: "采购价", editable: function () {
                        return EditFlag;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "采购价" }
                },
                {
                    field: "ShipmentQty", title: "销售量", editable: function () {
                        return EditFlag;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "销售量" }
                },
                {
                    field: "ShipmentDate", title: "实际用量日期", format: "{0:yyyy-MM-dd}", editable: function () {
                        return EditFlag;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "实际用量日期" }
                },
                {
                    field: "QRCodeEdit", title: "二维码", editable: function () {
                        return EditFlag;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "Remark", title: "备注", editable: function () {
                        return EditFlag;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "备注" }
                },
                {
                    field: "IsCanOrder", title: "是否有效", hidden: true, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "是否有效" }
                },
                {
                    field: "CFN_Property6", title: "CFN_Property6", hidden: true, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "CFN_Property6" }
                },
                {
                    field: "PurchaseOrderNbr", title: "寄售申请单号", editable: function () {
                        return EditFlag;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "寄售申请单号" }
                },
                {
                    field: "Id", title: "删除", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "删除" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='deleteItem'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "Id", title: "植入信息", hidden: true, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "植入信息" }
                },
                {
                    field: "QRCheck", title: "二维码发票认证", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码发票认证" }
                }

            ],
            editable: "incell",
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstWinSLProductList").find("i[name='deleteItem']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.DeleteItem(data.Id);

                });

            }
        });

        //操作记录
        $("#RstWinSLOPLog").kendoGrid({
            dataSource: kendoSLOPLog,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 275,
            columns: [
                {
                    field: "OperUserId", title: "操作人账号",
                    headerAttributes: { "class": "text-center text-bold", "title": "操作人账号" }
                },
                {
                    field: "OperUserName", title: "操作人姓名",
                    headerAttributes: { "class": "text-center text-bold", "title": "操作人姓名" }
                },
                {
                    field: "OperTypeName", title: "操作内容",
                    headerAttributes: { "class": "text-center text-bold", "title": "操作内容" }
                },
                {
                    field: "OperDate", title: "操作时间", format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "操作时间" }
                },
                {
                    field: "OperNote", title: "备注信息",
                    headerAttributes: { "class": "text-center text-bold", "title": "备注信息" }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            page: function (e) {
            }
        });

        //附件
        $("#RstWinSLAttachList").kendoGrid({
            dataSource: kendoSLAttach,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 260,
            columns: [
                {
                    field: "Name", title: "附件名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "附件名称" }
                },
                {
                    field: "Identity_Name", title: "上传人",
                    headerAttributes: { "class": "text-center text-bold", "title": "上传人" }
                },
                {
                    field: "UploadDate", title: "上传时间", format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "上传时间" }
                },
                {
                    field: "Id", title: "下载",
                    headerAttributes: { "class": "text-center text-bold", "title": "下载" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='downloadAttach'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "Id", title: "删除", hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "删除" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='deleteAttach'></i>#}#",
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
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstWinSLAttachList").find("i[name='downloadAttach']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.DownloadAttach(data.Name, data.Url);

                });

                $("#RstWinSLAttachList").find("i[name='deleteAttach']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.DeleteAttach(data.Id);
                });

            },
            page: function (e) {
            }
        });
    }

    //销售调整窗体Grid
    var createSAAdjustWinGrid = function () {
        //历史数据
        $("#RstSAHistoryOrderData").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 260,
            columns: [
                {
                    field: "DealerName", title: "经销商", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" }
                },
                {
                    field: "WarehouseName", title: "仓库", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" }
                },
                {
                    field: "ShipmentNbr", title: "销售单号", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单号" }
                },
                {
                    field: "HospitalName", title: "销售医院", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "销售医院" }
                },
                {
                    field: "SubmitDate", title: "提交日期", format: "{0:yyyy-MM-dd}", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "提交日期" }
                },
                {
                    field: "ShipmentDate", title: "用量日期", format: "{0:yyyy-MM-dd}", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "用量日期" }
                },
                {
                    field: "UPN", title: "产品型号", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
                },
                {
                    field: "UPN2", title: "短编号", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "短编号" }
                },
                {
                    field: "ProductCnName", title: "产品中文名", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" }
                },
                {
                    field: "LotNumber", title: "序列号\批号", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号\批号" }
                },
                {
                    field: "QRCode", title: "二维码", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "ExpiredDate", title: "有效期", format: "{0:yyyy-MM-dd}", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" }
                },
                {
                    field: "ShipmentQty", title: "销售数量", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "销售数量" }
                },
                {
                    field: "ShipmentPrice", title: "销售单价",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单价" }
                },
                {
                    field: "Id", title: "删除", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "删除" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-times' style='font-size: 14px; cursor: pointer;' name='deleteHistory'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }

            ],
            editable: "incell",
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstSAHistoryOrderData").find("i[name='deleteHistory']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.DeleteAdjustItem(data.Id, data.LotId);
                });

            }
        });
        //库存数据
        $("#RstSAInventoryData").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 260,
            columns: [
                {
                    field: "DealerName", title: "经销商", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" }
                },
                {
                    field: "WarehouseName", title: "仓库", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" }
                },
                {
                    field: "UPN", title: "产品型号", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
                },
                {
                    field: "UPN2", title: "短编号", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "短编号" }
                },
                {
                    field: "ProductCnName", title: "产品中文名", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" }
                },
                {
                    field: "LotNumber", title: "序列号\批号", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号\批号" }
                },
                {
                    field: "QRCode", title: "二维码", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "ExpiredDate", title: "有效期", format: "{0:yyyy-MM-dd}", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" }
                },
                {
                    field: "TotalQty", title: "库存数量", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "库存数量" }
                },
                {
                    field: "ShipmentQty", title: "销售数量",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售数量" }
                },
                {
                    field: "ShipmentPrice", title: "销售单价",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单价" }
                },
                {
                    field: "Id", title: "删除", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "删除" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-times' style='font-size: 14px; cursor: pointer;' name='deleteInventory'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }

            ],
            editable: "incell",
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstSAInventoryData").find("i[name='deleteInventory']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.DeleteAdjustItem(data.Id, data.LotId);
                });

            }
        });
    }

    that.DeleteItem = function (Id) {
        if (confirm('是否要删除该产品？')) {
            var data = that.GetModel();
            data.DelProductId = Id;
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteItem',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess != true) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '删除成功！',
                            callback: function () {
                            }
                        });
                        $("#RstWinSLProductList").data("kendoGrid").setOptions({
                            dataSource: model.RstWinSLProductList
                        });
                        if (model.WinProductQty) {
                            $("#spGP2SumQty").text(model.WinProductQty);
                        }
                        if (model.WinProductSum) {
                            $("#spGP2SumPrice").text(model.WinProductSum);
                        }
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.DeleteAdjustItem = function (Id, LotId) {
        var data = that.GetModel();
        data.DelAdjustId = Id;
        data.DelAdjustLotId = LotId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteAdjustItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess != true) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: model.ExecuteMessage,
                        callback: function () {
                        }
                    });
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '删除成功！',
                        callback: function () {
                        }
                    });
                    $("#RstSAHistoryOrderData").data("kendoGrid").setOptions({
                        dataSource: model.RstSAHistoryOrderData
                    });
                    $("#RstSAInventoryData").data("kendoGrid").setOptions({
                        dataSource: model.RstSAInventoryData
                    });
                }
                FrameWindow.HideLoading();
            }
        });

    }

    var clearChooseProduct = function () {
        $('#CheckInvItem').removeAttr("checked");
        $('#CheckAllHis').removeAttr("checked");
        $('#CheckAllInv').removeAttr("checked");
        chooseProduct.splice(0, chooseProduct.length);
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            chooseProduct.push(data);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < chooseProduct.length; i++) {
            if ((chooseProduct[i].LotId && data.LotId && chooseProduct[i].LotId == data.LotId) || (chooseProduct[i].Id && data.Id && chooseProduct[i].Id == data.Id)) {
                chooseProduct.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < chooseProduct.length; i++) {
            if ((chooseProduct[i].LotId && data.LotId && chooseProduct[i].LotId == data.LotId) || (chooseProduct[i].Id && data.Id && chooseProduct[i].Id == data.Id)) {
                exists = true;
            }
        }
        return exists;
    }

    that.UploadInvoiceAttach = function () {
        $("#winShipmentInvoiceUploadLayout").kendoWindow({
            title: "Title",
            width: 850,
            height: 300,
            actions: [
                "Maximize",
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("发票批量上传").center().open();
    }

    that.QueryInvoiceNo = function () {
        var grid = $("#RstWinInvoiceNo").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }
    var invoiceDataSource = GetKendoDataSource(business, 'QueryInvoiceNo', null, 20);
    that.UploadInvoiceNo = function () {
        $("#RstWinInvoiceNo").kendoGrid({
            dataSource: invoiceDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 230,
            columns: [
                {
                    field: "LineNbr", title: "行号",
                    headerAttributes: { "class": "text-center text-bold", "title": "行号" }
                },
                {
                    field: "ShipmentNbr", title: "销售单号",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单号" }
                },
                {
                    field: "InvoiceNo", title: "发票号",
                    headerAttributes: { "class": "text-center text-bold", "title": "发票号" }
                },
                {
                    field: "ErrorMsg", title: "错误信息",
                    headerAttributes: { "class": "text-center text-bold", "title": "错误信息" }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            }
        });
        $("#winInvoiceNoUploadLayout").kendoWindow({
            title: "Title",
            width: 750,
            height: 400,
            actions: [
                "Maximize",
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("发票号批量上传").center().open();
    }

    that.ImportInvoiceNo = function () {
        var data = {};
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ImportInvoiceNo',
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
                that.QueryInvoiceNo();

                FrameWindow.HideLoading();
            }
        });
    }

    that.OpenDetailWin = function (OrderId, IsShipmentUpdate, IsModified, ShipmentType, DealerId, DealerType) {
        if (OrderId) {
            top.createTab({
                id: 'M_' + OrderId,
                title: '销售出库单明细',
                url: 'Revolution/Pages/Shipment/ShipmentListInfo.aspx?OrderId=' + OrderId + '&&IsShipmentUpdate=' + IsShipmentUpdate + '&&IsModified=' + IsModified + '&&ShipmentType=' + ShipmentType + '&&DealerId=' + DealerId + '&&DealerType=' + DealerType,
                refresh: true
            });
        } else {
            top.createTab({
                id: 'M_ShipmentList_New',
                title: '销售出库单明细',
                url: 'Revolution/Pages/Shipment/ShipmentListInfo.aspx?OrderId=' + OrderId + '&&IsShipmentUpdate=' + IsShipmentUpdate + '&&IsModified=' + IsModified + '&&ShipmentType=' + ShipmentType + '&&DealerId=' + DealerId + '&&DealerType=' + DealerType,
                refresh: true
            });
        }
    }

    that.ShowDetails = function () {
        $("#DivSLBasicInfo").kendoTabStrip({
            animation: {
                open: {
                    effects: "fadeIn"
                }
            }
        });

        $("#HidShipDate").val("");
        var data = that.GetModel();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitDetailWin',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //基本信息
                $('#WinSLOrderId').val(model.WinSLOrderId);
                $('#WinShipmentType').val(model.WinShipmentType);
                $('#WinIsAuth').val(model.WinIsAuth);
                $('#HidShipDate').val(model.HidShipDate);
                $('#WinSLDealer').DmsDealerFilter({
                    dataSource: model.LstDealerName,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    onChange: that.ChangeDealer
                });
                $('#WinSLDealer_Control').data("kendoDropDownList").value(model.WinSLDealer.Key);
                $('#WinSLProductLine').FrameDropdownList({
                    dataSource: model.LstWinSLProductLine,
                    dataKey: 'Id',
                    dataValue: 'AttributeName',
                    selectType: 'select',
                    onChange: that.ChangeProductLine
                });
                $('#WinSLProductLine_Control').data("kendoDropDownList").value(model.WinSLProductLine.Key);
                $('#WinSLHospital').FrameDropdownList({
                    dataSource: model.LstWinSLHospital,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    onChange: that.ChangeHospital
                });
                $('#WinSLHospital_Control').data("kendoDropDownList").value(model.WinSLHospital.Key);
                $('#WinSLShipmentDate').FrameDatePicker({
                    //format: "yyyy-MM-dd"
                    max: model.WinSLShipDate_Max,
                    min: model.WinSLShipDate_Min,
                    value: model.WinSLShipmentDate,
                    onChange: that.ChangeShipDate
                });
                $('#WinSLOrderType').FrameTextBox({
                    value: model.WinSLOrderType,
                    readonly: true
                });
                $('#WinSLInvoiceNo').FrameTextBox({
                    value: model.WinSLInvoiceNo
                });
                $('#WinSLOrderNo').FrameTextBox({
                    value: model.WinSLOrderNo,
                    readonly: true
                });
                $('#WinSLInvoiceDate').FrameDatePicker({
                    value: model.WinSLInvoiceDate
                });
                $('#WinSLOrderStatus').FrameTextBox({
                    value: model.WinSLOrderStatus,
                    readonly: true
                });
                $('#WinSLInvoiceHead').FrameTextBox({
                    value: model.WinSLInvoiceHead
                });
                $('#WinSLOrderRemark').FrameTextArea({
                    value: model.WinSLOrderRemark
                });

                $('#BtnSLAddProduct').unbind('click');
                $('#BtnSLAddProduct').FrameButton({
                    text: '添加产品',
                    icon: 'plus',
                    onClick: function () {
                        that.ShowDialog(model.WinIsDetailUpdate, model.WinSLOrderId, model.WinSLOrderType, model.WinSLShipmentDate);
                    }
                });
                $('#BtnSLAddAttach').unbind('click');
                $('#BtnSLAddAttach').FrameButton({
                    text: '添加附件',
                    icon: 'plus',
                    onClick: function () {
                        that.WinUploadAttach();
                    }
                });

                var editFlag = false;
                $('#BtnWinNextMove').FrameButton('enable');
                if (model.WinSLOrderStatus == "草稿") {
                    editFlag = true;
                    $('#BtnWinNextMove').unbind('click');
                    $('#BtnWinNextMove').FrameButton({
                        text: '下一步',
                        icon: 'arrow-right',
                        onClick: function () {
                            that.CheckSubmit();
                        }
                    });
                }
                else {
                    $('#BtnWinNextMove').unbind('click');
                    $('#BtnWinNextMove').FrameButton({
                        text: '修改发票信息',
                        icon: 'edit',
                        onClick: function () {
                            that.CheckSubmit();
                        }
                    });
                }
                //产品明细
                createSLWinResultList(editFlag);
                $("#RstWinSLProductList").data("kendoGrid").setOptions({
                    dataSource: model.RstWinSLProductList
                });
                if (model.WinProductQty) {
                    $("#spGP2SumQty").text(model.WinProductQty);
                }
                if (model.WinProductSum) {
                    $("#spGP2SumPrice").text(model.WinProductSum);
                }

                //控件控制
                var gridProduct = $("#RstWinSLProductList").data("kendoGrid");
                var gridAttach = $("#RstWinSLAttachList").data("kendoGrid");
                gridProduct.hideColumn(11); //采购价
                gridProduct.hideColumn(17);    //CFN_Property6
                gridProduct.hideColumn(18);    //短期寄售申请单号
                gridProduct.hideColumn(19);    //删除
                gridAttach.showColumn(4);

                $('#WinSLDealer').DmsDealerFilter('disable');
                $('#WinSLProductLine').FrameDropdownList('disable');
                $('#WinSLHospital').FrameDropdownList('disable');
                $('#WinSLOrderRemark').FrameTextArea('disable');
                $('#WinSLInvoiceHead').FrameTextBox('disable');
                $('#WinSLShipmentDate').FrameDatePicker('disable');
                $('#WinSLInvoiceDate').FrameDatePicker('disable');
                $('#WinSLInvoiceNo').FrameTextBox('disable');
                $('#BtnWinDraft').FrameButton('disable');
                $('#BtnWinDelete').FrameButton('disable');
                $('#BtnWinNextMove').FrameButton('disable');
                $('#BtnWinRevoke').FrameButton('disable');
                $('#BtnSLAddProduct').FrameButton('disable');
                $('#BtnWinPrice').FrameButton('disable');

                if (model.WinSLOrderStatus == "草稿") {
                    $('#WinSLProductLine').FrameDropdownList('enable');
                    $('#WinSLHospital').FrameDropdownList('enable');
                    $('#WinSLDealer').DmsDealerFilter('enable');

                    $('#WinSLOrderRemark').FrameTextArea('enable');
                    $('#WinSLInvoiceHead').FrameTextBox('enable');
                    $('#WinSLInvoiceNo').FrameTextBox('enable');
                    $('#WinSLShipmentDate').FrameDatePicker('enable');
                    $('#WinSLInvoiceDate').FrameDatePicker('enable');
                    $('#BtnWinDraft').FrameButton('enable');
                    $('#BtnWinDelete').FrameButton('enable');
                    $('#BtnWinNextMove').FrameButton('enable');
                    $('#WinSLInvoiceDate').FrameDatePicker('enable');

                    //只有寄售销售单才需要管理员填写采购价
                    if (model.WinShipmentType == "Consignment") {
                        gridProduct.showColumn(11);
                    }
                    //this.GridPanel2.ColumnModel.SetEditable(13, true);
                    gridProduct.showColumn(16);
                    gridProduct.showColumn(19); //删除
                    gridAttach.showColumn(4);

                    //Edit By SongWeiming on 2015-08-25 附件下载列不显示

                }
                if (model.WinSLOrderStatus == "已完成") {
                    $('#BtnWinNextMove').FrameButton('enable');
                    $('#WinSLInvoiceNo').FrameTextBox('enable');
                    $('#WinSLInvoiceHead').FrameTextBox('enable');
                    $('#WinSLInvoiceDate').FrameDatePicker('enable');
                    if (model.WinDisablePriceBtn != null && model.WinDisablePriceBtn == false) {
                        $('#BtnWinPrice').FrameButton('enable');
                    }
                    if (model.WinDisableRevokeBtn != null && model.WinDisableRevokeBtn == false) {
                        $('#BtnWinRevoke').FrameButton('enable');
                    }
                    gridAttach.hideColumn(4);
                }
                if (model.IsDealer) {
                    $('#WinSAShipDate').FrameDatePicker('disable');
                }

                //操作记录
                that.QueryOPLog();
                that.QueryAttachInfo();

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });

        $("#winSLDetailLayout").kendoWindow({
            title: "Title",
            width: 1010,
            height: 600,
            actions: [
                "Close"
            ],
            resizable: true,
            modal: true,
            close: that.CloseDetailWin
        }).data("kendoWindow").title("销售出库单明细").center().open();

    }

    that.ChangeDealer = function () {

        var data = that.GetModel();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeDealer',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#WinSLProductLine').FrameDropdownList({
                    dataSource: model.LstWinSLProductLine,
                    dataKey: 'Id',
                    dataValue: 'AttributeName',
                    selectType: 'select',
                    onChange: that.ChangeProductLine
                });
                $('#WinSLHospital').FrameDropdownList({
                    dataSource: model.LstWinSLHospital,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    onChange: that.ChangeHospital
                });
                FrameWindow.HideLoading();
            }
        });

    }

    that.ChangeProductLine = function () {

        var data = that.GetModel();
        if (confirm('改变产品线将删除已添加的产品！')) {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'ChangeProductLine',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $("#RstWinSLProductList").data("kendoGrid").setOptions({
                        dataSource: model.RstWinSLProductList
                    });
                    if (model.WinProductQty) {
                        $("#spGP2SumQty").text(model.WinProductQty);
                    }
                    if (model.WinProductSum) {
                        $("#spGP2SumPrice").text(model.WinProductSum);
                    }
                    $('#WinSLShipmentDate').FrameDatePicker({
                        //format: "yyyy-MM-dd"
                        max: model.WinSLShipDate_Max,
                        min: model.WinSLShipDate_Min,
                        onChange: that.ChangeShipDate
                    });
                    $('#WinSLHospital').FrameDropdownList({
                        dataSource: [],
                        dataKey: 'Id',
                        dataValue: 'Name',
                        selectType: 'select',
                        onChange: that.ChangeHospital
                    });
                    SetMod(true);
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.ChangeShipDate = function () {

        var data = that.GetModel();
        if (data.WinSLProductLine.Key == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请先选择产品线！',
                callback: function () {
                }
            });
            return;
        }
        if ($("#HidShipDate").val() != data.WinSLShipmentDate) {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'ChangeShipDate',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#HidShipDate').val(model.HidShipDate);
                    $('#WinSLHospital').FrameDropdownList({
                        dataSource: model.LstWinSLHospital,
                        dataKey: 'Id',
                        dataValue: 'Name',
                        selectType: 'select',
                        onChange: that.ChangeHospital
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.ChangeHospital = function () {

        var data = that.GetModel();
        if (confirm('改变销售医院将删除不符合该医院授权的产品！')) {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'ChangeHospital',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $("#RstWinSLProductList").data("kendoGrid").setOptions({
                        dataSource: model.RstWinSLProductList
                    });
                    if (model.WinProductQty) {
                        $("#spGP2SumQty").text(model.WinProductQty);
                    }
                    if (model.WinProductSum) {
                        $("#spGP2SumPrice").text(model.WinProductSum);
                    }
                    SetMod(true);
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.ShowDialog = function (isupdate, orderid, ordertype, shipdate) {
        //判断是否符合打开对话框的条件
        //1、产品线 2、销售医院
        var model = that.GetModel();
        if (model.WinSLProductLine.Key == "" || model.WinSLHospital.Key == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请选择产品线和销售医院后再添加产品！',
                callback: function () {
                }
            });
            return;
        }
        //用量日期
        if (model.WinSLShipmentDate == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请选择用量日期后再添加产品！',
                callback: function () {
                }
            });
            return;
        }

        var SaleType = ordertype;
        var IsAuth = $("#WinIsAuth").val();
        var ShipmentDate = shipdate;
        if (isupdate) {
            $('#WinSADealer').FrameTextBox({
                value: model.WinSLDealer.Value
            });
            $('#WinSAProductLine').FrameTextBox({
                value: model.WinSLProductLine.Value
            });
            $('#WinSAUseDate').FrameTextBox({
                value: ShipmentDate
            });
            $('#WinSAHospital').FrameTextBox({
                value: model.WinSLHospital.Value
            });
            $('#WinSAAdjustReason').FrameDropdownList({
                dataSource: [{ Key: "经销商调整数据", Value: "经销商调整数据" }, { Key: "医院调整数据", Value: "医院调整数据" }, { Key: "审计调整", Value: "审计调整（仅管理员操作）" }, { Key: "系统调整", Value: "系统调整（仅管理员操作）" }, { Key: "其他调整", Value: "其他调整（仅管理员操作）" }],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'select'
            });
            that.ShowAdminShipmentDialog();
        }
        else {
            that.ShowShipmentDialog();
        }
    }

    that.ShowAdminShipmentDialog = function () {
        createSAAdjustWinGrid();
        $("#winSLShipmentAdjustLayout").kendoWindow({
            title: "Title",
            width: 900,
            height: 570,
            actions: [
                "Maximize",
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("销售调整").center().open();
    }

    that.QueryShipmentItem = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'QueryShipmentItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#RstSCInventoryItem').data("kendoGrid").setOptions({
                        dataSource: model.RstSCInventoryItem
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.ShowShipmentDialog = function () {
        $("#RstSCInventoryItem").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 280,
            columns: [
                {
                    title: "选择", width: '50px', encoded: false,
                    headerTemplate: '<input id="CheckInvItem" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=LotId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=LotId#"></label>',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "WarehouseName", title: "分仓库",
                    headerAttributes: { "class": "text-center text-bold", "title": "分仓库" }
                },
                {
                    field: "CFN", title: "产品型号",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
                },
                {
                    field: "LotNumber", title: "序列号/批号",
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号/批号" }
                },
                {
                    field: "QRCode", title: "二维码",
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "LotExpiredDate", title: "有效期",
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" }
                },
                {
                    field: "IsCanOrder", title: "是否可销售",
                    headerAttributes: { "class": "text-center text-bold", "title": "是否可销售" }
                },
                {
                    field: "UnitOfMeasure", title: "单位",
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" }
                },
                {
                    field: "LotInvQty", title: "库存数量",
                    headerAttributes: { "class": "text-center text-bold", "title": "库存数量" }
                }
            ],
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
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstSCInventoryItem").find(".Check-Item").unbind("click");
                $("#RstSCInventoryItem").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstSCInventoryItem").data("kendoGrid"),
                    dataItem = grid.dataItem(row);

                    if (checked) {
                        dataItem.IsChecked = true;
                        addItem(dataItem);
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeItem(dataItem);
                        row.removeClass("k-state-selected");
                    }
                });

                $('#CheckInvItem').unbind('change');
                $('#CheckInvItem').on('change', function (ev) {
                    var checked = ev.target.checked;
                    $('.Check-Item').each(function (idx, item) {
                        var row = $(this).closest("tr");
                        var grid = $("#RstSCInventoryItem").data("kendoGrid");
                        var data = grid.dataItem(row);

                        if (checked) {
                            addItem(data);
                            $(this).prop("checked", true); //此处设置每行的checkbox选中，必须用prop方法
                            $(this).closest("tr").addClass("k-state-selected");  //设置grid 每一行选中
                        } else {
                            removeItem(data);
                            $(this).prop("checked", false); //此处设置每行的checkbox不选中，必须用prop方法
                            $(this).closest("tr").removeClass("k-state-selected");  //设置grid 每一行不选中
                        }
                    });
                });
            },
            page: function (e) {
                clearChooseProduct();
            }
        });
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitShipmentChooseItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#WinSCWarehouse').FrameDropdownList({
                        dataSource: model.LstWinSCWarehouse,
                        dataKey: 'Id',
                        dataValue: 'Name',
                        selectType: 'select',
                        value: model.WinSCWarehouse
                    });
                    $('#WinSCExpired').FrameDropdownList({
                        dataSource: model.LstWinSCExpired,
                        dataKey: 'Key',
                        dataValue: 'Value',
                        selectType: 'select',
                        value: model.WinSCExpired
                    });
                    $('#WinSCLotNumber').FrameTextBox({
                        value: model.WinSCLotNumber
                    });
                    $('#WinSCCFN').FrameTextBox({
                        value: model.WinSCCFN
                    });
                    $('#WinSCQrCode').FrameTextBox({
                        value: model.WinSCQrCode
                    });
                }
                FrameWindow.HideLoading();
            }
        });
        $("#winSLShipmentChooseItemLayout").kendoWindow({
            title: "Title",
            width: 900,
            height: 570,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("物料选择").center().open();
    }

    that.QueryShipmentHistory = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'QueryShipmentHistory',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#RstSHHistoryItem').data("kendoGrid").setOptions({
                        dataSource: model.RstSHHistoryItem
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.ShowAdjustHistory = function () {
        $("#RstSHHistoryItem").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 310,
            columns: [
                {
                    title: "选择", width: '50px', encoded: false,
                    headerTemplate: '<input id="CheckAllHis" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "WarehouseName", title: "仓库",
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" }
                },
                {
                    field: "ShipmentNbr", title: "销售单号",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单号" }
                },
                {
                    field: "HospitalName", title: "销售医院",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售医院" }
                },
                {
                    field: "ShipmentDate", title: "用量日期",
                    headerAttributes: { "class": "text-center text-bold", "title": "用量日期" }
                },
                {
                    field: "UPN", title: "产品型号",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
                },
                {
                    field: "LotNumber", title: "序列号\批号",
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号\批号" }
                },
                {
                    field: "QRCode", title: "二维码",
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "UOM", title: "单位",
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" }
                },
                {
                    field: "ShipmentQty", title: "销售数量",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售数量" }
                },
                {
                    field: "ShipmentPrice", title: "销售单价",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单价" }
                }
            ],
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
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstSHHistoryItem").find(".Check-Item").unbind("click");
                $("#RstSHHistoryItem").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstSHHistoryItem").data("kendoGrid"),
                    dataItem = grid.dataItem(row);

                    if (checked) {
                        dataItem.IsChecked = true;
                        addItem(dataItem);
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeItem(dataItem);
                        row.removeClass("k-state-selected");
                    }
                });

                $('#CheckAllHis').unbind('change');
                $('#CheckAllHis').on('change', function (ev) {
                    var checked = ev.target.checked;
                    $('.Check-Item').each(function (idx, item) {
                        var row = $(this).closest("tr");
                        var grid = $("#RstSHHistoryItem").data("kendoGrid");
                        var data = grid.dataItem(row);

                        if (checked) {
                            addItem(data);
                            $(this).prop("checked", true); //此处设置每行的checkbox选中，必须用prop方法
                            $(this).closest("tr").addClass("k-state-selected");  //设置grid 每一行选中
                        } else {
                            removeItem(data);
                            $(this).prop("checked", false); //此处设置每行的checkbox不选中，必须用prop方法
                            $(this).closest("tr").removeClass("k-state-selected");  //设置grid 每一行不选中
                        }
                    });
                });
            },
            page: function (e) {
                clearChooseProduct();
            }
        });
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitShipmentHistory',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#WinSHWarehouse').FrameDropdownList({
                        dataSource: model.LstWinSHWarehouse,
                        dataKey: 'Id',
                        dataValue: 'Name',
                        selectType: 'select',
                        value: model.WinSHWarehouse
                    });
                    $('#WinSHHospital').FrameTextBox({
                        value: model.WinSHHospital
                    });
                    $('#WinSHShipmentNo').FrameTextBox({
                        value: model.WinSHShipmentNo
                    });
                    $('#WinSHCFN').FrameTextBox({
                        value: model.WinSHCFN
                    });
                    $('#WinSHLotNumber').FrameTextBox({
                        value: model.WinSHLotNumber
                    });
                    $('#WinSHQrCode').FrameTextBox({
                        value: model.WinSHQrCode
                    });
                }
                FrameWindow.HideLoading();
            }
        });
        $("#winSLShipmentHistoryLayout").kendoWindow({
            title: "Title",
            width: 900,
            height: 570,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("历史销售记录").center().open();
    }

    that.QueryShipmentInventory = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'QueryShipmentInventory',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#RstSIInventoryItem').data("kendoGrid").setOptions({
                        dataSource: model.RstSIInventoryItem
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.ShowAdjustInventory = function () {
        $("#RstSIInventoryItem").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 310,
            columns: [
                {
                    title: "选择", width: '50px', encoded: false,
                    headerTemplate: '<input id="CheckAllInv" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=LotId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=LotId#"></label>',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "WarehouseName", title: "仓库",
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" }
                },
                {
                    field: "CFN", title: "产品型号",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
                },
                {
                    field: "LotNumber", title: "序列号/批号",
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号/批号" }
                },
                {
                    field: "QRCode", title: "二维码",
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "LotExpiredDate", title: "有效期",
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" }
                },
                {
                    field: "IsCanOrder", title: "是否可订购",
                    headerAttributes: { "class": "text-center text-bold", "title": "是否可订购" }
                },
                {
                    field: "UnitOfMeasure", title: "单位",
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" }
                },
                {
                    field: "LotInvQty", title: "数量",
                    headerAttributes: { "class": "text-center text-bold", "title": "数量" }
                }
            ],
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
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstSIInventoryItem").find(".Check-Item").unbind("click");
                $("#RstSIInventoryItem").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstSIInventoryItem").data("kendoGrid"),
                    dataItem = grid.dataItem(row);

                    if (checked) {
                        dataItem.IsChecked = true;
                        addItem(dataItem);
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeItem(dataItem);
                        row.removeClass("k-state-selected");
                    }
                });

                $('#CheckAllInv').unbind('change');
                $('#CheckAllInv').on('change', function (ev) {
                    var checked = ev.target.checked;
                    $('.Check-Item').each(function (idx, item) {
                        var row = $(this).closest("tr");
                        var grid = $("#RstSIInventoryItem").data("kendoGrid");
                        var data = grid.dataItem(row);

                        if (checked) {
                            addItem(data);
                            $(this).prop("checked", true); //此处设置每行的checkbox选中，必须用prop方法
                            $(this).closest("tr").addClass("k-state-selected");  //设置grid 每一行选中
                        } else {
                            removeItem(data);
                            $(this).prop("checked", false); //此处设置每行的checkbox不选中，必须用prop方法
                            $(this).closest("tr").removeClass("k-state-selected");  //设置grid 每一行不选中
                        }
                    });
                });
            },
            page: function (e) {
                clearChooseProduct();
            }
        });
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitShipmentInventory',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#WinSIWarehouse').FrameDropdownList({
                        dataSource: model.LstWinSIWarehouse,
                        dataKey: 'Id',
                        dataValue: 'Name',
                        selectType: 'select',
                        value: model.WinSIWarehouse
                    });
                    $('#WinSIExpired').FrameDropdownList({
                        dataSource: model.LstWinSIExpired,
                        dataKey: 'Key',
                        dataValue: 'Value',
                        selectType: 'select',
                        value: model.WinSIExpired
                    });
                    $('#WinSILotNumber').FrameTextBox({
                        value: model.WinSILotNumber
                    });
                    $('#WinSICFN').FrameTextBox({
                        value: model.WinSICFN
                    });
                    $('#WinSIQrCode').FrameTextBox({
                        value: model.WinSIQrCode
                    });
                }
                FrameWindow.HideLoading();
            }
        });
        $("#winSLShipmentInventoryLayout").kendoWindow({
            title: "Title",
            width: 900,
            height: 570,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("库存数据").center().open();
    }

    that.ShowImportQrCodeWin = function () {
        $("#winSLQRCodeImportLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 200,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("经销商二维码导入").center().open();
    }

    that.AddAdjustItems = function (type) {
        var data = that.GetModel();
        if (chooseProduct.length > 0) {
            var param = '';
            if (type == "Shipment") {
                for (var i = 0; i < chooseProduct.length; i++) {
                    param += chooseProduct[i].Id + ',';
                }
                data.ParaHistoryItem = param;
                data.ParaInventoryItem = null;
            } else {
                for (var i = 0; i < chooseProduct.length; i++) {
                    param += chooseProduct[i].LotId + ',';
                }
                data.ParaInventoryItem = param;
                data.ParaHistoryItem = null;
            }
            FrameUtil.SubmitAjax({
                business: business,
                method: 'AddAdjustItems',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    if (model.IsSuccess == true) {
                        $("#RstSAInventoryData").data("kendoGrid").setOptions({
                            dataSource: model.RstSAInventoryData
                        });
                        $("#RstSAHistoryOrderData").data("kendoGrid").setOptions({
                            dataSource: model.RstSAHistoryOrderData
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
        else {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请选择要添加的数据！',
                callback: function () {
                }
            });
        }
    }

    that.AddItemsToDetail = function () {
        var data = that.GetModel();
        if (chooseProduct.length > 0) {
            var param = '';
            for (var i = 0; i < chooseProduct.length; i++) {
                param += chooseProduct[i].LotId + ',';
            }
            data.ParaChooseItem = param;
            FrameUtil.SubmitAjax({
                business: business,
                method: 'AddItemsToDetail',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    if (model.IsSuccess == true) {
                        $("#RstWinSLProductList").data("kendoGrid").setOptions({
                            dataSource: model.RstWinSLProductList
                        });
                        if (model.WinProductQty) {
                            $("#spGP2SumQty").text(model.WinProductQty);
                        }
                        if (model.WinProductSum) {
                            $("#spGP2SumPrice").text(model.WinProductSum);
                        }
                        $("#winSLShipmentChooseItemLayout").data("kendoWindow").close();
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
        else {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请选择要添加的数据！',
                callback: function () {
                }
            });
        }
    }

    that.AddAdjustItemsToDetail = function () {
        var data = that.GetModel();
        var record;
        var inventory = $("#RstSAInventoryData").data("kendoGrid").dataSource.data();
        var history = $("#RstSAHistoryOrderData").data("kendoGrid").dataSource.data();
        if (data.WinSLOrderType == '寄售产品销售单') {
            for (var i = 0; i < inventory.length ; i++) {
                record = inventory[i];

                if (record.ShipmentPrice == '' || record.ShipmentPrice == null) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '请填写销售单价！',
                        callback: function () {
                        }
                    });
                    return;
                }
            }

            for (var i = 0; i < history.length ; i++) {
                record = history[i];

                if (record.ShipmentPrice == '' || record.ShipmentPrice == null) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '请填写销售单价！',
                        callback: function () {
                        }
                    });
                    return;
                }
                if (record.ShipmentQty == '' || record.ShipmentQty == null || record.ShipmentQty == 0) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '请填写销售数量！',
                        callback: function () {
                        }
                    });
                    return;
                }
            }
        }

        data.RstSAInventoryData = inventory;
        data.RstSAHistoryOrderData = history;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'AddShipmentAdjustToShipmentLot',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#WinSLOrderRemark').FrameTextArea({
                        value: model.WinSLOrderRemark
                    });
                    $("#RstWinSLProductList").data("kendoGrid").setOptions({
                        dataSource: model.RstWinSLProductList
                    });
                    if (model.WinProductQty) {
                        $("#spGP2SumQty").text(model.WinProductQty);
                    }
                    if (model.WinProductSum) {
                        $("#spGP2SumPrice").text(model.WinProductSum);
                    }
                    $("#winSLShipmentAdjustLayout").data("kendoWindow").close();
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: model.ExecuteMessage,
                        callback: function () {
                        }
                    });
                }
                FrameWindow.HideLoading();
            }
        });

    }

    that.ShowUpdatePriceWin = function () {
        $("#RstSLWinOrderPrice").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 230,
            columns: [
                {
                    field: "WarehouseName", title: "分仓库", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "分仓库" }
                },
                {
                    field: "CFN", title: "产品型号", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
                },
                {
                    field: "CFNEnName", title: "产品英文名", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" }
                },
                {
                    field: "UPN", title: "产品UPN", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品UPN" }
                },
                {
                    field: "LotNumber", title: "序号/批号", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "序号/批号" }
                },
                {
                    field: "QRCode", title: "二维码", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "ExpiredDate", title: "产品有效期", format: "{0:yyyy-MM-dd}", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" }
                },
                {
                    field: "UnitOfMeasure", title: "单位", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" }
                },
                {
                    field: "ConvertFactor", title: "系数", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "系数" }
                },
                {
                    field: "TotalQty", title: "库存量", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "库存量" }
                },
                {
                    field: "UnitPrice", title: "单价",
                    headerAttributes: { "class": "text-center text-bold", "title": "单价" }
                },
                {
                    field: "ShipmentQty", title: "销售量", editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "销售量" }
                }

            ],
            editable: "incell"
        });
        var data = { WinSLOrderId: $("#WinSLOrderId").val(), HidShipDate: $("#HidShipDate").val() };
        FrameUtil.SubmitAjax({
            business: business,
            method: 'OrderPriceList',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#RstSLWinOrderPrice').data("kendoGrid").setOptions({
                        dataSource: model.RstSLWinOrderPrice
                    });
                }
                FrameWindow.HideLoading();
            }
        });

        $("#winUpdateOrderPriceLayout").kendoWindow({
            title: "Title",
            width: 900,
            height: 300,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("销售单数据提交核查结果").center().open();
    }

    that.SaveUpdatePrice = function () {
        var grid = $("#RstSLWinOrderPrice").data("kendoGrid").dataSource.data();
        var data = that.GetModel();
        data.RstSLWinOrderPrice = grid;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveUpdatePrice',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    that.QueryOPLog();
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: model.ExecuteMessage,
                        callback: function () {
                        }
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.ShowCheckSubmitResultWin = function () {
        $("#RstSLWinCheckResult").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 230,
            columns: [
                {
                    field: "IsError", title: "结果",
                    headerAttributes: { "class": "text-center text-bold", "title": "结果" }
                },
                {
                    field: "ShipmentDate", title: "用量日期", format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "用量日期" }
                },
                {
                    field: "WhmName", title: "仓库",
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" }
                },
                {
                    field: "CustomerFaceNbr", title: "产品型号",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
                },
                {
                    field: "CfnChineseName", title: "产品名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品名称" }
                },
                {
                    field: "ConvertFactor", title: "包装数",
                    headerAttributes: { "class": "text-center text-bold", "title": "包装数" }
                },
                {
                    field: "LotNumber", title: "批号",
                    headerAttributes: { "class": "text-center text-bold", "title": "批号" }
                },
                {
                    field: "QrCode", title: "二维码",
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "ExpiredDate", title: "产品有效期", format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" }
                },
                {
                    field: "TotalQty", title: "可用库存数",
                    headerAttributes: { "class": "text-center text-bold", "title": "可用库存数" }
                },
                {
                    field: "ShipmentQty", title: "销售数量",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售数量" }
                },
                {
                    field: "AvailableQty", title: "剩余库存",
                    headerAttributes: { "class": "text-center text-bold", "title": "剩余库存" }
                },
                {
                    field: "SalesUnitPrice", title: "销售单价",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单价" }
                },
                {
                    field: "ErrorType", title: "错误类别",
                    headerAttributes: { "class": "text-center text-bold", "title": "错误类别" }
                },
                {
                    field: "ErrorDesc", title: "错误描述",
                    headerAttributes: { "class": "text-center text-bold", "title": "错误描述" }
                },
                {
                    field: "ErrorFixSuggestion", title: "建议修改",
                    headerAttributes: { "class": "text-center text-bold", "title": "建议修改" }
                }

            ]
        });
        var data = { WinSLOrderId: $("#WinSLOrderId").val(), HidShipDate: $("#HidShipDate").val() };
        FrameUtil.SubmitAjax({
            business: business,
            method: 'CheckSubmitResult',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#RstSLWinCheckResult').data("kendoGrid").setOptions({
                        dataSource: model.RstSLWinCheckResult
                    });
                    $('#spWrongCnt').text(model.WinWrongCnt);
                    $('#spCorrectCnt').text(model.WinCorrectCnt);
                    $('#spSumQty').text(model.WinProductQty);
                    $('#spSumPrice').text(model.WinProductSum);
                }
                FrameWindow.HideLoading();
            }
        });

        $("#winCheckSubmitResultLayout").kendoWindow({
            title: "Title",
            width: 900,
            height: 365,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("销售单数据提交核查结果").center().open();
    }

    var SetMod = function (changed) {
        var data = that.GetModel();
        if (data.WinSLProductLine.Key == "" || data.WinSLHospital.Key == "") {
            $("#BtnSLAddProduct").FrameButton('disable');
        }
        else {
            $("#BtnSLAddProduct").FrameButton('enable');
        }
        var WinIsModified = $('#WinIsModified').val();
        if (changed) {
            if (WinIsModified == 'new') {
                $('#WinIsModified').val('newchanged');
            } else if (WinIsModified == 'old') {
                $('#WinIsModified').val('oldchanged');
            }
        }
    }

    that.CloseDetailWin = function () {
        var currenStatus = $('#WinIsModified').val();
        //Ext.getCmp('orderTypeWin').hide();
        if (currenStatus == 'new') {
            that.DeleteDraft();
        }
        if (currenStatus == 'newchanged') {
            //第一次新增的窗口
            if (!confirm('数据已被修改，是否保存？')) {
                that.DeleteDraft();
            }
        }
        if (currenStatus == 'oldchanged') {
            //修改窗口

            if (!confirm('数据已被修改，是否保存？')) {
                //alert('用户需保存草稿或提交数据');
                $('#WinIsModified').val('');
                top.deleteTabsCurrent();
            }
        }
    }

    that.SaveDraft = function () {
        var data = that.GetModel();

        if (data.WinSLOrderRemark && data.WinSLOrderRemark.length > 2000) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '备注内容不能超过2000字',
                callback: function () {
                }
            });
            return;
        }

        var gridProduct = $("#RstWinSLProductList").data("kendoGrid").dataSource.data();
        data.RstWinSLProductList = gridProduct;

        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveDraft',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: model.ExecuteMessage,
                    callback: function () {
                    }
                });
                if (model.IsSuccess == true) {
                    $('#WinIsModified').val('');
                    $("#winSLDetailLayout").data("kendoWindow").close();
                    that.Query();
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.DeleteDraft = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteDraft',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess != true) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: "删除草稿失败！",
                        callback: function () {
                        }
                    });
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: "删除草稿成功！",
                        callback: function () {
                        }
                    });
                    $('#WinIsModified').val('');
                    $("#winSLDetailLayout").data("kendoWindow").close();
                    that.Query();
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.DoRevoke = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DoRevoke',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: "删除草稿失败！",
                    callback: function () {
                    }
                });
                if (model.IsSuccess == true) {
                    $('#WinIsModified').val('');
                    $("#winSLDetailLayout").data("kendoWindow").close();
                    that.Query();
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.ShowReason = function () {
        $("#RstWinSLReason").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 230,
            columns: [
                {
                    field: "ProductLineName", title: "产品线",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "OrderNumber", title: "销售单号",
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单号" }
                }

            ]
        });
        var data = {};
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DoRevoke',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $('#RstWinSLReason').data("kendoGrid").setOptions({
                        dataSource: model.RstWinSLReason
                    });
                }
                FrameWindow.HideLoading();
            }
        });

        $("#winReasonLayout").kendoWindow({
            title: "Title",
            width: 500,
            height: 300,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("产品线无法选择原因").center().open();
    }

    that.CheckSubmit = function () {
        $('#BtnWinNextMove').FrameButton('disable');
        var data = that.GetModel();

        if (data.WinSLOrderStatus == '已完成') {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DoSubmit',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    if (model.IsSuccess == true) {
                        $("#WinIsModified").val("");
                        that.Query();
                        $("#winSLDetailLayout").data("kendoWindow").close();
                        if (model.ExecuteMessage != null && model.ExecuteMessage != "") {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: model.ExecuteMessage,
                                callback: function () {
                                }
                            });
                        }
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
                    }
                    FrameWindow.HideLoading();
                }
            });
        } else {
            //if ($('#hiddenIsEditting').val() != '') {
            //    FrameWindow.ShowAlert({
            //        target: 'top',
            //        alertType: 'info',
            //        message: '操作未完成，请稍后点击！',
            //        callback: function () {
            //        }
            //    });
            //    return;
            //}
            if (data.WinSLOrderRemark.length > 2000) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '备注内容不能超过2000字！',
                    callback: function () {
                    }
                });
                return;
            }

            var cbProductLineWin = data.WinSLProductLine;
            var cbHospitalWin = data.WinSLHospital;
            var grid = $('#RstWinSLProductList').data("kendoGrid").items();
            var hiddenDealerType = $('#HidDealerType');
            var hiddenShipmentType = data.WinShipmentType;
            var txtShipmentDateWin = data.WinSLShipmentDate;
            var txtOrderStatusWin = data.WinSLOrderStatus;

            if (txtShipmentDateWin != '') {
                if (cbProductLineWin.Key != '' && cbHospitalWin.Key != '' &&
                     ((hiddenDealerType.val() != 'T2' && grid.length > 0)
                       || (hiddenDealerType.val() == 'T2' && hiddenShipmentType == '寄售产品销售单')
                       || (hiddenDealerType.val() == 'T2' && hiddenShipmentType != '寄售产品销售单')
                      )
                    ) {
                    //数据核查
                    var store;
                    var strBasicChkRtn = '';
                    var qtyCheck = 0;

                    store = $("#RstWinSLProductList").data("kendoGrid").dataSource.data();

                    //逐行遍历校验数据（基础校验）
                    for (var i = 0; i < store.length ; i++) {
                        var record = store[i];

                        //仅草稿状态的单据，在提价时才会进行逐行明细数据的校验
                        if (txtOrderStatusWin == '草稿' || txtOrderStatusWin == '') {

                            var re = /^[1-9]\d*$/;
                            if (!re.test(record.ShipmentQty * record.ConvertFactor) && record.ShipmentQty > 0 && record.ConvertFactor != "3") {
                                strBasicChkRtn += '批号：' + record.LotNumber + ' 填写的销售数量有误！<br>'
                            }

                            if (record.ShipmentQty == 0) {
                                strBasicChkRtn += '批号：' + record.LotNumber + ' 销售数量不能为0！<br>'
                            }

                            if (record.UnitPrice == null || record.UnitPrice == '') {
                                strBasicChkRtn += '批号：' + record.LotNumber + ' 请填写产品单价！<br>'
                            }

                            if (record.QRCodeEdit != null && record.QRCodeEdit != '' && record.ShipmentQty > 1) {
                                strBasicChkRtn += '带二维码的产品数量不得大于一<br>';
                            }

                        }
                    }

                    //如果基础校验全部通过，则调用Ajax方法进行库存、用量日期等的校验
                    if (strBasicChkRtn == '') {

                        data.RstWinSLProductList = store;
                        //Begin Ajax：CheckSubmit
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'CheckSubmit',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {

                                if (model.IsSuccess == true) {
                                    that.ShowCheckSubmitResultWin();
                                }
                                else {
                                    FrameWindow.ShowAlert({
                                        target: 'top',
                                        alertType: 'info',
                                        message: model.ExecuteMessage,
                                        callback: function () {
                                        }
                                    });
                                    $('#BtnWinNextMove').FrameButton('enable');
                                }
                                FrameWindow.HideLoading();
                            }
                        });
                    } else {
                        //提示错误信息
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: strBasicChkRtn,
                            callback: function () {
                            }
                        });
                        $('#BtnWinNextMove').FrameButton('enable');
                    }


                } else {
                    //请填写完整后再提交！
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '请填写完整后再提交！',
                        callback: function () {
                        }
                    });
                    $('#BtnWinNextMove').FrameButton('enable');
                }

            } else {
                //请填写销售日期！
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '请填写销售日期！',
                    callback: function () {
                    }
                });
                $('#BtnWinNextMove').FrameButton('enable');
            }
        }
    }

    that.SubmitCheckCorrectRecord = function () {
        $('#BtnSLSubmitCorrect').FrameButton('disable');
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DoSubmit',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess == true) {
                    $("#WinIsModified").val("");
                    that.Query();
                    $("#winSLDetailLayout").data("kendoWindow").close();
                    $("#winCheckSubmitResultLayout").data("kendoWindow").close();
                    if (model.ExecuteMessage != null && model.ExecuteMessage != "") {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
                    }
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: model.ExecuteMessage,
                        callback: function () {
                        }
                    });
                    $('#BtnSLSubmitCorrect').FrameButton('enable');
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.WinUploadAttach = function () {
        $("#winSLAttachmentLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 200,
            actions: [
                "Close"
            ],
            resizable: false,
            close: function () {
                that.QueryAttachInfo();
            }
            //modal: true,
        }).data("kendoWindow").title("上传附件").center().open();
    }

    that.DownloadAttach = function (Name, Url) {
        var url = '/Pages/Download.aspx?downloadname=' + escape(Name) + '&filename=' + escape(Url) + '&downtype=ShipmentToHospital';
        open(url, 'Download');
    }

    that.DeleteAttach = function (ID) {
        var data = {};
        data.DelAttachId = ID;
        if (confirm('是否要删除该附件？')) {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteAttach',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess != true) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '删除成功！',
                            callback: function () {
                            }
                        });
                        that.QueryAttachInfo();
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    var setLayout = function () {
    }

    return that;
}();