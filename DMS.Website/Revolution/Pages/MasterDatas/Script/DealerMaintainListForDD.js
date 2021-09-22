var DealerMaintainListForDD = {};

DealerMaintainListForDD = function () {
    var that = {};
    var IsOrNot = [{ Key: "1", Value: "是" }, { Key: "0", Value: "否" }];
    var business = 'MasterDatas.DealerMaintainListForDD';
    var deleteDealer = [];

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
                $('#DealerListType').val(model.DealerListType);
                $('#QrySAPNo').FrameTextBox({
                    value: model.QrySAPNo
                });
                $('#QryDealerAddress').FrameTextBox({
                    value: model.QryDealerAddress
                });
                //$('#QryDealerName').DmsDealerFilter({
                //    dataSource: [],//model.LstDealerName,
                //    delegateBusiness: business,
                //    dataKey: 'DealerId',
                //    dataValue: 'DealerName',
                //    selectType: 'select',
                //    filter: 'contains',
                //    serferFilter: true
                //    //value: model.QryDealerName
                //});
                $('#QryDealerName').DmsDealerFilter({
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
                   // value: model.QryDealer,
                });
                $('#QryDealerType').FrameDropdownList({
                    dataSource: model.LstDealerType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryDealerType
                });

                $('#QryIsActive').FrameDropdownList({
                    dataSource: IsOrNot,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select'
                });
                $('#QryIsHaveRedFlag').FrameDropdownList({
                    dataSource: IsOrNot,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select'
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });

                $('#BtnExportAuthorize').FrameButton({
                    text: '导出经销商授权产品信息',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportByAuthorize();
                    }
                });

                $('#BtnExportLicense').FrameButton({
                    text: '导出CFDA证照信息',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportByLicense();
                    }
                });


                if (model.IsDealer) {
                    //$('#QryDealerName').FrameDropdownList({
                    //    dataSource: [{Key:model.QryDealerName.Key,Value:model.QryDealerName.Value}],
                    //    dataKey: 'Key',
                    //    dataValue: 'Value',
                    //    value: model.QryDealerName.Key
                    //});
                    //$("#QryDealerName").FrameDropdownList('disable');
                    $("#QryDealerType_Control").data("kendoDropDownList").value(model.QryDealerType.Key);
                    $("#QryDealerType").FrameDropdownList('disable');
                }
                else {
                    
                    var grid = $("#RstResultList").data("kendoGrid");
                    if (grid) {
                        grid.showColumn(10);
                    }
                }

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.Query = function () {
        //clearDeleteDealer();
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }


    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 20);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "ChineseName", title: "经销商名称",
                    width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "SapCode", title: "SAP账号",
                    width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "SAP账号" }
                },
                {
                    field: "DealerType", title: "经销商类型",
                    width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商类型" }
                },
                //{
                //    field: "Address", title: "地址",
                //    width: 180,
                //    headerAttributes: { "class": "text-center text-bold", "title": "地址" }
                //},
                //{
                //    field: "PostalCode", title: "邮编",
                //    width: 90,
                //    headerAttributes: { "class": "text-center text-bold", "title": "邮编" }
                //},
                //{
                //    field: "Phone", title: "电话",
                //    width: 90,
                //    headerAttributes: { "class": "text-center text-bold", "title": "电话" },
                //    template: "#if (data.HosDistrict) {#<span>#=data.HosDistrict#</span>#} else { if (data.HosTown) {#<span>#=data.HosTown#</span>#}}#"
                //},
                //{
                //    field: "Fax", title: "传真",
                //    width: 90,
                //    headerAttributes: { "class": "text-center text-bold", "title": "传真" }
                //},
                {
                    field: "ActiveFlag", title: "有效",
                    width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "有效" },
                    template: "#if (data.ActiveFlag) {#<i class='fa fa-check-square-o' style='font-size: 14px; cursor: pointer;'></i>#}else{#<i class='fa fa-square-o' style='font-size: 14px; cursor: pointer;'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "DDReportName", title: "DD报告名称",
                    width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "DD报告名称" }
                },
                {
                    field: "DDStartDate", title: "起始时间", format: "{0:yyyy-MM-dd}",
                    width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "起始时间" }
                },
                {
                    field: "DDEndDate", title: "过期时间", format: "{0:yyyy-MM-dd}",
                    width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "过期时间" }
                },
                {
                    field: "IsHaveRedFlag", title: "是否有RedFlag",
                    width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "是否有RedFlag" },
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "DDUpdateUser", title: "创建人",
                    width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "创建人" }
                },
                {
                    field: "DDUpdateDate", title: "创建时间", format: "{0:yyyy-MM-dd}",
                    width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "创建时间" }
                },
                {
                    title: "背调记录",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 100,
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='upload'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                //{
                //    title: "明细",
                //    headerAttributes: {
                //        "class": "text-center text-bold"
                //    },
                //    width: 50,
                //    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='detail'></i>#}#",
                //    attributes: {
                //        "class": "text-center text-bold"
                //    }
                //}

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
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

                $("#RstResultList").find("i[name='upload']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.UploadAttachList(data.Id, data.DealerType, '背调记录');
                });


                //$("#RstResultList").find("i[name='detail']").bind('click', function (e) {
                //    var tr = $(this).closest("tr");
                //    var data = grid.dataItem(tr);

                //    that.OpenMasterEditor(data.Id, data.DealerType, data.ChineseName);
                //});
            },
            page: function (e) {
                //clearDeleteDealer();
            }
        });
    }




    var addItem = function (data) {
        if (!isExists(data)) {
            deleteDealer.push(data.HosId);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < deleteDealer.length; i++) {
            if (deleteDealer[i] == data.HosId) {
                deleteDealer.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < deleteDealer.length; i++) {
            if (deleteDealer[i] == data.HosId) {
                exists = true;
            }
        }
        return exists;
    }

    that.UploadAttachList = function (Id, Type,Name) {
        var url = 'Revolution/Pages/MasterDatas/DealerAttachDetailForDD.aspx?';
        url += 'DealerId=' + escape(Id) + '&DealerType=' + escape(Type);
        FrameWindow.OpenWindow({
            target: 'top',
            title: Name,
            url: Common.AppVirtualPath + url,
            width: $(window).width() * 1,
            height: $(window).height() * 1,
            actions: [],
            callback: function (result) {
                //if (result == "success") {
                //    that.Query();
                //}
            }
        });
    }

    that.OpenMasterEditor = function (Id, Type, Name) {
        var url = 'Revolution/Pages/MasterDatas/DealerMasterEditor.aspx?';
        url += 'DealerId=' + escape(Id);
        url += '&DealerType=' + escape(Type);
        FrameWindow.OpenWindow({
            target: 'top',
            title: '明细：' + Name,
            url: Common.AppVirtualPath + url,
            width: $(window).width() * 0.7,
            height: $(window).height() * 0.9,
            actions: [],
            callback: function (result) {
                //if (result == "success") {
                //    that.Query();
                //}
            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();