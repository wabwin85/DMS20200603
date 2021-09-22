var HospitalEditor = {};

HospitalEditor = function () {
    var that = {};

    var business = 'MasterDatas.HospitalEditor';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        $('#IptHosID').val(Common.GetUrlParam('Id'));
        var data = that.GetModel();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#IptHosID").val(model.IptHosID);
                $("#ChangeType").val(model.ChangeType);
                $('#IptHPLCode').FrameTextBox({
                    value: model.IptHPLCode
                });
                $('#IptHPLName').FrameTextBox({
                    value: model.IptHPLName
                });
                $('#IptHPLSName').FrameTextBox({
                    value: model.IptHPLSName
                });
                $('#IptHPLPhone').FrameTextBox({
                    value: model.IptHPLPhone
                });
                $('#IptHPLAddress').FrameTextBox({
                    value: model.IptHPLAddress
                });
                $('#IptHPLPostalCOD').FrameTextBox({
                    value: model.IptHPLPostalCOD
                });
                $('#IptHPLDean').FrameTextBox({
                    value: model.IptHPLDean
                });
                $('#IptHPLDeanContact').FrameTextBox({
                    value: model.IptHPLDeanContact
                });
                $('#IptHPLHead').FrameTextBox({
                    value: model.IptHPLHead
                });
                $('#IptHPLHeadContact').FrameTextBox({
                    value: model.IptHPLHeadContact
                });
                $('#IptHPLWeb').FrameTextBox({
                    value: model.IptHPLWeb
                });
                $('#IptHPLBSCode').FrameTextBox({
                    value: model.IptHPLBSCode
                });
                
                $("#IptHPLCode_Control").attr("disabled", "disabled");

                $('#IptHPLGrade').FrameDropdownList({
                    dataSource: model.LstHPLGrade,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.IptHPLGrade.Key
                });
                $("#IptHPLGrade_Control").data("kendoDropDownList").value(model.IptHPLGrade.Key);
                $('#IptHPLProvince').FrameDropdownList({
                    dataSource: model.LstHPLProvince,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.IptHPLProvince.Key,
                    onChange: that.ProvinceChange
                });
                $("#IptHPLProvince_Control").data("kendoDropDownList").value(model.IptHPLProvince.Key);
                if (model.IptHPLRegion.Key != "") {
                    $('#IptHPLRegion').FrameDropdownList({
                        dataSource: [{ TerId: model.IptHPLRegion.Key, Description: model.IptHPLRegion.Value }],
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select',
                        onChange: that.RegionChange
                    });
                    $("#IptHPLRegion_Control").data("kendoDropDownList").value(model.IptHPLRegion.Key);
                }
                else {
                    $('#IptHPLRegion').FrameDropdownList({
                        dataSource: model.LstHPLRegion,
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select',
                        onChange: that.RegionChange
                    });
                }
                if (model.IptHPLTown.Key != "") {
                    $('#IptHPLTown').FrameDropdownList({
                        dataSource: [{ TerId: model.IptHPLTown.Key, Description: model.IptHPLTown.Value }],
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select'
                    });
                    $("#IptHPLTown_Control").data("kendoDropDownList").value(model.IptHPLTown.Key);
                }
                else {
                    $('#IptHPLTown').FrameDropdownList({
                        dataSource: model.LstHPLTown,
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select'
                    });
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
                
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });

    }

    that.ProvinceChange = function () {

        var data = that.GetModel();
        if (data.IptHPLProvince.Key == "") {
            $('#IptHPLRegion').FrameDropdownList({
                dataSource: [],
                dataKey: 'TerId',
                dataValue: 'Description',
                selectType: 'select',
                onChange: that.RegionChange
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'ProvinceChange',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#IptHPLRegion').FrameDropdownList({
                        dataSource: model.LstHPLRegion,
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select',
                        onChange: that.RegionChange
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
        $('#IptHPLTown').FrameDropdownList({
            dataSource: [],
            dataKey: 'TerId',
            dataValue: 'Description',
            selectType: 'select'
        });
    }

    that.RegionChange = function () {

        var data = that.GetModel();
        if (data.IptHPLRegion.Key == "") {
            $('#IptHPLTown').FrameDropdownList({
                dataSource: [],
                dataKey: 'TerId',
                dataValue: 'Description',
                selectType: 'select'
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'RegionChange',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#IptHPLTown').FrameDropdownList({
                        dataSource: model.LstHPLTown,
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select'
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.SaveChanges = function () {
        var data = that.GetModel();

        if (data.IptHPLName == "" || data.IptHPLProvince.Key == "" || data.IptHPLRegion.Key == "" || data.IptHPLTown.Key == "") {
            //kendo.alert("请完整填写医院信息");
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请完整填写医院信息！',
                callback: function () {
                }
            });
            data.IsSuccess = false;
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SaveChanges',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess != true) {
                        //kendo.alert(model.ExecuteMessage);
                        FrameWindow.ShowAlert({
                            target: 'center',
                            alertType: 'info',
                            message: model.ExecuteMessage,
                            callback: function () {
                            }
                        });
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
        }

        return data.IsSuccess;

    }

    var setLayout = function () {
    }

    return that;
}();