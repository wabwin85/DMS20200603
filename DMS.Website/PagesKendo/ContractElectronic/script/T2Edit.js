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
        $("#SubBuName").val($.getUrlParam("ProductLineName"));
        $("#SubBuNameEn").val($.getUrlParam("DivisionCode"));
        $("#ExportId").val("00000000-0000-0000-0000-000000000000");
        //$("#DealerId").val($.getUrlParam("DealerID"));
       
        //$("#DealerType").val($.getUrlParam("DivisionCode"));
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
        $("#BtnContractRevoke").FrameButton({
            onClick: function () {
                that.RevokeConfirmOpen();
            }
        });
        $('#BtnSelectAll').bind('click', function () {
            $.MySelectedAll("BtnSelectAll");
        })

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
        //data.DealerId = $.getUrlParam("DealerID");
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
        var data = that.GetModel('InitT2Modify');
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
                   
                    $("#ContractStatus").FrameTextBox("setValue", model.ContractVerList[0].Status);
                    var item = $("#ContractVer").data("kendoDropDownList").dataItem();
                    that.ControlBtn(item.VersionStatus)
                    if (model.ContractVerList[0].Status == "草稿") {
                        $("#BtnGiveupCache").show();
                    }
                    that.InitControlsDataV(model.ContractVerList[0]);

                } else {
                    that.InitControlsData(model.ContractList[0]);
                }
                $("#sortable-handlers").FrameSortAble("removeDataSource");

                var Status = item == null ? "草稿" : item.Status;
                var DataValue = { Data: model.ContractAttach, Status: Status };
                $("#sortable-handlers").FrameSortAble("setDataSource", DataValue);

                //$("#sortable-handlers").FrameSortAble("setDataSource", model.ContractAttach);
            }
            hideLoading();
        });
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



    that.InitControlsDataV = function (model) {

        $("#PlatformId").val(model.PlatformId);
        $("#DealerId").val(model.DealerId);


        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DivContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DeptName").FrameTextBox('setValue', model.DeptName);
        $("#DeptNameEn").FrameTextBox('setValue', model.DeptNameEn);
        $("#DivDealer").FrameTextBox('setValue', model.DealerName);
        $("#ContractStatus").FrameTextBox("setValue", model.Status);
        $("#PlatformName").FrameTextBox('setValue', model.PlatformName);
        $("#DealerName").FrameTextBox('setValue', model.DealerName);
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AgreementStartDate);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AgreementEndDate);


        $("#ExportId").val(model.ExportId);
        $("#SubBuName").FrameTextBox("setValue", $.getUrlParam("ProductLineName"));
        $("#SubBuNameEn").FrameTextBox("setValue", $.getUrlParam("DivisionCode"));
        //$('#IsAddNew').data("kendoMobileSwitch").check(model.IsAddNew);
        $("#IsAddNew").FrameSwitch('setValue', model.IsAddNew);
        $("#PlatformBusinessContact").FrameTextBox('setValue', model.PlatformBusinessContact);
        $("#PlatformBusinessPhone").FrameTextBox('setValue', model.PlatformBusinessPhone);
        $("#SubDeptName").FrameTextBox('setValue', model.SubDeptName);
        $("#SubDeptNameEn").FrameTextBox('setValue', model.SubDeptNameEn);
    }

    that.InitControlsData = function (model) {
        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DivContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DeptName").FrameTextBox('setValue', model.ProductName);
        $("#DeptNameEn").FrameTextBox('setValue', model.ProductEName);
        $("#DivDealer").FrameTextBox('setValue', model.CompanyName);
        $("#SubBuName").FrameTextBox("setValue", $.getUrlParam("ProductLineName"));
        $("#SubBuNameEn").FrameTextBox("setValue", $.getUrlParam("DivisionCode"));
        $("#DealerId").val(model.DealerId);
        $("#PlatformId").val(model.LPId);
        $("#PlatformName").FrameTextBox('setValue', model.LPName);
        $("#DealerName").FrameTextBox('setValue', model.CompanyName);
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AmendBegineDate);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AmendEndDate);
        $("#SubDeptName").FrameTextBox('setValue', model.SubDeptName);
        $("#SubDeptNameEn").FrameTextBox('setValue', model.SubDeptNameEn);
    }
    that.ChangeIsNewProductline = function (e) {
        if (e.checked) {
            $("#SubTr").show();
        }
        else {
            $("#SubTr").hide();
        }
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
            value: ""
        });
        //$("#ContractNo").FrameTextBox('disable');
        $("#DivContractNo").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivContractNo").FrameTextBox('disable');
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

        $("#PlatformName").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#PlatformName").FrameTextBox('disable');

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

        $("#IsAddNew").FrameSwitch({
            value: false,
            onChange: that.ChangeIsNewProductline
        })

        //$("#IsAddNew").kendoMobileSwitch({
        //    onLabel: '是',
        //    offLabel: '否',
        //    checked: false,
        //    change: function (e) {
        //        if (e.checked) {
        //            $("#SubTr").show();
        //        }
        //        else {
        //            $("#SubTr").hide();
        //        }
        //    }
        //});
        $("#PlatformBusinessContact").FrameTextBox({
            value: "",
        });

        $("#PlatformBusinessPhone").FrameTextBox({
            value: "",
        });
        $("#SubDeptName").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#SubBuName").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#SubBuName").FrameTextBox('disable');
        $("#SubBuNameEn").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#SubBuNameEn").FrameTextBox('disable');

        $("#SubDeptName").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
       
        $("#SubDeptNameEn").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
   
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