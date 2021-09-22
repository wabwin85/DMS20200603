var ThirdPartyQueryForGenesis = {};

ThirdPartyQueryForGenesis = function () {
    var that = {};

    var business = 'Contract.ThirdPartyQueryForGenesis';

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
                //经销商
                $('#QryDealer').DmsDealerFilter({
                    dataSource: model.LstDealer,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealer
                });
                //审批状态
                $('#QryApprovalStatus').FrameDropdownList({
                    dataSource: [{ Key: '申请审批中', Value: '申请审批中' }, { Key: '申请审批通过', Value: '申请审批通过' }, { Key: '申请审批拒绝', Value: '申请审批拒绝' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryApprovalStatus
                });
                //是否上传附件
                $('#QryIsAttach').FrameDropdownList({
                    dataSource: [{ Key: '是', Value: '是' }, { Key: '否', Value: '否' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryIsAttach
                });
                //医院名称
                $('#QryHospitalName').FrameTextBox({
                    value: model.QryHospitalName
                });
                //是否已披露医院
                $('#QryIsHospital').FrameDropdownList({
                    dataSource: [{ Key: '是', Value: '是' }, { Key: '否', Value: '否' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryIsHospital
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });

                if (model.DisableSelect) {
                    $('#QryDealer').DmsDealerFilter('disable');
                }

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
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 15);

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 510,
            columns: [
                {
                    field: "SAPCode", title: "ERPCode", width: 150, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "ERPCode" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "经销商中文名称", width: 230,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商中文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductNameString", title: "产品线", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HospitaCode", title: "医院Code", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院Code" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HospitalName", title: "医院名称", width: 150, 
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CompanyName", title: "第三方公司1", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "第三方公司1" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Rsm", title: "与第三方关系1", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "与第三方关系1" },
                    attributes: { "class": "table-td-cell" }
                },
                //{
                //    field: "CompanyName2", title: "第三方公司2", width: 150,
                //    headerAttributes: { "class": "text-center text-bold", "title": "第三方公司2" },
                //    attributes: { "class": "table-td-cell" }
                //},
                //{
                //    field: "Rsm2", title: "与第三方关系2", width: 120,
                //    headerAttributes: { "class": "text-center text-bold", "title": "与第三方关系2" },
                //    attributes: { "class": "table-td-cell" }
                //},
                {
                    field: "CreatDate", title: "披露时间", width: 100, format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "披露时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ApprovalDate", title: "审批时间", width: 120, format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "审批时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ApprovalStatus", title: "审批状态", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "审批状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "IsAt", title: "是否上传附件", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "是否上传附件" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "NotTP", title: "确认无披露", width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "确认无披露" },
                    attributes: { "class": "table-td-cell" }
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
                
            }
        });
    }

    //导出
    that.Export = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'ThirdPartyQueryForGenesisExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'DmaId', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Name', data.QryHospitalName);
        urlExport = Common.UpdateUrlParams(urlExport, 'IsAt', data.QryIsAttach.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'ApprovalStatus', data.QryApprovalStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'IsHospital', data.QryIsHospital.Key);
        startDownload(urlExport, 'ThirdPartyQueryForGenesisExport');//下载名称
    }

    var setLayout = function () {
    }

    return that;
}();
