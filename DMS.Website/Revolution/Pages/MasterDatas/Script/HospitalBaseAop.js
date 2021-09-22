var HospitalBaseAop = {};

HospitalBaseAop = function () {
    var that = {};

    var business = 'MasterDatas.HospitalBaseAop';
    var pickedList = [];
    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = FrameUtil.GetModel();
        FrameWindow.ShowLoading();
        createResultList();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                
                $('#QryBu').FrameDropdownList({
                    dataSource: model.ListBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryBu
                });
                $('#QryYear').FrameTextBox({
                    value: model.QryYear
                });
                $('#QryHospitalNbr').FrameTextBox({
                    value: model.QryHospitalNbr
                });
                $('#QryHospitalName').FrameTextBox({
                    value: model.QryHospitalName
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
                    icon: 'upload',
                    onClick: function () {
                        that.openInfo();
                    }
                });

                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
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
    that.Delete = function (aophrID) {
        var data = FrameUtil.GetModel();
        data.DeleteAOPHRID = aophrID
        if (confirm('确定删除此信息')) {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Delete',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess) {
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
    var kendoDataSource = GetKendoDataSource(business, 'Query', null);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    field: "SubCompanyName", title: "分子公司", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "分子公司" },
                },
                {
                    field: "BrandName", title: "品牌", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "品牌" },
                },
                {
                    field: "ProductLineName", title: "产品线", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                },
                {
                    field: "CQ_Name", title: "产品分类", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类" }
                },
                {
                    field: "AOPHR_Year", title: "年份", width: '50px',
                    headerAttributes: { "class": "text-center text-bold", "title": "年份" }
                },
                {
                    field: "HOS_HospitalName", title: "医院名称", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" }
                },
                {
                    field: "HOS_Key_Account", title: "医院编号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院编号" }
                },
                {
                    field: "AOPHR_January", title: "一月", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "一月" }
                },
                {
                    field: "AOPHR_February", title: "二月", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "二月" }
                },
                {
                    field: "AOPHR_March", title: "三月", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "三月" }
                },
                {
                    field: "AOPHR_April", title: "四月", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "四月" }
                },
                {
                    field: "AOPHR_May", title: "五月", width: '70px', 
                    headerAttributes: { "class": "text-center text-bold", "title": "五月" }
                },
                {
                    field: "AOPHR_June", title: "六月", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "六月" }
                },
                {
                    field: "AOPHR_July", title: "七月", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "七月" }
                },
                {
                    field: "AOPHR_August", title: "八月", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "八月" }
                },
                {
                    field: "AOPHR_September", title: "九月", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "九月" }
                },
                {
                    field: "AOPHR_October", title: "十月", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "十月" }
                },
                {
                    field: "AOPHR_November", title: "十一月", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "十一月" }
                },
                {
                    field: "AOPHR_December", title: "十二月", width: '70px',
                    headerAttributes: { "class": "text-center text-bold", "title": "十二月" }
                },
                {
                    title: "删除", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='delete'></i>",
                    attributes: {
                        "class": "text-center text-bold"
                    }
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
                $("#RstResultList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    var AOPHRId = data.AOPHR_ID;
                    that.Delete(AOPHRId);
                });
            },
            page: function (e) {
            }
        });
    }


    that.openInfo = function () {
        top.createTab({
            id: 'M2_AOPHospitalReferenceImport',
            title: '医院标准指标导入',
            url: 'Revolution/Pages/MasterDatas/HospitalBaseAopImport.aspx'
        });
    }

    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'HospitalBaseAopExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'ProductLineBumId', data.QryBu.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'Year', data.QryYear);
        urlExport = Common.UpdateUrlParams(urlExport, 'HospitalNbr', data.QryHospitalNbr);
        urlExport = Common.UpdateUrlParams(urlExport, 'HospitalName', data.QryHospitalName);
        startDownload(urlExport, 'HospitalBaseAopExport');
    }
    var setLayout = function () {
    }

    return that;
}();
