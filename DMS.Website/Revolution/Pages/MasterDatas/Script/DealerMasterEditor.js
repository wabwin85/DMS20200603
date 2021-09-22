var DealerMasterEditor = {};

DealerMasterEditor = function () {
    var that = {};

    var business = 'MasterDatas.DealerMasterEditor';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        $("#DivBasicInfo").kendoTabStrip({
            animation: {
                open: {
                    effects: "fadeIn"
                }
            }
        });
        $('#IptDmaID').val(Common.GetUrlParam('DealerId'));
        $('#IptDealerType').val(Common.GetUrlParam('DealerType'));
        var data = that.GetModel();
        createAttachList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#IptDmaID').val(model.IptDmaID);
                $('#IptDealerType').val(model.IptDealerType);
                //基本信息
                $('#IptDmaCName').FrameTextBox({
                    value: model.IptDmaCName
                });
                $('#IptDmaCSName').FrameTextBox({
                    value: model.IptDmaCSName
                });
                $('#IptDmaEName').FrameTextBox({
                    value: model.IptDmaEName
                });
                $('#IptDmaESName').FrameTextBox({
                    value: model.IptDmaESName
                });
                $('#IptDmaNo').FrameTextBox({
                    value: model.IptDmaNo
                });
                $('#IptDmaSapNo').FrameTextBox({
                    value: model.IptDmaSapNo
                });
                $('#IptCorpType').FrameTextBox({
                    value: model.IptCorpType
                });
                $('#IptCarrier').FrameTextBox({
                    value: model.IptCarrier
                });
                $("#IptFirstSignDate").FrameDatePicker({
                    format: "yyyy-MM-dd",
                    value: model.IptFirstSignDate
                });
                //$("#IptFirstSignDate_Control").val(model.IptFirstSignDate);
                $("#IptSystemStartDate").FrameDatePicker({ 
                    format: "yyyy-MM-dd",
                    value: model.IptSystemStartDate
                });
                //$("#IptSystemStartDate_Control").val(model.IptSystemStartDate);
                $('#IptSNDealer').FrameSwitch({
                    onLabel: "南方",
                    offLabel: "北方"
                });
                $('#IptSalesMode').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.IptSalesMode
                });
                $('#IptActiveFlag').FrameSwitch({
                    onLabel: "有效",
                    offLabel: "无效",
                    value: model.IptActiveFlag
                });
                $('#IptDmaProvince').FrameDropdownList({
                    dataSource: model.LstDmaProvince,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.IptDmaProvince.Key,
                    onChange: that.ProvinceChange
                });
                $("#IptDmaProvince_Control").data("kendoDropDownList").value(model.IptDmaProvince.Key);
                if (model.IptDmaRegion.Key != "") {
                    $('#IptDmaRegion').FrameDropdownList({
                        dataSource: [{ TerId: model.IptDmaRegion.Key, Description: model.IptDmaRegion.Value }],
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select',
                        onChange: that.RegionChange
                    });
                    $("#IptDmaRegion_Control").data("kendoDropDownList").value(model.IptDmaRegion.Key);
                }
                else {
                    $('#IptDmaRegion').FrameDropdownList({
                        dataSource: model.LstDmaRegion,
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select',
                        onChange: that.RegionChange
                    });
                }
                if (model.IptDmaTown.Key != "") {
                    $('#IptDmaTown').FrameDropdownList({
                        dataSource: [{ TerId: model.IptDmaTown.Key, Description: model.IptDmaTown.Value }],
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select'
                    });
                    $("#IptDmaTown_Control").data("kendoDropDownList").value(model.IptDmaTown.Key);
                }
                else {
                    $('#IptDmaTown').FrameDropdownList({
                        dataSource: model.LstDmaTown,
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select'
                    });
                }
                $('#DrpDmaType').FrameDropdownList({
                    dataSource: model.LstDmaType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.IptDmaType
                });
                $("#DrpDmaType_Control").data("kendoDropDownList").value(model.IptDmaType);
                $('#DrpTaxType').FrameDropdownList({
                    dataSource: model.LstDmaTaxType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.IptTaxType
                });
                $("#DrpTaxType_Control").data("kendoDropDownList").value(model.IptTaxType);
                $('#DrpDealerAuthentication').FrameDropdownList({
                    dataSource: model.LstDmaAuthentication,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.IptDealerAuthentication
                });
                $("#DrpDealerAuthentication_Control").data("kendoDropDownList").value(model.IptDealerAuthentication);

                //地址信息
                $("#IptDmaRegisterAddress").FrameTextBox({
                    value: model.IptDmaRegisterAddress
                });
                $('#IptDmaAddress').FrameTextBox({
                    value: model.IptDmaAddress
                });
                $('#IptDmaShipToAddress').FrameTextBox({
                    value: model.IptDmaShipToAddress
                });
                $('#IptDmaPostalCOD').FrameTextBox({
                    value: model.IptDmaPostalCOD
                });
                $("#IptDmaPhone").FrameTextBox({
                    value: model.IptDmaPhone
                });
                $("#IptDmaFax").FrameTextBox({
                    value: model.IptDmaFax
                });
                $("#IptDmaContact").FrameTextBox({
                    value: model.IptDmaContact
                });
                $("#IptDmaEmail").FrameTextBox({
                    value: model.IptDmaEmail
                });

                //工商注册信息
                $("#IptDmaGeneralManager").FrameTextBox({
                    value: model.IptDmaGeneralManager
                });
                $("#IptDmaLegalRep").FrameTextBox({
                    value: model.IptDmaLegalRep
                });
                $("#IptDmaRegisteredCapital").FrameTextBox({
                    value: model.IptDmaRegisteredCapital
                });
                $("#IptDmaBankAccount").FrameTextBox({
                    value: model.IptDmaBankAccount
                });
                $("#IptDmaBank").FrameTextBox({
                    value: model.IptDmaBank
                });
                $("#IptDmaTaxNo").FrameTextBox({
                    value: model.IptDmaTaxNo
                });
                $("#IptDmaLicense").FrameTextBox({
                    value: model.IptDmaLicense
                });
                $("#IptDmaLicenseLimit").FrameTextBox({
                    value: model.IptDmaLicenseLimit
                });
                $("#IptDmaEstablishDate").FrameDatePicker({ 
                    format: "yyyy-MM-dd",
                    value: model.IptDmaEstablishDate
                });
                //$("#IptDmaEstablishDate_Control").val(model.IptDmaEstablishDate);

                //财务信息
                $("#IptDmaFinance").FrameTextBox({
                    value: model.IptDmaFinance
                });
                $("#IptDmaFinancePhone").FrameTextBox({
                    value: model.IptDmaFinancePhone
                });
                $("#IptDmaFinanceEmail").FrameTextBox({
                    value: model.IptDmaFinanceEmail
                });
                $('#DrpDmaPayment').FrameDropdownList({
                    dataSource: model.LstDmaPayment,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'select',
                    value: model.IptDmaPayment
                });
                $("#DrpDmaPayment_Control").data("kendoDropDownList").value(model.IptDmaPayment);

                //经销商附件
                $("#IptDmaAttachName").FrameTextBox({
                    value: model.IptDmaAttachName
                });
                $('#IptDmaAttachType').FrameDropdownList({
                    dataSource: model.LstDmaAttachType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select'
                });
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.QueryAttach();
                    }
                });
                that.QueryAttach();

                //授权-指标导出
                $('#IptDmaExportType').FrameDropdownList({
                    dataSource: [{ Key: "1", Value: "导出授权" }, { Key: "2", Value: "导出指标" }, { Key: "3", Value: "批量导出授权" }, { Key: "4", Value: "批量导出指标" }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    value: "1",
                    onChange: that.ExportTypeChange
                });
                $('#IptDmaYear').FrameDropdownList({
                    dataSource: model.LstYear,
                    dataKey: 'COP_Period',
                    dataValue: 'COP_Period',
                    selectType: 'select'
                });
                $('#IptDmaProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'ProductLineId',
                    dataValue: 'ProductLineName',
                    selectType: 'select'
                });
                $('#IptDmaAllProductLine').FrameDropdownList({
                    dataSource: model.LstAllProductLine,
                    dataKey: 'Id',
                    dataValue: 'AttributeName',
                    selectType: 'select'
                });
                $('#BtnExportAuthorize').FrameButton({
                    text: '导出授权',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export("Authorize");
                    }
                });
                $('#BtnExportAOPD').FrameButton({
                    text: '导出经销商指标',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export("AOPD");
                    }
                });
                $('#BtnExportAOPH').FrameButton({
                    text: '导出医院指标',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export("AOPH");
                    }
                });
                $('#BtnExportAOPP').FrameButton({
                    text: '导出产品分类指标',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export("AOPP");
                    }
                });

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export("ExportAll");
                    }
                });
                $('#BtnCancel').FrameButton({
                    text: '取消',
                    icon: 'window-close-o',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });

                //页面控件是否可用
                if (model.IsDealer) {
                    //如果是经销商用户，则不可编辑，且保存、取消按钮不可间                   
                    $("#IptDmaCName").FrameTextBox('disable');
                    $("#IptDmaCSName").FrameTextBox('disable');
                    $("#IptDmaEName").FrameTextBox('disable');
                    $("#IptDmaESName").FrameTextBox('disable');
                    $("#IptDmaNo").FrameTextBox('disable');
                    $("#IptDmaSapNo").FrameTextBox('disable');
                    $("#IptDmaProvince").FrameDropdownList('disable');
                    $("#IptDmaRegion").FrameDropdownList('disable');
                    $("#IptDmaTown").FrameDropdownList('disable');
                    $("#IptCorpType").FrameTextBox('disable');
                    $("#DrpDmaType").FrameDropdownList('disable');
                    $("#DrpTaxType").FrameDropdownList('disable');
                    $("#IptSNDealer").FrameSwitch('disable');
                    $("#IptSalesMode").FrameSwitch('disable');
                    $("#IptFirstSignDate").FrameDatePicker('disable');
                    $("#DrpDealerAuthentication").FrameDropdownList('disable');
                    $("#IptSystemStartDate").FrameDatePicker('disable');
                    $("#IptCarrier").FrameTextBox('disable');
                    $("#IptActiveFlag").FrameSwitch('disable');

                    $("#IptDmaRegisterAddress").FrameTextBox('disable');
                    $("#IptDmaAddress").FrameTextBox('disable');
                    $("#IptDmaShipToAddress").FrameTextBox('disable');
                    $("#IptDmaPostalCOD").FrameTextBox('disable');
                    $("#IptDmaPhone").FrameTextBox('disable');
                    $("#IptDmaFax").FrameTextBox('disable');
                    $("#IptDmaContact").FrameTextBox('disable');
                    $("#IptDmaEmail").FrameTextBox('disable');
                    $("#IptDmaGeneralManager").FrameTextBox('disable');
                    $("#IptDmaLegalRep").FrameTextBox('disable');
                    $("#IptDmaRegisteredCapital").FrameTextBox('disable');
                    $("#IptDmaBankAccount").FrameTextBox('disable');
                    $("#IptDmaBank").FrameTextBox('disable');
                    $("#IptDmaTaxNo").FrameTextBox('disable');
                    $("#IptDmaLicense").FrameTextBox('disable');
                    $("#IptDmaLicenseLimit").FrameTextBox('disable');
                    $("#IptDmaEstablishDate").FrameDatePicker('disable');
                    $("#IptDmaFinance").FrameTextBox('disable');
                    $("#IptDmaFinancePhone").FrameTextBox('disable');
                    $("#IptDmaFinanceEmail").FrameTextBox('disable');
                    $("#DrpDmaPayment").FrameDropdownList('disable');
                }
                else {
                    $("#IptDmaCName").FrameTextBox('enable');
                    $("#IptDmaCSName").FrameTextBox('enable');
                    $("#IptDmaEName").FrameTextBox('enable');
                    $("#IptDmaESName").FrameTextBox('enable');
                    $("#IptDmaNo").FrameTextBox('enable');
                    $("#IptDmaSapNo").FrameTextBox('enable');
                    $("#IptDmaProvince").FrameDropdownList('enable');
                    $("#IptDmaRegion").FrameDropdownList('enable');
                    $("#IptDmaTown").FrameDropdownList('enable');
                    $("#IptCorpType").FrameTextBox('enable');
                    $("#DrpDmaType").FrameDropdownList('enable');
                    $("#DrpTaxType").FrameDropdownList('enable');
                    $("#IptSNDealer").FrameSwitch('enable');
                    $("#IptSalesMode").FrameSwitch('enable');
                    $("#IptFirstSignDate").FrameDatePicker('enable');
                    $("#DrpDealerAuthentication").FrameDropdownList('enable');
                    $("#IptSystemStartDate").FrameDatePicker('enable');
                    $("#IptCarrier").FrameTextBox('enable');
                    $("#IptActiveFlag").FrameSwitch('enable');

                    $("#IptDmaRegisterAddress").FrameTextBox('enable');
                    $("#IptDmaAddress").FrameTextBox('enable');
                    $("#IptDmaShipToAddress").FrameTextBox('enable');
                    $("#IptDmaPostalCOD").FrameTextBox('enable');
                    $("#IptDmaPhone").FrameTextBox('enable');
                    $("#IptDmaFax").FrameTextBox('enable');
                    $("#IptDmaContact").FrameTextBox('enable');
                    $("#IptDmaEmail").FrameTextBox('enable');
                    $("#IptDmaGeneralManager").FrameTextBox('enable');
                    $("#IptDmaLegalRep").FrameTextBox('enable');
                    $("#IptDmaRegisteredCapital").FrameTextBox('enable');
                    $("#IptDmaBankAccount").FrameTextBox('enable');
                    $("#IptDmaBank").FrameTextBox('enable');
                    $("#IptDmaTaxNo").FrameTextBox('enable');
                    $("#IptDmaLicense").FrameTextBox('enable');
                    $("#IptDmaLicenseLimit").FrameTextBox('enable');
                    $("#IptDmaEstablishDate").FrameDatePicker('enable');
                    $("#IptDmaFinance").FrameTextBox('enable');
                    $("#IptDmaFinancePhone").FrameTextBox('enable');
                    $("#IptDmaFinanceEmail").FrameTextBox('enable');
                    $("#DrpDmaPayment").FrameDropdownList('enable');
                }

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.ProvinceChange = function () {

        var data = that.GetModel();
        if (data.IptDmaProvince.Key == "") {
            $('#IptDmaRegion').FrameDropdownList({
                dataSource: [],
                dataKey: 'TerId',
                dataValue: 'Description',
                selectType: 'select',
                onChange: that.RegionChange
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'ProvinceChange',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#IptDmaRegion').FrameDropdownList({
                        dataSource: model.LstDmaRegion,
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select',
                        onChange: that.RegionChange
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
        $('#IptDmaTown').FrameDropdownList({
            dataSource: [],
            dataKey: 'TerId',
            dataValue: 'Description',
            selectType: 'select'
        });
    }

    that.RegionChange = function () {

        var data = that.GetModel();
        if (data.IptDmaRegion.Key == "") {
            $('#IptHPLTown').FrameDropdownList({
                dataSource: [],
                dataKey: 'TerId',
                dataValue: 'Description',
                selectType: 'select'
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'RegionChange',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#IptDmaTown').FrameDropdownList({
                        dataSource: model.LstDmaTown,
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select'
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.ExportTypeChange = function () {
        var selectItem = $('#IptDmaExportType').FrameDropdownList('getValue');
        if (selectItem.Key == "2")
        {
            $("#divYear").show();
            $("#divProductLine").show();
            $("#divIndex").show();
            $("#divAllProductLine").hide();
            $("#divAuthorize").hide();
        }
        else if (selectItem.Key == "3")
        {
            $("#divAllProductLine").show();
            $("#divAuthorize").show();
            $("#divProductLine").hide();
            $("#divYear").hide();
            $("#divIndex").hide();
        }
        else if (selectItem.Key == "4")
        {
            $("#divAllProductLine").show();
            $("#divYear").show();
            $("#divIndex").show();
            $("#divProductLine").hide();
            $("#divAuthorize").hide();
        }
        else
        {
            $("#divProductLine").show();
            $("#divAuthorize").show();
            $("#divAllProductLine").hide();
            $("#divYear").hide();
            $("#divIndex").hide();
        }
    }

    that.QueryAttach = function () {
        var grid = $("#RstAttachList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    that.Export = function (fileType) {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DealerMasterEditorExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerMasterEditorExportType', fileType);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealer', data.IptDmaID);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryExportType', data.IptDmaExportType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.IptDmaProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryAllProductLine', data.IptDmaAllProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryYear', data.IptDmaYear.Key);
        startDownload(urlExport, 'DealerMasterEditorExport');

    }

    var kendoDataSource = GetKendoDataSource(business, 'QueryAttach', null, 20);
    var createAttachList = function () {
        $("#RstAttachList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 295,
            columns: [
                {
                    field: "Name", title: "附件名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "附件名称" }
                },
                {
                    field: "TypeName", title: "附件类型",
                    headerAttributes: { "class": "text-center text-bold", "title": "附件类型" }
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
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='download'></i>#}#",
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

                $("#RstAttachList").find("i[name='download']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.Download(data.Name, data.Url);

                });

            },
            page: function (e) {
            }
        });
    }

    that.Download = function (Name, Url) {
        var url = '../../../Pages/Download.aspx?downloadname=' + escape(Name) + '&filename=' + escape(Url) + '&downtype=dcms';
        open(url, 'Download');
    }

    var setLayout = function () {
    }

    return that;
}();