var PolicyTemplate = {};

PolicyTemplate = function () {
    var that = {};
    var LstPolicyGeneralDesc = [];
    var target = '';
    var policyFactorId = 3;
    var policyRuleId = 3;
    var isCanEdit;

    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;

        return model;
    }

    that.InitPage = function () {
        $('#IptPolicyId').val($.getUrlParam('PolicyId'));
        $('#IptPageType').val($.getUrlParam('PageType'));

        var showPreview = $.getUrlParam('ShowPreview');

        var data = that.GetModel('InitPage');
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
            //Basic
            //政策ID
            $('#IptPolicyId').val(model.IptPolicyId);
            //政策状态
            $('#IptPromotionState').val(model.IptPromotionState);
            //促销类型
            $('#IptPolicyStyle').val(model.IptPolicyStyle);
            $('#IptPolicyStyleSub').val(model.IptPolicyStyleSub);
            //产品线
            $('#IptProductLine').val(model.IptProductLine);
            //政策编号
            $('#IptPolicyNo').FrameLabel({
                value: model.IptPolicyNo
            });
            //政策名称
            $('#IptPolicyName').FrameTextBox({
                value: model.IptPolicyName
            });
            //分组名称
            $('#IptPolicyGroupName').FrameTextBox({
                value: model.IptPolicyGroupName
            });
            //开始时间
            $('#IptBeginDate').FrameDatePicker({
                depth: "year",
                start: "year",
                format: "yyyy-MM",
                value: model.IptBeginDate
            });
            //终止时间
            $('#IptEndDate').FrameDatePicker({
                depth: "year",
                start: "year",
                format: "yyyy-MM",
                value: model.IptEndDate
            });
            //经销商结算周期
            $('#IptPeriod').FrameDropdownList({
                dataSource: [{ Key: '季度', Value: '季度' }, { Key: '年度', Value: '年度' }, { Key: '月度', Value: '月度' }],
                dataKey: 'Key',
                dataValue: 'Value',
                value: model.IptPeriod
            });
            //计入返利与达成
            $('#IptAcquisition').FrameSwitch({
                value: model.IptAcquisition
            });
            //经销商积分效期
            $('#IptPointValidDateType').FrameDropdownList({
                dataSource: [{ Key: 'Year', Value: '当年有效' }, { Key: 'HalfYear', Value: '半年有效' }, { Key: 'Quarter', Value: '结算周期的次季度有效' }],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'select',
                value: model.IptPointValidDateType
            });

            //Dealer
            //结算对象
            $('#IptProTo').FrameDropdownList({
                dataSource: [{ Key: 'ByDealer', Value: '经销商' }, { Key: 'ByHospital', Value: '医院' }],
                dataKey: 'Key',
                dataValue: 'Value',
                value: model.IptProTo,
                onChange: that.ChangeProTo
            });
            //指定类型
            $('#IptProToType').FrameDropdownList({
                dataSource: [{ Key: 'ByDealer', Value: '指定经销商' }, { Key: 'ByAuth', Value: '所有代理商' }],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'select',
                value: model.IptProToType,
                onChange: that.ChangeProToType
            });

            that.ChangeProToType();

            isCanEdit = model.IsCanEdit;

            var PolicyStyleSubCode = getPolicyStyleSubCode(model.IptPolicyStyleSub);
            //显示新增政策是哪一个，显示新增政策的政策编号，如：CXZP为新增赠品
            $('.' + PolicyStyleSubCode).show();

            createFactorList(model.RstFactorList);
            createRuleList(model.RstRuleList);
            createAttachmentList(model.RstAttachmentList);

            $('#PnlSummary').html(model.IptPolicySummary);
            that.SetEditEvent();

            //无修改面板
            $('#PnlSummary').height($('.content-main').height() - 60);

            //指定经销商维护
            $('#BtnProToType').FrameButton({
                onClick: openAppointedDealer
            });
            $('#BtnAddFactor').FrameButton({
                onClick: function () {
                    openFactor('true', '');
                }
            });
            $('#BtnAddRule').FrameButton({
                onClick: function () {
                    openRule('true', '');
                }
            });
            $('#BtnAddAttachment').FrameButton({
                onClick: function () {
                    $('#BtnOpenAttachment').click();
                }
            });
            $('#BtnOpenAttachment').kendoUpload({
                async: {
                    saveUrl: Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyAttachment.ashx?ForeignType=Promotion&ActionType=SecondRate&PolicyId=" + $('#IptPolicyId').val(),
                    autoUpload: true
                },
                select: function (e) {
                    showLoading();
                },
                multiple: false,
                success: that.ReloadAttachment
            });

            $('#BtnAdvance').FrameButton({
                onClick: function () {
                    that.ConvertAdvance();
                }
            });
            $('#BtnPreview').FrameButton({
                onClick: function () {
                    that.Preview();
                }
            });
            $('#BtnSave').FrameButton({
                onClick: function () {
                    that.Save();
                }
            });
            $('#BtnReturn').FrameButton({
                onClick: function () {
                    $('.policyButton').hide();
                    $('.policySummary').show();

                    //无修改面板
                    var h = $('.content-main').height() - 60;
                    $('#PnlSummary').animate({
                        height: h + 'px'
                    }, 1000);

                    $('#Pnl' + target).slideUp(1000);

                    target = '';

                    setLayout();
                }
            });
            $('#BtnSubmit').FrameButton({
                onClick: function () {
                    that.Submit();
                }
            });
            $('#BtnBack').FrameButton({
                onClick: function () {
                    $('#PnlPreview').fadeOut(500, function () {
                        $('#PnlEdit').fadeIn(500);
                    })

                    $('.policyButton').hide();
                    $('.policySummary').show();
                }
            });
            $('#BtnClose').FrameButton({
                onClick: function () {
                    closeWindow({
                        target: 'top'
                    });
                }
            });

            LstPolicyGeneralDesc = model.LstPolicyGeneralDesc;
            $('.CellInput').each(function (index) {
                if ($(this).data('type') == 'DropdownList' && $(this).hasClass("CellInputDropdownList")) {
                    var controlId = $(this).attr("id");
                    var pointFor = $(this).data('for');
                    var group = $(this).data('group');

                    $(this).on('click', function () {
                        var pointFor = $(this).data('for');
                        var group = $(this).data('group');

                        $('#Pnl' + group).find('.Pointer').addClass("PointerNone");
                        $('#Pnl' + group).find('.Pointer[data-for="' + pointFor + '"]').removeClass("PointerNone");

                        $('#IptDesc' + group).html('');
                        $.each(LstPolicyGeneralDesc, function (i, n) {
                            if (n.Level2 == pointFor && n.Level3 == $('#' + controlId + '_Control').data("kendoDropDownList").value()) {
                                $('#IptDesc' + group).html(n.DescContent);
                            }
                        });
                    });

                    $('#' + controlId + '_Control').on('change', function () {
                        $('#Pnl' + group).find('.Pointer').addClass("PointerNone");
                        $('#Pnl' + group).find('.Pointer[data-for="' + pointFor + '"]').removeClass("PointerNone");

                        $('#IptDesc' + group).html('');
                        $.each(LstPolicyGeneralDesc, function (i, n) {
                            if (n.Level2 == pointFor && n.Level3 == $('#' + controlId + '_Control').data("kendoDropDownList").value()) {
                                $('#IptDesc' + group).html(n.DescContent);
                            }
                        });
                    });
                } else {
                    $(this).on('click', function () {
                        var pointFor = $(this).data('for');
                        var group = $(this).data('group');

                        $('#Pnl' + group).find('.Pointer').addClass("PointerNone");
                        $('#Pnl' + group).find('.Pointer[data-for="' + pointFor + '"]').removeClass("PointerNone");

                        $('#IptDesc' + group).html('');
                        $.each(LstPolicyGeneralDesc, function (i, n) {
                            if (n.Level2 == pointFor && n.Level3 == '') {
                                $('#IptDesc' + group).html(n.DescContent);
                            }
                        });
                    });
                }
            })

            if (isCanEdit == false) {
                setReadonly();
                $('#PnlPreview').html(model.IptPolicyPreview);
            }

            if (showPreview == 'false') {
                $('.policyButton').hide();
                $('.policySummary').show();
            } else {
                $('.policyButton').hide();
                $('.policyPreview').show();

                $('#PnlEdit').hide();
                $('#PnlPreview').show();
            }

            $(window).resize(function () {
                setLayout();
            })

            hideLoading();
        });
    }

    that.ChangeProTo = function () {
        showLoading();

        if ($('#IptProTo').FrameDropdownList('getValue') == 'ByDealer') {
            $('#TrProToType').show();
            $('#IptProToType').FrameDropdownList('setValue', '');
            $('#TrBtnProToType').hide();
        } else {
            $('#TrProToType').hide();
            $('#TrBtnProToType').hide();
        }

        hideLoading();
    }

    that.ChangeProToType = function () {
        showLoading();

        if ($('#IptProToType').FrameDropdownList('getValue') == '') {
            $('#TrBtnProToType').hide();
        } else {
            $('#TrBtnProToType').show();
        }

        hideLoading();
    }

    that.ConvertAdvance = function () {
        var data = that.GetModel('ConvertAdvance');

        showConfirm({
            target: 'top',
            message: '此操作不可撤销，请确认是否转成高级模式？',
            confirmCallback: function () {
                showLoading();
                submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
                    showAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '转换成功',
                        callback: function () {
                            window.location = Common.AppVirtualPath + 'PagesKendo/Promotion/PolicyInfo.aspx?PolicyId=' + model.IptPolicyId + '&PageType=Modify&PolicyStyle=' + escape(model.IptPolicyStyle) + '&PolicyStyleSub=' + escape(model.IptPolicyStyleSub) + '&ShowPreview=false&IsTemplate=false';
                        }
                    });
                });
            }
        });
    }

    that.Save = function () {
        var data = that.GetModel('Save');

        var message = checkPolicy(data);
        if (message.length > 0) {
            showAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        } else {
            showConfirm({
                target: 'top',
                message: '确定保存促销政策吗？',
                confirmCallback: function () {
                    showLoading();
                    submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
                        $('#PnlSummary').html(model.IptPolicySummary);
                        that.SetEditEvent();

                        showAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '保存成功'
                        });

                        hideLoading();
                    });
                }
            });
        }
    }

    that.Preview = function () {
        var data = that.GetModel('Preview');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
            $('#PnlSummary').html(model.IptPolicySummary);
            that.SetEditEvent();

            $('#PnlPreview').html(model.IptPolicyPreview);

            $('#PnlEdit').fadeOut(500, function () {
                $('#PnlPreview').fadeIn(500);
            })

            $('.policyButton').hide();
            $('.policyPreview').show();

            setLayout();

            hideLoading();
        });
    }

    that.Submit = function () {
        var data = that.GetModel('Submit');

        var message = checkPolicy(data);
        if (message.length > 0) {
            showAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        } else {
            showConfirm({
                target: 'top',
                message: '确定提交促销政策吗？',
                confirmCallback: function () {
                    showLoading();
                    submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
                        showAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '提交成功',
                            callback: function () {
                                closeWindow({
                                    target: 'top'
                                });
                            }
                        });

                        hideLoading();
                    });
                }
            });
        }
    }

    that.ReloadFactor = function () {
        var data = that.GetModel('ReloadFactor');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
            $('#PnlSummary').html(model.IptPolicySummary);
            that.SetEditEvent();

            $("#RstFactorList").data("kendoGrid").setOptions({
                dataSource: model.RstFactorList
            });

            hideLoading();
        });
    }

    that.RemoveFactor = function (factorId, isGift, isPoint) {
        var data = that.GetModel('RemoveFactor');
        data.IptPolicyFactorId = factorId;
        data.IptPolicyFactorIsGift = isGift;
        data.IptPolicyFactorIsPoint = isPoint;

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
            $('#PnlSummary').html(model.IptPolicySummary);
            that.SetEditEvent();

            $("#RstFactorList").data("kendoGrid").setOptions({
                dataSource: model.RstFactorList
            });

            showAlert({
                target: 'top',
                alertType: 'info',
                message: '删除成功'
            });

            hideLoading();
        });
    }

    that.ReloadRule = function () {
        var data = that.GetModel('ReloadRule');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
            $('#PnlSummary').html(model.IptPolicySummary);
            that.SetEditEvent();

            $("#RstRuleList").data("kendoGrid").setOptions({
                dataSource: model.RstRuleList
            });

            hideLoading();
        });
    }

    that.RemoveRule = function (ruleId) {
        var data = that.GetModel('RemoveRule');
        data.IptPolicyRuleId = ruleId;

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
            $('#PnlSummary').html(model.IptPolicySummary);
            that.SetEditEvent();

            $("#RstRuleList").data("kendoGrid").setOptions({
                dataSource: model.RstRuleList
            });

            showAlert({
                target: 'top',
                alertType: 'info',
                message: '删除成功'
            });

            hideLoading();
        });
    }

    that.ReloadAttachment = function () {
        var data = that.GetModel('ReloadAttachment');

        //showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
            $('#PnlSummary').html(model.IptPolicySummary);
            that.SetEditEvent();

            $("#RstAttachmentList").data("kendoGrid").setOptions({
                dataSource: model.RstAttachmentList
            });

            hideLoading();
        });
    };

    that.RemoveAttachment = function (attachmentId, attachmentName) {
        var data = that.GetModel('RemoveAttachment');
        data.IptAttachmentId = attachmentId;
        data.IptAttachmentName = attachmentName;

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
            $('#PnlSummary').html(model.IptPolicySummary);
            that.SetEditEvent();

            $("#RstAttachmentList").data("kendoGrid").setOptions({
                dataSource: model.RstAttachmentList
            });

            showAlert({
                target: 'top',
                alertType: 'info',
                message: '删除成功'
            });

            hideLoading();
        });
    }

    that.ReloadSummary = function () {
        var data = that.GetModel('ReloadSummary');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
            $('#PnlSummary').html(model.IptPolicySummary);
            that.SetEditEvent();

            hideLoading();
        });
    }

    that.SetEditEvent = function () {
        $('.edit').on('click', function () {
            if (target != $(this).data('target')) {
                targetTmp = $(this).data('target');

                //有修改面板
                var h = $('.content-main').height() - $('#Pnl' + targetTmp).height() - 70;
                $('#PnlSummary').animate({
                    height: h + 'px'
                }, 1000);

                if (target != '') {
                    $('#Pnl' + target).slideUp(500, function () {
                        $('#Pnl' + targetTmp).slideDown(500, function () {
                            setGrid();
                        });
                    });
                } else {
                    $('#Pnl' + targetTmp).slideDown(1000, function () {
                        setGrid();
                    });
                }

                $('.policyButton').hide();
                $('.policy' + targetTmp).show();

                target = targetTmp;

                {
                    var data = that.GetModel('Save');

                    showLoading();
                    submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateHanler.ashx", data, function (model) {
                        $('#PnlSummary').html(model.IptPolicySummary);
                        that.SetEditEvent();

                        hideLoading();
                    });
                }
            }
        });
    }

    var setReadonly = function () {
        //政策名称
        $('#IptPolicyName').FrameTextBox('disable');
        //分组名称
        $('#IptPolicyGroupName').FrameTextBox('disable');
        //开始时间
        $('#IptBeginDate').FrameDatePicker('disable');
        //终止时间
        $('#IptEndDate').FrameDatePicker('disable');
        //经销商结算周期
        $('#IptPeriod').FrameDropdownList('disable');
        //计入返利与达成
        $('#IptAcquisition').FrameSwitch('disable');
        //一/二级积分效期
        $('#IptPointValidDateType').FrameDropdownList('disable');
        //结算对象
        $('#IptProTo').FrameDropdownList('disable');
        //指定类型
        $('#IptProToType').FrameDropdownList('disable');

        $('#TrBtnProToType').remove();

        $('#BtnAddFactor').remove();
        $('#BtnAddRule').remove();
        $('#BtnAdvance').remove();
        $('#BtnSave').remove();
        $('#BtnSubmit').remove();
        $('#BtnAddAttachment').remove();
        $('#BtnOpenAttachment').data("kendoUpload").destroy();

        $("#RstFactorList").data("kendoGrid").hideColumn(3);
        $("#RstRuleList").data("kendoGrid").hideColumn(2);
        $("#RstAttachmentList").data("kendoGrid").hideColumn(5);
    }

    //打开指定经销商维护页面
    var openAppointedDealer = function () {
        var data = that.GetModel();

        if (data.IptProductLine == '') {
            showAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线'
            });
        } else {
            var url = 'PagesKendo/Promotion/MaintainAppointedDealer.aspx?';
            url += 'PolicyId=' + $('#IptPolicyId').val();
            url += '&ProductLine=' + escape(data.IptProductLine);
            url += '&SubBu=';
            url += '&PageType=' + escape($('#IptPageType').val());
            url += '&PromotionState=' + escape($('#IptPromotionState').val());

            openWindow({
                target: 'this',
                title: '政策适用对象',
                url: Common.AppVirtualPath + url,
                width: 800,
                height: 560,
                actions: ["Close"],
                callback: that.ReloadSummary
            });
        }
    }

    var openFactor = function (isPageNew, factorId) {
        var url = 'PagesKendo/Promotion/FactorInfo.aspx?';
        url += 'PolicyId=' + $('#IptPolicyId').val();
        url += '&IsPageNew=' + isPageNew;
        if (isPageNew == 'true') {
            policyFactorId++;
            url += '&PolicyFactorId=' + policyFactorId;
        } else {
            url += '&PolicyFactorId=' + factorId;
        }
        url += '&IsPoint=' + escape($('#IptPolicyStyle').val());
        url += '&IsPointSub=' + escape($('#IptPolicyStyleSub').val());
        url += '&PageType=' + escape($('#IptPageType').val());
        url += '&PromotionState=' + escape($('#IptPromotionState').val());

        openWindow({
            target: 'this',
            title: '政策参数',
            url: Common.AppVirtualPath + url,
            width: 800,
            height: 560,
            actions: ["Close"],
            callback: that.ReloadFactor
        });
    }

    var openRule = function (isPageNew, ruleId) {
        var url = 'PagesKendo/Promotion/RuleInfo.aspx?';
        url += 'PolicyId=' + $('#IptPolicyId').val();
        url += '&IsPageNew=' + isPageNew;
        if (isPageNew == 'true') {
            policyRuleId++;
            url += '&PolicyRuleId=' + policyRuleId;
        } else {
            url += '&PolicyRuleId=' + ruleId;
        }
        url += '&PolicyStyle=' + escape($('#IptPolicyStyle').val());
        url += '&PolicyStyleSub=' + escape($('#IptPolicyStyleSub').val());
        url += '&PageType=' + escape($('#IptPageType').val());
        url += '&PromotionState=' + escape($('#IptPromotionState').val());

        openWindow({
            target: 'this',
            title: '促销规则',
            url: Common.AppVirtualPath + url,
            width: 800,
            height: 560,
            actions: ["Close"],
            callback: that.ReloadRule
        });
    }

    var createFactorList = function (dataSource) {
        $("#RstFactorList").kendoGrid({
            dataSource: dataSource,
            sortable: true,
            resizable: true,
            scrollable: true,
            columns: [
            {
                field: "FactName", title: "参数名称", width: '200px',
                headerAttributes: {
                    "class": "center bold", "title": "参数名称"
                }
            },
            {
                field: "IsGiftName", title: "参数描述",
                headerAttributes: {
                    "class": "center bold", "title": "参数描述"
                }
            },
            {
                title: "编辑", width: "50px",
                headerAttributes: {
                    "class": "center bold"
                },
                template: "<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>",
                attributes: {
                    "class": "center"
                }
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

                $('#RstFactorList').find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    openFactor('false', data.PolicyFactorId);
                });

                $('#RstFactorList').find("i[name='remove']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    showConfirm({
                        target: 'top',
                        message: '确定删除政策参数吗？',
                        confirmCallback: function () {
                            that.RemoveFactor(data.PolicyFactorId, data.IsGift, data.IsPoint);
                        }
                    });
                });
            }
        });
    }

    var createRuleList = function (dataSource) {
        $("#RstRuleList").kendoGrid({
            dataSource: dataSource,
            sortable: true,
            resizable: true,
            scrollable: true,
            columns: [
            {
                field: "RuleDesc", title: "规则描述",
                headerAttributes: {
                    "class": "center bold", "title": "规则描述"
                }
            },
            {
                title: "编辑", width: "50px",
                headerAttributes: {
                    "class": "center bold"
                },
                template: "<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>",
                attributes: {
                    "class": "center"
                }
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

                $('#RstRuleList').find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    openRule('false', data.RuleId);
                });

                $('#RstRuleList').find("i[name='remove']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    showConfirm({
                        target: 'top',
                        message: '确定删除促销规则吗？',
                        confirmCallback: function () {
                            that.RemoveRule(data.RuleId);
                        }
                    });
                });
            }
        });
    }

    var createAttachmentList = function (dataSource) {
        $("#RstAttachmentList").kendoGrid({
            dataSource: dataSource,
            sortable: true,
            resizable: true,
            scrollable: true,
            columns: [
            {
                field: "Id", title: "附件id",
                hidden: true,
                headerAttributes: {
                    "class": "center bold", "title": "附件id"
                }
            },
            {
                field: "Name", title: "附件名称",
                headerAttributes: {
                    "class": "center bold", "title": "附件名称"
                }
            },
            {
                field: "Identity_Name", title: "上传人", width: '200px',
                headerAttributes: {
                    "class": "center bold", "title": "上传人"
                }
            },
            {
                field: "UploadDate", title: "上传时间", width: '200px',
                headerAttributes: {
                    "class": "center bold", "title": "上传时间"
                }
            },
            {
                title: "下载", width: "50px",
                headerAttributes: {
                    "class": "center bold"
                },
                template: "<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='download'></i>",
                attributes: {
                    "class": "center"
                }
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

                $('#RstAttachmentList').find("i[name='download']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    var url = Common.AppVirtualPath + 'Pages/Download.aspx?downloadname=' + escape(data.Name) + '&filename=' + escape(data.Url) + '&downtype=Promotion';

                    window.location = url;
                });

                $('#RstAttachmentList').find("i[name='remove']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    showConfirm({
                        target: 'top',
                        message: '确定删除附件吗？',
                        confirmCallback: function () {
                            that.RemoveAttachment(data.Id, data.Url);
                        }
                    });
                });
            }
        });
    }

    var getPolicyStyleSubCode = function (PolicyStyleSub) {
        var PolicyStyleSubCode = '';
        if (PolicyStyleSub == '促销赠品') {
            PolicyStyleSubCode = 'CXZP';
        } else if (PolicyStyleSub == '满额送固定积分') {
            PolicyStyleSubCode = 'GDJF';
        } else if (PolicyStyleSub == '金额百分比积分') {
            PolicyStyleSubCode = 'BFBJF';
        } else if (PolicyStyleSub == '促销赠品转积分') {
            PolicyStyleSubCode = 'BCJF';
        } else if (PolicyStyleSub == '满额送赠品') {
            PolicyStyleSubCode = 'SZP';
        } else if (PolicyStyleSub == '满额打折') {
            PolicyStyleSubCode = 'DZ';
        }
        return PolicyStyleSubCode
    }

    var checkPolicy = function (data) {
        var message = [];

        var PolicyStyleSubCode = getPolicyStyleSubCode(data.IptPolicyStyleSub);

        if (target == '' || target == 'Basic') {
            if (data.IptPolicyName == '') {
                message.push('请归类名称');
            }
            if (data.IptBeginDate == null) {
                message.push('请填写开始时间');
            }
            if (data.IptEndDate == null) {
                message.push('请填写终止时间');
            }
            if (PolicyStyleSubCode == 'CXZP') {
                if (data.IptAcquisition == null) {
                    message.push('请选择计入返利与达成');
                }
            } else if (PolicyStyleSubCode == 'GDJF') {
                if (data.IptAcquisition == null) {
                    message.push('请选择计入返利与达成');
                }
                if (data.IptPointValidDateType == '') {
                    message.push('经销商积分效期');
                }
            } else if (PolicyStyleSubCode == 'BFBJF') {
                if (data.IptAcquisition == null) {
                    message.push('请选择计入返利与达成');
                }
                if (data.IptPointValidDateType == '') {
                    message.push('经销商积分效期');
                }
            } else if (PolicyStyleSubCode == 'BCJF') {
                if (data.IptAcquisition == null) {
                    message.push('请选择计入返利与达成');
                }
                if (data.IptPointValidDateType == '') {
                    message.push('经销商积分效期');
                }
            }
        }
        if (target == '' || target == 'Dealer') {
            if (data.IptProTo == '') {
                message.push('请选择结算对象');
            }
            if (data.IptProTo == 'ByDealer' && data.IptProToType == '') {
                message.push('请选择结算经销商');
            }
        }

        return message;
    }

    var setGrid = function () {
        $("#RstFactorList").data("kendoGrid").setOptions({
            height: 120
        });
        $("#RstRuleList").data("kendoGrid").setOptions({
            height: 120
        });
        $("#RstAttachmentList").data("kendoGrid").setOptions({
            height: 120
        });
    }

    var setLayout = function () {
        var h = $('.content-main').height();

        if (target != '') {
            //有修改面板
            $('#PnlSummary').height(h - $('#Pnl' + target).height() - 70);
        } else {
            //无修改面板
            $('#PnlSummary').height($('.content-main').height() - 60);
        }

        setGrid();
    }

    return that;
}();
