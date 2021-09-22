var ConsignmentMasterUpnPicker = {};

ConsignmentMasterUpnPicker = function () {
    var that = {};

    var business = 'MasterDatas.ConsignmentMasterUpnPicker';
    var pickedList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        $('#QryProductLine').val(Common.GetUrlParam('Bu'));
        $('#QryInstanceId').val(Common.GetUrlParam('InstanceId'));

        $('#QryCFNCode').FrameTextBox({
            value: ''
        });
        $('#QryCFNName').FrameTextBox({
            value: ''
        });
        //$('#DisplayCanOrder').FrameCheckbox({
        //    value: ''
        //});
        $('#DisplayCanOrder').FrameSwitch({
            onLabel: "是",
            offLabel: "否",
            value: "是",
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
        return data;
    };
    var fields = {};
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 10, GetFnParams);
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
                     template: "#if(data.IsCanOrder=='是'){#" +
                                             '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>' +
                                             '#}#',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "CustomerFaceNbr", title: "产品型号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EnglishName", title: "产品英文名", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "产品中文名", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Price", title: "产品单价", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品单价" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UOM", title: "包装", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "包装" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Sheet", title: "单位数量", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单位数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Avaiable", title: "可订数量", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "可订数量" },
                    attributes: { "class": "table-td-cell" }
                },

                {
                    title: "是否可下单", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    editable: false,
                    template: "#if (IsCanOrder=='是'){#" +
                                   '是' +
                                "#}else{#" +
                                    '否' +
                                "#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "ProductMsg", title: "产品详细信息", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品详细信息" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CurGMKind", title: "产品类别", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品类别" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CurGMCatalog", title: "产品分类代码", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类代码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CurRegNo", title: "注册证编号-1", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-1" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CurManuName", title: "生产企业(注册证-1)", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业(注册证-1)" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LastRegNo", title: "注册证编号-2", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-2" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LastManuName", title: "生产企业(注册证-2)", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业(注册证-2)" },
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


    var addItem = function (data) {
        if (!isExists(data)) {
            pickedList.push(data.Id + '@' + data.Price + '@' + data.UOM);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id + '@' + data.Price + '@' + data.UOM) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id + '@' + data.Price + '@' + data.UOM) {
                exists = true;
            }
        }
        return exists;
    }



    var setLayout = function () {
    }

    return that;
}();

