var ConsignmentMasterListInfo = {};

ConsignmentMasterListInfo = function () {
    var that = {};

    var business = 'MasterDatas.ConsignmentMasterListInfo';
    var CustomerFaceNbr = [];
    var g = 0;
    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.RstDetailList = $("#RstDetailList").data("kendoGrid").dataSource.data();
        return model;
    }
    var EntityModel = {};
    var OrderStatus = "";
    var LstBuArr = [];

    that.Init = function () {
        var data = {};

        data.InstanceId = Common.GetUrlParam('InstanceId');
        data.QryStatus = Common.GetUrlParam('Status');

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                EntityModel = JSON.parse(model.EntityModel);
                OrderStatus = EntityModel.OrderStatus;//订单状态
                LstBuArr = model.LstBu;
                //$("#hidDealerId").val(model.DealerId);
                $("#hidOrderType").val(EntityModel.OrderType);
                $("#hidLatestAuditDate").val(EntityModel.UpdateDate);
                $('#InstanceId').val(model.InstanceId);
                $('#IsNewApply').val(model.IsNewApply);
                if (model.IsNewApply) {
                    //新增
                    if (model.LstBu != null) {
                        $('#ProductLineId').val(model.LstBu[0].Key); //默认第一列
                        EntityModel.ProductLineId = model.LstBu[0].Key;
                    }
                }
                else {
                    $('#ProductLineId').val(EntityModel.ProductLineId);
                }
                //近效期规则
                var temp = "";
                $.each(model.LstType, function (index, val) {
                    if (EntityModel.OrderType === val.Key)
                        temp = val.Value;
                })
                $('#QryApplyType').FrameDropdownList({
                    dataSource: model.LstType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: { Key: EntityModel.OrderType, Value: temp }
                });

                //产品线
                $.each(model.LstBu, function (index, val) {
                    if (EntityModel.ProductLineId === val.Key)
                        temp = val.Value;
                })
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: { Key: EntityModel.ProductLineId, Value: temp },
                    onChange: function (s) {
                        that.ProductLineChange(this.value);
                    }
                });
                //提交时间
                $('#QrySubmitDate').FrameTextBox({
                    value: EntityModel.CreateDate,
                });
                //规则单据号
                $('#QryOrderNo').FrameTextBox({
                    value: EntityModel.OrderNo,
                });
                //单据状态
                $.each(model.LstStatus, function (index, val) {
                    if (EntityModel.OrderStatus === val.Key)
                        temp = val.Value;
                })
                $('#QryOrderStatus').FrameTextBox({
                    value: temp,
                });


                //申请单主信息    
                $('#QryRuleName').FrameTextBox({
                    value: EntityModel.ConsignmentName,
                });
                $('#QryCustomRuleDays').FrameTextBox({
                    value: '',
                });

                var LstRuleArr = [];
                LstRuleArr.push({ Key: "15", Value: "15天" });
                LstRuleArr.push({ Key: "30", Value: "30天" });
                LstRuleArr.push({ Key: "0", Value: "自定义天数" });
                $('#QryRuleDays').FrameDropdownList({
                    dataSource: LstRuleArr,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    onChange: function (s) {
                        if (this.value == "0") {
                            $("#QryCustomRuleDays").parent().parent().show();
                            $('#QryCustomRuleDays').FrameTextBox({
                                value: "",
                            });
                        }
                        else
                            $("#QryCustomRuleDays").parent().parent().hide();
                    },
                });

                if (EntityModel.ConsignmentDay != "" && EntityModel.ConsignmentDay != null) {
                    if (EntityModel.ConsignmentDay != 15 && EntityModel.ConsignmentDay != 30) {
                        $("#QryCustomRuleDays").parent().parent().show();
                        $('#QryCustomRuleDays').FrameTextBox('setValue', EntityModel.ConsignmentDay);

                        $('#QryRuleDays').FrameDropdownList('setValue', { Key: "0", Value: "自定义天数" });
                    }
                    else {
                        $('#QryRuleDays').FrameDropdownList('setValue', { Key: EntityModel.ConsignmentDay, Value: EntityModel.ConsignmentDay + "天" });
                    }
                }
                else {
                    $("#QryCustomRuleDays").parent().parent().hide();
                }

                //备注
                $('#QryRemark').FrameTextArea({
                    value: EntityModel.Remark,
                });
                //时间
                $('#QryBeginDate').FrameDatePickerRange({
                    value: { EndDate: EntityModel.EndDate, StartDate: EntityModel.StartDate },
                    format: "yyyy-MM-dd",
                });
                //可延期次数
                $('#QryDelayTimes').FrameTextBox({
                    value: EntityModel.DelayTime,
                });


                //绑定经销商。产品明细 。操作日志等
                createRstDealerList(model.RstDealerList)
                createRstProductDetail(model.RstProductDetail);
                //if (!model.IsNewApply) {
                $('#RstOperationLog').DmsOperationLog({
                    dataSource: model.RstLogDetail
                });
                // }

                //按钮权限控制

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
                        that.DeleteDraft();
                    }
                });
                $('#BtnSubmit').FrameButton({
                    text: '提交申请',
                    icon: 'send',
                    onClick: function () {
                        that.Submit();
                    }
                });
                $('#BtnRevoke').FrameButton({
                    text: '撤销',
                    icon: 'reply',
                    onClick: function () {
                        that.Revoke();
                    }
                });

                //经销商添加
                $('#BtnDealerAdd').FrameButton({
                    text: '添加',
                    icon: 'plus',
                    onClick: function () {
                        that.BtnDealerAdd();
                    }
                });
                //产品明细
                $('#BtnAddProduct').FrameButton({
                    text: '添加产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddProduct();
                    }
                });
                $('#BtnAddComProduct').FrameButton({
                    text: '添加成套产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddUpn();
                    }
                });

                that.InitDetailWindow()
                that.InitSetDetailWindow(EntityModel.OrderStatus);


                $(window).resize(function () {
                    setLayout();
                })
                setLayout();


                FrameWindow.HideLoading();
            }
        });
    }

    that.InitDetailWindow = function () {
        $('#QrySubmitDate').FrameTextBox('disable');
        $('#QryOrderNo').FrameTextBox('disable');
        $('#QryOrderStatus').FrameTextBox('disable');

        $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;//不可修改金额
        $("#RstProductDetail").data("kendoGrid").columns[5].editable = true;
        $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');
        $("#RstDealerList").data("kendoGrid").hideColumn('Delete');
    }

    that.InitSetDetailWindow = function (Status) {
        //如果单据状态是“草稿”，则可以修改
        if (Status == "Draft") {
            that.removeButton("BtnRevoke");
            $('#QryDelayTimes').FrameTextBox('enable');
            $("#RstProductDetail").data("kendoGrid").columns[4].editable = false;//修改金额
            $("#RstProductDetail").data("kendoGrid").showColumn('Delete');
            $("#RstDealerList").data("kendoGrid").showColumn('Delete');
            $('#QryBeginDate').FrameDatePickerRange('enable');
            $('#QryRuleName').FrameTextBox('enable');
            $('#QryCustomRuleDays').FrameTextBox('enable');
            $('#QryRemark').FrameTextArea('enable');
            $('#QryRuleDays').FrameDropdownList('enable');
        }
        else if (Status == "Submit") {
            $('#QryDelayTimes').FrameTextBox('disable');
            $("#RstProductDetail").data("kendoGrid").columns[4].editable = false;//修改金额
            $("#RstProductDetail").data("kendoGrid").showColumn('Delete');
            $("#RstDealerList").data("kendoGrid").showColumn('Delete');
            $('#QryBu').FrameDropdownList('disable');
            $('#QryApplyType').FrameDropdownList('disable');

            $('#QryRemark').FrameTextArea('disable');
            that.removeButton("BtnSave");
            that.removeButton("BtnDelete");
            that.removeButton("BtnSubmit");
            $('#QryBeginDate').FrameDatePickerRange('disable');
            $('#QryRuleName').FrameTextBox('disable');
            $('#QryCustomRuleDays').FrameTextBox('disable');
            $('#QryRemark').FrameTextArea('disable');
            $('#QryRuleDays').FrameDropdownList('disable');
        }
        else if (Status == 'Cancel') {
            $('#QryDelayTimes').FrameTextBox('disable');
            $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;
            $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');
            $("#RstDealerList").data("kendoGrid").hideColumn('Delete');
            $('#QryBu').FrameDropdownList('disable');
            $('#QryApplyType').FrameDropdownList('disable');

            that.removeButton("BtnSave");
            that.removeButton("BtnDelete");
            that.removeButton("BtnSubmit");
            $('#QryBeginDate').FrameDatePickerRange('disable');
            $('#QryRuleName').FrameTextBox('disable');
            $('#QryCustomRuleDays').FrameTextBox('disable');
            $('#QryRemark').FrameTextArea('disable');
            that.removeButton("BtnRevoke");
            $('#QryRuleDays').FrameDropdownList('disable');

            $('#BtnDealerAdd').FrameButton('disable');
            $('#BtnAddProduct').FrameButton('disable');
            $('#BtnAddComProduct').FrameButton('disable');
        }
        that.SwitchSetAddCfnSetBtnHidden(Status);
    }
    that.SwitchSetAddCfnSetBtnHidden = function (Status) {
        if (Status == "Draft") {
            $("#RstProductDetail").data("kendoGrid").columns[4].editable = false;
            $("#RstProductDetail").data("kendoGrid").showColumn('Delete');
            $("#RstDealerList").data("kendoGrid").showColumn('Delete');
        }
        else {
            if (Status == "Submit") {
                $("#RstProductDetail").data("kendoGrid").columns[4].editable = false;
                $("#RstProductDetail").data("kendoGrid").showColumn('Delete');
                $("#RstDealerList").data("kendoGrid").showColumn('Delete');
            }

            if (Status == "Cancel") {
                $("#RstProductDetail").data("kendoGrid").columns[4].editable = true;//禁止编辑
                $("#RstProductDetail").data("kendoGrid").hideColumn('Delete');
                $("#RstDealerList").data("kendoGrid").hideColumn('Delete');
            }
        }
    }

    var createRstDealerList = function (dataSource) {
        $("#RstDealerList").kendoGrid({
            dataSource: {
                data: dataSource,
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            //height: 300,
            columns: [
            {
                field: "Name", title: "中文名", width: 'auto',
                headerAttributes: { "class": "text-center text-bold", "title": "中文名" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "SAPCode", title: "ERP账号", width: '150px',
                headerAttributes: { "class": "text-center text-bold", "title": "ERP账号" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "DealerType", title: "经销商类型", width: '150',
                headerAttributes: { "class": "text-center text-bold", "title": "经销商类型" },
                attributes: { "class": "table-td-cell" }
            },
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
                //$("#RstDetailList").find("i[name='delete']").bind('click', function () {
                //    var tr = $(this).closest("tr")
                //    var data = grid.dataItem(tr);
                //    $("#RstDetailList").data("kendoGrid").dataSource.remove(data);
                //    $("#RstDetailList").data("kendoGrid").dataSource.fetch();
                //});

                $("#RstDealerList").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $("#RstDealerList").data("kendoGrid").dataSource.remove(data);
                    that.DeleteDealerItem(data.Id);
                });

            }
        });
    }


    var createRstProductDetail = function (dataSource) {
        $("#RstProductDetail").kendoGrid({
            dataSource: {
                data: dataSource,
                schema: {
                    model: {
                        fields: {
                            RequiredQty: { type: "number", validation: { required: true, format: "{0:n0}", min: 1 } }
                        }
                    },
                },
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            //height: 300,
            columns: [
            {
                field: "CustomerFaceNbr", title: "产品型号", width: '120px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "ShortName", title: "产品编码", width: '130px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品编码" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "CfnEnglishName", title: "产品英文名", width: 'auto', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "CfnChineseName", title: "产品中文名", width: '150px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "RequiredQty", title: "订购数量", width: '80px', editable: false,
                headerAttributes: { "class": "text-center text-bold", "title": "订购数量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "UOM", title: "单位", width: '50px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "Remark", title: "备注", width: '60px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "备注" },
                attributes: { "class": "table-td-cell" }
            },
             {
                 field: "Delete", title: "删除", width: '50px', editable: true,
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

                $("#RstProductDetail").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $("#RstProductDetail").data("kendoGrid").dataSource.remove(data);
                    that.DeletePlineItem(data.Id);
                });

            }
        });

        var grid = $("#RstProductDetail").data("kendoGrid");
        grid.bind("save", grid_save);
        function grid_save(e) {
            that.UpdateItem(e);
        }
    }


    that.Delete = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确认要添加选中的经销商吗？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'Delete',
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
    }

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

    //撤销操作
    that.Revoke = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定要执行此操作？',
            confirmCallback: function () {
                var data = {};
                var param = FrameUtil.GetModel();
                data.InstanceId = param.InstanceId;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'Revoke',
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
        var data = FrameUtil.GetModel();
        var message = [];
        //var message = that.CheckForm(data);
        if (isNaN(data.QryCustomRuleDays)) {
            message.push("寄售天数不合法");
        }
        if (isNaN(data.QryDelayTimes)) {
            message.push("可延期次数不合法");
        }
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            EntityModel.InstanceId = data.InstanceId;
            EntityModel.ProductLineId = data.ProductLineId;
            EntityModel.OrderType = data.QryApplyType.Key
            EntityModel.Remark = data.QryRemark;
            EntityModel.ConsignmentName = data.QryRuleName;
            if (data.QryRuleDays.Key == "0") {
                EntityModel.ConsignmentDay = data.QryCustomRuleDays;
            } else {
                if (data.QryRuleDays.Key == "15")
                    EntityModel.ConsignmentDay = "15";
                if (data.QryRuleDays.Key == "30")
                    EntityModel.ConsignmentDay = "30";
            }
            EntityModel.DelayTime = data.QryDelayTimes;
            EntityModel.StartDate = data.QryBeginDate.StartDate;
            EntityModel.EndDate = data.QryBeginDate.EndDate;
            data = {};
            data.EntityModel = JSON.stringify(EntityModel);
            //data.EntityModel.push(EntityModel);

            FrameWindow.ShowLoading();
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
    }

    that.Submit = function () {
        var param = FrameUtil.GetModel();
        var message = that.CheckForm(param);
        if (isNaN(param.QryCustomRuleDays)) {
            message.push("寄售天数不合法");
        }
        if (isNaN(param.QryDelayTimes)) {
            message.push("可延期次数不合法");
        }
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            EntityModel.InstanceId = param.InstanceId;
            EntityModel.ProductLineId = param.ProductLineId;
            EntityModel.OrderType = param.QryApplyType.Key
            EntityModel.Remark = param.QryRemark;
            EntityModel.ConsignmentName = param.QryRuleName;
            if (param.QryRuleDays.Key == "0") {
                EntityModel.ConsignmentDay = param.QryCustomRuleDays;
            } else {
                if (param.QryRuleDays.Key == "15")
                    EntityModel.ConsignmentDay = param.QryRuleDays.Key;
                if (param.QryRuleDays.Key == "30")
                    EntityModel.ConsignmentDay = param.QryRuleDays.Key
            }
            EntityModel.DelayTime = param.QryDelayTimes;
            EntityModel.StartDate = param.QryBeginDate.StartDate;
            EntityModel.EndDate = param.QryBeginDate.EndDate;
            data = {};
            data.InstanceId = param.InstanceId;
            data.EntityModel = JSON.stringify(EntityModel);
            data.QryBu = param.QryBu.Key;
            data.QryConsignmentName = param.QryRuleName;

            FrameWindow.ShowConfirm({
                target: 'top',
                message: '确定要执行此操作?',
                confirmCallback: function () {
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'CheckedSubmit',
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
                                if (model.hidRtnVal == "Success") {
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
                                                    message: '提交成功',
                                                    callback: function () {
                                                        top.deleteTabsCurrent();
                                                    }
                                                });

                                            }
                                            FrameWindow.HideLoading();
                                        }
                                    });
                                }
                                else if (model.hidRtnVal == "Error") {
                                    FrameWindow.ShowAlert({
                                        target: 'top',
                                        alertType: 'error',
                                        message: model.hidRtnMsg,
                                    });
                                }
                            }
                            FrameWindow.HideLoading();
                        }
                    });
                }
            });
        }
    }

    that.CheckForm = function (data) {
        var message = [];
        var reg = '^[0-9]*$';
        if ($.trim(data.ProductLineId) == "") {
            message.push('请选择产品线');
        }
        else if ($.trim(data.QryApplyType.Key) == "") {
            message.push('请选择近效期规则');
        }
        else if ($.trim(data.QryRuleName) == "") {
            message.push('请填写寄售规则名称');
        }
        else if ($.trim(data.QryRuleDays.Key) == "") {
            message.push('请选择寄售天数');
        }
        else if ($.trim(data.QryRuleDays.Key) == "0") {
            if ($.trim(data.QryCustomRuleDays) == "") {
                message.push('请填写寄售天数');
            }
            if (parseFloat(data.QryCustomRuleDays) <= 0) {
                message.push('寄售天数必须大于0');
            }
        }
        else if ($.trim(data.QryDelayTimes) == "") {
            message.push('请填写可延迟次数');
        }
        else if ($.trim(data.QryBeginDate.StartDate) == "" || data.QryBeginDate.EndDate == "") {
            message.push('请选择时间');
        }
        else if ($.trim(data.QryBeginDate.StartDate) != "" || data.QryBeginDate.EndDate != "") {
            if (new Date(data.QryBeginDate.StartDate) > new Date(data.QryBeginDate.EndDate)) {
                message.push('结束时间不能小于开始时间');
            }
        }
        return message;
    }

    //添加经销商
    that.BtnDealerAdd = function () {
        var data = FrameUtil.GetModel();
        var IptProductLine = $('#ProductLineId').val();
        var FormId = $('#InstanceId').val();
        if (IptProductLine == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线',
            });
        }
        else {
            url = Common.AppVirtualPath + 'Revolution/Pages/MasterDatas/ConsignmentMasterDealerPicker.aspx?' + 'Bu=' + IptProductLine + '&&InstanceId=' + FormId,
            FrameWindow.OpenWindow({
                target: 'top',
                title: '明细',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (list) {
                    if (list) {
                        var data = {}; var pickearr = "";
                        data.InstanceId = $('#InstanceId').val();
                        for (var i = 0; i <= list.length - 1; i++) {
                            pickearr += list[i] + ","
                        }
                        data.DealerParams = pickearr;

                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'DoAddItems',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                var dataSource = $("#RstDealerList").data("kendoGrid").dataSource.data();

                                for (var i = 0; i < model.RstDealerList.length; i++) {
                                    var exists = false;
                                    for (var j = 0; j < dataSource.length; j++) {
                                        if (dataSource[j].Id == model.RstDealerList[i].Id) {
                                            exists = true;
                                        }
                                    }

                                    if (!exists) {
                                        $("#RstDealerList").data("kendoGrid").dataSource.add(model.RstDealerList[i]);
                                    }
                                }
                                //$("#RstDetailList").data("kendoGrid").dataSource.fetch();
                                $("#RstDealerList").data("kendoGrid").setOptions({
                                    dataSource: $("#RstDealerList").data("kendoGrid").dataSource
                                });
                                FrameWindow.HideLoading();
                            }
                        });
                    }
                }
            });
        }
    }
    //添加产品
    that.AddProduct = function () {
        var data = FrameUtil.GetModel();
        var IptProductLine = $('#ProductLineId').val();
        var FormId = $('#InstanceId').val();

        if (IptProductLine == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线',
            });
        }
        else {
            url = Common.AppVirtualPath + 'Revolution/Pages/MasterDatas/ConsignmentMasterUpnPicker.aspx?' + 'Bu=' + IptProductLine + '&&InstanceId=' + FormId,

            FrameWindow.OpenWindow({
                target: 'top',
                title: '添加产品',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (list) {
                    if (list) {
                        var data = {}; var pickearr = "";
                        data.InstanceId = $('#InstanceId').val();
                        data.QryBu = $('#ProductLineId').val();
                        for (var i = 0; i <= list.length - 1; i++) {
                            pickearr += list[i] + ","
                        }
                        data.DealerParams = pickearr;

                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'DoAddProductItems',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                var dataSource = $("#RstProductDetail").data("kendoGrid").dataSource.data();

                                for (var i = 0; i < model.RstProductDetail.length; i++) {
                                    var exists = false;
                                    for (var j = 0; j < dataSource.length; j++) {
                                        if (dataSource[j].Id == model.RstProductDetail[i].Id) {
                                            exists = true;
                                        }
                                    }

                                    if (!exists) {
                                        $("#RstProductDetail").data("kendoGrid").dataSource.add(model.RstProductDetail[i]);
                                    }
                                }
                                //$("#RstDetailList").data("kendoGrid").dataSource.fetch();
                                $("#RstProductDetail").data("kendoGrid").setOptions({
                                    dataSource: $("#RstProductDetail").data("kendoGrid").dataSource
                                });
                                FrameWindow.HideLoading();
                            }
                        });
                    }
                }
            });
        }
    }
    //添加组产品
    that.AddUpn = function () {
        var data = FrameUtil.GetModel();
        var IptProductLine = $('#ProductLineId').val();
        var FormId = $('#InstanceId').val();
        var OrderType = "";
        var IptDealer = "";
        if (IptProductLine == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线',
            });
        }
        else {
            url = Common.AppVirtualPath + 'Revolution/Pages/MasterDatas/ConsignmentMasterSetUpnPicker.aspx?' + 'Bu=' + IptProductLine + '&&Dealer=' + IptDealer + '&&HeaderId=' + FormId + '&&OrderTypeId=' + OrderType,
            FrameWindow.OpenWindow({
                target: 'top',
                title: '添加成套产品',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (list) {
                    if (list) {
                        var data = {};
                        var data = {}; var pickearr = "";
                        data.InstanceId = $('#InstanceId').val();
                        for (var i = 0; i <= list.length - 1; i++) {
                            pickearr += list[i] + ","
                        }
                        data.DealerParams = pickearr;

                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'DoAddCfnSet',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                var dataSource = $("#RstProductDetail").data("kendoGrid").dataSource.data();

                                for (var i = 0; i < model.RstProductDetail.length; i++) {
                                    var exists = false;
                                    for (var j = 0; j < dataSource.length; j++) {
                                        if (dataSource[j].Id == model.RstProductDetail[i].Id) {
                                            exists = true;
                                        }
                                    }
                                    if (!exists) {
                                        $("#RstProductDetail").data("kendoGrid").dataSource.add(model.RstProductDetail[i]);
                                    }
                                }
                                //$("#RstDetailList").data("kendoGrid").dataSource.fetch();
                                $("#RstProductDetail").data("kendoGrid").setOptions({
                                    dataSource: $("#RstProductDetail").data("kendoGrid").dataSource
                                });
                                FrameWindow.HideLoading();
                            }
                        });
                    }
                }
            });
        }
    }
    //刷新数据
    that.RefershHeadData = function () {
        var data = {};
        var parm = FrameUtil.GetModel();
        data.InstanceId = parm.InstanceId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'RefershHeadData',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstProductDetail").data("kendoGrid").setOptions({
                    dataSource: model.RstProductDetail
                });
                $("#RstDealerList").data("kendoGrid").setOptions({
                    dataSource: model.RstDealerList
                });
                FrameWindow.HideLoading();
            }
        });
    }

    that.ProductLineChange = function (obj) {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '产品线发送改变，将删除产品和原有销售？',
            confirmCallback: function () {
                $('#ProductLineId').val(obj);
                //createRstDealerList([]);
                //createRstProductDetail([]);

                var data = {};
                var parm = FrameUtil.GetModel();
                data.InstanceId = parm.InstanceId;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'ChangeProductLine',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        that.RefershHeadData();
                    }
                });
            },
            cancelCallback: function () {
                var Bu = '';
                $.each(LstBuArr, function (index, val) {
                    if ($('#ProductLineId').val() === val.Key)
                        Bu = {
                            Key: $('#ProductLineId').val(), Value: val.Value
                        };
                })
                $('#QryBu').FrameDropdownList('setValue', Bu);
            }
        });

    }

    that.DeleteDealerItem = function (dealerId) {
        var data = {};
        data.DealerItemId = dealerId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
            }
        });
    };

    that.DeletePlineItem = function (PlineItemId) {
        var data = {};
        data.PlineItemId = PlineItemId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeletePlineItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
            }
        });
    }

    //明细订购数单元格保存，无法采用统一保存；因为在提交之后仍可以修改，只能单元格单独提交
    that.UpdateItem = function (e) {
        var data = {};
        data.PlineItemId = e.model.Id;
        if (e.values.RequiredQty) {
            data.RequiredQty = e.values.RequiredQty;
        }
        else {
            data.RequiredQty = e.model.RequiredQty
        }
        if (isNaN(data.RequiredQty)) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: "数字框输入不合法",
            });
            return;
        }
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'UpdateItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                that.RefershHeadData();
                FrameWindow.HideLoading();
            }
        });
    };


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

    that.removeButton = function (obj) {
        $('#' + obj + '').empty();
        $('#' + obj + '').removeClass();
        $('#' + obj + '').unbind();
    };

    var setLayout = function () {
    }

    return that;
}();
