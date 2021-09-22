var DealerAttachDetail = {};

DealerAttachDetail = function () {
    var that = {};

    var business = 'MasterDatas.DealerAttachDetail';
    var deleteAttach = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        $('#HidDealerId').val(Common.GetUrlParam('DealerId'));
        var data = that.GetModel();
        createAttachList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#HidDealerId').val(model.HidDealerId);
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
                    text: '上传附件',
                    icon: 'upload',
                    onClick: function () {
                        that.initUploadAttachDiv();
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
                        saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=dcms&InstanceId=" + $('#HidDealerId').val(),
                        autoUpload: true
                    },
                    upload: function (e) {
                        e.data = { selectType: $('#WinFileType').FrameDropdownList('getValue').Key };
                    },
                    multiple: false,
                    success: function (e) {
                        //$("#BtnUploadProxy").FrameSortAble("FileaddNewData", e.response)
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

    //上传
    that.UploadFile = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'DealerListExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerListExportType', 'ExportByDealer');
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealer', data.QryDealerName.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerType', data.QryDealerType.Key);
        urlExport = Common.UpdateUrlParams(urlExport, 'QrySAPNo', data.QrySAPNo);
        urlExport = Common.UpdateUrlParams(urlExport, 'QryDealerAddress', data.QryDealerAddress);
        startDownload(urlExport, 'DealerListExport');

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

                $("#RstAttachList").find("i[name='download']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.Download(data.Name, data.Url);

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

    that.initUploadAttachDiv = function (CName, EName, DealerType) {
        $("#winUploadAttachLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 200,
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