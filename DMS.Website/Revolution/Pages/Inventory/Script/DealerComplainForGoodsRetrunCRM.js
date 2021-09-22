var DealerComplainForGoodsRetrunCRM = {};

DealerComplainForGoodsRetrunCRM = function () {
    var that = {};

    var business = 'Inventory.DealerComplainForGoodsRetrunCRM';

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
                $('#QryDealer').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealer
                });

                $('#QryStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryStatus
                });
                $('#QryComplainNumber').FrameTextBox({
                    value: model.QryComplainNumber
                });

                $('#QrySubmitDate').FrameDatePickerRange({
                    value: model.QrySubmitDate
                });

                $('#QryApplyUser').FrameTextBox({
                    value: model.QryApplyUser
                });

                $('#QryUPN').FrameTextBox({
                    value: model.QryUPN
                });
                $('#QryLotNumber').FrameTextBox({
                    value: model.QryLotNumber
                });
                $('#QryDN').FrameTextBox({
                    value: model.QryDN
                });

                if (model.IsCanApply == true) {
                    $('#BtnNew').FrameButton({
                        text: '新增',
                        icon: 'file',
                        onClick: function () {
                            openInfo();
                        }
                    });
                }
                else {
                    $('#BtnNew').remove();
                }

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

    //大区维护
    that.Export = function () {
        var data = that.GetModel();
        
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DealerComplainForGoodsRetrunCRMListExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'Dealer', data.QryDealer.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Status', data.QryStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'ComplainNumber', data.QryComplainNumber);
        urlExport = Common.UpdateUrlParams(urlExport, 'DN', data.QryDN);
        urlExport = Common.UpdateUrlParams(urlExport, 'UPN', data.QryUPN);
        urlExport = Common.UpdateUrlParams(urlExport, 'ApplyUser', data.QryApplyUser);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubmitDateStartDate', data.QrySubmitDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'SubmitDateEndDate', data.QrySubmitDate.EndDate);
        startDownload(urlExport, 'DealerComplainForGoodsRetrunCRMListExport');

       

    }
    //返回服务端分页数据，第一个参数为映射business页面，第二个参数为business页面查询方法，第三个参数为需要格式化参数类型，如日期类型，无需处理则传入null或不传，第四个参数每页显示条目，不传默认为10条
    var fields = { DC_CreatedDate: { type: "date" } };
    var kendoDataSource = GetKendoDataSource(business, 'Query',fields,15);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "DC_ComplainNbr", title: "投诉申请单编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "投诉申请单编号" }
                },
                {
                    field: "ComplainType", title: "投诉类型", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "投诉类型" }
                },
                {
                    field: "CorpName", title: "经销商", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" }
                },
                {
                    field: "IDENTITY_NAME", title: "申请人", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请人" }
                },
                {
                    field: "CarrierNumber", title: "经销商快递单号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商快递单号" }
                },
                {
                    field: "DN", title: "蓝威全球投诉号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "蓝威全球投诉号" }
                },
                {
                    field: "StatusName", title: "状态", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "状态" }
                },
                {
                    field: "DC_CreatedDate", title: "申请日期", width: '100px', format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "申请日期" }
                },
                {
                    field: "PropertyRight", title: "产品物权", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品物权" }
                },
                {
                    field: "ReturnType", title: "处理类型", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "处理类型" }
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
                refresh: true,
                pageSizes: false
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

                    openInfo(data.CCH_ID, data.Status, data.No);
                });
            }
        });
    }

    var openInfo = function (InstanceId, Status, No) {
        if (InstanceId) {
            top.createTab({
                id: 'M_' + InstanceId,
                title: '寄售合同 -' + No,
                url: 'Revolution/Pages/Consign/ConsignContractInfo.aspx?InstanceId=' + InstanceId + '&&Status=' + Status
            });
        } else {
            top.createTab({
                id: 'M_CONSIGN_CONTRACT_NEW',
                title: '寄售合同 - 新增',
                url: 'Revolution/Pages/Consign/ConsignContractInfo.aspx'
            });
        }
    }

    var setLayout = function () {
    }

    return that;
}();
