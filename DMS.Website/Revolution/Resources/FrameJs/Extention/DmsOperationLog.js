(function ($) {
    //DmsOperationLog Start
    $.fn.DmsOperationLog = function (param1, param2) {
        if (typeof ($(this)) == 'undefined' || $(this).length == 0) {
            return;
        }

        var controlId = $(this).attr("id");

        if (typeof param1 == "string") {
            var func = $.fn.DmsOperationLog.methods[param1];
            if (func) {
                return func(this, param2);
            } else {
                console.log('error: none method');
                return '';
            }
        } else {
            var setting = $.extend({}, $.fn.DmsOperationLog.defaults, param1);
            if (!setting.value) {
                setting.value = $.fn.DmsHospitalFilter.defaults.value;
            }
            $(this).data(setting);

            $('#' + controlId).empty();

            if (setting.dataSource.length > 0) {
                //HTML
                var html = '';
                html += '<div class="box box-primary" style="margin-bottom: 5px;">';
                html += '	<div class="box-header with-border">';
                html += '	    <h3 class="box-title"><i class="fa fa-fw fa-navicon"></i>&nbsp;操作记录</span>';
                html += '	</div>';
                html += '	<div class="box-body" style="padding: 0px;">';
                html += '	    <div class="col-xs-12">';
                html += '	        <div class="row">';
                html += '	            <div id="' + controlId + '_Control" class="k-grid-page-all frame-grid"></div>';
                html += '	        </div>';
                html += '	    </div>';
                html += '	</div>';
                html += '</div>';

                $('#' + controlId).append(html);

                $('#' + controlId + '_Control').kendoGrid({
                    dataSource: setting.dataSource,
                    columns: [
                        {
                            title: "序号", width: '50px',
                            headerAttributes: { "class": "text-center text-bold", "title": "序号" },
                            template: "<span class='row-number'></span>",
                            attributes: { "class": "text-right" }
                        },
                        {
                            field: "OperRole", title: "操作人账号", width: '200px',
                            headerAttributes: { "class": "center bold", "title": "操作人账号" }
                        },
                        {
                            field: "OperUser", title: "操作人姓名", width: '200px',
                            headerAttributes: { "class": "center bold", "title": "操作人姓名" }
                        },
                        {
                            field: "OperTypeName", title: "操作内容", width: '150px',
                            headerAttributes: { "class": "center bold", "title": "操作内容" }
                        },
                        {
                            field: "OperDate", title: "操作时间", width: '150px',
                            headerAttributes: { "class": "center bold", "title": "操作时间" }
                        },
                        {
                            field: "OperNote", title: "备注信息", width: 'auto',
                            headerAttributes: { "class": "center bold", "title": "备注信息" }
                        }
                    ],
                    noRecords: true,
                    messages: {
                        noRecords: "没有符合条件的记录"
                    },
                    dataBound: function (e) {
                        var grid = e.sender;
                        var rows = this.items();

                        $(rows).each(function () {
                            var index = $(this).index() + 1;
                            var rowLabel = $(this).find(".row-number");
                            $(rowLabel).html(index);
                        });
                    }
                });
            }
        }
    };

    $.fn.DmsOperationLog.defaults = $.extend({}, {
        type: 'DmsOperationLog',
        dataSource: []
    });

    $.fn.DmsOperationLog.methods = {
        setDatasource: function (my, value) {
            var controlId = $(my).attr("id");

            $('#' + controlId + '_Control').data('kendoGrid').setOptions({
                dataSource: value
            });
        }
    };
    //DmsOperationLog End
})(jQuery);