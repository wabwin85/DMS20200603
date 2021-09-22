var DealerPage = {};

DealerPage = function () {
    var that = {};

    var business = 'Dashboard.DealerPage';

    var hyperLink = {
        'POReceipt': { ByDealerType: false, PowerKey: "M2_DealerReceipt", Title: "经销商收货", Url: "Revolution/Pages/POReceipt/POReceiptList.aspx" },
        'Inventory': { ByDealerType: false, PowerKey: "M2_InventoryUpload", Title: "库存数据上传", Url: "Revolution/Pages/Inventory/InventoryImport.aspx" },
        'Shipment': { ByDealerType: false, PowerKey: "M2_ShipmentOrder", Title: "销售出库单", Url: "Revolution/Pages/Shipment/ShipmentList.aspx" },
        'SalesForecast': { ByDealerType: false, PowerKey: "M2_T2Forecast", Title: "经销商采购预测", Url: "Revolution/Pages/Order/PurchasingForecastReport.aspx" },
        'Invoice': { ByDealerType: false, PowerKey: "M2_ShipmentOrder", Title: "销售出库单", Url: "Revolution/Pages/Shipment/ShipmentList.aspx" },
        'DealerQA': { ByDealerType: false, PowerKey: "M2_DealerQA", Title: "经销商问答", Url: "Pages/DCM/DealerQAList.aspx" },
        'OrderQT': {
            ByDealerType: true,
            LPT1: { PowerKey: "M2_OrderApply", Title: "平台及一级经销商订单申请", Url: "Revolution/Pages/Order/OrderApplyLP.aspx" },
            T2: { PowerKey: "M2_OrderApplyForT2", Title: "二级经销商订单申请", Url: "Revolution/Pages/Order/OrderApply.aspx" }
        },
        'ShipmentQT': { ByDealerType: false, PowerKey: "M2_ShipmentOrder", Title: "销售出库单", Url: "Revolution/Pages/Shipment/ShipmentList.aspx" },
        'ShipmentReversedQT': { ByDealerType: false, PowerKey: "M2_ShipmentOrder", Title: "销售出库单", Url: "Revolution/Pages/Shipment/ShipmentList.aspx" },
        'TransferQT': { ByDealerType: false, PowerKey: "M2_TransferOut", Title: "借货出库", Url: "Revolution/Pages/Transfer/TransferList.aspx" },
        'InventoryAdjustQT': { ByDealerType: false, PowerKey: "M2_InventoryReturn", Title: "退换货申请", Url: "Revolution/Pages/Inventory/InventoryReturn.aspx" },
        'NormalInventory': { ByDealerType: false, PowerKey: "M2_InventoryQuery", Title: "库存查询", Url: "Revolution/Pages/Inventory/QueryInventoryPage.aspx" },
        'ConsignmentInventory': { ByDealerType: false, PowerKey: "M2_InventoryQuery", Title: "库存查询", Url: "Revolution/Pages/Inventory/QueryInventoryPage.aspx" },
        'BorrowInventory': { ByDealerType: false, PowerKey: "M2_InventoryQuery", Title: "库存查询", Url: "Revolution/Pages/Inventory/QueryInventoryPage.aspx" },
        'SystemHoldInventory': { ByDealerType: false, PowerKey: "M2_InventoryQuery", Title: "库存查询", Url: "Revolution/Pages/Inventory/QueryInventoryPage.aspx" },
        'ShipmentInit': { ByDealerType: false, PowerKey: "M2_ShipmentInit", Title: "销售数据批量上传", Url: "Revolution/Pages/Shipment/ShipmentInitList.aspx" },
        'DealerQR': { ByDealerType: false, PowerKey: "M2_DealerQRProductUpload", Title: "二维码产品数据收集", Url: "Revolution/Pages/Inventory/InventoryQROperation.aspx" },
        'DealerPriceQuery': { ByDealerType: false, PowerKey: "M2_DealerPriceQuery", Title: "经销商订单价格查询", Url: "Revolution/Pages/Order/DealerPriceQuery.aspx" },
        'OrderApplyImport': {
            ByDealerType: true,
            LPT1: { PowerKey: "OrderApplyImport", Title: "平台及一级经销商订单导入", Url: "Revolution/Pages/Order/OrderApplyLPImport.aspx" },
            T2: { PowerKey: "OrderApplyImportForT2", Title: "二级经销商订单导入", Url: "Revolution/Pages/Order/OrderImport.aspx" }
        },
    }

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        $('.panel-todo').slimScroll({
            height: '176px'
        });
        $('.panel-manual').slimScroll({
            height: '176px'
        });

        $(".small-box").hover(function () {
            kendo.fx(this).zoom("in").startValue(1).endValue(1.2).play();
        }, function () {
            kendo.fx(this).zoom("out").endValue(1).startValue(1.2).play();
        });

        createDimension();
        createTrend();

        var data = {};

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#BtnSalesImport').on('click', function () {
                    openHyperLink('ShipmentInit', model.IptCorpType);
                });
                $('#BtnSalesFill').on('click', function () {
                    openHyperLink('Shipment', model.IptCorpType);
                });
                $('#BtnSalesReport').on('click', function () {
                    openHyperLink('DealerQR', model.IptCorpType);
                });
                $('#BtnInvoiceUpload').on('click', function () {
                    alert('not found');
                });
                $('#BtnOrderFill').on('click', function () {
                    openHyperLink('OrderQT', model.IptCorpType);
                });
                $('#BtnPriceQuery').on('click', function () {
                    openHyperLink('DealerPriceQuery', model.IptCorpType);
                });
                $('#BtnOrderImport').on('click', function () {
                    openHyperLink('OrderApplyImport', model.IptCorpType);
                });
                $('#BtnDelivery').on('click', function () {
                    openHyperLink('POReceipt', model.IptCorpType);
                });

                createTodo(model.RstTodo, model.IptCorpType);
                createManual(model.RstManual);
                createSummary(model.RstSummary, model.IptCorpType);
                createNotice(model.RstNotice);

                bindQuarter(model.LstQuarter, model.IptQuarter);
                bindBu(model.LstBu, model.IptBu);

                setDimensionData(model.RstDimension);
                setTrendData(model.RstTrend);

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.RefreshNotice = function () {
        var data = {};

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'RefreshNotice',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                createNotice(model.RstNotice);

                FrameWindow.HideLoading();
            }
        });
    }

    that.ChangeQuarter = function () {
        var data = {};
        data.IptQuarter = {};
        data.IptQuarter.Key = $('#IptQuarter').data('key');
        data.IptQuarter.Value = $('#IptQuarter').data('value');

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeQuarter',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                bindBu(model.LstBu, model.IptBu);

                setDimensionData(model.RstDimension);
                setTrendData(model.RstTrend);

                FrameWindow.HideLoading();
            }
        });
    }

    that.ChangeBu = function () {
        var data = {};
        data.IptQuarter = {};
        data.IptQuarter.Key = $('#IptQuarter').data('key');
        data.IptQuarter.Value = $('#IptQuarter').data('value');
        data.IptBu = {};
        data.IptBu.Key = $('#IptBu').data('key');
        data.IptBu.Value = $('#IptBu').data('value');

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeBu',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                setDimensionData(model.RstDimension);
                setTrendData(model.RstTrend);

                FrameWindow.HideLoading();
            }
        });
    }

    var createTodo = function (dataSource, dealerType) {
        $('#RstTodo').empty();
        if (dataSource.length > 0) {
            $(dataSource).each(function (i, n) {
                var h = '';
                h += '<li class="item">';
                h += '  <div class="product-img">';
                h += '      <i class="fa fa-fw fa-angle-right" style="color: #3c8dbc;"></i>';
                h += '  </div>';
                h += '  <div class="product-info" data-key="' + n.Key + '">' + n.Value + '</div>';
                h += '</li>';
                $('#RstTodo').append(h);
            });

            $('#RstTodo').find('.product-info').on('click', function () {
                openHyperLink($(this).data('key'), dealerType);
            });
        } else {

        }
    }

    var createManual = function (dataSource) {
        $('#RstManual').empty();
        $(dataSource).each(function (i, n) {
            var h = '';
            h += '<div class="col-xs-6">';
            h += '  <div class="row" style="cursor: pointer;" onclick="window.open(\'' + n.ManualUrl + '\');">';
            h += '      <i class="fa fa-fw fa-plus-square" style="color: #3c8dbc;"></i>&nbsp;&nbsp;' + n.ManualName;
            h += '  </div>';
            h += '</div>';
            $('#RstManual').append(h);
        });
    }

    var createSummary = function (dataSource, dealerType) {
        $('#RstSummary').empty();
        $(dataSource).each(function (i, n) {
            var h = '';
            h += '<li class="item">';
            h += '  <div class="product-img">';
            h += '      <i class="fa fa-fw fa-angle-right" style="color: #3c8dbc;"></i>';
            h += '  </div>';
            h += '  <div class="product-info" data-key="' + n.Key + '">' + n.Value + '</div>';
            h += '</li>';
            $('#RstSummary').append(h);
        });

        $('#RstSummary').find('.product-info').on('click', function () {
            openHyperLink($(this).data('key'), dealerType);
        });
    }

    var createNotice = function (dataSource) {
        $('#RstNotice').empty();
        $(dataSource).each(function (i, n) {
            var h = '';
            h += '<li class="item">';
            h += '  <div class="product-img">';
            h += '      <i class="fa fa-fw fa-angle-right" style="color: #3c8dbc;"></i>';
            h += '  </div>';
            h += '  <div class="product-info">';
            h += '      <a href="javascript:void(0)" class="product-title" data-id=' + n.Id + ' data-title=' + n.Title + '>';
            if (n.ConfirmFlag == 1) {
                h += '      <span style="color: #C00000;"><i class="fa fa-fw fa-warning"></i>待确认&nbsp;&nbsp;</span>';
            }
            h += n.Title;
            h += '      </a>';
            h += '      <span class="product-description">' + n.PublishedDate + '</span>';
            h += '  </div>';
            h += '</li>';
            $('#RstNotice').append(h);
        });

        $('#RstNotice').find('.product-title').on('click', function () {
            FrameWindow.OpenWindow({
                target: 'top',
                title: $(this).data('title'),
                url: Common.AppVirtualPath + 'Revolution/Pages/Platform/BulletinRead.aspx?InstanceId=' + $(this).data('id'),
                width: 600,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: that.RefreshNotice
            });
        });
    }

    var bindQuarter = function (lstQuarter, iptQuarter) {
        $('#LstQuarter').empty();
        $(lstQuarter).each(function (i, n) {
            var h = '';
            h += '<li><a href="#" data-key="' + n.Quarter + '" data-value="' + n.Quarter + '">' + n.Quarter + '</a></li>';
            $('#LstQuarter').append(h);
        });
        $('#LstQuarter').find('a').on('click', function () {
            $('#IptQuarter').html($(this).html() + '&nbsp;<i class="fa fa-fw fa-caret-down"></i>');
            $('#IptQuarter').data('key', $(this).data('key'));
            $('#IptQuarter').data('value', $(this).data('value'));
            that.ChangeQuarter();
        });
        if (iptQuarter.Key == '') {
            $('#IptQuarter').html('无数据&nbsp;<i class="fa fa-fw fa-caret-down"></i>');
        } else {
            $('#IptQuarter').html(iptQuarter.Value + '&nbsp;<i class="fa fa-fw fa-caret-down"></i>');
            $('#IptQuarter').data('key', iptQuarter.Key);
            $('#IptQuarter').data('value', iptQuarter.Value);
        }
    }

    var bindBu = function (lstBu, iptBu) {
        $('#LstBu').empty();
        $(lstBu).each(function (i, n) {
            var h = '';
            h += '<li><a href="#" data-key="' + n.BuCode + '" data-value="' + n.BuName + '">' + n.BuName + '</a></li>';
            $('#LstBu').append(h);
        });
        $('#LstBu').find('a').on('click', function () {
            $('#IptBu').html($(this).html() + '&nbsp;<i class="fa fa-fw fa-caret-down"></i>');
            $('#IptBu').data('key', $(this).data('key'));
            $('#IptBu').data('value', $(this).data('value'));
            that.ChangeBu();
        });
        if (iptBu.Key == '') {
            $('#IptBu').html('无数据&nbsp;<i class="fa fa-fw fa-caret-down"></i>');
        } else {
            $('#IptBu').html(iptBu.Value + '&nbsp;<i class="fa fa-fw fa-caret-down"></i>');
            $('#IptBu').data('key', iptBu.Key);
            $('#IptBu').data('value', iptBu.Value);
        }
    }

    var createDimension = function () {
        $("#RstDimension").kendoChart({
            legend: {
                position: "bottom"
            },
            seriesDefaults: {
                type: "radarLine"
            },
            series: [{
                name: "经销商",
                data: [],
                color: '#003B6F'
            }],
            categoryAxis: {
                categories: ["采购完成", "医院增长及覆盖", "进销存管理", "BU定制指标", "医院销售完成"]
            },
            valueAxis: {
                labels: {
                    format: "{0}"
                },
                min: 0,
                max: 20,
                majorUnit: 5
            },
            tooltip: {
                visible: true,
                format: "{0}"
            }
        });
    }

    var setDimensionData = function (dataSource) {
        if (dataSource) {
            $("#RstDimension").data("kendoChart").setOptions({
                series: [{
                    name: "经销商",
                    data: [dataSource.CGWC, dataSource.YYZZJFG, dataSource.JXCGL, dataSource.BUDZZB, dataSource.YYXSWC],
                    color: '#003B6F'
                }]
            });
        }
    }

    var createTrend = function () {
        $("#RstTrend").kendoChart({
            legend: {
                position: "bottom"
            },
            seriesDefaults: {
                type: "line"
            },
            series: [{
                name: "总分趋势",
                data: [],
                color: '#003B6F'
            }],
            valueAxis: {
                labels: {
                    format: "{0}"
                },
                line: {
                    visible: false
                },
                min: 0,
                max: 100,
                majorUnit: 10
            },
            categoryAxis: {
                categories: [],
                majorGridLines: {
                    visible: false
                },
                labels: {
                    rotation: "auto"
                }
            },
            tooltip: {
                visible: true,
                format: "{0}"
            }
        });
    }

    var setTrendData = function (dataSource) {
        if (dataSource) {
            $("#RstTrend").data("kendoChart").setOptions({
                series: [{
                    name: "总分趋势",
                    data: [{ value: dataSource.TotalQ1 }, { value: dataSource.TotalQ2 }, { value: dataSource.TotalQ3 }, { value: dataSource.TotalQ4 }],
                    color: '#003B6F'
                }],
                categoryAxis: {
                    categories: [dataSource.Quarter1, dataSource.Quarter2, dataSource.Quarter3, dataSource.Quarter4],
                    majorGridLines: {
                        visible: false
                    },
                    labels: {
                        rotation: "auto"
                    }
                }
            });
        }
    }

    var openHyperLink = function (key, dealerType) {
        var link = hyperLink[key]
        if (link) {
            if (link.ByDealerType) {
                if (dealerType == 'LP' || dealerType == 'T1') {
                    top.createTab({
                        id: 'M_' + link.LPT1.PowerKey,
                        title: link.LPT1.Title,
                        url: link.LPT1.Url
                    });
                } else if (dealerType == 'T2') {
                    top.createTab({
                        id: 'M_' + link.T2.PowerKey,
                        title: link.T2.Title,
                        url: link.T2.Url
                    });
                }
            } else {
                top.createTab({
                    id: 'M_' + link.PowerKey,
                    title: link.Title,
                    url: link.Url
                });
            }
        }
    }

    var setLayout = function () {
        if ($(window).width() < 768) {
            $('#PnlSummary, #PnlNotice').height(300);
            $('#PnlChart').height(289);
            $('.carousel-inner').height(289);
            $('.carousel-inner').find('.item').height(289);

            $("#RstDimension").data("kendoChart").setOptions({
                chartArea: {
                    width: $('.carousel-inner').width(),
                    height: 300 - 31
                }
            });
            $("#RstTrend").data("kendoChart").setOptions({
                chartArea: {
                    width: $('.carousel-inner').width(),
                    height: 300 - 31
                }
            });

            $('#PnlSummary').slimScroll({
                height: '300px'
            });
            $('#PnlNotice').slimScroll({
                height: '300px'
            });
        } else {
            var hWindow = $(window).height();

            var hLine1 = $('#PnlLine1').outerHeight(true);
            var hHead = $('.row-summary').find('.box-header').outerHeight(true);

            var h = (hWindow - hLine1 - hHead - 14) < 280 ? 280 : (hWindow - hLine1 - hHead - 14);

            $('#PnlSummary, #PnlNotice').height(h);
            $('#PnlChart').height(h - 11);
            $('.carousel-inner').height(h - 11);
            $('.carousel-inner').find('.item').height(h - 11);

            $("#RstDimension").data("kendoChart").setOptions({
                chartArea: {
                    width: $('.carousel-inner').width(),
                    height: h - 31
                }
            });
            $("#RstTrend").data("kendoChart").setOptions({
                chartArea: {
                    width: $('.carousel-inner').width(),
                    height: h - 31
                }
            });

            $('#PnlSummary').slimScroll({
                height: h + 'px'
            });
            $('#PnlNotice').slimScroll({
                height: h + 'px'
            });
        }
    }

    return that;
}();
