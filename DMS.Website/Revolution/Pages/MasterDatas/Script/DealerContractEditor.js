var DealerContractEditor = {};

DealerContractEditor = function () {
    var that = {};

    var business = 'MasterDatas.DealerContractEditor';
    var businessServer = 'MasterDatas.PartsClsfcList';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();
        return model;
    }
    var isCreated = true;//新增
    var PartsTypeArr = [];
    var LstAuthTypeArr = [];
    var LstApplyAuthTypeArr = [];
    var DelDlg_hospitalIdArr = [];//删除医院
    var Choice_hospitalIdArr = [];//选择医院
    var Copy_hospitalIdArr = [];//复制医院
    var deleteHospitalIdArr = [];//删除医院选中Rows

    that.Init = function () {
        //主页面
        $("#ContractId").val(Common.GetUrlParam('ct'));
        $("#hidDealerId").val(Common.GetUrlParam('dr'));
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: that.GetModel(),
            callback: function (model) {
                LstAuthTypeArr = model.LstAuthType;
                LstApplyAuthTypeArr = model.LstApplyAuthType;
                $('#lbDealerName').text(model.DealerName);

                $('#ProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryProductLine,
                    //onChange: function (s) {
                    //    that.ProductLineChange(this.value);
                    //}
                });
                $('#AuthType').FrameDropdownList({
                    dataSource: model.LstAuthType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: model.QryAuthType
                });
            }
        });
        //$('#QryDealer').DmsDealerFilter({
        //    dataSource: [],
        //    delegateBusiness: business,
        //    dataKey: 'DealerId',
        //    dataValue: 'DealerName',
        //    selectType: 'select',
        //    filter: 'contains',
        //    serferFilter: true,
        //    value: model.QryDealer
        //});
        var model = FrameUtil.GetModel();
        $('#QryAuthStartDate').FrameDatePickerRange({
            value: model.QryAuthStartDate
        });
        $('#QryAuthStopDate').FrameDatePickerRange({
            value: model.QryAuthStopDate
        });
        $('#QryHosStartDate').FrameDatePickerRange({
            value: model.QryHosStartDate
        });
        $('#QryHosStopDate').FrameDatePickerRange({
            value: model.QryHosStopDate
        });
        $('#HosHospitalName').FrameTextBox({
            value: model.QryHospitalName
        });
        $('#HosNoAuthDate').FrameSwitch({
            onLabel: "是",
            offLabel: "否",
            value: model.QryNotHasHosDate
        });
        //编辑或新增页面
        $('#IptProductLine').FrameTextBox({
            value: model.IptProductLine
        });
        $('#IptProductLine').FrameTextBox('disable');
        $('#IptCatagoryName').FrameTextBox({
            value: model.IptCatagoryName
        });
        $('#IptCatagoryName').FrameTextBox('disable');
        $("#IptAuthStartDate").FrameDatePicker({
            value: model.IptAuthStartDate,
            onChange: that.startChange,
            max: model.IptAuthStopDate
        });
        $("#IptAuthStopDate").FrameDatePicker({
            value: model.IptAuthStopDate,
            onChange: that.endChange,
            min: model.IptAuthStartDate
        });
        $('#IptProductDesc').FrameTextBox({
            value: model.IptProductDesc
        });
        $('#IptNote').FrameTextArea({
            value: model.IptNote
        });

        //主页面
        $('#BtnQuery').FrameButton({
            text: '查询',
            icon: 'search',
            onClick: function () {
                that.QueryAuthorization();
            }
        });
        $('#BtnNew').FrameButton({
            text: '新增授权',
            icon: 'plus-square',
            onClick: function () {
                isCreated = true;
                that.initAuthorizationEditor();
            }
        });
        $('#BtnDelete').FrameButton({
            text: '删除',
            icon: 'trash-o',
            onClick: function () {
                that.DeleteAuthorization();
            }
        });
        $('#BtnDelete').FrameButton('disable');
        $('#BtnSearchHospital').FrameButton({
            text: '查询',
            icon: 'search',
            onClick: function () {
                that.QueryHospital();
            }
        });
        $('#BtnAddHospital').FrameButton({
            text: '选择医院',
            icon: 'plus-square',
            onClick: function () {
                var lineId = $('#hiddenProductLine').val();
                var dclId = $('#hiddenId').val();
                if (dms.common.isNullorEmpty(lineId) || dms.common.isNullorEmpty(dclId)) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '请选择授权分类!',
                    });
                }
                else {
                    that.ShowHospitalSelectorDlg();
                }
            }
        });
        $('#BtnCopyHospital').FrameButton({
            text: '复制医院',
            icon: 'plus-square',
            onClick: function () {
                var lineId = $('#hiddenProductLine').val();
                var dclId = $('#hiddenId').val();
                if (dms.common.isNullorEmpty(lineId) || dms.common.isNullorEmpty(dclId)) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '请选择授权分类!',
                    });
                }
                else {
                    that.ShowHospitalCopyDlg();
                }
            }
        });
        $('#BtnSelectedDel').FrameButton({
            text: '删除医院',
            icon: 'minus-circle',
            onClick: function () {
                var lineId = $('#hiddenProductLine').val();
                var dclId = $('#hiddenId').val();
                if (dms.common.isNullorEmpty(lineId) || dms.common.isNullorEmpty(dclId)) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '请选择授权分类!',
                    });
                }
                else {
                    that.ShowHospitalSelectdDelDlg();
                }
            }
        });

        $('#BtnDeleteHospital').FrameButton({
            text: '删除',
            icon: 'trash-o',
            onClick: function () {
                that.DeleteSelectedHosp();
            }
        });


        //附件上传
        $('#WinAttachUpload').kendoUpload({
            async: {
                saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=DealerAuthorization",
                autoUpload: true
            },
            upload: function (e) {
                e.data = { InstanceId: $('#hiddenId').val() };
            },
            multiple: false,
            success: function (e) {
                that.RstAttachmentList();
            }
        });
        createAuthorizationList([]);
        createAuthHospitalList([]);

        //注册popover
        $('[data-toggle="popover"]').popover();

        $("#treeview").kendoTreeView({
            loadOnDemand: false,
            dataSource: that.treeNode,
            dataTextField: "Name",
            select: that.onSelect
        });

        $("#divSplit").kendoSplitter({
            orientation: "divSplit",
            panes: [
                { collapsible: true, size: "500px" },
                { collapsible: false },
                { collapsible: true }
            ]
        });

        $(window).resize(function () {
            setLayout();
        });
        FrameWindow.HideLoading();
    }

    //授权属性
    that.initAuthorizationEditor = function (record) {
        //编辑或新增页面
        $('#BtnAddAttach').FrameButton({
            text: '添加附件',
            icon: 'plus',
            onClick: function () {
                that.ShowUploadAttachDlg();
            }
        });
        $('#BtnSaveAut').FrameButton({
            text: '确认',
            icon: 'floppy-o',
            onClick: function () {
                that.SaveAuthorization();
            }
        });
        $('#BtnCancelAut').FrameButton({
            text: '取消',
            icon: 'times',
            onClick: function () {
                $("#winAuthorizationEditor").data("kendoWindow").close();
            }
        });

        if (record) {
            var rowGrid = record;
            $('#IptAuthTypeForEdit').FrameDropdownList({
                dataSource: LstAuthTypeArr,
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'none',
                value: ''
            });
            $('#hiddenId').val(rowGrid.Id);
            $('#hiddenCatagoryId').val(rowGrid.PmaId);
            $('#IptProductLine').FrameTextBox('setValue', record.ProductLineDesc);
            $('#IptCatagoryName').FrameTextBox('setValue', record.PmaDesc);

            if (record.StartDate != null && record.StartDate != '') {
                var dt1 = new Date(record.StartDate);
                $("#IptAuthStartDate").FrameDatePicker('setValue', dt1);
            }
            else {
                $("#IptAuthStartDate").FrameDatePicker('setValue', '');
            }

            if (record.EndDate != null && record.EndDate != '') {
                var dt2 = new Date(record.EndDate);
                $("#IptAuthStopDate").FrameDatePicker('setValue', dt2);
            }
            else {
                $("#IptAuthStopDate").FrameDatePicker('setValue', '');
            }
            $('#IptProductDesc').FrameTextBox('setValue', record.ProductDescription);
            $('#IptNote').FrameTextBox('setValue', record.HospitalListDesc);
            $('#hiddenProductLine').val(rowGrid.ProductLineBumId);

            var IptAuthTypeForEdit = { Key: "", Value: "" };
            if (record.Type != "" && record.Type != null) {
                $.each(LstAuthTypeArr, function (index, val) {
                    if (record.Type === val.Key)
                        IptAuthTypeForEdit = { Key: val.Key, Value: val.Value };
                })
            }
            $('#IptAuthTypeForEdit').FrameDropdownList('setValue', IptAuthTypeForEdit);
            $('#IptAuthTypeForEdit').FrameDropdownList('disable');

            that.QueryHospital();//加载包含医院
            $("#winAuthorizationEditor").kendoWindow({
                title: "Title",
                width: 800,
                height: 450,
                modal: true,//遮罩层
            }).data("kendoWindow").title("授权属性").center().open();
            that.RstAttachmentList();
        }
        else {//新增状态 
            $('#IptCatagoryName').FrameTextBox('setValue', '');
            $("#IptAuthStartDate").FrameDatePicker('setValue', '');
            $("#IptAuthStopDate").FrameDatePicker('setValue', '');
            $('#IptProductDesc').FrameTextBox('setValue', '');
            $('#IptProductLine').FrameTextBox('setValue', '');
            $('#IptNote').FrameTextArea('setValue', '');

            $('#IptAuthTypeForEdit').FrameDropdownList({
                dataSource: LstApplyAuthTypeArr,
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'none',
                value: ''
            });
            that.QueryHospital();//加载包含医院
            var data = {};
            FrameUtil.SubmitAjax({
                business: business,
                method: 'InitAuthorization',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $('#hiddenId').val(model.hiddenId);

                    $("#winAuthorizationEditor").kendoWindow({
                        title: "Title",
                        width: 800,
                        height: 450,
                        modal: true,
                    }).data("kendoWindow").title("授权属性").center().open();
                    that.RstAttachmentList();
                }
            });
        }
        createAttachmentList();

    }

    //附件上传弹窗
    that.ShowUploadAttachDlg = function () {
        $("#winAttachmentLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 150,
            modal: true,//遮罩层
        }).data("kendoWindow").title("上传附件").center().open();
    };
    //选择医院
    that.ShowHospitalSelectorDlg = function () {
        $('#BtnHSSave').FrameButton({
            text: '确定',
            icon: 'save',
            onClick: function () {
                that.ChoiceHospitalSave();
            }
        });
        $('#BtnHSCancel').FrameButton({
            text: '取消',
            icon: 'reply',
            onClick: function () {
                $('#winHospitalSelectorLayout').data("kendoWindow").close();
            }
        });
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DelHospitalInit',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#WinHSProvince').FrameDropdownList({
                    dataSource: model.RstResultProvincesList,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'none',
                    filter: "contains",
                    value: model.QryProvince,
                    onChange: function (s) {
                        that.ChangeChoiceHosProvince(s.target.value);
                    },

                });
                $('#WinHSCity').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    filter: "contains",
                    readonly: model.IsDealer ? true : false,
                    value: model.QryCity,
                    onChange: function (s) {
                        that.ChangeChoiceHosCity(s.target.value);
                    },
                });
                $('#WinHSDistrict').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    filter: "contains",
                    readonly: model.IsDealer ? true : false,
                    value: model.QryDistrict,
                    onChange: function (s) {
                        that.ChangeChoiceHosDistrict(s.target.value);
                    },
                });

                $('#WinHSHospital').FrameTextBox({
                    value: model.QryHospitalName,
                });
                that.CreateHospitalSelectorDlgList([]);

                $("#winHospitalSelectorLayout").kendoWindow({
                    title: "Title",
                    width: 800,
                    height: 450,
                    modal: true,
                }).data("kendoWindow").title("医院选择").center().open();
            }
        });

    }
    //选择医院-省份选择
    that.ChangeChoiceHosProvince = function (ProvinceId) {
        var data = that.GetModel();
        data.QryProvince = ProvinceId;
        data.HosProvinceText = $('#WinHSProvince').FrameDropdownList('getValue').Value;
        data.HosCityText = $('#WinHSCity').FrameDropdownList('getValue').Value;
        data.HosDistrictText = $('#WinHSDistrict').FrameDropdownList('getValue').Value;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeChoiceHosProvince',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                $('#WinHSCity').FrameDropdownList({
                    dataSource: model.RstResultCityList,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    filter: "contains",
                    value: '',
                    onChange: function (s) {
                        that.ChangeChoiceHosCity(s.target.value);
                    }
                });
                $("#RstHospitalSelectorList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultCityList
                });

                FrameWindow.HideLoading();
            }
        });
    };
    //选择地区
    that.ChangeChoiceHosCity = function (CityId) {
        var data = that.GetModel();
        data.QryProvince = $('#WinHSProvince').FrameDropdownList('getValue').Key;
        data.QryCity = CityId;
        data.HosProvinceText = $('#WinHSProvince').FrameDropdownList('getValue').Value;
        data.HosCityText = $('#WinHSCity').FrameDropdownList('getValue').Value;
        data.HosDistrictText = $('#WinHSDistrict').FrameDropdownList('getValue').Value;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeChoiceHosProvince',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#WinHSDistrict').FrameDropdownList({
                    dataSource: model.RstResultCityList,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    filter: "contains",
                    value: '',
                    onChange: function (s) {
                        that.ChangeChoiceHosDistrict(s.target.value);
                    }
                });
                $("#RstHospitalSelectorList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultCityList
                });
                FrameWindow.HideLoading();
            }
        });
    };
    //医院选择区/县
    that.ChangeChoiceHosDistrict = function (DistrictId) {
        var data = that.GetModel();
        data.QryProvince = $('#WinHSProvince').FrameDropdownList('getValue').Key;
        data.QryCity = $('#WinHSCity').FrameDropdownList('getValue').Key;
        data.QryDistrict = DistrictId;
        data.HosProvinceText = $('#WinHSProvince').FrameDropdownList('getValue').Value;
        data.HosCityText = $('#WinHSCity').FrameDropdownList('getValue').Value;
        data.HosDistrictText = $('#WinHSDistrict').FrameDropdownList('getValue').Value;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeChoiceHosProvince',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstHospitalSelectorList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultCityList
                });

                FrameWindow.HideLoading();
            }
        });
    };
    //选择医院-确认
    that.ChoiceHospitalSave = function () {
        var data = that.GetModel();
        data.QryProvince = $('#WinHSProvince').FrameDropdownList('getValue').Key;
        data.QryCity = $('#WinHSCity').FrameDropdownList('getValue').Key;
        data.QryDistrict = $('#WinHSDistrict').FrameDropdownList('getValue').Key;
        data.HosProvinceText = $('#WinHSProvince').FrameDropdownList('getValue').Value;
        data.HosCityText = $('#WinHSCity').FrameDropdownList('getValue').Value;
        data.HosDistrictText = $('#WinHSDistrict').FrameDropdownList('getValue').Value;
        data.SearchHospitalName = $('#WinHDHospital').FrameTextBox('getValue');
        data.submitStrParam = JSON.stringify(Choice_hospitalIdArr);
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChoiceHospitalSave',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    that.QueryHospital();
                    $('#winHospitalSelectorLayout').data("kendoWindow").close();
                }
                FrameWindow.HideLoading();
            }
        });
    }

    //复制医院
    that.ShowHospitalCopyDlg = function () {
        $('#BtnASCopy').FrameButton({
            text: '复制医院',
            icon: 'clone',
            onClick: function () {
                that.CopyHospitalSubmit();
            }
        });
        $('#BtnASCancel').FrameButton({
            text: '取消',
            icon: 'reply',
            onClick: function () {
                $('#winAuthorizationSelectorLayout').data("kendoWindow").close();
            }
        });
        $("#winAuthorizationSelectorLayout").kendoWindow({
            title: "Title",
            width: 800,
            height: 450,
            modal: true,
        }).data("kendoWindow").title("医院复制").center().open();
        that.CreateAuthorizationSelectorCopyList([]);

        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'CopyHospitalQuery',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstAuthorizationSelectorList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });
            }
        });

    }
    //复制确认
    that.CopyHospitalSubmit = function () {
        var data = that.GetModel();
        data.submitStrParam = JSON.stringify(Copy_hospitalIdArr);
        FrameUtil.SubmitAjax({
            business: business,
            method: 'CopyHospitalSubmit',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    that.QueryHospital();
                    $('#winAuthorizationSelectorLayout').data("kendoWindow").close();
                }
                FrameWindow.HideLoading();
            }
        });
    }



    //删除医院
    that.ShowHospitalSelectdDelDlg = function () {

        $('#BtnHDQuery').FrameButton({
            text: '查找',
            icon: 'search',
            onClick: function () {
                that.QueryRest();
            }
        });
        $('#BtnHDDelete').FrameButton({
            text: '删除',
            icon: 'remove',
            onClick: function () {
                that.DeleteHospital();
            }
        });
        $('#BtnHDCancel').FrameButton({
            text: '关闭',
            icon: 'reply',
            onClick: function () {
                $('#winHospitalSelectdDelLayout').data("kendoWindow").close();
            }
        });
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'DelHospitalInit',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#WinHDProvince').FrameDropdownList({
                    dataSource: model.RstResultProvincesList,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'none',
                    filter: "contains",
                    value: model.QryProvince,
                    onChange: function (s) {
                        that.ChangeProvince(s.target.value, 'WinHDDistrict', 'WinHDCity');
                    },

                });
                $('#WinHDCity').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    filter: "contains",
                    readonly: model.IsDealer ? true : false,
                    value: model.QryCity,
                    onChange: function (s) {
                        that.ChangeCity(s.target.value, 'WinHDDistrict');
                    },
                });
                $('#WinHDDistrict').FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    filter: "contains",
                    readonly: model.IsDealer ? true : false,
                    value: model.QryDistrict
                });

                $('#WinHDHospital').FrameTextBox({
                    value: model.QryHospitalName,
                });
                that.CreateHospitalSelectdDelList([]);

                $("#winHospitalSelectdDelLayout").kendoWindow({
                    title: "Title",
                    width: 800,
                    height: 450,
                    modal: true,
                    resizable: false,
                }).data("kendoWindow").title("医院信息").center().open();
            }
        });
    }
    //查找
    that.QueryRest = function () {
        var data = FrameUtil.GetModel();
        data.PageSize = 15; data.Page = 1;
        data.SearchHospitalName = $('#WinHDHospital').FrameTextBox('getValue');
        data.QryProvince = $('#WinHDProvince').FrameDropdownList('getValue').Key;
        data.QryCity = $('#WinHDCity').FrameDropdownList('getValue').Key;
        data.QryDistrict = $('#WinHDDistrict').FrameDropdownList('getValue').Key;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'HospitalSelectdDelQuery',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstHospitalSelectdDelList").data("kendoGrid").setOptions({
                    dataSource: model.RstResultList
                });
                FrameWindow.HideLoading();
            }
        });
    };
    //删除
    that.DeleteHospital = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定删除吗？',
            confirmCallback: function () {
                var data = FrameUtil.GetModel();
                data.submitStrParam = JSON.stringify(DelDlg_hospitalIdArr);

                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteHospital',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess) {
                            that.QueryRest();
                            that.QueryHospital();
                        }
                        FrameWindow.HideLoading();
                    }
                });
            },
        });
    };

    //详情-包含医院删除(按钮)
    that.DeleteSelectedHosp = function () {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定删除吗？',
            confirmCallback: function () {
                var data = that.GetModel();
                data.submitStrParam = JSON.stringify(deleteHospitalIdArr);
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteHospitalListEvent',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess) {
                            that.QueryHospital();
                        }
                        FrameWindow.HideLoading();
                    }
                });
            },
            cancelCallback: function () {
            }
        });
    }
    //详情-包含医院授权时间修改
    that.UpdateHospitalAuthDate = function (HosId, beginDate, endDate) {
        if (beginDate == "" || beginDate == null || beginDate == undefined) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '授权开始时间为空！',
            });
            return;
        }
        if (endDate == "" || endDate == null || endDate == undefined) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '授权截止时间为空！',
            });
            return;
        }
        var data = FrameUtil.GetModel();
        data.HospitalId = HosId;
        data.AuthStartDate = beginDate;
        data.AuthEndDate = endDate;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'UpdateHospitalAuthDate',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '授权时间修改成功！',
                    });
                    that.QueryHospital();
                    $("#winHospitalUpdatelDateLayout").data("kendoWindow").close();
                }
                FrameWindow.HideLoading();
            }
        });
    }

    that.startChange = function (e) {
        var id_StopDate = dms.common.convertToFrameJsControl('IptAuthStopDate');
        dms.common.startDateChange(e.sender, $("#" + id_StopDate).data("kendoDatePicker"));
    };
    that.endChange = function (e) {
        var id_StartDate = dms.common.convertToFrameJsControl('IptAuthStartDate');
        dms.common.endDateChange($("#" + id_StartDate).data("kendoDatePicker"), e.sender);
    };

    //授权列表
    that.QueryAuthorization = function () {
        var grid = $("#RstAuthorizationList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    var kendoAuthorization = GetKendoDataSource(business, 'QueryAuthorization');
    var createAuthorizationList = function () {
        $("#RstAuthorizationList").kendoGrid({
            dataSource: kendoAuthorization,
            resizable: true,
            sortable: true,
            scrollable: true,
            selectable: "row",
            columns: [
                {
                    field: "ProductLineDesc", title: "产品线", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PmaDesc", title: "产品分类", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductDescription", title: "产品描述", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品描述" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HospitalListDesc", title: "授权区域描述", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "授权区域描述" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "StartDate", title: "授权开始日期", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "开始日期" },
                    //format: "{0:yyyy-MM-dd}"
                    template: "#= kendo.toString(kendo.parseDate(StartDate, 'yyyy-MM-dd'), 'yyyy-MM-dd') #",
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "EndDate", title: "授权终止日期", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "结束日期" },
                    template: "#= kendo.toString(kendo.parseDate(EndDate, 'yyyy-MM-dd'), 'yyyy-MM-dd') #",
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Type", title: "授权类型", width: '80px', template: function (gridrow) {
                        var Type = "";
                        if (LstAuthTypeArr.length > 0) {
                            if (gridrow.Type != "") {
                                $.each(LstAuthTypeArr, function () {
                                    if (this.Key == gridrow.Type) {
                                        Type = this.Value;
                                        return false;
                                    }
                                })
                            }
                            return Type;
                        } else {
                            return Type;
                        }
                    },
                    headerAttributes: { "class": "text-center text-bold", "title": "授权类型" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "明细", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='authdetail' title='明细'></i>",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            pageable: {
                refresh: true,
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
                $("#RstAuthorizationList").find("i[name='authdetail']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);

                    isCreated = false;
                    that.initAuthorizationEditor(data);
                });

                $("#RstAuthorizationList").on('click', '.k-grid-content tr', function () {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    $("#hiddenId").val(data.Id);
                    $("#hiddenCatagoryId").val(data.PmaId);
                    $("#hiddenProductLine").val(data.ProductLineBumId);
                    $('#BtnDelete').FrameButton('enable');
                    that.QueryHospital();//加载包含医院
                });

            },
            page: function (e) {
            }
        });
    }


    //包含医院
    that.QueryHospital = function () {
        var grid = $("#RstAuthHospitalList").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            return;
        }
    }

    var kendoAuthHospitalList = GetKendoDataSource(business, 'QueryAuthHospitalList');
    var createAuthHospitalList = function () {
        $("#RstAuthHospitalList").kendoGrid({
            dataSource: kendoAuthHospitalList,
            schema: {
                model: {
                    fields: {
                        HosStartDate: { type: "date", format: "yyyy-mm-dd", editable: true },
                        HosEndDate: { type: "date", format: "yyyy-mm-dd", editable: true },
                    }
                },
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            selectable: "row",
            //editable:true,
            columns: [
                {
                    field: "HosHospitalName", title: "医院名称", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosKeyAccount", title: "医院编号", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院编号" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosStartDate", title: "医院授权开始时间", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院授权开始时间" },
                    template: "#= kendo.toString(kendo.parseDate(HosStartDate, 'yyyy-MM-dd'), 'yyyy-MM-dd') #",
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosEndDate", title: "医院授权截止时间", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院授权截止时间" },
                    template: "#= kendo.toString(kendo.parseDate(HosEndDate, 'yyyy-MM-dd'), 'yyyy-MM-dd') #",
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosGrade", title: "等级", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "等级" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosProvince", title: "省份", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "省份" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosCity", title: "地区", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "地区" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosDistrict", title: "区/县", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "区/县" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosRemark", title: "科室", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "科室" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "操作", width: "50px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='authdetail' title='编辑'></i>",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            pageable: {
                refresh: true,
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
                $("#RstAuthHospitalList").find("i[name='authdetail']").bind('click', function (e) {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    that.UpdateHosEditor(data);
                });
                $("#RstAuthHospitalList").on('click', '.k-grid-content tr', function () {
                    var tr = $(this).closest("tr");
                    var data = grid.dataItem(tr);
                    that.EditDeleteHospitalList(data);
                });

            },
            page: function (e) {
            }
        });
    }

    that.UpdateHosEditor = function (data) {
        $("#WinHosBeginDate").FrameDatePicker({
            value: data.HosStartDate,
        });
        $("#WinHosEndDate").FrameDatePicker({
            value: data.HosEndDate,
        });
        $('#BtnHosUpdate').FrameButton({
            text: '确认',
            icon: 'floppy-o',
            onClick: function () {
                var beginDate = $("#WinHosBeginDate").FrameDatePicker('getValue');
                var endDate = $("#WinHosEndDate").FrameDatePicker('getValue');
                that.UpdateHospitalAuthDate(data.HosId, beginDate, endDate);
            }
        });
        $('#BtnHosCancel').FrameButton({
            text: '取消',
            icon: 'times',
            onClick: function () {
                $("#winHospitalUpdatelDateLayout").data("kendoWindow").close();
            }
        });
        $("#winHospitalUpdatelDateLayout").kendoWindow({
            title: "Title",
            width: 350,
            height: 150,
            modal: true,
        }).data("kendoWindow").title("授权属性").center().open();

    };

    //选择省份联动地区
    that.ChangeProvince = function (ParentId, District, City) {
        var data = {};
        data.parentId = ParentId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'BindCity',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                $('#' + City).FrameDropdownList({
                    dataSource: model.RstResultCityList,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'none',
                    filter: "contains",
                    value: '',
                    onChange: function (s) {
                        that.ChangeCity(s.target.value, District);
                    }
                });
                $('#' + District).FrameDropdownList({
                    dataSource: [],
                    dataKey: 'Id',
                    dataValue: 'Name',
                    selectType: 'none',
                    filter: "contains",
                    readonly: model.IsDealer ? true : false,
                    value: model.QryDistrict
                });


                FrameWindow.HideLoading();
            }
        });
    };

    //选择地区联动区县
    that.ChangeCity = function (ParentId, District) {
        var data = {};
        data.parentId = ParentId;
        FrameUtil.SubmitAjax({
            business: business,
            method: 'BindArea',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                $('#' + District).FrameDropdownList({
                    dataSource: model.RstResultAreaList,
                    dataKey: 'TerId',
                    dataValue: 'Description',
                    selectType: 'none',
                    filter: "contains",
                    value: ''
                });

                FrameWindow.HideLoading();
            }
        });
    };

    // 创建附件列表
    var createAttachmentList = function (dataSource) {
        $("#RstAttachmentList").kendoGrid({
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
                field: "Name", title: "附件名称", width: 'auto', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "附件名称"
                }
            },
            {
                field: "Identity_Name", title: "上传人", width: '150px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "上传人"
                }
            },
            {
                field: "UploadDate", title: "上传时间", width: '150px', editable: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "上传时间"
                }
            },
            {
                field: "Url", title: "Url", width: '150px', editable: true, hidden: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "Url"
                }
            },
             {
                 title: "下载", width: '50px',
                 headerAttributes: {
                     "class": "text-center text-bold", "title": "下载", "style": "vertical-align: middle;"
                 },
                 template: "<i class='fa fa-download' style='font-size: 14px; cursor: pointer;'></i>",
                 attributes: {
                     "class": "text-center text-bold"
                 },
             },
             {
                 field: "Delete", title: "删除", width: '100px', editable: true,
                 headerAttributes: {
                     "class": "text-center text-bold", "title": "删除", "style": "vertical-align: middle;"
                 },
                 template: "<i class='fa fa-close item-delete' style='font-size: 14px; cursor: pointer;'></i>",
                 attributes: {
                     "class": "text-center text-bold"
                 },
             }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 5,
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

                $("#RstAttachmentList").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    that.AttachmentDelete(data, data.Id, data.Type, data.Url);
                });
                $("#RstAttachmentList").find(".fa-download").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    var url = '../Download.aspx?downloadname=' + escape(data.Name) + '&filename=' + escape(data.Url) + '&downtype=DealerAuthorization';
                    downloadfile(url);
                });

            }
        });
    }
    //刷新文件
    that.RstAttachmentList = function () {
        var data = FrameUtil.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'AttachmentStore_Refresh',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#RstAttachmentList").data("kendoGrid").setOptions({
                    dataSource: model.LstAttachmentList
                });
                FrameWindow.HideLoading();
            }
        });
    }
    //删除附件
    that.AttachmentDelete = function (dataItem, Id, type, AttachmentName) {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '是否要删除该附件文件?',
            confirmCallback: function () {
                var data = {};
                data.AttachmentId = Id;
                data.FolderName = type;
                data.fileName = AttachmentName;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteAttachment',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        $("#RstAttachmentList").data("kendoGrid").dataSource.remove(dataItem);
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    };
    //删除医院
    that.CreateHospitalSelectdDelList = function (dataSource) {
        $("#RstHospitalSelectdDelList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                 {
                     title: "全选", width: '50px', encoded: false,
                     headerTemplate: '<input id="CheckAll_DelHos" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll_DelHos"></label>',
                     template: '<input type="checkbox" id="Check_#=HosId#" class="k-checkbox Check-Item-DelHos" /><label class="k-checkbox-label" for="Check_#=HosId#"></label>',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "HosHospitalName", title: "医院名称", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosKeyAccount", title: "级别", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "级别" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosGrade", title: "等级", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "等级" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosProvince", title: "省", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "省" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosCity", title: "市", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "市" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HosDistrict", title: "区/县", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "区/县" },
                    attributes: { "class": "table-td-cell" }
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

                $("#RstHospitalSelectdDelList").find(".Check-Item-DelHos").unbind("click");
                $("#RstHospitalSelectdDelList").find(".Check-Item-DelHos").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstHospitalSelectdDelList").data("kendoGrid"),
                    dataItem = grid.dataItem(row);

                    if (checked) {
                        dataItem.IsChecked = true;
                        addItem(dataItem, "delHospital");
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeItem(dataItem, "delHospital");
                        row.removeClass("k-state-selected");
                    }
                });

                $('#CheckAll_DelHos').unbind('change');
                $('#CheckAll_DelHos').on('change', function (ev) {
                    var checked = ev.target.checked;
                    $('.Check-Item-DelHos').each(function (idx, item) {
                        var row = $(this).closest("tr");
                        var grid = $("#RstHospitalSelectdDelList").data("kendoGrid");
                        var data = grid.dataItem(row);

                        if (checked) {
                            addItem(data, "delHospital");
                            $(this).prop("checked", true); //此处设置每行的checkbox选中，必须用prop方法
                            $(this).closest("tr").addClass("k-state-selected");  //设置grid 每一行选中
                        } else {
                            removeItem(data, "delHospital");
                            $(this).prop("checked", false); //此处设置每行的checkbox不选中，必须用prop方法
                            $(this).closest("tr").removeClass("k-state-selected");  //设置grid 每一行不选中
                        }
                    });
                });
            },
            page: function (e) {
                $('#CheckAll_DelHos').removeAttr("checked");
            }
        });
    }
    //选择医院
    that.CreateHospitalSelectorDlgList = function (dataSource) {
        $("#RstHospitalSelectorList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                 {
                     title: "全选", width: '50px', encoded: false,
                     headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                     template: '<input type="checkbox" id="Check_#=Key#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Key#"></label>',
                     headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "Value", title: "包含", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "包含" },
                    attributes: { "class": "table-td-cell" }
                }

            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 8,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                //$("#RstHospitalSelectorList").find(".Check-Item").unbind("click");
                $("#RstHospitalSelectorList").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    //grid = $("#RstHospitalSelectorList").data("kendoGrid"),
                    dataItem = grid.dataItem(row);

                    if (checked) {
                        dataItem.IsChecked = true;
                        addItem(dataItem, "choiceHospital");
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeItem(dataItem, "choiceHospital");
                        row.removeClass("k-state-selected");
                    }
                });

                $('#CheckAll').unbind('change');
                $('#CheckAll').on('change', function (ev) {
                    var checked = ev.target.checked;
                    $('.Check-Item').each(function (idx, item) {
                        var row = $(this).closest("tr");
                        var grid = $("#RstHospitalSelectorList").data("kendoGrid");
                        var data = grid.dataItem(row);

                        if (checked) {
                            addItem(data, "choiceHospital");
                            $(this).prop("checked", true); //此处设置每行的checkbox选中，必须用prop方法
                            $(this).closest("tr").addClass("k-state-selected");  //设置grid 每一行选中
                        } else {
                            removeItem(data, "choiceHospital");
                            $(this).prop("checked", false); //此处设置每行的checkbox不选中，必须用prop方法
                            $(this).closest("tr").removeClass("k-state-selected");  //设置grid 每一行不选中
                        }
                    });
                });
            },
            page: function (e) {
                $('#CheckAll').removeAttr("checked");
            }
        });
    }
    //复制医院
    that.CreateAuthorizationSelectorCopyList = function (dataSource) {
        $("#RstAuthorizationSelectorList").kendoGrid({
            dataSource: dataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                 {
                     title: "选择", width: '50px', encoded: false,
                     //headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                     template: '<input type="checkbox" id="Check_#=Id#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=Id#"></label>',
                     headerAttributes: { "class": "center bold", "title": "选择", "style": "vertical-align: middle;" },
                     attributes: { "class": "center" }
                 },
                {
                    field: "ProductLineDesc", title: "产品线", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "PmaDesc", title: "产品分类", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品分类" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductDescription", title: "产品描述", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "产品描述" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HospitalListDesc", title: "授权区域描述", width: '100px',
                    headerAttributes: { "class": "text-center text-bold", "title": "授权区域描述" },
                    attributes: { "class": "table-td-cell" }
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

                //$("#RstAuthorizationSelectorList").find(".Check-Item").unbind("click");
                $("#RstAuthorizationSelectorList").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    //grid = $("#RstAuthorizationSelectorList").data("kendoGrid"),
                    dataItem = grid.dataItem(row);
                    //单选
                    $('.Check-Item').each(function (idx, item) {
                        var row_item = $(this).closest("tr");
                        var data_item = grid.dataItem(row_item);
                        if (data_item.Id != dataItem.Id) {//排除点击行
                            removeItem(data_item, "copyHospital");
                            $(this).prop("checked", false); //此处设置每行的checkbox不选中，必须用prop方法
                            $(this).closest("tr").removeClass("k-state-selected");  //设置grid 每一行不选中
                        }
                    });
                    if (checked) {
                        dataItem.IsChecked = true;
                        addItem(dataItem, "copyHospital");
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeItem(dataItem, "copyHospital");
                        row.removeClass("k-state-selected");
                    }
                });

                $('#CheckAll').unbind('change');
                $('#CheckAll').on('change', function (ev) {
                    var checked = ev.target.checked;
                    $('.Check-Item').each(function (idx, item) {
                        var row = $(this).closest("tr");
                        var grid = $("#RstAuthorizationSelectorList").data("kendoGrid");
                        var data = grid.dataItem(row);

                        if (checked) {
                            addItem(data, "copyHospital");
                            $(this).prop("checked", true); //此处设置每行的checkbox选中，必须用prop方法
                            $(this).closest("tr").addClass("k-state-selected");  //设置grid 每一行选中
                        } else {
                            removeItem(data, "copyHospital");
                            $(this).prop("checked", false); //此处设置每行的checkbox不选中，必须用prop方法
                            $(this).closest("tr").removeClass("k-state-selected");  //设置grid 每一行不选中
                        }
                    });
                });
            },
            page: function (e) {
                $('#CheckAll').removeAttr("checked");
            }
        });
    }


    //新增授权确认
    that.SaveAuthorization = function () {
        var blSuccess = true;
        var message = [];
        var data = FrameUtil.GetModel();

        if (dms.common.isNullorEmpty($('#hiddenProductLine').val()) && dms.common.isNullorEmpty($('#hiddenCatagoryId').val())) {
            blSuccess = false;
            message.push('请选择授权产品线或产品分类!');
        }
        if (dms.common.isNullorEmpty($("#IptAuthStartDate").FrameDatePicker('getValue'))) {
            blSuccess = false;
            message.push('请选择授权开始日期!');
        }
        if (dms.common.isNullorEmpty($("#IptAuthStopDate").FrameDatePicker('getValue'))) {
            blSuccess = false;
            message.push('请选择授权截止日期!');
        }
        if (dms.common.isNullorEmpty($('#IptAuthTypeForEdit').FrameDropdownList('getValue').Key)) {
            blSuccess = false;
            message.push('请选择授权类型!');
        }
        if (!blSuccess) {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: message,
                callback: function () {
                }
            });
            return;
        }
        var grid = $("#RstAuthorizationList").data("kendoGrid");
        var row = grid.select();
        var dataItem = grid.dataItem(row);
        var submitStrParam = [];
        if (!isCreated) {
            submitStrParam = {
                "PmaId": $('#hiddenCatagoryId').val(),
                "Id": dataItem.Id,
                "DclId": dataItem.DclId,
                "DmaId": dataItem.DmaId,
                "ProductLineBumId": $('#hiddenProductLine').val(),
                "AuthorizationType": dataItem.AuthorizationType,
                "HospitalListDesc": $('#IptNote').FrameTextArea('getValue'),
                "ProductDescription": $('#IptProductDesc').FrameTextBox('getValue'),
                "PmaDesc": $('#IptCatagoryName').FrameTextBox('getValue'),
                "ProductLineDesc": $('#IptProductLine').FrameTextBox('getValue'),
                "StartDate": $("#IptAuthStartDate").FrameDatePicker('getValue'),
                "EndDate": $("#IptAuthStopDate").FrameDatePicker('getValue'),
                "Type": $('#IptAuthTypeForEdit').FrameDropdownList('getValue').Key,
            };
        }
        else {//新增
            if ($('#hiddenProductLine').val() == "" || $('#hiddenCatagoryId').val() == "") {
                FrameWindow.ShowAlert({
                    target: 'top',
                    alertType: 'warning',
                    message: '请选择授权产品线或产品分类！',
                    callback: function () {
                    }
                });
                return;
            }
            submitStrParam = {
                "PmaId": $('#hiddenCatagoryId').val(),
                "Id": $('#hiddenId').val(),
                "DclId": $("#ContractId").val(),
                "DmaId": $('#hidDealerId').val(), //$('#hiddenDealer').val(),//modify by aibing
                "ProductLineBumId": $('#hiddenProductLine').val(),
                "AuthorizationType": "1",
                "HospitalListDesc": $('#IptNote').FrameTextArea('getValue'),
                "ProductDescription": $('#IptProductDesc').FrameTextBox('getValue'),
                "PmaDesc": '',
                "ProductLineDesc": '',
                "StartDate": $("#IptAuthStartDate").FrameDatePicker('getValue'),
                "EndDate": $("#IptAuthStopDate").FrameDatePicker('getValue'),
                "Type": $('#IptAuthTypeForEdit').FrameDropdownList('getValue').Key,
            };
            
        }

        data.submitStrParam = JSON.stringify(submitStrParam);
        data.isCreated = isCreated ? "Created" : "Updated";
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定保存此信息吗？',
            confirmCallback: function () {
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'ValidAttachment',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        if (model.IsSuccess) {
                            if ($('#IptAuthTypeForEdit').FrameDropdownList('getValue').Key != 'Normal'
                                && model.hiddenRtnMsg != 'Success') {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'warning',
                                    message: '请上传审批邮件',
                                });
                            }
                            else {
                                that.SaveAuthorizationInfo(data);
                                $('#hiddenId').val('');
                                $('#hiddenCatagoryId').val('');
                                $('#hiddenProductLine').val('');
                            }
                            
                        }
                        $(window).resize(function () {
                            setLayout();
                        });
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }
    that.SaveAuthorizationInfo = function (data) {
        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveAuthorization',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {

                if (model.IsSuccess) {
                    $("#winAuthorizationEditor").data("kendoWindow").close();
                    that.QueryHospital();//refresh 医院列表
                    that.QueryAuthorization();//refresh 授权列表
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '保存成功',
                    });
                }

                FrameWindow.HideLoading();
            }
        });
    }
    //删除授权信息
    that.DeleteAuthorization = function () {
        var data = FrameUtil.GetModel();
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '确定删除此信息吗？',
            confirmCallback: function () {
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteAuthorization',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {

                        if (model.IsSuccess) {
                            FrameWindow.ShowAlert({
                                target: 'top',
                                alertType: 'info',
                                message: '删除成功',
                                callback: function () {
                                    that.QueryAuthorization();
                                }
                            });
                        }
                        $(window).resize(function () {
                            setLayout();
                        })

                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }

    /***************选择产品分类************************/

    $('#selectType').FrameButton({
        text: '',
        icon: 'search',
        onClick: function () {
            that.AddProductParts();
        }
    });
    $('#BtnPSSave').FrameButton({
        text: '确定',
        icon: 'save',
        onClick: function () {
            that.SavePartsSelectType();
        }
    });
    $('#BtnPSCancel').FrameButton({
        text: '取消',
        icon: 'reply',
        onClick: function () {
            $('#winPartsSelectorLayout').data("kendoWindow").close();
        }
    });

    //添加产品分类
    that.AddProductParts = function () {
        $("#winPartsSelectorLayout").kendoWindow({
            title: "Title",
            width: 600,
            height: 350,
            modal: true,
        }).data("kendoWindow").title("产品分类查询").center().open();
        $("#hidSelectProductLineId").val("");
        

        FrameUtil.SubmitAjax({
            business: business,
            method: 'PartsSelectorInit',
            url: Common.AppHandler,
            data: that.GetModel(),
            callback: function (model) {
                $('#QryProductLine').FrameDropdownList({
                    dataSource: model.LstProductLine,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'none',
                    value: model.QryProductLine,
                    onChange: function (s) {
                        that.ProductLineChange(this.value);
                    }
                });

                

            }
        });

        that.ProductLineChange = function (Bu) {
            if ($("#hidSelectProductLineId").val() != Bu) {
                $("#hidSelectProductLineId").val(Bu);
                that.treeNode.read();
                FrameWindow.HideLoading();
            }
        }
        
        //确定产品分类
        that.SavePartsSelectType = function () {
            var data = FrameUtil.GetModel();
            data.PartType = PartsTypeArr[0].id;
            data.PartTypeLine = PartsTypeArr[0].ProductLineId;
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SavePartsType',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess) {
                        var BuName = $('#QryProductLine').FrameDropdownList('getValue');
                        if (PartsTypeArr[0].id != null && PartsTypeArr[0].id != "" && PartsTypeArr[0].id != undefined) {
                            $('#IptCatagoryName').FrameTextBox('setValue', PartsTypeArr[0].Name);
                            $('#hiddenCatagoryId').val(PartsTypeArr[0].id);
                            $('#hiddenProductLine').val(PartsTypeArr[0].ProductLineId);
                            $('#IptProductLine').FrameTextBox('setValue', BuName.Value);
                        }
                        else if (PartsTypeArr[0].ProductLineId != null && PartsTypeArr[0].ProductLineId != "" && PartsTypeArr[0].ProductLineId != undefined) {
                            $('#hiddenCatagoryId').val(PartsTypeArr[0].id);
                            $('#hiddenProductLine').val(PartsTypeArr[0].ProductLineId);
                            $('#IptProductLine').FrameTextBox('setValue', BuName.Value);
                        }
                        $("#winPartsSelectorLayout").data("kendoWindow").close();
                    }
                    FrameWindow.HideLoading();
                }
            });
        }

    };
    //分类树添加右键菜单
    that.treeNode = new kendo.data.HierarchicalDataSource({
        transport: {
            read: {
                type: "Post",
                url: Common.AppHandler + '?Business=' + businessServer + '&Method=GetPartsClsfcTree',
                dataType: "json",
                contentType: "application/json; charset=utf-8"
            },
            parameterMap: function (options, operation) {
                if (operation == "read") {
                    var Data = FrameUtil.GetModel();
                    Data.ParentID = options.Id ? options.Id : "";
                    return JSON.stringify(Data);
                }
            }
        },
        schema: {
            model: {
                hasChildren: "HasChildren",
                id: "Id",
                //children: "LPartsTree",
                children: that.treeNode,
                fields: {
                    HasChildren: { type: "boolean" }
                }
            },
            data: function (d) {
                return d.LstPartsClassification;
            },
            parse: function (d) {
                FrameWindow.HideLoading();
                return d;
            }, errors: "error"
        }

    });
    that.onSelect = function (e) {
        var treeview = $("#treeview").data("kendoTreeView");
        if (treeview) {
            var item = treeview.dataItem(e.node);
            if (item) {
                PartsTypeArr.splice(0, 1);
                PartsTypeArr.push(item);

            }
        }
    };
    that.EditDeleteHospitalList = function (data) {
        deleteHospitalIdArr.splice(0, 1);
        deleteHospitalIdArr.push({
            "HosId": data.HosId,
            "HosHospitalShortName": data.HosHospitalShortName,
            "HosHospitalName": data.HosHospitalName,
            "HosGrade": data.HosGrade,
            "HosKeyAccount": data.HosKeyAccount,
            "HosProvince": data.HosProvince,
            "HosCity": data.HosCity,
            "HosDistrict": data.HosDistrict,
            "HosRemark": data.HosRemark,
            "HosStartDate": data.HosStartDate,
            "HosEndDate": data.HosEndDate
        });
    }
    /***************选择产品分类************************/

    var addItem = function (data, dataType) {
        if (!isExists(data, dataType)) {
            if ("delHospital" == dataType)
                DelDlg_hospitalIdArr.push({
                    HosId: data.HosId,
                    HosHospitalName: data.HosHospitalName
                });
            if ("choiceHospital" == dataType) {
                Choice_hospitalIdArr.push({
                    Key: data.Key,
                    Value: data.Value
                });
            }
            if ("copyHospital" == dataType) {
                Copy_hospitalIdArr.push({
                    "Id": data.Id,
                    "PmaId": data.PmaId,
                    "DclId": data.DclId,
                    "DmaId": data.DmaId,
                    "ProductLineBumId": data.ProductLineBumId,
                    "AuthorizationType": data.AuthorizationType,
                    "HospitalListDesc": data.HospitalListDesc,
                    "ProductDescription": data.ProductDescription,
                    "PmaDesc": data.PmaDesc,
                    "ProductLineDesc": data.ProductLineDesc
                });
            }
        }
    }

    var removeItem = function (data, dataType) {
        if ("delHospital" == dataType) {
            for (var i = 0; i < DelDlg_hospitalIdArr.length; i++) {
                if (DelDlg_hospitalIdArr[i].HosId == data.HosId) {
                    DelDlg_hospitalIdArr.splice(i, 1);
                    break;
                }
            }
        }
        if ("choiceHospital" == dataType) {
            for (var i = 0; i < Choice_hospitalIdArr.length; i++) {
                if (Choice_hospitalIdArr[i].Key == data.Key) {
                    Choice_hospitalIdArr.splice(i, 1);
                    break;
                }
            }
        }
        if ("copyHospital" == dataType) {
            for (var i = 0; i < Copy_hospitalIdArr.length; i++) {
                if (Copy_hospitalIdArr[i].Id == data.Id) {
                    Copy_hospitalIdArr.splice(i, 1);
                    break;
                }
            }
        }
    }

    var isExists = function (data, dataType) {
        var exists = false;
        if ("delHospital" == dataType) {
            for (var i = 0; i < DelDlg_hospitalIdArr.length; i++) {
                if (DelDlg_hospitalIdArr[i].HosId == data.HosId) {
                    exists = true;
                }
            }
        }
        if ("choiceHospital" == dataType) {
            for (var i = 0; i < Choice_hospitalIdArr.length; i++) {
                if (Choice_hospitalIdArr[i].Key == data.Key) {
                    exists = true;
                }
            }
        }
        if ("copyHospital" == dataType) {
            for (var i = 0; i < Copy_hospitalIdArr.length; i++) {
                if (Copy_hospitalIdArr[i].Id == data.Id) {
                    exists = true;
                }
            }
        }
        return exists;
    }

    //下载文件
    function downloadfile(url) {
        var iframe = document.createElement("iframe");
        iframe.src = url;
        iframe.style.display = "none";
        document.body.appendChild(iframe);
    }
    var setLayout = function () {
    }

    return that;
}();
