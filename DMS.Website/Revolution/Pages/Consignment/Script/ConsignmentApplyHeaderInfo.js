var ConsignmentApplyHeaderInfo = {};

ConsignmentApplyHeaderInfo = function () {
    var that = {};

    var business = 'Consignment.ConsignmentApplyHeaderInfo';
    var CustomerFaceNbr = [];
    var g = 0;
    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        model.RstDetailList = $("#RstDetailList").data("kendoGrid").dataSource.data();
        return model;
    }

    var EntityModel = "";
    var LstBuArr = [];
    var LstSalesRepArr = [];
    var LstProlineDmaArr = [];
    var LstcbProductsourceArr = [];
    var hidChanConsignment = "";
    that.Init = function () {
        var data = {};
        $("#QryPriceType").val("Dealer");
        $("#QryOrderType").val("Normal");
        $("#QrySpecialPrice").val("");
        $('#IsNewApply').val(Common.GetUrlParam('IsNew'));
        data.InstanceId = Common.GetUrlParam('InstanceId');
        data.QryStatus = Common.GetUrlParam('Status');
        data.DealerId = Common.GetUrlParam('DealerId');
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                EntityModel = JSON.parse(model.EntityModel);
                $("#QryDealerId").val(model.QryDealerId);
                $('#InstanceId').val(model.InstanceId);

                $("#hidCorpType").val(model.hidCorpType);
                $("#hidDivisionCode").val(model.hidDivisionCode);
                $("#hidProductLine").val(model.hidProductLine);
                $("#HospId").val(model.HospId);
                $("#hidConsignment").val(model.hidConsignment);
                $("#hidUpdateDate").val(model.hidUpdateDate);
                $("#hidorderState").val(model.hidorderState);
                $("#hidChanConsignment").val(model.hidChanConsignment);
                LstProlineDmaArr = model.LstProlineDma;
                LstcbProductsourceArr = model.LstcbProductsource;
                LstBuArr = model.LstBu;
                LstSalesRepArr = model.LstSalesRepStor;
                //申请单类型
                $('#QryApplyType').FrameTextBox({
                    value: model.QryApplyType,
                });
                $('#QryApplyType').FrameTextBox('disable');

                //经销商
                $('#QryDealer').FrameTextBox({
                    value: model.QryDealer,
                });
                $('#QryDealer').FrameTextBox('disable');
                //提交日期
                $('#QrySubmitDate').FrameTextBox({
                    value: model.QrySubmitDate,
                });
                $('#QrySubmitDate').FrameTextBox('disable');

                $('#QryApplyNo').FrameTextBox({
                    value: model.QryApplyNo,
                });
                $('#QryApplyNo').FrameTextBox('disable');

                if (EntityModel.ProductLineId != "" && EntityModel.ProductLineId != null) {
                    $.each(model.LstBu, function (index, val) {
                        if (dms.common.ToLowerCaseFn(EntityModel.ProductLineId) === dms.common.ToLowerCaseFn(val.Key)) {
                            model.Qrycbproline = { Key: EntityModel.ProductLineId, Value: val.Value };
                        }
                    })
                }
                $('#Qrycbproline').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.Qrycbproline,
                    onChange: function (s) {
                        that.ProductLineChange(this.value);
                    }
                });
                $('#Qrycbproline').FrameDropdownList('disable');

                //医院模块
                $('#QrycbHospital').FrameDropdownList({
                    dataSource: model.LstcbHospital,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    value: model.QrycbHospital,
                    onChange: function (s) {
                        that.HospitalChange(this.value);
                    }
                });

                $('#QryTextHospit').FrameTextBox({
                    value: EntityModel.HospitalName,
                });
                $('#QryTextHospit').FrameTextBox('disable');

                if (model.cbHospitalHidden) {
                    $('#QryTextHospit').parent().parent().show();
                    $('#QrycbHospital').parent().parent().hide();
                }

                //寄售合同     
                var QryRule = "";
                if (EntityModel.CmId != "" && EntityModel.CmId != null) {
                    $.each(model.LstDealerConsignment, function (index, val) {
                        if (EntityModel.CmId === val.Id) {
                            QryRule = { Key: EntityModel.CmId, Value: val.Name };
                        }
                    })
                }
                $('#QryRule').FrameDropdownList({
                    dataSource: model.LstDealerConsignment,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    value: QryRule,
                    onChange: function (s) {
                        that.RulesChange(this.value);
                    }
                });
                //寄售规则
                $('#QryConsignmentRule').FrameTextBox({
                    value: model.txtConsignmentRuleId,
                });
                //来源经销商
                $('#QrycbSuorcePro').parent().parent().show();
                var QrycbSuorcePro = "";
                $.each(model.LstProlineDma, function (index, val) {
                    if (EntityModel.ConsignmentId === val.Id) {
                        QrycbSuorcePro = { Key: EntityModel.ConsignmentId, Value: val.Name };
                    }
                })
                $('#QrycbSuorcePro').FrameDropdownList({
                    dataSource: model.LstProlineDma,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    value: QrycbSuorcePro,
                    onChange: function (e) {
                        that.SuorceProChange(this.value);
                    }
                });


                //产品来源
                $('#QrycbProductsource').FrameDropdownList({
                    dataSource: model.LstcbProductsource,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: '',
                    onChange: function (e) {
                        that.ChanConsignmentFrom(this.value);
                    }
                });

                //申请单状态
                $('#QryOrderState').FrameTextBox({
                    value: model.QryOrderState,
                });
                $('#QryOrderState').FrameTextBox('disable');
                //延期状态
                $('#QryDelayState').FrameTextBox({
                    value: model.QryDelayState,
                });
                $('#QryDelayState').FrameTextBox('disable');

                //申请单主信息    ***************************
                $('#Qrynumber').FrameTextBox({
                    value: parseFloat(model.Qrynumber).toFixed(2),
                });
                $('#Qrynumber').FrameTextBox('disable');

                $('#QryTaoteprice').FrameTextBox({
                    value: parseFloat(model.QryTaoteprice).toFixed(2),
                });
                $('#QryTaoteprice').FrameTextBox('disable');
                //寄售原因 、备注
                $('#QryConsignment').FrameTextArea({
                    value: model.QryConsignment,
                });
                $('#QryRemark').FrameTextArea({
                    value: model.QryRemark,
                });
                //销售人员信息
                $('#QrySales').FrameDropdownList({
                    dataSource: model.LstSalesRepStor,
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    value: '',
                    onChange: function (s) {
                        that.ChangeSalesRepStor(s.target.value);
                    },
                });
                $('#QrySalesName').FrameTextBox({
                    value: model.QrySalesName,
                });
                $('#QrySalesEmail').FrameTextBox({
                    value: model.QrySalesEmail,
                });
                $('#QrySalesPhone').FrameTextBox({
                    value: model.QrySalesPhone,
                });
                $('#QrySalesName').FrameTextBox('disable');
                $('#QrySalesEmail').FrameTextBox('disable');
                $('#QrySalesPhone').FrameTextBox('disable');
                //收货人
                $('#QryConsignee').FrameTextBox({
                    value: model.QryConsignee,
                });
                $('#QryConsigneePhone').FrameTextBox({
                    value: model.QryConsigneePhone,
                });

                //收货地址
                $.each(model.LstSAPWarehouseAddress, function (index, val) {
                    if (model.QrycbSAPWarehouseAddress.Key === val.WhCode) {
                        model.QrycbSAPWarehouseAddress = { Key: val.WhCode, Value: val.WhAddress };
                    }
                })
                $('#QrycbSAPWarehouseAddress').FrameDropdownList({
                    dataSource: model.LstSAPWarehouseAddress,
                    dataKey: 'WhCode',
                    dataValue: 'WhAddress',
                    selectType: 'none',
                    value: model.QrycbSAPWarehouseAddress,
                });

                //医院名称
                $('#QryTexthospitalname').FrameTextBox({
                    value: model.QryTexthospitalname,
                });
                $('#QryHospitalAddress').FrameTextBox({
                    value: model.QryHospitalAddress,
                });
                //var endDP = $("#QrydfRDD").kendoDatePicker({
                //    culture: "zh-CN",
                //    value: model.QrydfRDD,
                //    dateInput: true,
                //    format: "yyyy-MM-dd",
                //    depth: "month",
                //    start: "month",
                //}).data("kendoDatePicker");
                //endDP.element[0].disabled = true;
                // $('#QrydfRDD').data('kendoDatePicker').enable(false);
                $('#QrydfRDD').FrameDatePicker({
                    format: "yyyy-MM-dd",
                    value: (model.QrydfRDD == '' || model.QrydfRDD == null) ? '' : new Date(model.QrydfRDD)
                });


                //寄售规则规则明细************************************///////////
                $('#QryNumberDays').FrameTextBox({
                    value: model.QryNumberDays,
                });
                $('#QryDelaytimes').FrameTextBox({
                    value: model.QryDelaytimes,
                });
                $('#QryBeginData').FrameTextBox({
                    value: model.QryBeginData,
                });
                $('#QryIsControlAmount').FrameTextBox({
                    value: model.QryIsControlAmount,
                });
                $('#QryIsControlNumber').FrameTextBox({
                    value: model.QryIsControlNumber,
                });
                $('#QryEndData').FrameTextBox({
                    value: model.QryEndData,
                });
                $('#QryIsDiscount').FrameTextBox({
                    value: model.QryIsDiscount,
                });
                $('#QryIsKB').FrameTextBox({
                    value: model.QryIsKB,
                });
                $('#QryNumberDays').FrameTextBox('disable');
                $('#QryDelaytimes').FrameTextBox('disable');
                $('#QryBeginData').FrameTextBox('disable');
                $('#QryIsControlAmount').FrameTextBox('disable');
                $('#QryIsControlNumber').FrameTextBox('disable');
                $('#QryEndData').FrameTextBox('disable');
                $('#QryIsDiscount').FrameTextBox('disable');
                $('#QryIsKB').FrameTextBox('disable');


                //选择 医院
                $('#BtnChoiceHopital').FrameButton({
                    text: '选择',
                    icon: 'search',
                    onClick: function () {
                        that.ChoiceHospital();
                    }
                });
                $('#BtnApplyDelay').FrameButton({
                    text: '申请延期',
                    icon: 'save',
                    onClick: function () {
                        that.btnDelay();
                    }
                });
                $('#BtnSave').FrameButton({
                    text: '保存草稿',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
                    }
                });
                $('#BtnDelete').FrameButton({
                    text: '删除草稿',
                    icon: 'remove',
                    onClick: function () {
                        that.Delete();
                    }
                });
                $('#BtnSubmit').FrameButton({
                    text: '提交申请',
                    icon: 'send',
                    onClick: function () {
                        that.Submit();
                    }
                });
                $('#BtnAddProduct').FrameButton({
                    text: '添加产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddProduct();
                    }
                });
                $('#BtnAddComProduct').FrameButton({
                    text: '添加组产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddUpn();
                    }
                });
                $('#BtnReturnOrder').FrameButton({
                    text: '添加退货单产品',
                    icon: 'plus',
                    onClick: function () {
                        that.ReturnUpn();
                    }
                });

                createRstOutFlowList(model.RstResultList);
                $('#RstOperationLog').DmsOperationLog({
                    dataSource: model.RstLogDetail
                });
                $("#RstDetailList").data("kendoGrid").setOptions({
                    dataSource: model.RstDetailList
                });
                that.InitSetDetailWindow(EntityModel, model.IsDealer);//初始化页面按钮/列等

                if (EntityModel.ConsignmentFrom != "" && EntityModel.ConsignmentFrom != null) {
                    $("#hidChanConsignment").val(EntityModel.ConsignmentFrom);
                }
                else {
                    $("#hidChanConsignment").val("Bsc");
                }

                //产品来源赋值
                $.each(LstcbProductsourceArr, function (index, val) {
                    if ($("#hidChanConsignment").val() === val.Key) {
                        $('#QrycbProductsource').FrameDropdownList('setValue', { Key: $("#hidChanConsignment").val(), Value: val.Value });
                    }
                })

                if ($("#hidChanConsignment").val() == "Bsc") {
                    $('#QrycbSuorcePro').parent().parent().hide();
                }
                else {
                    var tempConsignmentId = EntityModel.ConsignmentId != null ? EntityModel.ConsignmentId : "";
                    $.each(LstProlineDmaArr, function (index, val) {
                        if (tempConsignmentId === val.Id) {
                            $('#QrycbSuorcePro').FrameDropdownList('setValue', { Key: EntityModel.CmId, Value: val.Name });
                        }
                    })
                    $('#QrycbSuorcePro').parent().parent().show();
                }
                if ($("#hidChanConsignment").val() == "Otherdealers") {
                    $("#RstDetailList").data("kendoGrid").columns[4].editable = true;
                }
                else {
                    $("#RstDetailList").data("kendoGrid").columns[4].editable = false;//允许编辑
                }
                that.InitSetAddCfnSetBtnHidden();

                //$('#QryTextHospit').parent().parent().show();
                //$('#QrycbHospital').parent().parent().hide();
                //if (EntityModel.OrderStatus == "Draft") {

                //}
                //else {
                //    $('#QryTextHospit').parent().parent().hide();
                //    $('#QrycbHospital').parent().parent().show();
                //    $('#QryTextHospit').FrameTextBox('setValue', EntityModel.HospitalName);
                //}
                //绑定数据需在前，否则无法获取columns进行设置


                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }
    //权限控制
    that.InitSetDetailWindow = function (header, IsDealer) {
        if (header != null) {
            $("#HiDmaId").val(header.DmaId);
            if (IsDealer) {
                //如果是T1或LP，且单据是“草稿”，则可以修改
                if (EntityModel.OrderStatus == "Draft") {
                    //隐藏复制、放弃修改按钮
                    $('#QrycbHospital').FrameDropdownList('enable');
                    $('#Qrycbproline').FrameDropdownList('enable');
                    $('#QryRule').FrameDropdownList('enable');
                    $('#QryRule').parent().parent().show();
                    $('#QryConsignmentRule').parent().parent().hide();//寄售规则
                    $('#QrycbSuorcePro').FrameDropdownList('enable');
                    $('#QrycbProductsource').FrameDropdownList('enable');
                    $('#QryDelayState').parent().parent().hide();

                    that.removeButton("BtnApplyDelay");

                    $("#RstDetailList").data("kendoGrid").columns[4].editable = false;//允许编辑
                    $("#RstDetailList").data("kendoGrid").hideColumn('Delete');//默认不显示
                    $("#QryConsignment").FrameTextArea('enable');
                    $('#QryRemark').FrameTextArea('enable');
                    $('#QryConsignee').FrameTextBox('enable');
                    $('#QrycbSAPWarehouseAddress').FrameDropdownList('enable');
                    $('#QryConsigneePhone').FrameTextBox('enable');
                    $('#QrydfRDD').FrameDatePicker('enable');
                }
                else {
                    $('#QrycbSuorcePro').FrameDropdownList('disable');
                    $('#QrycbHospital').FrameDropdownList('disable');
                    $('#Qrycbproline').FrameDropdownList('disable');
                    $('#QryRule').FrameDropdownList('disable');
                    $('#QryRule').parent().parent().hide();
                    $('#QryConsignmentRule').parent().parent().show();//寄售规则
                    $('#QrycbProductsource').FrameDropdownList('disable');
                    $('#QryDelayState').parent().parent().show();

                    $('#QrySales').parent().parent().hide();
                    that.removeButton("BtnSave");
                    that.removeButton("BtnDelete");
                    that.removeButton("BtnSubmit");

                    if (EntityModel.OrderStatus == "Submitted") {
                        that.removeButton("BtnApplyDelay");
                    }
                    else if (EntityModel.OrderStatus == "Approved") {
                        $('#BtnApplyDelay').FrameButton({
                            text: '申请延期',
                            icon: 'save',
                            onClick: function () {
                                that.btnDelay();
                            }
                        });
                        if (EntityModel.DelayOrderStatus == "Approved") {
                            if (EntityModel.DelayDelayTime > 0) {
                                $('#BtnApplyDelay').FrameButton({
                                    text: '申请延期',
                                    icon: 'save',
                                    onClick: function () {
                                        that.btnDelay();
                                    }
                                });
                            }
                            else {
                                that.removeButton("BtnApplyDelay");
                            }
                        }
                        if (EntityModel.DelayOrderStatus == "Rejected") {
                            this.BtnDelay.Show();
                        }
                        if (EntityModel.DelayOrderStatus == "Submitted") {
                            that.removeButton("BtnApplyDelay");
                        }
                    }

                    $("#RstDetailList").data("kendoGrid").columns[4].editable = true;
                    $("#RstDetailList").data("kendoGrid").hideColumn('Delete');
                    $("#QryConsignment").FrameTextArea('disable');
                    $('#QryRemark').FrameTextArea('disable');
                    $('#QryConsignee').FrameTextBox('disable');
                    $('#QrycbSAPWarehouseAddress').FrameDropdownList('disable');
                    $('#QryConsigneePhone').FrameTextBox('disable');
                    $('#QrydfRDD').FrameDatePicker('disable');
                }
            }
            else {
                $('#QrycbSuorcePro').FrameDropdownList('disable');
                $('#QrycbHospital').FrameDropdownList('disable');
                $('#Qrycbproline').FrameDropdownList('disable');
                $('#QryRule').FrameDropdownList('disable');
                $('#QryRule').parent().parent().hide();
                $('#QrycbProductsource').FrameDropdownList('disable');
                $('#QrySales').FrameDropdownList('disable');

                $("#QryConsignment").FrameTextArea('disable');
                $('#QryRemark').FrameTextArea('disable');
                $('#QryConsignee').FrameTextBox('disable');
                $('#QrycbSAPWarehouseAddress').FrameDropdownList('disable');
                $('#QryConsigneePhone').FrameTextBox('disable');
                $('#QrydfRDD').FrameDatePicker('disable');
                that.removeButton("BtnSave");
                that.removeButton("BtnDelete");
                that.removeButton("BtnSubmit");
                that.removeButton("BtnApplyDelay");
            }
        }
    }
    that.InitSetAddCfnSetBtnHidden = function () {
        var model = FrameUtil.GetModel();
        if ($("#hidorderState").val() == "Draft") {
            $("#RstDetailList").data("kendoGrid").columns[4].editable = false;
            $("#RstDetailList").data("kendoGrid").showColumn('Delete');

            if (model.QrycbProductsource.Key == "Bsc" || $.trim(model.QrycbProductsource.Key) == "") {
                $('#BtnAddProduct').FrameButton({
                    text: '添加产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddProduct();
                    }
                });
                $('#BtnAddComProduct').FrameButton({
                    text: '添加组产品',
                    icon: 'plus',
                    onClick: function () {
                        that.AddUpn();
                    }
                });
                that.removeButton("BtnReturnOrder");
                $("#RstDetailList").data("kendoGrid").columns[4].editable = false;
            }
            else if (model.QrycbProductsource.Key == "Otherdealers") {
                that.removeButton("BtnReturnOrder");
                that.removeButton("BtnAddProduct");
                that.removeButton("BtnAddComProduct");
                $("#RstDetailList").data("kendoGrid").columns[4].editable = true;//禁用编辑
                if ($.trim(model.QrycbSuorcePro.Key) != "") {
                    $('#BtnReturnOrder').FrameButton({
                        text: '添加退货单产品',
                        icon: 'plus',
                        onClick: function () {
                            that.ReturnUpn();
                        }
                    });
                }
            }
        }
        else {
            that.removeButton("BtnReturnOrder");
            that.removeButton("BtnAddProduct");
            that.removeButton("BtnAddComProduct");
            $("#RstDetailList").data("kendoGrid").columns[4].editable = true;
            $("#RstDetailList").data("kendoGrid").hideColumn('Delete');
        }
    }

    var createRstOutFlowList = function (dataSource) {
        $("#RstDetailList").kendoGrid({
            dataSource: {
                data: dataSource,
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            editable: true,
            //height: 300,
            columns: [
            {
                field: "CustomerFaceNbr", title: "产品型号", width: '150px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品型号" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "CfnChineseName", title: "产品中文名", width: '150px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品中文名" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "CfnEnglishName", title: "产品英文名", width: 'auto', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品英文名" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "UOM", title: "单位", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "单位" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "Qty", title: "申请数量", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "申请数量" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "Price", title: "产品单价", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "产品单价" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "Amount", title: "金额小计", width: '80px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "金额小计" },
                attributes: { "class": "table-td-cell" }
            },
            {
                field: "LotNumber", title: "批号", width: '150px', editable: true,
                headerAttributes: { "class": "text-center text-bold", "title": "批号" },
                attributes: { "class": "table-td-cell" }
            },
             {
                 field: "Delete", title: "删除", width: '60px', editable: true,
                 headerAttributes: { "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;" },
                 template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                 attributes: { "class": "text-center text-bold" },
             }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 10,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;
                var rows = this.items();
                $(rows).each(function () {
                    var index = $(this).index() + 1;
                    var rowLabel = $(this).find(".Row-Number");
                    $(rowLabel).html(index);
                });
                //$("#RstDetailList").find("i[name='delete']").bind('click', function () {
                //    var tr = $(this).closest("tr")
                //    var data = grid.dataItem(tr);
                //    $("#RstDetailList").data("kendoGrid").dataSource.remove(data);
                //    $("#RstDetailList").data("kendoGrid").dataSource.fetch();
                //});

                $("#RstDetailList").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    $("#RstDetailList").data("kendoGrid").dataSource.remove(data);
                    that.DeleteProductItem(data.Id);
                });

            }
        });

        var grid = $("#RstDetailList").data("kendoGrid");
        grid.bind("save", grid_save);
        function grid_save(e) {
            that.UpdateItem(e);
        }
    }
    //刷新数据
    that.RefershHeadData = function () {
        var data = {};
        var parm = FrameUtil.GetModel();
        data.InstanceId = parm.InstanceId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'RefershHeadData',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstDetailList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });
                FrameWindow.HideLoading();
            }
        });
    }

    //修改产品明细单元格由于提示较复杂，故采用单个单元格直接保存的方式
    ///产品明细修改保存
    that.UpdateItem = function (e) {
        var data = {};
        var param = FrameUtil.GetModel();
        data.InstanceId = param.InstanceId;
        data.PlineItemId = e.model.Id;
        if (e.values.CustomerFaceNbr) {
            data.Upn = e.values.CustomerFaceNbr;
        }
        else {
            data.Upn = e.model.CustomerFaceNbr
        }
        if (e.values.Qty) {
            data.RequiredQty = e.values.Qty;
        }
        else {
            data.RequiredQty = e.model.Qty
        }
        if (e.values.Price) {
            data.cfnPrice = e.values.Price;
        }
        else {
            data.cfnPrice = e.model.Price
        }

        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'UpdateItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    var msg = "";
                    if (model.hidRtnVal == "LotTooLong") {
                        msg = "输入的产品编号过长，长度为30";
                    } else if (model.hidRtnVal == "LotNotExists") {
                        msg = "输入的产品编号不存在";
                    } else if (model.hidRtnVal == "LotExisted") {
                        msg = "输入的产品编号已存在";
                    }
                    else if (model.hidRtnVal == "LotPriceExisted") {
                        msg = "相同价格的产品已经存在";
                    }
                    if (msg != "") {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: msg,
                        });
                    }
                    that.RefershHeadData();
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'Error',
                        message: model.ExecuteMessage,
                    });
                }
                FrameWindow.HideLoading();
            }
        });
    };

    //删除产品明细列表（单行删除）
    that.DeleteProductItem = function (PlineItemId) {
        var data = {};
        data.PlineItemId = PlineItemId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DeleteItem',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
            }
        });
    };
    //申请延期
    that.btnDelay = function () {
        var data = that.GetModel();
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定申请延期吗？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DelayClick',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess) {
                            if (model.hidIsSaved) {
                                top.deleteTabsCurrent();
                            }
                            else if (model.hidRtnVal == 'Error') {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'warning',
                                    message: model.hidRtnMsg,
                                    callback: function () {

                                    }
                                });
                            }
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'Error',
                                message: model.ExecuteMessage,
                                callback: function () {
                                }
                            });
                        }
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    };

    that.DeleteDraftOrder = function () {
        $("#hiddIsModifyStatus").val("false");
        if ("true" == $("#IsNewApply").val()) {
            var data = FrameUtil.GetModel();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteDraft',
                url: Common.AppHandler,
                data: data,
                async: false,
                callback: function (model) {
                    if (!model.IsSuccess) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: model.ExecuteMessage,
                        });
                    }
                    FrameWindow.HideLoading();
                    $("#hiddIsModifyStatus").val("true");
                }
            });
        }
    };
    //删除草稿
    that.Delete = function () {
        var data = that.GetModel();
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定删除草稿吗？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteDraft',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess) {
                            if (model.hidIsSaved) {
                                top.deleteTabsCurrent();
                            }
                            else {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'warning',
                                    message: '申请单信息发生改变，请重新操作',
                                    callback: function () {

                                    }
                                });
                            }
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'Error',
                                message: model.ExecuteMessage,
                                callback: function () {
                                }
                            });
                        }
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }

    //保存草稿
    that.Save = function () {
        var data = that.GetModel();
        //验证产品线，否则无法带出订单（分子公司和品牌）
        if ($.trim(data.Qrycbproline.Key) == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线',
            });
            return;
        }
        else {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SaveDraft',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (!model.IsSuccess) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'error',
                            message: model.ExecuteMessage,

                        });
                    }
                    else {
                        if (model.hidIsSaved) {
                            top.deleteTabsCurrent();
                        }
                        else {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'warning',
                                message: '申请单信息发生改变，请重新操作',
                                callback: function () {

                                }
                            });
                        }
                    }
                    FrameWindow.HideLoading();
                }
            });
        }
    }
    //提交
    that.Submit = function () {
        var data = that.GetModel();
        var message = that.CheckForm(data);

        if (message.length > 0) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: message,
            });
        }
        else {
            FrameWindow.ShowConfirm({
                target: 'top',
                message: '确定提交?',
                confirmCallback: function () {
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'CheckSubmit',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            if (!model.IsSuccess) {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'error',
                                    message: model.ExecuteMessage,
                                });
                            }
                            else {
                                if (model.hidRtnVal == "Success") {
                                    that.VerificationSubmit(data);
                                }
                                else if (model.hidRtnVal == "Error") {
                                    FrameWindow.ShowAlert({
                                        target: 'top',
                                        alertType: 'error',
                                        message: model.hidRtnMsg,
                                    });
                                }
                                else if (model.hidRtnVal == "Warn") {
                                    FrameWindow.ShowConfirm({
                                        target: 'top',
                                        message: '验证通过，是否提交?',
                                        confirmCallback: function () {
                                            that.VerificationSubmit(data);
                                        }
                                    })
                                }
                            }
                            FrameWindow.HideLoading();
                        }
                    });
                }
            });

        }
    }

    that.VerificationSubmit = function (data) {
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Submit',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (!model.IsSuccess) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'error',
                        message: model.ExecuteMessage,
                    });
                }
                else {
                    if (model.hidIsSaved) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '提交成功',
                            callback: function () {
                                top.deleteTabsCurrent();
                            }
                        });
                    }
                    else {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'warning',
                            message: '申请单信息发生改变，请重新操作',
                            callback: function () {

                            }
                        });
                    }
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.CheckForm = function (data) {
        var message = [];
        var reg = '^[0-9]*$';
        if ($.trim(data.Qrycbproline.Key) == "") {
            message.push('请选择产品线');
        }
        else if ($.trim(data.QrycbProductsource.Key) == "") {
            message.push('请选择产品来源');
        }
        else if ($.trim(data.QryRule.Key) == "") {
            message.push('请选择寄售合同');
        }
            //else if ($.trim(data.QrycbHospital.Key) == "") {
            //    message.push('请选择医院');
            //}
            //else if ($.trim(data.QrySales.Key) == "") {
            //    message.push('请选择销售');
            //}
        else if ($.trim(data.QrySalesName) == "" || $.trim(data.QrySalesEmail) == "" || $.trim(data.QrySalesPhone) == "") {
            message.push('请填写销售人员信息');
        }
        else if ($.trim(data.QryConsignee) == "") {
            message.push('请填写收货人');
        }
        else if ($.trim(data.QrycbSAPWarehouseAddress.Key) == "") {
            message.push('请选择收货地址');
        }
        else if ($.trim(data.QryConsigneePhone) == "") {
            message.push('请填写收货人电话');
        }
        else if ($.trim(data.QrydfRDD) == "") {
            message.push('请填写期望到货日期');
        }
        //else if ($.trim(data.IptContractDate.StartDate) == "" || data.IptContractDate.EndDate == "") {
        //    message.push('请选择合同时间');
        //}
        if (parseInt(data.QryNumberDays) <= 15 && data.QryConsignment == '') {
            message.push('小于等于15天的寄售必须填写原因寄售原因中填写手术相关信息。');
        }
        if (parseInt(data.QryNumberDays) <= 15 && data.QrycbHospital.Key == '') {
            message.push('Message', '小于等于15天的寄售必须选择医院。');
        }

        return message;
    }

    //添加产品
    that.AddProduct = function () {
        var data = FrameUtil.GetModel();
        data.IptProductLine = data.Qrycbproline.Key;
        data.IptDealer = $("#QryDealerId").val();
        var InstanceId = data.InstanceId;
        var SpecialPrice = "";
        var PriceType = $("#QryPriceType").val();
        var OrderType = $("#QryOrderType").val();
        if (data.IptProductLine == "" || data.IptProductLine == null) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择必要的信息',
            });
        }
        else {
            url = Common.AppVirtualPath + 'Revolution/Pages/Consignment/ConsignmentPicker.aspx?' + 'InstanceId=' + InstanceId + '&&Bu=' + data.IptProductLine + '&&Dealer=' + data.IptDealer + '&&SpecialPrice=' + SpecialPrice + '&&PriceType=' + PriceType + '&&OrderType=' + OrderType,

                    FrameWindow.OpenWindow({
                        target: 'top',
                        title: '添加产品',
                        url: url,
                        width: $(window).width() * 0.7,
                        height: $(window).height() * 0.9,
                        actions: ["Close"],
                        callback: function (list) {
                            if (list) {
                                var pickearr = "";
                                var data = FrameUtil.GetModel();
                                data.InstanceId = $('#InstanceId').val();
                                data.QryBu = $('#ProductLineId').val();
                                for (var i = 0; i <= list.length - 1; i++) {
                                    pickearr += list[i] + ","
                                }
                                data.DealerParams = pickearr;

                                FrameWindow.ShowLoading();
                                FrameUtil.SubmitAjax({
                                    business: business,
                                    method: 'DoAddProductItems',
                                    url: Common.AppHandler,
                                    data: data,
                                    callback: function (model) {
                                        var dataSource = $("#RstDetailList").data("kendoGrid").dataSource.data();

                                        for (var i = 0; i < model.RstResultList.length; i++) {
                                            var exists = false;
                                            for (var j = 0; j < dataSource.length; j++) {
                                                if (dataSource[j].Id == model.RstResultList[i].Id) {
                                                    exists = true;
                                                }
                                            }

                                            if (!exists) {
                                                $("#RstDetailList").data("kendoGrid").dataSource.add(model.RstResultList[i]);
                                            }
                                        }
                                        //$("#RstDetailList").data("kendoGrid").dataSource.fetch();
                                        $("#RstDetailList").data("kendoGrid").setOptions({
                                            dataSource: $("#RstDetailList").data("kendoGrid").dataSource
                                        });
                                        FrameWindow.HideLoading();
                                    }
                                });
                            }
                        }
                    });
        }
    }
    //添加组产品
    that.AddUpn = function () {
        var data = FrameUtil.GetModel();
        data.IptProductLine = data.Qrycbproline.Key;
        data.OrderType = $("#QryOrderType").val();
        data.IptDealer = $("#QryDealerId").val();
        if (data.IptProductLine.Key == "" || data.IptDealer == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线和经销商',
            });
        }
        else {

            url = Common.AppVirtualPath + 'Revolution/Pages/Consignment/ConsignmentUpnPicker.aspx?' + 'Bu=' + data.IptProductLine + '&&Dealer=' + data.IptDealer + '&&HeaderId=' + data.InstanceId + '&&OrderTypeId=' + data.OrderType,

            FrameWindow.OpenWindow({
                target: 'top',
                title: '添加组产品',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (list) {
                    if (list) {
                        var pickearr = "";
                        var data = FrameUtil.GetModel();
                        data.InstanceId = $('#InstanceId').val();
                        for (var i = 0; i <= list.length - 1; i++) {
                            pickearr += list[i] + ","
                        }
                        data.DealerParams = pickearr;

                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'DoAddCfnSet',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                var dataSource = $("#RstDetailList").data("kendoGrid").dataSource.data();

                                for (var i = 0; i < model.RstResultList.length; i++) {
                                    var exists = false;
                                    for (var j = 0; j < dataSource.length; j++) {
                                        if (dataSource[j].Id == model.RstResultList[i].Id) {
                                            exists = true;
                                        }
                                    }
                                    if (!exists) {
                                        $("#RstDetailList").data("kendoGrid").dataSource.add(model.RstResultList[i]);
                                    }
                                }
                                //$("#RstDetailList").data("kendoGrid").dataSource.fetch();
                                $("#RstDetailList").data("kendoGrid").setOptions({
                                    dataSource: $("#RstDetailList").data("kendoGrid").dataSource
                                });
                                FrameWindow.HideLoading();
                            }
                        });
                    }
                }
            });
        }
    }

    //添加退货单产品
    that.ReturnUpn = function () {
        var data = FrameUtil.GetModel();
        data.IptProductLine = data.Qrycbproline.Key;
        data.IptDealer = $("#QryDealerId").val();
        if (data.IptProductLine.Key == "" || data.IptDealer == "" || data.QrycbSuorcePro.Key == "" || data.QryRule.Key == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线、经销商、经销商来源和寄售合同',
            });
        }
        else {

            url = Common.AppVirtualPath + 'Revolution/Pages/Consignment/ConsignmentReturnsPicker.aspx?' + 'Bu=' + data.IptProductLine + '&&Dealer=' + data.IptDealer + '&&HeaderId=' + data.InstanceId + '&&SuorceProId=' + data.SuorcePro.Key + '&&QryRuleId' + data.QryRule.Key,

            FrameWindow.OpenWindow({
                target: 'top',
                title: '退货单产品',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (list) {
                    if (list) {
                        var pickearr = "";
                        var data = FrameUtil.GetModel();
                        data.InstanceId = $('#InstanceId').val();
                        for (var i = 0; i <= list.length - 1; i++) {
                            pickearr += list[i] + ","
                        }
                        data.DealerParams = pickearr;

                        FrameWindow.ShowLoading();
                        FrameUtil.SubmitAjax({
                            business: business,
                            method: 'AddOtherdealersCfn',
                            url: Common.AppHandler,
                            data: data,
                            callback: function (model) {
                                var dataSource = $("#RstDetailList").data("kendoGrid").dataSource.data();

                                for (var i = 0; i < model.RstResultList.length; i++) {
                                    var exists = false;
                                    for (var j = 0; j < dataSource.length; j++) {
                                        if (dataSource[j].Id == model.RstResultList[i].Id) {
                                            exists = true;
                                        }
                                    }
                                    if (!exists) {
                                        $("#RstDetailList").data("kendoGrid").dataSource.add(model.RstResultList[i]);
                                    }
                                }
                                //$("#RstDetailList").data("kendoGrid").dataSource.fetch();
                                $("#RstDetailList").data("kendoGrid").setOptions({
                                    dataSource: $("#RstDetailList").data("kendoGrid").dataSource
                                });
                                FrameWindow.HideLoading();
                            }
                        });
                    }
                }
            });
        }
    }

    //医院选择
    that.ChoiceHospital = function () {
        var data = FrameUtil.GetModel();
        data.IptProductLine = data.Qrycbproline.Key;
        if (data.IptProductLine == "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择产品线'
            });
        }
        else {

            url = Common.AppVirtualPath + 'Revolution/Pages/Consignment/HospitalPicker.aspx?' + 'ProductLine=' + data.IptProductLine

            FrameWindow.OpenWindow({
                target: 'top',
                title: '医院选择',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (list) {
                    if (list) {
                        var hospitalname = list[0].HospitalName;
                        var HOS_Address = list[0].HospitalAddress;
                        $('#QryTexthospitalname').FrameTextBox({
                            value: hospitalname,
                        });
                        $('#QryHospitalAddress').FrameTextBox({
                            value: HOS_Address,
                        });

                    }
                }
            });
        }
    }


    //修改产品线
    that.ProductLineChange = function (Bu) {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '产品线发生改变，是否删除原有申请单？',
            confirmCallback: function () {
                //先清除，否则原始绑定的值一致存在
                $('#QryRule').FrameDropdownList('setValue', { Key: '', Value: '' });
                $('#QrySales').FrameDropdownList('setValue', { Key: '', Value: '' });
                that.ClearConsignmentinfo();
                that.ClearSaleInfo();
                var data = FrameUtil.GetModel();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'ChangeProductLine',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        $("#hidProductLine").val(Bu);
                        LstProlineDmaArr = model.LstProlineDma;
                        LstcbProductsourceArr = model.LstcbProductsource;
                        LstSalesRepArr = model.LstSalesRepStor;
                        //销售
                        $('#QrySales').FrameDropdownList({
                            dataSource: model.LstSalesRepStor,
                            dataKey: 'Id',
                            dataValue: 'Name',
                            selectType: 'none',
                            value: '',
                            onChange: function (s) {
                                that.ChangeSalesRepStor(s.target.value);
                            },
                        });
                        //寄售合同     
                        $('#QryRule').FrameDropdownList({
                            dataSource: model.LstDealerConsignment,
                            dataKey: 'Id',
                            dataValue: 'Name',
                            selectType: 'none',
                            value: '',
                            onChange: function (s) {
                                that.RulesChange(this.value);
                            }
                        });
                        //SetConsignmentinfo
                        $('#QryNumberDays').FrameTextBox('setValue', model.QryNumberDays);
                        $('#QryDelaytimes').FrameTextBox('setValue', model.QryDelaytimes);
                        $('#QryBeginData').FrameTextBox('setValue', model.QryBeginData);
                        $('#QryIsControlAmount').FrameTextBox('setValue', model.QryIsControlAmount);
                        $('#QryIsControlNumber').FrameTextBox('setValue', model.QryIsControlNumber);
                        $('#QryEndData').FrameTextBox('setValue', model.QryEndData);
                        $('#QryIsDiscount').FrameTextBox('setValue', model.QryIsDiscount);
                        $('#QryIsKB').FrameTextBox('setValue', model.QryIsKB);
                        //经销商来源
                        $('#QrycbSuorcePro').FrameDropdownList({
                            dataSource: model.LstProlineDma,
                            dataKey: 'Id',
                            dataValue: 'Name',
                            selectType: 'none',
                            value: QrycbSuorcePro,
                            onChange: function (e) {
                                that.SuorceProChange(this.value);
                            }
                        });
                        //医院修改
                        $('#QrycbHospital').FrameDropdownList({
                            dataSource: model.LstcbHospital,
                            dataKey: 'Id',
                            dataValue: 'Name',
                            selectType: 'none',
                            value: model.QrycbHospital,
                            onChange: function (s) {
                                that.HospitalChange(this.value);
                            }
                        });
                        that.InitSetAddCfnSetBtnHidden();
                        if ($.trim(data.QrycbHospital.Key) != '') {
                            HospitBind();
                        }
                        that.RefershHeadData();

                        FrameWindow.HideLoading();
                    }
                });
            },
            cancelCallback: function () {
                var CancelBu = { Key: '', Value: '' };
                $.each(LstBuArr, function (index, val) {
                    if ($("#hidProductLine").val() === val.Key)
                        CancelBu = { Key: $("#hidProductLine").val(), Value: val.Value };
                })
                $('#Qrycbproline').FrameDropdownList('setValue', CancelBu);
            }
        });
    }

    that.ClearConsignmentinfo = function () {
        $("#hidConsignment").val('');
        $('#QryNumberDays').FrameTextBox('setValue', '');
        $('#QryDelaytimes').FrameTextBox('setValue', '');
        $('#QryBeginData').FrameTextBox('setValue', '');
        $('#QryIsControlAmount').FrameTextBox('setValue', '');
        $('#QryIsControlNumber').FrameTextBox('setValue', '');
        $('#QryEndData').FrameTextBox('setValue', '');
        $('#QryTaoteprice').FrameTextBox('setValue', '');
        $('#QryIsDiscount').FrameTextBox('setValue', '');
        $('#QryIsKB').FrameTextBox('setValue', '');

    };
    that.ClearSaleInfo = function () {
        $('#QrySalesName').FrameTextBox('setValue', '');
        $('#QrySalesEmail').FrameTextBox('setValue', '');
        $('#QrySalesPhone').FrameTextBox('setValue', '');
        $('#QryTexthospitalname').FrameTextBox('setValue', '');
        $('#QryHospitalAddress').FrameTextBox('setValue', '');
    };
    //修改寄售合同
    that.RulesChange = function (rule) {
        that.ClearConsignmentinfo();
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'SetConsignment',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#hidConsignment").val(rule);
                //SetConsignmentinfo
                $('#QryNumberDays').FrameTextBox('setValue', model.QryNumberDays);
                $('#QryDelaytimes').FrameTextBox('setValue', model.QryDelaytimes);
                $('#QryBeginData').FrameTextBox('setValue', model.QryBeginData);
                $('#QryIsControlAmount').FrameTextBox('setValue', model.QryIsControlAmount);
                $('#QryIsControlNumber').FrameTextBox('setValue', model.QryIsControlNumber);
                $('#QryEndData').FrameTextBox('setValue', model.QryEndData);
                $('#QryIsDiscount').FrameTextBox('setValue', model.QryIsDiscount);
                $('#QryIsKB').FrameTextBox('setValue', model.QryIsKB);
                that.InitSetAddCfnSetBtnHidden();
                that.RefershHeadData();
                FrameWindow.HideLoading();
            }
        });
    }

    //来源经销商修改
    that.SuorceProChange = function (SuorcePro) {
        $('#BtnReturnOrder').unbind();
        $('#BtnReturnOrder').FrameButton({
            text: '添加退货单产品',
            icon: 'plus',
            onClick: function () {
                that.ReturnUpn();
            }
        });
    }

    //产品来源修改 
    that.ChanConsignmentFrom = function (ProductsourceId) {
        var data = FrameUtil.GetModel();
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '产品来源发送改变，是否删除原有申请单?',
            confirmCallback: function () {
                createRstOutFlowList([]);

                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'ChanConsignmentFrom',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        $("#hidChanConsignment").val(ProductsourceId);

                        if (ProductsourceId == "Bsc") {
                            that.removeButton("BtnReturnOrder");
                            $('#BtnAddProduct').FrameButton({
                                text: '添加产品',
                                icon: 'search',
                                onClick: function () {
                                    that.AddProduct();
                                }
                            });
                            $('#BtnAddComProduct').FrameButton({
                                text: '添加组产品',
                                icon: 'search',
                                onClick: function () {
                                    that.AddUpn();
                                }
                            });
                            $('#QrycbProductsource').parent().parent().hide();
                        }
                        else if (ProductsourceId == "Otherdealers") {
                            $('#QrycbProductsource').parent().parent().show();
                            that.removeButton("BtnReturnOrder");
                            that.removeButton("BtnAddProduct");
                            that.removeButton("BtnAddComProduct");
                        }
                        $('#QrycbProductsource').FrameDropdownList('setValue', '');

                        FrameWindow.HideLoading();

                    }
                });
            },
            cancelCallback: function () {
                var CancelProSource = { Key: '', Value: '' };
                $.each(LstcbProductsourceArr, function (index, val) {
                    if ($("#hidChanConsignment").val() === val.Key)
                        CancelProSource = { Key: $("#hidChanConsignment").val(), Value: val.Value };
                })
                $('#QrycbProductsource').FrameDropdownList('setValue', CancelProSource);
            }
        });
    };

    //医院修改
    that.HospitalChange = function (hospitalId) {
        if ($("#HospId").val() != hospitalId)
            HospitBind();
    }

    var HospitBind = function () {
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'HospitChange',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $.each(LstSalesRepArr, function (index, val) {
                    if (model.SaleSelectedId === val.Id) {
                        $('#QrySales').FrameDropdownList('setValue', { Key: val.Id, Value: val.Name });
                    }
                })
                that.ChangeSalesRepStor();//销售修改
                $("#HospId").val(data.QrycbHospital.Key);

                FrameWindow.HideLoading();
            }
        });
    }

    //变更销售
    that.ChangeSalesRepStor = function (obj) {
        var SalesName = "";
        var SalesEmail = "";
        var SalesPhone = "";
        $.each(LstSalesRepArr, function (index, val) {
            if (obj === val.Id) {
                SalesName = val.Name;
                SalesEmail = val.Email;
                SalesPhone = val.Mobile;
            }
        })
        $('#QrySalesName').FrameTextBox('setValue', SalesName);
        $('#QrySalesEmail').FrameTextBox('setValue', SalesEmail);
        $('#QrySalesPhone').FrameTextBox('setValue', SalesPhone);
    }

    that.removeButton = function (obj) {
        $('#' + obj + '').empty();
        $('#' + obj + '').removeClass();
        $('#' + obj + '').unbind();
    };

    var setLayout = function () {
    }

    return that;
}();
