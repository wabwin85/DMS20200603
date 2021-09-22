var ContractThirdPartyV2 = {};

ContractThirdPartyV2 = function () {
    var that = {};

    var business = 'Contract.ContractThirdPartyV2';

    that.GetModel = function () {
        var model = FrameUtil.GetModel();

        return model;
    }

    var chooseProduct = [];

    that.Init = function () {
        $("#DivBasicInfo").kendoTabStrip({
            animation: {
                open: {
                    effects: "fadeIn"
                }
            }
        });

        var data = {};
        data.HidDealerId = Common.GetUrlParam('DealerId');
        createResultList();
        createAttachList();
        createLineList();

        FrameUtil.SubmitAjax({
            business: business,
            method: 'Init',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                //公司名称
                $('#HidDealerId').val(model.HidDealerId);
                $('#HidDealerType').val(model.DealerType);
                $('#QryDealerName').FrameTextBox({
                    value: model.QryDealerName,
                    readonly: true
                });
                $('#QryHospitalName').FrameTextBox({
                    value: model.QryHospitalName
                });
                //状态
                $('#QryType').FrameDropdownList({
                    dataSource: [{ Key: '已生效', Value: '已生效' }, { Key: '未生效', Value: '未生效' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.QryType
                });

                //按钮
                $('#BtnQuery').FrameButton({
                    text: '查询',
                    icon: 'search',
                    onClick: function () {
                        that.QueryAutHosp();
                        that.QueryPubHosp();
                    }
                });
                $('#BtnExport').FrameButton({
                    text: '导出',
                    icon: 'file-excel-o',
                    onClick: function () {
                        that.Export();
                    }
                });
                $('#BtnCreatePdf').FrameButton({
                    text: '生成第三方披露表 PDF',
                    icon: 'file-pdf-o',
                    onClick: function () {
                        that.CreatePdf();
                    }
                });
                $('#BtnCancel').FrameButton({
                    text: '返回',
                    icon: 'times',
                    onClick: function () {
                        top.deleteTabsCurrent();
                    }
                });
                $('#BtnHelpTemplate').FrameButton({
                    text: '使用帮助及模板',
                    icon: 'question-circle',
                    onClick: function () {
                        that.DownloadTemplate();
                    }
                });

                //第三方披露页面
                $('#BtnAddLine').FrameButton({
                    text: '添加',
                    icon: 'plus',
                    onClick: function () {
                        clearChooseProduct();
                        that.ShowProductLine();
                    }
                });
                $('#BtnWinCancel').FrameButton({
                    text: '返回',
                    icon: 'times',
                    onClick: function () {
                        $("#winThirdPartyLayout").data("kendoWindow").close();
                    }
                });
                $('#BtnWinAddItems').FrameButton({
                    text: '添加',
                    icon: 'plus',
                    onClick: function () {
                        that.AddItems();
                    }
                });
                $('#BtnWinClose').FrameButton({
                    text: '关闭',
                    icon: 'times',
                    onClick: function () {
                        $("#winAddLineLayout").data("kendoWindow").close();
                    }
                });
                //提交按钮
                $('#BtnWinEndThirdParty').FrameButton({
                    text: '终止披露申请',
                    icon: 'ban',
                    onClick: function () {
                        that.EndThirdPartylist();
                    }
                });
                $('#BtnWinSubmit').FrameButton({
                    text: '提交续约',
                    icon: 'check',
                    onClick: function () {
                        that.RenewSubmit();
                    }
                });
                $('#BtnWinRenew').FrameButton({
                    text: '续约',
                    icon: 'check',
                    onClick: function () {
                        that.Renew();
                    }
                });
                $('#BtnWinApproveEnd').FrameButton({
                    text: '终止披露审批通过',
                    icon: 'check',
                    onClick: function () {
                        that.EndThirdPartylistApprover();
                    }
                });
                $('#BtnWinRefuseEnd').FrameButton({
                    text: '终止披露审批拒绝',
                    icon: 'check',
                    onClick: function () {
                        that.RefuseEndThirdPartylist();
                    }
                });
                $('#BtnWinThirdPartyApproval').FrameButton({
                    text: '披露申请审批通过',
                    icon: 'check',
                    onClick: function () {
                        that.Approval();
                    }
                });
                $('#BtnWinThirdPartyReject').FrameButton({
                    text: '披露申请审批拒绝',
                    icon: 'ban',
                    onClick: function () {
                        that.Reject();
                    }
                });
                $('#BtnWinThirdPartySubmit').FrameButton({
                    text: '披露申请提交',
                    icon: 'check',
                    onClick: function () {
                        that.SaveThirdParty();
                    }
                });

                //上传附件
                $('#WinAttachUpload').kendoUpload({
                    async: {
                        saveUrl: "../Handler/UploadAttachmentHanler.ashx?Type=DCMSDisclosure&DealerId=" + $('#HidDealerId').val() + "&DealerType=" + $('#HidDealerType').val() + "&DealerName=" + $('#QryDealerName').FrameTextBox('getValue'),
                        autoUpload: true
                    },
                    upload: function (e) {
                        e.data = { DisclosureId: $('#DisclosureId').val(), HdType: $('#HidType').val(), CompanyName: $('#WinCompanyName').FrameTextBox('getValue'), HospitalName: $('#WinHospitalName').FrameTextBox('getValue'), ProductLine: $('#WinProductLine').FrameTextBox('getValue') };
                    },
                    multiple: false,
                    success: function (e) {
                        that.QueryAttach();
                    }
                });

                //控件控制
                if (model.DisableFlag)
                {
                    $('#BtnCreatePdf').FrameButton('disable');
                }
                if (model.HideFlag) {
                    $("#RstAutHospList").data("kendoGrid").hideColumn(2);
                    $("#RstWinAttachList").data("kendoGrid").hideColumn(4);
                }
                else {
                    $('#BtnAddAttach').FrameButton({
                        text: '新增附件',
                        icon: 'upload',
                        onClick: function () {
                            that.ShowAttachment();
                        }
                    });
                }

                //$("#RstAutHospList").data("kendoGrid").setOptions({
                //    dataSource: model.RstAutHospList
                //});
                //$("#RstPubHospList").data("kendoGrid").setOptions({
                //    dataSource: model.RstPubHospList
                //});
                that.QueryAutHosp();
                that.QueryPubHosp();
                $('#RstWinProductLine').data("kendoGrid").setOptions({
                    dataSource: model.RstWinProductLine
                });

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                FrameWindow.HideLoading();
            }
        });
    }

    that.QueryAutHosp = function () {
        var gridAut = $("#RstAutHospList").data("kendoGrid");
        if (gridAut) {
            gridAut.dataSource.page(1);
            return;
        }
    }

    that.QueryPubHosp = function () {
        var gridPub = $("#RstPubHospList").data("kendoGrid");
        if (gridPub) {
            gridPub.dataSource.page(1);
            return;
        }
    }

    //导出
    that.Export = function () {
        var data = that.GetModel();
        var urlExport = Common.ExportUrl;
        urlExport = Common.UpdateUrlParams(urlExport, 'Business', business);
        urlExport = Common.UpdateUrlParams(urlExport, 'DownloadCookie', 'ContractThirdPartyV2Export');
        urlExport = Common.UpdateUrlParams(urlExport, 'DealerId', data.HidDealerId);
        urlExport = Common.UpdateUrlParams(urlExport, 'HospitalName', data.QryHospitalName);
        startDownload(urlExport, 'ContractThirdPartyV2Export');//下载名称
    }

    //生成PDF
    that.CreatePdf = function () {
        var data = that.GetModel();
        $.ajax({
            type: "post",
            url: "ContractThirdPartyV2.aspx/CreatePdf",
            data: "{ 'dealerID':'" + data.HidDealerId + "', 'dealerName':'" + data.QryDealerName + "' }",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                var result = eval('(' + data.d + ')');
                if (result.IsSuccess) {
                    var url = '/Pages/Download.aspx?downloadname=' + escape(result.downName) + '&fileName=' + escape(result.fileName) + '&downtype=dcms';
                    window.open(url, 'Download');
                }
                else {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: result.ExecuteMessage,
                    });
                }
                FrameWindow.HideLoading();
            },
            error: function (err) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: "access faield:" + err,
                });
            }
        });
    }

    //下载模板
    that.DownloadTemplate = function () {
        var url = '/Pages/Download.aspx?downloadname=ThirdPartyTemplate.zip&filename=ThirdPartyTemplate.zip';
        window.open(url, 'Download');
    }

    //授权医院披露信息表
    var kendoAutDataSource = GetKendoDataSource(business, 'QueryAutHosp', null, 5);
    var kendoPubDataSource = GetKendoDataSource(business, 'QueryPubHosp', null, 15);

    var createResultList = function () {
        $("#RstAutHospList").kendoGrid({
            dataSource: kendoAutDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            //height: 500,
            columns: [
                {
                    field: "HospitalName", title: "医院名称", width: 150, 
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HospitalCode", title: "医院代码", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院代码" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "操作", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#DealerId').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstAutHospList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    $('#HidType').val('new');
                    that.ShowDetails('', data.HospitalName, data.HospitalId);
                });
            }
        });

        $("#RstPubHospList").kendoGrid({
            dataSource: kendoPubDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            //height: 500,
            columns: [
                {
                    field: "Id", title: "ID", width: 150, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "ID" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "HospitalName", title: "医院名称", width: 180,
                    headerAttributes: { "class": "text-center text-bold", "title": "医院名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ProductNameString", title: "合作产品线", width: 120,
                    headerAttributes: { "class": "text-center text-bold", "title": "合作产品线" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "CompanyName", title: "公司名称", width: 150, 
                    headerAttributes: { "class": "text-center text-bold", "title": "公司名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Rsm", title: "与贵司或医院关系", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "与贵司或医院关系" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ThirdType", title: "当前状态", width: 100, 
                    headerAttributes: { "class": "text-center text-bold", "title": "当前状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ApprovalStatus", title: "审批状态", width: 130,
                    headerAttributes: { "class": "text-center text-bold", "title": "审批状态" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ApprovalName", title: "审批人", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "审批人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "TerminationDate", title: "终止披露时间", width: 150, hidden: true,
                    headerAttributes: { "class": "text-center text-bold", "title": "终止披露时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "ApprovalDate", title: "审批时间", width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "审批时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "查看明细", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-edit' style='font-size: 14px; cursor: pointer;' name='edit'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstPubHospList").find("i[name='edit']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    $('#HidType').val('old');
                    that.ShowDetails(data.Id, '', '');
                });
            }
        });
    }

    //第三方披露表窗体
    that.ShowDetails = function (Id, HosName, HosId) {
        var data = {};
        data.HidDealerId = $('#HidDealerId').val();
        data.DisclosureId = Id;
        data.HospitalId = HosId;
        data.WinHospitalName = HosName;
        data.DealerType = $('#HidDealerType').val();
        FrameWindow.ShowLoading();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'InitDetail',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $('#DisclosureId').val(model.DisclosureId);
                $('#HospitalId').val(model.HospitalId);
                //初始化控件
                $('#WinHospitalName').FrameTextBox({
                    value: model.WinHospitalName,
                    readonly: true
                });
                $('#WinProductLine').FrameTextBox({
                    value: model.WinProductLine
                });
                $('#WinCompanyName').FrameTextBox({
                    value: model.WinCompanyName
                });
                $('#WinSubmitName').FrameTextBox({
                    value: model.WinSubmitName
                });
                $('#WinPhone').FrameTextBox({
                    value: model.WinPhone
                });
                $('#WinApplicationNote').FrameTextArea({
                    value: model.WinApplicationNote
                });
                $('#HidApplicationNote').val(model.WinApplicationNote);
                $('#WinApprovalRemark').FrameTextArea({
                    value: model.WinApprovalRemark
                });
                $("#WinBeginDate").FrameDatePicker({
                    format: "yyyy-MM-dd",
                    value: model.WinBeginDate
                });
                $("#WinEndDate").FrameDatePicker({
                    format: "yyyy-MM-dd",
                    value: model.WinEndDate
                });
                $("#WinTerminationDate").FrameDatePicker({
                    format: "yyyy-MM-dd",
                    value: model.WinTerminationDate
                });
                $('#WinRsm').FrameDropdownList({
                    dataSource: [{ Key: '经销商指定公司', Value: '经销商指定公司' }, { Key: '医院指定公司', Value: '医院指定公司' }],
                    dataKey: 'Key',
                    dataValue: 'Value',
                    selectType: 'select',
                    value: model.WinRsm,
                    onChange: that.RelationshipChange
                });

                //控件控制
                $('#HidApproveStatus').val(model.HidApproveStatus);
                $('#divApproveRemark').hide();
                $('#BtnAddLine').FrameButton('enable');
                $('#BtnWinSubmit').hide();
                $('#divTermDate').hide();

                $('#WinRsm').FrameDropdownList('enable');
                $('#BtnWinThirdPartyApproval').hide();
                $('#BtnWinThirdPartyReject').hide();

                $('#divEndDate').hide();
                $('#divBeginDate').hide();
                $('#BtnWinRenew').hide();
                $('#BtnWinEndThirdParty').hide();// 终止披露申请
                $('#BtnWinApproveEnd').hide();//终止披露审批通过
                $('#BtnWinRefuseEnd').hide();//终止披露审批拒绝

                if ($('#HidType').val() == "old") {

                    $('#WinApprovalRemark').FrameTextArea('disable');
                    $('#WinHospitalName').FrameTextBox('disable');
                    $('#WinBeginDate').FrameDatePicker('disable');
                    $('#WinEndDate').FrameDatePicker('disable');
                    $('#BtnAddLine').FrameButton('disable');
                    $('#WinCompanyName').FrameTextBox('disable');
                    $('#WinRsm').FrameDropdownList('disable');
                    $('#WinProductLine').FrameTextBox('disable');
                    $('#WinPhone').FrameTextBox('disable');
                    $('#WinSubmitName').FrameTextBox('disable');
                    $('#WinTerminationDate').FrameDatePicker('disable');
                    $('#WinApplicationNote').FrameTextArea('disable');
                    $('#BtnWinThirdPartySubmit').hide();

                    if (model.HidApproveStatus == "申请审批中") {    //平台登录
                        $('#WinApplicationNote').FrameTextArea('disable');
                        $('#WinApprovalRemark').FrameTextArea('disable');
                        if (model.LPLogin == true) {
                            $('#BtnWinThirdPartyApproval').show();//披露申请审批通过
                            $('#BtnWinThirdPartyReject').show();//披露申请审批拒绝
                            $('#divApproveRemark').show();

                        }
                        //管理员登录
                        if (model.AdminLogin == true) {
                            $('#BtnWinThirdPartyApproval').show();//披露审批通过
                            $('#BtnWinThirdPartyReject').show();//披露申请审批拒绝
                            $('#divApproveRemark').show();
                        }
                        if (model.DealerLogin == true) {
                            $('#BtnWinThirdPartySubmit').hide();//披露申请提交
                            $('#BtnAddLine').FrameButton('disable');
                            $('#divApproveRemark').hide();
                        }
                        if (model.EnableApproveRemark == true) {
                            $('#WinApprovalRemark').FrameTextArea('enable');
                        }

                    }
                    if (model.HidApproveStatus == "申请审批通过") {

                        $('#divBeginDate').show();
                        $('#divEndDate').show();
                        $('#divTermDate').show();
                        $('#WinApplicationNote').FrameTextArea('enable');
                        $('#WinTerminationDate').FrameDatePicker('enable');

                        if (model.ShowApprove == true)
                        {
                            $('#BtnWinApproveEnd').html('<i class="fa fa-fw fa-check"></i>&nbsp;&nbsp;' + model.BtnApproveText);//有Bug
                            $('#BtnWinApproveEnd').show();
                        }
                        if (model.ShowTermDate == true)
                        {
                            $('#divTermDate').show();
                        }
                        if (model.ShowEndThird == true) {
                            $('#BtnWinEndThirdParty').show();
                        }
                        if (model.ShowRenew == true)
                        {
                            $('#BtnWinRenew').show();
                        }

                    }

                    if (model.HidApproveStatus == "终止申请审批中") {

                        $('#divTermDate').show();
                        $('#divApproveRemark').show();
                        
                        if (model.ShowApprove == true) {
                            $('#BtnWinApproveEnd').html('<i class="fa fa-fw fa-check"></i>&nbsp;&nbsp;' + model.BtnApproveText);//有Bug
                            $('#BtnWinApproveEnd').show();
                        }
                        if (model.ShowRefuseEnd == true)
                        {
                            $('#BtnWinRefuseEnd').show();//终止披露审批拒绝
                        }
                        if (model.EnableApproveRemark == true)
                        {
                            $('#WinApprovalRemark').FrameTextArea('enable');
                        }

                    }

                    if (model.HidApproveStatus == "终止申请审批拒绝") {
                        $('#divApproveRemark').show();
                        $('#divTermDate').show();
                    }
                    if (model.HidApproveStatus == "申请审批拒绝") {
                        $('#WinApplicationNote').FrameTextArea('disable');
                        $('#divApproveRemark').show();
                    }
                    if (model.HidApproveStatus == "终止申请审批通过") {
                        $('#divTermDate').show();
                        $('#WinApprovalRemark').FrameTextArea('disable');
                    }
                }
                else {
                    $('#WinCompanyName').FrameTextBox('enable');
                    $('#WinProductLine').FrameTextBox('disable');
                    $('#WinApplicationNote').FrameTextArea('enable');
                    $('#WinSubmitName').FrameTextBox('enable');
                    $('#WinPhone').FrameTextBox('enable');
                    $('#WinHospitalName').FrameTextBox('enable');
                    $('#BtnWinThirdPartySubmit').show();
                    if (model.BtnSubmitText)
                    {
                        $('#BtnWinThirdPartySubmit').html('<i class="fa fa-fw fa-check"></i>&nbsp;&nbsp;' + model.BtnSubmitText);
                    }

                }

                SetRulePageActivate();

                that.QueryAttach();

                $(window).resize(function () {
                    setLayout();
                })
                setLayout();

                $("#winThirdPartyLayout").kendoWindow({
                    title: "Title",
                    width: 600,
                    height: '80%',
                    actions: [
                        "Close"
                    ],
                    resizable: false,
                    //modal: true,
                }).data("kendoWindow").title("第三方披露表").center().open();

                FrameWindow.HideLoading();
            }
        });
    }

    var SetRulePageActivate = function () {

        if ($('#HidApproveStatus').val() == "申请审批拒绝" ||
            $('#HidApproveStatus').val() == "终止申请审批拒绝" ||
            $('#HidApproveStatus').val() == "终止申请审批通过" ||
            $('#HidApproveStatus').val() == "终止申请审批中" || $('#HidApproveStatus').val() == "申请审批通过") {

            $("#RstWinAttachList").data("kendoGrid").hideColumn(4);
            $('#BtnAddAttach').hide();

        }

        if ($('#HidApproveStatus').val() == "申请审批通过" && $('#HidType').val() == "new" || $('#HidApproveStatus').val() == "申请审批中" || $('#HidType').val() == "new") {
            $("#RstWinAttachList").data("kendoGrid").showColumn(4);
            $('#BtnAddAttach').show();
        }
    }

    //修改关系
    that.RelationshipChange = function () {
        var selectValue = $('#WinRsm').FrameDropdownList('getValue').Key;
        if (selectValue == '经销商指定公司')
        {
            $('#lbWinRsmRemark').text('请上传文件：贵司与第三方公司的合同、合规附件、合规/质量培训签到表和质量自检表，请在右上角的使用帮助及模板中下载相关模板');
        }
        else if (selectValue == '医院指定公司')
        {
            $('#lbWinRsmRemark').text('请上传医院指定的证明文件：包括第三方与医院的合同，或医院公函，或医院公告，或医院官方网站说明，或经BP销售团队确认的经销商声明');
        }
        else
        {
            $('#lbWinRsmRemark').text('');
        }
    }

    //按钮事件
    that.EndThirdPartylist = function () {
        var data = that.GetModel();
        if (data.WinApplicationNote == '')
        {    
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '终止披露必须填写披露备注！'
            });
            return; 
        }  
              
        if (data.WinApplicationNote == $('#HidApplicationNote').val() && $('#HidApproveStatus').val() != '申请审批通过')
        {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '终止披露请重新填写披露备注！'
            });
            return;
        }
                       
        if (data.WinTerminationDate == '')
        {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择终止披露时间！'
            });
            return; 
        }
        else{
            var bdate = new Date(data.WinBeginDate);
            var edate = new Date(data.WinEndDate);
            var TerminationendDate = new Date(data.WinTerminationDate);
            if (TerminationendDate > edate || TerminationendDate < bdate)
            {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '请选择披露范内的时间终止披露！'
                });
                return;
            }      
            else{
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'EndThirdPartylist',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        $("#winThirdPartyLayout").data("kendoWindow").close();
                        that.QueryPubHosp();
                        FrameWindow.HideLoading();
                    }
                });
            }
        }
    }

    that.RenewSubmit = function () {
        var data = that.GetModel();
        var attachCount = $('#RstWinAttachList').data("kendoGrid").items().length;
        if (data.WinProductLine == '')
        { 
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '产品线为空请重新提交披露申请！'
            });
        } 
        else if (attachCount == 0)
        { 
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请先上传证明文件后再提交！'
            });
        }
        else{
            FrameUtil.SubmitAjax({
                business: business,
                method: 'RenewSubmit',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $("#winThirdPartyLayout").data("kendoWindow").close();
                    that.QueryPubHosp();
                    FrameWindow.HideLoading();
                }
            });
        };
    }

    that.Renew = function () {
        var data = {};
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Renew',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '请上传证明文件后点击“提交续约”按钮，完成续约操作。如果需要更新第三方公司名称，请提交新申请！'
                });
                $('#HidType').val('new');
                $('#DisclosureId').val(model.DisclosureId);

                $('#BtnWinApproveEnd').hide();
                $('#BtnWinSubmit').show();
                $('#BtnWinRenew').hide();
                $('#BtnWinApproveEnd').hide();
                SetRulePageActivate();
                that.QueryAttach();
                FrameWindow.HideLoading();
            }
        });
    }

    that.EndThirdPartylistApprover = function () {
        var data = that.GetModel();
        if ($('#HidType').val() == "old") {

            if (data.WinApplicationNote == '')
            { 
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '终止披露必须填写披露备注！'
                });
            } 
            if (data.WinApplicationNote == $('#HidApplicationNote').val() && $('#HidApproveStatus').val() == '申请审批通过')
            {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '终止披露请重新填写披露备注！'
                });
            }

            if (data.WinTerminationDate == '')
            {
                FrameWindow.ShowAlert({
                    target: 'center',
                    alertType: 'info',
                    message: '请选择终止披露时间！'
                });
            }
            else{
                var bdate = new Date(data.WinBeginDate);
                var edate = new Date(data.WinEndDate);                              
                var TerminationendDate = new Date(data.WinTerminationDate);
                if (TerminationendDate > edate || TerminationendDate < bdate)
                {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '请选择披露范内的时间终止披露！'
                    });
                } 
                     
                else{
                    FrameUtil.SubmitAjax({
                        business: business,
                        method: 'EndThirdPartylistApprover',
                        url: Common.AppHandler,
                        data: data,
                        callback: function (model) {
                            $("#winThirdPartyLayout").data("kendoWindow").close();
                            that.QueryPubHosp();
                            FrameWindow.HideLoading();
                        }
                    });
                }
            }
        }
    }

    that.RefuseEndThirdPartylist = function () {
        var data = that.GetModel();
        if (data.WinApprovalRemark == '') {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '审批拒绝必须填写审批备注！'
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'RefuseEndThirdPartylist',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $("#winThirdPartyLayout").data("kendoWindow").close();
                    that.QueryPubHosp();
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.Approval = function () {
        var data = that.GetModel();
        FrameUtil.SubmitAjax({
            business: business,
            method: 'Approval',
            url: Common.AppHandler,
            data: data,
            callback: function (model) {
                $("#winThirdPartyLayout").data("kendoWindow").close();
                that.QueryPubHosp();
                FrameWindow.HideLoading();
            }
        });
    }

    that.Reject = function () {
        var data = that.GetModel();
        if (data.WinApprovalRemark == '') {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '审批拒绝必须填写审批备注！'
            });
        }
        else {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'Reject',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    $("#winThirdPartyLayout").data("kendoWindow").close();
                    that.QueryPubHosp();
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    that.SaveThirdParty = function () {
        var data = that.GetModel();
        var attachCount = $('#RstWinAttachList').data("kendoGrid").items().length;
        if (attachCount == 0)
        {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请先上传证明文件后再提交！'
            });
        }
        else
        {
            FrameUtil.SubmitAjax({
                business: business,
                method: 'SaveThirdParty',
                url: Common.AppHandler,
                data: data,
                callback: function (model) {
                    FrameWindow.ShowAlert({
                        target: 'center',
                        alertType: 'info',
                        message: '保存成功！'
                    });
                    $("#winThirdPartyLayout").data("kendoWindow").close();
                    that.QueryPubHosp();
                    FrameWindow.HideLoading();
                }
            });
        }
    }

    //产品线表
    var createLineList = function () {
        $("#RstWinProductLine").kendoGrid({
            dataSource: [],
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 280,
            columns: [
                {
                    title: "选择", width: 50, encoded: false,
                    headerTemplate: '<input id="CheckAll" type="checkbox" class="k-checkbox Check-All" /><label class="k-checkbox-label" for="CheckAll"></label>',
                    template: '<input type="checkbox" id="Check_#=ProductLineId#" class="k-checkbox Check-Item" /><label class="k-checkbox-label" for="Check_#=ProductLineId#"></label>',
                    headerAttributes: { "class": "text-center bold", "title": "选择", "style": "vertical-align: middle;" },
                    attributes: { "class": "text-center" }
                },
                {
                    field: "DivisionName", title: "BU",
                    width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "BU" }
                },
                {
                    field: "ProductLineName", title: "产品线名称",
                    width: 150,
                    headerAttributes: { "class": "text-center text-bold", "title": "产品线名称" }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                pageSize: 20,
                input: true,
                numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstWinProductLine").find(".Check-Item").unbind("click");
                $("#RstWinProductLine").find(".Check-Item").on("click", function () {
                    var checked = this.checked,
                    row = $(this).closest("tr"),
                    grid = $("#RstWinProductLine").data("kendoGrid"),
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
                        var grid = $("#RstWinProductLine").data("kendoGrid");
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
                clearChooseProduct();
            }
        });
    }
    //添加产品线
    that.AddItems = function () {
        if (chooseProduct.length > 0) {
            var param = '';
            for (var i = 0; i < chooseProduct.length; i++) {
                param += chooseProduct[i].DivisionName + ',';
            }
            if ($('#WinProductLine'))
            {
                $('#WinProductLine').FrameTextBox('setValue', param.substr(0, param.length - 1));
            }
            $("#winAddLineLayout").data("kendoWindow").close();
        } else {
            FrameWindow.ShowAlert({
                target: 'center',
                alertType: 'info',
                message: '请选择要添加的数据！'
            });
        }
    }
    //产品线窗体
    that.ShowProductLine = function () {
        $("#winAddLineLayout").kendoWindow({
            title: "Title",
            width: 500,
            height: 350,
            actions: [
                "Close"
            ],
            resizable: false,
            //modal: true,
        }).data("kendoWindow").title("添加产品线").center().open();
    }

    //附件表
    that.QueryAttach = function () {
        var gridAttach = $("#RstWinAttachList").data("kendoGrid");
        if (gridAttach) {
            gridAttach.dataSource.page(1);
            return;
        }
    }
    var kendoAttachDataSource = GetKendoDataSource(business, 'QueryAttach', null, 15);
    var createAttachList = function () {
        $("#RstWinAttachList").kendoGrid({
            dataSource: kendoAttachDataSource,
            resizable: true,
            sortable: true,
            scrollable: true,
            height: 340,
            columns: [
                {
                    field: "Name", title: "附件名称", width: 200,
                    headerAttributes: { "class": "text-center text-bold", "title": "附件名称" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "Identity_Name", title: "上传人", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "上传人" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    field: "UploadDate", title: "上传时间", width: 100,
                    headerAttributes: { "class": "text-center text-bold", "title": "上传时间" },
                    attributes: { "class": "table-td-cell" }
                },
                {
                    title: "下载", width: 50,
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-download' style='font-size: 14px; cursor: pointer;' name='download'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                },
                {
                    title: "删除", width: 50, 
                    headerAttributes: {
                        "class": "text-center text-bold"
                    },
                    template: "#if ($('\\#Id').val() != '') {#<i class='fa fa-trash' style='font-size: 14px; cursor: pointer;' name='delete'></i>#}#",
                    attributes: {
                        "class": "text-center text-bold"
                    }
                }
            ],
            pageable: {
                refresh: false,
                pageSizes: false,
                //pageSize: 20,
                //input: true,
                //numeric: false
            },
            noRecords: true,
            messages: {
                noRecords: "没有符合条件的记录"
            },
            dataBound: function (e) {
                var grid = e.sender;

                $("#RstWinAttachList").find("i[name='download']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    var url = '/Pages/Download.aspx?downloadname=' + escape(data.Name) + '&filename=' + escape(data.Url) + '&downtype=dcms';
                    window.open(url, 'Download');
                });

                $("#RstWinAttachList").find("i[name='delete']").bind('click', function (e) {
                    var tr = $(this).closest("tr")
                    var data = grid.dataItem(tr);

                    that.DeleteAttach(data.Id, data.Url);
                });
            }
        });
    }
    //附件上传窗体
    that.ShowAttachment = function () {
        $("#winAttachmentLayout").kendoWindow({
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

    that.DeleteAttach = function (Id, Url) {
        FrameWindow.ShowConfirm({
            target: 'center',
            message: '是否要删除该文件？',
            confirmCallback: function () {
                var data = that.GetModel();
                data.DeleteId = Id;
                data.DealerType = $('#HidDealerType').val();
                FrameUtil.SubmitAjax({
                    business: business,
                    method: 'DeleteAttach',
                    url: Common.AppHandler,
                    data: data,
                    callback: function (model) {
                        FrameWindow.ShowAlert({
                            target: 'center',
                            alertType: 'info',
                            message: '删除成功！',
                            callback: function () {
                                that.QueryAttach();
                            }
                        });
                        FrameWindow.HideLoading();
                    }
                });
            }
        });
    }

    //选择产品线
    var clearChooseProduct = function () {
        $('#CheckAll').removeAttr("checked");
        chooseProduct.splice(0, chooseProduct.length);
    }

    var addItem = function (data) {
        if (!isExists(data)) {
            chooseProduct.push(data);
        }
    }

    var removeItem = function (data) {
        for (var i = 0; i < chooseProduct.length; i++) {
            if ((chooseProduct[i].ProductLineId && data.ProductLineId && chooseProduct[i].ProductLineId == data.ProductLineId)) {
                chooseProduct.splice(i, 1);
                break;
            }
        }
    }

    var isExists = function (data) {
        var exists = false;
        for (var i = 0; i < chooseProduct.length; i++) {
            if ((chooseProduct[i].ProductLineId && data.ProductLineId && chooseProduct[i].ProductLineId == data.ProductLineId)) {
                exists = true;
            }
        }
        return exists;
    }

    var setLayout = function () {
    }

    return that;
}();
