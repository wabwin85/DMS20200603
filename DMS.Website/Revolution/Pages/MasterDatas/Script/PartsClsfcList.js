var PartsClsfcList = {};

PartsClsfcList = function () {
    var that = {};

    var business = 'MasterDatas.PartsClsfcList';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.ProductLineId = $("#hidSelectProductLineId").val();
        model.ProductCatagoryPctId = $("#hidSelectNodeId").val();
        return model;
    }

    that.Init = function () {

        $("#cornerNotification").kendoNotification({
            autoHideAfter: 2000,
            position: {
                bottom: 60
            }
        })
        //注册popover
        $('[data-toggle="popover"]').popover();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: that.GetModel(),
            callback: function (model) {
                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.QryProductLine,
                    onChange: function (s) {
                        that.ProductLineChange(this.value);
                    }
                });
                $('#WinProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.QryProductLine
                });
                $('#WinIsContain').FrameDropdownList({
                    dataSource: [{ Key: '1', Value: '包含' }, { Key: '0', Value: '不包含' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select'
                });
            }
        });

        $("#treeview").kendoTreeView({
            loadOnDemand: false,
            dataSource: that.treeNode,
            dataTextField: "Name",
            select: that.onSelect
        });

        that.initRstContainProduct();
        $("#divSplit").kendoSplitter({
            orientation: "divSplit",
            panes: [
                { collapsible: true, size: "320px" },
                { collapsible: false },
                { collapsible: true }
            ]
        });

        //分类树添加右键菜单
        $("#contentMenu").kendoContextMenu({
            orientation: "vertical",
            target: "#treeview",
            filter: ".k-in",
            animation: {
                open: {
                    effects: "fadeIn",
                },
                //duration: 1000
            },
            open: function(e) {
                var node = $(e.target); //分类树选中的节点
                var item = $("#treeview").data("kendoTreeView").dataItem(node);
                if (item.ClsNode == "Quota") {
                    $('#liMenuAdd').hide();
                }
                else {
                    $('#liMenuAdd').show();
                }
            },
            select: function (e) {
                $('#popoverModal').show(); //显示遮罩层
                var button = $(e.item); //右键菜单选中的按钮
                var node = $(e.target); //分类树选中的节点
                var Title = button.context.innerText;
                var operatype = "";
                //alert(kendo.format("'{0}' button clicked on '{1}' node", button.text(), node.text()));

                var item = $("#treeview").data("kendoTreeView").dataItem(node);
                if (item.Id == "00000000-0000-0000-0000-000000000000") {
                    Title = "新增分类";
                }
                $("#hidSelectNodeId").val(item.Id);
                $("#ClsNode").val(item.ClsNode);
                if (button.context.innerText.trim() == "新增分类") {
                    operatype = "Add";
                } else if (button.context.innerText.trim() == "编辑分类") {
                    operatype = "Edit";
                } else {
                    operatype = "Delete";
                }
                if (operatype != "Delete" && !(item.Id == "00000000-0000-0000-0000-000000000000" && operatype == "Edit")) {
                    $('li[data-uid="' + item.uid + '"] span.k-state-border-down').popover({
                        animation: true,
                        template: '<div id="poppanel" class="popover" style="width:400px;max-width: 400px" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>',
                        container: 'body',
                        html: true,
                        title: Title,
                        content: function () {
                            return $('#template_popover').html();
                        }
                    }).popover('show');
                } else {
                    $('#popoverModal').hide();
                    $('#treeview span[aria-describedby^=\'popover\']').popover('hide');
                    $('#treeview span[aria-describedby^=\'popover\']').popover('destroy');
                }

                that.operatePart(operatype);
            }
        });
        //选择产品飘窗
        $("#btnCancel").click(function (event) {
            $("#RightEditShow").data("kendoWindow").close();
        })
        $(".cd-panel__container").click(function (e) {
            e.stopPropagation();
        });
        dms.file.importDataByExcelInit("CfnPartsReation", "导入CFN、产品分类关系数据");
        //导入窗口
        //$("#ImportExcelWindow").kendoWindow({
        //    width: "400px",
        //    height: "200px",
        //    title: "分类属性",
        //    modal: true,
        //    actions: ["Close"]
        //});

    };

    that.ProductLineChange = function (Bu) {
        if ($("#hidSelectProductLineId").val() != Bu) {
            $("#hidSelectProductLineId").val(Bu);
            that.treeNode.read();
            FrameWindow.HideLoading();
        }
    }
    that.treeNode = new kendo.data.HierarchicalDataSource({
        transport: {
            read: {
                type: "Post",
                url: Common.AppHandler + '?Business=' + business + '&Method=GetPartsClsfcTree',
                dataType: "json",
                contentType: "application/json; charset=utf-8"
            },
            parameterMap: function (options, operation) {
                if (operation == "read") {
                    var Data = FrameUtil.GetModel();
                    Data.ParentID = options.Id ? options.Id : "";
                    return JSON.stringify(Data);
                }
            }
        },
        schema: {
            model: {
                hasChildren: "HasChildren",
                id: "Id",
                //children: "LPartsTree",
                children: that.treeNode,
                fields: {
                    HasChildren: { type: "boolean" }
                }
            },
            data: function (d) {
                //var dat = "[" + JSON.stringify(d.Result.TreeList) + "]";
                //return $.parseJSON(dat);
                return d.LstPartsClassification;
            },
            parse: function (d) {
                FrameWindow.HideLoading();
                return d;
            }, errors: "error"
        }

    });
    //左侧分类操作
    that.operatePart = function (opType) {
        $("#hidOperatePartType").val(opType);
        //var win = $("#PartsWindow").data("kendoWindow");

        if ($("#hidSelectNodeId").val() != "") {
            var tree = $("#treeview").data("kendoTreeView");
            //var selectedNode = tree.select();
            var item = tree.dataSource.get($("#hidSelectNodeId").val());
            var selectedNode = tree.findByUid(item.uid);

            if (item.ParentId == '') {
                if (opType == "Add") {
                    //新增产品线
                    //$("#spanLeftEditTitle").text("新增产品线");
                    $("#lblPartName").text("产品线名称：");

                    //showPartsWin();
                    //$("#liParentName").hide();
                    //$("#liShortName").show();
                    //$("#LeftEditShow").addClass("cd-panel--is-visible");
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: "顶层分类不能做此操作",
                        callback: function () {
                        }
                    });
                }
            }
            else {
                //普通节点
                if (opType != "Delete") {
                    if (opType == "Add") {
                        $("#lblPartName").text("分类名称：");
                        $("#txtPartName").val('');
                        $("#txtPartDes").val('');
                        $("#txtPartENName").val('');
                        $("#txtPartCode").val('');
                        $("#lblParentCode").text(item.Code);
                        $("#lblParentName").text(item.Name);

                    }
                    else {
                        //showPartsWin();
                        //$("#LeftEditShow").addClass("cd-panel--is-visible");
                        $("#txtPartName").val(item.Name);
                        $("#txtPartDes").val(item.Description);
                        $("#txtPartENName").val(item.EnglishName);
                        $("#txtPartCode").val(item.Code);

                        if (item.ParentId == '') {
                            //$("#spanLeftEditTitle").text("修改产品线");
                            //win.title("修改产品线");
                            $("#lblPartName").text("产品线名称：");

                            //$("#liParentName").hide();
                            //$("#liShortName").show();
                        }
                        else {
                            var pitem = tree.dataSource.get(item.ParentId);
                            if (pitem != undefined) {
                                $("#lblParentName").text(pitem.Name);
                                $("#lblParentCode").text(pitem.Code);
                            }
                            //$("#spanLeftEditTitle").text("修改分类");
                            //win.title("修改分类");
                            $("#lblPartName").text("分类名称：");
                            //$("#liParentName").show();
                            //$("#liShortName").hide();
                        }
                    }
                }
                else {
                    //删除节点
                    //dms.common.confirm(, function (res) {
                    if (confirm("删除操作不可逆，是否确认删除？")) {
                        if (item.HasChildren) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: "删除失败！该分类含有子分类，请先删除子分类，再进行本操作",
                                callback: function () {
                                }
                            });
                        }
                        else {
                            //删除节点
                            
                            var data = {};
                            data.hidSelectNodeId = $("#hidSelectNodeId").val();
                            data.ClsNode = $("#ClsNode").val();

                            FrameWindow.ShowLoading();
                            FrameUtil.SubmitAjax({
                                business: business,
                                method: 'DeleteNode',
                                url: Common.AppHandler,
                                data: data,
                                callback: function (model) {
                                    if (model.ExecuteMessage == "Success") {
                                        FrameWindow.ShowAlert({
                                            target: 'top',
                                            alertType: 'info',
                                            message: "删除成功",
                                            callback: function () {
                                            }
                                        });
                                        tree.remove(selectedNode);
                                        FrameWindow.HideLoading();
                                    } else {
                                        FrameWindow.ShowAlert({
                                            target: 'top',
                                            alertType: 'info',
                                            message: model.ExecuteMessage,
                                            callback: function () {
                                            }
                                        });
                                        FrameWindow.HideLoading();
                                    }
                                }
                            });

                        }
                    }
                    //})
                }
            }
        }
        else {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: "请先选择分类节点",
                callback: function () {
                }
            });
        }
    };

    //新增操作
    that.openAddCFNDialog = function (e) {
        if ($("#btnAdd").attr("disabled") == "disabled") {
            return;
        }
        if ($("#hidSelectIsLeafNode").val() == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: "请先选择对应的分类节点",
                callback: function () {
                }
            });
            return;
        }
        if ($("#hidSelectIsLeafNode").val() == "true") {
            var button = $(e.target);
            if (button.attr("disabled") == "disabled") {
                return;
            }
            $("#cfn").val('');
            that.initRstProductInfo();
            $("#RightEditShow").kendoWindow({
                title: "Title",
                width: 1010,
                height: 580,
                actions: [
                    "Close"
                ],
                resizable: false,
                //modal: true,
            }).data("kendoWindow").title("产品信息查询").center().open();
        }
        else {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: "授权产品分类节点才能添加产品，请重新选择",
                callback: function () {
                }
            });
        }
    }
    that.onSelect = function (e) {
        var treeview = $("#treeview").data("kendoTreeView");
        if (treeview) {
            var item = treeview.dataItem(e.node);
            if (item) {
                if ($("#RstContainProduct").data("kendoGrid").dataSource.hasChanges() || $("#hidHasAddCFNFlag").val() == "true") {
                    dms.common.confirm("有未保存的修改，是否继续？", function (res) {
                        if (res) {
                            that.initContainPartsClassificationData(item);
                        } else {
                            e.preventDefault();
                            return;
                        }
                    });
                } else {
                    that.initContainPartsClassificationData(item);
                }
            }
        }
    }

    that.initContainPartsClassificationData = function (item) {
        $("#hidHasAddCFNFlag").val(false);

        $("#hidSelectNodeId").val(item.Id);
        $("#ClsNode").val(item.ClsNode);
        $("#hidSelectProductLineId").val(item.ProductLineId);

        if (item.ClsNode == "Authorization") {
            $("#hidSelectIsLeafNode").val(true);
            $("#btnSave").attr("disabled", false);
            $("#btnAdd").attr("disabled", false);
            $("#btnAdd").addClass("addbtn-info");
            $("#btnSave").addClass("submitbtn-info");
        }
        else {
            $("#hidSelectIsLeafNode").val(false);
            $("#btnSave").attr("disabled", true);
            $("#btnAdd").attr("disabled", true);
            $("#btnAdd").attr("disabled", true).removeClass("addbtn-info");
            $("#btnSave").attr("disabled", true).removeClass("submitbtn-info");
        }
        that.initRstContainProduct();
    };

    that.deleteSelected = function () {
        var RstContainProduct = $("#RstContainProduct").data("kendoGrid");
        if (RstContainProduct) {
            var data = [];
            RstContainProduct.select().each(function () {
                var dataItem = RstContainProduct.dataItem(this);
                data.push(dataItem);
            });

            if (!data.length) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '至少选中一条数据!',
                    callback: function () {
                    }
                });
                return;
            }

            //if (!confirm("确认删除？")) {
            //    return;
            //}

            $.each(data, function (i, item) {
                RstContainProduct.dataSource.remove(item);
            })
        }
    }
    that.deleteAll = function () {
        var RstContainProduct = $("#RstContainProduct").data("kendoGrid");
        if (RstContainProduct) {
            if (RstContainProduct.dataSource.data().length == 0) {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'info',
                    message: "当前无需要删除的数据",
                    callback: function () {
                    }
                });
                return;
            }
            //if (!confirm("确认删除？")) {
            //    return;
            //}

            var deleteData;
            var filters = RstContainProduct.dataSource.filter();
            var allData = RstContainProduct.dataSource.data();
            if (filters == undefined || filters.filters.length == 0) {
                deleteData = allData;
            } else {
                var query = new kendo.data.Query(allData);
                deleteData = query.filter(filters).data;
            }

            $(deleteData).each(function () {
                var dataItem = this;
                RstContainProduct.dataSource.remove(dataItem);
            });
        }
    }
    that.RstContainProductDataSource = new kendo.data.DataSource({
        transport: {
            read: {
                type: "post",
                url: Common.AppHandler + '?Business=' + business + '&Method=GetContainProducts',
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
            model: {
                id: "Id",
                fields: {
                    Id: { type: "string" },
                    CustomerFaceNbr: { type: "string" },
                    EnglishName: { type: "string" },
                    ChineseName: { type: "string" },
                    Description: { type: "string" },
                    PCTName: { type: "string" },
                    PCTEnglishName: { type: "string" },
                    ProductLineName: { type: "string" },
                    Implant: { type: "boolean" },
                    Tool: { type: "boolean" },
                    Share: { type: "boolean" }
                }
            },
            data: function (d) {
                return d.LstContainProducts;
            },
            total: function (d) {
                return d.DataCount;
            },
            parse: function (d) {
                return d;
            }, errors: "error",
        },
        batch: true,
        pageSize: 10,
        serverPaging: true
    });
    that.initRstContainProduct = function () {
        var RstContainProduct = $("#RstContainProduct").data("kendoGrid");
        if (RstContainProduct) {
            RstContainProduct.dataSource.read();
            return;
        }
        $("#RstContainProduct").kendoGrid({
            toolbar: kendo.template($("#template_toolbar").html()),
            dataSource: that.RstContainProductDataSource,
            height: 450,
            groupable: false,
            sortable: true,
            resizable: true,
            selectable: "multiple, row",
            pageable: {
                refresh: true,
                pageSizes: true,
                buttonCount: 5
            },
            columns: [{
                field: "CustomerFaceNbr",
                title: "产品型号",
                width: 100
            }, {
                field: "EnglishName",
                title: "英文说明",
                width: 150
            }, {
                field: "ChineseName",
                title: "中文说明",
                width: 150
            }, {
                field: "ProductLineName",
                title: "产品线",
            }, {
                template: "#if(Implant){#" + "植入" + "#}else{#" + "非植入" + "#}#",
                field: "Implant",
                title: "植入",
                width: 70,
                attributes: { style: "text-align:center;" }
            }, {
                template: "#if(Tool){#" + "是" + "#}else{#" + "否" + "#}#",
                field: "Tool",
                title: "工具",
                width: 90,
                attributes: { style: "text-align:center;" }
            }, {
                template: "#if(Share){#" + "是" + "#}else{#" + "否" + "#}#",
                field: "Share",
                title: "共享",
                width: 80,
                attributes: { style: "text-align:center;" }
            }
            , {
                title: "操作", field: "del", filterable: false, template: "<a id=\"delCFN\" style=\"text-align:center; color:blue;cursor:pointer\">删除</a>",
                width: 50, headerAttributes: { "class": "align-center" },
                attributes: { style: "text-align:center;" }
            }],
            dataBound: function () {
                $("a[id=delCFN]").bind("click",
                function (e) {
                    var row = $(this).closest("tr"),
                    RstContainProduct = $("#RstContainProduct").data("kendoGrid"),
                    dataItem = RstContainProduct.dataItem(row);
                    that.RstContainProductDataSource.remove(dataItem);
                })
            }
        });
    }
    that.initRstProductInfo = function () {
        var RstProductInfo = $("#RstProductInfo").data("kendoGrid");
        if (RstProductInfo) {
            RstProductInfo.dataSource.read();
            return;
        }
        $("#RstProductInfo").kendoGrid({
            toolbar: kendo.template($("#template").html()),
            dataSource: {
                //data: products,
                transport: {
                    read: {
                        type: "post",
                        url: Common.AppHandler + '?Business=' + business + '&Method=GetCFNList',
                        dataType: "json",
                        contentType: "application/json; charset=utf-8"
                    },
                    //parameterMap: function (options, operation) {
                    //    if (operation == "read") {
                    //        var parameter = {
                    //            jsonMessageString: JSON.stringify({
                    //                ActionName: "CFN", Parameters: {
                    //                    OperateType: "GetCFNList",
                    //                    page: options.page,
                    //                    pageSize: options.pageSize,
                    //                    ProductLine: "",
                    //                    ProductCatagoryPctId: "",
                    //                    CFN: $("#cfn").val()
                    //                }
                    //            })
                    //        };
                    //        return parameter;
                    //    }
                    //}
                    parameterMap: function (options, operation) {
                        if (operation == "read") {
                            var Data = {};
                            Data.WinProductLine = $('#WinProductLine').FrameDropdownList('getValue');
                            Data.WinProductModel = $("#cfn").val();
                            Data.WinIsContain = $('#WinIsContain').FrameDropdownList('getValue');
                            Data.Page = options.page;
                            Data.PageSize = options.pageSize;
                            return JSON.stringify(Data);
                        }
                    }
                },
                schema: {
                    model: {
                        id: "Id",
                        fields: {
                            Id: { type: "string" },
                            CustomerFaceNbr: { type: "string" },
                            EnglishName: { type: "string" },
                            ChineseName: { type: "string" },
                            Description: { type: "string" },
                            PCTName: { type: "string" },
                            PCTEnglishName: { type: "string" },
                            ProductLineName: { type: "string" },
                            Implant: { type: "boolean" },
                            Tool: { type: "boolean" },
                            Share: { type: "boolean" }
                        }
                    },
                    data: function (d) {
                        return d.RstProductInfo;
                    },
                    total: function (d) {
                        return d.DataCount;
                    },
                    parse: function (d) {
                        return d;
                    }, errors: "error",
                },
                batch: true,
                pageSize: 10,
                serverPaging: true
            },
            height: 355,
            groupable: false,
            sortable: true,
            resizable: true,
            selectable: "multiple, row",
            pageable: {
                refresh: true,
                pageSizes: true,
                buttonCount: 5
            },
            columns: [{
                field: "CustomerFaceNbr",
                title: "产品型号",
                width: 100,
                template: " <span style=\"#:PCTName != null ? 'color:red' : ''#\">#:CustomerFaceNbr == null ? '' : CustomerFaceNbr #</span>"
            }, {
                field: "EnglishName",
                title: "英文说明",
                width: 150
            }, {
                field: "ChineseName",
                title: "中文说明",
                width: 200
            }, {
                field: "Description",
                title: "描述",
                width: 200
            }, {
                field: "PCTName",
                title: "产品分类",
                width: 150
            }, {
                field: "PCTEnglishName",
                title: "产品分类英文名称",
                width: 150
            }, {
                field: "ProductLineName",
                title: "产品线",
                width: 150
            }, {
                template: "#if(Implant){#" + "植入" + "#}else{#" + "非植入" + "#}#",
                field: "Implant",
                title: "植入",
                width: 70,
                attributes: { style: "text-align:center;" }
            }, {
                template: "#if(Tool){#" + "是" + "#}else{#" + "否" + "#}#",
                field: "Tool",
                title: "工具",
                width: 60,
                attributes: { style: "text-align:center;" }
            }, {
                template: "#if(Share){#" + "是" + "#}else{#" + "否" + "#}#",
                field: "Share",
                title: "共享",
                width: 60,
                attributes: { style: "text-align:center;" }
            }],
            dataBound: function (e) {
                var RstProductInfo = this;
                RstProductInfo.tbody.find("tr").dblclick(function (e) {
                    var dataItem = RstProductInfo.dataItem(this);
                    that.AddCfn();

                });
            }
        });
    }
    ////关闭右侧分类飘窗
    //var CloseWindow = function () {
    //    $("#LeftEditShow").removeClass("cd-panel--is-visible");
    //}

    //保存修改分类
    that.savePartsCls = function () {
        if ($("#txtPartName").val().trim() == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: $("#lblPartName").text() + "必填",
                callback: function () {
                }
            });
            return;
        }

        //if ($("#txtPartName").val().trim() == "") {
        //    FrameWindow.ShowAlert({
        //        target: 'top',
        //        alertType: 'info',
        //        message: "分类名称必填",
        //        callback: function () {
        //        }
        //    });
        //    return;
        //}

        var tree = $("#treeview").data("kendoTreeView");
        var selectedNode = tree.select();
        //var selectedDataItem = tree.dataItem(selectedNode);
        var selectedDataItem = tree.dataSource.get($("#hidSelectNodeId").val());
        var newId = dms.common.newGuid();

        var param = {
            PartName: $("#txtPartName").val(),
            PartDes: $("#txtPartDes").val(),
            PartENName: $("#txtPartENName").val(),
            ProductLineId: $("#hidSelectProductLineId").val(),
            ParentCode: $("#lblParentCode").text(),
            Code: $("#txtPartCode").val(),
            ClsNode: $("#ClsNode").val()
        };
        FrameWindow.ShowLoading();
        
        var data = {};
        data.PartName = $("#txtPartName").val();
        data.PartDes = $("#txtPartDes").val();
        data.PartENName = $("#txtPartENName").val();
        data.ProductLineId = $("#hidSelectProductLineId").val();
        data.ParentCode = $("#lblParentCode").text();
        data.Code = $("#txtPartCode").val();
        data.ClsNode = $("#ClsNode").val();
        if ($("#hidOperatePartType").val() == "Add") {
            data.ChangeNodeId = "";
        }
        else {
            data.ChangeNodeId = $("#hidSelectNodeId").val();
        }
        data.hidSelectNodeId = $("#hidSelectNodeId").val();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveNode',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.ExecuteMessage == "Success") {
                    if ($("#hidOperatePartType").val() == "Add") {//新增
                        var obj = new Object();
                        obj.Id = model.ChangeNodeId;
                        obj.Name = param.PartName;
                        obj.Description = param.PartDes;
                        obj.EnglishName = param.PartENName;
                        obj.ParentId = model.hidSelectNodeId;
                        obj.ProductLineId = param.ProductLineId;
                        obj.ParentCode = param.ParentCode;
                        obj.Code = param.Code;
                        obj.ClsNode = model.ClsNode;
                        obj.HasChildren = false;
                        selectedDataItem.append(obj);
                    }
                    else {//修改
                        selectedDataItem.Name = param.PartName;;
                        selectedDataItem.Description = param.PartDes;
                        selectedDataItem.EnglishName = param.PartENName;
                        selectedDataItem.ParentCode = param.ParentCode;
                        selectedDataItem.Code = param.Code;

                        selectedDataItem.set("text", param.PartName);
                    }
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: "保存成功!",
                        callback: function () {
                        }
                    });
                    //$("#LeftEditShow").removeClass("cd-panel--is-visible");
                    that.CloseLimWin();
                    $("#txtPartName").val("");
                    $("#txtPartDes").val("");
                    $("#txtPartENName").val("");
                    $("#txtPartCode").val("");
                    FrameWindow.HideLoading();
                } else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: "保存失败！",
                        callback: function () {
                        }
                    });
                    FrameWindow.HideLoading();
                }
            }
        });

    }
    that.reloadProductInfo = function () {
        if ($("#RstProductInfo") != null) {
            var RstProductInfo = $("#RstProductInfo").data("kendoGrid");
            if (RstProductInfo) {
                RstProductInfo.dataSource.page(1);
                return;
            }
        }
    }
    //添加产品
    that.AddCfn = function () {
        //var data = gatherCFNData();

        var data = [];
        var RstProductInfo = $("#RstProductInfo").data("kendoGrid");
        if (RstProductInfo.select() == undefined || RstProductInfo.select().length == 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: "请先选择产品，再添加。",
                callback: function () {
                }
            });
            return;
        }
        //添加产品是否存在已配置分类标识；
        var flag = false;
        RstProductInfo.select().each(function () {
            var dataItem = RstProductInfo.dataItem(this);

            data.push(dataItem);
            if (dataItem.PCTName != null && dataItem.PCTName != "") {
                flag = true;
            }
        });

        if (flag) {
            //dms.common.confirm(, function (res) {
            if (!confirm("添加的部分产品已配置分类，是否继续添加？")) {
                return;
            }
            else {
                var msg = that.addCFNItems(data);
                //that.callFlyAnimation();
                //dms.common.confirm(, function (res) {
                if (!confirm(msg)) {
                    //$("#RightEditShow").removeClass("cd-panel--is-visible");
                    $("#RightEditShow").data("kendoWindow").close();
                }
                //})
            }
            //})
        }
        else {
            var msg = that.addCFNItems(data);
            //that.callFlyAnimation();
            //dms.common.confirm(, function (res) {
            if (!confirm(msg)) {
                //$("#RightEditShow").removeClass("cd-panel--is-visible");
                $("#RightEditShow").data("kendoWindow").close();
            }
            //})
        }
    }
    //收集cfn数据
    that.gatherCFNData = function () {
        var data = [];
        var RstProductInfo = $("#RstProductInfo").data("kendoGrid");
        RstProductInfo.select().each(function () {
            var dataItem = RstProductInfo.dataItem(this);
            data.push(dataItem);
        });

        return data;
    }
    //插入CFN，data是数组或kendo.data.ObservableArray
    that.addCFNItems = function (data) {
        var oldData = that.RstContainProductDataSource.data();
        var oldDataLength = oldData.length;

        $.each(data, function (i, item) {
            var dataItem = new Object();
            dataItem.Id = item.Id;
            dataItem.ProductCatagoryPctId = $("#hidSelectNodeId").val();
            dataItem.ProductLineBumId = $("#hidSelectProductLineId").val();
            dataItem.CustomerFaceNbr = item.CustomerFaceNbr;
            dataItem.EnglishName = item.EnglishName;
            dataItem.ChineseName = item.ChineseName;
            dataItem.ProductLineName = item.ProductLineName;
            dataItem.Implant = item.Implant;
            dataItem.Tool = item.Tool;
            dataItem.Share = item.Share;
            dataItem.State = "Added";

            var add = true;
            $(oldData).each(function () {
                if (this.Id == item.Id) {
                    add = false;
                    return false;
                }
            });
            if (add) {
                that.RstContainProductDataSource.add(dataItem);
                $("#hidHasAddCFNFlag").val(true);
            }

        });

        if (oldDataLength == that.RstContainProductDataSource.data().length) {
            return "是否继续添加产品?";
        } else {
            return "添加成功，是否继续添加产品?";
        }
    }
    //最后保存
    that.saveChanges = function () {
        if ($("#btnSave").attr("disabled") == "disabled") {
            return;
        }
        var RstContainProduct = $("#RstContainProduct").data("kendoGrid"),
            parameterMap = RstContainProduct.dataSource.transport.parameterMap;
        var currentData = RstContainProduct.dataSource.data();
        var createdRecords = [];
        for (var i = 0; i < currentData.length; i++) {
            if (currentData[i].State == "Added") {
                createdRecords.push(currentData[i].toJSON());
            }
        }
        var deletedRecords = [];
        for (var i = 0; i < RstContainProduct.dataSource._destroyed.length; i++) {
            deletedRecords.push(RstContainProduct.dataSource._destroyed[i].toJSON());
        }
        if (createdRecords.length == 0 && deletedRecords.length == 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: "数据未做修改，无需保存",
                callback: function () {
                }
            });
        }
        else {
            var data = that.GetModel();
            data.PartsCls_ChangeRecords_Created = JSON.stringify(createdRecords);
            data.PartsCls_ChangeRecords_Deleted = JSON.stringify(deletedRecords);

            FrameUtil.SubmitAjax({
                business: business,
                method: 'SaveCfnPartsRelationChanges',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    dms.common.alert("保存成功!", function () {
                        RstContainProduct.dataSource._destroyed = [];
                        RstContainProduct.dataSource.read();
                    });
                }
            });
        }
    }
    //飞入效果
    that.callFlyAnimation = function () {
        var offset = $("#RstProductInfo").offset();
        var flyer = $('<div class="fly-item fa fa-cube"></div>');
        flyer.fly({
            start: {
                left: event.pageX,
                top: event.pageY
            },
            end: {
                left: offset.left + 10,
                top: offset.top + 10,
                width: 0,
                height: 0
            },
            onEnd: function () {
                this.destory();
            }
        });
    }
    that.CloseLimWin = function () {
        $('#popoverModal').hide();
        $('#treeview span[aria-describedby^=\'popover\']').popover('hide');
        $('#treeview span[aria-describedby^=\'popover\']').popover('destroy');
    }

    var setLayout = function () {
    }

    return that;
}();