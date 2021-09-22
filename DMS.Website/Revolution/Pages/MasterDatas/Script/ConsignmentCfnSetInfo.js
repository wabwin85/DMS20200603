var ConsignmentCfnSetInfo = {};

ConsignmentCfnSetInfo = function () {
    var that = {};

    var business = 'MasterDatas.ConsignmentCfnSetInfo';
    var CustomerFaceNbr = [];
    var g = 0;
    var pickedList = [];
    var GetModel = function () {
        var model = FrameUtil.GetModel();
        model.InstanceId = Common.GetUrlParam('InstanceId');
        model.RstDetailList = $("#RstDetailList").data("kendoGrid").dataSource.data();
        return model;
    }
    $("#IsNewApply").val(Common.GetUrlParam('IsNew'));

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

                var hidBu = "";
                if (Common.GetUrlParam('InstanceId') != "" && Common.GetUrlParam('InstanceId') != null) {
                    if (model.IptBu.Key != "" && model.IptBu.Key != null)
                        hidBu = model.IptBu.Key;
                }
                else {
                    hidBu = Common.GetUrlParam('Bu');
                }
                $.each(model.LstBu, function (index, val) {
                    if (hidBu === val.Key)
                        model.IptBu = { Key: val.Key, Value: val.Value };
                })

                $('#IptBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.IptBu,
                    onChange: that.ProductLineChange
                });
                if (Common.GetUrlParam('InstanceId') != "" && Common.GetUrlParam('InstanceId') != null) {
                    $('#IptBu').FrameDropdownList('disable');
                }

                $('#IptCFNSetChineseName').FrameTextBox({
                    value: model.IptCFNSetChineseName
                });
                $('#IptCFNSetEnglishName').FrameTextBox({
                    value: model.IptCFNSetEnglishName
                });
                $('#BtnAddUpn').FrameButton({
                    text: '添加产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddUpn();
                    }
                });
                $('#BtnSave').FrameButton({
                    text: '保存',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
                    }
                });

                $('#BtnClose').FrameButton({
                    text: '取消',
                    icon: 'close',
                    onClick: function () {
                        top.deleteTabsCurrent();
                    }
                });
                $("#RstDetailList").data("kendoGrid").setOptions({
                    dataSource: model.RstDetailList
                });
                createRstOutFlowList();
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();


                FrameWindow.HideLoading();
            }
        });
    }

    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 10, GetModel);
    var createRstOutFlowList = function (dataSource) {
        $("#RstDetailList").kendoGrid({
            dataSource: kendoDataSource,
            schema: {
                model: {
                    fields: {
                        DefaultQuantity: { type: "number", validation: { required: true, min: 0 } }
                    }
                }
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            columns: [
            {
                editable: function () {
                    return false;
                },
                field: "CustomerFaceNbr", title: "产品型号", width: '150px',
                headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
            },
            {
                editable: function () {
                    return false;
                },
                field: "ChineseName", title: "中文名", width: '200px',
                headerAttributes: { "class": "text-center text-bold", "title": "中文名" }
            },
            {
                editable: function () {
                    return false;
                },
                field: "EnglishName", title: "英文名", width: '200px',
                headerAttributes: { "class": "text-center text-bold", "title": "英文名" }
            },
            {
                field: "DefaultQuantity", title: "默认数量", width: '60px',
                headerAttributes: { "class": "text-center text-bold", "title": "默认数量" }
            },
             {
                 editable: function () {
                     return false;
                 },
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
            edit: function (e) {
                var grid = e.sender;
                var tr = $(e.container).closest("tr");
                var data = grid.dataItem(tr);
                var Qty = e.container.find("input[name=DefaultQuantity]");

                Qty.change(function (b) {
                    if (parseFloat($(this).val()) < 0) {
                        data.DefaultQuantity = ($(this).val()) * (-1);
                        $("#RstDetailList").data("kendoGrid").dataSource.fetch();
                        return false;
                    }
                });
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
                    //var Item = gridDataSource.get(row.Id);
                    var dataSource = $("#RstDetailList").data("kendoGrid").dataSource;
                    dataSource.remove(row);
                });



            },
            page: function (e) {

            }
        });
    }

    that.Query = function () {
        var grid = $("#RstDetailList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    that.AddUpn = function () {
        var data = GetModel();
        if (data.IptBu && data.IptBu.Key == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请先选择产品线',
                callback: function () {
                }
            });
            return;
        }

        url = Common.AppVirtualPath + 'Revolution/Pages/MasterDatas/CfnSetCFN.aspx?' + 'InstanceId=' + Common.GetUrlParam('InstanceId') + '&IptBuKey=' + data.IptBu.Key + '&IptBuValue=' + data.IptBu.Value;

        FrameWindow.OpenWindow({
            target: 'top',
            title: '添加产品',
            url: url,
            width: $(window).width() * 0.7,
            height: $(window).height() * 0.9,
            actions: ["Close"],
            callback: function (flowList) {
                var dataSource = $("#RstDetailList").data("kendoGrid").dataSource;
                $.each(flowList, function (i, item) {
                    var index = that.SeachDataSource(dataSource.data(), item.CfnId);
                    if (index < 0) {
                        dataSource.add(item);
                    }
                });

            }
        });
    }
    that.SeachDataSource = function (dataSource, cfnId) {
        var index = -1;
        $.each(dataSource, function (i, item) {
            if (item.CfnId == cfnId) {
                index = i;
                return;
            }
        });
        return index;
    }
    that.Save = function () {
        var data = GetModel();
        if ($.trim(data.IptCFNSetChineseName) == "" || $.trim(data.IptCFNSetEnglishName) == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请填写成套产品的中英文名称!'
            });
            return;
        }
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Save',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '保存成功',
                        callback: function () {
                            top.deleteTabsCurrent();
                        }
                    });
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: model.ExecuteMessage,
                        callback: function () {
                        }
                    });
                }
                $(window).resize(function () {
                    setLayout();
                })

                FrameWindow.HideLoading();
            }
        });
    }

    that.DeleteDraftOrder = function () {
        $("#hiddIsModifyStatus").val("false");
        if ("true" == $("#IsNewApply").val()) {
            $("#hiddIsModifyStatus").val("true");
        }
    };
    that.ProductLineChange = function () {

        $("#RstDetailList").data("kendoGrid").setOptions({
            dataSource: []
        });

    }
    var setLayout = function () {
    }

    return that;
}();
