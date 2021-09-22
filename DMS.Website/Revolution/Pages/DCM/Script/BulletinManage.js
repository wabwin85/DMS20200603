var BulletinManage = {};

BulletinManage = function () {
    var that = {};

    var business = 'DCM.BulletinManage';

    var LstUrgentDegreeArr;
    var LstStatusArr;

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
                //发布时间
                $('#QryPublishedDate').FrameDatePickerRange({
                    value: model.QryPublishedDate
                });
                //有效期
                $('#QryExpirationDate').FrameDatePickerRange({
                    value: model.QryExpirationDate
                });
                //标题
                $('#QryTitle').FrameTextBox({
                    value: model.QryTitle
                });
                //发布人
                $('#QryPublishedUser').FrameTextBox({
                    value: model.QryPublishedUser
                });
                //重要性
                $('#QryUrgentDegree').FrameDropdownList({
                    dataSource: model.LstUrgentDegree,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryUrgentDegree
                });
                LstUrgentDegreeArr = model.LstUrgentDegree;
                //状态
                $('#QryStatus').FrameDropdownList({
                    dataSource: model.LstStatus,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryStatus
                });
                LstStatusArr = model.LstStatus;
                
                if (model.ShowSearch)
                {
                    $('#BtnQuery').FrameButton({
                        text: '查询',
                        icon: 'search',
                        onClick: function () {
                            that.Query();
                        }
                    });
                }

                if (!model.IsDealer && model.ShowImport)
                {
                    $('#BtnImport').FrameButton({
                        text: '新增',
                        icon: 'plus',
                        onClick: function () {
                            that.OpenDetailWin('00000000-0000-0000-0000-000000000000');
                        }
                    });
                }

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

    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    //var fields = {
    //    TimeDate: { type: "date", format: "{0:yyyy-MM-dd HH:mm:ss}" }
    //};
    var kendoDataSource = GetKendoDataSource(business, 'Query', null, 15);

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    field: "Title", title: "标题", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "标题" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "IdentityName", title: "创建人", width: 150, 
                    headerAttributes: { "class": "text-center text-bold", "title": "创建人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Status", title: "状态", width: 120, template: function (gridRow) {
                        var status = "";
                        if (LstStatusArr.length > 0) {
                            if (gridRow.Status != "") {
                                $.each(LstStatusArr, function () {
                                    if (this.Key == gridRow.Status) {
                                        status = this.Value;
                                        return false;
                                    }
                                })
                            }
                        }
                        return status;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PublishedDate", title: "发布时间", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "发布时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ExpirationDate", title: "有效期", width: 150,
                    template: "#if(ExpirationDate=='9999-12-31'){#永久#}else{##=ExpirationDate##}#",
                    headerAttributes: { "class": "text-center text-bold", "title": "有效期" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UrgentDegree", title: "紧急程度", width: 80, template: function (gridRow) {
                        var degree = "";
                        if (LstUrgentDegreeArr.length > 0) {
                            if (gridRow.UrgentDegree != "") {
                                $.each(LstUrgentDegreeArr, function () {
                                    if (this.Key == gridRow.UrgentDegree) {
                                        degree = this.Value;
                                        return false;
                                    }
                                })
                            }
                        }
                        return degree;
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "紧急程度" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ReadFlag", title: "是否必须确认", width: 50,
                    headerAttributes: { "class": "text-center text-bold", "title": "是否必须确认" },
                    template: "#if(ReadFlag){#<i class='fa fa-check-square-o' style='font-size: 14px; cursor: pointer;'></i>#}else{#<i class='fa fa-square-o' style='font-size: 14px; cursor: pointer;'></i>#}#",
                    attributes: { "class": "text-center table-td-cell" }
                },
                {
                    title: "明细", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
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

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    that.OpenDetailWin(data.Id);
                });

            }
        });
    }

    //新增明细
    that.OpenDetailWin = function (BulletId) {
        if (BulletId != '00000000-0000-0000-0000-000000000000') {
            top.createTab({
                id: 'M_' + BulletId,
                title: '明细',
                url: 'Revolution/Pages/DCM/BulletinManageInfo.aspx?BulletId=' + BulletId
            });
        } else {
            top.createTab({
                id: 'M_Bulletin_New',
                title: '明细',
                url: 'Revolution/Pages/DCM/BulletinManageInfo.aspx?BulletId=' + BulletId
            });
        }
    }

    var setLayout = function () {
    }

    return that;
}();
