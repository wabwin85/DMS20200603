var DealerInventoryHistoryReport_New = {};

DealerInventoryHistoryReport_New = function () {
    var that = {};

    var business = 'Report.DealerInventoryHistoryReport_New';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                //if (model.CanActiveDealer) {
                    $('#QryDealer').FrameDropdownList({
                        dataSource: model.LstDealer,
                        dataKey: 'DealerID',
                        dataValue: 'DealerName',
                        selectType: 'all',
                        value: model.QryDealer
                    });
                //}
                //else {
                //    $('#QryDealer').FrameDropdownList({
                //        dataSource: model.LstDealer,
                //        dataKey: 'DealerID',
                //        dataValue: 'DealerName',
                //        selectType: 'all',
                //        value: model.QryDealer,
                //        readOnly: true
                //    });
                //}

                $('#QryApplyDate').FrameDatePickerRange({
                    value: model.QryApplyDate
                });   
               
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });

                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
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
        var data = FrameUtil.GetModel();
        console.log(data);

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Query',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });

                FrameWindow.HideLoading();
            }
        });
    }

    //经销商历史库存明细报表
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Dealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'StartDate', data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'EndDate', data.QryApplyDate.EndDate);

        FrameUtil.StartDownload({
            url: urlExport,
            cookie: 'DealerInventoryHistoryReport_NewExport',
            business: business
        });
    }

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "DealerName", title: "经销商名称", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "DealerType", title: "经销商类型", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商类型" }
                },
                {
                    field: "ParentDealer", title: "上级经销商", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "上级经销商" }
                },
                {
                    field: "WarehouseName", title: "仓库", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" }
                },
                {
                    field: "WhmType", title: "仓库类型", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库类型" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "CustomerFaceNbr", title: "产品型号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
                },
                {
                    field: "CFNChineseName", title: "产品中文名称", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名称" }
                },
                {
                    field: "CFNEnglishName", title: "产品英文名称", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名称" }
                },
                {
                    field: "LotNumber", title: "序列号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号" }
                },
                {
                    field: "QRCode", title: "二维码", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "ExpiredDateString", title: "有效期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" }
                },
                {
                    field: "UnitOfMeasure", title: "单位", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" }
                },
                {
                    field: "OnHandQty", title: "库存数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "库存数量" }
                },
                {
                    field: "INV_BAK_DATE", title: "库存日期", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "库存日期" }
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
            }
        });
    }


    var setLayout = function () {
    }

    return that;
}();
