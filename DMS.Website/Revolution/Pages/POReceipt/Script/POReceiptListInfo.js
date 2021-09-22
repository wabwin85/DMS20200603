var POReceiptListInfo = {};

POReceiptListInfo = function () {
    var that = {};

    var business = 'POReceipt.POReceiptListInfo';
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

                createRstOutFlowList(model.RstContractDetail);


                $('#IptApplyBasic').DmsApplyBasic({
                    value: model.IptApplyBasic
                });

                $('#IptSapNumber').FrameLabel({
                    value: model.IptSapNumber,
                    readonly: readonly
                });
                $('#IptStatus').FrameTextBox({
                    value: model.IptStatus,
                    readonly: readonly
                });
                //$('#IptDealer').DmsDealerFilter({
                //    dataSource: [],
                //    delegateBusiness: business,
                //    dataKey: 'DealerId',
                //    dataValue: 'DealerName',
                //    selectType: 'select',
                //    filter: 'contains',
                //    serferFilter: true,
                //    value:model.IptDealer,
                //    readonly: data.QryStatus == "草稿" ? true : readonly
                //});
                $('#IptDealer').FrameLabel({
                    value: model.IptDealer,
                    readonly: readonly

                });
                $('#IptPoNumber').FrameLabel({
                    value: model.IptPoNumber,
                    readonly: readonly

                });
                $('#IptVendor').FrameLabel({
                    value: model.IptVendor,
                    readonly: readonly
                });
                $('#IptSapShipmentDate').FrameLabel({
                    value: model.IptSapShipmentDate,
                    readonly: readonly
                });
                $('#IptFormStatus').FrameLabel({
                    value: model.IptFormStatus,
                    readonly: readonly
                });


                $('#IptCarrier').FrameLabel({
                    value: model.IptCarrier,
                    readonly: readonly

                });
                $('#IptTrackingNo').FrameLabel({
                    value: model.IptTrackingNo,
                    readonly: readonly
                });
                $('#IptShipType').FrameLabel({
                    value: model.IptShipType,
                    readonly: readonly
                });

                $('#IptWarehouse').FrameDropdownList({
                    dataSource: model.LstWarehouse,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    value: { Key: model.IptWhmId, Value: model.IptWarehouse },
                    //onChange: function (s) {
                    //    that.WarehouseChange(this.value);
                    //}
                });
                $('#IptWarehouse').FrameDropdownList('disable');

                $('#IptFromWarehouse').FrameLabel({
                    value: model.IptFromWarehouse,
                    readonly: readonly
                });


                //操作记录绑定
                //$('#RstOperationLog').DmsOperationLog({
                //    dataSource: model.RstLogDetail
                //});

                $('#RstOperationLog').DmsOperationLog({
                    dataSource: model.RstLogDetail
                });
                //确认收货,是否可见
                if (!model.SaveButton) {
                    $('#IptWarehouse').FrameDropdownList('enable');
                    $('#BtnConfirm').FrameButton({
                        text: '确认收货',
                        icon: 'save',
                        onClick: function () {
                            that.BtnConfirm();
                        }
                    });
                }
                else {
                    $('#BtnConfirm').remove();
                }
                //取消收货单，是否可见
                if (!model.CancelButton) {
                    $('#BtnCancleForm').FrameButton({
                        text: '取消收货单',
                        icon: 'recycle',
                        onClick: function () {
                            that.BtnCancleForm();
                        }
                    });
                }
                else {
                    $('#BtnCancleForm').remove();
                }

                $("#RstDetailList").data("kendoGrid").hideColumn('Delete');
                if (model.DealerType == 'LP' || model.DealerType == 'LS') {
                    $("#RstDetailList").data("kendoGrid").showColumn('Delete');
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
            {
                field: "CFN", title: "产品型号", width: '70px',
                headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
            },
            {
                field: "UPN", title: "产品型号", width: '100px', hidden: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品型号" }
            },

            {
                field: "CFNChineseName", title: "产品中文名", width: '80px',
                headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" },
                attributes: { "class": "table-td-cell" }

            },
            {
                field: "CFNEnglishName", title: "产品英文名", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "LotNumber", title: "序列号/批号", width: '80px',
                headerAttributes: { "class": "text-center text-bold", "title": "序列号/批号" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "QRCode", title: "二维码", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "ExpiredDate", title: "有效期", width: '70px',
                headerAttributes: { "class": "text-center text-bold", "title": "二维码" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "UnitOfMeasure", title: "单位", width: '50px',
                headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "ReceiptQty", title: "数量", width: '50px',
                headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "LotDOM", title: "产品生产日期", width: '80px',
                headerAttributes: { "class": "text-center text-bold", "title": "数量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "ERPNbr", title: "ERP主表内码", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "ERP主表内码" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "ERPLineNbr", title: "ERP明细表内码", width: '100px',
                headerAttributes: { "class": "text-center text-bold", "title": "ERP明细表内码" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "ERPAmount", title: "ERP金额", width: '80px',
                headerAttributes: { "class": "text-center text-bold", "title": "ERP金额" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "ERPTaxRate", title: "ERP税率", width: '70px',
                headerAttributes: { "class": "text-center text-bold", "title": "ERP税率" },
                attributes: { "class": "table-td-cell" }
            },
             {
                 title: "批次质检报告(CoA)下载", width: '50px',
                 headerAttributes: { "class": "text-center text-bold", "title": "下载", "style": "vertical-align: middle;" },
                 template: "<i class='fa fa-download' style='font-size: 14px; cursor: pointer;'></i>",
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

                $("#RstDetailList").find(".fa-download").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $.ajax({
                        type: "POST",
                        url: "/Revolution/Pages/POReceipt/POReceiptListInfo.aspx/DownloadPdf",
                        contentType: "application/json;charset=utf-8",
                        data: JSON.stringify({ Lot: data.LotNumber, Property1: data.Property1, Upn: data.UPN }),
                        dataType: "json",
                        success: function (d) {
                            if (d != null || d != undefined) {
                                var res = d.d;
                                if (res.success)
                                    window.location.href = res.data.DownPath;
                                else
                                    FrameWindow.ShowAlert({
                                        target: 'top',
                                        alertType: 'warning',
                                        message: res.msg,
                                    });
                            }
                        },
                        error: function (e) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'warning',
                                message: '访问异常',
                            });
                        }
                    });
                    //$("#RstDetailList").data("kendoGrid").dataSource.remove(data);
                });

            }

        });
    }

    that.BtnCancleForm = function () {

        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定取消收货单吗？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
                data.InstanceId = Common.GetUrlParam('InstanceId');
                data.IptWhmId = (data.IptWarehouse != "" || data.IptWarehouse != null) ? data.IptWarehouse.Key : "";
                data.IptWarehouse = (data.IptWarehouse != "" || data.IptWarehouse != null) ? data.IptWarehouse.Value : "";
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DoCancelYes',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'cancle',
                            message: '取消收货单成功！',
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

    that.BtnConfirm = function () {
        var data = FrameUtil.GetModel();

        var message = that.CheckForm(data);
        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            data.IptWhmId = (data.IptWarehouse != "" || data.IptWarehouse != null) ? data.IptWarehouse.Key : "";
            data.InstanceId = Common.GetUrlParam('InstanceId');
            data.IptWarehouse = (data.IptWarehouse != "" || data.IptWarehouse != null) ? data.IptWarehouse.Value : "";
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DoYes',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '收货成功',
                        callback: function () {
                            //top.changeTabsName(self.frameElement.getAttribute('id'), model.InstanceId, '寄售申请 - ' + '123');

                            //var url = Common.AppVirtualPath + 'Revolution/Pages/Consign/ConsignContractInfo.aspx';
                            //url += '?InstanceId=' + model.InstanceId;
                            top.deleteTabsCurrent();
                            //window.location = url;
                        }
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.CheckForm = function (data) {
        var message = [];
        var reg = '^[0-9]*$';
        if ($.trim(data.IptWarehouse.Key) == '') {
            message.push('请选择收货仓库');
        }
        return message;
    }

    var setLayout = function () {
    }

    return that;
}();
