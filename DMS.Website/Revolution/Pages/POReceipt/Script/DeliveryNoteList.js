var DeliveryNoteList = {};

DeliveryNoteList = function () {
    var that = {};

    var business = 'POReceipt.DeliveryNoteList';

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
                var LayoutDealer = model.QryDealer;
                $("#DealerListType").val(model.DealerListType);
                if (model.IsDealer)//经销商,锁定经销商选择
                {
                    LayoutDealer = { Key: model.LstDealer[0].Id, Value: model.LstDealer[0].Name };
                }
                //经销商
                //$('#QryDealer').FrameDropdownList({
                //    dataSource: model.LstDealer,
                //    dataKey: 'Id',
                //    dataValue: 'Name',
                //    selectType: 'all',
                //    filter: "contains",
                //    readonly: model.IsDealer ? true : false,
                //    value: LayoutDealer
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
                    readonly: model.IsDealer ? true : false,
                    serferFilter: true,
                    value: model.QryDealer,
                });
                //申请单类型
                $('#QryType').FrameDropdownList({
                    dataSource: model.LstQType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryType
                });
                //日期
                $('#QryPOreceiptDate').FrameDatePickerRange({
                    value: model.QryPOreceiptDate
                });
                //发货单号
                $('#QryDeliveryNoteNbr').FrameTextBox({
                    value: model.QryDeliveryNoteNbr
                });
                //经销商采购单号
                $('#QryPONbr').FrameTextBox({
                    value: model.QryPONbr
                });
                $('#QrySapCode').FrameTextBox({
                    value: model.QrySapCode
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });


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
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 15);


    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "DealeridDmaName", title: "经销商中文名", width: '130px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商中文名" },
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
                    field: "SapCode", title: "ERP代码", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "ERP代码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PoNbr", title: "采购单号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "采购单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DeliveryNoteNbr", title: "发货单号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "发货单号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Cfn", title: "产品型号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotNumber", title: "序列号/批次", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号/批次" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ExpiredDate", title: "过期日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "过期日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DnUnitOfMeasure", title: "单位", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ReceiveQty", title: "数量", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ShipmentDate", title: "发货日期", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "发货日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ReceiptUserName", title: "导入文件名", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "导入文件名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "StatusName", title: "单价", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单价" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CreateDate", title: "生成日期", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "生成日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProblemDescription", title: "问题描述", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "问题描述" },
                    attributes: { "class": "table-td-cell" }
                }

            ],
            pageable: {
                refresh: true,
                pageSizes: false,
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;
            }
        });
    }


    var setLayout = function () {
    }

    return that;
}();
