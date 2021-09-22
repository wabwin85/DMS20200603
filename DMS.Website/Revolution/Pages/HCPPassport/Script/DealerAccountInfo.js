var DealerAccountInfo = {};

DealerAccountInfo = function () {
    var that = {};

    var business = 'HCPPassport.DealerAccountInfo';
    var CustomerFaceNbr = [];

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};
        data.ID = Common.GetUrlParam('ID');

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                createRstOutFlowList(model.RstResultList)
                if (Common.GetUrlParam('ID') == '') {
                    $('#IptName').FrameTextBox({
                        value: model.IptName,

                    });

                    $('#IptPhone').FrameTextBox({
                        value: model.IptPhone,

                    });

                    $('#IptEmail').FrameTextBox({
                        value: model.IptEmail,

                    });

                    //$('#IptRoles').FrameMultiDropdownList({
                    //    dataSource: model.LstRoles,
                    //    value: model.IptRoles,
                    //    selectType: 'select',
                       
                    //});
                }
                else {

                    $('#IptName').FrameLabel({
                        value: model.IptName,
                        readonly: true,
                    });

                    $('#IptPhone').FrameLabel({
                        value: model.IptPhone,
                        readonly: true,
                    });

                    $('#IptEmail').FrameLabel({
                        value: model.IptEmail,
                        readonly: true,
                    });
                    $('#IptRoles').FrameMultiDropdownList({
                        dataSource: model.LstRoles,
                        value: model.IptRoles,
                        selectType: 'select',
                        readonly: true
                    });
                }
              

                $('#IptIsFlag').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.IptIsFlag,
                    readonly: model.IsAdmin
                });

                $('#BtnSave').FrameButton({
                    text: '保存',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
                    }
                });
                $('#BtnAddUpn').FrameButton({
                    text: '添加角色',
                    icon: 'search',
                    onClick: function () {
                        that.AddUpn();
                    }
                });

                $('#BtnClose').FrameButton({
                    text: '关闭',
                    icon: 'save',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });


                $(window).resize(function () {
                    setLayout();
                })
                setLayout();


                FrameWindow.HideLoading();
            }
        });
    }

    that.AddUpn = function () {
        //var data = FrameUtil.GetModel();

        url = Common.AppVirtualPath + 'Revolution/Pages/HCPPassport/DealerAccountPicker.aspx?' + 'InstanceId=';

        FrameWindow.OpenWindow({
            target: 'top',
            title: '添加角色',
            url: url,
            width: $(window).width() * 0.7,
            height: $(window).height() * 0.9,
            actions: ["Close"],
            callback: function (flowList) {
                if (flowList) {
                    var dataSource = $("#RstDetailList").data("kendoGrid").dataSource.data();

                    for (var i = 0; i < flowList.length; i++) {
                        var exists = false;
                        for (var j = 0; j < dataSource.length; j++) {
                            if (dataSource[j].Key == flowList[i].Key) {
                                exists = true;
                            }
                        }
                        if (!exists) {
                            $("#RstDetailList").data("kendoGrid").dataSource.add(flowList[i]);
                        }
                    }
                    $("#RstDetailList").data("kendoGrid").dataSource.fetch();

                }

            }
        });
    }


    that.Save = function () {
        var data = that.GetModel();

        data.ID = Common.GetUrlParam('ID');

        Roles = [];
        for (var i = 0; i < $("#RstDetailList").data("kendoGrid").dataSource._data.length; i++) {
            Roles[i] = $("#RstDetailList").data("kendoGrid").dataSource._data[i].Key

        }
        data.Roles = Roles;

        var message = that.CheckForm(data);
        if (message.length > 0 && Common.GetUrlParam('ID') == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        //else if (data.Roles.length==0) {
        
        //    FrameWindow.ShowAlert({
        //        target: 'top',
        //        alertType: 'warning',
        //        message: "请选择角色",
        //    });
        //}
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Save',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {

                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '保存成功',
                        callback: function () {
                            //that.Init();
                            //var url = Common.AppVirtualPath + 'Revolution/Pages/OBORESign/OBORESignInfo.aspx';
                            //url += '?ES_ID=' + model.ES_ID;
                            //window.location = url;
                            FrameWindow.CloseWindow({
                                target: 'top'
                            });
                        }
                    });

                    FrameWindow.HideLoading();
                }
            });
        }

        
    }

    that.CheckForm = function (data) {
        var message = [];
        if ($.trim(data.IptName) == "") {
            message.push('请填写用户姓名');
        }
        if ($.trim(data.IptPhone) == "") {
            message.push('请填写用户手机号');
        }
        if ($.trim(data.IptEmail) == "") {
            message.push('请填写用户邮箱');
        }

        return message;
    }

    var createRstOutFlowList = function (dataSource) {
        $("#RstDetailList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
            {
                field: "Value", title: "角色", width: '150px',
                headerAttributes: { "class": "text-center text-bold", "title": "角色" }
            },
             {
                 field: "Delete", title: "删除", width: '50px',
                 headerAttributes: { "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;" },
                 template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                 attributes: { "class": "text-center text-bold" },
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
                var rows = this.items();
                $(rows).each(function () {
                    var index = $(this).index() + 1;
                    var rowLabel = $(this).find(".Row-Number");
                    $(rowLabel).html(index);
                });

                $("#RstDetailList").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $("#RstDetailList").data("kendoGrid").dataSource.remove(data);
                    $("#RstDetailList").data("kendoGrid").dataSource.fetch();
                });

            }
        });
    }

    var setLayout = function () {
    }

    return that;
}();
