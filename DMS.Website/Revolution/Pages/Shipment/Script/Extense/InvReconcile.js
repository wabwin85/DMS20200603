var InvReconcile = {};

InvReconcile = function () {
    var that = {};
    var business = 'Shipment.Extense.InvReconcile';
    var globalBrandId = parent.$('#IptBrandId').val();
    var globalSubCompanyId = parent.$('#IptSubCompanyId').val();
    var globalSubCompanyName = parent.$('#IptSubCompanyName').html() == undefined ? "瑞奇" : parent.$('#IptSubCompanyName').html();
    var globalBrandName = parent.$('#IptBrandName').html() == undefined ? "瑞奇" : parent.$('#IptBrandName').html();
    $('#SubCompanyName').val(globalSubCompanyName == undefined ? "瑞奇" : globalSubCompanyName);
    $('#BrandName').val(globalBrandName == undefined ? "瑞奇" : globalBrandName);
    var pickedList = [], pickedProductList = [], pickedProductIdsList = [];
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
                    dataSource: [{ Key: "全部", Value: "全部" }, { Key: "对账失败", Value: "对账失败" }, { Key: "未对账", Value: "未对账" }, { Key: "已对账", Value: "已对账" }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.CompareInfo
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        createResultList();
                        that.Query();
                        pickedList = [], pickedProductList = [], pickedProductIdsList = [];
                        //that.ShowProductDetailInfo(pickedList);
                    }
                });

                $('#BtnAutoReconcile').FrameButton({
                    text: '自动对账',
                    icon: 'search',
                    onClick: function () {
                        if (that.CheckNotExceedOneMonth() > 30) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: "批量对账的单据日期必须小于30天",
                                callback: function () {
                                }
                            });
                        }
                        else {
                            that.CompareReconcile(pickedList, null, "auto");
                        }
                    }
                });

                $('#BtnManualReconcile').FrameButton({
                    text: '人工对账',
                    icon: 'search',
                    onClick: function () {
                        that.CompareReconcile(pickedProductIdsList, pickedProductList, "manual");
                    }
                });

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportSummary("InvRecSummaryExport");
                    }
                });

                $('#BtnExportDetail').FrameButton({
                    text: '导出详细',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportDetail("InvRecDetailExport");
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

    that.OpenDetailWin = function (OrderId, IsShipmentUpdate, IsModified, ShipmentType, DealerId, DealerType) {
        if (OrderId) {
            top.createTab({
                id: 'M_' + OrderId,
                title: '销售出库单明细',
                url: 'Revolution/Pages/Shipment/ShipmentListInfo.aspx?OrderId=' + OrderId + '&&IsShipmentUpdate=' + IsShipmentUpdate + '&&IsModified=' + IsModified + '&&ShipmentType=' + ShipmentType + '&&DealerId=' + DealerId,
                refresh: true
            });
        } else {
            top.createTab({
                id: 'M_ShipmentList_New',
                title: '销售出库单明细',
                url: 'Revolution/Pages/Shipment/ShipmentListInfo.aspx?OrderId=' + OrderId + '&&IsShipmentUpdate=' + IsShipmentUpdate + '&&IsModified=' + IsModified + '&&ShipmentType=' + ShipmentType + '&&DealerId=' + DealerId,
                refresh: true
            });
        }
    }

    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 10000);
    var createResultList = function () {
        var data = that.GetModel(); 
        if (typeof (data) != undefined) {
            if (data.CompareInfo != null) {
                if (data.CompareInfo.Key == "已对账")
                    kendoDataSource = GetKendoDataSource(business, 'Query');
                else
                    kendoDataSource = GetKendoDataSource(business, 'Query', null, 10000);
            } else {

                kendoDataSource = GetKendoDataSource(business, 'Query', null, 10000);
            }

        }

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
                    template: '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item"  /> <label class="k-checkbox-label" for="Check_#=Id#"></label>',
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
                },
                {
                    title: "明细",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 50,
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='detail'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            dataBound: function (e) {
                var grid = e.sender;
                dms.common.dynamicSetmouseStretchText({id:grid.wrapper.attr("Id")});
                $("#RstResultList").find("i[name='detail']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr); 
                    //that.ShowDetails();
                    that.OpenDetailWin(data.Id, "", "", "", data.DealerId, $('#HidDealerType').val());
                });
                 

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
                    $('#RstResultList .Check-Item').each(function (idx, item) {
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
                    that.ShowProductDetailInfo(pickedList);
                });
            },
            page: function (e) {
                $('#CheckAll').removeAttr("checked");
            }
        });
    };

    that.ExportDetail = function (type) {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'InvReconcileDetailExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'SubCompanyName', globalSubCompanyName);
        urlExport = Common.UpdateUrlParams(urlExport, 'BrandName', globalBrandName);
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerId', data.Dealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLineId', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderNumber', data.QryOrderNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'ReconcileStartDate', data.QryReconcileDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'ReconcileEndDate', data.QryReconcileDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'HospitalName', data.QryHospital);
        urlExport = Common.UpdateUrlParams(urlExport, 'CompareInfo', data.CompareInfo.Key);
        startDownload(urlExport, 'InvReconcileDetailExport');
    }

   

    that.CheckNotExceedOneMonth = function () {
        if (pickedList.length > 1) {
            pickedList.sort(function (x, y) {
                var date1 = new Date(x.ShipmentDate), date2 = new Date(y.ShipmentDate);
                return date1.getTime() > date2.getTime();
            })
            var maxDate = new Date(pickedList[0].ShipmentDate),
                minDate = new Date(pickedList[pickedList.length - 1].ShipmentDate);
            var day = parseInt((Date.parse(maxDate) - Date.parse(minDate)) / (1000 * 60 * 60 * 24));
            if (day > 30)
                return false;
            return true;
        }
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
                data.SubCompanyName = globalSubCompanyName == null ? "瑞奇" : globalSubCompanyName;
                data.BrandName = globalBrandName == null ? "瑞奇" : globalBrandName;
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
                                    createResultList();
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
                        pickedList = [], pickedProductList = [], pickedProductIdsList = [];
                        FrameWindow.HideLoading();
                    }
                });
            }
        }
        else {
            if (confirm('确定要人工对账吗')) {
                FrameWindow.ShowLoading();
                if (isExistsProduct("") == true) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '请选择对账失败的产品明细进行人工对账',
                        callback: function () { 
                        }
                    });
                    FrameWindow.HideLoading();
                    return false;
                }

                var data = FrameUtil.GetModel();
                data.Ids = generateQueryFromArray(ids,true);
                data.DetailIds = generateQueryFromArray(iNVRecDetailIds,true);
                data.IsSystemCompare = false;
                data.PageSize = 10;
                data.Page = 1; 
                data.SubCompanyId = globalSubCompanyId;
                data.BrandId = globalBrandId;
                data.SubCompanyName = globalSubCompanyName == null ? "瑞奇" : globalSubCompanyName;
                data.BrandName = globalBrandName == null ? "瑞奇" : globalBrandName;
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
                                    getProductInvoiceDetailInfos(ids,true); 
                                    createResultList();
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
                        pickedList = [], pickedProductList = [], pickedProductIdsList = [];
                        FrameWindow.HideLoading();
                    }
                });
            }
        }
    }

    that.ExportSummary = function (type) {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;

        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'InvRecSummaryExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'SubCompanyName', globalSubCompanyName);
        urlExport = Common.UpdateUrlParams(urlExport, 'BrandName', globalBrandName);
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerId', data.Dealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLineId', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'OrderNumber', data.QryOrderNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'ReconcileStartDate', data.QryReconcileDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'ReconcileEndDate', data.QryReconcileDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'HospitalName', data.QryHospital);
        urlExport = Common.UpdateUrlParams(urlExport, 'CompareInfo', data.CompareInfo.Key);
        startDownload(urlExport, 'InvRecSummaryExport');
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
                pageSizes: true,
                pageSize: 100,
                input: true,
                numeric: false
            },
            columns: [
                {
                    title: "选择", width: '50px', encoded: false,
                    template: '#if(CompareStatus !="对账成功") {# <input type="checkbox" id="Check_Product_#=ProductIndex#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_Product_#=ProductIndex#"></label>#}#',
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
                    field: 'CompareInfos',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '状态' },
                    attributes: { "class": "table-td-cell" }
                }
            ],
            dataBound: function (e) {
                var grid = e.sender;
                dms.common.dynamicSetmouseStretchText({ id: grid.wrapper.attr("Id") });
                $("#RstProductDetail").find(".Check-Item").unbind("click");
                $("#RstProductDetail").find(".Check-Item").on('click', function () {
                    var checked = this.checked,
                        row = $(this).closest("tr"),
                        grid = $("#RstProductDetail").data("kendoGrid"),
                        dataItem = grid.dataItem(row); 
                    if (checked) {
                        dataItem.IsChecked = true;
                        addProductItem(dataItem);
                        addProductIds(dataItem);
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeProductItem(dataItem);
                        removeProductIds(dataItem);
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
                pageSizes: true,
                pageSize: 100,
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
                dms.common.dynamicSetmouseStretchText({ id: grid.wrapper.attr("Id") });
                $('#RstInvDetail').find('i[name="downloadAttach"]').bind('click', function () { 
                    var tr = $(this).closest("tr");
                        grid = $("#RstInvDetail").data("kendoGrid"),
                        dataItem = grid.dataItem(tr); 
                    that.DownloadAttach(dataItem.AT_Name, dataItem.Url);
                });
            }
        });
    };

   

    function getProductInvoiceDetailInfos(ids, tag = false) {
        FrameWindow.ShowLoading();
        var data = FrameUtil.GetModel();
        if (tag)
            data.Ids = generateQueryFromArray(ids, true);
        else
            data.Ids = generateQueryFromArray(ids);
        //data.PageSize = 10;
        //data.Page = 1;
        data.SubCompanyName = globalSubCompanyName == null ? "瑞奇" : globalSubCompanyName;
        data.BrandName = globalBrandName == null ? "瑞奇" : globalBrandName;

        FrameUtil.SubmitAjax({
            business: business,
            method: 'QueryProductInvoiceDetail',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess == true) {
                    $('#RstProductDetail').data("kendoGrid").setOptions({
                        dataSource: { data: model.RstProductDetail }
                    });
                    if (model.RstProductDetail.length > 0)
                        $('#divProductDetail').show();
                    else
                        $('#divProductDetail').hide();

                    $('#RstInvDetail').data("kendoGrid").setOptions({
                        dataSource: { data: model.RstInvoiceDetail }
                    });
                    if (model.RstInvoiceDetail.length > 0)
                        $('#divInvoiceDetail').show();
                    else
                        $('#divInvoiceDetail').hide();

                }
                FrameWindow.HideLoading();
            }
        });

        //FrameUtil.SubmitAjax({
        //    business: business,
        //    method: 'QueryProductDetail',
        //    url: Common.AppHandler,
        //    data: data,
        //    callback: function (model) { 
        //        if (model.IsSuccess == true) {
        //            $('#RstProductDetail').data("kendoGrid").setOptions({
        //                dataSource: { data: model.RstProductDetail}
        //            }); 
        //            if (model.RstProductDetail.length > 0)
        //                $('#divProductDetail').show();
        //            else
        //                $('#divProductDetail').hide();
        //        }
        //        FrameWindow.HideLoading();
        //    }
        //});
        //FrameUtil.SubmitAjax({
        //    business: business,
        //    method: 'QueryInvoiceDetail',
        //    url: Common.AppHandler,
        //    data: data,
        //    callback: function (model) {
        //        if (model.IsSuccess == true) { 
        //            $('#RstInvDetail').data("kendoGrid").setOptions({
        //                dataSource: { data: model.RstInvoiceDetail }
        //            });
        //            if (model.RstInvoiceDetail.length > 0)
        //                $('#divInvoiceDetail').show();
        //            else
        //                $('#divInvoiceDetail').hide();
        //        }
        //        FrameWindow.HideLoading();
        //    }
        //}); 
    }

    var generateQueryFromArray = function (idsArray, tag = false) {
        if (tag == true)
            return idsArray.map(function (id) {
                return "'" + id + "'";
            }).join(',');;
        return idsArray.map(function (id) {
            return "'" + id.Id + "'";
        }).join(',');
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            pickedList.push({ Id: data.Id, ShipmentDate:data.SPH_ShipmentDate});
        }
    }

    var addProductItem = function (data) {
        if (!isExistsProduct(data)) {
            pickedProductList.push(data.INVRecDetailId);
        }
    }

    var addProductIds= function (data) {
        if (!isExistsProductIds(data)) {
            pickedProductIdsList.push(data.Id);
        }
    }

    var isExistsProductIds = function (data) {
        var exists = false;
        for (var i = 0; i < pickedProductIdsList.length; i++) {
            if (pickedProductIdsList[i] == data.Id) {
                exists = true;
            }
        }
        return exists;
    }

    var isExistsProduct = function (data) {
        var exists = false;
        for (var i = 0; i < pickedProductList.length; i++) {
            if (pickedProductList[i] == data.INVRecDetailId || pickedProductList[i] == data) {
                exists = true;
            }
        }
        return exists;
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].Id == data.Id) {
                exists = true;
            }
        }
        return exists;
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].Id == data.Id) {
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

    var removeProductIds = function (data) {
        for (var i = 0; i < pickedProductIdsList.length; i++) {
            if (pickedProductIdsList[i] == data.Id) {
                pickedProductIdsList.splice(i, 1);
                break;
            }
        }
    }

    return that;
}();

 