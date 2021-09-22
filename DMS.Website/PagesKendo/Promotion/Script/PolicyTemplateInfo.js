var PolicyTemplateInfo = {};

PolicyTemplateInfo = function () {
    var that = {};
    var LstPolicyGeneralDesc = [];
    var tabStrip;
    var step = 0;
    var policyFactorId = 3;
    var policyRuleId = 3;
    var isCanEdit;
    var isSaved;

    that.GetModel = function (method) {
        var model = $.getModel();
        model.Method = method;

        return model;
    }

    that.InitPage = function () {
        $('#IptPolicyId').val($.getUrlParam('PolicyId'));
        $('#IptPageType').val($.getUrlParam('PageType'));
        $('#IptPolicyStyle').val($.getUrlParam('PolicyStyle'));
        $('#IptPolicyStyleSub').val($.getUrlParam('PolicyStyleSub'));

        var data = that.GetModel('InitPage');
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateInfoHanler.ashx", data, function (model) {
            tabStrip = $("#PnlPolicy").kendoTabStrip({
                animation: {
                    open: {
                        duration: 0,
                        effects: "show"
                    },
                    close: {
                        duration: 0,
                        effects: "hide"
                    }
                }
            }).data("kendoTabStrip");

            var PolicyStyleSubCode = getPolicyStyleSubCode(model.IptPolicyStyleSub);

            //政策ID
            $('#IptPolicyId').val(model.IptPolicyId);
            //大类
            $('#IptPolicyStyle').val(model.IptPolicyStyle);
            //小类
            $('#IptPolicyStyleSub').val(model.IptPolicyStyleSub);
            //促销计算基数
            $('#IptPolicyType').FrameDropdownList({
                dataSource: [{ Key: '植入赠', Value: '医院植入' }, { Key: '采购赠', Value: '商业采购' }],
                dataKey: 'Key',
                dataValue: 'Value',
                value: model.IptPolicyType,
                onChange: that.ChangePolicyType
            });
            //产品线
            $('#IptProductLine').FrameDropdownList({
                dataSource: model.LstProductLine,
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'select',
                value: model.IptProductLine,
                onChange: that.ChangeProductLine
            });
            //政策名称
            $('#IptTemplateName').FrameTextBox({
                value: model.IptTemplateName
            });
            //政策说明
            $('#IptPolicyDesc').FrameTextArea({
                rows: 10,
                value: model.IptPolicyDesc
            });
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
                value: model.IptProToType
            });
            //经销商结算周期
            $('#IptPeriod').FrameDropdownList({
                dataSource: [{ Key: '季度', Value: '季度' }, { Key: '年度', Value: '年度' }, { Key: '月度', Value: '月度' }],
                dataKey: 'Key',
                dataValue: 'Value',
                value: model.IptPeriod
            });
            //封顶类型
            $('#IptTopType').FrameDropdownList({
                dataSource: [{ Key: 'Policy', Value: '政策统一值' }, { Key: 'Dealer', Value: '经销商' }, { Key: 'Hospital', Value: '医院' }],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'select',
                value: model.IptTopType,
                onChange: that.ChangeTopType
            });
            //封顶值
            $('#IptTopValue').FrameNumeric({
                value: model.IptTopValue
            });
            //扣除上期赠品
            $('#IptMinusLastGift').FrameSwitch({
                value: model.IptMinusLastGift
            });
            //进位方式
            $('#IptCarryType').FrameDropdownList({
                dataSource: [{ Key: 'KeepValue', Value: '保留原值' }, { Key: 'Floor', Value: '往下取整' }, { Key: 'Ceiling', Value: '往上取整' }, { Key: 'Round', Value: '四舍五入' }],
                dataKey: 'Key',
                dataValue: 'Value',
                value: model.IptCarryType
            });
            //增量计算
            $('#IptIncrement').FrameSwitch({
                value: model.IptIncrement
            });
            //累计上期余量
            $('#IptAddLastLeft').FrameSwitch({
                value: model.IptAddLastLeft
            });
            //YTD奖励追溯
            $('#IptYtdOption').FrameDropdownList({
                dataSource: [{ Key: 'N', Value: '无' }, { Key: 'YTD', Value: '年度指标完成追溯' }, { Key: 'YTDRTN', Value: 'YTD指标完成追溯' }],
                dataKey: 'Key',
                dataValue: 'Value',
                value: model.IptYtdOption
            });
            //计入返利与达成
            $('#IptAcquisition').FrameSwitch({
                value: model.IptAcquisition
            });
            //平台积分可用于全产品
            $('#IptUseProductForLp').FrameSwitch({
                value: model.IptUseProductForLp
            });

            //平台积分有效期
            $('#IptPointValidDateTypeForLp').FrameLabel({
                value: '当前账期延展1个季度'
            });
            //一/二级积分效期
            $('#IptPointValidDateType').FrameDropdownList({
                dataSource: [{ Key: 'Year', Value: '当年有效' }, { Key: 'HalfYear', Value: '半年有效' }, { Key: 'Quarter', Value: '结算周期的次季度有效' }],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'select',
                value: model.IptPointValidDateType
                //onChange: that.ChangePointValidDateType
            });
            //买减折价率
            $('#IptMjRatio').FrameNumeric({
                value: model.IptMjRatio
            });

            $('#PnlPreview').html(model.IptPolicyPreview);

            //显示新增政策是哪一个，显示新增政策的政策编号，如：CXZP为新增赠品
            $('.' + PolicyStyleSubCode).show();
            $('.' + PolicyStyleSubCode).attr('visible', 'true');

            //基本参数panal的id为PnlBasic，
            //移除里面visible=‘false’的tr元素，find查找返回所有的子元素
            $('#PnlBasic').find("tr[visible='false']").remove();
            //计算参数
            $('#PnlCalc').find("tr[visible='false']").remove();
            $('#PnlGift').find("tr[visible='false']").remove();

            //移除不没有选项panal
            if ($('#PnlBasic').find('.KendoTable').find('tr[visible=\'true\']').length == 0) {
                $('#PnlBasic').remove();
            }
            if ($('#PnlCalc').find('.KendoTable').find('tr[visible=\'true\']').length == 0) {
                $('#PnlCalc').remove();
            }
            if ($('#PnlGift').find('.KendoTable').find('tr[visible=\'true\']').length == 0) {
                $('#PnlGift').remove();
            }

            initColumnLayout();

            createFactorList(model);
            createRuleList(model);

            isCanEdit = model.IsCanEdit;

            $('#BtnBack').FrameButton({
                onClick: function () {
                    --step;
                    tabStrip.select(step);

                    $(".Step").hide();
                    $(".Step" + step).show();
                }
            });
            $('#BtnNext').FrameButton({
                onClick: function () {
                    if (step == 0 && isCanEdit) {
                        that.Save(true, false);
                    } else {
                        ++step;
                        tabStrip.select(step);

                        $(".Step").hide();
                        $(".Step" + step).show();

                    }
                }
            });
            $('#BtnSave').FrameButton({
                onClick: function () {
                    that.Save(false, false);
                }
            });
            $('#BtnPreview').FrameButton({
                onClick: function () {
                    that.Save(true, true);

                    //console.log(isCanEdit);
                    //if (isCanEdit) {
                    //    that.Save(true, true);
                    //} else {
                    //    ++step;
                    //    tabStrip.select(step);

                    //    $(".Step").hide();
                    //    $(".Step" + step).show();
                    //}
                }
            });
            $('#BtnClose').FrameButton({
                onClick: function () {
                    closeWindow({
                        target: 'top'
                    });
                }
            });
            $('#BtnAddFactor').FrameButton({
                onClick: function () {
                    openFactor('true');
                }
            });
            $('#BtnAddRule').FrameButton({
                onClick: function () {
                    openRule('true');
                }
            });

            if (isCanEdit == false) {
                isSaved = true;
                $('#IptProductLine').FrameDropdownList('disable');
                $('#IptPolicyType').FrameDropdownList('disable');
            } else {
                isSaved = false;
            }

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

            if (isCanEdit == true) {
                tabStrip.disable(tabStrip.tabGroup.children().eq(0));
                tabStrip.disable(tabStrip.tabGroup.children().eq(1));
                tabStrip.disable(tabStrip.tabGroup.children().eq(2));
                tabStrip.disable(tabStrip.tabGroup.children().eq(3));
                $('.TabStep').addClass('k-state-default');
            } else {
                $('.TabStep').on('click', function () {
                    var to = $(this).data('step');

                    step = to;

                    $(".Step").hide();
                    $(".Step" + step).show();
                });
            }

            tabStrip.select(0);
            $(".Step").hide();
            $(".Step0").show();

            $(window).resize(function () {
                setLayout();
            })
            setLayout();

            hideLoading();
        });
    }

    that.ChangePolicyType = function () {
        var data = that.GetModel('ChangePolicyType');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateInfoHanler.ashx", data, function (model) {
            if ($('#IptPolicyType').FrameDropdownList('getValue') == '采购赠') {
                $('#IptProTo').FrameDropdownList('setValue', 'ByDealer');
                $('#IptProTo').FrameDropdownList('disable');
                $('#TrProToType').show();
                $('#IptProToType').FrameDropdownList('setValue', '');
            } else {
                $('#IptProTo').FrameDropdownList('enable');
            }

            $("#RstFactorList").data("kendoGrid").setOptions({
                dataSource: model.RstFactorList
            });

            hideLoading();
        });
    }

    that.ChangeProTo = function () {
        showLoading();

        if ($('#IptProTo').FrameDropdownList('getValue') == 'ByDealer') {
            $('#TrProToType').show();
            $('#IptProToType').FrameDropdownList('setValue', '');
        } else {
            $('#TrProToType').hide();
        }

        hideLoading();
    }

    that.ChangeTopType = function () {
        showLoading();

        if ($('#IptTopType').FrameDropdownList('getValue') == 'Policy') {
            $('#TdTopType').hide();
            $('#TrTopValue').show();
            $('#IptTopValue').FrameNumeric('setValue', '');
        } else if ($('#IptTopType').FrameDropdownList('getValue') == 'Dealer' || $('#IptTopType').FrameDropdownList('getValue') == 'Hospital') {
            $('#TdTopType').show();
            $('#TrTopValue').hide();
        } else {
            $('#TdTopType').hide();
            $('#TrTopValue').hide();
        }

        hideLoading();
    }

    that.Save = function (goNext, loadPreview) {
        var data = that.GetModel('Save');

        var message = checkPolicy(data);
        if (message.length > 0) {
            showAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        } else {
            var ConfirmMessage = '';
            if (isSaved) {
                ConfirmMessage = '确定保存促销模板吗？'
            } else {
                ConfirmMessage = '请确认产品线和促销计算基数填写正确，保存后将不能修改。'
            }

            showConfirm({
                target: 'top',
                message: ConfirmMessage,
                confirmCallback: function () {
                    showLoading();
                    submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateInfoHanler.ashx", data, function (model) {
                        if (!isSaved) {
                            $('#IptProductLine').FrameDropdownList('disable');
                            $('#IptPolicyType').FrameDropdownList('disable');

                            isSaved = true;
                        }

                        if (!goNext && !loadPreview) {
                            showAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '保存成功'
                            });
                        } else {
                            if (goNext) {
                                ++step;
                                tabStrip.select(step);

                                $(".Step").hide();
                                $(".Step" + step).show();
                            }

                            if (loadPreview) {
                                $('#PnlPreview').html(model.IptPolicyPreview);
                            }
                        }

                        hideLoading();
                    });
                }
            });
        }
    }

    that.ReloadFactor = function () {
        var data = that.GetModel('ReloadFactor');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateInfoHanler.ashx", data, function (model) {
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
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateInfoHanler.ashx", data, function (model) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: '删除成功',
                callback: function () {
                    $("#RstFactorList").data("kendoGrid").setOptions({
                        dataSource: model.RstFactorList
                    });
                }
            });

            hideLoading();
        });
    }

    that.ReloadRule = function () {
        var data = that.GetModel('ReloadRule');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateInfoHanler.ashx", data, function (model) {
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
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyTemplateInfoHanler.ashx", data, function (model) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: '删除成功',
                callback: function () {
                    $("#RstRuleList").data("kendoGrid").setOptions({
                        dataSource: model.RstRuleList
                    });
                }
            });

            hideLoading();
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

        if (data.IptProductLine == '') {
            message.push('请选择产品线');
        }
        if (data.IptTemplateName == '') {
            message.push('请模板名称');
        }
        if (data.IptProTo == '') {
            message.push('请选择结算对象');
        }
        if (data.IptProTo == 'ByDealer' && data.IptProToType == '') {
            message.push('请选择结算经销商指定类型');
        }
        if (data.IptPolicyType == '') {
            message.push('请选择促销计算基数');
        }
        if (PolicyStyleSubCode == 'CXZP') {
            if (data.IptPeriod == '') {
                message.push('请选择经销商结算周期');
            }
            if (data.IptMinusLastGift == null) {
                message.push('请选择扣除上期赠品');
            }
            if (data.IptIncrement == null) {
                message.push('请选择增量计算');
            }
            if (data.IptAddLastLeft == null) {
                message.push('请选择累计上期余量');
            }
            if (data.IptTopType == 'Policy' && (data.IptTopValue == null || data.IptTopValue == '')) {
                message.push('请填写封顶值');
            }
            if (data.IptCarryType == '') {
                message.push('请选择进位方式');
            }
            if (data.IptAcquisition == null) {
                message.push('请选择计入返利与达成');
            }
            if (data.IptPointValidDateType == '') {
                message.push('经销商积分效期');
            }
        } else if (PolicyStyleSubCode == 'GDJF') {
            if (data.IptPeriod == '') {
                message.push('请选择经销商结算周期');
            }
            if (data.IptMinusLastGift == null) {
                message.push('请选择扣除上期赠品');
            }
            if (data.IptIncrement == null) {
                message.push('请选择增量计算');
            }
            if (data.IptTopType == 'Policy' && (data.IptTopValue == null || data.IptTopValue == '')) {
                message.push('请填写封顶值');
            }
            if (data.IptCarryType == '') {
                message.push('请选择进位方式');
            }
            if (data.IptAcquisition == null) {
                message.push('请选择计入返利与达成');
            }
            if (data.IptPointValidDateType == '') {
                message.push('经销商积分效期');
            }
        } else if (PolicyStyleSubCode == 'BFBJF') {
            if (data.IptPeriod == '') {
                message.push('请选择经销商结算周期');
            }
            if (data.IptMinusLastGift == null) {
                message.push('请选择扣除上期赠品');
            }
            if (data.IptIncrement == null) {
                message.push('请选择增量计算');
            }
            if (data.IptTopType == 'Policy' && (data.IptTopValue == null || data.IptTopValue == '')) {
                message.push('请填写封顶值');
            }
            if (data.IptCarryType == '') {
                message.push('请选择进位方式');
            }
            if (data.IptAcquisition == null) {
                message.push('请选择计入返利与达成');
            }
            if (data.IptPointValidDateType == '') {
                message.push('经销商积分效期');
            }
        } else if (PolicyStyleSubCode == 'BCJF') {
            if (data.IptPeriod == '') {
                message.push('请选择经销商结算周期');
            }
            if (data.IptMinusLastGift == null) {
                message.push('请选择扣除上期赠品');
            }
            if (data.IptIncrement == null) {
                message.push('请选择增量计算');
            }
            if (data.IptTopType == 'Policy' && (data.IptTopValue == null || data.IptTopValue == '')) {
                message.push('请填写封顶值');
            }
            if (data.IptCarryType == '') {
                message.push('请选择进位方式');
            }
            if (data.IptAcquisition == null) {
                message.push('请选择计入返利与达成');
            }
            if (data.IptPointValidDateType == '') {
                message.push('经销商积分效期');
            }
        }

        return message;
    }

    var setReadonly = function () {
        //促销计算基数
        $('#IptPolicyType').FrameDropdownList('disable');
        //产品线
        $('#IptProductLine').FrameDropdownList('disable');
        //政策名称
        $('#IptTemplateName').FrameTextBox('disable');
        //政策说明
        $('#IptPolicyDesc').FrameTextArea('disable');
        //结算对象
        $('#IptProTo').FrameDropdownList('disable');
        //指定类型
        $('#IptProToType').FrameDropdownList('disable');
        //经销商结算周期
        $('#IptPeriod').FrameDropdownList('disable');
        //封顶类型
        $('#IptTopType').FrameDropdownList('disable');
        //封顶值
        $('#IptTopValue').FrameNumeric('disable');
        //扣除上期赠品
        $('#IptMinusLastGift').FrameSwitch('disable');
        //进位方式
        $('#IptCarryType').FrameDropdownList('disable');
        //增量计算
        $('#IptIncrement').FrameSwitch('disable');
        //累计上期余量
        $('#IptAddLastLeft').FrameSwitch('disable');
        //YTD奖励追溯
        $('#IptYtdOption').FrameDropdownList('disable');
        //计入返利与达成
        $('#IptAcquisition').FrameSwitch('disable');
        //平台积分可用于全产品
        $('#IptUseProductForLp').FrameSwitch('disable');
        //平台积分有效期
        $('#IptPointValidDateTypeForLp').FrameLabel('disable');
        //经销商积分效期
        $('#IptPointValidDateType').FrameDropdownList('disable');
        //买减折价率
        $('#IptMjRatio').FrameNumeric('disable');

        $('#BtnAddFactor').remove();
        $('#BtnAddRule').remove();
        $('#BtnSave').remove();

        $("#RstFactorList").data("kendoGrid").hideColumn(3);
        $("#RstRuleList").data("kendoGrid").hideColumn(2);
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
        url += '&IsTemplate=True';

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
        url += '&IsTemplate=True';

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

    var initColumnLayout = function () {
        //IptPolicyType:促销计算基数
        //IptProTo:结算对象
        if ($('#IptPolicyType').FrameDropdownList('getValue') == '采购赠') {
            $('#IptProTo').FrameDropdownList('disable');
            //结算对象的div
            $('#TrProToType').show();
        } else {
            $('#IptProTo').FrameDropdownList('enable');
        }

        if ($('#IptProTo').FrameDropdownList('getValue') == 'ByDealer') {
            $('#TrProToType').show();
        } else {
            $('#TrProToType').hide();
        }

        if ($('#IptTopType').FrameDropdownList('getValue') == 'Policy') {
            $('#TdTopType').hide();
            $('#TrTopValue').show();
        } else if ($('#IptTopType').FrameDropdownList('getValue') == 'Dealer' || $('#IptTopType').FrameDropdownList('getValue') == 'Hospital') {
            $('#TdTopType').show();
            $('#TrTopValue').hide();
        } else {
            $('#TdTopType').hide();
            $('#TrTopValue').hide();
        }
    }

    var createFactorList = function (model) {
        $("#RstFactorList").kendoGrid({
            dataSource: model.RstFactorList,
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

    var createRuleList = function (model) {
        $("#RstRuleList").kendoGrid({
            dataSource: model.RstRuleList,
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

    var setLayout = function () {
        var h = $('.content-main').height();
        $('.PolicyTab').height(h - 35);

        $("#RstFactorList").data("kendoGrid").setOptions({
            height: h - 145
        });
        $("#RstRuleList").data("kendoGrid").setOptions({
            height: h - 185
        });
    }

    return that;
}();
