var AdminPage = {};

AdminPage = function () {
    var that = {};

    var business = 'Dashboard.AdminPage';

    
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

        createMenu();

        var data = {};

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppVirtualPath + 'Revolution/Pages/Dashboard/Handler/AdminPageHandler.ashx',
            data: data,
            callback: function (model) {
                

                createTodo(model.RstTodo, model.IptCorpType);
                createManual(model.RstManual);
                createSummary(model.RstSummary, model.IptCorpType);
                createNotice(model.RstNotice);
                bindYear(model.LstYear, model.IptYear);

                setOrderData(model.RstOrder, model.RstOrderProduct);
                setShipmentData(model.RstShipment, model.RstShipmentProduct);
                setInterfaceData(model.RstInterface, model.RstLPInterface);
                setMenuData(model.RstMenu, model.RstMenuName);

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



    var createCell = function (data) {
        var cell = new Object();

        cell.value = data == '' ? null : parseInt(data);

        return cell;
    }

    var createCell2 = function (data) {
        var cell = new Object();

        cell.value = data == '' ? null : parseInt(data) * 0.85;

        return cell;
    }

    var setOrderData = function (RstOrder, RstProduct) {
        if (typeof ($('#RstOrder').data("kendoChart")) != 'undefined') {
            $("#RstOrder").data("kendoChart").destroy();
        }
        var dataSourceOrder = new Array();
        dataSourceOrder.push(createCell(RstOrder.Month1));
        dataSourceOrder.push(createCell(RstOrder.Month2));
        dataSourceOrder.push(createCell(RstOrder.Month3));
        dataSourceOrder.push(createCell(RstOrder.Month4));
        dataSourceOrder.push(createCell(RstOrder.Month5));
        dataSourceOrder.push(createCell(RstOrder.Month6));
        dataSourceOrder.push(createCell(RstOrder.Month7));
        dataSourceOrder.push(createCell(RstOrder.Month8));
        dataSourceOrder.push(createCell(RstOrder.Month9));
        dataSourceOrder.push(createCell(RstOrder.Month10));
        dataSourceOrder.push(createCell(RstOrder.Month11));
        dataSourceOrder.push(createCell(RstOrder.Month12));

        var dataSourceProduct = new Array();
        dataSourceProduct.push(createCell(RstProduct.Month1));
        dataSourceProduct.push(createCell(RstProduct.Month2));
        dataSourceProduct.push(createCell(RstProduct.Month3));
        dataSourceProduct.push(createCell(RstProduct.Month4));
        dataSourceProduct.push(createCell(RstProduct.Month5));
        dataSourceProduct.push(createCell(RstProduct.Month6));
        dataSourceProduct.push(createCell(RstProduct.Month7));
        dataSourceProduct.push(createCell(RstProduct.Month8));
        dataSourceProduct.push(createCell(RstProduct.Month9));
        dataSourceProduct.push(createCell(RstProduct.Month10));
        dataSourceProduct.push(createCell(RstProduct.Month11));
        dataSourceProduct.push(createCell(RstProduct.Month12));


        $("#RstOrder").kendoChart({
            legend: {
                position: "bottom"
            },
            theme: "metro",
            series: [{
                type: "column",
                data: dataSourceOrder,
                stack: true,
                name: "订单数量",
                color: "#4682B4"
            }, {
                type: "line",
                data: dataSourceProduct,
                name: "产品总数量",
                color: "#FFA500",
                axis: "产品总数量"
            }],
            categoryAxis: {
                categories: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
                majorGridLines: {
                    visible: false
                },
                axisCrossingValues: [0, 12]
            },
            valueAxis: [{
                title: { text: "订单数量" },
                min: 0,
                max: 20000,
                majorUnit: 5000
            }, {
                name: "产品总数量",
                title: { text: "产品总数量" },
                majorUnit: 100000
            }],
            tooltip: {
                visible: true,
                template: "#= series.name #: #= value #"
            }
        });

    }


    var setShipmentData = function (RstShipment,RstShipmentProduct) {
        if (RstShipment) {
            if (typeof ($('#RstShipment').data("kendoChart")) != 'undefined') {
                $("#RstShipment").data("kendoChart").destroy();
            }
            var dataSourceShipment = new Array();
            dataSourceShipment.push(createCell(RstShipment.Month1));
            dataSourceShipment.push(createCell(RstShipment.Month2));
            dataSourceShipment.push(createCell(RstShipment.Month3));
            dataSourceShipment.push(createCell(RstShipment.Month4));
            dataSourceShipment.push(createCell(RstShipment.Month5));
            dataSourceShipment.push(createCell(RstShipment.Month6));
            dataSourceShipment.push(createCell(RstShipment.Month7));
            dataSourceShipment.push(createCell(RstShipment.Month8));
            dataSourceShipment.push(createCell(RstShipment.Month9));
            dataSourceShipment.push(createCell(RstShipment.Month10));
            dataSourceShipment.push(createCell(RstShipment.Month11));
            dataSourceShipment.push(createCell(RstShipment.Month12));

            var dataSourceShipmentProduct = new Array();
            dataSourceShipmentProduct.push(createCell(RstShipmentProduct.Month1));
            dataSourceShipmentProduct.push(createCell(RstShipmentProduct.Month2));
            dataSourceShipmentProduct.push(createCell(RstShipmentProduct.Month3));
            dataSourceShipmentProduct.push(createCell(RstShipmentProduct.Month4));
            dataSourceShipmentProduct.push(createCell(RstShipmentProduct.Month5));
            dataSourceShipmentProduct.push(createCell(RstShipmentProduct.Month6));
            dataSourceShipmentProduct.push(createCell(RstShipmentProduct.Month7));
            dataSourceShipmentProduct.push(createCell(RstShipmentProduct.Month8));
            dataSourceShipmentProduct.push(createCell(RstShipmentProduct.Month9));
            dataSourceShipmentProduct.push(createCell(RstShipmentProduct.Month10));
            dataSourceShipmentProduct.push(createCell(RstShipmentProduct.Month11));
            dataSourceShipmentProduct.push(createCell(RstShipmentProduct.Month12));
			

            $("#RstShipment").kendoChart({
                legend: {
                    position: "bottom"
                },
                theme: "metro",
                series: [{
                    type: "column",
                    data: dataSourceShipment,
                    stack: true,
                    name: "销售单数量",
                    color: "#4682B4"
                }, {
                    type: "line",
                    data: dataSourceShipmentProduct,
                    color: "#FFA500",
                    name: "销售产品总数量",
                    axis: "销售产品总数量"
                }],
                categoryAxis: {
                    categories: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
                    majorGridLines: {
                        visible: false
                    },
                    axisCrossingValues: [0, 12]
                },
                valueAxis: [{
                    title: { text: "销售单数量" },
                    min: 0,
                    max: 20000,
                    majorUnit: 5000
                }, {
                    name: "销售产品总数量",
                    title: { text: "产品总数量" },
                    max: 200000,
                    majorUnit: 50000
                }],
                tooltip: {
                    visible: true,
                    template: "#= series.name #: #= value #"
                }
            });
        }
    }


    var setInterfaceData = function (RstInterface, RstLPInterface) {
        if (RstInterface) {
            var dataSourceInterface = new Array();
            dataSourceInterface.push(createCell(RstInterface.Month1));
            dataSourceInterface.push(createCell(RstInterface.Month2));
            dataSourceInterface.push(createCell(RstInterface.Month3));
            dataSourceInterface.push(createCell(RstInterface.Month4));
            dataSourceInterface.push(createCell(RstInterface.Month5));
            dataSourceInterface.push(createCell(RstInterface.Month6));
            dataSourceInterface.push(createCell(RstInterface.Month7));
            dataSourceInterface.push(createCell(RstInterface.Month8));
            dataSourceInterface.push(createCell(RstInterface.Month9));
            dataSourceInterface.push(createCell(RstInterface.Month10));
            dataSourceInterface.push(createCell(RstInterface.Month11));
            dataSourceInterface.push(createCell(RstInterface.Month12));

            var dataSourceInterfaceLP = new Array();
            dataSourceInterfaceLP.push(createCell(RstLPInterface.Month1));
            dataSourceInterfaceLP.push(createCell(RstLPInterface.Month2));
            dataSourceInterfaceLP.push(createCell(RstLPInterface.Month3));
            dataSourceInterfaceLP.push(createCell(RstLPInterface.Month4));
            dataSourceInterfaceLP.push(createCell(RstLPInterface.Month5));
            dataSourceInterfaceLP.push(createCell(RstLPInterface.Month6));
            dataSourceInterfaceLP.push(createCell(RstLPInterface.Month7));
            dataSourceInterfaceLP.push(createCell(RstLPInterface.Month8));
            dataSourceInterfaceLP.push(createCell(RstLPInterface.Month9));
            dataSourceInterfaceLP.push(createCell(RstLPInterface.Month10));
            dataSourceInterfaceLP.push(createCell(RstLPInterface.Month11));
            dataSourceInterfaceLP.push(createCell(RstLPInterface.Month12));

            $("#RstInterface").kendoChart({
                theme: "metro",
                legend: {
                    position: "bottom"
                },
                seriesDefaults: {
                    type: "column"
                },
                series: [{
                    type: "column",
                    data: dataSourceInterface,
                    stack: true,
                    color: "#4682B4",
                    name: "接口调用次数"
                }, {
                    type: "line",
                    data: dataSourceInterfaceLP,
                    color: "#FFA500",
                    name: "平台接口调用次数"
                }],
                valueAxis: [{
                    title: { text: "接口调用次数" },
                    min: 0
                    }, {
                    name: "接口调用次数",
                    title: { text: "平台接口调用次数" },
                    majorUnit: 50000
                }],
                categoryAxis: {
                    categories: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
                    majorGridLines: {
                        visible: false
                    },
                    labels: {
                        rotation: "auto"
                    },
                    axisCrossingValues: [0, 12]
                },
                tooltip: {
                    visible: true,
                    template: "#= series.name #: #= value #"
                }
            });
        }
    }

    var createMenu = function () {
        $("#RstMenu").kendoChart({
            legend: {
                position: "bottom"
            },
            theme: "metro",
            seriesDefaults: {
                type: "column"
            },
            series: [{
                name: "最常使用的菜单次数",
                data: []
            }],
            valueAxis: {
                title: { text: "最常使用的菜单次数" },                
                min: 0
            },
            categoryAxis: {
                majorGridLines: {
                    visible: false
                },
                categories: [],
                
                labels: {
                    rotation: "auto"
                }
            },
            tooltip: {
                visible: true,
                template: "#= value #"
            }
        });
    }

    var setMenuData = function (dataSource, dataSource2) {
        if (dataSource) {
            $("#RstMenu").data("kendoChart").setOptions({
                series: [
                {
                    name: "二级使用的菜单次数",
                    data: [{ value: dataSource.MenuT21 }, { value: dataSource.MenuT22 }, { value: dataSource.MenuT23 }, { value: dataSource.MenuT24 }, { value: dataSource.MenuT25 }, { value: dataSource.MenuT26 }, { value: dataSource.MenuT27 }, { value: dataSource.MenuT28 }, { value: dataSource.MenuT29}, { value: dataSource.MenuT210 }],
                    color: '#4682B4',
                    stack: true
                },
                {
                    name: "一级使用的菜单次数",
                    data: [{ value: dataSource.MenuT11 }, { value: dataSource.MenuT12 }, { value: dataSource.MenuT13 }, { value: dataSource.MenuT14 }, { value: dataSource.MenuT15 },{ value: dataSource.MenuT16 }, { value: dataSource.MenuT17 }, { value: dataSource.MenuT18 }, { value: dataSource.MenuT19 }, { value: dataSource.MenuT110 }],
                    color: '#FFA500',
                    stack: true
                },
                {
                    name: "平台使用的菜单次数",
                    data: [{ value: dataSource.MenuLP1 }, { value: dataSource.MenuLP2 }, { value: dataSource.MenuLP3 }, { value: dataSource.MenuLP4 }, { value: dataSource.MenuLP5 }, { value: dataSource.MenuLP6 }, { value: dataSource.MenuLP7 }, { value: dataSource.MenuLP8 }, { value: dataSource.MenuLP9 }, { value: dataSource.MenuLP10 }],
                    color: '#34C6BB',
                    stack: true
                }
                ],
                categoryAxis: {
                    categories: [dataSource2.Name1, dataSource2.Name2, dataSource2.Name3, dataSource2.Name4, dataSource2.Name5, dataSource2.Name6, dataSource2.Name7, dataSource2.Name8, dataSource2.Name9, dataSource2.Name10]
                }
            });
        }
    }

    var bindYear = function (lstYear, iptYear) {
        $('#LstYear').empty();
        $(lstYear).each(function (i, n) {
            var h = '';
            h += '<li><a href="#" data-key="' + n.YearCode + '" data-value="' + n.YearCode + '">' + n.YearCode + '</a></li>';
            $('#LstYear').append(h);
        });
        $('#LstYear').find('a').on('click', function () {
            $('#IptYear').html($(this).html() + '&nbsp;<i class="fa fa-fw fa-caret-down"></i>');
            $('#IptYear').data('key', $(this).data('key'));
            $('#IptYear').data('value', $(this).data('value'));
            that.ChangeYear();
        });
        if (iptYear.Key == '') {
            $('#IptYear').html('无数据&nbsp;<i class="fa fa-fw fa-caret-down"></i>');
        } else {
            $('#IptYear').html(iptYear.Value + '&nbsp;<i class="fa fa-fw fa-caret-down"></i>');
            $('#IptYear').data('key', iptYear.Key);
            $('#IptYear').data('value', iptYear.Value);
        }
    }

    that.ChangeYear = function () {
        var data = {};
        data.IptYear = {};
        data.IptYear.Key = $('#IptYear').data('key');
        data.IptYear.Value = $('#IptYear').data('value');

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeYear',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                setOrderData(model.RstOrder, model.RstOrderProduct);
                setShipmentData(model.RstShipment, model.RstShipmentProduct);
                setInterfaceData(model.RstInterface, model.RstLPInterface);
                setMenuData(model.RstMenu, model.RstMenuName);

                FrameWindow.HideLoading();
            }
        });
    }


    var setLayout = function () {
        if ($(window).width() < 768) {
            $('#PnlSummary, #PnlNotice').height(300);
            $('#PnlChart').height(600);
            $('.carousel-inner').height(600);
            $('.carousel-inner').find('.item').height(600);

            $("#RstOrder").data("kendoChart").setOptions({
                chartArea: {
                    width: $('.carousel-inner').width(),
                    height: 300 - 31
                }
            });
            $("#RstShipment").data("kendoChart").setOptions({
                chartArea: {
                    width: $('.carousel-inner').width(),
                    height: 300 - 31
                }
            });
            $("#RstInterface").data("kendoChart").setOptions({
                chartArea: {
                    width: $('.carousel-inner').width(),
                    height: 300 - 31
                }
            });
            $("#RstMenu").data("kendoChart").setOptions({
                chartArea: {
                    width: $('.carousel-inner').width(),
                    height: 300 - 31
                }
            });

            $('#PnlSummary').slimScroll({
                height: '260px'
            });
            $('#PnlNotice').slimScroll({
                height: '260px'
            });
        } else {
            var hWindow = $(window).height();

            var hLine1 = $('#PnlLine1').outerHeight(true);
            var hHead = $('.row-summary').find('.box-header').outerHeight(true);

            var h = (hWindow - hLine1 - hHead - 14) < 600 ? 600 : (hWindow - hLine1 - hHead - 14);

            $('#PnlSummary, #PnlNotice').height(h );
            $('#PnlChart').height(h+11);
            $('.carousel-inner').height(h);
            $('.carousel-inner').find('.item').height(h );

            $("#RstOrder").data("kendoChart").setOptions({
                chartArea: {
                    width: $('.carousel-inner').width(),
                    height: 300 - 31
                }
            });
            $("#RstShipment").data("kendoChart").setOptions({
                chartArea: {
                    width: $('.carousel-inner').width(),
                    height: 300 - 31
                }
            });
            $("#RstInterface").data("kendoChart").setOptions({
                chartArea: {
                    width: $('.carousel-inner').width(),
                    height: 300 - 31
                }
            });
            $("#RstMenu").data("kendoChart").setOptions({
                chartArea: {
                    width: $('.carousel-inner').width(),
                    height: 300 - 31
                }
            });

            $('#PnlSummary').slimScroll({
                height: (h - 200) + 'px'
            });
            $('#PnlNotice').slimScroll({
                height: (h - 200) + 'px'
            });
        }
    }

    return that;
}();
