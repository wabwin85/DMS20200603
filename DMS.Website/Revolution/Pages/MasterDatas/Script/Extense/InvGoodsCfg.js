var InvGoodsCfg = {};
InvGoodsCfg = function () {
    var that = {};

    var business = "MasterDatas.Extense.InvGoodsCfg";
    var pickedList = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    };

    that.ExportDetail = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;

        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'InvGoodsCfgExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'Bu', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryCFN', data.QryCFN);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductNameCN', data.ProductNameCN);
        urlExport = Common.UpdateUrlParams(urlExport, 'InvType', data.InvType);
        startDownload(urlExport, 'InvGoodsCfgExport');
    }

    that.Init = function () {
        var data = FrameUtil.GetModel();
        createResultList();
        //Init form
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) { 
                $('#QryBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });
                $('#QryCFN').FrameTextBox({
                    value: model.QryCFN
                });
                $('#ProductNameCN').FrameTextBox({
                    value: model.ProductNameCN
                });
                $('#InvType').FrameTextBox({
                    value:model.InvType
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnImport').FrameButton({
                    text: '导入',
                    icon: 'file-code-o',
                    onClick: function () {
                        that.openInfo();
                    }
                });
                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportDetail();
                    }
                });
                $('#BtnDelete').FrameButton({
                    text: '删除',
                    icon: 'trash-o',
                    onClick: function () { 
                        that.Delete();
                    }
                });
                FrameWindow.HideLoading();
            }

        });
    };

    var kendoDataSource = GetKendoDataSource(business, 'Query');

    var createResultList = function () {
        $('#RstResultList').kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                title: "全选", width: '50px', encoded: false,
                headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                template: '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>',
                headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                attributes: { "class": "center" }
            }, {
                    field: 'ProductLine', title: '产品线', width: '120px',
                    headerAttributes: { 'class':'text-center text-bold','title':'产品线'}
                },
                {
                    field: 'QryCFN', title: '产品型号', width: 'auto',
                    headerAttributes: { 'class': 'text-center text-bold', 'title':'产品型号'}
                },
                {
                    field: 'ProductNameCN', title: '产品中文名称', width: 'auto',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '产品中文名称' }
                },
                {
                    field: 'InvType', title: '发票规格型号', width: 'auto',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '发票规格型号' }
                },
                {
                    field: 'UpdateTime', title: '更新时间', width: 'auto',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '更新时间' }
                },
                {
                    field: 'Modifier', title: '操作人员', width: 'auto',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '操作人员' }
                },
                {
                    title: '删除', width: '80px',
                    headerAttributes: { 'class': 'text-center text-bold' },
                    template: "<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='delete'></i>",
                    attributes: { "class": "text-center text-bold"}
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
            messages: { noRecords: "没有符合条件的记录" },
            dataBound: function (e) {
                var grid = e.sender;
                $("#RstResultList").find(".Check-Item").unbind("click");
                $("#RstResultList").find(".Check-Item").on('click', function () {
                    var checked = this.checked,
                        row = $(this).closest("tr"),
                        grid = $("#RstResultList").data("kendoGrid"),
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
                        var grid = $("#RstResultList").data("kendoGrid");
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
                $("#RstResultList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    that.Delete(data.Id);
                });
            },
            page: function (e) {
                $('#CheckAll').removeAttr("checked");
            }
        });
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].Id == data.Id) {
                exists = true;
            }
        }
        return exists;
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            pickedList.push(data.Id);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i] == data.Id) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    that.openInfo = function () {
        top.createTab({
            id: 'M_发票商品导入',
            title: '发票商品导入',
            url: 'Revolution/Pages/MasterDatas/Extense/InvGoodsCfgImport.aspx'
        });
    }

    that.Export = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'InvGoodsCfgExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'Bu', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryCFN', data.QryCFN);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductNameCN', data.ProductNameCN);
        urlExport = Common.UpdateUrlParams(urlExport, 'InvType', data.InvType);
        startDownload(urlExport, 'InvGoodsCfgExport');
    };

    that.Delete = function (Id) {
        var deleteId = [];
        if (Id) {
            deleteId.push(Id);
        }
        else {
            for (var i = 0; i < pickedList.length; i++) {
                deleteId.push(pickedList[i]);
            }
        } 
        if (0 == deleteId.length) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请选择要删除的商品映射维护信息'
            });
            return;
        } else {
            var data = FrameUtil.GetModel();
            data.DeleteSeleteID = deleteId;
            FrameWindow.ShowConfirm({
                target: 'top',
                message: '确定要执行删除操作？',
                confirmCallback: function () {
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'Delete',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            if (!model.IsSuccess) {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'info',
                                    message: "删除失败",
                                    callback: function () {
                                    }
                                });
                            }
                            else {
                                pickedList = [];
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
                            FrameWindow.HideLoading();
                        }

                    });
                }
            });
        }
    }

    var setLayout = function () {

    }
    return that;
}();