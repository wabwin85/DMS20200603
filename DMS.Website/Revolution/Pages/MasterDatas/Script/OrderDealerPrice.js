var OrderDealerPrice = {};

OrderDealerPrice = function () {
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
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryDealer').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'none',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealer,
                    //readonly: model.cbDealerDisabled,
                });
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
                $('#QryProvince').FrameDropdownList({
                    dataSource: model.ListProvince,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'all',
                    value: model.QryProvince,
                    onChange: that.changeProvince
                });
                $('#QryCity').FrameDropdownList({
                    dataSource: model.ListCity,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'all',
                    value: model.QryCity
                });

                
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnImport').FrameButton({
                    text: '导入',
                    icon: 'upload',
                    onClick: function () {
                        that.openInfo();
                    }
                });

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });

                $('#BtnImportProduct').FrameButton({
                    text: '导入产品',
                    icon: 'upload',
                    onClick: function () {
                        if (confirm('确定从金蝶ERP同步产品数据？')) {
                            that.importProduct();
                        }
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
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    field: "DmaName", title: "经销商", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                },
                {
                    field: "SapCode", title: "SAPCode", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "SAPCode" },
                },
                {
                    field: "ParentDmaName", title: "上级经销商", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "上级经销商" },
                },
                {
                    field: "CustomerFaceNbr", title: "产品代码", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品代码" }
                },
                {
                    field: "CfnChineseName", title: "产品中文名称", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名称" }
                },
                {
                    field: "CfnDescription", title: "产品英文名称", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名称" }
                },
                //{
                //    field: "Lot", title: "产品线", width: '80px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
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
                    field: "DealerType", title: "价格所属", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "价格所属" }
                },
                {
                    field: "Price", title: "产品价格", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品价格" }
                },
                {
                    field: "BeginDate", title: "开始时间", width: '100px',format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "开始时间" }
                },
                {
                    field: "EndDate", title: "终止时间", width: '100px', format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "终止时间" }
                }
                ,
                {
                    title: "删除", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='delete'></i>",
                    attributes: {
                        "class": "text-center text-bold"
                    }
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
                var grid = e.sender;
                $("#RstResultList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    var CFNPId = data.Id;
                    that.Delete(CFNPId);
                });
            },
            page: function (e) {
            }
        });
    }

    that.importProduct = function () {
        var data = FrameUtil.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ImportProduct',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '同步成功',
                    callback: function () {
                    }
                });
                FrameWindow.HideLoading();
            }
        });
    }

    that.openInfo = function () {
        top.createTab({
            id: 'M_价格导入',
            title: '价格导入',
            url: 'Revolution/Pages/MasterDatas/OrderDealerPriceImport.aspx'
        });
    }

    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'OrderDealerPriceListExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerId', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLineBumId', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'CfnCode', data.QryUPN);
        urlExport = Common.UpdateUrlParams(urlExport, 'PriceType', data.QryPriceType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Province', data.QryProvince.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'City', data.QryCity.Key);
        startDownload(urlExport, 'OrderDealerPriceListExport');
    }
    var setLayout = function () {
    }

    return that;
}();
