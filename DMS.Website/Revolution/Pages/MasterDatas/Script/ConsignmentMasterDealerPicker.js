var ConsignmentMasterDealerPicker = {};

ConsignmentMasterDealerPicker = function () {
    var that = {};

    var business = 'MasterDatas.ConsignmentMasterDealerPicker';
    var pickedList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {

        $('#QryBu').val(Common.GetUrlParam('Bu'));
        $('#QryInstanceId').val(Common.GetUrlParam('InstanceId'));
        var data = {};
        data.QryBu = Common.GetUrlParam('Bu');
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#DivisionCode").val(model.DivisionCode);
                $('#QryDealerName').FrameTextBox({
                    value: '',
                });
                $('#FilterDealer').FrameDropdownList({
                    dataSource: model.RstDealerType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.FilterDealer
                });
                $('#QrySAPCode').FrameTextBox({
                });

                $('#QryBuName').FrameTextBox({
                    value: model.QryBuName,
                    readonly: true
                });

                that.CreateResultList();

                $('#BtnOk').FrameButton({
                    text: '确定',
                    icon: 'file',
                    onClick: function () {
                        if (pickedList.length == 0) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'warning',
                                message: '确认要添加选中的经销商',


                            });
                        } else {
                            FrameWindow.ShowConfirm({
                                target: 'top',
                                message: '确认要添加选中的经销商吗？',
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
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
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

    //that.Query = function () {
    //    var data = FrameUtil.GetModel();

    //    FrameWindow.ShowLoading();
    //    FrameUtil.SubmitAjax({
    //        business: business,
    //        method: 'Query',
    //        url: Common.AppHandler,
    //        data: data,
    //        callback: function (model) {
    //            $("#RstResultList").data("kendoGrid").setOptions({
    //                dataSource: model.RstResultList
    //            });
    //            $("#RstResultList").css("display", "block")

    //            FrameWindow.HideLoading();
    //        }
    //    });
    //}

    //查询
    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }
    //function GetFnParams() {
    //    var data = {};
    //    data.QryProductLine = $('#QryBu').val();
    //    return data;
    //};
    var fields = {};
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 10);
    //经销商
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
                    field: "ChineseName", title: "中文名", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "中文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SapCode", title: "ERP账号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "ERP账号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DealerType", title: "经销商类别", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商类别" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Address", title: "地址", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "地址" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PostalCode", title: "邮编", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "邮编" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Phone", title: "电话", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "电话" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Fax", title: "传真", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "传真" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "有效", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    editable: false,
                    template: "#if (ActiveFlag){#" +
                                   '<input type="checkbox" name="personAdmin" id="personAdmin" disabled checked/>' +
                                "#}else{#" +
                                    '<input type="checkbox" name="personAdmin" id="personAdmin" disabled/>' +
                                "#}#",
                    attributes: {
                        "class": "text-center text-bold table-td-cell"
                    }
                },

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
                $('#CheckAll').removeAttr("checked");
            }
        });
    }


    var addItem = function (data) {
        if (!isExists(data)) {
            pickedList.push(data.Id);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id) {
                exists = true;
            }
        }
        return exists;
    }



    var setLayout = function () {
    }

    return that;
}();
