var DealerSalesReport_New = {};

DealerSalesReport_New = function () {
    var that = {};

    var business = 'Report.DealerSalesReport_New';

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

                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'ProductLineID',
                    dataValue: 'ProductLineName',
                    selectType: 'all',
                    value: model.QryProductLine
                });

                $('#QryApplyDate').FrameDatePickerRange({
                    value: model.QryApplyDate
                }); 

                $('#QryStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'OrderStaus',
                    dataValue: 'StatusName',
                    selectType: 'all',
                    value: model.QryStatus
                });


                $('#QryProductModel').FrameTextBox({
                    value: model.QryProductModel
                });

                $('#QryBatchNo').FrameTextBox({
                    value: model.QryBatchNo
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

                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
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
        var data = FrameUtil.GetModel();
        console.log(data);

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Query',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });

                FrameWindow.HideLoading();
            }
        });
    }

    //经销商销售报表
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLine', data.QryProductLine.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'StartDate', data.QryApplyDate.StartDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'EndDate', data.QryApplyDate.EndDate);
        urlExport = Common.UpdateUrlParams(urlExport, 'Status', data.QryStatus.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductModel', data.QryProductModel);
        urlExport = Common.UpdateUrlParams(urlExport, 'BatchNo', data.QryBatchNo);

        FrameUtil.StartDownload({
            url: urlExport,
            cookie: 'DealerSalesReport_NewExport',
            business: business
        });
    }

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "DMA_ChineseName", title: "经销商名称", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商名称" }
                },
                {
                    field: "DMA_EnglishName", title: "经销商英文名称", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商英文名称" }
                },
                {
                    field: "DMA_SAP_Code", title: "经销商ERP Account", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商ERP Account" }
                },
                {
                    field: "SPH_ShipmentNbr", title: "销售单号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单号" }
                },
                {
                    field: "SPH_Type", title: "销售单类型", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单类型" }
                },
                {
                    field: "ShipmentStatus", title: "销售单状态", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "销售单状态" }
                },
                {
                    field: "SPH_SubmitDate", title: "单据日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单据日期" }
                },
                {
                    field: "IDENTITY_NAME", title: "操作人", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "操作人" }
                },
                {
                    field: "SPH_ShipmentDate", title: "销售日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "销售日期" }
                },
                {
                    field: "Year", title: "年度", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "年度" }
                },
                {
                    field: "Month", title: "月度", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "月度" }
                },
                {
                    field: "HOS_HospitalName", title: "销售医院", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "销售医院" }
                },
                {
                    field: "HOS_Province", title: "医院所属省份", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院所属省份" }
                },
                {
                    field: "HOS_City", title: "医院所属地区", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院所属地区" }
                },
                {
                    field: "HOS_District", title: "医院所属市", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院所属市" }
                },
                {
                    field: "HOS_Key_Account", title: "医院代码", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院代码" }
                },
                {
                    field: "YesOrNo", title: "是否已报台", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "是否已报台" }
                },
                {
                    field: "ProductLineName", title: "产品线", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" }
                },
                {
                    field: "WHM_Code", title: "仓库编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库编号" }
                },
                {
                    field: "WHM_Name", title: "仓库名称", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "仓库名称" }
                },
                {
                    field: "CFN_CustomerFaceNbr", title: "产品编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品编号" }
                },
                {
                    field: "CFN_ChineseName", title: "产品中文名", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" }
                },
                {
                    field: "CFN_EnglishName", title: "产品英文名", width: '250px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" }
                },
                {
                    field: "LTM_LotNumber", title: "产品批号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品批号" }
                },
                {
                    field: "QRCode", title: "二维码", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二维码" }
                },
                {
                    field: "LTM_ExpiredDate", title: "产品有效期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品有效期" }
                },
                {
                    field: "SLT_LotShippedQty", title: "销售数量", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "销售数量" }
                },
                {
                    field: "SalesAmount", title: "销售价格", width: '100px', encoded: false,
                    headerAttributes: { "class": "text-center text-bold", "title": "销售价格" },
                    attributes: { "class": "right" },
                    format: "{0:N2}"
                },
                {
                    field: "SPH_InvoiceNo", title: "销售发票", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "销售发票" }
                },
                {
                    field: "SPH_InvoiceDate", title: "发票日期", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "发票日期" }
                },
                {
                    field: "SPH_NoteForPumpSerialNbr", title: "备注", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "备注" }
                },
                {
                    field: "HOS_Address", title: "购货者经营地址", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "购货者经营地址" }
                },
                {
                    field: "HOS_Phone", title: "购货者联系方式", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "购货者联系方式" }
                },
                {
                    field: "RFU_CurRegNo", title: "注册证编号-1", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-1" }
                },
                {
                    field: "RFU_CurManuName", title: "生产企业（注册证-1）", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业（注册证-1）" }
                },
                {
                    field: "RFU_LastRegNo", title: "注册证编号-2", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "注册证编号-2" }
                },
                {
                    field: "RFU_LastManuName", title: "生产企业（注册证-2）", width: '300px',
                    headerAttributes: { "class": "text-center text-bold", "title": "生产企业（注册证-2）" }
                },
                {
                    field: "CFN_Level1Code", title: "Level1 Code", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level1 Code" }
                },
                {
                    field: "CFN_Level1Desc", title: "Level1 Desc", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level1 Desc" }
                },
                {
                    field: "CFN_Level2Code", title: "Level2 Code", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level2 Code" }
                },
                {
                    field: "CFN_Level2Desc", title: "Level2 Desc", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level2 Desc" }
                },
                {
                    field: "CFN_Level3Code", title: "Level3 Code", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level3 Code" }
                },
                {
                    field: "CFN_Level3Desc", title: "Level3 Desc", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level3 Desc" }
                },
                {
                    field: "CFN_Level4Code", title: "Level4 Code", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level4 Code" }
                },
                {
                    field: "CFN_Level4Desc", title: "Level4 Desc", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level4 Desc" }
                },
                {
                    field: "CFN_Level5Code", title: "Level5 Code", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level5 Code" }
                },
                {
                    field: "CFN_Level5Desc", title: "Level5 Desc", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "Level5 Desc" }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 20,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
            }
        });
    }


    var setLayout = function () {
    }

    return that;
}();
