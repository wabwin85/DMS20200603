var DealerAccountPicker = {};

DealerAccountPicker = function () {
    var that = {};

    var business = 'HCPPassport.DealerAccountPicker';
    var pickedList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {


        var data = {};
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                //$('#QryBu').FrameDropdownList({
                //    dataSource: model.LstBu,
                //    dataKey: 'ProductLineID',
                //    dataValue: 'ProductLineName',
                //    selectType: 'all',
                //    value: model.QryBu
                //});

                //$('#QryFilter').FrameTextBox({
                //});

                that.CreateResultList(model.RstResultList);

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
                    icon: 'search',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });
                //$('#BtnQuery').FrameButton({
                //    text: '查询',
                //    icon: 'search',
                //    onClick: function () {
                //        that.Query();
                //    }
                //});

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.Save = function () {
        var data = that.GetModel();

        var message = that.CheckForm(data);
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {

            Roles = [];

            data.InstanceId = Common.GetUrlParam('InstanceId');
            data.Roles = pickedList;

            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Save',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    //if (model.IsSuccess) {
                    //    FrameWindow.ShowAlert({
                    //        target: 'top',
                    //        alertType: 'info',
                    //        message: '保存成功',
                    //        callback: function () {

                    //            //top.deleteTabsCurrent();

                    //        }
                    //    });
                    //}
                    FrameWindow.CloseWindow({
                        target: 'top'
                    });

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.CheckForm = function (data) {
        var message = [];
        if (pickedList.length == 0) {
            message.push('请选择有效数据');
        }



        return message;
    }

    that.Query = function () {
        var data = FrameUtil.GetModel();
        data.InstanceId = Common.GetUrlParam('InstanceId');

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Query',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });

                FrameWindow.HideLoading();
            }
        });
    }

    //UPN
    that.CreateResultList = function (dataSource) {

        $("#RstResultList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                 {
                     title: "全选", width: '30px', encoded: false,
                     headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                     template: '<input type="checkbox" id="Check_#=Key#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Key#"></label>',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "Value", title: "角色", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "角色" }
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
            pickedList.push({
                Key: data.Key,
                Value: data.Value,
              
            });
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].Key == data.Key) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].Key == data.Key) {
                exists = true;
            }
        }
        return exists;
    }



    var setLayout = function () {
    }

    return that;
}();
