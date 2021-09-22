var InterfaceDataList = {};

InterfaceDataList = function () {
    var that = {};

    var business = 'DataInterface.InterfaceDataList';
    var chooseInterface = [];

    var LstStatusArr;
    var LstTypeArr;

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
                //接口类型
                $('#QryInterfaceType').FrameDropdownList({
                    dataSource: model.LstInterfaceType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryInterfaceType
                });
                LstTypeArr = model.LstInterfaceType;
                //接口状态
                $('#QryInterfaceStatus').FrameDropdownList({
                    dataSource: model.LstInterfaceStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryInterfaceStatus
                });
                LstStatusArr = model.LstInterfaceStatus;
                //平台商
                $('#QryClient').FrameDropdownList({
                    dataSource: model.LstClient,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'select',
                    value: model.QryClient
                });
                $('#QryInterfaceDate').FrameDatePickerRange({
                    value: model.QryInterfaceDate
                });
                $('#QryBatchNbr').FrameTextBox({
                    value: model.QryBatchNbr
                });
                $('#QryHeaderNo').FrameTextBox({
                    value: model.QryHeaderNo
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnPending').FrameButton({
                    text: '重置',
                    icon: 'refresh',
                    onClick: function () {
                        that.SetRecordStatus('Pending');
                    }
                });

                if (model.IsDealer)
                {
                    $('#QryClient').FrameDropdownList('disable');
                }

                createResultList();

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.Query = function () {
        if ($('#QryInterfaceType').FrameDropdownList('getValue').Key != '') {
            clearChooseInterface();
            var grid = $("#RstResultList").data("kendoGrid");
            if (grid) {
                grid.dataSource.page(0);
                return;
            }
        }
        else {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请先选择接口类型！'
            });
            return;
        }
    }

    var fields = { CreateDate: { type: "date", format: "{0: yyyy-MM-dd HH:mm:ss}" } }
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
                    title: "选择", width: 50, encoded: false,
                    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '#if(Status == "Pending" || Status == "Success" || Status == "Failure"){#<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>#}#',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "HeaderNo", title: "单据号", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "单据号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DataType", title: "接口类型", width: 180, template: function (gridRow) {
                        var type = "";
                        if (LstTypeArr.length > 0) {
                            if (gridRow.DataType != "") {
                                $.each(LstTypeArr, function () {
                                    if (this.Key == gridRow.DataType) {
                                        type = this.Value;
                                        return false;
                                    }
                                })
                            }
                        }
                        return type;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "接口类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Status", title: "接口状态", width: 120, template: function (gridRow) {
                        var status = "";
                        if (LstStatusArr.length > 0) {
                            if (gridRow.Status != "") {
                                $.each(LstStatusArr, function () {
                                    if (this.Key == gridRow.Status) {
                                        status = this.Value;
                                        return false;
                                    }
                                })
                            }
                        }
                        return status;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "接口状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DealerName", title: "平台商", width: 260,
                    headerAttributes: { "class": "text-center text-bold", "title": "平台商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CreateDate", title: "生成时间", width: 150, format: "{0:yyyy-MM-dd HH:mm:ss}",
                    headerAttributes: { "class": "text-center text-bold", "title": "生成时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "BatchNbr", title: "批处理号", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "批处理号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "RecordNbr", title: "行号", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "行号" },
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
                var grid = e.sender;

                $("#RstResultList").find(".Check-Item").unbind("click");
                $("#RstResultList").find(".Check-Item").on("click", function () {
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
                });

                $('#CheckAll').unbind('change');
                $('#CheckAll').on('change', function (ev) {
                    var checked = ev.target.checked;
                    $('.Check-Item').each(function (idx, item) {
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
                });
            },
            page: function (e) {
                clearChooseInterface();
            }
        });
    }

    that.SetRecordStatus = function (status) {
        if ($('#QryInterfaceType').FrameDropdownList('getValue').Key == '') {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请先选择接口类型！'
            });
            return false;
        }
        
        if (chooseInterface.length > 0) {
            if (confirm('你确定执行该操作吗？')) {
                var data = {};
                var param = '';
                for (var i = 0; i < chooseInterface.length; i++) {
                    param += chooseInterface[i] + ';';
                }
                data.ParamID = param;
                data.ExecStatus = status;
                data.QryInterfaceType = $('#QryInterfaceType').FrameDropdownList('getValue');
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'SetRecordStatus',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.ExecuteMessage != "Success") {
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: model.ExecuteMessage
                            });
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: '执行成功！'
                            });
                            that.Query();
                        }
                        FrameWindow.HideLoading();
                    }
                });
            }
        }
        else {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择需要重置的数据！'
            });
        }
    }

    var clearChooseInterface = function () {
        $('#CheckAll').removeAttr("checked");
        chooseInterface.splice(0, chooseInterface.length);
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            chooseInterface.push(data.Id);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < chooseInterface.length; i++) {
            if (chooseInterface[i] == data.Id) {
                chooseInterface.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < chooseInterface.length; i++) {
            if (chooseInterface[i] == data.Id) {
                exists = true;
            }
        }
        return exists;
    }

    var setLayout = function () {
    }

    return that;
}();