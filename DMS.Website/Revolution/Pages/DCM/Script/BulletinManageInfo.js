var BulletinManageInfo = {};

BulletinManageInfo = function () {
    var that = {};

    var business = 'DCM.BulletinManage';
    var chooseDealer = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var LstDealerTypeArr;

    that.InitDetail = function () {
        
        var data = {};
        $('#BulletId').val(Common.GetUrlParam('BulletId'));
        data.BulletId = $('#BulletId').val();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitDetail',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                LstDealerTypeArr = model.LstDealerType;
                $('#BulletId').val(model.BulletId);
                //公告内容
                $('#WinUrgentDegree').FrameDropdownList({
                    dataSource: model.LstUrgentDegree,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.WinUrgentDegree
                });
                $('#WinStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.WinStatus
                });
                $('#WinStatus').FrameDropdownList('disable');
                $('#WinExpirationDate').FrameDatePicker({
                    max: '9999-12-31',
                    value: model.WinExpirationDate
                });
                $('#WinIsRead').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.WinIsRead,
                });
                $('#WinTitle').FrameTextBox({
                    value: model.WinTitle
                });
                $('#WinBody').FrameTextArea({
                    value: model.WinBody,
                    height: '310px'
                });
                //经销商列表
                $('#WinFilterDealerType').FrameDropdownList({
                    dataSource: model.LstDealerType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.WinFilterDealerType
                });
                $('#WinFilterDealer').FrameTextBox({
                    value: model.WinFilterDealer
                });
                $('#WinFilterSAPCode').FrameTextBox({
                    value: model.WinFilterSAPCode
                });
                
                //按钮控制*******************
                //主页面 
                $('#BtnWinPublished').FrameButton({
                    text: '发布',
                    icon: 'bullhorn',
                    onClick: function () {
                        that.SetStatusPublished();
                    }
                });
                $('#BtnWinSaveDraft').FrameButton({
                    text: '保存草稿',
                    icon: 'save',
                    onClick: function () {
                        that.SetStatusDraft();
                    }
                });
                $('#BtnWinCancelled').FrameButton({
                    text: '作废',
                    icon: 'ban',
                    onClick: function () {
                        that.CancelledItem();
                    }
                });
                $('#BtnWinDelDraft').FrameButton({
                    text: '删除草稿',
                    icon: 'trash',
                    onClick: function () {
                        that.DeleteDraft();
                    }
                });
                $('#BtnWinCancel').FrameButton({
                    text: '返回',
                    icon: 'times-circle',
                    onClick: function () {
                        that.CancelModify();
                    }
                });
                //经销商列表
                $('#BtnWinAddItem').FrameButton({
                    text: '添加经销商',
                    icon: 'plus',
                    onClick: function () {
                        that.ShowFilterDealerWin();
                    }
                });
                $('#BtnFilterSearch').FrameButton({
                    text: '查找',
                    icon: 'search',
                    onClick: function () {
                        clearChooseDealer();
                        that.QueryFilterDealer();
                    }
                });
                $('#BtnFilterSave').FrameButton({
                    text: '添加',
                    icon: 'plus',
                    onClick: function () {
                        that.SubmitSelection();
                    }
                });
                $('#BtnFilterCancel').FrameButton({
                    text: '返回',
                    icon: 'times',
                    onClick: function () {
                        $("#winFilterDealerLayout").data("kendoWindow").close();
                    }
                });
                //附件列表
                $('#BtnWinAddAttach').FrameButton({
                    text: '添加附件',
                    icon: 'plus',
                    onClick: function () {
                        that.ShowAttachmentWin();
                    }
                });
                //上传文件
                $('#WinAttachUpload').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=UploadFile&FileType=Bulletin",
                        autoUpload: true
                    },
                    upload: function (e) {
                        e.data = { InstanceId: $('#BulletId').val() };
                    },
                    multiple: false,
                    success: function (e) {
                        //$("#BtnUploadProxy").FrameSortAble("FileaddNewData", e.response)
                        that.QueryAttachInfo();
                    }
                });

                createDetailList();
                createFilterDealer();
                createAttachList();

                //页面控制
                //按钮设置为不可见
                $('#BtnWinCancelled').hide();
                $('#BtnWinDelDraft').hide();
                $('#BtnWinPublished').hide();
                $('#BtnWinSaveDraft').hide();

                var gridDealer = $("#RstDealerDetailList").data("kendoGrid");
                var gridAttach = $("#RstAttachmentList").data("kendoGrid");
                gridDealer.hideColumn(8);
                gridAttach.hideColumn(7);

                //添加按钮不可用
                $('#BtnWinAddItem').hide();
                $('#BtnWinAddAttach').hide();

                //控件状态控制
                $('#WinUrgentDegree').FrameDropdownList('enable');
                $('#WinExpirationDate').FrameDatePicker('enable');
                $('#WinIsRead').FrameSwitch('enable');
                $('#WinTitle').FrameTextBox('enable');
                $('#WinBody').FrameTextArea('enable');

                if (model.WinIsEmptyId == true) {
                    $('#WinIsPageNew').val('True');

                    $('#BtnWinPublished').show();
                    $('#BtnWinSaveDraft').show();
                    $('#BtnWinAddItem').show();
                    $('#BtnWinAddAttach').show();
                    gridDealer.showColumn(8);
                    gridAttach.showColumn(7);

                }
                else {
                    if (model.WinIsPublisher == true)
                    {
                        if (model.WinHdStatus == 'Draft') {
                            $('#WinIsPageNew').val('True');
                            $('#BtnWinDelDraft').show();
                            $('#BtnWinPublished').show();
                            $('#BtnWinSaveDraft').show();
                            $('#BtnWinAddItem').show();
                            $('#BtnWinAddAttach').show();
                            gridDealer.showColumn(8);
                            gridAttach.showColumn(7);

                        }
                        else if (model.WinHdStatus == 'Published') {
                            $('#WinIsSaved').val('True');
                            $('#BtnWinCancel').hide();
                            $('#BtnWinCancelled').show();

                        }
                    }
                    if (model.WinHdStatus == 'Published' || model.WinHdStatus == 'Cancelled') {
                        $('#WinIsSaved').val('True');
                        $('#WinUrgentDegree').FrameDropdownList('disable');
                        $('#WinExpirationDate').FrameDatePicker('disable');
                        $('#WinIsRead').FrameSwitch('disable');
                        $('#WinTitle').FrameTextBox('disable');
                        $('#WinBody').FrameTextArea('disable');

                    }
                }

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.SetStatusPublished = function () {
        $('#WinHdStatus').val('Published');
        var data = that.GetModel();
			
        if (data.WinUrgentDegree.Key == "" || data.WinTitle == "" || data.WinBody == "")
        {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请填写完整！'
            });
            return;
        }
        else if (data.WinTitle.length > 400)
        {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '公告标题不能超过400字！'
            });
            return;
        }
        if (data.WinBody.length > 2000)
        {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '公告内容不能超过2000字！'
            });
            return;
        }
        if ($("#RstDealerDetailList").data("kendoGrid").dataSource.data().length == 0 && $('#WinHdStatus').val() == 'Published')
        {             
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择经销商！'
            });
        }          
        else
        {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SaveBulletin',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '保存成功！',
                        callback: function () {
                            top.deleteTabsCurrent();
                        }
                    });

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.SetStatusDraft = function () {
        $('#WinHdStatus').val('Draft');
        var data = that.GetModel();

        if (data.WinTitle.length > 400)
        {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '公告标题不能超过400字！'
            });
            return;
        }
        else if (data.WinBody.length > 2000)
        {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '公告内容不能超过2000字！'
            });
            return;
        }
        else{
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SaveBulletin',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '保存成功！',
                        callback: function () {
                            top.deleteTabsCurrent();
                        }
                    });

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.CancelledItem = function () {
        if (confirm('你确定要执行该操作吗？')) {
            var data = that.GetModel();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'CancelledItem',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '操作成功！',
                        callback: function () {
                            top.deleteTabsCurrent();
                        }
                    });

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.DeleteDraft = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteDraft',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '删除成功！',
                    callback: function () {
                        top.deleteTabsCurrent();
                    }
                });

                FrameWindow.HideLoading();
            }
        });
    }

    that.CancelModify = function () {
        $('#WinHdStatus').val('Draft');
        var data = that.GetModel();

        if (confirm('是否保存草稿？')) {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SaveBulletin',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '保存成功！',
                        callback: function () {
                            top.deleteTabsCurrent();
                        }
                    });

                    FrameWindow.HideLoading();
                }
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteDraft',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '删除成功！',
                        callback: function () {
                            top.deleteTabsCurrent();
                        }
                    });

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.QueryDetailInfo = function () {
        var grid = $("#RstDealerDetailList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }
    var fieldsDetail = { ConfirmDate: { type: "date", format: "{0: yyyy-MM-dd HH:mm:ss}" }, ReadDate: { type: "date", format: "{0: yyyy-MM-dd HH:mm:ss}" } };
    var kendoDetailDealer = GetKendoDataSource(business, 'QueryDetailInfo', fieldsDetail, 15);;
    var createDetailList = function () {
        $("#RstDealerDetailList").kendoGrid({
            dataSource: kendoDetailDealer,
            resizable: true,
            sortable: true,
            scrollable: true,
            //editable: true,
            height: 350,
            columns: [
                {
                    field: "Id", title: "Id", width: 100, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "Id" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DealerDmaId", title: "DealerDmaId", width: 100, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "DealerDmaId" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ChineseName", title: "中文名称", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "中文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SapCode", title: "ERP账号", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "ERP账号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "IsConfirm", title: "是否已确认", width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "是否已确认" },
                    template: "#if(IsConfirm){#<i class='fa fa-check-square-o' style='font-size: 14px; cursor: pointer;'></i>#}else{#<i class='fa fa-square-o' style='font-size: 14px; cursor: pointer;'></i>#}#",
                    attributes: { "class": "text-center table-td-cell" }
                },
                {
                    field: "ConfirmDate", title: "确认时间", width: 150, format: "{0:yyyy-MM-dd HH:mm:ss}",
                    headerAttributes: { "class": "text-center text-bold", "title": "确认时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "IsRead", title: "是否已阅读", width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "是否已阅读" },
                    template: "#if(IsRead){#<i class='fa fa-check-square-o' style='font-size: 14px; cursor: pointer;'></i>#}else{#<i class='fa fa-square-o' style='font-size: 14px; cursor: pointer;'></i>#}#",
                    attributes: { "class": "text-center table-td-cell" }
                },
                {
                    field: "ReadDate", title: "阅读时间", width: 150, format: "{0:yyyy-MM-dd HH:mm:ss}",
                    headerAttributes: { "class": "text-center text-bold", "title": "阅读时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "删除", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-times' style='font-size: 14px; cursor: pointer;' name='delete'></i>#}#",
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

                $("#RstDealerDetailList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    that.DeleteDealerItem(data.DealerDmaId);
                });

            },
            page: function (e) {
            }
        });
    }

    //删除经销商
    that.DeleteDealerItem = function (Id) {
        var data = {};
        data.DelDealerId = Id;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteDealerItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                that.QueryDetailInfo();

                FrameWindow.HideLoading();
            }
        });
    }

    //查询经销商
    that.QueryFilterDealer = function () {
        var grid = $("#RstFilterDealerResult").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }
    var kendoFilterDealer = GetKendoDataSource(business, 'QueryFilterDealer', fieldsAtt, 500);
    var createFilterDealer = function () {
        $("#RstFilterDealerResult").kendoGrid({
            dataSource: kendoFilterDealer,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 325,
            columns: [
                {
                    title: "选择", encoded: false,
                    width: 50,
                    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "ChineseName", title: "中文名称", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "中文名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "SapCode", title: "ERP账号", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "ERP账号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "DealerType", title: "经销商类别", width: 150, template: function (gridRow) {
                        var type = "";
                        if (LstDealerTypeArr.length > 0) {
                            if (gridRow.DealerType != "") {
                                $.each(LstDealerTypeArr, function () {
                                    if (this.Key == gridRow.DealerType) {
                                        type = this.Value;
                                        return false;
                                    }
                                })
                            }
                        }
                        return type;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "经销商类别" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Address", title: "地址", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "地址" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PostalCode", title: "邮编", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "邮编" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Phone", title: "电话", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "电话" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Fax", title: "传真", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "传真" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ActiveFlag", title: "有效", width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "有效" },
                    template: "#if(ActiveFlag){#<i class='fa fa-check-square-o' style='font-size: 14px; cursor: pointer;'></i>#}else{#<i class='fa fa-square-o' style='font-size: 14px; cursor: pointer;'></i>#}#",
                    attributes: { "class": "text-center table-td-cell" }
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

                $("#RstFilterDealerResult").find(".Check-Item").unbind("click");
                $("#RstFilterDealerResult").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstFilterDealerResult").data("kendoGrid"),
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
                        var grid = $("#RstFilterDealerResult").data("kendoGrid");
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
                clearChooseDealer();
            }
        });
        
    }

    that.ShowFilterDealerWin = function () {
        $("#winFilterDealerLayout").kendoWindow({
            title: "Title",
            width: 900,
            height: 500,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("明细").center().open();
    }

    var clearChooseDealer = function () {
        $('#CheckAll').removeAttr("checked");
        $('.Check-Item').removeAttr("checked");
        $('.Check-Item').closest("tr").removeClass("k-state-selected");
        chooseDealer.splice(0, chooseDealer.length);
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            chooseDealer.push(data);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < chooseDealer.length; i++) {
            if (chooseDealer[i].Id && data.Id && chooseDealer[i].Id == data.Id) {
                chooseDealer.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < chooseDealer.length; i++) {
            if (chooseDealer[i].Id && data.Id && chooseDealer[i].Id == data.Id) {
                exists = true;
            }
        }
        return exists;
    }

    that.SubmitSelection = function () {
        if (chooseDealer.length > 0)
        {
            var data = {};
            data.BulletId = $('#BulletId').val();
            var param = '';
            for (var i = 0; i < chooseDealer.length; i++) {
                param += chooseDealer[i].Id + ',';
            }
            data.ChooseParam = param.substr(0, param.length - 1);
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SubmitSelection',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    
                    that.QueryDetailInfo();
                    clearChooseDealer();
                    that.QueryFilterDealer()
                    
                    FrameWindow.HideLoading();
                }
            });
        }
        else
        {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择要添加的数据！',
            });
        }
    }

    //附件
    that.QueryAttachInfo = function () {
        var grid = $("#RstAttachmentList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }
    var fieldsAtt = { UploadDate: { type: "date", format: "{0: yyyy-MM-dd}" } };
    var kendoAttach = GetKendoDataSource(business, 'QueryAttachInfo', fieldsAtt, 10);
    var createAttachList = function () {
        $("#RstAttachmentList").kendoGrid({
            dataSource: kendoAttach,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 345,
            columns: [
                {
                    field: "Id", title: "Id", hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "Id" }
                },
                {
                    field: "MainId", title: "MainId", hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "MainId" }
                },
                {
                    field: "Name", title: "附件名称",
                    headerAttributes: { "class": "text-center text-bold", "title": "附件名称" }
                },
                {
                    field: "Url", title: "Url", hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "Url" }
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
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='downloadAttach'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    field: "Id", title: "删除",
                    headerAttributes: { "class": "text-center text-bold", "title": "删除" },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-times' style='font-size: 14px; cursor: pointer;' name='deleteAttach'></i>#}#",
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

                $("#RstAttachmentList").find("i[name='downloadAttach']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.DownloadAttach(data.Name, data.Url);

                });

                $("#RstAttachmentList").find("i[name='deleteAttach']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    that.DeleteAttach(data.Id, data.IsCurrent);
                });

            },
            page: function (e) {
            }
        });
    }

    that.DownloadAttach = function (Name, Url) {
        var url = '../Download.aspx?downloadname=' + escape(Name) + '&filename=' + escape(Url);
        open(url, 'Download');
    }

    that.DeleteAttach = function (ID, IsCurrent) {
        var data = {};
        data.DelAttachId = ID;
        if (confirm('是否要删除该附件？')) {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteAttach',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '删除成功！'
                    });
                    
                    that.QueryAttachInfo();
                    FrameWindow.HideLoading();
                }
            });
        }

    }

    that.ShowAttachmentWin = function () {
        $("#winAttachLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 200,
            actions: [
                "Close"
            ],
            resizable: false,
            close: function () {
                that.QueryAttachInfo();
            }
            //modal: true,
        }).data("kendoWindow").title("上传附件").center().open();
    }

    var setLayout = function () {
    }

    return that;
}();
