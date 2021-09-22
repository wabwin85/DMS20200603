var DealerLicenseChange = {};

DealerLicenseChange = function () {
    var that = {};

    var business = 'MasterDatas.DealerLicenseChange';
    var chooseProduct = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {

        $('#hidDealerId').val(Common.GetUrlParam('DealerId'));

        var data = that.GetModel();
        createLCResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryLCFlowNo').FrameTextBox({
                    value: model.QryLCFlowNo
                });
                $('#QryLCDealerName').DmsDealerFilter({
                    dataSource: model.LstLCDealerName,
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.QryLCDealerName
                });
                $('#QryLCApplyStatus').FrameDropdownList({
                    dataSource: [{ Key: "审批通过", Value: "审批通过" }, { Key: "审批拒绝", Value: "审批拒绝" }, { Key: "草稿", Value: "草稿" }, { Key: "审批中", Value: "审批中" }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select'
                });

                $('#BtnLCQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.QueryMainInfo();
                    }
                });

                $('#BtnWinClose').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        if ($("#hidApplyStatus").val() == "new" || $("#hidApplyStatus").val() == "草稿") {
                            if (confirm('是否保存草稿？')) {
                                that.SaveDraft();
                            } else {
                                that.DeleteDraft();
                            }
                        }
                        else {
                            $("#winLCDetailLayout").data("kendoWindow").close();
                        }
                    }
                });

                if (model.IsDealer) {
                    if (model.QryLCDealerName != null)
                    {
                        $('#QryLCDealerName').FrameDropdownList({
                            dataSource: [{ Key: model.QryLCDealerName.Key, Value: model.QryLCDealerName.Value }],
                            dataKey: 'Key',
                            dataValue: 'Value',
                            value: model.QryLCDealerName.Key
                        });
                        $("#QryLCDealerName").FrameDropdownList('disable');
                    }

                    $('#BtnLCNew').FrameButton({
                        text: '新增',
                        icon: 'plus',
                        onClick: function () {
                            $("#WinDMLID").val("");
                            $("#hidApplyStatus").val("new");
                            that.InitLCDetailDiv();
                        }
                    });

                    
                }

                //弹窗按钮
                $('#BtnWinSubmit').FrameButton({
                    text: '提交审批',
                    icon: 'check',
                    onClick: function () {
                        that.SubmitToFlow();
                    }
                });
                $('#BtnWinDelDraft').FrameButton({
                    text: '删除草稿',
                    icon: 'trash',
                    onClick: function () {
                        that.DeleteDraft();
                    }
                });
                $('#BtnWinSaveDraft').FrameButton({
                    text: '保存草稿',
                    icon: 'floppy-o',
                    onClick: function () {
                        that.SaveDraft();
                    }
                });

                //按钮
                $('#BtnLCSelectAddr').FrameButton({
                    text: '选择地址',
                    icon: 'plus',
                    onClick: function () {
                        that.initLCAddressDiv();
                    }
                });
                $('#BtnLCSelectProd202').FrameButton({
                    text: '重新选择分类',
                    icon: 'plus',
                    onClick: function () {
                        $("#WinProductCat").val("202");
                        clearChooseProduct();
                        that.initLCProductCatagoryDiv();
                    }
                });
                $('#BtnLCSelectProd217').FrameButton({
                    text: '重新选择分类',
                    icon: 'plus',
                    onClick: function () {
                        $("#WinProductCat").val("217");
                        clearChooseProduct();
                        that.initLCProductCatagoryDiv();
                    }
                });
                $('#BtnLCSelectProd302').FrameButton({
                    text: '重新选择分类',
                    icon: 'plus',
                    onClick: function () {
                        $("#WinProductCat").val("302");
                        clearChooseProduct();
                        that.initLCProductCatagoryDiv();
                    }
                });
                $('#BtnLCSelectProd317').FrameButton({
                    text: '重新选择分类',
                    icon: 'plus',
                    onClick: function () {
                        $("#WinProductCat").val("317");
                        clearChooseProduct();
                        that.initLCProductCatagoryDiv();
                    }
                });
                $('#BtnLCAddAttach').FrameButton({
                    text: '添加附件',
                    icon: 'plus',
                    onClick: function () {
                        that.initLCAttachmentDiv();
                    }
                });

                //address
                $('#BtnLCSaveAddr').FrameButton({
                    text: '添加',
                    onClick: function () {
                        that.SaveShipToAddress();
                    }
                });

                $('#BtnLCCancelAddr').FrameButton({
                    text: '取消',
                    onClick: function () {
                        $("#winLCAddressLayout").data("kendoWindow").close();
                    }
                });

                //product
                $('#BtnLCWinQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        clearChooseProduct();
                        that.SearchLCProduct();
                    }
                });
                $('#BtnWinAddProduct').FrameButton({
                    text: '添加',
                    icon: 'plus',
                    onClick: function () {
                        that.AddLCProductToTab();
                    }
                });

                $('#BtnCloseProductWin').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $("#winLCProductCatagoryLayout").data("kendoWindow").close();
                    }
                });

                //attach
                //$('#BtnLCUploadAttach').FrameButton({
                //    text: '上传附件',
                //    onClick: function () {
                //        that.UploadLCAttach();
                //    }
                //});
                //$('#BtnLCClearAttach').FrameButton({
                //    text: '清除',
                //    onClick: function () {
                //        that.ClearLCAttach();
                //    }
                //});

                //初始化上传控件
                $('#WinLCFileUpload').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=DealerLicense",
                        autoUpload: true
                    },
                    upload: function (e) {
                        e.data = { InstanceId: $('#WinDMLID').val() };
                    },
                    multiple: false,
                    success: function (e) {
                        //$("#BtnUploadProxy").FrameSortAble("FileaddNewData", e.response)
                        that.QueryAttachInfo();
                    }
                });

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

    that.QueryMainInfo = function () {
        var grid = $("#RstLCResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    that.QueryAddressInfo = function () {
        var grid = $("#RstLCAddressList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    that.QueryAttachInfo = function () {
        var grid = $("#RstLCAttachList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    var kendoDataSource = GetKendoDataSource(business, 'QueryMainInfo', null, 20);
    var createLCResultList = function () {
        $("#RstLCResultList").kendoGrid({
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
                    field: "DMA_ChineseShortName", title: "经销商名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "DML_NewApplyNO", title: "申请单编号",
                    headerAttributes: { "class": "text-center text-bold", "title": "申请单编号" }
                },
                {
                    field: "DML_NewApplyStatus", title: "审批状态",
                    headerAttributes: { "class": "text-center text-bold", "title": "审批状态" }
                },
                {
                    field: "DML_NewApplyDate", title: "申请时间", format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "申请时间" }
                },
                {
                    title: "查看",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#DML_MID').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='detail'></i>#}#",
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

                $("#RstLCResultList").find("i[name='detail']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    $("#WinDMLID").val(data.DML_MID);
                    $("#hidApplyStatus").val(data.DML_NewApplyStatus);

                    that.InitLCDetailDiv();
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
            }
        });
    }

    //窗体部分Grid
    var kendoLCAddress = GetKendoDataSource(business, 'QueryAddressInfo', null, 10);
    var kendoLCAttach = GetKendoDataSource(business, 'QueryAttachInfo', null, 10);
    var createLCWinResultList = function () {
        //地址
        $("#RstLCAddressList").kendoGrid({
            dataSource: kendoLCAddress,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 255,
            columns: [
                {
                    field: "ST_WH_Code", title: "地址代码",
                    headerAttributes: { "class": "text-center text-bold", "title": "地址代码" }
                },
                {
                    field: "ST_Type", title: "地址类型",
                    headerAttributes: { "class": "text-center text-bold", "title": "地址类型" }
                },
                {
                    field: "ST_Address", title: "地址名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "地址名称" }
                },
                {
                    field: "ST_IsSendAddress", title: "是否默认发货地址",
                    headerAttributes: { "class": "text-center text-bold", "title": "是否默认发货地址" }
                },
                {
                    hidden: true,
                    title: "删除",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#ST_ID').val() != '') {#<i class='fa fa-close' style='font-size: 14px; cursor: pointer;' name='deleteAddress'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    hidden: true,
                    title: "变更默认发货地址",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#ST_ID').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='editAddress'></i>#}#",
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

                $("#RstLCAddressList").find("i[name='deleteAddress']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.DeleteAddress(data.ST_ID, data.ST_WH_Code);
                });

                $("#RstLCAddressList").find("i[name='editAddress']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.UpdateAddress(data.ST_ID, data.ST_IsSendAddress);
                });
            },
            page: function (e) {
            }
        });

        //2002二类
        $("#RstLCProductList202").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 100,
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
            height: 100,
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
            height: 100,
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
            height: 100,
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
            height: 255,
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
                },
                {
                    hidden: true,
                    field: "Id", title: "删除",
                    headerAttributes: { "class": "text-center text-bold", "title": "删除" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='deleteAttach'></i>#}#",
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

                $("#RstLCAttachList").find("i[name='deleteAttach']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    
                    that.DeleteAttach(data.Id);
                });

            },
            page: function (e) {
            }
        });
    }

    that.DeleteAddress = function (ID, Code) {
        var data = {};
        data.WinAddrID = ID;
        data.WinAddrCode = Code;
        if (confirm('是否要删除该地址？')) {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteAddress',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess != true) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '删除成功！',
                            callback: function () {
                            }
                        });
                        that.QueryAddressInfo();
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.UpdateAddress = function (ID, IsSend) {
        var data = that.GetModel();
        data.WinAddrID = ID;
        data.WinAddrIsSend = IsSend;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'UpdateAddress',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess != true) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: model.ExecuteMessage,
                        callback: function () {
                        }
                    });
                }
                else {
                    that.QueryAddressInfo();
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.DownloadAttach = function (Name, Url) {
        var url = '/Pages/Download.aspx?downloadname=' + escape(Name) + '&filename=' + escape(Url) + '&downtype=DealerLicense';
        open(url, 'Download');
    }

    that.DeleteAttach = function (ID) {
        var data = {};
        data.WinAttachId = ID;
        if (confirm('是否要删除该附件？')) {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteAttach',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess != true) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '删除成功！',
                            callback: function () {
                            }
                        });
                        $("#RstLCAttachList").data("kendoGrid").setOptions({
                            dataSource: model.RstLCAttachList
                        });
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
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

    //新增
    that.InitLCDetailDiv = function () {
        $("#DivLCBasicInfo").kendoTabStrip({
            animation: {
                open: {
                    effects: "fadeIn"
                }
            }
        });
        
        var data = that.GetModel();

        //控件显示
        if (data.hidApplyStatus == "草稿" || data.hidApplyStatus == "审批拒绝" || data.hidApplyStatus == "new") {

            $('#BtnWinSubmit').show();
            $('#BtnWinDelDraft').show();
            $('#BtnWinSaveDraft').show();
            $('#BtnLCSelectAddr').show();
            $('#BtnLCSelectProd202').show();
            $('#BtnLCSelectProd217').show();
            $('#BtnLCSelectProd302').show();
            $('#BtnLCSelectProd317').show();
            $('#BtnLCAddAttach').show();

        }
        else {

            $('#BtnWinSubmit').hide();
            $('#BtnWinDelDraft').hide();
            $('#BtnWinSaveDraft').hide();
            $('#BtnLCSelectAddr').hide();
            $('#BtnLCSelectProd202').hide();
            $('#BtnLCSelectProd217').hide();
            $('#BtnLCSelectProd302').hide();
            $('#BtnLCSelectProd317').hide();
            $('#BtnLCAddAttach').hide();

        }

        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitLCDetailWin',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //基本信息
                $("#WinDefaultAddress").val(model.WinDefaultAddress);
                $("#WinDMLID").val(model.WinDMLID);
                $("#hidApplyStatus").val(model.hidApplyStatus);
                $("#WinHidAppNo").val(model.WinHidAppNo);
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
                    value:model.WinLCLicenseStart
                });
                $('#WinLCLicenseEnd').FrameDatePicker({
                    //format: "yyyy-MM-dd"
                    value:model.WinLCLicenseEnd
                });
                $('#WinLCRecordStart').FrameDatePicker({
                    //format: "yyyy-MM-dd"
                    value:model.WinLCRecordStart
                });
                $('#WinLCRecordEnd').FrameDatePicker({
                    //format: "yyyy-MM-dd"
                    value:model.WinLCRecordEnd
                });
                $('#WinLCSales').FrameDropdownList({
                    dataSource: model.LstLCSales,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select'
                });
                if (model.WinLCSales) {
                    $("#WinLCSales_Control").data("kendoDropDownList").value(model.WinLCSales.Key);
                }

                createLCWinResultList();

                //控件
                var gridAddress = $("#RstLCAddressList").data("kendoGrid");
                if (gridAddress) {
                    gridAddress.dataSource.page(1);
                }
                var gridAttach = $("#RstLCAttachList").data("kendoGrid");
                if (gridAttach) {
                    gridAttach.dataSource.page(1);
                }
                gridAddress.showColumn(4);
                gridAddress.showColumn(5);
                gridAttach.showColumn(4);
                if (model.hidApplyStatus == "new" || model.hidApplyStatus == "草稿" || model.hidApplyStatus == "审批拒绝") {

                    $('#WinLCHeadOfCorp').FrameTextBox('enable');
                    $('#WinLCLegalRep').FrameTextBox('enable');
                    $('#WinLCLicenseNo').FrameTextBox('enable');
                    $('#WinLCLicenseStart').FrameDatePicker('enable');
                    $('#WinLCLicenseEnd').FrameDatePicker('enable');
                    $('#WinLCRecordNo').FrameTextBox('enable');
                    $('#WinLCRecordStart').FrameDatePicker('enable');
                    $('#WinLCRecordEnd').FrameDatePicker('enable');

                    //var gridAddress = $("#RstLCAddressList").data("kendoGrid");
                    //if (gridAddress) {
                    //    gridAddress.showColumn(4);
                    //    gridAddress.showColumn(5);
                    //}
                    //var gridAttach = $("#RstLCAttachList").data("kendoGrid");
                    //if (gridAttach) {
                    //    gridAttach.showColumn(4);
                    //}
                    //gridAddress.showColumn(4);
                    //gridAddress.showColumn(5);
                    //gridAttach.showColumn(4);
                }
                else {

                    $('#WinLCHeadOfCorp').FrameTextBox('disable');
                    $('#WinLCLegalRep').FrameTextBox('disable');
                    $('#WinLCLicenseNo').FrameTextBox('disable');
                    $('#WinLCLicenseStart').FrameDatePicker('disable');
                    $('#WinLCLicenseEnd').FrameDatePicker('disable');
                    $('#WinLCRecordNo').FrameTextBox('disable');
                    $('#WinLCRecordStart').FrameDatePicker('disable');
                    $('#WinLCRecordEnd').FrameDatePicker('disable');

                    //var gridAddress = $("#RstLCAddressList").data("kendoGrid");
                    //if (gridAddress) {
                    //    gridAddress.hideColumn(4);
                    //    gridAddress.hideColumn(5);
                    //}
                    //var gridAttach = $("#RstLCAttachList").data("kendoGrid");
                    //if (gridAttach) {
                    //    gridAttach.hideColumn(4);
                    //}
                    gridAddress.hideColumn(4);
                    gridAddress.hideColumn(5);
                    gridAttach.hideColumn(4);
                }

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

                //地址附件
                that.QueryAddressInfo();
                that.QueryAttachInfo();

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });

        $("#winLCDetailLayout").kendoWindow({
            title: "Title",
            width: 1200,
            height: '93%',
            actions: [
                "Maximize"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("CFDA证照信息修改").center().open();

    }

    //草稿操作
    that.SaveDraft = function () {
        var data = that.GetModel();

        var grid202 = $("#RstLCProductList202").data("kendoGrid").dataSource.data();
        var grid217 = $("#RstLCProductList217").data("kendoGrid").dataSource.data();
        var grid302 = $("#RstLCProductList302").data("kendoGrid").dataSource.data();
        var grid317 = $("#RstLCProductList317").data("kendoGrid").dataSource.data();

        data.RstLCProductList202 = grid202;
        data.RstLCProductList217 = grid217;
        data.RstLCProductList302 = grid302;
        data.RstLCProductList317 = grid317;

        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveDraft',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess != true) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: model.ExecuteMessage,
                        callback: function () {
                        }
                    });
                }
                else {
                    $("#winLCDetailLayout").data("kendoWindow").close();
                    that.QueryMainInfo();
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.DeleteDraft = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteDraft',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess != true) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: model.ExecuteMessage,
                        callback: function () {
                        }
                    });
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: "草稿已删除！",
                        callback: function () {
                        }
                    });
                    $("#winLCDetailLayout").data("kendoWindow").close();
                    that.QueryMainInfo();
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.SubmitToFlow = function () {
        var data = that.GetModel();
        var errMsg = "";
        if (data.WinLCSales.Key == '') {
            errMsg += "请选择蓝威销售人员，如无销售人员请联系系统管理员<br/>"
        }
        if (data.WinLCLicenseNo == '' || data.WinLCRecordNo == '') {
            errMsg += "请填写证件编号<br/>"
        }
        if (data.WinLCLicenseStart == '' || data.WinLCRecordStart == '') {
            errMsg += "请填写起始日期<br/>"
        }
        if (data.WinLCLicenseEnd == '' || data.WinLCRecordEnd == '') {
            errMsg += "请填写结束日期<br/>"
        }
        if (data.WinLCHeadOfCorp == '') {
            errMsg += "请填写企业负责人<br/>"
        }
        if (data.WinLCLegalRep == '') {
            errMsg += "请填写法人代表<br/>"
        }
        var gridAddr = $("#RstLCAddressList").data("kendoGrid");
        var addrRows = gridAddr.items();
        if (addrRows.length <= 0) {
            errMsg += "请维护地址信息<br/>"
        }
        var gridAtt = $("#RstLCAttachList").data("kendoGrid");
        var attRows = gridAtt.items();
        //if (attRows.length <= 0) {
        //    errMsg += "请上传附件<br/>"
        //}
        if (errMsg != "")
        {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: errMsg,
                callback: function () {
                }
            });
        }
        else {
            var grid202 = $("#RstLCProductList202").data("kendoGrid").dataSource.data();
            var grid217 = $("#RstLCProductList217").data("kendoGrid").dataSource.data();
            var grid302 = $("#RstLCProductList302").data("kendoGrid").dataSource.data();
            var grid317 = $("#RstLCProductList317").data("kendoGrid").dataSource.data();
            
            data.RstLCProductList202 = grid202;
            data.RstLCProductList217 = grid217;
            data.RstLCProductList302 = grid302;
            data.RstLCProductList317 = grid317;

            FrameUtil.SubmitAjax({
                business: business,
                method: 'SubmitToFlow',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess != true) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: "提交成功！",
                            callback: function () {
                            }
                        });
                        $("#winLCDetailLayout").data("kendoWindow").close();
                        that.QueryMainInfo();
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.initLCAddressDiv = function () {
        
        //填写地址信息
        $("#WinLCAddressType").FrameDropdownList({
            dataSource: [{ Key: "经营地址", Value: "经营地址" }, { Key: "仓库地址", Value: "仓库地址" }, { Key: "住所地址", Value: "住所地址" }],
            dataKey: 'Key',
            dataValue: 'Value',
            selectType: 'select'
        })
        $("#WinLCAddressInfo").FrameTextArea({
            value: ""
        });

        $("#winLCAddressLayout").kendoWindow({
            title: "Title",
            width: 420,
            height: 200,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("添加地址").center().open();

    }

    that.initLCProductCatagoryDiv = function () {
        
        //显示产品分类信息
        $("#RstLCWinProductList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 245,
            columns: [
                {
                    title: "选择", width: '50px', encoded: false,
                    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=CatagoryID#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=CatagoryID#"></label>',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
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
            //pageable: {
            //    refresh: false,
            //    pageSizes: false,
            //    pageSize: 20,
            //    input: true,
            //    numeric: false
            //},
            //page: function (e) {
            //}
            dataBound: function (e) {
                //var grid = e.sender;

                $("#RstLCWinProductList").find(".Check-Item").unbind("click");
                $("#RstLCWinProductList").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstLCWinProductList").data("kendoGrid"),
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
                        var grid = $("#RstLCWinProductList").data("kendoGrid");
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
            }
        });

        //product
        $("#WinLCProductCode").FrameTextBox({
            value: ""
        });
        $("#WinLCProductName").FrameTextBox({
            value: ""
        });
       
        $("#winLCProductCatagoryLayout").kendoWindow({
            title: "Title",
            width: 700,
            height: 425,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("产品分类选择").center().open();
    }

    that.SearchLCProduct = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'SearchLCProduct',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess != true) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: model.ExecuteMessage,
                        callback: function () {
                        }
                    });
                }
                else {
                    $("#RstLCWinProductList").data("kendoGrid").setOptions({
                        dataSource: model.RstLCWinProductList
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.AddLCProductToTab = function () {
        if (chooseProduct.length > 0) {
            var data = that.GetModel();
            
            if ($("#WinProductCat").val() == "202") {
                data.RstLCProductList202 = chooseProduct;
                $("#RstLCProductList202").data("kendoGrid").setOptions({
                    dataSource: data.RstLCProductList202
                });
            }
            if ($("#WinProductCat").val() == "217") {
                data.RstLCProductList217 = chooseProduct;
                $("#RstLCProductList217").data("kendoGrid").setOptions({
                    dataSource: data.RstLCProductList217
                });
            }
            if ($("#WinProductCat").val() == "302") {
                data.RstLCProductList302 = chooseProduct;
                $("#RstLCProductList302").data("kendoGrid").setOptions({
                    dataSource: data.RstLCProductList302
                });
            }
            if ($("#WinProductCat").val() == "317") {
                data.RstLCProductList317 = chooseProduct;
                $("#RstLCProductList317").data("kendoGrid").setOptions({
                    dataSource: data.RstLCProductList317
                });
            }
        }
        else {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: "请选择要添加的产品分类代码！",
                callback: function () {
                }
            });
        }
    }

    var clearChooseProduct = function () {
        $('#CheckAll').removeAttr("checked");
        chooseProduct.splice(0, chooseProduct.length);
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            chooseProduct.push(data);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < chooseProduct.length; i++) {
            if (chooseProduct[i].CatagoryID == data.CatagoryID) {
                chooseProduct.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < chooseProduct.length; i++) {
            if (chooseProduct[i].CatagoryID == data.CatagoryID) {
                exists = true;
            }
        }
        return exists;
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

    that.initLCAttachmentDiv = function () {
        
        $("#winLCAttachmentLayout").kendoWindow({
            title: "Title",
            width: 420,
            height: 200,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("上传附件").center().open();

    }

    that.SaveShipToAddress = function () {
        var data = FrameUtil.GetModel();
        if ($('#cbxIsDefaultShipTo').prop('checked')) {
            data.IsDefaultAddr = "是";
        }
        else {
            data.IsDefaultAddr = "否";
        }
        
        if (data.WinLCAddressType.Key == "" || data.WinLCAddressInfo == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: "请填写完整后再提交！",
                callback: function () {
                }
            });
            return;
        }
        else if (data.WinLCAddressInfo.length > 60) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: "地址信息超长，请调整后提交！",
                callback: function () {
                }
            });
            return;
        }
        else {
            if ($("#WinDefaultAddress").val() != "N" && $('#cbxIsDefaultShipTo').prop('checked')) {
                if (confirm('默认发货仓库将由：' + $("#WinDefaultAddress").val() + '修改为</br>' + data.WinLCAddressInfo + '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp是否提交？')) {

                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'SaveShipToAddress',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {

                            if (model.IsSuccess) {
                                $("#winLCAddressLayout").data("kendoWindow").close();
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'info',
                                    message: '添加成功！',
                                    callback: function () {
                                        that.QueryAddressInfo();
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
            else {
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'SaveShipToAddress',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {

                        if (model.IsSuccess) {
                            $("#winLCAddressLayout").data("kendoWindow").close();
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '添加成功！',
                                callback: function () {
                                    that.QueryAddressInfo();
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

    that.UploadLCAttach = function () {
        //var url = 'Revolution/Pages/MasterDatas/DealerAttachDetail.aspx?';
        //url += 'DealerId=' + escape(Id);
        //FrameWindow.OpenWindow({
        //    target: 'top',
        //    title: Name,
        //    url: Common.AppVirtualPath + url,
        //    width: $(window).width() * 1,
        //    height: $(window).height() * 1,
        //    actions: [],
        //    callback: function (result) {
        //        //if (result == "success") {
        //        //    that.Query();
        //        //}
        //    }
        //});
    }

    that.ClearLCAttach = function () {

    }

    var setLayout = function () {
    }

    return that;
}();