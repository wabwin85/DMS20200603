var TerritoryEditor = {};

TerritoryEditor = function () {
    var that = {};

    var business = 'MasterDatas.TerritoryEditor';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        $('#IptTerId').val(Common.GetUrlParam('Id'));
        var data = that.GetModel();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#IptTerId").val(model.IptTerId);
                $("#ChangeType").val(model.ChangeType);

                $('#IptTerCode').FrameTextBox({
                    value: model.IptTerCode
                });
                $('#IptTerName').FrameTextBox({
                    value: model.IptTerName
                });
                $('#IptTerType').FrameDropdownList({
                    dataSource: model.LstTerType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.IptTerType.Key,
                    onChange: that.TerTypeChange
                });
                that.TerTypeChange();
                $("#IptTerType_Control").data("kendoDropDownList").value(model.IptTerType.Key);
                if (model.ChangeType == "UpdateData") {
                    $("#IptTerType_Control").data("kendoDropDownList").readonly(true);
                }
                $('#IptProvince').FrameDropdownList({
                    dataSource: model.LstProvince,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.IptProvince.Key,
                    onChange: that.ProvinceChange
                });
                $("#IptProvince_Control").data("kendoDropDownList").value(model.IptProvince.Key);
                $('#IptCity').FrameDropdownList({
                    dataSource: model.LstCity,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'select',
                    value: model.IptCity.Key
                });
                $("#IptCity_Control").data("kendoDropDownList").value(model.IptCity.Key);
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
    that.TerTypeChange = function () {
        var data = that.GetModel();
        if (data.IptTerType.Key == "Province") {
            $("#IptProvince").closest("div[class='row']") .hide();
            $("#IptCity").closest("div[class='row']").hide();
        } else if (data.IptTerType.Key == "City") {
            $("#IptProvince").closest("div[class='row']").show();
            $("#IptCity").closest("div[class='row']").hide();

        } else if (data.IptTerType.Key == "County") {
            $("#IptProvince").closest("div[class='row']").show();
            $("#IptCity").closest("div[class='row']").show();
        }
    }
    that.ProvinceChange = function () {
        var data = that.GetModel();
        if (data.IptProvince.Key == "") {
            $('#IptCity').FrameDropdownList({
                dataSource: [],
                dataKey: 'TerId',
                dataValue: 'Description',
                selectType: 'select'
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'ProvinceChange',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#IptCity').FrameDropdownList({
                        dataSource: model.LstCity,
                        dataKey: 'TerId',
                        dataValue: 'Description',
                        selectType: 'select',
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.SaveChanges = function () {
        var data = that.GetModel();

        if (data.IptTerName == "") {            
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请完整填写区域信息！',
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