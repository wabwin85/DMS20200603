var PolicyList = {};

PolicyList = function () {
    var that = {};
    var LstPolicyTypeDesc = [];
    var policyMode = '';
    var templateId = '';

    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;

        return model;
    }

    that.InitPage = function () {
        /*data的值
        
        Method:"InitPage"
        QryPolicyName: null
        QryPolicyNo:null
        QryPolicyStatus:null
        QryProductLine:null
        QryPromotionType:null
        QryTimeStatus:null
        QryYear:null

        */
        var data = that.GetModel('InitPage');

        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyListHanler.ashx", data, function (model) {
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
            //状态
            $('#QryPolicyStatus').FrameDropdownList({
                dataSource: model.LstPolicyStatus,
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'all'
            });
            //政策编号
            $('#QryPolicyNo').FrameTextBox({});
            //时效状态
            $('#QryTimeStatus').FrameDropdownList({
                dataSource: model.LstTimeStatus,
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'all'
            });
            //年份
            $('#QryYear').FrameTextBox({});
            //促销类型
            $('#QryPromotionType').FrameDropdownList({
                dataSource: [{ Key: '赠品', Value: '赠品类（按时间段结算）' }, { Key: '积分', Value: '积分类（按时间段结算）' }, { Key: '即买即赠', Value: '即买即赠（按单张订单计算）' }],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'all'
            });

            createPolicyList(model);

            $('#IptProductLine').FrameDropdownList({
                dataSource: model.LstProductLine,
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'select',
                onChange: that.ChangeProductLine
            });
            $('#PnlByTemplate').on('click', function () {
                policyMode = "Template";
            });
            $('#PnlByAdvance').on('click', function () {
                policyMode = "Advance";
            });

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

                    $('#IptProductLine').FrameDropdownList('setValue', '');
                    templateId = '';
                    $('#IptTemplateDesc').html('');
                    $('#RstTemplateList').empty();

                    $('#PnlByTemplate').click();
                    $('#PnlPolicyTypeWindow').data("kendoWindow").center().open();
                }
            });
            $('#BtnAdd').FrameButton({
                onClick: function () {
                    if (policyMode == 'Template') {
                        if (templateId == '') {
                            showAlert({
                                target: 'top',
                                alertType: 'warning',
                                message: '请选择模板政策！'
                            });
                        } else {
                            $('#PnlPolicyTypeWindow').data("kendoWindow").center().close();
                            OpenPolicyTemplateInit(templateId, 'Modify', '新增模板政策信息', 'false');
                        }
                    } else {
                        if ($('#IptPolicyStyleSub').val() == '') {
                            showAlert({
                                target: 'top',
                                alertType: 'warning',
                                message: '请选择政策类型！'
                            });
                        } else {
                            $('#PnlPolicyTypeWindow').data("kendoWindow").center().close();
                            OpenPolicy('', 'Modify', $('#IptPolicyStyle').val(), $('#IptPolicyStyleSub').val(), '新增政策信息', 'false', 'false');
                        }
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
                title: '添加政策',
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
                $('#IptPolicyStyle').val($(this).attr('PolicyStyle'));
                //赠送小类
                $('#IptPolicyStyleSub').val($(this).attr('PolicyStyleSub'));

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
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyListHanler.ashx", data, function (model) {
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
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyListHanler.ashx", data, function (model) {
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
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyListHanler.ashx", data, function (model) {
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

    that.ChangeProductLine = function () {
        var data = that.GetModel('ChangeProductLine');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyListHanler.ashx", data, function (model) {
            templateId = '';
            $('#IptTemplateDesc').html('');

            $('#RstTemplateList').empty();

            $.each(model.RstTemplateList, function (i, n) {
                var e = document.createElement("li");
                e.style.cssText = 'list-style: none;';
                e.className = 'ClassTemplateItem';
                e.textContent = n.PolicyName;
                e.dataset.policyId = n.PolicyId;
                e.dataset.description = n.Description;

                $('#RstTemplateList').append(e);
            });

            $(".ClassTemplateItem").on('click', function () {
                $(".ClassTemplateItem").removeClass('SelectItem');
                $(this).addClass('SelectItem');

                templateId = $(this).data('policyId');
                $('#IptTemplateDesc').html($.replaceAll($(this).data('description'), '\n', '<br />'));
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
                    field: "PolicyNo", title: "政策编号", width: '150px',
                    headerAttributes: { "class": "center bold", "title": "政策编号" }
                },
                {
                    field: "PolicyName", title: "政策名称",
                    headerAttributes: { "class": "center bold", "title": "政策名称" }
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
                    field: "StartDate", title: "开始时间", width: '100px',
                    headerAttributes: { "class": "center bold", "title": "开始时间" }
                },
                {
                    field: "EndDate", title: "结束时间", width: '100px',
                    headerAttributes: { "class": "center bold", "title": "结束时间" }
                },
                {
                    field: "Status", title: "状态", width: '80px',
                    headerAttributes: { "class": "center bold", "title": "状态" }
                },
                {
                    field: "TimeStatus", title: "时效状态", width: '80px',
                    headerAttributes: { "class": "center bold", "title": "时效状态" }
                },
                {
                    field: "CalPeriod", title: "已结算", width: '80px',
                    headerAttributes: { "class": "center bold", "title": "已结算" }
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
                    template: "#if ($('\\#IptUserId').val() == data.UserId && data.canDelete) {#<i class='fa fa-remove' style='font-size: 14px; cursor: pointer;' name='remove'></i>#}#",
                    attributes: {
                        "class": "center"
                    }
                },
                {
                    title: "查看", width: "50px",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    template: "#if (data.canView) {#<i class='fa fa-file-text-o' style='font-size: 14px; cursor: pointer;' name='view'></i>#}#",
                    attributes: {
                        "class": "center"
                    }
                },
                {
                    title: "预览", width: "50px",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    template: "<i class='fa fa-file-code-o' style='font-size: 14px; cursor: pointer;' name='preview'></i>",
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
                },
                {
                    title: "查看审批", width: "70px",
                    headerAttributes: {
                        "class": "center bold"
                    },
                    template: " #if(data.remark=='1'){#<i class='fa fa-file-text-o' style='font-size: 14px; cursor: pointer;' name='ViewApproval'></i>#}#",
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

                    if (data.PolicyMode == 'Advance') {
                        OpenPolicy(data.PolicyId, 'Modify', '', '', data.PolicyName, 'false', 'false');
                    } else {
                        OpenPolicyTemplate(data.PolicyId, 'Modify', data.PolicyName, 'false');
                    }
                });

                $("#RstPolicyList").find("i[name='remove']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    showConfirm({
                        target: 'top',
                        message: '确定删除该促销政策吗？',
                        confirmCallback: function () {
                            that.RemovePolicy(data.PolicyId);
                        }
                    });
                });
                //查看审批节点
                $("#RstPolicyList").find("i[name='ViewApproval']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    var InstanceID = data.InstanceID;
                    var processId = data.processId;

                    var url = '../../../Pages/EkpControl.aspx?formInstanceId=' + InstanceID + '&processId=' + processId + '&dmsview=ekp';
                    top.createTab('FLOW_' + data.PolicyId, data.PolicyName + ' - 审批流', url);
                    //window.open('../../../Pages/EkpControl.aspx?sysId=DMS&modelId=PromotionPolicy&templateFormId=PromotionPolicyTemplate&formInstanceId=' + InstanceID + '&processId=' + processId)
                });

                $("#RstPolicyList").find("i[name='view']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    if (data.PolicyMode == 'Advance') {
                        OpenPolicy(data.PolicyId, 'View', '', '', data.PolicyName, 'false', 'false');
                    } else {
                        OpenPolicyTemplate(data.PolicyId, 'View', data.PolicyName, 'false');
                    }
                });

                $("#RstPolicyList").find("i[name='preview']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    if (data.PolicyMode == 'Advance') {
                        OpenPolicy(data.PolicyId, 'View', '', '', data.PolicyName, 'true', 'false');
                    } else {
                        OpenPolicyTemplate(data.PolicyId, 'View', data.PolicyName, 'true');
                    }
                });

                $("#RstPolicyList").find("i[name='copy']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    showConfirm({
                        target: 'top',
                        message: '确定复制该合同吗？',
                        confirmCallback: function () {
                            that.CopyPolicy(data.PolicyId);
                        }
                    });
                });
            }
        });
    }

    var OpenPolicy = function (policyId, pageType, policyStyle, policyStyleSub, title, showPreview, isTemplate) {
        openWindow({
            target: 'top',
            title: title,
            url: Common.AppVirtualPath + 'PagesKendo/Promotion/PolicyInfo.aspx?PolicyId=' + policyId + '&PageType=' + pageType + '&PolicyStyle=' + escape(policyStyle) + '&PolicyStyleSub=' + escape(policyStyleSub) + '&ShowPreview=' + escape(showPreview) + '&IsTemplate=' + escape(isTemplate),
            width: 1300,
            height: 600,
            maxed: true,
            callback: function () {
                that.Query();
            }
        });
    }

    var OpenPolicyTemplateInit = function (templateId, pageType, title, showPreview) {
        openWindow({
            target: 'top',
            title: title,
            url: Common.AppVirtualPath + 'PagesKendo/Promotion/PolicyTemplateInit.aspx?TemplateId=' + templateId + '&PageType=' + pageType + '&ShowPreview=' + escape(showPreview),
            width: 1300,
            height: 600,
            maxed: true,
            callback: function () {
                that.Query();
            }
        });
    }

    var OpenPolicyTemplate = function (policyId, pageType, title, showPreview) {
        openWindow({
            target: 'top',
            title: title,
            url: Common.AppVirtualPath + 'PagesKendo/Promotion/PolicyTemplate.aspx?PolicyId=' + policyId + '&PageType=' + pageType + '&ShowPreview=' + escape(showPreview),
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
            height: h - 220
        });
    }

    return that;
}();
