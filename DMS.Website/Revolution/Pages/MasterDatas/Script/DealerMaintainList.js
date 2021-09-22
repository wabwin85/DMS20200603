var DealerMaintainList = {};

DealerMaintainList = function () {
    var that = {};

    var business = 'MasterDatas.DealerMaintainList';
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
                $('#QrySAPNo').FrameTextBox({
                    value: model.QrySAPNo
                });
                $('#QryDealerAddress').FrameTextBox({
                    value: model.QryDealerAddress
                });
                $('#QryDealerName').DmsDealerFilter({
                    dataSource: model.LstDealerName,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryDealerName
                });
                $('#QryDealerType').FrameDropdownList({
                    dataSource: model.LstDealerType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryDealerType
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

                $('#BtnExportAuthorizeHos').FrameButton({
                    text: '导出经销商授权分类及医院信息',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportByAuthorizeHos();
                    }
                });

                $('#BtnExportLicense').FrameButton({
                    text: '导出CFDA证照信息',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportByLicense();
                    }
                });

                //弹窗按钮
                $('#BtnCloseDealerInfo').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $("#winDealerInfoLayout").data("kendoWindow").close();
                    }
                });
                $('#BtnSaveDealerChangeName').FrameButton({
                    text: '提交',
                    icon: 'save',
                    onClick: function () {
                        that.SaveDealerName();
                    }
                });
                $('#BtnCloseDealerChangeName').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $("#winDealerChangeNameLayout").data("kendoWindow").close();
                    }
                });
                $('#BtnWinClose').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $("#winLCDetailLayout").data("kendoWindow").close();
                    }
                });

                if (model.IsDealer) {
                    $('#QryDealerName').FrameDropdownList({
                        dataSource: [{Key:model.QryDealerName.Key,Value:model.QryDealerName.Value}],
                        dataKey: 'Key',
                        dataValue: 'Value',
                        value: model.QryDealerName.Key
                    });
                    $("#QryDealerName").FrameDropdownList('disable');
                    $("#QryDealerType_Control").data("kendoDropDownList").value(model.QryDealerType.Key);
                    $("#QryDealerType").FrameDropdownList('disable');
                }
                else {
                    $('#BtnRefreshDealerCache').FrameButton({
                        text: '刷新经销商缓存',
                        icon: 'refresh',
                        onClick: function () {
                            that.RefreshCache();
                        }
                    });
                    var grid = $("#RstResultList").data("kendoGrid");
                    if (grid) {
                        grid.showColumn(10);
                    }
                }

                //$('#BtnNew').FrameButton({
                //    text: '新增',
                //    icon: 'plus',
                //    onClick: function () {
                //        that.HospitalEdit('', '医院详细信息');
                //    }
                //});

                //$('#BtnDelete').FrameButton({
                //    text: '删除',
                //    icon: 'trash-o',
                //    onClick: function () {
                //        that.Delete();
                //    }
                //});

                //$("#RstResultList").data("kendoGrid").setOptions({
                //    dataSource: model.RstResultList
                //});

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.Query = function () {
        clearDeleteDealer();
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    //导出
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DealerListExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerListExportType', 'ExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealer', data.QryDealerName.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerType', data.QryDealerType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QrySAPNo', data.QrySAPNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerAddress', data.QryDealerAddress);
        startDownload(urlExport, 'DealerListExport');

    }

    that.ExportByAuthorize = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DealerListExportByAuthorize');
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerListExportType', 'ExportByAuthorize');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealer', data.QryDealerName.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerType', data.QryDealerType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QrySAPNo', data.QrySAPNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerAddress', data.QryDealerAddress);
        startDownload(urlExport, 'DealerListExportByAuthorize');
    }

    that.ExportByAuthorizeHos = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DealerListExportByAuthorizeHos');
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerListExportType', 'ExportByAuthorizeHos');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealer', data.QryDealerName.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerType', data.QryDealerType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QrySAPNo', data.QrySAPNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerAddress', data.QryDealerAddress);
        startDownload(urlExport, 'DealerListExportByAuthorizeHos');
    }

    that.ExportByLicense = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DealerListExportByLicense');
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerListExportType', 'ExportByLicense');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealer', data.QryDealerName.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerType', data.QryDealerType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QrySAPNo', data.QrySAPNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerAddress', data.QryDealerAddress);
        startDownload(urlExport, 'DealerListExportByLicense');
    }

    //刷新缓存
    that.RefreshCache = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'RefreshDealerCache',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess != true) {
                    kendo.alert(model.ExecuteMessage);
                }
                else {
                    kendo.alert("刷新缓存成功！");
                }
                FrameWindow.HideLoading();
            }
        });
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
                //{
                //    title: "选择", width: '50px', encoded: false,
                //    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                //    template: '<input type="checkbox" id="Check_#=HosId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=HosId#"></label>',
                //    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                //    attributes: { "class": "text-center" }
                //},
                {
                    field: "ChineseName", title: "经销商名称",
                    width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "SapCode", title: "SAP账号",
                    width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "SAP账号" }
                },
                {
                    field: "DealerType", title: "经销商类型",
                    width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商类型" }
                },
                {
                    field: "Address", title: "地址",
                    width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "地址" }
                },
                {
                    field: "PostalCode", title: "邮编",
                    width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "邮编" }
                },
                {
                    field: "Phone", title: "电话",
                    width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "电话" },
                    template: "#if (data.HosDistrict) {#<span>#=data.HosDistrict#</span>#} else { if (data.HosTown) {#<span>#=data.HosTown#</span>#}}#"
                },
                {
                    field: "Fax", title: "传真",
                    width: 90,
                    headerAttributes: { "class": "text-center text-bold", "title": "传真" }
                },
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
                    title: "上传附件",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 80,
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='upload'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "维护",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 50,
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='maintain'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    hidden: true,
                    title: "经销商更名",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 90,
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='editname'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "明细",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 50,
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='detail'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "CFDA信息查看",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 110,
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='searchcfda'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "CFDA信息变更",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    width: 110,
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='editcfda'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }

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

                    that.UploadAttachList(data.Id, '经销商附件');
                });

                $("#RstResultList").find("i[name='maintain']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    $("#SelectDealerId").val(data.Id);

                    that.initMaintainInfoDiv();
                });

                $("#RstResultList").find("i[name='editname']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    $("#SelectDealerId").val(data.Id);
                    $("#SelectSAPNo").val(data.SapCode);
                    $("#SelectDealerType").val(data.DealerType);

                    that.initDealerChangeNameDiv(data.ChineseName, data.EnglishName, data.DealerType);
                });

                $("#RstResultList").find("i[name='detail']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.OpenMasterEditor(data.Id, data.DealerType, data.ChineseName);
                });

                $("#RstResultList").find("i[name='searchcfda']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    $("#SelectDealerId").val(data.Id);
                    that.InitLCDetailDiv(data.ChineseName);
                });

                $("#RstResultList").find("i[name='editcfda']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.OpenCFDAEditor(data.Id);
                });

                //$("#RstResultList").find(".Check-Item").unbind("click");
                //$("#RstResultList").find(".Check-Item").on("click", function () {
                //    var checked = this.checked,
                //    row = $(this).closest("tr"),
                //    grid = $("#RstResultList").data("kendoGrid"),
                //    dataItem = grid.dataItem(row);

                //    if (checked) {
                //        dataItem.IsChecked = true;
                //        addItem(dataItem);
                //        row.addClass("k-state-selected");
                //    } else {
                //        dataItem.IsChecked = false;
                //        removeItem(dataItem);
                //        row.removeClass("k-state-selected");
                //    }
                //});

                //$('#CheckAll').unbind('change');
                //$('#CheckAll').on('change', function (ev) {
                //    var checked = ev.target.checked;
                //    $('.Check-Item').each(function (idx, item) {
                //        var row = $(this).closest("tr");
                //        var grid = $("#RstResultList").data("kendoGrid");
                //        var data = grid.dataItem(row);

                //        if (checked) {
                //            addItem(data);
                //            $(this).prop("checked", true); //此处设置每行的checkbox选中，必须用prop方法
                //            $(this).closest("tr").addClass("k-state-selected");  //设置grid 每一行选中
                //        } else {
                //            removeItem(data);
                //            $(this).prop("checked", false); //此处设置每行的checkbox不选中，必须用prop方法
                //            $(this).closest("tr").removeClass("k-state-selected");  //设置grid 每一行不选中
                //        }
                //    });
                //});
            },
            page: function (e) {
                clearDeleteDealer();
            }
        });
    }

    that.QueryAttachInfo = function () {
        var grid = $("#RstLCAttachList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    var kendoLCAttach = GetKendoDataSource(business, 'QueryAttachInfo', null, 10);
    //窗体部分Grid
    var createLCWinResultList = function () {
        //地址
        $("#RstLCAddressList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 270,
            columns: [
                {
                    field: "SWA_WH_Code", title: "仓库代码",
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库代码" }
                },
                {
                    field: "SWA_AddressType", title: "地址类型",
                    headerAttributes: { "class": "text-center text-bold", "title": "地址类型" }
                },
                {
                    field: "SWA_WH_Address", title: "地址名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "地址名称" }
                },
                {
                    field: "SWA_IsSendAddress", title: "是否默认发货地址",
                    headerAttributes: { "class": "text-center text-bold", "title": "是否默认发货地址" }
                }

            ],
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            }
        });

        //2002二类
        $("#RstLCProductList202").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 150,
            columns: [
                {
                    field: "CatagoryID", title: "产品分类代码",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类代码" }
                },
                {
                    field: "CatagoryName", title: "产品分类名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类名称" }
                },
                {
                    field: "CatagoryType", title: "分类级别",
                    headerAttributes: { "class": "text-center text-bold", "title": "分类级别" }
                }
            ],
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            }
        });

        //2017二类
        $("#RstLCProductList217").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 150,
            columns: [
                {
                    field: "CatagoryID", title: "产品分类代码",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类代码" }
                },
                {
                    field: "CatagoryName", title: "产品分类名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类名称" }
                },
                {
                    field: "CatagoryType", title: "分类级别",
                    headerAttributes: { "class": "text-center text-bold", "title": "分类级别" }
                }
            ],
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            }
        });

        //2002三类
        $("#RstLCProductList302").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 150,
            columns: [
                {
                    field: "CatagoryID", title: "产品分类代码",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类代码" }
                },
                {
                    field: "CatagoryName", title: "产品分类名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类名称" }
                },
                {
                    field: "CatagoryType", title: "分类级别",
                    headerAttributes: { "class": "text-center text-bold", "title": "分类级别" }
                }
            ],
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            }
        });

        //2017三类
        $("#RstLCProductList317").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 150,
            columns: [
                {
                    field: "CatagoryID", title: "产品分类代码",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类代码" }
                },
                {
                    field: "CatagoryName", title: "产品分类名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类名称" }
                },
                {
                    field: "CatagoryType", title: "分类级别",
                    headerAttributes: { "class": "text-center text-bold", "title": "分类级别" }
                }
            ],
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            }
        });

        //附件
        $("#RstLCAttachList").kendoGrid({
            dataSource: kendoLCAttach,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 270,
            columns: [
                {
                    field: "Name", title: "附件名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "附件名称" }
                },
                {
                    field: "Identity_Name", title: "上传人",
                    headerAttributes: { "class": "text-center text-bold", "title": "上传人" }
                },
                {
                    field: "UploadDate", title: "上传时间", format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "上传时间" }
                },
                {
                    field: "Id", title: "下载",
                    headerAttributes: { "class": "text-center text-bold", "title": "下载" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='downloadAttach'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
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

                $("#RstLCAttachList").find("i[name='downloadAttach']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.DownloadAttach(data.Name, data.Url);

                });

            },
            page: function (e) {
            }
        });
    }

    that.Delete = function () {
        if (deleteDealer.length > 0) {
            var data = {};
            data.LstHosID = deleteDealer;
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteData',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess != true) {
                        kendo.alert(model.ExecuteMessage);
                    }
                    else {
                        kendo.alert("删除成功！");
                        that.Query();
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
        else {
            kendo.alert('请选择需要删除的数据！');
        }
    }

    var clearDeleteDealer = function () {
        $('#CheckAll').removeAttr("checked");
        deleteDealer.splice(0, deleteDealer.length);
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

    that.UploadAttachList = function (Id, Name) {
        var url = 'Revolution/Pages/MasterDatas/DealerAttachDetail.aspx?';
        url += 'DealerId=' + escape(Id);
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

    that.OpenCFDAEditor = function (Id) {
        var url = 'DealerLicenseChange.aspx?';
        url += 'DealerId=' + escape(Id);
        open(url, 'CFDAEditor');
    }

    that.initMaintainInfoDiv = function () {
        $("#winDealerInfoLayout").kendoWindow({
            title: "Title",
            width: 700,
            height: 480,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("经销商联系人维护").center().open();
        //显示联系人信息
        var DealerContactDataSource = GetKendoDataSource(business, 'QueryDealerContactInfo', null, 20);
        $("#MaintainDealerInfoList").kendoGrid({
            dataSource: DealerContactDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 400,
            columns: [
                {
                    field: "DistributorName", title: "经销商名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "Position", title: "职位",
                    headerAttributes: { "class": "text-center text-bold", "title": "职位" }
                },
                {
                    field: "Contract", title: "联系人姓名",
                    headerAttributes: { "class": "text-center text-bold", "title": "联系人姓名" }
                },
                {
                    field: "Phone", title: "联系人电话",
                    headerAttributes: { "class": "text-center text-bold", "title": "联系人电话" }
                },
                {
                    field: "Mobile", title: "联系人手机",
                    headerAttributes: { "class": "text-center text-bold", "title": "联系人手机" }
                },
                {
                    field: "EMail", title: "联系人邮箱",
                    headerAttributes: { "class": "text-center text-bold", "title": "联系人邮箱" },
                    template: "#if (data.HosDistrict) {#<span>#=data.HosDistrict#</span>#} else { if (data.HosTown) {#<span>#=data.HosTown#</span>#}}#"
                },
                {
                    field: "Address", title: "联系人地址",
                    headerAttributes: { "class": "text-center text-bold", "title": "联系人地址" }
                },
                {
                    field: "Remark", title: "联系人备注",
                    headerAttributes: { "class": "text-center text-bold", "title": "联系人备注" }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
            page: function (e) {
            }
        });

        var grid = $("#MaintainDealerInfoList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }

    }

    that.initDealerChangeNameDiv = function (CName, EName, DealerType) {
        $("#winDealerChangeNameLayout").kendoWindow({
            title: "Title",
            width: 800,
            height: 150,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("经销商更名").center().open();
        //显示经销商名称
        $("#WinOldCName").FrameTextBox({
            value: CName,
            readonly: true
        });
        $("#WinOldEName").FrameTextBox({
            value: EName,
            readonly: true
        });
        $("#WinNewCName").FrameTextBox({
        });
        $("#WinNewEName").FrameTextBox({
        });

        if (DealerType == "T2") {
            $("#divEName").css("display", "none");
        } else {
            $("#divEName").css("display", "block");
        }

    }

    that.InitLCDetailDiv = function (Name) {
        $("#DivLCBasicInfo").kendoTabStrip({
            animation: {
                open: {
                    effects: "fadeIn"
                }
            }
        });

        var data = that.GetModel();
        createLCWinResultList();

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitLCDetailWin',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //基本信息
                //$("#WinDefaultAddress").val(model.WinDefaultAddress);
                //$("#WinDMLID").val(model.WinDMLID);
                //$("#hidApplyStatus").val(model.hidApplyStatus);
                //$("#WinHidAppNo").val(model.WinHidAppNo);
                $('#WinLCHeadOfCorp').FrameTextBox({
                    value: model.WinLCHeadOfCorp
                });
                $('#WinLCLegalRep').FrameTextBox({
                    value: model.WinLCLegalRep
                });
                $('#WinLCLicenseNo').FrameTextBox({
                    value: model.WinLCLicenseNo
                });
                $('#WinLCRecordNo').FrameTextBox({
                    value: model.WinLCRecordNo
                });
                $('#WinLCLicenseStart').FrameDatePicker({
                    //format: "yyyy-MM-dd"
                    value: model.WinLCLicenseStart == null ? '' : model.WinLCLicenseStart
                });
                $('#WinLCLicenseEnd').FrameDatePicker({
                    //format: "yyyy-MM-dd"
                    value: model.WinLCLicenseEnd == null ? '' : model.WinLCLicenseEnd
                });
                $('#WinLCRecordStart').FrameDatePicker({
                    //format: "yyyy-MM-dd"
                    value: model.WinLCRecordStart == null ? '' : model.WinLCRecordStart
                });
                $('#WinLCRecordEnd').FrameDatePicker({
                    //format: "yyyy-MM-dd"
                    value: model.WinLCRecordEnd == null ? '' : model.WinLCRecordEnd
                });

                //产品分类
                $("#RstLCProductList202").data("kendoGrid").setOptions({
                    dataSource: model.RstLCProductList202
                });
                $("#RstLCProductList217").data("kendoGrid").setOptions({
                    dataSource: model.RstLCProductList217
                });
                $("#RstLCProductList302").data("kendoGrid").setOptions({
                    dataSource: model.RstLCProductList302
                });
                $("#RstLCProductList317").data("kendoGrid").setOptions({
                    dataSource: model.RstLCProductList317
                });

                //地址
                $("#RstLCAddressList").data("kendoGrid").setOptions({
                    dataSource: model.RstLCAddressList
                });
                
                that.QueryAttachInfo();

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();

                $("#winLCDetailLayout").kendoWindow({
                    title: "Title",
                    width: 1010,
                    height: '90%',
                    actions: [
                        "Close"
                    ],
                    resizable: true,
                    modal: true,
                }).data("kendoWindow").title("CFDA证照信息申请及审批(" + Name + ")").center().open();
            }
        });

    }

    that.DownloadAttach = function (Name, Url) {
        var url = '../../../Pages/Download.aspx?downloadname=' + escape(Name) + '&filename=' + escape(Url) + '&downtype=dcms';
        open(url, 'Download');
    }

    that.SaveDealerName = function () {
        var data = FrameUtil.GetModel();

        if ($("#divEName").is(':visible'))
        {
            if (data.WinNewEName == "" || data.WinNewCName == "")
            {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: "请填写完整",
                    callback: function () {
                    }
                });
                return;
            }
        }
        else
        {
            if (data.WinNewCName == "") {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: "请填写完整",
                    callback: function () {
                    }
                });
                return;
            }
        }

        if (confirm('请确认修改信息')) {

            FrameUtil.SubmitAjax({
                business: business,
                method: 'SaveDealerName',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    if (model.IsSuccess) {
                        $("#winDealerChangeNameLayout").data("kendoWindow").close();
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '修改成功！',
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

    var setLayout = function () {
    }

    return that;
}();