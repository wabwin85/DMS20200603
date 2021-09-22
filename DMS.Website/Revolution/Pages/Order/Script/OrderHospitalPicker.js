﻿var OrderHospitalPicker = {};

OrderHospitalPicker = function () {
    var that = {};

    var business = 'Order.OrderHospitalPicker';
    var pickedList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        $('#QrySelectedProductLine').val(Common.GetUrlParam('ProductLine'));
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                //$('#QryQueryType').FrameRadio({
                //    dataSource: [{ Key: 'upn', Value: 'UPN' }, { Key: 'set', Value: '组套' }],
                //    dataKey: 'Key',
                //    dataValue: 'Value',
                //    value: { Key: 'upn', Value: 'UPN' }
                //});
                $('#QryProvince').FrameDropdownList({
                    dataSource: model.RstResultProvincesList,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'none',
                    filter: "contains",
                    value: model.QryProvince,
                    onChange: function (s) {
                        that.ChangeProvince(s.target.value);
                    },

                });
                $('#QryCity').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    filter: "contains",
                    readonly: model.IsDealer ? true : false,
                    value: model.QryCity,
                    onChange: function (s) {
                        that.ChangeProvince();
                    },
                });
                $('#QryDistrict').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    filter: "contains",
                    readonly: model.IsDealer ? true : false,
                    value: model.QryDistrict
                });

                $('#QryHospitalName').FrameTextBox({
                    value: model.QryHospitalName,
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
                                message: '请选择医院'
                            });
                        }
                        else if (pickedList.length > 1) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'warning',
                                message: '医院选择必须唯一'
                            });
                        }
                        else {
                            FrameWindow.SetWindowReturnValue({
                                target: 'top',
                                value: pickedList
                            });

                            FrameWindow.CloseWindow({
                                target: 'top'
                            });
                        }
                    }
                });
                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'search',
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

    //查询
    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }
    function GetFnParams() {
        var data = FrameUtil.GetModel();
        data.QryProvince = data.QryProvince.Value;//采用文本，不用Id
        data.QryCity = data.QryCity.Value;
        data.QryDistrict = data.QryDistrict.Value;
        return data;
    };
    var fields = {};
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 8, GetFnParams);
    that.CreateResultList = function (dataSource) {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                 {
                     title: "全选", width: '50px', encoded: false,
                     headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                     template: '<input type="checkbox" id="Check_#=HOS_ID#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=HOS_ID#"></label>',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "HOS_HospitalName", title: "医院名称", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品短编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_Key_Account", title: "医院代码", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院代码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_Address", title: "地址", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_Province", title: "省", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "省" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_City", title: "市", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "市" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HOS_District", title: "区/县", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "区/县" },
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

    //选择省份联动地区
    that.ChangeProvince = function (ParentId) {
        var data = {};
        data.parentId = ParentId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'BindCity',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                $('#QryCity').FrameDropdownList({
                    dataSource: model.RstResultCityList,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'none',
                    filter: "contains",
                    value: '',
                    onChange: function (s) {
                        that.ChangeCity(s.target.value);
                    }
                });
                $('#QryDistrict').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    filter: "contains",
                    readonly: model.IsDealer ? true : false,
                    value: model.QryDistrict
                });


                FrameWindow.HideLoading();
            }
        });
    };

    //选择地区联动区县
    that.ChangeCity = function (ParentId) {
        var data = {};
        data.parentId = ParentId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'BindArea',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                $('#QryDistrict').FrameDropdownList({
                    dataSource: model.RstResultAreaList,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'none',
                    filter: "contains",
                    value: ''
                });

                FrameWindow.HideLoading();
            }
        });
    };


    var addItem = function (data) {
        if (!isExists(data)) {
            var temp = {
                Key: "",
                HospitalName: "",
                HospitalAddress: ""
            };
            temp.Key = data.HOS_ID;
            temp.HospitalName = data.HOS_HospitalName;
            temp.HospitalAddress = data.HOS_Address;
            pickedList.push(temp);
        }     
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].Key == data.HOS_ID) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].Key == data.HOS_ID) {
                exists = true;
            }
        }
        return exists;
    }

    var setLayout = function () {
    }

    return that;
}();
