var PolicyInfo = {};

PolicyInfo = function () {
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

        var showPreview = $.getUrlParam('ShowPreview');

        var data = that.GetModel('InitPage');
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
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
            //是否新增
            $('#IsPageNew').val(model.IsPageNew);
            //政策状态
            $('#IptPromotionState').val(model.IptPromotionState);
            //政策编号
            $('#IptPolicyNo').FrameLabel({
                value: model.IptPolicyNo
            });
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
            //SubBU
            $('#IptSubBu').FrameDropdownList({
                dataSource: model.LstSubBu,
                dataKey: 'SubBUCode',
                dataValue: 'SubBUName',
                selectType: 'select',
                value: model.IptSubBu
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
            //$('#IptMinusLastGift').FrameDropdownList({
            //    dataSource: [{ Key: 'Y', Value: '是' }, { Key: 'N', Value: '否' }],
            //    dataKey: 'Key',
            //    dataValue: 'Value',
            //    value: model.IptMinusLastGift
            //});
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
            //$('#IptIncrement').FrameDropdownList({
            //    dataSource: [{ Key: 'Y', Value: '是' }, { Key: 'N', Value: '否' }],
            //    dataKey: 'Key',
            //    dataValue: 'Value',
            //    value: model.IptIncrement
            //});
            //累计上期余量
            $('#IptAddLastLeft').FrameSwitch({
                value: model.IptAddLastLeft
            });
            //$('#IptAddLastLeft').FrameDropdownList({
            //    dataSource: [{ Key: 'N', Value: '否' }, { Key: 'Y', Value: '是' }],
            //    dataKey: 'Key',
            //    dataValue: 'Value',
            //    value: model.IptAddLastLeft
            //});
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
            //$('#IptAcquisition').FrameDropdownList({
            //    dataSource: [{ Key: 'Y', Value: '是' }, { Key: 'N', Value: '否' }],
            //    dataKey: 'Key',
            //    dataValue: 'Value',
            //    value: model.IptAcquisition
            //});
            //平台积分可用于全产品
            $('#IptUseProductForLp').FrameSwitch({
                value: model.IptUseProductForLp
            });

            //平台积分有效期
            //{ Key: 'Always', Value: '始终有效' }, { Key: 'AccountMonth', Value: '账期延展' }, { Key: 'AbsoluteDate', Value: '固定日期' }
            //$('#IptPointValidDateTypeForLp').FrameDropdownList({
            //    dataSource: [{ Key: 'OneQuarter', Value: '当前账期延展1个季度' }, { Key: 'Always', Value: '当年有效' }, { Key: 'AccountMonth', Value: '账期有效' }, { Key: 'AbsoluteDate', Value: '结算周期的次季度有效' }],
            //    dataKey: 'Key',
            //    dataValue: 'Value',
            //    selectType: 'OneQuarter',
            //    value: model.IptPointValidDateTypeForLp,
            //    //onChange: that.ChangePointValidDateTypeForLp
            //});
            $('#IptPointValidDateTypeForLp').FrameLabel({
                value: '当前账期延展1个季度'
            });
            //跨度-平台
            //$('#IptPointValidDateDurationForLp').FrameDropdownList({
            //    dataSource: [{ Key: '1', Value: '1个月' }, { Key: '2', Value: '2个月' }, { Key: '3', Value: '3个月' }, { Key: '4', Value: '4个月' }, { Key: '5', Value: '5个月' }, { Key: '6', Value: '6个月' }, { Key: '7', Value: '7个月' }, { Key: '8', Value: '8个月' }, { Key: '9', Value: '9个月' }, { Key: '10', Value: '10个月' }, { Key: '11', Value: '11个月' }, { Key: '12', Value: '12个月' }],
            //    dataKey: 'Key',
            //    dataValue: 'Value',
            //    value: model.IptPointValidDateDurationForLp
            //});
            //日期-平台
            //$('#IptPointValidDateAbsoluteForLp').FrameDatePicker({
            //    value: model.IptPointValidDateAbsoluteForLp
            //});
            //一/二级积分效期
            $('#IptPointValidDateType').FrameDropdownList({
                dataSource: [{ Key: 'Year', Value: '当年有效' }, { Key: 'HalfYear', Value: '半年有效' }, { Key: 'Quarter', Value: '结算周期的次季度有效' }],
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'select',
                value: model.IptPointValidDateType
                //onChange: that.ChangePointValidDateType
            });

            //跨度
            //$('#IptPointValidDateDuration').FrameDropdownList({
            //    dataSource: [{ Key: '1', Value: '1个月' }, { Key: '2', Value: '2个月' }, { Key: '3', Value: '3个月' }, { Key: '4', Value: '4个月' }, { Key: '5', Value: '5个月' }, { Key: '6', Value: '6个月' }, { Key: '7', Value: '7个月' }, { Key: '8', Value: '8个月' }, { Key: '9', Value: '9个月' }, { Key: '10', Value: '10个月' }, { Key: '11', Value: '11个月' }, { Key: '12', Value: '12个月' }],
            //    dataKey: 'Key',
            //    dataValue: 'Value',
            //    value: model.IptPointValidDateDuration
            //});
            //日期
            //$('#IptPointValidDateAbsolute').FrameDatePicker({
            //    value: model.IptPointValidDateAbsolute
            //});
            //买减折价率
            $('#IptMjRatio').FrameNumeric({
                value: model.IptMjRatio
            });
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
            createAttachmentList(model);

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
                    if (step == 0 && model.IsCanEdit) {
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
                    if (model.IsCanEdit) {
                        that.Save(true, true);
                    } else {
                        ++step;
                        tabStrip.select(step);

                        $(".Step").hide();
                        $(".Step" + step).show();
                    }
                }
            });
            $('#BtnSubmit').FrameButton({
                onClick: function () {
                    that.Submit();
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
            //二级加价率
            $('#BtnPointRatio').FrameButton({
                onClick: function () {

                    openSecondRate();
                }
            });
            $('#BtnAddRule').FrameButton({
                onClick: function () {
                    openRule('true');
                }
            });

            $('#files').kendoUpload({
                async: {
                    // $.getUrlParam('PolicyId') 
                    saveUrl: Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyAttachment.ashx?ForeignType=Promotion&ActionType=SecondRate&PolicyId=" + $('#IptPolicyId').val(),
                    autoUpload: true
                },
                //localization: {
                //    select: "上传文件",
                //},
                select: function (e) {
                    showLoading();
                },
                multiple: false,
                success: that.ReloadAttachment
            });

            that.ChangeProToType();
            $('#BtnAddAttachment').FrameButton({
                onClick: function () {
                    //showLoading();
                    document.getElementById('files').click();

                }
            });
            //指定经销商维护
            $('#BtnProToType').FrameButton({
                onClick: openAppointedDealer

            });
            //封顶类型
            $('#BtnTopType').FrameButton({
                onClick: function () {

                    openCapType();
                }
            });

            isCanEdit = model.IsCanEdit;
            if (isCanEdit == false) {
                isSaved = true;
                setReadonly();

                $('#PnlPreview').html(model.IptPolicyPreview);
            } else {
                if (model.IptPolicyNo != '系统自动生成') {
                    isSaved = true;
                    $('#IptProductLine').FrameDropdownList('disable');
                    $('#IptSubBu').FrameDropdownList('disable');
                    $('#IptPolicyType').FrameDropdownList('disable');
                } else {
                    isSaved = false;
                }
            }

            LstPolicyGeneralDesc = model.LstPolicyGeneralDesc;
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
                        $.each(LstPolicyGeneralDesc, function (i, n) {
                            if (n.Level2 == pointFor && n.Level3 == $('#' + controlId + '_Control').data("kendoDropDownList").value()) {
                                $('#IptDesc' + group).html(n.DescContent);
                            }
                        });
                    });

                    $('#' + controlId + '_Control').on('change', function () {
                        $('#Pnl' + group).find('.Pointer').addClass("PointerNone");
                        $('#Pnl' + group).find('.Pointer[for="' + pointFor + '"]').removeClass("PointerNone");

                        $('#IptDesc' + group).html('');
                        $.each(LstPolicyGeneralDesc, function (i, n) {
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
                tabStrip.disable(tabStrip.tabGroup.children().eq(4));
                $('.TabStep').addClass('k-state-default');
            } else {
                $('.TabStep').on('click', function () {
                    var to = $(this).attr('step');

                    step = to;

                    $(".Step").hide();
                    $(".Step" + step).show();
                });
            }

            if (showPreview == 'false') {
                tabStrip.select(0);
                $(".Step").hide();
                $(".Step0").show();
            } else {
                tabStrip.select(4);
                step = 4;
                $(".Step").hide();
                $(".Step4").show();
            }

            $(window).resize(function () {
                setLayout();
            })
            setLayout();

            hideLoading();
        });
    }

    that.ReloadAttachment = function () {
        var data = that.GetModel('ReloadAttachment');

        //showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
            $("#RstAttachmentList").data("kendoGrid").setOptions({
                dataSource: model.RstAttachmentList
            });

            hideLoading();
        });
    };

    //附件
    openAttach = function () {
        document.getElementById('files').click();
        //var url = 'PagesKendo/Promotion/MaintainAttachment.aspx?';
        //url += '&PolicyId=' + escape($('#IptPolicyId').val());
        ////callback: that.ReloadFactor
        //openWindow({
        //    target: 'this',
        //    title: '政策附件导入',
        //    url: Common.AppVirtualPath + url,
        //    width: 700,
        //    height: 260,
        //    actions: ["Close"],
        //    callback: that.ReloadAttachment
        //});
    }
    //封顶值
    var openCapType = function () {
        var url = 'PagesKendo/Promotion/MaintainCapType.aspx?';
        url += 'PolicyId=' + escape($('#IptPolicyId').val());
        url += '&TopType=' + escape($('#IptTopType').FrameDropdownList('getValue'));
        // IptTopType 要传一封顶值类型
        openWindow({
            target: 'this',
            title: '政策赠送封顶值导入',
            url: Common.AppVirtualPath + url,
            width: 800,
            height: 560,
            actions: ["Close"]
        });
    }

    //维护平台到二级加价率
    var openSecondRate = function () {
        var url = 'PagesKendo/Promotion/MaintainSecondRate.aspx?';
        url += 'PolicyId=' + escape($('#IptPolicyId').val());
        //$.getUrlParam('PolicyId')
        openWindow({
            target: 'this',
            title: '本政策二级到平台积分加价率维护',
            url: Common.AppVirtualPath + url,
            width: 800,
            height: 560,
            actions: ["Close"]
        });
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
            url += '&SubBu=' + escape(data.IptSubBu);
            url += '&PageType=' + escape($('#IptPageType').val());
            url += '&PromotionState=' + escape($('#IptPromotionState').val());

            if (isSaved) {
                openWindow({
                    target: 'this',
                    title: '政策适用对象',
                    url: Common.AppVirtualPath + url,
                    width: 800,
                    height: 560,
                    actions: ["Close"]
                });
            } else {
                showConfirm({
                    target: 'top',
                    message: '维护经销商后产品线和SubBU将不可更改，确定继续吗？',
                    confirmCallback: function () {
                        $('#IptProductLine').FrameDropdownList('disable');
                        $('#IptSubBu').FrameDropdownList('disable');

                        openWindow({
                            target: 'this',
                            title: '政策适用对象',
                            url: Common.AppVirtualPath + url,
                            width: 800,
                            height: 560,
                            actions: ["Close"]
                        });
                    }
                });
            }
        }
    }

    that.ChangeProductLine = function () {
        var data = that.GetModel('ChangeProductLine');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
            $('#IptSubBu').FrameDropdownList('setDataSource', model.LstSubBu);

            hideLoading();
        });
    }

    that.ChangePolicyType = function () {
        var data = that.GetModel('ChangePolicyType');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
            if ($('#IptPolicyType').FrameDropdownList('getValue') == '采购赠') {
                $('#IptProTo').FrameDropdownList('setValue', 'ByDealer');
                $('#IptProTo').FrameDropdownList('disable');
                $('#TrProToType').show();
                $('#IptProToType').FrameDropdownList('setValue', '');
                $('#TrBtnProToType').hide();
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

    that.ChangeTopType = function () {
        var data = that.GetModel('ChangeTopType');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
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
        });
    }

    //that.ChangePointValidDateTypeForLp = function () {
    //    showLoading();

    //    //$('#IptPointValidDateDurationForLp').FrameDropdownList('setValue', '');
    //    //$('#IptPointValidDateAbsoluteForLp').FrameDatePicker('setValue', '');

    //   //// if ($('#IptPointValidDateTypeForLp').FrameDropdownList('getValue') == 'AbsoluteDate') {
    //   //  //   $('#TrPointValidDateDurationForLp').hide();
    //   //   //  $('#TrPointValidDateAbsoluteForLp').show();
    //   // } else if ($('#IptPointValidDateTypeForLp').FrameDropdownList('getValue') == 'AccountMonth') {
    //   //     $('#TrPointValidDateDurationForLp').show();
    //   //     $('#TrPointValidDateAbsoluteForLp').hide();
    //   // } else {
    //   //     $('#TrPointValidDateDurationForLp').hide();
    //   //     $('#TrPointValidDateAbsoluteForLp').hide();
    //   // }

    //    hideLoading();
    //}

    //that.ChangePointValidDateType = function () {
    //    showLoading();

    //    $('#IptPointValidDateDuration').FrameDropdownList('setValue', '');
    //    $('#IptPointValidDateAbsolute').FrameDatePicker('setValue', '');

    //    if ($('#IptPointValidDateType').FrameDropdownList('getValue') == 'AbsoluteDate') {
    //        $('#TrPointValidDateDuration').hide();
    //        $('#TrPointValidDateAbsolute').show();
    //    } else if ($('#IptPointValidDateType').FrameDropdownList('getValue') == 'AccountMonth') {
    //        $('#TrPointValidDateDuration').show();
    //        $('#TrPointValidDateAbsolute').hide();
    //    } else {
    //        $('#TrPointValidDateDuration').hide();
    //        $('#TrPointValidDateAbsolute').hide();
    //    }

    //    hideLoading();
    //}

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
                ConfirmMessage = '确定保存促销政策吗？'
            } else {
                ConfirmMessage = '请确认产品线、SubBU和促销计算基数填写正确，保存后将不能修改。'
            }

            showConfirm({
                target: 'top',
                message: ConfirmMessage,
                confirmCallback: function () {
                    showLoading();
                    submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
                        if (!isSaved) {
                            $('#IptProductLine').FrameDropdownList('disable');
                            $('#IptSubBu').FrameDropdownList('disable');
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

    that.Submit = function () {
        var data = that.GetModel('Submit');

        var message = checkPolicy(data);
        if (message.length > 0) {
            showAlert({
                target: 'top',
                alertType: 'warning',
                message: message
            });
        } else {
            showConfirm({
                target: 'top',
                message: '确定提交此政策吗？',
                confirmCallback: function () {
                    showLoading();
                    submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
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
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
            $("#RstFactorList").data("kendoGrid").setOptions({
                dataSource: model.RstFactorList
            });

            hideLoading();
        });
    }

    that.ReloadAttachment = function () {
        var data = that.GetModel('ReloadAttachment');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
            $("#RstAttachmentList").data("kendoGrid").setOptions({
                dataSource: model.RstAttachmentList
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
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
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
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
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
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
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

    that.RemoveAttachment = function (attachmentId, attachmentName) {
        var data = that.GetModel('RemoveAttachment');
        data.IptAttachmentId = attachmentId;
        data.IptAttachmentName = attachmentName;

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/PolicyInfoHanler.ashx", data, function (model) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: '删除成功',
                callback: function () {
                    $("#RstAttachmentList").data("kendoGrid").setOptions({
                        dataSource: model.RstAttachmentList
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
        if (data.IptPolicyName == '') {
            message.push('请归类名称');
        }
        if (data.IptBeginDate == null) {
            message.push('请填写开始时间');
        }
        if (data.IptEndDate == null) {
            message.push('请填写终止时间');
        }
        if (data.IptProTo == '') {
            message.push('请选择结算对象');
        }
        if (data.IptProTo == 'ByDealer' && data.IptProToType == '') {
            message.push('请选择指定类型');
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
            // if (data.IptPointValidDateTypeForLp == '') {
            //    message.push('请选择平台积分有效期');
            //}
            //if (data.IptPointValidDateTypeForLp == 'AccountMonth' && data.IptPointValidDateDurationForLp == '') {
            //    message.push('请选择跨度-平台');
            //}
            //if (data.IptPointValidDateTypeForLp == 'AbsoluteDate' && data.IptPointValidDateAbsoluteForLp == '') {
            //    message.push('请填写日期-平台');
            //}
            //if (data.IptPointValidDateType == '') {
            //    message.push('经销商积分效期');
            //}
            // if (data.IptPointValidDateType == 'AccountMonth' && data.IptPointValidDateDuration == '') {
            //    message.push('请选择跨度');
            // }
            // if (data.IptPointValidDateType == 'AbsoluteDate' && data.IptPointValidDateAbsolute == '') {
            //      message.push('请填写日期');
            // }
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
            //if (data.IptPointValidDateTypeForLp == '') {
            //    message.push('请选择平台积分有效期');
            // }
            // if (data.IptPointValidDateTypeForLp == 'AccountMonth' && data.IptPointValidDateDurationForLp == '') {
            //    message.push('请选择跨度-平台');
            //}
            // if (data.IptPointValidDateTypeForLp == 'AbsoluteDate' && data.IptPointValidDateAbsoluteForLp == '') {
            //    message.push('请填写日期-平台');
            // }
            if (data.IptPointValidDateType == '') {
                message.push('经销商积分效期');
            }
            // if (data.IptPointValidDateType == 'AccountMonth' && data.IptPointValidDateDuration == '') {
            //     message.push('请选择跨度');
            // }
            // if (data.IptPointValidDateType == 'AbsoluteDate' && data.IptPointValidDateAbsolute == '') {
            //     message.push('请填写日期');
            // }
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
            //if (data.IptPointValidDateTypeForLp == '') {
            //   message.push('请选择平台积分有效期');
            //}
            // if (data.IptPointValidDateTypeForLp == 'AccountMonth' && data.IptPointValidDateDurationForLp == '') {
            //     message.push('请选择跨度-平台');
            //  }
            //  if (data.IptPointValidDateTypeForLp == 'AbsoluteDate' && data.IptPointValidDateAbsoluteForLp == '') {
            //      message.push('请填写日期-平台');
            // }
            if (data.IptPointValidDateType == '') {
                message.push('经销商积分效期');
            }
            //  if (data.IptPointValidDateType == 'AccountMonth' && data.IptPointValidDateDuration == '') {
            //     message.push('请选择跨度');
            // }
            // if (data.IptPointValidDateType == 'AbsoluteDate' && data.IptPointValidDateAbsolute == '') {
            //      message.push('请填写日期');
            //  }
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
            //if (data.IptMjRatio == null || data.IptMjRatio == '') {
            //    message.push('请填写特殊折价率');
            //}
            //if (data.IptPointValidDateTypeForLp == '') {
            //    message.push('请选择平台积分有效期');
            // }
            // if (data.IptPointValidDateTypeForLp == 'AccountMonth' && data.IptPointValidDateDurationForLp == '') {
            //     message.push('请选择跨度-平台');
            //  }
            //  if (data.IptPointValidDateTypeForLp == 'AbsoluteDate' && data.IptPointValidDateAbsoluteForLp == '') {
            //     message.push('请填写日期-平台');
            //  }
            if (data.IptPointValidDateType == '') {
                message.push('经销商积分效期');
            }
            //  if (data.IptPointValidDateType == 'AccountMonth' && data.IptPointValidDateDuration == '') {
            //       message.push('请选择跨度');
            //    }
            //   if (data.IptPointValidDateType == 'AbsoluteDate' && data.IptPointValidDateAbsolute == '') {
            //      message.push('请填写日期');
            //   }
        }

        return message;
    }

    var setReadonly = function () {
        //促销计算基数
        $('#IptPolicyType').FrameDropdownList('disable');
        //产品线
        $('#IptProductLine').FrameDropdownList('disable');
        //SubBU
        $('#IptSubBu').FrameDropdownList('disable');
        //政策名称
        $('#IptPolicyName').FrameTextBox('disable');
        //分组名称
        $('#IptPolicyGroupName').FrameTextBox('disable');
        //开始时间
        $('#IptBeginDate').FrameDatePicker('disable');
        //终止时间
        $('#IptEndDate').FrameDatePicker('disable');
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
        //$('#IptPointValidDateTypeForLp').FrameLabel('disable');
        //跨度-平台
        //$('#IptPointValidDateDurationForLp').FrameDropdownList('disable');
        //日期-平台
        // $('#IptPointValidDateAbsoluteForLp').FrameDatePicker('disable');
        //一/二级积分效期
        $('#IptPointValidDateType').FrameDropdownList('disable');
        //跨度
        // $('#IptPointValidDateDuration').FrameDropdownList('disable');
        //日期
        // $('#IptPointValidDateAbsolute').FrameDatePicker('disable');
        //买减折价率
        $('#IptMjRatio').FrameNumeric('disable');

        $('#BtnAddFactor').remove();
        $('#BtnAddRule').remove();
        $('#BtnSave').remove();
        $('#BtnSubmit').remove();
        $('#BtnAddAttachment').remove();
        $('#files').data("kendoUpload").destroy();
        //$('#files').remove();
        //$('.k-upload').remove();

        $("#RstFactorList").data("kendoGrid").hideColumn(3);
        $("#RstRuleList").data("kendoGrid").hideColumn(2);
        $("#RstAttachmentList").data("kendoGrid").hideColumn(5);
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

    var initColumnLayout = function () {
        //IptPolicyType:促销计算基数
        //IptProTo:结算对象
        if ($('#IptPolicyType').FrameDropdownList('getValue') == '采购赠') {
            $('#IptProTo').FrameDropdownList('disable');
            //结算对象的div
            $('#TrProToType').show();
            //指定类型维护按钮
            $('#TrBtnProToType').hide();
        } else {
            $('#IptProTo').FrameDropdownList('enable');
        }

        if ($('#IptProTo').FrameDropdownList('getValue') == 'ByDealer') {
            $('#TrProToType').show();
            $('#TrBtnProToType').hide();
        } else {
            $('#TrProToType').hide();
        }

        if ($('#IptProToType').FrameDropdownList('getValue') == 'ByDealer') {
            $('#TrBtnProToType').show();
        } else {
            $('#TrBtnProToType').show();
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
        ////平台积分有效期：IptPointValidDateTypeForLp
        //if ($('#IptPointValidDateTypeForLp').FrameDropdownList('getValue') == 'AbsoluteDate') {
        //    //跨度平台
        //    $('#TrPointValidDateDurationForLp').hide();
        //    //日期平台
        //    $('#TrPointValidDateAbsoluteForLp').show();
        //} else if ($('#IptPointValidDateTypeForLp').FrameDropdownList('getValue') == 'AccountMonth') {
        //    $('#TrPointValidDateDurationForLp').show();
        //    $('#TrPointValidDateAbsoluteForLp').hide();
        //} else {
        //    $('#TrPointValidDateDurationForLp').hide();
        //    $('#TrPointValidDateAbsoluteForLp').hide();
        //}
        //一/二级积分效期:IptPointValidDateType
        //if ($('#IptPointValidDateType').FrameDropdownList('getValue') == 'AbsoluteDate') {
        //    $('#TrPointValidDateDuration').hide();
        //    $('#TrPointValidDateAbsolute').show();
        //} else if ($('#IptPointValidDateType').FrameDropdownList('getValue') == 'AccountMonth') {
        //    $('#TrPointValidDateDuration').show();
        //    $('#TrPointValidDateAbsolute').hide();
        //} else {
        //    $('#TrPointValidDateDuration').hide();
        //    $('#TrPointValidDateAbsolute').hide();
        //}
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

    var createAttachmentList = function (model) {
        $("#RstAttachmentList").kendoGrid({
            dataSource: model.RstAttachmentList,
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

    var setLayout = function () {
        var h = $('.content-main').height();
        $('.PolicyTab').height(h - 35);

        $("#RstFactorList").data("kendoGrid").setOptions({
            height: h - 145
        });
        $("#RstRuleList").data("kendoGrid").setOptions({
            height: h - 185
        });
        $("#RstAttachmentList").data("kendoGrid").setOptions({
            height: h - 145
        });
    }

    return that;
}();
