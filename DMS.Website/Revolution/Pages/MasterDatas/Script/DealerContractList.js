var DealerContractList = {};

DealerContractList = function () {
    var that = {};

    var business = 'MasterDatas.DealerContractList';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        return model;
    }

    that.Init = function () {
        var model = FrameUtil.GetModel();
        createResultList();
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
        $('#QryContractNumber').FrameTextBox({
            value: model.QryContractNumber
        });
        $('#QryContractYears').FrameTextBox({
            value: model.QryContractYears
        });
        $('#DeleteDealerContractID').FrameTextBox({
            value: model.DeleteDealerContractID
        });
        $('#BtnQuery').FrameButton({
            text: '查询',
            icon: 'search',
            onClick: function () {
                that.Query();
            }
        });
        $('#BtnNew').FrameButton({
            text: '新增',
            icon: 'file',
            onClick: function () {
                model.AddDealerContractID = null;
                that.initDetailDiv(model, false);
            }
        });

        $('#saveDetail').FrameButton({
            text: '确认',
            icon: 'save',
            onClick: function () {
                that.SaveDetail();
            }
        });
        $('#colseDetail').FrameButton({
            text: '取消',
            icon: 'close',
            onClick: function () {
                $("#divContractDetail").data("kendoWindow").close();
            }
        });

        $(window).resize(function () {
            setLayout();
        });
        FrameWindow.HideLoading();
    }

    that.initDetailDiv = function (model, readonly) {
        $("#divContractDetail").kendoWindow({
            title: "Title",
            width: 450,
            height: 300,
            actions: [
                "Pin",
                "Minimize",
                "Maximize",
                "Close"
            ],
            modal: true,
        }).data("kendoWindow").title("合同属性").center().open();
        //编辑或新增页面
        $('#AddDealer').DmsDealerFilter({
            dataSource: [],
            delegateBusiness: business,
            dataKey: 'DealerId',
            dataValue: 'DealerName',
            selectType: 'select',
            filter: 'contains',
            serferFilter: true,
            value: readonly ? model.AddDealer : { Key: '', Value: '' },
            readonly: readonly
        });
        $('#AddContractNumber').FrameTextBox({
            value: model.AddContractNumber
        });
        $('#AddContractYears').FrameTextBox({
            value: model.AddContractYears
        });

        $("#AddStartDate").FrameDatePicker({
            value: model.AddStartDate,
            onChange: that.startChange,
            max: model.AddStopDate
        });

        $("#AddStopDate").FrameDatePicker({
            value: model.AddStopDate,
            onChange: that.endChange,
            min: model.AddStartDate
        });

        $('#AddDealerContractID').FrameTextBox({
            value: model.AddDealerContractID
        });
    }

    that.startChange = function (e) {
        var id_StopDate = dms.common.convertToFrameJsControl('AddStopDate');
        dms.common.startDateChange(e.sender, $("#" + id_StopDate).data("kendoDatePicker"));
    };
    that.endChange = function (e) {
        var id_StartDate = dms.common.convertToFrameJsControl('AddStartDate');
        dms.common.endDateChange($("#" + id_StartDate).data("kendoDatePicker"), e.sender);
    };
    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    var kendoDataSource = GetKendoDataSource(business, 'Query');
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    field: "DMA_ChineseName", title: "经销商", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" }
                },
                {
                    field: "ContractNumber", title: "合同编号", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "合同编号" }
                },
                {
                    field: "ContractYears", title: "合同有效期", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "合同有效期" }
                },
                {
                    field: "BuName", title: "产品线", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "SubBuName", title: "合同分类", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "合同分类" }
                },
                {
                    field: "StartDate", title: "开始日期", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "开始日期" },
                    //format: "{0:yyyy-MM-dd}"
                    template: "#= kendo.toString(kendo.parseDate(StartDate, 'yyyy-MM-dd'), 'yyyy-MM-dd') #"
                },
                {
                    field: "StopDate", title: "结束日期", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "结束日期" },
                    template: "#= kendo.toString(kendo.parseDate(StopDate, 'yyyy-MM-dd'), 'yyyy-MM-dd') #"
                },
                {
                    field: "CreateDate", title: "创建日期", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "创建日期" },
                    //template: "#= kendo.toString(kendo.parseDate(CreateDate, 'yyyy-MM-dd mm:HH:ss'), 'yyyy-MM-dd mm:HH:ss') #"
                },
                {
                    title: "明细", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit' title='明细'></i>&nbsp;&nbsp;<i class='fa fa-id-card' style='font-size: 14px; cursor: pointer;' name='authdetail' title='授权明细'></i>&nbsp;&nbsp;<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='deletedetail' title='删除'></i>",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            pageable: {
                refresh: true,
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
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    var Dealer = { Key: data.DmaId, Value: data.DMA_ChineseName };
                    var model = {};
                    model.AddDealer = Dealer;
                    model.AddDealerContractID = data.Id;
                    model.AddContractNumber = data.ContractNumber;
                    model.AddContractYears = data.ContractYears;
                    model.AddStartDate = data.StartDate;
                    model.AddStopDate = data.StopDate;
                    that.initDetailDiv(model, true);
                });
                $("#RstResultList").find("i[name='authdetail']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    that.openAuthDetailInfo(data.Id, data.DmaId);
                });
                $("#RstResultList").find("i[name='deletedetail']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    that.DeleteDetail(data.Id);
                });

            },
            page: function (e) {
                $('#CheckAll').removeAttr("checked");
            }
        });
    }

    that.SaveDetail = function () {
        var blSuccess = true;
        var message = [];
        var data = FrameUtil.GetModel();
        if (dms.common.isNullorEmpty(data.AddDealerContractID)) {
            data.AddDealerContractID = null;
        }
        if (data.AddDealer && data.AddDealer.Key == '') {
            blSuccess = false;
            message.push('请选择经销商!');
        }
        /*
        if (dms.common.isNullorEmpty(data.AddContractNumber)) {
            blSuccess = false;
            message.push('请填写合同编号!');
        }
        if (dms.common.isNullorEmpty(data.AddContractYears)) {
            blSuccess = false;
            message.push('请填写合同有效期!');
        }
        */
        if (dms.common.isNullorEmpty(data.AddStartDate)) {
            blSuccess = false;
            message.push('请选择开始日期!');
        }
        if (dms.common.isNullorEmpty(data.AddStopDate)) {
            blSuccess = false;
            message.push('请选择结束日期!');
        }
        if (!blSuccess) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: message,
                callback: function () {
                }
            });
            return;
        }


        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定保存此信息吗？',
            confirmCallback: function () {
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'SaveDetail',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess) {
                            $("#divContractDetail").data("kendoWindow").close();
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '保存成功',
                                callback: function () {
                                    that.Query();
                                }
                            });
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: model.ExecuteMessage,
                                callback: function () {
                                }
                            });
                        }
                        $(window).resize(function () {
                            setLayout();
                        });
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }

    that.DeleteDetail = function (Id) {
        var data = FrameUtil.GetModel();
        data.DeleteDealerContractID = Id;
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定删除此信息吗？',
            confirmCallback: function () {
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteDetail',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {

                        if (model.IsSuccess) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '删除成功',
                                callback: function () {
                                    that.Query();
                                }
                            });
                        } else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: model.ExecuteMessage,
                                callback: function () {
                                }
                            });
                        }
                        $(window).resize(function () {
                            setLayout();
                        })

                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }

    that.openAuthDetailInfo = function (DealerContractId, DmaId) {
        top.createTab({
            id: 'M_' + DealerContractId,
            title: '授权列表',
            url: 'Revolution/Pages/MasterDatas/DealerContractEditor.aspx?ct=' + DealerContractId + '&dr=' + DmaId
        });
    }
    var setLayout = function () {
    }

    return that;
}();
