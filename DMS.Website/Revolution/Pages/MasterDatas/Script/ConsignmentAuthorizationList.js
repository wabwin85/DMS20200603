var ConsignmentAuthorizationList = {};

ConsignmentAuthorizationList = function () {
    var that = {};

    var business = 'MasterDatas.ConsignmentAuthorizationList';

    var LstDealerArr = [];

    that.Init = function () {
        var data = {};

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstDealerArr = model.LstDealer;
                //产品线
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });
                //经销商
                $('#QryDealer').FrameDropdownList({
                    dataSource: model.LstDealer,
                    dataKey: 'Id',
                    dataValue: 'ChineseShortName',
                    filter: 'contains',
                    selectType: 'all',
                    value: model.QryDealer
                });
                //申请单状态
                $('#QryStatus').FrameDropdownList({
                    //dataSource: model.LstStatus,
                    dataSource: [{ "Key": "1", "Value": "有效" }, { "Key": "0", "Value": "无效" }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryStatus
                });
                //寄售规则
                $('#QryConsignmentRules').FrameDropdownList({
                    dataSource: model.LstConsignmentRules,
                    dataKey: 'CMID',
                    dataValue: 'Name',
                    selectType: 'all',
                    value: model.QryConsignmentRules
                });

                //按钮权限控制
                if (model.InsertEnabled) {
                    $('#BtnNew').FrameButton({
                        text: '添加',
                        icon: 'plus',
                        onClick: function () {
                            openInfo();
                        }
                    });
                }
                else {
                    $('#BtnNew').remove();
                }
                if (model.SearchEnabled) {
                    $('#BtnQuery').FrameButton({
                        text: '查询',
                        icon: 'search',
                        onClick: function () {
                            that.Query();
                        }
                    });
                }
                else {
                    $('#BtnQuery').remove();
                }

                //$("#RstResultList").data("kendoGrid").setOptions({
                //    dataSource: model.RstResultList
                //});

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
                createResultList();
            }
        });
    }

    //that.Query = function () {
    //    var data = FrameUtil.GetModel();
    //    //console.log(data);

    //    FrameWindow.ShowLoading();
    //    FrameUtil.SubmitAjax({
    //        business: business,
    //        method: 'Query',
    //        url: Common.AppHandler,
    //        data: data,
    //        callback: function (model) {
    //            $("#RstResultList").data("kendoGrid").setOptions({
    //                dataSource: model.RstResultList
    //            });

    //            FrameWindow.HideLoading();
    //        }
    //    });
    //}
    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    var fields = {
        StartDate: { type: "date", format: "{0:yyyy/MM/dd}" }, EndDate: { type: "date", format: "{0:yyyy/MM/dd}" }
    };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 15);

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            //dataSource: [],
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "ConsignmentName", title: "短期寄售名称", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "短期寄售名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "经销商", width: '180px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "BrandName", title: "品牌", width: '60px',
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "StartDate", title: "开始时间", width: '100px', type: "date", format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "开始时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EndDate", title: "终止时间", width: '100px', type: "date", format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "终止时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "状态", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    editable: false,
                    template: "#if (IsActive){#" +
                                   '<input type="checkbox" name="personAdmin" id="personAdmin" disabled checked/>' +
                                "#}else{#" +
                                    '<input type="checkbox" name="personAdmin" id="personAdmin" disabled/>' +
                                "#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "明细", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }

            ],
            editable: false,
            pageable: {
                refresh: true,
                pageSizes: false
                //refresh: false,
                //pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    openInfo(data.Id, data.IsActive);
                });
            }
        });
    }

    var openInfo = function (InstanceId, IsActive) {
        $('#submit').empty(); $('#submit').removeAttr("class");
        $('#updateAuthorization').empty(); $('#updateAuthorization').removeAttr("class");
        $('#termination').empty(); $('#termination').removeAttr("class");
        $('#Btnrecovery').empty(); $('#Btnrecovery').removeAttr("class");
        $("#windowLayout").kendoWindow({
            title: "Title",
            width: 450,
            height: 300,
            actions: [
                "Pin",
                "Minimize",
                "Maximize",
                "Close"
            ],
            modal: true,
        }).data("kendoWindow").title("经销商短期寄售申请详情").center().open();
        if (InstanceId) {
            $("#InstanceId").val(InstanceId);
            // var data = FrameUtil.GetModel();
            var data = {};
            data.InstanceId = InstanceId;
            FrameUtil.SubmitAjax({
                business: business,
                method: 'PreviewQuery',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    setWindowsLayout(model, true);
                    FrameWindow.HideLoading();
                }
            });
        } else {
            var data = {};
            FrameUtil.SubmitAjax({
                business: business,
                method: 'LayoutInit',
                url: Common.AppHandler,
                data: {},
                callback: function (model) {
                    setWindowsLayout(model, false);
                    FrameWindow.HideLoading();
                }
            });
        }
    }


    var setWindowsLayout = function (model, readonly) {
        var hidAuthorizationStatus = "";
        //产品线
        if (readonly) {
            //详情数据绑定的产品线、寄售名称实时查询使用的
            var LayoutBu = {};//产品线绑定
            $.each(model.WLstBu, function (index, val) {
                if (model.WRstResultList[0].CA_ProductLine_Id === val.Id)
                    LayoutBu = {
                        Key: val.Id, Value: val.Name
                    };
            })
            var LayoutDealer = {};//经销商绑定
            $.each(LstDealerArr, function (index, val) {
                if (model.WRstResultList[0].CA_DMA_ID === val.Id)
                    LayoutDealer = {
                        Key: val.Id, Value: val.Name
                    };
            })
            var LayoutConsignmentRules = {};//短期寄售名称
            $.each(model.WLstConsignmentRules, function (index, val) {
                if (model.WRstResultList[0].CA_CM_ID === val.Id)
                    LayoutConsignmentRules = {
                        Key: val.Id, Value: val.Name
                    };
            })

            var LayoutStatus = { Key: model.WRstResultList[0].CA_CM_ID, Value: "" };
            var LayoutCA_StartDate = model.WRstResultList[0].CA_StartDate;
            var LayoutCA_EndDate = model.WRstResultList[0].CA_EndDate;
            hidAuthorizationStatus = model.WRstResultList[0].CA_IsActive ? "1" : "0";
        }
        $('#WQryBu').FrameDropdownList({
            dataSource: model.WLstBu,
            dataKey: 'Id',
            dataValue: 'Name',
            selectType: 'none',
            value: LayoutBu,
        })
        // $("#QryDealer_Control").data("kendoDropDownList").value(model.LstDealer[0].Id);
        //经销商
        $('#WQryDealer').FrameDropdownList({
            dataSource: model.WLstDealer,
            dataKey: 'Id',
            dataValue: 'Name',
            selectType: 'none',
            value: LayoutDealer,
            onChange: function (s) {
                that.ProductBind();
            },
        });;
        //申请单状态
        $('#WQryActive').prop("checked", hidAuthorizationStatus == "" ? true : (hidAuthorizationStatus == "1" ? true : false));
        //$('#QryStatus').FrameDropdownList({
        //    dataSource: model.WLstStatus,
        //    dataKey: 'Key',
        //    dataValue: 'Value',
        //    selectType: 'all',
        //    readonly: readonly,
        //    value: LayoutStatus
        //});
        //寄售规则
        $('#WQryConsignmentRules').FrameDropdownList({
            dataSource: model.WLstConsignmentRules,
            dataKey: 'Id',
            dataValue: 'Name',
            selectType: 'none',
            value: LayoutConsignmentRules
        });
        //时间
        var starDP = $("#WQryBeginDate").kendoDatePicker({
            value: LayoutCA_StartDate,
            format: "yyyy-MM-dd",
            depth: "month",
            start: "month",
        }).data("kendoDatePicker");
        //  starDP.element[0].disabled = true;

        //结束日期
        var endDP = $("#WQryEndDate").kendoDatePicker({
            value: LayoutCA_EndDate,
            dateInput: false,
            format: "yyyy-MM-dd",
            depth: "month",
            start: "month",
        }).data("kendoDatePicker");
        //endDP.element[0].disabled = true
        //endDP.element[0].readonly = true;

        $('#WQryBeginDate').data('kendoDatePicker').enable(!readonly);
        $('#WQryEndDate').data('kendoDatePicker').enable(!readonly); //设置是否可用。  
        $("#WQryBu_Control").data("kendoDropDownList").enable(!readonly);
        $("#WQryDealer_Control").data("kendoDropDownList").enable(!readonly)
        $("#WQryConsignmentRules_Control").data("kendoDropDownList").enable(!readonly)
        //状态有效,修改、终止
        if (hidAuthorizationStatus == "1") {
            $("#updateAuthorization").unbind();
            $('#updateAuthorization').FrameButton({
                text: '修改授权',
                icon: 'file',
                onClick: function (e) {
                    that.UpdateopenInfo();
                }
            });
            $("#termination").unbind();
            $('#termination').FrameButton({
                text: '终止',
                icon: 'file',
                onClick: function (e) {
                    that.StopopenInfo();
                }
            });
            $("#Btnrecovery").empty();
            $("#Btnrecovery").removeClass();
            $("#submit").empty();
            $("#submit").removeClass();
        }
        //状态无效，恢复
        if (hidAuthorizationStatus == "0") {
            $("#Btnrecovery").unbind();
            $('#Btnrecovery').FrameButton({
                text: '恢复',
                icon: 'file',
                onClick: function (e) {
                    that.RecoveryopenInfo();
                }
            });
            $("#updateAuthorization").empty();
            $("#updateAuthorization").removeClass();
            $("#termination").empty();
            $("#termination").removeClass();
            $("#submit").empty();
            $("#submit").removeClass();
        }
        //无状态，新增
        if (hidAuthorizationStatus == "") {
            $("#submit").unbind();
            $('#submit').FrameButton({
                text: '提交',
                icon: 'save',
                onClick: function (e) {
                    that.SubmitopenInfo();
                }
            });
            $("#updateAuthorization").empty();
            $("#updateAuthorization").removeClass();
            $("#termination").empty();
            $("#termination").removeClass();
            $("#Btnrecovery").empty();
            $("#Btnrecovery").removeClass();
        }
    }
    //查询经销商对应的产品线
    that.ProductBind = function () {
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'LayoutInitProductBind',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#WQryBu').FrameDropdownList({
                    dataSource: model.WLstBu,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'all',
                    onChange: function (s) {
                        that.ChoiceConsignmenBind();
                    },
                });
                FrameWindow.HideLoading();
            }
        });
    };
    //查询经销商、产品线对应的寄售规则
    that.ChoiceConsignmenBind = function () {
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'LayoutInitChoiceConsignmenBind',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#WQryConsignmentRules').FrameDropdownList({
                    dataSource: model.WLstConsignmentRules,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'all'
                });
                FrameWindow.HideLoading();
            }
        });
    };

    that.CheckForm = function (data) {
        var message = [];
        var reg = '^[0-9]*$';
        if ($.trim(data.WQryDealer.Key) == "") {
            message.push('请选择经销商');
        }
        else if ($.trim(data.WQryBu.Key) == "") {
            message.push('请选择产品线');
        }
        else if ($.trim(data.WQryConsignmentRules.Key) == "") {
            message.push('请选择短期寄售名称');
        }
        else if ($.trim(data.WQryBeginDate) == "") {
            message.push('请填写开始时间');
        }
        else if ($.trim(data.WQryEndDate) == "") {
            message.push('请填写结束时间');
        }
        return message;
    }
    //修改授权
    that.UpdateopenInfo = function () {
        //显示提交按钮，解锁时间选择框
        $('#WQryBeginDate').data('kendoDatePicker').enable(true);
        $('#WQryEndDate').data('kendoDatePicker').enable(true);
        $("#submit").unbind();
        $('#submit').FrameButton({
            text: '提交',
            icon: 'save',
            onClick: function (e) {
                that.SubmitopenInfo();
            }
        });
    };
    //终止
    that.StopopenInfo = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定终止吗？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'Stop',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'Delete',
                            message: '终止成功',
                            callback: function () {
                                $("#windowLayout").data("kendoWindow").close();
                            }
                        });
                        that.Query();
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    };
    //提交
    that.SubmitopenInfo = function () {
        var data = FrameUtil.GetModel();
        data.WQryBeginDate = $("#WQryBeginDate").val();
        data.WQryEndDate = $("#WQryEndDate").val();
        var message = that.CheckForm(data);
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Sumbit',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'Sumbit',
                        message: '提交成功',
                        callback: function () {
                            $("#windowLayout").data("kendoWindow").close();
                        }
                    });
                    that.Query();
                    FrameWindow.HideLoading();
                }
            });
        }
    };
    //恢复
    that.RecoveryopenInfo = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定恢复吗？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'recovery',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'save',
                            message: '恢复成功',
                            callback: function () {
                                $("#windowLayout").data("kendoWindow").close();
                            }
                        });
                        that.Query();
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    };

    var setLayout = function () {
    }

    return that;
}();
