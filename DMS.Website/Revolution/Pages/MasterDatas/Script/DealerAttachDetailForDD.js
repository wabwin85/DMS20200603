var DealerAttachDetailForDD = {};

DealerAttachDetailForDD = function () {
    var that = {};

    var business = 'MasterDatas.DealerAttachDetailForDD';
    var deleteAttach = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        $('#HidDealerId').val(Common.GetUrlParam('DealerId'));
        $('#HidDealerType').val(Common.GetUrlParam('DealerType'));
        var data = that.GetModel();
        createAttachList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#HidDealerId').val(model.HidDealerId);
                $('#QryDDReportName').FrameTextBox({
                    value: model.QryDDReportName
                });

                $('#QryDDStartDate').FrameDatePickerRange({
                    format: "yyyy-MM-dd",
                    value: model.QryDDStartDate
                });

                $('#QryDDEndDate').FrameDatePickerRange({
                    format: "yyyy-MM-dd",
                    value: model.QryDDEndDate
                });
                $('#WinIptDDReportName').FrameTextBox({
                    value: model.WinIptDDReportName
                });

                $('#WinIptDDStartDate').FrameDatePicker({
                    format: "yyyy-MM-dd",
                    value: model.WinIptDDStartDate
                });

                $('#WinIptDDEndDate').FrameDatePicker({
                    format: "yyyy-MM-dd",
                    value: model.WinIptDDEndDate
                });
                $('#WinIptIsHaveRedFlag').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.WinIptIsHaveRedFlag
                });
                $('#BtnSeach').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });
                $('#BtnReturn').FrameButton({
                    text: '返回',
                    icon: 'reply',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });

                $('#BtnShowUpload').FrameButton({
                    text: '创建背调记录',
                    icon: 'upload',
                    onClick: function () {
                        that.initUploadAttachDiv();
                    }
                });

                $('#BtnUploadAttach').FrameButton({
                    text: '保存',
                    icon: 'save',
                    onClick: function () {
                        that.SaveInfo();
                    }
                });
                $('#WinFileType').FrameDropdownList({
                    dataSource: model.LstFileType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.WinFileType
                });

                $('#WinFileUpload').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=ddReport&InstanceId=" + $('#HidDealerId').val() + "&DealerType=" + $('#HidDealerType').val(),
                        autoUpload: false
                    },
                    upload: function (e) {
                        var data = that.GetModel();
                        e.data = { DDReportName: data.WinIptDDReportName, DDStartDate: data.WinIptDDStartDate, DDEndDate: data.WinIptDDEndDate, DDIsHaveRedFlag: data.WinIptIsHaveRedFlag };
                    },
                    multiple: false,
                    success: function (e) {
                        //$("#BtnUploadProxy").FrameSortAble("FileaddNewData", e.response)
                        $("#winUploadAttachLayout").data("kendoWindow").close();
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '保存成功！',
                            callback: function () {
                            }
                        });
                        var upload = $("#WinFileUpload").data("kendoUpload");
                        upload.clearAllFiles();
                        that.Query();
                    }
                });

                //$('#BtnUploadAttach').FrameButton({
                //    text: '上传附件',
                //    onClick: function () {
                //        that.UploadFile();
                //    }
                //});

                //$('#BtnClearAttach').FrameButton({
                //    text: '清除',
                //    onClick: function () {
                //        that.ClearFile();
                //    }
                //});

                if (model.IsDealer) {

                }
                else {

                }

                //$("#RstAttachList").data("kendoGrid").setOptions({
                //    dataSource: model.RstAttachList
                //});

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.Query = function () {
        var grid = $("#RstAttachList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    that.SaveInfo = function () {
        var data = that.GetModel();
        if (data.WinIptDDReportName == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请填写DD报告名称',
                callback: function () {
                }
            });
            return;
        }
        if (data.WinIptDDStartDate == null || data.WinIptDDStartDate == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: '请填写DD报告有效开始时间',
                callback: function () {
                }
            });
            return;
        }
        if (!data.WinIptIsHaveRedFlag) {
            if (data.WinIptDDEndDate == null || data.WinIptDDEndDate == '') {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '请填写DD报告有效截止时间',
                    callback: function () {
                    }
                });
                return;
            }
        } else {
            if ($(".k-upload-files").find('li') && $(".k-upload-files").find('li').length <= 0) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: 'DD报告附件必须上传',
                    callback: function () {
                    }
                });
                return;
            }
        }
        var upload = $("#WinFileUpload").data("kendoUpload");
        if (upload.getFiles().length > 0) {
            upload.upload();
        }
        else {
            var data = that.GetModel();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SaveDDInfo',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess != true) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '保存成功！',
                            callback: function () {
                            }
                        });
                        that.Query();
                    }
                    FrameWindow.HideLoading();
                }
            });
            upload.clearAllFiles();
            $("#winUploadAttachLayout").data("kendoWindow").close();
        }
    }

    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 20);
    var createAttachList = function () {
        $("#RstAttachList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 400,
            columns: [
                //{
                //    field: "Name", title: "附件名称",
                //    headerAttributes: { "class": "text-center text-bold", "title": "附件名称" }
                //},
                {
                    field: "ReportName", title: "DD报告名称",
                    width: "auto",
                    headerAttributes: { "class": "text-center text-bold", "title": "DD报告名称" }
                },
                {
                    field: "DDStartDate", title: "起始时间", format: "{0:yyyy-MM-dd}",
                    width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "起始时间" }
                },
                {
                    field: "DDEndDate", title: "过期时间", format: "{0:yyyy-MM-dd}",
                    width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "过期时间" }
                },
                {
                    field: "IsHaveRedFlag", title: "是否有RedFlag",
                    width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "是否有RedFlag" },
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "UploadUser", title: "创建人",
                    width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "创建人" }
                },
                {
                    field: "UploadDate", title: "创建时间", format: "{0:yyyy-MM-dd}",
                    width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "创建时间" }
                },
                {
                    field: "Id", title: "下载", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "下载" },
                    template: "#if ($('\\#ATID').val() != '') {#<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='download'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "Id", title: "删除", width: 80,
                    headerAttributes: { "class": "text-center text-bold", "title": "删除" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='delete'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstAttachList").find("i[name='download']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    if (data.ATID == null) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '无附件信息！',
                            callback: function () {
                            }
                        });
                        return;
                    } else {
                        that.Download(data.Name, data.Url);
                    }

                });

                $("#RstAttachList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    $("#SelectAttachId").val(data.Id);

                    that.Delete();
                });

            },
            page: function (e) {
            }
        });
    }

    that.Download = function (Name, Url) {
        var url = '/Pages/Download.aspx?downloadname=' + escape(Name) + '&filename=' + escape(Url) + '&downtype=' + $('#HidDealerType').val() + '_BackgroundCheck';
        open(url, 'Download');
    }

    that.Delete = function () {
        var data = that.GetModel();
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '是否要删除该附件文件?',
            confirmCallback: function () {
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteAttach',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess != true) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: model.ExecuteMessage,
                                callback: function () {
                                }
                            });
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '删除成功！',
                                callback: function () {
                                }
                            });
                            that.Query();
                        }
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }

    that.initUploadAttachDiv = function (CName, EName, DealerType) {

        $("#winUploadAttachLayout").kendoWindow({
            title: "Title",
            width: 500,
            height: 400,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("上传附件").center().open();

    }

    that.ClearFile = function () {

    }

    var setLayout = function () {
    }

    return that;
}();