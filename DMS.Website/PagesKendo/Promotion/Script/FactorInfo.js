var FactorInfo = {};

FactorInfo = function () {
    var that = {};
    var LstRelationCondition = [];
    var LstFactorDesc = [];
    var ruleConditionId;
    var isCanEdit;

    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;

        return model;
    }

    that.InitPage = function () {
        $('#IsPageNew').val($.getUrlParam('IsPageNew'));
        $('#IsTemplate').val($.getUrlParam('IsTemplate'));
        $('#IptPolicyId').val($.getUrlParam('PolicyId'));
        $('#IptPolicyFactorId').val($.getUrlParam('PolicyFactorId'));
        $('#IptIsPoint').val($.getUrlParam('IsPoint'));
        $('#IptIsPointSub').val($.getUrlParam('IsPointSub'));
        $('#IptPageType').val($.getUrlParam('PageType'));
        $('#IptPromotionState').val($.getUrlParam('PromotionState'));

        var data = that.GetModel('InitPage');
        console.log(data);
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/FactorInfoHanler.ashx", data, function (model) {
            console.log(model);

            $('#IptPolicyId').val(model.IptPolicyId);
            //是否新增
            $('#IsPageNew').val(model.IsPageNew);
            //因素类型
            $('#IptFactor').FrameDropdownList({
                dataSource: model.LstFactor,
                dataKey: 'FactId',
                dataValue: 'FactName',
                selectType: 'select',
                value: model.IptFactor,
                onChange: that.ChangeFactor
            });

            //if ($('#IptFactor').FrameDropdownList('getValue') == 1) {
            //    $('#Condition').show();
            //    $('#ConditionH').hide();
            //}
            //else if ($('#IptFactor').FrameDropdownList('getValue') ==2) {
            //    $('#Condition').hide();
            //    $('#ConditionH').show();
            //}
            //else {
            //    $('#Condition').show();
            //}
            //描述
            $('#IptRemark').FrameTextArea({
                height: 118,
                value: model.IptRemark
            });
            //促销赠品
            $('#IptIsGift').FrameSwitch({
                value: model.IptIsGift
            });
            //积分可订购产品
            $('#IptPointsValue').FrameSwitch({
                value: model.IptPointsValue
            });

            //条件因素-条件
            $('#IptRuleCondition').FrameDropdownList({
                dataSource: model.LstRuleCondition,
                dataKey: 'ConditionId',
                dataValue: 'ConditionName',
                selectType: 'select',
                onChange: that.ChangeRuleCondition
            });

            ////条件因素-条件
            //$('#IptRuleConditionH').FrameDropdownList({
            //    dataSource: model.LstRuleCondition,
            //    dataKey: 'ConditionId',
            //    dataValue: 'ConditionName',
            //    selectType: 'select',
            //    onChange: that.ChangeRuleCondition
            //});
            //条件因素-类型
            $('#IptRuleConditionType').FrameDropdownList({
                dataSource: [],
                dataKey: 'ConditionType',
                dataValue: 'ConditionType',
                selectType: 'select'
            });
            //条件因素-数值
            $('#IptRuleConditionValues').FrameTextArea({
                height: 149
            });

            //关联因素-关联因素
            $('#IptRelationCondition').FrameDropdownList({
                dataSource: [],
                dataKey: 'PolicyFactorId',
                dataValue: 'FactName',
                selectType: 'select',
                onChange: that.ChangeRelationCondition
            });
            //关联因素-描述
            $('#IptRelationConditionRemark').FrameTextArea({
                height: 179
            });
            $('#IptRelationConditionRemark').FrameTextArea('disable');

            if (model.IsPageNew == 'false') {
                $('#IptFactor').FrameDropdownList("disable");
                $('#IptIsGift').FrameSwitch("disable");
                $('#IptPointsValue').FrameSwitch("disable");

                if (model.IptFactor == '1') {
                    var h = 118;
                    if (model.IptIsPointSub == '促销赠品' || model.IptIsPointSub == '促销赠品转积分' || model.IptIsPointSub == '满额送赠品' || model.IptIsPointSub != '满额打折') {
                        h = h - 30;
                        $('#TrIsGift').show();
                    }
                    else {
                        $('#TrIsGift').hide();
                    }

                    if (model.IptIsPointSub != '促销赠品' && model.IptIsPointSub != '满额送赠品' && model.IptIsPointSub != '满额打折') {
                        h = h - 30;
                        $('#TrPointsValue').show();
                    } else {
                        $('#TrPointsValue').hide();
                    }
                    $('#IptRemark').FrameTextArea("setHeight", h);
                }

                $('#IptFactorClass').val(model.IptFactorClass);

                if (model.IptFactorClass != '') {
                    if (model.IsTemplate != 'True' && $.stringContains('6,7,14,15', model.IptFactor, ',')) {
                        $('#BtnUploadTopType').show();
                    } else {
                        $('#BtnUploadTopType').remove();
                    }

                    if (model.IsTemplate == 'True' && $.stringContains('1,2', model.IptFactor, ',')) {
                        $('#PnlDetail').remove();
                        ruleConditionId = 1;
                    } else {
                        $('#PnlDetail').show();

                        createFactorRuleList(model);
                        ruleConditionId = model.IptConditionMaxId;
                    }
                } else {
                    $('#PnlDetail').remove();
                    ruleConditionId = 1;
                }
            } else {
                $('#PnlDetail').remove();
                ruleConditionId = 1;
            }

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
            //上传更改指定产品指标
            $('#BtnUploadTopType').FrameButton({

                onClick: openProTarget
            });
            $('#BtnConditionSave').FrameButton({
                onClick: that.SaveCondition
            });
            $('#BtnConditionBack').FrameButton({
                onClick: function () {
                    if ($('#IptFactorClass').val() == 'Rule') {
                        $("#PnlConditionRuleInfo, #PnlConditionList").slideToggle();
                    } else {
                        //关联因素-关联因素
                        LstRelationCondition = [];
                        $('#IptRelationCondition').FrameDropdownList('setDataSource', LstRelationCondition);
                        $('#IptRelationCondition').FrameDropdownList('setValue', '');
                        //关联因素-描述
                        $('#IptRelationConditionRemark').FrameTextArea('setValue', '');

                        $("#PnlConditionRelationInfo, #PnlConditionList").slideToggle();
                    }

                    $("#PnlFactorButton, #PnlConditionButton").toggle();

                    $("#RstFactorRule").data("kendoGrid").setOptions({
                        height: 190
                    });
                }
            });
            $('#BtnConditionAdd').FrameButton({
                onClick: function () {
                    that.ShowCondition('');
                }
            });

            isCanEdit = model.IsCanEdit;
            if (isCanEdit == false) {
                setReadonly(model.IptFactorClass);
            }

            LstFactorDesc = model.LstFactorDesc;
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
                        $.each(LstFactorDesc, function (i, n) {
                            if (n.Level2 == pointFor && n.Level3 == $('#' + controlId + '_Control').data("kendoDropDownList").value()) {
                                $('#IptDesc' + group).html(n.DescContent);
                            }
                        });
                    });

                    $('#' + controlId + '_Control').on('change', function () {
                        $('#Pnl' + group).find('.Pointer').addClass("PointerNone");
                        $('#Pnl' + group).find('.Pointer[for="' + pointFor + '"]').removeClass("PointerNone");

                        $('#IptDesc' + group).html('');
                        $.each(LstFactorDesc, function (i, n) {
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
                        $.each(LstFactorDesc, function (i, n) {
                            if (n.Level2 == pointFor && n.Level3 == '') {
                                $('#IptDesc' + group).html(n.DescContent);
                            }

                        });
                    });
                }
            })

            //$("input[type='text']").each(function () {
            //    $(this).focus(function () {
            //        $(this).select();
            //    });
            //});
            //$("textarea").each(function () {
            //    $(this).focus(function () {
            //        $(this).select();
            //    });
            //});

            $(window).resize(function () {
                setLayout();
            })
            setLayout();

            hideLoading();
        });
    }

    that.ChangeFactor = function () {
        var data = that.GetModel('ChangeFactor');

        if (data.IptFactor == '1') {
            var h = 118;
            if (data.IptIsPointSub == '促销赠品' || data.IptIsPointSub == '促销赠品转积分' || data.IptIsPointSub == '满额送赠品' || data.IptIsPointSub != '满额打折') {
                h = h - 30;
                $('#TrIsGift').show();
            }
            else {
                $('#TrIsGift').hide();
            }

            if (data.IptIsPointSub != '促销赠品' && data.IptIsPointSub != '满额送赠品' && data.IptIsPointSub != '满额打折') {
                h = h - 30;
                $('#TrPointsValue').show();
            } else {
                $('#TrPointsValue').hide();
            }
            $('#IptRemark').FrameTextArea("setHeight", h);

            showLoading();
            submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/FactorInfoHanler.ashx", data, function (model) {
                $('#IptIsGift').FrameSwitch("setValue", model.IptIsGift);
                $('#IptPointsValue').FrameSwitch("setValue", model.IptPointsValue);

                if (model.IptCheckIsGift == 0) {
                    $('#IptIsGift').FrameSwitch("enable");
                    $('#IptPointsValue').FrameSwitch("enable");
                } else if (model.IptCheckIsGift == 1) {
                    $('#IptIsGift').FrameSwitch("disable");
                    $('#IptPointsValue').FrameSwitch("enable");
                } else if (model.IptCheckIsGift == 2) {
                    $('#IptIsGift').FrameSwitch("enable");
                    $('#IptPointsValue').FrameSwitch("disable");
                } else if (model.IptCheckIsGift == 3) {
                    $('#IptIsGift').FrameSwitch("disable");
                    $('#IptPointsValue').FrameSwitch("disable");
                }
                console.log(model.LstRuleCondition);
                hideLoading();
            });
        } else {
            $('#IptRemark').FrameTextArea("setHeight", 118);
            $('#IptIsGift').FrameSwitch("setValue", false);
            $('#TrIsGift').hide();
            $('#IptPointsValue').FrameSwitch("setValue", false);
            $('#TrPointsValue').hide();
        }

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
            showLoading();
            submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/FactorInfoHanler.ashx", data, function (model) {
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '保存成功',
                    callback: function () {
                        if (model.IsPageNew == 'true') {
                            var url = 'PagesKendo/Promotion/FactorInfo.aspx?';
                            url += 'PolicyId=' + model.IptPolicyId;
                            url += '&IsPageNew=false';
                            url += '&PolicyFactorId=' + model.IptPolicyFactorId;
                            url += '&IsPoint=' + escape(model.IptIsPoint);
                            url += '&IsPointSub=' + escape(model.IptIsPointSub);
                            url += '&PageType=' + escape(model.IptPageType);
                            url += '&PromotionState=' + escape(model.IptPromotionState);
                            url += '&IsTemplate=' + escape(model.IsTemplate);
                            url += '&timestamp=' + $.getUrlParam('timestamp');

                            window.location = Common.AppVirtualPath + url;
                        }
                    }
                });

                hideLoading();
            });
        }
    }

    that.ChangeRelationCondition = function () {
        $('#IptRelationConditionRemark').FrameTextArea('setValue', '');
        $.each(LstRelationCondition, function (i, n) {
            if (n.PolicyFactorId == $('#IptRelationCondition').FrameDropdownList('getValue')) {
                $('#IptRelationConditionRemark').FrameTextArea('setValue', n.FactDesc);
            }
        });
    }

    that.ChangeRuleCondition = function () {
        var data = that.GetModel('ChangeRuleCondition');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/FactorInfoHanler.ashx", data, function (model) {
            //条件因素-类型
            $('#IptRuleConditionType').FrameDropdownList('setDataSource', model.LstRuleConditionType);
            $('#IptRuleConditionType').FrameDropdownList('setValue', '');

            hideLoading();
        });
    }

    that.ShowCondition = function (conditionId) {
        $('#IptConditionId').val(conditionId);
        var data = that.GetModel('ShowCondition');

        if (data.IptFactorClass == 'Rule') {
            if (conditionId == '') {
                //条件因素-条件
                $('#IptRuleCondition').FrameDropdownList('setValue', '');
                $('#IptRuleCondition').FrameDropdownList('enable');
                //条件因素-类型
                $('#IptRuleConditionType').FrameDropdownList('setDataSource', []);
                $('#IptRuleConditionType').FrameDropdownList('setValue', '');
                $('#IptRuleConditionType').FrameDropdownList('enable');
                //条件因素-数值
                $('#IptRuleConditionValues').FrameTextArea('setValue', '');

                $("#PnlConditionRuleInfo, #PnlConditionList").slideToggle();

                $("#PnlFactorButton, #PnlConditionButton").toggle();
            } else {
                showLoading();
                submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/FactorInfoHanler.ashx", data, function (model) {
                    //条件因素-条件
                    $('#IptRuleCondition').FrameDropdownList('setValue', model.IptRuleCondition);
                    $('#IptRuleCondition').FrameDropdownList('disable');
                    //条件因素-类型
                    $('#IptRuleConditionType').FrameDropdownList('setDataSource', model.LstRuleConditionType);
                    $('#IptRuleConditionType').FrameDropdownList('setValue', model.IptRuleConditionType);
                    $('#IptRuleConditionType').FrameDropdownList('disable');
                    //条件因素-IptRuleConditionType
                    var values = '';
                    for (var i = 0; i < model.RstRuleConditionValues.length; i++) {
                        values += model.RstRuleConditionValues[i].Code;
                        if (i != model.RstRuleConditionValues.length - 1) {
                            values += '\n';
                        }
                    }
                    $('#IptRuleConditionValues').FrameTextArea('setValue', values);

                    $("#PnlConditionRuleInfo, #PnlConditionList").slideToggle();

                    $("#PnlFactorButton, #PnlConditionButton").toggle();

                    hideLoading();
                });
            }
        } else {
            showLoading();
            submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/FactorInfoHanler.ashx", data, function (model) {
                //关联因素-关联因素
                LstRelationCondition = model.LstRelationCondition;
                $('#IptRelationCondition').FrameDropdownList('setDataSource', LstRelationCondition);
                $('#IptRelationCondition').FrameDropdownList('setValue', '');
                //关联因素-描述
                $('#IptRelationConditionRemark').FrameTextArea('setValue', '');

                $("#PnlConditionRelationInfo, #PnlConditionList").slideToggle();

                $("#PnlFactorButton, #PnlConditionButton").toggle();

                hideLoading();
            });
        }
    }

    that.SaveCondition = function () {
        var data = that.GetModel('SaveCondition');

        if (data.IptFactorClass == 'Rule') {
            var message = checkFormRule(data);

            if (message.length > 0) {
                showAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: message,
                });
            } else {
                if ($('#IptConditionId').val() == '') {
                    ruleConditionId++;
                    data.IptConditionId = ruleConditionId;
                }
                console.log(data.IptPolicyFactorId);
                console.log(data.IptConditionId);
                showLoading();
                submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/FactorInfoHanler.ashx", data, function (model) {
                    if (model.RstCheckFailList.length == 0) {
                        showAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '保存成功',
                            callback: function () {
                                $("#PnlConditionRuleInfo, #PnlConditionList").slideToggle();

                                $("#RstFactorRule").data("kendoGrid").setOptions({
                                    dataSource: model.RstFactorRule,
                                    height: 190
                                });

                                $("#PnlFactorButton, #PnlConditionButton").toggle();
                            }
                        });
                    } else {
                        var msg = '';
                        msg += '数值内容校验失败，错误信息如下：<br /><br />';
                        for (i = 0; i < model.RstCheckFailList.length; i++) {
                            msg += model.RstCheckFailList[i].Code + '（' + model.RstCheckFailList[i].ErrMsg + '）<br />';
                        }

                        showAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: msg
                        });
                    }

                    hideLoading();
                });
            }
        } else {
            var message = checkFormRelation(data);

            if (message.length > 0) {
                showAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: message,
                });
            } else {
                showLoading();
                submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/FactorInfoHanler.ashx", data, function (model) {
                    $("#PnlConditionRelationInfo, #PnlConditionList").slideToggle();

                    $("#RstFactorRule").data("kendoGrid").setOptions({
                        dataSource: model.RstFactorRule,
                        height: 190
                    });

                    $("#PnlFactorButton, #PnlConditionButton").toggle();

                    hideLoading();
                });
            }
        }
    }

    that.RemoveCondition = function () {
        var data = that.GetModel('RemoveCondition');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/FactorInfoHanler.ashx", data, function (model) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: '删除成功',
                callback: function () {
                    $("#RstFactorRule").data("kendoGrid").setOptions({
                        dataSource: model.RstFactorRule,
                        height: 190
                    });
                }
            });

            hideLoading();
        });
    }

    var setReadonly = function (factorClass) {
        //因素类型
        $('#IptFactor').FrameDropdownList('disable');
        //描述
        $('#IptRemark').FrameTextArea('disable');
        //促销赠品
        $('#IptIsGift').FrameSwitch('disable');
        //积分可订购产品
        $('#IptPointsValue').FrameSwitch('disable');

        //条件因素-条件
        $('#IptRuleCondition').FrameDropdownList('disable');
        //条件因素-类型
        $('#IptRuleConditionType').FrameDropdownList('disable');
        //条件因素-数值
        $('#IptRuleConditionValues').FrameTextArea('disable');

        //关联因素-关联因素
        $('#IptRelationCondition').FrameDropdownList('disable');
        //关联因素-描述
        $('#IptRelationConditionRemark').FrameTextArea('disable');

        $('#BtnConditionAdd').remove();
        $('#BtnSave').remove();
        $('#BtnConditionSave').remove();

        if (factorClass == "Rule") {
            $("#RstFactorRule").data("kendoGrid").hideColumn(4);
        } else {
            $("#RstFactorRule").data("kendoGrid").hideColumn(2);
        }
    }

    var createFactorRuleList = function (model) {
        if (model.IptFactorClass == "Rule") {
            $("#RstFactorRule").kendoGrid({
                dataSource: model.RstFactorRule,
                sortable: true,
                resizable: true,
                scrollable: true,
                height: 190,
                columns: [
                    {
                        field: "ConditionName", title: "条件", width: '100px',
                        headerAttributes: { "class": "center bold", "title": "条件" }
                    },
                    {
                        field: "OperTag", title: "类型", width: '100px',
                        headerAttributes: { "class": "center bold", "title": "类型" }
                    },
                    {
                        field: "ConditionValue", title: "描述",
                        headerAttributes: { "class": "center bold", "title": "描述" }
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

                    $("i[name='edit']").bind('click', function (e) {
                        var tr = $(this).closest("tr")
                        var data = grid.dataItem(tr);

                        that.ShowCondition(data.PolicyFactorConditionId);
                    });

                    $("i[name='remove']").bind('click', function (e) {
                        var tr = $(this).closest("tr")
                        var data = grid.dataItem(tr);

                        showConfirm({
                            target: 'top',
                            message: '确定删除限定条件吗？',
                            confirmCallback: function () {
                                $('#IptConditionId').val(data.PolicyFactorConditionId);
                                that.RemoveCondition();
                            }
                        });
                    });
                }
            });
        } else {
            $("#RstFactorRule").kendoGrid({
                dataSource: model.RstFactorRule,
                sortable: true,
                resizable: true,
                scrollable: true,
                height: 190,
                columns: [
                    {
                        field: "FactName", title: "关联参数", width: '200px',
                        headerAttributes: { "class": "center bold", "title": "关联参数" }
                    },
                    {
                        field: "FactDesc", title: "描述",
                        headerAttributes: { "class": "center bold", "title": "描述" }
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
                            message: '确定删除关联参数吗？',
                            confirmCallback: function () {
                                $('#IptConditionId').val(data.ConditionPolicyFactorId);
                                that.RemoveCondition();
                            }
                        });
                    });
                }
            });
        }
    }
    //
    var openProTarget = function () {

        var url = 'PagesKendo/Promotion/MaintainSpecifyProTarget.aspx?';
        url += 'PolicyId=' + escape($.getUrlParam('PolicyId'));
        url += '&PolicyFactorId=' + escape($.getUrlParam('PolicyFactorId'));
        url += '&FactorClass=' + escape($('#IptFactor').FrameDropdownList('getValue'));
        console.log("heloo" + url);
        openWindow({
            target: 'top',
            title: '指定产品指标导入',
            url: Common.AppVirtualPath + url,
            width: 800,
            height: 560,
            actions: ["Close"]
        });
    }
    var checkFormMain = function (data) {
        var message = [];

        if (data.IptFactor == '') {
            message.push('请选择参数类型');
        }

        return message
    }

    var checkFormRule = function (data) {
        var message = [];

        if (data.IptRuleCondition == '') {
            message.push('请选择条件');
        }
        if (data.IptRuleConditionType == '') {
            message.push('请选择类型');
        }
        if (data.IptRuleConditionValues == '') {
            message.push('请填写数值');
        }

        return message
    }

    var checkFormRelation = function (data) {
        var message = [];

        if (data.IptRelationCondition == '') {
            message.push('请选择关联参数');
        }

        return message
    }

    var initColumnLayout = function () {
    }

    var setLayout = function () {
        var h = $('.content-main').height();
    }

    return that;
}();
