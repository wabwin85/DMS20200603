var SellInData = {};

SellInData = function () {
    var that = {};
    var developModel = true;
    var business = 'Shipment.Extense.SellInData';
    var globalBrandId = parent.$('#IptBrandId').val();
    var globalSubCompanyId = parent.$('#IptSubCompanyId').val();
    var globalSubCompanyName = parent.$('#IptSubCompanyName').html() == undefined ? "瑞奇" : parent.$('#IptSubCompanyName').html();
    var globalBrandName = parent.$('#IptBrandName').html() == undefined ? "瑞奇" : parent.$('#IptBrandName').html();
    $('#SubCompanyName').val(globalSubCompanyName == undefined ? "瑞奇" : globalSubCompanyName);
    $('#BrandName').val(globalBrandName == undefined ? "瑞奇" : globalBrandName);

    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        return model;
    };

    that.Init = function () {
        var data = FrameUtil.GetModel();

        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: "Init",
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#SelAccountYear').FrameDropdownList({
                    dataSource: [
                        { Key: "全部", Value: "全部" },
                        { Key: "2022", Value: "2022" },
                        { Key: "2021", Value: "2021" },
                        { Key: "2020", Value: "2020" }
                    ],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.SelAccountYear
                });
                $('#SelAccountMonth').FrameDropdownList({
                    dataSource: [{ Key: "全部", Value: "全部" }, { Key: "01", Value: "01" }, { Key: "02", Value: "02" }, { Key: "03", Value: "03" }, { Key: "04", Value: "04" }, { Key: "05", Value: "05" }, { Key: "06", Value: "06" }, { Key: "07", Value: "07" }, { Key: "08", Value: "08" }, { Key: "09", Value: "09" }, { Key: "10", Value: "10" }, { Key: "11", Value: "11" }, { Key: "12", Value: "12" }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.SelAccountMonth
                });
                $('#SelSubCompany').FrameDropdownList({
                    dataSource: [ { Key: "瑞奇", Value: "瑞奇" }, { Key: "神经介入", Value: "神经介入" }, { Key: "切口事业部", Value: "切口事业部" }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.SelSubCompany
                });
                $('#SelQuarter').FrameDropdownList({
                    dataSource: [{ Key: "Q1", Value: "Q1" }, { Key: "Q2", Value: "Q2" }, { Key: "Q3", Value: "Q3" }, { Key: "Q4", Value: "Q4" }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.SelQuarter

                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        createResultList();
                        that.Query(); 
                    }
                }); 

                $('#BtnImport').FrameButton({
                    text: '导入',
                    icon: 'file-code-o',
                    onClick: function () {
                        that.openInfo();
                    }
                });
                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                       
                        that.ExportData();
                    }
                });
                FrameWindow.HideLoading();
            }

        });
    };
    var kendoDataSource = GetKendoDataSource(business, 'Query');

    that.openInfo = function () {
        top.createTab({
            id: 'S_商采数据导入',
            title: '商采数据导入',
            url: developModel == true ? 'Revolution/Pages/Shipment/Extense/SellInDataImport.aspx' : 'Extense/Revolution/Pages/Shipment/Extense/SellInDataImport.aspx'
        });
    }

    that.ExportData = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'SellInDataExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'SubCompany', globalSubCompanyName);
        urlExport = Common.UpdateUrlParams(urlExport, 'Brand', globalBrandName);
        urlExport = Common.UpdateUrlParams(urlExport, 'AccountingYear', data.SelAccountYear.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'AccountingQuarter', data.SelQuarter.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'AccountingMonth', data.SelAccountMonth.Key);
        startDownload(urlExport, 'SellInDataExport');
    }

    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }
    var createResultList = function () {
        $('#RstResultList').kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            noRecords: true,
            editable: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 20,
                input: true,
                numeric: false
            },
            columns: [
                {
                    field: 'SubCompany',
                    title: '分子公司',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '分子公司' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Brand',
                    title: '品牌',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '品牌' },
                    attributes: { "class": "table-td-cell" }
                }
                , {
                    field: 'AccountingYear',
                    title: '核算年份',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '核算年份' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'AccountingQuarter',
                    title: '核算季度',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '核算季度' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'AccountingMonth',
                    title: '核算月份（记帐期间）',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '核算月度' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Channel',
                    title: '渠道',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '渠道' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SalesIdentity',
                    title: '销售凭证',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '销售凭证' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SalesIdentityRow',
                    title: '销售凭证行项目',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '销售凭证行项目' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'OrderType',
                    title: '订单类型',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '订单类型' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ActualDiscount',
                    title: '实际折扣',
                    width: '40px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '实际折扣' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'CompanyCode',
                    title: '公司代码',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '公司代码' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: '公司名称',
                    title: 'CompanyName',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '公司名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'IsRelated',
                    title: '关联方',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '关联方' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'RevenueType',
                    title: '收入类型',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '收入类型' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'BorderType',
                    title: '国内外',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '国内外' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ProductLine',
                    title: '产品线',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品线' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ProductProvince',
                    title: '产品线&省份',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品线&省份' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceDate',
                    title: '出具发票日期',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '出具发票日期' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SoldPartyDealerCode',
                    title: '售达方DMS Code',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '售达方DMS Code' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SoldPartySAPCode',
                    title: '售达方',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '售达方' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SoldPartyName',
                    title: '售达方名称',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '售达方名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'BillingType',
                    title: '开票类型',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '开票类型' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Province',
                    title: '省份',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '省份' },
                    editable: true,
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ExchangeRate',
                    title: '汇率',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '汇率' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'MaterialCode',
                    title: '物料',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '物料' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'MaterialName',
                    title: '物料名称',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '物料名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'UPN',
                    title: '规格型号',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '规格型号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'OutInvoiceNum',
                    title: '已出发票数量',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '已出发票数量' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceNetAmount',
                    title: '开票金额（净价）',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '开票金额（净价）' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceRate',
                    title: '开票税额',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '开票税额' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'RebateNetAmount',
                    title: '返利金额（净价）',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '返利金额（净价）' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'RebateRate',
                    title: '返利税额',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '返利税额' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceAmount',
                    title: '开票总额',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '开票总额' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'LocalCurrencyAmount',
                    title: '本币金额',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '本币金额' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'KLocalCurrencyAmount',
                    title: '本币金额(K)',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '本币金额(K)' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'DeliveryDate',
                    title: '发货日期',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发货日期' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'OrderCreateDate',
                    title: '订单创建日期',
                    width: '60px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '订单创建日期' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ProductLineAndSoldParty',
                    title: '产品线&售达方',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品线&售达方' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ActualLegalEntity',
                    title: '实控方',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '实控方' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'IsNeedRecovery',
                    title: '是否需要还原',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '是否需要还原' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'RecoveryComment',
                    title: '还原备注',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '还原备注' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'BusinessCaliber',
                    title: '商务口径收入',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '商务口径收入' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ClosedAccount',
                    title: '关账收入',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '关账收入' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Comment',
                    title: '备注',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '备注' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'ProductGeneration',
                    title: '产品代次',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品代次' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'StandardPrice',
                    title: '标准价',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '标准价' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Region',
                    title: '区域',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '区域' },
                    attributes: { "class": "table-td-cell" }
                },
            ]

        });
    }

    return that;

}();