var ConsignApplyList = {};

ConsignApplyList = function () {
    var that = {};

    var business = 'Consign.ConsignApplyList';

    that.GetModel = function () {
        var model = $.getModel();

        return model;
    }

    that.Init = function () {
        var data = {};

        submitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'all',
                    value: model.QryBu
                });
                $('#QryDealer').FrameTextBox({
                    //dataSource: model.LstBu,
                    //dataKey: 'Id',
                    //dataValue: 'Name',
                    //selectType: 'all',
                    value: model.QryDealer
                });
                $('#QryApplyNo').FrameTextBox({
                    value: model.QryContractNo
                });
                $('#QryApplyStatus').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'CodeId',
                    dataValue: 'CodeValue',
                    selectType: 'all',
                    value: model.QryStatus
                });
                $('#QryConsignContract').FrameTextBox({
                    value: model.QryContractNo
                });
                $('#QryHospital').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryDiscountRule
                });
                $('#QryHasUpn').FrameTextBox({
                    dataSource: [],
                    dataKey: 'CodeId',
                    dataValue: 'CodeValue',
                    selectType: 'all',
                    value: model.QryHasUpn
                });
                $('#QryApplyDate').FrameDatePickerRange({
                    value: model.QryContractDate
                });
                $('#QrySale').FrameTextBox({
                    value: model.QryContractNo
                });

                $('#PnlButton').append('<button id="BtnNew" class="tss-btn btn-primary"><i class="fa fa-fw fa-file"></i>&nbsp;&nbsp;新增</button>\n');
                $('#BtnNew').FrameButton({
                    onClick: function () {
                        openInfo();
                    }
                });
                $('#PnlButton').append('<button id="BtnQuery" class="tss-btn btn-primary"><i class="fa fa-fw fa-search"></i>&nbsp;&nbsp;查询</button>\n');
                $('#BtnQuery').FrameButton({
                    onClick: function () {
                        that.Query();
                    }
                });

                createResultList(model.RstResultList);

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                hideLoading();
            }
        });
    }

    that.Query = function () {
        var data = that.GetModel();

        showLoading();
        submitAjax({
            business: business,
            method: 'Query',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });

                hideLoading();
            }
        });
    }

    //大区维护
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = $.updateUrlParams(urlExport, 'Area', data.QryArea);
        urlExport = $.updateUrlParams(urlExport, 'IsActive', data.QryIsActive);

        startDownload({
            url: urlExport,
            cookie: 'AreaListExport',
            business: business
        });
    }

    var createResultList = function (dataSource) {
        $("#RstResultList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "BU", title: "BU", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "BU" }
                },
                {
                    field: "Dealer", title: "经销商", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" }
                },
                {
                    field: "ApplyNo", title: "申请单号", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请单号" }
                },
                {
                    field: "ApplyDate", title: "申请时间", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请时间" }
                },
                {
                    field: "ApplyPeople", title: "申请人", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请人" }
                },
                {
                    field: "ConsignContract", title: "寄售合同", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "寄售合同" }
                },
                {
                    field: "BillStatus", title: "单据状态", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "单据状态" }
                },
                {
                    field: "Hospital", title: "医院", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院" }
                },
                {
                    field: "Sale", title: "销售", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "销售" }
                },

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 20,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstResultList").find(".AreaName").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    //openInfo(data.AreaCode, data.AreaName);
                });
            }
        });
    }

    var openInfo = function (InstanceId, InstanceNo) {
        if (InstanceId) {
            top.createTab('M_' + id, '寄售申请 - ' + InstanceNo, '/Revolution/Pages/Consign/ConsignContractInfo.aspx?InstanceId=' + InstanceId, true);
        } else {
            top.createTab('M_CONSIGN_CONTRACT_NEW', '寄售申请 - 新增', '/Revolution/Pages/Consign/ConsignContractInfo.aspx', true);
        }
    }

    var setLayout = function () {
    }

    return that;
}();
