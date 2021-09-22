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
        $(".hideDivPayType1").hide();
        $(".hideDivPayType2").hide();
        $("#BtnPreview").FrameButton({
            onClick: function () {
                that.ExportPDF("Preview");
            }
        });
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
        }
        var data = that.GetModel('InsertExportSubmit');
        data.ContractTemplateList = $("#sortable-handlers").FrameSortAble("getSelectValue");
        if (!that.checkEndTime(data.OriginalStartDate, data.OriginalEndDate)) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: "原协议到期日期终止日期不能小于原协议到期日期开始日期",
            });
            hideLoading();
            return false;
        }
        if (!that.checkEndTime(data.AgreementStartDate, data.AgreementEndDate)) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: "补充协议生效日期到期日期终止日期不能小于补充协议生效日期开始日期",
            });
            hideLoading();
            return false;
        };
        if (data.IsProduct == "0" && data.IsPrices == "0" && data.IsTerritory == "0" && data.IsPurchase == "0" && data.IsPayment == "0")
        {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: "必须选择一个商务条款",
            });
            hideLoading();
            return false;
        }

        if (data.PaymentType == "Credit" && data.IsPayment == "1") {

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
       // data.Rebate = that.DiscountList();
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
    that.checkEndTime = function (startTime, endTime) {

        var start = new Date(startTime.replace("-", "/").replace("-", "/"));
        var end = new Date(endTime.replace("-", "/").replace("-", "/"));
        if (end < start) {
            return false;
        }
        return true;
    }
    that.QueryInitData = function () {
        var data = that.GetModel('InitLPAndT1Modify');
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
                    $("#ContractStatus").FrameTextBox("setValue", model.ContractVerList[0].Status);
               
                    that.ControlBtn(item.VersionStatus);
                    that.InitControlsDataV(model.ContractVerList[0]);

                } else {
                    that.InitControlsData(model.ContractList[0]);
                }
                var Status = item == null ? "草稿" : item.Status;
                var DataValue = { Data: model.ContractAttach, Status: Status };
                $("#sortable-handlers").FrameSortAble("removeDataSource");
                $("#sortable-handlers").FrameSortAble("setDataSource", DataValue);

            }

            //初始化【最低采购额度】
            $("#IsPurchase").FrameCheckBox("purchaseControl");
            //初始化【最低授权区域】
            $("#IsTerritory").FrameCheckBox("territoryControl");
            //初始化【支付方式】
            $("#IsPayment").FrameCheckBox("paymentControl", $("#PaymentType").FrameTextBox('getValue'));

            //绑定【最低采购额度】事件
            $("#IsPurchase").FrameCheckBox("purchaseCheck");
            //绑定【销售区域】事件
            $("#IsTerritory").FrameCheckBox("territoryCheck");
            //绑定【付款方式】事件
            $("#IsPayment").FrameCheckBox("paymentCheck", $("#PaymentType").FrameTextBox('getValue'));

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
                var Status = item == null ? "草稿" : item.Status;
                var DataValue = { Data: model.ContractAttach, Status: Status };
                $("#sortable-handlers").FrameSortAble("setDataSource", DataValue);
                hideLoading();
            });
        }
    }

    that.InitControlsDataV = function (model) {
        $("#DivContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DivBU").FrameTextBox('setValue', model.DeptName);
        $("#DivContractType").FrameTextBox('setValue', model.DeptNameEn);
        $("#DivDealer").FrameTextBox('setValue', model.DealerName);
        $("#ContractStatus").FrameTextBox("setValue", model.Status);

        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#OriginalNo").FrameTextBox('setValue', model.OriginalNo);

        $("#OriginalStartDate").FrameDatePicker('setValue', model.OriginalStartDate);
        $("#OriginalEndDate").FrameDatePicker('setValue', model.OriginalEndDate);

        $("#DealerName").FrameTextBox('setValue', model.DealerName);
        $("#DealerNameEn").FrameTextBox('setValue', model.DealerNameEn);
        $("#DeptName").FrameTextBox('setValue', model.DeptName);
        $("#DeptNameEn").FrameTextBox('setValue', model.DeptNameEn);
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AgreementStartDate);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AgreementEndDate);
      
        if (model.PaymentType == 'Credit') {
            $(".hideDivPayType1").show();
            $(".hideDivPayType2").show();
        }
        $("#PaymentType").FrameTextBox('setValue', model.PaymentType);
        $("#CreditLimit").FrameTextBox('setValue', model.CreditLimit);

        $("#COName").FrameTextBox('setValue', model.COName);
        $("#CONameEn").FrameTextBox('setValue', model.CONameEn);
        $("#COContactInfo").FrameTextBox('setValue', model.COContactInfo);
        $("#PaymentDays").FrameTextBox('setValue', model.PaymentDays);
        $("#BankGuarantee").FrameTextBox('setValue', model.BankGuarantee);
        $("#CompanyGuarantee").FrameNumeric('setValue', model.CompanyGuarantee);
        $("#ExportId").val(model.ExportId);
        $("#SubProductName").val(model.SubProductName);
        $("#SubProductEName").val(model.SubProductEName);
    
        $("#IsProduct").FrameCheckBox('setValue', model.IsProduct);
        $("#IsPrices").FrameCheckBox('setValue', model.IsPrices);
        $("#IsTerritory").FrameCheckBox('setValue', model.IsTerritory);
        $("#IsPurchase").FrameCheckBox('setValue', model.IsPurchase);
        $("#IsPayment").FrameCheckBox('setValue', model.IsPayment);
        $("#DealerId").val(model.DealerId);
    }

    that.InitControlsData = function (model) {
        $("#DivContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DivBU").FrameTextBox('setValue', model.ProductName);
        $("#DivContractType").FrameTextBox('setValue', model.ProductEName);
        $("#DivDealer").FrameTextBox('setValue', model.CompanyName);

        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#OriginalNo").FrameTextBox('setValue', model.ContractNoCurrent);
        $("#OriginalStartDate").FrameDatePicker('setValue', model.DealerBeginDate);
        $("#OriginalEndDate").FrameDatePicker('setValue', model.DealerEndDate);
        $("#DealerName").FrameTextBox('setValue', model.CompanyName);
        $("#DealerNameEn").FrameTextBox('setValue', model.CompanyEName);
        $("#DeptName").FrameTextBox('setValue', model.ProductName);
        $("#DeptNameEn").FrameTextBox('setValue', model.ProductEName);
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AmendBegineDate);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AmendEndDate);
        if (model.Payment == 'Credit') {
            $(".hideDivPayType1").show();
            $(".hideDivPayType2").show();
        }
        $("#PaymentType").FrameTextBox('setValue', model.Payment);
        $("#CreditLimit").FrameTextBox('setValue', model.CreditLimit);
        $("#SubProductName").val(model.SubProductName);
        $("#SubProductEName").val(model.SubProductEName);
        $("#DealerId").val(model.DealerId);
        //$("#ExportId").val(model.ExportId);
        //alert(model.ExportId)
    }
    that.InitControlsDataView = function () {
        $("#OriginalNo").FrameTextBox('disable');
        $("#AgreementStartDate").FrameDatePicker('disable');
        $("#OriginalStartDate").FrameDatePicker('disable');
        $("#OriginalEndDate").FrameDatePicker('disable');
        $("#COName").FrameTextBox('disable');

        $("#CONameEn").FrameTextBox('disable');
        $("#COContactInfo").FrameTextBox('disable');
        $("#PaymentDays").FrameTextBox('disable');
        $("#BankGuarantee").FrameTextBox('disable');
        $("#CreditLimit").FrameTextBox('disable');
        $("#CompanyGuarantee").FrameNumeric('disable');

        $("#IsProduct").FrameCheckBox('disable');
        $("#IsPrices").FrameCheckBox('disable');
        $("#IsTerritory").FrameCheckBox('disable');
        $("#IsPurchase").FrameCheckBox('disable');
        $("#IsPayment").FrameCheckBox('disable');
    };
    that.InitControlsDataEnable = function ()
    {
        $("#OriginalNo").FrameTextBox('enable');
        $("#AgreementStartDate").FrameDatePicker('enable');
        $("#OriginalStartDate").FrameDatePicker('enable');
        $("#OriginalEndDate").FrameDatePicker('enable');
        $("#COName").FrameTextBox('enable');

        $("#CONameEn").FrameTextBox('enable');
        $("#COContactInfo").FrameTextBox('enable');
        $("#PaymentDays").FrameTextBox('enable');
        $("#BankGuarantee").FrameTextBox('enable');
        $("#CreditLimit").FrameTextBox('enable');
        $("#CompanyGuarantee").FrameNumeric('enable');

        $("#IsProduct").FrameCheckBox('enable');
        $("#IsPrices").FrameCheckBox('enable');
        $("#IsTerritory").FrameCheckBox('enable');
        $("#IsPurchase").FrameCheckBox('enable');
        $("#IsPayment").FrameCheckBox('enable');
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
        $("#DivContractNo").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivContractNum").FrameTextBox('disable');
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
            value: 'LP',
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivDealerType").FrameTextBox('disable');
        $("#DivDealer").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivDealer").FrameTextBox('disable');


        $("#ContractNo").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#ContractNo").FrameTextBox('disable');

        $("#OriginalNo").FrameTextBox({
            value: "",
        });

        $("#OriginalStartDate").FrameDatePicker({
            format: "yyyy-MM-dd",
            depth: "month",
            start: "month",
        });
        $("#OriginalEndDate").FrameDatePicker({
            format: "yyyy-MM-dd",
            depth: "month",
            start: "month",
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
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#AgreementEndDate").FrameDatePicker('disable');


        $("#DealerName").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DealerName").FrameTextBox('disable');

        $("#DealerNameEn").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#CompanyEName").FrameTextBox('disable');

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

        $("#COName").FrameTextBox({
            value: "",
        });
        $("#CONameEn").FrameTextBox({
            value: "",
        });

        $("#COContactInfo").FrameTextBox({
            value: "",
        });
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
        });
        $("#IsProduct").FrameCheckBox({
            value: "",
        });
        $("#IsPrices").FrameCheckBox({
            value: "",
        });
        $("#IsTerritory").FrameCheckBox({
            value: "",
        });
        $("#IsPurchase").FrameCheckBox({
            value: "",
        });
        $("#IsPayment").FrameCheckBox({
            value: "",
        });
        
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

        $('#PnlContractContent').css("height", (h - 30) + "px");

        var PnlContractInfo = $('#PnlContractInfo').height();
        var PnlContractBase = $('#PnlContractBase').height();

        var PnlContractSelect = (PnlContractInfo - PnlContractBase - 60) + "px";
        $("#PnlContractSelect").css("height", PnlContractSelect);

    }


    return that;
}();