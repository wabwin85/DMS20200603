var Page = {};
Page = function () {
    var that = {};
    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;
        return model;
    }
    that.InitPage = function () {
        showLoading();
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
        $("#BtnPreview").FrameButton({
            onClick: function () {
                that.ExportPDF("Preview");
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
        $('#BtnSelectAll').bind('click', function () {
            $.MySelectedAll("BtnSelectAll");
        });
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
        data.ContractTemplatePdfList = [];



        //console.log(data.ContractTemplateList);

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
        if (!$.CheckdSubmit()) {

            showAlert({
                target: 'top',
                alertType: 'info',
                message: "请填写必填项",
            });
            hideLoading();
            return false;
        }
        var data = that.GetModel('InsertExportSubmit');
        data.ContractTemplateList = $("#sortable-handlers").FrameSortAble("getSelectValue");

        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
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
        var data = that.GetModel('InsertExportCache');
        data.ContractTemplateList = $("#sortable-handlers").FrameSortAble("getSelectValue");
        showLoading();
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
        var data = that.GetModel('InitLPAndT1Term');
        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
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
                    //有历史版本显示导出按钮
                    var item = $("#ContractVer").data("kendoDropDownList").dataItem();
                    that.ControlBtn(item.VersionStatus);

                    $("#ContractStatus").FrameTextBox("setValue", model.ContractVerList[0].Status);


                    that.InitControlsDataV(model.ContractVerList[0]);

                } else {
                    that.InitControlsData(model.ContractList[0]);
                }



                //alert(JSON.stringify(model.ContractVerList))


                var Status = item == null ? "草稿" : item.Status;
                $("#sortable-handlers").FrameSortAble("removeDataSource");
                var DataValue = { Data: model.ContractAttach, Status: Status };
                $("#sortable-handlers").FrameSortAble("setDataSource", DataValue);
            }
            hideLoading();
        });
    }
    that.changeVerssionStatus = function () {
        var item = $("#ContractVer").data("kendoDropDownList").dataItem();
        if (item) {
            showLoading();
            that.ControlBtn(item.VersionStatus);
            that.InitControlsDataV(item);
            var data = that.GetModel('SelectAttach');
            data.SelectExportId = $("#ContractVer").data("kendoDropDownList").value();
            submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
                $("#sortable-handlers").FrameSortAble("removeDataSource");
                $("#sortable-handlers").FrameSortAble("setDataSource", model.ContractAttach);
                hideLoading();
            });
        }
    }

    that.InitControlsDataV = function (model) {
        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DivBU").FrameTextBox('setValue', model.DeptName);
        $("#DivDealerType").FrameTextBox('setValue', 'T1');
        $("#DivDealer").FrameTextBox('setValue', model.DealerName);
        $("#ContractStatus").FrameTextBox("setValue", model.Status);

        $("#DealerName").FrameTextBox('setValue', model.DealerName);
        $("#DealerNameEn").FrameTextBox('setValue', model.DealerNameEn);
        $("#DealerAddress").FrameTextBox('setValue', model.DealerAddress);
        $("#DealerManager").FrameTextBox('setValue', model.DealerManager);
        $("#DeptName").FrameTextBox('setValue', model.DeptName);
        $("#DeptNameEn").FrameTextBox('setValue', model.DeptNameEn);
        $("#TerminationType").FrameTextBox('setValue', model.TerminationType);
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AgreementStartDate);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AgreementEndDate);
        $("#Balance").FrameTextBox('setValue', model.CurrentAR);

        $("#DealerAddressEn").FrameTextBox('setValue', model.DealerAddressEn);
        $("#DealerManagerEn").FrameTextBox('setValue', model.DealerManagerEn);
        $("#ApplicantName").FrameTextBox('setValue', model.ApplicantName);
        $("#ApplicantNameEn").FrameTextBox('setValue', model.ApplicantNameEn);
        $("#ExportId").val(model.ExportId);
        $("#SubProductName").val(model.SubProductName);
        $("#SubProductEName").val(model.SubProductEName);
        $("#DealerId").val(model.DealerId);
    }

    that.InitControlsData = function (model) {
        console.log(model);
        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DivBU").FrameTextBox('setValue', model.ProductName);
        $("#DivDealerType").FrameTextBox('setValue', 'T1');
        $("#DivDealer").FrameTextBox('setValue', model.CompanyName);


        $("#DealerName").FrameTextBox('setValue', model.CompanyName);
        $("#DealerNameEn").FrameTextBox('setValue', model.CompanyEName);
        $("#DealerAddress").FrameTextBox('setValue', model.OfficeAddress);
        $("#DealerManager").FrameTextBox('setValue', model.Contact);

        $("#DeptName").FrameTextBox('setValue', model.ProductName);
        $("#DeptNameEn").FrameTextBox('setValue', model.ProductEName);
        $("#TerminationType").FrameTextBox('setValue', model.TerminationType);
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AgreementBegin);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AgreementEnd);

        $("#Balance").FrameTextBox('setValue', model.CurrentAR);
        $("#SubProductName").val(model.SubProductName);
        $("#SubProductEName").val(model.SubProductEName);
        $("#DealerId").val(model.DealerId);
    }
    that.InitControlsDataView = function () {
        $("#DealerManagerEn").FrameTextBox("disable");
        $("#DealerAddressEn").FrameTextBox("disable");
        $("#ApplicantName").FrameTextBox("disable");
        $("#ApplicantNameEn").FrameTextBox("disable");
        
    };
    that.InitControlsDataEnable = function () {
        $("#DealerManagerEn").FrameTextBox("enable");
        $("#DealerAddressEn").FrameTextBox("enable");
        $("#ApplicantName").FrameTextBox("enable");
        $("#ApplicantNameEn").FrameTextBox("enable");
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

        $("#DivBU").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivBU").FrameTextBox('disable');

        $("#DivContractType").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivContractType").FrameTextBox('disable');

        $("#DivContractClass").FrameTextBox({
            value: $.getUrlParam("ContractTypeName"),
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivContractClass").FrameTextBox('disable');

        $("#DivDealerType").FrameTextBox({
            value: 'T1',
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivDealerType").FrameTextBox('disable');
        $("#DivDealer").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivDealer").FrameTextBox('disable');




        $("#DealerName").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DealerName").FrameTextBox('disable');

        $("#DealerNameEn").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DealerNameEn").FrameTextBox('disable');

        $("#DealerAddress").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DealerAddress").FrameTextBox('disable');

        $("#DealerAddressEn").FrameTextBox({
            value: "",
        });

        $("#DealerManager").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DealerManager").FrameTextBox('disable');

        $("#DealerManagerEn").FrameTextBox({
            value: "",
        });

        $("#AgreementStartDate").FrameDatePicker({
            format: "yyyy-MM-dd",
            depth: "month",
            start: "month",
        });
        $("#AgreementStartDate").FrameDatePicker('disable');

        $("#AgreementEndDate").FrameDatePicker({
            format: "yyyy-MM-dd",
            depth: "month",
            start: "month",
        });
        $("#AgreementEndDate").FrameDatePicker('disable');

        $("#ApplicantName").FrameTextBox({
            value: "",
        });

        $("#ApplicantNameEn").FrameTextBox({
            value: "",
        });

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

        $("#TerminationType").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });

        $("#TerminationType").FrameTextBox('disable');


        $("#Balance").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#Balance").FrameTextBox('disable');

    }
    that.ControlBtn = function (Status) {

        if (Status == "Draft") {
            that.InitControlsDataEnable();
            $("#BtnSubmit").show();
            $("#BtnPDFExport").hide();
            $("#BtnPDFCache").show();
            $("#BtnGiveupCache").show();
            $("#BtnPreview").show();
            $("#BtnContractRevoke").hide();
        }
        else if (Status == "WaitDealerSign") {
            that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").hide();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").show();
        }
        else if (Status == "WaitDealerSign" || Status == "WaitBscSign") {
            that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").hide();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").show();
        }
        else if (Status == "Complete") {
            that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").hide();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").hide();
        }
        else if (Status == "Cancelled") {
            that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").show();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").hide();
        }
        else if (Status == "WaitDealerAbandonment") {
            that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").hide();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").hide();
        }
        else if (Status == "Abandonment") {
            that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").show();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").hide();
        }

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
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
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