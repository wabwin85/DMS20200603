var ConsignInventoryAdjustPicker = {};

ConsignInventoryAdjustPicker = function () {
    var that = {};

    var business = 'Consign.ConsignInventoryAdjustPicker';
    var pickedList = [];
    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {

        //$('#QryBu').val(Common.GetUrlParam('Bu'));
        $('#QryProductLine').val(Common.GetUrlParam('Bu'));
        $('#QryDealer').val(Common.GetUrlParam('Dealer'));
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryWarehouse').FrameDropdownList({
                    dataSource: model.LstWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'all',
                    value: model.QryWarehouse,
                    onChange: that.WarehouseChange
                });
                //$('#QryWarehouseName').FrameTextBox({

                //    value: model.QryWarehouseName
                //});
                $('#QryLotNumber').FrameTextBox({

                    value: model.QryLotNumber
                });
                $('#QryProductModel').FrameTextBox({

                    value: model.QryLotNumber
                });
                $('#QryTwoCode').FrameTextBox({

                    value: model.QryLotNumber
                });

                $('#BtnOk').FrameButton({
                    text: '确定',
                    icon: 'file',
                    onClick: function () {
                        FrameWindow.SetWindowReturnValue({
                            target: 'top',
                            value: pickedList
                        });

                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });
                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'remove',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                createResultList(model.LstProduct);
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
        var message = that.CheckForm(data);
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
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
    }

    that.CheckForm = function (data) {
        var message = [];

        if ($.trim(data.QryWarehouse.Key) == "") {
            message.push('请选择仓库');
        }
        return message;
    }

    //大区维护
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Area', data.QryArea);
        urlExport = Common.UpdateUrlParams(urlExport, 'IsActive', data.QryIsActive);

        startDownload({
            url: urlExport,
            cookie: 'AreaListExport',
            business: business
        });
    }

    var createResultList = function (dataSource) {
        //var dataSource = [{ "ItemCID": "73965bc2-9683-4344-bc36-9ca395478305", "ItemCName": "费用项目", "ProvinceCode": "HENAN", "ProvinceName": "河南", "ChannelCode": "TL", "ChannelName": "通路", "TotalYTD": 1000.00, "FeeOfYear": 20000.00, "UsableFee": 20000.00, "RemainFee": 20000.00 },
        //                    { "ItemCID": "73965bc2-9683-4344-bc36-9ca395478306", "ItemCName": "费用项目1", "ProvinceCode": "HENAN1", "ProvinceName": "河南1", "ChannelCode": "TL1", "ChannelName": "通路1", "TotalYTD": 3000.00, "FeeOfYear": 60000.00, "UsableFee": 30000.00, "RemainFee": 30000.00 },
        //                  { "ItemCID": "73965bc2-9683-4344-bc36-9ca395478307", "ItemCName": "费用项目2", "ProvinceCode": "HENAN2", "ProvinceName": "河南2", "ChannelCode": "TL2", "ChannelName": "通路2", "TotalYTD": 2000.00, "FeeOfYear": 40000.00, "UsableFee": 40000.00, "RemainFee": 40000.00 }

        //];
        $("#RstResultList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                 {
                     title: "全选", width: '50px', encoded: false,
                     headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                     template: '<input type="checkbox" id="Check_#=LOT_ID#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=LOT_ID#"></label>',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "WarehouseName", title: "仓库", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" },
                },
                {
                    field: "UPN", title: "产品型号UPN", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号UPN" }
                },
                {
                    field: "ChineseName", title: "产品中文名", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" }
                },
                {
                    field: "PMA_ConvertFactor", title: "产品规格", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品规格" }
                },
                {
                    field: "LotNumber", title: "批号", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "批号" }
                },
                {
                    field: "QRCode", title: "二维码", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "LotExpiredDate", title: "有效期", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" }
                },
                {
                    field: "UnitOfMeasure", title: "单位", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" }
                },
                {
                    field: "LotInvQty", title: "库存数", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "库存数" }
                },
                {
                    field: "IAL_LotQty", title: "数量", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "数量" }
                },
                {
                    field: "Price", title: "单价", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单价" }
                }
                //,
                //{
                //    field: "Type", title: "总金额", width: '120px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "总金额" }
                //}

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

                $("#RstResultList").find(".Check-Item").unbind("click");
                $("#RstResultList").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstResultList").data("kendoGrid"),
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

                $('#CheckAll').unbind('change');
                $('#CheckAll').on('change', function (ev) {
                    var checked = ev.target.checked;
                    $('.Check-Item').each(function (idx, item) {
                        var row = $(this).closest("tr");
                        var grid = $("#RstResultList").data("kendoGrid");
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
                $('#CheckAll').removeAttr("checked");
            }
        });
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            pickedList.push({
                LOT_ID: data.LOT_ID,
                WarehouseName: data.WarehouseName,
                UPN: data.UPN,
                ChineseName: data.ChineseName,
                PMA_ConvertFactor: data.PMA_ConvertFactor,
                LotNumber: data.LotNumber,
                QRCode: data.QRCode,
                LotExpiredDate: data.LotExpiredDate,
                UnitOfMeasure: data.UnitOfMeasure,
                LotInvQty: data.LotInvQty,
                IAL_LotQty: data.IAL_LotQty,
                Price: data.Price,
                RemainFee: data.IAL_LotQty * data.Price,
                //UsableFee: data.UsableFee,
                //AdjustFee: data.AdjustFee,
                //RemainFee: data.RemainFee
            });
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].LOT_ID == data.LOT_ID) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].LOT_ID == data.LOT_ID) {
                exists = true;
            }
        }
        return exists;
    }
    that.WarehouseChange = function () {

        createResultList([]);
    }



    var setLayout = function () {
    }

    return that;
}();
