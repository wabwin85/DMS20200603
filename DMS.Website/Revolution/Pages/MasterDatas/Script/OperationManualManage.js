var OperationManualManage = {};

OperationManualManage = function () {
    var that = {};

    var business = 'MasterDatas.OperationManualManage';
    var deleteManual = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#QryManualName').FrameTextBox({
                    value: model.QryManualName
                });

                $('#WinManualUpload').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=ManualUpload",
                        autoUpload: true
                    },
                    upload: function (e) {
                        e.data = { InstanceId: $('#WinSLOrderId').val() };
                    },
                    multiple: false,
                    success: function (e) {
                        that.Query();
                    }
                });
                
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnUpload').FrameButton({
                    text: '上传教程',
                    icon: 'upload',
                    onClick: function () {
                        that.WinUploadManual();
                    }
                });

                $('#BtnDelete').FrameButton({
                    text: '删除',
                    icon: 'trash-o',
                    onClick: function () {
                        that.Delete();
                    }
                });

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
        clearDeleteManual();
        //var grid = $("#RstResultList").data("kendoGrid");
        //if (grid) {
        //    grid.dataSource.page(0);
        //    return;
        //}
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Query',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                
                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    //var kendoDataSource = GetKendoDataSource(business, 'Query', null, 20);
    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    title: "选择", width: 50, encoded: false,
                    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=ManualId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=ManualId#"></label>',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "ManualId", title: "教程手册ID", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "教程手册ID" }
                },
                {
                    field: "ManualName", title: "教程名称", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "教程名称" }
                },
                {
                    field: "Id", title: "下载",
                    width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "下载" },
                    template: "#if ($('\\#ManualId').val() != '') {#<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='download'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "Id", title: "删除",
                    width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "删除" },
                    template: "#if ($('\\#ManualId').val() != '') {#<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='delete'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
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
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstResultList").find("i[name='download']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.Download(data.ManualName, data.ManualUrl);

                });

                $("#RstResultList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    clearDeleteManual();
                    deleteManual.push(data.ManualId);
                    that.Delete();
                });

                $("#RstResultList").find(".Check-Item").unbind("click");
                $("#RstResultList").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstResultList").data("kendoGrid"),
                    dataItem = grid.dataItem(row);

                    if (checked) {
                        dataItem.IsChecked = true;
                        addItem(dataItem);
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeItem(dataItem);
                        row.removeClass("k-state-selected");
                    }
                });

                $('#CheckAll').unbind('change');
                $('#CheckAll').on('change', function (ev) {
                    var checked = ev.target.checked;
                    $('.Check-Item').each(function (idx, item) {
                        var row = $(this).closest("tr");
                        var grid = $("#RstResultList").data("kendoGrid");
                        var data = grid.dataItem(row);

                        if (checked) {
                            addItem(data);
                            $(this).prop("checked", true); //此处设置每行的checkbox选中，必须用prop方法
                            $(this).closest("tr").addClass("k-state-selected");  //设置grid 每一行选中
                        } else {
                            removeItem(data);
                            $(this).prop("checked", false); //此处设置每行的checkbox不选中，必须用prop方法
                            $(this).closest("tr").removeClass("k-state-selected");  //设置grid 每一行不选中
                        }
                    });
                });
            },
            page: function (e) {
                clearDeleteManual();
            }
        });
    }

    that.Download = function (Name, Url) {
        var url = '/Pages/Download.aspx?downloadname=' + escape(Name) + '&filename=' + escape(Url);
        open(url, 'Download');
    }

    that.Delete = function () {
        if (deleteManual.length > 0) {
            if (confirm('确认删除教程文件？')) {
                var data = {};
                data.LstManualID = deleteManual;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteData',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.ExecuteMessage != 'Success') {
                            //kendo.alert(model.ExecuteMessage);
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: model.ExecuteMessage,
                                callback: function () {
                                    clearDeleteManual();
                                }
                            });
                        }
                        else {
                            //kendo.alert("删除成功！");
                            FrameWindow.ShowAlert({
                                target: 'center',
                                alertType: 'info',
                                message: '删除成功！',
                                callback: function () {
                                    that.Query();
                                }
                            });
                        }
                        FrameWindow.HideLoading();
                    }
                });
            }
        }
        else {
            //kendo.alert('请选择需要删除的数据！');
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择需要删除的文件！',
                callback: function () {
                }
            });
        }
    }

    var clearDeleteManual = function () {
        $('#CheckAll').removeAttr("checked");
        deleteManual.splice(0, deleteManual.length);
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            deleteManual.push(data.ManualId);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < deleteManual.length; i++) {
            if (deleteManual[i] == data.ManualId) {
                deleteManual.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < deleteManual.length; i++) {
            if (deleteManual[i] == data.ManualId) {
                exists = true;
            }
        }
        return exists;
    }

    that.WinUploadManual = function () {
        $("#winManualLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 200,
            actions: [
                "Close"
            ],
            resizable: false,
            close: function () {
                that.Query();
            }
            //modal: true,
        }).data("kendoWindow").title("上传附件").center().open();
    }

    var setLayout = function () {
    }

    return that;
}();