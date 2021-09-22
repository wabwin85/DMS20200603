var SalesUserManage = {};

SalesUserManage = function () {
    var that = {};

    var business = 'DealerTrain.SalesUserManage';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

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

                $('#QrySale').FrameTextBox({
                    value: model.QrySale
                });

                $('#BtnNew').FrameButton({
                    text: '新增',
                    icon: 'file',
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
                $('#BtnImport').FrameButton({
                    text: '从微信用户导入',
                    icon: 'upload',
                    onClick: function () {
                        that.Import();
                    }
                });

                $('#save').FrameButton({
                    text: '提交',
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

    var kendoDataSource = GetKendoDataSource(business, 'Query',null,15);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "DealerName", title: "经销商", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商" }
                },
                {
                    field: "SalesName", title: "销售", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "销售" }
                },
                {
                    field: "SalesPhone", title: "手机", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "手机" }
                },
                {
                    field: "SalesEmail", title: "邮箱", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "邮箱" }
                },                
                {
                    title: "编辑", width: "100px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>&nbsp;&nbsp;<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='delete'></i>#}#",
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
                    var Dealer = { Key: data.DealerId, Value: data.DealerName };
                    var model = {};
                    model.AddDealer = Dealer;
                    model.AddDealerSalesID = data.DealerSalesId;
                    model.AddSalesName = data.SalesName;
                    model.AddSalesEmail = data.SalesEmail;
                    model.AddSalesPhone = data.SalesPhone;
                    model.AddSalesSex = data.SalesSex == 1 ? true : false;
                    that.initDiv(model, true);
                });
                $("#RstResultList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    
                    var AddDealerSalesID = data.DealerSalesId;
                    var isColse = false;
                    that.Delete(isColse, AddDealerSalesID);
                });
            }
        });
    }

    that.Import = function () {
        url = Common.AppVirtualPath + 'Revolution/Pages/DealerTrain/SalesUserImport.aspx?',

            FrameWindow.OpenWindow({
                target: 'top',
                title: '选择微信用户',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (list) {
                    if (list) {
                        var data = FrameUtil.GetModel();
                        data.DealerSalesIDList = list;

                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'ImportWechatUser',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {                                
                                FrameWindow.HideLoading();
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'info',
                                    message: '导入成功',
                                    callback: function () {
                                        that.Query();
                                    }
                                });
                            }
                        });
                    }
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
        }).data("kendoWindow").title("销售信息").center().open();
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
            readonly: readonly
        });
        $('#AddSalesName').FrameTextBox({
            value: model.AddSalesName
        });
        $('#AddSalesPhone').FrameTextBox({
            value: model.AddSalesPhone
        });
        $('#AddSalesEmail').FrameTextBox({
            value: model.AddSalesEmail
        });
        $('#AddSalesSex').FrameSwitch({
            onLabel: "男",
            offLabel: "女",
            value: model.AddSalesSex
        });
        $('#AddDealerSalesID').FrameTextBox({
            value: model.AddDealerSalesID
        });
        

    }
    that.Save = function () {
        var blSuccess = true;
        var msg = '';
        var data = FrameUtil.GetModel();
        if (data.AddDealer && data.AddDealer.Key == '') {
            blSuccess = false;
            msg = '请选择经销商!';
        }
        if (blSuccess && data.AddSalesName == '') {
            blSuccess = false;
            msg = '请填写姓名';
        }
        if (blSuccess && data.AddSalesPhone == '') {
            blSuccess = false;
            msg = '请填写手机号码!';
        }
        if (blSuccess && data.AddSalesEmail == '') {
            blSuccess = false;
            msg = '请填写邮箱!';
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
        if (confirm('确定提交此销售信息')) {
            
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
    }
    that.Delete = function (isColse, AddDealerSalesID) {
        var data = FrameUtil.GetModel();
        if (AddDealerSalesID) {
            data.AddDealerSalesID = AddDealerSalesID;
        }
        if (confirm('确定删除此销售信息')) {
            if (data && (data.AddDealerSalesID == '' || data.AddDealerSalesID == null)) {
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
    var setLayout = function () {
    }

    return that;
}();
