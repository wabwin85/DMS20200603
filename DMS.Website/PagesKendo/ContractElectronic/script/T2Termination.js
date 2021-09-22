var Page = {};
Page = function () {
    var that = {};
    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;
        return model;
    }
    that.InitPage = function () {
        $("#ContractId").val($.getUrlParam("ContractId"));
        $("#ContractType").val($.getUrlParam("ContractType"));
        $("#DeptId").val($.getUrlParam("DivisionCode"));
        $("#SubDepId").val($.getUrlParam("CCode"));
        $("#DealerType").val($.getUrlParam("DealerType"));
        $("#ExportId").val("00000000-0000-0000-0000-000000000000");
        
        $("#BtnPDFExport").FrameButton({
            onClick: function () {
                that.ExportPDF("PDFExport");
            }
        });
        $("#BtnPDFCache").FrameButton({
            onClick: function () {
                that.InsertCache();
            }
        });
        $("#BtnSubmit").FrameButton({
            onClick: function () {
                that.SubmitContract();
            }
        });

        $("#BtnGiveupCache").FrameButton({
            onClick: function () {
                that.GiveupCache();
            }
        });
        $("#BtnPreview").FrameButton({
            onClick: function () {
                that.ExportPDF("Preview");
            }
        });

        $('#BtnSelectAll').bind('click', function () {
            $.MySelectedAll("BtnSelectAll");
        })
        $("#BtnContractRevoke").FrameButton({
            onClick: function () {
                that.RevokeConfirmOpen();
            }
        });
        that.InitDivControls();

        that.QueryInitData();

        $(window).resize(function () {
            setLayout();
        })

        setLayout();

        //hideLoading();
    }
    that.RevokeConfirmOpen = function () {
        showConfirm({
            target: 'top',
            message: '确定 撤销该合同吗？',
            confirmCallback: function () {

                that.ContractRevoke();

            }
        });


    };
    that.ContractRevoke = function () {
        showLoading();
        var data = that.GetModel('ContractRevoke');
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/T2Handler.ashx", data, function (model) {
            that.QueryInitData();
            $("#BtnGiveupCache").hide();
            if (model.IsSuccess == true) {
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '已撤销该合同',
                });
            }


            hideLoading();
        });
    };
    that.ExportPDF = function (isPreview) {
        showLoading();
        var data = that.GetModel('ExportPDFLP');

        data.IsPreview = isPreview;

        //console.log($("#ContractVer").FrameTextBox("getText"));
        var contractVer = $("#ContractVer").data("kendoDropDownList").text();
        data.ContractVer = contractVer;

        data.SelectExportId = $("#ContractVer").data("kendoDropDownList").value();
        if (isPreview == "PDFExport") {
            if (!contractVer || $("#ContractVer").FrameTextBox("getText") == "草稿") {
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '未提交过任何版本不能导出PDF',
                });
                hideLoading();
                return;
            }
        }
        data.ContractTemplateList = $("#sortable-handlers").FrameSortAble("getSelectValue");
        data.ContractTemplatePdfList = $("a.UserFile").FrameSortAble("gatherFileInfo");

        var ChekFile = true;
        var Messing = "";


        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
            console.log(isPreview);
            if (isPreview == "PDFExport") {
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '已成功导出PDF',
                });
                var Url = Common.AppVirtualPath + "PagesKendo/Download.aspx?FilePath=" + model.FilePath + "&FileName=" + model.ContractNo + "-" + model.ContractVer + ".pdf";
                window.open(Url, "Download");
            } if (isPreview == "Preview") {
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '已成功导出预览版本的PDF文件',
                });
                var Url = Common.AppVirtualPath + "PagesKendo/Download.aspx?FilePath=" + model.FilePath + "&FileName=" + model.ContractNo + "-" + model.ContractVer + ".pdf";
                window.open(Url, "Download");

            }

            hideLoading();
        });
    }

    that.GiveupCache = function () {
        var data = that.GetModel('GiveupCache');
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
            if (model.IsSuccess) {
                that.QueryInitData();
                $("#BtnGiveupCache").hide();
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '已放弃暂存',
                });
                hideLoading();
            }
        });
    }

    that.SubmitContract = function () {
        showLoading();
        var data = that.GetModel('InsertExportSubmit');
        data.ContractTemplateList = $("#sortable-handlers").FrameSortAble("getSelectValue");

        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/T2Handler.ashx", data, function (model) {
            if (model.IsSuccess) {
                that.QueryInitData();
                $("#BtnGiveupCache").hide();
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '提交成功',
                });
                hideLoading();
            }
        });
    }

    that.InsertCache = function () {
        showLoading();
        var data = that.GetModel('InsertExportCache');
        data.ContractTemplateList = $("#sortable-handlers").FrameSortAble("getSelectValue");

        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
            if (model.IsSuccess) {
                that.QueryInitData();
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '暂存成功',
                });
            }
            hideLoading();
        });
    }
    that.QueryInitData = function () {
        var data = that.GetModel('InitT2Term');
        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/T2Handler.ashx", data, function (model) {
            if (model) {
                if (model.ContractVerList) {
                    $.each(model.ContractVerList, function (i, n) {
                        if (n.Status == "submit") {
                            n.Status = "提交";
                        } else {
                            n.Status = "草稿";
                        }
                        if (!n.VersionNo) {
                            n.VersionNo = "草稿";
                        }
                    });
                    $("#ContractVer").data("kendoDropDownList").setDataSource(model.ContractVerList);
                    $("#ContractVer").data("kendoDropDownList").select(0);
                    var item = $("#ContractVer").data("kendoDropDownList").dataItem();
                    $("#ContractStatus").FrameTextBox("setValue", model.ContractVerList[0].Status);
                    that.ControlBtn(item.VersionStatus)

                    if (model.ContractVerList[0].Status == "草稿") {
                        $("#BtnGiveupCache").show();
                    }
                    that.InitControlsDataV(model.ContractVerList[0]);
                   

                } else {
                    that.InitControlsData(model.ContractList[0]);
                    $("#ContractDate").FrameDatePicker('setValue', model.ContractDate);
                }
                $("#sortable-handlers").FrameSortAble("removeDataSource");
                var Status = item == null ? "草稿" : item.Status;
                var DataValue = {
                    Data: model.ContractAttach, Status: Status
                };
                $("#sortable-handlers").FrameSortAble("setDataSource", DataValue);
            }
            hideLoading();
        });
    }


    that.ControlBtn = function (Status) {

        if (Status == "Draft") {
            //that.InitControlsDataEnable();
            $("#BtnSubmit").show();
            $("#BtnPDFExport").hide();
            $("#BtnPDFCache").show();
            $("#BtnGiveupCache").show();
            $("#BtnPreview").show();
            $("#BtnContractRevoke").hide();
        }
        else if (Status == "WaitDealerSign") {
            //that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").hide();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").show();
        }
        else if (Status == "WaitDealerSign" || Status == "WaitBscSign" || Status == "WaitLPSign") {
            //that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").hide();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").show();
        }
        else if (Status == "Complete") {
            //that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").hide();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").hide();
        }
        else if (Status == "Cancelled") {
            //that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").show();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").hide();
        }
        else if (Status == "WaitDealerAbandonment") {
            //that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").hide();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").hide();
        }
        else if (Status == "Abandonment") {
            //that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").show();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").hide();
        }

    }

    that.changeVerssionStatus = function () {
        var item = $("#ContractVer").data("kendoDropDownList").dataItem();
        if (item) {
            showLoading();
            if (item.Status) {
                if (item.Status == "草稿") {
                    $("#BtnGiveupCache").show();
                } else {
                    $("#BtnGiveupCache").hide();
                }
            }
            that.InitControlsDataV(item);
            var data = that.GetModel('SelectAttach');
            data.SelectExportId = $("#ContractVer").data("kendoDropDownList").value();
            submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
                $("#sortable-handlers").FrameSortAble("removeDataSource");
                var DataValue = { Data: model.ContractAttach, Status: item.Status };
                $("#sortable-handlers").FrameSortAble("setDataSource", DataValue);
                hideLoading();
            });
        }
    }

    that.InitControlsDataV = function (model) {
        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DeptName").FrameTextBox('setValue', model.DeptName);
        $("#DeptNameEn").FrameTextBox('setValue', model.DeptNameEn);
        $("#DivDealer").FrameTextBox('setValue', model.DealerName);
        $("#ContractStatus").FrameTextBox("setValue", model.Status);

        $("#ExportId").val(model.ExportId);
        $("#DealerId").val(model.DealerId);
        $("#ContractDate").FrameDatePicker('setValue', model.ContractDate);
        $("#PlatformName").FrameTextBox('setValue', model.PlatformName);
        $("#DealerName").FrameTextBox('setValue', model.DealerName);
        $("#DealerAddress").FrameTextBox('setValue', model.DealerAddress);
        $("#DealerManager").FrameTextBox('setValue', model.DealerManager);
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AgreementStartDate);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AgreementEndDate);;
   
        $("#PaymentDate").FrameDatePicker('setValue', model.PaymentDate);
    }

    that.InitControlsData = function (model) {
        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DeptName").FrameTextBox('setValue', model.ProductName);
        $("#DeptNameEn").FrameTextBox('setValue', model.ProductEName);
        $("#DivDealer").FrameTextBox('setValue', model.CompanyName);

        $("#DealerId").val(model.DealerId);
        $("#PlatformId").val(model.LPId);
        $("#PaymentDate").FrameDatePicker('setValue', model.PaymentDate);
        $("#PlatformName").FrameTextBox('setValue', model.LPName);
        $("#DealerName").FrameTextBox('setValue', model.CompanyName);
        $("#DealerAddress").FrameTextBox('setValue', model.OfficeAddress);
        $("#DealerManager").FrameTextBox('setValue', model.Contact);
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AgreementBegin);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AgreementEnd);;
        
    }

    that.InitDivControls = function () {
        $("#ContractVer").kendoDropDownList({
            dataTextField: "VersionNo",
            dataValueField: "ExportId",
            change: that.changeVerssionStatus
        });
        $("#ContractStatus").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#ContractStatus").FrameTextBox('disable');
        $("#ContractNo").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#ContractNo").FrameTextBox('disable');

        $("#DeptName").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DeptName").FrameTextBox('disable');

        $("#DeptNameEn").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DeptNameEn").FrameTextBox('disable');

        $("#DivContractClass").FrameTextBox({
            value: $.getUrlParam("ContractTypeName"),
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivContractClass").FrameTextBox('disable');

        $("#DivDealerType").FrameTextBox({
            value: 'T2',
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivDealerType").FrameTextBox('disable');


        $("#PlatformName").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#PlatformName").FrameTextBox('disable');

        $("#DealerName").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DealerName").FrameTextBox('disable');

        $("#DealerAddress").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DealerAddress").FrameTextBox('disable');

        $("#DealerManager").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DealerManager").FrameTextBox('disable');


        $("#AgreementStartDate").FrameDatePicker({
            format: "yyyy-MM-dd",
            depth: "month",
            start: "month",
        });
        //$("#AgreementStartDate").FrameDatePicker('disable');

        $("#AgreementEndDate").FrameDatePicker({
            format: "yyyy-MM-dd",
            depth: "month",
            start: "month",
        });
        $("#AgreementEndDate").FrameDatePicker('disable');

        $("#ContractDate").FrameDatePicker({
            format: "yyyy-MM-dd",
            depth: "month",
            start: "month",
        });
        $("#PaymentDate").FrameDatePicker({
            format: "yyyy-MM-dd",
            depth: "month",
            start: "month",
        });
    }

    var InitContractList = function () {
        var data = [
            { ProjectID: "1", ProjectName: "经销商协议_LP", isCheck: true },
            { ProjectID: "2", ProjectName: "经销商协议_LP_附件一", isCheck: true },
            { ProjectID: "3", ProjectName: "经销商协议_LP_附件二", isCheck: true },
            { ProjectID: "4", ProjectName: "经销商协议_LP_附件三", isCheck: true },
            { ProjectID: "5", ProjectName: "设备采购附件", isCheck: true },
            { ProjectID: "6", ProjectName: "医疗器械质量保证协议-LP", isCheck: true },
            { ProjectID: "7", ProjectName: "数据质量保证函", isCheck: true }
        ];
        $.MySortAble('sortable-handlers', data);
    }

    var unBindItem = function () {
        $('.tem').unbind('click', function () { })
    }

    var setLayout = function () {
        var h = $('.content-main').height();
        // $('#DiscountList').css("height", (h - 405) + "px");

        $("#PnlContractContent").css("height", (h - 30) + "px");

        var PnlContractInfo = $('#PnlContractInfo').height();
        var PnlContractBase = $('#PnlContractBase').height();

        var PnlContractSelect = (PnlContractInfo - PnlContractBase - 60) + "px";
        $("#PnlContractSelect").css("height", PnlContractSelect);

    }

    return that;
}();