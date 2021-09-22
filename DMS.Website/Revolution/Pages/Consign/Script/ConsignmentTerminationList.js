var ConsignmentTerminationList = {};

ConsignmentTerminationList = function () {
    var that = {};

    var business = 'Consign.ConsignmentTerminationList';

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



                $('#QryStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryStatus
                });

                $('#QryContractNo').FrameTextBox({
                    value: model.QryContractNo
                });
                $('#QryTerminationNo').FrameTextBox({
                    value: model.QryTerminationNo
                });

                if (model.IsDealer == false) {
                    $('#BtnNew').FrameButton({
                        text: '新增',
                        icon: 'plus',
                        onClick: function () {
                            openInfo();
                        }
                    });
                }

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
                $('#InstanceId').val(model.InstanceId);
            }
        });
    }

    that.Query = function () {
        var data = FrameUtil.GetModel();
        //console.log(data);

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
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "CST_NO", title: "终止编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "终止编号" }
                },
                {
                    field: "CCH_No", title: "合同编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "合同编号" }
                },
                {
                    field: "CCH_Name", title: "合同名称", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "合同名称" }
                },
                {
                    field: "CCH_BeginDate", title: "合同开始时间", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "合同开始时间" }
                },
                {
                    field: "CCH_EndDate", title: "合同结束时间", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "合同结束时间" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" }
                },
                {
                    field: "BrandName", title: "品牌", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" }

                },
                {
                    field: "CST_Status", title: "终止状态", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "终止状态" }
                },
                {
                    title: "编辑", width: "50px",
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

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    openInfo(data.CST_ID, data.CST_Status, data.CCH_No);
                });
            }
        });
    }

    var openInfo = function (InstanceId, Status, CCH_No) {
        var data = FrameUtil.GetModel();
        if (InstanceId) {
            top.createTab({
                id: 'M_Consignment_Termination_Edit' + InstanceId,
                title: '合同终止-' + CCH_No,
                url: 'Revolution/Pages/Consign/ConsignmentTerminationInfo.aspx?InstanceId=' + InstanceId + '&&Status=' + Status,
                refresh: true
            });
        } else {
            top.createTab({
                id: 'M_Consignment_Termination_NEW',
                title: '合同终止 - 新增',
                url: 'Revolution/Pages/Consign/ConsignmentTerminationInfo.aspx?Type=ADD',
                refresh: true
            });
        }
    }

    var setLayout = function () {
    }

    return that;
}();
