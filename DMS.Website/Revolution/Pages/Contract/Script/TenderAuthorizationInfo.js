var TenderAuthorizationInfo = {};

TenderAuthorizationInfo = function () {
    var that = {};
    var pickedList = [];
    var business = 'Contract.TenderAuthorizationInfo';
    var listFileType = [{ "Key": "Tender_01", "Value": "营业执照" }, { "Key": "Tender_02", "Value": "医疗器械经营许可证" }, { "Key": "Tender_05", "Value": "其他附件" }];
    var listFileType2 = [{ "Key": "Tender_01", "Value": "营业执照" }, { "Key": "Tender_02", "Value": "医疗器械经营许可证" }, { "Key": "Tender_03", "Value": "税务登记证" }, { "Key": "Tender_04", "Value": "组织机构代码证" }, { "Key": "Tender_05", "Value": "其他附件" }];
    that.GetModel = function () {
        //model.InstanceId = $('#InstanceId').val();
        var model = FrameUtil.GetModel();
        if (model.IptSAtulicenseType==null || model.IptSAtulicenseType === '') {
            model.IptSAtulicenseType = true;
        }
        if (model.isNewApply == '') {
            model.isNewApply = true;
        }
        return model;
    }

    that.Init = function () {
        $('.WinFileUploadTender').hide();
        FrameWindow.ShowLoading();
        createHosResultList();
        createProResultList();
        createRstAttachmentDetail();
        $("#RstHospital").on("click", "tbody tr[role='row'] td", function () {
            //that.HospitalQuery();
            var index = $(this).parent().index();   //获取选中行的下标
            var grid = $("#RstHospital").data("kendoGrid");
            $("#RstHospital tr").removeClass("k-state-selected");
            var selectedId = grid.dataSource.at(index).Id;  //获取选中行的ID
            $('#HospitalId').val(selectedId);
            var row = $(this).parent().closest("tr");
            row.addClass("k-state-selected");
            that.ProductQuery();
        });
        $("#RstProduct").on("click", "tbody tr[role='row'] td", function () {
            //that.ProductQuery();
            var index = $(this).parent().index();   //获取选中行的下标            
            var grid = $("#RstProduct").data("kendoGrid");
            $("#RstProduct tr").removeClass("k-state-selected");
            var selectedId = grid.dataSource.at(index).Id;  //获取选中行的ID
            var row = $(this).parent().closest("tr");
            row.addClass("k-state-selected");
            $('#PCTId').val(selectedId);
        });
        var data = that.GetModel();
        data.InstanceId = Common.GetUrlParam('InstanceId');
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#InstanceId').val(model.InstanceId);
                $('#Status').val(model.Status);
                if (model.Status == "Draft" && model.IptDealerType && model.IptDealerType.Key == "T2") {
                    $('#divSuperior').show()
                }
                $('#IptAtuNo').FrameTextBox({
                    value: model.IptAtuNo,
                    readonly:true
                });
                $('#IptAtuApplyUser').FrameTextBox({
                    value: model.IptAtuApplyUser,
                    readonly:true
                });
                $('#IptAtuApplyDate').FrameTextBox({
                    value: model.IptAtuApplyDate,
                    readonly:true
                });

                $('#IptAuthorizationInfo').FrameDropdownList({
                    dataSource: model.ListAuthorizationInfo,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: SetKeyValue(model.ListAuthorizationInfo,model.IptAuthorizationInfo)
                });

                $('#IptAtuBeginDate').FrameDatePicker({
                    format: "yyyy-MM-dd",
                    value: (model.IptAtuBeginDate != null ? new Date(model.IptAtuBeginDate) : model.IptAtuBeginDate)
                });
                $('#IptAtuEndDate').FrameDatePicker({
                    format: "yyyy-MM-dd",
                    value: (model.IptAtuEndDate != null ? new Date(model.IptAtuEndDate) : model.IptAtuEndDate)
                });

                $('#IptProductLine').FrameDropdownList({
                    dataSource: model.ListBu,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: SetKeyValue(model.ListBu,model.IptProductLine),
                    onChange:that.ChangeProductLine
                });
                $('#IptDealerType').FrameDropdownList({
                    dataSource: model.ListDealerType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    value: SetKeyValue(model.ListDealerType, model.IptDealerType),
                    onChange: that.ChangeDealerType
                });
                
                $('#IptSAtulicenseType').FrameSwitch({
                    onLabel: "是",
                    offLabel: "否",
                    value: model.IptSAtulicenseType,
                    onChange:that.ChangeLicenseType
                });

                //if (model.IptSubBU != null && model.IptSubBU.Key != "") {
                //    $.each(model.ListSubBU, function (index, val) {
                //        if (model.IptSubBU.Key === val.SubBUCode)
                //            model.IptSubBU = { Key: val.SubBUCode, Value: val.SubBUName };
                //    })
                //}
                $('#IptSubBU').FrameDropdownList({
                    dataSource: model.ListSubBU,
                    dataKey: 'SubBUCode',
                    dataValue: 'SubBUName',
                    selectType: 'all',
                    value: SetKeyValue(model.ListSubBU, model.IptSubBU),
                    onChange:that.ChangeSubBu
                });

                $('#fileType').FrameDropdownList({
                    dataSource: listFileType,
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'all',
                    onChange: that.ChangeFileType
                });
                if (model.IptSuperiorDealer != null && model.IptSuperiorDealer.Key != "") {
                    $.each(model.ListSuperiorDealer, function (index, val) {
                        if (model.IptSuperiorDealer.Key === val.DMA_ID)
                            model.IptSuperiorDealer = { Key: val.DMA_ID, Value: val.DMA_ChineseName };
                    })
                }
                $('#IptSuperiorDealer').FrameDropdownList({
                    dataSource: model.ListSuperiorDealer,
                    dataKey: 'DMA_ID',
                    dataValue: 'DMA_ChineseName',
                    selectType: 'all',
                    value: model.IptSuperiorDealer
                });
                $('#IptDealerName').FrameTextBox({
                    value: model.IptDealerName
                });
                
                $('#IptAtuMailAddress').FrameTextBox({
                    value: model.IptAtuMailAddress
                });

                $('#IptAtuRemark').FrameTextArea({
                    value: model.IptAtuRemark
                });
                that.HospitalQuery();
                $('#BtnReturn').FrameButton({
                    text: '返回',
                    icon: 'reply',
                    onClick: function () {
                        if (confirm('是否保存当前草稿？')) {
                            that.Save(false);
                            window.location.href = 'TenderAuthorizationList.aspx';
                        }
                        else {
                            window.location.href = 'TenderAuthorizationList.aspx';
                        }
                    }
                });
                $('#BtnSave').FrameButton({
                    text: '保存草稿',
                    icon: 'save',
                    onClick: function () {
                        that.Save(true);
                    }
                });

                $('#BtnDelete').FrameButton({
                    text: '删除草稿',
                    icon: 'trash-o',
                    onClick: function () {
                        that.DeleteInfo();
                    }
                });
                $('#BtnSubmit').FrameButton({
                    text: '提交',
                    icon: 'check',
                    onClick: function () {
                        that.Submit();
                    }
                });
                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });

                $('#btnAddHospital').FrameButton({
                    text: '添加医院',
                    icon: 'plus-square',
                    onClick: function () {
                        that.AddHospital();
                    }
                });
                $('#btnDeleteHospital').FrameButton({
                    text: '删除授权医院',
                    icon: 'minus-square',
                    onClick: function () {
                        that.DeleteHospital();
                    }
                });
                $('#btnAddProduct').FrameButton({
                    text: '添加授权产品',
                    icon: 'plus-square',
                    onClick: function () {
                        that.AddProduct();
                    }
                });
                $('#btnDeleteProduct').FrameButton({
                    text: '删除授权产品',
                    icon: 'minus-square',
                    onClick: function () {
                        that.DeleteProduct();
                    }
                });

                $('#depSave').FrameButton({
                    text: '保存',
                    icon: 'save',
                    onClick: function () {
                        that.depSave();
                    }
                });
                $('#depColse').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $("#windowLayoutHospital").data("kendoWindow").close();
                    }
                });

                $('#proSave').FrameButton({
                    text: '确定',
                    icon: 'save',
                    onClick: function () {
                        that.proSave();
                    }
                });
                $('#proColse').FrameButton({
                    text: '关闭',
                    icon: 'close',
                    onClick: function () {
                        $("#windowLayoutProduct").data("kendoWindow").close();
                    }
                });
                $("#RstProductAddList").data("kendoGrid").setOptions({
                    dataSource: model.RstProductStore
                });
                FileUploadInit();
                

                
                $('#BtnAddAttachment').FrameButton({
                    text: '上传附件',
                    icon: 'upload',
                    onClick: function () {
                        that.initUploadAttachDiv();
                    }
                });
                that.refreshAttachment();
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();
                
                FrameWindow.HideLoading();
            }
        });
    }
    //--------------授权医院相关操作----------------------
    that.HospitalQuery = function () {
        var grid = $("#RstHospital").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            $('#HospitalId').val('');
            return;
        }
    }   
    var kendoHosDataSource = GetKendoDataSource(business, 'HospitalQuery', null, 10, that.GetModel);
    var createHosResultList = function () {
        $("#RstHospital").kendoGrid({
            dataSource: kendoHosDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    field: "HospitalName", title: "医院名称", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" },
                },
                {
                    field: "HospitalCode", title: "医院编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院编号" },
                },
                {
                    field: "HospitalGrade", title: "等级", width: '80px',
                    headerAttributes: { "class": "text-center text-bold", "title": "授权类型" },
                },
                
                {
                    field: "HospitalProvince", title: "省份", width: '120px', 
                    headerAttributes: { "class": "text-center text-bold", "title": "省份" }
                },
                {
                    field: "HospitalCity", title: "地区", width: '120px', 
                    headerAttributes: { "class": "text-center text-bold", "title": "地区" }
                },
                {
                    field: "HospitalDistrict", title: "区/县", width: '120px',
                    headerAttributes: { "class": "text-center text-bold", "title": "区/县" }
                },
                {
                    field: "HospitalDept", title: "科室", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "科室" }
                },
                
                {
                    title: "编辑", width: "80px",
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>",
                    attributes: {
                        "class": "text-center text-bold"
                    }
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
                $("#RstHospital").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    var hosInfo = {};
                    hosInfo.AddHospitalName = data.HospitalName;
                    hosInfo.AddHospitalNo = data.HospitalCode;
                    hosInfo.AddHosDepartment = data.HospitalDept;
                    hosInfo.HospitalId = data.Id;
                    that.initHosDeptDiv(hosInfo);
                });
            },
            page: function (e) {
            }
        });
    }
    that.initHosDeptDiv = function (model) {
        $('#HospitalId').val(model.HospitalId);
        
        $("#windowLayoutHospital").kendoWindow({
            title: "Title",
            width: 450,
            height: 300,
            actions: [
                "Pin",
                "Minimize",
                "Maximize",
                "Close"
            ],
            modal: true,
        }).data("kendoWindow").title("科室信息").center().open();
        //编辑或新增页面
        $('#AddHospitalNo').FrameTextBox({
            value: model.AddHospitalNo,
            readonly:true
        });
        $('#AddHospitalName').FrameTextBox({
            value: model.AddHospitalName,
            readonly:true
        });
        $('#AddHosDepartment').FrameTextBox({
            value: model.AddHosDepartment
        });


    }
    that.depSave = function () {
        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveDeptment',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '保存成功'
                    });
                    $("#windowLayoutHospital").data("kendoWindow").close();
                    that.HospitalQuery();
                }
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.AddHospital = function () {
        var data = that.GetModel();
        var checkRturn = validataForm(data);
        if (checkRturn != "") {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: checkRturn
            });
        }
        else {

            url = Common.AppVirtualPath + 'Revolution/Pages/Contract/HospitalPicker.aspx?' + 'ProductLine=' + data.IptProductLine.Key + '&InstanceId=' + data.InstanceId;

            FrameWindow.OpenWindow({
                target: 'top',
                title: '医院信息查询',
                url: url,
                width: $(window).width() * 0.7,
                height: $(window).height() * 0.9,
                actions: ["Close"],
                callback: function (list) {
                    var param = '';
                    for (var i = 0; list&&i < list.length; i++) {
                        param += list[i].Key + ',';
                    }
                    data.HospitalString = param;
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'SaveHospital',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            $('#ProductString').val('');
                            if (model.IsSuccess && param!='') {
                                FrameWindow.ShowAlert({
                                    target: 'top',
                                    alertType: 'info',
                                    message: '添加成功'
                                });
                                //$("#windowLayoutProduct").data("kendoWindow").close();
                                that.HospitalQuery();
                            }
                            $(window).resize(function () {
                                setLayout();
                            })
                            setLayout();

                            FrameWindow.HideLoading();
                        }
                    });
                    
                }
            });
        }
    }
    that.DeleteHospital = function () {
        var data = that.GetModel();
        if (data.HospitalId == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择需要删除的授权医院'
            });
        }
        else {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteHospital',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '删除成功'
                        });
                        that.HospitalQuery();
                    }
                    $(window).resize(function () {
                        setLayout();
                    })
                    setLayout();

                    FrameWindow.HideLoading();
                }
            });
        }
    }
    function validataForm(data) {
        var errMsg = "";
        var cbProductLine = data.IptProductLine;
        var cbWdSubBU = data.IptSubBU;
        var cbDealerType = data.IptDealerType;
        var AuthorizationInfo = data.IptAuthorizationInfo;
        var superiorDealer = data.IptSuperiorDealer;
        var atuBeginDate = data.IptAtuBeginDate;
        var atuEndDate = data.IptAtuEndDate;
        var atuDealerName = data.IptDealerName;
        var atuRemark = data.IptAtuRemark;
        var atuMailAddress = data.IptAtuMailAddress;
        var startTime = new Date(Date.parse(data.IptAtuBeginDate)).getTime();
        var endTime = new Date(Date.parse(data.IptAtuEndDate)).getTime();
        var beginyear = new Date(data.IptAtuEndDate)
        var endyear = new Date(data.IptAtuEndDate)
        var dates = Math.abs((startTime - endTime)) / (1000 * 60 * 60 * 24);
        if (cbProductLine.Key == null || cbProductLine.Key == '') {
            errMsg += "请选择产品线信息<br/>"
        }
        if (cbWdSubBU.Key == null || cbWdSubBU.Key == '') {
            errMsg += "请选择SubBU<br/>"
        }
        if (cbDealerType.Key == null || cbDealerType.Key == '') {
            errMsg += "请选择经销商类型<br/>"
        }
        if (AuthorizationInfo.Key == null || AuthorizationInfo.Key == '') {
            errMsg += "请选择授权类型<br/>"
        }
        if (atuBeginDate == null || atuBeginDate == '') {
            errMsg += "请填写授权开始时间<br/>"
        }
        if (atuEndDate == null || atuEndDate == '') {
            errMsg += "请填写授权终止时间<br/>"
        }
        if (atuBeginDate != null && atuBeginDate != '' && atuEndDate != null && atuEndDate != '' && atuBeginDate > atuEndDate) {
            errMsg += "授权终止时间必须大于授权开始时间<br/>"
        }
        if (atuDealerName == null || atuDealerName == '') {
            errMsg += "请填写经销商名称<br/>"
        }
        if (startTime != null && endTime != null) {
            if (dates > 90 && (atuRemark == null || atuRemark == '')) {
                errMsg += "授权时间大于90天，需填写备注信息<br/>"
            }
        }
        if ((atuRemark == null || atuRemark == '') && beginyear.getFullYear() != endyear.getFullYear() && atuBeginDate != '') {
            errMsg += "授权时间跨年，请填写备注信息<br/>"
        }

        if (cbDealerType == "T2" && superiorDealer == '') {
            errMsg += "请选择上级平台商<br/>"
        }
        return errMsg;
    }
    //-----------------------------------------------------

    //--------------授权产品相关操作-----------------------
    that.ProductQuery = function () {
        var grid = $("#RstProduct").data("kendoGrid");
        if (grid) {
            grid.dataSource.page(1);
            $('#PCTId').val('');
            return;
        }
    }
    var kendoProDataSource = GetKendoDataSource(business, 'ProductQuery', null, 10, that.GetModel);
    var createProResultList = function () {
        $("#RstProduct").kendoGrid({
            dataSource: kendoProDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    field: "HosKeyAccount", title: "医院编号", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院编号" },
                },
                {
                    field: "HosHospitalName", title: "医院名称", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" },
                },
                
                {
                    field: "SubProductName", title: "授权产品", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "授权产品" },
                },

                {
                    field: "RepeatDealer", title: "重复授权经销商", width: '200px',
                    headerAttributes: { "class": "text-center text-bold", "title": "重复授权经销商" }
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
            page: function (e) {
            }
        });
        $("#RstProductAddList").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
                {
                    title: "全选", width: '30px', encoded: false,
                    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=CaId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=CaId#"></label>',
                    headerAttributes: { "class": "center bold", "title": "全选", "style": "vertical-align: middle;" },
                    attributes: { "class": "center" }
                },
                {
                    field: "SubBuName", title: "合同分类", width: 'auto',
                    headerAttributes: { "class": "text-center text-bold", "title": "合同分类" },
                },

                {
                    field: "CaName", title: "授权产品分类", width: '150px',
                    headerAttributes: { "class": "text-center text-bold", "title": "授权产品分类" },
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

                $("#RstProductAddList").find(".Check-Item").unbind("click");
                $("#RstProductAddList").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstProductAddList").data("kendoGrid"),
                    dataItem = grid.dataItem(row);

                    if (checked) {
                        dataItem.IsChecked = true;
                        addItem(dataItem);
                        row.addClass("k-state-selected");
                    } else {
                        dataItem.IsChecked = false;
                        removeItem(dataItem);
                        row.removeClass("k-state-selected");
                    }
                });

                $('#CheckAll').unbind('change');
                $('#CheckAll').on('change', function (ev) {
                    var checked = ev.target.checked;
                    $('.Check-Item').each(function (idx, item) {
                        var row = $(this).closest("tr");
                        var grid = $("#RstProductAddList").data("kendoGrid");
                        var data = grid.dataItem(row);

                        if (checked) {
                            addItem(data);
                            $(this).prop("checked", true); //此处设置每行的checkbox选中，必须用prop方法
                            $(this).closest("tr").addClass("k-state-selected");  //设置grid 每一行选中
                        } else {
                            removeItem(data);
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
    
    var addItem = function (data) {
        if (!isExists(data)) {
            var temp = {
                Key: "",
                Value: ""
            };
            temp.Key = data.CaId;
            temp.Value = data.SubProductName;
            pickedList.push(temp);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].Key == data.CaId) {
                pickedList.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < pickedList.length; i++) {
            if (pickedList[i].Key == data.CaId) {
                exists = true;
            }
        }
        return exists;
    }
    that.AddProduct = function () {
        var data = that.GetModel();
        if (data.HospitalId == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择医院！'
            });
            return;
        }
        else {
            $("#windowLayoutProduct").kendoWindow({
                title: "Title",
                width: 500,
                height: 300,
                actions: [
                    "Pin",
                    "Minimize",
                    "Maximize",
                    "Close"
                ],
                modal: true,
            }).data("kendoWindow").title("授权产品").center().open();
        }
        
    }
    that.proSave = function () {
        var param = '';
        for (var i = 0; i < pickedList.length; i++) {
            param += pickedList[i].Key + ',';
        }
        $('#ProductString').val(param);
        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'SaveProduct',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#ProductString').val('');
                if (model.IsSuccess) {
                    FrameWindow.ShowAlert({
                        target: 'top',
                        alertType: 'info',
                        message: '保存成功'
                    });
                    $("#windowLayoutProduct").data("kendoWindow").close();
                    that.ProductQuery();
                }
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }
    that.DeleteProduct = function () {
        var data = that.GetModel();        
        if (data.PCTId == '') {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'warning',
                message: '请选择需要删除的授权产品'
            });
        }
        else {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'DeleteProductByID',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    if (model.IsSuccess) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '删除成功'
                        });
                        that.ProductQuery();
                    }
                    $(window).resize(function () {
                        setLayout();
                    })
                    setLayout();

                    FrameWindow.HideLoading();
                }
            });
        }
    }
    //-----------------------------------------------------
    that.ChangeProductLine = function () {
        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeProductLine',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    $('#IptSubBU').FrameDropdownList({
                        dataSource: model.ListSubBU,
                        dataKey: 'SubBUCode',
                        dataValue: 'SubBUName',
                        selectType: 'all',
                        value: SetKeyValue(model.ListSubBU, model.IptSubBU),
                        onChange: that.ChangeSubBu
                    });
                    that.HospitalQuery();
                }
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }
    that.ChangeSubBu = function () {
        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeSubBu',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    $("#RstProductAddList").data("kendoGrid").setOptions({
                        dataSource: model.RstProductStore
                    });
                    that.ProductQuery();
                }
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }
    
    that.ChangeDealerType = function () {
        var data = that.GetModel();
        if (data.Status == "Draft" && data.IptDealerType.Key == "T2") {
            $('#divSuperior').show()
        }
        else {
            $('#divSuperior').hide()
        }
    }
    var getFileType = function () {
        var data = that.GetModel();
        return data.fileType.Key;
    }
    //-----------------------附件相关操作-----------------------
    var FileUploadInit = function () {
        $('#WinFileUploadTender_01').kendoUpload({
            async: {
                saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=TenderAuthorization&InstanceId=" + $("#InstanceId").val() + '&FileType=Tender_01',
                autoUpload: true
            },
            select: function (e) {

            },
            validation: {
            },
            multiple: false,
            success: function (e) {
                //刷新附件列表
                that.refreshAttachment();
            }
        });
        $('#WinFileUploadTender_02').kendoUpload({
            async: {
                saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=TenderAuthorization&InstanceId=" + $("#InstanceId").val() + '&FileType=Tender_02',
                autoUpload: true
            },
            select: function (e) {

            },
            validation: {
            },
            multiple: false,
            success: function (e) {
                //刷新附件列表
                that.refreshAttachment();
            }
        });
        $('#WinFileUploadTender_03').kendoUpload({
            async: {
                saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=TenderAuthorization&InstanceId=" + $("#InstanceId").val() + '&FileType=Tender_03',
                autoUpload: true
            },
            select: function (e) {

            },
            validation: {
            },
            multiple: false,
            success: function (e) {
                //刷新附件列表
                that.refreshAttachment();
            }
        });
        $('#WinFileUploadTender_04').kendoUpload({
            async: {
                saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=TenderAuthorization&InstanceId=" + $("#InstanceId").val() + '&FileType=Tender_04',
                autoUpload: true
            },
            select: function (e) {

            },
            validation: {
            },
            multiple: false,
            success: function (e) {
                //刷新附件列表
                that.refreshAttachment();
            }
        });
        $('#WinFileUploadTender_05').kendoUpload({
            async: {
                saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=TenderAuthorization&InstanceId=" + $("#InstanceId").val() + '&FileType=Tender_05',
                autoUpload: true
            },
            select: function (e) {

            },
            validation: {
            },
            multiple: false,
            success: function (e) {
                //刷新附件列表
                that.refreshAttachment();
            }
        });
    }
    that.ChangeFileType = function () {
        
        var data = that.GetModel();
        $('.WinFileUploadTender').hide();
        $('#divWinFileUpload' + data.fileType.Key).show();
    }
    that.initUploadAttachDiv = function (CName, EName, DealerType) {
        $("#winUploadAttachLayout").kendoWindow({
            title: "Title",
            width: 400,
            height: 200,
            actions: [
        "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("上传附件").center().open();

    }

    //刷新文件
    that.refreshAttachment = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'AttachmentStore_Refresh',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                var dataSource = $("#RstAttachmentDetail").data("kendoGrid").dataSource.data();
                for (var i = 0; i < model.AttachmentList.length; i++) {
                    var exists = false;
                    for (var j = 0; j < dataSource.length; j++) {
                        if (dataSource[j].Id == model.AttachmentList[i].Id) {
                            exists = true;
                        }
                    }
                    if (!exists) {
                        $("#RstAttachmentDetail").data("kendoGrid").dataSource.add(model.AttachmentList[i]);
                    }
                }
                $("#RstAttachmentDetail").data("kendoGrid").setOptions({
                    dataSource: $("#RstAttachmentDetail").data("kendoGrid").dataSource
                });
                FrameWindow.HideLoading();
            }
        });
    }
    //删除附件
    that.AttachmentDelete = function (dataItem, Id, AttachmentName) {
        FrameWindow.ShowConfirm({
            target: 'top',
            message: '是否要删除该附件文件?',
            confirmCallback: function () {
                var data = {
                };
                data.DeleteAttachmentID = Id;
                data.DeleteAttachmentName = AttachmentName;
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteAttachment',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'Delete',
                            message: '删除附件成功',
                        });
                        $("#RstAttachmentDetail").data("kendoGrid").dataSource.remove(dataItem);
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    };
    function downloadfile(url) {
        var iframe = document.createElement("iframe");
        iframe.src = url;
        iframe.style.display = "none";
        document.body.appendChild(iframe);
    }

    var createRstAttachmentDetail = function (dataSource) {
        $("#RstAttachmentDetail").kendoGrid({
            dataSource: {
                data: dataSource,
            },
            resizable: true,
            sortable: true,
            scrollable: true,
            columns: [
            {
                field: "Name", title: "附件名称", width: 'auto',
                headerAttributes: {
                    "class": "text-center text-bold", "title": "附件名称"
                }
            },
            {
                field: "TypeName", title: "附件类型", width: '150px',
                headerAttributes: {
                    "class": "text-center text-bold", "title": "附件类型"
                }
            },
            {
                field: "Identity_Name", title: "上传人", width: '150px',
                headerAttributes: {
                    "class": "text-center text-bold", "title": "上传人"
                }
            },
            {
                field: "UploadDate", title: "上传时间", width: '150px',
                headerAttributes: {
                    "class": "text-center text-bold", "title": "上传时间"
                }
            },
            {
                field: "Url", title: "Url", width: '150px', hidden: true,
                headerAttributes: {
                    "class": "text-center text-bold", "title": "Url"
                }
            },
             {
                 title: "下载", width: '80px',
                 headerAttributes: {
                     "class": "text-center text-bold", "title": "下载", "style": "vertical-align: middle;"
                 },
                 template: "<i class='fa fa-download' style='font-size: 14px; cursor: pointer;'></i>",
                 attributes: {
                     "class": "text-center text-bold"
                 },
             },
             {
                 field: "Delete", title: "删除", width: '80px',
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

                $("#RstAttachmentDetail").find(".item-delete").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    that.AttachmentDelete(data, data.Id, data.Url);
                });
                $("#RstAttachmentDetail").find(".fa-download").bind('click', function () {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);
                    var url = '../Download.aspx?downloadname=' + escape(data.Name) + '&filename=' + escape(data.Url) + '&downtype=TenderAuthorization';
                    downloadfile(url);
                });

            }
        });
    }
    //----------------------------------------------------------


    that.ChangeLicenseType = function () {
        $('.WinFileUploadTender').hide();
        var data = that.GetModel();
        var dataSource;
        if (data.IptSAtulicenseType) {
            $('#fileType').FrameDropdownList({
                dataSource: listFileType,
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'all',
                onChange: that.ChangeFileType
            });
        }
        else {
            $('#fileType').FrameDropdownList({
                dataSource: listFileType2,
                dataKey: 'Key',
                dataValue: 'Value',
                selectType: 'all',
                onChange: that.ChangeFileType
            });
        }
        //$("#fileType").data("kendoDropdownList").setDataSource(dataSource);
        
    }
    that.Submit = function () {
        var data = that.GetModel();
        var massage = validataForm();
        if (massage == null || massage == '') {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'checkAttachment',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    FrameWindow.HideLoading();
                    if (model.IsSuccess) {
                        if (comfirm('是否确认提交审批？')) {
                            FrameWindow.ShowLoading();
                            FrameUtil.SubmitAjax({
                                business: business,
                                method: 'SaveSubmint',
                                url: Common.AppHandler,
                                data: data,
                                callback: function (model) {
                                    FrameWindow.HideLoading();
                                    if (model.IsSuccess) {
                                        FrameWindow.ShowAlert({
                                            target: 'top',
                                            alertType: 'info',
                                            message: '提交成功'
                                        });
                                    }
                                    $(window).resize(function () {
                                        setLayout();
                                    })
                                    setLayout();


                                }
                            });
                        }
                    }
                    $(window).resize(function () {
                        setLayout();
                    })
                    setLayout();

                    
                }
            });
        }
        else {
            FrameWindow.ShowAlert({
                target: 'top',
                alertType: 'info',
                message: massage
            });
        }
        FrameUtil.SubmitAjax({
            business: business,
            method: 'ChangeSubBu',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                if (model.IsSuccess) {
                    $("#RstProductAddList").data("kendoGrid").setOptions({
                        dataSource: model.RstProductStore
                    });
                    that.ProductQuery();
                }
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }
    that.Save = function (isTip) {
        var data = that.GetModel();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Save',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.HideLoading();
                if (model.IsSuccess) {
                    if (isTip) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '保存成功'
                        });
                    }
                }
                $(window).resize(function () {
                    setLayout();
                })
                setLayout();


            }
        });
    }
    that.DeleteInfo = function () {
        var data = that.GetModel();
        if (confirm('确认删除该草稿单？')) {
            FrameWindow.ShowLoading();
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Delete',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    FrameWindow.HideLoading();
                    if (model.IsSuccess) {
                        FrameWindow.ShowAlert({
                            target: 'top',
                            alertType: 'info',
                            message: '删除成功'
                        });
                        window.location.href = '/Revolution/Pages/Contract/TenderAuthorizationList.aspx';
                    }
                    $(window).resize(function () {
                        setLayout();
                    })
                    setLayout();


                }
            });
        }
    }
    that.Export = function () {
        var data = that.GetModel();

        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'TenderAuthorizationInfoExport');
        urlExport = Common.UpdateUrlParams(urlExport, 'InstanceId', data.InstanceId);
        startDownload(urlExport, 'TenderAuthorizationInfoExport');
    }
    function SetKeyValue(list, keyValue) {
        var rtn = {};
        if (keyValue != null&&keyValue.Key != "" ) {
            $.each(list, function (index, val) {
                if (keyValue.Key === val.Key)
                    rtn = { Key: val.Key, Value: val.Value };
            })
        }
        return rtn;
    }
    var setLayout = function () {
    }

    return that;
}();
