var TenderAuthorizationList = {};

TenderAuthorizationList = function () {
    var that = {};

    var business = 'Contract.TenderAuthorizationList';
    var pickedList = [];
    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = FrameUtil.GetModel();
        FrameWindow.ShowLoading();
        createResultList();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryDealer').FrameTextBox({
                    value: model.QryDealer,
                });
                $('#QryAuthorizationNo').FrameTextBox({
                    value: model.QryAuthorizationNo
                });
                $('#QryAuthorizationStart').FrameDatePickerRange({
                    value: model.QryAuthorizationStart
                });
                $('#QryAuthorizationEnd').FrameDatePickerRange({
                    value: model.QryAuthorizationEnd
                });
                $('#QryApproveDate').FrameDatePickerRange({
                    value: model.QryApproveDate
                });
                
                $('#QryApproveStatus').FrameDropdownList({
                    dataSource: model.ListApproveStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryApproveStatus
                });
                $('#QryAuthorizationType').FrameDropdownList({
                    dataSource: model.ListAuthorizationType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryAuthorizationType
                });
                
                $('#QryHospital').FrameTextBox({
                    value: model.QryHospital
                });
                
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnAdd').FrameButton({
                    text: '新增',
                    icon: 'file',
                    onClick: function () {
                        that.openInfo('');
                    }
                });

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });
                $('#export').FrameButton({
                    text: '导出授权书',
                    icon: 'file-pdf-o',
                    onClick: function () {
                        that.ExportAuthPDF();
                    }
                });
                $('#colse').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $("#windowLayout").data("kendoWindow").close();
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
    var fields = { DTM_BeginDate: { type: "date" }, DTM_EndDate: { type: "date" }, CreateDate: { type: "date" }, ApprovedDate: { type: "date" } };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    field: "DTM_NO", title: "授权书编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "授权书编号" },
                },
                {
                    field: "DTM_DealerName", title: "经销商名称", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" },
                },
                {
                    field: "DTM_ApplicType", title: "授权类型", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "授权类型" },
                },
                
                {
                    field: "DTM_BeginDate", title: "授权开始时间", width: '100px', format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "授权开始时间" }
                },
                {
                    field: "DTM_EndDate", title: "授权终止时间", width: '100px', format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "授权终止时间" }
                },
                {
                    field: "States", title: "审批状态", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "审批状态" }
                },
                {
                    field: "UserName", title: "申请人", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "申请人" }
                },
                {
                    field: "CreateDate", title: "申请时间", width: '100px', format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "申请时间" }
                },
                {
                    field: "ApprovedDate", title: "审批完成时间", width: '100px', format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "审批完成时间" }
                }
                ,
                {
                    title: "操作", width: "80px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if (States == '草稿') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#} else if(States == '审批通过'){#<i class='fa fa-file-pdf-o' style='font-size: 14px; cursor: pointer;' name='export'></i>#}else if(States == '审批中'){#<i class='fa fa-sign-out' style='font-size: 14px; cursor: pointer;' name='approve'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
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

                    var DTMID = data.DTM_ID;
                    that.openInfo(DTMID);
                });
                $("#RstResultList").find("i[name='export']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    var model = {};
                    model.DTMID = data.DTM_ID;
                    model.ConstractType = data.DTM_ApplicType;
                    that.initDiv(model);
                });
                $("#RstResultList").find("i[name='approval']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var datag = grid.dataItem(tr);
                    var data = FrameUtil.GetModel();
                    data.DTMID = datag.DTM_ID;
                    FrameWindow.ShowLoading();
                    createResultList();
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'GetEkpHistoryPageUrl',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            if (model.IsSuccess) {
                                window.open(model.ApprovalUrl, 'full', 'fullscreen');
                            }
                            $(window).resize(function () {
                                setLayout();
                            })
                            setLayout();

                            FrameWindow.HideLoading();
                        }
                    });
                    
                });
            },
            page: function (e) {
            }
        });
    }


    that.openInfo = function (InstansId) {
        //top.createTab({
        //    id: 'M_价格导入',
        //    title: '价格导入',
        //    url: 'Revolution/Pages/Contract/TenderAuthorizationInfo.aspx?InstanceId=' + InstansId
        //});
        window.location.href = 'TenderAuthorizationInfo.aspx?InstanceId=' + InstansId;
    }
    that.initDiv = function (obj) {
        $("#windowLayout").kendoWindow({
            title: "Title",
            width: 450,
            height: 150,
            actions: [
                "Pin",
                "Minimize",
                "Maximize",
                "Close"
            ],
            modal: true,
        }).data("kendoWindow").title("导出授权书").center().open();
        
        $('#ConstractType').FrameTextBox({
            value: obj.ConstractType,
            readonly:true
        });
        var data = FrameUtil.GetModel();
        data.DTMID = obj.DTMID;
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'GetExpAuthorization',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    $('#IptAuthorizationTypeExt').FrameDropdownList({
                        dataSource: model.ListAuthorizationTypeExt,
                        dataKey: 'Key',
                        dataValue: 'Value',
                        selectType: 'all',
                        value: model.IptAuthorizationTypeExt
                    });
                    $('#DTMID').FrameTextBox({
                        value: model.DTMID
                    });
                }
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });

    }
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'TenderAuthorizationListExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'Dealer', data.QryDealer);
        urlExport = Common.UpdateUrlParams(urlExport, 'AuthorizationNo', data.QryAuthorizationNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'StartBeginsDate', data.QryAuthorizationStart.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'StopBeginsDate', data.QryAuthorizationStart.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'StartEndDate', data.QryAuthorizationEnd.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'StopEndDate', data.QryAuthorizationEnd.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'BeginApprovedDate', data.QryApproveDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'EndApprovedDate', data.QryApproveDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'cbStatesType', data.QryApproveStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Authorization', data.QryAuthorizationType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Hospital', data.QryHospital);
        startDownload(urlExport, 'TenderAuthorizationListExport');
    }
    that.ExportAuthPDF = function () {
        var data = FrameUtil.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'GetDownloadPDFPath',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    var url = '../Download.aspx?downloadname=' + model.DTMNO + '&filename=' + model.PdfName + '&downtype=TenderFile';
                    open(url, 'Download');
                }
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }
    var setLayout = function () {
    }

    return that;
}();
