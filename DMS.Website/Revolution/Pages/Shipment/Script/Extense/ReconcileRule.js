var ReconcileRule = {};
ReconcileRule = function () {
    var that = {};

    var data = FrameUtil.GetModel();
    var business = "Shipment.Extense.ReconcileRule";
    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    };

    that.Query = function () {
        var grid = $("#RstResultList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    that.Init = function () { 
        var data = FrameUtil.GetModel();
        createResultList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#SubCompany').FrameDropdownList({
                    //dataSource: [{ Key: '0', Value: '蓝微' }, { Key: '1', Value: '瑞奇' }, { Key: '2', Value: '惠康' }, { Key: '3', Value: '神经介入' }],
                    dataSource: model.SubCompanies,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.SubCompany
                });

                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.Query();
                    }
                });

                $('#BtnExpDetail').hide().FrameButton({
                    text: '导出明细',
                    icon: 'file-excel-o',
                    onClick: function () {

                    }
                });
                $('#saveDetail').FrameButton({
                    text: '确认',
                    icon: 'save',
                    onClick: function () {
                        that.saveDetail();
                    }
                });
                $('#colseDetail').FrameButton({
                    text: '取消',
                    icon: 'close',
                    onClick: function () {
                        $("#divRulePop").data("kendoWindow").close();
                    }
                });
                FrameWindow.HideLoading();
            }
        });
    };

    that.saveDetail = function () {
        var data = FrameUtil.GetModel(); 
        var isProductTypeChecked = $('#ProductType').is(':checked') == true ? '1' : '0',
            isInvoiceDateChecked = $('#InvoiceDate').is(':checked') == true ? '1' : '0',
            isSalesHospitalChecked = $('#SalesHospital').is(':checked') == true ? '1' : '0';
        var rules = isProductTypeChecked+',' + isInvoiceDateChecked +','+ isSalesHospitalChecked;
        data.ReconcileRule = rules;
        data.SubCompanyId = $('#hidSubCompanyId').val();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Update',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    $("#divRulePop").data("kendoWindow").close();
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '保存成功',
                        callback: function () {
                            that.Query();
                        }
                    });
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: model.ExecuteMessage,
                        callback: function () {
                        }
                    });
                }
                $(window).resize(function () {
                    setLayout();
                });
                FrameWindow.HideLoading();
            }
        });
    };

    that.initRuleDiv = function (model, readonly) {
        //var data = FrameUtil.GetModel();  
        $('#divRulePop').kendoWindow({
            title: 'Title',
            width: 320,
            height: 180,
            actions: ["Close"],
            modal: true,
        }).data("kendoWindow").title("对账规则设置").center().open();
        var isProductTypeChecked = model.ProductType == '0' ? false : true, isInvoiceDateChecked = model.InvoiceDate == '0' ? false : true,
            isSalesHospitalChecked = model.SalesHospital == '0' ? false : true; 
        $('#ProductType').prop({ 'checked': isProductTypeChecked, 'disabled': true });
        $('#InvoiceDate').prop({ 'checked': isInvoiceDateChecked, 'disabled': true  });
        $('#SalesHospital').prop({ 'checked': isSalesHospitalChecked, 'disabled': true  });
        $('#hidSubCompanyId').val(model.SubCompanyId);
    };

    var kendoDataSource = GetKendoDataSource(business, 'Query');

    var createResultList = function () { 
        $('#RstResultList').kendoGrid({
            dataSource: kendoDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
                input: true,
                numeric: false
            },
            columns: [
                //{
                //    title: "选择", width: '50px', encoded: false,
                //    headerAttributes: { 'class': 'text-center text-bold', 'title': '选择' },
                //    template: '<input type="radio" id="rad_#=SubCompanyId#" />',
                //    attributes: { "class": "center" }

                //},
                {
                    hidden:true, field:'SubCompanyId',title:'公司Id'
                },
                {
                    field:'SubCompanyName', title: '分子公司',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '分子公司' }
                },
                {
                    field:'Rules', title: '对账规则',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '对账规则' },
                    template: function (gridrow) {
                        var status = gridrow.Rules.split(','), radlist = '';
                        var subcompanyid = gridrow.SubCompanyId;
                        if (status.length > 0) {
                            radlist += '<input type="checkbox" id="productType_' + subcompanyid + '" checked="true" disabled /> <label>产品型号</label> &nbsp;&nbsp;';
                            radlist += '<input type="checkbox" id="InvoiceDate_' + subcompanyid + '" ' + (status[1] ==0? "":"checked='true' disabled") +' /> <label>发票日期</label> &nbsp;&nbsp;';
                            radlist += '<input type="checkbox" id="Hospital_' + subcompanyid + '" ' + (status[2] == 0 ? "" : "checked='true' disabled") +' /> <label>销售医院</label>';
                           
                        }
                        return radlist;
                    }
                },
                {
                    field: 'UpdateTime', title: '更新时间',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '更新时间' }
                },
                {
                    field: 'UpdatedBy', title: '更新人',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '更新人' }
                },
                {
                    title: '明细',
                    headerAttributes: { 'class': 'text-center text-bold', 'title': '明细' },
                    template: "<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>",
                    attributes: { "class": "text-center text-bold" }
                }
                
            ],
            dataBound: function (e) {
                var grid = e.sender;
                $('#RstResultList').find('i[name="edit"]').bind('click', function (e) {
                    var tr = $(this).closest('tr');
                    var data = grid.dataItem(tr);
                    var subCompanyId = data.SubCompanyId;
                    var model = {};
                    var selectStatus = data.Rules.split(',');
                    
                    model.ProductType = selectStatus[0];
                    model.InvoiceDate = selectStatus[1];
                    model.SalesHospital = selectStatus[2];
                    model.SubCompanyId = subCompanyId;
                    that.initRuleDiv(model, false);

                });
            }
        });

    }
    return that;
}();