var Page = {};
var ContractFile = ContractFile || {};

Page = function () {
    var that = {};
    //
    that.newIdProxy;
    that.newIdGoods;
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
        $("#hideDivPayType1").hide();
        $("#hideDivPayType2").hide();
        $("#BtnUploadProxy").attr({ "data-tmpid": NewGuid(), "data-file": "OtherAttachment", "data-type": "OtherAttachment" });
        $("#ContractStatus").FrameTextBox("setValue", "草稿");
        //$("#BtnUploadGoods").attr({ "data-tmpid": NewGuid(), "data-file": "UploadGoods", "data-type": "UploadGoods" });
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
        $("#BtnPreview").FrameButton({
            onClick: function () {
                that.ExportPDF("Preview");
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

        that.InitList("草稿");
        that.InitDivControls();
        var data = that.GetModel('GetReadTemplateList');
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {

            createReadRedTemplate(model);
            //hideLoading();
        });



        that.QueryInitData();

        $(window).resize(function () {
            setLayout();
        })

        setLayout();

        hideLoading();
    }


    var createReadRedTemplate = function (model) {
        $("#ReadTemplateList").kendoGrid({
            dataSource: model.QryList,
            sortable: false,
            resizable: false,
            scrollable: false,
            columns: [
               
                 {
                     field: "IsRequired", title: "必读", width: '60',
                     headerAttributes: { "class": "center bold", "title": "必读" }
                 },
                {
                    field: "DocumentName", title: "阅读文件",
                    headerAttributes: { "class": "center bold", "title": "阅读文件" }
                },
                 {
                     field: "ReadUserName", title: "阅读人", width: '90',
                     headerAttributes: { "class": "center bold", "title": "阅读人" }
                 },
                {
                    field: "ReadDate", title: "阅读时间", width: '170',
                    headerAttributes: { "class": "center bold", "title": "阅读时间" }
                },
                //{
                //    field: "Confirm", title: "确认阅读", width: '60',
                //    headerAttributes: { "class": "center bold", "title": "确认阅读" },
                //    template: "#if(Confirm == null){#<i class='fa fa-file-pdf-o' style='font-size: 14px; cursor: pointer;' name='Confirm'></i>#} else {# <i></i> #}#",
                //    attributes: {
                //        "class": "center"
                //    }

                //},
                {
                    title: "下载", width: "60",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    template: "<a id='bb' href='' download><i class='fa fa-cloud-download' style='font-size: 14px; cursor: pointer;' name='Download'></i></a>",
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
                //var curWwwPath = window.document.location.href;
                //var pathName = window.document.location.pathname;
                //var pos = curWwwPath.indexOf(pathName);
                //var localhostPaht = curWwwPath.substring(0, pos);

                $("#ReadTemplateList").find("i[name='Download']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                   
                    $("#bb").attr("href", Common.AppVirtualPath + data.DocumentFile);
                });

                $("#ReadTemplateList").find("i[name='Confirm']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var Item = grid.dataItem(tr);
                    var data = that.GetModel('InsertDetail');
                    data.ReadID = Item.ReadId;

                    showConfirm({
                        target: 'top',
                        message: '确定阅读吗？',
                        confirmCallback: function () {
                            submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
                                //showAlert({
                                //    target: 'top',
                                //    alertType: 'info',
                                //    message: "阅读成功",
                                //    callback: function () {
                                        
                                //    }
                                //});
                                createReadRedTemplate(model)
                                hideLoading();
                            });
                        }
                    });
                });
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
        data.ContractTemplatePdfList = $("a.UserFile").FrameSortAble("gatherFileInfo");

        var ChekFile = true;
        var Messing = "";


        //$.each(data.ContractTemplateList, function (i, item) {
        //    if (item.FileType == "OtherAttachment") {


        //        var obj = $("a.UserFile[data-type=OtherAttachment]");
        //        if (obj == null || obj.length <= 0) {
        //            ChekFile = false;
        //            Messing += "请上传其它附件;";
        //            hideLoading();
        //        }
        //    }
        //});

        //if (!ChekFile) {
        //    showAlert({
        //        target: 'top',
        //        alertType: 'info',
        //        message: Messing,
        //    });

        //    return false;
        //}

        //console.log(data.ContractTemplateList);
        data.Rebate = that.DiscountList();
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
        showLoading();
        var data = that.GetModel('GiveupCache');
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
            that.QueryInitData();
            $("#BtnGiveupCache").hide();
            showAlert({
                target: 'top',
                alertType: 'info',
                message: '已放弃暂存',
            });
            hideLoading();
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
        //var ReadTemplate = $("#ReadTemplateList").data("kendoGrid").dataSource.data()
        //var Check = false;
        //for (var i = 0; i < ReadTemplate.length; i++) {
        //    if (ReadTemplate[i].IsRequired == "是" && ReadTemplate[i].ReadDate != null) {
        //        Check = true;
        //        break;
        //    }
        //}
        //if (!Check) {
        //    showAlert({
        //        target: 'top',
        //        alertType: 'info',
        //        message: "请阅读文件",
        //    });
        //    hideLoading();
        //    return false;
        //}
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
        data.Rebate = that.DiscountList();
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

        if (!that.checkEndTime(data.AgreementStartDate, data.AgreementEndDate)) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: "协议终止日期不能小于协议开始日期",
            });
            hideLoading();
            return false;
        }

        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {

            that.QueryInitData();
            $("#BtnGiveupCache").hide();
            showAlert({
                target: 'top',
                alertType: 'info',
                message: '提交成功',
            });
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
    that.InsertCache = function () {
        showLoading();

        var data = that.GetModel('InsertExportCache');
        data.ContractTemplateList = $("#sortable-handlers").FrameSortAble("getSelectValue");
        data.Rebate = that.DiscountList();
        data.ContractTemplatePdfList = $("a.UserFile").FrameSortAble("gatherFileInfo");

        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx", data, function (model) {
            that.QueryInitData();
            showAlert({
                target: 'top',
                alertType: 'info',
                message: '暂存成功',
            });
            hideLoading();
        });
    }

    that.changeVerssionStatus = function () {
        var item = $("#ContractVer").data("kendoDropDownList").dataItem();
        if (item) {
            showLoading();
            that.ControlBtn(item.VersionStatus)
            $("#ContractStatus").FrameTextBox("setValue", item.StatusName);
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

    that.DiscountList = function () {
        var grid = $("#DiscountList").data("kendoGrid");
        var Data = $("#DiscountList").data("kendoGrid").dataSource.data();
        //grid.refresh();
        var discountObj = {},
            Discount = [];
        $.each(Data, function (i, item) {
            Discount.push({ "Grade": item.Grade, "Discount": item.Discount });
        });
        var rebateRation = $("#DivRebateRatio").FrameTextBox("getValue"),
            rebateDiscount = $("#DivPerformanceRebateDiscount").FrameTextBox("getValue"),
            quarterRatio = $("#DivQuarterRatio").FrameTextBox("getValue");
        // 返利比例
        discountObj.RebateRation = rebateRation;
        //业绩评分返利折扣
        discountObj.RebateDiscount = rebateDiscount;
        //季度采购总额比例
        discountObj.QuarterRatio = quarterRatio;

        discountObj.DiscountList = Discount;

        return JSON.stringify(discountObj);
    }

    that.QueryInitData = function () {
        //初始隐藏导出按钮
        $("#BtnPDFExport").hide();
        var data = that.GetModel('InitLPApplyRenew');
        showLoading();
        //console.log("Common.AppVirtualPath:" + Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/LPAndT1Handler.ashx");
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

                    that.ControlBtn(item.VersionStatus)
                    $("#ContractStatus").FrameTextBox("setValue", item.StatusName);
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


        $("#DealerName").FrameTextBox('setValue', model.DealerName);
        $("#DealerNameEn").FrameTextBox('setValue', model.DealerNameEn);

        $("#LogisticsCompany").FrameTextBox('setValue', model.LogisticsCompany);
        $("#StartDate").FrameDatePicker('setValue', model.StartDate);
        $("#EndDate").FrameDatePicker('setValue', model.EndDate);

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
        $("#ExclusiveType").FrameTextBox('setValue', model.ExclusiveType);

        $("#DealerAddressEn").FrameTextBox('setValue', model.DealerAddressEn);
        $("#DealerManagerEn").FrameTextBox('setValue', model.DealerManagerEn);
        $("#PaymentDays").FrameTextBox('setValue', model.PaymentDays);
        $("#BankGuarantee").FrameTextBox('setValue', model.BankGuarantee);
        $("#CompanyGuarantee").FrameNumeric('setValue', model.CompanyGuarantee);

        $("#ExportId").val(model.ExportId);
        $("#CreditTerm").val(model.CreditTerm);
        $("#SubProductName").val(model.SubProductName);
        $("#SubProductEName").val(model.SubProductEName);
        $("#DealerId").val(model.DealerId);
        if ($("#DiscountList").data("kendoGrid")) {
            $("#DiscountList").data("kendoGrid").destroy();
        }
        that.InitList(model.Status);
        if (model.Rebate) {
            var Rebate = JSON.parse(model.Rebate);
            $("#DivRebateRatio").FrameTextBox('setValue', Rebate.RebateRation);
            $("#DivPerformanceRebateDiscount").FrameTextBox('setValue', Rebate.RebateDiscount);
            $("#DivQuarterRatio").FrameTextBox('setValue', Rebate.QuarterRatio);

            if (model.Status != "草稿") {

                $("#DiscountList").find("table th").eq(2).hide();

                if (Rebate.DiscountList.length > 0) {
                    $("#DiscountList").data("kendoGrid").dataSource.data(Rebate.DiscountList)
                    $("#DiscountList").data("kendoGrid").dataSource.at(0).fields["Grade"].editable = false;
                    $("#DiscountList").data("kendoGrid").dataSource.at(0).fields["Discount"].editable = false;
                }



            }
            else {

                if (Rebate.DiscountList.length > 0) {
                    $("#DiscountList").data("kendoGrid").dataSource.data(Rebate.DiscountList)
                    $("#DiscountList").find("table th").eq(2).show();
                    $("#DiscountList").find("table tr").find("td:eq(2)").show();
                    $("#DiscountList").data("kendoGrid").dataSource.at(0).fields["Grade"].editable = true;
                    $("#DiscountList").data("kendoGrid").dataSource.at(0).fields["Discount"].editable = true;
                }
            }

            //$("#DiscountList").data("kendoGrid").setDataSource(Rebate.DiscountList)({
            //    dataSource: Rebate.DiscountList
            //});
        }




        //$("#NewFileNameGoods").val();
        //$("#NewFileNameProxy").val();
    }
    that.InitControlsDataView = function () {
        $("#DealerAddressEn").FrameTextBox("disable");
        $("#DealerManagerEn").FrameTextBox("disable");
        $("#AgreementStartDate").FrameDatePicker("disable");
        $("#AgreementEndDate").FrameDatePicker("disable");
        $("#DivQuarterRatio").FrameTextBox("disable");
        $("#PaymentDays").FrameTextBox("disable");
        $("#BankGuarantee").FrameTextBox("disable");
        $("#CompanyGuarantee").FrameNumeric("disable");
        $("#DivRebateRatio").FrameTextBox("disable");
        $("#DivPerformanceRebateDiscount").FrameTextBox("disable");
        $("#BtnDownLoadProxyTemplate").attr("disabled", true);
        $("#BtnUploadProxy").attr("disabled", true);

        $("#DealerFax").FrameTextBox("disable");
        $("#DealerMail").FrameTextBox("disable");
        $("#DealerPhone").FrameTextBox("disable");
        $("#DealerManager").FrameTextBox("disable");
    };
    that.InitControlsDataEnable = function () {
        $("#DealerAddressEn").FrameTextBox("enable");
        $("#DealerManagerEn").FrameTextBox("enable");
        $("#AgreementStartDate").FrameDatePicker("enable");
        $("#AgreementEndDate").FrameDatePicker("enable");
        $("#DivQuarterRatio").FrameTextBox("enable");
        $("#PaymentDays").FrameTextBox("enable");
        $("#BankGuarantee").FrameTextBox("enable");
        $("#CompanyGuarantee").FrameNumeric("enable");
        $("#DivRebateRatio").FrameTextBox("enable");
        $("#DivPerformanceRebateDiscount").FrameTextBox("enable");
        $("#BtnDownLoadProxyTemplate").attr("disabled", false);
        $("#BtnUploadProxy").attr("disabled", false);

        $("#DealerFax").FrameTextBox("enable");
        $("#DealerMail").FrameTextBox("enable");
        $("#DealerPhone").FrameTextBox("enable");
        $("#DealerManager").FrameTextBox("enable");
    };
    that.InitControlsData = function (model) {
        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DivBU").FrameTextBox('setValue', model.ProductName);
        $("#DivContractType").FrameTextBox('setValue', model.ProductEName);
        $("#DivDealer").FrameTextBox('setValue', model.CompanyName);

        $("#DealerName").FrameTextBox('setValue', model.CompanyName);
        $("#DealerNameEn").FrameTextBox('setValue', model.CompanyEName);
        $("#DealerAddress").FrameTextBox('setValue', model.OfficeAddress);
        $("#DealerManager").FrameTextBox('setValue', model.Contact);
        $("#DealerMail").FrameTextBox('setValue', model.EMail);
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AgreementBegin);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AgreementEnd);
        $("#DeptName").FrameTextBox('setValue', model.ProductName);
        $("#DeptNameEn").FrameTextBox('setValue', model.ProductEName);
        $("#DealerPhone").FrameTextBox('setValue', model.Mobile);
        $("#DealerFax").FrameTextBox('setValue', model.OfficeNumber);
        $("#CreditTerm").val(model.CreditTerm);

        if (model.Payment == 'Credit') {
            $("#hideDivPayType1").show();
            $("#hideDivPayType2").show();
        }
        $("#PaymentType").FrameTextBox('setValue', model.Payment);
        $("#CreditLimit").FrameTextBox('setValue', model.CreditLimit);

        $("#ExclusiveType").FrameTextBox('setValue', model.ExclusiveType);
        $("#SubProductName").val(model.SubProductName);
        $("#SubProductEName").val(model.SubProductEName);
        $("#DealerId").val(model.DealerId);
    }

    that.InitList = function (Status) {
        var dataSource = new kendo.data.DataSource({

            schema: {
                data: function (res) {
                    //var response = $.parseJSON(res.Result[0].Value);
                    return res;
                },
                model: {

                    fields: {
                        Grade: { type: "string", validation: { required: true } },
                        Discount: { type: "string", validation: { required: true } },
                        Btndelete: { editable: false },
                    }
                }
            },


        });
        $("#DiscountList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            scrollable: true,
            editable: true,
            //toolbar: ["create"],
            toolbar: [{
                template: '<span style="float:left;"><span class=\"k-button \" id=\"btnAdd\">新增</span></span>',

            }],
            columns: [
                 {
                     field: "Grade", title: "经销商季度业绩考评得分", width: "120px", headerAttributes: { "class": "center bold", "title": "经销商季度业绩考评得分" },
                     editor: function (container, options) {
                         var input = $("<input id=\"\" />");
                         input.attr("name", options.field);
                         input.appendTo(container);
                         var autoComplete =
                           input.kendoAutoComplete({

                           });

                     }
                 },
                {
                    field: "Discount", title: "在“第一部分”返利基础上的额外折扣", width: "120px", headerAttributes: { "class": "center bold", "title": "在“第一部分”返利基础上的额外折扣" },
                    editor: function (container, options) {
                        var input = $("<input id=\"\" />");
                        input.attr("name", options.field);
                        input.appendTo(container);
                        var autoComplete =
                          input.kendoAutoComplete({

                          });

                    }
                },
                {
                    title: "删除",
                    field: "Btndelete",
                    template: "<a id=\"btndelete\" ><span class=\"k-button\">删除</span></a>",
                    width: 60,
                    headerAttributes: { "class": "align-center" },
                    attributes: { "class": "align-center" }
                }
            ],
            save: function (e) {
                var grid = e.sender;
                var dataSource = grid.dataSource;
                if (typeof (e.values.Grade) != 'undefined') {
                    e.model.Grade = e.values.Grade;
                }
                if (typeof (e.values.Discount) != 'undefined') {
                    e.model.Discount = e.values.Discount;
                }
                dataSource.fetch();
            },
            dataBound: function (e) {
                var grid = e.sender;
                if (Status != "草稿") {
                    $("#DiscountList").find("table tr").find("td:eq(2)").hide();
                    $("#btnAdd").parents(".k-grid-toolbar").hide();
                }
                else {
                    $("#DiscountList").find("table tr").find("td:eq(2)").show();
                    $("#btnAdd").parents(".k-grid-toolbar").show();
                }

                $("a[id=btndelete]").bind("click", function (e) {
                    var tr = $(this).closest("tr"), data = grid.dataItem(tr);
                    var Detail = grid.dataSource;
                    Detail.pushDestroy(data);

                });
            }

        });

    }

    that.InitDivControls = function () {

        $("#btnAdd").on('click', function () {

            $("#DiscountList").data("kendoGrid").dataSource.add({ Grade: "", Discount: "" })
        });

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
            value: 'LP',
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

        $("#ExclusiveType").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#ExclusiveType").FrameTextBox('disable');

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

        //
        $("#StartDate").FrameDatePicker({
            depth: "month",
            start: "month",
            format: "yyyy-MM-dd",
        });
        $("#EndDate").FrameDatePicker({
            depth: "month",
            start: "month",
            format: "yyyy-MM-dd",
        });
        $("#LogisticsCompany").FrameTextBox({
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

        $("#DivQuarterRatio").FrameTextBox({
            value: "",
        });
        $("#DivRebateRatio").FrameTextBox({
            value: "",
        });
        $("#DivPerformanceRebateDiscount").FrameTextBox({
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
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#CreditLimit").FrameTextBox('disable');

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
            multiple: false,
            validation: {
                allowedExtensions: [".pdf"],
            },
            success: function (e) {
                $("#BtnUploadProxy").FrameSortAble("FileaddNewData", e.response)
            },
        });

        var curWwwPath = window.document.location.href;
        var pos = curWwwPath.indexOf(window.document.location.pathname);
        $('#BtnDownLoadProxyTemplate').FrameButton({
            onClick: function () {
                window.location = curWwwPath.substring(0, pos) + "/Upload/ContractElectronicAttachmentTemplate/LP/AppointmentRenewal/其它附件.docx";
            }
        });

        $('#BtnUploadProxy').FrameButton({
            onClick: function () {

                document.getElementById('UploadProxyfiles').click();
            }
        });
        $('#UploadGoodsfiles').kendoUpload({
            async: {
                saveUrl: "/pageskendo/ContractElectronic/handlers/UploadHandler.ashx?Type=UploadGoods&NewFileName=" + NewGuid(),
                autoUpload: true
            },
            select: function (e) {
                var file = e.files;
                console.log(file[0].extension);
                if (file[0].extension != '.pdf') {
                    showAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '仅支持PDF上传1',
                    });
                }

            },
            multiple: false,
            validation: {
                allowedExtensions: [".pdf"],
            },
            success: function (e) {
                $("#BtnUploadGoods").FrameSortAble("FileaddNewData", e.response)
            }
        });

        $('#BtnUploadGoods').FrameButton({
            onClick: function () {
                document.getElementById('UploadGoodsfiles').click();
            }
        });
        $('#BtnDownLoadGoodsTemplate').FrameButton({
            onClick: function () {
                var curWwwPath = window.document.location.href;
                var pos = curWwwPath.indexOf(window.document.location.pathname);
                window.location = curWwwPath.substring(0, pos) + "/Upload/ContractElectronicAttachmentTemplate/LP/AppointmentRenewal/提货授权委托书.docx";
            }
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
    function S4() {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    }
    var NewGuid = function () {
        return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
    }






    var setLayout = function () {
        var h = $('.content-main').height();

        $("#PnlContractContent").css("height", (h - 30) + "px");

        //$("#DiscountList").data("kendoGrid").setOptions({
        //    height: 180
        //});

        var PnlContractInfo = $('#PnlContractInfo').height();
        var PnlContractBase = $('#PnlContractBase').height();

        var PnlContractSelect = (PnlContractInfo - PnlContractBase - 60) + "px";
        $("#PnlContractSelect").css("height", PnlContractSelect);

    }


    return that;
}();