var InvHospitalCfg = {};

InvHospitalCfg = function () {
    var that = {};
    var business = 'MasterDatas.InvHospitalCfg';
    var pickList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    };

    that.Init = function () {
        var data = {};
        createResultList();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#Province').FrameDropdownList({
                    dataSource: model.LstProvinces,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.Province,
                    onChange: function () { }
                });
                $('#City').FrameDropdownList({
                    dataSource: model.LstCities,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.City,
                });
                $('#District').FrameDropdownList({
                    dataSource: model.LstDistricts,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.District,
                });

                $('#HospitalName').FrameTextBox({
                    value: model.HospitalName
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnDelete').FrameButton({
                    text: '删除',
                    icon: 'trash-o',
                    onClick: function () {
                        that.Delete();
                    }
                });
                $('#BtnImport').FrameButton({
                    text: '导入',
                    icon: 'file-code-o',
                    onClick: function () {
                        that.openInfo();
                    }
                });
                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportDetail();
                    }
                });
                FrameWindow.HideLoading();
            }
        });
    };

    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    };

    that.Delete = function (id) {
        var deleteIds;
        if (id == undefined) {
            if (pickList.length > 0) {
                var ids = pickList.map(function (i) {
                    return '\'' + pickList[i] + '\'';
                }).join(',');
                deleteIds = ids;
            }
            else {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '请选择要删除的发票医院映射维护信息'
                });
                return;
            }
        }
        else {
            deleteIds = id;
        }
        var data = FrameUtil.GetModel();
        data.DeleteSeleteID = deleteIds;
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定要执行删除操作？',
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
                                message: "删除失败",
                                callback: function () {
                                }
                            });
                        }
                        else {
                            pickedList = [];
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '删除成功',
                                callback: function () {
                                    //top.deleteTabsCurrent();
                                    that.Query();
                                }
                            });
                        }
                        FrameWindow.HideLoading();
                    }

                });
            }
        });
    };

    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 20);
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
                    template: '<input type="checkbox" id="Check_#=InvHosId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=InvHosId#"></label>',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "DMSHospitalName", title: "DMS医院名称", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "DMS医院名称" }
                },
                {
                    field: "InvHospitalName", title: "发票医院名称", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "发票医院名称" }
                },
                {
                    field: "Hos_Code", title: "医院编号", width: 60,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院编号" }
                },
                {
                    field: "HOS_SFECode", title: "医院编号", width: 60,
                    headerAttributes: { "class": "text-center text-bold", "title": "SFE医院编号" }
                },
                {
                    field: "Hos_Provice", title: "省份", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "省份" }
                },
                {
                    field: "HOS_City", title: "地区", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "地区" }
                },
                {
                    field: "HOS_District", title: "区/县", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "区/县" }
                },
                {
                    field: "UpdateTime", title: "更新时间", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "更新时间" }
                },
                {
                    field: "UpdateBy", title: "操作员", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "操作员" }
                },
                {
                     title: "删除", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "删除" },
                    template: "<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='delete'></i>",
                    attributes: { "class": "text-center text-bold" }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 20,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;
                $("#RstResultList").find(".Check-Item").unbind('click');
                $("#RstResultList").find(".Check-Item").on('click', function () {
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

                $("#RstResultList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    that.Delete(data.InvHosId);
                });
            },
            page: function (e) {
                $('#CheckAll').removeAttr("checked");
            }
        });
    };

    var addItem = function (data) {
        if (!isExists(data)) {
            pickedList.push(data.InvHosId);
        }
    }

    var isExists = function (data) {
        for (var i = 0; i < pickedlist.length; i++) {
            if (pickList[i] == data.InvHosId)
                return true;
        }
        return false;
    };

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.InvHosId) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    return that;
}();