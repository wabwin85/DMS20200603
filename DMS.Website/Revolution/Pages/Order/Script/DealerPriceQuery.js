var DealerPriceQuery = {};

DealerPriceQuery = function () {
    var that = {};

    var business = 'MasterDatas.OrderDealerPrice';
    var pickedList = [];
    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = FrameUtil.GetModel();
        FrameWindow.ShowLoading();
        createResultList();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'QueryInit',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#DealerListType").val(model.DealerListType);
                if (model.hidInitDealerId != "" || model.hidInitDealerId != null) {
                    $.each(model.LstDealer, function (index, val) {
                        if (model.hidInitDealerId === val.Id)
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

                if ("T2" == model.DealerType) {
                    $('#QryDealer').DmsDealerFilter('disable');
                }

                $('#QryBu').FrameDropdownList({
                    dataSource: model.ListBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });
                $('#QryUPN').FrameTextBox({

                    value: model.QryUPN
                });
                $('#QryPriceType').FrameDropdownList({
                    dataSource: model.ListPriceType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryPriceType
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
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
        
    }

    that.Query = function () {
        var data = that.GetModel();
        if (data.QryDealer && data.QryDealer.Key == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请选择经销商',
                callback: function () {
                    
                }
            });
            return;
        }
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }
    that.changeProvince = function () {
        var data = FrameUtil.GetModel();
        if (data.QryProvince.Key == '') {
            $('#QryCity').FrameDropdownList({
                dataSource: [],
                dataKey: 'TerId',
                dataValue: 'Description',
                selectType: 'all'
            });
            return;
        }
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeProvince',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryCity').FrameDropdownList({
                    dataSource: model.ListCity,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'all',
                    value: model.QryCity
                });
            }
        });
    }
    that.Delete = function (cfnpID) {
        var data = FrameUtil.GetModel();
        data.DeleteCFNPID = cfnpID
        if (confirm('确定删除此信息')) {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Delete',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '删除成功',
                            callback: function () {
                                //top.deleteTabsCurrent();
                                that.Query();
                            }
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
                    $(window).resize(function () {
                        setLayout();
                    })

                    FrameWindow.HideLoading();
                }
            });
        }
    }
    var fields = { BeginDate: { type: "date" }, EndDate: { type: "date" } };
    var kendoDataSource = GetKendoDataSource(business, 'Query2', fields);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                //{
                //    field: "ProductLine", title: "分子公司", width: '80px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                //},
                //{
                //    field: "ProductLine", title: "品牌", width: '80px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                //},
                {
                    field: "ProductLineBumName", title: "产品线", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "DmaName", title: "经销商", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                },
                {
                    field: "SapCode", title: "ERPCode", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "ERPCode" },
                },
                //{
                //    field: "ParentDmaName", title: "上级经销商", width: '100px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "上级经销商" },
                //},
                {
                    field: "CustomerFaceNbr", title: "产品代码", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品代码" }
                },
                //{
                //    field: "CfnChineseName", title: "产品中文名称", width: '150px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名称" }
                //},
                //{
                //    field: "CfnDescription", title: "产品英文名称", width: '100px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名称" }
                //},
                {
                    field: "Province", title: "省份", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "省份" }
                },
                {
                    field: "City", title: "地区", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "地区" }
                },
                {
                    field: "PriceTypeValue", title: "价格类型", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "价格类型" }
                },
                {
                    field: "Price", title: "产品价格", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品价格" }
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



    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'OrderDealerPrice');
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerId', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLineBumId', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'CfnCode', data.QryUPN);
        urlExport = Common.UpdateUrlParams(urlExport, 'PriceType', data.QryPriceType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Query', 'true');
        startDownload(urlExport, 'OrderDealerPrice');
    }
    var setLayout = function () {
    }

    return that;
}();
