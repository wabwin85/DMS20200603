
var PositionHospital = {};
PositionHospital = function () {
    var that = {};
    var business = 'MasterDatas.PositionHospital';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.PositionID = $("#selectedNodePositionID").val();
        model.ProductLineID = $("#selectedNodeProductLineID").val();
        return model;
    }

    var IMPORT_NAME = '销售岗位与医院', IMPORT_TYPE = 'PositionHospitalMap', NO_PER_WRITE = false;
    var hospitalPositionFields = {
        PositionID: { type: "string" },
        ProductLineID: { type: "string" },
        HospitalID: { type: "string" },
        HOS_Key_Account: { type: "string", editable: false },
        HOS_HospitalName: { type: "string", editable: false },
        HOS_Province: { type: "string", editable: false },
        HOS_City: { type: "string", editable: false },
        HOS_District: { type: "string", editable: false },
        operation: { type: "string", editable: false }
    };
    var hospitalPositionModel = kendo.data.Model.define({
        id: "ID",
        fields: hospitalPositionFields
    });
    var gridDataSource = new kendo.data.DataSource({
        transport: {
            read: {
                type: "post",
                url: Common.AppHandler + '?Business=' + business + '&Method=GetHospitalPosition',
                dataType: "json",
                contentType: "application/json; charset=utf-8"
            },
            parameterMap: function (options, operation) {
                if (operation == "read") {
                    var Data = that.GetModel();
                    Data.Page = options.page;
                    Data.PageSize = options.pageSize;
                    return JSON.stringify(Data);
                }
            }
        },

        schema: {
            model: hospitalPositionModel,
            data: function (d) {
                return d.data;
            },
            total: function (d) {
                return d.total;
            },
            parse: function (response) {
                if (typeof (response) != 'string') {
                    response = JSON.stringify(response);
                }
                var r = JSON.parse(response);
                return r.data;
            }
        },
        serverPaging: true,
        pageSize: 10
    });

    that.Init = function () {
        //初始化提示框
        $("#cornerNotification").kendoNotification({
            autoHideAfter: 2000,
            position: {
                bottom: 60
            }
        });

        //初始化导入
        dms.file.importDataByExcelInit(IMPORT_TYPE, "导入销售岗位与医院关系");

        $("#Splitter").kendoSplitter({
            panes: [
                { collapsible: false, collapsed: false, size: "30%" },
                { collapsible: false }
            ]
        });

        $("#treeview").kendoTreeView({
            loadOnDemand: false,
            //checkboxes: {
            //    checkChildren: true
            //},
            dataSource: that.treeDataSource,
            //check: onCheck
            dataTextField: "AttributeName",
            select: that.onSelect
        });

        that.initGrid();
        $("#btnAdd").attr("disabled", true).removeClass("addbtn-info");
        $("#btnSave").attr("disabled", true);
        $("#btnSave").attr("hidden", NO_PER_WRITE);

        $("#filterText").keyup(function (e) {
            var filterText = $(this).val();

            if (filterText != "") {
                $("#treeview .k-group .k-in").closest("li").hide();
                $("#treeview .k-group .k-in:contains(" + filterText + ")").each(function () {
                    $(this).parents("ul, li").each(function () {
                        $(this).show();
                    });
                });
            }
            else {
                $("#treeview .k-group").find("ul").hide();
                $("#treeview .k-group").find("li").show();
            }
        });

        $("#btnAddAuthHospital").click(function () {
            var data = that.gatherHospitalData();
            var msg = that.addAuthHospital(data);
        });

        $("#btnCancelAddAuthHospital").click(function () {
            slidePanel.close("divAddHospital");
        });

        $("#btnCancelImport").click(function () {
            slidePanel.close("uploadShow");
        });

        $("#BtnImport").FrameButton({
            text: '确认并导入',
            onClick: function () {
                that.ImportUploadInfo();
            }
        });
        $("#BtnDownTmp").FrameButton({
            text: '下载模板',
            onClick: function () {
                window.open('/Upload/ExcelTemplate/Template_PositionHospitalImport.xls');
            }
        });
        $('#filePositionHospital').kendoUpload({
            async: {
                saveUrl: "../Handler/UploadFile.ashx?Type=HospitalPositionInit&SheetName=Sheet1",
                autoUpload: true
            },
            localization: {
                headerStatusUploading: "上传处理中,请稍等..."
            },
            multiple: false,
            error: function onError(e) {
                if (e.XMLHttpRequest.responseText != "") {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: e.XMLHttpRequest.responseText,
                        callback: function () {
                        }
                    });
                }
                FrameWindow.HideLoading();
                var upload = $("#filePositionHospital").data("kendoUpload");
                upload.enable();
            },
            success: function onSuccess(e) {
                if (e.XMLHttpRequest.responseText != "") {
                    var obj = $.parseJSON(e.XMLHttpRequest.responseText);
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: obj.msg,
                        callback: function () {
                        }
                    });
                    that.QueryUploadInfo();
                }
                FrameWindow.HideLoading();
                var upload = $("#filePositionHospital").data("kendoUpload");
                upload.enable();
            },
            upload: function onUpload(e) {
                var files = e.files;
                // Check the extension of the file and abort the upload if it is not .xls or .xlsx
                $.each(files, function () {
                    if (this.extension.toLowerCase() != ".xls" && this.extension.toLowerCase() != ".xlsx") {
                        FrameWindow.ShowAlert({
                            target: 'center',
                            alertType: 'info',
                            message: '只能导入Excel文件！',
                            callback: function () {
                                e.preventDefault();
                                var dataSource = $("#RstUploadInfo").data("kendoGrid").dataSource;
                                dataSource.data([]);
                                FrameWindow.HideLoading();
                            }
                        });
                    }
                    else {
                        FrameWindow.ShowLoading();
                        var upload = $("#filePositionHospital").data("kendoUpload");
                        upload.disable();
                    }
                });
            }
        });
    };

    that.doExportExcel = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'LafiteLogListExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'PositionID', data.PositionID);
       
        startDownload(urlExport, 'LafiteLogListExport');//下载名称
    }

    that.QueryUploadInfo = function () {
        var grid = $("#RstUploadInfo").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(0);
            return;
        }
    }
    var dsUploadInfo = GetKendoDataSource(business, 'QueryUploadPositionHospitalInfo', null, 100000);
    //显示导入Panel
    that.showWindow = function () {
        $("#RstUploadInfo").kendoGrid({
            dataSource: dsUploadInfo,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 230,
            columns: [
                {
                    field: "LineNbr", title: "行号",
                    headerAttributes: { "class": "text-center text-bold", "title": "行号" }
                },
               {
                   field: "HOS_Key_Account", title: "医院编号",
                   headerAttributes: { "class": "text-center text-bold", "title": "医院编号" }
               },
                {
                    field: "HOS_HospitalName", title: "医院名称", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ErrorMsg", title: "错误信息",
                    headerAttributes: { "class": "text-center text-bold", "title": "错误信息" }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            }
        });
        $("#dlgImport").kendoWindow({
            title: "Title",
            width: 750,
            height: 400,
            actions: [
                "Maximize",
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("导入销售岗位与医院关系").center().open();
    }


    that.ImportUploadInfo = function () {
        var data = dsUploadInfo.data();
        that.addAuthHospital(data);
        $("#dlgImport").data("kendoWindow").close();
        //var data = {};
        //FrameUtil.SubmitAjax({
        //    business: business,
        //    method: 'ImportUserInfo',
        //    url: Common.AppHandler,
        //    data: data,
        //    callback: function (model) {
        //        FrameWindow.ShowAlert({
        //            target: 'center',
        //            alertType: 'info',
        //            message: model.ExecuteMessage,
        //            callback: function () {
        //            }
        //        });
        //        that.QueryUploadUserInfo();

        //        FrameWindow.HideLoading();
        //    }
        //});
    }

    that.treeDataSource = new kendo.data.HierarchicalDataSource({
        transport: {
            read: {
                type: "post",
                url: Common.AppHandler + '?Business=' + business + '&Method=GetPositionOrgs',
                dataType: "json",
                contentType: "application/json; charset=utf-8"
            },
            parameterMap: function (options, operation) {
                if (operation == "read") {
                    var Data = FrameUtil.GetModel();
                    Data.AttributeID = options.AttributeID ? options.AttributeID : "";
                    return JSON.stringify(Data);
                }
            }
        },
        schema: {
            model: {
                id: "AttributeID",
                hasChildren: "HasChildren",
                //expanded: true
            },
            data: function (res) {
                var data = res.PositionOrgs;
                $.each(data, function (i, item) {
                    if (item.AttributeType == "Position") {
                        if (item.TSR != null && item.TSR != '') {
                            item.spriteCssClass = "fa fa-street-view position";
                            item.AttributeName = item.AttributeName + "（" + item.TSR + "）";
                        } else {
                            item.spriteCssClass = "fa fa-street-view position-notsr";
                        }
                    }
                })
                return data;
            }
        }
    });

    that.onSelect = function (e) {
        var treeview = $("#treeview").data("kendoTreeView");

        var item = treeview.dataItem(e.node);
        if (item) {
            FrameWindow.ShowLoading();
            if (item.AttributeType != "Position") {
                e.preventDefault();
                setTimeout(function () {
                    $(e.node).find(".k-state-focused").removeClass("k-state-focused");
                    FrameWindow.HideLoading();
                });
            }
            else {
                if ($("#grid").data("kendoGrid").dataSource.hasChanges()) {
                    dms.common.confirm("有未保存的修改，是否继续？", function (res) {
                        if (res) {
                            //有变化放弃保存时，可切换岗位
                            that.showHospital(item);
                        } else {
                            e.preventDefault();
                            FrameWindow.HideLoading();
                        }
                    });
                } else {
                    //没有变化时，可切换岗位
                    that.showHospital(item);
                }
            }
        }
    }

    that.showHospital = function (positionItem) {
        $("#selectedNodePositionID").val(positionItem.id);
        $("#selectedNodeProductLineID").val(positionItem.ProductLineID);
        $("#selectedNodeProductLineName").val(positionItem.ProductLineName);

        that.initGrid();
        $("#btnAdd").attr("disabled", false).addClass("addbtn-info");
        $("#btnSave").attr("disabled", false);
    }

    jQuery.expr[':'].contains = function (a, i, m) {
        return jQuery(a).text().toUpperCase()
            .indexOf(m[3].toUpperCase()) >= 0;
    };

    that.saveChanges = function () {
        if ($("#btnSave").attr("disabled") == "disabled") {
            return false;
        }

        var grid = $("#grid").data("kendoGrid"),
            parameterMap = grid.dataSource.transport.parameterMap;
        var currentData = grid.dataSource.data();

        var index = [];
        for (var i = 0; i < currentData.length; i++) {
            if (currentData[i].IsValidProductLine == false || currentData[i].IsValidPosition == false || currentData[i].IsValidHospital == false) {
                index.push(i);
            }
        }
        if (index.length > 0) {
            dms.common.confirm("列表中存在产品线、岗位或医院已失效的数据，是否删除？", function (res) {
                if (res) {
                    for (i = index.length - 1; i >= 0; i--) {
                        var dataItem = currentData[index[i]];
                        grid.dataSource.remove(dataItem);
                    }
                    //dms.common.alert('删除成功！')
                    //return;
                    that.doSave();
                }
            });
        } else {
            that.doSave();
        }
    };

    that.doSave = function () {

        var grid = $("#grid").data("kendoGrid"),
            parameterMap = grid.dataSource.transport.parameterMap;
        var currentData = grid.dataSource.data();

        var createdRecords = [];
        for (var i = 0; i < currentData.length; i++) {
            if (currentData[i].isNew()) {
                createdRecords.push(currentData[i].toJSON());
            }
        }
        var deletedRecords = [];
        for (var i = 0; i < grid.dataSource._destroyed.length; i++) {
            deletedRecords.push(grid.dataSource._destroyed[i].toJSON());
        }
        var data = that.GetModel();
        var para = {};
        para.Created = createdRecords;
        para.Deleted = deletedRecords;
        data.HospitalPosition_ChangeRecords = para;
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveHospitalPositionMapChanges',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                dms.common.alert("保存成功!<br/>注意：如果删减了医院，系统不会自动处理经销商授权医院的配置，请留意检查。", function () {
                    grid.dataSource._destroyed = [];
                    grid.dataSource.read();
                });
            }
        });
    }

    that.initGrid = function (id) {

        var grid = $("#grid").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }

        $("#grid").kendoGrid({
            toolbar: kendo.template($("#template_toolbar").html()),
            dataSource: gridDataSource,
            autoBind: true,
            height: 480,
            resizable: true,
            selectable: "multiple, row",
            sortable: {
                mode: "multiple"
            },
            //filterable: {
            //    extra: false,
            //    operators: {
            //        string: {
            //            contains: "包含",
            //            doesnotcontain: "不包含",
            //            eq: "等于",
            //            neq: "不等于",
            //            startswith: "开头为",
            //            endswith: "结尾为"
            //        },
            //        date: {
            //            eq: "等于",
            //            neq: "不等于",
            //            gt: "大于",
            //            gte: "大于等于",
            //            lt: "小于",
            //            lte: "小于等于"
            //        }
            //    }
            //},
            pageable: {
                refresh: true,
                pageSizes: true
            },
            columns: [
                {
                    field: "HOS_Key_Account",
                    title: "医院编号",
                    width: 120
                }, {
                    field: "HOS_HospitalName",
                    title: "医院名称",
                }, {
                    field: "HOS_Province",
                    title: "省份",
                    width: 100
                }, {
                    field: "HOS_City",
                    title: "市",
                    width: 100
                }, {
                    field: "HOS_District",
                    title: "区/县",
                    width: 100
                },
                {
                    title: "操作",
                    field: "operation",
                    template: kendo.template($("#template_operation").html()),
                    width: 80,
                    headerAttributes: { "class": "align-center" },
                    attributes: { "class": "align-center" },
                    filterable: false,
                    sortable: false,
                    hidden: NO_PER_WRITE
                }
            ],
            editable: true,
            dataBound: function () {
                FrameWindow.HideLoading();
            }
        });
    }

    that.deleteSelected = function () {
        var grid = $("#grid").data("kendoGrid");
        if (grid) {
            var data = [];
            grid.select().each(function () {
                var dataItem = grid.dataItem(this);
                data.push(dataItem);
            });

            if (!data.length) {
                dms.common.alert('至少选中一条数据！');
                return;
            }

            dms.common.confirm("确认删除？", function (res) {
                if (res) {
                    $.each(data, function (i, item) {
                        grid.dataSource.remove(item);
                    })
                }
            });
        }
    }

    that.deleteAll = function () {
        var grid = $("#grid").data("kendoGrid");
        if (grid) {
            dms.common.confirm("确认删除？", function (res) {
                if (res) {
                    var deleteData;
                    var filters = grid.dataSource.filter();
                    var allData = grid.dataSource.data();
                    if (filters == undefined || filters.filters.length == 0) {
                        deleteData = allData;
                    } else {
                        var query = new kendo.data.Query(allData);
                        deleteData = query.filter(filters).data;
                    }

                    $(deleteData).each(function () {
                        var dataItem = this;
                        grid.dataSource.remove(dataItem);
                    });
                }
            });
        }
    }

    that.openAddHospitalDialog = function (e) {
        var button = $(e);
        if (button.attr("disabled") == "disabled") {
            return;
        }

        var data = that.GetModel();
        if (data.ProductLineID == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线下面的岗位'
            });
        }
        else {
            var url = Common.AppVirtualPath + 'Revolution/Pages/MasterDatas/HospitalPicker.aspx?IsMuliteSelect=true&IsFilterAuth=false&' + 'ProductLine=' + data.ProductLineID;
            FrameWindow.OpenWindow({
                target: 'top',
                title: '医院选择',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (list) {
                    if (list) {
                        that.addAuthHospital(list);
                    }
                }
            });
        }
    }

    //收集选中医院数据
    that.gatherHospitalData = function () {
        var data = [];
        var grid = $("#hospitalGrid").data("kendoGrid");
        grid.select().each(function () {
            var dataItem = grid.dataItem(this);
            data.push(dataItem);
        });

        return data;
    }

    //插入授权医院，data是数组或kendo.data.ObservableArray
    that.addAuthHospital = function (data) {

        var alreadyExist = false;
        var oldData = gridDataSource.data();
        var oldDataLength = oldData.length;
        var existedCount = 0;
        var model = that.GetModel();
        $.each(data, function (i, item) {
            var dataItem = new hospitalPositionModel();
            dataItem.ID = dms.common.newGuid();
            dataItem.PositionID = model.PositionID;
            dataItem.ProductLineID = model.ProductLineID;
            dataItem.HOS_Key_Account = item.HOS_Key_Account;
            dataItem.HOS_HospitalName = item.HOS_HospitalName;
            dataItem.HOS_Province = item.HOS_Province;
            dataItem.HOS_City = item.HOS_City;
            dataItem.HOS_District = item.HOS_District;
            dataItem.HospitalID = item.HOS_ID;

            var add = true;
            $(oldData).each(function () {
                if (this.HospitalID == item.HOS_ID) {
                    existedCount++;
                    add = false;
                    alreadyExist = true;
                    return false;
                }
            });
            if (add) {
                gridDataSource.add(dataItem);
            }

        });

        var notice = $("#cornerNotification").data("kendoNotification");//提示信息
        notice.hide();

        if (alreadyExist) {
            //dms.common.alert("注意：添加的授权医院全部或部分已经被添加过");
            if (existedCount == data.length) {
                notice.show("未添加，添加的授权医院全部已经被添加过", "error");
            } else {
                notice.show("添加成功，添加的授权医院部分已经被添加过", "warning");
            }
        } else {
            notice.show("添加成功，请及时保存信息！", "info");
        }
    }

    //收集全部可选医院数据（有过滤条件取过滤后的，注：其实全部也是根据产品线过滤后的）
    that.gatherAllHospitalData = function () {
        var d = null;
        var dataSource = $("#hospitalGrid").data("kendoGrid").dataSource;
        var filters = dataSource.filter();
        var allData = dataSource.data();

        if (filters == undefined || filters.filters.length == 0) {
            d = allData;
        } else {
            var query = new kendo.data.Query(allData);
            d = query.filter(filters).data;
        }

        return d;
    }

    return that;
}();