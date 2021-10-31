var InvReconcile = {};

InvReconcile = function () {
    var that = {};
    var business = 'Shipment.Extense.InvReconcile';
    var globalBrandId = $('#IptSubCompanyId').val();
    var globalSubCompanyId = $('#IptSubCompanyId').val();
    var pickedList = [], pickedProductList = [];
    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        return model;
    };

    that.Init = function () {
        var data = FrameUtil.GetModel();
        createResultList();
        createProductResultList();
        createInvoiceResultList();
        FrameUtil.SubmitAjax({
            business: business,
            method: "Init",
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#Dealer').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    //parameters: { "IsAll": $("#DealerListType").val() },//查询类型 
                    //method: 'DealerFilter',
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.Dealer,
                });
                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryProductLine
                });
                $('#QryOrderNumber').FrameTextBox({
                    value: model.QryOrderNumber
                });
                $('#QryReconcileDate').FrameDatePickerRange({
                    value: model.QryReconcileDate
                });
                $('#QryHospital').FrameTextBox({
                    value: model.QryHospital
                });
                $('#CompareInfo').FrameDropdownList({
                    dataSource: [{ Key: "", Value: "全部" }, { Key: "对账失败", Value: "对账失败" }, { Key: "未对账", Value: "未对账" }, { Key: "已对账", Value: "已对账" }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.CompareInfo
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                        that.ShowProductDetailInfo(pickedList);
                    }
                });

                $('#BtnAutoReconcile').FrameButton({
                    text: '自动对账',
                    icon: 'search',
                    onClick: function () {
                        that.CompareReconcile(pickedList,null,"auto");
                    }
                });

                $('#BtnManualReconcile').FrameButton({
                    text: '人工对账',
                    icon: 'search',
                    onClick: function () {
                        that.CompareReconcile(pickedList,pickedProductList, "manual");
                    }
                });

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                    }
                });

                $('#BtnExportDetail').FrameButton({
                    text: '导出详细',
                    icon: 'file-excel-o',
                    onClick: function () {
                    }
                });
                FrameWindow.HideLoading();
            }
        });
    };

    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    var kendoDataSource = GetKendoDataSource(business, 'Query');
    var createResultList = function () {
        $('#RstResultList').kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
                input: true,
                numeric: false
            },
            columns: [
                {
                    title: "全选", width: '50px', encoded: false,
                    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>',
                    headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                    attributes: { "class": "center" }
                },
                {
                    hidden: true, field:'Id',title:'销售出库单Id'
                },
                {
                    field: 'DealerName', title: "经销商名称", width: '120px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '经销商名称' },
                    attributes: { "class": "table-td-cell" }
                }
                ,
                {
                    field: 'ProductLine', title: "产品线", width: '120px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品线' },
                    attributes: { "class": "table-td-cell" }
                }
                ,
                {
                    field: 'SubCompanyName', title: "分子公司", width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '分子公司' },
                    attributes: { "class": "table-td-cell" }
                }
                ,
                {
                    field: 'BrandName', title: "品牌", width: '120px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '品牌' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'HospitalName', title: "销售医院", width: '120px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '销售医院' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'OrderNumber', title: "销售单号", width: '160px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '销售单号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'TotalQty', title: "总数量", width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '总数量' }
                },
                {
                    field: 'InvQty', title: "发票数量", width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票数量' }
                },
                {
                    field: 'CompareStatus', title: "对账情况", width: '120px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '对账情况' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'CompareInfo', title: "是否对账", width: '120px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '是否对账' }
                },
                {
                    field: 'UpdateTime', title: "最新更新日期", width: '120px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '最新更新日期' }
                }
            ],
            dataBound: function (e) {
                var grid = e.sender;
                $("#RstResultList").find(".Check-Item").unbind("click");
                $("#RstResultList").find(".Check-Item").on('click', function () {
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
                    that.ShowProductDetailInfo(pickedList);
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
                        that.ShowProductDetailInfo(pickedList);
                    });
                });
            },
            page: function (e) {
                $('#CheckAll').removeAttr("checked");
            }
        });
    };

    that.Export = function (type) {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'InvReconcileSummaryExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'Dealer', data.Dealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryOrderNumber', data.QryOrderNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'ShipmentDateStart', data.QryReconcileDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'ShipmentDateEnd', data.QryReconcileDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'HospitalName', data.QryHospital);
        urlExport = Common.UpdateUrlParams(urlExport, 'CompareInfo', data.CompareInfo.Key);
        startDownload(urlExport, 'InvReconcileSummaryExport');
    }

    that.CompareReconcile = function (ids, iNVRecDetailIds, reconcileType) {
        //need check mutiple choices condition
        if (reconcileType == 'auto') {
            if (confirm('确定要自动对账吗')) {
                FrameWindow.ShowLoading();
                var data = FrameUtil.GetModel();
                data.Ids = generateQueryFromArray(ids);
                data.IsSystemCompare = true;
                data.PageSize = 10;
                data.Page = 1;
                data.SubCompanyId = globalSubCompanyId;
                data.BrandId = globalBrandId;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'CompareInvReconcile',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess == true) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '对账结束',
                                callback: function () {
                                    getProductInvoiceDetailInfos(ids);
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
                        FrameWindow.HideLoading();
                    }
                });
            }
        }
        else {
            if (confirm('确定要手工对账吗')) {
                FrameWindow.ShowLoading();
                if (isExistsProduct("") == true) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '请选择对账失败的产品明细进行人工对账',
                        callback: function () { 
                        }
                    });
                    return;
                }

                var data = FrameUtil.GetModel();
                data.Ids = generateQueryFromArray(iNVRecDetailIds);
                data.IsSystemCompare = false;
                data.PageSize = 10;
                data.Page = 1;
                data.SubCompanyId = globalSubCompanyId;
                data.BrandId = globalBrandId;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'CompareInvReconcile',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess == true) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '对账成功!',
                                callback: function () {
                                    getProductInvoiceDetailInfos(ids);
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
                        FrameWindow.HideLoading();
                    }
                });
            }
        }
    }

    /**
     * 
     * Create Product detail list
     */
    that.ShowProductDetailInfo = function (ids) {
        //createProductResultList();
        getProductInvoiceDetailInfos(ids);
    }

    that.DownloadAttach = function (Name, Url) {
        var url = '/Pages/Download.aspx?downloadname=' + escape(Name) + '&filename=' + escape(Url) + '&downtype=InvoiceAttachment';
        open(url, 'Download');
    }

    var createProductResultList = function () { 
        $('#RstProductDetail').kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
                input: true,
                numeric: false
            },
            columns: [
                {
                    title: "选择", width: '50px', encoded: false,
                    template: '<input type="checkbox" id="Check_Product_#=CFN_ID#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_Product_#=CFN_ID#"></label>',
                    attributes: { "class": "center" }
                },
                {
                    title: '', field:'INVRecDetailId',hidden:'true'
                },
                {
                    title: '销售单号', width: '80px',
                    field: 'OrderNumber',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '销售单号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '经销商名称', width: '80px',
                    field: 'DealerName',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '经销商名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '产品线', width: '70px',
                    field: 'ProductLineName',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品线' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '产品型号', width: '70px',
                    field: 'CFN',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品型号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '产品名称', width: '70px',
                    field: 'CFN_ChineseName',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '销售医院', width: '70px',
                    field: 'HospitalName',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '数量', width: '70px',
                    field: 'ShipmentQty',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '数量' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '状态', width: '70px',
                    field: 'CompareStatus',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '状态' },
                    attributes: { "class": "table-td-cell" }
                }
            ],
            dataBound: function (e) {
                var grid = e.sender;
                $("id=[^Check_Product_]").find(".Check-Item").unbind("click");
                $("id=[^Check_Product_]").find(".Check-Item").on('click', function () {
                    var checked = this.checked,
                        row = $(this).closest("tr"),
                        grid = $("#RstProductDetail").data("kendoGrid"),
                        dataItem = grid.dataItem(row);
                    if (dataItem.CompareStatus == '已对账')
                        $(this).attr('disabled','disabled');
                    if (checked) {
                        dataItem.IsChecked = true;
                        addProductItem(dataItem);
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeProductItem(dataItem);
                        row.removeClass("k-state-selected");
                    }
                    //that.ShowProductDetailInfo(pickedList);
                }); 
            }
        });
    };

    var createInvoiceResultList = function () { 
        $('#RstInvDetail').kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
                input: true,
                numeric: false
            },
            columns: [
                {
                    title: '销售单号', width: '80px',
                    field: 'OrderNumber',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '销售单号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '发票号', width: '80px',
                    field: 'InvoiceNo',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '发票抬头', width: '80px',
                    field: 'InvoiceTitle',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票抬头' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '发票日期', width: '70px',
                    field: 'InvoiceDate',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票日期' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '发票行号', width: '80px',
                    field: 'RowNo',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票行号' },
                    attributes: { "class": "table-td-cell" }
                }
                ,
                {
                    title: '发票商品名称', width: '120px',
                    field: 'CommodityName',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票商品名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '规格型号', width: '80px',
                    field: 'SpecificationModel',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '规格型号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '数量', width: '60px',
                    field: 'Quantity',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '数量' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: '发票附件', width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "发票附件", "style": "vertical-align: middle;" },
                    template: "<i name='downloadAttach' class='fa fa-download' style='font-size: 14px; cursor: pointer;'></i>",
                }
            ],
            dataBound: function (e) {
                var grid = e.sender;
                $('#RstInvDetail').find('i[name="downloadAttach"]').bind('click', function () {
                    var tr = $(this).closest("tr");
                    that.DownloadAttach(data.Name, data.Url);
                });
            }
        });
    };

    function getProductInvoiceDetailInfos(ids) {
        FrameWindow.ShowLoading();
        var data = FrameUtil.GetModel();
        data.Ids = generateQueryFromArray(ids);
        data.PageSize = 10;
        data.Page = 1;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'QueryProductDetail',
            url: Common.AppHandler,
            data: data,
            callback: function (model) { 
                if (model.IsSuccess == true) {
                    $('#RstProductDetail').data("kendoGrid").setOptions({
                        dataSource: { data: model.RstProductDetail}
                    }); 
                    if (model.RstProductDetail.length > 0)
                        $('#divDetailInfo').show();
                    else
                        $('#divDetailInfo').hide();
                }
                FrameWindow.HideLoading();
            }
        });
        FrameUtil.SubmitAjax({
            business: business,
            method: 'QueryInvoiceDetail',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess == true) { 
                    $('#RstInvDetail').data("kendoGrid").setOptions({
                        dataSource: { data: model.RstInvoiceDetail }
                    });
                    if (model.RstInvoiceDetail.length > 0)
                        $('#divDetailInfo').show();
                    else
                        $('#divDetailInfo').hide();
                }
                FrameWindow.HideLoading();
            }
        }); 
    }

    var generateQueryFromArray = function (ids) { 
        return ids.map(function (id) {
            return "'" + id + "'";
        }).join(',');
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            pickedList.push(data.Id);
        }
    }

    var addProductItem = function (data) {
        if (!isExistsProduct(data)) {
            pickedProductList.push(data.INVRecDetailId);
        }
    }

    var isExistsProduct = function (data) {
        var exists = false;
        for (var i = 0; i < pickedProductList.length; i++) {
            if (pickedProductList[i] == data.INVRecDetailId) {
                exists = true;
            }
        }
        return exists;
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id) {
                exists = true;
            }
        }
        return exists;
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }
    var removeProductItem = function (data) {
        for (var i = 0; i < pickedProductList.length; i++) {
            if (pickedProductList[i] == data.INVRecDetailId) {
                pickedProductList.splice(i, 1);
                break;
            }
        }
    }

    return that;
}();