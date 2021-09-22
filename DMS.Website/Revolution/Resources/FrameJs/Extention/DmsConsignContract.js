(function ($) {
    //DmsConsignContract Start
    $.fn.DmsConsignContract = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.DmsConsignContract.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.DmsConsignContract.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.DmsConsignContract.defaults.value;
            }
            $(this).data(setting);

            $(this).empty();

            //HTML
            var html = '';
            html += '<div class="col-xs-12 dms-picker">';
            html += '    <div class="row">';
            html += '        <div class="col-xs-12 col-sm-6 col-md-4 col-group" style="font-size: 1.2em;">';
            html += '            <div class="col-xs-4 col-label"><i class="fa fa-fw fa-require"></i>寄售合同名称</div>';
            html += '            <div class="col-xs-8 col-field">';
            if (!setting.readonly) {
                html += '                <select id="' + controlId + '_Contract_Control" style="width: 100%;"></select>';
            } else {
                html += '                <div id="' + controlId + '_Contract_Control"></div>';
            }
            html += '            </div>';
            html += '        </div>';
            html += '    </div>';
            html += '</div>';
            html += '<div class="col-xs-12" style="background-color: #f9f9f9;">';
            html += '    <div class="row">';
            html += '        <div class="col-xs-12 col-group">';
            html += '            <div class="col-xs-4 col-label col-3to1-4and8-label">寄售合同名称</div>';
            html += '            <div class="col-xs-8 col-field col-3to1-4and8-field">';
            html += '                <div id="' + controlId + '_ContractName_Control"></div>';
            html += '            </div>';
            html += '        </div>';
            html += '        <div class="col-xs-12 col-sm-6 col-md-4 col-group">';
            html += '            <div class="col-xs-4 col-label">寄售合同编号</div>';
            html += '            <div class="col-xs-8 col-field">';
            html += '                <div id="' + controlId + '_ContractNo_Control"></div>';
            html += '            </div>';
            html += '        </div>';
            html += '        <div class="col-xs-12 col-sm-6 col-md-4 col-group">';
            html += '            <div class="col-xs-4 col-label">寄售天数</div>';
            html += '            <div class="col-xs-8 col-field">';
            html += '                <div id="' + controlId + '_ConsignDay_Control"></div>';
            html += '            </div>';
            html += '        </div>';
            html += '        <div class="col-xs-12 col-sm-6 col-md-4 col-group">';
            html += '            <div class="col-xs-4 col-label">可延期次数</div>';
            html += '            <div class="col-xs-8 col-field">';
            html += '                <div id="' + controlId + '_DelayTimes_Control"></div>';
            html += '            </div>';
            html += '        </div>';
            html += '        <div class="col-xs-12 col-sm-6 col-md-4 col-group">';
            html += '            <div class="col-xs-4 col-label">合同时间</div>';
            html += '            <div class="col-xs-8 col-field">';
            html += '                <div id="' + controlId + '_ContractDate_Control"></div>';
            html += '            </div>';
            html += '        </div>';
            html += '        <div class="col-xs-12 col-sm-6 col-md-4 col-group">';
            html += '            <div class="col-xs-4 col-label">自动补货</div>';
            html += '            <div class="col-xs-8 col-field">';
            html += '                <input id="' + controlId + '_Kb_Control" type="checkbox"></input>';
            html += '            </div>';
            html += '        </div>';
            html += '        <div class="col-xs-12 col-sm-6 col-md-4 col-group">';
            html += '            <div class="col-xs-4 col-label">控制总金额</div>';
            html += '            <div class="col-xs-8 col-field">';
            html += '                <input id="' + controlId + '_FixedMoney_Control" type="checkbox"></input>';
            html += '            </div>';
            html += '        </div>';
            html += '        <div class="col-xs-12 col-sm-6 col-md-4 col-group">';
            html += '            <div class="col-xs-4 col-label">控制总数量</div>';
            html += '            <div class="col-xs-8 col-field">';
            html += '                <input id="' + controlId + '_FixedQuantity_Control" type="checkbox"></input>';
            html += '            </div>';
            html += '        </div>';
            html += '        <div class="col-xs-12 col-sm-6 col-md-4 col-group">';
            html += '            <div class="col-xs-4 col-label">有效期折扣规则</div>';
            html += '            <div class="col-xs-8 col-field">';
            html += '                <input id="' + controlId + '_UseDiscount_Control" type="checkbox"></input>';
            html += '            </div>';
            html += '        </div>';
            html += '        <div class="col-xs-12 col-group">';
            html += '            <div class="col-xs-4 col-label col-3to1-4and8-label">备注</div>';
            html += '            <div class="col-xs-8 col-field col-3to1-4and8-field">';
            html += '                <div id="' + controlId + '_Remark_Control"></div>';
            html += '            </div>';
            html += '        </div>';
            html += '    </div>';
            html += '</div>';

            $(this).append(html);

            $('#' + controlId + '_ContractName_Control').html(setting.value.ContractName);
            $('#' + controlId + '_ContractNo_Control').html(setting.value.ContractNo);
            $('#' + controlId + '_ConsignDay_Control').html(setting.value.ConsignDay);
            $('#' + controlId + '_DelayTimes_Control').html(setting.value.DelayTimes);
            $('#' + controlId + '_ContractDate_Control').html(setting.value.ContractDate);
            $('#' + controlId + '_Kb_Control').kendoMobileSwitch({
                onLabel: "是",
                offLabel: "否",
                enable: false,
                checked: setting.value.Kb
            });
            $('#' + controlId + '_FixedMoney_Control').kendoMobileSwitch({
                onLabel: "是",
                offLabel: "否",
                enable: false,
                checked: setting.value.FixedMoney
            });
            $('#' + controlId + '_FixedQuantity_Control').kendoMobileSwitch({
                onLabel: "是",
                offLabel: "否",
                enable: false,
                checked: setting.value.FixedQuantity
            });
            $('#' + controlId + '_UseDiscount_Control').kendoMobileSwitch({
                onLabel: "是",
                offLabel: "否",
                enable: false,
                checked: setting.value.UseDiscount
            });
            $('#' + controlId + '_Remark_Control').html(setting.value.Remark);

            if (!setting.readonly) {
                var optionLabel = '';
                if (setting.selectType == 'all') {
                    optionLabel = '全部';
                } else if (setting.selectType == 'select') {
                    optionLabel = '请选择';
                }
                $('#' + controlId + '_Contract_Control').kendoDropDownList({
                    height: 200,
                    dataTextField: setting.dataValue,
                    dataValueField: setting.dataKey,
                    dataSource: setting.dataSource,
                    optionLabel: optionLabel,
                    noDataTemplate: '',
                    value: setting.value.ContractId,
                    change: function (e) {
                        var contractId = this.value();

                        if (contractId != '') {
                            var data = {};
                            data.QryString = contractId;

                            FrameWindow.ShowLoading();
                            FrameUtil.SubmitAjax({
                                business: 'Consign.ConsignCommon',
                                method: 'QueryConsingContract',
                                url: Common.AppHandler,
                                data: data,
                                callback: function (model) {
                                    $('#' + controlId).data('value', model.RstResult);

                                    $('#' + controlId + '_ContractName_Control').html(model.RstResult.ContractName);
                                    $('#' + controlId + '_ContractNo_Control').html(model.RstResult.ContractNo);
                                    $('#' + controlId + '_ConsignDay_Control').html(model.RstResult.ConsignDay);
                                    $('#' + controlId + '_DelayTimes_Control').html(model.RstResult.DelayTimes);
                                    $('#' + controlId + '_ContractDate_Control').html(model.RstResult.ContractDate);
                                    $('#' + controlId + '_Kb_Control').data("kendoMobileSwitch").check(model.RstResult.Kb);
                                    $('#' + controlId + '_FixedMoney_Control').data("kendoMobileSwitch").check(model.RstResult.FixedMoney);
                                    $('#' + controlId + '_FixedQuantity_Control').data("kendoMobileSwitch").check(model.RstResult.FixedQuantity);
                                    $('#' + controlId + '_UseDiscount_Control').data("kendoMobileSwitch").check(model.RstResult.UseDiscount);
                                    $('#' + controlId + '_Remark_Control').html(model.Remark);

                                    setting.onChange.call(this);

                                    FrameWindow.HideLoading();
                                }
                            });
                        } else {
                            $('#' + controlId).DmsConsignContract('clear');

                            setting.onChange.call(this);
                        }
                    }
                });
            } else {
                $('#' + controlId + '_Remark_Control').html(setting.value.ContractName);
            }
        }
    };

    $.fn.DmsConsignContract.defaults = $.extend({}, {
        type: 'DmsConsignContract',
        value: { 'ContractId': '', 'ContractName': '', 'ContractNo': '', 'ConsignDay': '', 'DelayTimes': '', 'ContractDate': '', 'Kb': false, 'FixedMoney': false, 'FixedQuantity': false, 'UseDiscount': false, 'Remark': '' },
        dataSource: [],
        dataKey: '',
        dataValue: '',
        selectType: '',
        readonly: false,
        onChange: function () { }
    });

    $.fn.DmsConsignContract.methods = {
        setDataSource: function (my, value) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                $('#' + controlId + '_Contract_Control').data("kendoDropDownList").setDataSource(value);
                $('#' + controlId).DmsConsignContract('clear');
            }
        },
        //setValue: function (my, value) {
        //    var controlId = $(my).attr("id");

        //    if (!$(my).data('readonly')) {
        //        $(my).data('value', value);

        //        $('#' + controlId + '_ContractName_Control').html(value.ContractName);
        //        $('#' + controlId + '_ContractNo_Control').html(value.ContractNo);
        //        $('#' + controlId + '_ConsignDay_Control').html(value.ConsignDay);
        //        $('#' + controlId + '_DelayTimes_Control').html(value.DelayTimes);
        //        $('#' + controlId + '_ContractDate_Control').html(value.ContractDate);
        //        $('#' + controlId + '_Kb_Control').html(value.Kb.Value);
        //        $('#' + controlId + '_FixedMoney_Control').html(value.FixedMoney.Value);
        //        $('#' + controlId + '_FixedQuantity_Control').html(value.FixedQuantity.Value);
        //        $('#' + controlId + '_UseDiscount_Control').html(value.UseDiscount.Value);
        //        $('#' + controlId + '_Remark_Control').html(value.Remark);
        //    }
        //},
        getValue: function (my) {
            return $(my).data('value');
        },
        //clear: function (my) {
        //    var controlId = $(my).attr("id");

        //    if (!$(my).data('readonly')) {
        //        var value = $(my).data('value');
        //        value.ContractName = '';
        //        value.ContractNo = '';
        //        value.ConsignDay = '';
        //        value.DelayTimes = '';
        //        value.ContractDate = '';
        //        value.Kb = { 'Key': '', 'Value': '' };
        //        value.FixedMoney = { 'Key': '', 'Value': '' };
        //        value.FixedQuantity = { 'Key': '', 'Value': '' };
        //        value.UseDiscount = { 'Key': '', 'Value': '' };
        //        value.Remark = '';

        //        $(my).data('value', value);

        //        $('#' + controlId + '_ContractName_Control').html('');
        //        $('#' + controlId + '_ContractNo_Control').html('');
        //        $('#' + controlId + '_ConsignDay_Control').html('');
        //        $('#' + controlId + '_DelayTimes_Control').html('');
        //        $('#' + controlId + '_ContractDate_Control').html('');
        //        $('#' + controlId + '_Kb_Control').html('');
        //        $('#' + controlId + '_FixedMoney_Control').html('');
        //        $('#' + controlId + '_FixedQuantity_Control').html('');
        //        $('#' + controlId + '_UseDiscount_Control').html('');
        //        $('#' + controlId + '_Remark_Control').html('');
        //    }
        //},
        clear: function (my) {
            var controlId = $(my).attr("id");

            if (!$(my).data('readonly')) {
                var value = $.fn.DmsConsignContract.defaults.value;

                $(my).data('value', value);

                $('#' + controlId + '_Contract_Control').data("kendoDropDownList").value('');
                $('#' + controlId + '_ContractName_Control').html('');
                $('#' + controlId + '_ContractNo_Control').html('');
                $('#' + controlId + '_ConsignDay_Control').html('');
                $('#' + controlId + '_DelayTimes_Control').html('');
                $('#' + controlId + '_ContractDate_Control').html('');
                $('#' + controlId + '_Kb_Control').data("kendoMobileSwitch").check(false);
                $('#' + controlId + '_FixedMoney_Control').data("kendoMobileSwitch").check(false);
                $('#' + controlId + '_FixedQuantity_Control').data("kendoMobileSwitch").check(false);
                $('#' + controlId + '_UseDiscount_Control').data("kendoMobileSwitch").check(false);
                $('#' + controlId + '_Remark_Control').html('');
            }
        }
    };
    //DmsConsignContract End
})(jQuery);