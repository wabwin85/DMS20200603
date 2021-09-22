var ConsignContractInfo = {};

ConsignContractInfo = function () {
    var that = {};

    var business = 'Consign.ConsignContractInfo';
    var CustomerFaceNbr = [];
    var g = 0;
    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.RstDetailList = $("#RstDetailList").data("kendoGrid").dataSource.data();
        return model;
    }

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
                //var readonly = !((data.QryStatus == "草稿" || data.QryStatus == ""));
                //model.ViewMode == "View"
                if (model.ViewMode == "View" && data.QryStatus != "草稿" && data.QryStatus != "") {
                    var readonly = true;
                }
                else if (model.ViewMode == "View" && data.QryStatus == "") {
                    var readonly = true;
                }
                else {
                    var readonly = false;
                }
                $('#InstanceId').val(model.InstanceId);
                $('#IsNewApply').val(model.IsNewApply);

                createRstOutFlowList(model.RstContractDetail)

             
                $('#IptApplyBasic').DmsApplyBasic({
                    value: model.IptApplyBasic
                });

                $('#IptProductLine').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.IptProductLine,
                    readonly: data.QryStatus == "草稿" ? true : readonly,
                    onChange: that.ProductLineChange

                });


                $('#IptNo').FrameLabel({
                    value: model.IptNo,
                    readonly: readonly
                });
                $('#IptContractName').FrameTextBox({
                    value: model.IptContractName,
                    readonly: readonly
                });
                $('#IptDealer').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.IptDealer,
                    readonly: data.QryStatus == "草稿" ? true : readonly
                });

                $('#IptStatus').FrameLabel({
                    value: model.IptStatus,
                    readonly: readonly

                });
                $('#IptConsignmentDay').FrameTextBox({
                    value: model.IptConsignmentDay,
                    readonly: readonly,
                    onChange: that.CheckInt
                });
                $('#IptIsFixedMoney').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.IptIsFixedMoney,
                    readonly: readonly
                });
                $('#IptDelayNumber').FrameTextBox({
                    value: model.IptDelayNumber,
                    readonly: readonly,
                    onChange: that.CheckInt
                });
                $('#IptIsFixedQty').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.IptIsFixedQty,
                    readonly: readonly
                });
                $('#IptIsKB').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.IptIsKB,
                    readonly: readonly
                });
                $('#IptContractDate').FrameDatePickerRange({
                    value: model.IptContractDate,
                    readonly: readonly
                });
                $('#IptIsUseDiscount').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.IptIsUseDiscount,
                    readonly: readonly
                });
                $('#IptRemark').FrameTextArea({
                    value: model.IptRemark,
                    readonly: readonly
                });

                if (!model.IsNewApply) {
                    $('#RstOperationLog').DmsOperationLog({
                        dataSource: model.RstOperationLog
                    });
                }

                if (data.QryStatus == "草稿" || !readonly) {
                    if (model.IsDealer == false && model.CheckCreateUser==true) {
                        $('#BtnSave').FrameButton({
                            text: '保存',
                            icon: 'save',
                            onClick: function () {
                                that.Save();
                            }
                        });
                        $('#BtnDelete').FrameButton({
                            text: '删除',
                            icon: 'save',
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
                        $('#BtnAddUpn').FrameButton({
                            text: '添加产品',
                            icon: 'search',
                            onClick: function () {
                                that.AddUpn();
                            }
                        });
                    }
                    
                    //$('#BtnAddSet').FrameButton({
                    //    text: '添加组套',
                    //    icon: 'plus',
                    //    onClick: function () {
                    //        that.AddUpn("组套");
                    //    }
                    //});

                }
                else {

                    $('#BtnSubmit').remove();
                    $('#BtnSave').remove();
                    $('#BtnDelete').remove();

                }

                if ((readonly && data.QryStatus != "草稿") || model.IsDealer == true || model.CheckCreateUser == false) {
                    $("#RstDetailList").data("kendoGrid").hideColumn('Delete');
                }
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
            //height: 300,
            columns: [


            //{
            //    field: "CFN_CustomerFaceNbr", title: "产品UPN", width: '100px',
            //    headerAttributes: { "class": "text-center text-bold", "title": "产品UPN" }
            //},
            {
                field: "CFN_Property1", title: "产品短编号", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "产品短编号" }
            },
            //{
            //    field: "CFN_ChineseName", title: "中文名", width: '100px',
            //    headerAttributes: { "class": "text-center text-bold", "title": "中文名" }
            //},
            {
                field: "PMA_ConvertFactor", title: "规格", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "规格" }
            },
            {
                field: "CFN_Property3", title: "单位", width: '80px',
                headerAttributes: { "class": "text-center text-bold", "title": "单位" },

            },
            {
                field: "Type", title: "类型", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "类型" }
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

                $("#RstDetailList").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $("#RstDetailList").data("kendoGrid").dataSource.remove(data);
                });
                
            }
        });
    }


    that.Delete = function () {

        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定删除草稿吗？',
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
            CFN_Property1 = [];
            Type = [];
            $("#RstDetailList").data("kendoGrid").dataSource;
            for (var i = 0; i < $("#RstDetailList").data("kendoGrid").dataSource._data.length; i++) {
                CFN_Property1[i] = $("#RstDetailList").data("kendoGrid").dataSource._data[i].CFN_Property1
                Type[i] = $("#RstDetailList").data("kendoGrid").dataSource._data[i].Type
            }
            data.IptCFN_Property1 = CFN_Property1;
            data.IptType = Type;
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Save',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.UPNCheck != '') {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: model.UPNCheck,

                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '保存成功',
                            callback: function () {
                                //top.changeTabsName(self.frameElement.getAttribute('id'), model.InstanceId, '寄售申请 - ' + '123');

                                //var url = Common.AppVirtualPath + 'Revolution/Pages/Consign/ConsignContractInfo.aspx';
                                //url += '?InstanceId=' + model.InstanceId;
                                top.deleteTabsCurrent();
                                //window.location = url;
                            }
                        });

                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.Submit = function () {
        //('#IptCustomerFaceNbr').val(CustomerFaceNbr)
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
            CFN_Property1 = [];
            Type = [];
            $("#RstDetailList").data("kendoGrid").dataSource;
            for (var i = 0; i < $("#RstDetailList").data("kendoGrid").dataSource._data.length; i++) {
                CFN_Property1[i] = $("#RstDetailList").data("kendoGrid").dataSource._data[i].CFN_Property1
                Type[i] = $("#RstDetailList").data("kendoGrid").dataSource._data[i].Type
            }

            data.IptCFN_Property1 = CFN_Property1;
            data.IptType = Type;
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Submit',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    if (model.UPNCheck != '') {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: model.UPNCheck,
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '提交成功',
                            callback: function () {
                                //top.changeTabsName(self.frameElement.getAttribute('id'), model.InstanceId, '寄售申请 - ' + '123');
                                //var url = Common.AppVirtualPath + 'Revolution/Pages/Consign/ConsignContractInfo.aspx';
                                //url += '?InstanceId=' + model.InstanceId;
                                //window.location = url;
                                top.deleteTabsCurrent();
                            }
                        });

                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.CheckForm = function (data) {
        var message = [];
        var reg = '^[0-9]*$';
        if ($.trim(data.IptProductLine.Key) == "") {
            message.push('请选择产品线');
        }
        else if ($.trim(data.IptDealer.Key) == "") {
            message.push('请选择经销商');
        }
        else if ($.trim(data.IptContractName) == "") {
            message.push('请填写合同名称');
        }
        else if ($.trim(data.IptConsignmentDay) == "") {
            message.push('请填写寄售天数');
        }
        else if ($.trim(data.IptDelayNumber) == "") {
            message.push('请填写可延迟次数');
        }
        else if ($.trim(data.IptContractDate.StartDate) == "" || data.IptContractDate.EndDate == "") {
            message.push('请选择合同时间');
        }



        return message;
    }

    that.AddUpn = function () {
        var data = FrameUtil.GetModel();
        if (data.IptProductLine.Key == "" || data.IptDealer.Key == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线和经销商',


            });
        }
        else {

            url = Common.AppVirtualPath + 'Revolution/Pages/Consign/ConsignUpnPicker.aspx?' + 'Bu=' + data.IptProductLine.Key + '&&Dealer=' + data.IptDealer.Key,

            FrameWindow.OpenWindow({
                target: 'top',
                title: '产品UPN/组套',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (list) {
                    if (list) {
                        var data = {};
                        data.IptProductLine = $('#IptProductLine').FrameDropdownList('getValue');
                        data.IptDealer = $('#IptDealer').FrameDropdownList('getValue');
                        data.LstUpn = list.UpnList;
                        data.LstSet = list.SetList;

                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'AddDetail',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                var dataSource = $("#RstDetailList").data("kendoGrid").dataSource.data();

                                for (var i = 0; i < model.LstContractDetail.length; i++) {
                                    var exists = false;
                                    for (var j = 0; j < dataSource.length; j++) {
                                        if (dataSource[j].CFN_Property1 == model.LstContractDetail[i].CFN_Property1) {
                                            exists = true;
                                        }
                                    }

                                    if (!exists) {
                                        $("#RstDetailList").data("kendoGrid").dataSource.add(model.LstContractDetail[i]);
                                    }
                                }
                                //$("#RstDetailList").data("kendoGrid").dataSource.fetch();
                                $("#RstDetailList").data("kendoGrid").setOptions({
                                    dataSource: $("#RstDetailList").data("kendoGrid").dataSource
                                });
                                FrameWindow.HideLoading();
                            }
                        });
                    }
                }
            });
        }
    }



    that.ProductLineChange = function () {

        createRstOutFlowList([]);

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
