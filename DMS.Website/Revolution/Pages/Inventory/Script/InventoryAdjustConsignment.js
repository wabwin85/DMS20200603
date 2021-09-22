var InventoryAdjustConsignment = {};

InventoryAdjustConsignment = function () {
    var that = {};

    var business = 'Inventory.InventoryAdjustConsignment';

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
                //产品线
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });
                //经销商
                if (model.DealerId != "" || model.DealerId != null) {
                    $.each(model.LstDealer, function (index, val) {
                        if (model.DealerId === val.Id)
                            model.QryDealer = { Key: val.Id, Value: val.ChineseShortName };
                    })
                }
                //$('#QryDealer').FrameDropdownList({
                //    dataSource: model.LstDealer,
                //    dataKey: 'Id',
                //    dataValue: 'ChineseShortName',
                //    selectType: 'all',
                //    value: model.QryDealer
                //});
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

                //类型
                $('#QryType').FrameDropdownList({
                    dataSource: model.LstType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryType
                });
                //开始日期
                //$('#QryStartDate').FrameDatePickerRange({
                //    value: model.QryBeginDate,
                //    readonly: 0
                //});
                //$("#QryStartDate").kendoDateTimePicker({
                //    value: model.QryBeginDate,
                //    dateInput: true
                //});
                var starDP = $("#QryBeginDate").kendoDatePicker({
                    value: model.QryBeginDate,
                    format: "yyyy-MM-dd",
                    depth: "month",
                    start: "month",
                }).data("kendoDatePicker");
                // starDP.element[0].disabled = true;

                //结束日期
                //$('#QryEndDate').FrameDatePickerRange({
                //    value: model.QryEndDate
                //});
                var endDP = $("#QryEndDate").kendoDatePicker({
                    value: model.QryEndDate,
                    dateInput: false,
                    format: "yyyy-MM-dd",
                    depth: "month",
                    start: "month",
                }).data("kendoDatePicker");
                // endDP.element[0].disabled = true;
                //状态
                $('#QryStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryStatus
                });
                //调整单号
                $('#QryOrderNo').FrameTextBox({
                    value: model.QryOrderNo
                });
                //产品型号
                $('#QryProductType').FrameTextBox({
                    value: model.QryProductType
                });
                //批号/二维码
                $('#QryLotNumber').FrameTextBox({
                    value: model.QryLotNumber
                });


                //经销商，并且不是总部=>新增；禁用经销商选择
                if (model.InsertVisible) {
                    $('#BtnAdd').FrameButton({
                        text: '新增',
                        icon: 'plus',
                        onClick: function () {
                            openInfo();
                        }
                    });
                }

                if (model.SearchVisible) {
                    $('#BtnQuery').FrameButton({
                        text: '查询',
                        icon: 'search',
                        onClick: function () {
                            that.Query();
                        }
                    });
                }

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
    var fields = {};
    var params = function () {
        var parm = FrameUtil.GetModel();
        parm.QryBeginDate = $("#QryBeginDate").val();
        parm.QryEndDate = $("#QryEndDate").val();
        return parm;
    };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 15, params);

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

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
            {
                field: "DealerName", title: "经销商", width: 'auto',
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
                field: "AdjustNumber", title: "调整单号", width: '150px',
                headerAttributes: { "class": "text-center text-bold", "title": "调整单号" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "TypeName", title: "类型", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "类型" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "TotalQyt", title: "总数量", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "总数量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "CreateDate", title: "调整日期", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "调整日期" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "CreateUserName", title: "调整人", width: '150px',
                headerAttributes: { "class": "text-center text-bold", "title": "调整人" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "StatusName", title: "状态", width: '100px',
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
            }

            ],
            pageable: {
                refresh: true,
                pageSizes: false,
                ////pageSize: 20,
                ////input: true,
                ////numeric: false
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

                    openInfo(data.Id, data.Status, data.AdjustNumber);
                });
            }
        });
    }

    var openInfo = function (InstanceId, Status, No) {
        if (InstanceId) {
            top.createTab({
                id: 'M_' + InstanceId,
                title: '其他出入库(寄售仓库) -' + ValidateDataType(No),
                url: 'Revolution/Pages/Inventory/InventoryAdjustConsignmentInfo.aspx?InstanceId=' + InstanceId + '&&Status=' + Status + '&&NewApply=false',
                refresh: true
            });
        } else {
            top.createTab({
                id: 'M_INVENTORY_INVENTORY_CONSIGNMENTADJUSTAPPLY_NEW',
                title: '其他出入库(寄售仓库) - 新增',
                url: 'Revolution/Pages/Inventory/InventoryAdjustConsignmentInfo.aspx?NewApply=true',
                refresh: true
            });
        }
    }

    var setLayout = function () {
    }

    return that;
}();
