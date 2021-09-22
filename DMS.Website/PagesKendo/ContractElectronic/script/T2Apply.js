var Page = {};
Page = function () {
    var that = {};
    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;
        model.DeptName = model.DivBU;
        model.SubDeptName = model.DivContractType;
        model.SubBuName = model.DivContractType;
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
        $("#Phone").val($.getUrlParam("DMA_Phone"));
        
        
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
        })
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

        //hideLoading();
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

                $("#ReadTemplateList").find("i[name='Download']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    $("#bb").attr("href", Common.AppVirtualPath + data.DocumentFile);
                });
            }
        });
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
        data.ContractTemplatePdfList = $("a.UserFile").FrameSortAble("gatherFileInfo");
        submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/T2Handler.ashx", data, function (model) {
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
        var data = that.GetModel('InitT2ApplyRenew');
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

    that.ControlBtn = function (Status) {

        if (Status == "Draft") {
            //that.InitControlsDataEnable();
            $("#BtnSubmit").show();
            $("#BtnPDFExport").hide();
            $("#BtnPDFCache").show();
            $("#BtnGiveupCache").show();
            $("#BtnPreview").show();
            $("#BtnContractRevoke").hide();
            //$("#BtnDownLoadProxyTemplate").attr("disabled", false);
            //$("#BtnUploadProxy").attr("disabled", false);
        }
        else if (Status == "WaitDealerSign") {
            //that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").hide();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").show();
            //$("#BtnDownLoadProxyTemplate").attr("disabled", true);
            //$("#BtnUploadProxy").attr("disabled", true);
        }
        else if (Status == "WaitDealerSign" || Status == "WaitBscSign" || Status == "WaitLPSign") {
            //that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").hide();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").show();
            //$("#BtnDownLoadProxyTemplate").attr("disabled", true);
            //$("#BtnUploadProxy").attr("disabled", true);
        }
        else if (Status == "Complete") {
            //that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").hide();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").hide();
            //$("#BtnDownLoadProxyTemplate").attr("disabled", true);
            //$("#BtnUploadProxy").attr("disabled", true);
        }
        else if (Status == "Cancelled") {
            //that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").show();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").hide();
            //$("#BtnDownLoadProxyTemplate").attr("disabled", true);
            //$("#BtnUploadProxy").attr("disabled", true);
        }
        else if (Status == "WaitDealerAbandonment") {
            //that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").hide();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").hide();
            //$("#BtnDownLoadProxyTemplate").attr("disabled", true);
            //$("#BtnUploadProxy").attr("disabled", true);
        }
        else if (Status == "Abandonment") {
            //that.InitControlsDataView();
            $("#BtnSubmit").hide();
            $("#BtnPDFExport").show();
            $("#BtnPDFCache").show();
            $("#BtnGiveupCache").hide();
            $("#BtnPreview").hide();
            $("#BtnContractRevoke").hide();
            //$("#BtnDownLoadProxyTemplate").attr("disabled", true);
            //$("#BtnUploadProxy").attr("disabled", true);
        }

    }

    that.InitControlsDataV = function (model) {
        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DivBU").FrameTextBox('setValue', model.DeptName);
        $("#DivContractType").FrameTextBox('setValue', model.DeptNameEn);
        $("#DivDealer").FrameTextBox('setValue', model.DealerName);
        $("#ContractStatus").FrameTextBox("setValue", model.Status);


        $("#ExportId").val(model.ExportId);
        $("#PlatformName").FrameTextBox('setValue', model.PlatformName);
        $("#PlatformAddress").FrameTextBox('setValue', model.PlatformAddress);
        $("#PlatformContact").FrameTextBox('setValue', model.PlatformContact);
        $("#DealerName").FrameTextBox('setValue', model.DealerName);
        $("#DealerAddress").FrameTextBox('setValue', model.DealerAddress);
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AgreementStartDate);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AgreementEndDate);
        $("#DealerId").val(model.DealerId);
        $("#PlatformFax").FrameTextBox('setValue', model.PlatformFax);
        //$("#PlatformPostCode").FrameTextBox('setValue', model.PlatformPostCode);
        $("#PlatformBank").FrameTextBox('setValue', model.PlatformBank);
        //$("#DealerFax").FrameTextBox('setValue', model.DealerFax);
        //$("#DealerPostCode").FrameTextBox('setValue', model.DealerPostCode);
        $("#DealerBank").FrameTextBox('setValue', model.DealerBank);
        $("#Guarantee").FrameTextBox('setValue', model.Guarantee);
        $("#DealerContact").FrameTextBox('setValue', model.DealerContact);
        $("#DealerPhone").FrameTextBox('setValue', model.Phone);

    }

    that.InitControlsData = function (model) {
        $("#ContractNo").FrameTextBox('setValue', model.ContractNo);
        $("#DivBU").FrameTextBox('setValue', model.ProductName);
        $("#DivContractType").FrameTextBox('setValue', model.ProductEName);
        $("#DivDealer").FrameTextBox('setValue', model.CompanyName);
        $("#DealerId").val(model.DealerId);
        $("#PlatformId").val(model.LPId);
        $("#PlatformName").FrameTextBox('setValue', model.LPName);
        $("#PlatformAddress").FrameTextBox('setValue', model.LPAddress);
        $("#PlatformContact").FrameTextBox('setValue', model.LPContacts);
        $("#PlatformBank").FrameTextBox('setValue', model.PlatformBank);
        $("#DealerName").FrameTextBox('setValue', model.CompanyName);
        $("#DealerAddress").FrameTextBox('setValue', model.OfficeAddress);
        $("#AgreementStartDate").FrameDatePicker('setValue', model.AgreementBegin);
        $("#AgreementEndDate").FrameDatePicker('setValue', model.AgreementEnd);
        $("#DealerBank").FrameTextBox('setValue', model.DealerBank);
        $("#DealerContact").FrameTextBox('setValue', model.DealerContact);
        $("#DealerPhone").FrameTextBox('setValue', model.Phone);
        
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
            submitAjax(Common.AppVirtualPath + "PagesKendo/ContractElectronic/handlers/T2Handler.ashx", data, function (model) {
                $("#sortable-handlers").FrameSortAble("removeDataSource");
                var DataValue = { Data: model.ContractAttach, Status: item.Status };
                $("#sortable-handlers").FrameSortAble("setDataSource", DataValue);
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
            value: 'T2',
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivDealerType").FrameTextBox('disable');

        $("#DivDealer").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DivDealer").FrameTextBox('disable');



        $("#PlatformName").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#PlatformName").FrameTextBox('disable');

        $("#PlatformAddress").FrameTextBox({
            value: "",
            //style: "background-color:#EEEEEE;width:100%;"
        });
        //$("#PlatformAddress").FrameTextBox('disable');

        //$("#PlatformFax").FrameTextBox({
        //    value: "",
        //});

        //$("#PlatformPostCode").FrameTextBox({
        //    value: "",
        //});

        $("#PlatformBank").FrameTextBox({
            value: "",
        });

        $("#PlatformContact").FrameTextBox({
            value: "",
            //style: "background-color:#EEEEEE;width:100%;"
        });
        //$("#PlatformContact").FrameTextBox('disable');


        $("#DealerName").FrameTextBox({
            value: "",
            style: "background-color:#EEEEEE;width:100%;"
        });
        $("#DealerName").FrameTextBox('disable');

        $("#DealerAddress").FrameTextBox({
            value: "",
            //style: "background-color:#EEEEEE;width:100%;"
        });
        //$("#DealerAddress").FrameTextBox('disable');

        //$("#DealerFax").FrameTextBox({
        //    value: "",
        //});

        //$("#DealerPostCode").FrameTextBox({
        //    value: "",
        //});

        $("#DealerBank").FrameTextBox({
            value: "",
        });

        $("#DealerContact").FrameTextBox({
            value: "",
        });

        $("#DealerPhone").FrameTextBox({
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

        $("#Guarantee").FrameTextBox({
            value: "",
        });

     

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


        $('#FileQualityChecklist').kendoUpload({
            async: {
                autoUpload: false
            },
            select: function (e) {
                var file = e.files;
                // console.log(file[0].name);
                $("#DivQualityChecklist").FrameLabel({
                    value: file[0].name
                });
            },
            multiple: false,
        });

        $('#BtnUploadQualityChecklist').FrameButton({
            onClick: function () {
                document.getElementById('FileQualityChecklist').click();
            }
        });

        $('#FileAuthorization').kendoUpload({
            async: {
                autoUpload: false
            },
            select: function (e) {
                var file = e.files;
                // console.log(file[0].name);
                $("#DivAuthorization").FrameLabel({
                    value: file[0].name
                });
            },
            multiple: false,
        });

        $('#BtnUploadAuthorization').FrameButton({
            onClick: function () {
                document.getElementById('FileAuthorization').click();
            }
        });

        $('#FileTrainRegist').kendoUpload({
            async: {
                autoUpload: false
            },
            select: function (e) {
                var file = e.files;
                // console.log(file[0].name);
                $("#DivTrainRegist").FrameLabel({
                    value: file[0].name
                });
            },
            multiple: false,
        });

        $('#BtnUploadTrainRegist').FrameButton({
            onClick: function () {
                document.getElementById('FileTrainRegist').click();
            }
        });

    }
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

        var PnlContractInfo = $('#PnlContractInfo').height();
        var PnlContractBase = $('#PnlContractBase').height();

        var PnlContractSelect = (PnlContractInfo - PnlContractBase - 60) + "px";
        $("#PnlContractSelect").css("height", PnlContractSelect);

    }

    return that;
}();