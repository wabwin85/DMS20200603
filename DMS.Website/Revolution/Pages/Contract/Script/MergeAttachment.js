var MergeAttachment = {};

MergeAttachment = function () {
    var that = {};

    var business = 'Contract.MergeAttachment';
    var deleteAttach = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        $('#HidContractId').val(Common.GetUrlParam('ContId'));
        $('#HidDealerType').val(Common.GetUrlParam('DealerType'));

        var data = that.GetModel();
        createAttachList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#HidContractId').val(model.HidContractId);
                $('#HidFileType').val(model.HidFileType);

                $('#WinFileType').FrameDropdownList({
                    dataSource: model.LstFileType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.WinFileType
                });

                $('#WinAttachType').FrameDropdownList({
                    dataSource: model.LstFileType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.WinAttachType
                });

                $('#WinAttachName').FrameTextBox({
                    value: model.WinAttachName
                });

                $('#WinUploadDate').FrameTextBox({
                    value: model.WinUploadDate,
                    readonly: true
                });

                $('#WinAttachmentUpload').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=dcms&InstanceId=" + $('#HidContractId').val(),
                        autoUpload: true
                    },
                    upload: function (e) {
                        e.data = { selectType: $('#WinFileType').FrameDropdownList('getValue').Key };
                    },
                    multiple: false,
                    success: function (e) {
                        //$("#BtnUploadProxy").FrameSortAble("FileaddNewData", e.response)
                        if (e.XMLHttpRequest.responseText != "") {
                            var obj = $.parseJSON(e.XMLHttpRequest.responseText);
                            if (obj.result == "Success") {
                                that.Query();
                            }
                            else {
                                FrameWindow.ShowAlert({
                                    target: 'center',
                                    alertType: 'info',
                                    message: obj.msg,
                                    callback: function () {
                                        var upload = $("#WinAttachmentUpload").data("kendoUpload");
                                        upload.clearAllFiles();
                                    }
                                });
                            }
                        }
                        FrameWindow.HideLoading();
                    }
                });

                $('#BtnWinSave').FrameButton({
                    text: '保存',
                    icon: 'floppy-o',
                    onClick: function () {
                        that.UpdateAttachmentName();
                    }
                });
                $('#BtnWinCancel').FrameButton({
                    text: '取消',
                    icon: 'times',
                    onClick: function () {
                        $("#winAttachInfoLayout").data("kendoWindow").close();
                    }
                });

                if (model.DisableUpload)
                {
                    $('#btnAddAttachment').hide();
                }

                //$("#RstResultList").data("kendoGrid").setOptions({
                //    dataSource: model.RstResultList
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
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }

    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 20);
    var createAttachList = function () {
        $("#RstResultList").kendoGrid({
            toolbar: kendo.template($("#templateOp").html()),
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 400,
            columns: [
                {
                    field: "Name", title: "附件名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "附件名称" }
                },
                {
                    field: "TypeName", title: "附件类型",
                    headerAttributes: { "class": "text-center text-bold", "title": "附件类型" }
                },
                {
                    field: "Identity_Name", title: "上传人",
                    headerAttributes: { "class": "text-center text-bold", "title": "上传人" }
                },
                {
                    field: "UploadDate", title: "上传时间", format: "{0:yyyy-MM-dd}",
                    headerAttributes: { "class": "text-center text-bold", "title": "上传时间" }
                },
                {
                    field: "Id", title: "下载",
                    headerAttributes: { "class": "text-center text-bold", "title": "下载" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='download'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "Id", title: "修改",
                    headerAttributes: { "class": "text-center text-bold", "title": "修改" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "Id", title: "删除",
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

                $("#RstResultList").find("i[name='download']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.Download(data.Name, data.Url);

                });

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.ShowAttachInfo(data.Id);

                });

                $("#RstResultList").find("i[name='delete']").bind('click', function (e) {
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
        var url = '/Pages/Download.aspx?downloadname=' + escape(Name) + '&filename=' + escape(Url) + '&downtype=dcms';
        open(url, 'Download');
    }

    that.Delete = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteAttach',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.ExecuteMessage != 'Success') {
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
        $('#SelectAttachId').val('');
    }

    that.ConvertPdf = function () {

    }

    that.InitUploadAttach = function () {
        $("#winAttachmentLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 200,
            actions: [
                "Close"
            ],
            resizable: false,
            close: function () {
                $('#WinFileType').FrameDropdownList('setIndex', 0);
                var upload = $("#WinAttachmentUpload").data("kendoUpload");
                upload.clearAllFiles();
            }
            //modal: true,
        }).data("kendoWindow").title("上传附件").center().open();

    }

    that.ShowAttachInfo = function (Id) {
        var data = {};
        data.SelectAttachId = Id;
        data.HidFileType = $('#HidFileType').val();
        $('#SelectAttachId').val(Id);
        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitAttachInfo',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //$('#WinAttachType').FrameDropdownList('setValue', model.WinAttachType);
                $('#WinAttachType_Control').data("kendoDropDownList").value(model.WinAttachType.Key);

                $('#WinAttachName').FrameTextBox('setValue', model.WinAttachName);

                $('#WinUploadDate').FrameTextBox('setValue', model.WinUploadDate);

                $('#HidFileExt').val(model.HidFileExt);
                $('#HidOldType').val(model.HidOldType);

                if (model.DisableDDL)
                {
                    $('#WinAttachType').FrameDropdownList('disable');
                }

                $("#winAttachInfoLayout").kendoWindow({
                    title: "Title",
                    width: 400,
                    height: 200,
                    actions: [
                        "Close"
                    ],
                    resizable: false,
                    close: function () {
                        $('#SelectAttachId').val('');
                        $('#HidFileExt').val('');
                        $('#HidOldType').val('');
                    }
                    //modal: true,
                }).data("kendoWindow").title("附件信息").center().open();

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.UpdateAttachmentName = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'UpdateAttachmentName',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                
                if (model.ExecuteMessage == 'Success')
                {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '更新成功！',
                        callback: function () {
                            that.Query();
                            $("#winAttachInfoLayout").data("kendoWindow").close();
                        }
                    });
                }
                else if (model.ExecuteMessage == 'Incomplete')
                {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '请填写完整！',
                        callback: function () {
                        }
                    });
                }

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();