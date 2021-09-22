var WHSearchHospital = {};

WHSearchHospital = function () {
    var that = {};

    var business = "Inventory.WHSearchHospital";
    var pickedList = { HosList: [] };

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
                $('#QryHPLevel').FrameDropdownList({
                    dataSource: model.LstHPLevel,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryHPLevel
                });
                $('#QryHPProvince').FrameDropdownList({
                    dataSource: model.LstHPProvince,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.QryHPProvince,
                    onChange: that.ProvinceChange
                });
                $('#QryHPRegion').FrameDropdownList({
                    dataSource: model.LstHPRegion,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.QryHPRegion,
                    onChange: that.RegionChange
                });
                $('#QryHPTown').FrameDropdownList({
                    dataSource: model.LstHPTown,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.QryHPTown
                });
                $('#QryHPName').FrameTextBox({
                    value: model.QryHPName
                });

               
                $('#BtnSave').FrameButton({
                    text: '确定',
                    icon: 'floppy-o',
                    onClick: function () {
                        FrameWindow.SetWindowReturnValue({
                            target: 'top',
                            value: pickedList
                        });

                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });
                
                $('#BtnCancel').FrameButton({
                    text: '取消',
                    icon: 'times-circle',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });
                $('#BtnQuery').FrameButton({
                    text: '查找',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                //$("#RstResultList").data("kendoGrid").setOptions({
                //    dataSource: model.RstResultList
                //});

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.ProvinceChange = function () {

        var data = that.GetModel();
        if (data.QryHPProvince.Key == "") {
            $('#QryHPRegion').FrameDropdownList({
                dataSource: [],
                dataKey: 'TerId',
                dataValue: 'Description',
                selectType: 'select',
                onChange: that.RegionChange
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'ProvinceChange',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#QryHPRegion').FrameDropdownList({
                        dataSource: model.LstHPRegion,
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select',
                        onChange: that.RegionChange
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
        $('#QryHPTown').FrameDropdownList({
            dataSource: [],
            dataKey: 'TerId',
            dataValue: 'Description',
            selectType: 'select'
        });
    }

    that.RegionChange = function () {

        var data = that.GetModel();
        if (data.QryHPRegion.Key == "") {
            $('#QryHPTown').FrameDropdownList({
                dataSource: [],
                dataKey: 'TerId',
                dataValue: 'Description',
                selectType: 'select'
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'RegionChange',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#QryHPTown').FrameDropdownList({
                        dataSource: model.LstHPTown,
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select'
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 10);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 350,
            columns: [
                {
                    title: "选择", width: 50, encoded: false,
                    //headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=HosId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=HosId#"></label>',
                    headerAttributes: { "class": "center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "center" }
                },
                {
                    field: "HosHospitalName", title: "医院名称", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" }
                },
                {
                    field: "HosKeyAccount", title: "级别", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "级别" }
                },
                {
                    field: "HosGrade", title: "等级", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "等级" }
                },
                {
                    field: "HosProvince", title: "省份", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "省份" }
                },
                {
                    field: "HosCity", title: "地区", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "地区" }
                },
                {
                    field: "HosDistrict", title: "区/县", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "区/县" }
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

            }
        });
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            pickedList.HosList.splice(0, pickedList.HosList.length);
            pickedList.HosList.push(data);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.HosList.length; i++) {
            if (pickedList.HosList[i] == data) {
                pickedList.HosList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.HosList.length; i++) {
            if (pickedList.HosList[i] == data) {
                exists = true;
            }
        }
        return exists;
    }

    var setLayout = function () {
    }

    return that;
}();