var RuleInfo = {};

RuleInfo = function () {
    var that = {};
    var LstRuleDesc = [];
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
        $('#IptPolicyRuleId').val($.getUrlParam('PolicyRuleId'));
        $('#IptPolicyStyle').val($.getUrlParam('PolicyStyle'));
        $('#IptPolicyStyleSub').val($.getUrlParam('PolicyStyleSub'));
        $('#IptPageType').val($.getUrlParam('PageType'));
        $('#IptPromotionState').val($.getUrlParam('PromotionState'));

        var data = that.GetModel('InitPage');
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/RuleInfoHanler.ashx", data, function (model) {
            $('#IptPolicyId').val(model.IptPolicyId);
            //是否新增
            $('#IsPageNew').val(model.IsPageNew);
            //规则描述
            $('#IptDesc').FrameTextArea({
                rows: 2,
                value: model.IptDesc
            });
            $('#IptPolicyFactorX').FrameDropdownList({
                dataSource: model.LstPolicyFactorX,
                dataKey: 'PolicyFactorId',
                dataValue: 'FactName',
                selectType: 'select',
                value: model.IptPolicyFactorX,
                onChange: that.ChangePolicyFactorX
            });
            $('#IptFactorRemarkX').FrameTextBox({
                value: model.IptFactorRemarkX
            });
            $('#IptFactorRemarkX').FrameTextBox('disable');
            $('#IptPolicyFactorY').FrameDropdownList({
                dataSource: model.LstPolicyFactorY,
                dataKey: 'GiftPolicyFactorId',
                dataValue: 'FactName',
                selectType: 'select',
                value: model.IptPolicyFactorY
            });
            $('#IptPolicyFactorY').FrameDropdownList('disable');
            $('#IptFactorRemarkY').FrameTextBox({
                value: model.IptFactorRemarkY
            });
            $('#IptFactorRemarkY').FrameTextBox('disable');
            $('#IptFactorRemarkY').FrameTextBox('disable');
            $('#IptFactorValueX').FrameNumeric({
                decimals: 4,
                format: '0.0000',
                value: model.IptFactorValueX
            });
            $('#IptFactorValueY').FrameNumeric({
                decimals: 4,
                format: '0.0000',
                value: model.IptFactorValueY
            });
            $('#IptPointValue').FrameTextBox({
                value: model.IptPointValue
            });
            $('#IptPointType').FrameDropdownList({
                dataSource: [{ 'key': '采购价', 'value': '按采购价' }, { 'key': '经销商固定积分', 'value': '按经销商固定积分转换' }],
                dataKey: 'key',
                dataValue: 'value',
                selectType: 'select',
                value: model.IptPointType
            });
            $('#IptPointType').on('change', function () {
                if (model.IsTemplate != 'True' && $('#IptPointType').FrameDropdownList('getValue') == '经销商固定积分')
                {                  
                    $('#TdProToType').show();
                }
                else if ($('#IptPointType').FrameDropdownList('getValue') == '采购价') {
                    $('#TdProToType').hide();
                }
                else {
                    $('#TdProToType').hide();
                }
            });
            $('#BtnProToType').FrameButton({
                onClick:function(){
                    PointTypeDownLoad();
                }
                    
            })
            var PolicyStyleSubCode = getPolicyStyleSubCode(model.IptPolicyStyleSub);

            $('.' + PolicyStyleSubCode).show();
            $('.' + PolicyStyleSubCode).attr('visible', 'true');
            $('#PnlBasic').find("tr[visible='false']").remove();

            //if (PolicyStyleSubCode == 'CXZP') {
            //    $('#IptDesc').FrameTextArea("setHeight", "50");
            //} else if (PolicyStyleSubCode == 'GDJF') {
            //    $('#IptDesc').FrameTextArea("setHeight", "110");
            //} else if (PolicyStyleSubCode == 'BFBJF') {
            //    $('#IptDesc').FrameTextArea("setHeight", "140");
            //} else if (PolicyStyleSubCode == 'BCJF') {

            //} else if (PolicyStyleSubCode == 'SZP') {
            //    $('#IptDesc').FrameTextArea("setHeight", "50");
            //} else if (PolicyStyleSubCode == 'DZ') {
            //    $('#IptDesc').FrameTextArea("setHeight", "140");
            //}
            //LstRuleDesc = model.LstRuleDesc;
            //$('.CellInput').each(function (index) {
            //    var controlId = $(this).attr("id");
            //    var pointFor = $(this).attr("for");
            //    var group = $(this).attr('group');
            //    $(this).on('click', function () {
            //        var pointFor = $(this).attr("for");
            //        var group = $(this).attr('group');

            //        $('#Pnl' + group).find('.Pointer').addClass("PointerNone");
            //        $('#Pnl' + group).find('.Pointer[for="' + pointFor + '"]').removeClass("PointerNone");

            //        $('#IptDesc' + group).html('');
            //        $.each(LstRuleDesc, function (i, n) {
            //            if (n.Level2 == pointFor) {
            //                $('#IptDesc' + group).html(n.DescContent)
            //            }

            //        });
            //    });

            //});

            $('#BtnDemoInfo').FrameButton({
                onClick: function () {
                    showDemo();
                }
            });
            if (model.IsPageNew == 'false') {
                $('#IptPolicyConditionFacter').FrameDropdownList({
                    dataSource: model.LstPolicyConditionFacter,
                    dataKey: 'PolicyFactorId',
                    dataValue: 'FactName',
                    selectType: 'select'
                });
                $('#IptSymbol').FrameDropdownList({
                    dataSource: model.LstSymbol,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select'
                });
                $('#IptValueType').FrameDropdownList({
                    dataSource: model.LstValueType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    onChange: that.ChangeValueType
                });
                $('#IptRefValue1').FrameDropdownList({
                    dataSource: model.LstRefValue1,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select'
                });
                $('#IptRefValue2').FrameDropdownList({
                    dataSource: model.LstRefValue2,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select'
                });
                $('#IptValue1').FrameNumeric({});
                $('#IptValue2').FrameNumeric({});
                $('#IptCompareFacter').FrameDropdownList({
                    dataSource: model.LstCompareFacter,
                    dataKey: 'PolicyFactorId',
                    dataValue: 'FactName',
                    selectType: 'select'
                });
                $('#IptCompareFacterRatio').FrameNumeric({});

                $('#PnlDetail').show();

                createFactorConditionList(model);
                ruleConditionId = model.IptConditionMaxId;
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
            $('#BtnConditionSave').FrameButton({
                onClick: that.SaveDetail
            });
            $('#BtnConditionBack').FrameButton({
                onClick: function () {
                    $("#PnlConditionInfo, #PnlConditionList").slideToggle();

                    $("#PnlRuleButton, #PnlDetailButton").toggle();

                    $("#RstRuleDetail").data("kendoGrid").setOptions({
                        height: 119
                    });
                }
            });
            $('#BtnAddCondition').FrameButton({
                onClick: function () {
                    that.ShowCondition('');
                }
            });

            isCanEdit = model.IsCanEdit;
            if (isCanEdit == false) {
                setReadonly();
            }

            LstRuleDesc = model.LstRuleDesc;
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
                        $.each(LstRuleDesc, function (i, n) {
                            if (n.Level2 == pointFor && n.Level3 == $('#' + controlId + '_Control').data("kendoDropDownList").value()) {
                                $('#IptDesc' + group).html(n.DescContent);
                            }
                        });
                    });

                    $('#' + controlId + '_Control').on('change', function () {
                        $('#Pnl' + group).find('.Pointer').addClass("PointerNone");
                        $('#Pnl' + group).find('.Pointer[for="' + pointFor + '"]').removeClass("PointerNone");

                        $('#IptDesc' + group).html('');
                        $.each(LstRuleDesc, function (i, n) {
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
                        $.each(LstRuleDesc, function (i, n) {
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

     var PointTypeDownLoad = function () {
        //需要知道选择的key

            var url = 'PagesKendo/Promotion/MaintainUploadFixedChange.aspx?';
            url += 'PolicyId=' + escape($('#IptPolicyId').val());
            url += '&PolicyRuleId=' + escape($('#IptPolicyRuleId').val());
            url += '&ConditionId=' + escape($('#IptConditionId').val());
            console.log(url);
            // IptTopType 要传一封顶值类型
            openWindow({
                target: 'top',
                title: '固定积分转换率',
                url: Common.AppVirtualPath + url,
                width: 800,
                height: 560,
                actions: ["Close"]
            });
        
    }
    that.ChangePolicyFactorX = function () {
        $('#IptFactorRemarkX').FrameTextBox('setValue', '');
        var data = $('#IptPolicyFactorX_Control').data("kendoDropDownList").dataSource.options.data;
        $.each(data, function (i, n) {
            if (n.PolicyFactorId == $('#IptPolicyFactorX').FrameDropdownList('getValue')) {
                $('#IptFactorRemarkX').FrameTextBox('setValue', n.FactDesc);
            }
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
            showLoading();
            submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/RuleInfoHanler.ashx", data, function (model) {
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '保存成功',
                    callback: function () {
                        if (model.IsPageNew == 'true') {
                            var url = 'PagesKendo/Promotion/RuleInfo.aspx?';
                            url += 'PolicyId=' + model.IptPolicyId;
                            url += '&IsPageNew=false';
                            url += '&PolicyRuleId=' + model.IptPolicyRuleId;
                            url += '&PolicyStyle=' + escape(model.IptPolicyStyle);
                            url += '&PolicyStyleSub=' + escape(model.IptPolicyStyleSub);
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

    that.SaveDetail = function () {
        var data = that.GetModel('SaveDetail');

        var message = checkDetail(data);

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
            showLoading();
            submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/RuleInfoHanler.ashx", data, function (model) {
                showAlert({
                    target: 'top',
                    alertType: 'info',
                    message: '保存成功',
                    callback: function () {
                        $("#PnlConditionInfo, #PnlConditionList").slideToggle();

                        $("#PnlRuleButton, #PnlDetailButton").toggle();

                        $("#RstRuleDetail").data("kendoGrid").setOptions({
                            dataSource: model.RstRuleDetail,
                            height: 119
                        });
                    }
                });

                hideLoading();
            });
        }
    }

    that.RemoveCondition = function () {
        var data = that.GetModel('RemoveCondition');

        showLoading();
        submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/RuleInfoHanler.ashx", data, function (model) {
            showAlert({
                target: 'top',
                alertType: 'info',
                message: '删除成功',
                callback: function () {
                    $("#RstRuleDetail").data("kendoGrid").setOptions({
                        dataSource: model.RstRuleDetail,
                        height: 119
                    });
                }
            });

            hideLoading();
        });
    }

    that.ShowCondition = function (conditionId) {
        console.log(conditionId);
        $('#BtnDemoInfo').text("显示示例");
        $('#DemoInfo').hide();

        $('#IptConditionId').val(conditionId);
        var data = that.GetModel('ShowCondition');

        if (conditionId == '') {
            $('#IptPolicyConditionFacter').FrameDropdownList('setValue', '');
            $('#IptSymbol').FrameDropdownList('setValue', '');
            $('#IptValueType').FrameDropdownList('setValue', '');
            $('#IptRefValue1').FrameDropdownList('setValue', '');
            $('#IptRefValue2').FrameDropdownList('setValue', '');
            $('#IptValue1').FrameNumeric('setValue', '');
            $('#IptValue2').FrameNumeric('setValue', '');
            $('#IptCompareFacter').FrameDropdownList('setValue', '');
            $('#IptCompareFacterRatio').FrameNumeric('setValue', '');

            that.ChangeValueType();

            $("#PnlConditionInfo, #PnlConditionList").slideToggle();

            $("#PnlRuleButton, #PnlDetailButton").toggle();
        } else {
            showLoading();
            submitAjax(Common.AppVirtualPath + "PagesKendo/Promotion/Handler/RuleInfoHanler.ashx", data, function (model) {
                $("#PnlConditionInfo, #PnlConditionList").slideToggle();

                $("#PnlRuleButton, #PnlDetailButton").toggle();

                $('#IptPolicyConditionFacter').FrameDropdownList('setValue', model.IptPolicyConditionFacter);
                $('#IptSymbol').FrameDropdownList('setValue', model.IptSymbol);
                $('#IptValueType').FrameDropdownList('setValue', model.IptValueType);
                $('#IptRefValue1').FrameDropdownList('setValue', model.IptRefValue1);
                $('#IptRefValue2').FrameDropdownList('setValue', model.IptRefValue2);
                $('#IptValue1').FrameNumeric('setValue', model.IptValue1);
                $('#IptValue2').FrameNumeric('setValue', model.IptValue2);
                $('#IptCompareFacter').FrameDropdownList('setValue', model.IptCompareFacter);
                $('#IptCompareFacterRatio').FrameNumeric('setValue', model.IptCompareFacterRatio);

                that.ChangeValueType();

                hideLoading();
            });
        }
    }

    that.ChangeValueType = function () {
        var valueType = $('#IptValueType').FrameDropdownList('getValue');
        if (valueType == 'AbsoluteValue') {
            $('#TrRefValue1').hide();
            $('#TrRefValue2').hide();
            $('#TrValue1').show();
            $('#TrValue2').show();
            $('#TrCompareFacter').hide();
            $('#TrCompareFacterRatio').hide();
        } else if (valueType == 'RelativeValue') {
            $('#TrRefValue1').show();
            $('#TrRefValue2').show();
            $('#TrValue1').hide();
            $('#TrValue2').hide();
            $('#TrCompareFacter').hide();
            $('#TrCompareFacterRatio').hide();
        } else if (valueType == 'OtherFactor') {
            $('#TrRefValue1').hide();
            $('#TrRefValue2').hide();
            $('#TrValue1').hide();
            $('#TrValue2').hide();
            $('#TrCompareFacter').show();
            $('#TrCompareFacterRatio').show();
            $('#IptCompareFacterRatio').FrameNumeric('setValue', '1');
        } else {
            $('#TrRefValue1').hide();
            $('#TrRefValue2').hide();
            $('#TrValue1').hide();
            $('#TrValue2').hide();
            $('#TrCompareFacter').hide();
            $('#TrCompareFacterRatio').hide();
        }
    }

    var showDemo = function () {
        if ($('#BtnDemoInfo').text() == "显示示例") {
            $('#BtnDemoInfo').text("收起示例");
        } else {
            $('#BtnDemoInfo').text("显示示例");
        }
        $('#DemoInfo').slideToggle();
    }

    var checkFormMain = function (data) {
        var message = [];

        if (data.IptDesc == '') {
            message.push('请填写规则描述');
        }
        if (data.IptPolicyFactorX == '') {
            message.push('请选择赠品/积分计算基数类型');
        }
        var PolicyStyleSubCode = getPolicyStyleSubCode(data.IptPolicyStyleSub);
        if (PolicyStyleSubCode == 'CXZP') {
            if (data.IptPolicyFactorY == '') {
                message.push('请选择赠品/积分可订产品');
            }
            if (data.IptFactorValueX == null || data.IptFactorValueX == '') {
                message.push('请填写赠品/积分计算系数1');
            }
            if (data.IptFactorValueY == null || data.IptFactorValueY == '') {
                message.push('请填写赠品/积分计算系数2');
            }
        } else if (PolicyStyleSubCode == 'GDJF') {
            if (data.IptFactorValueX == null || data.IptFactorValueX == '') {
                message.push('赠品/积分计算基数类型');
            }
            if (data.IptPointValue == '') {
                message.push('请填写固定积分');
            }
        } else if (PolicyStyleSubCode == 'BFBJF') {
            if (data.IptFactorValueY == null || data.IptFactorValueY == '') {
                message.push('请填写赠品/积分计算系数2');
            }
        } else if (PolicyStyleSubCode == 'BCJF') {
            if (data.IptPolicyFactorY == '') {
                message.push('请选择赠品/积分可订产品');
            }
            if (data.IptFactorValueX == null || data.IptFactorValueX == '') {
                message.push('请填写赠品/积分计算系数1');
            }
            if (data.IptFactorValueY == null || data.IptFactorValueY == '') {
                message.push('请填写赠品/积分计算系数2');
            }
            //if (data.IptPointType == '') {
            //   message.push('请填写积分换算方式');
           // }
        } else if (PolicyStyleSubCode == 'SZP') {
            if (data.IptPolicyFactorY == '') {
               // message.push('请选择赠品/积分可订产品');
            }
            if (data.IptFactorValueX == null || data.IptFactorValueX == '') {
                message.push('请填写赠品/积分计算系数1 值');
            }
            if (data.IptFactorValueY == null || data.IptFactorValueY == '') {
                message.push('请填写赠品/积分计算系数2');
            }
        } else if (PolicyStyleSubCode == 'DZ') {
            if (data.IptFactorValueY == null || data.IptFactorValueY == '') {
                message.push('请填写赠品/积分计算系数2');
            }
        }

        return message
    }

    var checkDetail = function (data) {
        var message = [];

        if (data.IptPolicyConditionFacter == '') {
            message.push('请选择条件参数');
        }
        if (data.IptSymbol == '') {
            message.push('请选择判断符号');
        }
        if (data.IptValueType == '') {
            message.push('请选择值类型');
        }
        if (data.IptValueType == 'AbsoluteValue') {
            if (data.IptValue1 == null || data.IptValue1 == '') {
                message.push('请填写判断值1');
            }
            //if (data.IptValue2 == null || data.IptValue2 == '') {
            //    message.push('请填写判断值2');
            //}
        } else if (data.IptValueType == 'RelativeValue') {
            if (data.IptRefValue1 == '') {
                message.push('请选择引用判断值1');
            }
            //if (data.IptRefValue2 == '') {
            //    message.push('请选择引用判断值2');
            //}
        } else if (data.IptValueType == 'OtherFactor') {
            if (data.IptCompareFacter == '') {
                message.push('请选择比较参数');
            }
            if (data.IptCompareFacterRatio == null || data.IptCompareFacterRatio == '') {
                message.push('请填写系数');
            }
        }

        return message;
    }
    
    var setReadonly = function () {
        $('#IptDesc').FrameTextArea('disable');
        $('#IptPolicyFactorX').FrameDropdownList('disable');
        $('#IptFactorRemarkX').FrameTextBox('disable');
        $('#IptPolicyFactorY').FrameDropdownList('disable');
        $('#IptFactorRemarkY').FrameTextBox('disable');
        $('#IptFactorRemarkY').FrameTextBox('disable');
        $('#IptFactorValueX').FrameNumeric('disable');
        $('#IptFactorValueY').FrameNumeric('disable');
        $('#IptPointValue').FrameTextBox('disable');
        $('#IptPointType').FrameDropdownList('disable');

        $('#IptPolicyConditionFacter').FrameDropdownList('disable');
        $('#IptSymbol').FrameDropdownList('disable');
        $('#IptValueType').FrameDropdownList('disable');
        $('#IptRefValue1').FrameDropdownList('disable');
        $('#IptRefValue2').FrameDropdownList('disable');
        $('#IptValue1').FrameNumeric('disable');
        $('#IptValue2').FrameNumeric('disable');
        $('#IptCompareFacter').FrameDropdownList('disable');
        $('#IptCompareFacterRatio').FrameNumeric('disable');

        $('#BtnAddCondition').remove();
        $('#BtnSave').remove();
        $('#BtnConditionSave').remove();

        $("#RstRuleDetail").data("kendoGrid").hideColumn(5);
    }

    var createFactorConditionList = function (model) {
        $("#RstRuleDetail").kendoGrid({
            dataSource: model.RstRuleDetail,
            sortable: true,
            resizable: true,
            scrollable: true,
            height: 119,
            columns: [
                {
                    field: "FactName", title: "参数名称",
                    headerAttributes: { "class": "center bold", "title": "参数名称" }
                },
                {
                    field: "LogicSymbolName", title: "判断符号", width: '200px',
                    headerAttributes: { "class": "center bold", "title": "判断符号" }
                },
                {
                    field: "Value1", title: "判断值1", width: '150px',
                    headerAttributes: { "class": "center bold", "title": "判断值1" }
                },
                {
                    field: "Value2", title: "判断值2", width: '100px',
                    headerAttributes: { "class": "center bold", "title": "判断值2" }
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

                    that.ShowCondition(data.RuleFactorId);
                });

                $("i[name='remove']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    showConfirm({
                        target: 'top',
                        message: '确定删除规则条件吗？',
                        confirmCallback: function () {
                            $('#IptConditionId').val(data.RuleFactorId);
                            that.RemoveCondition();
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

    var initColumnLayout = function () {
    }

    var setLayout = function () {
        var h = $('.content-main').height();
    }

    return that;
}();
