var DealerSalesStatistics_New = {};

DealerSalesStatistics_New = function () {
    var that = {};

    var business = 'Report.DealerSalesStatistics_New';

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

                var InDueTimeDataSource = [];

                InDueTimeDataSource.push({ 'Key': '0', 'Value': '全部' }, { 'Key': '1', 'Value': '否' }, { 'Key': '2', 'Value': '是' }, { 'Key': '3', 'Value': '无销量' });

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

                $('#QryStartDate').FrameDatePickerRange({
                    value: model.QryStartDate
                });

                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'ProductLineID',
                    dataValue: 'ProductLineName',
                    selectType: 'all',
                    value: model.QryProductLine
                });

                $('#QryEndDate').FrameDatePickerRange({
                    value: model.QryEndDate
                }); 

                $('#QryInDueTime').FrameDropdownList({
                    dataSource: InDueTimeDataSource,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    value: model.QryInDueTime
                });

                $('#QryIsPurchased').FrameSwitch({
                    value: model.QryIsPurchased
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

    //经销商数据及时率报表
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Dealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'StartbeginTime', data.QryStartDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'StartstopTime', data.QryStartDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'EndbeginTime', data.QryEndDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'EndstopTime', data.QryEndDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'InDueTime', data.QryInDueTime.Value);
        urlExport = Common.UpdateUrlParams(urlExport, 'IsPurchased', data.QryIsPurchased);

        FrameUtil.StartDownload({
            url: urlExport,
            cookie: 'DealerSalesStatistics_NewExport',
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
                    field: "DMA_ChineseName", title: "经销商名称", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "DMA_EnglishName", title: "经销商英文名称", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商英文名称" }
                },
                {
                    field: "DMA_SAP_Code", title: "经销商ERP Account", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商ERP Account" }
                },
                {
                    field: "Month", title: "月度", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "月度" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "StartTime", title: "开始时间", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "开始时间" }
                },
                {
                    field: "EndTime", title: "结束时间", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "结束时间" }
                },
                {
                    field: "InDueTime", title: "及时上传", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "及时上传" }
                },
                {
                    field: "IsPurchased", title: "是否已采购", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "是否已采购" }
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
