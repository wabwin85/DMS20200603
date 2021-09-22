var ConsignUpnPicker = {};

ConsignUpnPicker = function () {
    var that = {};

    var business = 'Consign.ConsignUpnPicker';
    var pickedList = { UpnList: [], SetList: [] };

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
      
        $('#QryBu').val(Common.GetUrlParam('Bu'));
        $('#QryDealer').val(Common.GetUrlParam('Dealer'));
      

        $('#QryQueryType').FrameRadio({
            dataSource: [{ Key: 'upn', Value: 'UPN' }, { Key: 'set', Value: '组套' }],
            dataKey: 'Key',
            dataValue: 'Value',
            value: { Key: 'upn', Value: 'UPN' }
        });
        $('#QryFilter').FrameTextBox({
        });

        that.CreateResultList();
        
        $('#BtnOk').FrameButton({
            text: '确定',
            icon: 'file',
            onClick: function () {
                FrameWindow.SetWindowReturnValue({
                    target: 'top',
                    value: pickedList
                });

                FrameWindow.CloseWindow({
                    target: 'top'
                });
            }
        });
        $('#BtnClose').FrameButton({
            text: '关闭',
            icon: 'remove',
            onClick: function () {
                FrameWindow.CloseWindow({
                    target: 'top'
                });
            }
        });
        $('#BtnQuery').FrameButton({
            text: '查询',
            icon: 'search',
            onClick: function () {
                that.Query();
            }
        });

        $(window).resize(function () {
            setLayout();
        })
        setLayout();

        FrameWindow.HideLoading();
    }

    that.Query = function () {
        var data = FrameUtil.GetModel();
        data.QryBu = Common.GetUrlParam('Bu')
        data.QryDealer = Common.GetUrlParam('Dealer')
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Query',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.QryQueryType.Key == "upn") {
                    $("#RstResultList").data("kendoGrid").setOptions({
                        dataSource: model.RstResultList
                    });
                    $("#RstResultListSet").css("display", "none")
                    $("#RstResultList").css("display", "block")
                }
                else {
                    that.CreateResultListSet();
                    $("#RstResultListSet").data("kendoGrid").setOptions({
                        dataSource: model.RstResultListSet
                    });
                    $("#RstResultList").css("display", "none")
                    $("#RstResultListSet").css("display", "block")
                }
               

                FrameWindow.HideLoading();
            }
        });
    }

    //大区维护
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Area', data.QryArea);
        urlExport = Common.UpdateUrlParams(urlExport, 'IsActive', data.QryIsActive);

        startDownload({
            url: urlExport,
            cookie: 'AreaListExport',
            business: business
        });
    }

    //UPN
    that.CreateResultList = function (dataSource) {
        
        $("#RstResultList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                 {
                     title: "全选", width: '50px', encoded: false,
                     headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                     template: '<input type="checkbox" id="Check_#=CFN_Property1#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=CFN_Property1#"></label>',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                //{
                //    field: "CFN_CustomerFaceNbr", title: "产品UPN", width: '150px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "产品UPN" },
                //},
                {
                    field: "CFN_Property1", title: "产品短编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品短编号" }
                },
                //{
                //    field: "CFN_ChineseName", title: "中文名", width: '120px',
                //    headerAttributes: { "class": "text-center text-bold", "title": "中文名" }
                //},
                {
                    field: "PMA_ConvertFactor", title: "规格", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "规格" }
                },
                {
                    field: "CFN_Property3", title: "单位", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" }
                },
                {
                    field: "Type", title: "类型", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "类型" }
                }
                
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

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
                $('#CheckAll').removeAttr("checked");
            }
        });
    }
    //组套
    that.CreateResultListSet = function (dataSource) {
        $("#RstResultListSet").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    title: "全选", width: '50px', encoded: false,
                    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=CFNS_ID#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=CFNS_ID#"></label>',
                    headerAttributes: { "class": "text-center text-bold", "title": "全选", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "CFNS_ChineseName", title: "产品中文名", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" }
                },
                {
                    field: "CFNS_EnglishName", title: "产品英文名", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" }
                },
                {
                    field: "Unit", title: "单位", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "单位" }
                },
                {
                    field: "Type", title: "类型", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "类型" }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstResultListSet").find(".Check-Item").unbind("click");
                $("#RstResultListSet").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstResultListSet").data("kendoGrid"),
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
                        var grid = $("#RstResultListSet").data("kendoGrid");
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
                $('#CheckAll').removeAttr("checked");
            }
        });
    }


    var addItem = function (data) {
        if (!isExists(data)) {
            if (data.Type == 'UPN') {
                pickedList.UpnList.push(data.CFN_Property1);
            } else {
                pickedList.SetList.push(data.CFNS_ID);
            }
        }
    }

    var removeItem = function (data) {
        if (data.Type == 'UPN') {
            for (var i = 0; i < pickedList.UpnList.length; i++) {
                if (pickedList.UpnList[i] == data.CFN_Property1) {
                    pickedList.UpnList.splice(i, 1);
                    break;
                }
            }
        } else {
            for (var i = 0; i < pickedList.SetList.length; i++) {
                if (pickedList.SetList[i] == data.CFNS_ID) {
                    pickedList.SetList.splice(i, 1);
                    break;
                }
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        if (data.Type == 'UPN') {
            for (var i = 0; i < pickedList.UpnList.length; i++) {
                if (pickedList.UpnList[i] == data.CFN_Property1) {
                    exists = true;
                }
            }
        } else {
            for (var i = 0; i < pickedList.SetList.length; i++) {
                if (pickedList.SetList[i] == data.CFNS_ID) {
                    exists = true;
                }
            }
        }
        return exists;
    }



    var setLayout = function () {
    }

    return that;
}();
