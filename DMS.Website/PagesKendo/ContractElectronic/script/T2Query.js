var Page = {};
Page = function () {
    var that = {};
    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;
        return model;
    }


    that.InitPage = function () {
        $('#QryContractNO').FrameTextBox({});

        $('#QryCCNameCN').FrameDropdownList({
            dataKey: 'CC_Code',
            dataValue: 'CC_NameCN',
            selectType: 'all'
        });

        $('#QryDealerType').FrameDropdownList({
            dataSource: [{ Key: 'T2', Value: 'T2' }],
            dataKey: 'Key',
            dataValue: 'Value',
            selectType: 'AllDealer'
        });
        $('#QryDealerName').FrameTextBox({});
        $('#BtnQuery').FrameButton({
            onClick: function () {
                that.Query();
            }
        });
        $('#IsNewContract').FrameDropdownList({
            dataSource: [{ Key: 'AllContract', Value: '所有合同' }, { Key: 'NewContract', Value: '已生成' }, { Key: 'NoContract', Value: '未生成' }],
            dataKey: 'Key',
            dataValue: 'Value',
            selectType: 'AllContract'
        });

        var data = this.GetModel('InitPageT2');
        createPolicyList();
        createEffectState();

        //弹窗授权书
        $('#IptAuthorizationCode').FrameTextBox({});
        $('#IptAuthorizationContacts').FrameTextBox({});
        $('#IptAuthorizationPhone').FrameTextBox({});
        $('#BtnAuthorizationPDF').FrameButton({
            onClick: function () {
                if ($('#IptAuthorizationCode').FrameTextBox('getValue') == '') {
                    showAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '请填写授权编号！',
                    });
                } else {
                    window.open('/Pages/Contract/PrintPage.aspx?ExportType=Authorization'
                        + '&contractId=' + $('#hidContractId').val()
                        + '&dealerId=' + $('#hidDealerId').val()
                        + '&dealerName=' + $('#hidDealerName').val()
                        + '&dealerType=' + $('#hidDealerType').val()
                        + '&parmetType=' + $('#hidParmetType').val()
                        + '&Identifier=' + $('#IptAuthorizationCode').FrameTextBox('getValue')
                        + '&conUser=' + $('#IptAuthorizationContacts').FrameTextBox('getValue')
                        + '&conTel=' + $('#IptAuthorizationPhone').FrameTextBox('getValue')
                        + '&begindate=' + $('#hidEffectiveDate').val()
                        + '&SuBu=' + $('#hidSuBU').val()
                        + '&enddate=' + $('#hidExpirationDate').val());
                }
            }
        });
        $('#BtnAuthorizationClose').FrameButton({
            onClick: function () {
                $("#winAuthorizationLayout").data("kendoWindow").close();
            }
        });

        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/QueryHandler.ashx", data, function (model) {
            $("#ContractList").data("kendoGrid").setOptions({
                dataSource: model.QryList
            });

            $('#QryProductLine').FrameDropdownList({
                dataSource: model.QryBUList,
                dataKey: 'DivisionCode',
                dataValue: 'ProductLineName',
                selectType: 'all',
                onChange: that.ChangeProductLine
            });


            $(window).resize(function () {
                setLayout();
            })
            setLayout();

            hideLoading();

        });


    };
    that.Query = function () {
        var data = this.GetModel('QueryT2');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/QueryHandler.ashx", data, function (model) {

            $("#ContractList").data("kendoGrid").setOptions({
                dataSource: model.QryList
            });
            hideLoading();

        });
    }
    that.ChangeProductLine = function () {
        var data = that.GetModel('ChangeProductLine');
        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/QueryHandler.ashx", data, function (model) {
            $('#QryCCNameCN').FrameDropdownList('setDataSource', model.QryClassContractList);

            hideLoading();
        });
    }

    var createPolicyList = function (model) {
        $("#ContractList").kendoGrid({
            dataSource: [
                //{ ContractNum: 1, ContractType: 'New', ContractClass: 1, ProductLine: 1, DealerType: 'LP', Dealer: 1 },
                //{ ContractNum: 2, ContractType: 'Edit', ContractClass: 2, ProductLine: 2, DealerType: 'LP', Dealer: 2 },
                //{ ContractNum: 3, ContractType: 'New', ContractClass: 3, ProductLine: 3, DealerType: 'T1', Dealer: 3 },
                //{ ContractNum: 4, ContractType: 'Edit', ContractClass: 4, ProductLine: 4, DealerType: 'T1', Dealer: 4 },
                //{ ContractNum: 5, ContractType: 'Stop', ContractClass: 5, ProductLine: 5, DealerType: 'T1', Dealer: 5 }
            ],
            sortable: true,
            resizable: true,
            scrollable: true,
            columns: [
                {
                    field: "ContractNo", title: "合同编号", width: '120px',
                    headerAttributes: { "class": "center bold", "title": "合同编号" }
                },
                 {
                     field: "ContractTypeName", title: "合同类型", width: '80px',
                     headerAttributes: { "class": "center bold", "title": "合同类型" }
                 },
                {
                    field: "ContractType", title: "合同类型", width: '120px', hidden: true,
                    headerAttributes: { "class": "center bold", "title": "合同类型" }
                },
                 {
                     field: "ProductLineName", title: "产品线", width: '100px',
                     headerAttributes: { "class": "center bold", "title": "产品线" }
                 },
                {
                    field: "CNameCN", title: "合同分类", width: '100px',
                    headerAttributes: { "class": "center bold", "title": "合同分类" }
                },

                {
                    field: "DealerType", title: "经销商类型", width: '70px',
                    headerAttributes: { "class": "center bold", "title": "经销商类型" }
                },
                {
                    field: "DealerName", title: "经销商", width: '200px',
                    headerAttributes: { "class": "center bold", "title": "经销商" }
                },
                 {
                     field: "ContractStatus", title: "合同状态", width: '60px',
                     headerAttributes: { "class": "center bold", "title": "合同状态" }
                 },
                 {
                     field: "IsPassTraining", title: "培训状态", width: '60px',
                     headerAttributes: { "class": "center bold", "title": "培训状态" },
                     template: "#= IsPassTraining?'已通过':'未通过' #"
                 },
                {
                    title: "导出PDF", width: "60px",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    template: "<i class='fa fa-file-pdf-o' style='font-size: 14px; cursor: pointer;' name='export'></i>",
                    attributes: {
                        "class": "center"
                    }
                },
                {
                    title: "生成授权书", width: "60px",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    template: "<i class='fa fa-file-excel-o' style='font-size: 14px; cursor: pointer;' name='authorization'></i>",
                    attributes: {
                        "class": "center"
                    }
                },
                {
                    title: "合同附件", width: "60px",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    template: "<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='contractattach'></i>",
                    attributes: {
                        "class": "center"
                    }
                },
                {
                    title: "明细",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    width: 50, hidden: true,
                    template: "#if ($('\\#ContractId').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='detail'></i>#}#",
                    attributes: {
                        "class": "center"
                    }
                },
                {
                    title: "生效状态",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    width: 50,
                    template: "#if ($('\\#ContractId').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='effectstate'></i>#}#",
                    attributes: {
                        "class": "center"
                    }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 20,
                input: true,
                numeric: false
            },
            dataBound: function (e) {
                var grid = e.sender;
                $("#ContractList").find("i[name='export']").each(function(index,e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    if (!data.IsPassTraining) {
                        $(this).hide();
                    } else {
                        $(this).bind('click', function() {
                            var params = {};
                            params.Method = "GetEsignContractType";
                            params.ContractId = data.ContractId;
                            params.ContractNo = data.ContractNo;
                            params.ContractType = data.ContractType;

                            submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", params, function(model) {
                                hideLoading();
                                openPage(data, model.ESignContractType);
                            });
                        });
                    }
                });
                /*$("#ContractList").find("i[name='export']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    //openPage(data)
                    var params = {};
                    params.Method = "GetEsignContractType";
                    params.ContractId = data.ContractId;
                    params.ContractNo = data.ContractNo;
                    params.ContractType = data.ContractType;

                    submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", params, function (model) {

                        hideLoading();

                        openPage(data, model.ESignContractType);

                    });
                    //openPage(data);
                });
                */

                $("#ContractList").find("i[name='authorization']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    var params = {};
                    params.Method = "CheckIfCanAuthorization";
                    params.IptContractId = data.ContractId;
                    params.IptDealerType = data.DealerType;
                    params.IptContractType = data.ContractType;

                    submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/QueryHandler.ashx", params, function (model) {

                        if (model.ShowAuthorization == true) {

                            $('#hidContractId').val(data.ContractId);
                            $('#hidDealerType').val(data.DealerType);
                            $('#hidParmetType').val(data.ContractType);
                            that.ShowAuthorization(data.ContractId, data.ContractType);
                        }
                        else {
                            showAlert({
                                target: 'center',
                                alertType: 'info',
                                message: '无法生成授权书！',
                            });
                        }

                        hideLoading();

                    });

                });

                $("#ContractList").find("i[name='detail']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    showLoading();
                    window.location.href = '/Pages/Contract/ContractDeatil.aspx?ContractID=' + data.ContractId + '&ParmetType=' + data.ContractType + '&DealerType=' + data.DealerType;
                });

                $("#ContractList").find("i[name='contractattach']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    showLoading();
                    openWindow({
                        target: 'top',
                        title: data.ContractNo,
                        url: Common.AppVirtualPath + 'Revolution/Pages/Contract/MergeAttachment.aspx?ParmetType=' + data.ContractType + '&ContId=' + data.ContractId + '&DealerType=' + data.DealerType,
                        width: 1300,
                        height: 450,
                        maxed: false,
                        resizable: true,
                        scrollable: false,
                    });
                    hideLoading();
                });

                $("#ContractList").find("i[name='effectstate']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    that.ShowEffectState(data.ContractId);
                });
            }
        });
    }

    that.ShowAuthorization = function (contractId, contractType) {
        var params = {};
        params.Method = "GetContractDetailInfo";
        params.IptContractId = contractId;
        params.IptContractType = contractType;
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/QueryHandler.ashx", params, function (model) {
            hideLoading();

            $('#hidDealerId').val(model.hidDealerId);
            $('#hidDealerName').val(model.hidDealerName);
            $('#hidEffectiveDate').val(kendo.toString(kendo.parseDate(model.hidEffectiveDate, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss'));
            $('#hidSuBU').val(model.hidSuBU);
            $('#hidExpirationDate').val(kendo.toString(kendo.parseDate(model.hidExpirationDate, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss'));

            $('#IptAuthorizationCode').FrameTextBox('setValue', '');
            $('#IptAuthorizationContacts').FrameTextBox('setValue', '');
            $('#IptAuthorizationPhone').FrameTextBox('setValue', '');

            $("#winAuthorizationLayout").kendoWindow({
                title: "Title",
                width: 400,
                //height: 220,
                actions: [
                    "Close"
                ],
                resizable: false,
            }).data("kendoWindow").title("生成授权书").center().open();

        });
    }

    that.ShowEffectState = function (Id) {
        var data = this.GetModel('QueryEffectState');
        data.QryContractID = Id;

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/QueryHandler.ashx", data, function (model) {

            $("#EffectStateList").data("kendoGrid").setOptions({
                dataSource: model.QryEffectStateList
            });

            $("#winEffectStateLayout").kendoWindow({
                title: "Title",
                width: 450,
                height: 220,
                actions: [
                    "Close"
                ],
                resizable: false,
            }).data("kendoWindow").title("合同生效状态明细").center().open();

            hideLoading();

        });
    }

    var createEffectState = function () {
        $("#EffectStateList").kendoGrid({
            dataSource: [],
            sortable: true,
            resizable: true,
            scrollable: true,
            columns: [
                {
                    field: "Nbr", title: "编号", width: '100px',
                    headerAttributes: { "class": "center bold", "title": "编号" }
                },
                {
                    field: "Massage", title: "状态消息", width: '230px',
                    headerAttributes: { "class": "center bold", "title": "状态消息" }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 20,
                input: true,
                numeric: false
            },
            dataBound: function (e) {

            }
        });
    }


    //var openPage = function (data) {
    //    var url = '?ContractId=' + escape(data.ContractId)
    //                + '&ContractNo=' + escape(data.ContractNo)
    //                //合同类型，如：appointment
    //                + '&ContractType=' + escape(data.ContractType)
    //                //如：经销商修改
    //                + '&ContractTypeName=' + escape(data.ContractTypeName)
    //                //产品线中文名
    //                + '&ProductLineName=' + escape(data.ProductLineName)
    //                //产品线code
    //                + '&DivisionCode=' + escape(data.DivisionCode)
    //                //合同分类，Subu
    //                + '&CNameCN=' + escape(data.CNameCN)
    //                //subu code
    //                + '&CCode=' + escape(data.CCode)
    //                //经销商类型
    //                + '&DealerType=' + escape(data.DealerType)
    //                //经销商电话
    //                + '&DMA_Phone=' + escape(data.DMA_Phone)
    //                //经销商中文名
    //                + '&DealerName=' + escape(data.DealerName);
    //    if (data.DealerType == 'T2') {
    //        if (data.ContractType == 'Appointment') {

    //            openPdfPage(data.ContractNo, 'T2Apply.aspx' + url);
    //        }
    //        else if (data.ContractType == 'Renewal') {
    //            openPdfPage(data.ContractNo, 'T2Apply.aspx' + url);
    //        }
    //        else if (data.ContractType == 'Amendment') {
    //            openPdfPage(data.ContractNo, 'T2Edit.aspx' + url);
    //        }
    //        else if (data.ContractType == 'Termination') {
    //            openPdfPage(data.ContractNo, 'T2Termination.aspx' + url);
    //        }
    //    }
    //}

    var openPage = function (data, eSignContractType) {
        var url = '?ContractId=' + escape(data.ContractId)
                    + '&ContractNo=' + escape(data.ContractNo)
                    //合同类型，如：appointment
                    //+ '&ContractType=' + escape(data.ContractType)
                    + '&ContractType=' + escape(eSignContractType)
                    //如：经销商修改
                    + '&ContractTypeName=' + escape(data.ContractTypeName)
                    //产品线中文名
                    + '&ProductLineName=' + escape(data.ProductLineName)
                    //产品线code
                    + '&DivisionCode=' + escape(data.DivisionCode)
                    //合同分类，Subu
                    + '&CNameCN=' + escape(data.CNameCN)
                    //subu code
                    + '&CCode=' + escape(data.CCode)
                    //经销商类型
                    + '&DealerType=' + escape(data.DealerType)
                    //经销商电话
                    + '&DMA_Phone=' + escape(data.DMA_Phone)
                    //经销商中文名
                    + '&DealerName=' + escape(data.DealerName);
        if (data.DealerType == 'T2') {
            if (eSignContractType == 'Appointment') {

                openPdfPage(data.ContractNo, 'T2Apply.aspx' + url);
            }
            else if (eSignContractType == 'Renewal') {
                openPdfPage(data.ContractNo, 'T2Apply.aspx' + url);
            }
            else if (eSignContractType == 'Amendment') {
                openPdfPage(data.ContractNo, 'T2Edit.aspx' + url);
            }
            else if (eSignContractType == 'Termination') {
                openPdfPage(data.ContractNo, 'T2Termination.aspx' + url);
            }
        }
    }

    var openPdfPage = function (title, url, data) {
        openWindow({
            target: 'top',
            title: title,
            url: Common.AppVirtualPath + 'PagesKendo/ContractElectronic/TTwo/' + url,
            width: 1300,
            height: 600,
            maxed: false,
            resizable: true,
            scrollable: false,
        });
    }

    var setLayout = function () {
        var h = $('.content-main').height();
        //console.log(h);
        $("#ContractList").data("kendoGrid").setOptions({
            height: h - 200
        });
    }

    return that;
}();