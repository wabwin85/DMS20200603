var WarehouseMaint = {};

WarehouseMaint = function () {
    var that = {};

    var business = 'Inventory.WarehouseMaint';

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
                    value: model.QryDealer
                });
                $('#QryWarehouse').FrameTextBox({
                    value: model.QryWarehouse
                });
                $('#QryAddress').FrameTextBox({
                    value: model.QryAddress
                });
                
                if (model.IsDealer == true) {
                    $("#QryDealer").FrameDropdownList('disable');
                    $("#QryDealer_Control").data("kendoDropDownList").value(model.DealerId);
                }

                if (model.IsShowQuery == true)
                {
                    $('#BtnQuery').FrameButton({
                        text: '查询',
                        icon: 'search',
                        onClick: function () {
                            that.Query();
                        }
                    });
                }

                if (model.IsShowAdd == true)
                {
                    $('#BtnNew').FrameButton({
                        text: '新建',
                        icon: 'plus',
                        onClick: function () {
                            that.WarehouseEdit('', '', '新建经销商仓库');
                        }
                    });
                }

                if (model.IsShowSave == true)
                {
                    //$('#BtnSave').FrameButton({
                    //    text: '保存',
                    //    icon: 'save',
                    //    onClick: function () {
                    //        that.SaveChange();
                    //    }
                    //});
                }

                if (model.IsShowDelete == true)
                {
                    //$('#BtnDelete').FrameButton({
                    //    text: '删除',
                    //    icon: 'trash-o',
                    //    onClick: function () {
                    //        that.Query();
                    //    }
                    //});
                }

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });

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

    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    //导出数据
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'WarehouseMaintExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryWarehouse', data.QryWarehouse);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryAddress', data.QryAddress);
        startDownload(urlExport, 'WarehouseMaintExport');
    }

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
                    field: "DealerName", title: "经销商", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" }
                },
                {
                    field: "Code", title: "仓库代码", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库代码" }
                },
                {
                    field: "Name", title: "仓库名称", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库名称" }
                },
                {
                    field: "Province", title: "省份", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "省份" }
                },
                {
                    field: "City", title: "城市", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "城市" }
                },
                {
                    field: "TypeName", title: "仓库的类型", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库的类型" }
                },
                {
                    field: "PostalCode", title: "邮编", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "邮编" }
                },
                {
                    field: "Address", title: "地址", width: 260,
                    headerAttributes: { "class": "text-center text-bold", "title": "地址" }
                },
                {
                    field: "Town", title: "区或乡", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "区或乡" },
                    template: "#if (data.Town) {#<span>#=data.Town#</span>#} else { if (data.District) {#<span>#=data.District#</span>#}}#"
                },
                {
                    field: "Phone", title: "电话", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "电话" }
                },
                {
                    field: "Fax", title: "传真", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "传真" }
                },
                {
                    field: "ActiveFlag", title: "有效标志", width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "有效标志" },
                    template: "#if (data.ActiveFlag) {#<i class='fa fa-check-square-o' style='font-size: 14px; cursor: pointer;'></i>#}else{#<i class='fa fa-square-o' style='font-size: 14px; cursor: pointer;'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "明细", width: "auto",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 50,
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
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

                    that.WarehouseEdit(data.Id, data.DmaId, data.Name);
                });
            }
        });
    }

    that.WarehouseEdit = function (Id, DealerId, Name) {
        var url = 'Revolution/Pages/Inventory/WarehouseEditor.aspx?';
        url += 'Id=' + escape(Id);
        url += '&DmaId=' + escape(DealerId);
        FrameWindow.OpenWindow({
            target: 'top',
            title: '明细:' + Name,
            url: Common.AppVirtualPath + url,
            width: $(window).width() * 0.6,
            height: $(window).height() * 0.6,
            actions: ["Close"],
            callback: function (result) {
                if (result == "success")
                {
                    that.Query();
                }
            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();