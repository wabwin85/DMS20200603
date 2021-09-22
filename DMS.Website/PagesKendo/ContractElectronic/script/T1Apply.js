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
        $("#BtnUploadProxy").attr({ "data-tmpid": NewGuid(), "data-file": "OtherAttachment", "data-type": "OtherAttachment" });
        $("#hideDivPayType1").hide();
        $("#hideDivPayType2").hide();

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
        };

        var data = that.GetModel('InsertExportSubmit');

        if (data.PaymentType == "Credit") {

            if ((parseFloat(data.CompanyGuarantee) + parseFloat(data.BankGuarantee) - parseFloat(data.CreditLimit)) != 0) {
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: "【银行保函】加上【母公司保函】必须等于【信用限额】",
                });
                hideLoading();
                return false;
            }
        }

        data.ContractTemplateList = $("#sortable-handlers").FrameSortAble("getSelectValue");
        data.ContractTemplatePdfList = $("a.UserFile").FrameSortAble("gatherFileInfo");
        var ChekFile = true;
        var Messing = "";
        $.each(data.ContractTemplateList, function (i, item) {
            if (item.FileType == "OtherAttachment") {

                var obj = $("a.UserFile[data-type=OtherAttachment]");
                if (obj == null || obj.length <= 0) {
                    ChekFile = false;
                    Messing += "请上传其它附件;";
                    hideLoading();
                }
            }
        });
        if (!ChekFile) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: Messing,
            });

            return false;
        };
        
        if (!that.checkEndTime(data.AgreementStartDate, data.AgreementEndDate))
        {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: "协议终止日期不能小于协议开始日期",
            });
            hideLoading();
            return false;
        }

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
        showLoading();
        var data = that.GetModel('InsertExportCache');
        data.ContractTemplateList = $("#sortable-handlers").FrameSortAble("getSelectValue");
        data.ContractTemplatePdfList = $("a.UserFile").FrameSortAble("gatherFileInfo");
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
        var data = that.GetModel('InitT1ApplyRenew');
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
                    });
                  
                    $("#ContractVer").data("kendoDropDownList").setDataSource(model.ContractVerList);
                    $("#ContractVer").data("kendoDropDownList").select(0);
                    //有历史版本显示导出按钮
                    var item = $("#ContractVer").data("kendoDropDownList").dataItem();

                    that.ControlBtn(item.VersionStatus)

                    $("#ContractStatus").FrameTextBox("setValue", model.ContractVerList[0].Status);
                    that.InitControlsDataV(model.ContractVerList[0]);

                } else {
                    that.InitControlsData(model.ContractList[0]);
                }
             
              

                $("#sortable-handlers").FrameSortAble("removeDataSource");
                var Status = item == null ? "草稿" : item.Status;
             
                var DataValue = { Data: model.ContractAttach, Status: Status };
                $("#sortable-handlers").FrameSortAble("setDataSource", DataValue);
                $("a.UserFile").remove();
                $("a.Proxyfile").remove();
                that.InitUserFileUpload(model);
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
                var DataValue = { Data: model.ContractAttach, Status: item.Status };
                $("#sortable-handlers").FrameSortAble("setDataSource", DataValue);
                $("a.UserFile").remove();
                $("a.Proxyfile").remove();
                that.InitUserFileUpload(model);
                hideLoading();
            });
        }
    }
    that.InitUserFileUpload = function (model) {

        $.each(model.ContractAttach, function (i, item) {
            if (item.TemplateFile1 != null) {

                var btn = $("button[data-file='" + item.FileType + "']");
                btn.attr("data-tmpid", NewGuid())
                var Type = btn.attr("data-type");
                btn.attr("data-path", item.TemplateFile1);
                btn.attr("data-fileName", item.FileName);

                //var id = btn.attr("id");
                var value = { FilePath: item.TemplateFile1, FileName: item.FileName, Type: Type };
                btn.FrameSortAble("FileaddNewData", value)
            }

            //alert(item.TemplateId)
        });
    };
    that.InitControlsDataV = function (model) {
        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DivBU").FrameTextBox('setValue', model.DeptName);
        $("#DivContractType").FrameTextBox('setValue', model.DeptNameEn);
        $("#DivDealer").FrameTextBox('setValue', model.DealerName);
        $("#ContractStatus").FrameTextBox("setValue", model.Status);

        $("#DealerName").FrameTextBox('setValue', model.DealerName);
        $("#DealerNameEn").FrameTextBox('setValue', model.DealerNameEn);
        $("#DealerAddress").FrameTextBox('setValue', model.DealerAddress);
        $("#DealerManager").FrameTextBox('setValue', model.DealerManager);
        $("#DealerMail").FrameTextBox('setValue', model.DealerMail);
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AgreementStartDate);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AgreementEndDate);
        $("#DeptName").FrameTextBox('setValue', model.DeptName);
        $("#DeptNameEn").FrameTextBox('setValue', model.DeptNameEn);
        $("#DealerPhone").FrameTextBox('setValue', model.DealerPhone);
        $("#DealerFax").FrameTextBox('setValue', model.DealerFax);
        if (model.PaymentType == 'Credit') {
            $("#hideDivPayType1").show();
            $("#hideDivPayType2").show();
        }
        $("#PaymentType").FrameTextBox('setValue', model.PaymentType);
        $("#CreditLimit").FrameTextBox('setValue', model.CreditLimit);
        $("#DealerAddressEn").FrameTextBox('setValue', model.DealerAddressEn);
        $("#DealerManagerEn").FrameTextBox('setValue', model.DealerManagerEn);
        $("#PaymentDays").FrameTextBox('setValue', model.PaymentDays);
        $("#BankGuarantee").FrameTextBox('setValue', model.BankGuarantee);
        $("#CompanyGuarantee").FrameNumeric('setValue', model.CompanyGuarantee);
        $("#ExportId").val(model.ExportId);
        $("#SubProductName").val(model.SubProductName);
        $("#SubProductEName").val(model.SubProductEName);
        $("#DealerId").val(model.DealerId);
    }

    that.InitControlsData = function (model) {
        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DivBU").FrameTextBox('setValue', model.ProductName);
        $("#DivContractType").FrameTextBox('setValue', model.ProductEName);
        $("#DivDealer").FrameTextBox('setValue', model.CompanyName);

        $("#DealerName").FrameTextBox('setValue', model.CompanyName);
        $("#DealerNameEn").FrameTextBox('setValue', model.CompanyEName);
        $("#DealerAddress").FrameTextBox('setValue', model.OfficeAddress);
        $("#DealerManager").FrameTextBox('setValue', model.Contact);
        $("#DealerMail").FrameTextBox('setValue', model.EMail)
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AgreementBegin);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AgreementEnd);
        $("#DeptName").FrameTextBox('setValue', model.ProductName);
        $("#DeptNameEn").FrameTextBox('setValue', model.ProductEName);
        $("#DealerPhone").FrameTextBox('setValue', model.Mobile);
        $("#DealerFax").FrameTextBox('setValue', model.OfficeNumber);
        if (model.Payment == 'Credit') {
            $("#hideDivPayType1").show();
            $("#hideDivPayType2").show();
        }
        $("#PaymentType").FrameTextBox('setValue', model.Payment);
        $("#CreditLimit").FrameTextBox('setValue', model.CreditLimit);
        $("#SubProductName").val(model.SubProductName);
        $("#SubProductEName").val(model.SubProductEName);
        $("#DealerId").val(model.DealerId);
    }
    that.InitControlsDataView = function () {
        $("#DealerAddressEn").FrameTextBox('disable');
        $("#DealerManagerEn").FrameTextBox('disable');
        $("#AgreementStartDate").FrameDatePicker('disable');
        $("#AgreementEndDate").FrameDatePicker('disable');
        $("#PaymentDays").FrameTextBox('disable');
        $("#BankGuarantee").FrameTextBox('disable');
        $("#CompanyGuarantee").FrameNumeric('disable');
        $("#CreditLimit").FrameTextBox('disable');
        $("#BtnDownLoadProxyTemplate").attr("disabled", true);
        $("#BtnUploadProxy").attr("disabled", true);

        $("#DealerFax").FrameTextBox("disable");
        $("#DealerMail").FrameTextBox("disable");
        $("#DealerPhone").FrameTextBox("disable");
        $("#DealerManager").FrameTextBox("disable");
    };
    that.InitControlsDataEnable = function () {
        $("#DealerAddressEn").FrameTextBox('enable');
        $("#DealerManagerEn").FrameTextBox('enable');
        $("#AgreementStartDate").FrameDatePicker('enable');
        $("#AgreementEndDate").FrameDatePicker('enable');
        $("#PaymentDays").FrameTextBox('enable');
        $("#BankGuarantee").FrameTextBox('enable');
        $("#CompanyGuarantee").FrameNumeric('enable');
        $("#CreditLimit").FrameTextBox('enable');
        $("#BtnDownLoadProxyTemplate").attr("disabled", false);
        $("#BtnUploadProxy").attr("disabled", false);

        $("#DealerFax").FrameTextBox("enable");
        $("#DealerMail").FrameTextBox("enable");
        $("#DealerPhone").FrameTextBox("enable");
        $("#DealerManager").FrameTextBox("enable");
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

        $("#DealerPhone").FrameTextBox({
            value: ""//,
            //style: "background-color:#EEEEEE;width:100%;"
        });
        //$("#DealerPhone").FrameTextBox('disable');

        $("#DealerFax").FrameTextBox({
            value: ""//,
            //style: "background-color:#EEEEEE;width:100%;"
        });
        //$("#DealerFax").FrameTextBox('disable');

        $("#DealerMail").FrameTextBox({
            value: ""//,
            //style: "background-color:#EEEEEE;width:100%;"
        });
        //$("#DealerMail").FrameTextBox('disable');

        $("#DealerManager").FrameTextBox({
            value: ""//,
            //style: "background-color:#EEEEEE;width:100%;"
        });
       //$("#DealerManager").FrameTextBox('disable');

        $("#DealerManagerEn").FrameTextBox({
            value: "",
        });

        $("#AgreementStartDate").FrameDatePicker({
            format: "yyyy-MM-dd",
            depth: "month",
            start: "month",
        });
        $("#AgreementEndDate").FrameDatePicker({
            format: "yyyy-MM-dd",
            depth: "month",
            start: "month",
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

        $("#PaymentType").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#PaymentType").FrameTextBox('disable');

        $("#PaymentDays").FrameTextBox({
            value: "",
        });

        $("#BankGuarantee").FrameTextBox({
            value: "",
        });

        $("#CompanyGuarantee").FrameNumeric({
            value: 0,
        });

        $("#CreditLimit").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#CreditLimit").FrameTextBox('disable');

        var curWwwPath = window.document.location.href;
        var pos = curWwwPath.indexOf(window.document.location.pathname);
        $('#BtnDownLoadProxyTemplate').FrameButton({
            onClick: function () {
                window.location = curWwwPath.substring(0, pos) + "/Upload/ContractElectronicAttachmentTemplate/LP/AppointmentRenewal/其它附件.docx";
            }
        });

        $('#UploadProxyfiles').kendoUpload({
            async: {
                saveUrl: "/pageskendo/ContractElectronic/handlers/UploadHandler.ashx?Type=OtherAttachment&NewFileName=" + NewGuid(),
                autoUpload: true
            },
            select: function (e) {
                var file = e.files;
                if (file[0].extension != '.pdf') {
                    showAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '仅支持PDF上传',
                    });
                }

            },
            validation: {
                allowedExtensions: [".pdf"],
            },
            multiple: false,
            success: function (e) {
                $("#BtnUploadProxy").FrameSortAble("FileaddNewData", e.response)
            }
        });

        $('#BtnUploadProxy').FrameButton({
            onClick: function () {
                document.getElementById('UploadProxyfiles').click();
            }
        });
        $("#BtnPreview").FrameButton({
            onClick: function () {
                that.ExportPDF("Preview");
            }
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

        $.each(data.ContractTemplateList, function (i, item) {
            if (item.FileType == "OtherAttachment") {


                var obj = $("a.UserFile[data-type=OtherAttachment]");
                if (obj == null || obj.length <= 0) {
                    ChekFile = false;
                    Messing += "请通知经销商上传【其它附件】";
                    hideLoading();
                }
            }
        });

        if (!ChekFile) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: Messing,
            });

            return false;
        }

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
    //校验
    //that.CheckedFormInfo = function () {
    //    var AgreementStartDate = $("#AgreementStartDate_Control").val()
    //};

    that.checkEndTime = function (startTime, endTime) {
        
        var start = new Date(startTime.replace("-", "/").replace("-", "/"));
        var end = new Date(endTime.replace("-", "/").replace("-", "/"));
    
        if (end < start) {
            return false;
        }
        return true;
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
    function S4() {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    }
    var NewGuid = function () {
        return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
    };
    var setLayout = function () {
        var h = $('.content-main').height();
        // $('#DiscountList').css("height", (h - 405) + "px");

        $("#PnlContractContent").css("height", (h - 30) + "px");

        var PnlContractInfo = $("#PnlContractInfo").height();
        var PnlContractBase = $("#PnlContractBase").height();

        var PnlContractSelect = (PnlContractInfo - PnlContractBase - 60) + "px";
        $("#PnlContractSelect").css("height", PnlContractSelect);

    }

    return that;

}();