var ConsignmentTerminationInfo = {};

ConsignmentTerminationInfo = function () {
    var that = {};

    var business = 'Consign.ConsignmentTerminationInfo';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();
      
        return model;
    }

    that.Init = function () {
        var data = {};

        data.InstanceId = Common.GetUrlParam('InstanceId');
        data.QryStatus = Common.GetUrlParam('Status');
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                debugger
                var readonly = !(data.QryStatus == "草稿" || data.QryStatus == "");
                if(Common.GetUrlParam('Sub')=="Submit"){
                    var readonly = true;
                }
                
                $('#InstanceId').val(model.InstanceId);
                $('#IsNewApply').val(model.IsNewApply);

                $('#IptApplyBasic').DmsApplyBasic({
                    value: model.IptApplyBasic
                });
                $('#IptConsignContract').DmsConsignContract({
                    dataSource: model.LstContract,
                    dataKey: 'ContractId',
                    dataValue: 'ContractName',
                    selectType: 'select',
                    readonly: model.CheckCreateUser == false ? true : readonly,
                    value: model.IptConsignContract
                });
               
                $('#IptBu').FrameDropdownList({
                    dataSource: model.LstBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.IptBu,
                    readonly: data.QryStatus == "草稿" ? true : readonly,
                    onChange: that.ChangeBu
                });

                $('#IptDealer').DmsDealerFilter({
                    dataSource: [],
                    delegateBusiness: business,
                    dataKey: 'DealerId',
                    dataValue: 'DealerName',
                    selectType: 'select',
                    filter: 'contains',
                    serferFilter: true,
                    value: model.IptDealer,
                    readonly: data.QryStatus == "草稿" ? true : readonly,
                    onChange: that.ChangeBu
                });
                
                $('#IptReason').FrameTextArea({
                    value: model.IptReason,
                    readonly: model.CheckCreateUser == false ? true : readonly
                });
                if (!model.IsNewApply) {
                    $('#RstOperationLog').DmsOperationLog({
                        dataSource: model.RstOperationLog
                    });
                }
                
                if (data.QryStatus == "草稿" || !readonly) {
                    if (model.CheckCreateUser==true) {
                        $('#BtnSave').FrameButton({
                            text: '保存',
                            icon: 'save',
                            onClick: function () {
                                that.Save();
                            }
                        });
                        $('#BtnDelete').FrameButton({
                            text: '删除',
                            icon: 'save',
                            onClick: function () {
                                that.Delete();
                            }
                        });
                        $('#BtnSubmit').FrameButton({
                            text: '提交',
                            icon: 'send',
                            onClick: function () {
                                that.Submit();
                            }
                        });
                    }
                    

                }
                else {
                    $('#BtnSubmit').remove();
                    $('#BtnSave').remove();
                    $('#BtnDelete').remove();
                }

               

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();


                FrameWindow.HideLoading();
            }
        });
    }

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
        
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Submit',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '提交成功',
                        callback: function () {
                            //top.changeTabsName(self.frameElement.getAttribute('id'), model.InstanceId, '寄售终止 - '+model.CST_No);

                            //var url = Common.AppVirtualPath + 'Revolution/Pages/Consign/ConsignmentTerminationInfo.aspx';
                            //url += '?InstanceId=' + model.InstanceId+'&&Sub=Submit';
                            top.deleteTabsCurrent();
                            //window.location = url;
                        }
                    });
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.Save = function () {

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

        
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Save',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '保存成功',
                        callback: function () {
                       
                            //top.changeTabsName(self.frameElement.getAttribute('id'), model.InstanceId, '寄售终止 - ' + model.CST_No);

                            //var url = Common.AppVirtualPath + 'Revolution/Pages/Consign/ConsignmentTerminationInfo.aspx';
                            //url += '?InstanceId=' + model.InstanceId;
                            top.deleteTabsCurrent();
                            //window.location = url;
                        }
                    });
                    FrameWindow.HideLoading();
                }
            });
        }

    }

    that.Delete = function () {

        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定删除草稿吗？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'Delete',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'Delete',
                            message: '删除成功',
                            callback: function () {
                                top.deleteTabsCurrent();
                            }
                        });
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }


    that.ChangeBu = function () {
        var data = FrameUtil.GetModel();
        data.IptBu = $('#IptBu').FrameDropdownList('getValue');
        data.IptDealer = $('#IptDealer').FrameDropdownList('getValue');
        if (data.IptBu.Key != ''&&data.IptDealer.Key!='') {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'ChangeBu',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#IptConsignContract').DmsConsignContract('setDataSource', model.LstConsignContract);

                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.CheckForm = function (data) {
        var message = [];
        if ($.trim(data.IptBu.Key) == "") {
            message.push('请选择产品线');
        }
        else if ($.trim(data.IptDealer.Key) == "") {
            message.push('请选择经销商');
        }
        else if ($.trim(data.IptReason) == "")
        {
            message.push('请填写终止原因');
        }
        else if ($.trim(data.IptConsignContract.ContractId)=="")
        {
            message.push('请选择寄售合同');
        }
        
        return message;
    }






    var setLayout = function () {
    }

    return that;
}();
