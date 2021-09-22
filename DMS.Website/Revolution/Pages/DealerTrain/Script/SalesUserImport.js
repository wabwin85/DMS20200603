var SalesUserImport = {};

SalesUserImport = function () {
    var that = {};

    var business = 'DealerTrain.SalesUserImport';
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
                $('#QryDealer').FrameTextBox({

                    value: model.QryDealer
                });
                $('#QrySale').FrameTextBox({

                    value: model.QrySale
                });

                $('#BtnOk').FrameButton({
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
                     template: '<input type="checkbox" id="Check_#=WeChatUserId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=WeChatUserId#"></label>',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "DealerName", title: "经销商", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                },
                {
                    field: "SalesName", title: "姓名", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "姓名" }
                },
                {
                    field: "SalesSex", title: "性别", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "性别" },
                    template: "#if (SalesSex == '1') {#男#}else{#女#}# "
                },
                {
                    field: "SalesPhone", title: "联系电话", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "联系电话" }
                    
                },
                {
                    field: "SalesEmail", title: "邮箱", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "邮箱" }
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
            pickedList.push(data.WeChatUserId);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].WeChatUserId == data.WeChatUserId) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].WeChatUserId == data.WeChatUserId) {
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
