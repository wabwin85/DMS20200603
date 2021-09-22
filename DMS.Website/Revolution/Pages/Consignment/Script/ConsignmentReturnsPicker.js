var ConsignmentReturnsPicker = {};

ConsignmentReturnsPicker = function () {
    var that = {};

    var business = 'Consignment.ConsignmentReturnsPicker';
    var pickedList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {

        $('#hidProductLine').val(Common.GetUrlParam('Bu'));
        $('#hidDealerId').val(Common.GetUrlParam('Dealer'));
        $("#InstanceId").val(Common.GetUrlParam('HeaderId'));
        $("#hidCmId").val(Common.GetUrlParam('QryRuleId'));//寄售合同
        $("#hidIahDmaId").val(Common.GetUrlParam('SuorceProId'));//来源经销商

        that.CreateResultList();

        FrameWindow.ShowLoading();
        that.CreateRstResultDetailList();

        $('#BtnAdd').FrameButton({
            text: '添加',
            icon: 'plus',
            onClick: function () {
                if (pickedList.length == 0) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: '确认要添加选中的产品',


                    });
                } else {
                    FrameWindow.ShowConfirm({
                        target: 'top',
                        message: '确认要添加选中的产品吗？',
                        confirmCallback: function () {
                            FrameWindow.SetWindowReturnValue({
                                target: 'top',
                                value: pickedList
                            });

                            FrameWindow.CloseWindow({
                                target: 'top'
                            });
                        }
                    });

                }
            }
        });
        $('#BtnClose').FrameButton({
            text: '关闭',
            icon: 'remove',
            onClick: function () {
                FrameWindow.CloseWindow({
                    target: 'top'
                });
            }
        });

        FrameWindow.HideLoading();
    }

    //详情
    that.CreateRstResultDetailList = function (dataSource) {

        $("#RstResultDetailList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    field: "CustomerFaceNbr", title: "产品型号", width: '180px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "中文名", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "中文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EnglishName", title: "英文名", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "英文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Property1", title: "短编码", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "短编码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotNumber", title: "批次号", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "批次号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Quantity", title: "数量", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                    attributes: { "class": "table-td-cell" }
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
        });
    }


    function GetFnParams() {
        var data = {};
        data.QryProductLine = $('#QryBu').val();
        return data;
    };
    var fields = {
        CFN_Property3: { type: "number", decimals: 0, validation: { required: false, min: 1, format: "{0:N0}" } }
    };
    var kendoDataSource = GetKendoDataSource(business, 'Init', fields, 10, GetFnParams);
    //UPN
    that.CreateResultList = function () {

        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                 {
                     title: "全选", width: '50px', encoded: false,
                     headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                     template: '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "IahDmaId", title: "经销商", width: '180px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AdjNbr", title: "单据号", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "单据号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CreatedDate", title: "创建时间", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "创建时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ApprovalDate", title: "批准日期", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "批准日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "明细", width: "50px", editable: true,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }

            ],
            editable: true,
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
                //明细点击
                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    that.openSelectInfo(data.Id);
                });
            },
            page: function (e) {
                $('#CheckAll').removeAttr("checked");
            }
        });
    }

    //明细查询
    that.openSelectInfo = function (CfnSetId) {
        var data = {};
        data.CfnSetId = CfnSetId;
        data.Page = 1;
        data.PageSize = 10;
        data.DataCount = 0;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Query',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstResultDetailList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultDetailList
                });

                FrameWindow.HideLoading();
            }
        });
    };

    //组套


    var addItem = function (data) {
        if (data.CFN_Property3 == "" || data.CFN_Property3 == undefined) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '确认选中产品的订购数量大于0',
            });
            return;
        }
        if (!isExists(data)) {
            pickedList.push(data.Id + "|" + data.CFN_Property3);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id + "|" + data.CFN_Property3) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id + "|" + data.CFN_Property3) {
                exists = true;
            }
        }

        return exists;
    }



    var setLayout = function () {
    }

    return that;
}();
