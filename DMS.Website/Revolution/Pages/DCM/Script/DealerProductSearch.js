var DealerProductSearch = {};

DealerProductSearch = function () {
    var that = {};

    var business = 'DCM.DealerProductSearch';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};

        $("#DivRgstBasicInfo").kendoTabStrip({
            animation: {
                open: {
                    effects: "fadeIn"
                }
            }
        });
        $("#DivDtlBasicInfo").kendoTabStrip({
            animation: {
                open: {
                    effects: "fadeIn"
                }
            }
        });

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //产品线
                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductline,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryProductLine
                });
                //产品型号
                $('#QryCFN').FrameTextBox({
                    value: model.QryCFN
                });
                
                $('#BtnQuery').FrameButton({
                    text: '查找',
                    icon: 'search',
                    onClick: function () {
                        //if ($('#QryProductLine').FrameDropdownList('getValue').Key == '')
                        //{
                        //    FrameWindow.ShowAlert({
                        //        target: 'center',
                        //        alertType: 'info',
                        //        message: '请选择产品线！'
                        //    });
                        //}
                        //else
                        {
                            that.Query();
                        }
                    }
                });
                $('#BtnExportProduct').FrameButton({
                    text: '导出产品信息',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.ExportByProduct();
                    }
                });
                $('#BtnDownload').FrameButton({
                    text: '证照下载',
                    icon: 'download',
                    onClick: function () {
                        window.open('../Download.aspx?downloadname=蓝威三证.zip&filename=蓝威三证.zip', 'Download');
                    }
                });
                $('#BtnHelp').FrameButton({
                    text: '帮助',
                    icon: 'question-circle',
                    onClick: function () {
                        that.ShowHelpWin();
                    }
                });

                //注册证
                $('#BtnWinCloseRegistration').FrameButton({
                    text: '关闭',
                    icon: 'minus-circle',
                    onClick: function () {
                        $("#winRegistrationLayout").data("kendoWindow").close();
                    }
                });

                //帮助
                $('#BtnWinCloseHelp').FrameButton({
                    text: '关闭',
                    icon: 'minus-circle',
                    onClick: function () {
                        $("#winHelpLayout").data("kendoWindow").close();
                    }
                });

                createDetailInfo();
                createResultList();
                createRegistration();
                createRegistrationNew();

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });

    }

    //帮助
    that.ShowHelpWin = function () {
        $("#winHelpLayout").kendoWindow({
            title: "Title",
            width: 350,
            height: 175,
            actions: [
                "Close"
            ],
            resizable: false
            //modal: true,
        }).data("kendoWindow").title("帮助").center().open();
    }

    //主信息查询
    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 15);

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "CustomerFaceNbr", title: "产品型号", width: 120, 
                    headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SubCompanyName", title: "分子公司", width: 70,
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "BrandName", title: "品牌", width: 60,
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                    attributes: { "class": "table-td-cell" }

                },
                {
                    field: "ProductLineName", title: "产品线", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EnglishName", title: "英文说明", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "英文说明" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "中文说明", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "中文说明" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PCTName", title: "产品分类", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PCTEnglishName", title: "产品分类英文名称", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类英文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Implant", title: "植入", width: 50, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "植入" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Tool", title: "工具", width: 50, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "工具" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Share", title: "共享", width: 50, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "共享" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Description", title: "描述", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "描述" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "注册证下载", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if (Property4 != '-1') {#<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='download'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "明细", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if (Property4 != '-1') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
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

                $("#RstResultList").find("i[name='download']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $('#hidCfnId').val('');
                    $('#WinProductLot').FrameTextBox('setValue', '');
                    $('#hidCfnId').val(data.CustomerFaceNbr);
                    that.ShowDownload();
                });

                $("#RstResultList").find("i[name='edit']").on('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    that.ShowDetail(data);
                })
            }
        });
    }

    that.ShowDownload = function () {
        that.QueryRegistration();
        that.QueryRegistrationBylot();
        that.QueryRegistrationNew();
        that.QueryRegistrationBylotNew();
        $("#winRegistrationLayout").kendoWindow({
            title: "Title",
            width: 900,
            height: 490,
            actions: [
                "Close"
            ],
            resizable: false
            //modal: true,
        }).data("kendoWindow").title("产品注册证").center().open();
    }

    that.ShowDetail = function (data) {
        if (data.Property4 != '-1')
        {
            //产品信息
            $('#WinDetailID').FrameTextBox('setValue', data.Id);
            $('#WinProductLineName').FrameTextBox('setValue', data.ProductLineName);
            $('#WinPCTName').FrameTextBox('setValue', data.PCTName);
            $('#WinPCTEnglishName').FrameTextBox('setValue', data.PCTEnglishName);
            $('#WinCustomerFaceNbr').FrameTextBox('setValue', data.CustomerFaceNbr);
            $('#WinEnglishName').FrameTextBox('setValue', data.EnglishName);
            $('#WinChineseName').FrameTextBox('setValue', data.ChineseName);
            $('#WinDescription').FrameTextBox('setValue', data.Description);
            $('#WinImplant').FrameSwitch('setValue', data.Implant);
            $('#WinTool').FrameSwitch('setValue', data.Tool);
            $('#WinShare').FrameSwitch('setValue', data.Share);
            //描述
            $('#WinProperty1').FrameTextBox('setValue', data.Property1);
            $('#WinProperty2').FrameTextBox('setValue', data.Property2);
            $('#WinProperty3').FrameTextBox('setValue', data.Property3);
            $('#WinProperty4').FrameTextBox('setValue', data.Property4);
            $('#WinProperty5').FrameTextBox('setValue', data.Property5);
            $('#WinProperty6').FrameTextBox('setValue', data.Property6);
            $('#WinProperty7').FrameTextBox('setValue', data.Property7);
            $('#WinProperty8').FrameTextBox('setValue', data.Property8);

            $("#winCFNDetailLayout").kendoWindow({
                title: "Title",
                width: 600,
                height: 490,
                //actions: [
                //    "Close"
                //],
                resizable: false
                //modal: true,
            }).data("kendoWindow").title("产品详细信息").center().open();
        }
    }

    //注册证
    that.QueryRegistration = function () {
        var grid = $("#RstWinRegistration").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }
    that.QueryRegistrationBylot = function () {
        var grid = $("#RstWinRegistrationBylot").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    var fieldsReg = { VALID_DATE_FROM: { type: "date", format: "{0: yyyy-MM-dd}" }, VALID_DATE_TO: { type: "date", format: "{0: yyyy-MM-dd}" } };
    var fieldsRegLot = { AT_UploadDate: { type: "date", format: "{0: yyyy-MM-dd}" } };
    var RegistrationSource = GetKendoDataSource(business, 'QueryRegistration', fieldsReg, 15);
    var RegistrationBylotSource = GetKendoDataSource(business, 'QueryRegistrationBylot', fieldsRegLot, 15);

    var createRegistration = function () {
        $("#RstWinRegistration").kendoGrid({
            dataSource: RegistrationSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 380,
            columns: [
                {
                    field: "REG_NO", title: "注册证编号", width: 170,
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AttachName", title: "资质名称", width: 270,
                    headerAttributes: { "class": "text-center text-bold", "title": "资质名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Type", title: "资质类型", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "资质类型" },
                    attributes: { "class": "table-td-cell" }

                },
                {
                    field: "VALID_DATE_FROM", title: "有效期-起始", width: 100, format: "{0: yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期-起始" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "VALID_DATE_TO", title: "有效期-终止", width: 100, format: "{0: yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期-终止" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "MANU_NAME", title: "生产企业", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "下载", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if (AttachName != null && AttachName != '' && AttachName != '.pdf') {#<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='download'></i>#}#",
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

                $("#RstWinRegistration").find("i[name='download']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    var url = '../Download.aspx?downloadname=' + escape(data.AttachName) + '&filename=' + escape(data.AttachURL) + '&downtype=cfn';

                    if (confirm('注意：DMS下载的产品注册证仅供蓝威代理商经营范围资质存档或产品使用单位验收备案使用，产品注册证的解释权归蓝威所有。\r\n  请即时下载打印产品注册证，以确为最新版本注册证。'))
                    {
                        window.open(url, 'Download');
                    }
                });
            }
        });

        $('#WinProductLot').FrameTextBox({
            value: ''
        });
        $('#BtnWinSearch').FrameButton({
            text: '查询',
            icon: 'search',
            onClick: function () {
                that.QueryRegistrationBylot();
            }
        });
        $("#RstWinRegistrationBylot").kendoGrid({
            dataSource: RegistrationBylotSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 335,
            columns: [
                {
                    field: "AT_Name", title: "报关单名称", width: 170,
                    headerAttributes: { "class": "text-center text-bold", "title": "报关单名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AT_Type", title: "类型", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AT_UPN", title: "报关单UPN", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "报关单UPN" },
                    attributes: { "class": "table-td-cell" }

                },
                {
                    field: "AT_LotNumber", title: "产品批号", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品批号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "AT_UploadDate", title: "上传日期", width: 150, format: "{0: yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "上传日期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "下载", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='download'></i>",
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

                $("#RstWinRegistrationBylot").find("i[name='download']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    window.open(data.AT_Url, 'Download');
                });
            }
        });
    }

    //注册证新
    that.QueryRegistrationNew = function () {
        var data = {};
        data.hidCfnId = $('#hidCfnId').val();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'QueryRegistrationNew',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstWinRegistrationNew").data("kendoGrid").setOptions({
                    dataSource: {
                        data: model.RstWinRegistrationNew,
                        schema: {
                            model: {
                                fields: {
                                    ValidDateFrom: { type: "date", format: "{0:yyyy-MM-dd}" },
                                    ValidDateTo: { type: "date", format: "{0:yyyy-MM-dd}" }
                                }
                            }
                        }
                    }
                });

                FrameWindow.HideLoading();
            }
        });
    }
    that.QueryRegistrationBylotNew = function () {
        var data = {};
        data.hidCfnId = $('#hidCfnId').val();
        data.WinProductLotNew = $('#WinProductLotNew').FrameTextBox('getValue');
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'QueryRegistrationBylotNew',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstWinRegistrationBylotNew").data("kendoGrid").setOptions({
                    dataSource: model.RstWinRegistrationBylotNew
                });
                
                FrameWindow.HideLoading();
            }
        });
    }

    var createRegistrationNew = function () {
        $("#RstWinRegistrationNew").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 380,
            columns: [
                {
                    field: "DocNum", title: "注册证编号", width: 170,
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SourceFileName", title: "资质名称", width: 270,
                    headerAttributes: { "class": "text-center text-bold", "title": "资质名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ValidDateFrom", title: "有效期-起始", width: 100, format: "{0: yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期-起始" },
                    attributes: { "class": "table-td-cell" }

                },
                {
                    field: "ValidDateTo", title: "有效期-终止", width: 100, format: "{0: yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期-终止" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "下载", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='download'></i>",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 15,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstWinRegistrationNew").find("i[name='download']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    
                    if (confirm('注意：DMS下载的产品注册证仅供蓝威代理商经营范围资质存档或产品使用单位验收备案使用，产品注册证的解释权归蓝威所有。\r\n  请即时下载打印产品注册证，以确为最新版本注册证。')) {
                        window.open(data.LinkUrl, 'Download');//TODO
                    }
                });
            }
        });

        $('#WinProductLotNew').FrameTextBox({
            value: ''
        });
        $('#BtnWinSearchNew').FrameButton({
            text: '查询',
            icon: 'search',
            onClick: function () {
                that.QueryRegistrationBylotNew();
            }
        });
        $("#RstWinRegistrationBylotNew").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 335,
            columns: [
                {
                    field: "SourceFileName", title: "报关单名称", width: 170,
                    headerAttributes: { "class": "text-center text-bold", "title": "报关单名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Category", title: "类型", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UPN", title: "报关单UPN", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "报关单UPN" },
                    attributes: { "class": "table-td-cell" }

                },
                {
                    field: "Lot", title: "产品批号", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品批号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "下载", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='download'></i>",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 15,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstWinRegistrationBylotNew").find("i[name='download']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    window.open(data.LinkUrl, 'Download');//TODO
                });
            }
        });
    }

    //明细
    var createDetailInfo = function () {
        //产品信息
        $('#WinDetailID').FrameTextBox({
            value: ''
        });
        $('#WinDetailID').FrameTextBox('disable');
        $('#WinProductLineName').FrameTextBox({
            value: ''
        });
        $('#WinProductLineName').FrameTextBox('disable');
        $('#WinPCTName').FrameTextBox({
            value: ''
        });
        $('#WinPCTName').FrameTextBox('disable');
        $('#WinPCTEnglishName').FrameTextBox({
            value: ''
        });
        $('#WinPCTEnglishName').FrameTextBox('disable');
        $('#WinCustomerFaceNbr').FrameTextBox({
            value: ''
        });
        $('#WinCustomerFaceNbr').FrameTextBox('disable');
        $('#WinEnglishName').FrameTextBox({
            value: ''
        });
        $('#WinEnglishName').FrameTextBox('disable');
        $('#WinChineseName').FrameTextBox({
            value: ''
        });
        $('#WinChineseName').FrameTextBox('disable');
        $('#WinDescription').FrameTextBox({
            value: ''
        });
        $('#WinDescription').FrameTextBox('disable');
        $('#WinImplant').FrameSwitch({
            onLabel: "植入",
            offLabel: "非植入",
            value: false,
        });
        $('#WinImplant').FrameSwitch('disable');
        $('#WinTool').FrameSwitch({
            onLabel: "工具",
            offLabel: "非工具",
            value: false,
        });
        $('#WinTool').FrameSwitch('disable');
        $('#WinShare').FrameSwitch({
            onLabel: "共享",
            offLabel: "不共享",
            value: false,
        });
        $('#WinShare').FrameSwitch('disable');
        //描述
        $('#WinProperty1').FrameTextBox({
            value: ''
        });
        $('#WinProperty1').FrameTextBox('disable');
        $('#WinProperty2').FrameTextBox({
            value: ''
        });
        $('#WinProperty2').FrameTextBox('disable');
        $('#WinProperty3').FrameTextBox({
            value: ''
        });
        $('#WinProperty3').FrameTextBox('disable');
        $('#WinProperty4').FrameTextBox({
            value: ''
        });
        $('#WinProperty4').FrameTextBox('disable');
        $('#WinProperty5').FrameTextBox({
            value: ''
        });
        $('#WinProperty5').FrameTextBox('disable');
        $('#WinProperty6').FrameTextBox({
            value: ''
        });
        $('#WinProperty6').FrameTextBox('disable');
        $('#WinProperty7').FrameTextBox({
            value: ''
        });
        $('#WinProperty7').FrameTextBox('disable');
        $('#WinProperty8').FrameTextBox({
            value: ''
        });
        $('#WinProperty8').FrameTextBox('disable');

        $('#BtnWinCloseDetail').FrameButton({
            text: '取消',
            icon: 'times-circle',
            onClick: function () {
                $("#winCFNDetailLayout").data("kendoWindow").close();
            }
        });
    }

    that.ExportByProduct = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'ProductExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'ExportType', 'ExportProduct');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryCFN', data.QryCFN);
        startDownload(urlExport, 'ProductExportByDealer');
    }
    var setLayout = function () {
    }

    return that;
}();
