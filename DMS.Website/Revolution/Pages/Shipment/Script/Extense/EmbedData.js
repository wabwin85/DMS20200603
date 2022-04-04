var EmbedData = {};

EmbedData = function () {
    var that = {};
    var developModel = true;
    var business = 'Shipment.Extense.EmbedData';
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
                $('#SelSubCompany').FrameDropdownList({
                    dataSource: [{ Key: "全部", Value: "全部" }, { Key: "瑞奇", Value: "瑞奇" }, { Key: "神经介入", Value: "神经介入" }, { Key: "切口事业部", Value: "切口事业部" }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value:model.SubCompany
                });
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
                    dataSource: [{ Key: "全部", Value: "全部" }, { Key: "01", Value: "01" }, { Key: "02", Value: "02" }, { Key: "03", Value: "03" }, { Key: "04", Value: "04" }, { Key: "05", Value: "05" }, { Key: "06", Value: "06" }, { Key: "07", Value: "07" }, { Key: "08", Value: "08" }, { Key: "09", Value: "09" }, { Key: "10", Value: "10" } ,{ Key: "11", Value: "11" }, { Key: "12", Value: "12" }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.SelAccountMonth
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
            id: 'S_植入数据导入',
            title: '植入数据导入',
            url: developModel == true ? 'Revolution/Pages/Shipment/Extense/EmbedDataImport.aspx' : 'Extense/Revolution/Pages/Shipment/Extense/EmbedDataImport.aspx'
        });
    }

    that.ExportData = function () { 
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'EmbedDataExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'SubCompany', globalSubCompanyName);
        urlExport = Common.UpdateUrlParams(urlExport, 'Brand', globalBrandName);
        urlExport = Common.UpdateUrlParams(urlExport, 'AccountingYear', data.SelAccountYear.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'AccountingMonth', data.SelAccountMonth.Key);
        startDownload(urlExport, 'EmbedDataExport');
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
                    field:'SubCompany',
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
                }, {
                    field: 'AccountingYear',
                    title: '核算年份',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '核算年份' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'AccountingMonth',
                    title: '核算月度',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '核算月度' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'DealerCode',
                    title: 'DMS经销商编号',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '经销商编号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'DealerName',
                    title: '经销商名称',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '经销商名称' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'LegalEntity',
                    title: '实控方',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '实控方' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'SalesEntity',
                    title: '销售方名称（发票卖方）',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '销售方名称（发票卖方）' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Hos_Level',
                    title: '医院等级',
                    width: '40px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '医院等级' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Hos_Type',
                    title: '医院类型',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '医院类型' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Hos_Code',
                    title: 'DMS医院编号',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': 'DMS医院编号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Hos_Name',
                    title: '医院名称（发票买方）',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '医院名称（发票买方）' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'NewOpenMonth',
                    title: '新开月份',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '新开月份' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'NewOpenProduct',
                    title: '新开产品',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '新开产品' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'PMA_UPN',
                    title: '规格型号',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '规格型号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'CFN_Name',
                    title: '商品名称',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '商品名称' },
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
                    field: 'ShipmentNbr',
                    title: '出库单号',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '出库单号' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'UsedDate',
                    title: '出库/用量日期',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '出库/用量日期' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceNumber',
                    title: '发票号码',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票号码' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceDate',
                    title: '发票日期',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票日期' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Quantity',
                    title: '数量',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '数量' },
                    editable:true,
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoicePrice',
                    title: '发票单价（不含税)',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票单价（不含税)' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'InvoiceRate',
                    title: '税率',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '税率' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'AssessUnitPrice',
                    title: '考核单价（未税）',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '考核单价（未税）' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'AssessPrice',
                    title: '考核金额（未税）',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '考核金额（未税）' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'Remark',
                    title: '备注',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '备注' },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: 'IsLocked',
                    title: '数据状态',
                    width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '数据状态' },
                    attributes: { "class": "table-td-cell" },
                    template: function (gridRow) {
                        var isLocked = gridRow.IsLocked;
                        if (isLocked)
                            return '锁定';
                        else
                            return '正常';
                    }
                }
            ]

        });
    }

    return that;

}();