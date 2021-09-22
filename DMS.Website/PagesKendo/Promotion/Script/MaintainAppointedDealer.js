var MaintainAppointedDealer = {};

MaintainAppointedDealer = function () {
    var that = {};
    var LstPolicyDealerDesc = [];
    var isCanEdit;

    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;

        return model;
    }

    that.InitPage = function () {
        $('#IptPolicyId').val($.getUrlParam('PolicyId'));
        $('#IptProductLine').val($.getUrlParam('ProductLine'));
        $('#IptSubBu').val($.getUrlParam('SubBu'));
        $('#IptPageType').val($.getUrlParam('PageType'));
        $('#IptPromotionState').val($.getUrlParam('PromotionState'));

        var data = that.GetModel('InitPage');
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/MaintainAppointedDealerHanler.ashx", data, function (model) {
            $('#IptDealerCode').FrameTextArea({
                height: 100
            });
            $('#IptOperType').FrameDropdownList({
                dataSource: [{ Key: '包含', Value: '包含' }, { Key: '不包含', Value: '不包含' }],
                dataKey: 'Key',
                dataValue: 'Value'
            });

            createPolicyDealerList(model);

            $('#BtnSave').FrameButton({
                onClick: that.Save
            });
            $('#BtnClose').FrameButton({
                onClick: function () {
                    closeWindow({
                        target: 'parent'
                    });
                }
            });

            LstPolicyDealerDesc = model.LstPolicyDealerDesc;
            $('.CellInput').each(function (index) {
                if ($(this).data('type') == 'DropdownList' && $(this).hasClass("CellInputDropdownList")) {
                    var controlId = $(this).attr("id");
                    var pointFor = $(this).attr('for');
                    var group = $(this).attr('group');

                    $(this).on('click', function () {
                        var pointFor = $(this).attr('for');
                        var group = $(this).attr('group');

                        $('#Pnl' + group).find('.Pointer').addClass("PointerNone");
                        $('#Pnl' + group).find('.Pointer[for="' + pointFor + '"]').removeClass("PointerNone");

                        $('#IptDesc' + group).html('');
                        $.each(LstPolicyDealerDesc, function (i, n) {
                            if (n.Level2 == pointFor && n.Level3 == $('#' + controlId + '_Control').data("kendoDropDownList").value()) {
                                $('#IptDesc' + group).html(n.DescContent);
                            }
                        });
                    });

                    $('#' + controlId + '_Control').on('change', function () {
                        $('#Pnl' + group).find('.Pointer').addClass("PointerNone");
                        $('#Pnl' + group).find('.Pointer[for="' + pointFor + '"]').removeClass("PointerNone");

                        $('#IptDesc' + group).html('');
                        $.each(LstPolicyDealerDesc, function (i, n) {
                            if (n.Level2 == pointFor && n.Level3 == $('#' + controlId + '_Control').data("kendoDropDownList").value()) {
                                $('#IptDesc' + group).html(n.DescContent);
                            }
                        });
                    });
                } else {
                    $(this).on('click', function () {
                        var pointFor = $(this).attr('for');
                        var group = $(this).attr('group');

                        $('#Pnl' + group).find('.Pointer').addClass("PointerNone");
                        $('#Pnl' + group).find('.Pointer[for="' + pointFor + '"]').removeClass("PointerNone");

                        $('#IptDesc' + group).html('');
                        $.each(LstPolicyDealerDesc, function (i, n) {
                            if (n.Level2 == pointFor && n.Level3 == '') {
                                $('#IptDesc' + group).html(n.DescContent);
                            }
                        });
                    });
                }
            })

            $(window).resize(function () {
                setLayout();
            })
            setLayout();

            hideLoading();
        });
    }

    that.Save = function () {
        var data = that.GetModel('Save');

        var message = checkFormMain(data);
        if (message.length > 0) {
            showAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        } else {
            submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/MaintainAppointedDealerHanler.ashx", data, function (model) {
                var msg = '';
                msg += '成功录入经销商' + model.IptImportSuccess + '家<br />';
                if (model.IptImportFail != 0) {
                    msg += '未录入经销商' + model.IptImportFail + '家，错误信息如下：<br /><br />';
                    for (i = 0; i < model.RstImportFailList.length; i++) {
                        msg += model.RstImportFailList[i].SAPCode + '（' + model.RstImportFailList[i].ErrMsg + '）<br />';
                    }
                }

                showAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: msg
                });

                $("#RstPolicyDealer").data("kendoGrid").setOptions({
                    dataSource: model.RstPolicyDealer
                });

                hideLoading();
            });
        }
    }

    that.Remove = function (dealerId) {
        var data = that.GetModel('Remove');
        data.IptDealerId = dealerId;

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/MaintainAppointedDealerHanler.ashx", data, function (model) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: '删除成功',
                callback: function () {
                    $("#RstPolicyDealer").data("kendoGrid").setOptions({
                        dataSource: model.RstPolicyDealer
                    });
                }
            });

            hideLoading();
        });
    }

    var createPolicyDealerList = function (model) {
        $("#RstPolicyDealer").kendoGrid({
            dataSource: model.RstPolicyDealer,
            sortable: true,
            resizable: true,
            scrollable: true,
            height: 230,
            columns: [
                {
                    field: "DealerFullName", title: "经销商名称",
                    headerAttributes: { "class": "center bold", "title": "经销商名称" }
                },
                {
                    field: "OperType", title: "类型", width: '150px',
                    headerAttributes: { "class": "center bold", "title": "类型" }
                },
                {
                    title: "删除", width: "50px",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    template: "<i class='fa fa-remove' style='font-size: 14px; cursor: pointer;' name='remove'></i>",
                    attributes: {
                        "class": "center"
                    }
                }
            ],
            dataBound: function (e) {
                var grid = e.sender;

                $("i[name='remove']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    showConfirm({
                        target: 'top',
                        message: '确定删除经销商吗？',
                        confirmCallback: function () {
                            that.Remove(data.DEALERID);
                        }
                    });
                });
            }
        });
    }

    var setReadonly = function () {
    }

    var checkFormMain = function (data) {
        var message = [];

        if (data.IptDealerCode == '') {
            message.push('请填写经销商Code');
        }
        if (data.IptOperType == '') {
            message.push('请选择类型');
        }

        return message;
    }

    var initColumnLayout = function () {
    }

    var setLayout = function () {
        var h = $('.content-main').height();
    }

    return that;
}();
