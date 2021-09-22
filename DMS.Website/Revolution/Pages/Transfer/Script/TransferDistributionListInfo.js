/// <reference path="ConsignmentPicker.js" />
var TransferDistributionListInfo = {};

TransferDistributionListInfo = function () {
    var that = {};

    var business = 'Transfer.TransferDistributionList';
    var chooseProduct = [];
    
    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        
        return model;
    }

    that.Init = function () {
        var data = {};
        data.InstanceId = Common.GetUrlParam('InstanceId');
        data.hidDealerFromId = Common.GetUrlParam('FromDealer');
        $("#QryTransferType").val("Rent");
        $("#IsNewApply").val(Common.GetUrlParam('IsNew'));

        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitInfoWin',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#InstanceId').val(model.InstanceId);
                $('#hidDealerFromId').val(model.hidDealerFromId);

                $('#QryWinProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryWinProductLine,
                    onChange: that.ProductLineChange
                });
                //一级经销商
                $('#QryWinDealerFrom').DmsDealerFilter({
                    dataSource: model.LstFromDealer,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryWinDealerFrom,
                    onChange: that.ChangeFromDealer
                });
                //二级经销商
                $('#QryWinDealerTo').FrameDropdownList({
                    dataSource: model.LstToDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'select',
                    filter: 'contains',
                    value: model.QryWinDealerTo,
                    onchange: that.DealerToChange
                });

                $('#QryWinNumber').FrameTextBox({
                    value: model.QryWinNumber
                });
                //出库时间
                $('#QryWinDate').FrameTextBox({
                    value: model.QryWinDate,
                    readonly: true
                });

                $('#QryWinStatus').FrameTextBox({
                    value: model.QryWinStatus,
                    readonly: true
                });

                //选择产品
                $('#WinTDLWarehouse').FrameDropdownList({
                    dataSource: model.LstFromWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: model.WinTDLWarehouse
                });
                $('#WinTDLLotNumber').FrameTextBox({
                    value: ''
                });
                $('#WinTDLCFN').FrameTextBox({
                    value: ''
                });
                $('#WinTDLQrCode').FrameTextBox({
                    value: ''
                });

                $('#BtnSave').FrameButton({
                    text: '保存草稿',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
                    }
                });
                $('#BtnDelete').FrameButton({
                    text: '删除草稿',
                    icon: 'trash',
                    onClick: function () {
                        that.DeleteDraft();
                    }
                });
                $('#BtnSubmit').FrameButton({
                    text: '提交申请',
                    icon: 'check',
                    onClick: function () {
                        that.Submit();
                    }
                });
                $('#BtnClose').FrameButton({
                    text: '返回',
                    icon: 'close',
                    onClick: function () {
                        top.deleteTabsCurrent();
                    }
                });
                $('#BtnWinAddProduct').FrameButton({
                    text: '添加产品',
                    icon: 'plus',
                    onClick: function () {
                        clearChooseProduct();
                        that.ShowAddProductWin();
                    }
                });
                $('#BtnTDLSearch').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        clearChooseProduct();
                        that.QueryProduct();
                    }
                });
                $('#BtnWinAdd').FrameButton({
                    text: '确认',
                    icon: 'save',
                    onClick: function () {
                        that.AddProduct();
                    }
                });
                $('#BtnWinClose').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $('#winTDLProductLayout').data("kendoWindow").close();
                    }
                });

                //按钮状态
                $('#BtnSave').FrameButton('disable');
                $('#BtnDelete').FrameButton('disable');
                $('#BtnSubmit').FrameButton('disable');
                $('#BtnWinAddProduct').FrameButton('disable');
                $('#BtnTDLSearch').FrameButton('disable');
                $('#BtnWinAdd').FrameButton('disable');
                $('#QryWinProductLine').FrameDropdownList('disable');
                $('#QryWinDealerFrom').DmsDealerFilter('disable');
                $('#QryWinDealerTo').FrameDropdownList('disable');
                $('#QryWinNumber').FrameTextBox('disable');

                //页面控制*******************
                var editFlag = false;
                if (model.QryWinStatus == "草稿")
                    editFlag = true;
                createRstWinProductDetail(editFlag);
                
                if (model.IsDealer) {
                    if (model.QryWinStatus == "草稿") {
                        //绑定经销商。产品明细 
                        $('#BtnSave').FrameButton('enable');
                        $('#BtnDelete').FrameButton('enable');
                        $('#BtnSubmit').FrameButton('enable');
                        $('#BtnWinAddProduct').FrameButton('enable');
                        $('#BtnTDLSearch').FrameButton('enable');
                        $('#BtnWinAdd').FrameButton('enable');
                        $('#QryWinProductLine').FrameDropdownList('enable');
                        $('#QryWinDealerFrom').DmsDealerFilter('enable');
                        $('#QryWinDealerTo').FrameDropdownList('enable');
                        $("#RstWinProductDetail").data("kendoGrid").showColumn(11);
                    }
                    else {
                        //绑定经销商。产品明细 
                        //$("#RstWinProductDetail").data("kendoGrid").hideColumn(11);
                    }
                }

                //页面控制*******************

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();


                FrameWindow.HideLoading();
            }
        });
    }

    that.QueryProductDetail = function () {
        var grid = $("#RstWinProductDetail").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }
    var kendoProductDetail = GetKendoDataSource(business, 'QueryProductDetail', null, 10);
    var createRstWinProductDetail = function (editFlag) {
        $("#RstWinProductDetail").kendoGrid({
            dataSource: kendoProductDetail,
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            height: 400,
            columns: [
                {
                    field: "WarehouseName", title: "仓库", width: 'auto', editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFNEnglishName", title: "产品英文名", width: 150, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFNChineseName", title: "产品中文名", width: 120, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN", title: "产品型号", width: 80, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotNumber", title: "序列号/批号", width: 80, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号/批号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QRCode", title: "二维码", width: 80, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ExpiredDate", title: "有效期", width: 80, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UnitOfMeasure", title: "单位", width: 50, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TotalQty", title: "库存量", width: 50, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "库存量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TransferQty", title: "分销数量", width: 50, editable: function () {
                        return editFlag;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "分销数量" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ToWarehouseName", title: "移入仓库", width: 100, editable: function () {
                        return false;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "移入仓库" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Delete", title: "删除", width: 50, editable: function () {
                        return false;
                    }, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;" },
                    template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                    attributes: { "class": "text-center text-bold" },
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 10,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstWinProductDetail").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $("#RstWinProductDetail").data("kendoGrid").dataSource.remove(data);
                    that.Delete(data.Id);
                });

            }
        });
    }

    that.QueryProduct = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'QueryProductList',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstTDLProductItem").data("kendoGrid").setOptions({
                    dataSource: model.RstTDLProductItem
                });
                FrameWindow.HideLoading();
            }
        });
    }
    //var kendoProductList = GetKendoDataSource(business, 'QueryProductList', null, 10);
    //经销商
    var createResultList = function () {

        $("#RstTDLProductItem").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 290,
            columns: [
                 {
                     title: "全选", width: '50px', encoded: false,
                     headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                     template: '<input type="checkbox" id="Check_#=LotId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=LotId#"></label>',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "WarehouseName", title: "分仓库", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "分仓库" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EnglishName", title: "英文名称", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "英文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "中文名称", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "中文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CFN", title: "产品型号", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotNumber", title: "序列号/批号", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "序列号/批号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "QRCode", title: "二维码", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotExpiredDate", title: "有效期", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "LotInvQty", title: "库存数量", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "库存数量" },
                    attributes: { "class": "table-td-cell" }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstTDLProductItem").find(".Check-Item").unbind("click");
                $("#RstTDLProductItem").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstTDLProductItem").data("kendoGrid"),
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
                        var grid = $("#RstTDLProductItem").data("kendoGrid");
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
                clearChooseProduct();
                $('#CheckAll').removeAttr("checked");
            }
        });
    }

    var clearChooseProduct = function () {
        $('#CheckAll').removeAttr("checked");
        chooseProduct.splice(0, chooseProduct.length);
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            chooseProduct.push(data.LotId);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < chooseProduct.length; i++) {
            if (chooseProduct[i] == data.LotId) {
                chooseProduct.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < chooseProduct.length; i++) {
            if (chooseProduct[i] == data.LotId) {
                exists = true;
            }
        }
        return exists;
    }

    //修改产品线
    that.ProductLineChange = function () {
      
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '改变产品线将删除已添加的产品！',
            confirmCallback: function () {
                //createRstDealerList([]);

                var model = FrameUtil.GetModel();
                var data = {}; data.InstanceId = model.InstanceId;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteDetail',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        that.QueryProductDetail();
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }
    //更改一级经销商
    that.ChangeFromDealer = function () {
        var data = {};
        data.QryFromDealerName = $('#QryWinDealerFrom').DmsDealerFilter('getValue');

        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeFromDealer',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryWinDealerTo').FrameDropdownList({
                    dataSource: model.LstToDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    selectType: 'select',
                    filter: 'contains',
                    value: model.QryWinDealerTo,
                    onchange: that.DealerToChange
                });
                FrameWindow.HideLoading();
            }
        });
    }
    //更改二级经销商
    that.DealerToChange = function (DealerId) {
        $("#hidDealerToDefaultWarehouseId").val("");//初始化
        
        //查询仓库等信息是否存在
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'CheckDealer',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (!model.IsSuccess) {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'warning',
                        message: model.ExecuteMessage,
                        callback: function () {

                        }
                    });
                }
                else {
                    $("#hidDealerToDefaultWarehouseId").val(model.hidDealerToDefaultWarehouseId);
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.ShowAddProductWin = function () {
        var data = that.GetModel();
        if (data.QryWinDealerTo && data.QryWinDealerTo.Key != "" && data.QryWinProductLine && data.QryWinProductLine.Key != "")
        {
            createResultList();
            $("#winTDLProductLayout").kendoWindow({
                title: "Title",
                width: 900,
                height: 500,
                actions: [
                    "Close"
                ],
                resizable: false,
                //modal: true,
            }).data("kendoWindow").title("添加产品").center().open();
        }
        else
        {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择产品线与二级经销商！',
                callback: function () {
                }
            });
        }
    }
    
    //添加产品
    that.AddProduct = function () {
        if (chooseProduct.length > 0) {
            var param = '';
            for (var i = 0; i < chooseProduct.length; i++) {
                param += chooseProduct[i] + ',';
            }
            var data = that.GetModel();
            data.ParamProductItem = param;
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DoAddProductItems',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    //var dataSource = $("#RstWinProductDetail").data("kendoGrid").dataSource.data();

                    //for (var i = 0; i < model.RstWinProductDetail.length; i++) {
                    //    var exists = false;
                    //    for (var j = 0; j < dataSource.length; j++) {
                    //        if (dataSource[j].QRCode == model.RstWinProductDetail[i].QRCode) {
                    //            exists = true;
                    //        }
                    //    }

                    //    if (!exists) {
                    //        dataSource.push(model.RstWinProductDetail[i]);
                    //    }
                    //}
                    $("#RstWinProductDetail").data("kendoGrid").setOptions({
                        dataSource: model.RstWinProductDetail
                    });
                    FrameWindow.HideLoading();
                }
            });
            
        }
        else {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择要添加的数据！',
                callback: function () {
                }
            });
        }
    }

    //单行删除 操作
    that.Delete = function (LotId) {
        var data = {};
        data.LotId = LotId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'Delete',
                    message: '删除成功',
                });
                FrameWindow.HideLoading();
            }
        });
    }

    that.DeleteDraftOrder = function () {
        $("#hiddIsModifyStatus").val("false");
        if ("true" == $("#IsNewApply").val()) {
            var data = {};
            var param = FrameUtil.GetModel();
            data.InstanceId = param.InstanceId;
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteDraft',
                url: Common.AppHandler,
                data: data,
                async: false,
                callback: function (model) {
                    if (!model.IsSuccess) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: model.ExecuteMessage,
                        });
                    }
                    FrameWindow.HideLoading();
                    $("#hiddIsModifyStatus").val("true");
                }
            });
        }
    };
    //删除草稿
    that.DeleteDraft = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确认要执行删除操作？',
            confirmCallback: function () {
                var data = {};
                var param = FrameUtil.GetModel();
                data.InstanceId = param.InstanceId;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteDraft',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'Delete',
                            message: '删除成功',
                            callback: function () {
                                top.deleteTabsCurrent();
                            }
                        });
                        FrameWindow.HideLoading();
                    }
                });
            }
        });

    };
    
    //保存草稿
    that.Save = function () {
        var data = that.GetModel();
        data.RstWinProductDetail = $("#RstWinProductDetail").data("kendoGrid").dataSource.data();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveDraft',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (!model.IsSuccess) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'error',
                        message: model.ExecuteMessage,

                    });
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '保存成功',
                        callback: function () {
                            top.deleteTabsCurrent();
                        }
                    });

                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.Submit = function () {
        var data = that.GetModel();
        data.RstWinProductDetail = $("#RstWinProductDetail").data("kendoGrid").dataSource.data();
        
        if (data.QryWinDealerTo && data.QryWinDealerTo.Key != "" && data.QryWinProductLine && data.QryWinProductLine.Key != "")
        {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Submit',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    if (!model.IsSuccess) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'error',
                            message: model.ExecuteMessage,

                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '提交成功！',
                            callback: function () {
                                top.deleteTabsCurrent();
                            }
                        });

                    }
                    FrameWindow.HideLoading();
                }
            });
        }
        else {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: "校验产品线及二级经销商！",
            });
        } 
    }

    that.CheckInt = function () {
        var r = /^[0-9]*$/;
        var IptConsignmentDay = $('#IptConsignmentDay').FrameTextBox('getValue')
        var IptDelayNumber = $('#IptDelayNumber').FrameTextBox('getValue')
        if (!r.test(IptConsignmentDay)) {
            $("#IptConsignmentDay_Control").val("");
        }
        if (!r.test(IptDelayNumber)) {
            $("#IptDelayNumber_Control").val("");
        }

    }

    var setLayout = function () {
    }

    return that;
}();


