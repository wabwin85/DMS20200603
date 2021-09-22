var ConsignCountManage = {};

ConsignCountManage = function () {
    var that = {};

    var business = 'Consign.ConsignCountManage';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        if (model.AddAmount == "") {
            model.AddAmount = null;
        }
        if (model.AddTotal == "") {
            model.AddTotal = null;
        }
        return model;
    }

    that.Init = function () {
        var data = {};
        createResultList();
        
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                
                $('#QryDealer').FrameTextBox({
                    value: model.QryDealer
                });

                $('#QryUpn').FrameTextBox({
                    value: model.QryUpn
                });

                $('#BtnNew').FrameButton({
                    text: '新增',
                    icon: 'plus',
                    onClick: function () {
                        that.initDiv(model, false);
                    }
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });


                $('#save').FrameButton({
                    text: '保存',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
                    }
                });
                $('#delete').FrameButton({
                    text: '删除',
                    icon: 'trash',
                    onClick: function () {
                        that.Delete(true);
                    }
                });
                $('#colse').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $("#windowLayout").data("kendoWindow").close();
                    }
                });

                $('#DeleteDealerSalesID').FrameTextBox({
                        value: data.DeleteDealerSalesID
                });

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.Query = function () {        
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }


    //返回服务端分页数据，第一个参数为映射business页面，第二个参数为business页面查询方法，第三个参数为需要格式化参数类型，如日期类型，无需处理则传入null或不传，第四个参数每页显示条目，不传默认为10条
    var fields = {
        CQ_BeginDate: { type: "date" }, CQ_EndDate: { type: "date"}
    };
    var kendoDataSource = GetKendoDataSource(business, 'Query', fields, 15, that.GetModel);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "DMA_ChineseName", title: "经销商", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" }
                },
                {
                    field: "CQ_UPN", title: "UPN", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "UPN" }
                },
                {
                    field: "CQ_Amount", title: "金额", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "金额" }
                },
                {
                    field: "CQ_Qty", title: "数量", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "数量" }
                },
                {
                    field: "CQ_BeginDate", title: "开始时间", width: '120px',format: "{0: yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "开始时间" }
                },
                {
                    field: "CQ_EndDate", title: "结束时间", width: '120px', format: "{0: yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "结束时间" }
                },
                {
                    title: "编辑", width: "80px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#{#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>&nbsp;&nbsp;<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='delete'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }

            ],
            pageable: {
                refresh: true,
                pageSizes: false,
                input: true,
                numeric: false
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
                    var Dealer = { Key: data.DMA_ID, Value: data.DMA_ChineseName };
                    var model = {};
                    model.AddDealer = Dealer;
                    model.AddCQID = data.CQ_ID;
                    model.AddUpn = {};
                    model.AddUpn.Key = data.CQ_UPN;
                    model.AddUpn.Value = data.CQ_UPN;
                    model.AddAmount = data.CQ_Amount;
                    model.AddTotal = data.CQ_Qty;
                    model.AddValidity = {};
                    model.AddValidity.StartDate = data.CQ_BeginDate;
                    model.AddValidity.EndDate = data.CQ_EndDate;
                    that.initDiv(model, true);
                });
                $("#RstResultList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    
                    var AddCQID = data.CQ_ID;
                    var isColse = false;
                    that.Delete(isColse, AddCQID);
                });
            }
        });
    }

    that.initDiv = function (model, readonly) {
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
        }).data("kendoWindow").title("寄售总量规则维护").center().open();
        //编辑或新增页面
        $('#AddDealer').DmsDealerFilter({
            dataSource: [],
            delegateBusiness: business,
            dataKey: 'DealerId',
            dataValue: 'DealerName',
            selectType: 'select',
            filter: 'contains',
            serferFilter: true,
            value: readonly ? model.AddDealer : {Key:'',Value:''},
            readonly: readonly,
            onChange: that.ChangeDealer
        });
        //$('#AddUpn').FrameTextBox({
        //    value: model.AddUpn,
        //    readonly: readonly
        //});
        $('#AddUpn').FrameDropdownList({
            dataSource: [],
            dataKey: 'Upn',
            dataValue: 'Upn',
            selectType: 'select',
            value: model.AddUpn,
            readonly: readonly
        });
        $('#AddValidity').FrameDatePickerRange({
            value: model.AddValidity
        });
        $('#AddAmount').FrameTextBox({
            value: model.AddAmount
        });
        $('#AddTotal').FrameTextBox({
            value: model.AddTotal
        });
        $('#AddCQID').FrameTextBox({
            value: model.AddCQID
        });
        

    }
    that.Save = function () {
        var blSuccess = true;
        var msg = '';
        var data = that.GetModel();
        if (data.AddDealer && data.AddDealer.Key == '') {
            blSuccess = false;
            msg = '请选择经销商!';
        }
        if (blSuccess && data.AddUpn == '') {
            blSuccess = false;
            msg = '请填写Upn';
        }
        if (blSuccess && (data.AddValidity.StartDate == ''||data.AddValidity.EndDate == '')) {
            blSuccess = false;
            msg = '请选择有效期!';
        }
        if (data.AddAmount != null&&isNaN(data.AddAmount)) {
            blSuccess = false;
            msg = '总金额请输入有效数字!';
        }
        if (data.AddTotal != null && isNaN(data.AddTotal)) {
            blSuccess = false;
            msg = '总数量输入有效数字!';
        }
        if (blSuccess && data.AddAmount == null && data.AddTotal==null) {
            blSuccess = false;
            msg = '请填写总金额或总数量!';
        }
        if (!blSuccess) {
            //FrameWindow.ShowAlert({
            //    target: 'top',
            //    alertType: 'info',
            //    message: msg,
            //    callback: function () {
            //        //top.deleteTabsCurrent();
            //    }
            //});
            alert(msg);
            return;
        }
            
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Save',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess) {
                    $("#windowLayout").data("kendoWindow").close();
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '保存成功',
                        callback: function () {
                            that.Query();
                        }
                    });
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
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
    that.Delete = function (isColse, AddCQID) {
        var data = FrameUtil.GetModel();
        if (AddCQID) {
            data.AddCQID = AddCQID;
        }
        if (confirm('确定删除寄售总量规则')) {
            if (data && (data.AddCQID == '' || data.AddCQID == null)) {
                $("#windowLayout").data("kendoWindow").close();
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '删除成功',
                    callback: function () {
                        //top.deleteTabsCurrent();
                    }
                });
            }
            else {
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'Delete',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {

                        if (model.IsSuccess) {
                            if (isColse) {
                                $("#windowLayout").data("kendoWindow").close();
                            }
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '删除成功',
                                callback: function () {
                                    //top.deleteTabsCurrent();
                                    that.Query();
                                }
                            });
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
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
        }
    }

    that.ChangeDealer = function () {

        var data = that.GetModel();
        
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeDealer',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#AddUpn').FrameDropdownList({
                    dataSource: model.LstUpn,
                    dataKey: 'Upn',
                    dataValue: 'Upn',
                    selectType: 'select'
                });
                FrameWindow.HideLoading();
            }
        });

    }
    var setLayout = function () {
    }

    return that;
}();
