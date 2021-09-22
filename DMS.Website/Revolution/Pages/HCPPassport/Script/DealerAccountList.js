var DealerAccountList = {};

DealerAccountList = function () {
    var that = {};

    var business = 'HCPPassport.DealerAccountList';

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

                $('#QryName').FrameTextBox({
                    value: model.QryName
                });

                $('#QryPhone').FrameTextBox({
                    value: model.QryPhone
                });

                $('#QryEmail').FrameTextBox({
                    value: model.QryEmail
                });
                

                $('#BtnNew').FrameButton({
                    text: '新增',
                    icon: 'file',
                    onClick: function () {
                        NewopenInfo('');
                    }
                });


                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

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
        var data = FrameUtil.GetModel();
        //console.log(data);

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Query',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstResultList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });

                FrameWindow.HideLoading();
            }
        });
    }

    var createResultList = function () {
        $("#RstResultList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 500,
            columns: [
                {
                    title: "查看", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                 {
                     title: "密码重置", width: "50px",
                     headerAttributes: {
                         "class": "text-center text-bold"
                     },
                     template: "#if ($('\\#CST_NO').val() != '') {#<i class='fa fa-unlock-alt' style='font-size: 14px; cursor: pointer;' name='resetPWD'></i>#}#",
                     attributes: {
                         "class": "text-center text-bold"
                     }
                 },
                {
                    field: "IDENTITY_CODE", title: "账户编号", width: '140px',
                    headerAttributes: { "class": "text-center text-bold", "title": "账户编号" }
                },
                {
                    field: "IDENTITY_NAME", title: "用户姓名", width: '140px',
                    headerAttributes: { "class": "text-center text-bold", "title": "用户姓名" }
                },
                {
                    field: "PHONE", title: "用户手机号", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "用户手机号" }
                },
                {
                    field: "EMAIL1", title: "用户邮箱", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "用户邮箱" }
                },
                {
                    field: "FLAG", title: "是否有效", width: '90px',
                    headerAttributes: { "class": "text-center text-bold", "title": "是否有效" }
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

                $("#RstResultList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    NewopenInfo(data.Id);
                });
                $("#RstResultList").find("i[name='resetPWD']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    ResetPWD(data.Id);
                });
                
            }
        });
    }



    var NewopenInfo = function (ID) {


        url = Common.AppVirtualPath + 'Revolution/Pages/HCPPassport/DealerAccountInfo.aspx?ID=' + ID;

        FrameWindow.OpenWindow({
            target: 'top',
            title: '账号维护',
            url: url,
            width: $(window).width() * 0.6,
            height: $(window).height() * 0.8,
            actions: ["Close"],
            callback: function (flowList) {
                var data = {};
               
                FrameWindow.ShowLoading();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'Query',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        $("#RstResultList").data("kendoGrid").setOptions({
                            dataSource: model.RstResultList
                        });
                        
                        FrameWindow.HideLoading();
                    }
                });

            }
        });
    }

    var ResetPWD = function (ID) {


        url = Common.AppVirtualPath + 'Revolution/Pages/HCPPassport/DealerAccountResetPWD.aspx?ID=' + ID;

        FrameWindow.OpenWindow({
            target: 'top',
            title: '密码重置',
            url: url,
            width: $(window).width() * 0.4,
            height: $(window).height() * 0.5,
            actions: ["Close"],
            callback: function (flowList) {
                var data = {};

                FrameWindow.ShowLoading();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'Query',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        //$("#RstResultList").data("kendoGrid").setOptions({
                        //    dataSource: model.RstResultList
                        //});

                        FrameWindow.HideLoading();
                    }
                });

            }
        });
    }


    var setLayout = function () {
    }

    return that;
}();
