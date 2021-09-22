var ConsignmentCfnSetList = {};

ConsignmentCfnSetList = function () {
    var that = {};

    var business = 'MasterDatas.ConsignmentCfnSetList';
    var pickedList = [];
    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = FrameUtil.GetModel();
        createResultList();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryBu').FrameDropdownList({
                    dataSource: model.ListBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });
                $('#QryCFN').FrameTextBox({

                    value: model.QryCFN
                });
                $('#QryCFNSetName').FrameTextBox({

                    value: model.QryCFNSetName
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
                    icon: 'plus',
                    onClick: function () {
                        that.openInfo();
                    }
                });
                $('#BtnDelete').FrameButton({
                    text: '删除',
                    icon: 'trash',
                    onClick: function () {
                        that.Delete();
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


    var kendoDataSource = GetKendoDataSource(business, 'Query');
    var createResultList = function () {
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
                     field: "SubCompanyName", title: "分子公司", width: '80px',
                     headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                 },
                 {
                     field: "BrandName", title: "品牌", width: '80px',
                     headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                 },
                 {
                     field: "ProductLineName", title: "产品线", width: '120px',
                     headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                 },
                 //{
                 //    field: "UPN", title: "成套产品UPN", width: '150px',
                 //    headerAttributes: { "class": "text-center text-bold", "title": "成套产品UPN" }
                 //},
                {
                    field: "ChineseName", title: "成套产品中文名称", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "成套产品中文名称" },
                },

                {
                    field: "EnglishName", title: "成套产品英文名称", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "成套产品英文名称" }
                },
                {
                    title: "明细", width: "80px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>&nbsp;&nbsp;<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='delete'></i>",
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

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    that.openInfo(data.Id)

                });
                $("#RstResultList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    that.Delete(data.Id);
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
    that.Delete = function (Id) {
        var deleteId = [];
        if (Id) {
            deleteId.push(Id)
        }
        else {
            for (var i = 0; i < pickedList.length; i++) {
                deleteId.push(pickedList[i])
            }
        }
        if (0 == deleteId.length) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: "请选择需要删除的组套产品！",
            });
            return;
        }
        else {
            var data = FrameUtil.GetModel();
            data.DeleteSeleteID = deleteId;
            FrameWindow.ShowConfirm({
                target: 'top',
                message: '确定要执行删除操作?',
                confirmCallback: function () {
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'Delete',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            if (!model.IsSuccess) {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'info',
                                    message: model.ExecuteMessage,
                                    callback: function () {
                                    }
                                });
                            }
                            else {
                                pickedList = [];
                                that.Query();
                            }
                            FrameWindow.HideLoading();
                        }
                    });
                }
            });
        }
    }


    that.openInfo = function (InstanceId) {
        var param = '';
        var IsNew = true;
        if (InstanceId) {
            param = InstanceId;
            IsNew = false;
        }
        top.createTab({
            id: 'M_' + InstanceId,
            title: '明细信息',
            url: 'Revolution/Pages/MasterDatas/ConsignmentCfnSetInfo.aspx?IsNew=' + IsNew + '&&InstanceId=' + param + '&&Bu=' + $('#QryBu').FrameDropdownList('getValue').Key,
            refresh: true
        });
    }
    var setLayout = function () {
    }

    return that;
}();
