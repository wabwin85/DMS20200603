var PolicyTemplateList = {};

PolicyTemplateList = function () {
    var that = {};
    var LstPolicyTypeDesc = [];
    var addType = 'template';

    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;

        return model;
    }

    that.InitPage = function () {
        var data = that.GetModel('InitPage');

        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateListHanler.ashx", data, function (model) {
            $('#IptUserId').val(model.IptUserId)
            //政策名称
            $('#QryPolicyName').FrameTextBox({});
            //产品线
            $('#QryProductLine').FrameDropdownList({
                dataSource: model.LstProductLine,
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'all'
            });
            //促销类型
            $('#QryPromotionType').FrameDropdownList({
                dataSource: [{ Key: '赠品', Value: '赠品类（按时间段结算）' }, { Key: '积分', Value: '积分类（按时间段结算）' }, { Key: '即买即赠', Value: '即买即赠（按单张订单计算）' }],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'all'
            });

            createPolicyList(model);

            $('#BtnQuery').FrameButton({
                onClick: function () {
                    that.Query();
                }
            });

            //新增促销政策
            $('#BtnNew').FrameButton({
                onClick: function () {
                    $('.in').removeClass('in');
                    $(".ClassItem").removeClass('SelectItem');
                    $('#IptPolicyStyle').val('');
                    $('#IptPolicyStyleSub').val('');
                    $('#IptDesc').html('');
                    $('#PnlPolicyTypeWindow').data("kendoWindow").center().open();
                }
            });
            $('#BtnAdd').FrameButton({
                onClick: function () {
                    if ($('#IptPolicyStyleSub').val() == '') {
                        showAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: '请选择政策类型！'
                        });
                    } else {
                        $('#PnlPolicyTypeWindow').data("kendoWindow").center().close();
                        OpenPolicy('', $('#IptPolicyStyle').val(), $('#IptPolicyStyleSub').val(), '促销政策模板 - ' + '新增');
                    }
                }
            });
            $('#BtnClose').FrameButton({
                onClick: function () {
                    $('#PnlPolicyTypeWindow').data("kendoWindow").center().close();
                }
            });

            //政策类型选择
            $('#PnlPolicyTypeWindow').kendoWindow({
                width: 800,
                height: 450,
                modal: true,
                visible: false,
                resizable: false,
                title: '添加政策模板',
                actions: [
                    "Close"
                ]
            });

            //选择新增方式
            $("#PnlPolicyType").kendoTabStrip({
                animation: {
                    open: {
                        effects: "fadeIn"
                    }
                }
            });

            LstPolicyTypeDesc = model.LstPolicyTypeDesc;
            $(".ClassItem").on('click', function () {
                $(".ClassItem").removeClass('SelectItem');
                $(this).addClass('SelectItem');
                //赠送大类
                $('#IptPolicyStyle').val($(this).data('policyStyle'));
                //赠送小类
                $('#IptPolicyStyleSub').val($(this).data('policyStyleSub'));
                $('#IptDesc').html('');
                $.each(LstPolicyTypeDesc, function (i, n) {
                    if (n.Level2 == $('#IptPolicyStyle').val() && n.Level3 == $('#IptPolicyStyleSub').val()) {
                        $('#IptDesc').html(n.DescContent);
                    }
                });
            });

            $(window).resize(function () {
                setLayout();
            })
            setLayout();

            hideLoading();
        });
    }

    that.Query = function () {
        var data = this.GetModel('Query');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateListHanler.ashx", data, function (model) {
            $("#RstPolicyList").data("kendoGrid").setOptions({
                dataSource: model.RstPolicyList
            });

            hideLoading();
        });
    }

    that.RemovePolicy = function (policyId) {
        var data = this.GetModel('RemovePolicy');
        data.IptPolicyId = policyId;

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateListHanler.ashx", data, function (model) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: '删除成功',
                callback: function () {
                    $("#RstPolicyList").data("kendoGrid").setOptions({
                        dataSource: model.RstPolicyList
                    });
                }
            });

            hideLoading();
        });
    }

    that.CopyPolicy = function (policyId) {
        var data = this.GetModel('CopyPolicy');
        data.IptPolicyId = policyId;

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateListHanler.ashx", data, function (model) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: '复制成功',
                callback: function () {
                    $("#RstPolicyList").data("kendoGrid").setOptions({
                        dataSource: model.RstPolicyList
                    });
                }
            });

            hideLoading();
        });
    }

    var createPolicyList = function (model) {
        $("#RstPolicyList").kendoGrid({
            dataSource: model.RstPolicyList,
            sortable: true,
            resizable: true,
            scrollable: true,
            columns: [
                {
                    field: "PolicyName", title: "模板名称",
                    headerAttributes: { "class": "center bold", "title": "模板名称" }
                },
                {
                    field: "BU", title: "产品线", width: '100px',
                    headerAttributes: { "class": "center bold", "title": "产品线" }
                },
                {
                    field: "PolicyStyle", title: "政策类型", width: '100px',
                    headerAttributes: { "class": "center bold", "title": "政策类型" }
                },
                {
                    title: "编辑", width: "50px",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    template: "#if ($('\\#IptUserId').val() == data.UserId || $('\\#IptUserId').val() == 'c763e69b-616f-4246-8480-9df40126057c') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "center"
                    }
                },
                {
                    title: "删除", width: "50px",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    template: "#if ($('\\#IptUserId').val() == data.UserId) {#<i class='fa fa-remove' style='font-size: 14px; cursor: pointer;' name='remove'></i>#}#",
                    attributes: {
                        "class": "center"
                    }
                },
                {
                    title: "复制", width: "50px",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    template: "<i class='fa fa-copy' style='font-size: 14px; cursor: pointer;' name='copy'></i>",
                    attributes: {
                        "class": "center"
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
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstPolicyList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    OpenPolicy(data.PolicyId, '', '', '促销政策模板 - ' + data.PolicyName);
                });

                $("#RstPolicyList").find("i[name='remove']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    showConfirm({
                        target: 'top',
                        message: '确定删除该促销政策模板吗？',
                        confirmCallback: function () {
                            that.RemovePolicy(data.PolicyId);
                        }
                    });
                });

                $("#RstPolicyList").find("i[name='copy']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    showConfirm({
                        target: 'top',
                        message: '确定复制该促销政策模板吗？',
                        confirmCallback: function () {
                            that.CopyPolicy(data.PolicyId);
                        }
                    });
                });
            }
        });
    }

    var OpenPolicy = function (policyId, policyStyle, policyStyleSub, title) {
        openWindow({
            target: 'top',
            title: title,
            url: Common.AppVirtualPath + 'PagesKendo/Promotion/PolicyTemplateInfo.aspx?PolicyId=' + policyId + '&PageType=Modify&PolicyStyle=' + escape(policyStyle) + '&PolicyStyleSub=' + escape(policyStyleSub) + '&IsTemplate=true',
            width: 1300,
            height: 600,
            maxed: true,
            callback: function () {
                that.Query();
            }
        });
    }

    var setLayout = function () {
        var h = $('.content-main').height();

        $("#RstPolicyList").data("kendoGrid").setOptions({
            height: h - 160
        });
    }

    return that;
}();
