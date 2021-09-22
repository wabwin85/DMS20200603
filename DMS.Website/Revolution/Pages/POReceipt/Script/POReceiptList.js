/// <reference path="../POReceiptListInfo.aspx" />
var POReceiptList = {};

POReceiptList = function () {
    var that = {};

    var business = 'POReceipt.POReceiptList';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#DealerListType").val(model.DealerListType);
                var LayoutDealer = model.QryDealer;
                //产品线
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });
                //经销商
                //dataKey存在差异，故采用两种方式
                if (model.hidDealer != "" || model.hidDealer != null) {
                    $.each(model.LstDealer, function (index, val) {
                        if (model.hidDealer == val.Id)
                            model.QryDealer = { Key: val.Id, Value: val.ChineseShortName };
                    })
                }
                $('#QryDealer').DmsDealerFilter({
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
                    value: model.QryDealer,
                });

                //申请单类型
                $('#QryType').FrameDropdownList({
                    dataSource: model.LstType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryType
                });
                //开始日期
                var starDP = $("#QryBeginDate").kendoDatePicker({
                    value: model.QryBeginDate,
                    format: "yyyy-MM-dd",
                    depth: "month",
                    start: "month",
                }).data("kendoDatePicker");
                //starDP.element[0].disabled = true;
                //结束日期
                var endDP = $("#QryEndDate").kendoDatePicker({
                    value: model.QryEndDate,
                    dateInput: false,
                    format: "yyyy-MM-dd",
                    depth: "month",
                    start: "month",
                }).data("kendoDatePicker");
                //endDP.element[0].disabled = true;
                //申请单状态
                $('#QryStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryStatus
                });
                //发货单号
                $('#QryDeliveryOrderNo').FrameTextBox({
                    value: model.QryDeliveryOrderNo
                });
                //产品型号
                $('#QryProductType').FrameTextBox({
                    value: model.QryProductType
                });
                //批号/二维码
                $('#QryLotNumber').FrameTextBox({
                    value: model.QryLotNumber
                });
                //经销商采购单号
                $('#QryPurchaseOrderNo').FrameTextBox({
                    value: model.QryPurchaseOrderNo
                });
                $('#QryERPLineNbr').FrameTextBox({
                    value: model.QryERPLineNbr
                });
                $('#QryERPNbr').FrameTextBox({
                    value: model.QryERPNbr
                });
                //权限控制
                if (model.SerchVisibile) {
                    $('#BtnQuery').FrameButton({
                        text: '查询',
                        icon: 'search',
                        onClick: function () {
                            that.Query();
                        }
                    });
                }
                else {
                    $('#BtnQuery').remove();
                }
                $('#BtnRLDImport').remove();
                if (model.btnImportHidden) {
                    //$('#BtnRLDImport').remove();
                    $('#BtnDeliveryImport').remove();
                }
                else {
                    //$('#BtnRLDImport').FrameButton({
                    //    text: '平台及RLD发货数据导入',
                    //    icon: 'file-excel-o',
                    //    onClick: function () {
                    //        that.Import();
                    //    }
                    //});
                    $('#BtnDeliveryImport').FrameButton({
                        text: '发货数据导入',
                        icon: 'file-excel-o',
                        onClick: function () {
                            that.ImportDelivery('0');
                        }
                    });
                    $('#BtnVRDeliveryImport').FrameButton({
                        text: '虚拟发货数据导入',
                        icon: 'file-excel-o',
                        onClick: function () {
                            that.ImportDelivery('1');
                        }
                    });
                }
                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'share-square-o',
                    onClick: function () {
                        that.Export();
                    }
                });


                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
                createResultList();
            }
        });
    }

    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }
    var params = function () {
        var parm = FrameUtil.GetModel();
        parm.QryBeginDate = $("#QryBeginDate").val();
        parm.QryEndDate = $("#QryEndDate").val();
        return parm;
    };
    var fields = {};
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 15, params);

    //经销商收货列表
    that.Export = function () {
        var data = that.GetModel();
        //startDownload({
        //    url: urlExport,
        //    cookie: 'AreaListExport',
        //    business: business
        //});
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'POReceiptListExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'Bu', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Dealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Type', data.QryType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'BeginDate', $("#QryBeginDate").val());
        urlExport = Common.UpdateUrlParams(urlExport, 'EndDate', $("#QryEndDate").val());
        urlExport = Common.UpdateUrlParams(urlExport, 'Status', data.QryStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderNo', data.QryDeliveryOrderNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductType', data.QryProductType);
        urlExport = Common.UpdateUrlParams(urlExport, 'LotNumber', data.QryLotNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'PurchaseOrderNo', data.QryPurchaseOrderNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'ERPLineNbr', data.QryERPLineNbr);
        urlExport = Common.UpdateUrlParams(urlExport, 'ERPNbr', data.QryERPNbr);
        startDownload(urlExport, 'POReceiptListExport');
    }

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "DealerName", title: "经销商", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "BrandName", title: "品牌", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SapShipmentid", title: "ERP发货单号", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "ERP发货单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PurchaseOrderNbr", title: "经销商采购单号", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商采购单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PoNumber", title: "收货单号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "收货单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TypeName", title: "类型", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "VendorName", title: "发货方", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "发货方" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TotalQyt", title: "总数量", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "总数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SapShipmentDate", title: "发货时间", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "发货时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ReceiptDate", title: "收货时间", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "收货时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ReceiptUserName", title: "收货人", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "收货人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "StatusName", title: "状态", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "明细", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "打印", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-print' style='font-size: 14px; cursor: pointer;' name='print'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }

            ],
            pageable: {
                refresh: true,
                pageSizes: false,
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    that.openInfo(data.Id, data.Status, data.PurchaseOrderNbr);
                });
                $("#RstResultList").find("i[name='print']").on('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    openPrintPage(data.Id);
                })
            }
        });
    }
    //导入
    that.Import = function () {
        top.createTab({
            id: 'M_PORECEIPT_RLDEXCEL_IMPORT',
            title: '经销商收货RLD导入',
            url: 'Revolution/Pages/POReceipt/POReceiptImport.aspx'
        });
    }
    //导入
    that.ImportDelivery = function (IsVR) {
        top.createTab({
            id: 'M_PORECEIPT_DELIVERY_IMPORT',
            title: '经销商发货数据导入',
            url: 'Revolution/Pages/POReceipt/POReceiptDeliveryImport.aspx?IsVRImport=' + IsVR
        });
    }
    that.openInfo = function (InstanceId, Status, No) {
        if (InstanceId) {
            top.createTab({
                id: 'M_' + InstanceId,
                title: '经销商收货-' + ValidateDataType(No),
                url: 'Revolution/Pages/POReceipt/POReceiptListInfo.aspx?InstanceId=' + InstanceId + '&&Status=' + Status,
                refresh: true
            });
        } else {
            alert("数据异常");
        }
    }
    var openPrintPage = function (id) {
        window.open("POReceiptPrint.aspx?id=" + id, 'newwindow',
        'status=no,width=850px,height=550px,scrollbars=yes,resizable=yes,location=no,top=50,left=100');
    }

    var setLayout = function () {
    }

    return that;
}();
