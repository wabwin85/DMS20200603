var HospitalList = {};

HospitalList = function () {
    var that = {};

    var business = 'MasterDatas.HospitalList';
    var deleteHosp = [];

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
                $('#QryHPLName').FrameTextBox({
                    value: model.QryHPLName
                });
                $('#QryHPLDean').FrameTextBox({
                    value: model.QryHPLDean
                });
                $('#QryHPLGrade').FrameDropdownList({
                    dataSource: model.LstHPLGrade,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryHPLGrade
                });
                $('#QryHPLProvince').FrameDropdownList({
                    dataSource: model.LstHPLProvince,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.QryHPLProvince,
                    onChange: that.ProvinceChange
                });
                $('#QryHPLRegion').FrameDropdownList({
                    dataSource: model.LstHPLRegion,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.QryHPLRegion,
                    onChange: that.RegionChange
                });
                $('#QryHPLTown').FrameDropdownList({
                    dataSource: model.LstHPLTown,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.QryHPLTown
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
                        that.HospitalEdit('', '医院详细信息');
                    }
                });
                

                //$('#BtnSave').FrameButton({
                //    text: '保存',
                //    icon: 'save',
                //    onClick: function () {
                //        that.SaveChange();
                //    }
                //});
                

                $('#BtnDelete').FrameButton({
                    text: '删除',
                    icon: 'trash-o',
                    onClick: function () {
                        that.Delete();
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
        if (data.QryHPLProvince.Key == "") {
            $('#QryHPLRegion').FrameDropdownList({
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
                    $('#QryHPLRegion').FrameDropdownList({
                        dataSource: model.LstHPLRegion,
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select',
                        onChange: that.RegionChange
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
        $('#QryHPLTown').FrameDropdownList({
            dataSource: [],
            dataKey: 'TerId',
            dataValue: 'Description',
            selectType: 'select'
        });
    }

    that.RegionChange = function () {

        var data = that.GetModel();
        if (data.QryHPLRegion.Key == "") {
            $('#QryHPLTown').FrameDropdownList({
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
                    $('#QryHPLTown').FrameDropdownList({
                        dataSource: model.LstHPLTown,
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
        clearDeleteHosp();
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    var fields = { HosLastModifiedDate: { type: "date", format: "{0: yyyy-MM-dd HH:mm:ss}" } }
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 20);
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
                    template: '<input type="checkbox" id="Check_#=HosId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=HosId#"></label>',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "HosHospitalName", title: "医院名称", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" }
                },
                {
                    field: "HosKeyAccount", title: "医院编号", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院编号" }
                },
                {
                    field: "HosKeyBSAccount", title: "波科医院编号", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "波科医院编号" }
                },
                {
                    field: "HosGrade", title: "等级", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "等级" }
                },
                {
                    field: "HosProvince", title: "省份", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "省份" }
                },
                {
                    field: "HosCity", title: "地区", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "地区" }
                },
                {
                    field: "HosDistrict", title: "区/县", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "区/县" },
                    template: "#if (data.HosDistrict) {#<span>#=data.HosDistrict#</span>#} else { if (data.HosTown) {#<span>#=data.HosTown#</span>#}}#"
                },
                {
                    field: "HosDirector", title: "院长", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "院长" }
                },
                {
                    field: "HosDirectorContact", title: "院长联系方式", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "院长联系方式" }
                },
                {
                    field: "HosLastModifiedDate", title: "修改日期", width: 150, format: "{0:yyyy-MM-dd HH:mm:ss}",
                    headerAttributes: { "class": "text-center text-bold", "title": "修改日期" }
                },
                {
                    field: "LastUpdateUserName", title: "修改人", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "修改人" }
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

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    that.HospitalEdit(data.HosId, '医院详细信息');
                });

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
                clearDeleteHosp();
            }
        });
    }

    that.Delete = function () {
        if (deleteHosp.length > 0) {
            if (confirm('确认删除医院信息？'))
            {
                var data = {};
                data.LstHosID = deleteHosp;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteData',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess != true) {
                            //kendo.alert(model.ExecuteMessage);
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: model.ExecuteMessage,
                                callback: function () {
                                }
                            });
                        }
                        else {
                            //kendo.alert("删除成功！");
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: '删除成功！',
                                callback: function () {
                                }
                            });
                            that.Query();
                        }
                        FrameWindow.HideLoading();
                    }
                });
            }
        }
        else {
            //kendo.alert('请选择需要删除的数据！');
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择需要删除的数据！',
                callback: function () {
                }
            });
        }
    }

    var clearDeleteHosp = function () {
        $('#CheckAll').removeAttr("checked");
        deleteHosp.splice(0, deleteHosp.length);
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            deleteHosp.push(data.HosId);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < deleteHosp.length; i++) {
            if (deleteHosp[i] == data.HosId) {
                deleteHosp.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < deleteHosp.length; i++) {
            if (deleteHosp[i] == data.HosId) {
                exists = true;
            }
        }
        return exists;
    }

    that.HospitalEdit = function (Id, Name) {
        var url = 'Revolution/Pages/MasterDatas/HospitalEditor.aspx?';
        url += 'Id=' + escape(Id);
        FrameWindow.OpenWindow({
            target: 'top',
            title: Name,
            url: Common.AppVirtualPath + url,
            width: $(window).width() * 0.6,
            height: $(window).height() * 0.7,
            actions: ["Close"],
            callback: function (result) {
                if (result == "success") {
                    that.Query();
                }
            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();