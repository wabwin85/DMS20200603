var MyInfo = {};

MyInfo = function () {
    var that = {};

    var business = 'MyInfo';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    that.Init = function () {
        var data = {};

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                
                $('#LoginID').FrameTextBox({
                    value: model.LoginID,
                    readonly: true
                });
                $('#UserName').FrameTextBox({
                    value: model.UserName
                });
                $('#Email1').FrameTextBox({
                    value: model.Email1
                });
                $('#Email2').FrameTextBox({
                    value: model.Email2
                });
                $('#Phone').FrameTextBox({
                    value: model.Phone,
                    readonly:true
                }); 
                $('#Address').FrameTextBox({
                    value: model.Address
                });
                $('#HasCompany').val(model.HasCompany);
                $('#IsNewOrder').val(model.IsNewOrder);
                if (model.HasCompany) {
                    $('#plOrder').show();
                    $('#plCorporation').show();
                    $('#ORContactPerson').FrameTextBox({
                        value: model.ORContactPerson
                    });
                    $('#ORContact').FrameTextBox({
                        value: model.ORContact
                    });
                    $('#ORContactMobile').FrameTextBox({
                        value: model.ORContactMobile
                    });
                    $('#ORConsignee').FrameTextBox({
                        value: model.ORConsignee
                    });
                    $('#ORConsigneePhone').FrameTextBox({
                        value: model.ORConsigneePhone
                    });
                    $('#OROrderEmail').FrameTextBox({
                        value: model.OROrderEmail
                    });
                    $('#ORShipmentDealer').FrameTextBox({
                        value: model.ORShipmentDealer
                    });
                    $('#ORReceiveSMS').FrameSwitch({
                        onLabel: "是",
                        offLabel: "否",
                        value: model.ORReceiveSMS
                    });
                    $('#ORReceiveEmail').FrameSwitch({
                        onLabel: "是",
                        offLabel: "否",
                        value: model.ORReceiveEmail
                    });
                    $('#ORReceiveOrder').FrameSwitch({
                        onLabel: "是",
                        offLabel: "否",
                        value: model.ORReceiveOrder
                    });


                    $('#CPDealerID').FrameTextBox({
                        value: model.CPDealerID,
                        readonly: true
                    });
                    $('#CPDealerChineseName').FrameTextBox({
                        value: model.CPDealerChineseName,
                        readonly: true
                    });
                    $('#CPDealerEnglishName').FrameTextBox({
                        value: model.CPDealerEnglishName,
                        readonly: true
                    });
                    $('#CPDealerCertification').FrameTextBox({
                        value: model.CPDealerCertification,
                        readonly: true
                    });
                    $('#CPDealerAddress').FrameTextBox({
                        value: model.CPDealerAddress,
                        readonly: true
                    });
                    $('#CPDealerPostalCode').FrameTextBox({
                        value: model.CPDealerPostalCode,
                        readonly: true
                    });
                    $('#CPDealerPhone').FrameTextBox({
                        value: model.CPDealerPhone,
                        readonly: true
                    });
                    $('#CPDealerFax').FrameTextBox({
                        value: model.CPDealerFax,
                        readonly: true
                    });
                }
                else {
                    $('#plOrder').hide();
                    $('#plCorporation').hide();
                }
                $('#BtnSave').FrameButton({
                    text: '保存',
                    icon: 'save',
                    onClick: function () {
                        that.Save();
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

    that.Save = function () {        
        var data = FrameUtil.GetModel();
        data.IsNewOrder = $('#IsNewOrder').val();
        data.HasCompany = $('#HasCompany').val();
           
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Save',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {                
                if (model.IsSuccess) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '保存成功',
                        callback: function () {
                            //top.deleteTabsCurrent();
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
                FrameWindow.HideLoading();
            }
        });
    }

    

    var setLayout = function () {
    }

    return that;
}();
