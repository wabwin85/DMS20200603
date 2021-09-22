var ConsignInventoryAdjustHeaderInfo = {};

ConsignInventoryAdjustHeaderInfo = function () {
    var that = {};

    var business = 'Consign.ConsignInventoryAdjustHeaderInfo';
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

                var readonly = !(data.QryStatus == "草稿" || data.QryStatus == "");
                if (Common.GetUrlParam('Sub') == "Submit") {
                    var readonly = true;
                }
                $('#InstanceId').val(model.InstanceId);
                $('#IsNewApply').val(model.IsNewApply);

                createRstOutFlowList(model.LstInventoryAdjustDetail)

                $('#IptApplyBasic').DmsApplyBasic({
                    value: model.IptApplyBasic
                });
                $('#IptDealer').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    readonly: true,
                    value: model.IptDealer,
                    onChange: that.Dealer
                });

                $('#IptProductLine').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.IptProductLine,
                    readonly: data.QryStatus == "草稿" ? true : readonly,
                    onChange: that.ProductLineChange

                });
                $('#IptType').FrameLabel({
                    value: model.IptType,
                    readonly: readonly

                });


                $('#IptBoSales').FrameDropdownList({
                    dataSource: model.LstBoSales,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'all',
                    filter: "contains",
                    readonly: readonly,
                    value: model.IptBoSales
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
                    if (model.CheckCreateUser == true) {
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
                                that.AddPfroduct();
                            }
                        });

                    }

                }
                else {
                    $('#BtnSubmit').remove();
                    $('#BtnSave').remove();
                    $('#BtnDelete').remove();


                }
                if ((readonly && data.QryStatus != "草稿") || model.IsDealer == false) {
                    $("#RstDetailList").data("kendoGrid").hideColumn('Delete');
                }

                $("#RstDetailList").data("kendoGrid").setOptions({
                    dataSource: model.RstDetailList
                });


                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                $("#RstDetailList").data("kendoGrid").dataSource.fetch();
                FrameWindow.HideLoading();
            }
        });
    }


    var createRstOutFlowList = function (dataSource) {
        $("#RstDetailList").kendoGrid({
            dataSource: {
                data: dataSource,
                aggregate: [
                            //{ field: "LotInvQty", aggregate: "sum" },
                            { field: "RemainFee", aggregate: "sum" }
                ]
            },
            scrollable: true,
            columns: [

            {
                field: "WarehouseName", title: "仓库", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "仓库" }
            },
            {
                field: "UPN", title: "产品型号UPN", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "产品型号UPN" }
            },
            {
                field: "ChineseName", title: "产品中文名", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" }
            },
            {
                field: "PMA_ConvertFactor", title: "产品规格", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "产品规格" }
            },
            {
                field: "LotNumber", title: "批号", width: '80px',
                headerAttributes: { "class": "text-center text-bold", "title": "批号" },
            },
            {
                field: "QRCode", title: "二维码", width: '150px',
                headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
            },
            {
                field: "LotExpiredDate", title: "有效期", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "有效期" }
            },
            {
                field: "UnitOfMeasure", title: "单位", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "单位" }
            },
            {
                field: "LotInvQty", title: "库存数", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "库存数" }
            },
            {
                field: "IAL_LotQty", title: "数量", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                //attributes: { "class": "right" },
                //format: "{0:N2}",
                //footerTemplate: '#: kendo.toString(sum, "N2") #',
                //footerAttributes: { "class": "right" }
            },
            {
                field: "Price", title: "单价", width: '80px',
                headerAttributes: { "class": "text-center text-bold ", "title": "单价" },
            },
            //{
            //    field: "Price", title: "单价", width: '80px',
            //    headerAttributes: { "class": "center bold", "title": "单价" },
            //    template: "<input name='Price' class='Adjust-Fee' />",

            //},
            {
                field: "RemainFee", title: "总金额", width: '80px',
                headerAttributes: { "class": "center bold", "title": "总金额" },
                attributes: { "class": "right" },
                format: "{0:N2}",
                footerTemplate: '#: kendo.toString(sum, "N2") #',
                footerAttributes: { "class": "right" }
            },
             {
                 field: "Delete", title: "删除", width: '50px',
                 headerAttributes: { "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;" },
                 template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                 attributes: { "class": "text-center text-bold" },
             }
            ],
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

                $("#RstDetailList").find("i[name='delete']").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $("#RstDetailList").data("kendoGrid").dataSource.remove(data);
                    $("#RstDetailList").data("kendoGrid").dataSource.fetch();
                });

                $("#RstDetailList").find(".Adjust-Fee").each(function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    data.RemainFee = data.IAL_LotQty * data.Price;
                    $(this).kendoNumericTextBox({
                        value: data.Price,
                        spinners: false,
                        change: function () {
                            var v = this.value() ? this.value() : 0;
                            data.Price = v;
                            data.RemainFee = data.IAL_LotQty * data.Price;
                            $("#RstDetailList").data("kendoGrid").dataSource.fetch();

                        }
                    });
                });

                $("#RstDetailList").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $("#RstDetailList").data("kendoGrid").dataSource.remove(data);
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
            LOTID = [];
            Price = [];
            $("#RstDetailList").data("kendoGrid").dataSource;
            for (var i = 0; i < $("#RstDetailList").data("kendoGrid").dataSource._data.length; i++) {
                LOTID[i] = $("#RstDetailList").data("kendoGrid").dataSource._data[i].LOT_ID
                Price[i] = $("#RstDetailList").data("kendoGrid").dataSource._data[i].Price
            }
            data.IptLOTID = LOTID;
            data.IptPrice = Price;
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Save',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    if (model.CheckBoSales == false) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: "请选择销售",
                        });
                    }
                    else {

                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '保存成功',
                            callback: function () {
                                //top.changeTabsName(self.frameElement.getAttribute('id'), model.InstanceId, '寄售买断 - ' + '123');

                                //var url = Common.AppVirtualPath + 'Revolution/Pages/Consign/ConsignInventoryAdjustHeaderInfo.aspx';
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

    that.Delete = function () {
        var QryStatus = Common.GetUrlParam('Status');
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定删除草稿吗？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();

                if (QryStatus == "") {

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
                else {
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

            }
        });





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
            LOTID = [];
            Price = [];
            $("#RstDetailList").data("kendoGrid").dataSource;
            for (var i = 0; i < $("#RstDetailList").data("kendoGrid").dataSource._data.length; i++) {
                LOTID[i] = $("#RstDetailList").data("kendoGrid").dataSource._data[i].LOT_ID
                Price[i] = $("#RstDetailList").data("kendoGrid").dataSource._data[i].Price
            }
            data.IptLOTID = LOTID;
            data.IptPrice = Price;
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Submit',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    if (model.CheckBoSales == false) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: "请选择销售",
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '提交成功',
                            callback: function () {
                                //top.changeTabsName(self.frameElement.getAttribute('id'), model.InstanceId, '寄售买断 - ' + '123');

                                //var url = Common.AppVirtualPath + 'Revolution/Pages/Consign/ConsignInventoryAdjustHeaderInfo.aspx';
                                //url += '?InstanceId=' + model.InstanceId + '&&Sub=Submit';
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

    that.CheckForm = function (data) {
        var message = [];

        if ($.trim(data.IptProductLine.Key) == "") {
            message.push('请选择产品线');
        }
            //else if ($.trim(data.IptBoSales.Key) == "") {
            //    message.push('请选择销售');
            //}
        else if ($.trim(data.IptDealer.Key) == "") {
            message.push('请选择经销商');
        }
        else if (!PriceMessage()) {
            message.push('请填写产品价格');
        }

        return message;
    }
    function PriceMessage() {
        for (var i = 0; i < $("#RstDetailList").data("kendoGrid").dataSource._data.length; i++) {
            if ($("#RstDetailList").data("kendoGrid").dataSource._data[i].Price == "0.00") {
                return false
            }
        }
        return true;
    }


    that.AddPfroduct = function (Type) {
        var data = that.GetModel();
        if (data.IptProductLine.Key == "" || data.IptDealer.Key == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线和经销商',


            });
        }
        else {
            FrameWindow.OpenWindow({
                target: 'top',
                title: Type,
                url: Common.AppVirtualPath + 'Revolution/Pages/Consign/ConsignInventoryAdjustPicker.aspx?' + 'Bu=' + data.IptProductLine.Key + '&&Dealer=' + data.IptDealer.Key,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (flowList) {
                    if (flowList) {
                        var dataSource = $("#RstDetailList").data("kendoGrid").dataSource.data();

                        for (var i = 0; i < flowList.length; i++) {
                            var exists = false;
                            for (var j = 0; j < dataSource.length; j++) {
                                if (dataSource[j].LOT_ID == flowList[i].LOT_ID) {
                                    exists = true;
                                }
                            }
                            if (!exists) {
                                $("#RstDetailList").data("kendoGrid").dataSource.add(flowList[i]);
                            }
                        }
                        $("#RstDetailList").data("kendoGrid").dataSource.fetch();

                    }

                }
            });
        }
    }

    that.ProductLineChange = function () {

        createRstOutFlowList([]);
        var data = that.GetModel();
        if (data.IptProductLine.Key == "") {
            $('#IptBoSales').FrameDropdownList({
                dataSource: [],
                dataKey: 'Id',
                dataValue: 'Name',
                selectType: 'all',
                filter: "contains",

            });
            $(window).resize(function () {
                setLayout();
            })
            setLayout();


            FrameWindow.HideLoading();
        }
        else {

            FrameUtil.SubmitAjax({
                business: business,
                method: 'BoSalesChange',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    $('#IptBoSales').FrameDropdownList({
                        dataSource: model.LstBoSales,
                        dataKey: 'Id',
                        dataValue: 'Name',
                        selectType: 'all',
                        filter: "contains",
                        value: model.IptBoSales
                    });
                    $(window).resize(function () {
                        setLayout();
                    })
                    setLayout();


                    FrameWindow.HideLoading();
                }
            });
        }
    }



    that.Dealer = function () {

        createRstOutFlowList([]);
    }


    var setLayout = function () {
    }

    return that;
}();
