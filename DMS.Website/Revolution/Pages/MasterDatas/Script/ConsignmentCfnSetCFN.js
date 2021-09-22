var ConsignmentCfnSetCFN = {};

ConsignmentCfnSetCFN = function () {
    var that = {};
    var InstanceId = Common.GetUrlParam('InstanceId');
    var business = 'MasterDatas.ConsignmentCfnSetCFN';
    var pickedList = [];
    var GetModel = function () {
        var model = FrameUtil.GetModel();
        model.InstanceId = Common.GetUrlParam('InstanceId');
        model.QryBU = { Key: Common.GetUrlParam('IptBuKey'), Value: Common.GetUrlParam('IptBuValue') };
        return model;
    }

    that.Init = function () {
        var data = FrameUtil.GetModel();
        data.InstanceId = Common.GetUrlParam('InstanceId');
        data.QryBU = { Key: Common.GetUrlParam('IptBuKey'), Value: Common.GetUrlParam('IptBuValue') };
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'ProductLineID',
                    dataValue: 'ProductLineName',
                    selectType: 'all',
                    value: model.QryBu,
                    readonly: true
                });
                $('#QryCFN').FrameTextBox({
                    value: model.QryCFN
                });
                $('#QryIsInclude').FrameDropdownList({
                    dataSource: [{ Key: '', Value: '请选择' }, { Key: '1', Value: '是' }, { Key: '0', Value: '否' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: { Key: '', Value: '请选择' }
                });
                $('#BtnConfirm').FrameButton({
                    text: '确定',
                    icon: 'file',
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
                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'close',
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
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }


    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 15, GetModel);
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
                    field: "CustomerFaceNbr", title: "产品型号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                },
                {
                    field: "EnglishName", title: "英文说明", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "英文说明" }
                },
                {
                    field: "ChineseName", title: "中文说明", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "中文说明" }

                },
                {
                    field: "PCTName", title: "产品分类", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类" }

                },
                {
                    field: "PCTEnglishName", title: "产品分类英文名称", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类英文名称" }
                    //},
                    //{
                    //    field: "ProductLineName", title: "产品线", width: '100px',
                    //    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                    //},
                    //{
                    //    field: "Implant", title: "植入", width: '100px',
                    //    headerAttributes: { "class": "text-center text-bold", "title": "植入" },
                    //template: "#if (Implant == '1') {#是#}else{#否#}# "
                    //},
                    //{
                    //    field: "Tool", title: "工具", width: '100px',
                    //    headerAttributes: { "class": "text-center text-bold", "title": "工具" }
                    //},
                    //{
                    //    field: "Share", title: "共享", width: '100px',
                    //    headerAttributes: { "class": "text-center text-bold", "title": "共享" }
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
            var temp = {};
            temp.CustomerFaceNbr = data.CustomerFaceNbr;
            temp.ChineseName = data.ChineseName;
            temp.EnglishName = data.EnglishName;
            temp.DefaultQuantity = 0;
            temp.CfnsId = InstanceId;
            temp.CfnId = data.Id
            pickedList.push(temp);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].CfnId == data.Id) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].Id == data.Id) {
                exists = true;
            }
        }
        return exists;
    }
    that.WarehouseChange = function () {

        createResultList([]);
    }



    var setLayout = function () {
    }

    return that;
}();
