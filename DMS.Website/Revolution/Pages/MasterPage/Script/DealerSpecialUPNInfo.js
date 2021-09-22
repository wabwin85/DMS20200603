var DealerSpecialUPNInfo = {};

DealerSpecialUPNInfo = function () {
    var that = {};

    var business = 'MasterPage.DealerSpecialUPNInfo';
    var CustomerFaceNbr = [];
    var g = 0;
    var pickedList = [];
    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.RstDetailList = $("#RstDetailList").data("kendoGrid").dataSource.data();
        return model;
    }

    that.Init = function () {
        var data = {};

        data.InstanceId = Common.GetUrlParam('InstanceId');
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                
                createRstOutFlowList(model.RstResultList)

                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });

                $('#QryFilter').FrameTextBox({
                });
                $('#BtnDelete').FrameButton({
                    text: '删除',
                    icon: 'save',
                    onClick: function () {
                        that.Delete();
                    }
                });
                $('#BtnAddUpn').FrameButton({
                    text: '添加产品',
                    icon: 'search',
                    onClick: function () {
                        that.AddUpn();
                    }
                });
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        top.deleteTabsCurrent();
                    }
                });
                $("#RstDetailList").data("kendoGrid").setOptions({
                    dataSource: model.RstDetailList
                });

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();


                FrameWindow.HideLoading();
            }
        });
    }
    var createRstOutFlowList = function (dataSource) {
        $("#RstDetailList").kendoGrid({
            dataSource: {
                data: dataSource,
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
             {
                    title: "全选", width: '20px', encoded: false,
                    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=CFN_Property1#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=CFN_Property1#"></label>',
                    headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                    attributes: { "class": "center" }
             },
            {
                field: "CFN_Property1", title: "产品短编号", width: '150px',
                headerAttributes: { "class": "text-center text-bold", "title": "产品短编号" }
            },
            {
                field: "CFN_ChineseName", title: "产品中文名", width: '200px',
                headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" }
            },
            {
                field: "CFN_EnglishName", title: "产品英文名", width: '200px',
                headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" }
            },
            {
                field: "PMA_ConvertFactor", title: "规格", width: '60px',
                headerAttributes: { "class": "text-center text-bold", "title": "规格" }
            },
            {
                field: "CFN_Property3", title: "单位", width: '60px',
                headerAttributes: { "class": "text-center text-bold", "title": "单位" },

            },
            //{
            //    field: "DS_CreateUser", title: "创建人", width: '100px',
            //    headerAttributes: { "class": "text-center text-bold", "title": "创建人" }
            //},
            //{
            //    field: "DS_CreateDate", title: "创建时间", width: '100px',
            //    headerAttributes: { "class": "text-center text-bold", "title": "创建时间" }
            //},
             {
                 field: "Delete", title: "删除", width: '50px',
                 headerAttributes: { "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;" },
                 template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                 attributes: { "class": "text-center text-bold" },
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
                var rows = this.items();
                $(rows).each(function () {
                    var index = $(this).index() + 1;
                    var rowLabel = $(this).find(".Row-Number");
                    $(rowLabel).html(index);
                });
                


                $("#RstDetailList").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var row = grid.dataItem(tr);
                    var data = FrameUtil.GetModel();
                    data.InstanceId = Common.GetUrlParam('InstanceId');
                    data.CFN_ID = row.CFN_ID;
                    FrameWindow.ShowLoading();
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'Delete',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            $("#RstDetailList").data("kendoGrid").setOptions({
                                dataSource: model.RstDetailList
                            });

                            FrameWindow.HideLoading();
                        }
                    });
                });



                $("#RstDetailList").find(".Check-Item").unbind("click");
                $("#RstDetailList").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstDetailList").data("kendoGrid"),
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
                        var grid = $("#RstDetailList").data("kendoGrid");
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

            if (pickedList.length == 0) {
                pickedList[0] = data.CFN_ID;
            }
            else {
                pickedList[pickedList.length] = data.CFN_ID;
            }

        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.CFN_ID) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.CFN_ID) {
                exists = true;
            }
        }
        return exists;
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
                $("#RstDetailList").data("kendoGrid").setOptions({
                    dataSource: model.RstDetailList
                });

                FrameWindow.HideLoading();
            }
        });
    }


    that.Delete = function () {


        var message = that.CheckForm(pickedList);
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            var data = FrameUtil.GetModel();
            data.InstanceId = Common.GetUrlParam('InstanceId');
            data.CFNID = pickedList;
            FrameUtil.SubmitAjax({
                business: business,
                method: 'CheckDelete',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'Delete',
                        message: '删除成功',
                        callback: function () {
                            pickedList = [];
                            //top.deleteTabsCurrent();
                            $("#RstDetailList").data("kendoGrid").setOptions({
                                dataSource: model.RstDetailList
                            });

                            FrameWindow.HideLoading();
                        }
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
        //FrameWindow.ShowConfirm({
        //    target: 'top',
        //    message: '确定删除吗？',
        //    confirmCallback: function () {
                
        //    }
        //});
    }

    that.CheckForm = function (data) {
        var message = [];
        if (data.length==0) {
            message.push('请选择有效数据');
        }



        return message;
    }

    that.AddUpn = function () {
        //var data = FrameUtil.GetModel();
        
        url = Common.AppVirtualPath + 'Revolution/Pages/MasterPage/DealerSpecialUPNPicker.aspx?' + 'InstanceId=' + Common.GetUrlParam('InstanceId');

            FrameWindow.OpenWindow({
                target: 'top',
                title: '组套UPN',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (flowList) {
                    var data = FrameUtil.GetModel();
                    data.InstanceId = Common.GetUrlParam('InstanceId');

                    FrameWindow.ShowLoading();
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'ChangeList',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                           
                            
                            $("#RstDetailList").data("kendoGrid").setOptions({
                                dataSource: model.RstDetailList
                            });

                            FrameWindow.HideLoading();
                        }
                    });
                    
                }
            });
    }


    var setLayout = function () {
    }

    return that;
}();
