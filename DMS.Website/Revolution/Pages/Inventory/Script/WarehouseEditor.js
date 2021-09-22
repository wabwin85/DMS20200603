var WarehouseEditor = {};

WarehouseEditor = function () {
    var that = {};

    var business = 'Inventory.WarehouseEditor';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        $('#IptDmaID').val(Common.GetUrlParam('DmaId'));
        $('#IptID').val(Common.GetUrlParam('Id'));
        var data = that.GetModel();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#IptDmaID").val(model.IptDmaID);
                $("#IptID").val(model.IptID);
                $("#ChangeType").val(model.ChangeType);
                $("#IptConID").val(model.IptConID);
                $("#IptHoldWarehouse").val(model.IptHoldWarehouse);
                $('#IptWHCode').FrameTextBox({
                    value: model.IptWHCode
                });
                $('#IptWHName').FrameTextBox({
                    value: model.IptWHName
                });
                $('#IptWHActiveFlag').FrameSwitch({
                    onLabel: "有效",
                    offLabel: "失效",
                    value: model.IptWHActiveFlag
                });
                $('#IptWHHospName').FrameTextBox({
                    value: model.IptWHHospName,
                    readonly: true
                });
                $("#IptHosp").val(model.IptHosp);
                $('#IptWHProvince').FrameTextBox({
                    value: model.IptWHProvince
                });
                $('#IptWHCity').FrameTextBox({
                    value: model.IptWHCity
                });
                $('#IptWHTown').FrameTextBox({
                    value: model.IptWHTown
                });
                $('#IptWHAddress').FrameTextBox({
                    value: model.IptWHAddress
                });
                $('#IptPostalCOD').FrameTextBox({
                    value: model.IptPostalCOD
                });
                $('#IptWHPhone').FrameTextBox({
                    value: model.IptWHPhone
                });
                $('#IptWHFax').FrameTextBox({
                    value: model.IptWHFax
                });
                if (model.IptWHType.Key == 'Normal') {
                    $('#IptWHType').FrameDropdownList({
                        dataSource: model.LstWHType,
                        dataKey: 'Key',
                        dataValue: 'Value',
                        selectType: 'select',
                        value: model.IptWHType.Key
                    });
                    $("#IptWHType_Control").data("kendoDropDownList").value(model.IptWHType.Key);
                }
                else {
                    $('#IptWHType').FrameDropdownList({
                        dataSource: [{ Key: 'LP_Consignment', Value: '平台寄售库' }, { Key: 'LP_Borrow', Value: '平台借货库' }, { Key: 'Borrow', Value: '波科借货库' }, { Key: 'Consignment', Value: '波科寄售库' }, { Key: 'DefaultWH', Value: '缺省仓库' }, { Key: 'Frozen', Value: '冻结库' } ],
                        dataKey: 'Key',
                        dataValue: 'Value'
                    });
                    $("#IptWHType_Control").data("kendoDropDownList").value(model.IptWHType.Key);

                    if (model.IptWHType.Key == "DefaultWH") {
                        $("#BtnSave").attr("disabled", "disabled");
                        $("#BtnSearchHosp").attr("disabled", "disabled");
                    }
                    else {
                        $("#BtnSave").css("display", "none");
                        $("#BtnSearchHosp").css("display", "none");
                    }

                    $("#IptWHName_Control").attr("disabled", "disabled");
                    $("#IptWHHospName_Control").attr("disabled", "disabled");
                    $("#IptWHProvince_Control").attr("disabled", "disabled");
                    $("#IptWHCity_Control").attr("disabled", "disabled");
                    $("#IptWHTown_Control").attr("disabled", "disabled");
                    $("#IptWHAddress_Control").attr("disabled", "disabled");
                    $("#IptPostalCOD_Control").attr("disabled", "disabled");
                    $("#IptWHPhone_Control").attr("disabled", "disabled");
                    $("#IptWHFax_Control").attr("disabled", "disabled");
                    $("#IptWHType").FrameDropdownList('disable');
                    $("#IptWHActiveFlag").FrameSwitch('disable');
                }

                //按钮事件
                $('#BtnSave').FrameButton({
                    text: '保存',
                    icon: 'save',
                    onClick: function () {
                        that.SaveChanges();
                    }
                });
                $('#BtnClose').FrameButton({
                    text: '取消',
                    icon: 'window-close-o',
                    onClick: function () {
                        FrameWindow.CloseWindow({
                            target: 'top'
                        });
                    }
                });
                $('#BtnSearchHosp').FrameButton({
                    text: '查找医院',
                    icon: 'search',
                    onClick: function () {
                        if ($('#cbxCopyHosp').prop('checked')) {
                            that.SearchHospital();
                        }
                        else {
                            kendo.alert("请先选中'复制医院信息'！");
                        }
                    }
                });

                $("#IptWHCode_Control").attr("disabled", "disabled");
                if (model.EnableHospitalBtn == false && model.EnableSaveBtn == false) {
                    $("#BtnSave").FrameButton("disable");
                    $("#BtnSearchHosp").FrameButton("disable");
                }

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });

    }

    that.SearchHospital = function () {
        var url = 'Revolution/Pages/Inventory/WHSearchHospital.aspx';
        FrameWindow.OpenWindow({
            target: 'top',
            title: '医院信息查询',
            url: Common.AppVirtualPath + url,
            width: $(window).width() * 1.1,
            height: $(window).height() * 1.2,
            actions: ["Close"],
            callback: function (list) {
                if (list && list.HosList.length > 0)
                {
                    $('#IptWHHospName').FrameTextBox({
                        value: list.HosList[0].HosHospitalName,
                        readonly: true
                    });
                    $("#IptHosp").val(list.HosList[0].HosId);
                    $('#IptWHProvince').FrameTextBox({
                        value: list.HosList[0].HosProvince
                    });
                    $('#IptWHCity').FrameTextBox({
                        value: list.HosList[0].HosCity
                    });
                    $('#IptWHTown').FrameTextBox({
                        value: list.HosList[0].HosTown
                    });
                    $('#IptWHAddress').FrameTextBox({
                        value: list.HosList[0].HosAddress
                    });
                    $('#IptPostalCOD').FrameTextBox({
                        value: list.HosList[0].HosPostalCode
                    });
                    $('#IptWHPhone').FrameTextBox({
                        value: list.HosList[0].HosPhone
                    });
                    $('#IptWHFax').FrameTextBox({
                        value: list.HosList[0].HosFax
                    });

                }
            }
        });
    }

    that.SaveChanges = function () {
        var data = that.GetModel();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveChanges',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess != true) {
                    kendo.alert(model.ExecuteMessage);
                }
                else {
                    FrameWindow.SetWindowReturnValue({
                        target: 'top',
                        value: 'success'
                    });

                    FrameWindow.CloseWindow({
                        target: 'top'
                    });
                    
                }
                
                setLayout();

                FrameWindow.HideLoading();
            }
        });

        return data.IsSuccess;
    }

    var setLayout = function () {
    }

    return that;
}();