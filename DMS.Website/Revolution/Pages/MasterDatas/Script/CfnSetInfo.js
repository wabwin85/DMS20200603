var CfnSetInfo = {};

CfnSetInfo = function () {
    var that = {};

    var business = 'MasterDatas.CfnSetInfo';
    var CustomerFaceNbr = [];
    var g = 0;
    var pickedList = [];
    var GetModel = function () {
        var model = FrameUtil.GetModel();
        model.InstanceId = Common.GetUrlParam('InstanceId');
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

                $('#IptBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.IptBu,
                    onChange: that.ProductLineChange
                });
                $('#IptCFNSetUPN').FrameTextBox({
                    value: model.IptCFNSetUPN,
                    readonly: !model.isCanEditUPN
                });
                $('#IptCFNSetChineseName').FrameTextBox({
                    value: model.IptCFNSetChineseName
                });
                $('#IptCFNSetEnglishName').FrameTextBox({
                    value: model.IptCFNSetEnglishName
                });

                $('#IptCFNSetUOM').FrameTextBox({
                    value: model.IptCFNSetUOM
                });

                $('#IptCFNSetCanOrder').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.IptCFNSetCanOrder
                });
                $('#IptCFNSetImpant').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.IptCFNSetImpant
                });
                $('#IptCFNSetTool').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.IptCFNSetTool
                });
                $('#IptCFNSetShare').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.IptCFNSetShare
                });
                $('#IptCFNSetCINO').FrameTextBox({
                    value: model.IptCFNSetCINO
                });
                $('#IptCFNSetPT7').FrameTextBox({
                    value: model.IptCFNSetPT7
                });
                $('#IptCFNSetPT8').FrameTextBox({
                    value: model.IptCFNSetPT8
                });
                $('#IptCFNSetDescription').FrameTextBox({
                    value: model.IptCFNSetDescription
                });
                $('#BtnAddUpn').FrameButton({
                    text: '添加产品',
                    icon: 'file',
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
                        var index = that.SeachDataSource(dataSource.data(),item.CfnId);
                        if (index<0) {
                            dataSource.add(item);
                        }
                    });
                                        
                }
            });
    }
    that.SeachDataSource = function (dataSource,cfnId) {
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
        if (data.IptCFNSetUPN == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请填写成套产品UPN',
                callback: function () {
                    //top.deleteTabsCurrent();
                    that.Query();
                }
            });
            return;
        }
        FrameWindow.ShowLoading();
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
//                            that.Query();
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

    that.ProductLineChange = function () {

        $("#RstDetailList").data("kendoGrid").setOptions({
            dataSource: []
        });

    }
    var setLayout = function () {
    }

    return that;
}();
