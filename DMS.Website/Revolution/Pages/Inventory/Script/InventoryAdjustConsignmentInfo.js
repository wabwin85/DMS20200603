var InventoryAdjustConsignmentInfo = {};

InventoryAdjustConsignmentInfo = function () {
    var that = {};

    var business = 'Inventory.InventoryAdjustConsignmentInfo';
    var CustomerFaceNbr = [];
    var g = 0;
    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.RstDetailList = $("#RstDetailList").data("kendoGrid").dataSource.data();
        return model;
    }

    var EntityModel = "";
    var EditColumnArray = [];//编辑列
    var LstBuArr = [];
    var LstTypeArr = [];

    that.Init = function () {
        var data = {};
        $("#IsNewApply").val(Common.GetUrlParam('NewApply'));
        data.InstanceId = Common.GetUrlParam('InstanceId');
        data.QryStatus = Common.GetUrlParam('Status');
        data.IsNewApply = Common.GetUrlParam('NewApply');
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#DealerListType").val(model.DealerListType);
                $('#InstanceId').val(model.InstanceId);
                $('#IsNewApply').val(model.IsNewApply);
                EntityModel = JSON.parse(model.EntityModel);
                LstBuArr = model.LstBu;
                LstTypeArr = model.LstType;

                $("#InstanceId").val(EntityModel.Id);
                $("#hiddenDealerId").val(EntityModel.DmaId);
                if (EntityModel.Reason != "" && EntityModel.Reason != null) {
                    $("#hiddenAdjustTypeId").val(EntityModel.Reason);
                    model.hiddenAdjustTypeId = EntityModel.Reason;
                }
                if (EntityModel.ProductLineBumId != null) {
                    $("#hiddenProductLineId").val(EntityModel.ProductLineBumId);
                    model.hiddenProductLineId = EntityModel.ProductLineBumId;
                }

                //$('#IptApplyBasic').DmsApplyBasic({
                //    value: model.IptApplyBasic
                //});
                if (model.IsNewApply) {
                    if (model.LstBu != null) {
                        model.IptProductLine = model.LstBu[0];
                        $("#hiddenProductLineId").val(model.LstBu[0].Key);
                    }
                }
                else {
                    $.each(model.LstBu, function (index, val) {
                        if (model.hiddenProductLineId === val.Key)
                            model.IptProductLine = {
                                Key: model.hiddenProductLineId, Value: val.Value
                            };
                    })
                    //调整类型
                    $.each(model.LstType, function (index, val) {
                        if (model.hiddenAdjustTypeId === val.Key)
                            model.IptAdjustType = {
                                Key: model.hiddenAdjustTypeId, Value: val.Value
                            };
                    })
                }
                //产品线
                $('#IptProductLine').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.IptProductLine,
                    onChange: function (e) {
                        that.ProductLineChange(this.value);
                    }

                });
                //调整类型
                $('#IptAdjustType').FrameDropdownList({
                    dataSource: model.LstType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.IptAdjustType,
                    onChange: function (e) {
                        that.AdjustTypeChange(this.value);
                    }
                });
                //库存调整单号
                $('#IptAdjustNo').FrameTextBox({
                    value: model.IptNo,
                });
                $('#IptAdjustNo').FrameTextBox('disable');
                //调整日期
                $('#IptAdjustDate').FrameTextBox({
                    value: model.IptAdjustDate,
                });
                $('#IptAdjustDate').FrameTextBox('disable');
                //经销商
                //$('#IptDealer').FrameDropdownList({
                //    dataSource: model.LstDealer,
                //    dataKey: 'Id',
                //    dataValue: 'ChineseShortName',
                //    selectType: 'none',
                //    filter: 'contains',
                //    value: model.IptDealer,
                //    onChange: function (e) {
                //        that.DealerChange(this.value);
                //    }
                //});
                $('#IptDealer').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    parameters: { "IsAll": $("#DealerListType").val() },//查询类型
                    business: 'Util.DealerScreenFilter',
                    method: 'DealerFilter',
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'none',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.IptDealer,
                    onChange: function (e) {
                        that.DealerChange(this._old);
                    }
                });
                //状态
                $('#IptStatus').FrameTextBox({
                    value: model.IptStatus,
                });
                $('#IptStatus').FrameTextBox('disable');
                //调整原因
                $('#IptAdjustReason').FrameTextArea({
                    value: model.IptAdjustReason,
                });
                //调整备注
                $('#IptAduitNoteWin').FrameTextArea({
                    value: model.IptAdjustReason,
                });


                $('#RstOperationLog').DmsOperationLog({
                    dataSource: model.RstLogDetail
                });
                createRstProductDetail(model.RstContractDetail);

                //经销商新增,按钮权限控制, !readonly：判断是否是新增
                $('#RevokeButton').remove();//設置隱藏

                $('#BtnSave').FrameButton({
                    text: '保存草稿',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
                    }
                });

                $('#BtnDelete').FrameButton({
                    text: '删除草稿',
                    icon: 'remove',
                    onClick: function () {
                        that.Delete();
                    }
                });
                $('#BtnSubmit').FrameButton({
                    text: '提交',
                    icon: 'send',
                    onClick: function () {
                        that.Submit();
                    }
                });
                $('#RevokeButton').FrameButton({
                    text: '撤销',
                    icon: 'reply',
                    onClick: function () {
                        that.Cancle();
                    }
                });
                //添加产品功能不需!,原后台方法决定

                $('#BtnAddUpn').FrameButton({
                    text: '添加产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddUpn();
                    }
                });

                that.InitPage(EntityModel, model);

                that.EditColumn();
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.InitPage = function (mainData, model) {
        //窗口状态控制
        $("#RstDetailList").data("kendoGrid").hideColumn('ExpiredDate');//5
        $("#RstDetailList").data("kendoGrid").showColumn('QRCode');//4
        $("#RstDetailList").data("kendoGrid").showColumn('QRCodeEdit');//11
        $("#RstDetailList").data("kendoGrid").hideColumn('Delete');//12

        $("#RstDetailList").data("kendoGrid").columns[3].editable = true;//禁用编辑
        $("#RstDetailList").data("kendoGrid").columns[5].editable = true;
        $("#RstDetailList").data("kendoGrid").columns[9].editable = true;
        $("#RstDetailList").data("kendoGrid").columns[11].editable = true;

        $('#IptDealer').DmsDealerFilter('disable');
        $('#IptProductLine').FrameDropdownList('disable');
        $('#IptAdjustType').FrameDropdownList('disable');
        $('#IptAdjustReason').FrameTextArea('disable');

        $('#IptAduitNoteWin').FrameTextArea('disable');
        $('#IptAduitNoteWin').parent().parent().hide();

        that.removeButton("BtnSave");
        that.removeButton("BtnDelete");
        that.removeButton("BtnSubmit");
        that.removeButton("RevokeButton");
        that.removeButton("BtnAddUpn");
        if (model.IsDealer) {
            if (mainData.Status == "Draft") {
                $('#IptDealer').DmsDealerFilter('enable');
                $('#IptProductLine').FrameDropdownList('enable');
                $('#IptAdjustType').FrameDropdownList('enable');
                $('#IptAdjustReason').FrameTextArea('enable');
                $('#BtnSave').FrameButton({
                    text: '保存草稿',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
                    }
                });
                $('#BtnDelete').FrameButton({
                    text: '删除草稿',
                    icon: 'remove',
                    onClick: function () {
                        that.Delete();
                    }
                });
                $('#BtnSubmit').FrameButton({
                    text: '提交',
                    icon: 'send',
                    onClick: function () {
                        that.Submit();
                    }
                });
                $("#RstDetailList").data("kendoGrid").columns[11].editable = false;
                $("#RstDetailList").data("kendoGrid").showColumn('Delete');
                //如果是其他入库，则序列号、有效期可以做修改
                if (mainData.Reason == "StockIn") {
                    $("#RstDetailList").data("kendoGrid").showColumn('QRCodeEdit');//11
                    $("#RstDetailList").data("kendoGrid").columns[3].editable = false;//编辑
                    $("#RstDetailList").data("kendoGrid").columns[5].editable = false;//编辑
                    $("#RstDetailList").data("kendoGrid").columns[11].editable = false;//编辑
                }
                else {
                    $("#RstDetailList").data("kendoGrid").columns[3].editable = true;//出库 序列号、二维码禁用编辑
                    $("#RstDetailList").data("kendoGrid").columns[11].editable = true;
                }
                $("#RstDetailList").data("kendoGrid").columns[9].editable = false;//9
                if (mainData.ProductLineBumId != null && mainData.Reason != null) {
                    $('#BtnAddUpn').FrameButton({
                        text: '添加产品',
                        icon: 'plus',
                        onClick: function () {
                            that.AddUpn();
                        }
                    });
                }
                if (mainData.Reason == "StockOut") {
                    $("#RstDetailList").data("kendoGrid").showColumn('QRCode');//4
                    $("#RstDetailList").data("kendoGrid").showColumn('QRCodeEdit');//11
                }
                EditColumnArray.push(3);
                EditColumnArray.push(9);
                EditColumnArray.push(11);
            }
            else {
                $("#RstDetailList").data("kendoGrid").showColumn('ExpiredDate');//5
                $("#RstDetailList").data("kendoGrid").hideColumn('Delete');//12
                EditColumnArrayIsExists(3);
                EditColumnArrayIsExists(9);
                EditColumnArrayIsExists(11);
                if (mainData.Reason == "StockOut") {
                    $("#RstDetailList").data("kendoGrid").showColumn('QRCode');//4
                    $("#RstDetailList").data("kendoGrid").showColumn('QRCodeEdit');//11
                }
                else {
                    $("#RstDetailList").data("kendoGrid").showColumn('QRCodeEdit');//11
                }
            }
            if (mainData.Reason == "StockIn" || mainData.Reason == "StockOut") {
                if (mainData.Status == "Submit") {
                    $('#RevokeButton').FrameButton({
                        text: '撤销',
                        icon: 'reply',
                        onClick: function () {
                            that.Cancle();
                        }
                    });
                }
            }
            else {
                if (mainData.Status == "Submitted") {
                    $('#RevokeButton').FrameButton({
                        text: '撤销',
                        icon: 'reply',
                        onClick: function () {
                            that.Cancle();
                        }
                    });
                }
            }
        }
        else {
            if (mainData.Reason == "StockIn") {
                $("#RstDetailList").data("kendoGrid").showColumn('QRCode');//4
            }
            else if (mainData.Reason == "StockOut") {
                $("#RstDetailList").data("kendoGrid").showColumn('QRCode');//4
            }
        }
        if (mainData.Status == "Reject" || mainData.Status == "Accept") {
            $('#IptAduitNoteWin').parent().parent().show();
        }

    };
    var createRstProductDetail = function (datasource) {
        $("#RstDetailList").kendoGrid({
            dataSource: {
                data: datasource,
                schema: {
                    model: {
                        fields: {
                            AdjustQty: { type: "number", validation: { required: true, min: 0 } }
                        }
                    },
                },
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            columns: [
            {
                field: "WarehouseName", title: "仓库", width: 'auto', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "仓库" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "CFN", title: "产品型号", width: '120px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "UPN", title: "产品型号", width: '120px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "LotNumber", title: "序列号/批号", width: '100px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "序列号/批号" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "QRCode", title: "二维码", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "ExpiredDate", title: "有效期", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "有效期" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "UnitOfMeasure", title: "单位", width: '50px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "TotalQty", title: "库存量", width: '60px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "库存量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "CreatedDate", title: "入库时间", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "入库时间" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "AdjustQty", title: "数量", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "PurchaseOrderNbr", title: "关联订单", width: '80px', editable: true, hidden: true,
                headerAttributes: { "class": "text-center text-bold", "title": "关联订单" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "QRCodeEdit", title: "二维码", width: '120px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                attributes: { "class": "table-td-cell" }
            },
             {
                 field: "Delete", title: "删除", width: '50px', editable: true,
                 headerAttributes: { "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;" },
                 template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                 attributes: { "class": "text-center text-bold" },
             }
            ],
            edit: function (e) {
                that.CheckQty(e);
            },
            save: function (e) {
                that.UpdateItem(e);
            },
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
                    var data = grid.dataItem(tr);
                    $("#RstDetailList").data("kendoGrid").dataSource.remove(data);
                    that.DeleteItem(data.Id);
                });

                that.EditColumn();
            }
        });
    }

    //验证数量
    that.CheckQty = function (e) {
        var qty = /^[1-9]\d*$/;
        var grid = e.sender;
        var tr = $(e.container).closest("tr");
        var data = grid.dataItem(tr);
        var AdjustQty = e.container.find("input[name=AdjustQty]");

        AdjustQty.change(function (b) {
            if ($('#IptAdjustType').FrameDropdownList('getValue').Key != 'StockIn') {
                if (accMin(data.TotalQty, $(this).val()) < 0) {
                    //数量错误时，编辑行置为空
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'warning',
                        message: "调整数量不能大于库存量！",
                    });
                    data.AdjustQty = data.TotalQty;
                    $("#RstDetailList").data("kendoGrid").dataSource.fetch();
                    return false;
                }
            }
            if (accMul($(this).val(), 1000000) % accDiv(1, data.ConvertFactor).mul(1000000) != 0) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: "最小单位是" + +accDiv(1, data.ConvertFactor)
                });
                data.AdjustQty = data.TotalQty;
                $("#RstDetailList").data("kendoGrid").dataSource.fetch();
                return false;
            }

        });
    }

    //修改产品明细单元格由于提示较复杂，故采用单个单元格直接保存的方式
    //编辑行数据实时保存
    that.UpdateItem = function (e) {
        var data = {};
        var param = FrameUtil.GetModel();
        data.hiddenAdjustTypeId = param.hiddenAdjustTypeId;
        data.InstanceId = param.InstanceId;
        data.LotId = e.model.Id;
        if (e.values.CFN) {
            data.CFN = e.values.CFN;
        }
        else {
            data.CFN = e.model.CFN
        }
        if (e.values.LotNumber) {
            data.lotNumber = e.values.LotNumber;
        }
        else {
            data.lotNumber = e.model.LotNumber
        }
        if (e.values.ExpiredDate) {
            data.expiredDate = e.values.ExpiredDate;
        }
        else {
            data.expiredDate = e.model.ExpiredDate
        }
        if (e.values.AdjustQty) {
            data.adjustQty = e.values.AdjustQty;
        }
        else {
            data.adjustQty = e.model.AdjustQty
        }
        if (e.values.QRCodeEdit) {
            data.EditQrCode = e.values.QRCodeEdit;
        }
        else {
            data.EditQrCode = e.model.QRCodeEdit
        }

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    that.RefershHeadData();
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'Error',
                        message: model.ExecuteMessage,
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    };

    //*****************************************CZ*******************************
    //刷新数据
    that.RefershHeadData = function () {
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'RefershHeadData',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstDetailList").data("kendoGrid").setOptions({
                    dataSource: model.RstContractDetail
                });
                $("#QryTotalAmount").FrameTextBox('setValue', model.QryTotalAmount);
                $("#QryTotalQty").FrameTextBox('setValue', model.QryTotalQty);
                FrameWindow.HideLoading();
            }
        });
    }
    //删除行
    that.DeleteItem = function (LotId) {
        var data = {
        };
        data.LotId = LotId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '删除成功',
                });
                FrameWindow.HideLoading();
            }
        });
    };


    //撤销操作
    that.Cancle = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定撤销吗？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
                FrameWindow.ShowLoading();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DoRevoke',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '撤销成功',
                                callback: function () {
                                    top.deleteTabsCurrent();
                                }
                            });
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'Error',
                                message: model.ExecuteMessage,
                                callback: function () {
                                }
                            });
                        }
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    };

    that.DeleteDraftOrder = function () {
        $("#hiddIsModifyStatus").val("false");
        if ("true" == $("#IsNewApply").val()) {
            var data = FrameUtil.GetModel();
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
    that.Delete = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定删除草稿吗？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
                FrameWindow.ShowLoading();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteDraft',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '删除草稿成功',
                                callback: function () {
                                    top.deleteTabsCurrent();
                                }
                            });
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'Error',
                                message: model.ExecuteMessage,
                                callback: function () {
                                }
                            });
                        }
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }
    //保存草稿
    that.Save = function () {
        var data = that.GetModel();
        //验证产品线，否则无法带出订单（分子公司和品牌）
        if ($.trim(data.IptProductLine.Key) == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线',
            });
        }
        else if ($.trim(data.IptAdjustReason).length > 2000) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '调整原因的内容不能超过2000字!',
            });
        }
        else {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SaveDraft',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '保存草稿成功',
                            callback: function () {
                                top.deleteTabsCurrent();
                            }
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'Error',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }
    //表单提交
    that.Submit = function () {
        var data = that.GetModel();
        if ($.trim(data.IptAdjustReason).length > 2000) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '调整原因的内容不能超过2000字!',
            });
        }
        var message = that.CheckForm(data);
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DoSubmit',
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
                        if (!model.hiddenIsRtnValue) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'warning',
                                message: model.warnMsg,
                            });
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '提交成功',
                                callback: function () {
                                    top.deleteTabsCurrent();
                                }
                            });
                        }
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    var CheckAddItemsParam = function () {
        //此函数用来控制“添加产品”按钮的状态
        var productLine = $('#IptProductLine').FrameDropdownList('getValue').Key;
        var AdjustType = $('#IptAdjustType').FrameDropdownList('getValue').Key;
        if (productLine == '' || AdjustType == '') {
            that.removeButton("BtnAddUpn");
        } else {
            $('#BtnAddUpn').FrameButton({
                text: '添加产品',
                icon: 'plus',
                onClick: function () {
                    that.AddUpn();
                }
            });
        }
    }
    //产品线改变
    that.ProductLineChange = function (Bu) {
        if ($("#hiddenProductLineId").val() != Bu) {
            if ($("#hiddenProductLineId").val() == '') {
                $("#hiddenProductLineId").val(Bu);
                that.RefershHeadData();
                CheckAddItemsParam();
            }
            else {
                FrameWindow.ShowConfirm({
                    target: 'top',
                    message: '改变产品线将删除已添加的产品！',
                    confirmCallback: function () {
                        var data = FrameUtil.GetModel();
                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'OnProductLineChange',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                $("#hiddenProductLineId").val(Bu);
                                that.RefershHeadData();
                                CheckAddItemsParam();

                                FrameWindow.HideLoading();
                            }
                        });
                    },
                    cancelCallback: function () {
                        var originalBu = {
                            Key: '', Value: ''
                        };
                        $.each(LstBuArr, function (index, val) {
                            if ($("#hiddenProductLineId").val() === val.Key)
                                originalBu = {
                                    Key: $("#hiddenProductLineId").val(), Value: val.Value
                                };
                        })
                        $('#IptProductLine').FrameDropdownList('setValue', originalBu);
                    }
                });
            }
        }
    }

    //调整类型改变
    that.AdjustTypeChange = function (Type) {
        if (Type == 'StockIn') {
            $("#RstDetailList").data("kendoGrid").showColumn('QRCodeEdit');
            $("#RstDetailList").data("kendoGrid").columns[3].editable = false;
            $("#RstDetailList").data("kendoGrid").columns[4].editable = false;
        }
        else {
            $("#RstDetailList").data("kendoGrid").showColumn('QRCode');
            $("#RstDetailList").data("kendoGrid").showColumn('QRCodeEdit');
            $("#RstDetailList").data("kendoGrid").columns[3].editable = true;
            $("#RstDetailList").data("kendoGrid").columns[4].editable = true;
        }
        if ($("#hiddenAdjustTypeId").val() != Type) {
            if ($("#hiddenAdjustTypeId").val() == '') {
                $("#hiddenAdjustTypeId").val(Type);
                that.RefershHeadData();
                CheckAddItemsParam();
            }
            else {
                FrameWindow.ShowConfirm({
                    target: 'top',
                    message: '改变调整类型将删除已添加的产品！',
                    confirmCallback: function () {
                        var data = FrameUtil.GetModel();
                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'OnAdjustTypeChange',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                if (Type == "StockOut") {
                                    EditColumnArrayIsExists(3);
                                }
                                else {
                                    EditColumnArray.push(3);
                                    EditColumnArray.push(11);
                                }
                                $("#hiddenAdjustTypeId").val(Type);
                                that.RefershHeadData();
                                CheckAddItemsParam();

                                FrameWindow.HideLoading();
                            }
                        });
                    },
                    cancelCallback: function () {
                        var originalType = {
                            Key: '', Value: ''
                        };
                        $.each(LstTypeArr, function (index, val) {
                            if ($("#hiddenAdjustTypeId").val() === val.Key)
                                originalType = {
                                    Key: $("#hiddenAdjustTypeId").val(), Value: val.Value
                                };
                        })
                        $('#IptAdjustType').FrameDropdownList('setValue', originalType);
                    }
                });
            }
        }
    }

    //详情页经销商改变
    that.DealerChange = function (dealerId) {
        if ($("#hiddenDealerId").val() != dealerId) {
            var data = FrameUtil.GetModel();
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteDetail',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $("#hiddenDealerId").val(dealerId);
                    that.RefershHeadData();
                    CheckAddItemsParam();

                    FrameWindow.HideLoading();
                }
            });
        }
    };

    that.CheckForm = function (data) {
        var message = [];
        var reg = '^[0-9]*$';
        if ($.trim(data.IptProductLine.Key) == "") {
            message.push('请选择产品线');
        }
        else if ($.trim(data.IptDealer.Key) == "") {
            message.push('请选择经销商');
        }
        else if ($.trim(data.IptAdjustType) == "") {
            message.push('请选择调整类型');
        }
        else if ($.trim(data.IptAdjustReason) == "") {
            message.push('请填写调整原因');
        }
        //表单数量验证
        var msg1 = ""; var msg2 = ""; var msg3 = ""; var msg4 = ""; var msg5 = "";
        for (var i = 0; i < data.RstDetailList.length; i++) {
            var record = data.RstDetailList[i];
            if (record.AdjustQty <= 0) {
                msg1 = '调整数量不能为0！';
            }
            if (record.LotNumber == "" || record.LotNumber == null) {
                msg2 = '批号/序列号不能为空！';
            }
            if ((record.QRCodeEdit == '' || record.QRCodeEdit == null) && $.trim(data.hiddenAdjustTypeId) == 'StockIn') {
                msg3 = '其他入库操作必须填写二维码';
            }
            if ((record.QRCodeEdit == '' || record.QRCodeEdit == null) && record.QRCode == "NoQR" && $.trim(data.hiddenAdjustTypeId) == 'StockOut') {
                msg4 = '其他出库操作二维码不能为NoQR';
            }
            if (record.QRCodeEdit != null && record.QRCodeEdit != '' && record.AdjustQty > 1) {
                msg5 = '带二维码的产品数量不得大于一';
            }
        }
        if (msg1 != "")
            message.push(msg1);
        if (msg2 != "")
            message.push(msg2);
        if (msg3 != "")
            message.push(msg3);
        if (msg4 != "")
            message.push(msg4);
        if (msg5 != "")
            message.push(msg5);

        return message;

    }

    //添加产品
    that.AddUpn = function () {
        var data = FrameUtil.GetModel();
        var InstanceId = data.InstanceId;
        var hiddenDealerId = $("#hiddenDealerId").val();
        var hiddenProductLineId = $("#hiddenProductLineId").val();
        var hiddenAdjustType = $("#hiddenAdjustTypeId").val();
        var hiddenReturnType = "Consignment";
        if (data.IptProductLine.Key == "" || data.IptAdjustType.Key == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线和调整类型后再添加产品！',
            });
        }
        else if (data.IptDealer.Key == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择经销商',
            });
        }
        else {
            url = Common.AppVirtualPath + 'Revolution/Pages/Inventory/InventoryAdjustListMtrPicker.aspx?InstanceId=' + InstanceId + '&&hiddenDealerId=' + hiddenDealerId + '&&hiddenProductLineId=' + hiddenProductLineId + '&&hiddenAdjustType=' + hiddenAdjustType + '&&hiddenReturnType=' + hiddenReturnType + '&&ChoiceType=1';

            FrameWindow.OpenWindow({
                target: 'top',
                title: '物料选择',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (d) {
                    if (d) {
                        var pickearr = "";
                        var r = d[0];
                        var list = r.res;
                        var data = FrameUtil.GetModel();
                        data.InstanceId = $('#InstanceId').val();
                        data.QryBu = $('#hiddenProductLineId').val();

                        data.hiddenDialogAdjustId = InstanceId;
                        data.hiddenDialogDealerId = hiddenDealerId;
                        data.hiddenDialogAdjustType = hiddenAdjustType;
                        data.hiddenWarehouseType = hiddenReturnType;
                        data.cbWarehouse1 = r.Warehouse;
                        data.cbWarehouse2 = r.Warehouse2;

                        for (var i = 0; i <= list.length - 1; i++) {
                            pickearr += list[i] + ","
                        }
                        data.ProductStrParams = pickearr;

                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'DoAddProductItems',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                that.RefershHeadData();
                                FrameWindow.HideLoading();
                            }
                        });
                    }
                }
            });
        }
    }



    that.EditColumn = function () {
        var dataView = $("#RstDetailList").data("kendoGrid").dataSource.view();
        for (var i = 0; i < dataView.length; i++) {
            var uid = dataView[i].uid;
            for (var j = 0; j < EditColumnArray.length; j++) {
                var editColumn = $($("#RstDetailList tbody").find("tr[data-uid=" + uid + "] td")[EditColumnArray[j]]);
                $(editColumn).addClass("grid-cell-edit");
            }
        }
    };
    function EditColumnArrayIsExists(obj) {
        let x = EditColumnArray.indexOf(obj);
        while (x > -1) {
            EditColumnArray.splice(x, 1)
            x = EditColumnArray.indexOf(obj);
        }
    }

    that.removeButton = function (obj) {
        $('#' + obj + '').empty();
        $('#' + obj + '').removeClass();
        $('#' + obj + '').unbind();
    };

    var setLayout = function () {
    }

    return that;
}();


