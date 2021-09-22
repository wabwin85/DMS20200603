var InterfaceLogList = {};

InterfaceLogList = function () {
    var that = {};

    var business = 'DataInterface.InterfaceLogList';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstIlNameArr = "";
    var LstIlStatusArr = "";

    that.Init = function () {
        var data = {};
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstIlNameArr = model.LstIlName;
                LstIlStatusArr = model.LstIlStatus;
                //接口名称
                $('#QryIlName').FrameDropdownList({
                    dataSource: model.LstIlName,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryIlName
                });
                //接口状态
                $('#QryIlStatus').FrameDropdownList({
                    dataSource: model.LstIlStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryIlStatus
                });
                //平台商
                $('#QryDealer').FrameDropdownList({
                    dataSource: model.LstDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'select',
                    readonly: model.IsDealer,
                    value: model.QryDealer
                });
                //时间
                $('#QryIlDate').FrameDatePickerRange({
                    value: model.QryIlDate
                });
                //批处理号
                $('#QryIlBatchNbr').FrameTextBox({
                    value: model.QryIlBatchNbr
                });
                
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnWinClose').FrameButton({
                    text: '关闭',
                    icon: 'times',
                    onClick: function () {
                        $("#winDetailLayout").data("kendoWindow").close();
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

    var fields = {
        IL_StartTime: { type: "date", format: "{0:yyyy-MM-dd HH:mm:ss}" }, IL_EndTime: { type: "date", format: "{0:yyyy-MM-dd HH:mm:ss}" }
    };
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
                    field: "IL_Name", title: "接口名称", width: 150, template: function (gridrow) {
                        var Name = "";
                        if (LstIlNameArr.length > 0) {
                            if (gridrow.IL_Name != "") {
                                $.each(LstIlNameArr, function () {
                                    if (this.Key == gridrow.IL_Name) {
                                        Name = this.Value;
                                        return false;
                                    }
                                })
                            }
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "接口名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "IL_StartTime", title: "开始时间", width: 150, format: '{0:yyyy-MM-dd HH:mm:ss}',
                    headerAttributes: { "class": "text-center text-bold", "title": "开始时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "IL_EndTime", title: "结束时间", width: 150, format: '{0:yyyy-MM-dd HH:mm:ss}',
                    headerAttributes: { "class": "text-center text-bold", "title": "结束时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "IL_Status", title: "接口状态", width: 150, template: function (gridrow) {
                        var Name = "";
                        if (LstIlStatusArr.length > 0) {
                            if (gridrow.IL_Status != "") {
                                $.each(LstIlStatusArr, function () {
                                    if (this.Key == gridrow.IL_Status) {
                                        Name = this.Value;
                                        return false;
                                    }
                                })
                            }
                            return Name;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "接口状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DMA_ChineseName", title: "平台商", width: 300,
                    headerAttributes: { "class": "text-center text-bold", "title": "平台商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "IL_BatchNbr", title: "批处理号", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "批处理号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "明细", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
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

                    that.ShowDetails(data.Id);
                });

            }
        });
    }

    that.ShowDetails = function (Id) {
        var data = {};
        data.IlId = Id;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitDetail',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
               
                $('#WinIlName').FrameTextBox({
                    value: model.WinIlName,
                    readonly: true
                });
                $('#WinIlStartTime').FrameTextBox({
                    value: model.WinIlStartTime,
                    readonly: true
                });
                $('#WinIlEndTime').FrameTextBox({
                    value: model.WinIlEndTime,
                    readonly: true
                });
                $('#WinIlStatus').FrameTextBox({
                    value: model.WinIlStatus,
                    readonly: true
                });
                $('#WinIlDealerName').FrameTextBox({
                    value: model.WinIlDealerName,
                    readonly: true
                });
                $('#WinIlBatchNbr').FrameTextBox({
                    value: model.WinIlBatchNbr,
                    readonly: true
                });
                $('#WinIlMessage').FrameTextArea({
                    value: model.WinIlMessage,
                    height: '310px'
                });
                $('#WinIlMessage').FrameTextArea('disable');

                FrameWindow.HideLoading();
            }
        });
        $("#winDetailLayout").kendoWindow({
            title: "Title",
            width: 900,
            height: 500,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("日志明细").center().open();
    }

    var setLayout = function () {
    }

    return that;
}();
