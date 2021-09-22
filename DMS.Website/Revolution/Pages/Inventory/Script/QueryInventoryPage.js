var QueryInventoryPage = {};

QueryInventoryPage = function () {
    var that = {};

    var business = 'Inventory.QueryInventoryPage';

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
                $('#QryDealer').FrameDropdownList({
                    dataSource: model.LstDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'all',
                    filter: 'contains',
                    value: model.QryDealer,
                    onChange: that.DealerChange
                });
                $('#QryWarehouse').FrameDropdownList({
                    dataSource: model.LstWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    filter: 'contains',
                    value: model.QryWarehouse
                });
                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryProductLine
                });
                $('#QryProductModel').FrameTextBox({
                    value: model.QryProductModel
                });
                $('#QrySNQrCode').FrameTextBox({
                    value: model.QrySNQrCode
                });
                $('#QryProductName').FrameTextBox({
                    value: model.QryProductName
                });
                $('#QryStockdays').FrameTextBox({
                    value: model.QryStockdays,
                    placeholder: '>=库存天数'
                });
                $('#QryValidityDate').FrameDatePickerRange({
                    value: model.QryValidityDate
                });

                if (model.IsShowQuery == true) {
                    $('#BtnQuery').FrameButton({
                        text: '查询',
                        icon: 'search',
                        onClick: function () {
                            that.Query();
                        }
                    });
                }

                $('#BtnClear').FrameButton({
                    text: '清空条件',
                    icon: 'undo',
                    onClick: function () {
                        if (!model.IsDealer)
                        {
                            $("#QryDealer_Control").data("kendoDropDownList").value('');
                        }
                        $("#QryWarehouse_Control").data("kendoDropDownList").value('');
                        $("#QryProductLine_Control").data("kendoDropDownList").value('');
                        $('#QryProductModel').FrameTextBox('setValue', '');
                        $('#QrySNQrCode').FrameTextBox('setValue', '');
                        $('#QryProductName').FrameTextBox('setValue', '');
                        $('#QryStockdays').FrameTextBox('setValue', '');
                        $('#QryValidityDate').FrameDatePickerRange({ });
                    }
                });

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });

                $('#BtnExportByCategory').FrameButton({
                    text: 'ABC产品分类导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportByCategory();
                    }
                });

                if (model.IsDealer == true) {
                    if (model.DealerType != "HQ" && model.DealerType != "LP") {
                        $("#BtnExportByCategory").hide();
                        $("#QryDealer").FrameDropdownList('disable');
                    } else {
                        $("#BtnExportByCategory").show();
                    }
                    $("#QryDealer_Control").data("kendoDropDownList").value(model.DealerId);
                    that.DealerChange();
                } else {
                    $("#BtnExportByCategory").show();
                }

                //$("#RstResultList").data("kendoGrid").setOptions({
                //    dataSource: model.RstResultList
                //});

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.DealerChange = function () {

        var data = that.GetModel();
        if (data.QryDealer.Key == "") {
            $('#QryWarehouse').FrameDropdownList({
                dataSource: [],
                dataKey: 'Id',
                dataValue: 'Name',
                selectType: 'select',
                filter: 'contains'
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DealerChange',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#QryWarehouse').FrameDropdownList({
                        dataSource: model.LstWarehouse,
                        dataKey: 'Id',
                        dataValue: 'Name',
                        selectType: 'select',
                        value: model.QryWarehouse,
                        filter: 'contains'
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
        //var data = FrameUtil.GetModel();
        ////console.log(data);

        //FrameWindow.ShowLoading();
        //FrameUtil.SubmitAjax({
        //    business: business,
        //    method: 'Query',
        //    url: Common.AppHandler,
        //    data: data,
        //    callback: function (model) {
        //        $("#RstResultList").data("kendoGrid").setOptions({
        //            dataSource: model.RstResultList
        //        });

        //        FrameWindow.HideLoading();
        //    }
        //});
    }

    //导出
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'QueryInventoryPageExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'QueryInventoryExportType', 'ExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductModel', data.QryProductModel);
        urlExport = Common.UpdateUrlParams(urlExport, 'QrySNQrCode', data.QrySNQrCode);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryWarehouse', data.QryWarehouse.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryValidityDateStartDate', data.QryValidityDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryValidityDateEndDate', data.QryValidityDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductName', data.QryProductName);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryStockdays', data.QryStockdays);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        startDownload(urlExport, 'QueryInventoryPageExport');

    }

    that.ExportByCategory = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'QueryInventoryPageExportByCategory');
        urlExport = Common.UpdateUrlParams(urlExport, 'QueryInventoryExportType', 'ExportByCategory');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductModel', data.QryProductModel);
        urlExport = Common.UpdateUrlParams(urlExport, 'QrySNQrCode', data.QrySNQrCode);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryWarehouse', data.QryWarehouse.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryValidityDateStartDate', data.QryValidityDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryValidityDateEndDate', data.QryValidityDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductName', data.QryProductName);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryStockdays', data.QryStockdays);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        startDownload(urlExport, 'QueryInventoryPageExportByCategory');
    }

    //返回服务端分页数据，第一个参数为映射business页面，第二个参数为business页面查询方法，第三个参数为需要格式化参数类型，如日期类型，无需处理则传入null或不传，第四个参数每页显示条目，不传默认为10条
    //var fields = { DC_CreatedDate: { type: "date" } };
    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 20);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "DealerName", title: "经销商名称", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" }
                },
                {
                    field: "BrandName", title: "品牌", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" }
                },
                {
                    field: "WarehouseName", title: "仓库", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" }
                },
                {
                    field: "WhmType", title: "仓库类型", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库类型" }
                },
                {
                    field: "Upn", title: "产品型号", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
                },
                {
                    field: "CFNChineseName", title: "产品中文名", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" }
                },
                {
                    field: "CFNEnglishName", title: "产品英文名", width: 260,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" }
                },
                {
                    field: "LotNumber", title: "序列号/批号", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号/批号" }
                },
                {
                    field: "QRCode", title: "二维码", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "ExpiredDateString", title: "有效期", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" }
                },
                {
                    field: "UnitOfMeasure", title: "单位", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" }
                },
                {
                    field: "OnHandQty", title: "库存数量", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "库存数量" }
                },
                {
                    field: "LotDOM", title: "产品生产日期", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品生产日期" }
                },
                {
                    field: "FrozenDate", title: "在库时间", width: 100, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "在库时间" }
                },
                {
                    field: "WarehouseFrom", title: "产品来源", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品来源" }
                },
                {
                    title: "批次质检报告(CoA)下载", width: "auto",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 50,
                    template: "#if ($('\\#Upn').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
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

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    downPDF(data.LotNumber, data.Property1, data.Upn);
                });
            }
        });
    }

    var downPDF = function (lot, prop, upn) {
        $.ajax({
            type: "post",
            url: "QueryInventoryPage.aspx/GetPDFInfo",
            data: "{ 'Lot':'" + lot + "', 'Prop':'" + prop + "', 'Upn':'" + upn + "' }",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                var result = eval('(' + data.d + ')');
                if (result.IsSuccess) {
                    var url = '/Pages/Download.aspx?downloadname=' + escape(result.downName) + '&fileName=' + escape(result.fileName) + '&downtype=COA';
                    downloadfile(url);
                }
                else {
                    kendo.alert(result.ExecuteMessage);
                }
                FrameWindow.HideLoading();
            },
            error: function (err) {
                kendo.alert("access faield:" + err);
            }
        });
    }

    var setLayout = function () {
    }

    function downloadfile(url) {

        var iframe = document.createElement("iframe");
        iframe.src = url;
        //iframe.style.display = "none";
        document.body.appendChild(iframe);
    }

    return that;
}();